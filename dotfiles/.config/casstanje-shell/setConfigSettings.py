import json,sys,os
import toolsVariables
import cleanConfig

oldStdout = sys.stdout

logFile = open(f"{toolsVariables.casstanjeShellDir}/setSettings.log", "w")
sys.stdout = logFile

currentSetSettings = {}
userConfigPath = f'{toolsVariables.casstanjeShellDir}/user-config.json'

# Read existing values into object, leave empty if none
try:
    with open(userConfigPath, "r") as f:
        currentSetSettings = json.load(f)
except:
    print("No settings set")

if not ("bar" in currentSetSettings): 
    currentSetSettings["bar"] = {}

if not ("theming" in currentSetSettings):
    currentSetSettings["theming"] = {}

if not ("appDefaults" in currentSetSettings):
    currentSetSettings["appDefaults"] = {}

if not ("catppuccinaccent" in currentSetSettings):
    currentSetSettings["catppuccinaccent"] = ""




# Newly changed settings
print(f"sys.argv[1]: {sys.argv[1]}")
newData = json.loads(sys.argv[1])
for settingType,settings in newData.items():
    if(settingType != "catppuccinaccent"):
        for settingKey,settingValue in settings.items():
            currentSetSettings[settingType][settingKey] = settingValue
    else:
        if(settings != ""):
            currentSetSettings[settingType] = settings # 'settings' is the ctp flavor here

# Write new values + old ones to user-config.json
with open(userConfigPath, "w") as f:
    f.write(
        json.dumps(currentSetSettings, indent=4, sort_keys=True)
    )

# Clean config for nix
cleanConfig.main()

os.system('notify-send -u critical -t 5000 -a "casstanje shell" "updated config" "new config will apply on next rebuild"')