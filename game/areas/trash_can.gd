extends Node3D
class_name TrashCan

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Enemy:
        Events.enemy_recycled.emit()
        body.queue_free()
