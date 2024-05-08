import zipfile
import os
import subprocess
import sys

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

if __name__ == "__main__":
    # 检查是否提供了正确的参数数量
    if len(sys.argv) < 2:
        print("Usage: python script.py app_file package_name")
        sys.exit(1)

    # 从命令行参数中获取传入的值
    app_file = sys.argv[1]
    package_name = sys.argv[2]

    app_file_path = os.path.dirname(app_file)
    extracted_dir = app_file_path + "/zip"

    print("app_file："+app_file)
    print("package_name："+package_name)

    # 调用函数并传入参数
    unzip_app_and_send_files(app_file, package_name, extracted_dir)
