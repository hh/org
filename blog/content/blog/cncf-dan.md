+++
title = "Thank You Dan Kohn"
date = 2021-03-19
author = ["Riaan Kleinhans"]
lastmod = "Fri Mar 06 17:06:13 NZDT 2021"
summary =  "He believed in ii, and in all of us."
+++

This story is all about relationships and how that is the currency behind all things that make this world move forward. It is also about the visionary leadership of a friend dear to us all.

In the year 2015 Hippie Hacker was working at [Chef.io](https://www.chef.io/) as a consultant. One of the assignments Hippie was working on was with [Maritime Telecommunications Network](https://en.wikipedia.org/wiki/Maritime_Telecommunications_Network) (MTN). This was a turning point towards Kubernetes where we are today, through relationships and also friendships built at that time. Through this assignment, Hippie Hacker met Aaron Crickenberger, who was working for MTN chief innovation officer Bob Wise.

Together they did some amazing things, deploying hands-off over the internet network booting of servers that was then managed by Chef software. They spent several weeks together to make this magic happen. And in this way, relationships and kinship were forged.

During this time Hippie was preparing a presentation about the work he was doing with the [Marine Reach](https://marinereach.com/) vessels. He asked Bob and his team if he could show them his presentation for some feedback from a live audience. The team really resonated with Hippie’s passion for the things he was involved in with Marine Reach.

Later Hippie, while he was living in Portland, did some more work with the MTN team. Bob shipped servers to him to allow him to do some more work on the network booting for the cruise ship industry.

Shortly after that Bob and Aaron left MTN, and Hippie returned from the USA to New Zealand, with the servers still stranded in the USA. After working up some courage Hippie asked Bob if he had some money available to relocate the servers to New Zealand. Bob said that he could not help with money, but would introduce him to someone that could help.
Bob told [Dan Kohn](https://en.wikipedia.org/wiki/Dan_Kohn) all about who Hippie was, the work he was doing, and the things that are important to him. Bob introduced them and that was the start of another important relationship on this journey. The servers were relocated and they are used as part of the infrastructure for Hippie's vision.

At this time Hippie was doing some work for [Balena](https://www.balena.io/) with [Denver Williams](https://github.com/denverwilliams) which allowed the “image pull and networking boot” he was working on before in new ways. This inspired Hippie to use this technology with Kubernetes, pulling down the images and installing [Gitlab](https://about.gitlab.com/) on top of it. He showed this to Dan, who thought it was a great way to use Kubernetes. 

Impressed by Hippie’s innovative approach Dan asked him if he would like to join the CNCF to help demonstrate what the organization is capable of. Hippie jumped in to help create a [Demo of CNCF technologies](https://github.com/cncf/demo/) This however did not get much traction.

The demo was however foundational in exploring some ideas which evolved into the next project Hippie supported the CNCF with. Dan's vision was to get all cloud providers actively engaged in the cloud-native experience and they started work on [Cross-Cloud](https://github.com/crosscloudci/cross-cloud) to find ways to more concretely show the work of the CNCF with a frontend at [CNCF.CI](https://cncf.ci/) showing all projects that were available on all the participating cloud providers. [Taylor Carpenter](https://github.com/taylor), a long time friend, continued the project with [vulk.coop](https://vulk.coop) team and Hippie was ready to take on new challenges with Dan.

In 2017 Hippie attended his first CloudNativeCon + KubeCon Europe in Berlin, Germany. Dan was starting on the road to reshaping the world of open source and how it would be consumed. He was instrumental in creating a conformance standard for [Kubernetes](https://en.wikipedia.org/wiki/Kubernetes) and the Kubernetes Certified Service Provider program which was introduced to the opensource world at this conference. 

Almost a year later in February 2018 [Kenichi Omichi](https://github.com/oomichi) dug into the Kubernetes log and found that Kubernetes had 481 API’s and tests covered only 53 endpoints, which is 11%. Dan knew that if the CNCF wanted to ensure that the [Certified Kubernetes brand](https://github.com/cncf/k8s-conformance/pulls#certified-kubernetes) would be meaningful they had to invest in test development to get that numbers much higher. 

The importance of the Kubernetes Conformance program soon had high visibility, but was in danger of being meaningless. There were two issues, firstly a very low test coverage of the API and secondly, a difficulty in measuring the coverage without a lot of manual data mining.

This time Hippie paired with [Rohan Fletcher](https://github.com/rohfle). During a discussion with Hippie and Rohan, Dan showed them a disk usage graph for OSX and proposed following that model as the right way to visually show the Conformance coverage of the Kubernetes API.

![disk_graph](/images/blog_image/disk_graph.png "The actual screenshot Dan shared to show his vision")
The actual screenshot Dan shared to show his vision

Rohan started on the project to create what is today known as [APISnoop](https://apisnoop.cncf.io/). A visual display, giving clear insight into the lay of the land of Kubernetes Conformance that was eagerly expected by the community when it was introduced at KubeCon Europe in May 2018.

In 2018 [Zach Mandeville](https://github.com/zachmandeville) joined the team and took over the magic behind the tool. At that point there was no instrumentation and cover was determined by looking at the test logs, audit logs showing the hits from the e2e binary, but still, it was difficult to determine which test hit specific endpoints. Zach did a lot of writing, rewriting, and changes not only to APISnoop but also driving updates of underlying Kubernetes logging until a clear signal could be distinguished from the noise.

At about the same time Hippie’s team started creating a tool to measure and show the cover of conformance, a separate effort was started for filling in the backlog of conformance tests.

After about a year APISnoop showed very little movement on the graph, as the test writing efforts yielded very little results. Within character, Dan started looking at other ways to get the conformance cover increasing at a rate that would satisfy his vision.

By this time Hippie and his team at [ii](https://ii.coop/) had been looking at the Kubernetes API and all its underlying parts, logs, specs, and much more for almost a year. It was a logical fit for them to step up to the plate and get the graph to move up in the right direction.

The writing of tests was a learning experience for everyone in ii, as well as the contributors in the Kubernetes community. Initially, a lot of work was put into creating tests that cover all the requirements and then shared with the community once it was ready for approval to merge into the test repo. Iron sharpens iron and together the stakeholder figure out the shape of conformance testing. However, this initially resulted in a lot of lost time in writing and rewriting tests.

Hippie and the ii team came up with the mock test concept, using org-mode in their own flavor of [Emacs (Humacs)](https://www.humacs.org/) using a test writing template, running on a Kubernetes cluster. Zach developed SnoopDB out of APISnoop that is deployed on the same Kubernetes cluster. This allowed for live testing and probing of the Kubernetes API, getting immediate feedback about the success of any test concept. Mock tests with their proven results were then presented at the SIG Architecture Conformance sub-project meetings as Issues for initial approval before creating the actual tests and pull requests. The Kubernetes project is a complex organism, with a vast community and diverse [Special Interest Groups](https://github.com/kubernetes/community) (SIG’s), conformance cuts across all these organizational levels. Getting consensus is an equally complex task that requires a lot of collaboration. 

The method that Hippie’s team developed helped to increase the velocity of test writing. The tools and methods are continually being improved and developed to encouraging co-operation between test writers. This resulted in the creation of [Sharing.io](https://pair.sharing.io/) for collaboration, it also brought into being their unique [Kind+APISnoop](https://github.com/cncf/apisnoop/tree/main/kind) combination that allows anyone to access the power of APISnoop locally.

Dan was always pushing the bar higher, continually expecting better and clearer results out of APISnoop to make it a well-used tool throughout the Kubernetes community. This allowed Zach to continually improve the functionality of APISnoop, changing it from a static page with the current status of conformance, to a multi-faceted tool with several ways to view the current data as well as historical data per release. This allows the user to appreciate the progress being made towards reaching 100% conformance test cover.

![1_15Cover](/images/blog_image/1_15Cover.png "1.15 Cover")
Test Cover 1.15 

![1_21Cover](/images/blog_image/1_21cover.png "1.21 Cover")
Test cover 1.21

A page was also added to visually track conformance progress across releases and visually show the progress in eliminating technical debt.

![alt_text](/images/blog_image/Conformance-progress.png "conformance-progress")
Conformance Progress graph

All the added conformance test cover was great news and added the expected prestige and value of the Certified Kubernetes brand. At the same time, it was making life increasingly difficult for [Taylor Waggoner](https://github.com/taylorwaggoner) at the CNCF managing the Conformance Certification process. 

All pull requests for certification had to be manually verified to ensure it contained the correct data, but the list of conformance tests kept growing with each release. Dan approached Hippie and requested that the process should be automated, and in 2020 the CNCF CI Bot was created by [Berno Kleinhans ](https://github.com/bernokl)and [Rob Kielty](https://github.com/RobertKielty). This allowed for the automatic checking and labeling of conformance pull requests, speeding up the process and making the human effort required less. 

The Kubernetes conformance journey up to this day was an eventful one, built around relationships and community cooperation, with many different contributors playing their part to help move this forward. All of this was made possible by the extraordinary vision and leadership of a friend dear to everyone in the Kubernetes community, Dan Kohn.

![Dan_Kohn](/images/blog_image/dan_kohn.jpg "Dan Kohn")
