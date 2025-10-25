import json,sys,os
import applyConfig
import toolsVariables

oldStdout = sys.stdout

logFile = open(f"{toolsVariables.casstanjeShellDir}/setSettings.log", "w")
sys.stdout = logFile

currentSetSettings = {}
userConfigPath = f'{toolsVariables.casstanjeShellDir}/user-config.json'

# Read existing values into object, leave empty if none
with open(userConfigPath, "r") as f:
    try:
        currentSetSettings = json.load(f)
    except:
        print("No settings set")

if not ("bar" in currentSetSettings): 
    currentSetSettings["bar"] = {}

if not ("theming" in currentSetSettings):
    currentSetSettings["theming"] = {}

if not ("appDefaults" in currentSetSettings):
    currentSetSettings["appDefaults"] = {}

if not ("catppuccinflavor" in currentSetSettings):
    currentSetSettings["catppuccinflavor"] = ""




# Newly changed settings
print(f"sys.argv[1]: {sys.argv[1]}")
newData = json.loads(sys.argv[1])
for settingType,settings in newData.items():
    if(settingType != "catppuccinflavor"):
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

# Apply new settings
applyConfig.main()