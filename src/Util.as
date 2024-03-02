// c 2024-02-16
// m 2024-03-01

const string BLUE   = "\\$09D";
const string CYAN   = "\\$2FF";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";

string InsertSeparators(int num) {
    int abs = Math::Abs(num);
    if (abs < 1000)
        return tostring(num);

    string str = tostring(abs);

    string result;

    for (int i = 0; i < str.Length; i++) {
        if (i > 0 && (str.Length - i) % 3 == 0)
            result += S_Separator;

        result += str.SubStr(i, 1);
    }

    if (num < 0)
        result = "-" + result;

    return result;
}