if SERVER then return end

-- 
net.Receive(SCP_207_CONFIG.TextToSendToServer, function ( )
    local TextToPrint = net.ReadString()
    LocalPlayer():ChatPrint( TextToPrint )
end)