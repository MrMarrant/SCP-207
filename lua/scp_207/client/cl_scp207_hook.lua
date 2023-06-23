if SERVER then return end

-- Adapt screen size if user change it.
hook.Add( "OnScreenSizeChanged", "OnScreenSizeChanged.scp207_ScreenSizeChanged", function( oldWidth, oldHeight )
    SCP_207_CONFIG.ScrW = ScrW()
    SCP_207_CONFIG.ScrH = ScrH()
end )