extends ColorRect

onready var tamanho_inicial = rect_size
var scale = 1 setget set_scale
var vertical = false

func _draw():
	draw_rect(Rect2(Vector2(), tamanho_inicial), Color(0, 0.6, 0), false)
	
	if tamanho_inicial.y > tamanho_inicial.x:
		vertical = true

func set_scale(val):
	scale = val
	
	if vertical:
		rect_size.x = tamanho_inicial.y * scale 
	else:
		rect_size.x = tamanho_inicial.x * scale 
