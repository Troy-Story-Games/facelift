extends Node

const HAND_PATH = "res://game/player/hands/"
const ENEMIES_PATH = "res://game/enemy/enemies/"

var player_hands: Dictionary
var enemies: Dictionary

func _ready() -> void:
    player_hands = load_dict_from_path(HAND_PATH)
    enemies = load_dict_from_path(ENEMIES_PATH)

func is_player_wearing_spectral_mask() -> bool:
    var game: Game = get_tree().current_scene as Game
    var player: Player = game.find_child("Player")
    return player.is_wearing_spectral_mask()

func get_enemy(enemy_name: String) -> PackedScene:
    assert(enemy_name in enemies, "Wrong enemy name")
    return enemies[enemy_name]

func get_hand(hand_name: String) -> PackedScene:
    assert(hand_name in player_hands, "Wrong hand name")
    return player_hands[hand_name]

func instance_scene_on_world(packed_scene: PackedScene, position) -> Node:
    var game: Game = get_tree().current_scene as Game
    var world: World = null
    while not world:
        world = game.current_scene as World
        if not world:
            await get_tree().create_timer(0.25).timeout

    var instance : Node3D = packed_scene.instantiate()
    world.add_child(instance)
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
