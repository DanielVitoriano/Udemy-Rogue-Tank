extends Node

var pontuacao = 0

signal pontuacao_alterada

func aumentar_pontos(val):
	pontuacao += val
	emit_signal("pontuacao_alterada")
