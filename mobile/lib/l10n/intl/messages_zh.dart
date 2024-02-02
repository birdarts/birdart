// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(lat, lon, alt) => "经度：${lat}\n纬度：${lon}\n海拔：${alt}";

  static String m1(hour, minute) => "${hour}时${minute}分";

  static String m2(second) => "${second}秒";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "adult": MessageLookupByLibrary.simpleMessage("成鸟"),
        "ageUnknown": MessageLookupByLibrary.simpleMessage("年龄不详"),
        "bottomExplore": MessageLookupByLibrary.simpleMessage("探索"),
        "bottomHome": MessageLookupByLibrary.simpleMessage("首页"),
        "bottomMyBirdart": MessageLookupByLibrary.simpleMessage("我的Birdart"),
        "bottomRecords": MessageLookupByLibrary.simpleMessage("记录"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "databaseError": MessageLookupByLibrary.simpleMessage("数据库错误"),
        "exploreTitle": MessageLookupByLibrary.simpleMessage("探索周边"),
        "female": MessageLookupByLibrary.simpleMessage("雌鸟"),
        "forgetPassword": MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "homeBirding": MessageLookupByLibrary.simpleMessage("去观鸟！"),
        "homeDate": MessageLookupByLibrary.simpleMessage("日期"),
        "homeDisableTrack": MessageLookupByLibrary.simpleMessage("关闭轨迹记录"),
        "homeEnableTrack": MessageLookupByLibrary.simpleMessage("开启轨迹记录"),
        "homeJoinTeam": MessageLookupByLibrary.simpleMessage("加入观鸟队伍"),
        "homeOldRecord": MessageLookupByLibrary.simpleMessage("输入记录"),
        "homeTime": MessageLookupByLibrary.simpleMessage("时间"),
        "juvenile": MessageLookupByLibrary.simpleMessage("未成年"),
        "locationDisabled":
            MessageLookupByLibrary.simpleMessage("定位服务未开启，请开启定位服务"),
        "locationPermissionDenied":
            MessageLookupByLibrary.simpleMessage("位置权限已被永久拒绝，无法请求位置权限"),
        "loginAppError": MessageLookupByLibrary.simpleMessage("应用内部错误。"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("登陆失败。"),
        "loginFormConfirmNotMatch":
            MessageLookupByLibrary.simpleMessage("密码不匹配。"),
        "loginFormConfirmPassword":
            MessageLookupByLibrary.simpleMessage("确认密码"),
        "loginFormConfirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("请确认您的密码。"),
        "loginFormEmail": MessageLookupByLibrary.simpleMessage("电子邮箱"),
        "loginFormEmailFormat": MessageLookupByLibrary.simpleMessage("邮箱地址错误。"),
        "loginFormEmailHint":
            MessageLookupByLibrary.simpleMessage("请输入一个有效的邮箱地址。"),
        "loginFormPassword": MessageLookupByLibrary.simpleMessage("密码"),
        "loginFormPasswordFormat": MessageLookupByLibrary.simpleMessage(
            "密码应当至少包括8个字符，可以使用字母、数字、特殊符号。"),
        "loginFormPasswordHint":
            MessageLookupByLibrary.simpleMessage("请选择一个复杂的密码。"),
        "loginFormPasswordNotEmpty":
            MessageLookupByLibrary.simpleMessage("密码不能为空。"),
        "loginFormPhone": MessageLookupByLibrary.simpleMessage("电话号码"),
        "loginFormPhoneHint":
            MessageLookupByLibrary.simpleMessage("请输入一个有效的电话号码。"),
        "loginFormUsername": MessageLookupByLibrary.simpleMessage("用户名"),
        "loginFormUsernameHint":
            MessageLookupByLibrary.simpleMessage("请选择一个您喜欢的用户名。"),
        "loginFormVer": MessageLookupByLibrary.simpleMessage("验证码"),
        "loginFormVerFormat": MessageLookupByLibrary.simpleMessage("验证码不能为空。"),
        "loginFormVerHint":
            MessageLookupByLibrary.simpleMessage("请输入验证码，不区分大小写。"),
        "loginFromReset": MessageLookupByLibrary.simpleMessage("返回登录"),
        "loginHint": MessageLookupByLibrary.simpleMessage("已有账号？立刻登陆。"),
        "loginNetworkError": MessageLookupByLibrary.simpleMessage("网络错误。"),
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登陆成功。"),
        "male": MessageLookupByLibrary.simpleMessage("雄鸟"),
        "mapCoordinate": m0,
        "mapNameAgol": MessageLookupByLibrary.simpleMessage("Arcgis卫星图"),
        "mapNameOSM": MessageLookupByLibrary.simpleMessage("开放街道地图"),
        "mapNameSat": MessageLookupByLibrary.simpleMessage("卫星图"),
        "mapNameStamenTerrain":
            MessageLookupByLibrary.simpleMessage("Stamen地形图"),
        "mapNameTDT": MessageLookupByLibrary.simpleMessage("天地图"),
        "myAbout": MessageLookupByLibrary.simpleMessage("关于"),
        "myData": MessageLookupByLibrary.simpleMessage("数据中心"),
        "myLogin": MessageLookupByLibrary.simpleMessage("登陆"),
        "myOpenSource": MessageLookupByLibrary.simpleMessage("开放源代码"),
        "myRegister": MessageLookupByLibrary.simpleMessage("注册"),
        "myResetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
        "mySettings": MessageLookupByLibrary.simpleMessage("设置"),
        "myTitle": MessageLookupByLibrary.simpleMessage("个人中心"),
        "nestling": MessageLookupByLibrary.simpleMessage("幼鸟"),
        "networkError": MessageLookupByLibrary.simpleMessage("网络错误"),
        "newListAutoHotspot": MessageLookupByLibrary.simpleMessage("自动选择"),
        "newListSearch": MessageLookupByLibrary.simpleMessage("搜索鸟种"),
        "newListTrackDisabled": MessageLookupByLibrary.simpleMessage("轨迹记录关闭"),
        "newListTrackDuration": m1,
        "ok": MessageLookupByLibrary.simpleMessage("确认"),
        "profileChangeAvatar": MessageLookupByLibrary.simpleMessage("修改头像"),
        "profileChooseAvatar": MessageLookupByLibrary.simpleMessage("从手机选择头像"),
        "profileEditUserName": MessageLookupByLibrary.simpleMessage("修改用户名"),
        "profileEmail": MessageLookupByLibrary.simpleMessage("电子邮箱"),
        "profileEnterUserName": MessageLookupByLibrary.simpleMessage("输入用户名"),
        "profileLogout": MessageLookupByLibrary.simpleMessage("退出账号"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("个人资料"),
        "profileUserID": MessageLookupByLibrary.simpleMessage("用户ID"),
        "recordsTitle": MessageLookupByLibrary.simpleMessage("观鸟记录"),
        "registerFailed": MessageLookupByLibrary.simpleMessage("注册失败。"),
        "registerHint": MessageLookupByLibrary.simpleMessage("没有账号？现在注册。"),
        "registerNameLength":
            MessageLookupByLibrary.simpleMessage("用户名应包含至少6个字符。"),
        "registerNameNotEmpty":
            MessageLookupByLibrary.simpleMessage("用户名不能为空。"),
        "registerSuccess":
            MessageLookupByLibrary.simpleMessage("注册成功，请检查您的收件箱。"),
        "resetPasswordFailed": MessageLookupByLibrary.simpleMessage("找回密码失败。"),
        "resetPasswordSuccessful":
            MessageLookupByLibrary.simpleMessage("找回密码成功，请用新密码登陆。"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "settingsSelectTrackInterval":
            MessageLookupByLibrary.simpleMessage("选择轨迹时间间隔"),
        "settingsTrackInterval": MessageLookupByLibrary.simpleMessage("轨迹时间间隔"),
        "settingsTrackIntervalSeconds": m2,
        "settingsWifiSyncImage":
            MessageLookupByLibrary.simpleMessage("WiFi下自动同步图片"),
        "settingsWifiSyncTrack":
            MessageLookupByLibrary.simpleMessage("WiFi下自动同步轨迹"),
        "sexUnknown": MessageLookupByLibrary.simpleMessage("性别不详"),
        "smsCodeSendFailed": MessageLookupByLibrary.simpleMessage("短信发送失败。"),
        "smsCodeSendSuccessful":
            MessageLookupByLibrary.simpleMessage("短信发送成功，请及时查收。")
      };
}
