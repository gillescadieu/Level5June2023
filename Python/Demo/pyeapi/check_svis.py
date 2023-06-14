#!/usr/bin/python3

import pyeapi

# The aim is to free up subnets allocated to SVIs 10 and 20 on a hundred switches 
# so if a switch has no VLAN 10 or 20 allocated to any "up interfaces" then we can consider the subnet unused if the "down interfaces" have been down for a certain amount of time (eg 90 days)

# Is VLAN 10 present on each individual switch?
# 	if yes, is there any active port in vlan 10?
# 		if yes, we don't do anything
# 		if no, then list the unactive ports in this VLAN and display their downtime (ideally against the switch uptime)

# Log the results switch per switch

# Initial variables 

switch_file = open("switches.txt", "r")
switches = switch_file.read().splitlines()
vlans = [10,20]



connect = pyeapi.connect_to('leaf1-DC1')
vlan_output = connect.run_commands(['show vlan'],)

vlan_output = vlan_output[0]

for switch in switches:
    print("Switch:", switch)
    for vlan in vlan_output['vlans']:
        if len(vlan_output['vlans'][vlan]['interfaces']) == 0:
            print("  VLAN", vlan, "is empty")
        if len(vlan_output['vlans'][vlan]['interfaces']) != 0:
            print("  VLAN", vlan, "is not empty and contains:")
        for interface in vlan_output['vlans'][vlan]['interfaces']:
            check_int_command = "show interfaces "+interface
            int_output = connect.run_commands([check_int_command],)
            int_status = int_output[0]['interfaces'][interface]['interfaceStatus']
            if int_status == "connected":
                print("        interface ", interface, "is connected")
            if int_status != "connected":
                print("        interface ", interface, "is not connected")

