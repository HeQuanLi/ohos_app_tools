import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ohos_app_tools/utils/padding_utils.dart';

import '../bean/sing_path_info.dart';
import '../static/assets_svg.dart';
import '../utils/constant_utils.dart';
import '../utils/shared_preferences_utils.dart';
import '../utils/text_utils.dart';
import '../widgets/common/svg_asset.dart';

class SettingDialog extends StatefulWidget {
  final Function(SingPathInfo) callback;

  const SettingDialog({required this.callback, super.key});

  @override
  State<SettingDialog> createState() => _SettingDialog();
}

class _SettingDialog extends State<SettingDialog> {
  late Function(SingPathInfo) callback;
  final _signToolPathController = TextEditingController();
  final _cerPathController = TextEditingController();
  final _p7bPathController = TextEditingController();
  final _p12PathController = TextEditingController();
  final _aliasController = TextEditingController();
  final _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callback = widget.callback;
    _getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              width: 550,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _titleRegion(),
                  padding(top: 20),
                  itemConfig("签名工具：", true, _signToolPathController),
                  itemConfig(".cer地址：", true, _cerPathController),
                  itemConfig(".p7b地址：", true, _p7bPathController),
                  itemConfig(".p12地址：", true, _p12PathController),
                  itemConfig("alias：", false, _aliasController),
                  itemConfig("密码：", false, _pwdController),
                  sureBtn()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _titleRegion() {
    return Row(
      children: [
        Expanded(
          child: normalText(
            "配置参数",
            fontSize: 18,
            color: 0xFF404040,
          ),
        ),
        InkWell(
          child: svgAsset(AssetsSvg.close, width: 20, height: 21),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget itemConfig(
      String title, bool showBtn, TextEditingController controller) {
    return padding(
      top: 10,
      child: Row(
        children: [
          Container(
            width: 80,
            alignment: Alignment.centerRight,
            child: Text(title),
          ),
          Expanded(
            child: _inputContent(controller),
          ),
          Visibility(
            visible: showBtn,
            child: padding(
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  _chooseFile(controller);
                },
                child: const Text("浏览"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sureBtn() {
    return padding(
      top: 20,
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            _savePath();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          ),
          child: const Text(
            "确定",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputContent(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xFFC7D440),
      autocorrect: false,
      maxLines: 1,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC7D440)), // 设置默认边框颜色
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC7D440)), // 设置聚焦时的边框颜色
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }

  _chooseFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        final realPath = _getRemainingPath(path);
        controller.text = realPath;
      }
    }
  }

  String _getRemainingPath(String path) {
    // 查找"Users"的索引
    int index = path.indexOf("Users");
    if (index != -1) {
      // 获取索引后面的内容
      return path.substring(index - 1);
    } else {
      // 如果找不到"Users"，返回原始路径
      return path;
    }
  }

  _savePath() {
    final singPathInfo = SingPathInfo(
        _signToolPathController.text,
        _cerPathController.text,
        _p7bPathController.text,
        _p12PathController.text,
        _aliasController.text,
        _pwdController.text);
    _saveValue(jsonEncode(singPathInfo.toJson()));
    Navigator.pop(context);
    callback(singPathInfo);
  }

  _saveValue(String data) async {
    await SharedPreferencesUtil.saveString(ConstantUtils.signPathInfo, data);
  }

  _getValue() async {
    var result =
        await SharedPreferencesUtil.getString(ConstantUtils.signPathInfo);
    if (result != null) {
      Map<String, dynamic> map = json.decode(result);
      SingPathInfo singPathInfo = SingPathInfo.fromJson(map);
      _signToolPathController.text = singPathInfo.signToolPath;
      _cerPathController.text = singPathInfo.cerPath;
      _p7bPathController.text = singPathInfo.p7bPath;
      _p12PathController.text = singPathInfo.p12Path;
      _aliasController.text = singPathInfo.alias;
      _pwdController.text = singPathInfo.pwd;
    }
  }
}
