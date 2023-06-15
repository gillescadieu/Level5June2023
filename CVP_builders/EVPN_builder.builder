import yaml

from cvplibrary import CVPGlobalVariables, GlobalVariableNames

labels = CVPGlobalVariables.getValue(GlobalVariableNames.CVP_SYSTEM_LABELS)

for item in labels:
  key, value = item.split(':')
  if key == 'hostname':
    hostname = value

EVPN_model_raw = """
leaf1-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.11
      mask: 32
    loopback1:
      ipv4: 192.168.102.11
      mask: 32
    Ethernet3:
      ipv4: 192.168.103.0
      mask: 31
    Ethernet4:
      ipv4: 192.168.103.2
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.4
      mask: 31
  BGP: 
    ASN: 65101
    spine_peers:
      - 192.168.103.1
      - 192.168.103.3
      - 192.168.103.5
leaf2-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.12
      mask: 32
    loopback1:
      ipv4: 192.168.102.11
      mask: 32
    Ethernet3:
      ipv4: 192.168.103.6
      mask: 31
    Ethernet4:
      ipv4: 192.168.103.8
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.10
      mask: 31
  BGP:
    ASN: 65101
    spine_peers:
      - 192.168.103.7
      - 192.168.103.9
      - 192.168.101.11
leaf3-DC1:
  interfaces:
      loopback0:
        ipv4: 192.168.101.13
        mask: 32
      loopback1:
        ipv4: 192.168.102.13
        mask: 32
      Ethernet3:
        ipv4: 192.168.103.12
        mask: 31
      Ethernet4:
        ipv4: 192.168.103.14
        mask: 31
      Ethernet5:
        ipv4: 192.168.103.16
        mask: 31
  BGP:
    ASN: 65102
    spine_peers:
      - 192.168.103.13
      - 192.168.103.15
      - 192.168.101.17
leaf4-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.14
      mask: 32
    loopback1:
      ipv4: 192.168.102.13
      mask: 32
    Ethernet3:
        ipv4: 192.168.103.18
        mask: 31
    Ethernet4:
      ipv4: 192.168.103.20
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.22
      mask: 31
  BGP: 
    ASN: 65102
    spine_peers:
      - 192.168.103.19
      - 192.168.103.21
      - 192.168.101.23
spine1-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.101
      mask: 32
    Ethernet2:
      ipv4: 192.168.103.1
      mask: 31
    Ethernet3:
      ipv4: 192.168.103.7
      mask: 31
    Ethernet4:
      ipv4: 192.168.103.13
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.19
      mask: 31
    Ethernet6:
      ipv4: 192.168.103.25
      mask: 31
    Ethernet7:
      ipv4: 192.168.103.31
      mask: 31
  BGP:
    ASN: 65100
spine2-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.102
      mask: 32
    Ethernet2:
      ipv4: 192.168.103.3
      mask: 31
    Ethernet3:
      ipv4: 192.168.103.9
      mask: 31
    Ethernet4:
      ipv4: 192.168.103.15
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.21
      mask: 31
    Ethernet6:
      ipv4: 192.168.103.27
      mask: 31
    Ethernet7:
      ipv4: 192.168.103.33
      mask: 31
  BGP: 
    ASN: 65100
spine3-DC1:
  interfaces:
    loopback0:
      ipv4: 192.168.101.103
      mask: 32
    Ethernet2:
      ipv4: 192.168.103.5
      mask: 31
    Ethernet3:
      ipv4: 192.168.103.11
      mask: 31
    Ethernet4:
      ipv4: 192.168.103.17
      mask: 31
    Ethernet5:
      ipv4: 192.168.103.23
      mask: 31
    Ethernet6:
      ipv4: 192.168.103.29
      mask: 31
    Ethernet7:
      ipv4: 192.168.103.35
      mask: 31
  BGP: 
    ASN: 65100
"""

EVPN_data_model = yaml.safe_load(EVPN_model_raw)

def gen_interface(hostname):
  for interface in EVPN_data_model[hostname]['interfaces']:
    ipv4 = EVPN_data_model[hostname]['interfaces'][interface]['ipv4']
    mask =  EVPN_data_model[hostname]['interfaces'][interface]['mask']
    print("interface %s") % interface
    print("  ip address %s/%s") % (ipv4,mask)
    if "Ethernet" in interface:
      print("  mtu 9214")
      print("  no switchport")
def gen_spine(hostname):
  print("ip prefix-list LOOPBACK")
  print("  seq 10 permit 192.168.101.0/24 eq 32")
  print("  seq 20 permit 192.168.102.0/24 eq 32")
  print("route-map LOOPBACK permit 10")
  print("  match ip address prefix-list LOOPBACK")
  print("peer-filter LEAF-AS-RANGE")
  print("  10 match as-range 65000-65535 result accept")
  ASN = EVPN_data_model[hostname]['BGP']['ASN']
  lo0 = EVPN_data_model[hostname]['interfaces']['loopback0']['ipv4']
  print("router bgp %s") % ASN
  print("  router-id %s") % lo0
  print("  no bgp default ipv4-unicast")
  print("  maximum-paths 3")
  print("  distance bgp 20 200 200")
  print("  bgp listen range 192.168.0.0/16 peer-group LEAF_Underlay peer-filter LEAF-AS-RANGE")
  print("  neighbor LEAF_Underlay peer group")
  print("  neighbor LEAF_Underlay send-community")
  print("  neighbor LEAF_Underlay maximum-routes 12000")
  print("  redistribute connected route-map LOOPBACK")
  print("  address-family ipv4")
  print("    neighbor LEAF_Underlay activate")
  print("    redistribute connected route-map LOOPBACK")

def gen_leaf(hostname):
  print("ip prefix-list LOOPBACK")
  print("  seq 10 permit 192.168.101.0/24 eq 32")
  print("  seq 20 permit 192.168.102.0/24 eq 32")
  print("route-map LOOPBACK permit 10")
  print("  match ip address prefix-list LOOPBACK")
  ASN = EVPN_data_model[hostname]['BGP']['ASN']
  lo0 = EVPN_data_model[hostname]['interfaces']['loopback0']['ipv4']
  print("router bgp %s") % ASN
  print("  router-id %s") % lo0
  print("  no bgp default ipv4-unicast")
  print("  maximum-paths 3")
  print("  distance bgp 20 200 200")
  print("  neighbor SPINE_Underlay peer group")
  if "DC1" in hostname:
    print("  neighbor SPINE_Underlay remote-as 65100")
  if "DC2" in hostname:
    print("  neighbor SPINE_Underlay remote-as 65200")
  print("  neighbor SPINE_Underlay send-community")
  print("  neighbor SPINE_Underlay maximum-routes 12000")
  print("  neighbor LEAF_Peer peer group")
  print("  neighbor LEAF_Peer remote-as %s") % ASN
  print("  neighbor LEAF_Peer next-hop-self")
  print("  neighbor LEAF_Peer maximum-routes 12000")
  for neighbor in EVPN_data_model[hostname]['BGP']['spine_peers']:
    print("  neighbor %s peer group SPINE_Underlay") % neighbor

  print("  redistribute connected route-map LOOPBACK")
  print("  address-family ipv4") 
  print("    neighbor SPINE_Underlay activate")
  print("    neighbor LEAF_Peer activate") 

gen_interface(hostname) 

if 'spine' in hostname:
  gen_spine(hostname)
  
if 'leaf' in hostname:
  gen_leaf(hostname)