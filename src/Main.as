// c 2024-02-16
// m 2024-02-26

const string title = "\\$FFF" + Icons::Trophy + "\\$G Trophy Estimator";

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Show))
        S_Show = !S_Show;
}

void Render() {
    if (!S_Show)
        return;

    UI::Begin(title, S_Show, UI::WindowFlags::AlwaysAutoResize);
        UI::BeginTabBar("##tabs");
            Tab_CotdQuali();
            Tab_CotdKnockout();
            Tab_CotdRerunQuali();
            Tab_CotdRerunKnockout();
        UI::EndTabBar();
    UI::End();
}

int cotdQualiRank = 0;
void Tab_CotdQuali() {
    if (!UI::BeginTabItem("COTD Quali"))
        return;

    cotdQualiRank = UI::InputInt("rank", cotdQualiRank);

    UI::Text("trophies for rank " + cotdQualiRank + ": " + InsertSeparators(CotdQualifierTrophies(cotdQualiRank)));

    UI::EndTabItem();
}

int cotdKnockoutPlayers = 0;
int cotdKnockoutDiv     = 0;
int cotdKnockoutDivRank = 0;
void Tab_CotdKnockout() {
    if (!UI::BeginTabItem("COTD Knockout"))
        return;

    cotdKnockoutPlayers = UI::InputInt("players", cotdKnockoutPlayers);
    cotdKnockoutDiv     = UI::InputInt("div", cotdKnockoutDiv);
    cotdKnockoutDivRank = UI::InputInt("div rank", cotdKnockoutDivRank);

    UI::Text("trophies for rank " + cotdKnockoutDivRank + " of div " + cotdKnockoutDiv + ": " + InsertSeparators(CotdKnockoutTrophies(cotdKnockoutPlayers, cotdKnockoutDiv, cotdKnockoutDivRank)));

    UI::EndTabItem();
}

int cotdRerunQualiRank = 0;
void Tab_CotdRerunQuali() {
    if (!UI::BeginTabItem("COTD Rerun Quali"))
        return;

    cotdRerunQualiRank = UI::InputInt("rank", cotdRerunQualiRank);

    UI::Text("trophies for rank " + cotdRerunQualiRank + ": " + InsertSeparators(CotdRerunQualifierTrophies(cotdRerunQualiRank)));

    UI::EndTabItem();
}

int cotdRerunKnockoutPlayers = 0;
int cotdRerunKnockoutDiv     = 0;
int cotdRerunKnockoutDivRank = 0;
void Tab_CotdRerunKnockout() {
    if (!UI::BeginTabItem("COTD Rerun Knockout"))
        return;

    cotdRerunKnockoutPlayers = UI::InputInt("players", cotdRerunKnockoutPlayers);
    cotdRerunKnockoutDiv     = UI::InputInt("div", cotdRerunKnockoutDiv);
    cotdRerunKnockoutDivRank = UI::InputInt("div rank", cotdRerunKnockoutDivRank);

    UI::Text("trophies for rank " + cotdRerunKnockoutDivRank + " of div " + cotdRerunKnockoutDiv + ": " + InsertSeparators(CotdRerunKnockoutTrophies(cotdRerunKnockoutPlayers, cotdRerunKnockoutDiv, cotdRerunKnockoutDivRank)));

    UI::EndTabItem();
}