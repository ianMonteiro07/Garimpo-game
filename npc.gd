extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("O jogador encostou no NPC! Pode falar com ele.")
