// c 2024-02-26
// m 2024-02-29

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

void Tab_KoData() {
    if (!UI::BeginTabItem("KO Data"))
        return;

    const MLFeed::KoDataProxy@ koData = MLFeed::GetKoData();
    if (koData !is null) {
        if (UI::BeginTable("##koData-table", 2, UI::TableFlags::Resizable | UI::TableFlags::ScrollY)) {
            UI::TableSetupScrollFreeze(0, 1);
            UI::TableSetupColumn("variable");
            UI::TableSetupColumn("value");
            UI::TableHeadersRow();

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("Division");
            UI::TableNextColumn(); UI::Text(tostring(koData.Division));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("GameMode");
            UI::TableNextColumn(); UI::Text(koData.GameMode);

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("KOsMilestone");
            UI::TableNextColumn(); UI::Text(tostring(koData.KOsMilestone));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("KOsNumber");
            UI::TableNextColumn(); UI::Text(tostring(koData.KOsNumber));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("Map");
            UI::TableNextColumn(); UI::Text(koData.Map);

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("MapRoundNb");
            UI::TableNextColumn(); UI::Text(tostring(koData.MapRoundNb));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("MapRoundTotal");
            UI::TableNextColumn(); UI::Text(tostring(koData.MapRoundTotal));

            // UI::TableNextRow();
            // UI::TableNextColumn(); UI::Text("Players");
            // UI::TableNextColumn(); UI::Text(tostring(koData.Players));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("PlayersNb");
            UI::TableNextColumn(); UI::Text(tostring(koData.PlayersNb));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("RoundNb");
            UI::TableNextColumn(); UI::Text(tostring(koData.RoundNb));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("RoundTotal");
            UI::TableNextColumn(); UI::Text(tostring(koData.RoundTotal));

            UI::Separator();

            const MLFeed::KoPlayerState@ playerState = koData.GetPlayerState(myName);
            if (playerState !is null) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("isAlive");
                UI::TableNextColumn(); UI::Text(tostring(playerState.isAlive));

                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("isDNF");
                UI::TableNextColumn(); UI::Text(tostring(playerState.isDNF));

                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("name");
                UI::TableNextColumn(); UI::Text(playerState.name);

                UI::Separator();

                MLFeed::PlayerCpInfo@ cpInfo = playerState.MainState;
                if (cpInfo !is null)
                    TableCpInfo(cpInfo);
                else {
                    UI::TableNextRow();
                    UI::TableNextColumn(); UI::Text("PlayerCpInfo");
                    UI::TableNextColumn(); UI::Text("\\$F00null");
                }
            } else {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("KoPlayerState");
                UI::TableNextColumn(); UI::Text("\\$F70null");
            }

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
        if (UI::BeginTable("##raceData-table", 2, UI::TableFlags::Resizable | UI::TableFlags::ScrollY)) {
            UI::TableSetupScrollFreeze(0, 1);
            UI::TableSetupColumn("variable");
            UI::TableSetupColumn("value");
            UI::TableHeadersRow();

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_APIRaceTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_APIRaceTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_IsSynchronizingRecord");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_IsSynchronizingRecord));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_LocalRaceTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_LocalRaceTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_QualificationsJoinTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_QualificationsJoinTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_QualificationsProgress");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_QualificationsProgress));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_Rank");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_Rank));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("COTDQ_UpdateNonce");
            UI::TableNextColumn(); UI::Text(tostring(raceData.COTDQ_UpdateNonce));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("CPCount");
            UI::TableNextColumn(); UI::Text(tostring(raceData.CPCount));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("CPsToFinish");
            UI::TableNextColumn(); UI::Text(tostring(raceData.CPsToFinish));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("CpCount");
            UI::TableNextColumn(); UI::Text(tostring(raceData.CpCount));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("LapCount");
            UI::TableNextColumn(); UI::Text(tostring(raceData.LapCount));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("LapCount_Accurate");
            UI::TableNextColumn(); UI::Text(tostring(raceData.LapCount_Accurate));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("LapsNb");
            UI::TableNextColumn(); UI::Text(tostring(raceData.LapsNb));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("LastRecordTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.LastRecordTime));

            // UI::TableNextRow();
            // UI::TableNextColumn(); UI::Text("Map");
            // UI::TableNextColumn(); UI::Text(raceData.Map);

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("Rules_EndTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.Rules_EndTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("Rules_GameTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.Rules_GameTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("Rules_StartTime");
            UI::TableNextColumn(); UI::Text(tostring(raceData.Rules_StartTime));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("SpawnCounter");
            UI::TableNextColumn(); UI::Text(tostring(raceData.SpawnCounter));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("UpdateNonce");
            UI::TableNextColumn(); UI::Text(tostring(raceData.UpdateNonce));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("lastMap");
            UI::TableNextColumn(); UI::Text(raceData.lastMap);

            // UI::TableNextRow();
            // UI::TableNextColumn(); UI::Text("latestPlayerStats");
            // UI::TableNextColumn(); UI::Text(tostring(raceData.latestPlayerStats));

            // UI::TableNextRow();
            // UI::TableNextColumn(); UI::Text("type");
            // UI::TableNextColumn(); UI::Text(raceData.type);

            UI::Separator();

            const MLFeed::PlayerCpInfo@ cpInfo = raceData.GetPlayer_V2(myName);
            if (cpInfo !is null)
                TableCpInfo(cpInfo);
            else {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("PlayerCpInfo");
                UI::TableNextColumn(); UI::Text("\\$F00null");
            }

            UI::EndTable();
        }
    }

    UI::EndTabItem();
}

void TableCpInfo(const MLFeed::PlayerCpInfo@ cpInfo) {
    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("name");
    UI::TableNextColumn(); UI::Text(cpInfo.name);

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("IsFinished");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.IsFinished));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("IsSpawned");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.IsSpawned));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("UpdateNonce");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.UpdateNonce));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("bestTime");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.bestTime));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("cpCount");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.cpCount));

    // UI::TableNextRow();
    // UI::TableNextColumn(); UI::Text("cpTimes");
    // UI::TableNextColumn(); UI::Text(tostring(cpInfo.cpTimes));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("lastCpTime");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.lastCpTime));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("name");
    UI::TableNextColumn(); UI::Text(cpInfo.name);

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("raceRank");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.raceRank));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("spawnIndex");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.spawnIndex));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("spawnStatus");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.spawnStatus));

    UI::TableNextRow();
    UI::TableNextColumn(); UI::Text("taRank");
    UI::TableNextColumn(); UI::Text(tostring(cpInfo.taRank));
}