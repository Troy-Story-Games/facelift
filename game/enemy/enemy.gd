extends CharacterBody3D
class_name Enemy

const PoofParticles = preload("res://game/fx/poof_particles.tscn")

@export var health: float = 100.0
@export var speed: float = 1.0

var direction: Vector3 = Vector3.ZERO
var ragdoll: bool = false
var target_pos: Vector3 = Vector3.ZERO
var target_set: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_target(target_transform: Transform3D):
    target_pos = target_transform.origin
    target_set = true

func _process(_delta):
    if ragdoll or not target_set:
        return
    if not animation_player.is_playing():
        animation_player.play("walk")

func _physics_process(delta):
    if ragdoll or not target_set:
        return  # Don't need to move if we're ragdoll or we don't have a target

    direction = global_transform.origin.direction_to(target_pos).normalized()
    direction.y = 0  # Only need the x,z direction
    velocity = (direction * speed) * delta
    look_at(global_transform.origin - direction, Vector3.UP)
    move_and_collide(velocity, false)
