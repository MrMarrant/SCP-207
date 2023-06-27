if CLIENT then return end

hook.Add( "PlayerDeath", "PlayerDeath.RemoveEffect_SCP207", scp_207.CureEffect )
hook.Add( "PlayerChangedTeam", "PlayerChangedTeam.RemoveEffect_SCP207", scp_207.CureEffect )

hook.Add( "PlayerDeath", "PlayerDeath.Remove_SCP207", scp_207.DropSCP2017 )
hook.Add( "PlayerDisconnected", "PlayerDisconnected.Remove_SCP207", scp_207.DropSCP2017 )