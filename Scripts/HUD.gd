extends CanvasLayer

func _ready():
	escrever_pontuacao()
	Controlador.connect("pontuacao_alterada", self, "on_pontuacao_alterada")
	
func on_pontuacao_alterada():
	escrever_pontuacao()
		
func escrever_pontuacao():
	$pontuacao.text = str(Controlador.pontuacao)
