extends Control

const STARTING_NPCS: Array[String] = [
	"Klein Moretti",
	"Dunn Smith",
	"Leonard Mitchell",
	"Old Neil",
	"Melissa Moretti",
	"Benson Moretti",
	"Audrey Hall",
	"Alger Wilson",
]
const SPEEDS: Array[int] = [1, 2, 5, 10]

var _clock_label := Label.new()
var _pause_button := Button.new()
var _rows_container := VBoxContainer.new()
var _rows: Dictionary[StringName, NpcRow] = {}


func _ready() -> void:
	_build_ui()
	NpcManager.npc_added.connect(_add_row)
	NpcManager.npc_removed.connect(_remove_row)
	NpcManager.npcs_ticked.connect(_on_npcs_ticked)
	for agent in NpcManager.get_agents():
		_add_row(agent)
	for npc_name in STARTING_NPCS:
		NpcManager.spawn(npc_name)
	_clock_label.text = TimeSystem.get_time_string()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	var top_bar := HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 8)
	root.add_child(top_bar)

	_clock_label.add_theme_font_size_override("font_size", 24)
	_clock_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(_clock_label)

	_pause_button.text = "Pause"
	_pause_button.toggle_mode = true
	_pause_button.toggled.connect(_on_pause_toggled)
	top_bar.add_child(_pause_button)

	var step_button := Button.new()
	step_button.text = "Step"
	step_button.tooltip_text = "Advance a single tick"
	step_button.pressed.connect(TimeSystem.advance_tick)
	top_bar.add_child(step_button)

	var speed_group := ButtonGroup.new()
	for speed in SPEEDS:
		var speed_button := Button.new()
		speed_button.text = "%dx" % speed
		speed_button.toggle_mode = true
		speed_button.button_group = speed_group
		speed_button.button_pressed = is_equal_approx(float(speed), TimeSystem.speed)
		speed_button.pressed.connect(TimeSystem.set_speed.bind(float(speed)))
		top_bar.add_child(speed_button)

	root.add_child(HSeparator.new())
	root.add_child(NpcRow.create_header())

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	_rows_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rows_container.add_theme_constant_override("separation", 6)
	scroll.add_child(_rows_container)


func _add_row(agent: NpcAgent) -> void:
	var row := NpcRow.new(agent)
	_rows[agent.id] = row
	_rows_container.add_child(row)


func _remove_row(agent: NpcAgent) -> void:
	var row: NpcRow = _rows.get(agent.id)
	if row:
		_rows.erase(agent.id)
		row.queue_free()


func _on_npcs_ticked(_tick: int) -> void:
	_clock_label.text = TimeSystem.get_time_string()
	for row: NpcRow in _rows.values():
		row.refresh()


func _on_pause_toggled(is_paused: bool) -> void:
	TimeSystem.paused = is_paused
	_pause_button.text = "Resume" if is_paused else "Pause"
