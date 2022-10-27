local item_entity_def = minetest.registered_entities["__builtin:item"]

local function destroy(self)
    self.itemstring = ""
    self.object:remove()
end

local old_on_punch = item_entity_def.on_punch

function item_entity_def.on_punch(self, hitter)
    if not minetest.is_player(hitter) then
        return
    end

    local wield_list = hitter:get_wield_list()

    if wield_list ~= "main" then
        -- no chance of putting it into the hand anyway, just do the old thing
        old_on_punch(self, hitter)
        return
    end

    if not self.itemstring or self.itemstring == "" then
        destroy(self)
        return
    end

    local left = ItemStack(self.itemstring)
    local itemdef = minetest.registered_items[left:get_name()]

    if not itemdef then
        -- unknown item, should (almost) never happen
        destroy(self)
        return
    end

    local inv = hitter:get_inventory()
    if not inv then
        return
    end

    local wield_index = hitter:get_wield_index()

    if itemdef.on_use then
        -- to prevent accidental use, preferentially try to place the item *not* in the player's hand
        local wield_item = hitter:get_wielded_item()

        if wield_item:get_name() ~= "" then
            -- if the player is already holding something, do the old thing.
            old_on_punch(self, hitter)
            return
        end

        local inv_size = inv:get_size("main")

        -- first, try to add to existing stacks
        for i = 1, inv_size do
            local contents = inv:get_stack("main", i)
            if contents:get_name() == left:get_name() then
                left = contents:add_item(left)
                inv:set_stack("main", i, contents)
                if left:is_empty() then
                    destroy(self)
                    return
                end
            end
        end

        -- try to add to non-hand indexes
        for i = 1, inv_size do
            if i ~= wield_index then
                local contents = inv:get_stack("main", i)
                left = contents:add_item(left)
                inv:set_stack("main", i, contents)
                if left:is_empty() then
                    destroy(self)
                    return
                end
            end
        end

        -- as a last resort, try to add to the hand
        local contents = inv:get_stack("main", wield_index)
        left = contents:add_item(left)
        inv:set_stack("main", wield_index, contents)

        if left:is_empty() then
            destroy(self)
        else
            self:set_item(left)
        end

    else
        -- preferentially try to put the item into the hand
        local contents = inv:get_stack("main", wield_index)
        left = contents:add_item(left)
        inv:set_stack("main", wield_index, contents)

        if left:is_empty() then
            destroy(self)

        else
            -- hand is full, do the old thing
            self:set_item(left)
            old_on_punch(self, hitter)
        end
    end
end
