if SERVER then return end

-- 
net.Receive(SCP_207_CONFIG.TextToSendToServer, function ( )
    local TextToPrint = net.ReadString()
    LocalPlayer():ChatPrint( TextToPrint )
end)

net.Receive(SCP_207_CONFIG.StartOverlayEffect, function ( )
    local ply = LocalPlayer()
    local IterationBySeconds = net.ReadUInt(12)
    timer.Create("Timer.scp207_StartOverlayEffect_"..ply:EntIndex(), 1, IterationBySeconds, function()
        if (!IsValid(ply)) then return end
        --TODO : Mettre l'overlay
    end)
end)

net.Receive(SCP_207_CONFIG.RemoveOverlayEffect, function ( )
    local ply = LocalPlayer()
    if (timer.Exists("Timer.scp207_StartOverlayEffect_"..ply:EntIndex())) then
        timer.Remove("Timer.scp207_StartOverlayEffect_"..ply:EntIndex())
    end
    -- TODO : Remove l'overlay ou remettre les param par défaut
end)