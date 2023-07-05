import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CoordinateTool {
  /// 将 112/1,58/1,390971/10000 格式的经纬度转换成 112.99434397362694格式
  /// @param dms 度分秒
  /// @return 度
  static double dmsToDegree(String dms) {
    var dimensionality = 0.0;

    //用 ，将数值分成3份
    var split = dms.split(",");
    for (int i = 0; i < split.length; i++) {
      var s = split[i].split("/");
      //用112/1得到度分秒数值
      var v = double.parse(s[0]) / double.parse(s[1]);
      //将分秒分别除以60和3600得到度，并将度分秒相加
      dimensionality += v / pow(60, i);
    }
    return dimensionality;
  }

  //获取小数部分
  static double _getDPoint(double num) {
    var fInt = num.toInt();
    return (num - fInt).toDouble();
  }

  //double 经纬度 获取度分秒
  static String degreeToDms(String str) {
    var num = 0.0;
    try {
      num = double.parse(str);
    } catch (e) {
      debugPrint(e.toString());
    }
    final degree = num.abs().floor().toInt(); //获取整数部分
    final temp = _getDPoint(num.abs()) * 60;
    final minute = temp.floor().toInt(); //获取整数部分
    final second = _getDPoint(temp) * 60;
    return "$degree°$minute′${second.toStringAsFixed(2)}″";
  }

  static double distance(double lat1, double lon1, double lat2, double lon2) =>
      acos(sin(lat1.rad) * sin(lat2.rad) +
          cos(lat1.rad) * cos(lat2.rad) * cos(lon2.rad - lon1.rad)) *
      6371.0;
}

extension _DegToRad on double {
  double get rad => this * pi / 180;
}
