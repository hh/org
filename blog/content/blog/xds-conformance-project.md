+++
title = "xDS Conformance Project"
date = 2021-12-09
author = ["Zach Mandeville"]
lastmod = "Fri Dec 09 00:09:49 NZDT 2021"
summary =  "A look into the work ii has done on the xdS conformance test framework"
+++


# Introduction

I've had the privilege to spend the majority of this year working to develop an [xDS conformance test suite](https://github.com/ii/xds-test-harness). While this project is most definitely still in its infancy, the work is already rewarding and points to tremendous potential. Today, I wanted to introduce the conformance project and its goals, the ways we've approached the project, and the exciting progress made so far.

# What is xDS?

xDS, or extensible discovery service, is a set of APIs pioneered by [Envoy](https://envoyproxy.io). They allow for what is described as a [&ldquo;Universal Data Plane API&rdquo;](https://blog.envoyproxy.io/the-universal-data-plane-api-d15cec7a). In the example of Envoy, xDS allows a group to build their own control plane that, as long as it implements the relatively basic set of discovery services, can dynamically update all aspects of their Envoy service mesh. It is an idea that allows for a great amount of freedom and variety when working with Envoy, but has use cases beyond this proxy.

For this reason, the conformance project is not a test suite for Envoy, but for the xDS protocol itself, specifically the transport layer. It is a set of testable behaviours for how resources are exchanged in an xDS api, without specifying the kinds of resources or the context in which they're exchanged. This will let us set up a rich, consistent definition of xDS so it can continue to extend, adapt, and grow to its full potential.

# Some initial technical goals

The conformance framework is intended as a single binary, and set of tests, that can be easily downloaded and run against someone&rsquo;s xDS implementation. We decided to write the framework in Go due to its popularity in the community, the simplicity of its language, and its superb support for concurrency&#x2013; as concurrency was central to the planned design of the framework.

One of the goals of this project was to help build understanding of the protocol itself, to establish for the first time what &rsquo;conformant behaviour&rsquo; means within xDS. These APIs are young, and handle a lot of complex tasks within an already complex domain. While the documentation for Envoy is great, and growing, there is still a lot of undocumented behaviour, where the only way to understand how something *should* be working is to deduce it from the source code. From the beginning, we wanted both the framework and tests to be written as simply as possible, so they could articulate conformance as clearly and plainly as possible.

# Our Test case syntax

For testing, it is hard to find a more plain-spoken and articulate syntax than [Gherkin](https://cucumber.io/docs/gherkin/reference/), which is why we chose it for the conformance framework. Gherkin uses natural language, plus a small amount of keywords, so that the tests act as a shared language between stakeholders and developers. The first stage of the project was just to come up with a set of sample tests, just through meetings and a shared google doc.  It made me quite happy to be able to take these sample test cases and transpose them, nearly verbatim, into executable tests.

Gherkin is only a testing syntax and does not handle the testing functionality. For that, we use the [Godog library](https://github.com/cucumber/godog). Godog converts Gherkin into  regex patterns that map to functions. One of the awesome benefits of this is that, if you are intentional and clever with how you write test cases, you can re-use functions across tests.  This minimizes the amount of code you must write and maintain, while providing a consistent rhythm and readability to the tests.

## An example

For example, one of the behaviours we wanted to test is wildcard subscriptions. With xDS generally, a client will request specific resources from a server, and if those resources exist, they should be included in the server's response. However, the listener and cluster discovery services (LDS and CDS, respectively) allow for wildcard subscriptions, where a client can receive all resources for the service without having to specifically name them in their subscription request.

In the original test case document, this scenario was described as so:

> Server has resources A, B, and C. Client subscribes to wildcard. Server should send a response containing all three resources with some initial version and a nonce. Client sends an ACK with that version and nonce.

This was translated into a test case as:

    Scenario Outline: The service should send all resources on a wildcard request.
        Given a target setup with <service>, <resources>, and <starting version>
        When the Client does a wildcard subscription to <service>
        Then the Client receives the <expected resources> and <starting version>
        And the Client sends an ACK to which the <service> does not respond

Each line then maps to a function in our test runner.  The `<words>` in the above lines represent example terms, which lets us provide an example table to this test. Godogs will run the test for each example given in the table, replacing each `<word>` with the row's respective column.

In other words, we can run the same test for two different services by simply adding this table beneath the test:

    Examples:
         | service | starting version | resources | expected resources |
         | "CDS"   | "1"              | "A,B,C"   | "C,A,B"            |
         | "LDS"   | "1"              | "D,E,F"   | "F,D,E"            |
         

After testing wildcard subscriptions, we wanted to test  subscription updates. If a client does a wildcard subscription, and any of the service resources change, then the server should send an updated response, without prompting, to the client.

This test, as described, follows a similar pattern as the first one: there is an initial state, actions occur, and they trigger expected responses.  Since they share a pattern, the tests can share code. 

We were able to write this second test as:

    Scenario Outline: The service should send updates to the client
      Given a target setup with <service>, <resources>, and <starting version>
      When the Client does a wildcard subscription to <service>
      Then the Client receives the <expected resources> and <starting version>
      When a <chosen resource> of the <service> is updated to the <next version>
      Then the Client receives the <expected resources> and <next version>
      And the Client sends an ACK to which the <service> does not respond

This test covers new behaviour across two different services, and only requires a single new function to be written (the second WHEN step). As the test framework evolves, we are finding it easier to write tests without writing any new code at all.


# Setting up the test runner

While the tests are simple, and hopefully straightforward, it took a decent amount of work to get here. The first difficulty was that we needed a test runner that could adapt itself to each service, while being able to use the same function.  Secondly, we needed a way to write linear tests to describe interactions that were not necessarily linear.

The envoy xDS APIs are built with [gRPC](https://grpc.io/) using bidirectional streams. Not every request from an xDS client should get a response from the server, and the server should send certain responses to the client before they know to request them. The above test is an example of this, where an update to the state should cause the server to send a response without the client's prompting.

We needed a way to start a service stream and investigate the various calls and responses through the changing state of the entire instance. We did this by using the concurrent patterns built in to go and through designing a service interface.

Without going too heavily into code, the essential pattern for each test is this: In the beginning GIVEN step we setup the target server using an integrated adapter. In the first WHEN step we initiate an interface for the specified service. This interface is built with a set of channels, a cache for the requests and responses sent along these channels, and functions for managing the stream.

We start the stream and set up a couple concurrent go routines, initiated with the service channels. These routines listen for new messages and pass them along the stream as needed, and send any responses or any errors back along their respective channels.

In this way, we can adjust the state of the instance and the action of the client while maintaining an uninterrupted stream. It also allows us to observe all meaningful responses and errors that happen during the lifecycle of the stream. In each of the THEN steps, we use the cache of responses and errors to validate the behaviour and determine whether the test passed.

This pattern allows for us to linearly describe non-linear behaviour, while the Service interface lets us use the same function across services.


# Integrating the suite into an xDS implementation

Now that we had the design, we needed to verify that it could work with an actual target. A good use case for the xDS conformance suite would be to test a custom control plane implementation, to verify that its behaviour is consistent with any other Envoy control plane. And so, we built an implementation of the [go-control-plane](https://github.com/envoyproxy/go-control-plane), and integrated the framework&rsquo;s adapter for it.

Basing our implementation off the awesome example server included in the go-control-plane repo (and their integration tests) we were able to build our own example server to test the framework against.

An important aspect of the framework is that it needs an adapter API to communicate state changes to the target server outside of the communication happening in the xDS services.  I was quite happy when we were able to include our adapter into our go-control-plane implementation with only a few lines of code.


# Collaborative work

We ran our framework against the example target and found that the majority of our tests passed and the ones that did not were highlighting behaviour already described in open issues in the go-control-plane repo. The framework, even in its prototype state, was working as we roughly expected.

More importantly, though, this framework was helping us articulate behaviour that hadn&rsquo;t been documented much outside of github issues. We&rsquo;ve begun to collaborate with the maintainers of the go-control-plane so that their expertise can help strengthen our framework and its adapter, while our tests are helping define and strengthen the behaviour of this control plane. It has been a delight to collaborate on this project, where the work is simultaneously exploratory and concrete, and could help lead to improvements across multiple projects and domains.


# Where we go from here

The framework is still in its earliest stages. We are still implementing the basic tests for the SoTW protocol before moving to more complex behaviours in the newer Delta protocol. I am excited to build out these tests and to run them against an increasing variety of example targets. It is exciting to see the beginnings of the framework used alongside control plane development, to help illuminate and explain the xDS protocol and to ensure our implementations are as strong as they can be!
