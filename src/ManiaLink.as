// c 2024-02-26
// m 2024-02-26

int rank = 0;

void ReadQualiRank() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
    CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);

    while (true) {
        sleep(500);

        rank = 0;

        CGameManiaAppPlayground@ CMAP = Network.ClientManiaAppPlayground;

        if (CMAP is null || CMAP.Playground is null || ServerInfo.CurGameModeStr != "TM_COTDQualifications_Online")
            continue;

        for (uint i = 0; i < CMAP.UILayers.Length; i++) {
            CGameUILayer@ Layer = CMAP.UILayers[i];
            if (Layer is null || Layer.LocalPage is null || Layer.LocalPage.MainFrame is null)
                continue;

            CGameManialinkFrame@ Owner = cast<CGameManialinkFrame@>(CMAP.UILayers[i].LocalPage.MainFrame.GetFirstChild("frame-score-owner"));
            if (Owner is null)
                continue;

            CGameManialinkControl@ LabelRank = Owner.GetFirstChild("label-rank");
            if (LabelRank is null)
                continue;

            CControlLabel@ Control = cast<CControlLabel@>(LabelRank.Control);
            if (Control is null)
                continue;

            rank = Text::ParseInt(Control.Label);

            print("rank: " + rank);
        }
    }
}