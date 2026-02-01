extends PlayerHand
class_name HammerHand

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Enemy:
        var enemy = body as Enemy
        if enemy.can_hammer_enemy:
            enemy.ragdoll = true
            enemy.freeze = false
