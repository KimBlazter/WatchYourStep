extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const car_scene_ref = preload("res://Car_Scene.tscn")
var r_scene_ref = load("res://Road.tscn")
const energy_sc = preload("res://Energy.tscn")
onready var level_sc_ref = get_node("..")
onready var car_spawner_l = get_node("CarSpawnerLeft")
onready var car_spawner_r = get_node("CarSpawnerRight")
onready var pedestrian_c_0 = get_node("PedestrianCrosswalk")
onready var pedestrian_c_1 = get_node("PedestrianCrosswalk2")
var time = 0
var pos = abs(self.position.y)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_pedestrian_crosswalk()
	randomize_flowers()
	randomize_energy()



func _process(delta):
	pos = abs(self.position.y)
	time += delta
	$Label.text = str(5/(1+pos/100))
	randomize()
	if time > rand_range(5/(1+pos/100), 5):
		randomize()
		if rand_range(0,2) > 1:
			var car_i = car_scene_ref.instance()
			rdm_car_color(car_i)
			add_child(car_i)
			car_i.position.y = car_spawner_l.position.y
			car_i.position.x = car_spawner_l.position.x
		else:
			var car_i = car_scene_ref.instance()
			rdm_car_color(car_i)
			car_i.flip_car()
			add_child(car_i)
			car_i.position.y = car_spawner_r.position.y
			car_i.position.x = car_spawner_r.position.x
		time = 0
		
func spawn_road():
	var r_instance = r_scene_ref.instance()
	level_sc_ref.call_deferred("add_child", r_instance)
	r_instance.position = Vector2(self.position.x, self.position.y - 200)

func _on_Area2D_body_entered(body):
	spawn_road()
	
func rdm_car_color(car):
	randomize()
	var color = randi()%3
	car.get_node("Sprite").texture = load("res://car"+str(color)+".png")

func randomize_pedestrian_crosswalk():
	randomize()
	var p1pos = rand_range(car_spawner_l.position.x + 10, car_spawner_r.position.x / 2)
	var p2pos = p1pos + rand_range(70, 230)
	pedestrian_c_0.position.x = p1pos
	pedestrian_c_1.position.x = p2pos

func randomize_flowers():
	var flowers_array = []
	for i in range(0, 23):
		flowers_array.append(get_node("Flower"+str(i)))
	for e in flowers_array:
		randomize()
		e.texture = load("res://flower_"+str(randi()%4)+".png")

func randomize_energy():
	randomize()
	if randi()%10 > 8:
		var pos = rand_range(car_spawner_l.position.x + 100, car_spawner_r.position.x - 100)
		var e_i = energy_sc.instance()
		e_i.position = Vector2(pos, 55)
		add_child(e_i)
