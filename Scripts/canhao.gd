extends Area2D


const pre_disparo = preload("res://scenes/disparo_torre.tscn")
const vel_rot = PI * .2

func escolher_alvo():
	if $mira.is_colliding():
		return $mira.get_collider()
	return null

func _ready():
	get_parent().connect("jogador_entrou", self, "o_jogador_entrou")
	get_parent().connect("jogador_saiu", self, "o_jogador_saiu")
	
	$mira.cast_to = Vector2(get_parent().sensor_inicial, 0)
	
func o_jogador_entrou(n):
	if n:
		$tempo_disparo.start()
	$mira.enabled = true

func o_jogador_saiu(n):
	if !n:
		$mira.enabled = false
		$tempo_disparo.stop()
		$fumaca.emitting = false

func _on_tempo_disparo_timeout():
	if $mira.is_colliding():
		disparar()
	else:
		$fumaca.emitting = false

func disparar():
	$fumaca.emitting = true
	$som_disparo.play()
	$anim_torreta.play("disparo")
	var disparo = pre_disparo.instance()
	disparo.global_position = global_position
	disparo.dir = Vector2(cos(rotation), sin(rotation))
	disparo.distancia_max = get_parent().sensor_inicial
	get_parent().get_parent().add_child(disparo)

func setlife(val):
	$barra/barra_vida.scale = val
