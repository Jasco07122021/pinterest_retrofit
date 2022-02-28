import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_2022/models/collection_model.dart';
import 'package:pinterest_2022/services/hive_db.dart';
import 'package:pinterest_2022/widgets/circle_progress.dart';
import 'package:pinterest_2022/widgets/pick_image.dart';

import '../main.dart';
import '../services/retrofit_server.dart';
import '../widgets/bottom_sheet.dart';
import 'details_page.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const id = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  List<Collections> list = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool isLoadingBottom = false;
  int totalPage = 144;


  _loadDateRetrofit() {
    Dio dio = Dio();
    RetrofitServer retrofit = RetrofitServer(dio);
    retrofit.getCollections(paramsSearch(page: 1 + Random().nextInt(totalPage))).then((value) {
      _showDataRetrofit(value);
    });
  }


  _showDataRetrofit(List<Collections> response) async {
    setState(() {
      list.addAll(response);
      isLoading = false;
      isLoadingBottom = false;
    });
  }


  loadMoreRetrofit() async {
    setState(() {
      isLoadingBottom = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    _loadDateRetrofit();
  }

  @override
  void initState() {
    super.initState();

    if (HiveDB.get().isEmpty) {
      _loadDateRetrofit();
    } else {
      list = HiveDB.get();
      isLoading = false;
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreRetrofit();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    list = HiveDB.get();
  }

  @override
  void dispose() {
    super.dispose();
    HiveDB.put(list);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: _leadingAppBar(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CircleProgressWidgets.showCenterLoad(
              centerLoad: isLoading,
              child: MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: list.length,
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return const SizedBox.shrink();
                    }
                    return _grid(index: index);
                  }),
            ),
            CircleProgressWidgets.showLoadMore(loadMore: isLoadingBottom),
          ],
        ),
      ),
    );
  }

  Container _leadingAppBar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).hoverColor,
      ),
      child: Text(
        "All",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }

  GestureDetector _grid({index}) {
    return GestureDetector(
      onTap: () {
        HiveDB.put(list);
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
            const SizedBox(height: 10),
            list[index].coverPhoto!.description != null
                ? bottomListTile(index: index)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Spacer(),
                        moreHorizontal(list[index].coverPhoto!),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  GestureDetector moreHorizontal(CoverPhoto obj) {
    return GestureDetector(
      onTap: () {
        Widgets.bottomSheetPadding(
          context: context,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(CupertinoIcons.clear),
                ),
                const SizedBox(width: 20),
                Widgets.text17BottomSheet(text: "Share to"),
              ],
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.only(top: 15),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Widgets.faangCompany(
                      text: "Send", img: "assets/images/img.png"),
                  const SizedBox(width: 20),
                  Widgets.faangCompany(
                      text: "Telegram", img: "assets/images/img_6.png"),
                  const SizedBox(width: 20),
                  Widgets.faangCompany(
                      text: "Facebook", img: "assets/images/img_2.png"),
                  const SizedBox(width: 20),
                  Widgets.faangCompany(
                      text: "Gmail", img: "assets/images/img_3.png"),
                  const SizedBox(width: 20),
                  Widgets.faangCompany(
                      text: "Copy link", img: "assets/images/img_4.png"),
                  const SizedBox(width: 20),
                  Widgets.faangCompany(
                      text: "More", img: "assets/images/img_5.png"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  String result = await ImgDownloaderWidget.saveGallery(
                      url: obj.links!.download!);
                  ImgDownloaderWidget.showToast(text: result);
                },
                child: Widgets.text20BottomSheet(text: "Download image")),
            const SizedBox(height: 20),
            Widgets.text20BottomSheet(text: "Hide Pin"),
            const SizedBox(height: 20),
            Widgets.columnButtonBottomSheet(
                text20: "Report Pin",
                text15: "This goes against Pinterest's community guidelines"),
            const SizedBox(height: 40),
            Widgets.text15BottomSheet(
                text: "This Pin is inspired by your recent activity"),
          ],
        );
      },
      child: const Icon(
        Icons.more_horiz,
        size: 20,
      ),
    );
  }

  Padding bottomListTile({index}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: 30,
              imageUrl: list[index].coverPhoto!.user!.profileImage!.large!,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              list[index].coverPhoto!.description!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          moreHorizontal(list[index].coverPhoto!),
        ],
      ),
    );
  }
}
