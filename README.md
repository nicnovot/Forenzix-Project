# Forenzix-Project
Development of Forenzix, a Linux distro for capturing and investigating system compromise while allowing the machine to be brought back quickly.

Plans for the project are to:
- build a stable Linux base with a large Universal Driver Database.
- Incorporate dd, hashing packages which support MD5, SHA-1 and SHA-2.
- Develope interactive scripts to ask the user which detected "evidence" drives to caputure,
- acquire a hash value for that evidence,
- perform a data dump of that evidence,
- ensure that the data is uncorrupted,
- convert the raw dump to a *.vmdk file,
- create a Virtual Machine with the amount of RAM of the computer which is being investigated,
- a NIC connected to a simulated internet,
- Begin a Wireshark capturre logging all traffic.  More goals to follow.
