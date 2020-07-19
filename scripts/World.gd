extends Node2D

var Bullet = preload('res://scenes/Bullet.tscn')
var crosshair1 = load('res://assets/crosshair001.png')

func _ready():
# warning-ignore:return_value_discarded
	$Player.connect('shoot', self, 'spawn_bullet')
	Input.set_custom_mouse_cursor(crosshair1, 0, Vector2(16, 16))
	$Player/CanvasLayer2/FogDetector.scale = Vector2(get_viewport_rect().size.x * 0.01, get_viewport_rect().size.y * 0.01)
	$Player/CanvasLayer2/FogDetector.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	$AnimationPlayer.play("timecycle")
	$Player/AnimationPlayer.play("fov_timecycle")

func spawn_bullet(pos, dir):
	var bullet
	bullet = Bullet.instance()
	bullet.init(pos, dir)
	
	$BulletContainer.add_child(bullet)
