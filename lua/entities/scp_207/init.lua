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

AddCSLuaFile("shared.lua")
include("shared.lua")

-- TODO : Mettre les bon sons.
local PhysicSoundLow = Sound( "physics/glass/glass_bottle_impact_hard"..math.random(1, 3)..".wav" )
local BreakSound = Sound( "physics/glass/glass_bottle_break"..math.random(1, 2)..".wav" )
local PickUpSound = Sound( "scp_207/pickup.mp3" )

function ENT:BreakEntity()
	local effectdata = EffectData()

	effectdata:SetOrigin( self:GetPos() )
	sound.Play( BreakSound, self:GetPos(), 75, math.random( 50, 160 ) )
	util.Effect( "GlassImpact", effectdata )
	self:Remove()
end

function ENT:Initialize()
	self:SetModel( "models/scp_207/scp_207.mdl" )
	self:RebuildPhysics()
end

function ENT:RebuildPhysics( value )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

function ENT:PhysicsCollide( data, physobj )
	if ( data.Speed > 250 and data.DeltaTime > 0.01) then
		self:BreakEntity(pos)
	elseif (data.Speed > 20 and data.DeltaTime > 0.01) then
		sound.Play( PhysicSoundLow, self:GetPos(), 75, math.random( 50, 160 ) )	
	end
end

function ENT:OnTakeDamage( dmginfo )
	local DmgReceive = dmginfo:GetDamage()
	if (DmgReceive >= 5) then
		self:BreakEntity(pos)
	else
		return 0
	end
end

function ENT:Use( ply)
	if(SCP_207_CONFIG.JobNotAllowed[team.GetName(ply:Team())]) then return end

	sound.Play( PickUpSound, ply:GetPos(), 75, math.random( 50, 160 ) )	
	self:Remove()
	ply:Give("swep_scp207")
end