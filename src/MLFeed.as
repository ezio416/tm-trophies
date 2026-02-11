bool alive        = false;
int  division     = 0;
int  divisionRank = 0;
int  gottenRank   = 0;
int  playersLeft  = 0;
int  qualiRank    = 0;
bool wasAlive     = false;

int GetQualiRank() {
    const MLFeed::HookRaceStatsEventsBase_V4@ raceData = MLFeed::GetRaceData_V4();
    if (raceData is null)
        return 0;

    return raceData.COTDQ_Rank;
}

void SetKoInfo() {
    const MLFeed::KoDataProxy@ koData = MLFeed::GetKoData();
    if (koData is null) {
        division = 0;
        divisionRank = 0;
        playersLeft = 0;
    }

    division = Math::Max(0, koData.Division);
    playersLeft = Math::Max(0, koData.PlayersNb);

    const MLFeed::KoPlayerState@ player = koData.GetPlayerState(myName);
    if (player is null || player.MainState is null) {
        divisionRank = 0;
        wasAlive = false;
        return;
    }

    alive = player.isAlive;

    if (alive) {
        divisionRank = player.MainState.raceRank;
        wasAlive = true;
    } else {
        if (wasAlive) {
            gottenRank = divisionRank;

            string msg = "got rank " + divisionRank + " of div " + division;
            print(msg);
            UI::ShowNotification(title, msg);
        }

        wasAlive = false;
    }
}
