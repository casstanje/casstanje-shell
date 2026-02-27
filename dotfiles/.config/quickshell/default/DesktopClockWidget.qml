import 'singletons/'
import 'elements/'
import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        PanelWindow {
            visible: Config.desktopClockEnabled
            id: window
            required property var modelData
            screen: modelData

            anchors {
                top: true
            }

            margins {
                top: DynamicVars.barHeight
            }

            aboveWindows: false
            exclusionMode: ExclusionMode.Ignore

            implicitWidth: clockLayout.width
            implicitHeight: clockLayout.height

            color: "transparent"

            WrapperRectangle {
                id: clockLayout
                color: "transparent"

                margin: 0
                bottomMargin: 0
                ColumnLayout {
                    spacing: 0
                    Text {
                        id: clock
                        text: Time.justTime.replace(":", Number(Time.seconds) % 2 == 0 ? ":" : " ")
                        topPadding: -10
                        bottomPadding: -10
                        font.pointSize: 80
                        color: Theme.accent
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        property real textTopPadding: -10
                        
                        spacing: 0
                        Text {
                            id: date
                            text: Time.date
                            font.pointSize: 18
                            color: Theme.subtext
                            lineHeight: 0
                            topPadding: parent.textTopPadding
                        }

                        Text {
                            id: year
                            text: " " + Time.year
                            font.pointSize: 18
                            color: Theme.subtext
                            lineHeight: 0
                            topPadding: parent.textTopPadding
                        }
                    }

                }
            }
        }
    }
}

