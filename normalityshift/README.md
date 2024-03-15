# **System Call Update: Debian Buster to Bullseye in PHP Apache**

This example highlights how minor OS updates, like upgrading from Debian Buster to Bullseye, can alter system calls in a PHP Apache environment, specifically changing `nanosleep` to `clock_nanosleep`. This change, while reflective of kernel and library updates between Debian versions, serves as a poignant example of how such updates can inadvertently affect anomaly-based Intrusion Detection Systems (IDS), potentially leading to false positives.

## **Key Change**

The transition from `nanosleep` to `clock_nanosleep` stems directly from the `glibc` update from version 2.28 to 2.31. This upgrade introduces `clock_nanosleep`, providing high-resolution sleep functionality with a selectable clock.

## **Sysdig Captures**

### **Debian Buster - `nanosleep` Usage**

![nanosleep in Debian Buster](https://raw.githubusercontent.com/Asbatel/ReplicaWatcher/master/normalityshift/buster.png)

*Sysdig capture showing `nanosleep` system calls in Debian Buster.*

### **Debian Bullseye - `clock_nanosleep` Usage**

![clock_nanosleep in Debian Bullseye](https://raw.githubusercontent.com/Asbatel/ReplicaWatcher/master/normalityshift/bullseye.png)

*Sysdig capture showing `clock_nanosleep` system calls in Debian Bullseye.*


