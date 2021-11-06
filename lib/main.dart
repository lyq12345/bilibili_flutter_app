import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/hi_cache.dart';
import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/core/hi_net.dart';
import 'package:flutter_application_1/http/dao/login_dao.dart';
import 'package:flutter_application_1/http/request/notice_request.dart';
import 'package:flutter_application_1/http/request/test_request.dart';
import 'package:flutter_application_1/model/owner.dart';
import 'package:flutter_application_1/model/video_model.dart';
import 'package:flutter_application_1/navigator/bottom_navigator.dart';
import 'package:flutter_application_1/navigator/hi_navigator.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:flutter_application_1/page/login_page.dart';
import 'dart:convert';

import 'package:flutter_application_1/page/registration_page.dart';
import 'package:flutter_application_1/page/video_detail_page.dart';
import 'package:flutter_application_1/util/color.dart';
import 'package:flutter_application_1/util/toast.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _biliRouteDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        // 进行初始化
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _biliRouteDelegate)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  // 为Navigator设置一个Key，必要的时候可以通过navigatorkey.currentState来获取到NavigatorState对象

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args?['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  bool get hasLogin => LoginDao.getBoardingPass() != null;
  @override
  Widget build(BuildContext context) {
    // 管理路由堆栈
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已经存在，则将该页面和它上面的所有页面进行出栈
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其他页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }

    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];

    // 通知路由发生变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
        // 修复Android物理返回键无法返回上一页的问题
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              // 登录页拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast("请先登录");
                  return false;
                }
              }
            }
            // 执行返回操作
            if (!route.didPop(result)) {
              return false;
            }
            var tempPages = [...pages]; // 旧
            pages.removeLast(); // 新
            // 通知路由发生变化
            HiNavigator.getInstance().notify(pages, tempPages);
            return true;
          },
        ),
        onWillPop: () async => !await navigatorKey.currentState!.maybePop());
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
