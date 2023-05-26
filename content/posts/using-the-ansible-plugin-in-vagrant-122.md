---
title: 'Using the Ansible plugin in Vagrant 1.2.2'
date: 2013-12-16T21:37:00.001-05:00
draft: false
url: /2013/12/using-ansible-plugin-in-vagrant-122.html
---

I didn't find much reference to this online, and it hung me up for quite some time: The [Ansible plugin](http://docs.vagrantup.com/v2/provisioning/ansible.html) for [Vagrant](http://www.vagrantup.com/) has changed fairly substantially between version 1.2.2 (which is the version currently packaged by debian testing/jessie) and version 1.4.0 (which is covered by the online docs).

The top things I've noticed are:

*   No inventory file is automatically generated.
*   The inventory\_path option in 1.4.0 was called inventory\_file in 1.2.2.

Since the documentation for Vagrant is not too comprehensive to begin with, I think it's best to just ignore it and read the source. For comparison, source of [config.rb at 1.4.0](https://github.com/mitchellh/vagrant/blob/v1.4.0/plugins/provisioners/ansible/config.rb) vs [config.rb at 1.2.2](https://github.com/mitchellh/vagrant/blob/v1.2.2/plugins/provisioners/ansible/config.rb).