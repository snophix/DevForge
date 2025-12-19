import os
import subprocess


class SetupUtils:
    def shell_command(command: str) -> subprocess.CompletedProcess[bytes]:
        commandList = command.split(" ")
        result = subprocess.run(commandList)
        return result

    def make_dir(dir: str) -> None:
        if not SetupUtils.dir_exists(dir):
            os.mkdir(dir)
        
    def change_dir(dir: str) -> None:
        os.chdir(dir)
        
    def dir_exists(dir: str) -> bool:
        return os.path.exists(dir) and os.path.isdir(dir)
        
    def create_empty_file(path: str) -> None:
        f = open(path, "w+")
        f.close()


def setup_environment(scriptPath: str, arguments: dict) -> tuple[int, str]:
    # execute to allow for custom scripting
    scriptFile = open(scriptPath, "r")
    exec(scriptFile.read(), {"arguments": arguments, "SetupUtils": SetupUtils})

    return 0, f'Run "{scriptPath}" with no errors'


def get_arguments(scriptPath: str) -> dict:
    pass
