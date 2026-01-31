extends CanvasLayer
class_name MainMenu

func _on_play_button_pressed() -> void:
    Events.game_started.emit()

func _on_exit_button_pressed() -> void:
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
    get_tree().quit()
