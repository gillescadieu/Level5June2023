import yaml

data_model_dis = open('switches.yaml', 'r')

data_model = data_model_dis.read()

data_model_dict = yaml.safe_load(data_model)

for switch in data_model_dict['devices']:
    print(switch+":")
    for interface in data_model_dict['devices'][switch]['interfaces']:
        print("interface", interface)
        print("  ip address", data_model_dict['devices'][switch]['interfaces'][interface])
        print("router bgp", data_model_dict['devices'][switch]['BGP']['ASN'])
        ip,mask = data_model_dict['devices'][switch]['interfaces']['loopback0'].split('/')
        print("  router-id", ip)
        
