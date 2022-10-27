local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

assert(
	type(futil.version) == "number" and futil.version >= os.time({year = 2022, month = 10, day = 24}),
	"please update futil"
)

builtin_overrides = {
	author = "flux",
	license = "AGPL_v3",
	version = os.time({year = 2022, month = 9, day = 6}),
	fork = "flux",

	modname = modname,
	modpath = modpath,
	S = S,

	has = {
		canonical_name = minetest.get_modpath("canonical_name"),
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

builtin_overrides.dofile("settings")

if builtin_overrides.settings.pickup_to_wieldslot.enabled then
	builtin_overrides.dofile("pickup_to_wieldslot")
end

if builtin_overrides.settings.sort_privs.enabled then
	builtin_overrides.dofile("sort_privs")
end

if builtin_overrides.settings.sort_status.enabled then
	builtin_overrides.dofile("sort_status")
end

if builtin_overrides.settings.split_long_messages.enabled then
	builtin_overrides.dofile("split_long_messages")
end

if builtin_overrides.has.canonical_name and builtin_overrides.settings.fix_capitalization.enabled then
	builtin_overrides.dofile("fix_capitalization")
end
