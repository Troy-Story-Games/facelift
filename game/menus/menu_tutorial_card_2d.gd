extends CanvasLayer
class_name MenuTutorialCard2D

@onready var label: Label = $Control2/Control/Label

func set_label_text(text: String) -> void:
    label.text = text
