extends Node

func instance_scene_on_main(packed_scene: PackedScene, position) -> Node:
    var main := get_tree().current_scene
    var instance : Node3D = packed_scene.instantiate()
    main.add_child(instance)
    if position is Transform3D:
        instance.global_transform = position
    elif position is Vector3:
        instance.global_transform.origin = position
    return instance
