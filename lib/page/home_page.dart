import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/hi_state.dart';
import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/dao/home_dao.dart';
import 'package:flutter_application_1/model/home_mo.dart';
import 'package:flutter_application_1/navigator/hi_navigator.dart';
import 'package:flutter_application_1/page/home_tab_page.dart';
import 'package:flutter_application_1/page/profile_page.dart';
import 'package:flutter_application_1/page/video_detail_page.dart';
import 'package:flutter_application_1/util/color.dart';
import 'package:flutter_application_1/util/toast.dart';
import 'package:flutter_application_1/widget/hi_tab.dart';
import 'package:flutter_application_1/widget/loading_container.dart';
import 'package:flutter_application_1/widget/navigation_bar.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  late TabController _controller;
  bool _isLoading = true;
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    // 页面初始化时注册一个监听
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('current:${current.page}');
      print('pre:${pre.page}');
      this._currentPage = current.page;
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页：onPause');
      }
      //当页面返回到首页恢复首页的状态栏样式
      if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
        // var statusStyle = StatusStyle.DARK_CONTENT;
        // changeStatusBar()
      }
    });
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    HiNavigator.getInstance().removeListener(this.listener);
    _controller.dispose();
    super.dispose();
  }

  // 监听生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState: ${state}');
    switch (state) {
      case AppLifecycleState.inactive: // 出于这种状态下的应用假设他们可能在仍核实后暂停
        break;
      case AppLifecycleState.resumed: // 从后台切换前台，界面可见
        // fix 安卓压后台，状态栏字体变白问题
        // if (!(_currentPage is VideoDetailPage)) {
        //   changeStatusBar()
        // }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // app结束时调用
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
            child: Column(
              children: [
                NavigationBar(
                  height: 50,
                  child: _appBar(),
                  color: Colors.white,
                  statusStyle: StatusStyle.DARK_CONTENT,
                ),
                Container(
                  color: Colors.white,
                  child: _tabBar(),
                ),
                Flexible(
                    child: TabBarView(
                        controller: _controller,
                        children: categoryList.map((tab) {
                          return HomeTabPage(
                            bannerList: tab.name == '推荐' ? bannerList : null,
                            categoryName: tab.name,
                          );
                        }).toList()))
              ],
            ),
            isLoading: _isLoading));
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          text: tab.name,
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      insets: 13,
      unselectedLabelColor: Colors.black54,
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      print("loadData():${result}");
      if (result.categoryList != null) {
        _controller =
            TabController(length: result.categoryList!.length, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList!;
        bannerList = result.bannerList!;
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: Image(
              height: 46,
              width: 46,
              image: AssetImage('images/avatar.png'),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
