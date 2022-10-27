local s = minetest.settings

builtin_overrides.settings = {
	fix_capitalization = {
		enabled = s:get_bool("builtin_overrides.fix_capitalization.enabled", true),
	},
	pickup_to_wieldslot = {
		enabled = s:get_bool("builtin_overrides.settings.pickup_to_wieldslot.enabled", true)
	},
	sort_privs = {
		enabled = s:get_bool("builtin_overrides.sort_privs.enabled", true),
		color_privs = s:get_bool("builtin_overrides.sort_privs.color_privs", false),
	},
	sort_status = {
		enabled = s:get_bool("builtin_overrides.sort_status.enabled", true),
	},
	split_long_messages = {
		enabled = s:get_bool("builtin_overrides.split_long_messages.enabled", true),
	},
}
