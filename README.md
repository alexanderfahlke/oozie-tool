oozie-tool
==========

A little toolbox for apache oozie.

This tool will return all FAILED, KILLED and TIMEDOUT actions for all bundles that have the status RUNNING if you run ```getRunningBundles.sh```.

It is also possible to only check a specific bundle by the bundle ID with the ```getCoordinatorsByBundleID.sh``` script.

Tested with the following Oozie client build versions:

- 3.1.3-incubating
- 3.3.2-cdh4.7.0

examples
----
Checking a bundle that has no failed, killed and timedout coordinator actions:

![](https://raw.githubusercontent.com/alexanderfahlke/images/master/github.com/alexanderfahlke/oozie-tool/bundle-with-no-failed-coordinators.png)

Checking a bundle with a lot of failed, killed or timedout coordinator actions:

![](https://raw.githubusercontent.com/alexanderfahlke/images/master/github.com/alexanderfahlke/oozie-tool/bundle-with-failed-coordinators.png)

Setup guide
----

1. Clone this repo: ```git clone https://github.com/alexanderfahlke/oozie-tool.git```
2. copy ```config/config.ini.tpl``` to ```config/config.ini```
3. adjust ```config/config.ini``` to match your environment (most likely the ```OOZIE_BIN```)
4. run ```getRunningBundles.sh```
