extends Area2D

var distancia_maxima = 250

var atirador
var velocidade = 300
var dano = 10;
var dir = Vector2(0, -1) setget setDir
var vivo = true;
onready var pos_inicial = global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



func _process(delta):
	if vivo:
		if( global_position.distance_to(pos_inicial) > distancia_maxima):
			auto_destruicao()
		translate(dir * velocidade * delta)
	pass


func _on_area_notificacao_screen_exited():
	auto_destruicao()
	pass # Replace with function body.

func setDir(val):
	dir = val
	rotation = dir.angle()
	pass

func auto_destruicao():
	$fumaca.emitting = false
	vivo = false
	$tiro_sprite.visible = false
	$anim_destroi.play("destroindose")
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	yield($anim_destroi, "animation_finished")
	queue_free()

func _on_tiro_body_entered(body):
	auto_destruicao()


func _on_tiro_area_entered(area):
	if area.has_method("acerto"):
		area.acerto(dano, self)
		auto_destruicao()
