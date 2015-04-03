
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"
var t

func _process(delta):
	t = get_parent().get_node("Position3D").get_translation()
	set_translation(t)

func _ready():
	set_process(true)
	pass


