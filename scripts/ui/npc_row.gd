class_name NpcRow
extends HBoxContainer

const SEPARATION := 16
const NAME_WIDTH := 200.0
const STAT_BAR_WIDTH := 120.0
const STAT_VALUE_WIDTH := 36.0
const STAT_INNER_SEPARATION := 4
const FOOD_WIDTH := 48.0
const DEAD_MODULATE := Color(1, 1, 1, 0.4)

var agent: NpcAgent

var _name_label := Label.new()
var _stat_bars: Dictionary[StringName, ProgressBar] = {}
var _stat_labels: Dictionary[StringName, Label] = {}
var _food_label := Label.new()
var _action_label := Label.new()


func _init(p_agent: NpcAgent) -> void:
	agent = p_agent


func _ready() -> void:
	add_theme_constant_override("separation", SEPARATION)

	_name_label.custom_minimum_size.x = NAME_WIDTH
	_name_label.clip_text = true
	add_child(_name_label)

	for stat: NpcStat in agent.stats.values():
		_add_stat_column(stat)

	_food_label.custom_minimum_size.x = FOOD_WIDTH
	_food_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_food_label)

	_action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_action_label)

	refresh()


func refresh() -> void:
	_name_label.text = agent.display_name
	for stat: NpcStat in agent.stats.values():
		_stat_bars[stat.id].value = stat.value
		_stat_labels[stat.id].text = str(roundi(stat.value))
	_food_label.text = str(agent.get_item_count(NpcAgent.FOOD))
	_action_label.text = agent.get_status_text()
	_action_label.modulate = agent.current_action.color if agent.current_action else Color.WHITE
	modulate = Color.WHITE if agent.is_alive else DEAD_MODULATE


func _add_stat_column(stat: NpcStat) -> void:
	var column := HBoxContainer.new()
	column.add_theme_constant_override("separation", STAT_INNER_SEPARATION)
	add_child(column)

	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(STAT_BAR_WIDTH, 18.0)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.max_value = stat.max_value
	bar.show_percentage = false
	var fill := StyleBoxFlat.new()
	fill.bg_color = stat.color
	bar.add_theme_stylebox_override("fill", fill)
	column.add_child(bar)

	var label := Label.new()
	label.custom_minimum_size.x = STAT_VALUE_WIDTH
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	column.add_child(label)

	_stat_bars[stat.id] = bar
	_stat_labels[stat.id] = label


static func create_header(stats: Array[NpcStat]) -> HBoxContainer:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", SEPARATION)
	header.modulate = Color(1, 1, 1, 0.6)
	var columns := [["Name", NAME_WIDTH]]
	for stat in stats:
		columns.append([stat.display_name, STAT_BAR_WIDTH + STAT_INNER_SEPARATION + STAT_VALUE_WIDTH])
	columns.append(["Food", FOOD_WIDTH])
	columns.append(["Action", 0.0])
	for column in columns:
		var label := Label.new()
		label.text = column[0]
		label.custom_minimum_size.x = column[1]
		header.add_child(label)
	return header
