from cvprac.cvp_client import CvpClient

# The next three lines are only to keep Python from warning about self-signed certificates
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

cvp = "192.168.0.5"
cvp_user = "arista"
cvp_pw = "arista3sho"

client = CvpClient()

client.connect([cvp], cvp_user, cvp_pw)

inventory = client.api.get_inventory()

for item in inventory:
    if item['complianceIndication'] == "WARNING":
        print("The switch", item['hostname'], "is out of compliance")
    else: 
        print("The switch", item['hostname'], "is in compliance")