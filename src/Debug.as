int        debugCotdKnockoutDiv     = 0;
int        debugCotdKnockoutDivRank = 0;
int        debugCotdKnockoutPlayers = 0;
int        debugCotdQualiRank       = 0;
bool       debugCotdRerun           = false;
const vec4 rowBgAltColor            = vec4(0.0f, 0.0f, 0.0f, 0.5f);

void RenderDebug() {
    if (!S_Debug)
        return;

    const int flags = UI::GetDefaultWindowFlags()
        | UI::WindowFlags::AlwaysAutoResize
        | UI::WindowFlags::NoFocusOnAppearing
    ;

    if (UI::Begin(title + " (Debug)", S_Debug, flags)) {
        if (UI::BeginTable("##table-debug", 2, UI::TableFlags::RowBg)) {
            UI::PushStyleColor(UI::Col::TableRowBgAlt, rowBgAltColor);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("cup name");
            UI::TableNextColumn();
            UI::Text(name);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("challenge ID");
            UI::TableNextColumn();
            UI::Text(tostring(challengeId));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("edition");
            UI::TableNextColumn();
            UI::Text(tostring(edition));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("rerun");
            UI::TableNextColumn();
            UI::Text(tostring(edition > 1));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("total players");
            UI::TableNextColumn();
            UI::Text(tostring(totalPlayers));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("qualifier rank");
            UI::TableNextColumn();
            UI::Text(tostring(qualiRank));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("division");
            UI::TableNextColumn();
            UI::Text(tostring(division));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("division rank");
            UI::TableNextColumn();
            UI::Text(tostring(divisionRank));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("players left");
            UI::TableNextColumn();
            UI::Text(tostring(playersLeft));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("alive");
            UI::TableNextColumn();
            UI::Text(tostring(alive));

            UI::TableNextRow();

            UI::PopStyleColor();
            UI::EndTable();
        }

        UI::BeginTabBar("##tabs");
            Tab_CotdQuali();
            Tab_CotdKnockout();
            Tab_RaceData();
            Tab_KoData();
        UI::EndTabBar();
    }

    UI::End();
}

void Tab_CotdQuali() {
    if (!UI::BeginTabItem("COTD Qualifier"))
        return;

    debugCotdRerun = UI::Checkbox("rerun", debugCotdRerun);
    debugCotdQualiRank = UI::InputInt("rank", debugCotdQualiRank);

    UI::Text("trophies for rank " + debugCotdQualiRank + ": " + InsertSeparators(CotdQualifierTrophies(debugCotdQualiRank, debugCotdRerun)));

    UI::EndTabItem();
}

void Tab_CotdKnockout() {
    if (!UI::BeginTabItem("COTD Knockout"))
        return;

    debugCotdRerun = UI::Checkbox("rerun", debugCotdRerun);
    debugCotdKnockoutPlayers = UI::InputInt("players", debugCotdKnockoutPlayers);
    debugCotdKnockoutDiv     = UI::InputInt("div", debugCotdKnockoutDiv);
    debugCotdKnockoutDivRank = UI::InputInt("div rank", debugCotdKnockoutDivRank);

    const string numTrophies = InsertSeparators(CotdKnockoutTrophies(debugCotdKnockoutPlayers, debugCotdKnockoutDiv, debugCotdKnockoutDivRank, debugCotdRerun));
    UI::Text("trophies for rank " + debugCotdKnockoutDivRank + " of div " + debugCotdKnockoutDiv + ": " + numTrophies);

    UI::EndTabItem();
}

void Tab_KoData() {
    if (!UI::BeginTabItem("KO Data"))
        return;

    const MLFeed::KoDataProxy@ koData = MLFeed::GetKoData();
    if (koData !is null) {
        if (UI::BeginTable("##table-koData", 2, UI::TableFlags::RowBg)) {
            UI::PushStyleColor(UI::Col::TableRowBgAlt, rowBgAltColor);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("Division");
            UI::TableNextColumn();
            UI::Text(tostring(koData.Division));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("GameMode");
            UI::TableNextColumn();
            UI::Text(koData.GameMode);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("KOsMilestone");
            UI::TableNextColumn();
            UI::Text(tostring(koData.KOsMilestone));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("KOsNumber");
            UI::TableNextColumn();
            UI::Text(tostring(koData.KOsNumber));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("Map");
            UI::TableNextColumn();
            UI::Text(koData.Map);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("MapRoundNb");
            UI::TableNextColumn();
            UI::Text(tostring(koData.MapRoundNb));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("MapRoundTotal");
            UI::TableNextColumn();
            UI::Text(tostring(koData.MapRoundTotal));

            // UI::TableNextRow();
            // UI::TableNextColumn();
            // UI::Text("Players");
            // UI::TableNextColumn();
            // UI::Text(tostring(koData.Players));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("PlayersNb");
            UI::TableNextColumn();
            UI::Text(tostring(koData.PlayersNb));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("RoundNb");
            UI::TableNextColumn();
            UI::Text(tostring(koData.RoundNb));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("RoundTotal");
            UI::Separator();
            UI::TableNextColumn();
            UI::Text(tostring(koData.RoundTotal));
            UI::Separator();

            const MLFeed::KoPlayerState@ playerState = koData.GetPlayerState(myName);
            if (playerState !is null) {
                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text("isAlive");
                UI::TableNextColumn();
                UI::Text(tostring(playerState.isAlive));

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text("isDNF");
                UI::TableNextColumn();
                UI::Text(tostring(playerState.isDNF));

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text("name");
                UI::Separator();
                UI::TableNextColumn();
                UI::Text(playerState.name);
                UI::Separator();

                MLFeed::PlayerCpInfo@ cpInfo = playerState.MainState;
                if (cpInfo !is null)
                    Table_CpInfo(cpInfo);
                else {
                    UI::TableNextRow();
                    UI::TableNextColumn();
                    UI::Text("PlayerCpInfo");
                    UI::TableNextColumn();
                    UI::Text("\\$F00null");
                }
            } else {
                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text("KoPlayerState");
                UI::TableNextColumn();
                UI::Text("\\$F70null");
            }

            UI::TableNextRow();

            UI::PopStyleColor();
            UI::EndTable();
        }
    } else
        UI::Text("\\$F70koData null");

    UI::EndTabItem();
}

void Tab_RaceData() {
    if (!UI::BeginTabItem("Race Data"))
        return;

    const MLFeed::HookRaceStatsEventsBase_V4@ raceData = MLFeed::GetRaceData_V4();
    if (raceData !is null) {
        if (UI::BeginTable("##table-raceData", 2, UI::TableFlags::RowBg)) {
            UI::PushStyleColor(UI::Col::TableRowBgAlt, rowBgAltColor);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_APIRaceTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_APIRaceTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_IsSynchronizingRecord");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_IsSynchronizingRecord));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_LocalRaceTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_LocalRaceTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_QualificationsJoinTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_QualificationsJoinTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_QualificationsProgress");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_QualificationsProgress));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_Rank");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_Rank));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("COTDQ_UpdateNonce");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.COTDQ_UpdateNonce));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("CPCount");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.CPCount));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("CPsToFinish");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.CPsToFinish));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("CpCount");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.CpCount));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("LapCount");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.LapCount));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("LapCount_Accurate");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.LapCount_Accurate));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("LapsNb");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.LapsNb));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("LastRecordTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.LastRecordTime));

            // UI::TableNextRow();
            // UI::TableNextColumn();
            // UI::Text("Map");
            // UI::TableNextColumn();
            // UI::Text(raceData.Map);

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("Rules_EndTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.Rules_EndTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("Rules_GameTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.Rules_GameTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("Rules_StartTime");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.Rules_StartTime));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("SpawnCounter");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.SpawnCounter));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("UpdateNonce");
            UI::TableNextColumn();
            UI::Text(tostring(raceData.UpdateNonce));

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text("lastMap");
            UI::Separator();
            UI::TableNextColumn();
            UI::Text(raceData.lastMap);
            UI::Separator();

            // UI::TableNextRow();
            // UI::TableNextColumn();
            // UI::Text("latestPlayerStats");
            // UI::TableNextColumn();
            // UI::Text(tostring(raceData.latestPlayerStats));

            // UI::TableNextRow();
            // UI::TableNextColumn();
            // UI::Text("type");
            // UI::TableNextColumn();
            // UI::Text(raceData.type);

            const MLFeed::PlayerCpInfo_V4@ cpInfo = raceData.GetPlayer_V4(myName);
            if (cpInfo !is null)
                Table_CpInfo(cpInfo);
            else {
                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text("PlayerCpInfo");
                UI::TableNextColumn();
                UI::Text("\\$F00null");
            }

            UI::TableNextRow();

            UI::PopStyleColor();
            UI::EndTable();
        }
    }

    UI::EndTabItem();
}

void Table_CpInfo(const MLFeed::PlayerCpInfo@ cpInfo) {
    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("name");
    UI::TableNextColumn();
    UI::Text(cpInfo.name);

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("IsFinished");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.IsFinished));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("IsSpawned");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.IsSpawned));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("UpdateNonce");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.UpdateNonce));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("bestTime");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.bestTime));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("cpCount");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.cpCount));

    // UI::TableNextRow();
    // UI::TableNextColumn();
    // UI::Text("cpTimes");
    // UI::TableNextColumn();
    // UI::Text(tostring(cpInfo.cpTimes));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("lastCpTime");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.lastCpTime));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("name");
    UI::TableNextColumn();
    UI::Text(cpInfo.name);

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("raceRank");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.raceRank));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("spawnIndex");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.spawnIndex));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("spawnStatus");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.spawnStatus));

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::Text("taRank");
    UI::TableNextColumn();
    UI::Text(tostring(cpInfo.taRank));
}
