extends Marker3D
class_name EnemySpawner

const EnemyScene = preload("res://game/enemy/enemy.tscn")

@export var rand_min: float = 2.5
@export var rand_max: float = 8.0
@export var target: Marker3D

@onready var timer: Timer = $Timer

func _ready() -> void:
    assert(target, "Target needs to be set")

func start_spawning():
    spawn()

func spawn() -> void:
    var enemy = Utils.instance_scene_on_main(EnemyScene, global_transform) as Enemy
    enemy.set_target(target.global_transform)
    timer.start(randf_range(rand_min, rand_max))

func _on_timer_timeout() -> void:
    spawn()
