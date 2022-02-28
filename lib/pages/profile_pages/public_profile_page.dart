import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/hive_db.dart';
import '../../widgets/bottom_sheet.dart';

class PublicProfilePage extends StatefulWidget {
  const PublicProfilePage({Key? key}) : super(key: key);

  static const id = '/public_profile_page';

  @override
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  Map<dynamic, dynamic> map = {};
  late TextEditingController controllerName;
  late TextEditingController controllerSurname;
  bool _validateName = false;
  bool _validateSurname = false;

  @override
  void initState() {
    super.initState();
    map = HiveDB.getUser();
    controllerName = TextEditingController(text: map["name"]!);
    controllerSurname = TextEditingController(text: map["surname"]!);
  }

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
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(CupertinoIcons.back),
                  ),
                  MaterialButton(
                    child: const Text("Done"),
                    color: Theme.of(context).backgroundColor,
                    textColor: Theme.of(context).hoverColor,
                    shape: const StadiumBorder(),
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        controllerName.text.trim().toString().isEmpty
                            ? _validateName = true
                            : _validateName = false;
                        controllerSurname.text.trim().toString().isEmpty
                            ? _validateSurname = true
                            : _validateSurname = false;
                      });
                      if (!_validateSurname && !_validateName) {
                        map['name'] =  controllerName.text.trim().toString();
                        map['surname'] =  controllerSurname.text.trim().toString();
                        HiveDB.putUser(map);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              Widgets.text17BottomSheet(text: "Settings"),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(
                    map["name"]![0].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: const Text("Edit"),
                  shape: const StadiumBorder(),
                  textColor: Theme.of(context).hoverColor,
                  color: Theme.of(context).backgroundColor,
                  elevation: 1,
                ),
              ],
            ),
          ),
          _textField(labelText: "Name", controller: controllerName),
          _textField(labelText: "Surname", controller: controllerSurname),
        ],
      ),
    );
  }

  TextField _textField({controller, labelText}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).hoverColor),
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: InputBorder.none,
        labelStyle: TextStyle(color: Theme.of(context).hoverColor),
        errorText: _checkError(text: labelText),
      ),
    );
  }

  _checkError({text}) {
    if (text == "Name") {
      if (_validateName) {
        return 'Value Can\'t Be Empty';
      }
      return null;
    } else {
      if (_validateSurname) {
        return 'Value Can\'t Be Empty';
      }
      return null;
    }
  }
}
