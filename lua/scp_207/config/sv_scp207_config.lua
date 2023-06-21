if CLIENT then return end

util.AddNetworkString( SCP_207_CONFIG.TextToSendToServer )

-- Eevent & effetc to apply to a player, depend on the state.
SCP_207_CONFIG.TableStateEffect = SCP_207_CONFIG.TableStateEffect or {}
SCP_207_CONFIG.TableStateEffect[1] = {
    PrintMessageInfo = scp_207.TranslateLanguage(SCP_207_LANG, "InitialIncreaseStats")
}
SCP_207_CONFIG.TableStateEffect[10] = {
    StartOverlayEffect = true
}
SCP_207_CONFIG.TableStateEffect[15] = {
    EventDoorsDestroyable = true
}
SCP_207_CONFIG.TableStateEffect[24] = {
    PrintMessageInfo = scp_207.TranslateLanguage(SCP_207_LANG, "IncreaseStats_6")
}