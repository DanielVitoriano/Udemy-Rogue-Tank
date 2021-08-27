extends ColorRect

export var tamanho_area = Vector2()
var proporsao

func _ready():
	proporsao = get_rect().size / tamanho_area

func _draw():
	for re in get_tree().get_nodes_in_group("entidade_radar"):
		draw_circle(re.global_position * proporsao, 2, Color(1,0,0,1))

	for j in get_tree().get_nodes_in_group("jogador"):
		draw_circle(j.global_position * proporsao, 2, Color(1,1,1,1))
	
func _on_timer_radar_timeout():
	update()
