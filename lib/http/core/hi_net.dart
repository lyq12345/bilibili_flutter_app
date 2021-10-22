import 'package:flutter_application_1/http/request/base_request.dart';

class HiNet {
  HiNet._(); // 构造函数
  static HiNet? _instance = null; // 不实例化
  // 懒汉模式
  static HiNet? getInstance() {
    // 通过该函数向整个系统提供实例
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(BaseRequest request) async {
    var response = await send(request);
    var result = response['data'];
    printLog(result);
    return result;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    printLog('method:${request.httpMethod()}');
    request.addHeader("token", "123");
    printLog('header:${request.header}');
    return Future.value({
      "statusCode": 200,
      "data": {"code": 0, "message": "success"}
    });
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }
}
