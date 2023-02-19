[Setting hidden]
bool useRandomFavoriteSkin = Permissions::UseCustomSkin();

[Setting hidden]
bool useRandomPrestigeSkin = true;

[Setting hidden]
bool SeasonSkin = true;

[Setting hidden]
bool RoyalSkin = true;

[Setting hidden]
bool RankedSkin = true;

[Setting hidden]
bool AuthorSkin = true;

[Setting hidden]
bool GoldSkin = true;

[Setting hidden]
bool SilverSkin = true;

[Setting hidden]
bool BronzeSkin = true;

[SettingsTab name="Vehicle Skin" icon="Kenney::Car"]
void RenderVehicleSkinSettings() {
    bool changed = false;
    
    UI::Text("Favorite Skins");
    UI::Separator();
    if (Permissions::UseCustomSkin()) {
        if (UI::Checkbox("Enable Random Favorite Skin##RFS", useRandomFavoriteSkin) != useRandomFavoriteSkin) {
            useRandomFavoriteSkin = !useRandomFavoriteSkin;
            changed = true;
        }
    }
    UI::Dummy(vec2(0,20));

    UI::Text("Prestige Skins");
    UI::Separator();
    if (UI::Checkbox("Enable Random Prestige Skin##RPS", useRandomPrestigeSkin) != useRandomPrestigeSkin) {
        useRandomPrestigeSkin = !useRandomPrestigeSkin;
        changed = true;
    }
    UI::Dummy(vec2(0,10));

    UI::BeginDisabled(!useRandomPrestigeSkin);
    UI::Dummy(vec2(20,0));
    UI::SameLine();
    UI::Text("Prestige Skin Types");
    UI::Dummy(vec2(20,0));
    UI::SameLine();
    if (UI::Checkbox("Season##Season", SeasonSkin) != SeasonSkin) {
        SeasonSkin = !SeasonSkin;
        changed = true;
    }
    UI::SameLine();
    if (UI::Checkbox("Ranked##Ranked", RankedSkin) != RankedSkin) {
        RankedSkin = !RankedSkin;
        changed = true;
    }
    UI::SameLine();
    if (UI::Checkbox("Royal##Royal", RoyalSkin) != RoyalSkin) {
        RoyalSkin = !RoyalSkin;
        changed = true;
    }
    UI::Dummy(vec2(0,10));

    UI::Dummy(vec2(20,0));
    UI::SameLine();
    UI::Text("Prestige Skin Medals / Levels");
    UI::Dummy(vec2(20,0));
    UI::SameLine();
    if (UI::Checkbox("Author / Lvl IV##Author", AuthorSkin) != AuthorSkin) {
        AuthorSkin = !AuthorSkin;
        changed = true;
    }
    UI::SameLine();
    if (UI::Checkbox("Gold / Lvl III##Gold", GoldSkin) != GoldSkin) {
        GoldSkin = !GoldSkin;
        changed = true;
    }
    UI::SameLine();
    if (UI::Checkbox("Silver / Lvl II##Silver", SilverSkin) != SilverSkin) {
        SilverSkin = !SilverSkin;
        changed = true;
    }
    UI::SameLine();
    if (UI::Checkbox("Bronze / Lvl I##Bronze", BronzeSkin) != BronzeSkin) {
        BronzeSkin = !BronzeSkin;
        changed = true;
    }
    UI::EndDisabled();

    if (changed) {
        startnew(LoadSkins);
    }
}