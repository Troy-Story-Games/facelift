extends StaticBody3D
class_name Table

var all_spawners: Array[EnemySpawner] = []
var score_thresholds: Array[float] = [0.0, 200.0, 2000.0]
var current_level = 0 : set = _set_current_level

@onready var construction_enemy_spawners: Node3D = $ConstructionEnemySpawners
@onready var forklift_spawners: Node3D = $ForkliftSpawners
@onready var spectral_enemy_spawners: Node3D = $SpectralEnemySpawners
@onready var tower: Tower = $Tower
@onready var digging_particles: GPUParticles3D = $DiggingParticles

func _ready() -> void:
    Events.score_changed.connect(_on_events_score_changed)

func start_game():
    for child in construction_enemy_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
            child.spawn()  # When we start, spawn some construction workers
            all_spawners.append(child)
    for child in forklift_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
            all_spawners.append(child)
    for child in spectral_enemy_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
            all_spawners.append(child)

func _on_events_score_changed(current_score: float) -> void:
    if current_level == len(score_thresholds) - 1:
        return
    if current_score > score_thresholds[current_level + 1]:
        print("Level up!")
        current_level += 1

func _set_current_level(value: int) -> void:
    var prev_level = current_level
    current_level = value
    if prev_level < current_level:
        for spawner in all_spawners:
            print("Reducing enemy spawn time!")
            spawner.rand_min *= 0.5
            spawner.rand_max *= 0.5

func _process(_delta) -> void:
    if tower.building:
        digging_particles.emitting = true
    else:
        digging_particles.emitting = false
