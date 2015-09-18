var filename
var strategy

func _init(var s_filename, var strategy_class):
	filename = s_filename
	strategy = strategy_class
	
func loadTree(var parentNode):
	var loadingStrategy = strategy.new(filename)
	loadingStrategy.loadNodeTree(parentNode)
	loadingStrategy.finish()
	

class LoadAsFile:
	var file
	var object_creator
	
	func _init (var filename):
		var object_creator_class = load("res://game/scripts/save/object_creator.gd")
		object_creator = object_creator_class
		
		file = File.new()
		file.open(filename, File.READ)
	
	func loadNodeTree(parent):
		var name = file.get_var();
		var type = file.get_var();
		var node = object_creator.create(type)
		node.set_name(name)
		node.set_process(file.get_var())
		parent.add_child(node)
		
		print ("created ", name, " ", type)
		
		var prop_count = file.get_32()
		print ("prop_count ", prop_count)
		
		for i in range (prop_count):
			type = file.get_8()
			name = file.get_var()
			var value = file.get_var()
			
			if (type == 255):
				var resource = load (value)
				node.set(name, resource)
			else:
				node.set(name, value)
				
#			if (type != 20):
#				print (type, " ", name, " " , value);
#			else:
#				print (type, " ", name);
		
		var children_count = file.get_32()
		for i in range (children_count):
			loadNodeTree(node)
		
	func finish():
		file.close()

class LoadAsScene:
	var filename
	
	func _init (var filename):
		self.filename = filename
	
	func loadNodeTree(world):
		var world = load(filename)
		if (world == null):
			print ("loading failed. Error: ", world)
			
		return world
	