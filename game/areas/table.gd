extends StaticBody3D
class_name Table

@onready var construction_enemy_spawners: Node3D = $ConstructionEnemySpawners
@onready var forklift_spawners: Node3D = $ForkliftSpawners
@onready var spectral_enemy_spawners: Node3D = $SpectralEnemySpawners
@onready var tower: Tower = $Tower
@onready var digging_particles: CPUParticles3D = $DiggingParticles

func start_game():
    for child in construction_enemy_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
    for child in forklift_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
    for child in spectral_enemy_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()

func _process(_delta) -> void:
    if tower.building:
        digging_particles.emitting = true
    else:
        digging_particles.emitting = false
