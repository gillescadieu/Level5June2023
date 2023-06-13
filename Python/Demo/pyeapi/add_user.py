#!/usr/bin/python3

import pyeapi

switches = ['leaf1-DC1', 'leaf2-DC1', 'leaf3-DC1', 'leaf4-DC1', 'borderleaf1-DC1', 'borderleaf2-DC1', 'spine1-DC1', 'spine2-DC1', 'spine3-DC1']

username = "automator"
sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJP8mEf82JRslo9rwNVa7ivlUwHUAYcILixJWHD0ojybT112RYckgdemYpw1PXi/pAL7/5twL+OSWfwSvy/kcTTdoRwPggsrKzyyR1uCb+UyqRCsPo41hfeD+HOqsDO98ithPO5q4mOohNddWaNKXMTXB4vqOOTqNxq79cGWLWlbCM2vKRlGClpFAZ0YkF0bMBh6fPa74EuxcdYjGqijPFnGdlOOTPwhrCrLjjXhSyfwcebYNB1EWsf+IldXGvSS6ngLZSYiZzS3oq28VQy3TlJ3pbXTNPLOwfFJitn2iH/Yd6UZ1sb60zqtbvUlHSDTHFy4FnItPE+4Kp6LUUVKdZ arista@june2023l5-spare-1-c22abf98"

for switch in switches: 
    connect = pyeapi.connect_to(switch)
    result = connect.api("Users").create
