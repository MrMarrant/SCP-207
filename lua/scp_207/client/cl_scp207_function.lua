if SERVER then return end

/* Create the overlay for infected player.
* @Player ply The player to display the overlay.
*/
function scp_207.DisplayOverlay(ply)
    if (!IsValid(ply)) then return end

    if (ply.scp207_Overlay) then return end -- we don't want two overlay.
    local OverlaySCP207 = vgui.Create("DImage")
    OverlaySCP207:SetImageColor(Color(0, 0, 0, 0))
    OverlaySCP207:SetSize(SCP_207_CONFIG.ScrW, SCP_207_CONFIG.ScrH)
    OverlaySCP207:SetImage("overlay_scp207/overlay_scp207_1.jpg")
    ply.scp207_Overlay = OverlaySCP207
end


-- 
net.Receive(SCP_207_CONFIG.TextToSendToServer, function ( )
    local TextToPrint = net.ReadString()
    LocalPlayer():ChatPrint( TextToPrint )
end)

net.Receive(SCP_207_CONFIG.StartOverlayEffect, function ( )
    local ply = LocalPlayer()
    local IterationBySeconds = net.ReadUInt(12)

    scp_207.DisplayOverlay(ply)
    local saturation = 0
    local incrementSaturation = 250/IterationBySeconds

    timer.Create("Timer.scp207_StartOverlayEffect_"..ply:EntIndex(), 1, IterationBySeconds, function()
        if (!IsValid(ply)) then return end
        if (!ply.scp207_Overlay) then return end

        ply.scp207_Overlay:SetImageColor(Color(0, 0, 0, saturation))
        saturation = saturation + incrementSaturation
    end)
end)

net.Receive(SCP_207_CONFIG.RemoveOverlayEffect, function ( )
    local ply = LocalPlayer()
    if (timer.Exists("Timer.scp207_StartOverlayEffect_"..ply:EntIndex())) then
        timer.Remove("Timer.scp207_StartOverlayEffect_"..ply:EntIndex())
    end
    if (ply.scp207_Overlay) then
        ply.scp207_Overlay:Remove()
        ply.scp207_Overlay = nil
    end
end)