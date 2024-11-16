extends Control

@onready var file_dialog = $fileDialog
@onready var btn_select_images = $btnFindImages
@onready var btn_start = $btnStart

var selected_images = []

func _ready():
	btn_select_images.pressed.connect(_on_select_images_pressed)
	btn_start.pressed.connect(_on_start_pressed)
	
	file_dialog.files_selected.connect(_on_files_selected)
	file_dialog.filters = ["*.png", "*.jpg"]
	# Define o caminho inicial do FileDialog para a pasta de imagens padrão 
	
	var user_dir = OS.get_environment(OS.get_user_data_dir().get_basename()) + "/Pictures" # Para Windows 
	var dir = DirAccess.open(user_dir) 
	print(user_dir)
	if dir == null or !dir.dir_exists("."): 
		user_dir = OS.get_environment("HOME") + "/Pictures" # Para sistemas Unix/Linux 
		dir = DirAccess.open(user_dir) 
		if dir == null or !dir.dir_exists("."): 
			print("Diretório 'Pictures' não encontrado em nenhum dos caminhos padrão.") 
			
	file_dialog.current_path = user_dir


func _on_select_images_pressed():
	file_dialog.popup_centered()  # Abre o diálogo de seleção de arquivos

func _on_start_pressed():
	selected_images = load_images()
	GameManagement.go_to_gameplay("res://scenes/memory_game.tscn", selected_images)  # Passa as imagens para o jogo

func _on_files_selected(files):
	var dir = DirAccess.open("user://images")
	if not dir:
		DirAccess.make_dir_recursive_absolute("user://images")
	
	selected_images.clear()  # Limpa as seleções anteriores
	for file in files:
		var file_name = file.get_file()
		var source_path = file
		var target_path = "user://images/" + file_name

		var source_file = FileAccess.open(source_path, FileAccess.READ)
		if source_file:
			var target_file = FileAccess.open(target_path, FileAccess.WRITE)
			if target_file:
				var buffer = source_file.get_buffer(source_file.get_length())
				target_file.store_buffer(buffer)
				target_file.close()
				
				# Adiciona o caminho da imagem ao array de imagens selecionadas
				selected_images.append(target_path)
				
			source_file.close()
			
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
