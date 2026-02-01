extends CanvasLayer
class_name MainMenu

@onready var check_button: CheckButton = $MainMenu/MenuButtonContainer/VBoxContainer/CheckButton

func _ready() -> void:
    Music.play("main_menu")

func _on_play_button_pressed() -> void:
    Events.game_started.emit(check_button.button_pressed)

func _on_exit_button_pressed() -> void:
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
    get_tree().quit()
