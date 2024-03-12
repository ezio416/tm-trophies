// c 2024-02-29
// m 2024-03-11

int          challengeId         = 0;
int          edition             = 0;
const string mapMonitorUrl       = "https://map-monitor.xk.io/cached";
string       name;
uint64       nextRequest         = 0;
int          totalPlayers        = 0;
const int    totalPlayersDefault = 3000;
const uint64 waitTime            = 15000;

void SetCotdInfo() {
    uint64 now = Time::Now;

    if (now < nextRequest)
        return;

    nextRequest = now + waitTime + Math::Rand(0, 5000);

    Net::HttpRequest@ req = Net::HttpGet(mapMonitorUrl + "/api/cup-of-the-day/current");

    while (!req.Finished())
        yield();

    int code = req.ResponseCode();
    string text = req.String();

    if (code != 200) {
        warn("bad first API response (" + code + "): " + text);
        return;
    }

    Json::Value@ info;

    try {
        @info = Json::Parse(text);
        Json::Type type = info.GetType();
        if (type != Json::Type::Object)
            throw("JSON value is not an object, rather a(n) " + tostring(type));
    } catch {
        error(getExceptionInfo());
        warn("bad first API response: " + text);
        return;
    }

    if (info.HasKey("edition")) {
        edition = int(info["edition"]);
    } else {
        warn("response missing key 'edition'");
        edition = 0;
        return;
    }

    if (info.HasKey("competition")) {
        Json::Value@ competition = info["competition"];

        if (competition.HasKey("name"))
            name = string(competition["name"]);
        else {
            warn("competition missing key 'name'");
            name = "";
            totalPlayers = 0;
            return;
        }

        if (competition.HasKey("nbPlayers"))
            totalPlayers = int(competition["nbPlayers"]);
        else {
            warn("competition missing key 'nbPlayers'");
            totalPlayers = 0;
            return;
        }
    } else {
        warn("response missing key 'competition'");
        name = "";
        totalPlayers = 0;
        return;
    }

    if (info.HasKey("challenge")) {
        Json::Value@ challenge = info["challenge"];

        if (challenge.HasKey("id"))
            challengeId = int(challenge["id"]);
        else {
            warn("challenge missing key 'id'");
            challengeId = 0;
        }
    } else {
        warn("response missing key 'challenge'");
        challengeId = 0;
    }

    if (totalPlayers == 0) {
        totalPlayers = totalPlayersDefault;

        trace("got 0 players, trying another way");

        CTrackMania@ App = cast<CTrackMania@>(GetApp());
        if (App.RootMap is null) {
            warn("not in a map");
            return;
        }

        @req = Net::HttpGet(mapMonitorUrl + "/api/challenges/" + challengeId + "/records/maps/" + App.RootMap.EdChallengeId + "/players?players[]=" + myUserId);
        while (!req.Finished())
            yield();

        code = req.ResponseCode();
        text = req.String();

        if (code != 200) {
            warn("bad second API response (" + code + "): " + text);
            return;
        }

        try {
            @info = Json::Parse(text);
            Json::Type type = info.GetType();
            if (type != Json::Type::Object)
                throw("JSON value is not an object, rather a(n) " + tostring(type));
        } catch {
            error(getExceptionInfo());
            warn("bad second API response: " + text);
            return;
        }

        if (info.HasKey("cardinal"))
            totalPlayers = int(info["cardinal"]);
        else
            warn("response missing key 'cardinal'");
    }
}