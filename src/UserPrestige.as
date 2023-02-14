[Setting name="Random Prestige Skin" category="Vehicle Skin" description="Currently changes when map switches"]
bool useRandomPrestigeSkin = true;

namespace UserPrestige {

    dictionary royalTeam = {
        {"Team01", "Flamingo"},
        {"Team02", "Pig"},
        {"Team03", "Clown Fish"},
        {"Team04", "Fox"},
        {"Team05", "Octopus"},
        {"Team06", "Butterfly"},
        {"Team07", "Crocodile"},
        {"Team08", "Grasshopper"},
        {"Team09", "Ladybug"},
        {"Team10", "Macaw Parrot"},
        {"Team11", "Giraffe"},
        {"Team12", "Bee"},
        {"Team13", "Dolphin"},
        {"Team14", "Peafowl"},
        {"Team15", "Kangaroo"},
        {"Team16", "Monkey"},
        {"Team17", "Panda"},
        {"Team18", "Zebra"},
        {"Team19", "Rabbit"},
        {"Team20", "Polar Bear"}
    };

    dictionary medal = {
        {"1", "Bronze"},
        {"2", "Silver"},
        {"3", "Gold"},
        {"4", "Author"}
    };

    class PrestigeData : Skin {
        string CategoryType;
        uint CategoryLevel;
        NWebServicesPrestige::EPrestigeMode Mode;
        uint PrestigeLevel;
        string SkinOptions;
        uint TimeStamp;
        uint Year;

        PrestigeData() {}

        PrestigeData(CUserPrestige@ data) {
            CategoryType = data.CategoryType;
            CategoryLevel = data.CategoryLevel;
            Mode = data.Mode;
            Id = data.PrestigeId;
            PrestigeLevel = data.PrestigeLevel;
            SkinOptions = data.SkinOptions;
            TimeStamp = data.TimeStamp;
            Year = data.Year;
            SkinType = "Prestige";
        }

        string ToString() const {
            return CategoryType + " | " + CategoryLevel + " | " + Mode + " | " + Id + " | " + PrestigeLevel + " | " + SkinOptions + " | " + TimeStamp + " | " + Year;
        }
    }

    array<PrestigeData@> userPrestiges;

    void GetAccountPrestigeList(CGameUserManagerScript@ userMgr, MwId userId) {
        CWebServicesTaskResult_UserPrestigeListScript@ req = userMgr.Prestige_GetAccountPrestigeList(userId);
        
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            userPrestiges.RemoveRange(0, userPrestiges.Length);
            auto prestige = req.UserPrestigeList;
            for (uint i = 0; i < prestige.Length; i++) {
                userPrestiges.InsertLast(PrestigeData(prestige[i]));
            }
        }

        if (req.HasFailed) {
            error("Error getting prestiges: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }
        userMgr.TaskResult_Release(req.Id);
    }

    void GetCurrentPrestige(CGameUserManagerScript@ userMgr, MwId userId, bool &out usingPrestige) {
        CWebServicesTaskResult_UserPrestigeScript@ req = userMgr.Prestige_GetCurrentAccountPrestige(userId);
        
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            // only using this to check if user has skin enabled
            // in future might be possible to combine prestige and customskin
            usingPrestige = req.HasUserPrestige;
        }

        if (req.HasFailed) {
            error("Error getting prestiges: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }
        userMgr.TaskResult_Release(req.Id);
    }

    void SetCurrentAccountPrestige(CGameUserManagerScript@ userMgr, MwId userId, const string &in prestigeId) {
        CWebServicesTaskResult_UserPrestigeScript@ req = userMgr.Prestige_SetCurrentAccountPrestige(userId, prestigeId);
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            string catType = req.UserPrestige.CategoryType;
            string catLevel = tostring(req.UserPrestige.CategoryLevel);
            if (royalTeam.Exists(catType)) {
                trace("Prestige skin has been set to: " + req.UserPrestige.Year + " " + string(royalTeam[catType]) + " " + string(medal[catLevel]));
            } else {
                trace("Prestige skin has been set to: " + req.UserPrestige.Year + " " + catType + " " + string(medal[catLevel]));
            }
        }

        if (req.HasFailed) {
            error("Error setting prestige skin: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }

        userMgr.TaskResult_Release(req.Id);
    }

    void ResetCurrentAccountPrestige(CGameUserManagerScript@ userMgr, MwId userId) {
        CWebServicesTaskResult_UserPrestigeScript@ req = userMgr.Prestige_ResetCurrentAccountPrestige(userId);
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            // trace("Prestige skin has been unset");
        }

        if (req.HasFailed) {
            error("Error unsetting prestige: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }

        userMgr.TaskResult_Release(req.Id);
    }

}