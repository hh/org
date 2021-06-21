# main shell

#!/bin/bash
    ## D Lets set up our environment (this will be done in dockerfile)
    mkdir /tmp/foo
    ## This will pull a fresh copy, I prefer to use what we have in gs
    # curl -s  https://bgp.potaroo.net/cidr/autnums.html | sed -nre '/AS[0-9]/s/.*as=([^&]+)&.*">([^<]+)<\/a> ([^,]+), (.*)/"\1", "\3", "\4"/p'  | head
    # TODO: add if statement to do manual parsing if the gs file is not there
    gsutil cp gs://ii_bq_scratch_dump/potaroo_company_asn.csv  /tmp/potaroo.csv

    ## I want to import the above csv into pg
    ## Blocked by pg container
    
    ## Ok Caleb was going to create the docker imgage based on
    ## https://github.com/cncf/apisnoop/blob/main/apps/snoopdb/postgres/Dockerfile
    ## He is needed in xds
    ## I need to switch gears to get a container I can test in

    ## PYASN section
    ## D This moves to docker file when it is ready
    git clone https://github.com/hadiasghari/pyasn.git
    pip install pyasn

    ## pyasn installs its utils in ~/.local/bin/*
    ## Add pyasn utils to path (dockerfile?)
    export PATH="/home/ii/.local/bin/:$PATH"
    ## full list of RIB files on ftp://archive.routeviews.org//bgpdata/2021.05/RIBS/ 
    cd /tmp/foo
    pyasn_util_download.py --latest
    ## Convert rib file to .dat we can process
    pyasn_util_convert.py --single rib.latest.bz2 ipasn_latest.dat
