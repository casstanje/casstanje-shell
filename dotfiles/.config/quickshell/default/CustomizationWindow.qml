pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "./elements/"
import "./singletons/"

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
    property var themingProperties: {}
    property var appDefaultProperties: {}
    property string getConfigPath: "./.config/casstanje-shell/getConfigSettings.py"
    property string setConfigPath: "./.config/casstanje-shell/setConfigSettings.py"
    property string resetConfigPath: "./.config/casstanje-shell/resetConfig.py"
    property string changedSettingsString: ""
    property var changedSettings: {"bar": {}, "theming": {}, "appDefaults": {}, "catppuccinflavor": ""}

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
                                if(root.startFlavor != root.currentFlavor){
                                    root.changedSettings["catppuccinflavor"] = root.currentFlavor
                                }else{
                                    root.changedSettings["catppuccinflavor"] = ""
                                }
                                root.changedSettingsString = JSON.stringify(root.changedSettings)
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
                        text: "controls which .desktop files the hyprland shortcuts open, as well as the default apps for xdg"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                    }
                    WrapperRectangle {
                        Layout.fillWidth: true
                        id: appDefaultSettingsHolder
                        required property string modelData
                        margin: 8
                        radius: Theme.borderRadius
                        color: Theme.darkerBackground
                        ColumnLayout {
                            id: appDefaultSettingsColumnLayout
                            Layout.fillWidth: true

                            Repeater {
                                model: Object.keys(root.appDefaultProperties)
                                WrapperRectangle {
                                    required property var modelData
                                    color: "transparent"
                                    implicitWidth: appDefaultSettingsColumnLayout.width
                                    ConfigSetting {
                                        text: parent.modelData
                                        modelData: root.appDefaultProperties[parent.modelData]
                                        onNewValueChanged: {
                                            if(modelData["startValue"] != newValue){
                                                root.changedSettings["appDefaults"][parent.modelData] = newValue
                                            }else{
                                                if(parent.modelData in root.changedSettings["appDefaults"])
                                                    delete root.changedSettings["appDefaults"][parent.modelData]
                                            }
                                            root.changedSettingsString = JSON.stringify(root.changedSettings)
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
                        text: "THEMING"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize * 1.2
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "theme settings for both windows and the bar. \nif this does not take effect upon clicking apply, you should log out and back in again"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                    }
                    WrapperRectangle {
                        Layout.fillWidth: true
                        id: themingSettingHolder
                        required property string modelData
                        margin: 8
                        radius: Theme.borderRadius
                        color: Theme.darkerBackground
                        ColumnLayout {
                            id: themingSettingColumnLayout
                            Layout.fillWidth: true

                            Repeater {
                                model: Object.keys(root.themingProperties)
                                WrapperRectangle {
                                    required property var modelData
                                    color: "transparent"
                                    implicitWidth: themingSettingColumnLayout.width
                                    ConfigSetting {
                                        text: parent.modelData
                                        modelData: root.themingProperties[parent.modelData]
                                        onNewValueChanged: {
                                            if(modelData["startValue"] != newValue){
                                                root.changedSettings["theming"][parent.modelData] = newValue
                                            }else{
                                                if(parent.modelData in root.changedSettings["theming"])
                                                    delete root.changedSettings["theming"][parent.modelData]
                                            }
                                            root.changedSettingsString = JSON.stringify(root.changedSettings)
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
                                                ConfigSetting {
                                                    text: settingLoader.modelData
                                                    modelData: settingLoader.settingObject
                                                    onNewValueChanged: {
                                                        if(modelData["startValue"] != newValue){
                                                            root.changedSettings["bar"][settingLoader.modelData] = newValue
                                                        }else{
                                                            if(settingLoader.modelData in root.changedSettings["bar"])
                                                                delete root.changedSettings["bar"][settingLoader.modelData]
                                                        }
                                                        root.changedSettingsString = JSON.stringify(root.changedSettings)
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
                                                            ConfigSetting {
                                                                text: parent.modelData
                                                                modelData: settingLoader.settingObject[parent.modelData]
                                                                onNewValueChanged: {
                                                                    if(modelData["startValue"] != newValue){
                                                                        root.changedSettings["bar"][parent.modelData] = newValue
                                                                    }else{
                                                                        if(parent.modelData in root.changedSettings["bar"])
                                                                            delete root.changedSettings["bar"][parent.modelData]
                                                                    }
                                                                    root.changedSettingsString = JSON.stringify(root.changedSettings)
                                                                    
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
                        text: "a profile image for hyprlock and the start menu can be added at the path below. the image must be under 400x400 pixels, and be a PNG or JPEG"
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
                                text: "~/.face"
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
                        /*Bar Config*/
                        Quickshell.execDetached(
                            {
                                command: ["python", "setConfigSettings.py", root.changedSettingsString],
                                workingDirectory: FileHelper.homeFolder + ".config/casstanje-shell/"
                            }
                        )
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
                WrapperMouseArea {
                    id: resetToDefaultButton
                    hoverEnabled: true
                    property bool hoveredOver: false
                    property bool yaSure: false
                    onEntered: hoveredOver = true
                    onExited: hoveredOver = false

                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if(!yaSure){
                            yaSure = true
                            yaSureTimer.running = true
                        }else{
                            Quickshell.execDetached(
                                {
                                    command: ["python", "resetConfig.py", root.changedSettingsString],
                                    workingDirectory: FileHelper.homeFolder + ".config/casstanje-shell/"
                                }
                            )
                        }
                    }
                    WrapperRectangle {
                        margin: 8
                        border.color: Theme.red
                        border.width: 1
                        color: parent.hoveredOver ? Theme.surface : "transparent"
                        radius: Theme.borderRadius

                        Text {
                            text: resetToDefaultButton.yaSure ? "you sure??" : "reset to defaults"
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                            color: Theme.red
                        }
                    }
                }
            }
        }
    }


    Process {
        id: killQsProc
        command: ["kill", Quickshell.processId]
    }

    Process {
        id: getConfigJsonProc
        command: ["python", root.getConfigPath, "\"1\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const jsonObject = JSON.parse(this.text)
                root.barConfigProperties = jsonObject["bar"]
                root.themingProperties = jsonObject["theming"]
                root.appDefaultProperties = jsonObject["appDefaults"]
                root.currentFlavor = jsonObject["catppuccinflavor"]
            }
        }
        running: true
    }

    Timer {
        id: yaSureTimer
        interval: 3000
        onTriggered: {
            resetToDefaultButton.yaSure = false
        }
    }
}
