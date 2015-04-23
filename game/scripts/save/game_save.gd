

func saveTree(var node, var gridMap, var filename):
	var pack = PackedScene.new()
	pack.pack(gridMap)
	
	var res = ResourceSaver.save("res://savegames/map_tmp.scn", pack, ResourceSaver.FLAG_COMPRESS)
	_setOwnerRecursive(node, node)
	
	var file = File.new()
	file.open(filename, File.WRITE)
	_saveNode(node, file)
	file.close()
	
func _setOwnerRecursive(var node, var owner):
	if (node.get_owner() != owner):
		node.set_owner(owner)
	
	for n in node.get_children():
		_setOwnerRecursive(n, owner)
		
func _saveNode (var node, var file):
	file.store_var(node.get_name())
	file.store_var(node.get_type())
	file.store_32(node.get_child_count())
	
	var props = node.get_property_list()
	for p in props:
		print ("name: ", p["name"], " type: ", p["type"]);
		if (!p["usage"] & PROPERTY_USAGE_STORAGE):
			continue
		
		var value = node.get(p["name"])
		print ("value: ", value)
		
		file.store_var(p["name"])
		file.store_var(value)
	
	for child in node.get_children():
		_saveNode(child, file)