import 'package:flutter/material.dart';

typedef SliderCallBack = Function(AnimationController animationController);

class SliderButton extends StatefulWidget {
  final SliderCallBack sliderCallBack;

  const SliderButton({Key? key, required this.sliderCallBack})
      : super(key: key);

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton>
    with TickerProviderStateMixin {
  double initDetails = 0.0;
  double sliderDistance = 0.0;
  late AnimationController _animatedContainer;
  late Animation _curvedAnimation;
  double sliderWidth = 80;
  double buttonHeight = 80;

  double width = 360.0;

  bool enableSlider = true;

  @override
  void initState() {
    super.initState();

    _animatedContainer =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _curvedAnimation =
        CurvedAnimation(parent: _animatedContainer, curve: Curves.ease);

    _curvedAnimation.addListener(() {
      setState(() {
        sliderDistance =
            sliderDistance - sliderDistance * _curvedAnimation.value;
        if (sliderDistance < 0) {
          sliderDistance = 0;
        }
      });
    });

    _animatedContainer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animatedContainer.reset();
        enableSlider = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        if (!enableSlider) return;
        initDetails = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!enableSlider) return;
        sliderDistance = details.globalPosition.dx - initDetails;
        if(sliderDistance<0){
          sliderDistance = 0;
        }

        if (sliderDistance > width - sliderWidth) {
          sliderDistance = width - sliderWidth;
          enableSlider = false;
          widget.sliderCallBack.call(_animatedContainer);
        }
        setState(() {});
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (enableSlider) {
          setState(() {
            _animatedContainer.forward();
          });
        }
      },
      child: Container(
        height: buttonHeight,
        width: double.maxFinite,
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: buttonHeight,
                width: sliderDistance <= 0 ? 0 : sliderDistance + sliderWidth,
                color: Colors.red,
              ),
            ),
            Center(child: Text('滑动解锁')),
            Positioned(
              top: 0,
              left: sliderDistance,
              child: Container(
                height: buttonHeight,
                width: sliderWidth,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
