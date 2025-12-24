import sys
from PyQt6.QtWidgets import QApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl, QObject, pyqtSlot, pyqtSignal, pyqtProperty, QAbstractListModel, Qt
from pathlib import Path

class Project:
    def __init__(self, name, description, status, date):
        self.name = name
        self.description = description
        self.status = status
        self.date = date

class ProjectModel(QAbstractListModel):
    NameRole = Qt.ItemDataRole.UserRole + 1
    DescriptionRole = Qt.ItemDataRole.UserRole + 2
    StatusRole = Qt.ItemDataRole.UserRole + 3
    DateRole = Qt.ItemDataRole.UserRole + 4

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
        return None

    def roleNames(self):
        return {
            self.NameRole: b'name',
            self.DescriptionRole: b'description',
            self.StatusRole: b'status',
            self.DateRole: b'date'
        }

    def load_projects(self):
        self._projects = [
            Project("Site Web E-commerce", "Développement d'une plateforme de vente en ligne avec panier et paiement", "En cours", "15/12/2024"),
            Project("Application Mobile", "App mobile cross-platform pour la gestion de tâches", "Planifié", "10/01/2025"),
            Project("API REST", "API backend pour microservices", "Terminé", "01/12/2024"),
            Project("Dashboard Analytics", "Tableau de bord pour visualisation de données", "En cours", "20/12/2024"),
        ]

class ProjectManager(QObject):
    projectSelectedChanged = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._selected_name = ""
        self._selected_description = ""
        self._selected_status = ""
        self._selected_date = ""

    @pyqtSlot(str, str, str, str)
    def selectProject(self, name, description, status, date):
        self._selected_name = name
        self._selected_description = description
        self._selected_status = status
        self._selected_date = date
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

def main():
    app = QApplication(sys.argv)
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