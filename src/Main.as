// c 2024-02-16
// m 2024-03-11

string       gameMode;
string       myName;
string       myUserId;
const string title = "\\$FFF" + Icons::Trophy + "\\$G Trophies";

void Main() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
    CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);

    myName = App.LocalPlayerInfo.Name;
    myUserId = App.LocalPlayerInfo.WebServicesUserId;

    ChangeFont();

    while (true) {
        gameMode = ServerInfo.CurGameModeStr;

        if (gameMode == "TM_COTDQualifications_Online" || gameMode == "TM_KnockoutDaily_Online")
            SetCotdInfo();

        yield();
    }
}

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();
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
    if (
        !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    RenderQualifier();
    RenderKnockout();
    RenderDebug();
}

void RenderQualifier() {
    if (!S_Qualifier || gameMode != "TM_COTDQualifications_Online")
        return;

    qualiRank = GetQualiRank();

    const float posX = Draw::GetWidth() * S_X;
    const float posY = Draw::GetHeight() * S_Y;

    nvg::FontFace(font);

    nvg::FontSize(S_HeaderFontSize);
    const string header = Icons::Trophy + " COT" + (edition == 1 ? "D" : edition == 2 ? "N" : edition == 3 ? "M" : "?") + " Qualifier " + Icons::Trophy;
    const vec2 headerSize = nvg::TextBounds(header);

    nvg::FontSize(S_FontSize);
    const string subheader1 = "Rank " + qualiRank + " / " + totalPlayers;
    const vec2 subheader1Size = nvg::TextBounds(subheader1);
    const float subheader1OffsetY = S_Header ? headerSize.y + S_HeaderFontSize * 0.4f : 0.0f;

    const string subheader2 = "Division " + division + " / " + int(Math::Ceil(float(totalPlayers) / 64.0f));
    const vec2 subheader2Size = nvg::TextBounds(subheader2);
    const float subheader2OffsetY = subheader1OffsetY + subheader1Size.y;

    const string rank1       = "1: "       + InsertSeparators(CotdQualifierTrophies(1,   edition > 1));
    const string rank2       = "2: "       + InsertSeparators(CotdQualifierTrophies(2,   edition > 1));
    const string rank3       = "3: "       + InsertSeparators(CotdQualifierTrophies(3,   edition > 1));
    const string rank4_10    = "4-10: "    + InsertSeparators(CotdQualifierTrophies(4,   edition > 1));
    const string rank11_50   = "11-50: "   + InsertSeparators(CotdQualifierTrophies(11,  edition > 1));
    const string rank51_100  = "51-100: "  + InsertSeparators(CotdQualifierTrophies(51,  edition > 1));
    const string rank101_250 = "101-250: " + InsertSeparators(CotdQualifierTrophies(101, edition > 1));

    string rank251Plus;
    string rank251_500;
    string rank501_1000;
    string rank1001_2500;
    string rank2501Plus;

    if (edition > 1)
        rank251Plus   = "251+: "      + InsertSeparators(CotdQualifierTrophies(251, true));
    else {
        rank251_500   = "251-500: "   + InsertSeparators(CotdQualifierTrophies(251));
        rank501_1000  = "501-1000: "  + InsertSeparators(CotdQualifierTrophies(501));
        rank1001_2500 = "1001-2500: " + InsertSeparators(CotdQualifierTrophies(1001));
        rank2501Plus  = "2501+: "     + InsertSeparators(CotdQualifierTrophies(2501));
    }

    const float rank1OffsetY = S_Subheader ? subheader2OffsetY + subheader2Size.y * 1.5f : subheader1OffsetY;

    const vec2 rank1Size       = nvg::TextBounds(rank1);
    const vec2 rank2Size       = nvg::TextBounds(rank2);
    const vec2 rank3Size       = nvg::TextBounds(rank3);
    const vec2 rank4_10Size    = nvg::TextBounds(rank4_10);
    const vec2 rank11_50Size   = nvg::TextBounds(rank11_50);
    const vec2 rank51_100Size  = nvg::TextBounds(rank51_100);
    const vec2 rank101_250Size = nvg::TextBounds(rank101_250);

    vec2 rank251PlusSize;
    vec2 rank251_500Size;
    vec2 rank501_1000Size;
    vec2 rank1001_2500Size;
    vec2 rank2501PlusSize;

    if (edition > 1)
        rank251PlusSize = nvg::TextBounds(rank251Plus);
    else {
        rank251_500Size   = nvg::TextBounds(rank251_500);
        rank501_1000Size  = nvg::TextBounds(rank501_1000);
        rank1001_2500Size = nvg::TextBounds(rank1001_2500);
        rank2501PlusSize  = nvg::TextBounds(rank2501Plus);
    }

    float maxTextWidth = 0.0f;
    if (S_Header)
        maxTextWidth = headerSize.x;
    if (S_Subheader) {
        maxTextWidth = Math::Max(maxTextWidth, subheader1Size.x);
        maxTextWidth = Math::Max(maxTextWidth, subheader2Size.x);
    }
    maxTextWidth = Math::Max(maxTextWidth, rank1Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank2Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank3Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank4_10Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank11_50Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank51_100Size.x);
    maxTextWidth = Math::Max(maxTextWidth, rank101_250Size.x);

    if (edition > 1)
        maxTextWidth = Math::Max(maxTextWidth, rank251PlusSize.x);
    else {
        maxTextWidth = Math::Max(maxTextWidth, rank251_500Size.x);
        maxTextWidth = Math::Max(maxTextWidth, rank501_1000Size.x);
        maxTextWidth = Math::Max(maxTextWidth, rank1001_2500Size.x);
        maxTextWidth = Math::Max(maxTextWidth, rank2501PlusSize.x);
    }

    if (S_Background) {
        nvg::FillColor(S_BackgroundColor);
        nvg::BeginPath();
        nvg::RoundedRect(
            posX,
            posY,
            maxTextWidth + S_BackgroundXPad * 2.0f,
            rank1OffsetY + rank1Size.y * (edition > 1 ? 8.0f : 11.0f) + S_BackgroundYPad * 2.0f,
            S_BackgroundRadius
        );
        nvg::Fill();
    }

    const float posMidWidth = posX + S_BackgroundXPad + maxTextWidth * 0.5f;

    nvg::TextAlign(nvg::Align::Center | nvg::Align::Top);

    if (S_Header) {
        nvg::FontSize(S_HeaderFontSize);
        nvg::FillColor(S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad,
            header
        );
    }

    if (S_Subheader) {
        // rank / total players
        nvg::FontSize(S_FontSize);
        nvg::FillColor(S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + subheader1OffsetY,
            subheader1
        );

        // division
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + subheader2OffsetY,
            subheader2
        );
    }

    nvg::FontSize(S_FontSize);

    nvg::FillColor(qualiRank == 1 ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY,
        rank1
    );

    nvg::FillColor(qualiRank == 2 ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y,
        rank2
    );

    nvg::FillColor(qualiRank == 3 ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 2.0f,
        rank3
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 4, 10) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 3.0f,
        rank4_10
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 11, 50) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 4.0f,
        rank11_50
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 51, 100) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 5.0f,
        rank51_100
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 101, 250) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 6.0f,
        rank101_250
    );

    if (edition > 1) {
        nvg::FillColor(qualiRank > 250 ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 7.0f,
            rank251Plus
        );
    } else {
        nvg::FillColor(IsBetweenInclusive(qualiRank, 251, 500) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 7.0f,
            rank251_500
        );

        nvg::FillColor(IsBetweenInclusive(qualiRank, 501, 1000) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 8.0f,
            rank501_1000
        );

        nvg::FillColor(IsBetweenInclusive(qualiRank, 1001, 2500) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 9.0f,
            rank1001_2500
        );

        nvg::FillColor(qualiRank > 2500 ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + rank1Size.y * 10.0f,
            rank2501Plus
        );
    }
}

void RenderKnockout() {
    if (!S_Knockout || gameMode != "TM_KnockoutDaily_Online")
        return;

    SetKoInfo();

    UI::Begin(title, S_Knockout, UI::WindowFlags::AlwaysAutoResize);
        UI::Text("rerun: " + (edition > 1));
        UI::Text("total players: " + totalPlayers);
        UI::Text("total divisions: " + Math::Ceil(float(totalPlayers) / 64.0f));
        UI::Text("division: " + division);
        UI::Text("rank: " + divisionRank);
        UI::Text("players left: " + playersLeft);
        UI::Text("alive: " + alive);

        UI::Separator();

        if (edition > 1) {
            UI::Text(                                    "Rank 1: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 1,  true)));
            UI::Text(                                    "Rank 2: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 2,  true)));
            UI::Text((playersLeft > 2  ? WHITE : GRAY) + "Rank 3: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 3,  true)));
            UI::Text((playersLeft > 3  ? WHITE : GRAY) + "Rank 4-8: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 4,  true)));
            UI::Text((playersLeft > 8  ? WHITE : GRAY) + "Rank 9-32: " + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 9,  true)));
            UI::Text((playersLeft > 32 ? WHITE : GRAY) + "Rank 33+: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 33, true)));
        } else {
            UI::Text(                                    "Rank 1: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 1)));
            UI::Text(                                    "Rank 2: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 2)));
            UI::Text((playersLeft > 2  ? WHITE : GRAY) + "Rank 3: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 3)));
            UI::Text((playersLeft > 3  ? WHITE : GRAY) + "Rank 4-8: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 4)));
            UI::Text((playersLeft > 8  ? WHITE : GRAY) + "Rank 9-32: " + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 9)));
            UI::Text((playersLeft > 32 ? WHITE : GRAY) + "Rank 33+: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 33)));
        }

    UI::End();
}