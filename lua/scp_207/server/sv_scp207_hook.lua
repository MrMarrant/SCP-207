if CLIENT then return end

hook.Add( "PlayerDeath", "PlayerDeath.RemoveEffect_SCP207", scp_207.CureEffect )
hook.Add( "PlayerChangedTeam", "PlayerChangedTeam.RemoveEffect_SCP207", scp_207.CureEffect )