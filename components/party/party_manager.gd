
class_name PartyManager
extends Node

const MAX_PARTY_SIZE: int = 4

func party_exists(_id: StringName) -> bool: return false

func create_party(
	_members: Array[PartyMembership],
	_max_size: int = MAX_PARTY_SIZE
) -> StringName: return &""

func get_party(_id: StringName) -> Party: return null

func get_party_members(_id: StringName) -> Array[PartyMembership]: return []

func remove_party(_id: StringName) -> bool: return false
