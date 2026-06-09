extends Area2D

# O @export faz as variáveis aparecerem no painel Inspetor
@export var nome_disco: String = "Vinicius de Moraes"
@export var peso: int = 1
@export var valor: int = 50

# Pega a referência do nó Label que você adicionou na cena
@onready var info_label = $Label

# _ready roda assim que o disco aparece na tela (quando você dá Play)
func _ready():
	# Verifica se o Label existe e atualiza o texto com os valores do Inspetor
	if info_label:
		info_label.text = "R$ " + str(valor) + " | " + str(peso) + "kg"

# Esta função permite que o Player saiba exatamente onde este disco está
func get_posicao():
	return global_position

func _on_body_entered(body):
	if body.name == "Player":
		# Cria um dicionário com os dados reais do disco
		var item_coletado = {
			"nome": nome_disco,
			"peso": peso,
			"valor": valor
		}
		
		# Guarda o dicionário na bolsa do jogador
		body.inventario.append(item_coletado)
		print("Coletou: ", nome_disco, " | Tamanho da mochila: ", body.inventario.size())
		
		queue_free()
