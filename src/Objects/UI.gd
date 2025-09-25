extends CanvasLayer

@onready var cherry_description := $Shop/Trees/CherryContainer/DescriptionContainer/Description
@onready var ice_description := $Shop/Trees/IceContainer/DescriptionContainer/Description
@onready var big_description := $Shop/Trees/BigContainer/DescriptionContainer/Description


func _on_Cherry_pressed():
	GameController.build("cherry")


func _on_Ice_pressed():
	GameController.build("ice")


func _on_Big_pressed():
	GameController.build("big")


func _on_Cherry_mouse_entered():
	cherry_description.visible = true


func _on_Cherry_mouse_exited():
	cherry_description.visible = false


func _on_Ice_mouse_entered():
	ice_description.visible = true


func _on_Ice_mouse_exited():
	ice_description.visible = false


func _on_Big_mouse_entered():
	big_description.visible = true


func _on_Big_mouse_exited():
	big_description.visible = false
