import json,os,sys
import toolsVariables
def main(printOutput = False):
    oldStdout = sys.stdout

    logFile = open(f"{toolsVariables.casstanjeShellDir}/getSettings.log", "w")
    sys.stdout = logFile


    setOptions={}
    optionsObject={}

    # Write existing values into object, leave empty if none
    with open(f"{toolsVariables.casstanjeShellDir}/user-config.json", "r") as f:
        try:
            jsonObject = json.load(f)
            for cat,settings in jsonObject.items():
                if(cat != "catppuccinflavor"):
                    setOptions[cat] = {}
                    for settingKey,settingValue in settings.items():
                        setOptions[cat][settingKey] = settingValue
                else:
                    setOptions[cat] = settings # 'settings' is the ctp flavor here
        except:
            print("No set settings found")

    # Compare existing user-set values to avialable options,
    # and create an object containing all options with their 
    # either user-set values or default ones
    with open(f"{toolsVariables.casstanjeShellDir}/config-template.json", "r") as f:
        jsonObject = json.load(f)
        for key,value in jsonObject.items():
            if(key == "barConfig"):
                optionsObject["bar"] = {}
                if not("bar" in setOptions.keys()): setOptions["bar"] = {}
                # Loop though categories
                for cat,settings in value.items():
                    optionsObject["bar"][cat] = {}
                    # Loop through settings in category
                    for settingKey,settingValue in settings.items():
                        if("default" in settingValue.keys()):
                            jsonSettingValue = (
                                setOptions["bar"][settingKey] 
                                if settingKey in setOptions["bar"].keys() else 
                                settingValue["default"]
                            )
                            # App settings to dictionary with final value
                            optionsObject["bar"][cat][settingKey] = {
                                "value": jsonSettingValue,
                                "startValue": jsonSettingValue,
                                "type": settingValue["type"],
                                "name": settingValue["name"],
                                "default": settingValue["default"],
                                "description": settingValue["description"]
                            }
                        else:
                            # Sub-categories (individual module settings)
                            optionsObject["bar"][cat][settingKey] = {}
                            # Loop through sub-categories
                            for subSettingKey,subSettingValue in settingValue.items():
                                jsonSettingValue = (
                                    setOptions["bar"][subSettingKey] 
                                    if subSettingKey in setOptions["bar"].keys() else 
                                    subSettingValue["default"]
                                )
                                optionsObject["bar"][cat][settingKey][subSettingKey] = {
                                    "value": jsonSettingValue,
                                    "startValue": jsonSettingValue,
                                    "type": subSettingValue["type"],
                                    "name": subSettingValue["name"],
                                    "default": subSettingValue["default"],
                                    "description": subSettingValue["description"]
                                }
            elif(key == "theming"): 
                optionsObject["theming"] = {}
                if not("theming" in setOptions.keys()): setOptions["theming"] = {}
                for settingKey,settingValue in value.items():
                    jsonSettingValue = (
                        setOptions["theming"][settingKey]
                        if settingKey in setOptions["theming"].keys() else
                        settingValue["default"]
                    )
                    optionsObject["theming"][settingKey] = {
                        "value": jsonSettingValue,
                        "startValue": jsonSettingValue,
                        "type": settingValue["type"],
                        "qsName": settingValue["qsName"],
                        "hyprName": settingValue["hyprName"],
                        "default": settingValue["default"],
                        "description": settingValue["description"]
                    }
            elif(key == "appDefaults"):
                optionsObject["appDefaults"] = {}
                if not("appDefaults" in setOptions.keys()): setOptions["appDefaults"] = {}
                for settingKey,settingValue in value.items():
                    jsonSettingValue = (
                        setOptions["appDefaults"][settingKey]
                        if settingKey in setOptions["appDefaults"].keys() else
                        settingValue["default"]
                    )
                    optionsObject["appDefaults"][settingKey] = {
                        "value": jsonSettingValue,
                        "startValue": jsonSettingValue,
                        "type": settingValue["type"],
                        "name": settingValue["name"],
                        "mimeTypes": settingValue["mimeTypes"],
                        "default": settingValue["default"],
                        "description": settingValue["description"]
                    }
            elif(key == "catppuccinflavor"):
                useDefaultValue = "catppuccinflavor" in setOptions.keys()
                if(useDefaultValue): useDefaultValue = setOptions["catppuccinflavor"] != ""
                optionsObject["catppuccinflavor"] = (
                    setOptions["catppuccinflavor"]
                    if useDefaultValue else
                    value
                )
                    


    # Output data to log for debugging
    print()
    print("Finished output pretty-printed:")
    print(json.dumps(optionsObject, indent=2))

    # Close the log file
    logFile.close()
    sys.stdout = oldStdout

    # If the script is run by itself, print the data else return the data
    sysArgv1 = sys.argv[1] if len(sys.argv) > 1 else ""
    if(printOutput or sysArgv1 == "1"): print(json.dumps(optionsObject, indent=2))
    else: return optionsObject

if __name__ == '__main__':
    main(True)
