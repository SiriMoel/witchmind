knowledge_loot = {
    {
        id = "begin",
        chance = 2.0,
        spawn_func = function(x, y)
            CreateItemActionEntity("WM_REMEMBER", x - 8, y - 2)
            CreateItemActionEntity("WM_RECALL", x + 8, y - 2)
        end,
    },
    {
        id = "forget",
        chance = 1.5,
        spawn_func = function(x, y)
            CreateItemActionEntity("WM_FORGET", x - 8, y - 2)
            CreateItemActionEntity("WM_REMEMBER_ONE", x + 8, y - 2)
        end,
    },
    {
        id = "thoughts",
        chance = 1.5,
        spawn_func = function(x, y)
            CreateItemActionEntity("WM_DAYDREAM", x - 8, y - 2)
            CreateItemActionEntity("WM_SHIFT_FOCUS", x + 8, y - 2)
        end,
    },
}

function KnowledgeLoot(x, y)
    if not GameHasFlagRun("witchmind_got") then
        GameAddFlagRun("witchmind_got")
        knowledge_loot[1].spawn_func(x, y)
    else
        SetRandomSeed(x, y)
        local chance_total = 0.0
        for i,v in ipairs(knowledge_loot) do
            v.chance_min = chance_total
            v.chance_max = chance_total + v.chance
            chance_total = v.chance_max
        end
        local num = Random(0, math.floor(chance_total)) + 0.1 * Random(0, (chance_total - math.floor(chance_total)) * 10)
        for i,v in ipairs(knowledge_loot) do
            if num >= v.chance_min and num < v.chance_max then
                v.spawn_func(x, y)
                break
            end
        end
    end
end