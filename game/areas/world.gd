extends Node3D
class_name World

const ROTATE_SPEED: float = 0.5

var game_started: bool = false : set = _set_game_started
var spectral_mask_spawn: Transform3D
var hammer_mask_spawn: Transform3D

@onready var table: Table = $Table
@onready var main_menu_3d: XRToolsViewport2DIn3D = $MainMenu3D
@onready var game_floor: MeshInstance3D = $Floor/Floor
@onready var menu_spectral_mask: Node3D = $MainMenu3D/SpectralMaskTutorial/SpectralMask
@onready var menu_hammer_mask: Node3D = $MainMenu3D/HammerMaskTutorial/hammer_mask
@onready var menu_hammer: Node3D = $MainMenu3D/HammerMaskTutorial/Hammer
@onready var menu_construction_enemy: Node3D = $MainMenu3D/ConstructorTutorial/construction_enemy
@onready var menu_spectral_enemy: Node3D = $MainMenu3D/SpectralTutorial/SpectralEnemy
@onready var menu_forklift_enemy: Node3D = $MainMenu3D/ForkliftTutorial/forklift_enemy
@onready var menu_tower_tutorial: Node3D = $MainMenu3D/TowerTutorial
@onready var spectral_mask: Mask = $SpectralMask
@onready var hammer_mask: Mask = $HammerMask
@onready var game_over_menu_3d: XRToolsViewport2DIn3D = $GameOverMenu3D
@onready var alt_room: Node3D = $AltRoom

func _ready() -> void:
    spectral_mask_spawn = spectral_mask.global_transform
    hammer_mask_spawn = hammer_mask.global_transform
    spectral_mask.hide()
    hammer_mask.hide()
    game_over_menu_3d.hide()
    Events.game_started.connect(_on_events_game_started)
    Events.game_over.connect(_on_events_game_over)
    if get_tree().current_scene.is_simulator:
        game_floor.show()
        game_started = true

func _process(delta: float) -> void:
    if not main_menu_3d.visible:
        return

    menu_forklift_enemy.rotate_y(ROTATE_SPEED * delta)
    menu_spectral_enemy.rotate_y(ROTATE_SPEED * delta)
    menu_construction_enemy.rotate_y(ROTATE_SPEED * delta)
    menu_hammer_mask.rotate_y(ROTATE_SPEED * delta)
    menu_spectral_mask.rotate_y(ROTATE_SPEED * delta)
    menu_hammer.rotate_y(ROTATE_SPEED * delta)
    menu_tower_tutorial.rotate_y(ROTATE_SPEED * delta)

func _on_events_game_started(ar_enabled: bool):
    game_started = true
    if ar_enabled:
        alt_room.hide()

func _set_game_started(value: bool) -> void:
    game_started = value
    if game_started:
        main_menu_3d.hide()
        spectral_mask.show()
        hammer_mask.show()
        table.start_game()
        Music.play("game_music")

func _on_events_game_over():
    game_over_menu_3d.show()
