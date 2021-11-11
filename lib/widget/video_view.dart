import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/util/color.dart';
import 'package:flutter_application_1/util/view_util.dart';
import 'package:flutter_application_1/widget/hi_video_controls.dart';
import 'package:orientation/orientation.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

// 播放器组件
class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget overlayUI;
  const VideoView(this.url,
      {Key? key,
      this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      required this.overlayUI})
      : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController; //chiwie播放器controller
  //封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover!),
      );
  //进度条颜色设置
  get _progressColors => ChewieProgressColors(
        playedColor: primary,
        handleColor: primary,
        backgroundColor: Colors.grey,
        bufferedColor: primary[50]!,
      );

  @override
  void initState() {
    super.initState();
    // 初始化播放器设置
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      allowMuting: false,
      allowPlaybackSpeedChanging: false,
      placeholder: _placeholder,
      materialProgressColors: _progressColors,
      customControls: MaterialControls(
        showLoadingOnInitialize: false,
        showBigPlayIcon: false,
        bottomGradient: blackLinearGradient(),
        overlayUI: widget.overlayUI,
      ),
    );
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(controller: _chewieController),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
