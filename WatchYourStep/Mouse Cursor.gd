extends Sprite


var mouse_visibility: bool = true

func _ready():
	# Hide mouse windows mouse cursor on launch.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update custom mouse cursor every tick.
	self.position = get_global_mouse_position()
