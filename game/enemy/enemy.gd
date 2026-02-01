@tool
extends XRToolsPickable
class_name Enemy

const PoofParticles = preload("res://game/fx/poof_particles.tscn")

@export var health: float = 100.0
@export var speed: float = 0.5
@export var arrival_safe_distance: float = 0.1
@export var enemy_scene: PackedScene
@export var can_grab_enemy: bool = true
@export var can_hammer_enemy: bool = true

var direction: Vector3 = Vector3.ZERO
var ragdoll: bool = false : set = _set_ragdoll
var target_pos: Vector3 = Vector3.ZERO
var target_set: bool = false
var velocity: Vector3
var physical_bone_simulator_3d: PhysicalBoneSimulator3D
var animation_player: AnimationPlayer
var enemy_model: Node3D
var enemy_type: String : set = _set_enemy_type

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var enemy: Node3D = $Enemy
@onready var construction_enemy: Node3D = $ConstructionEnemy
@onready var despawn_timer: Timer = $DespawnTimer
@onready var enemy_hitbox: Area3D = $EnemyHitbox
@onready var enemy_hitbox_collision_shape_3d: CollisionShape3D = $EnemyHitbox/CollisionShape3D

func _ready():
    assert(enemy_scene, "Enemy type not set")
    Events.player_put_on_spectral_mask.connect(_on_events_player_put_on_spectral_mask)
    Events.player_took_off_spectral_mask.connect(_on_events_player_took_off_spectral_mask)

    freeze = true
    enemy_model = enemy_scene.instantiate()
    add_child(enemy_model)
    physical_bone_simulator_3d = enemy_model.find_child("PhysicalBoneSimulator3D") as PhysicalBoneSimulator3D
    animation_player = enemy_model.find_child("AnimationPlayer") as AnimationPlayer
    if not can_grab_enemy:
        set_collision_layer_value(5, false)

func _set_enemy_type(value: String) -> void:
    enemy_type = value
    if enemy_type == "spectral_enemy":
        hide()

func _on_events_player_put_on_spectral_mask() -> void:
    if enemy_type == "spectral_enemy":
        show()

func _on_events_player_took_off_spectral_mask() -> void:
    if enemy_type == "spectral_enemy":
        hide()

func set_target(target_transform: Transform3D):
    target_pos = target_transform.origin
    target_set = true

func _process(_delta):
    if ragdoll or not target_set:
        return
    if animation_player and not animation_player.is_playing():
        play_moving_animation()

func _physics_process(delta):
    if ragdoll or not target_set:
        return  # Don't need to move if we're ragdoll or we don't have a target
    if global_transform.origin.distance_to(target_pos) <= arrival_safe_distance:
        play_building_animation()
        if enemy_type == "forklift_enemy":
            face_tower()
        return

    direction = global_transform.origin.direction_to(target_pos).normalized()
    direction.y = 0  # Only need the x,z direction
    velocity = (direction * speed) * delta
    look_at(global_transform.origin - direction, Vector3.UP)
    move_and_collide(velocity, false)

func face_tower():
    var game: Game = get_tree().current_scene as Game
    var world: World = game.current_scene as World
    var tower: Tower = world.find_child("Tower") as Tower
    direction = global_transform.origin.direction_to(tower.global_transform.origin).normalized()
    look_at(tower.global_transform.origin - direction, Vector3.UP)

func try_play_animation(anim_name: String):
    if not animation_player:
        return
    animation_player.play(anim_name)

func play_moving_animation():
    match enemy_type:
        "construction_enemy", "spectral_enemy":
            try_play_animation("ConstructorWalking")
        "forklift_enemy":
            try_play_animation("ForkliftDriving")

func play_building_animation():
    match enemy_type:
        "construction_enemy", "spectral_enemy":
            try_play_animation("ConstructorHammerAttack")
        "forklift_enemy":
            try_play_animation("ForkliftConstructing")

func play_held_animation():
    match enemy_type:
        "construction_enemy", "spectral_enemy":
            try_play_animation("ConstructorInAir")

func play_driving_animation():
    match enemy_type:
        "construction_enemy", "spectral_enemy":
            try_play_animation("ConstructorWalking")

func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
    ragdoll = true
    play_held_animation()

func _on_dropped(_pickable: Variant) -> void:
    if animation_player:
        animation_player.stop()

func _set_ragdoll(value: bool) -> void:
    var orig = ragdoll
    ragdoll = value
    if ragdoll and not orig:
        enemy_hitbox.set_deferred("monitorable", false)
        enemy_hitbox.set_deferred("monitorable", false)
        enemy_hitbox_collision_shape_3d.set_deferred("disabled", true)
        set_collision_layer_value(3, false)
        set_collision_layer_value(5, false)
        set_collision_mask_value(3, false)
        can_grab_enemy = false
        Events.enemy_died.emit()
        despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
    queue_free()
