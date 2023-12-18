extends Label


func _ready():
	pass 

var cores = [Color(1, 0, 0), Color(1, 0.647, 0), Color(0.5, 0, 0.5)]
var indice_cor_atual = 0 
var tempo_entre_cores = 1.0 
var tempo_passado = 0.0

func _physics_process(delta):
	tempo_passado += delta
	
	if tempo_passado >= tempo_entre_cores:
		_mudar_cor()
		tempo_passado = 0.0

func _mudar_cor():
	self.modulate = cores[indice_cor_atual]
	
	indice_cor_atual += 1
	if indice_cor_atual >= cores.size():
		indice_cor_atual = 0
