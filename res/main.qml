import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1200
    height: 700
    title: "DevForge - Project Manager"
    color: "#1a1a1a"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            color: "#242424"

            ColumnLayout {
                id: contentLayout

                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: "#2a2a2a"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            text: "DevForge"
                            font.pixelSize: 24
                            font.bold: true
                            color: "#00d4ff"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Project Manager"
                            font.pixelSize: 12
                            color: "#888888"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                ListView {
                    id: projectListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: projectModel
                    spacing: 0

                    delegate: Rectangle {
                        width: projectListView.width
                        height: contentLayout.implicitHeight + 30
                        color: projectListView.currentIndex === index ? "#333333" : "#242424"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#2d2d2d"
                            onExited: parent.color = projectListView.currentIndex === index ? "#333333" : "#242424"
                            onClicked: {
                                projectListView.currentIndex = index
                                projectManager.selectProject(model.name, model.description, model.status, model.date)
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 5

                            Text {
                                text: model.name
                                font.pixelSize: 14
                                font.bold: true
                                color: "#ffffff"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: model.description
                                font.pixelSize: 11
                                color: "#aaaaaa"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                maximumLineCount: 2
                                wrapMode: Text.WordWrap
                            }

                            Rectangle {
                                Layout.preferredWidth: statusText.width + 20
                                Layout.preferredHeight: 22
                                radius: 11
                                color: model.status === "En cours" ? "#1a4d2e" : 
                                       model.status === "Terminé" ? "#1a3d4d" : "#4d3d1a"

                                Text {
                                    id: statusText
                                    anchors.centerIn: parent
                                    text: model.status
                                    font.pixelSize: 10
                                    color: model.status === "En cours" ? "#4ade80" : 
                                           model.status === "Terminé" ? "#60a5fa" : "#fbbf24"
                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 30

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: projectManager.selectedName === ""

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "📁"
                            font.pixelSize: 64
                            color: "#444444"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Sélectionnez un projet"
                            font.pixelSize: 20
                            color: "#666666"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Cliquez sur un projet dans la liste pour voir ses détails"
                            font.pixelSize: 14
                            color: "#555555"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 25
                    visible: projectManager.selectedName !== ""

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 14

                            Image {
                                anchors.centerIn: parent
                                width: 32
                                height: 32
                                fillMode: Image.PreserveAspectFit

                                source: projectManager.selectedStatus === "En cours"
                                    ? "icons/progress.svg"
                                    : projectManager.selectedStatus === "Terminé"
                                    ? "icons/done.svg"
                                    : "icons/planned.svg"
                            }
                        }


                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                text: projectManager.selectedName
                                font.pixelSize: 28
                                font.bold: true
                                color: "#ffffff"
                            }

                            RowLayout {
                                spacing: 15

                                Rectangle {
                                    Layout.preferredWidth: statusLabel.width + 20
                                    Layout.preferredHeight: 28
                                    radius: 14
                                    color: projectManager.selectedStatus === "En cours" ? "#1a4d2e" : 
                                           projectManager.selectedStatus === "Terminé" ? "#1a3d4d" : "#4d3d1a"

                                    Text {
                                        id: statusLabel
                                        anchors.centerIn: parent
                                        text: projectManager.selectedStatus
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: projectManager.selectedStatus === "En cours" ? "#4ade80" : 
                                               projectManager.selectedStatus === "Terminé" ? "#60a5fa" : "#fbbf24"
                                    }
                                }

                                Text {
                                    text: "📅 " + projectManager.selectedDate
                                    font.pixelSize: 13
                                    color: "#888888"
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: "#242424"
                        radius: 12

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 25
                            spacing: 15

                            Text {
                                text: "Description"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#00d4ff"
                            }

                            Text {
                                text: projectManager.selectedDescription
                                font.pixelSize: 14
                                color: "#cccccc"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        columnSpacing: 20
                        rowSpacing: 20

                        Repeater {
                            model: [
                                {title: "Tâches", value: "12/24", icon: "✓"},
                                {title: "Progression", value: "50%", icon: "📊"},
                                {title: "Équipe", value: "5 membres", icon: "👥"}
                            ]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 100
                                color: "#242424"
                                radius: 12

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 10

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 24
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: "#ffffff"
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: modelData.title
                                        font.pixelSize: 12
                                        color: "#888888"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}