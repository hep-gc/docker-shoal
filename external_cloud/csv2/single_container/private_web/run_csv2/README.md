# Run Jobs on an External Cloud from a Single Container with private web using csv2 container README

## Introduction

This README describes how to use the code in this directory - along with the csv2 container produced using the code in ../ansible_setup as described in the README in the private_web directory (one directory up from here) - to pull and run a container running csv2 on your host machine.

## Pre-requesites

To successfully pull and run the csv2 container on your host machine, the following pre-requisites are needed:

* Root or sudo access on the host machine
* A running [docker](https://runnable.com/docker/install-docker-on-linux) installation and a [docker-compose](https://docs.docker.com/v17.09/compose/install/) installation
* At least 6GB of RAM allocated to docker containers. On a mac, for example, this can be set in the advanced docker preferences. For linux machines, docker appears to allocate the full system memory by default, so as long as the host VM has well over 6GB of RAM, it should be ok. 
* The following ports must be open to external IPv4 traffic:
  * 9168 
  * 40000-40500
  * 3306
  * 80
  * 443, 444
  
  These ports are open by default on a mac (because mac doesn't run a firewall by default). The ports can be opened on a centos 7 machine, for example, using the following command:
  ~~~~
  $ firewall-cmd --permanent --add-port=9168/tcp
  $ firewall-cmd --reload
  ~~~~
  and repeating for the other ports and port ranges.
  
* Access to a web browser to view the csv2 webpage

## Pulling and running the csv2 container

1. Pull the csv2 docker image from github:

   If you created your own image following the instructions in the private_web README (one directory up from here), pull the image from your docker hub account:

  ~~~~
  $ docker pull danikam/csv2_private_web
  ~~~~
  
  This pull should take ~5-15 minutes depending on your internet speed.
  
2. Start up the csv2 container using docker-compose. Note: the docker-compose command must be run from this directory (i.e. the directory containing the docker-compose.yml file):

  ~~~~
  $ docker-compose up&
  ~~~~
  
  It should take ~2-5 minutes for the container to get up and running.
  
3. Once the container is up and running, you should be able to see the csv2 web interface by typing https://localhost into your local web browser. The webpage (at least on firefox, and likely others) will come up with a security warning due to the self-signed ssl certificate, and ask if you want to add an exception - add the security exception to continue to the csv2 webpage. You will then be asked to input a username and password. These are:

Username: csv2_default
Password: csv2_pass

  The container is currently set up to run jobs on the otter testing cloud, but you can add or remove other clouds by pressing the "Clouds" tab at the top left of the csv2 web page, then pressing the "+" button that appears at the top left of the Clouds page.

4. Start a bash shell in the running csv2 container and submit a sample job to condor.

  First, determine the name of the running csv2 container by typing:
  
  ~~~~
  $ docker ps
  ~~~~
  
  
  
  Use the following command to start an interactive bash shell in the csv2 container:
  
  ~~~~
  $ docker exec -it [name of running csv2 container] /bin/bash
  ~~~~
  
  Once in the container, switch to the condor user to submit the sample job job.sh in the /jobs directory:
  
  ~~~~
  $ su condor
  $ cd /jobs
  $ condor_submit job.sh
  ~~~~
  
   Press ctl-D to switch back to the root user. The job should appear on the cloud status webpage (https://htc-dev.heprc.uvic.ca/cloud/status/), and cloudscheduler will launch VMs to run the job. The VM should boot and start running the test job after ~5-10 minutes. 

  The status of the job can be checked using condor_q

  ~~~~
  $ condor_q
  ~~~~

  For more information, use the better-analyze option
  ~~~~
  $ condor_q -better-analyze
  ~~~~

  Note that it may take ~5-10 minutes for the VM to boot on otter and the job to start running.