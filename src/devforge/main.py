import sys
from PyQt6.QtWidgets import QApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl, QObject, pyqtSlot, pyqtSignal, pyqtProperty, QAbstractListModel, Qt
from PyQt6.QtGui import QIcon, QPixmap
from pathlib import Path




def language_icon(language: str) -> str:
    lang = language.lower()

    if "python" in lang:
        return "icons/python.png"
    if "php" in lang:
        return "icons/php.png"
    if "kotlin" in lang:
        return "icons/kotlin.png"
    if "react" in lang:
        return "icons/react.png"
    if "qml" in lang:
        return "icons/python.png"

    return "icons/default.png"


class Project:
    def __init__(self, name, description, status, date, language, location, commits):
        self.name = name
        self.description = description
        self.status = status
        self.date = date
        self.language = language
        self.language_icon = language_icon(language)
        self.location = location
        self.commits = commits
        

class ProjectModel(QAbstractListModel):
    NameRole = Qt.ItemDataRole.UserRole + 1
    DescriptionRole = Qt.ItemDataRole.UserRole + 2
    StatusRole = Qt.ItemDataRole.UserRole + 3
    DateRole = Qt.ItemDataRole.UserRole + 4
    LanguageRole = Qt.ItemDataRole.UserRole + 5
    LanguageIconRole = Qt.ItemDataRole.UserRole + 6
    LocationRole = Qt.ItemDataRole.UserRole + 7
    CommitsRole = Qt.ItemDataRole.UserRole + 8

    def __init__(self, parent=None):
        super().__init__(parent)
        self._projects = []
        self.load_projects()

    def rowCount(self, parent=None):
        return len(self._projects)

    def data(self, index, role=Qt.ItemDataRole.DisplayRole):
        if not index.isValid() or index.row() >= len(self._projects):
            return None
        
        project = self._projects[index.row()]
        if role == self.NameRole:
            return project.name
        elif role == self.DescriptionRole:
            return project.description
        elif role == self.StatusRole:
            return project.status
        elif role == self.DateRole:
            return project.date
        elif role == self.LanguageRole:
            return project.language
        elif role == self.LanguageIconRole:
            return project.language_icon
        elif role == self.LocationRole:
            return project.location
        elif role == self.CommitsRole:
            return project.commits
        return None

    def roleNames(self):
        return {
            self.NameRole: b'name',
            self.DescriptionRole: b'description',
            self.StatusRole: b'status',
            self.DateRole: b'date',
            self.LanguageRole: b'language',
            self.LanguageIconRole: b'language_icon',
            self.LocationRole: b'location',
            self.CommitsRole: b'commits'
        }

    def load_projects(self):
        self._projects = [
        Project("Site Web E-commerce", "Développement d'une plateforme e-commerce complète", "En cours", "15/12/2024", "PHP", "C:\\Users\\hello\\OneDrive\\Documents", 45),
        Project("Application Mobile", "Application mobile cross-platform pour iOS et Android", "Planifié", "10/01/2025", "Kotlin", "C:\\Users\\hello\\OneDrive\\Documents\\Code", 0),
        Project("API REST", "API backend pour services web modernes", "Terminé", "01/12/2024", "Python", "D:\\Folders\\Hi", 89),
        Project("Dashboard Analytics", "Tableau de bord d'analyse des données en temps réel", "En cours", "20/12/2024", "React", "D:\\Folders\\Hi\\Mes_Files", 12),
        Project("DevForge", "Application de gestion de projets de développement logiciel avancée.", "En cours", "15/12/2024", "Python / QML", "C:\\Users", 128)
    ]
        

class ProjectManager(QObject):
    projectSelectedChanged = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._selected_name = ""
        self._selected_description = ""
        self._selected_status = ""
        self._selected_date = ""
        self._selected_language = ""
        self._selected_language_icon = ""
        self._selected_location = ""
        self._selected_commits = 0


    @pyqtSlot(str, str, str, str, str, str, int)
    def selectProject(self, name, description, status, date, language, location, commits):
        self._selected_name = name
        self._selected_description = description
        self._selected_status = status
        self._selected_date = date
        self._selected_language = language
        self._selected_language_icon = language_icon(language)
        self._selected_location = location
        self._selected_commits = commits
        self.projectSelectedChanged.emit()

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedName(self):
        return self._selected_name

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedDescription(self):
        return self._selected_description

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedStatus(self):
        return self._selected_status

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedDate(self):
        return self._selected_date
    
    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedLanguage(self):
        return self._selected_language

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedLanguageIcon(self):
        return self._selected_language_icon

    @pyqtProperty(str, notify=projectSelectedChanged)
    def selectedLocation(self):
        return self._selected_location
    
    @pyqtProperty(int, notify=projectSelectedChanged)
    def selectedCommits(self):
        return self._selected_commits

def main():
    app = QApplication(sys.argv)
    res_icon_path = Path(__file__).parent.parent.parent / "res" / "icons"
    icon = QIcon()

    icon.addPixmap(QPixmap(str(res_icon_path / "df-16.png")))
    icon.addPixmap(QPixmap(str(res_icon_path / "df-32.png")))
    icon.addPixmap(QPixmap(str(res_icon_path / "df-64.png")))
    icon.addPixmap(QPixmap(str(res_icon_path / "df-256.png")))

    app.setWindowIcon(icon)
    app.setWindowIcon(icon)
    engine = QQmlApplicationEngine()
    
    project_model = ProjectModel()
    project_manager = ProjectManager()

    engine.rootContext().setContextProperty("projectModel", project_model)
    engine.rootContext().setContextProperty("projectManager", project_manager)

    qml_file = Path(__file__).parent.parent.parent / "res" / "main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())

if __name__ == "__main__":
    main()