class_name NpcRow
extends HBoxContainer

const NAME_WIDTH := 200.0
const ENERGY_BAR_WIDTH := 220.0
const ENERGY_VALUE_WIDTH := 48.0

var agent: NpcAgent

var _name_label := Label.new()
var _energy_bar := ProgressBar.new()
var _energy_label := Label.new()
var _action_label := Label.new()


func _init(p_agent: NpcAgent) -> void:
	agent = p_agent


func _ready() -> void:
	add_theme_constant_override("separation", 16)

	_name_label.custom_minimum_size.x = NAME_WIDTH
	_name_label.clip_text = true
	add_child(_name_label)

	_energy_bar.custom_minimum_size = Vector2(ENERGY_BAR_WIDTH, 18.0)
	_energy_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_energy_bar.max_value = NpcAgent.MAX_ENERGY
	_energy_bar.show_percentage = false
	add_child(_energy_bar)

	_energy_label.custom_minimum_size.x = ENERGY_VALUE_WIDTH
	_energy_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_energy_label)

	_action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_action_label)

	refresh()


func refresh() -> void:
	_name_label.text = agent.display_name
	_energy_bar.value = agent.energy
	_energy_label.text = str(roundi(agent.energy))
	_action_label.text = agent.get_status_text()
	_action_label.modulate = agent.current_action.color if agent.current_action else Color.WHITE


static func create_header() -> HBoxContainer:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 16)
	header.modulate = Color(1, 1, 1, 0.6)
	var columns := [
		["Name", NAME_WIDTH],
		["Energy", ENERGY_BAR_WIDTH + ENERGY_VALUE_WIDTH + 16.0],
		["Action", 0.0],
	]
	for column in columns:
		var label := Label.new()
		label.text = column[0]
		label.custom_minimum_size.x = column[1]
		header.add_child(label)
	return header
