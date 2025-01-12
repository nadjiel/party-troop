extends GutTest

var party: Party

func before_each() -> void:
	party = Party.new()

func after_all() -> void:
	queue_free()

#region Initialization

func test_party_starts_with_max_party_size_greater_than_zero() -> void:
	assert_gt(party.max_size, 0, "Max_party_size started as zero or less")

func test_party_starts_with_initial_member_paths_empty() -> void:
	assert_eq(
		party.initial_member_paths.size(),
		0,
		"Initial_member_paths started with values"
	)

func test_party_starts_with_members_empty() -> void:
	assert_eq(
		party.members.size(),
		0,
		"Members started with values"
	)

#endregion

#region Property max_size

func test_max_size_cant_be_zero() -> void:
	party.max_size = 0
	
	assert_gt(party.max_size, 0, "Max_size was set to zero or less")

func test_max_size_cant_be_negative() -> void:
	party.max_size = -1
	
	assert_gt(party.max_size, 0, "Max_size was set to zero or less")

#endregion

#region Property initial_member_paths

func test_initial_member_paths_cant_have_more_entries_than_max_size() -> void:
	party.max_size = 1
	party.initial_member_paths = [
		^"Path1", ^"Path2"
	]
	
	assert_eq(
		party.initial_member_paths,
		[ ^"Path1" ],
		"Initial_member_paths accepted too many entries"
	)

func test_initial_member_paths_cant_have_repeated_entries() -> void:
	party.max_size = 1
	party.initial_member_paths = [
		^"Path1", ^"Path1"
	]
	
	assert_eq(
		party.initial_member_paths,
		[ ^"Path1" ],
		"Initial_member_paths accepted repeated entries"
	)

#endregion

#region Property members

func test_members_cant_have_more_entries_than_max_size() -> void:
	party.max_size = 1
	party.members = [
		autofree(PartyMembership.new()), autofree(PartyMembership.new())
	]
	
	assert_eq(
		party.members.size(),
		party.max_size,
		"Members accepted too many entries"
	)

func test_members_cant_have_repeated_entries() -> void:
	var member: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [
		member, member
	]
	
	assert_eq(
		party.members,
		[ member ],
		"Members accepted repeated entries"
	)

func test_members_cant_have_null_entries() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = null
	
	party.max_size = 2
	party.members = [
		member1, member2
	]
	
	assert_eq(
		party.members,
		[ member1 ],
		"Members accepted null entries"
	)

#endregion

#region Method position_is_valid_to_insert

func test_position_is_valid_to_insert_if_zero() -> void:
	assert_true(
		party.position_is_valid_to_insert(0),
		"Position 0 was considered invalid"
	)

func test_position_is_valid_to_insert_if_minus_one() -> void:
	assert_true(
		party.position_is_valid_to_insert(-1),
		"Position -1 was considered invalid"
	)

func test_position_is_valid_to_insert_if_its_negative_size_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.position_is_valid_to_insert(-3),
		"Position just small enough was considered invalid"
	)

func test_position_is_not_valid_to_insert_if_smaller_than_negative_size_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_false(
		party.position_is_valid_to_insert(-4),
		"Position too small was considered valid"
	)

func test_position_is_valid_to_insert_if_equal_to_size() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	assert_true(
		party.position_is_valid_to_insert(1),
		"Position equal to size was considered invalid"
	)

func test_position_is_not_valid_to_insert_if_greater_than_size() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	assert_false(
		party.position_is_valid_to_insert(2),
		"Position greater than size was considered valid"
	)

#endregion

#region Method position_is_valid_to_access

func test_position_is_valid_to_access_if_zero_with_content() -> void:
	party.members = [ autofree(PartyMembership.new()) ]
	
	assert_true(
		party.position_is_valid_to_access(0),
		"Position 0 was considered invalid"
	)

func test_position_is_not_valid_to_access_if_zero_without_content() -> void:
	assert_false(
		party.position_is_valid_to_access(0),
		"Position 0 was considered valid"
	)

func test_position_is_valid_to_access_if_minus_one_with_content() -> void:
	party.members = [ autofree(PartyMembership.new()) ]
	
	assert_true(
		party.position_is_valid_to_access(-1),
		"Position -1 was considered invalid"
	)

func test_position_is_not_valid_to_access_if_minus_one_without_content() -> void:
	assert_false(
		party.position_is_valid_to_access(-1),
		"Position -1 was considered valid"
	)

func test_position_is_valid_to_access_if_equal_to_negative_size() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.position_is_valid_to_access(-2),
		"Position just small enough was considered invalid"
	)

func test_position_is_not_valid_to_access_if_smaller_than_negative_size() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_false(
		party.position_is_valid_to_access(-3),
		"Position too small was considered valid"
	)

func test_position_is_valid_to_access_if_equal_to_size_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.position_is_valid_to_access(1),
		"Position equal to size minus one was considered invalid"
	)

func test_position_is_not_valid_to_access_if_greater_than_size_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_false(
		party.position_is_valid_to_access(2),
		"Position greater than size minus one was considered valid"
	)

#endregion

#region Method translate_negative_position_to_insert

func test_translate_negative_position_to_insert_returns_size_with_minus_one() -> void:
	assert_eq(
		party.translate_negative_position_to_insert(-1),
		party.members.size(),
		"Position -1 didn't equal size"
	)

func test_translate_negative_position_to_insert_returns_size_minus_passed_position_minus_one() -> void:
	party.members = [
		autofree(PartyMembership.new()),
		autofree(PartyMembership.new())
	]
	
	assert_eq(
		party.translate_negative_position_to_insert(-2),
		1,
		"Position -2 didn't equal size minus 1"
	)

#endregion

#region Method translate_negative_position_to_access

func test_translate_negative_position_to_access_works_with_minus_one() -> void:
	assert_eq(
		party.translate_negative_position_to_access(-1),
		party.members.size() - 1,
		"Position -1 didn't equal size minus 1"
	)

func test_translate_negative_position_to_access_works_with_negative_values() -> void:
	party.members = [
		autofree(PartyMembership.new()),
		autofree(PartyMembership.new())
	]
	
	assert_eq(
		party.translate_negative_position_to_access(-2),
		0,
		"Position -2 didn't equal size - 2"
	)

#endregion

#region Method is_full

func test_is_full_if_reached_max_size() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.is_full(),
		"Full party wasn't considered full"
	)

func test_is_full_is_false_if_not_reached_max_size() -> void:
	party.max_size = 2
	party.members = []
	
	assert_false(
		party.is_full(),
		"Empty party was considered full"
	)

#endregion

#region Method is_empty

func test_is_empty_if_reached_min_size() -> void:
	party.max_size = 2
	party.members = []
	
	assert_true(
		party.is_empty(),
		"Empty party wasn't considered empty"
	)

func test_is_empty_is_false_if_not_reached_min_size() -> void:
	party.max_size = 2
	party.members = [
		autofree(PartyMembership.new())
	]
	
	assert_false(
		party.is_empty(),
		"Non empty party was considered empty"
	)

#endregion

#region Method has_member

func test_has_member_if_added() -> void:
	var member: PartyMembership = autofree(PartyMembership.new())
	
	party.members = [ member ]
	
	assert_true(
		party.has_member(member),
		"Present member was considered absent"
	)

func test_has_member_is_false_if_not_added() -> void:
	party.members = []
	
	assert_false(
		party.has_member(autofree(PartyMembership.new())),
		"Absent member was considered present"
	)

func test_has_member_is_false_if_null() -> void:
	party.members = []
	
	assert_false(
		party.has_member(null),
		"Null member was considered present"
	)

#endregion

#region Method get_member_from_position

func test_get_member_from_position_doesnt_find_if_position_is_invalid() -> void:
	party.members = []
	
	assert_null(
		party.get_member_from_position(0),
		"Got member from invalid position"
	)

func test_get_member_from_position_finds_if_position_is_valid() -> void:
	party.members = [ autofree(PartyMembership.new()) ]
	
	assert_not_null(
		party.get_member_from_position(0),
		"Didn't get member from valid position"
	)

#endregion

#region Method get_position_from_member

func test_get_position_from_member_doesnt_find_if_member_is_absent() -> void:
	party.members = []
	
	assert_eq(
		party.get_position_from_member(null),
		-1,
		"Got position from absent member"
	)

func test_get_position_from_member_finds_if_member_is_present() -> void:
	var member: PartyMembership = autofree(PartyMembership.new())
	
	party.members = [ member ]
	
	assert_eq(
		party.get_position_from_member(member),
		0,
		"Didn't get position from present member"
	)

#endregion

#region Method add_member

func test_add_member_refuses_invalid_position() -> void:
	assert_false(
		party.add_member(autofree(PartyMembership.new()), -2),
		"Added member in invalid position"
	)

func test_add_member_refuses_null_node() -> void:
	assert_false(
		party.add_member(null, 0),
		"Added null member"
	)

func test_add_member_handles_negative_position() -> void:
	assert_true(
		party.add_member(autofree(PartyMembership.new()), -1),
		"Handled negative position"
	)
	assert_gt(
		party.members.size(),
		0,
		"Member wasn't added"
	)

func test_add_member_uses_negative_position_as_expected() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.members = [ member1 ]
	
	assert_true(
		party.add_member(member2, -1),
		"Handled negative position"
	)
	assert_eq(
		party.members,
		[ member1, member2 ],
		"Member wasn't added to right position"
	)

func test_add_member_cancels_if_full() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	assert_false(
		party.add_member(member2, -1),
		"Added member to full party"
	)
	assert_eq(
		party.members,
		[ member1 ],
		"Member was added"
	)

func test_add_member_cancels_if_member_is_repeated() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1 ]
	
	assert_false(
		party.add_member(member1, -1),
		"Added repeated member to party"
	)
	assert_eq(
		party.members,
		[ member1 ],
		"Member was added again"
	)

func test_add_member_emits_member_joined_signal() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = []
	
	watch_signals(party)
	
	party.add_member(member1, -1)
	
	assert_signal_emitted(
		party,
		"member_joined",
		"Member_joined signal wasn't emitted"
	)

func test_add_member_doesnt_emit_member_joined_signal_if_unsuccessful() -> void:
	party.max_size = 1
	party.members = []
	
	watch_signals(party)
	
	party.add_member(null, -1)
	
	assert_signal_not_emitted(
		party,
		"member_joined",
		"Member_joined signal was emitted"
	)

func test_add_member_emits_filled_signal_on_filled() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = []
	
	watch_signals(party)
	
	party.add_member(member1, -1)
	
	assert_signal_emitted(
		party,
		"filled",
		"Filled signal wasn't emitted"
	)

func test_add_member_doesnt_emit_filled_signal_if_not_filled() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = []
	
	watch_signals(party)
	
	party.add_member(member1, -1)
	
	assert_signal_not_emitted(
		party,
		"filled",
		"Filled signal was emitted"
	)

func test_add_member_doesnt_emit_signals_if_told_so() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = []
	
	watch_signals(party)
	
	party.add_member(member1, -1, true)
	
	assert_signal_not_emitted(
		party,
		"member_joined",
		"Member_joined signal was emitted"
	)
	assert_signal_not_emitted(
		party,
		"filled",
		"Filled signal was emitted"
	)

#endregion

#region Method add_leader

func test_add_leader_uses_position_zero() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1 ]
	
	assert_true(
		party.add_leader(member2),
		"Didn't add member"
	)
	assert_eq(
		party.members,
		[ member2, member1 ],
		"Added member in invalid position"
	)

#endregion

#region Method add_follower

func test_add_follower_uses_position_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1 ]
	
	assert_true(
		party.add_follower(member2),
		"Didn't add member"
	)
	assert_eq(
		party.members,
		[ member1, member2 ],
		"Added member in invalid position"
	)

#endregion

#region Method remove_member_from_position

func test_remove_member_from_position_refuses_invalid_position() -> void:
	assert_null(
		party.remove_member_from_position(-2),
		"Removed member from invalid position"
	)

func test_remove_member_from_position_handles_negative_position() -> void:
	party.add_leader(autofree(PartyMembership.new()))
	
	assert_not_null(
		party.remove_member_from_position(-1),
		"Handled negative position"
	)
	assert_eq(
		party.members.size(),
		0,
		"Member wasn't removed"
	)

func test_remove_member_from_position_uses_negative_position_as_expected() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.members = [ member1, member2 ]
	
	assert_not_null(
		party.remove_member_from_position(-2),
		"Handled negative position"
	)
	assert_eq(
		party.members,
		[ member2 ],
		"Member wasn't removed from right position"
	)

func test_remove_member_from_position_cancels_if_empty() -> void:
	party.members = []
	
	assert_null(
		party.remove_member_from_position(-1),
		"Removed member from empty party"
	)

func test_remove_member_from_position_emits_member_left_signal() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	watch_signals(party)
	
	party.remove_member_from_position(-1)
	
	assert_signal_emitted(
		party,
		"member_left",
		"Member_left signal wasn't emitted"
	)

func test_remove_member_from_position_doesnt_emit_member_left_signal_if_unsuccessful() -> void:
	party.max_size = 1
	party.members = []
	
	watch_signals(party)
	
	party.remove_member_from_position(-1)
	
	assert_signal_not_emitted(
		party,
		"member_left",
		"Member_left signal was emitted"
	)

func test_remove_member_from_position_emits_emptied_signal_on_emptied() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	watch_signals(party)
	
	party.remove_member_from_position(-1)
	
	assert_signal_emitted(
		party,
		"emptied",
		"Emptied signal wasn't emitted"
	)

func test_remove_member_from_position_doesnt_emit_emptied_signal_if_not_emptied() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	watch_signals(party)
	
	party.remove_member_from_position(-1)
	
	assert_signal_not_emitted(
		party,
		"emptied",
		"Emptied signal was emitted"
	)

func test_remove_member_from_position_doesnt_emit_signals_if_told_so() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 1
	party.members = [ member1 ]
	
	watch_signals(party)
	
	party.remove_member_from_position(-1, true)
	
	assert_signal_not_emitted(
		party,
		"member_left",
		"Member_left signal was emitted"
	)
	assert_signal_not_emitted(
		party,
		"emptied",
		"Emptied signal was emitted"
	)

#endregion

#region Method remove_leader

func test_remove_leader_uses_position_zero() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_not_null(
		party.remove_leader(),
		"Didn't remove member"
	)
	assert_eq(
		party.members,
		[ member2 ],
		"Removed member in invalid position"
	)

#endregion

#region Method remove_follower

func test_remove_follower_uses_position_minus_one() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_not_null(
		party.remove_follower(),
		"Didn't remove member"
	)
	assert_eq(
		party.members,
		[ member1 ],
		"Removed member in invalid position"
	)

#endregion

#region Method swap_members_from_positions

func test_swap_members_from_positions_doesnt_accept_equal_positions() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_false(
		party.swap_members_from_positions(0, -2),
		"Swapped members"
	)

func test_swap_members_from_positions_accepts_ascendent_positions() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.swap_members_from_positions(0, 1),
		"Swapped members"
	)
	assert_eq(
		party.members,
		[ member2, member1 ],
		"Swap wasn't successful"
	)

func test_swap_members_from_positions_accepts_descendent_positions() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	assert_true(
		party.swap_members_from_positions(1, 0),
		"Swapped members"
	)
	assert_eq(
		party.members,
		[ member2, member1 ],
		"Swap wasn't successful"
	)

func test_swap_members_from_positions_emits_member_swapped_positions_signal() -> void:
	var member1: PartyMembership = autofree(PartyMembership.new())
	var member2: PartyMembership = autofree(PartyMembership.new())
	
	party.max_size = 2
	party.members = [ member1, member2 ]
	
	watch_signals(party)
	
	party.swap_members_from_positions(1, 0)
	
	assert_signal_emitted_with_parameters(
		party,
		"member_swapped_positions",
		[ member2, 1, 0 ],
		0
	)
	assert_signal_emitted_with_parameters(
		party,
		"member_swapped_positions",
		[ member1, 0, 1 ],
		1
	)

#endregion
