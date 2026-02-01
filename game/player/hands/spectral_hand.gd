extends PlayerHand
class_name SpectralHand

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Enemy:
        var enemy = body as Enemy
        if not enemy.can_hammer_enemy and not enemy.can_grab_enemy:
            # Must be spectral
            enemy.queue_free()
