ipa-client-reinstall.sh
========

Requires:
--------------
- ipa server set up with proper DNS config.
- ipa-client package installed
- ipa-admintools package installed

Features:
--------------
- might be able to detect environment fully automatic
- can be fully automated :D probably not supported at all :p
- can be run multiple times without breaking config
- can be run on a system set up with ipa-client-install without breaking it
- can be used in a script which also invokes ipa-client-install first and then this as a fallback in case the host is already joined
- might be able to fix broken client installs
- can NOT undo what it has done

