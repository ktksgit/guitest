extends ConfirmationDialog

var selection = 0

const SCENE_START = "res://game/world/demo/start.xscn"
const SINGLE_DWARF_SCENE =  "res://game/world/single_dwarf/start_dwarf.xscn"

func _ready():
	var list = get_node("ItemList")
	list.add_item("Default")
	list.add_item("Single Dwarf")

func _on_ScenarioDialog_confirmed():
	hide()
	if(selection == 0):
		get_parent().loadScenario(SCENE_START)
	elif(selection == 1):
		get_parent().loadScenario(SINGLE_DWARF_SCENE)


func _on_ItemList_item_selected( index ):
	selection = index
