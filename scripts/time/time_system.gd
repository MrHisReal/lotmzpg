extends Node
## Drives the simulation clock. Every tick advances in-game time by a fixed number of
## minutes; systems that simulate the world should listen to `ticked` instead of `_process`.

signal ticked(tick: int)
signal hour_changed(day: int, hour: int)
signal day_changed(day: int)

const MINUTES_PER_TICK := 10
const MINUTES_PER_HOUR := 60
const MINUTES_PER_DAY := 24 * MINUTES_PER_HOUR
## Real seconds per tick at 1x speed.
const SECONDS_PER_TICK := 0.5
## Prevents a long frame hitch from triggering hundreds of catch-up ticks.
const MAX_TICKS_PER_FRAME := 20
const START_MINUTE := 8 * MINUTES_PER_HOUR

var tick_count := 0
var total_minutes := START_MINUTE
var speed := 1.0
var paused := false

var _accumulator := 0.0


func _process(delta: float) -> void:
	if paused or speed <= 0.0:
		return
	_accumulator += delta * speed
	var ticks_this_frame := 0
	while _accumulator >= SECONDS_PER_TICK and ticks_this_frame < MAX_TICKS_PER_FRAME:
		_accumulator -= SECONDS_PER_TICK
		advance_tick()
		ticks_this_frame += 1
	if ticks_this_frame == MAX_TICKS_PER_FRAME:
		_accumulator = 0.0


func advance_tick() -> void:
	var previous_hour := get_hour()
	var previous_day := get_day()
	tick_count += 1
	total_minutes += MINUTES_PER_TICK
	if get_day() != previous_day:
		day_changed.emit(get_day())
	if get_hour() != previous_hour:
		hour_changed.emit(get_day(), get_hour())
	ticked.emit(tick_count)


func set_speed(value: float) -> void:
	speed = maxf(value, 0.0)


@warning_ignore("integer_division")
func get_day() -> int:
	return total_minutes / MINUTES_PER_DAY + 1


@warning_ignore("integer_division")
func get_hour() -> int:
	return (total_minutes % MINUTES_PER_DAY) / MINUTES_PER_HOUR


func get_minute() -> int:
	return total_minutes % MINUTES_PER_HOUR


func get_time_string() -> String:
	return "Day %d  %02d:%02d" % [get_day(), get_hour(), get_minute()]
