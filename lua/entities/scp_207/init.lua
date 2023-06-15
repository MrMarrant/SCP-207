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
local PhysisSoundLow = Sound( "bouncy_ball/ball_noise.mp3" )
local PhysisSoundHeavy = Sound( "bouncy_ball/ball_noise.mp3" )
local BreakSound = Sound( "bouncy_ball/ball_noise.mp3" )
local PickUpSound = Sound( "bouncy_ball/ball_noise.mp3" )

function ENT:Initialize()
	self:SetModel( "models/bouncy_ball/bouncy_ball.mdl" ) -- TODO : Chercher le modèle.
	self:RebuildPhysics()
end

function ENT:RebuildPhysics( value )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysWake()
end

function ENT:PhysicsCollide( data, physobj )
	if ( data.Speed > 50 and data.DeltaTime > 0.01) then
		sound.Play( PhysisSoundHeavy, self:GetPos(), 75, math.random( 50, 160 ) )	
	else
		sound.Play( PhysisSoundLow, self:GetPos(), 75, math.random( 50, 160 ) )	
	end
end

function ENT:OnTakeDamage( dmginfo )
	local DmgReceive = dmginfo:GetDamage()
	if (DmgReceive > 30) then
		self:Remove()
		sound.Play( BreakSound, self:GetPos(), 75, math.random( 50, 160 ) )
	else
		return 0
	end
end

function ENT:Use( ply)
	sound.Play( PickUpSound, ply:GetPos(), 75, math.random( 50, 160 ) )	
	self:Remove()
	ply:Give("swep_scp207")
end