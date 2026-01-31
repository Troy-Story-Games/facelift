extends StaticBody3D
class_name Table

@onready var construction_enemy_spawners: Node3D = $ConstructionEnemySpawners
@onready var forklift_spawners: Node3D = $ForkliftSpawners

func start_game():
    for child in construction_enemy_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
    for child in forklift_spawners.get_children():
        if child is EnemySpawner:
            child.start_spawning()
