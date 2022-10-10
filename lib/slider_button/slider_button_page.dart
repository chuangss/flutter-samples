import 'package:flutter/material.dart';
import 'package:flutter_samples/slider_button/slider_button.dart';
///
/// 滑动解锁
///
class SliderButtonPage extends StatelessWidget {
  const SliderButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SliderButton(
        sliderCallBack: (animationController) {
          animationController.forward();
        },
      )),
    );
  }
}
