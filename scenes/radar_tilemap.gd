extends Node2D

export(NodePath) var tilemap

func _ready():
	if tilemap:
		tilemap = get_node(tilemap)
		if tilemap is TileMap:
			var tamanho_area = (tilemap.cell_size * tilemap.get_used_rect().size)
			get_parent().tamanho_area = tamanho_area
	queue_free()
