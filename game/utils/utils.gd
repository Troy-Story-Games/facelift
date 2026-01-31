extends Node

const HAND_PATH = "res://game/player/hands/"

var player_hands: Dictionary

func _ready() -> void:
    player_hands = load_dict_from_path(HAND_PATH)
    print(player_hands)

func get_hand(name: String) -> PackedScene:
    assert(name in player_hands, "Wrong name")
    return player_hands[name]

func instance_scene_on_main(packed_scene: PackedScene, position) -> Node:
    var main := get_tree().current_scene
    var instance : Node3D = packed_scene.instantiate()
    main.add_child(instance)
    if position is Transform3D:
        instance.global_transform = position
    elif position is Vector3:
        instance.global_transform.origin = position
    return instance

func load_dict_from_path(dir_path: String, file_exts: Array[String] = [".tscn"]):
    var look_for_exts = []
    var ret := {}
    var dir := DirAccess.open(dir_path)
    if not dir:
        push_error("Could not find dirctory ", dir_path)
        return ret

    for ext in file_exts:
        look_for_exts.append(ext)
        look_for_exts.append(ext + ".import")
        look_for_exts.append(ext + ".remap")

    print_verbose("Loading files from ", dir_path, " with extensions ", file_exts)

    dir.list_dir_begin()
    var check := dir.get_next()
    while check != "":
        print_verbose("Checking ", check)
        for ext in look_for_exts:
            if not check.ends_with(ext):
                continue
            var split := check.split(".", false)
            var fname: String = split[0]
            var fext: String = split[1]
            var full_path := dir_path + fname + "." + fext
            if fname not in ret:
                print_verbose("Adding " + fname + " = " + full_path)
                ret[fname] = load(full_path)
            break
        check = dir.get_next()
    return ret
