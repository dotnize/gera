extends Node2D

var Bullet = preload('res://scenes/Bullet.tscn')


func _ready():
	$Player.connect('shoot', self, 'spawn_bullet')


func spawn_bullet(pos, dir):
	var bullet
	
	bullet = Bullet.instance()
	bullet.init(pos, dir)
	
	$BulletContainer.add_child(bullet)
