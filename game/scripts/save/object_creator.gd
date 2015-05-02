static func create(var obj_name):
	if (obj_name == "Node"):
		return Node.new()
	elif (obj_name == "Camera"):
		return Camera.new()
	elif (obj_name == "DirectionalLight"):
		return DirectionalLight.new()
	elif (obj_name == "GridMap"):
		return GridMap.new()