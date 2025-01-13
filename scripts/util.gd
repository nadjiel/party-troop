extends Node

static func resize_array(array: Array, size: int, default_value: Variant = null) -> Array:
	array.resize(size)
	array.fill(default_value)
	
	return array

## The [method check_and_disconnect_signal] method tries to
## disconnect a [param callable] from a signal in an
## [param object] if they are connected. [br]
## If they aren't, this method returns [code]false[/code] to indicate
## that nothing was done. If the [param object] is [code]null[/code]
## [code]false[/code] is also returned, and nothing is done. [br]
## If the disconection is successful, [code]true[/code] is returned.
static func check_and_disconnect_signal(
	object: Object,
	signal_name: StringName,
	callable: Callable
) -> bool:
	if object == null:
		return false
	if not object.has_signal(signal_name):
		return false
	if not object.is_connected(signal_name, callable):
		return false
	
	object.disconnect(signal_name, callable)
	
	return true

## The [method check_and_disconnect_signals] method tries to
## disconnect all the callables and signals passed
## in the [param signals] [code]Array[/code].
## The [param signals] parameter must be passed as
## an [code]Array[/code] which elements must be in the following format:
## [code]{ "name": <signal_name>, "callable": <callable_reference> }[/code]
## In the [param object] parameter is [code]null[/code], this method won't
## do nothing.
static func check_and_disconnect_signals(
	object: Object,
	signals: Array[Dictionary]
) -> void:
	if object == null:
		return
	
	for i: int in signals.size():
		check_and_disconnect_signal(
			object,
			signals[i].get("name", &""),
			signals[i].get("callable", func(): pass)
		)

## The [method check_and_connect_signal] method tries to
## connect a [param callable] to a signal in an [param object]. [br]
## If the [param object] is [code]null[/code],
## [code]false[/code] is returned and nothing is done. [br]
## If the connection is successful, [code]true[/code] is returned.
static func check_and_connect_signal(
	object: Object,
	signal_name: StringName,
	callable: Callable,
	flags: int = 0
) -> bool:
	if object == null:
		return false
	if not object.has_signal(signal_name):
		return false
	if object.is_connected(signal_name, callable):
		return false
	
	object.connect(signal_name, callable, flags)
	
	return true

## The [method check_and_connect_signals] method tries to
## connect all the callables and signals passed
## in the [param signals] [code]Array[/code].
## The [param signals] parameter must be passed as
## an [code]Array[/code] which elements must be in the following format:
## [code]{ "name": <signal_name>, "callable": <callable_reference>, "flags": <optional_flags> }[/code]
## If the [param object] parameter is [code]null[/code], this method won't
## do nothing.
static func check_and_connect_signals(
	object: Object,
	signals: Array[Dictionary]
) -> void:
	if object == null:
		return
	
	for i: int in signals.size():
		var callable: Callable = signals[i].get("callable")
		
		if callable == null:
			continue
		
		var flags: int = signals[i].get("flags", 0)
		
		object.connect(
			signals[i].get("name", &""),
			callable,
			flags
		)
