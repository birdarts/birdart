import 'package:flutter/material.dart';
import 'package:naturalist/fragments/home_fragment.dart';
import 'package:naturalist/fragments/map_fragment.dart';
import 'package:naturalist/fragments/mine_fragment.dart';
import 'package:naturalist/fragments/observation_fragment.dart';

import 'entity/app_dir.dart';
import 'entity/sql_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  while (AppDir.data.path.isEmpty || AppDir.cache.path.isEmpty) {
    await AppDir.setDir();
  }
  while (SQLProvider.database == null) {
    await SQLProvider.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'open naturalist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const BottomNav(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int _selectedIndex = 0; //預設值
  final List<Widget> pages = [
    const HomeFragment(),
    const ObservationFragment(),
    MapFragment(),
    const MineFragment(),
  ];

  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 0));
    super.initState();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        color: Colors.pink[50], borderRadius: BorderRadius.circular(25));
    const edgeInsets = EdgeInsets.fromLTRB(25, 5, 25, 5);

    final pageController = PageController();
    void onPageChanged(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    EdgeInsetsGeometry widthAnime(int note){
      final double width = 2.5 * note;
      return EdgeInsets.fromLTRB(width, 5, width, 5);
    }

    AnimatedBuilder getContainer(IconData iconData) {
      return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Container(
              //color: colorVariation((_resizableController.value *100).round()),
              padding: widthAnime((animationController.value * 10).round()),
              decoration: boxDecoration,
              child: Icon(iconData),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('open naturalist'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ), // 使用 AutomaticKeepAliveClientMixin 需要将页面包装在PageView中
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.home_outlined),
            ),
            activeIcon: getContainer(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.article_outlined),
            ),
            activeIcon: getContainer(Icons.article),
            label: '观察',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.location_on_outlined),
            ),
            activeIcon: getContainer(Icons.location_on),
            label: '地图',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.face_outlined),
            ),
            activeIcon: getContainer(Icons.face),
            label: '我的',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.black54,
        unselectedFontSize: 12,
        onTap: (int index) {
          setState(() {
            animationController = AnimationController(vsync: this,
              duration: const Duration(milliseconds: 250));
            pageController.jumpToPage(index);
            animationController.forward();
          });
        },
      ),
    );
  }
}
