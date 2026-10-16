dofile_once("mods/witchmind/files/scripts/utils.lua")

local new_actions = {
	{
		id = "KNOWLEDGE",
		name = "$action_wm_knowledge",
		description = "$actiondesc_wm_knowledge",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/knowledge.png",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "6,10",
		spawn_probability = "0.2,0.7",
		price = 220,
		mana = 0,
		max_uses = 1,
		never_unlimited = true,
		custom_xml_file = "mods/witchmind/files/entities/misc/card_knowledge.xml",
		action = function()
			local caster = GetUpdatedEntityID()
			if reflecting or not EntityHasTag(caster, "player_unit") then return end
			dofile_once("mods/witchmind/files/scripts/knowledge_loot.lua")
			local x, y = EntityGetTransform(caster)
			KnowledgeLoot(x, y)
			local comp_inv = EntityGetFirstComponentIncludingDisabled(caster, "Inventory2Component")
			if comp_inv then
				local wand = ComponentGetValue2(comp_inv, "mActiveItem")
				local c = EntityGetAllChildren(wand) or {}
				if #c > 0 then
					for _,v in ipairs(c) do
						if EntityHasTag(v, "witchmind_knowledge") then
							EntityKill(v)
							break
						end
					end
				end
			end
		end,
	},
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
						if type(data) == "table" then
							data.action(rec)
						end
					end
					how_many = how_many + 1
					data = witchmind[how_many]
				end
			else
				GamePrint("Your mind is empty...")
			end
		end,
	},
	{
		id = "REMEMBER_ONE",
		name = "$action_wm_rem_one",
		description = "$actiondesc_wm_rem_one",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/remember_one.png",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10",
		spawn_probability = "0",
		price = 200,
		mana = 10,
		action = function()
			local data = {}			
			if #deck > 0 then
				data = deck[1]
			else
				data = nil
			end
			if data ~= nil then
				table.insert(witchmind, data)
				table.insert(discarded, data)
				table.remove(deck, 1)
			end
		end,
	},
	{
		id = "FORGET",
		name = "$action_wm_forget",
		description = "$actiondesc_wm_forget",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/forget.png",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10",
		spawn_probability = "0",
		price = 200,
		mana = -30,
		action = function()
			witchmind = {}
		end,
	},
	{
		id = "DAYDREAM",
		name = "$action_wm_daydream",
		description = "$actiondesc_wm_daydream",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/daydream.png",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10",
		spawn_probability = "0",
		price = 110,
		mana = -20,
		action = function()
			c.fire_rate_wait = c.fire_rate_wait - 12
			current_reload_time = current_reload_time - 12
			for i = 1, 2 do
				table.insert(witchmind, "THOUGHT")
			end
		end,
	},
	{
		id = "SHIFT_FOCUS",
		name = "$action_wm_shift_focus",
		description = "$actiondesc_wm_shift_focus",
		sprite = "mods/witchmind/files/ui_gfx/gun_actions/shift_focus.png",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10",
		spawn_probability = "0",
		price = 140,
		mana = 7,
		action = function()
			if #witchmind > 1 then
				local last = witchmind[#witchmind]
				for i = 1, #witchmind - 1 do 
					witchmind[i] = last -- PLEASE WORK I DONT WANT TO DEEP COPY PLEASE PLEASE PLEASE
				end
			end
		end,
	},
}

for i,action in ipairs(new_actions) do
	action.id = "WM_" .. action.id
	table.insert(actions, action)
end