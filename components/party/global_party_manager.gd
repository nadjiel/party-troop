
extends PartyManager

var scene_party_manager: PartyManager:
	set = set_scene_party_manager,
	get = get_scene_party_manager

#region Setters & Getters

func set_scene_party_manager(new_manager: PartyManager) -> void:
	scene_party_manager = new_manager

func get_scene_party_manager() -> PartyManager:
	return scene_party_manager

#endregion

func create_party(
	members: Array[PartyMembership],
	max_size: int = MAX_PARTY_SIZE
) -> StringName:
	if scene_party_manager == null:
		return &""
	
	return scene_party_manager.create_party(members, max_size)

func get_party(id: StringName) -> Party:
	if scene_party_manager == null:
		return null
	
	return scene_party_manager.get_party(id)

func get_party_members(id: StringName) -> Array[PartyMembership]:
	if scene_party_manager == null:
		return []
	
	return scene_party_manager.get_party_members(id)

func remove_party(id: StringName) -> bool:
	if scene_party_manager == null:
		return false
	
	return scene_party_manager.remove_party(id)
