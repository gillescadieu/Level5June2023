from cvplibrary import Form


vlan = Form.getFieldById('vlan_id').getValue()
svi = Form.getFieldById('svi').getValue()
mask = 24

print("vlan %s") % vlan
print("")
print("interface vlan %s") % vlan
print("  ip address %s/%s") % (svi, mask)
