
class_name PartyUI
extends HBoxContainer

@export var party: Party:
	set = set_party,
	get = get_party

var party_connections: Array[Dictionary] = [
	{ "name": &"member_joined", "callable": _on_member_joined_party },
	{ "name": &"member_left", "callable": _on_member_left_party },
	{ "name": &"member_swapped_positions", "callable": _on_member_swapped_positions_in_party }
]

func set_party(new_party: Party) -> void:
	var old_party: Party = party
	
	party = new_party
	
	Util.check_and_disconnect_signals(old_party, party_connections)
	Util.check_and_connect_signals(new_party, party_connections)
	
	reset_member_slots(new_party.max_size)

func get_party() -> Party:
	return party

func add_member_slots(amount: int) -> void:
	for _i: int in amount:
		var new_slot := Label.new()
		
		new_slot.add_theme_font_size_override(&"theme_override_font_sizes/font_size", 8)
		#new_slot.set(&"theme_override_font_sizes/font_size", 8)
		
		add_child(Label.new())

func remove_member_slots() -> void:
	for child: Node in get_children():
		child.queue_free()

func reset_member_slots(amount: int) -> void:
	remove_member_slots()
	add_member_slots(amount)

func get_slot(index: int) -> Label:
	return get_child(index) as Label

func set_member_to_slot(membership: PartyMembership, index: int) -> void:
	var slot: Label = get_slot(index)
	var member: Node = membership.get_member()
	
	slot.text = member.name
	
	if member is Node2D:
		slot.self_modulate = member.self_modulate

func remove_member_from_slot(index: int) -> void:
	var slot: Label = get_slot(index)
	
	slot.text = ""
	slot.self_modulate = Color.WHITE

func _on_member_joined_party(
	member: PartyMembership, new_position: int
) -> void:
	set_member_to_slot(member, new_position)

func _on_member_left_party(
	_member: PartyMembership, old_position: int
) -> void:
	remove_member_from_slot(old_position)

func _on_member_swapped_positions_in_party(
	member: PartyMembership, old_position: int, new_position: int
) -> void:
	set_member_to_slot(member, new_position)
