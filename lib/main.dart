import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pinterest_2022/models/theme_model.dart';
import 'package:pinterest_2022/pages/first_page.dart';
import 'package:pinterest_2022/pages/home_page.dart';
import 'package:pinterest_2022/pages/login_page/sign_in.dart';
import 'package:pinterest_2022/pages/profile_pages/profile_page.dart';
import 'package:pinterest_2022/pages/profile_pages/public_profile_page.dart';
import 'package:pinterest_2022/pages/profile_pages/setting_page.dart';
import 'package:pinterest_2022/pages/search_pages/result_search_page.dart';
import 'package:pinterest_2022/pages/search_pages/search_page.dart';
import 'package:pinterest_2022/pages/search_pages/searching_page.dart';
import 'package:pinterest_2022/services/hive_db.dart';
import 'pages/details_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.nameHive);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
  if (HiveDB.get().isNotEmpty) {
    HiveDB.box.delete("collections");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: (HiveDB.getUser().isEmpty) ? const SignInPage() : const FirstPage(),
      routes: {
        SignInPage.id: (context) => const SignInPage(),
        FirstPage.id: (context) => const FirstPage(),
        HomePage.id: (context) => const HomePage(),
        PublicProfilePage.id: (context) => const PublicProfilePage(),
        SettingPage.id: (context) => const SettingPage(),
        SearchingPage.id: (context) => const SearchingPage(),
        SearchPage.id: (context) => const SearchPage(),
        ResultSearchPage.id: (context) => const ResultSearchPage(),
        DetailsPinterest.id: (context) => const DetailsPinterest(),
        ProfilePage.id: (context) => const ProfilePage(),
      },
    );
  }
}


