extends Node

var score = 0
var images = []  # Armazena as imagens selecionadas pelo jogador

func _ready():
	score = 0
	images.clear()  # Garante que a lista de imagens esteja limpa ao iniciar

func get_score():
	return score

func increase_score():
	score += 1

func reset_game():
	score = 0
	images.clear()

func go_to_gameplay(scene_path, selected_images = []):
	# Armazena as imagens se forem passadas
	if selected_images.size() > 0:
		images = selected_images
	get_tree().change_scene_to_file(scene_path)

func go_to_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)
