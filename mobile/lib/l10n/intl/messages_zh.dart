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

  static String m1(second) => "${second} 秒";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bottomExplore": MessageLookupByLibrary.simpleMessage("探索"),
        "bottomHome": MessageLookupByLibrary.simpleMessage("首页"),
        "bottomMyBirdart": MessageLookupByLibrary.simpleMessage("我的Birdart"),
        "bottomRecords": MessageLookupByLibrary.simpleMessage("记录"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "databaseError": MessageLookupByLibrary.simpleMessage("数据库错误"),
        "exploreTitle": MessageLookupByLibrary.simpleMessage("探索周边"),
        "homeBirding": MessageLookupByLibrary.simpleMessage("去观鸟！"),
        "homeDate": MessageLookupByLibrary.simpleMessage("日期"),
        "homeDisableTrack": MessageLookupByLibrary.simpleMessage("关闭轨迹记录"),
        "homeEnableTrack": MessageLookupByLibrary.simpleMessage("开启轨迹记录"),
        "homeJoinTeam": MessageLookupByLibrary.simpleMessage("加入观鸟队伍"),
        "homeOldRecord": MessageLookupByLibrary.simpleMessage("输入记录"),
        "homeTime": MessageLookupByLibrary.simpleMessage("时间"),
        "mapCoordinate": m0,
        "mapNameOSM": MessageLookupByLibrary.simpleMessage("开放街道地图"),
        "mapNameSat": MessageLookupByLibrary.simpleMessage("卫星图"),
        "mapNameTDT": MessageLookupByLibrary.simpleMessage("天地图"),
        "myAbout": MessageLookupByLibrary.simpleMessage("关于"),
        "myData": MessageLookupByLibrary.simpleMessage("数据中心"),
        "myLogin": MessageLookupByLibrary.simpleMessage("登陆"),
        "myOpenSource": MessageLookupByLibrary.simpleMessage("开放源代码"),
        "myRegister": MessageLookupByLibrary.simpleMessage("注册"),
        "mySettings": MessageLookupByLibrary.simpleMessage("设置"),
        "myTitle": MessageLookupByLibrary.simpleMessage("个人中心"),
        "networkError": MessageLookupByLibrary.simpleMessage("网络错误"),
        "ok": MessageLookupByLibrary.simpleMessage("确认"),
        "recordsTitle": MessageLookupByLibrary.simpleMessage("观鸟记录"),
        "settingsSelectTrackInterval":
            MessageLookupByLibrary.simpleMessage("选择轨迹时间间隔"),
        "settingsTrackInterval": MessageLookupByLibrary.simpleMessage("轨迹时间间隔"),
        "settingsTrackIntervalSeconds": m1,
        "settingsWifiSyncImage":
            MessageLookupByLibrary.simpleMessage("WiFi下自动同步图片"),
        "settingsWifiSyncTrack":
            MessageLookupByLibrary.simpleMessage("WiFi下自动同步轨迹")
      };
}
