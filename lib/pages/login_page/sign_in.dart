import 'package:flutter/material.dart';
import 'package:pinterest_2022/pages/first_page.dart';
import 'package:pinterest_2022/services/hive_db.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const id = '/sign_in_page';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSurname = TextEditingController();

  bool _validateName = false;
  bool _validateSurname = false;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.353,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/sign.png"),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                const Text(
                  "Welcome to Pinterest",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      _textField(text: "Name", controller: controllerName),
                      const SizedBox(height: 10,),
                      _textField(
                          text: "Surname", controller: controllerSurname),
                      const  SizedBox(height: 20),
                      _buttons(text: "Start"),
                    ],
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Theme.of(context).hoverColor),
                    text: "The program was created by ",
                    children: const [
                      TextSpan(
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        text: "J and R",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            _logo(size),
          ],
        ),
      ),
    );
  }

  Container _logo(Size size) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: size.height*0.2),
      child: Image.asset(
        "assets/images/logo.png",
        height: size.height * 0.2,
      ),
    );
  }

  MaterialButton _buttons({text}) {
    return MaterialButton(
      height: 50,
      minWidth: double.infinity,
      color: Colors.red,
      shape: const StadiumBorder(),
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
          Map<String,String> map = {
            "name":controllerName.text.trim().toString(),
            "surname":controllerSurname.text.trim().toString(),
          };
          HiveDB.putUser(map);
          Navigator.pushReplacementNamed(context, FirstPage.id);
        }
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  TextField _textField({text, controller}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).hoverColor),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        labelText: text,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Theme.of(context).hoverColor),
        errorText: _checkError(text: text),
      ),
    );
  }
}
