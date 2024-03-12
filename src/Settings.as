// c 2024-02-16
// m 2024-03-11

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

[Setting category="General" name="Show during qualifier"]
bool S_Qualifier = true;

[Setting category="General" name="Show during knockout"]
bool S_Knockout = true;

[Setting category="General" name="Big number separator"]
string S_Separator = ",";

[Setting category="General" name="Show debug window"]
bool S_Debug = false;


[Setting category="Position/Style" name="Position X" min=0.0f max=1.0f]
float S_X = 0.9f;

[Setting category="Position/Style" name="Position Y" min=0.0f max=1.0f]
float S_Y = 0.15f;

[Setting category="Position/Style" name="Show background"]
bool S_Background = true;

[Setting category="Position/Style" name="Background color" color]
vec4 S_BackgroundColor = vec4(0.0f, 0.0f, 0.0f, 0.7f);

[Setting category="Position/Style" name="Background X-padding" min=0.0f max=30.0f]
float S_BackgroundXPad = 8.0f;

[Setting category="Position/Style" name="Background Y-padding" min=0.0f max=30.0f]
float S_BackgroundYPad = 8.0f;

[Setting category="Position/Style" name="Background corner radius" min=0.0f max=50.0f]
float S_BackgroundRadius = 10.0f;

[Setting category="Position/Style" name="Show header"]
bool S_Header = true;

[Setting category="Position/Style" name="Show subheader" description="Rank/division"]
bool S_Subheader = true;

[Setting category="Position/Style" name="Font style"]
Font S_Font = Font::DroidSansBold;

[Setting category="Position/Style" name="Font size (header)" min=8 max=72]
uint S_HeaderFontSize = 24;

[Setting category="Position/Style" name="Font size" min=8 max=72]
uint S_FontSize = 18;

[Setting category="Position/Style" name="Font color" color]
vec4 S_FontColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Position/Style" name="Font color (highlight)" color]
vec4 S_FontHighlightColor = vec4(0.0f, 1.0f, 0.0f, 1.0f);