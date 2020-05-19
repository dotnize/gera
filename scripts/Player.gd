extends KinematicBody2D

signal shoot

const WALK_SPEED = 60
const RUN_SPEED = 110
var velocity  = Vector2()
var move_vec = Vector2()
var speed = WALK_SPEED
var idle = true

var shooting  = false
var reloading = false
var current_weapon = 0
var aiming

onready var TweenNode = get_node("Tween")

func _ready():
	$PlayerSprite.animation = 'player_walk'
	$PlayerSprite.playing = false
	$PlayerSprite.frame = 0
	aiming = false
	$Camera2D.position = Vector2(0.0, 0.0)


func _physics_process(delta):
	movement()
	if Input.is_action_pressed('shoot'):
		shoot()

func _process(delta):
	rotation()

func _input(event):
	if event.is_action_pressed('aim'):
		if !aiming:
			$Camera2D.position = Vector2(120.0, 0.0)
			aiming = true
		elif aiming:
			aiming = false
			$Camera2D.position = Vector2(0.0, 0.0)
	
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene("res://scenes/Menu.tscn")
		
	if event.is_action_pressed('equip1'):
		$PlayerSprite.animation = 'player_rifle'
		$PistolSprite.visible = false
		$RifleSprite.visible = true
		$RifleSprite.animation = 'smg_mp5'
		$ShootingTimer.wait_time = 0.1
		current_weapon = 1
	if event.is_action_pressed('equip2'):
		$PlayerSprite.animation = 'player_pistol'
		$PistolSprite.visible = true
		$RifleSprite.visible = false
		$PistolSprite.animation = 'pistol_9mm'
		$ShootingTimer.wait_time = 0.6
		current_weapon = 2
	if event.is_action_pressed('equip3'):
		current_weapon = 0
		$PistolSprite.visible = false
		$RifleSprite.visible = false
func movement():
	move_vec.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	move_vec.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if move_vec != Vector2(0, 0):
		idle = false
	else:
		idle = true
	if Input.is_action_pressed('run'):
		speed = RUN_SPEED
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.animation = 'player_run'
	else:
		speed = WALK_SPEED
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.animation = 'player_walk'
	if move_vec.length() > 0:
		velocity = move_vec.normalized() * speed
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.playing = true
	else:
		velocity *= 0
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.playing = false
			$PlayerSprite.frame = 0
			
	move_and_slide(velocity)

func rotation():
	var newrot
	var oldrot = global_rotation_degrees

	if idle and Input.is_action_pressed('run'):
		pass # dont rotate if idle and shifting
	else:
		if not idle and Input.is_action_pressed('run'):
			match move_vec:
				Vector2(-1, 0): #left
					newrot = -180
				Vector2(1, 0): #right
					newrot = 0
				Vector2(0, 1): #down
					newrot = 90
				Vector2(0, -1): #up
					newrot = -90
				Vector2(-1, -1): #upleft
					newrot = -135
				Vector2(-1, 1): #downleft
					newrot = 135
				Vector2(1, -1): #upright
					newrot = -45
				Vector2(1, 1): #downright
					newrot = 45
		else:
			var look_vec = get_global_mouse_position() - global_position
			newrot = rad2deg(atan2(look_vec.y, look_vec.x))
		
		if newrot <= -90 and oldrot >= 90:
			newrot += 360
		elif newrot >= 90 and oldrot <= -90:
			newrot -= 360
		TweenNode.interpolate_property(self, 'global_rotation_degrees', oldrot, newrot, 0.2, 0, 2)
		TweenNode.start()

func shoot():
	if not reloading and not shooting and not current_weapon == 0:
		shooting = true
		$ShootingTimer.start()
		
		emit_signal('shoot', $Aim.global_position, rotation)

func _on_ShootingTimer_timeout():
	shooting = false
