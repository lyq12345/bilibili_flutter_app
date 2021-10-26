// 测试适配器， mock数据

// import 'package:dio/dio.dart';
// import 'package:flutter_application_1/http/core/hi_adapter.dart';
// import 'package:flutter_application_1/http/core/hi_error.dart';
// import 'package:flutter_application_1/http/request/base_request.dart';

// class MockAdapter extends HiNetAdapter {
//   @override
//   Future<HiNetResponse<T>> send<T>(BaseRequest request) {
//     return Future.delayed(Duration(milliseconds: 1000), () {
//       HiNetResponse<Map<String, Object>> response = HiNetResponse(
//           data: {"code": 0, "message": 'success'}, statusCode: 403);
//           return response;
//     });
      
//   }
// }
