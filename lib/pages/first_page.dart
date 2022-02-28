import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest_2022/pages/messenger_page.dart';
import 'package:pinterest_2022/pages/search_pages/search_page.dart';

import 'home_page.dart';
import 'profile_pages/profile_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  static const id = '/first_page';

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }

  int _pagesIndex = 0;
  final List<Widget> _pagesList = [
    const HomePage(),
    const SearchPage(),
    const MessengerPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _pagesList.elementAt(_pagesIndex),
            _navbar(context),
            hasInternet
                ? const SizedBox.shrink()
                : Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    body: Center(
                      child: Lottie.asset(
                          "assets/lottie/3648-no-internet-connection.json"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Align _navbar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 0), blurRadius: 5),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _pagesIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.search), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.chat_bubble), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.circle_bottomthird_split),
                    label: ""),
              ],
              onTap: (index) {
                setState(() {
                  _pagesIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
