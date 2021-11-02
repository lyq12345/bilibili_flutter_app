import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }
// 基础请求

abstract class BaseRequest {
  var pathParams;
  var useHttps = true;
  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    // Http和Https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();
  Map<String, String> params = Map();
  // 添加参数
  BaseRequest add(String k, Object? v) {
    params[k] = v.toString();
    return this;
  }

  // Map<String, dynamic> header = Map();
  Map<String, dynamic> header = {
    'course-flag': 'fa',
    //https://coding.imooc.com/class/487.html 公告获取
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa',
    // 'boarding-pass': '登录成功返回的boarding-pass'
  };

  // 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
