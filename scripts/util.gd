extends Node

static func resize_array(array: Array, size: int, default_value: Variant = null) -> Array:
	array.resize(size)
	array.fill(default_value)
	
	return array
