pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "./elements/"
import "./functions/"

FloatingWindow {
    title: "casstanje shell customizer"
    id: root
    property string currentFlavor: ""
    property var programKeys: []
    property var programValues: []
    property var programValuesAsString: ""
    minimumSize.width: 400
    minimumSize.height: 300

    ListModel {
        id: colors
        ListElement{
            name: "rosewater"
            themeColor: function() { return Theme.rosewater }
        }
        ListElement{
            name: "flamingo"
            themeColor: function() { return Theme.flamingo }
        }
        ListElement{
            name: "pink"
            themeColor: function() { return Theme.pink }
        }
        ListElement{
            name: "mauve"
            themeColor: function() { return Theme.mauve }
        }
        ListElement{
            name: "red"
            themeColor: function() { return Theme.red }
        }
        ListElement{
            name: "maroon"
            themeColor: function() { return Theme.maroon }
        }
        ListElement{
            name: "yellow"
            themeColor: function() { return Theme.yellow }
        }
        ListElement{
            name: "green"
            themeColor: function() { return Theme.green }
        }
        ListElement{
            name: "teal"
            themeColor: function() { return Theme.teal }
        }
        ListElement{
            name: "sky"
            themeColor: function() { return Theme.sky }
        }
        ListElement{
            name: "sapphire"
            themeColor: function() { return Theme.sapphire }
        }
        ListElement{
            name: "blue"
            themeColor: function() { return Theme.blue }
        }
        ListElement {
            name: "lavender"
            themeColor: function() { return Theme.lavender }
        }
    }

    property var barConfigProperties: {}
    property string propertiesString: ""

    color: Theme.background

    onClosed: {
        killQsProc.running = true
    }

    ColumnLayout {
        anchors.fill: parent

        ScrollView {
            Layout.fillHeight: true
            contentHeight: scrollContent.implicitHeight
            contentWidth: scrollContent.implicitWidth
            WrapperRectangle {
                id: scrollContent
                implicitWidth: root.width
                color: "transparent"
                leftMargin: 8
                rightMargin: leftMargin
                topMargin: rightMargin
                ColumnLayout {
                    Text {
                        text: "CATPPUCCIN FLAVOR"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize * 1.2
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "this only takes effect in GTK apps after logging out and back in, because they use an environment variable for theming. Also, sometimes quickshell dosen't update the first time a flavor is clicked. In case that happens, just click the theme you want again (or log out and back in)"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                    }
                    
                    GridView {
                        model: colors
                        
                        Layout.fillWidth: true
                        implicitHeight: 400
                        id: grid
                        cellWidth: width / 4
                        cellHeight: implicitHeight / 4
                        flow: GridView.FlowLeftToRight
                        delegate: WrapperMouseArea{
                            id: colorItem
                            required property string name
                            required property var themeColor
                            width: grid.cellWidth
                            height: grid.cellHeight

                            hoverEnabled: true
                            property bool isHovered: false
                            onEntered: isHovered = true
                            onExited: isHovered = false
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.currentFlavor = colorItem.name
                                setCurrentFlavorProc.running = true
                            }

                            WrapperRectangle {
                                color: root.currentFlavor == colorItem.name ? Theme.brightSurface : (colorItem.isHovered ? Theme.surface : "transparent")
                                margin: 8
                                border.color: root.currentFlavor == colorItem.name ? Theme.accent : "transparent"
                                border.width: 2
                                radius: Theme.borderRadius
                                
                                ColumnLayout {
                                    spacing: 2

                                    Text {
                                        text: colorItem.name
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: colorItem.themeColor()
                                        Layout.alignment: Qt.AlignHCenter
                                        radius: Theme.borderRadius
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        implicitHeight: 2
                        radius: 100
                        Layout.fillWidth: true
                        color: Theme.brightSurface
                        Layout.topMargin: 6
                        Layout.bottomMargin: 6
                    }
                    Text {
                        text: "DEFAULT APPLICATIONS"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize * 1.2
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "this only changes the applications the keybinds in hyprbinds.conf launches, NOT the xdg-mime (actual) defaults."
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: root.programKeys
                        ColumnLayout {
                            required property var modelData
                            id: programItem
                            Text {
                                text: modelData
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize * 1.1
                            }
                            WrapperMouseArea {
                                Layout.fillWidth: true
                                cursorShape: Qt.IBeamCursor
                                WrapperRectangle {
                                    Layout.fillWidth: true
                                    radius: Theme.borderRadius
                                    color: Theme.darkerBackground
                                    TextInput {
                                        padding: 8
                                        text: root.programValues[root.programKeys.indexOf(programItem.modelData)]
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize
                                        selectionColor: Theme.accent
                                        selectedTextColor: Theme.background
                                        onTextEdited: {
                                            root.programValues[root.programKeys.indexOf(programItem.modelData)] = text
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    Rectangle {
                        implicitHeight: 2
                        radius: 100
                        Layout.fillWidth: true
                        Layout.topMargin: 6
                        Layout.bottomMargin: 6
                        color: Theme.brightSurface
                    }
                    Text {
                        text: "BAR CONFIG"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize * 1.2
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "if this does not take effect upon clicking apply, you should log out and back in again or restart quickshell manually"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                    }
                    Repeater {
                        id: settingRepeater
                        model: Object.keys(root.barConfigProperties)
                        WrapperRectangle {
                            Layout.fillWidth: true
                            id: settingCategory
                            required property string modelData
                            margin: 8
                            radius: Theme.borderRadius
                            color: Theme.darkerBackground
                            ColumnLayout {
                                id: settingColumnLayout
                                Layout.fillWidth: true

                                Text {
                                    text: settingCategory.modelData
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                    font.bold: true
                                }

                                Repeater {
                                    model: Object.keys(root.barConfigProperties[settingCategory.modelData])
                                    Loader {
                                        id: settingLoader
                                        required property var modelData
                                        property var settingObject: root.barConfigProperties[settingCategory.modelData][settingLoader.modelData]

                                        property Component subSettingHeader: Text {
                                            text: settingLoader.modelData
                                            font.capitalization: Font.AllUppercase
                                            color: Theme.accent
                                            font.family: Theme.fontFamily
                                            font.pointSize: Theme.fontSize
                                        }
                                    

                                        property Component setting: Loader {
                                            id: settingItemLoader
                                            property var dataObject: settingLoader.settingObject["subcategory"] == undefined ? settingLoader.settingObject : settingLoader.settingObject
                                            property bool isHeader: settingItemLoader.dataObject["type"] == undefined
                                            property Component text: Text {
                                                text:  settingLoader.modelData + " (" + (settingItemLoader.dataObject["type"] || "header") + ")"
                                                color: Theme.text
                                                font.family: Theme.fontFamily
                                                font.pointSize: Theme.fontSize
                                            }

                                            property Component setting: WrapperRectangle {
                                                color: "transparent"
                                                implicitWidth: settingColumnLayout.width
                                                BarConfigSettings {
                                                    text: settingLoader.modelData
                                                    modelData: settingLoader.settingObject
                                                    onNewValueChanged: {
                                                        root.barConfigProperties[settingCategory.modelData][settingLoader.modelData]["value"] = newValue
                                                        root.propertiesString = JSON.stringify(root.barConfigProperties)
                                                    }
                                                }
                                            }

                                            property Component subSettings: ColumnLayout {
                                                spacing: 4
                                                Layout.fillWidth: true
                                                Text {
                                                    text: settingLoader.modelData
                                                    font.capitalization: Font.AllUppercase
                                                    color: Theme.accent
                                                    font.family: Theme.fontFamily
                                                    font.pointSize: Theme.fontSize
                                                }
                                                ColumnLayout {
                                                    spacing: 10
                                                    Repeater {
                                                        model: Object.keys(settingLoader.settingObject)
                                                        WrapperRectangle {
                                                            color: "transparent"
                                                            implicitWidth: settingColumnLayout.width
                                                            required property var modelData
                                                            BarConfigSettings {
                                                                text: parent.modelData
                                                                modelData: settingLoader.settingObject[parent.modelData]
                                                                onNewValueChanged: {
                                                                    root.barConfigProperties[settingCategory.modelData][settingLoader.modelData][parent.modelData]["value"] = newValue
                                                                    root.propertiesString = JSON.stringify(root.barConfigProperties)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                WrapperRectangle {
                                                    topMargin: 8
                                                    bottomMargin: topMargin
                                                    color: "transparent"
                                                    Rectangle {
                                                        implicitHeight: 2
                                                        implicitWidth: settingColumnLayout.width
                                                        color: Theme.surface
                                                    }
                                                }
                                            } 

                                            sourceComponent: isHeader ? subSettings : setting
                                        }
                                        sourceComponent: Object.keys(settingObject).length != 0 ? setting : subSettingHeader
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        implicitHeight: 2
                        radius: 100
                        Layout.fillWidth: true
                        Layout.topMargin: 6
                        Layout.bottomMargin: 6
                        color: Theme.brightSurface
                    }
                    Text {
                        text: "PROFILE IMAGE"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize * 1.2
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "a profile image for hyprlock and the start menu can be added at the path below. the image must be under 400x400 pixels, and be a .png, .jpg or .jpeg"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    WrapperMouseArea {
                        Layout.fillWidth: true
                        cursorShape: Qt.IBeamCursor
                        WrapperRectangle {
                            Layout.fillWidth: true
                            radius: Theme.borderRadius
                            color: Theme.darkerBackground
                            TextInput {
                                padding: 8
                                text: "~/face.<file-extension>"
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                                selectionColor: Theme.accent
                                selectedTextColor: Theme.background
                                readOnly: true
                            }
                        }
                    }
                }
            }
        }

        WrapperRectangle {
            Layout.fillWidth: true
            color: Theme.background
            margin: 8
            topMargin: 0
            RowLayout {
                layoutDirection: Qt.RightToLeft
                WrapperMouseArea {
                    hoverEnabled: true
                    property bool hoveredOver: false
                    onEntered: hoveredOver = true
                    onExited: hoveredOver = false

                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        /*Default Applications*/
                        var newString = ""
                        for(var i = 0; i < root.programValues.length; i++) {
                            var value = root.programValues[i]
                            newString += "\"" + value + "\"" + (i != root.programValues.length - 1 ? "¾" : "")
                        }
                        root.programValuesAsString = newString
                        setProgramDefaultsProc.running = true

                        /*Bar Config*/
                        setConfigJsonProc.running = true
                    }
                    WrapperRectangle {
                        margin: 8
                        border.color: Theme.correct
                        border.width: 1
                        color: parent.hoveredOver ? Theme.surface : "transparent"
                        radius: Theme.borderRadius

                        Text {
                            text: "apply"
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                            color: Theme.correct
                        }
                    }
                }
                WrapperMouseArea {
                    hoverEnabled: true
                    property bool hoveredOver: false
                    onEntered: hoveredOver = true
                    onExited: hoveredOver = false

                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Quickshell.reload(false)
                    }
                    WrapperRectangle {
                        margin: 8
                        border.color: Theme.brightSurface
                        border.width: 1
                        color: parent.hoveredOver ? Theme.surface : "transparent"
                        radius: Theme.borderRadius

                        Text {
                            text: "reset"
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                            color: Theme.text
                        }
                    }
                }
                WrapperMouseArea {
                    hoverEnabled: true
                    property bool hoveredOver: false
                    onEntered: hoveredOver = true
                    onExited: hoveredOver = false

                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Qt.quit()
                    }
                    WrapperRectangle {
                        margin: 8
                        border.color: Theme.brightSurface
                        border.width: 1
                        color: parent.hoveredOver ? Theme.surface : "transparent"
                        radius: Theme.borderRadius

                        Text {
                            text: "close"
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                            color: Theme.text
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                }

            }
        }
    }


    Process {
        id: killQsProc
        command: ["kill", Quickshell.processId]
    }

    Process {
        id: getCurrentFlavorProc
        command: ["bash", FileHelper.homeFolder + ".config/casstanje-shell/get-catppuccin-flavor.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.currentFlavor = this.text.replace("\n", "")
            }
        }
        running: true
    }

    Process {
        id: setCurrentFlavorProc
        command: ["bash", FileHelper.homeFolder + "/.config/casstanje-shell/set-new-catppuccin-flavor.sh", root.currentFlavor]
        stdout: StdioCollector {
            onStreamFinished: {
                Quickshell.reload(false)
            }
        }
    }

    Process { // Needs to run a bit after app start, so the timer below sets running to true
        id: getProgramKeysProc
        command: ["sh", FileHelper.homeFolder + "/.config/casstanje-shell/get-app-defaults-keys.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanedText = this.text.replace("[", "").replace("]", "").replace(/\"/g, "").replace(/\n/g, "")
                root.programKeys = cleanedText.split(",")
            }
        }
        
    }

    Timer {
        interval: 200
        running: true
        onTriggered: {
            getProgramKeysProc.running = true
            getProgramValuesProc.running = true
        }
    }

    Process { // Same with this one
        id: getProgramValuesProc
        command: ["sh", FileHelper.homeFolder + "/.config/casstanje-shell/get-app-defaults-values.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanedText = this.text.replace(/\"/g, "")
                var array = cleanedText.split("\n")
                array.pop()
                root.programValues = array
            }
        }
        
    }

    Process {
        id: setProgramDefaultsProc
        command: ["sh", FileHelper.homeFolder + "/.config/casstanje-shell/set-new-app-defaults.sh", root.programValuesAsString]
    }

    Process {
        id: getConfigJsonProc
        command: ["sh", Quickshell.shellDir + "/scripts/getBarConfigJson.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                //console.log(this.text)
                var jsonObject = JSON.parse(this.text)
                root.barConfigProperties = {}
                for(var category in jsonObject){
                    var settings = jsonObject[category]
                    var settingCategory = {}
                    
                    for(var setting in settings){
                        var keys = settings[setting]
                        for(var key in keys){
                            if(settingCategory[setting] == undefined) settingCategory[setting] = {}
                            if(key != "name" && key != "value" && key != "description" && key != "type"){
                                var subKeys = keys[key]
                                var subCategory = {}
                                for(var subKey in subKeys){
                                    if(settingCategory[setting][key] == undefined) settingCategory[setting][key] = {}
                                    settingCategory[setting][key][subKey] = subKeys[subKey]
                                }
                                settingCategory[setting][key]["subcategory"] = true
                            }else {
                                settingCategory[setting][key] = keys[key]
                            }
                        }
                    }
                    console.log(Object.keys(settingCategory[setting]))
                    root.barConfigProperties[category] = settingCategory
                    settingRepeater.model = undefined
                    settingRepeater.model = Object.keys(root.barConfigProperties)
                }
                
            }
        }
        running: true
    }

    Process {
        id: setConfigJsonProc
        command: ["sh", Quickshell.shellDir + "/scripts/setBarConfigJson.sh", root.propertiesString]
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(setConfigJsonProc.command)
                Quickshell.reload(true)
            }
        }
    }
}