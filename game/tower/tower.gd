extends CharacterBody3D
class_name Tower

@export var max_heigh: float = 25.0
@export var speed: float = 0.015

var building: bool = false
var direction: Vector3 = Vector3.UP
var start_pos: Vector3
var overlapping_enemies: int = 0 : set=set_overlapping_bodies

func _ready() -> void:
    start_pos = global_transform.origin

func _physics_process(delta):
    if not building:
        return

    velocity = (direction * speed) * delta
    move_and_collide(velocity, false)

func set_overlapping_bodies(value: int):
    overlapping_enemies = max(value, 0)
    if overlapping_enemies > 0:
        building = true
    else:
        building = false

func _on_build_area_area_entered(area: Area3D) -> void:
    overlapping_enemies += 1

func _on_build_area_area_exited(area: Area3D) -> void:
    overlapping_enemies -= 1
