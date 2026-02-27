import json,os,sys,re
import getConfigSettings,toolsVariables

# "Cleans" the config, and places it in ./clean-user-config.json in a format that casstanje-shell.nix can read

def cleanSetting(setting,value):
    settingType = value["type"]
    settingValue = value["value"]
    settingDefault = value["default"]

    if(settingType == "SystemClock"):
        if(settingValue == "0"):
            settingValue = "SystemClock.Seconds"
        elif(settingValue == "1"): 
            settingValue = "SystemClock.Minutes"
        else:
            settingValue = "SystemClock.Hours"
    elif(settingType == "int"): 
        # Default to zero if setting is not an int
        if not (re.match(r"^-?[0-9]+$", settingValue)):
            settingValue = int(settingDefault)
        else:
            settingValue = int(settingValue)
    
    returnObject = {
        "type": settingType,
        "value": settingValue,
        "default": settingDefault
    }

    if("qsName" in value.keys()):
        returnObject["qsName"] = value["qsName"]
        returnObject["hyprName"] = value["hyprName"]
    else:
        returnObject["name"] = value["name"]

    if("mimeTypes" in value.keys()):
        returnObject["mimeTypes"] = value["mimeTypes"]

    return returnObject

def main():
    oldStdout = sys.stdout
    logFile = open(f"{toolsVariables.casstanjeShellDir}/cleanConfig.log", "w")
    sys.stdout = logFile

    settingsObject : dict = getConfigSettings.main()

    # Construct uncategorized settings object (the same, but without categories)
    uncategorizedSettingsObject = {}
    for settingType,cats in settingsObject.items():
        uncategorizedSettingsObject[settingType] = {}
        if(settingType != "catppuccinaccent"):
            for key,value in cats.items():
                if(settingType == "theming" or settingType == "appDefaults"):
                    uncategorizedSettingsObject[settingType][key] = value
                elif(settingType == "bar"):
                    for barKey,barValue in value.items():
                        if("value" in barValue.keys()):
                            #Settings
                            uncategorizedSettingsObject[settingType][barKey] = barValue
                        else:
                            #Sub-category
                            for subKey,subValue in barValue.items(): 
                                uncategorizedSettingsObject[settingType][subKey] = subValue
        else:
            uncategorizedSettingsObject[settingType] = cats # 'cats' is the value in this context
        

    cleanedSettings = {}
    for settingType,settings in uncategorizedSettingsObject.items():
        if(settingType != "catppuccinaccent"):
            for setting,value in settings.items():
                cleanedSetting = cleanSetting(setting,value)
                cleanedSettings[setting.replace(" ", "_")] = cleanedSetting["value"]
                
        else: 
            cleanedSettings['catppuccinaccent'] = settings # 'settings' is the catppuccin flavor here

    cleanedSettingsJson = json.dumps(cleanedSettings, indent=2)
    print()
    print("cleaned user config:")
    print(cleanedSettingsJson)
    with open(file=f"{toolsVariables.casstanjeShellDir}/clean-user-config.json", mode="w") as f:
        f.write(cleanedSettingsJson);
            
                    
    
if __name__ == '__main__':
    main()