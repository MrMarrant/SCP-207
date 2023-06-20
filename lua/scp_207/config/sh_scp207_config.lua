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

SCP_207_CONFIG.TimeDecay = 60 -- Numbers of second between each state.
SCP_207_CONFIG.MaxLoop = 48 -- Max loop of the effect from SCP207, one loop equal to duration of SCP_207_CONFIG.TimeDecay
SCP_207_CONFIG.IncrementStat = 0.1
SCP_207_CONFIG.InitialChanceInstantDeath = 4
SCP_207_CONFIG.RadiusCollisionDoor = 10
SCP_207_CONFIG.VelocityMinDestroyDoor = 300
SCP_207_CONFIG.DamageTakeBreakingDoor = 30
SCP_207_CONFIG.JobNotAllowed = {} -- TODO : Faire un fichier de config avec les jobs qui ne peuvent pas récupérer l'entité.
SCP_207_CONFIG.HandledLanguage = {
    "fr",
}
SCP_207_CONFIG.DoorClass = {
    prop_door_rotating = true,
    func_door = true,
    func_door_rotating = true
}
SCP_207_CONFIG.PlayersCanBreakDoors = {} -- List of players that has drink SCP 207

cvars.AddChangeCallback("gmod_language", function(name, old, new)
    SCP_207_CONFIG.LangServer = new
end)

scp_207.LoadLanguage(SCP_207_CONFIG.RootFolder.."language/", SCP_207_CONFIG.HandledLanguage, SCP_207_LANG)
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."shared/")
scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."server/")
--scp_207.LoadDirectory(SCP_207_CONFIG.RootFolder.."client/")