bool useRandomFavoriteSkin = Permissions::UseCustomSkin();
bool useRandomPrestigeSkin = true;

[SettingsTab name="Vehicle Skin" icon="Kenney::Car"]
void RenderVehicleSkinSettings() {
    bool oldRFSValue;
    bool oldRPSValue;
    if (Permissions::UseCustomSkin()) {
        oldRFSValue = useRandomFavoriteSkin;
        useRandomFavoriteSkin = UI::Checkbox("Random Favorite Skin##RFS", useRandomFavoriteSkin);
    }
    oldRPSValue = useRandomPrestigeSkin;
    useRandomPrestigeSkin = UI::Checkbox("Random Prestige Skin##RPS", useRandomPrestigeSkin);
    if (oldRFSValue != useRandomFavoriteSkin || oldRPSValue != useRandomPrestigeSkin) {
        startnew(LoadSkins);
    }
}