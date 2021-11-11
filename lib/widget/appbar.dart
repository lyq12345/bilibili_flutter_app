// 自定义顶部app bar
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/view_util.dart';

appBar(String title, String rightTitle, VoidCallback righButtonCallback) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    actions: [
      InkWell(
        onTap: righButtonCallback,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

// 视频详情页app bar
videoAppBar() {
  return Container(
    padding: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(
          color: Colors.white,
        ),
        Row(
          children: [
            Icon(
              Icons.live_tv_rounded,
              color: Colors.white,
              size: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 20,
              ),
            )
          ],
        )
      ],
    ),
  );
}
