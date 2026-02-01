extends Marker3D
class_name EnemySpawner

const SpawnPoofScene = preload("res://game/fx/enemy_spawn_poof.tscn")

@export var rand_min: float = 2.5
@export var rand_max: float = 8.0
@export var target: Marker3D
@export var spawn_type: String = "construction_enemy"
@export var enabled: bool = true

var enemy_scene: PackedScene

@onready var timer: Timer = $Timer

func _ready() -> void:
    assert(target, "Target needs to be set")
    enemy_scene = Utils.get_enemy(spawn_type)

func start_spawning():
    timer.start(randf_range(rand_min, rand_max))

func spawn() -> void:
    if not enabled:
        return
    var enemy = await Utils.instance_scene_on_world(enemy_scene, global_transform) as Enemy
    var poof = await Utils.instance_scene_on_world(SpawnPoofScene, global_transform) as GPUParticles3D
    poof.global_position.y += 0.025
    poof.finished.connect(poof.queue_free)
    poof.emitting = true
    enemy.enemy_type = spawn_type
    enemy.set_target(target.global_transform)

func _on_timer_timeout() -> void:
    spawn()
    timer.start(randf_range(rand_min, rand_max))
