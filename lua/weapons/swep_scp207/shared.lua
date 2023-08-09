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

AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = Model( "models/weapons/scp_207/v_scp_207.mdl" )
SWEP.WorldModel = Model( "models/weapons/scp_207/w_scp_207.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "slam"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

-- Variables Personnal to this weapon --
-- [[ STATS WEAPON ]]
SWEP.PrimaryCooldown = 3.5

local DrinkSound = Sound( "scp_207/drink.mp3" )

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetHoldType( self.HoldType )
end

function SWEP:Deploy()
	local ply = self:GetOwner()
	local speedAnimation = GetConVarNumber( "sv_defaultdeployspeed" )
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetPlaybackRate( speedAnimation )
	local VMAnim = ply:GetViewModel()
	local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 
	self:SetNextPrimaryFire( CurTime() + NexIdle + 0.1 ) --? We add 0.1s for avoid to cancel primary animation
	self:SetNextSecondaryFire( CurTime() + NexIdle )
	timer.Simple(NexIdle, function()
		if(!self:IsValid()) then return end
		self:SendWeaponAnim( ACT_VM_IDLE )
	end)
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.PrimaryCooldown )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	local VMAnim = self:GetOwner():GetViewModel()
	local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate()
	timer.Simple(NexIdle - 2.5, function()
		if(!self:IsValid()) then return end

		if SERVER then 
			sound.Play( DrinkSound, self:GetOwner():GetPos(), 75 )
		end
	end)
	timer.Simple(NexIdle, function()
		if(!self:IsValid() or !self:GetOwner():IsValid() or CLIENT) then return end

		scp_207.ConsumeSCP207(self:GetOwner())
		self:Remove()
	end)
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self:SetNextSecondaryFire( CurTime() + self.PrimaryCooldown )
	scp_207.DropSCP207(self:GetOwner(), self)
end