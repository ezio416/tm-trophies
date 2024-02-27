// c 2024-02-16
// m 2024-02-26

const string title = "\\$FFF" + Icons::Trophy + "\\$G Trophy Estimator";

void Main() {
    startnew(ReadQualiRank);
}

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