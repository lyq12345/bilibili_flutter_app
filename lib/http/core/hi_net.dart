import 'package:flutter_application_1/http/core/dio_adapter.dart';
import 'package:flutter_application_1/http/core/hi_adapter.dart';
import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/core/mock_adapter.dart';
import 'package:flutter_application_1/http/request/base_request.dart';

class HiNet {
  HiNet._(); // 构造函数
  static HiNet? _instance; // 不实例化
  // 懒汉模式
  static HiNet? getInstance() {
    // 通过该函数向整个系统提供实例
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse response;
    var error;
    try {
      response = await send(request);
      var result = response.data;
      printLog(result);

      var status = response.statusCode;
      switch (status) {
        case 200:
          return result;
        case 401:
          throw NeedLogin();
        case 403:
          throw NeedAuth(result.toString(), data: result);
        default:
          throw HiNetError(status!, result.toString(), data: result);
      }
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    // mock 构建请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }
}
