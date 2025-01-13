
class_name ScenePartyManager
extends PartyManager

@export var parties: Dictionary = {}:
	set = set_parties,
	get = get_parties

var party_counter: int = 0:
	set = set_party_counter,
	get = get_party_counter

#region Setters & Getters

func set_party_counter(new_value: int) -> void:
	party_counter = new_value

func get_party_counter() -> int:
	return party_counter

func set_parties(new_parties: Dictionary) -> void:
	parties = new_parties

func get_parties() -> Dictionary:
	return parties

#endregion

func initialize_party(id: StringName) -> void:
	var party: Party = get_party(id)
	
	if party == null:
		return
	
	party.id = id
	
	party.emptied.connect(remove_party.bind(id))
	
	for path: NodePath in party.initial_member_paths:
		var node: Node = get_tree().current_scene.get_node(path)
		
		if node is PartyMembership:
			party.add_follower(node)

func initialize_parties() -> void:
	for id: StringName in parties.keys():
		initialize_party(id)

func create_party(
	members: Array[PartyMembership],
	max_size: int = MAX_PARTY_SIZE
) -> StringName:
	if members.is_empty():
		return &""
	if max_size < 1:
		return &""
	
	var party_id: StringName = str(party_counter)
	
	var party = Party.new()
	party.id = party_id
	
	var added_member: bool = false
	
	for member: PartyMembership in members:
		added_member = added_member or party.add_follower(member)
	
	if not added_member:
		return &""
	
	parties[party_id] = party
	
	party.emptied.connect(remove_party.bind(party_id))
	
	party_counter += 1
	
	return party_id

func get_party(id: StringName) -> Party:
	return parties.get(id)

func get_party_members(id: StringName) -> Array[PartyMembership]:
	var party: Party = get_party(id)
	
	if party == null:
		return []
	
	return party.get_members()

func remove_party(id: StringName) -> bool:
	var party: Party = get_party(id)
	
	if party == null:
		return false
	
	var party_members: Array[PartyMembership] = party.get_members()
	
	while party_members.size() > 0:
		party.remove_follower()
	
	return parties.erase(id)

func _enter_tree() -> void:
	GlobalPartyManager.scene_party_manager = self
	
	get_tree().current_scene.ready.connect(_on_scene_ready)

func _on_scene_ready() -> void:
	initialize_parties()

func _exit_tree() -> void:
	GlobalPartyManager.scene_party_manager = null
