class GameInfo {
    CTrackMania@ app;

    GameInfo() {
        @app = cast<CTrackMania@>(GetApp());
    }

    CTrackManiaNetwork@ Network {
        get const {
            return cast<CTrackManiaNetwork@>(this.app.Network);
        }
        // set {}
    }

    CSmArenaClient@ CurrentPlayground {
        get const {
            return cast<CSmArenaClient@>(this.app.CurrentPlayground);
        }
        // set {}
    }

    CGameManiaAppPlayground@ ClientManiaAppPlayground {
        get const {
            return this.Network.ClientManiaAppPlayground;
        }
        // set {}
    }

     CGameUserManagerScript@ UserManagerScript {
        get const {
            return this.app.UserManagerScript;
        }
        // set {}
     }

     CGameDataFileManagerScript@ DataFileMgr {
        get const {
            return this.app.MenuManager.MenuCustom_CurrentManiaApp.DataFileMgr;
        }
        // set {}
     }

}