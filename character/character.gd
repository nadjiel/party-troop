
class_name Character
extends Node2D

@export var party_membership: PartyMembership:
	set = set_party_membership,
	get = get_party_membership

func set_party_membership(new_membership: PartyMembership) -> void:
	party_membership = new_membership

func get_party_membership() -> PartyMembership:
	return party_membership
