extends Control


func _ready():
	$btnRestart.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	GameManagement.go_to_scene("res://scenes/memory_game.tscn")
