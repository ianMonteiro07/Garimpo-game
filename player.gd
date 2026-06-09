extends CharacterBody2D

const SPEED = 400.0
const CAPACIDADE_MAXIMA = 5

var inventario = []

# Variáveis de Estado do Jogo (A Mágica do Game Flow)
var jogo_rodando = false
var jogo_finalizado = false

# Referências para os nós
@onready var timer = $Timer
@onready var tempo_label = $CanvasLayer/TempoLabel

func _ready():
	# Conecta o Timer à função de fim de jogo
	if timer:
		timer.timeout.connect(_on_timer_timeout)
		timer.stop() # Garante que o tempo não comece sozinho
		
	if tempo_label:
		tempo_label.text = "Tempo: " + str(int(timer.wait_time)) + "s"

	# --- NOVA PARTE: Exibir as regras logo de cara ---
	var painel_ui = get_tree().current_scene.get_node_or_null("UI/Panel")
	var label_ui = get_tree().current_scene.get_node_or_null("UI/Panel/Label")
	
	if painel_ui and label_ui:
		painel_ui.show()
		label_ui.text = "BEM-VINDO AO GARIMPO NOVAS RAÍZES!\n\n" + \
		"O Mestre dos Discos te deu uma missão...\n" + \
		"--------------------------------------------------\n" + \
		"1. Você tem " + str(int(timer.wait_time)) + " segundos para coletar discos pelo mapa.\n" + \
		"2. A linha amarela é o GPS (TSP) do menor caminho.\n" + \
		"3. CUIDADO: A mesa do estande só suporta " + str(CAPACIDADE_MAXIMA) + " kg!\n" + \
		"4.Escolha os discos mais valiosos. Se o peso estourar,\n ele vai remover um dos discos para balancear.\n" + \
		"5. Quando o tempo acabar, vá até o Mestre.\n\n" + \
		"[ PRESSIONE ENTER PARA INICIAR ]"

func _process(delta):
	# Só atualiza o relógio se o jogo estiver valendo
	if jogo_rodando and timer and not timer.is_stopped():
		tempo_label.text = "Tempo: " + str(int(timer.time_left)) + "s"

func _physics_process(delta):
	# O boneco SÓ se move se o jogo estiver rodando OU se já acabou (para ir até o mestre)
	if jogo_rodando or jogo_finalizado:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
		move_and_slide()

func _input(event):
	if event is InputEventKey and event.pressed:
		# Diagnóstico: fecha painel com ESC
		if event.keycode == KEY_ESCAPE:
			var painel_ui = get_tree().current_scene.get_node_or_null("UI/Panel")
			if painel_ui: painel_ui.hide()
			
		# Aperta ENTER para Iniciar o Jogo!
		if event.keycode == KEY_ENTER:
			if not jogo_rodando and not jogo_finalizado:
				
				# --- NOVA PARTE: Esconde o painel de regras ao iniciar ---
				var painel_ui = get_tree().current_scene.get_node_or_null("UI/Panel")
				if painel_ui:
					painel_ui.hide()
					
				iniciar_jogo()

func iniciar_jogo():
	jogo_rodando = true
	if timer:
		timer.start() # Agora sim, o relógio começa a bater!
	
	# Calcula e desenha a rota amarela
	calcular_rota_tsp()

func atualizar_linha_rota(lista_discos):
	var linha = get_tree().current_scene.get_node_or_null("RotaVisual")
	if not linha:
		return
		
	linha.clear_points()
	linha.add_point(global_position)
	for disco in lista_discos:
		linha.add_point(disco.get_posicao())
		
func resolver_mochila():
	var n = inventario.size()
	if n == 0:
		var painel_vazio = get_tree().current_scene.get_node("UI/Panel")
		var label_vazio = get_tree().current_scene.get_node("UI/Panel/Label")
		if painel_vazio and label_vazio:
			painel_vazio.show()
			label_vazio.text = "A feira fechou e você não pegou nada!\nSua avaliação: R$ 0"
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
	texto_final += "Capacidade da mesa: " + str(CAPACIDADE_MAXIMA) + " kg\n"
	texto_final += "Valor máximo alcançado: R$ " + str(valor_maximo) + "\n\n"
	texto_final += "Discos selecionados da sua coleta:\n"
	for disco in discos_escolhidos:
		texto_final += "- " + disco + "\n"
		
	# --- NOVA PARTE: O Veredito do Mestre ---
	var qtd_discos = discos_escolhidos.size()
	texto_final += "\nVEREDITO:\n"
	
	if valor_maximo >= 500:
		texto_final += "Excepcional! Uma curadoria digna de um verdadeiro colecionador.!"
	elif valor_maximo >= 200:
		texto_final += "Uma boa seleção. Rende um som legal.."
	else:
		if qtd_discos >= 3:
			texto_final += "Você encheu a mesa de peso morto! Lembre-se: no garimpo, quantidade não é qualidade."
		else:
			texto_final += "Muito fraco. Faltou visão de curador para escolher as peças certas..."
	# ----------------------------------------
	
	texto_final += "\n\n(Pressione ESC para fechar)"
		
	var painel_ui = get_tree().current_scene.get_node("UI/Panel")
	var label_ui = get_tree().current_scene.get_node("UI/Panel/Label")
	
	painel_ui.show()
	label_ui.text = texto_final

func calcular_rota_tsp():
	var todos_nos = get_tree().current_scene.get_children()
	var discos = []
	
	for n in todos_nos:
		if n.has_method("get_posicao"):
			discos.append(n)
			
	if discos.size() == 0:
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
			
	atualizar_linha_rota(rota_objetos)

func _on_timer_timeout():
	jogo_rodando = false
	jogo_finalizado = true
	
	if tempo_label:
		tempo_label.text = "Tempo Esgotado! Vá até o Mestre!"
	
	# Limpa os discos restantes do mapa
	var todos_nos = get_tree().current_scene.get_children()
	for n in todos_nos:
		# Se tem a função get_posicao, sabemos que é um disco, então deletamos
		if n.has_method("get_posicao"):
			n.queue_free()
			
	# Limpa a linha amarela
	var linha = get_tree().current_scene.get_node_or_null("RotaVisual")
	if linha:
		linha.clear_points()
