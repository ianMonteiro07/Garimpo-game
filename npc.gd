extends Area2D

func _on_body_entered(body):
	# 1. Verifica se quem encostou no NPC foi o jogador
	if body.name == "Player":
		
		# 2. A MÁGICA: Verifica em qual "estado" o jogo está
		
		if body.jogo_finalizado == true:
			# Se o tempo já acabou, ele abre a tela final com a nota!
			body.resolver_mochila()
			
		elif body.jogo_rodando == true:
			# Se o tempo está correndo e você bater nele sem querer:
			pass # O comando 'pass' diz ao Godot: "Ignore e não faça NADA"
			
		else:
			# Se o jogo nem começou ainda (antes de apertar Enter)
			pass
