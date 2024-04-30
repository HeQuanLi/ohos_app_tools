import 'dart:convert';
import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:path/path.dart' as p;

///
/// 通过命令得到带有响度值的 json，然后解析出对应的值，最终获得响度值
///
/// {
/// 	"input_i" : "-23.89",
/// 	"input_tp" : "-18.18",
/// 	"input_lra" : "4.20",
/// 	"input_thresh" : "-34.27",
/// 	"output_i" : "-24.11",
/// 	"output_tp" : "-18.54",
/// 	"output_lra" : "1.30",
/// 	"output_thresh" : "-34.53",
/// 	"normalization_type" : "dynamic",
/// 	"target_offset" : "0.11"
/// }
///
/// 源码参考：https://github.com/FFmpeg/FFmpeg/blob/master/tools/loudnorm.rb
///
Future<int> getAudioLUFS(String file) async {
  var shell = Shell(verbose: false);

  var ffmpegBin = "ffmpeg";
  if (Platform.isMacOS) {
    ffmpegBin = p.join(p.dirname(p.dirname(Platform.resolvedExecutable)),
        "Resources", "ffmpeg_bin", "ffmpeg");
  } else if (Platform.isWindows) {
    ffmpegBin = p.join(
        p.dirname(Platform.resolvedExecutable), "ffmpeg_bin", "ffmpeg.exe");
  }

  var shellResult = await shell.run(
      "$ffmpegBin -i '$file' -af loudnorm='I=-24.0:LRA=+11.0:tp=-2.0:print_format=json' -f null -");

  if (shellResult.first.exitCode != 0) throw Error();

  var text = shellResult.errText;

  Map<String, dynamic> data = json.decode(_getLast12Text(text));

  try {
    var lufs = double.parse(data['input_i']).round();
    return lufs;
  } on Exception {
    return -100;
  }
}

String _getLast12Text(String text) {
  List<String> lines = text.split("\n");
  String lastLines = lines.sublist(lines.length - 12).join('\n');
  return lastLines;
}
