# EditHosts

A couple of simple PowerShell scripts which will modify the hosts file on one (or more) Windows machines, so that you can route traffic destined for certain domains to specific IP addresses with minimal fuss. The scripts do this by adding (or removing) entries to (or from) the hosts file and they do this idempotently. In other words, when you add a host to the hosts file, it won't add it if it's already there.

Additionally, there's an extra script which enables you to copy your modified hosts file to multiple machines. This needs to be used with extreme caution (although it does make a backup of the remote hosts files), but is useful if you are trying to get precisely the same hosts file onto several machines in one step.

The linked blog post also explains the proper use of the `-WhatIf` parameter.

Full instructions here: https://tomssl.com/2019/04/30/a-better-way-to-add-and-remove-windows-hosts-file-entries/