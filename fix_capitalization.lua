local get_name = canonical_name.get

local function fix_name(name)
	if type(name) ~= "string" then
		return name
	end

	return get_name(name) or name
end

local function wrap(func, arg_processor)
	return function(...)
		return func(arg_processor(...))
	end
end

local function fix_arg(i)
	return function(...)
		local args = { ... }
		args[i] = fix_name(args[i])
		return unpack(args)
	end
end

minetest.get_player_privs = wrap(minetest.get_player_privs, fix_arg(1))
minetest.check_player_privs = wrap(minetest.check_player_privs, fix_arg(1))
minetest.check_password_entry = wrap(minetest.check_password_entry, fix_arg(1))
minetest.get_password_hash = wrap(minetest.get_password_hash, fix_arg(1))
minetest.get_player_ip = wrap(minetest.get_player_ip, fix_arg(1))
minetest.notify_authentication_modified = wrap(minetest.notify_authentication_modified, fix_arg(1))
minetest.set_player_password = wrap(minetest.set_player_password, fix_arg(1))
minetest.set_player_privs = wrap(minetest.set_player_privs, fix_arg(1))

minetest.chat_send_player = wrap(minetest.chat_send_player, fix_arg(1))
minetest.format_chat_message = wrap(minetest.format_chat_message, fix_arg(1))

minetest.get_player_by_name = wrap(minetest.get_player_by_name, fix_arg(1))
minetest.create_detached_inventory = wrap(minetest.create_detached_inventory, fix_arg(3))
minetest.show_formspec = wrap(minetest.show_formspec, fix_arg(1))
minetest.close_formspec = wrap(minetest.close_formspec, fix_arg(1))

minetest.remove_player = wrap(minetest.remove_player, fix_arg(1))
minetest.remove_player_auth = wrap(minetest.remove_player_auth, fix_arg(1))
minetest.get_ban_description = wrap(minetest.get_ban_description, fix_arg(1))
minetest.ban_player = wrap(minetest.ban_player, fix_arg(1))
minetest.unban_player_or_ip = wrap(minetest.unban_player_or_ip, fix_arg(1))
minetest.kick_player = wrap(minetest.kick_player, fix_arg(1))
minetest.disconnect_player = wrap(minetest.disconnect_player, fix_arg(1))

minetest.player_exists = wrap(minetest.player_exists, fix_arg(1))
minetest.send_join_message = wrap(minetest.send_join_message, fix_arg(1))
minetest.send_leave_message = wrap(minetest.send_leave_message, fix_arg(1))

minetest.record_protection_violation = wrap(minetest.record_protection_violation, fix_arg(2))
minetest.is_creative_enabled = wrap(minetest.is_creative_enabled, fix_arg(1))
minetest.is_area_protected = wrap(minetest.is_area_protected, fix_arg(3))

local function override_chatcommand(command_name, arg_processor)
	local old_func = minetest.registered_chatcommands[command_name].func
	if not old_func then
		error("unknown chat command " .. command_name)
	end
	minetest.override_chatcommand(command_name, {
		func = function(name, param)
			return old_func(name, arg_processor(param))
		end,
	})
end

local function trim_and_fix(name)
	return fix_name(name:trim())
end

local function split_and_fix(i)
	return function(param)
		local args = param:split("%s", false, -1, true)
		args[i] = fix_name(args[i])
		return table.concat(args, " ")
	end
end

override_chatcommand("ban", trim_and_fix)
override_chatcommand("clearinv", trim_and_fix)
override_chatcommand("clearpassword", trim_and_fix)
override_chatcommand("give", split_and_fix(1))
override_chatcommand("grant", split_and_fix(1))
override_chatcommand("kick", split_and_fix(1))
override_chatcommand("kill", split_and_fix(1))
override_chatcommand("last-login", split_and_fix(1))
override_chatcommand("msg", split_and_fix(1))
override_chatcommand("privs", split_and_fix(1))
override_chatcommand("remove_player", split_and_fix(1))
override_chatcommand("revoke", split_and_fix(1))
override_chatcommand("setpassword", split_and_fix(1))
override_chatcommand("unban", split_and_fix(1))
