import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/base_model.dart';
import 'result_search_page.dart';
import 'searching_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const id = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with RouteAware {
  FocusNode myFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 50),
                _bodyListGridText(text: "Ideas for you", count: 8),
                _bodyListGridText(text: "Popular on Pinterest", count: 6),
              ],
            ),
            _header(),
          ],
        ),
      ),
    );
  }

  _gridView({count}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shrinkWrap: true,
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 0.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultSearchPage(
                  text: count == 8
                      ? BaseModel.listSearchIdeas[index].keys
                          .toString()
                          .replaceAll(RegExp(r'[()]'), "")
                      : BaseModel.listSearchPopular[index].keys
                          .toString()
                          .replaceAll(RegExp(r'[()]'), ""),
                ),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                count == 8
                    ? _cardImg(BaseModel.listSearchIdeas[index].values
                        .toString()
                        .replaceAll(RegExp(r'[()]'), ""))
                    : _cardImg(
                        BaseModel.listSearchPopular[index].values
                            .toString()
                            .replaceAll(RegExp(r'[()]'), ""),
                      ),
                count == 8
                    ? _textCenterCard(BaseModel.listSearchIdeas[index].keys
                        .toString()
                        .replaceAll(RegExp(r'[()]'), ""))
                    : _textCenterCard(BaseModel.listSearchPopular[index].keys
                        .toString()
                        .replaceAll(RegExp(r'[()]'), ""))
              ],
            ),
          ),
        );
      },
    );
  }

  Image _cardImg(String img) {
    return Image.asset(
      img,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  Text _textCenterCard(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Column _bodyListGridText({text, count}) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(fontSize: 17),
          ),
        ),
        const SizedBox(height: 10),
        _gridView(count: count),
      ],
    );
  }

  _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 50,
      width: double.infinity,
      child: TextField(
        onTap: () {
          Navigator.pushNamed(context, SearchingPage.id);
          FocusScope.of(context).unfocus();
        },
        focusNode: myFocusNode,
        decoration: InputDecoration(
          hintText: "Search for ideas",
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(
            CupertinoIcons.camera_fill,
            color: Theme.of(context).hoverColor,
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Theme.of(context).hoverColor,
          ),
          contentPadding: const EdgeInsets.only(top: 10),
          isCollapsed: true,
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            borderSide: BorderSide(color: Theme.of(context).backgroundColor),
          ),
        ),
      ),
    );
  }
}
