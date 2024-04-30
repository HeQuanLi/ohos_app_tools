class AudioInfoBean {
  String audioName; //音频名称
  String audioPath; //音频路径
  AudioStatus state = AudioStatus.no; //状态
  int? lufsValue; //lufs数值
  int audioResultState = -1; //-1:未检测，0:合格，1：风险，2：失败

  AudioInfoBean(this.audioName, this.audioPath);
}

enum AudioStatus {
  no, //未检测
  running, //检测中
  success, //检测成功
  failed, //检测失败
}
