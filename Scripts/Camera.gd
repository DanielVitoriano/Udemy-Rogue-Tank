extends Camera2D

var intensidade
var angulo_rotacao = 0

func _ready():
	set_process(false)
	add_to_group("camera")

func _process(delta):
	angulo_rotacao += PI / 3
	offset = Vector2(sin(angulo_rotacao), cos(angulo_rotacao)) * intensidade
	pass

func tremer(intensidade2, duracao):
	set_process(true)
	self.intensidade = intensidade2
	get_tree().create_timer(duracao).connect("timeout", self, "tempo_acabou")
	
func tempo_acabou():
	set_process(false)
