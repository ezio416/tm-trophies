// c 2024-02-26
// m 2024-02-29

int div  = 0;
int rank = 0;

// void ReadQualiRank() {
//     CTrackMania@ App = cast<CTrackMania@>(GetApp());
//     CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
//     CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);

//     while (true) {
//         sleep(1000);

//         rank = 0;

//         CGameManiaAppPlayground@ CMAP = Network.ClientManiaAppPlayground;

//         if (CMAP is null || CMAP.Playground is null || ServerInfo.CurGameModeStr != "TM_COTDQualifications_Online")
//             continue;

//         for (uint i = 0; i < CMAP.UILayers.Length; i++) {
//             CGameUILayer@ Layer = CMAP.UILayers[i];
//             if (Layer is null || Layer.LocalPage is null || Layer.LocalPage.MainFrame is null)
//                 continue;

//             if (Layer.ManialinkPage.SubStr(18, 35) != "UIModule_COTDQualifications_Ranking")
//                 continue;

//             CGameManialinkFrame@ Owner = cast<CGameManialinkFrame@>(CMAP.UILayers[i].LocalPage.MainFrame.GetFirstChild("frame-score-owner"));
//             if (Owner is null)
//                 continue;

//             CGameManialinkControl@ LabelRank = Owner.GetFirstChild("label-rank");
//             if (LabelRank is null)
//                 break;

//             CControlLabel@ Control = cast<CControlLabel@>(LabelRank.Control);
//             if (Control is null)
//                 break;

//             rank = Text::ParseInt(Control.Label);

//             break;
//         }
//     }
// }

// int ReadDiv() {
//     CTrackMania@ App = cast<CTrackMania@>(GetApp());
//     CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
//     CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);
//     CGameManiaAppPlayground@ CMAP = Network.ClientManiaAppPlayground;

//     if (CMAP is null || CMAP.Playground is null || ServerInfo.CurGameModeStr != "TM_KnockoutDaily_Online")
//         return 0;

//     for (int i = CMAP.UILayers.Length - 1; i >= 0; i--) {
//         CGameUILayer@ Layer = CMAP.UILayers[i];
//         if (Layer is null || Layer.LocalPage is null)
//             continue;

//         if (Layer.ManialinkPage.SubStr(18, 30) != "UIModule_Knockout_KnockoutInfo")
//             continue;

//         CGameManialinkLabel@ MatchLabel = cast<CGameManialinkLabel@>(Layer.LocalPage.GetFirstChild("label-server-number"));
//         if (MatchLabel is null)
//             continue;

//         return Text::ParseInt(MatchLabel.Value.SubStr(12, MatchLabel.Value.Length - 12));
//     }

//     return 0;
// }

// int ReadDivRank() {
//     CTrackMania@ App = cast<CTrackMania@>(GetApp());
//     CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
//     CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);
//     CGameManiaAppPlayground@ CMAP = Network.ClientManiaAppPlayground;

//     if (CMAP is null || CMAP.Playground is null || ServerInfo.CurGameModeStr != "TM_KnockoutDaily_Online")
//         return 0;

//     for (int i = CMAP.UILayers.Length - 1; i >= 0; i--) {
//         CGameUILayer@ Layer = CMAP.UILayers[i];
//         if (Layer is null || Layer.LocalPage is null)
//             continue;

//         if (Layer.ManialinkPage.SubStr(18, 30) != "UIModule_Knockout_KnockoutInfo")
//             continue;

//         ;

//         return Text::ParseInt("");
//     }

//     return 0;
// }