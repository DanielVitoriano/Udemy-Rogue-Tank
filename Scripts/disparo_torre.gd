extends Area2D

var dir = Vector2() setget set_dir
var vel = 400
var distancia_max = 300
onready var pos_inicial = global_position

func _ready():
	pass
	

func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(pos_inicial) > distancia_max:
		queue_free()
		
func set_dir(val):
	dir = val
	rotation = val.angle()

func _on_disparo_torre_area_entered(area):
	if area.has_method("acerto"):
		area.acerto(5, self)
		queue_free()
