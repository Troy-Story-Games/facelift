extends CanvasLayer
class_name ScoreBoard

var is_game_over: bool = false
var current_score: int = 0 : set = _set_current_score

@onready var score: Label = $Control2/Control/VBoxContainer/Score
@onready var highscore: Label = $Control2/Control/VBoxContainer/Highscore

func _ready() -> void:
    Events.enemy_died.connect(_on_enemy_died)
    Events.enemy_recycled.connect(_on_enemy_recycled)
    Events.game_over.connect(_on_events_game_over)
    current_score = 0
    highscore.text = str(SaveAndLoad.save_data.get("high_score", 0))

func _on_events_game_over():
    is_game_over = true
    if current_score > SaveAndLoad.save_data.get("high_score", 0):
        SaveAndLoad.save_data["high_score"] = current_score
        SaveAndLoad.save_game()

func _on_enemy_recycled():
    current_score += 50

func _on_enemy_died():
    current_score += 10

func _set_current_score(value: int) -> void:
    if is_game_over:
        return
    current_score = value
    score.text = str(current_score)
    Events.score_changed.emit(current_score)
