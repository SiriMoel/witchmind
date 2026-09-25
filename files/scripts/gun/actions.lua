dofile_once("mods/witchmind/files/scripts/utils.lua")

local new_actions = {
	{
		id = "REMEMBER",
		name = "$action_wm_remember",
		description = "$actiondesc_wm_remember",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/remember.png",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10",
		spawn_probability = "0",
		price = 200,
		mana = 22,
		action = function()
			local data = {}
			local how_many = 1
			if #deck > 0 then
				data = deck[1]
			else
				data = nil
			end
			if data ~= nil then
				witchmind = {}
				while (#deck >= how_many) and ((data.type == ACTION_TYPE_PROJECTILE) or (data.type == ACTION_TYPE_MODIFIER) or (data.type == ACTION_TYPE_STATIC_PROJECTILE) or (data.type == ACTION_TYPE_OTHER)) do
					table.insert(witchmind, data)
					how_many = how_many + 1
					data = deck[how_many]
				end
				for i=1,how_many do
					data = deck[1]
					table.insert(discarded, data)
					table.remove(deck, 1)
				end
			end
		end,
	},
	{
		id = "RECALL",
		name = "$action_wm_recall",
		description = "$actiondesc_wm_recall",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/recall.png",
		spawn_requires_flag = "ff_gurbert_spells_unlocked",
		type = ACTION_TYPE_OTHER,
		recursive = true,
		spawn_level = "10",
		spawn_probability = "0",
		price = 200,
		mana = 70,
		action = function(recursion_level, iteration)
			local data = {}
			local how_many = 1
			if #witchmind > 0 then
				data = witchmind[1]
			else
				data = nil
			end
			if data ~= nil then
				while (#witchmind >= how_many) do
					local rec = check_recursion(data, recursion_level)
					if rec > -1 then
						data.action(rec)
					end
					how_many = how_many + 1
					data = witchmind[how_many]
				end
			else
				GamePrint("Your mind is empty...")
			end

		end,
	},
}

for i,action in ipairs(new_actions) do
	action.id = "WM_" .. action.id
	table.insert(actions, action)
end