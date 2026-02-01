extends PlayerHand
class_name SpectralHand

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Enemy:
        var enemy = body as Enemy
        if not enemy.can_hammer_enemy and not enemy.can_grab_enemy:
            # Must be spectral
            SoundFx.play_3d("brush_ghost", global_position, 1.0, -15.0)
            enemy.queue_free()
