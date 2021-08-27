extends Area2D

const pre_missel = preload("res://scenes/missel_teleguiado.tscn")
const vel_rot = PI * .1

func escolher_alvo():
	var tank = get_parent().bodys[0]
	var ht = (tank.global_position - global_position).normalized()
	var olhando = Vector2(cos(rotation), sin(rotation))
	
	if ht.dot(olhando) > 0:
		if $time_disparo.is_stopped():
			$time_disparo.start()
	else:
		$time_disparo.stop()

func disparar():
	if get_parent().bodys.size():
		$som_disparo.play()
		$Particles2D.emitting = true
		$anim.play("disparo")
		var missel = pre_missel.instance()
		get_parent().add_child(missel)
		missel.rotation = rotation
		missel.alvo = get_parent().bodys[0]
		missel.global_position = global_position
	else:
		$time_disparo.stop()

func _on_disparo_timeout():
	disparar()

func setlife(val):
	$barra/barra_vida.scale = val
