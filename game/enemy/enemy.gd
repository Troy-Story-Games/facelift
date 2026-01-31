@tool
extends XRToolsPickable
class_name Enemy

const PoofParticles = preload("res://game/fx/poof_particles.tscn")

@export var health: float = 100.0
@export var speed: float = 0.5
@export var arrival_safe_distance: float = 0.1
@export var enemy_type: PackedScene
@export var can_grab_enemy: bool = true

var direction: Vector3 = Vector3.ZERO
var ragdoll: bool = false : set = _set_ragdoll
var target_pos: Vector3 = Vector3.ZERO
var target_set: bool = false
var velocity: Vector3
var physical_bone_simulator_3d: PhysicalBoneSimulator3D
var animation_player: AnimationPlayer
var enemy_model

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var enemy: Node3D = $Enemy
@onready var construction_enemy: Node3D = $ConstructionEnemy
@onready var despawn_timer: Timer = $DespawnTimer

func _ready():
    assert(enemy_type, "Enemy type not set")
    freeze = true
    enemy_model = enemy_type.instantiate()
    add_child(enemy_model)
    physical_bone_simulator_3d = enemy_model.find_child("PhysicalBoneSimulator3D") as PhysicalBoneSimulator3D
    animation_player = enemy_model.find_child("AnimationPlayer") as AnimationPlayer
    if not can_grab_enemy:
        set_collision_layer_value(5, false)

func set_target(target_transform: Transform3D):
    target_pos = target_transform.origin
    target_set = true

func _process(_delta):
    if ragdoll or not target_set:
        return
    if animation_player and not animation_player.is_playing():
        try_play_animation("ConstructorWalking")

func try_play_animation(anim_name: String):
    if not animation_player:
        return
    animation_player.play(anim_name)

func _physics_process(delta):
    if ragdoll or not target_set:
        return  # Don't need to move if we're ragdoll or we don't have a target
    if global_transform.origin.distance_to(target_pos) <= arrival_safe_distance:
        try_play_animation("ConstructorHammerAttack")
        return

    direction = global_transform.origin.direction_to(target_pos).normalized()
    direction.y = 0  # Only need the x,z direction
    velocity = (direction * speed) * delta
    look_at(global_transform.origin - direction, Vector3.UP)
    move_and_collide(velocity, false)

func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
    ragdoll = true
    try_play_animation("ConstructorInAir")

func _on_dropped(_pickable: Variant) -> void:
    if animation_player:
        animation_player.stop()
    if physical_bone_simulator_3d:
        physical_bone_simulator_3d.physical_bones_start_simulation()

func _set_ragdoll(value: bool) -> void:
    ragdoll = value
    if ragdoll:
        despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
    queue_free()
