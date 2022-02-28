import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_2022/pages/profile_pages/public_profile_page.dart';

import '../../widgets/bottom_sheet.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const id = '/setting_page';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.95,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(CupertinoIcons.back),
              ),
              const Spacer(),
              Widgets.text17BottomSheet(text: "Settings"),
              const Spacer(),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 40),
          Widgets.text17BottomSheet(text: "Personal information"),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _showSetting();
            },
            child: Widgets.buttonRowBottomSheet(text: "Public profile"),
          ),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Account settings"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Permissions"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Notifications"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Privacy and data"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Home feed tuner"),
          const SizedBox(height: 40),
          Widgets.text17BottomSheet(text: "Actions"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Add account"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Log out"),
          const SizedBox(height: 40),
          Widgets.text17BottomSheet(text: "Support"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Get help"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "Terms & privacy"),
          const SizedBox(height: 20),
          Widgets.buttonRowBottomSheet(text: "About"),
        ],
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
      builder: (context) => const PublicProfilePage(),
    );
  }
}
