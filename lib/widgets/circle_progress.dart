import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircleProgressWidgets {
  static showLoadMore({loadMore}) {
    if (loadMore) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: LinearProgressIndicator(
          backgroundColor: Colors.yellow,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.blueAccent,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  static showCenterLoad({centerLoad, child}) {
    if (centerLoad) {
      return Center(
        child: Lottie.asset("assets/lottie/9329-loading.json"),
      );
    }
    return child;
  }

}
