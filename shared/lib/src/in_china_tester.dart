import 'dart:math';

import 'package:latlong2/latlong.dart' show LatLng;

const double pi = 3.1415926535897932384626;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const List<LatLng> outerChina = [
  LatLng(50.054, 87.377),
  LatLng(39.458, 73.007),
  LatLng(31.002, 78.807),
  LatLng(29.712, 81.136),
  LatLng(26.810, 88.607),
  LatLng(26.496, 92.430),
  LatLng(27.747, 98.143),
  LatLng(23.630, 97.176),
  LatLng(23.871, 98.627),
  LatLng(21.806, 99.066),
  LatLng(20.782, 101.835),
  LatLng(22.173, 102.274),
  LatLng(22.579, 105.614),
  LatLng(20.947, 107.723),
  LatLng(19.462, 106.757),
  LatLng(14.079, 109.701),
  LatLng(5.644, 106.625),
  LatLng(2.883, 110.887),
  LatLng(6.256, 115.897),
  LatLng(24.513, 122.884),
  LatLng(25.983, 124.950),
  LatLng(39.492, 124.247),
  LatLng(42.282, 130.839),
  LatLng(44.922, 133.519),
  LatLng(48.767, 135.541),
  LatLng(47.861, 131.542),
  LatLng(48.998, 130.926),
  LatLng(49.856, 128.026),
  LatLng(53.505, 126.005),
  LatLng(53.739, 121.610),
  LatLng(52.740, 119.589),
  LatLng(49.913, 116.337),
  LatLng(47.625, 115.106),
  LatLng(47.149, 119.281),
  LatLng(45.202, 111.810),
  LatLng(42.054, 105.087),
  LatLng(43.314, 97.001),
  LatLng(50.054, 87.377),
];
const List<LatLng> innerChina = [
  LatLng(48.214, 87.377),
  LatLng(41.868, 80.445),
  LatLng(39.254, 74.325),
  LatLng(35.605, 78.817),
  LatLng(31.528, 80.214),
  LatLng(30.586, 81.927),
  LatLng(28.097, 87.223),
  LatLng(28.368, 91.771),
  LatLng(27.146, 92.353),
  LatLng(28.908, 97.616),
  LatLng(26.819, 99.523),
  LatLng(24.253, 97.836),
  LatLng(24.333, 99.044),
  LatLng(22.356, 99.945),
  LatLng(21.684, 101.527),
  LatLng(22.680, 101.417),
  LatLng(23.590, 106.053),
  LatLng(21.581, 108.273),
  LatLng(19.441, 108.053),
  LatLng(14.292, 111.634),
  LatLng(6.758, 109.943),
  LatLng(7.369, 113.700),
  LatLng(13.951, 116.864),
  LatLng(23.630, 121.918),
  LatLng(30.207, 123.544),
  LatLng(40.234, 124.027),
  LatLng(43.121, 129.608),
  LatLng(45.233, 131.102),
  LatLng(47.950, 134.310),
  LatLng(47.358, 130.839),
  LatLng(48.767, 130.135),
  LatLng(49.629, 127.367),
  LatLng(52.793, 125.741),
  LatLng(53.295, 122.006),
  LatLng(52.580, 121.258),
  LatLng(49.997, 119.413),
  LatLng(48.097, 116.205),
  LatLng(48.302, 119.720),
  LatLng(46.669, 120.424),
  LatLng(40.735, 106.581),
  LatLng(43.057, 92.826),
  LatLng(48.214, 87.377)
];

const List<LatLng> accurateChina = [
  LatLng(27.32083, 88.91693),
  LatLng(27.54243, 88.76464),
  LatLng(28.00805, 88.83575),
  LatLng(28.1168, 88.62435),
  LatLng(27.86605, 88.14279),
  LatLng(27.82305, 87.19275),
  LatLng(28.11166, 86.69527),
  LatLng(27.90888, 86.45137),
  LatLng(28.15805, 86.19769),
  LatLng(27.88625, 86.0054),
  LatLng(28.27916, 85.72137),
  LatLng(28.30666, 85.11095),
  LatLng(28.59104, 85.19518),
  LatLng(28.54444, 84.84665),
  LatLng(28.73402, 84.48623),
  LatLng(29.26097, 84.11651),
  LatLng(29.18902, 83.5479),
  LatLng(29.63166, 83.19109),
  LatLng(30.06923, 82.17525),
  LatLng(30.33444, 82.11123),
  LatLng(30.385, 81.42623),
  LatLng(30.01194, 81.23221),
  LatLng(30.20435, 81.02536),
  LatLng(30.57552, 80.207),
  LatLng(30.73374, 80.25423),
  LatLng(30.96583, 79.86304),
  LatLng(30.95708, 79.55429),
  LatLng(31.43729, 79.08082),
  LatLng(31.30895, 78.76825),
  LatLng(31.96847, 78.77075),
  LatLng(32.24304, 78.47594),
  LatLng(32.5561, 78.40595),
  LatLng(32.63902, 78.74623),
  LatLng(32.35083, 78.9711),
  LatLng(32.75666, 79.52874),
  LatLng(33.09944, 79.37511),
  LatLng(33.42863, 78.93623),
  LatLng(33.52041, 78.81387),
  LatLng(34.06833, 78.73581),
  LatLng(34.35001, 78.98535),
  LatLng(34.6118, 78.33707),
  LatLng(35.28069, 78.02305),
  LatLng(35.49902, 78.0718),
  LatLng(35.50133, 77.82393),
  LatLng(35.6125, 76.89526),
  LatLng(35.90665, 76.55304),
  LatLng(35.81458, 76.18061),
  LatLng(36.07082, 75.92887),
  LatLng(36.23751, 76.04166),
  LatLng(36.66343, 75.85984),
  LatLng(36.73169, 75.45179),
  LatLng(36.91156, 75.39902),
  LatLng(36.99719, 75.14787),
  LatLng(37.02782, 74.56543),
  LatLng(37.17, 74.39089),
  LatLng(37.23733, 74.91574),
  LatLng(37.40659, 75.18748),
  LatLng(37.65243, 74.9036),
  LatLng(38.47256, 74.85442),
  LatLng(38.67438, 74.35471),
  LatLng(38.61271, 73.81401),
  LatLng(38.88653, 73.70818),
  LatLng(38.97256, 73.85235),
  LatLng(39.23569, 73.62005),
  LatLng(39.45483, 73.65569),
  LatLng(39.59965, 73.95471),
  LatLng(39.76896, 73.8429),
  LatLng(40.04202, 73.99096),
  LatLng(40.32792, 74.88089),
  LatLng(40.51723, 74.8588),
  LatLng(40.45042, 75.23394),
  LatLng(40.64452, 75.58284),
  LatLng(40.298, 75.70374),
  LatLng(40.35324, 76.3344),
  LatLng(41.01258, 76.87067),
  LatLng(41.04079, 78.08083),
  LatLng(41.39286, 78.39554),
  LatLng(42.03954, 80.24513),
  LatLng(42.19622, 80.23402),
  LatLng(42.63245, 80.15804),
  LatLng(42.81565, 80.25796),
  LatLng(42.88545, 80.57226),
  LatLng(43.02906, 80.38405),
  LatLng(43.1683, 80.81526),
  LatLng(44.11378, 80.36887),
  LatLng(44.6358, 80.38499),
  LatLng(44.73408, 80.51589),
  LatLng(44.90282, 79.87106),
  LatLng(45.3497, 81.67928),
  LatLng(45.15748, 81.94803),
  LatLng(45.13303, 82.56638),
  LatLng(45.43581, 82.64624),
  LatLng(45.5831, 82.32179),
  LatLng(47.20061, 83.03443),
  LatLng(46.97332, 83.93026),
  LatLng(46.99361, 84.67804),
  LatLng(46.8277, 84.80318),
  LatLng(47.0591, 85.52257),
  LatLng(47.26221, 85.70139),
  LatLng(47.93721, 85.53707),
  LatLng(48.39333, 85.76596),
  LatLng(48.54277, 86.59791),
  LatLng(49.1102, 86.87602),
  LatLng(49.09262, 87.34821),
  LatLng(49.17295, 87.8407),
  LatLng(48.98304, 87.89291),
  LatLng(48.88103, 87.7611),
  LatLng(48.73499, 88.05942),
  LatLng(48.56541, 87.99194),
  LatLng(48.40582, 88.51679),
  LatLng(48.21193, 88.61179),
  LatLng(47.99374, 89.08514),
  LatLng(47.88791, 90.07096),
  LatLng(46.95221, 90.9136),
  LatLng(46.57735, 91.07027),
  LatLng(46.29694, 90.92151),
  LatLng(46.01735, 91.02651),
  LatLng(45.57972, 90.68193),
  LatLng(45.25305, 90.89694),
  LatLng(45.07729, 91.56088),
  LatLng(44.95721, 93.5547),
  LatLng(44.35499, 94.71735),
  LatLng(44.29416, 95.41061),
  LatLng(44.01937, 95.34109),
  LatLng(43.99311, 95.53339),
  LatLng(43.28388, 95.87901),
  LatLng(42.73499, 96.38206),
  LatLng(42.79583, 97.1654),
  LatLng(42.57194, 99.51012),
  LatLng(42.67707, 100.8425),
  LatLng(42.50972, 101.8147),
  LatLng(42.23333, 102.0772),
  LatLng(41.88721, 103.4164),
  LatLng(41.87721, 104.5267),
  LatLng(41.67068, 104.5237),
  LatLng(41.58666, 105.0065),
  LatLng(42.46624, 107.4758),
  LatLng(42.42999, 109.3107),
  LatLng(42.64576, 110.1064),
  LatLng(43.31694, 110.9897),
  LatLng(43.69221, 111.9583),
  LatLng(44.37527, 111.4214),
  LatLng(45.04944, 111.873),
  LatLng(45.08055, 112.4272),
  LatLng(44.8461, 112.853),
  LatLng(44.74527, 113.638),
  LatLng(45.38943, 114.5453),
  LatLng(45.4586, 115.7019),
  LatLng(45.72193, 116.2104),
  LatLng(46.29583, 116.5855),
  LatLng(46.41888, 117.3755),
  LatLng(46.57069, 117.425),
  LatLng(46.53645, 117.8455),
  LatLng(46.73638, 118.3147),
  LatLng(46.59895, 119.7068),
  LatLng(46.71513, 119.9315),
  LatLng(46.90221, 119.9225),
  LatLng(47.66499, 119.125),
  LatLng(47.99475, 118.5393),
  LatLng(48.01125, 117.8046),
  LatLng(47.65741, 117.3827),
  LatLng(47.88805, 116.8747),
  LatLng(47.87819, 116.2624),
  LatLng(47.69186, 115.9231),
  LatLng(47.91749, 115.5944),
  LatLng(48.14353, 115.5491),
  LatLng(48.25249, 115.8358),
  LatLng(48.52055, 115.8111),
  LatLng(49.83047, 116.7114),
  LatLng(49.52058, 117.8747),
  LatLng(49.92263, 118.5746),
  LatLng(50.09631, 119.321),
  LatLng(50.33028, 119.36),
  LatLng(50.39027, 119.1386),
  LatLng(51.62083, 120.0641),
  LatLng(52.115, 120.7767),
  LatLng(52.34423, 120.6259),
  LatLng(52.54267, 120.7122),
  LatLng(52.58805, 120.0819),
  LatLng(52.76819, 120.0314),
  LatLng(53.26374, 120.8307),
  LatLng(53.54361, 123.6147),
  LatLng(53.18832, 124.4933),
  LatLng(53.05027, 125.62),
  LatLng(52.8752, 125.6573),
  LatLng(52.75722, 126.0968),
  LatLng(52.5761, 125.9943),
  LatLng(52.12694, 126.555),
  LatLng(51.99437, 126.4412),
  LatLng(51.38138, 126.9139),
  LatLng(51.26555, 126.8176),
  LatLng(51.31923, 126.9689),
  LatLng(51.05825, 126.9331),
  LatLng(50.74138, 127.2919),
  LatLng(50.31472, 127.334),
  LatLng(50.20856, 127.5861),
  LatLng(49.80588, 127.515),
  LatLng(49.58665, 127.838),
  LatLng(49.58443, 128.7119),
  LatLng(49.34676, 129.1118),
  LatLng(49.4158, 129.4902),
  LatLng(48.86464, 130.2246),
  LatLng(48.86041, 130.674),
  LatLng(48.60576, 130.5236),
  LatLng(48.3268, 130.824),
  LatLng(48.10839, 130.6598),
  LatLng(47.68721, 130.9922),
  LatLng(47.71027, 132.5211),
  LatLng(48.09888, 133.0827),
  LatLng(48.06888, 133.4843),
  LatLng(48.39112, 134.4153),
  LatLng(48.26713, 134.7408),
  LatLng(47.99207, 134.5576),
  LatLng(47.70027, 134.7608),
  LatLng(47.32333, 134.1825),
  LatLng(46.64017, 133.9977),
  LatLng(46.47888, 133.8472),
  LatLng(46.25363, 133.9016),
  LatLng(45.82347, 133.4761),
  LatLng(45.62458, 133.4702),
  LatLng(45.45083, 133.1491),
  LatLng(45.05694, 133.0253),
  LatLng(45.34582, 131.8684),
  LatLng(44.97388, 131.4691),
  LatLng(44.83649, 130.953),
  LatLng(44.05193, 131.298),
  LatLng(43.53624, 131.1912),
  LatLng(43.38958, 131.3104),
  LatLng(42.91645, 131.1285),
  LatLng(42.74485, 130.4327),
  LatLng(42.42186, 130.6044),
  LatLng(42.71416, 130.2468),
  LatLng(42.88794, 130.2514),
  LatLng(43.00457, 129.9046),
  LatLng(42.43582, 129.6955),
  LatLng(42.44624, 129.3493),
  LatLng(42.02736, 128.9269),
  LatLng(42.00124, 128.0566),
  LatLng(41.58284, 128.3002),
  LatLng(41.38124, 128.1529),
  LatLng(41.47249, 127.2708),
  LatLng(41.79222, 126.9047),
  LatLng(41.61176, 126.5661),
  LatLng(40.89694, 126.0118),
  LatLng(40.47037, 124.8851),
  LatLng(40.09362, 124.3736),
  LatLng(39.82777, 124.128), //入海口
  LatLng(37.225, 122.896),
  LatLng(30.676, 123.369),
  LatLng(25.82, 123.92),
  LatLng(20.43, 121.09),
  LatLng(16.253, 119.254),
  LatLng(11.768, 118.898),
  LatLng(3.51, 112.285),
  LatLng(7.81, 107.684),
  LatLng(13.925, 109.819),
  LatLng(18.498, 107.287),
  LatLng(21.51444, 108.2447), //入海口
  LatLng(21.54241, 107.99),
  LatLng(21.66694, 107.7831),
  LatLng(21.60526, 107.3627),
  LatLng(22.03083, 106.6933),
  LatLng(22.45682, 106.5517),
  LatLng(22.76389, 106.7875),
  LatLng(22.86694, 106.7029),
  LatLng(22.91253, 105.8771),
  LatLng(23.32416, 105.3587),
  LatLng(23.18027, 104.9075),
  LatLng(22.81805, 104.7319),
  LatLng(22.6875, 104.3747),
  LatLng(22.79812, 104.1113),
  LatLng(22.50387, 103.9687),
  LatLng(22.78287, 103.6538),
  LatLng(22.58436, 103.5224),
  LatLng(22.79451, 103.3337),
  LatLng(22.43652, 103.0304),
  LatLng(22.77187, 102.4744),
  LatLng(22.39629, 102.1407),
  LatLng(22.49777, 101.7415),
  LatLng(22.20916, 101.5744),
  LatLng(21.83444, 101.7653),
  LatLng(21.14451, 101.786),
  LatLng(21.17687, 101.2919),
  LatLng(21.57264, 101.1482),
  LatLng(21.76903, 101.099),
  LatLng(21.47694, 100.6397),
  LatLng(21.43546, 100.2057),
  LatLng(21.72555, 99.97763),
  LatLng(22.05018, 99.95741),
  LatLng(22.15592, 99.16785),
  LatLng(22.93659, 99.56484),
  LatLng(23.08204, 99.5113),
  LatLng(23.18916, 98.92747),
  LatLng(23.97076, 98.67991),
  LatLng(24.16007, 98.89073),
  LatLng(23.92999, 97.54762),
  LatLng(24.26055, 97.7593),
  LatLng(24.47666, 97.54305),
  LatLng(24.73992, 97.55255),
  LatLng(25.61527, 98.19109),
  LatLng(25.56944, 98.36137),
  LatLng(25.85597, 98.7104),
  LatLng(26.12527, 98.56944),
  LatLng(26.18472, 98.73109),
  LatLng(26.79166, 98.77777),
  LatLng(27.52972, 98.69699),
  LatLng(27.6725, 98.45888),
  LatLng(27.54014, 98.31992),
  LatLng(28.14889, 98.14499),
  LatLng(28.54652, 97.55887),
  LatLng(28.22277, 97.34888),
  LatLng(28.46749, 96.65387),
  LatLng(28.35111, 96.40193),
  LatLng(28.525, 96.34027),
  LatLng(28.79569, 96.61373),
  LatLng(29.05666, 96.47083),
  LatLng(28.90138, 96.17532),
  LatLng(29.05972, 96.14888),
  LatLng(29.25757, 96.39172),
  LatLng(29.46444, 96.08315),
  LatLng(29.03527, 95.38777),
  LatLng(29.33346, 94.64751),
  LatLng(29.07348, 94.23456),
  LatLng(28.6692, 93.96172),
  LatLng(28.61876, 93.35194),
  LatLng(28.3193, 93.22205),
  LatLng(28.1419, 92.71044),
  LatLng(27.86194, 92.54498),
  LatLng(27.76472, 91.65776),
  LatLng(27.945, 91.66277),
  LatLng(28.08111, 91.30138),
  LatLng(27.96999, 91.08693),
  LatLng(28.07958, 90.3765),
  LatLng(28.24257, 90.38898),
  LatLng(28.32369, 89.99819),
  LatLng(28.05777, 89.48749),
  LatLng(27.32083, 88.91693),
];

bool isPointInChina(LatLng point) => isInChina(point.latitude, point.longitude);

//true：in China，false：out of China。
bool isInChina(double lat, double lon) {
  if (lon < 72.0 || lon > 137.83 || lat < 0.82 || lat > 55.82) {
    return false;
  } else if (!pnPoly(LatLng(lat, lon), outerChina)) {
    return false;
  } else if (pnPoly(LatLng(lat, lon), innerChina)) {
    return true;
  } else {
    return pnPoly(LatLng(lat, lon), accurateChina);
  }
}

bool isTileInChina(int x, int y, int z) => isPointInChina(tileToLatLng(x, y, z));

LatLng tileToLatLng(int x, int y, int z) {
  final n = pow(2, z);
  final lonDeg = x / n * 360.0 - 180.0;
  final latRad = atan(sinh(pi * (1 - 2 * y / n)));
  final latDeg = latRad * 180.0 / pi;
  return LatLng(latDeg, lonDeg);
}

double sinh(double x) => (pow(e, x) - pow(e, -1 * x)) / 2;

//true：in polygon，false：out of polygon。
bool pnPoly(LatLng testPoint, List<LatLng> polygon) {
  int i = 0, j;
  bool c = false;
  int nvert = polygon.length;
  for (j = nvert - 1; i < nvert; j = i++) {
    //1.被测试点的纵坐标testy是否在本次循环所测试的两个相邻点纵坐标范围之内
    //2.待测点test是否在i,j两点之间的连线之下
    if (((polygon[i].longitude > testPoint.longitude) !=
            (polygon[j].longitude > testPoint.longitude)) &&
        (testPoint.latitude <
            (polygon[j].latitude - polygon[i].latitude) *
                    (testPoint.longitude - polygon[i].longitude) /
                    (polygon[j].longitude - polygon[i].longitude) +
                polygon[i].latitude)) {
      //交点次数，奇数为真，偶数为假
      c = !c;
    }
  }
  return c;
}
