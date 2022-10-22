local max_users = tonumber(minetest.settings:get("max_users")) or 15

local lc_cmp = futil.string.lc_cmp

local function sort_names(names, delim)
	local sorted_names = {}

    for name in names:gmatch("[%w_%-]+") do
        table.insert(sorted_names, name)
    end

    table.sort(sorted_names, lc_cmp)

	return table.concat(sorted_names, delim)
end

local old_get_server_status = minetest.get_server_status

function minetest.get_server_status(player_name, login)
	local status = old_get_server_status(player_name, login)
	local text, names = status:match("^# Server: (.*) clients: (.*)")

	if not (text and names) then
		return status
	end

	return ("# Server: %s clients (%i/%i): %s"):format(
        text,
		#minetest.get_connected_players(),
		max_users,
        sort_names(names, ", ")
    )
end
