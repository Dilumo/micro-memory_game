extends Control

@onready var audio_player_click = $AudioPlayer_Click
@onready var audio_player_no_match = $AudioPlayer_NoMatch
@onready var audio_player_match = $AudioPlayer_Match

@onready var grid_container = $GridContainer
@onready var level_display = $lblLevel
@onready var score_display = $lblScore

@onready var progress_bar = $progress_timer
@onready var timer = $Timer
@export var base_time: int = 20  # Tempo base para o nível 1
@export var time_decay: float = 0.85  # Fator de redução do tempo (15% a menos por nível)

@onready var banner_start = $rcBannerStartGame
@onready var label_banner = $rcBannerStartGame/lblStartLevel

var level = 1
var score = 0
var interaction_locked = false  # Bloqueio de interação global
var count_return_flip = 0
var flipped_cards = []

var time_left = 10.0  # Tempo total em segundos 
var max_time = time_left

func _ready():
	banner_start.visible = false
	timer.timeout.connect(_on_Timer_timeout)
	start_level(level)
	

func _on_Timer_timeout():
	if time_left > 0:
		time_left -= timer.wait_time  # Decrementa o tempo restante
		if time_left < 0:
			time_left = 0  # Garante que não passe abaixo de 0
	update_progress_bar()  # Atualiza a barra de progresso

func start_level(current_level):
	interaction_locked = true
	for card in grid_container.get_children():
		card.queue_free()
	grid_container.columns = calculate_columns(current_level)
	var images = load_images()
	var num_pairs = current_level + 1
	var cards = generate_card_pairs(images, num_pairs)
	cards.shuffle()

	spawn_cards(cards)
	update_level_display()
	show_level_banner(current_level)
	var level_time = int(base_time * pow(time_decay, current_level - 1))
	start_timer(level_time)

func start_timer(level_time : int):
	time_left = level_time
	max_time = level_time
	progress_bar.max_value = 100
	progress_bar.value = 100
	progress_bar.modulate = Color(0, 1, 0)  # Verde inicial
	

	timer.wait_time = 0.1  # Timer atualiza a cada 0.1s

func _on_card_start_flipped(card):
	if interaction_locked:
		return  # Bloqueia interações durante animação ou se já estiver bloqueado
	flipped_cards.append(card)
	if flipped_cards.size() > 2:
			return
			
	card.flip() # card animation
	audio_player_click.play()
	
	if flipped_cards.size() == 2:
		interaction_locked = true  # Bloqueia interações temporariamente

		if flipped_cards[0].card_image == flipped_cards[1].card_image:
			await get_tree().create_timer(0.5).timeout
			for c in flipped_cards:
				c.match()
			score += 1
			update_score_display()
			check_for_level_completion()
			flipped_cards.clear()
			count_return_flip = 0
			audio_player_match.play()
		else:
			await get_tree().create_timer(1).timeout
			for c in flipped_cards:
				c.flip()
			audio_player_no_match.play()
			flipped_cards.clear()



func _on_card_finish_interaction(card):
	count_return_flip += 1
	if count_return_flip == 2:
		interaction_locked = false  # Libera interação após processamento
		flipped_cards.clear()
		count_return_flip = 0

func all_cards_stopped_animating() -> bool:
	for card in flipped_cards:
		if card.is_animating:
			return false
	return true

func get_flipped_cards() -> Array:
	var flipped = []
	for child in grid_container.get_children():
		if (child.is_flipped or child.is_animating) and not child.is_matched:
			flipped.append(child)
	return flipped
func disable_cards():
	for child in grid_container.get_children():
		if (not child.is_flipped or not child.is_animating):
			child.is_wait_other_interaction = true


func spawn_cards(cards):
	for card_data in cards:
		var card = preload("res://scenes/card.tscn").instantiate()
		card.card_image = card_data["image"]
		card.finish_interactio.connect(_on_card_finish_interaction)
		card.card_start_flipped.connect(_on_card_start_flipped)
		grid_container.add_child(card)

func check_for_level_completion():
	if all_cards_matched():
		show_level_completed_message()

func all_cards_matched() -> bool:
	for child in grid_container.get_children():
		if not child.is_matched:
			return false
	return true

func show_level_banner(level):
	label_banner.text = "Level %d" % level
	label_banner.modulate = Color("f2b441")
	banner_start.visible = true

	var tween = create_tween()
	tween.tween_property(banner_start, "position", Vector2(0, 290), 0.5)

	await get_tree().create_timer(2).timeout
	hide_level_banner()

func hide_level_banner():
	var tween = create_tween()
	tween.tween_property(banner_start, "position", Vector2(banner_start.size.x, 290), 0.5)
	interaction_locked = false
	timer.start()
	interaction_locked = false

func show_level_completed_message():
	timer.stop()
	label_banner.text = "Nível %d Concluído!" % level
	label_banner.modulate = Color.SEA_GREEN
	banner_start.visible = true

	var tween = create_tween()
	tween.tween_property(banner_start, "position", Vector2(0, 290), 0.5)
	await tween.finished

	await get_tree().create_timer(1).timeout
	tween = create_tween()
	tween.tween_property(banner_start, "position", Vector2(banner_start.size.x, 290), 0.5)

	await get_tree().create_timer(1).timeout
	banner_start.visible = false

	level += 1
	score = 0
	start_level(level)

func update_progress_bar():
	# Calcula o valor da barra como porcentagem do tempo restante
	var percentage = (time_left / max_time) * 100
	progress_bar.value = percentage

	# Ajusta a cor da barra de verde (tempo cheio) para vermelho (tempo acabando)
	var green = percentage / 100
	var red = 1 - green  # Quanto menos tempo, mais vermelho
	var color = Color(red, green, 0)
	progress_bar.modulate = color  # Usa modulate em vez de self_modulate

	# Verifica se o tempo acabou
	if time_left <= 0:
		game_over()

func update_score_display():
	score_display.text = "Score: %d" % score

func update_level_display():
	level_display.text = "Level: %d" % level

func calculate_columns(current_level):
	var total_cards = (current_level + 1) * 2
	return min(5, ceil(sqrt(total_cards)))

func generate_card_pairs(images, num_pairs):
	var selected_images = images.slice(0, num_pairs)
	var cards = []
	for image in selected_images:
		cards.append({"image": image})
		cards.append({"image": image})
	return cards
func load_images():
	var dir = DirAccess.open("user://images")
	var images = []
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.get_extension() in ["png", "jpg"]:
				var file_path = "user://images/" + file
				if FileAccess.file_exists(file_path):
					# Carrega a imagem como recurso e converte em textura
					var image = Image.create(256,256, false,Image.FORMAT_ETC2_RGB8)
					var error = image.load(file_path)  # Carrega a imagem no objeto Image
					if error == OK:
						var texture = ImageTexture.create_from_image(image)  # Converte para textura
						images.append(texture)
			file = dir.get_next()
		dir.list_dir_end()

	if images.is_empty():
		images = preload_default_images()  # Carrega texturas padrão caso o diretório esteja vazio
	images.shuffle()
	return images



func preload_default_images():
	return [
		preload("res://resources/default_images/rato.jpg"),
		preload("res://resources/default_images/macaco.jpg"),
		preload("res://resources/default_images/pokemon.jpg")
	]

func game_over():
	timer.stop()
	interaction_locked = true
	GameManagement.go_to_scene("res://scenes/game_over.tscn")
