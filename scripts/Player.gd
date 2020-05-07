extends KinematicBody2D

signal shoot

const WALK_SPEED = 130
const RUN_SPEED = 190
var velocity  = Vector2()
var speed = WALK_SPEED

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
	var move_vec = Vector2()
	if Input.is_action_pressed("ui_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_vec.y += 1
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
	if Input.is_action_pressed('run'):
		speed = RUN_SPEED
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.animation = 'player_run'
	else:
		speed = WALK_SPEED
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.animation = 'player_walk'
	
	var oldrot = global_rotation_degrees
	var look_vec = get_global_mouse_position() - global_position
	var mouserot = rad2deg(atan2(look_vec.y, look_vec.x))
	# interpolate
	if mouserot < -90 and oldrot > 90:
		mouserot += 360
	elif mouserot > 90 and oldrot < -90:
		mouserot -= 360
	TweenNode.interpolate_property(self, 'global_rotation_degrees', oldrot, mouserot, 0.15)
	TweenNode.start()
	
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

	if Input.is_action_pressed('shoot'):
		shoot()


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

func shoot():
	if not reloading and not shooting and not current_weapon == 0:
		shooting = true
		$ShootingTimer.start()
		
		emit_signal('shoot', $Aim.global_position, rotation)

func _on_ShootingTimer_timeout():
	shooting = false
	
# apply rotation for mouse
func _set_rotation(new_transform):
	
	# apply tweened x-vector of basis
	self.transform.x = new_transform
	
	# make x and y orthogonal and normalized
	self.transform = self.transform.orthonormalized()
