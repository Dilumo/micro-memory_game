extends ProgressBar

@onready var progress_bar = $ProgressBar  # Ajuste o caminho conforme o seu scene tree
@onready var timer = $Timer  # Adicione um Timer na cena e conecte seu timeout

var time_left = 10.0  # Tempo total em segundos (pode ajustar)
var max_time = time_left

func _ready():
	progress_bar.value = 100  # Começa cheia
	timer.wait_time = 0.1  # Atualiza a cada 0.1s
	timer.start()

func _process(delta):
	update_progress_bar()

func update_progress_bar():
	# Calcula o valor da barra como porcentagem do tempo restante
	var percentage = (time_left / max_time) * 100
	progress_bar.value = percentage

	# Muda a cor da barra gradualmente para vermelho
	var color = Color(1, 1 - (percentage / 100), 1 - (percentage / 100))
	progress_bar.add_color_override("fg_color", color)  # "fg_color" = cor do preenchimento

	# Verifica se o tempo acabou
	if time_left <= 0:
		game_over()

func _on_Timer_timeout():
	time_left -= 0.1  # Subtrai 0.1 segundo por atualização

func game_over():
	timer.stop()
	print("Game Over!")  # Substituir por lógica de tela de Game Over
	# Aqui você pode adicionar lógica para resetar ou mostrar uma nova tela.
