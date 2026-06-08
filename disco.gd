extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		# Adiciona o disco na lista do jogador
		body.inventario.append("Disco do Vinicius de Moraes")
		
		# Mostra no terminal o que tem na bolsa
		print("Inventário atual: ", body.inventario)
		
		# Destrói o nó do disco (faz ele sumir da tela)
		queue_free()
