extends XROrigin3D
class_name Player

signal recenter()

var simulation: bool = false
var right_controller_move_buttom_held: bool = false
var last_pos_right_controller: Vector3 = Vector3.ZERO

@onready var xr_camera_3d: XRCamera3D = $XRCamera3D
@onready var simulator_component: SimulatorComponent = $SimulatorComponent
@onready var left_controller: XRControllerComponent = $LeftController
@onready var right_controller: XRControllerComponent = $RightController
@onready var function_pointer: XRToolsFunctionPointer = $RightController/FunctionPointer
@onready var player_body: XRToolsPlayerBody = $PlayerBody

func _ready() -> void:
    Events.game_started.connect(_on_events_game_started)

func _physics_process(_delta: float) -> void:
    last_pos_right_controller = right_controller.global_position
    reposition_player()

func reposition_player() -> void:
    if not right_controller_move_buttom_held:
        return

    var right_next_pos = right_controller.global_position
    var change = right_next_pos - last_pos_right_controller
    position += change

func enable_player_body():
    if simulation:
        return  # Player body must stay disabled during simulator
    player_body.enabled = true

func disable_player_body():
    player_body.enabled = false

func activate_simulator():
    simulation = true
    simulator_component.enabled = true
    player_body.enabled = false

func get_xr_camera_3d() -> XRCamera3D:
    return xr_camera_3d

func get_headset_global_position() -> Vector3:
    return xr_camera_3d.global_position

func recenter_player():
    # Adjust the origin to rotate it relative to the current camera rotation
    # Effectively forcing the camera to be facing "forward" (wherever the
    # origin was facing) - Mostly this is only useful after setting the
    # global_transform of the player.
    var difference = global_rotation.y - xr_camera_3d.global_rotation.y
    rotate(Vector3.UP, difference)

func _on_events_game_started() -> void:
    function_pointer.enabled = false
    function_pointer.hide()

func _on_left_controller_recenter() -> void:
    recenter.emit()
    recenter_player()

func _on_right_controller_recenter() -> void:
    recenter.emit()
    recenter_player()

func put_on_mask(hand_scene_name: String):
    print("Put on mask: ", hand_scene_name)
    var hand_scene: PackedScene = Utils.get_hand(hand_scene_name)
    var player_hand: PlayerHand = hand_scene.instantiate() as PlayerHand
    left_controller.add_child(player_hand)
    var lhand = left_controller.find_child("LeftHand")
    lhand.hide()

func _on_mask_detection_area_body_entered(body: Node3D) -> void:
    if body is Mask:
        var mask = body as Mask
        mask.hide()
        mask.freeze = true
        mask.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
        put_on_mask(mask.hand_scene_name)

func _on_function_pickup_left_controller_has_picked_up(_what: Variant) -> void:
    left_controller.rumble_for(0.2)

func _on_function_pickup_right_controller_has_picked_up(_what: Variant) -> void:
    right_controller.rumble_for(0.2)

func _on_right_controller_button_pressed(button_name: String) -> void:
    if button_name == "ax_button":
        right_controller_move_buttom_held = true

func _on_right_controller_button_released(button_name: String) -> void:
    if button_name == "ax_button":
        right_controller_move_buttom_held = false
