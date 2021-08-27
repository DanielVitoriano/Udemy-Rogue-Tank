tool
extends Node2D

export(float, 10, 3000) var sensor_radius = 500
export(float, 10, 1000) var radius = 10 setget set_radius
export(Color) var color = Color(0,0,0,0) setget set_color
export(NodePath) var tank

onready var raio = radius / sensor_radius

func _ready():
	if tank:
		tank = get_node(tank)

func _draw():
	draw_circle(Vector2(), radius, color)
	
	if !Engine.editor_hint:
		if tank and weakref(tank).get_ref():
			draw_circle(Vector2(), 3, Color.black)
			for re in get_tree().get_nodes_in_group("entidade_radar"):
				var angulo = (tank.global_position - re.global_position).angle()
				var distancia = tank.global_position.distance_to(re.global_position)
				if distancia < sensor_radius:
					draw_circle( Vector2(cos(angulo), sin(angulo)) * distancia * raio * (- 1), 2, Color(1, 0, 0))

func set_radius(val):
	radius = val
	if Engine.editor_hint:
		update()

func set_color(val):
	color = val
	if Engine.editor_hint:
		update()


func _on_Timer_timeout():
	update()
