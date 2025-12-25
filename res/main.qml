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

                        RowLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignHCenter

                            Image {
                                source: "icons/df-512.png" 
                                sourceSize.width: 32           
                                sourceSize.height: 32
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                text: "DevForge"
                                font.pixelSize: 24
                                font.bold: true
                                color: "#00d4ff"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
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
                        height: 100
                        color: projectListView.currentIndex === index ? "#333333" : "#242424"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#2d2d2d"
                            onExited: parent.color = projectListView.currentIndex === index ? "#333333" : "#242424"
                            onClicked: {
                                projectListView.currentIndex = index
                                projectManager.selectProject(model.name, model.description, model.status, 
                                                           model.date, model.language, model.location, model.commits)
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
                        Text { text: "📁"; font.pixelSize: 64; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Sélectionnez un projet"; font.pixelSize: 20; color: "#666666"; Layout.alignment: Qt.AlignHCenter }
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
                            Layout.preferredWidth: 60; Layout.preferredHeight: 60
                            radius: 14
                            color: "#242424"
                            Text { text: "🚀"; anchors.centerIn: parent; font.pixelSize: 30 }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Text {
                                text: projectManager.selectedName
                                font.pixelSize: 28; font.bold: true; color: "#ffffff"
                            }
                            RowLayout {
                                spacing: 15
                                Text { text: "📅 " + projectManager.selectedDate; color: "#888888" }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: "#242424"; radius: 12
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 25
                            Text { text: "Description"; font.bold: true; color: "#00d4ff" }
                            Text { 
                                text: projectManager.selectedDescription
                                color: "#cccccc"; wrapMode: Text.WordWrap; Layout.fillWidth: true 
                            }
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        columnSpacing: 20

                        Repeater {
                            model: [
                                { title: "Langage", value: projectManager.selectedLanguage, iconSource: projectManager.selectedLanguageIcon },
                                { title: "Localisation", value: projectManager.selectedLocation, icon: "📂" },
                                { title: "Commits", value: projectManager.selectedCommits + " commits", icon: "🔥" }
                            ]
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 100
                                color: "#242424"; radius: 12

                                ColumnLayout {
                                    anchors.centerIn: parent
        
       
                                    Image {
                                        visible: modelData.iconSource !== undefined
                                        source: modelData.iconSource || ""
                                        sourceSize.width: 32
                                        sourceSize.height: 32
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        visible: modelData.icon !== undefined
                                        text: modelData.icon || ""
                                        font.pixelSize: 24
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text { text: modelData.value; font.bold: true; color: "#ffffff"; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: modelData.title; color: "#888888"; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                        

                        }
                    }
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
}