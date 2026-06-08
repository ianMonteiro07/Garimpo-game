extends Area2D

# O @export faz as variáveis aparecerem no painel Inspetor
@export var nome_disco: String = "Vinicius de Moraes"
@export var peso: int = 1
@export var valor: int = 50

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
