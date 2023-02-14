void LoadSkins() {
    allSkins.RemoveRange(0, allSkins.Length);
    if (Permissions::UseCustomSkin() && useRandomFavoriteSkin) {
        VehicleSkin::GetFavoriteSkins(dataFileMgr, userId);
        for (uint i = 0; i < VehicleSkin::favoriteSkins.Length; i++) {
            allSkins.InsertLast(VehicleSkin::favoriteSkins[i]);
        }
        // if (devLog) {
        //     print("Favorite skins:");
        //     for (uint i = 0; i < VehicleSkin::favoriteSkins.Length; i++) {
        //         trace(VehicleSkin::favoriteSkins[i]);
        //     }
        // }
    }

    if (useRandomPrestigeSkin) {
        UserPrestige::GetAccountPrestigeList(userMgr, userId);
        UserPrestige::GetCurrentPrestige(userMgr, userId, isUsingPrestige);
        // print(isUsingPrestige);
        for (uint i = 0; i < UserPrestige::userPrestiges.Length; i++) {
            allSkins.InsertLast(UserPrestige::userPrestiges[i]);
        }
        // if (devLog) {
        //     print("Account Prestige:");
        //     for (uint i = 0; i < UserPrestige::userPrestiges.Length; i++) {
        //         trace(UserPrestige::userPrestiges[i]);
        //     }
        // }
    }

    trace(allSkins.Length + " Skins loaded");
}

array<Skin@> allSkins;
bool isUsingPrestige;
CGameUserManagerScript@ userMgr;
CGameDataFileManagerScript@ dataFileMgr;
MwId userId;

void Main() {
#if TMNEXT
    GameInfo@ gameInfo = GameInfo();
    @userMgr = gameInfo.UserManagerScript;
    @dataFileMgr = gameInfo.DataFileMgr;

    userId = userMgr.Users[0].Id;

    LoadSkins();

    bool changeFlag = false;
    bool inGame = false;
    bool triggered = false;

    while (true) {
        userId = userMgr.Users[0].Id;

        changeFlag = false;

        auto pg = gameInfo.CurrentPlayground;
        auto cmap = gameInfo.ClientManiaAppPlayground;
        if (pg is null && cmap is null && inGame) {
            inGame = false;
            changeFlag = true;
            // print("triggered from map exit");
        } else if (pg !is null) {
            inGame = true;

            uint endTime = pg.Arena.Rules.RulesStateEndTime;
            uint curTime = uint(cmap.Playground.GameTime);

            uint delta = endTime - curTime;

            if (triggered) {
                // if there's a live server that lasts more than 6 hours, I'd be surprised
                if (delta > 21600000) {
                    triggered = false;
                }
                yield();
                continue;
            }

            // we trigger right before server reset
            // doing it this way is required because 
            // Nadeo Net Code/Caching is weird
            if (delta < 5000) {
                changeFlag = true;
                triggered = true;
                // print("triggered from server reset");
            }
        }

        if (changeFlag && Permissions::UseCustomSkin() && allSkins.Length > 0) {
            uint randomIndex = Math::Rand(0,allSkins.Length);
            // print(randomIndex);

            if (allSkins[randomIndex].SkinType == "CustomSkin") {
                if (isUsingPrestige) {
                    UserPrestige::ResetCurrentAccountPrestige(userMgr, userId);
                    isUsingPrestige = false;
                }
                VehicleSkin::SetSkin(dataFileMgr, userId, allSkins[randomIndex].Id);
            } else if (allSkins[randomIndex].SkinType == "Prestige") {
                UserPrestige::SetCurrentAccountPrestige(userMgr, userId, allSkins[randomIndex].Id);
                isUsingPrestige = true;
            } else {
                trace("got some other type of skin :eyes:");
            }
        }

        yield();
    }
#endif
}