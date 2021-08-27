extends Area2D

signal dano(dano, node)

func acerto(dano, node):
	emit_signal("dano", dano, node)
