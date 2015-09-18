static func create(var obj_name):
	var script = GDScript.new()
	script.set_source_code("static func create(): \n\t return " + obj_name + ".new()")
	script.reload()
	return script.create()
