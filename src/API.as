// c 2024-02-29
// m 2024-03-01

const string audienceLive = "NadeoLiveServices";
string       lastCotd;
uint64       lastRequest  = 0;
bool         rerun        = false;
uint         totalPlayers = 0;
const uint64 waitTime     = 15000;

void SetCotdInfo() {
    uint64 now = Time::Now;

    if (now - lastRequest < waitTime)
        return;

    lastRequest = now;

    print("SetCotdInfo");

    while (!NadeoServices::IsAuthenticated(audienceLive))
        yield();

    Net::HttpRequest@ req = NadeoServices::Get(audienceLive, NadeoServices::BaseURLMeet() + "api/cup-of-the-day/current");
    req.Start();

    // Net::HttpRequest@ req = Net::HttpGet("https://map-monitor.xk.io/cached/api/cup-of-the-day/current");

    while (!req.Finished())
        yield();

    int code = req.ResponseCode();
    string text = req.String();

    if (code != 200) {
        warn("bad API response (" + code + "): " + text);
        return;
    }

    Json::Value@ info;

    try {
        @info = Json::Parse(text);
    } catch {
        error(getExceptionInfo());
        warn("bad API response: " + text);
        return;
    }

    string name = string(info["competition"]["name"]);
    if (name == lastCotd)
        return;

    rerun = !name.EndsWith("#1");
    lastCotd = name;

    totalPlayers = uint(info["competition"]["nbPlayers"]);

    gotCotdInfo = true;
}