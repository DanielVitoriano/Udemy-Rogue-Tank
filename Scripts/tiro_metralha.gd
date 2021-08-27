extends Area2D

var atirador

var velocidade = 400
var direcao = Vector2()
var dano = 1
onready var posicao_inicial = global_position


func _physics_process(delta):
	translate(direcao * velocidade * delta)
	if global_position.distance_to(posicao_inicial) > 150:
		auto_destruicao()


func _on_tiro_metralha_area_entered(area):
	if area.has_method("acerto"):
		area.acerto(dano, self)
		auto_destruicao()


func _on_tiro_metralha_body_entered(body):
	auto_destruicao()

func auto_destruicao():
	queue_free()
