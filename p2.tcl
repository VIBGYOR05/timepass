5. Implement simple ESS and with transmitting nodes in wire-less LAN by simulation and determine the performance with respect to transmission of packets.

 Basic Service Set (BSS) : Basic Service Set (BSS), as name suggests, is a group or set of all stations that communicate with each together. Here, stations are considered as computers or components connected to wired network. 
Advantages of BSS:
* Simplicity: A BSS is a simple and cost-effective way to provide wireless connectivity for a small area, such as a home or office.
* Easy to set up: Setting up a BSS is straightforward, as it only requires a single Access Point (AP) and a set of client devices.
* Lower latency: A BSS can provide lower latency than an ESS, as there is no need to communicate with other APs or a central controller.
* Easier to manage: A BSS is easier to manage than an ESS, as there is only one AP to configure and maintain.
Disadvantages of BSS:
* Limited coverage: A BSS has limited coverage, typically ranging from a few meters to a few hundred meters.
* Limited scalability: A BSS is not scalable beyond a certain point, as adding more users or devices can cause congestion and slow down the network.
* Limited mobility: Clients within a BSS can move around within its coverage area without losing connectivity, but cannot roam between different BSSs.
2. Extended Service Set (ESS) : Extended Service Set (ESS), as name suggests, is a group of BSSs or one or more interconnected BSS along with their wired network. 
Advantages of ESS:
* Scalability: An ESS can be scaled to cover a much larger area by interconnecting multiple BSSs.
* Greater coverage: An ESS can provide coverage over a large area, such as a campus or an entire building.
* Mobility: Clients within an ESS can roam between different BSSs without losing connectivity, allowing for greater mobility.
* Centralized management: An ESS can be managed centrally, making it easier to configure and maintain.
Similarities between the two:
* Components: Both BSS and ESS are made up of Access Points (APs) and client devices, such as laptops, smartphones, and tablets.
* Standards: Both BSS and ESS are defined by the IEEE 802.11 standard for wireless local area networks (WLANs).
* Frequency: Both BSS and ESS operate on one or more frequency bands, such as 2.4 GHz or 5 GHz.
* Connectivity: Both BSS and ESS provide wireless connectivity between client devices and the network infrastructure.
* Security: Both BSS and ESS can implement security measures, such as encryption and authentication, to protect the network and its users from unauthorized access.
* Roaming: Both BSS and ESS support client device roaming, which allows users to move from one coverage area to another without losing connectivity.


#create Simulator class
set ns [new Simulator]

#open trace file
set nt [open lab2.tr w]
$ns trace-all $nt

#create Topography object
set topo [new Topography]

#define grid size
$topo load_flatgrid 1000 1000

#open namtrace file
set nf [open lab2.nam w]


$ns namtrace-all-wireless $nf 1000 1000

#specify mobile node Parameter configuration
$ns node-config -adhocRouting DSDV \
-llType LL \
-macType Mac/802_11 \
-ifqType Queue/DropTail \
-ifqLen 20 \
-phyType Phy/WirelessPhy \
-channelType Channel/WirelessChannel \
-propType Propagation/TwoRayGround \
-antType Antenna/OmniAntenna \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON

#create a General Operation Director(god) object that stores the total number of mobile nodes.
create-god 4

#create nodes and label them
set n0 [$ns node]
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node]

$n0 label "tcp0"
$n1 label "sink0"
$n2 label "bs1"
$n3 label "bs2"

#give initial x, y, z coordinates to nodes
$n0 set X_ 110
$n0 set Y_ 500
$n0 set Z_ 0

$n1 set X_ 600
$n1 set Y_ 500
$n1 set Z_ 0

$n2 set X_ 300
$n2 set Y_ 500
$n2 set Z_ 0

$n3 set X_ 450
$n3 set Y_ 500
$n3 set Z_ 0

#attach agent and application to nodes and connect them

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1


$ns connect $tcp0 $sink1

#schedule the event
$ns at 0.5 "$ftp0 start"

#set up a destination for mobile nodes. They move to <x><y> coordinates at <s>m/s.


$ns at 0.3 "$n0 set dest 110 500 10"
$ns at 0.3 "$n1 set dest 600 500 20"
$ns at 0.3 "$n2 set dest 300 500 30"
$ns at 0.3 "$n3 set dest 450 500 30"

$ns at 10.0 "$n0 set dest 100 550 5"
$ns at 10.0 "$n1 set dest 630 450 5"
$ns at 70.0 "$n0 set dest 170 680 5"
$ns at 70.0 "$n1 set dest 580 380 5"

$ns at 120.0 "$n0 set dest 140 720 5"
$ns at 135.0 "$n0 set dest 110 600 5"
$ns at 140.0 "$n1 set dest 600 550 5"
$ns at 155.0 "$n0 set dest 89 500 5"
$ns at 190.0 "$n0 set dest 100 440 5"
$ns at 210.0 "$n1 set dest 700 600 5"
$ns at 240.0 "$n1 set dest 650 500 5" 




proc finish { } {
global ns nt nf
$ns flush-trace
exec nam lab2.nam & 
close $nt
close $nf 
exit 0
}

$ns at 400 "finish"
$ns run

