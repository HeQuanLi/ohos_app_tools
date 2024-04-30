import 'dart:io';

class FileUtils {
  /// @param path 路径
  /// @param list 返回文件地址
  /// @param filterFormats 过滤文件格式
  static Future<List<String>> readFile(
      String path, List<String> list, List<String>? filterFormats) async {
    if (await FileSystemEntity.isDirectory(path)) {
      Directory folder = Directory(path);
      await for (var entity in folder.list()) {
        list = await readFile(entity.path, list, filterFormats);
      }
    } else {
      if (await FileSystemEntity.isFile(path)) {
        if (filterFormats != null) {
          for (var element in filterFormats) {
            if (path.endsWith(element)) {
              list.add(path);
              break; // 一旦文件已添加，就不需要再继续循环
            }
          }
        } else {
          list.add(path);
        }
      }
    }
    return list;
  }
}
