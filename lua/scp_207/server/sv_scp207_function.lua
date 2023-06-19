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

if CLIENT then return end

function scp_207.DropSCP207(ply, ent)
	if (!IsValid(ply) or !IsValid(ent)) then return end
	local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
	local SCP207 = ents.Create( "scp_207" )
	local DistanceToPos = 50
	local PosObject = ply:GetShootPos() + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	SCP207:SetPos( PosObject )
	SCP207:SetAngles( ply:EyeAngles() )
	SCP207:Spawn()
	SCP207:Activate()
	ent:Remove()
end

function scp_207.ConsumeSCP207(ply)
	if (!IsValid(ply)) then return end
	if (ply.HasDrinkSCP207) then return end

	ply.HasDrinkSCP207 = true
	
	local index = 1
	local percent = SCP_207_CONFIG.InitialChanceInstantDeath

	scp_207.GetPreviousStatPlayer(ply)
	timer.Create("Timer.scp207_Effect_"..ply:EntIndex(), SCP_207_CONFIG.TimeDecay, SCP_207_CONFIG.MaxLoop, function()
        if not IsValid( ply ) then return end
		print(index)
		scp_207.IncrementStat(ply)
		scp_207.PrintMessageInfo(ply)
		if(index == 1) then scp_207.EventDoorsDestroyable(ply) end -- TODO : Le faire à partir de 24e minute
		if (index == 10) then scp_207.StartOverlayEffect(ply) end
		if (index >= 24) then
			scp_207.InstanDeath(ply, percent)

			if (!ply:Alive()) then return end

			percent =  math.Clamp( percent +  4, 0, 100 )
		end
        index = index + 1
    end)
end

/*
* Allows you to keep track of a player's previous stats.
* @Player ply The player whose stats are saved before the infection.
*/
function scp_207.GetPreviousStatPlayer(ply)
    if (!IsValid(ply)) then return end

    ply.scp207_PreviousInfoData = {
        WalkSpeed = ply:GetWalkSpeed(),
        RunSpeed = ply:GetRunSpeed(),
        JumpPower = ply:GetJumpPower(),
    }
end

/*
* Increment stat of the player, depend one the var SCP_207_CONFIG.IncrementStat.
* @Player ply The player to increment.
*/
function scp_207.IncrementStat(ply)
	if (!IsValid(ply)) then return end
	if (!ply.scp207_PreviousInfoData) then return end
	local WalkSpeed = ply.scp207_PreviousInfoData.WalkSpeed
	local RunSpeed = ply.scp207_PreviousInfoData.RunSpeed
	local JumpPower = ply.scp207_PreviousInfoData.JumpPower

	ply:SetWalkSpeed( ply:GetWalkSpeed() + WalkSpeed * SCP_207_CONFIG.IncrementStat )
	ply:SetRunSpeed( ply:GetRunSpeed()  + RunSpeed * SCP_207_CONFIG.IncrementStat )
	ply:SetJumpPower( ply:GetJumpPower()  + JumpPower * SCP_207_CONFIG.IncrementStat )
end

/*
* Return true if the entity will instant die.
*/
function scp_207.InstanDeath(ply, percent)
    if (percent >= math.Rand(1, 100)) then ply:Kill() end
end

function scp_207.PrintMessageInfo(ply)
	-- TODO : Choper un texte random et l'envoyer coté client
end

function scp_207.StartOverlayEffect(ply)
	-- TODO : Faire l'overlay ou l'effet de floue progressif jusqu'à 24m ou jusqu'à 48
end

/*
* DEPRECATED
*/
function scp_207.EventDoorsDestroyable(ply)
	if (!IsValid(ply)) then return end

	if (table.IsEmpty( SCP_207_CONFIG.PlayersCanBreakDoors)) then
		hook.Add( "Think", "Think.CheckDoorsBreakable_SCP207", function()
			for class, value in pairs(SCP_207_CONFIG.DoorClass) do
				local DoorsFounded = ents.FindByClass( class )
				for key, door in ipairs(DoorsFounded) do
					local PlayersFound = ents.FindInSphere( door:Getpos(), SCP_207_CONFIG.RadiusCollisionDoor )
					for key, entPly in ipairs(PlayersFound) do
						if (entPly:IsPlayer() and entPly.scp207_CanDestroyDoors) then
							scp_207.DestroyDoor(door, entPly)
						end
					end
				end
			end
		end )
	end

	SCP_207_CONFIG.PlayersCanBreakDoors[ply:EntIndex()] = true
	ply.scp207_CanDestroyDoors = true
end

function scp_207.RemoveEventDoorsDestroyable()
	if (!table.IsEmpty( SCP_207_CONFIG.PlayersCanBreakDoors)) then return end
	hook.Remove( "Think", "Think.CheckDoorsBreakable_SCP207" )
end

function scp_207.DestroyDoor(door, ply)
	local PhysPly = ply:GetPhysicsObject()
	if (PhysPly:GetVelocity():Length() < SCP_207_CONFIG.VelocityMinDestroyDoor) then return end

	door:EmitSound("doors/heavy_metal_stop1.wav",350,120)

	if (door:GetClass() == "prop_door_rotating") then
		local BrokenDoor = ents.Create("prop_physics")
		BrokenDoor:SetPos(door:GetPos())
		BrokenDoor:SetAngles(door:GetAngles())
		BrokenDoor:SetModel(door:GetModel())
		BrokenDoor:SetBodyGroups(door:GetBodyGroups())
		BrokenDoor:SetSkin(door:GetSkin())
		BrokenDoor:SetCustomCollisionCheck(true)
	
		door:Remove()
	
		BrokenDoor:Spawn()
	
		local PhysBrokenDoor = BrokenDoor:GetPhysicsObject()
		if IsValid(PhysBrokenDoor) then
			PhysBrokenDoor:ApplyForceOffset(ply:GetForward() * 500, PhysBrokenDoor:GetMassCenter())
		end
	else
		door:Fire("open")
	end
end


function scp_207.CureEffect(ply)
	if (!ply.HasDrinkSCP207) then return end

	if (ply.scp207_PreviousInfoData and ply:Alive()) then
		ply:SetWalkSpeed( ply.scp207_PreviousInfoData.WalkSpeed )
		ply:SetRunSpeed( ply.scp207_PreviousInfoData.RunSpeed )
		ply:SetJumpPower( ply.scp207_PreviousInfoData.JumpPower )

		ply.scp207_PreviousInfoData = nil
	end

	if (timer.Exists("Timer.scp207_Effect_"..ply:EntIndex())) then
		timer.Remove("Timer.scp207_Effect_"..ply:EntIndex())
	end


	-- TODO : Remove overlay
	-- TODO : Check if SCP_207_CONFIG.PlayersCanBreakDoors is nil and remove hook on door.
	SCP_207_CONFIG.PlayersCanBreakDoors[ply:EntIndex()] = nil
	ply.scp207_CanDestroyDoors = nil
	scp_207.RemoveEventDoorsDestroyable()

	ply.HasDrinkSCP207 = nil
end