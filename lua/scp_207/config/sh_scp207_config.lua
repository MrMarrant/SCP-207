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

SCP_207_CONFIG.PathJobNotAllowed = "data_scp_207/scp_207.json"
SCP_207_CONFIG.TimeDecay = 60 -- Numbers of second between each state.
SCP_207_CONFIG.MaxLoop = 48 -- Max loop of the effect from SCP207, one loop equal to duration of SCP_207_CONFIG.TimeDecay
SCP_207_CONFIG.IncrementStat = 0.1
SCP_207_CONFIG.IncrementStatJump = 0.05
SCP_207_CONFIG.InitialChanceInstantDeath = 4
SCP_207_CONFIG.RadiusCollisionDoor = 10
SCP_207_CONFIG.VelocityMinDestroyDoor = 300
SCP_207_CONFIG.DamageTakeBreakingDoor = 30
SCP_207_CONFIG.LangServer = GetConVar("gmod_language"):GetString()
SCP_207_CONFIG.JobNotAllowed = {}
SCP_207_CONFIG.HandledLanguage = {
    "fr",
    "en",
}
SCP_207_CONFIG.DoorClass = {
    prop_door_rotating = true,
    func_door = true,
    func_door_rotating = true
}
SCP_207_CONFIG.PlayersCanBreakDoors = {} -- List of players that has drink SCP 207

-- Network Value, EDIT ONLY IF NAMES ARE ALREADY TAKEN.
SCP_207_CONFIG.TextToSendToServer = "SCP_207_CONFIG.TextToSendToServer"
SCP_207_CONFIG.StartOverlayEffect = "SCP_207_CONFIG.StartOverlayEffect"
SCP_207_CONFIG.RemoveOverlayEffect = "SCP_207_CONFIG.RemoveOverlayEffect"

-- Get Lang of the server
cvars.AddChangeCallback("gmod_language", function(name, old, new)
    SCP_207_CONFIG.LangServer = new
end)

-- DIRECTORY DATA FOLDER
if not file.Exists("data_scp_207", "DATA") then
    file.CreateDir("data_scp_207")
end

if not file.Exists(SCP_207_CONFIG.PathJobNotAllowed, "DATA") then
    local SERVER_VALUES = {}
    file.Write(SCP_207_CONFIG.PathJobNotAllowed, util.TableToJSON(SERVER_VALUES, true))
end

local data = util.JSONToTable(file.Read(SCP_207_CONFIG.PathJobNotAllowed) or "") or {}
SCP_207_CONFIG.JobNotAllowed = data

scp_207.LoadLanguage(SCP_207_CONFIG.RootFolder.."language/", SCP_207_CONFIG.HandledLanguage, SCP_207_LANG)
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."shared/")
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."server/")
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."client/")