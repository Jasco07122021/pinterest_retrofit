import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'result_search_page.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  static const id = '/searching_page';

  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _header(),
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
          Flexible(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: Theme.of(context).hoverColor),
              onSubmitted: (value) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultSearchPage(text: value),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: "Search for ideas",
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  CupertinoIcons.camera_fill,
                  color: Theme.of(context).hoverColor,
                ),
                contentPadding: const EdgeInsets.only(top: 10, left: 10),
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  borderSide:
                      BorderSide(color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Theme.of(context).hoverColor),
            ),
          ),
        ],
      ),
    );
  }
}
