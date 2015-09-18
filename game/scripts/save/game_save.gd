
var filename
var strategy

func _init(var s_filename, var strategy_class):
	filename = s_filename
	strategy = strategy_class

func saveTree(var node):
	_setOwnerRecursive(node, node)
	
	var savingStrategy = strategy.new(filename)
	savingStrategy.saveNodeTree(node)
	savingStrategy.finish()
	
func _setOwnerRecursive(var node, var owner):
	if (node.get_owner() != owner):
		node.set_owner(owner)
	
	for n in node.get_children():
		_setOwnerRecursive(n, owner)


# save strategy 1
class SaveAsFile:
	var file
	
	func _init (var filename):
		file = File.new()
		file.open(filename, File.WRITE)
	
	func finish():
		file.close()
	
	func saveNodeTree (var node):
		#TODO: save if the node should be processed
		file.store_var(node.get_name())
		file.store_var(node.get_type())
		file.store_var(node.is_processing())
		
		var props = node.get_property_list()
		var prop_size = props.size()
		var prop_size_store_location = file.get_pos()
		file.store_32(prop_size)
		
		#save the script reference first:
		for p in props:
			if(p["name"] == "script/script"):
				var script_instance = node.get("script/script")
				if(script_instance != null):
					file.store_8(255)
					file.store_var("script/script")
					file.store_var(script_instance.get_path())
					
					props.erase(p)
					break;
		
		for p in props:
			#print ("name: ", p["name"], " type: ", p["type"]);
			if (!p["usage"] & PROPERTY_USAGE_STORAGE):
				prop_size -= 1
				continue
			
			var value = node.get(p["name"])
			if (p["type"] == TYPE_OBJECT && value != null && value extends Resource):
				value = value.get_path()
				file.store_8(255)
			else:
				file.store_8(p["type"])
			
			#TODO: 	- check if type == OBJECT and object extends class Node. Save the NodePath of the object
			# 		- all other object types are not saved
			
			file.store_var(p["name"])
			file.store_var(value)
		
		#save correct property count
		var current_position = file.get_pos()
		file.seek(prop_size_store_location)
		file.store_32(prop_size)
		file.seek(current_position)
		
		#save child nodes
		file.store_32(node.get_child_count())
		for child in node.get_children():
			saveNodeTree(child)

# strategy class 2 
# save node and its children as a scene
# all properties of the nodes are saved
class SaveAsScene:
	var filename
	
	func _init (var filename):
		self.filename = filename
	
	func finish():
		pass
		
	func saveNodeTree(var world):
		var failed = false
		if (world != null):
			var pack = PackedScene.new()
			pack.pack(world)
			
			var res = ResourceSaver.save(filename, pack, ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_RELATIVE_PATHS )
			if (res != OK):
				failed = true
				
				if (res == ERR_FILE_UNRECOGNIZED):
					print ("wrong file type. Use .xscn")
				else:
					print ("Error-Code: ", res)
		else:
			failed = true
		
		if (failed):
			print ("Saving failed")
