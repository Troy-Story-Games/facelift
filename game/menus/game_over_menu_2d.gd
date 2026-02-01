extends CanvasLayer
class_name GameOverMenu2D

func _on_play_button_pressed() -> void:
    var game: Game = get_tree().current_scene as Game
    var player: Player = game.player as Player
    player._on_events_game_over()  # Just in case they grabbed another mask
    Events.load_scene.emit("res://game/areas/world.tscn")

func _on_exit_button_pressed() -> void:
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
    get_tree().quit()
