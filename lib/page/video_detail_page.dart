import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/video_model.dart';
import 'package:flutter_application_1/widget/appbar.dart';
import 'package:flutter_application_1/widget/navigation_bar.dart';
import 'package:flutter_application_1/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel;
  const VideoDetailPage(
    this.videoModel, {
    Key? key,
  }) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(
            children: [
              if (Platform.isIOS)
                NavigationBar(
                  color: Colors.black,
                  statusStyle: StatusStyle.LIGHT_CONTENT,
                ),
              _videoView(),
              Text('视频详情页, vid:${widget.videoModel.vid}'),
              Text('视频详情页, vid:${widget.videoModel.title}'),
            ],
          )),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }
}
