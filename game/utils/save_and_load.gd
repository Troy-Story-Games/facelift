extends Node

const SAVE_FILE_PASS: String = "password...lol"
const SAVE_FILE: String = "user://facelift_save.bin"

var save_data: Dictionary = {
    "high_score": 0
}

func _ready() -> void:
    save_data = {}
    load_game()

func save_game() -> void:
    var file: = FileAccess.open_encrypted_with_pass(SAVE_FILE, FileAccess.WRITE, SAVE_FILE_PASS)
    file.store_line(JSON.stringify(save_data))
    file.close()

func load_game() -> void:
    if not FileAccess.file_exists(SAVE_FILE):
        return
    var file: = FileAccess.open_encrypted_with_pass(SAVE_FILE, FileAccess.READ, SAVE_FILE_PASS)
    if not file:
        push_error("Corrupted save file!")
        return

    if not file.eof_reached():
        var line := file.get_line()
        var dict: Dictionary = {}
        if line:
            var parsed = JSON.parse_string(line)
            if parsed:
                dict = parsed
        file.close()
        save_data = dict
    else:
        push_error("Empty save file!")
        file.close()
