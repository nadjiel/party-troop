
class_name Party
extends Resource

signal member_joined(member: PartyMembership, position: int)

signal member_left(member: PartyMembership, position: int)

signal member_swapped_positions(
	member: PartyMembership, old_position: int, new_position: int
)

signal filled()

signal emptied()

@export var max_size: int = PartyManager.MAX_PARTY_SIZE:
	set = set_max_size,
	get = get_max_size

@export var initial_member_paths: Array[NodePath] = []:
	set = set_initial_member_paths,
	get = get_initial_member_paths

var id: StringName:
	set = set_id,
	get = get_id

var members: Array[PartyMembership] = []:
	set = set_members,
	get = get_members

#region Getters & Setters

func set_max_size(new_size: int) -> void:
	new_size = max(new_size, 1)
	
	max_size = new_size

func get_max_size() -> int:
	return max_size

func set_initial_member_paths(new_paths: Array[NodePath]) -> void:
	var result: Array[NodePath] = []
	
	for path: NodePath in new_paths:
		if path in result:
			continue
		
		result.append(path)
	
	if result.size() > max_size:
		result.resize(max_size)
	
	initial_member_paths = result

func get_initial_member_paths() -> Array[NodePath]:
	return initial_member_paths

func set_id(new_id: StringName) -> void:
	id = new_id

func get_id() -> StringName:
	return id

# WARNING: members can be fred nodes
func set_members(new_members: Array[PartyMembership]) -> void:
	var result: Array[PartyMembership] = []
	
	for member: PartyMembership in new_members:
		if member == null:
			continue
		if member in result:
			continue
		
		result.append(member)
	
	if result.size() > max_size:
		result.resize(max_size)
	
	members = result

func get_members() -> Array[PartyMembership]:
	return members

#endregion

func position_is_valid_to_access(position: int) -> bool:
	var members_amount: int = members.size()
	
	return (
		position >= -members_amount and
		position < members_amount
	)

func position_is_valid_to_insert(position: int) -> bool:
	var members_amount: int = members.size()
	
	return (
		position >= -members_amount - 1 and
		position <= members_amount
	)

func translate_negative_position_to_access(position: int) -> int:
	return members.size() + position

func translate_negative_position_to_insert(position: int) -> int:
	return members.size() + (position + 1)

func is_full() -> bool:
	return members.size() == max_size

func is_empty() -> bool:
	return members.size() == 0

func has_member(member: PartyMembership) -> bool:
	return member in members

func get_member_from_position(position: int) -> PartyMembership:
	if not position_is_valid_to_access(position):
		return null
	
	return members[position]

func get_position_from_member(member: PartyMembership) -> int:
	return members.find(member)

func add_member(member: PartyMembership, position: int, suppress_signals := false) -> bool:
	if member == null:
		return false
	if not position_is_valid_to_insert(position):
		return false
	if is_full():
		return false
	if has_member(member):
		return false
	
	if position < 0:
		position = translate_negative_position_to_insert(position)
	
	members.insert(position, member)
	
	if not suppress_signals:
		member_joined.emit(member, position)
		member.joined_party.emit(id, position)
		
		if is_full():
			filled.emit()
	
	return true

func add_leader(leader: PartyMembership) -> bool:
	return add_member(leader, 0)

func add_follower(follower: PartyMembership) -> bool:
	return add_member(follower, -1)

func remove_member_from_position(position: int, supress_signals := false) -> PartyMembership:
	if not position_is_valid_to_access(position):
		return null
	if is_empty():
		return null
	
	if position < 0:
		position = translate_negative_position_to_access(position)
	
	var member: PartyMembership = members[position]
	
	members.remove_at(position)
	
	if not supress_signals:
		member_left.emit(member, position)
		member.left_party.emit(id, position)
		
		if is_empty():
			emptied.emit()
	
	return member

func remove_member(member: PartyMembership) -> bool:
	var position: int = get_position_from_member(member)
	
	if position == -1:
		return false
	
	remove_member_from_position(position)
	
	return true

func remove_leader() -> PartyMembership:
	return remove_member_from_position(0)

func remove_follower() -> PartyMembership:
	return remove_member_from_position(-1)

func commit_swap(position1: int, position2: int) -> void:
	var member2: PartyMembership = remove_member_from_position(position2, true)
	var member1: PartyMembership = remove_member_from_position(position1, true)
	
	add_member(member2, position1, true)
	add_member(member1, position2, true)
	
	member_swapped_positions.emit(member2, position2, position1)
	member_swapped_positions.emit(member1, position1, position2)
	member2.swapped_positions_in_party.emit(id, position2, position1)
	member1.swapped_positions_in_party.emit(id, position1, position2)

func swap_members_from_positions(position1: int, position2: int) -> bool:
	var member1: PartyMembership = get_member_from_position(position1)
	var member2: PartyMembership = get_member_from_position(position2)
	
	if member1 == null:
		return false
	if member2 == null:
		return false
	if member1 == member2:
		return false
	
	if position1 < position2:
		commit_swap(position1, position2)
	else:
		commit_swap(position2, position1)
	
	return true
