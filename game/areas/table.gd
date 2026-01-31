extends StaticBody3D
class_name Table

func start_game():
    for child in get_children():
        if child is EnemySpawner:
            child.start_spawning()
