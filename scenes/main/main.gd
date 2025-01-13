extends Node

@onready var party_ui: PartyUI = $World/PartyUI
@onready var character1: Character = $World/Character1
@onready var character2: Character = $World/Character2
@onready var character3: Character = $World/Character3
@onready var character4: Character = $World/Character4

func _ready() -> void:
	character1.party_membership.joined_party.connect(
		_on_character1_created_party,
		CONNECT_ONE_SHOT
	)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		character1.party_membership.leave_party() if character1.party_membership.is_in_party() else character1.party_membership.create_party()
	if Input.is_action_just_pressed("debug2"):
		character2.party_membership.leave_party() if character2.party_membership.is_in_party() else character2.party_membership.create_party()
	if Input.is_action_just_pressed("debug3"):
		character3.party_membership.leave_party() if character3.party_membership.is_in_party() else character3.party_membership.create_party()
	if Input.is_action_just_pressed("debug4"):
		character4.party_membership.leave_party() if character4.party_membership.is_in_party() else character4.party_membership.create_party()

func _on_character1_created_party(id: StringName, position: int) -> void:
	party_ui.party = character1.party_membership.get_party()
	party_ui.set_member_to_slot(character1.party_membership, 0)
