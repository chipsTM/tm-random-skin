[Setting name="Random Favorite Skin" category="Vehicle Skin" description="Currently changes when map switches"]
bool useRandomFavoriteSkin = true;

// [Setting name="Dev" category="Vehicle Skin" description="Useful for debugging skin related stuff"]
// bool devLog = false;

namespace VehicleSkin {

    class SkinData : Skin {
        string Checksum;
        string CreatorAccountId;
        string CreatorWebServicesUserId;
        string CreatorDisplayName;
        bool CreatorIsFirstPartyDisplayName;
        string DisplayName;
        string FileName;
        string FileUrl;
        string Name;
        string ThumbnailUrl;
        uint TimeStamp;
        string Type;

        SkinData() {}

        SkinData(CNadeoServicesSkin@ data) {
            Checksum = data.Checksum;
            CreatorAccountId = data.CreatorAccountId;
            CreatorWebServicesUserId = data.CreatorWebServicesUserId;
            CreatorDisplayName = data.CreatorDisplayName;
            CreatorIsFirstPartyDisplayName = data.CreatorIsFirstPartyDisplayName;
            DisplayName = data.DisplayName;
            FileName = data.FileName;
            FileUrl = data.FileUrl;
            Id = data.Id;
            Name = data.Name;
            ThumbnailUrl = data.ThumbnailUrl;
            TimeStamp = data.TimeStamp;
            Type = data.Type;
            SkinType = "CustomSkin";
        }

        string ToString() const {
            return DisplayName + " | " + Name + " | " + Id + " | " + Type;
        }
    }

    array<SkinData@> favoriteSkins;

    void GetFavoriteSkins(CGameDataFileManagerScript@ dataFileMgr, MwId userId) {
        CWebServicesTaskResult_NadeoServicesSkinListScript@ req = dataFileMgr.AccountSkin_NadeoServices_GetFavoriteList(userId);
        
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            favoriteSkins.RemoveRange(0, favoriteSkins.Length);
            auto skins = req.SkinList;
            for (uint i = 0; i < skins.Length; i++) {
                // 👀
                if (skins[i].Type == "Models/CarSport") {
                    favoriteSkins.InsertLast(SkinData(skins[i]));
                }
            }
        }

        if (req.HasFailed) {
            error("Error getting favorite skins: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }

        dataFileMgr.TaskResult_Release(req.Id);
    }

    void SetSkin(CGameDataFileManagerScript@ dataFileMgr, MwId userId, const string &in skinId) {
        CWebServicesTaskResult_NadeoServicesSkinScript@ req = dataFileMgr.AccountSkin_NadeoServices_Set(userId, skinId);
        while(req.IsProcessing) {
            yield();
        }

        if (req.HasSucceeded) {
            trace("Vehicle skin has been set to: " + req.Skin.DisplayName);
        }

        if (req.HasFailed) {
            error("Error setting skin: " + req.ErrorType + " | " + req.ErrorCode + " | " + req.ErrorDescription);
        }

        dataFileMgr.TaskResult_Release(req.Id);
    } 

}