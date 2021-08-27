extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		c.connect("tree_exited", self, "on_fragment_tree_exited")

func on_fragment_tree_exited():
	
	var corpos = 0
	
	for c in get_children():
		if c is RigidBody2D:
			corpos += 1
	
	if get_child_count() <= 1:
		queue_free()
