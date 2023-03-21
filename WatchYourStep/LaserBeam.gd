extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var length = 1000
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	$RayCast2D.force_raycast_update()
	var end_point = get_global_mouse_position()
	var init_pos = self.position
	$RayCast2D.cast_to = -(init_pos - end_point)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		$AnimatedSprite.position = to_local($RayCast2D.get_collision_point())
		$AnimatedSprite.visible = true
		$AnimatedSprite.play("default")
		$RayCast2D.get_collider().queue_free()
	player.energy -= 1
	randomize()
	$LaserSound.pitch_scale = rand_range(0.7, 0.7)
	$LaserSound.play()
	$RayCast2D/Beam.visible = true
	$RayCast2D/Beam.rotation = $RayCast2D.cast_to.angle() + deg2rad(-90)
	$RayCast2D/Beam.region_rect.end.y = $RayCast2D.cast_to.length()
	$RayCast2D/Beam/AnimationBeam.play("LaserDisapear")


func _on_AnimatedSprite_animation_finished():
	queue_free()
