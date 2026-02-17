// c 2024-05-06
// m 2024-06-08

uint              addedTrophies    = 0;
uint              currentTrophies  = 0;
TrophyGain@[]     gains;
bool              gettingHistory   = false;
uint              lifetimeTrophies = 0;
uint              permaTrophies    = 0;
const float       scale            = UI::GetScale();
SQLite::Database@ timeDB           = SQLite::Database(":memory:");

void RenderHistory() {
    if (!S_History)
        return;

    if (UI::Begin(title + " (History)", S_History, UI::WindowFlags::None)) {
        UI::BeginDisabled(gettingHistory);
        if (UI::Button("Get History (" + gains.Length + ")"))
            startnew(GetHistory);
        UI::EndDisabled();

        UI::Text("Current: "   + InsertSeparators(currentTrophies));
        UI::Text("Permanent: " + InsertSeparators(permaTrophies));
        UI::Text("Lifetime: "  + InsertSeparators(lifetimeTrophies));

        if (UI::BeginTable("##table-history", 3, UI::TableFlags::RowBg | UI::TableFlags::Sortable | UI::TableFlags::ScrollY)) {
            UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

            UI::TableSetupScrollFreeze(0, 1);
            // UI::TableSetupColumn("#",       UI::TableColumnFlags::WidthFixed, scale * 35.0f);
            UI::TableSetupColumn("timestamp", UI::TableColumnFlags::WidthFixed,                                scale * 160.0f);
            UI::TableSetupColumn("amount",    UI::TableColumnFlags::WidthFixed,                                scale * 80.0f);
            UI::TableSetupColumn("expired",   UI::TableColumnFlags::WidthFixed | UI::TableColumnFlags::NoSort, scale * 45.0f);
            UI::TableHeadersRow();

            UI::ListClipper clipper(gains.Length);
            while (clipper.Step()) {
                for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                    TrophyGain@ gain = gains[i];

                    UI::TableNextRow();

                    // UI::TableNextColumn();
                    // UI::Text(tostring(i));

                    UI::TableNextColumn();
                    UI::Text(gain.timestampIso);

                    UI::TableNextColumn();
                    UI::Text(InsertSeparators(gain.trophyTotal));

                    UI::TableNextColumn();
                    UI::Text(tostring(gain.expired));
                }
            }

            UI::PopStyleColor();
            UI::EndTable();
        }
    }

    UI::End();
}

void GetHistory() {
    if (gettingHistory)
        return;

    gettingHistory = true;

    NadeoServices::AddAudience("NadeoServices");

    currentTrophies  = 0;
    gains            = {};
    lifetimeTrophies = 0;
    permaTrophies    = 0;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    // const string id  = App.LocalPlayerInfo.WebServicesUserId;
    const string id = "8f08302a-f670-463b-9f71-fbfacffb8bd1";  // down 148,127
    // const string id = "2343ca67-a77c-47c8-83bd-74f99c6f0a37";  // hobbit
    // const string id = "a6ae76c9-9030-4a7b-b533-cacfd6e85cb2";  // shcr 2,342
    // const string id = "3bb0d130-637d-46a6-9c19-87fe4bda3c52";  // spam
    // const string id = "4bb5de94-1093-4b17-8776-afe9773fee4a";  // eddie
    // const string id = "c0d0d93b-8396-40dd-a928-377c436e8a70";  // soliva
    // const string id = "2ed0997d-62bc-4a53-8c09-ffb793382ea2";  // riolu 10,999
    // const string id = "da4642f9-6acf-43fe-88b6-b120ff1308ba";  // scrapie 10,629
    // const string id = "b981e0b1-2d6a-4470-9b52-c1f6b0b1d0a6";  // lingo 25,904
    // const string id = "2016f67a-0814-42ed-bea8-2e75da48840d";  // ike 185
    // const string id = "794a286c-44d9-4276-83ce-431cba7bab74";  // marius 127,099

    while (!NadeoServices::IsAuthenticated("NadeoServices"))
        yield();

    Net::HttpRequest@ req = NadeoServices::Get(
        "NadeoServices",
        NadeoServices::BaseURLCore() + "/accounts/" + id + "/trophies/lastYearSummary"
    );

    req.Start();
    while (!req.Finished())
        yield();

    int    code = req.ResponseCode();
    string msg  = req.String();

    if (code != 200) {
        warn("error getting trophy summary: code (" + code + ") msg (" + msg + ") error (" + req.Error() + ")");
        gettingHistory = false;
        return;
    }

    Json::Value@ resp;
    try {
        @resp = Json::Parse(msg);
    } catch {
        warn("error parsing data: " + msg);
        gettingHistory = false;
        return;
    }

    const uint summaryTrophies = uint(resp["points"]);

    const uint count  = 2000;
    uint       offset = 0;

    while (true) {
        sleep(500);

        @req = NadeoServices::Get(
            "NadeoServices",
            NadeoServices::BaseURLCore() + "/accounts/" + id + "/trophies?offset=" + offset + "&count=" + count
        );

        req.Start();
        while (!req.Finished())
            yield();

        code = req.ResponseCode();
        msg  = req.String();

        if (code != 200) {
            warn("error getting trophy history: code (" + code + ") msg (" + msg + ") error (" + req.Error() + ")");
            gettingHistory = false;
            return;
        }

        Json::Value@ resp;
        try {
            @resp = Json::Parse(msg);
        } catch {
            warn("error parsing data: " + msg);
            gettingHistory = false;
            return;
        }

        if (resp.GetType() != Json::Type::Object) {
            warn("msg is not an Object: " + msg);
            gettingHistory = false;
            return;
        }

        if (!resp.HasKey("data")) {
            warn("msg missing key 'data'");
            gettingHistory = false;
            return;
        }

        Json::Value@ data = resp["data"];

        if (data.GetType() != Json::Type::Array) {
            warn("data is not an Array");
            gettingHistory = false;
            return;
        }

        const uint total = data.Length;

        for (uint i = 0; i < total; i++) {
            TrophyGain@ gain = TrophyGain(data[i]);

            lifetimeTrophies += gain.trophyTotal;

            if (!gain.expired)
                addedTrophies += gain.trophyTotal;

            gains.InsertLast(gain);
        }

        if (total < count)
            break;

        offset += count;
    }

    currentTrophies = summaryTrophies;
    permaTrophies = summaryTrophies - addedTrophies;

    gettingHistory = false;
}

// courtesy of MisfitMaid
int64 IsoToUnix(const string &in inTime) {
    SQLite::Statement@ s = timeDB.Prepare("SELECT unixepoch(?) as x");
    s.Bind(1, inTime);
    s.Execute();
    s.NextRow();
    s.NextRow();
    return s.GetColumnInt64("x");
}

string UnixToIso(uint timestamp) {
    return Time::FormatString("%Y-%m-%d \\$AAA@ \\$G%H:%M:%S \\$G", timestamp);
}

class TrophyGain {
    uint   t1            = 0;
    uint   t2            = 0;
    uint   t3            = 0;
    uint   t4            = 0;
    uint   t5            = 0;
    uint   t6            = 0;
    uint   t7            = 0;
    uint   t8            = 0;
    uint   t9            = 0;
    string timestampIso;
    uint   timestampUnix = 0;
    uint   trophyTotal   = 0;

    TrophyGain() { }
    TrophyGain(Json::Value@ data) {
        t1 = int(data["t1Count"]);
        trophyTotal += trophy1 * t1;

        t2 = int(data["t2Count"]);
        trophyTotal += trophy2 * t2;

        t3 = int(data["t3Count"]);
        trophyTotal += trophy3 * t3;

        t4 = int(data["t4Count"]);
        trophyTotal += trophy4 * t4;

        t5 = int(data["t5Count"]);
        trophyTotal += trophy5 * t5;

        t6 = int(data["t6Count"]);
        trophyTotal += trophy6 * t6;

        t7 = int(data["t7Count"]);
        trophyTotal += trophy7 * t7;

        t8 = int(data["t8Count"]);
        trophyTotal += trophy8 * t8;

        t9 = int(data["t9Count"]);
        trophyTotal += trophy9 * t9;

        timestampUnix = IsoToUnix(string(data["timestamp"]));
        timestampIso = UnixToIso(timestampUnix);
    }

    bool get_expired() {
        return Time::Stamp - timestampUnix > 365 * 86400;
    }
}
