extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 100
var velocity = Vector2()
var direction_right = true
onready var height = self.position.y


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var random_speed = randi()%150 + 40
	speed = random_speed


func _physics_process(delta):
	velocity = Vector2()
	if direction_right:
		velocity.x += 1
	else:
		velocity.x -= 1
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

func flip_car():
	$Sprite.flip_h = true
	$Sprite.z_index = 0
	$Headlight.rotation_degrees = 180
	$Headlight.position.x = -31
	direction_right = false
	get_node("Car_Collider/CollisionCar").position.x = -15
	get_node("PlayerCollider/CollisionPlayer").position.x = -2


func _on_PlayerCollider_body_entered(body):
	print("Hit : ", body.name)
	body.game_over()


func _on_Car_Collider_body_entered(body):
	speed = body.speed
