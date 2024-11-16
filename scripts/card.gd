extends Control

@export var card_image: Texture  # Imagem da frente da carta
@export var back_texture: Texture  # Imagem do verso da carta

var is_flipped = false  # Controla se a carta está virada
var is_matched = false  # Se já foi encontrada uma combinação
var is_animating = false # Se a carta esta em animação
var is_wait_other_interaction # Espera por outra interação no jogo

signal card_flipped  # Emite quando uma carta é clicada
signal card_start_flipped
signal finish_interactio

@onready var image_front = $textFront
@onready var image_display = $textFront/textCardImage
@onready var image_back = $textBack

func _ready():
	image_display.texture = card_image
	# Começa mostrando o verso
	show_back()
	gui_input.connect(_on_card_clicked)

func show_back():
	image_front.visible = false
	image_back.visible = true
	finish_interactio.emit(self)

func show_front():
	image_back.visible = false
	image_front.visible = true

func flip():
	is_flipped = !is_flipped
	is_animating = true
	var target_rotation =  0 
	if is_flipped: 
		target_rotation = 180  
	var tween = create_tween() 
	tween.tween_property(self, "rotation_degrees", target_rotation, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	if is_flipped:
		tween.tween_callback(show_front)
	else:
		show_back()
	
	await tween.finished
	is_animating = false	

func _on_card_clicked(event):
	if is_wait_other_interaction: return
	if event is InputEventMouseButton and event.pressed and not is_matched and not is_animating:
		card_start_flipped.emit(self)

func match():
	is_matched = true
	is_animating = true

	var tween = create_tween()

	# Efeito de escala crescente (pop)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	# Roda a carta rapidamente (rotação)
	tween.tween_property(self, "rotation_degrees", 360, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Espera a primeira animação terminar antes de continuar
	await tween.finished

	# Efeito de fade-out com mudança de cor (para um tom de "vitória")
#	tween.tween_property(image_front, "modulate", Color(1, 1, 0.5, 0), 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	#await tween.finished  # Aguarda o fade-out

	is_animating = false
	hide_card()

# Oculta a carta após a animação
func hide_card():
	set_process(false)
	image_front.visible = false
	image_display.visible = false
	image_back.visible = false

	# Emite sinal para informar que a interação com a carta terminou
	finish_interactio.emit(self)
