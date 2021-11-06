import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/core/hi_error.dart';
import 'package:flutter_application_1/http/dao/login_dao.dart';
import 'package:flutter_application_1/navigator/hi_navigator.dart';
import 'package:flutter_application_1/util/string_util.dart';
import 'package:flutter_application_1/util/toast.dart';
import 'package:flutter_application_1/widget/appbar.dart';
import 'package:flutter_application_1/widget/login_button.dart';
import 'package:flutter_application_1/widget/login_effect.dart';
import 'package:flutter_application_1/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  // final VoidCallback onJumpToLogin;
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("注册", "登录", () {
          HiNavigator.getInstance().onJumpTo(RouteStatus.login);
        }),
        body: Container(
          child: ListView(
            // 自适应键盘弹起 防止遮挡
            children: [
              LoginEffect(
                protect: protect,
              ),
              LoginInput(
                "用户名",
                "请输入用户名",
                onChanged: (text) {
                  userName = text;
                  // print(text);
                  checkInput();
                },
              ),
              LoginInput(
                "密码",
                "请输入密码",
                onChanged: (text) {
                  password = text;
                  checkInput();
                },
                focusChanged: (focus) {
                  this.setState(() {
                    protect = focus;
                  });
                },
                obscureText: true,
              ),
              LoginInput(
                "确认密码",
                "请重新输入密码",
                onChanged: (text) {
                  rePassword = text;
                  checkInput();
                },
                focusChanged: (focus) {
                  this.setState(() {
                    protect = focus;
                  });
                },
                obscureText: true,
                lineStretch: true,
              ),
              LoginInput(
                "慕课网ID",
                "请输入你的慕课网用户ID",
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  imoocId = text;
                  checkInput();
                },
              ),
              LoginInput(
                "订单号",
                "请输入你的订单号后四位",
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  orderId = text;
                  checkInput();
                },
                lineStretch: true,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: LoginButton(
                  '注册',
                  enable: loginEnable,
                  onPressed: checkParams,
                ),
              )
            ],
          ),
        ));
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        } else {
          print('loginEnable is false');
        }
      },
      child: Text('注册'),
    );
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(userName!, password!, imoocId!, orderId!);
      print(result);
      if (result['code'] == 0) {
        print('注册成功！');
        showToast('注册成功！');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致！';
    } else if (orderId?.length != 4) {
      tips = '请输入订单号后四位！';
    }
    if (tips != null) {
      print(tips);
      return;
    } else {
      send();
    }
  }
}
