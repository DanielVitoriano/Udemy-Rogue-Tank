extends StaticBody2D

const pre_fragmentos = preload("res://scenes/caixa_fragmentos.tscn")
var ultimo_golpe

func _ready():
	$area_obstaculo.connect("acertado", self, "on_area_hitted")
	$area_obstaculo.connect("destruido", self, "on_area_destroid")
	
func on_area_hitted(dano, vida, node):
	ultimo_golpe = node
	if vida > 0:
			
		if dano > 5:
			$receber_dano.play("impacto")
		else:
			$receber_dano.play("impacto_metralha")
	
	else:
		$destroi.play()

func on_area_destroid():
	var fragmentos = pre_fragmentos.instance()
	fragmentos.global_position = global_position
	fragmentos.scale = scale
	$"../".call_deferred("add_child", fragmentos)
	queue_free()
