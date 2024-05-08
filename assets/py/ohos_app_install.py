import zipfile
import os
import subprocess

def unzip_app_and_send_files(app_file, package_name, extracted_dir):
    unzip_app(app_file, extracted_dir)
    stop_and_uninstall_app(package_name)
    send_files_to_device(extracted_dir, package_name)
    start_app(package_name)

def unzip_app(app_file, output_dir):
    print("开始解压APP")
    os.makedirs(output_dir, exist_ok=True)
    with zipfile.ZipFile(app_file, 'r') as zip_ref:
        zip_ref.extractall(output_dir)
    print("解压成功")

def stop_and_uninstall_app(package_name):
    print("停止并卸载应用")
    subprocess.run(f"hdc shell aa force-stop {package_name}", shell=True)
    subprocess.run(f"hdc uninstall {package_name}", shell=True)
    subprocess.run("hdc shell rm -rf data/local/tmp/6927085eaa4645068468e40d6c797292", shell=True)
    subprocess.run("hdc shell mkdir data/local/tmp/6927085eaa4645068468e40d6c797292", shell=True)

def send_files_to_device(extracted_dir, package_name):
    print("发送文件到设备")
    files = [f for f in os.listdir(extracted_dir) if f.endswith('.hap') or f.endswith('.hsp')]
    for file in files:
        subprocess.run(f"hdc file send {os.path.join(extracted_dir, file)} data/local/tmp/6927085eaa4645068468e40d6c797292", shell=True)

def start_app(package_name):
    print("启动应用")
    subprocess.run(f"hdc shell bm install -p data/local/tmp/6927085eaa4645068468e40d6c797292", shell=True)
    subprocess.run(f"hdc shell rm -rf data/local/tmp/6927085eaa4645068468e40d6c797292", shell=True)
    subprocess.run(f"hdc shell aa start -a AppAbility -b {package_name}", shell=True)
    print("启动成功")

# 示例用法：
app_file = "/Users/hequanli/Desktop/ohos/out/jojo-read-default-signed.app"
package_name = "com.shusheng.hm.JoJoRead"

app_file_path = os.path.dirname(app_file)
extracted_dir = app_file_path + "/zip"
unzip_app_and_send_files(app_file, package_name, extracted_dir)
