-- SCP-207, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- Functions
scp_207 = {}
-- Global Variables
SCP_207_CONFIG  = {}
-- Lang
SCP_207_LANG = {}
-- RootFolder path
SCP_207_CONFIG.RootFolder = "scp_207/"

/*
* Allows to load all the language files that the addon can handle.
* @string path Path containing the language files.
* @string default Default language.
* @table handledLanguage Array containing the supported languages.
* @table langData Table containing all translations.
*/
function scp_207.LoadLanguage(path, handledLanguage, langData )
    for key, value in ipairs(handledLanguage) do
        local filename = path .. value .. ".lua"
        include( filename )
        if SERVER then AddCSLuaFile( filename ) end
        assert(langData[value], "Language not found : ".. filename )
    end
end

/*
* Allows you to load all the files in a folder.
* @string path of the folder to load.
* @bool isFile if the path is a file and not a folder.
*/
function scp_207.LoadDirectory(pathFolder, isFile)
    if isFile then
        AddCSLuaFile(pathFolder)
        include(pathFolder)
    else
        local files, directories = file.Find(pathFolder.."*", "LUA")
        for key, value in pairs(files) do
            AddCSLuaFile(pathFolder..value)
            include(pathFolder..value)
        end
        for key, value in pairs(directories) do
            LoadDirectory(pathFolder..value)
        end
    end
end

print("SCP-207 Loading . . .")
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."config/sh_scp207_config.lua", true)
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."config/cl_scp207_config.lua", true)
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."config/sv_scp207_config.lua", true)
print("SCP-207 Loaded!")