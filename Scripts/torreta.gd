tool
extends StaticBody2D

var morto = false
export var vida = 50
onready var vida_inicial = vida
onready var controlador = get_node("/root/Controlador")
var primeiro_desenho = true
var bodys = []
export(float, 0, 360) var rotacao_inicial = 0.0 setget set_rotacao
export(float, 100, 1000) var sensor_inicial = 100.0 setget set_sensor

onready var canhao = $canhao_pesado

export(int, "PESADO", "GUIADO") var tipo = 0 setget set_tipo

signal jogador_entrou(n)
signal jogador_saiu(n)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Engine.editor_hint:
		return
	
	if bodys.size():
		var alvo = canhao.escolher_alvo()
		var angle = canhao.get_angle_to(bodys[0].global_position)
		if abs(angle) > .01:
			canhao.rotation += sign(angle) * delta * canhao.vel_rot
		
		if alvo != null  and alvo != bodys[0]:
			var antigo_corpo = bodys[0]
			var novo_corpo = bodys.find($canhao/mira.get_collider())
			bodys[0] = alvo
			bodys[novo_corpo] = antigo_corpo

func _draw():
	if morto:
		return
	
	if Engine.editor_hint:
		
		$canhao_pesado.visible = tipo == 0
		$tele_guiado.visible = tipo == 1
		
	if tipo == 0:
		canhao = $canhao_pesado
	elif tipo == 1:
		canhao = $tele_guiado
			
	if primeiro_desenho:
		
		$canhao_pesado.visible = tipo == 0
		$tele_guiado.visible = tipo == 1
		
		canhao.rotation = deg2rad(rotacao_inicial)
		var novo_shape = CircleShape2D.new()
		novo_shape.radius = sensor_inicial
		$sensor/CollisionShape2D.shape = novo_shape
		if !Engine.editor_hint:
			primeiro_desenho = false
			
			if tipo == 0:
				$tele_guiado.queue_free()
			elif tipo == 1:
				$canhao_pesado.queue_free()
			
	if bodys.size():
		draw_circle(Vector2(), $sensor/CollisionShape2D.shape.radius, Color(1, 0, 0, 0.1))
	draw_circle_arc(Vector2(), $sensor/CollisionShape2D.shape.radius, 0, 360, Color(1, 0, 0, 0.1))

func _on_sensor_body_entered(body):
	bodys.append(body)
	
	emit_signal("jogador_entrou", bodys.size())
	
	update()


func _on_sensor_body_exited(body):
	var index = bodys.find(body)
	if index >= 0:
		bodys.remove(index)
	
	emit_signal("jogador_saiu", bodys.size())
	
	update()

func set_rotacao(val):
	rotacao_inicial = val
	if Engine.editor_hint:
		update()

func set_sensor(val):
	sensor_inicial = val
	if Engine.editor_hint:
		update()

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func _on_area_dano_dano(dano, node):
	vida -= dano
	$sfxs/sfx_hit.play()
	#$canhao/barra/barra_vida.scale = float(vida) / float(vida_inicial)
	canhao.setlife(float(vida / float(vida_inicial)))
	if vida <= 0:
		morto = true
		set_process(false)
		$sensor.disconnect("body_exited", self, "_on_sensor_body_exited")
		canhao.queue_free()
		$sensor.queue_free()
		$area_dano.queue_free()
		$explosao/anim.play("explosao")
		$sfxs/explosao.play()
		#$barra_vida.queue_free()
		get_tree().call_group("camera", "tremer" , 5, 1)
		update()
		controlador.aumentar_pontos(10)
		remove_from_group("entidade_radar")

func set_tipo(val):
	tipo = val
	if Engine.editor_hint:
		update()  
