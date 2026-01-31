extends Node3D
class_name World

var game_started: bool = false : set = set_game_started

@onready var game_floor: MeshInstance3D = $Floor
@onready var table: Table = $Table
@onready var main_menu_3d: XRToolsViewport2DIn3D = $MainMenu3D

func _ready() -> void:
    Events.game_started.connect(_on_events_game_started)
    if get_tree().current_scene.is_simulator:
        game_floor.show()
        table.start_game()
        game_started = true

func _on_events_game_started():
    game_started = true
    table.start_game()

func set_game_started(value: bool) -> void:
    game_started = value
    if game_started:
        main_menu_3d.hide()
