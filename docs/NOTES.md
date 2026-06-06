# Notes & References

Working notes salvaged from the original README. Not core docs — see [USAGE.md](USAGE.md) for the actual workflow.

## Status

- Creating a Win11 and Rocky9 VM in VMware to test their connection.
- Create a bridge network, then a KS file that drives the HTTP(S) installation part.

## References

- [Skip MS account login during Windows 11 setup](https://www.windowscentral.com/how-set-windows-11-without-microsoft-account)
- [Restart a network interface / adapter on Linux and Windows cloud servers](https://www.layerstack.com/resources/tutorials/How-to-restart-Network-Interface-or-Network-Adapter-on-Linux-and-Windows-Cloud-Servers)
- Windows host could ping a SUSE Linux VM but not the reverse. Fix: Start → search "Windows Defender Firewall" → "Allow an app or feature through Windows Defender Firewall" → scroll to "Virtual Machine Monitoring" → "Change Settings" → enable for Public and Private (at least Public). [Source](https://superuser.com/questions/627208/unable-to-ping-a-windows-machine-from-linux)
