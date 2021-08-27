extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$tempo_destroir.wait_time = rand_range(8, 16)
	$tempo_destroir.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_tempo_destroir_timeout():
	$anim.play("desaparecer")
	yield($anim, "animation_finished")
	queue_free()
