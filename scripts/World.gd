extends Node2D

var Bullet = preload('res://scenes/Bullet.tscn')


func _ready():
	$Player.connect('shoot', self, 'spawn_bullet')
	Input.set_default_cursor_shape(3)

func spawn_bullet(pos, dir):
	var bullet
	
	bullet = Bullet.instance()
	bullet.init(pos, dir)
	
	$BulletContainer.add_child(bullet)
