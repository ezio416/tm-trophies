string       gameMode;
string       myName;
string       myUserId;
const string title = "\\$AAA" + Icons::Trophy + "\\$G Trophies";

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
        else {
            gottenRank = 0;
            totalPlayers = 0;
        }

        sleep(1000);
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

        if (UI::MenuItem(Icons::ClockO + " COTD Qualifier", "", S_Qualifier))
            S_Qualifier = !S_Qualifier;

        if (UI::MenuItem(Icons::Kenney::Fist + " COTD Knockout", "", S_Knockout))
            S_Knockout = !S_Knockout;

        if (UI::MenuItem(Icons::Calendar + " History", "", S_History))
            S_History = !S_History;

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
    RenderHistory();
    RenderDebug();
}

void RenderQualifier() {
    if (!S_Qualifier || gameMode != "TM_COTDQualifications_Online")
        return;

    const MLFeed::HookRaceStatsEventsBase_V4@ raceData = MLFeed::GetRaceData_V4();
    if (raceData !is null && raceData.COTDQ_QualificationsProgress != MLFeed::QualificationStage::Running)
        return;

    // COTDQ_QualificationsProgress == Running
    // else ServerReady or ServerEndingSoon or Null

    qualiRank = GetQualiRank();

    const float posX = Display::GetWidth() * S_X;
    const float posY = Display::GetHeight() * S_Y;

    nvg::FontFace(font);

    nvg::FontSize(S_HeaderFontSize);
    const string header = Icons::Trophy + " COT" + (edition == 1 ? "D" : edition == 2 ? "N" : edition == 3 ? "M" : "?") + " Qualifier";
    const vec2 headerSize = nvg::TextBounds(header);

    nvg::FontSize(S_FontSize);

    const string subheader1 = "Rank " + qualiRank + " / " + totalPlayers;
    const vec2 subheader1Size = nvg::TextBounds(subheader1);
    const float subheader1OffsetY = S_Header ? headerSize.y + S_HeaderFontSize * 0.4f : 0.0f;

    const string subheader2 = "Division " + int(Math::Ceil(float(qualiRank) / 64.0f)) + " / " + int(Math::Ceil(float(totalPlayers) / 64.0f));
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

    const float rank1OffsetY = S_Subheader ? subheader2OffsetY + subheader1Size.y * 1.5f : subheader1OffsetY;

    float maxTextWidth = 0.0f;
    if (S_Header)
        maxTextWidth = headerSize.x;
    if (S_Subheader) {
        maxTextWidth = Math::Max(maxTextWidth, subheader1Size.x);
        maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(subheader2).x);
    }
    // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank1).x);
    // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank2).x);
    // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank3).x);
    // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank4_10).x);
    // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank11_50).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank51_100).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank101_250).x);

    if (edition > 1)
        maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank251Plus).x);
    else {
        // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank251_500).x);
        // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank501_1000).x);
        maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank1001_2500).x);
        // maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank2501Plus).x);
    }

    if (S_Background) {
        nvg::FillColor(S_BackgroundColor);
        nvg::BeginPath();
        nvg::RoundedRect(
            posX,
            posY,
            maxTextWidth + S_BackgroundXPad * 2.0f,
            rank1OffsetY + subheader1Size.y * (edition > 1 ? 8.0f : 11.0f) + S_BackgroundYPad * 2.0f,
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
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y,
        rank2
    );

    nvg::FillColor(qualiRank == 3 ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 2.0f,
        rank3
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 4, 10) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 3.0f,
        rank4_10
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 11, 50) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 4.0f,
        rank11_50
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 51, 100) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 5.0f,
        rank51_100
    );

    nvg::FillColor(IsBetweenInclusive(qualiRank, 101, 250) ? S_FontHighlightColor : S_FontColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 6.0f,
        rank101_250
    );

    if (edition > 1) {
        nvg::FillColor(qualiRank > 250 ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 7.0f,
            rank251Plus
        );
    } else {
        nvg::FillColor(IsBetweenInclusive(qualiRank, 251, 500) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 7.0f,
            rank251_500
        );

        nvg::FillColor(IsBetweenInclusive(qualiRank, 501, 1000) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 8.0f,
            rank501_1000
        );

        nvg::FillColor(IsBetweenInclusive(qualiRank, 1001, 2500) ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 9.0f,
            rank1001_2500
        );

        nvg::FillColor(qualiRank > 2500 ? S_FontHighlightColor : S_FontColor);
        nvg::Text(
            posMidWidth,
            posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 10.0f,
            rank2501Plus
        );
    }
}

void RenderKnockout() {
    if (!S_Knockout || gameMode != "TM_KnockoutDaily_Online")
        return;

    SetKoInfo();

    const float posX = Display::GetWidth() * S_X;
    const float posY = Display::GetHeight() * S_Y;

    nvg::FontFace(font);

    nvg::FontSize(S_HeaderFontSize);
    const string header = Icons::Trophy + " COT" + (edition == 1 ? "D" : edition == 2 ? "N" : edition == 3 ? "M" : "?") + " Knockout";
    const vec2 headerSize = nvg::TextBounds(header);

    nvg::FontSize(S_FontSize);

    const int totalDivisions = int(Math::Ceil(float(totalPlayers) / 64.0f));

    const string subheader1 = "Remaining " + playersLeft + " / " + (division == totalDivisions ? totalPlayers % 64 : 64);
    const vec2 subheader1Size = nvg::TextBounds(subheader1);
    const float subheader1OffsetY = S_Header ? headerSize.y + S_HeaderFontSize * 0.4f : 0.0f;

    const string subheader2 = "Division " + division + " / " + totalDivisions;
    const float subheader2OffsetY = subheader1OffsetY + subheader1Size.y;

    const string rank1      = "1: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 1,  edition > 1));
    const string rank2      = "2: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 2,  edition > 1));
    const string rank3      = "3: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 3,  edition > 1));
    const string rank4_8    = "4-8: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 4,  edition > 1));
    const string rank9_32   = "9-32: " + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 9,  edition > 1));
    const string rank33Plus = "33+: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 33, edition > 1));

    const float rank1OffsetY = S_Subheader ? subheader2OffsetY + subheader1Size.y * 1.5f : subheader1OffsetY;

    float maxTextWidth = 0.0f;
    if (S_Header)
        maxTextWidth = headerSize.x;
    if (S_Subheader) {
        maxTextWidth = Math::Max(maxTextWidth, subheader1Size.x);
        maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(subheader2).x);
    }
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank1).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank2).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank3).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank4_8).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank9_32).x);
    maxTextWidth = Math::Max(maxTextWidth, nvg::TextBounds(rank33Plus).x);

    if (S_Background) {
        nvg::FillColor(S_BackgroundColor);
        nvg::BeginPath();
        nvg::RoundedRect(
            posX,
            posY,
            maxTextWidth + S_BackgroundXPad * 2.0f,
            rank1OffsetY + subheader1Size.y * 6.0f + S_BackgroundYPad * 2.0f,
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
        // players left / players in division
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

    nvg::FillColor(gottenRank == 1 ? S_FontHighlightColor : alive ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY,
        rank1
    );

    nvg::FillColor(gottenRank == 2 ? S_FontHighlightColor : alive ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y,
        rank2
    );

    nvg::FillColor(gottenRank == 3 ? S_FontHighlightColor : alive && playersLeft > 2 ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 2.0f,
        rank3
    );

    nvg::FillColor(IsBetweenInclusive(gottenRank, 4, 8) ? S_FontHighlightColor : alive && playersLeft > 3 ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 3.0f,
        rank4_8
    );

    nvg::FillColor(IsBetweenInclusive(gottenRank, 9, 32) ? S_FontHighlightColor : alive && playersLeft > 8 ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 4.0f,
        rank9_32
    );

    nvg::FillColor(gottenRank > 32 ? S_FontHighlightColor : alive && playersLeft > 32 ? S_FontColor : S_FontDisabledColor);
    nvg::Text(
        posMidWidth,
        posY + S_BackgroundYPad + rank1OffsetY + subheader1Size.y * 5.0f,
        rank33Plus
    );
}
