import json,os,sys,re
import getConfigSettings,toolsVariables

def cleanSetting(setting,value):
    settingType = value["type"]
    settingValue = value["value"]
    settingDefault = value["default"]

    if(settingType == "string"):
        settingValue = f'\\"{settingValue}\\"'
    elif(settingType == "SystemClock"):
        if(settingValue == "0"):
            settingValue = "SystemClock.Seconds"
        elif(settingValue == "1"): 
            settingValue = "SystemClock.Minutes"
        else:
            settingValue = "SystemClock.Hours"
    elif(settingType == "int"): 
        # Default to zero if setting is not an int
        if not (re.match(r"^-?[0-9]+$", settingValue)):
            settingValue = settingDefault
    
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
    settingsObject : dict = getConfigSettings.main()

    # Construct uncategorized settings object (the same, but without categories)
    uncategorizedSettingsObject = {}
    for settingType,cats in settingsObject.items():
        uncategorizedSettingsObject[settingType] = {}
        if(settingType != "catppuccinflavor"):
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
        

    for settingType,settings in uncategorizedSettingsObject.items():
        if(settingType != "catppuccinflavor"):
            for setting,value in settings.items():
                cleanedSetting = cleanSetting(setting,value)
                if(settingType == "bar"):
                    # Change value in quickshell/default/Config.qml
                    os.system(f'sed --follow-symlinks -i "/property {cleanedSetting["type"]} {cleanedSetting["name"]}:/c\\    property {cleanedSetting["type"]} {cleanedSetting["name"]}: {cleanedSetting["value"]}" {toolsVariables.homeDir}/.config/quickshell/default/Config.qml')
                elif(settingType == "theming"):
                    # Change value in quickshell/default/Theme.qml
                    if(cleanedSetting["qsName"] != ""):
                        os.system(f'sed --follow-symlinks -i "/property {cleanedSetting["type"]} {cleanedSetting["qsName"]}:/c\\    property {cleanedSetting["type"]} {cleanedSetting["qsName"]}: {cleanedSetting["value"]}" {toolsVariables.homeDir}/.config/quickshell/default/Theme.qml')
                    # Change value hypr/hyprstyle.conf
                    if(cleanedSetting["hyprName"] != ""):
                        os.system(f'sed --follow-symlinks -i  "/{cleanedSetting["hyprName"]} = /c\\    {cleanedSetting["hyprName"]} = {cleanedSetting["value"]}" {toolsVariables.homeDir}/.config/hypr/hyprstyle.conf')
                elif(settingType == "appDefaults"):
                    os.system(f'sed --follow-symlinks -i "/\\${cleanedSetting["name"]}=/c\\${cleanedSetting["name"]}={cleanedSetting["value"].replace("\\\"", "")}" {toolsVariables.homeDir}/.config/hypr/hyprbinds.conf')
                    # Set xdg-mime defaults
                    if(cleanedSetting["mimeTypes"] != ""):
                        os.system(f'xdg-mime default {cleanedSetting["value"].replace("\\\"", "")} {cleanedSetting["mimeTypes"]}')
        else: 
            for file in os.listdir(f"{toolsVariables.casstanjeShellDir}/catppuccin_flavor_setters"):
                os.system(f'CATPPUCCIN_FLAVOR="{settings}" bash {toolsVariables.casstanjeShellDir}/catppuccin_flavor_setters/{file}') # 'settings' is the catppuccin flavor here
            
                    
    
if __name__ == '__main__':
    main()