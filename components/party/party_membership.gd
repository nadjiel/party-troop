
class_name PartyMembership
extends Node

signal joined_party(id: StringName, position: int)

signal left_party(id: StringName, old_position: int)

signal swapped_positions_in_party(
	id: StringName, old_position: int, new_position: int
)

@export var party_id: StringName = &"":
	set = set_party_id,
	get = get_party_id

@export var max_size: int = GlobalPartyManager.MAX_PARTY_SIZE:
	set = set_max_size,
	get = get_max_size

@export var member: Node:
	set = set_member,
	get = get_member

func set_party_id(new_id: StringName) -> void:
	party_id = new_id

func get_party_id() -> StringName:
	return party_id

func set_max_size(new_size: int) -> void:
	max_size = max(new_size, 1)
	
	max_size = new_size

func get_max_size() -> int:
	return max_size

func set_member(new_member: Node) -> void:
	member = new_member

func get_member() -> Node:
	return member

func is_in_party() -> bool:
	return party_id != &""

func create_party() -> bool:
	if is_in_party():
		return false
	
	party_id = GlobalPartyManager.create_party([ self ], max_size)
	
	return true

func get_party() -> Party:
	return GlobalPartyManager.get_party(party_id)

func get_party_members() -> Array[PartyMembership]:
	return GlobalPartyManager.get_party_members(party_id)

func join_party(id: StringName, position: int) -> bool:
	if is_in_party():
		return false
	
	var party: Party = GlobalPartyManager.get_party(id)
	
	if party == null:
		return false
	
	var joined: bool = party.add_member(self, position)
	
	if joined:
		party_id = id
	
	return joined

func lead_new_party(id: StringName) -> bool:
	return join_party(id, 0)

func follow_new_party(id: StringName) -> bool:
	return join_party(id, -1)

func swap_positions_in_party(new_position: int) -> bool:
	if not is_in_party():
		return false
	
	var party: Party = get_party()
	
	var current_position: int = party.get_position_from_member(self)
	
	return party.swap_members_from_positions(current_position, new_position)

func lead_party() -> bool:
	return swap_positions_in_party(0)

func follow_party(id: StringName) -> bool:
	return swap_positions_in_party(-1)

func leave_party() -> bool:
	if not is_in_party():
		return false
	
	var party: Party = get_party()
	
	var left: bool = party.remove_member(self)
	
	if left:
		party_id = &""
	
	return left

func _ready() -> void:
	joined_party.connect(_on_joined_party)
	left_party.connect(_on_joined_party)

func _on_joined_party(id: StringName, _position: int) -> void:
	party_id = id

func _on_left_party(id: StringName, _old_position: int) -> void:
	party_id = &""
