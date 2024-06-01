extends CanvasLayer

@export var maze: Node2D

var hud_visible: bool = true

@onready var debugCheck: CheckBox = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/CheckBox
@onready var debugTimeSlider: HSlider = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HSlider
@onready var regenBtn: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Button
@onready var menuToggleBtn: Button = $Panel/Button
@onready var panel: Panel = $Panel

func _ready() -> void:
	if not maze:
		push_warning("Maze value not set on HUD!\nDisabling HUD")
		return
	
	debugCheck.connect("toggled", _on_debugCheck_toggled)
	debugTimeSlider.connect("value_changed", _on_debugTimeSlider_input)
	regenBtn.connect("pressed", _on_regenBtn_pressed)
	menuToggleBtn.connect("pressed", _on_menuToggleBtn_pressed)
	
	debugCheck.button_pressed = maze.debug
	debugTimeSlider.value = maze.debug_time

func _on_debugCheck_toggled(toggled_on: bool) -> void:
	maze.debug = toggled_on

func _on_debugTimeSlider_input(value: float) -> void:
	maze.debug_time = value

func _on_regenBtn_pressed() -> void:
	maze.generate()

func _on_menuToggleBtn_pressed() -> void:
	toggle_visibility()

func toggle_visibility() -> void:
	if hud_visible:
		var tween = get_tree().create_tween()
		menuToggleBtn.text = "<"
		tween.tween_property(panel, "position:x", 640, 0.5).set_trans(Tween.TRANS_SINE)
	else:
		var tween = get_tree().create_tween()
		menuToggleBtn.text = ">"
		tween.tween_property(panel, "position:x", 383, 0.5).set_trans(Tween.TRANS_SINE)
	
	hud_visible = !hud_visible
