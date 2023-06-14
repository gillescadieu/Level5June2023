
import pyeapi


vlans = [100,101,102,103,55,2100]
switches = ['leaf1-DC1', 'leaf2-DC1', 'leaf3-DC1', 'leaf4-DC1']

for switch in switches: 
    connect = pyeapi.connect_to(switch)
    for vlan in vlans:
        result = connect.api("vlans").create(vlan)
        if result == True:
            print("We added VLAN", vlan, "for switch", switch)
        if result == False:
            print("Something went wrong")



