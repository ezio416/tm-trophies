// c 2024-02-29
// m 2024-02-29

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

    Net::HttpRequest@ req = Net::HttpGet("https://map-monitor.xk.io/cached/api/cup-of-the-day/current");
    while (!req.Finished())
        yield();

    int code = req.ResponseCode();
    string text = req.String();

    if (code != 200) {
        warn("bad response (" + code + ") from map monitor: " + text);
        return;
    }

    Json::Value@ info;

    try {
        @info = Json::Parse(text);
    } catch {
        error(getExceptionInfo());
        warn("bad response from map monitor: " + text);
        return;
    }

    string name = string(info["competition"]["name"]);
    rerun = !name.EndsWith("#1");

    totalPlayers = uint(info["competition"]["nbPlayers"]);
}