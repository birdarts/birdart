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

  static String m0(month, day, year) => "${year}年${month}月${day}日";

  static String m1(lat, lon, alt) => "经度：${lat}\n纬度：${lon}\n海拔：${alt}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bottomExplore": MessageLookupByLibrary.simpleMessage("探索"),
        "bottomHome": MessageLookupByLibrary.simpleMessage("首页"),
        "bottomMyBirdart": MessageLookupByLibrary.simpleMessage("我的Birdart"),
        "bottomRecords": MessageLookupByLibrary.simpleMessage("记录"),
        "homeBirding": MessageLookupByLibrary.simpleMessage("去观鸟！"),
        "homeDate": MessageLookupByLibrary.simpleMessage("日期"),
        "homeDateFormat": m0,
        "homeEnableTrack": MessageLookupByLibrary.simpleMessage("开启轨迹记录"),
        "homeJoinTeam": MessageLookupByLibrary.simpleMessage("加入观鸟队伍"),
        "homeTime": MessageLookupByLibrary.simpleMessage("时间"),
        "mapCoordinate": m1,
        "mapNameOSM": MessageLookupByLibrary.simpleMessage("开放街道地图"),
        "mapNameSat": MessageLookupByLibrary.simpleMessage("卫星图"),
        "mapNameTDT": MessageLookupByLibrary.simpleMessage("天地图")
      };
}
