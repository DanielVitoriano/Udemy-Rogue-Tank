extends Area2D

var velocidade = 120
var alvo
var seguindo = false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	seguindo = true

func _process(delta):
	if seguindo:
		if alvo:
			var angle = get_angle_to(alvo.global_position)
			if abs(angle) > .01:
				rotation += sign(angle) * delta * 0.7
	translate(Vector2(cos(rotation), sin(rotation)).normalized() * velocidade * delta)

func _on_area_dano_destruido():
	destruir()

func destruir():
	$area_dano.queue_free()
	$misseis.hide()
	$coll.queue_free()
	set_process(false)
	$fumaca.emitting = false
	$fumaca2.emitting = false
	$fogo.emitting = false
	$fogo2.emitting = false
	$som_explosao.play()
	$anim.play("explosao")
	yield(get_tree().create_timer(2),"timeout")
	queue_free()


func _on_missel_teleguiado_area_entered(area):
	if area.has_method("acerto") and area.name != "area_dano_de_si":
		print(area.name)
		area.acerto(30, self)
		queue_free()
