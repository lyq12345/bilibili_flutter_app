// 带lottie动画的加载进度组件

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover; //加载动画是够覆盖在原有界面上
  const LoadingContainer(
      {Key? key,
      required this.child,
      this.cover = false,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : Container()],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
    return Container();
  }

  Widget get _loadingView {
    return Center(
      child: Lottie.asset('assets/loading.json'),
    );
  }
}
