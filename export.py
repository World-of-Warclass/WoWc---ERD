import pkg_resources
import subprocess

def is_package_installed(package_name):
    try:
        pkg_resources.get_distribution(package_name)
        return True
    except pkg_resources.DistributionNotFound:
        return False

package_name = "weasyprint"

if not is_package_installed(package_name):
    try:
        subprocess.check_call(["python", "-m", "pip", "install", package_name])
    except subprocess.CalledProcessError:
        print(f"Failed to install {package_name}")
        print("Please check if you can install weasyprint")
        exit(1)
else:
    command = ["weasyprint", "wowc-erd-sql.html", "World_of_Warclass_ERD.pdf"]
    subprocess.run(command, check=True)