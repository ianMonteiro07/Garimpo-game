# 💽 Garimpo 

Um mini-jogo 2D educativo desenvolvido na **Godot Engine 4** que explora a aplicação prática de algoritmos clássicos da Ciência da Computação: o **Problema do Caixeiro Viajante (TSP)** e o **Problema da Mochila (Knapsack 0-1)**.

## 📖 Sobre o Projeto

Você está no festival cultural **Novas Raízes** e tem uma missão dada pelo "Mestre dos Discos": garimpar as melhores raridades da MPB (como LPs do Vinicius de Moraes, Elis Regina, Clube da Esquina) espalhadas pelo evento. 

O desafio? O tempo é curto e a mesa do estande tem um limite estrito de peso. O jogador precisa equilibrar a otimização de rotas com a avaliação de custo-benefício dos itens coletados.

## 🎮 Como Jogar

- **Setas ou WASD:** Movimenta o personagem pelo mapa.
- **ENTER:** Inicia a contagem regressiva e desenha a rota otimizada (TSP) na tela.
- **ESC:** Fecha janelas de diálogo.
- **Objetivo:** Colete os discos mais valiosos antes que os 30 segundos acabem. Fique atento ao peso (indicado abaixo de cada disco), pois a capacidade máxima da mesa é de 5kg.
- **Finalização:** Quando o tempo esgotar, os discos restantes sumirão. Vá até o NPC "Mestre dos Discos" para que ele rode o algoritmo da Mochila e avalie a qualidade da sua curadoria.

## ⚙️ Sob o Capô: Os Algoritmos

O grande diferencial deste projeto é a integração de algoritmos de otimização diretamente no *Game Flow*. 

### 1. Otimização de Rota (Caixeiro Viajante - TSP)
Quando o jogador aperta `ENTER`, o jogo calcula a rota mais rápida para passar por todos os discos visíveis no mapa, desenhando uma linha amarela guiadora (`Line2D`).
- **Implementação:** Foi utilizada a **Heurística do Vizinho Mais Próximo (Nearest Neighbor)**. 
- **Como funciona no código:** A partir da posição atual do jogador, o algoritmo itera sobre o array de discos não visitados, calcula a distância euclidiana (`distance_to`) para cada um, e sempre escolhe o nó mais próximo até fechar o ciclo.

### 2. Curadoria e Limite de Peso (Problema da Mochila 0-1)
O jogador age de forma gulosa (coletando tudo o que vê), mas o NPC Mestre dos Discos atua como um filtro rigoroso quando o jogo acaba. A mesa suporta apenas `CAPACIDADE_MAXIMA = 5`.
- **Implementação:** O algoritmo clássico de **Programação Dinâmica**.
- **Como funciona no código:** O sistema constrói uma matriz bidimensional onde as linhas são os discos coletados e as colunas são as capacidades incrementais (de 0 a 5). Ele calcula o valor máximo possível sem estourar o peso (`max(valor_item + matriz[i - 1][w - peso_item], matriz[i - 1][w])`). No final, faz o *backtracking* na matriz para descobrir exatamente quais LPs entraram na seleção final, descartando os "pesos mortos".

## 🛠️ Tecnologias Utilizadas

- **Engine:** Godot Engine 4.x
- **Linguagem:** GDScript
- **Design/Assets:** Vetores SVG dinamicamente redimensionados

## 🚀 Como rodar o projeto localmente

1. Certifique-se de ter a [Godot 4](https://godotengine.org/download) instalada em sua máquina.
2. Clone este repositório:
   ```bash
   git clone [https://github.com/SEU_USUARIO/garimpo-novas-raizes.git](https://github.com/SEU_USUARIO/garimpo-novas-raizes.git)
