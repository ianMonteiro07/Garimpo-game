extends CharacterBody2D

const SPEED = 400.0
const CAPACIDADE_MAXIMA = 5

var inventario = []

func _physics_process(delta):
	# Movimentação do jogador
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

	# Opção para fechar o painel ao apertar ESC
	if Input.is_action_just_pressed("ui_cancel"):
		var main_node = get_tree().current_scene
		var painel_ui = main_node.get_node_or_null("UI/Panel")
		if painel_ui:
			painel_ui.hide()

func resolver_mochila():
	var n = inventario.size()
	if n == 0:
		print("Sua mochila está vazia!")
		return
		
	var matriz = []
	for i in range(n + 1):
		var linha = []
		linha.resize(CAPACIDADE_MAXIMA + 1)
		linha.fill(0)
		matriz.append(linha)
		
	for i in range(1, n + 1):
		var item = inventario[i - 1]
		var peso_item = item["peso"]
		var valor_item = item["valor"]
		for w in range(1, CAPACIDADE_MAXIMA + 1):
			if peso_item <= w:
				matriz[i][w] = max(valor_item + matriz[i - 1][w - peso_item], matriz[i - 1][w])
			else:
				matriz[i][w] = matriz[i - 1][w]
				
	var valor_maximo = matriz[n][CAPACIDADE_MAXIMA]
	var discos_escolhidos = []
	var peso_restante = CAPACIDADE_MAXIMA
	for i in range(n, 0, -1):
		if matriz[i][peso_restante] != matriz[i - 1][peso_restante]:
			var item_escolhido = inventario[i - 1]
			discos_escolhidos.append(item_escolhido["nome"])
			peso_restante -= item_escolhido["peso"]
			
	var texto_final = "AVALIAÇÃO DO MESTRE DOS DISCOS\n"
	texto_final += "--------------------------------------\n"
	texto_final += "Capacidade da bolsa: " + str(CAPACIDADE_MAXIMA) + " kg\n"
	texto_final += "Valor máximo alcançado: R$ " + str(valor_maximo) + "\n\n"
	texto_final += "Discos selecionados:\n"
	for disco in discos_escolhidos:
		texto_final += "- " + disco + "\n"
	texto_final += "\n(Pressione ESC para fechar)"
		
	var main_node = get_tree().current_scene
	var painel_ui = main_node.get_node("UI/Panel")
	var label_ui = main_node.get_node("UI/Panel/Label")
	
	painel_ui.show()
	label_ui.text = texto_final
