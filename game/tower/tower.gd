extends CharacterBody3D
class_name Tower

@export var max_travel: float = 1.4
@export var speed: float = 0.003
@export var build_speed_stack: float = 0.001

var game_over: bool = false
var building: bool = false
var direction: Vector3 = Vector3.UP
var start_pos: Vector3
var overlapping_enemies: int = 0 : set=set_overlapping_bodies

func _ready() -> void:
    start_pos = global_transform.origin

func _physics_process(delta):
    if not building or game_over:
        return

    if global_transform.origin.distance_to(start_pos) >= max_travel:
        Events.game_over.emit()
        game_over = true
        return

    var build_speed = speed + (build_speed_stack * overlapping_enemies)
    velocity = (direction * build_speed) * delta
    move_and_collide(velocity, false)

func set_overlapping_bodies(value: int):
    overlapping_enemies = max(value, 0)
    if overlapping_enemies > 0:
        building = true
    else:
        building = false

func _on_build_area_area_entered(area: Area3D) -> void:
    print("Building area entered: ", area)
    overlapping_enemies += 1

func _on_build_area_area_exited(_area: Area3D) -> void:
    overlapping_enemies -= 1
