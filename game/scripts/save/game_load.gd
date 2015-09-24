var filename
var strategy

func _init(var s_filename, var strategy_class):
	filename = s_filename
	strategy = strategy_class
	
func loadTree(var parentNode):
	var loadingStrategy = strategy.new(filename)
	loadingStrategy.loadNodeTree(parentNode)
	loadingStrategy.finish()
	

# class for loading a node tree which is saved in binary 
class LoadAsFile:
	var file
	
	func _init (var filename):
		file = File.new()
		file.open(filename, File.READ)
	
	# creates a simple object
	#
	# @param
	#	obj_name : typename of the object which is created, e.g. Node
	# @return
	#	a reference to the object or null
	func _createObject(var obj_name):
		var script = GDScript.new()
		script.set_source_code("static func create(): \n\t return " + obj_name + ".new()")
		var error = script.reload()
		if (error != OK):
			return null
			
		return script.create()
	
	func loadNodeTree(parent):
		var name = file.get_var()
		var type = file.get_var()
		var node = _createObject(type)
		if(node == null):
			print ("Loading failed. Tried to create unexisting object type.")
			return
			
		node.set_name(name)
		
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
				
		
		#add the node to the parent after the script file (a property) is loaded and added to the node
		parent.add_child(node)
		
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
	
