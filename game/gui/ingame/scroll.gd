extends Control

var bScrollHorizontal = 0
var bScrollVertical = 0

func _ready():
	set_process(true)

func _process(delta):
	if(bScrollHorizontal != 0):
		var cam = get_viewport().get_camera()
		cam.move(Vector3(bScrollHorizontal, 0, 0) * delta)
		
	if(bScrollVertical != 0):
		var cam = get_viewport().get_camera()
		cam.move(Vector3(0, bScrollVertical, 0) * delta)

func _on_ScrollRight_mouse_enter():
	bScrollHorizontal = 1

func _on_ScrollRight_mouse_exit():
	bScrollHorizontal = 0

func _on_ScrollUp_mouse_enter():
	bScrollVertical = 1

func _on_ScrollUp_mouse_exit():
	bScrollVertical = 0


func _on_ScrollLeft_mouse_enter():
	bScrollHorizontal = -1


func _on_ScrollLeft_mouse_exit():
	bScrollHorizontal = 0


func _on_ScrollDown_mouse_enter():
	bScrollVertical = -1

func _on_ScrollDown_mouse_exit():
	bScrollVertical = 0
