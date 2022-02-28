import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinterest_2022/services/hive_db.dart';
import 'package:pinterest_2022/services/logger_print_console.dart';

class PickImage {
  static pickImg() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image;
  }

  static saveImg({path}) {
    HiveDB.box.put("saveGallery", path);
  }

  static getImg() {
    return HiveDB.box.get("saveGallery");
  }
}

class ImgDownloaderWidget {
  static saveGallery({url}) async {
    try {
      var imageId = await ImageDownloader.downloadImage(
        url,
      );
      if (imageId == null) {
        LoggerPrint.d('null');
        return;
      }
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      LoggerPrint.d(fileName.toString() +
          " /// " +
          path.toString() +
          " /// " +
          size.toString());
      return "Image downloaded";
    } on PlatformException {
      LoggerPrint.d("error");
    }
  }

  static showToast({text}) {
    return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
