extends KinematicBody2D

signal shoot

const WALK_SPEED = 140
const RUN_SPEED = 200
var velocity  = Vector2()
var speed = WALK_SPEED

var shooting  = false
var reloading = false
var current_weapon = 0


func _ready():
	$PlayerSprite.animation = 'player_walk_unarmed'
	$PlayerSprite.playing = false
	$PlayerSprite.frame = 0


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
			$PlayerSprite.animation = 'player_run_unarmed'
	else:
		speed = WALK_SPEED
		if not reloading and not shooting and current_weapon == 0:
			$PlayerSprite.animation = 'player_walk_unarmed'
		
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
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
