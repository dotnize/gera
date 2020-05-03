extends Node2D

var Bullet = preload('res://scenes/Bullet.tscn')


func _ready():
	$Player.connect('shoot', self, 'spawn_bullet')
	Input.set_default_cursor_shape(3)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene("res://scenes/Menu.tscn")

func spawn_bullet(pos, dir):
	var bullet
	
	bullet = Bullet.instance()
	bullet.init(pos, dir)
	
	$BulletContainer.add_child(bullet)
