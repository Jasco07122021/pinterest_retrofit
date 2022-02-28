import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_2022/models/collection_model.dart';
import 'package:pinterest_2022/pages/home_page.dart';
import 'package:pinterest_2022/widgets/circle_progress.dart';

import '../../services/hive_db.dart';
import '../../services/retrofit_server.dart';
import '../../widgets/bottom_sheet.dart';
import '../details_page.dart';
import 'searching_page.dart';

class ResultSearchPage extends StatefulWidget {
  final String? text;

  const ResultSearchPage({Key? key, this.text}) : super(key: key);

  static const id = '/result_search_page';

  @override
  _ResultSearchPageState createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  TextEditingController controller = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  bool isLoading = true;
  bool isLoadingBottom = false;
  List<Collections> list = [];
  late int totalPage;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();


  _checkDateRetrofit() {
    Dio dio = Dio();
    RetrofitServer retrofit = RetrofitServer(dio);
    retrofit.getSearchCollections(paramsSearch(query: widget.text)).then((value) {
      _checkLoadPage(value);
    });
  }

  _checkLoadPage(String response) {
    Map<String, dynamic> map = jsonDecode(response);
    totalPage = map["total_pages"];
    setState(() {});
    _loadDateRetrofit();
  }



  _loadDateRetrofit() {
    Dio dio = Dio();
    RetrofitServer retrofit = RetrofitServer(dio);
    retrofit.getSearchCollections(paramsSearch(query: widget.text,page: 1 + Random().nextInt(totalPage))).then((value) {
      _showDataRetrofit(value);
    });
  }

  _showDataRetrofit(String response) {
    Map<String, dynamic> map = jsonDecode(response);
    list.addAll(parseCollectionResponse(jsonEncode(map['results'])));
    setState(() {
      isLoading = false;
      isLoadingBottom = false;
    });
  }

  loadMore() {
    setState(() {
      isLoadingBottom = true;
    });
    _loadDateRetrofit();
  }

  @override
  void initState() {
    super.initState();
    _checkDateRetrofit();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CircleProgressWidgets.showCenterLoad(centerLoad: isLoading,child: _bodyList()),
            CircleProgressWidgets.showLoadMore(loadMore: isLoadingBottom),
            _header(),
          ],
        ),
      ),
    );
  }

  _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 50,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.left_chevron),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              onTap: () {
                Navigator.pushNamed(context, SearchingPage.id);
                FocusScope.of(context).unfocus();
              },
              focusNode: myFocusNode,
              decoration: InputDecoration(
                hintText: widget.text,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                isCollapsed: true,
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  borderSide:
                      BorderSide(color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyList() {
    return list.isEmpty
        ? const Center(
            child: Text("No data"),
          )
        : ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            children: [
              const SizedBox(
                height: 50,
              ),
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                itemCount: list.length,
                shrinkWrap: true,
                controller: _scrollController2,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return const SizedBox.shrink();
                  }
                  return _grid(index: index);
                },
              ),
            ],
          );
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
            const SizedBox(height: 10),
            list[index].coverPhoto!.description != null
                ? bottomListTile(index: index)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Spacer(),
                        moreHorizontal(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  GestureDetector moreHorizontal() {
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
            Widgets.text20BottomSheet(text: "Download image"),
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
          moreHorizontal(),
        ],
      ),
    );
  }
}
