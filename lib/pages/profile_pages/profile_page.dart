import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_2022/models/collection_model.dart';
import 'package:pinterest_2022/pages/home_page.dart';
import 'package:pinterest_2022/services/hive_db.dart';
import 'package:pinterest_2022/services/logger_print_console.dart';

import '../../main.dart';
import '../../widgets/bottom_sheet.dart';
import '../details_page.dart';
import 'setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const id = '/profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final ScrollController _scrollController = ScrollController();
  List<Collections> list = [];
  Map<dynamic, dynamic> map = {};

  _checkPop() {
    setState(() {
      map = HiveDB.getUser();
    });
  }

  @override
  void initState() {
    super.initState();
    if (HiveDB.getSaved().isNotEmpty) {
      list = HiveDB.getSaved();
    }
    map = HiveDB.getUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (HiveDB.getSaved().isNotEmpty) {
      list = HiveDB.getSaved();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Icon(Icons.share),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              _menuBottomSheet();
            },
            child: const Icon(
              Icons.more_horiz,
              size: 30,
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).backgroundColor,
            child: Text(
              map["name"]![0].toString().toUpperCase(),
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          _headerText(),
          const SizedBox(height: 30),
          _search(),
          const SizedBox(height: 10),
          _bodyList(),
        ],
      ),
    );
  }

  Row _search() {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                fillColor: Theme.of(context).backgroundColor,
                filled: true,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).hoverColor,
                ),
                enabled: false,
                hintText: "Search your Pins",
                hintStyle: const TextStyle(color: Colors.grey),
                isCollapsed: true,
                contentPadding: const EdgeInsets.only(top: 10),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.plus))
      ],
    );
  }

  Column _headerText() {
    return Column(
      children: [
        Text(
          map["name"]! + "\n" + map["surname"]!,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("0 followers"),
            SizedBox(width: 10),
            Text("0 following"),
          ],
        ),
      ],
    );
  }

  MasonryGridView _bodyList() {
    return MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: list.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        itemBuilder: (context, index) {
          return _grid(index: index);
        });
  }

  Future<dynamic> _menuBottomSheet() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Widgets.text17BottomSheet(text: "Options"),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                 _showSetting();
              },
              child: Widgets.text20BottomSheet(text: "Settings"),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Widgets.text20BottomSheet(text: "Copy profile link"),
            ),
            const SizedBox(height: 20),
            Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _checkPop();
                },
                color: Colors.grey.shade200,
                shape: const StadiumBorder(),
                child: const Text("Close"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showSetting() {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) => const SettingPage(),
    ).then((value) => _checkPop());
  }

  GestureDetector _grid({index}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPinterest(obj: list[index]),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: list[index].coverPhoto!.urls!.regular!,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: list[index].coverPhoto!.width! /
                      list[index].coverPhoto!.height!,
                  child: Container(
                    color: list[index].coverPhoto!.color!.toColor(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
