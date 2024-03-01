// c 2024-02-16
// m 2024-02-29

string       gameMode;
string       myName;
const string title = "\\$FFF" + Icons::Trophy + "\\$G Trophy Estimator";

void Main() {
    SetCotdInfo();

    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
    CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);

    myName = App.LocalPlayerInfo.Name;

    while (true) {
        gameMode = ServerInfo.CurGameModeStr;
        yield();
    }
}

void RenderMenu() {
    if (UI::BeginMenu(title)) {
        if (UI::MenuItem(Icons::CheckSquareO + " Enabled", "", S_Enabled))
            S_Enabled = !S_Enabled;

        if (UI::MenuItem(Icons::ClockO + " Qualifier", "", S_Qualifier))
            S_Qualifier = !S_Qualifier;

        if (UI::MenuItem(Icons::Kenney::Fist + " Knockout", "", S_Knockout))
            S_Knockout = !S_Knockout;

        if (UI::MenuItem(Icons::Code + " Debug", "", S_Debug))
            S_Debug = !S_Debug;

        UI::EndMenu();
    }
}

void Render() {
    if (!S_Enabled)
        return;

    RenderQualifier();
    RenderKnockout();
    RenderDebug();
}

void RenderQualifier() {
    if (!S_Qualifier || gameMode != "TM_COTDQualifications_Online")
        return;

    qualiRank = GetQualiRank();

    UI::Begin(title + " (quali)", S_Qualifier);
        ;
    UI::End();
}

void RenderKnockout() {
    if (!S_Knockout || gameMode != "TM_KnockoutDaily_Online")
        return;

    SetKoValues();
    SetCotdInfo();

    UI::Begin(title + " (knockout)", S_Knockout);
        ;
    UI::End();
}

void RenderDebug() {
    if (!S_Debug)
        return;

    UI::Begin(title + " (debug)", S_Debug, UI::WindowFlags::None);
        UI::Text("rerun: " + rerun);
        UI::Text("total players: " + totalPlayers);
        UI::Separator();
        UI::Text("quali rank: " + qualiRank);
        UI::Separator();
        UI::Text("div: " + division);
        UI::Text("div rank: " + divisionRank);
        UI::Text("players left: " + playersLeft);

        UI::BeginTabBar("##tabs");
            Tab_CotdQuali();
            Tab_CotdKnockout();
            Tab_CotdRerunQuali();
            Tab_CotdRerunKnockout();
            Tab_KoData();
            Tab_RaceData();
        UI::EndTabBar();
    UI::End();
}