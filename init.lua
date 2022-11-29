futil.check_version({ year = 2022, month = 10, day = 24 })

builtin_overrides = fmod.create()

if builtin_overrides.settings.pickup_to_wieldslot_enabled then
	builtin_overrides.dofile("pickup_to_wieldslot")
end

if builtin_overrides.settings.sort_privs_enabled then
	builtin_overrides.dofile("sort_privs")
end

if builtin_overrides.settings.sort_status_enabled then
	builtin_overrides.dofile("sort_status")
end

if builtin_overrides.settings.split_long_messages_enabled then
	builtin_overrides.dofile("split_long_messages")
end

if builtin_overrides.has.canonical_name and builtin_overrides.settings.fix_capitalization_enabled then
	builtin_overrides.dofile("fix_capitalization")
end
