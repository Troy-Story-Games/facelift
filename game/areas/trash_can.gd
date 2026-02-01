extends Node3D
class_name TrashCan

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Enemy:
        gpu_particles_3d.emitting = true
        Events.enemy_recycled.emit()
        body.queue_free()
