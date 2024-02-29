// c 2024-02-16
// m 2024-02-29

const string myName = GetApp().LocalPlayerInfo.Name;
const string title  = "\\$FFF" + Icons::Trophy + "\\$G Trophy Estimator";

void Main() {
    // startnew(ReadQualiRank);
    // int div = ReadDiv();
}

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Show))
        S_Show = !S_Show;
}

void Render() {
    if (!S_Show)
        return;

    UI::Begin(title, S_Show, UI::WindowFlags::AlwaysAutoResize);
        UI::Text("quali rank: " + rank);
        UI::Text("div: " + div);

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