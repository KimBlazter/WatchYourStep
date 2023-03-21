extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 0
var velocity: Vector2 = Vector2()
onready var sprite = get_node("Sprite")
onready var drop_shadow_sprite = get_node("Sprite/DropShadow")
var facing_left: bool = false	# true mean right and false mean left
var step: int = 0
var started: bool = false
var game_over: bool = false

func _ready():
	get_tree().paused = true
	
func update_flip():
	if facing_left:
		sprite.set_flip_h(true)
		drop_shadow_sprite.position.x = 9
	else:
		sprite.set_flip_h(false)
		drop_shadow_sprite.position.x = 8

func _physics_process(delta):
	update_movement()

	# Input left click

	if Input.is_action_just_pressed("start"):
		if game_over:
			get_tree().change_scene("res://LevelScene.tscn")
		elif !started:
			get_tree().paused = false
			$StartupSound.play()
			$StartupMenu/Press/AnimationText.play("Hide")
			$StartupMenu/AnimationPlayer.play("Start")
			started = true
	
	$Node2D/Score.text = "score: "+str(abs(floor(self.position.y)))
		
func game_over():
	speed = 0
	$EnvMusic.stop()
	$GameOverSound.play()
	get_tree().paused = true
	$GameOverMenu.visible = true
	$GameOverMenu/GOAnimationPlayer.play("GameOver")

func update_movement():
	randomize()
	var r = rand_range(0, 1000)
	if r > 995:
		facing_left = !facing_left

	velocity = Vector2()
	velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	update_flip()
	velocity = move_and_slide(velocity)
	if is_moving():
		sprite.animation = "walk"
	else:
		sprite.animation = "idle"
	
func is_moving():
	return velocity != Vector2(0, 0)

func _on_Area2D_body_entered(body):
	body.get_owner().queue_free()	# Remove roads that are not visible anymore
	step += 1
	var t_speed = speed + step/5
	speed = clamp(t_speed, 20, 60)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Start":
		speed = 20
		$StartupMenu.queue_free()


func _on_GOAnimationPlayer_animation_finished(anim_name):
	game_over = true

func update_energy(e: int):
	var pb = $Node2D/Control/EnergyAmount
	pb.text = str(e) + "x"
