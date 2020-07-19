extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_default_cursor_shape(0)
	Input.set_custom_mouse_cursor(null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PLAY_pressed():
	get_tree().change_scene("res://scenes/World.tscn")


func _on_EXIT_pressed():
	get_tree().quit() # Replace with function body.
