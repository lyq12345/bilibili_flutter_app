import 'package:flutter/material.dart';
//可自定义样式的沉浸式导航栏

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;
  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _statusBarInit();
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height + top,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  // TODO: flutter_status_manager不支持空安全
  // void _statusBarInit() {
  //   //沉浸式状态栏样式
  //   FlutterStatusbarManager.setColor(color, animated: false);
  //   FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
  //       ? StatusBarStyle.DARK_CONTENT
  //       : StatusBarStyle.LIGHT_CONTENT);
  // }
}
