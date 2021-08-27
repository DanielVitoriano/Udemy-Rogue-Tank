tool
extends KinematicBody2D

var grupoTiros = "tiros-" + str(self)

const vel_rotacao = PI / 3

const max_velocidade = 100
var percorrido = 0
var carregado = true
var aceleracao = 0
var pre_tiro = preload("res://scenes/tiro.tscn")
var pre_caminho = preload("res://scenes/caminho.tscn")
var pre_tiroMetralhadora = preload("res://Scripts/tiro_metralha.tscn")
export(int, "bigRed", "blue", "dark", "darkLarge", "green") var tank_sprite = 0 setget set_tankSprite

var sprites = [
	"res://sprites/tankBody_bigRed.png",
	"res://sprites/tankBody_blue.png",
	"res://sprites/tankBody_dark.png",
	"res://sprites/tankBody_darkLarge.png",
	"res://sprites/tankBody_green.png"
]

signal disparo_canhao
signal disparo_metralhadora

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _draw():
	$sprite.texture = load(sprites[tank_sprite])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if( Engine.editor_hint):
		return
	
#	var dir_x = 0
#	var dir_y = 0
#
#	look_at(get_global_mouse_position())
#
#	if(Input.is_action_pressed("ui_right")):
#		dir_x += 1
#	elif(Input.is_action_pressed("ui_left")):
#		dir_x -= 1
#	if(Input.is_action_pressed("ui_up")):
#		dir_y -= 1
#	elif(Input.is_action_pressed("ui_down")):
#		dir_y += 1
#	#tiro
	if(Input.is_action_just_pressed("disparo") and carregado):
		#if(get_tree().get_nodes_in_group(grupoTiros).size() < 3):
		var tiro = pre_tiro.instance()
		tiro.global_position = $canhao/pos_tiro.global_position
		tiro.dir = Vector2(cos($canhao.global_rotation), sin($canhao.global_rotation)).normalized()
		tiro.add_to_group(grupoTiros)
		tiro.distancia_maxima = $canhao/mira.position.x - $canhao/pos_tiro.position.x
		get_parent().add_child(tiro)
		$canhao/anim.play("disparo")
		$canhao/canha_atirando.play("recuo")
		carregado = false
		$canhao/mira.update()
		$recarregar.start()
		emit_signal("disparo_canhao")
		tiro.atirador = self

	if Input.is_action_just_pressed("disparo_metralhadora"):
		tiro_metralhadora()
		$metralhadora/time_metralha.start()
	
	if Input.is_action_just_released("disparo_metralhadora"):
		$metralhadora/time_metralha.stop()
#	move_and_slide(Vector2(dir_x, dir_y) * velocidade)
	
	var rotacao = 0
	var direcao = 0
	var mod_velocidade = 1
	
	if get_tree().get_nodes_in_group(str(self) + "-oleo").size() > 0:
		mod_velocidade = 0.3
	
	if(Input.is_action_pressed("ui_right")):
		rotacao += 1
		
	elif(Input.is_action_pressed("ui_left")):
		rotacao -= 1
	
	if(Input.is_action_pressed("ui_up")):
		direcao += 1
	elif(Input.is_action_pressed("ui_down")):
		direcao -= 1
	
	aceleracao = lerp(aceleracao, max_velocidade  * direcao, 0.03)
	
	rotate(vel_rotacao * rotacao * delta)
	var move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * aceleracao * mod_velocidade)
	
	percorrido += move.length() * delta
	
	if percorrido > $sprite.texture.get_size().y:
		percorrido = 0
		var caminho = pre_caminho.instance()
		caminho.global_position = global_position - Vector2(cos(rotation), sin(rotation)).normalized() * 5
		caminho.global_rotation = global_rotation
		get_parent().add_child(caminho)
		
	
	$canhao.look_at(get_global_mouse_position())
	
	pass
func set_tankSprite(val):
	tank_sprite = val
	if( Engine.editor_hint):
		update()


func _on_recarregar_timeout():
	carregado = true
	$canhao/mira.update()

func tiro_metralhadora():
	var metralha = pre_tiroMetralhadora.instance()
	metralha.global_position = $metralhadora/Position2D.global_position
	metralha.global_rotation = global_rotation
	metralha.direcao = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	get_parent().add_child(metralha)
	emit_signal("disparo_metralhadora")
	metralha.atirador = self

func _on_time_metralha_timeout():
	tiro_metralhadora()


func _on_Area2D_destruido():
	queue_free()
