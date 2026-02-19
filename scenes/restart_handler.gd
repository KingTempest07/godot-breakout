extends CanvasLayer
class_name RestartHandler


var label_text: String


func _ready() -> void:
	$CenterContainer/VBoxContainer/RichTextLabel.text = label_text


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/scene_blocks.tscn")
