dofile_once("mods/witchmind/files/scripts/utils.lua")

local nxml = dofile_once("mods/witchmind/lib/nxml.lua")

-- appends
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/witchmind/files/scripts/gun/actions.lua")
ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/witchmind/files/scripts/gun/gun_append.lua")

-- translations
local translations = ModTextFileGetContent("data/translations/common.csv")
if translations ~= nil then
    while translations:find("\r\n\r\n") do
        translations = translations:gsub("\r\n\r\n","\r\n")
    end
    local new_translations = ModTextFileGetContent(table.concat({"mods/witchmind/files/translations.csv"}))
    translations = translations .. new_translations
    ModTextFileSetContent("data/translations/common.csv", translations)
end