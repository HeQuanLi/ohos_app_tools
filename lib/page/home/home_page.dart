import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';
import 'view/home_content_view.dart';
import 'view/home_operate_view.dart';
import 'view/home_title_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setWindowSize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(),
      child: _scaffold(),
    );
  }

  Widget _scaffold() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        var bloc = context.read<HomeBloc>();
        return Scaffold(
          body: Column(
            children: [
              if (Platform.isMacOS) const HomeTitleView(), //标题区域
              HomeOperateView(bloc: bloc, state: state), //操作区域
              HomeContentView(bloc: bloc, state: state), //内容区域
            ],
          ),
        );
      },
    );
  }

  Future setWindowSize() async {
    const size = Size(600, 600);
    await DesktopWindow.setWindowSize(size);
    await DesktopWindow.setMinWindowSize(size);
  }
}
