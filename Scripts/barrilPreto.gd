extends StaticBody2D

const pre_oleo = preload("res://scenes/oleo.tscn")

var ultimo_golpe

func _ready():
	$area_impacto.connect("acertado", self, "on_area_hitted")
	$area_impacto.connect("destruido", self, "on_area_destroid")
	
func on_area_hitted(dano, vida, node):
	ultimo_golpe = node
	if vida > 0:
	
		if dano > 5:
			$impacto_grande.play()
		
		else:
			var som_impacto = "impacto_pequeno" + str(randi() % 5 + 1)
			get_node(som_impacto).play()
	
	else:
		$explosao.play()

func on_area_destroid():
	print("acertou mizeravi")
	var qt_oleo = rand_range(2, 8)
	
	for o in range(qt_oleo):
		var oleo = pre_oleo.instance()
		var angle = randf() * (PI * 2)
		oleo.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * rand_range(30, 60)
		oleo.z_index = z_index - 1
		$"../".call_deferred("add_child", oleo)
	
	$area_impacto.queue_free()
	$anim.play("explosao")
	if ultimo_golpe and "atirador" in ultimo_golpe:
		Controlador.aumentar_pontos(15)
	yield($anim, "animation_finished")
	queue_free()
