extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func randomize_flowers():
	var flowers_array = []
	for i in range(0, 99):
		flowers_array.append(get_node("Flower"+str(i)))
	for e in flowers_array:
		randomize()
		e.texture = load("res://flower_"+str(randi()%4)+".png")
