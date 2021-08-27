extends Area2D

signal acertado(damage, vida, node)
signal destruido()

export var vida = 30

func acerto(dano, node):
	vida -= dano
	emit_signal("acertado", dano, vida, node)
	if vida <= 0:
		emit_signal("destruido")
