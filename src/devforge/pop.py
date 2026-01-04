from PyQt6.QtCore import QObject, pyqtSlot, pyqtSignal
from PyQt6.QtWidgets import QInputDialog, QLineEdit, QFileDialog

class ProjectDialogManager(QObject):
    projectCreated = pyqtSignal(str, str, str, str, str, str)

    def __init__(self, parent=None):
        super().__init__(parent)

    @pyqtSlot()
    def openNewProjectDialog(self):
        name, ok = QInputDialog.getText(None, "Nouveau Projet", "Nom :")
        if not ok or not name: return

        desc, ok = QInputDialog.getMultiLineText(None, "Configuration", "Description du projet :")
        if not ok: desc = "Aucune description"

        status_list = ["En cours", "Planifié", "Terminé"]
        status, ok = QInputDialog.getItem(None, "Configuration", "Statut actuel :", status_list, 0, False)
        if not ok: return

        date, ok = QInputDialog.getText(None, "Configuration", "Date (JJ/MM/AAAA) :", QLineEdit.EchoMode.Normal, "04/01/2026")
        if not ok: return

        langs = ["Python", "PHP", "Kotlin", "React", "QML"]
        lang, ok = QInputDialog.getItem(None, "Configuration", "Langage :", langs, 0, False)
        if not ok: return

        path = QFileDialog.getExistingDirectory(None, "Dossier du projet")
        
        if path:
            self.projectCreated.emit(str(name), str(desc), str(status), str(date), str(lang), str(path))