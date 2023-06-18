import 'package:flutter/material.dart';

import 'entity/consts.dart';
import 'fragments/home_fragment.dart';
import 'fragments/map_fragment.dart';
import 'fragments/mine_fragment.dart';
import 'fragments/list_fragment.dart';
import 'db/db_manager.dart';
import 'entity/app_dir.dart';
import 'entity/server.dart';
import 'entity/sharedpref.dart';
import 'entity/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mainCheck();
  runApp(const MyApp());
}

Future<void> mainCheck() async {
  while (AppDir.data.path.isEmpty ||
      AppDir.cache.path.isEmpty ||
      DbManager.database == null ||
      !Shared.inited ||
      !UserProfile.inited) {
    Future? sharedFuture;
    Future? dirFuture;
    Future? dbFuture;
    if (!Shared.inited) {
      sharedFuture = Shared.init();
    }
    if (AppDir.data.path.isEmpty || AppDir.cache.path.isEmpty) {
      dirFuture = AppDir.setDir();
    }
    if (DbManager.database == null) {
      dbFuture = DbManager.setDb();
    }
    if (!UserProfile.inited) {
      if (sharedFuture != null) {
        await sharedFuture;
      }
      UserProfile.init();
      Server.setupDio();
    }
    if (dirFuture != null) {
      await dirFuture;
    }
    if (dbFuture != null) {
      await dbFuture;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: const BottomNav(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: Colors.pinkAccent,
          secondary: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.pinkAccent[5],
          surfaceTintColor: Colors.pinkAccent[5],
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.pinkAccent,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.pinkAccent,
          backgroundColor: Colors.pinkAccent[5],
        ),
      ),
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
    const ListFragment(),
    const MapFragment(),
    const MineFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageController.jumpToPage(index);
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        elevation: 10,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: Icon(Icons.home_outlined),
            label: '首页',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.article,
              color: Colors.white,
            ),
            icon: Icon(Icons.article_outlined),
            label: '记录',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            icon: Icon(Icons.location_on_outlined),
            label: '探索',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.face,
              color: Colors.white,
            ),
            icon: Icon(Icons.face_outlined),
            label: '我的',
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
    );
  }
}
