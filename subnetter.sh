#!/bin/bash

# function definition - start

D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})

int2ip_bin () {
    # $1 - ip int
    echo "${D2B[$(( $1 >> 24 & 0xff ))]}.${D2B[$(( $1 >> 16 & 0xff ))]}.${D2B[$(( $1 >> 8 & 0xff ))]}.${D2B[$(( $1 & 0xff ))]}"
}

int2ip () {
    # $1 - ip int
    echo "$(( $1 >> 24 & 0xff )).$(( $1 >> 16 & 0xff )).$(( $1 >> 8 & 0xff )).$(( $1 & 0xff ))"
}

ip2int () {
    # $@ - ip array
    local ip=("$@")
    echo "$(( (((( (ip[0] << 8) | ip[1]) << 8) | ip[2]) << 8) | ip[3] ))"
}

netmask () {
    # $1 - prefix
    echo "$(( 0xffffffff << (32 - $1) ))"
}

network () {
    # $1 - ip int
    # $2 - mask int
    echo "$(( $1 & $2 ))"
}

broadcast () {
    # $1 - ip int
    # $2 - mask int
    echo "$(( $1 | ~$2 & 0xffffffff ))"
}

hosts () {
    # $1 - network int
    # $2 - broadcast int
    echo "$(( $2 - $1 - 1 ))"
}

class () {
    # $1 - ip 1st octet
    if (( $1 > 0 && $1 < 127 ))
    then echo A # 255.0.0.0 /8 
    elif (( $1 > 127 && $1 < 192 ))
    then echo B # 255.255.0.0 /16
    elif (( $1 > 191 && $1 < 224 ))
    then echo C # 255.255.255.0 /24
    elif (( $1 > 223 && $1 < 240 ))
    then echo D
    elif (( $1 > 239 && $1 < 256 ))
    then echo E
    elif (( $1 == 127 ))
    then echo Loopback
    fi
}

type () {
    # Private Internet | In Part Private Internet | Public Internet
    # 10.0.0.0/8
    # 172.16.0.0/12
    # 192.168.0.0/16 
    echo unknown
}

# function definition - end

{ IFS='./' read -a input; } <<< "$1"
ip=$(ip2int ${input[@]})
netmask=$(netmask ${input[4]})
class=$(class ${input[0]})
#type=$(type)

network=$(network $ip $netmask)
broadcast=$(broadcast $ip $netmask)
hosts=$(hosts $network $broadcast)
first_ip=$(( $network + 1 ))
last_ip=$(( $broadcast - 1 ))

printf "IPv4 Address: \t %15s /%s \t %s \n" "$(int2ip $ip)" "${input[4]}"   "$(int2ip_bin $ip)"
printf "Subnet Mask: \t %15s \t %s \n"      "$(int2ip $netmask)"            "$(int2ip_bin $netmask)" 
printf "Network: \t %15s \t %s \n"          "$(int2ip $network)"            "$(int2ip_bin $network)"
printf "Broadcast: \t %15s \t %s \n"        "$(int2ip $broadcast)"          "$(int2ip_bin $broadcast)"
printf "First Address: \t %15s \t %s \n"    "$(int2ip $first_ip)"           "$(int2ip_bin $first_ip)"
printf "Last Address: \t %15s \t %s \n"     "$(int2ip $last_ip)"            "$(int2ip_bin $last_ip)"
echo Hosts: $hosts
echo Class: $class
