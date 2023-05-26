import 'package:flutter/material.dart';

import 'entity/consts.dart';
import 'fragments/home_fragment.dart';
import 'fragments/map_fragment.dart';
import 'fragments/mine_fragment.dart';
import 'fragments/observation_fragment.dart';
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
        colorScheme: const ColorScheme.light(
          primary: Colors.pink,
          secondary: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.pink,
          backgroundColor: Colors.pink[10],
        ),
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
    const MapFragment(),
    const MineFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
            label: '观察',
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
