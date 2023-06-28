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

		scp_207.IncrementStat(ply)
		scp_207.ApplyStateEffect(ply, index)

		if (index >= 30) then
			scp_207.InstanDeath(ply, percent)

			if (!ply:Alive()) then return end

			percent =  index >= 48 and 100 or math.Clamp( percent +  SCP_207_CONFIG.IncrementChanceDeath, 0, 100 )
		end
        index = index + 1
    end)
end

/*
* Function that apply effects or events to be performed depending on the stage of the effect from SCP-207.
* @Player ply The player affected by SCP-207.
* @number index The curent state of the effect.
*/
function scp_207.ApplyStateEffect(ply, index)
    if (!IsValid(ply) or type(index) != "number") then return end

	local DataState = SCP_207_CONFIG.TableStateEffect[index]

	if (DataState) then
		if (DataState.PrintMessageInfo) then scp_207.PrintMessageInfo(ply, DataState.PrintMessageInfo) end
		if (DataState.StartOverlayEffect) then scp_207.StartOverlayEffect(ply, index) end
		if (DataState.EventDoorsDestroyable) then scp_207.EventDoorsDestroyable(ply) end
	end
	if (index % 2  == 0) then scp_207.PrintMessageInfo(ply, scp_207.TranslateLanguage(SCP_207_LANG, "IncreaseStats_"..math.random(1, 5))) end
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
	ply:SetJumpPower( ply:GetJumpPower()  + JumpPower * SCP_207_CONFIG.IncrementStatJump )
end

/*
* --! This method is shit, the math is not very good.
* Return true if the entity will instant die.
* @Player ply The player to kill if he is unlucky.
* @Number percent The percent chance to kill the player.
*/
function scp_207.InstanDeath(ply, percent)
    if (percent >= math.Rand(1, 100)) then ply:Kill() end
end

/*
* Display a message on client side of a player.
* @Player ply The player to print the message.
* @String text The text to display to the player.
*/
function scp_207.PrintMessageInfo(ply, text)
	net.Start(SCP_207_CONFIG.TextToSendToServer)
		net.WriteString(text)
	net.Send(ply)
end

/*
* Start the overlay effect on a player.
*/
function scp_207.StartOverlayEffect(ply, index)
	local IterationBySeconds = (SCP_207_CONFIG.MaxLoop - index) * SCP_207_CONFIG.TimeDecay
	net.Start(SCP_207_CONFIG.StartOverlayEffect)
		net.WriteUInt(IterationBySeconds, 12) --! Max is 4095 with 12
	net.Send(ply)
end

function scp_207.RemoveOverlayEffect(ply)
	net.Start(SCP_207_CONFIG.RemoveOverlayEffect)
	net.Send(ply)
end
/*
* When call, add an hook on every door to check if a player can break it.
* @Player ply The player who can break the doors
*/
function scp_207.EventDoorsDestroyable(ply)
	if (!IsValid(ply)) then return end

	if (table.IsEmpty( SCP_207_CONFIG.PlayersCanBreakDoors)) then
		hook.Add( "Think", "Think.CheckDoorsBreakable_SCP207", function()
			for class, value in pairs(SCP_207_CONFIG.DoorClass) do
				local DoorsFounded = ents.FindByClass( class )
				for key, door in ipairs(DoorsFounded) do
					local PlayersFound = ents.FindInSphere( door:GetPos(), SCP_207_CONFIG.RadiusCollisionDoor )
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

/*
* Remove the hook effect that check if a doors can be breakable.
*/
function scp_207.RemoveEventDoorsDestroyable()
	if (!table.IsEmpty( SCP_207_CONFIG.PlayersCanBreakDoors)) then return end
	hook.Remove( "Think", "Think.CheckDoorsBreakable_SCP207" )
end

/*
* The method for break a door.
* @Entity door the door who is about to be break, has to be a specific class door.
* @Player ply The play who break the door.
*/
function scp_207.DestroyDoor(door, ply)
	local PhysPly = ply:GetPhysicsObject()
	if (PhysPly:GetVelocity():Length() < SCP_207_CONFIG.VelocityMinDestroyDoor) then return end

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
		door:EmitSound("doors/heavy_metal_stop1.wav",350,120)
		ply:TakeDamage(SCP_207_CONFIG.DamageTakeBreakingDoor, ply, ply)

	elseif(!scp_207.DoorIsOpen( door )) then
		door:Fire("open")
		door.IsBreak = true
		timer.Simple(2, function() -- When door are open, while they are opening, they are still in the mode 'close', so it can spam during this time.
			if (!door:IsValid()) then return end
			door.IsBreak = nil
		end)
		door:EmitSound("doors/heavy_metal_stop1.wav",350,120)
		ply:TakeDamage(SCP_207_CONFIG.DamageTakeBreakingDoor, ply, ply)
	end
end

/*
* It cure every effect from SCP 207 on a player, only used when a player died or change team.
* @Player ply The player to cure.
*/
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


	scp_207.RemoveOverlayEffect(ply)
	SCP_207_CONFIG.PlayersCanBreakDoors[ply:EntIndex()] = nil
	ply.scp207_CanDestroyDoors = nil
	scp_207.RemoveEventDoorsDestroyable()

	ply.HasDrinkSCP207 = nil
end

/*
* Check is a door is open or not.
* @Entity door The door to check.
*/
function scp_207.DoorIsOpen( door )
	if (door.IsBreak) then return true end
	local doorClass = door:GetClass()

	if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then
		return door:GetInternalVariable( "m_toggle_state" ) == 0
	elseif ( doorClass == "prop_door_rotating" ) then
		return door:GetInternalVariable( "m_eDoorState" ) ~= 0
	else
		return false
	end
end

/*
* Function used for drop the entiot if it is equip by a player.
* @Player ply The player who will drop the entity.
*/
function scp_207.DropSCP2017(ply)
    if (!IsValid(ply)) then return end

    if (ply:HasWeapon("swep_scp207")) then

        local ent = ents.Create( "scp_207" )
        ent:SetPos( ply:GetShootPos() + ply:GetAimVector() * 20 )
        ent:SetAngles( ply:EyeAngles() + Angle(0, 48, 0))
        ent:Spawn()
        ent:Activate()
    end
end