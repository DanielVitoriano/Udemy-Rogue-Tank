extends RigidBody2D

export var boncing = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	bounce = boncing
	gravity_scale = 0
	linear_damp = 1
	angular_velocity = randf() * 5
	var direcao = randf() * (PI * 2)
	apply_impulse(Vector2(), Vector2(cos(direcao), sin(direcao) * 200))
	$Polygon2D.scale = get_parent().scale
	$Polygon2D2.scale = get_parent().scale
	$Polygon2D.rotation = get_parent().rotation
	$Polygon2D2.rotation = get_parent().rotation
	connect("sleeping_state_changed", self, "on_self_sleeping_state_changed")

func on_self_sleeping_state_changed():
	var t = get_tree().create_timer(randf() * 4 + 2)
	yield(t, "timeout")
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_method(self, "desaparecer", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.start()
	
	yield(tween, "tween_completed")
	
	
	queue_free()

func desaparecer(val):
	$Polygon2D.modulate = val
