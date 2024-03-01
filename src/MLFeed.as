// c 2024-02-29
// m 2024-02-29

uint division     = 0;
uint divisionRank = 0;
uint playersLeft  = 0;
uint qualiRank    = 0;
bool wasAlive     = false;

uint GetQualiRank() {
    const MLFeed::HookRaceStatsEventsBase_V4@ raceData = MLFeed::GetRaceData_V4();
    if (raceData is null)
        return 0;

    return raceData.COTDQ_Rank;
}

void SetKoValues() {
    const MLFeed::KoDataProxy@ koData = MLFeed::GetKoData();
    if (koData is null) {
        division = 0;
        divisionRank = 0;
        playersLeft = 0;
    }

    division = koData.Division;
    playersLeft = koData.PlayersNb;

    const MLFeed::KoPlayerState@ player = koData.GetPlayerState(myName);
    if (player is null || player.MainState is null) {
        divisionRank = 0;
        wasAlive = false;
        return;
    }

    if (player.isAlive) {
        divisionRank = player.MainState.raceRank;
        wasAlive = true;
    } else {
        if (wasAlive)
            print("got rank " + divisionRank + " of div " + division);

        wasAlive = false;
    }
}