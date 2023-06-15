if CLIENT then return end

function scp_207.DropSCP207(ply, ent)
	local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
	local SCP207 = ents.Create( "scp_018" )
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
    

end