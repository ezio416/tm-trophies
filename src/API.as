// c 2024-02-29
// m 2024-03-03

uint         challengeId         = 0;
uint         edition             = 0;
const string mapMonitorUrl       = "https://map-monitor.xk.io/cached";
string       name;
uint64       nextRequest         = 0;
bool         rerun               = false;
uint         totalPlayers        = 0;
const uint   totalPlayersDefault = 3000;
const uint64 waitTime            = 15000;

void SetCotdInfo() {
    uint64 now = Time::Now;

    if (now < nextRequest)
        return;

    nextRequest = now + waitTime + Math::Rand(0, 5000);

    print("SetCotdInfo");

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
        edition = uint(info["edition"]);
        rerun = edition > 1;
    } else {
        warn("response missing key 'edition'");
        edition = 0;
        rerun = false;
        return;
    }

    if (info.HasKey("competition")) {
        Json::Value@ competition = info["competition"];

        if (competition.HasKey("name"))
            name = string(competition["name"]);
        else {
            warn("competition missing key 'name'");
            name = "";
            totalPlayers = totalPlayersDefault;
            return;
        }

        if (competition.HasKey("nbPlayers"))
            totalPlayers = uint(competition["nbPlayers"]);
        else {
            warn("competition missing key 'nbPlayers'");
            totalPlayers = totalPlayersDefault;
            return;
        }
    } else {
        warn("response missing key 'competition'");
        name = "";
        totalPlayers = totalPlayersDefault;
        return;
    }

    if (totalPlayers == totalPlayersDefault) {
        print("getting total players another way");

        if (info.HasKey("challenge")) {
            Json::Value@ challenge = info["challenge"];

            if (challenge.HasKey("id"))
                challengeId = uint(challenge["id"]);
            else {
                warn("challenge missing key 'id'");
                challengeId = 0;
                return;
            }
        } else {
            warn("response missing key 'challenge'");
            challengeId = 0;
            return;
        }

        CTrackMania@ App = cast<CTrackMania@>(GetApp());
        CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);

        @req = Net::HttpGet(mapMonitorUrl + "/api/challenges/" + challengeId + "/records/maps/" + App.RootMap.EdChallengeId + "/players?players[]=" + Network.PlayerInfo.WebServicesUserId);
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
            totalPlayers = uint(info["cardinal"]);
        else {
            warn("response missing key 'cardinal'");
            totalPlayers = totalPlayersDefault;
            return;
        }
    }
}