import 'package:flutter/material.dart';
import 'shared/animation.dart';
import 'shared/text_field_style.dart';

class CongratesWidget extends StatefulWidget {
  final int finalTotalPoints;

  const CongratesWidget({super.key, required this.finalTotalPoints});
  @override
  State<CongratesWidget> createState() => _CongratesWidgetState();

}

class _CongratesWidgetState extends State<CongratesWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
//forward to stop animation to run once, repeat reverse to repeating
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator CongratesWidget - FRAME

    return Container(
        width: 385,
        height: 844,
        decoration: BoxDecoration(
          color : Color.fromRGBO(252, 213, 206, 1),
        ),
        child: Stack(
            children: <Widget>[
              AnimateElements(controller: _controller, left: 47, top: 105, width: 150, height: 150,
                  left2: 65, top2: 45, width2: 85, height2: 85,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 160, 142, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(85, 85)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 273, top: 496, width: 85, height: 85,
                  left2: 225, top2: 434, width2: 90, height2: 90,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 160, 142, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(90, 90)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 45.5, top: 703, width: 85, height: 85,
                  left2: -26.6, top2: 576, width2: 100, height2: 100,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 170, 97, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(100, 100)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 216, top: 272, width: 150, height: 150,
                  left2: 285, top2: 159, width2: 85, height2: 85,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 170, 97, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(85, 85)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 65, top: 496, width: 150, height: 150,
                  left2: 252.7, top2: 697, width2: 75, height2: 75,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 233, 208, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(75, 75)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 271, top: -63, width: 150, height: 150,
                  left2: 276, top2: 31, width2: 85, height2: 85,
                  container: Container(
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 233, 208, 1),
                        borderRadius : BorderRadius.all(Radius.elliptical(85, 85)),
                      )
                  )
              ),
              AnimateElements(controller: _controller, left: 0, top: -93, width: 390, height: 100,
                  left2: 0, top2: 138, width2: 390, height2: 100,
                  container: Container(
                    child: LargeOrangeTextStyle(text: 'Congrates', fontSize: 80,),
                  )
              ),
              AnimateElements(controller: _controller, left: 46.5, top: 312, width: 85, height: 85,
                  left2: -112.5, top2: 232, width2: 150, height2: 150,
                  container: Container(
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(255, 233, 208, 1),
                    borderRadius : BorderRadius.all(Radius.elliptical(150, 150)),
                  )
              )
              ),
              AnimateElements(controller: _controller, left: 18, top: 250, width: 355, height: 115,
                  left2: 18, top2: 250, width2: 355, height2: 115,
                  container: Container(
                    child: PinkTextStyle(text: 'Wow, You have done all the challenges for today !'),
                  )
              ),
              AnimateElements(controller: _controller, left: 18, top: 422, width: 355, height: 115,
                  left2: 18, top2: 422, width2: 355, height2: 115,
                  container: Container(
                    child: PinkTextStyle(text: 'Here is your points'),
                  )
              ),
        AnimateElements(controller: _controller, left: 38, top: 818, width: 315, height: 100,
            left2: 0, top2: 523, width2: 390, height2: 100,
            container: Container(
              child: LargeOrangeTextStyle(text: widget.finalTotalPoints.toString(), fontSize: 110,),
            )
        )
              ,Positioned(
                  top: 700,
                  left: 0,
                  height: 74,
                  width: 390,
                  child: GrayTextStyle(text: 'Get a coupon when you collect 100 points !',),
              ),

              Positioned(
                  top: 17,
                  left: 20,
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image : DecorationImage(
                            image: AssetImage('assets/images/back-arrow.png'),
                            fit: BoxFit.fitWidth
                        ),
                      )
                  )
              ),
            ]
        )
    );
  }
}
