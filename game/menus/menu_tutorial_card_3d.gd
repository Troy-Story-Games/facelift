extends Node3D
class_name MenuTutorialCard3D

@export_multiline var tutorial_text: String

var done: bool = false

@onready var viewport_2_din_3d: XRToolsViewport2DIn3D = $Viewport2Din3D

func _process(_delta) -> void:
    if done:
        return

    var scene = viewport_2_din_3d.get_scene_instance() as MenuTutorialCard2D
    if not scene:
        return
    scene.set_label_text(tutorial_text)
    done = true
