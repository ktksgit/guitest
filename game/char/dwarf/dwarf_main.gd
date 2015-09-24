extends Sprite3D

func _ready():
	pass

func select():
	print("selected dwarf")

func _on_StaticBody_input_event( camera, event, click_pos, click_normal, shape_idx ):
	# FIX/TODO this does not work
	print("selected ")
	print(click_pos)

