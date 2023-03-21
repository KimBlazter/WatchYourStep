extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 100
var velocity: Vector2 = Vector2()
onready var sprite = get_node("Sprite")
onready var hair_sprite = get_node("Sprite/hair")
onready var drop_shadow_sprite = get_node("Sprite/DropShadow")
const laser_sc = preload("res://LaserBeam.tscn")
onready var old_man_ref = get_node("../OldMan")
var energy: int = 100
var max_energy:int = 100

var facing_left = false	# true mean right and false mean left

	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
		facing_left = false
	if Input.is_action_pressed("left"):
		facing_left = true
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if facing_left:
		sprite.set_flip_h(true)
		hair_sprite.set_flip_h(true)
		drop_shadow_sprite.position.x = 1
		$Sprite/Particles2D.rotation_degrees = 180
	else:
		sprite.set_flip_h(false)
		hair_sprite.set_flip_h(false)
		drop_shadow_sprite.position.x = 0
		$Sprite/Particles2D.rotation_degrees = 0
		
	velocity = velocity.normalized() * speed

func refill_energy():
	energy = max_energy
	old_man_ref.update_energy(max_energy)
	$Pickup.play()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	if is_moving():
		sprite.animation = "run"
		hair_sprite.animation = "run"
		$Sprite/Particles2D.emitting = true
		
		if $Timer.time_left <= 0:
			randomize()
			$FootStep.pitch_scale = rand_range(0.9, 1.05)
			$FootStep.play()
			$Timer.start(0.35)
	else:
		sprite.animation = "idle"
		hair_sprite.animation = "idle"
		$Sprite/Particles2D.emitting = false

func shoot():
	if energy > 0:
		var laser_i = laser_sc.instance()
		laser_i.position = self.position
		laser_i.player = self
		get_node("..").add_child(laser_i)
		
		old_man_ref.update_energy(energy)

func game_over():
	old_man_ref.game_over()

func is_mouse_left():
	return get_global_mouse_position().x < self.position.x
	
func is_moving():
	return velocity != Vector2(0, 0)
	
func norm2(v: Vector2) -> float:	#magnitdue
	return sqrt(pow(v.x, 2) + pow(v.y, 2))

func angleBetweenVector2(v1: Vector2, v2: Vector2) -> float:
	return acos((v1.x * v2.x + v1.y * v2.y) / (norm2(v1) * norm2(v2)))
