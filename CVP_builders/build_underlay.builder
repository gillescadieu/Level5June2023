import yaml
from cvplibrary import CVPGlobalVariables, GlobalVariableNames

labels = CVPGlobalVariables.getValue(GlobalVariableNames.CVP_SYSTEM_LABELS)

for item in labels:
  key, value = item.split(':')
  if key == 'hostname':
    hostname = value
    

devices = '''
leaf1-DC1: 
  interfaces:
    loopback0: 192.168.101.11/32
    loopback1: 192.168.102.11/32
leaf2-DC1:
  interfaces:
    loopback0: 192.168.101.12/32
    loopback1: 192.168.102.11/32
leaf3-DC1: 
  interfaces:
    loopback0: 192.168.101.13/32 
    loopback1: 192.168.102.13/32
leaf4-DC1: 
  interfaces:
    loopback0: 192.168.101.14/32
    loopback1: 192.168.102.13/32
borderleaf1-DC1:
  interfaces:
    loopback0: 192.168.101.15/32
    loopback1: 192.168.102.15/32
borderleaf2-DC1:
  interfaces:
    loopback0: 192.168.101.16/32
    loopback1: 192.168.102.15/32
spine1-DC1:
  interfaces:
    loopback0: 192.168.101.101/32
spine2-DC1:
  interfaces:
    loopback0: 192.168.101.102/32
spine3-DC1:
  interfaces:
    loopback0: 192.168.101.103/32
'''

leaf_uplinks = ['Ethernet3', 'Ethernet4', 'Ethernet5']
spine_downlinks = ['Ethernet2', 'Ethernet3', 'Ethernet4', 'Ethernet5', 'Ethernet6', 'Ethernet7']


# interface e3
#   no switchport
#   ip address unnumbered loopback 0
#   ip ospf area 0
#   ip ospf network point-to-point
  
# router ospf 10
#   router-id loopback0
# "


devices_dict = yaml.safe_load(devices)

def gen_ospf(hostname):
  lo0, mask = devices_dict[hostname]['interfaces']['loopback0'].split('/')
  print("router ospf 10")
  print("  router-id %s") % lo0
  if 'spine' in hostname:
    for interface in spine_downlinks:
      print("interface %s") % interface
      print("  no switchport")
      print("  ip address unnumbered loopback0")
      print("  ip ospf area 0")
      print("  ip ospf network point-to-point")

  if 'leaf' in hostname:
    for interface in leaf_uplinks:
      print("interface %s") % interface
      print("  no switchport")
      print("  ip address unnumbered loopback0")
      print("  ip ospf area 0")
      print("  ip ospf network point-to-point")   

print("ip routing")
def gen_loopback(hostname):
  for interface in devices_dict[hostname]['interfaces']:
    print("interface %s") % interface
    print("  ip address %s") % devices_dict[hostname]['interfaces'][interface]
if ('spine' or 'leaf' in hostname):    
  gen_loopback(hostname)
  gen_ospf(hostname)
