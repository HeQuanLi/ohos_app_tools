import zipfile
import os
import subprocess
import shutil

def unzip_app_and_send_files(app_file, package_name, extracted_dir, signed_dir):
    clean_directories(extracted_dir, signed_dir, out_put_file_dir)
    unzip_app(app_file, signed_dir, extracted_dir)
    signed_app(extracted_dir, signed_dir)
    zip_signed_files(signed_dir)

def clean_directories(*directories):
    for directory in directories:
        if os.path.exists(directory):
            shutil.rmtree(directory)
        os.makedirs(directory)

def unzip_app(app_file, signed_dir, output_dir):
    print("开始解压APP")
    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(signed_dir, exist_ok=True)
    with zipfile.ZipFile(app_file, 'r') as zip_ref:
        zip_ref.extractall(output_dir)
    print("解压成功")

def signed_app(extracted_dir, signed_dir):
    print("开始签名APP")
    sign_files(extracted_dir, signed_dir, '.hap')
    sign_files(extracted_dir, signed_dir, '.hsp')
    print("签名完成")

def sign_files(source_dir, target_dir, extension):
    files = [f for f in os.listdir(source_dir) if f.endswith(extension)]
    for file in files:
        sign_file(source_dir, target_dir, file)

def sign_file(source_dir, target_dir, file):
    sign_command = f"java -jar {hap_sign_tool} sign-app -keyAlias {alias} -signAlg \"SHA256withECDSA\" -mode \"localSign\" -appCertFile \"{cer_path}\" -profileFile \"{profile_file_path}\" -inFile \"{os.path.join(source_dir, file)}\" -keystoreFile \"{k12_path}\" -outFile \"{target_dir}/{file.split('.')[0]}-signed.{file.split('.')[1]}\" -keyPwd \"{pwd}\" -keystorePwd \"{pwd}\""
    subprocess.run(sign_command, shell=True)

def zip_signed_files(signed_dir):
    os.makedirs(os.path.dirname(out_put_file_path), exist_ok=True)
    print("开始压缩已签名文件")
    with zipfile.ZipFile(out_put_file_path, 'w') as zip_ref:
        for root, _, files in os.walk(signed_dir):
            for file in files:
                zip_ref.write(os.path.join(root, file), os.path.relpath(os.path.join(root, file), signed_dir))
    print("压缩完成")

# 示例用法：
app_file = "/Users/hequanli/Desktop/ohos/jojo-read-default-signed.app"
hap_sign_tool = "/Users/hequanli/Library/Huawei/Sdk/HarmonyOS-NEXT-DP2/base/toolchains/lib/hap-sign-tool.jar"
cer_path = "/Users/hequanli/HarmonyCode/jojo-read/cer/jojo-ohos-debug.cer" 
profile_file_path="/Users/hequanli/HarmonyCode/jojo-read/cer/jojo-ohos-debug.p7b"
k12_path = "/Users/hequanli/HarmonyCode/jojo-read/cer/jojo-ohos.p12"
alias = "ohos"
pwd = "TNT999233"

app_file_path = os.path.dirname(app_file)
file_name = os.path.basename(app_file)
package_name = "com.shusheng.hm.JoJoRead"
extracted_dir = app_file_path + "/zip"
signed_dir = app_file_path + "/signed"
out_put_file_dir = app_file_path + "/out/"
out_put_file_path = out_put_file_dir + file_name

unzip_app_and_send_files(app_file, package_name, extracted_dir, signed_dir)
