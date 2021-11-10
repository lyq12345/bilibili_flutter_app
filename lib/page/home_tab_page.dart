import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/dao/home_dao.dart';
import 'package:flutter_application_1/model/home_mo.dart';
import 'package:flutter_application_1/model/video_model.dart';
import 'package:flutter_application_1/util/color.dart';
import 'package:flutter_application_1/widget/hi_banner.dart';
import 'package:flutter_application_1/util/toast.dart';
import 'package:flutter_application_1/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;
  const HomeTabPage({
    this.bannerList,
    required this.categoryName,
    Key? key,
  }) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoMo> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      // print('dis:${dis}');
      if (dis < 300 && !_loading) {
        print('------------------_loadData_________');
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              physics:
                  const AlwaysScrollableScrollPhysics(), //允许滚动，防止列表不足以充满页面时上拉加载失效
              controller: _scrollController,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              crossAxisCount: 2,
              itemCount: videoList.length,
              itemBuilder: (BuildContext context, int index) {
                //有banner的时候第一个item位置显示banner
                if (widget.bannerList != null && index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  );
                } else {
                  return VideoCard(
                    videoMo: videoList[index],
                  );
                }
              },
              staggeredTileBuilder: (int index) {
                if (widget.bannerList != null && index == 0) {
                  return StaggeredTile.fit(2);
                } else {
                  return StaggeredTile.fit(1);
                }
              })),
      onRefresh: _loadData,
      color: primary,
    );
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            // 合成新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      // 临界值，延迟1秒后再loading变成true
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
