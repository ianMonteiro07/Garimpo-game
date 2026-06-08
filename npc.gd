extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("O Mestre está avaliando o seu garimpo...")
		# Chama o algoritmo da mochila que está dentro do jogador!
		body.resolver_mochila()
