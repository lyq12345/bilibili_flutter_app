import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/home_mo.dart';
import 'package:flutter_application_1/navigator/hi_navigator.dart';
import 'package:flutter_application_1/util/format_util.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoCard extends StatelessWidget {
  final VideoMo? videoMo;
  const VideoCard({Key? key, this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(videoMo?.url);
          HiNavigator.getInstance()
              .onJumpTo(RouteStatus.detail, args: {"videoMo": videoMo});
        },
        child: SizedBox(
          height: 200,
          child: Card(
            //取消卡片边距
            margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemImage(context),
                  _infoText(),
                ],
              ),
            ),
          ),
        ));
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        FadeInImage.memoryNetwork(
          height: 120,
          width: size.width / 2 - 20,
          placeholder: kTransparentImage,
          image: videoMo!.cover!,
          fit: BoxFit.cover,
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
              decoration: BoxDecoration(
                  //线性渐变
                  gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoMo!.view!),
                  _iconText(Icons.favorite_border, videoMo!.favorite!),
                  _iconText(null, videoMo!.duration!)
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoMo!.duration!);
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }

  _infoText() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoMo!.title!,
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _owner()
        ],
      ),
    ));
  }

  _owner() {
    var owner = videoMo!.owner;
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                owner!.face!,
                width: 24,
                height: 24,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner.name!,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            )
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
