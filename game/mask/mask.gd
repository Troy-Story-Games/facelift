@tool
extends XRToolsPickable
class_name Mask

@export var hand_scene_name: String

func _ready() -> void:
    if not Engine.is_editor_hint():
        assert(hand_scene_name, "Hand scene required")
