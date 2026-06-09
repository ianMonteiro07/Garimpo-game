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

func _input(event):
	# Diagnóstico: fecha painel com ESC
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			var painel_ui = get_tree().current_scene.get_node_or_null("UI/Panel")
			if painel_ui: painel_ui.hide()
			
		# Calcula e desenha rota com ENTER
		if event.keycode == KEY_ENTER:
			calcular_rota_tsp()

func atualizar_linha_rota(lista_discos):
	var linha = get_tree().current_scene.get_node_or_null("RotaVisual")
	if not linha:
		print("AVISO: Nó 'RotaVisual' não encontrado no Main. Adicione um Line2D.")
		return
		
	linha.clear_points()
	linha.add_point(global_position) # Começa no jogador
	
	for disco in lista_discos:
		linha.add_point(disco.get_posicao()) # Vai para cada disco na ordem
		
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
		
	var painel_ui = get_tree().current_scene.get_node("UI/Panel")
	var label_ui = get_tree().current_scene.get_node("UI/Panel/Label")
	
	painel_ui.show()
	label_ui.text = texto_final

func calcular_rota_tsp():
	print("--- Iniciando cálculo TSP ---")
	var todos_nos = get_tree().current_scene.get_children()
	var discos = []
	
	for n in todos_nos:
		if n.has_method("get_posicao"):
			discos.append(n)
			
	if discos.size() == 0:
		print("ERRO: Nenhum disco encontrado.")
		return
	
	var rota_objetos = []
	var visitados = []
	var atual = global_position
	
	while visitados.size() < discos.size():
		var mais_proximo = null
		var menor_distancia = INF
		
		for d in discos:
			if not d in visitados:
				var dist = atual.distance_to(d.get_posicao())
				if dist < menor_distancia:
					menor_distancia = dist
					mais_proximo = d
		
		if mais_proximo:
			visitados.append(mais_proximo)
			rota_objetos.append(mais_proximo)
			atual = mais_proximo.get_posicao()
			
	# Desenha a linha amarela na tela
	atualizar_linha_rota(rota_objetos)
	print("Rota Otimizada calculada e desenhada!")
