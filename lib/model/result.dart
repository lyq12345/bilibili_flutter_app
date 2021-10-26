import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  // 定义字段
  int? code;
  String? method;
  String? requstPrams;
  Result(this.code, this.method, this.requstPrams);
  // 设置固定格式mixin
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
