import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets {
  static Future<dynamic> bottomSheetPadding({context, children}) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),),
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
          children: children,
        ),
      ),
    );
  }


  static Text text20BottomSheet({text}) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  static Text text17BottomSheet({text}) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17),
    );
  }

  static Text text15BottomSheet({text}) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15),
    );
  }

  static Row buttonRowBottomSheet({text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Widgets.text20BottomSheet(text: text),
        const Icon(CupertinoIcons.right_chevron),
      ],
    );
  }

  static GestureDetector columnButtonBottomSheet({text20, text15}) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgets.text20BottomSheet(text: text20),
          Widgets.text15BottomSheet(text: text15),
        ],
      ),
    );
  }

  static faangCompany({text, img}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(img),
          radius: 30,
        ),
        const SizedBox(height: 5),
        Text(text,style: const TextStyle(fontSize: 13),),
      ],
    );
  }
}
