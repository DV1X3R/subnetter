# Subnetter
## Bash network calculator

This little script can calculate basic subnet info using IP and prefix

* Usage Example

$ subnetter 192.168.0.1/24
```
IPv4 Address:        192.168.0.1 /24     11000000.10101000.00000000.00000001
Subnet Mask:       255.255.255.0         11111111.11111111.11111111.00000000
Network:             192.168.0.0         11000000.10101000.00000000.00000000
Broadcast:         192.168.0.255         11000000.10101000.00000000.11111111
First Address:       192.168.0.1         11000000.10101000.00000000.00000001
Last Address:      192.168.0.254         11000000.10101000.00000000.11111110
Hosts: 254
Class: C
```
