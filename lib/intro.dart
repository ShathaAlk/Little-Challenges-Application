import 'package:flutter/material.dart';
import 'home.dart';
import 'shared/animation.dart';
import 'shared/text_field_style.dart';

class IntroWidget extends StatefulWidget {
  const IntroWidget({super.key});

  @override
  State<IntroWidget> createState() => _IntroWidgetState();
}

class _IntroWidgetState extends State<IntroWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward().whenComplete(() {
    // put here the stuff you wanna do when animation completed!
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWidget(),
        )
    );
  });
//forward to stop animation to run once, repeat reverse to repeating
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Intro1Widget - FRAME

    return Container(
        width: 385,
        height: 844,
        decoration: BoxDecoration(
          color: Color.fromRGBO(252, 213, 206, 1),
        ),
        child: Stack(children: <Widget>[
          AnimateElements(controller: _controller, left: 0, top: 430, width: 390, height: 276,
              left2: 0, top2: 280, width2: 390, height2: 276,
              container: Container(
                child: LargeOrangeTextStyle(text: 'Small Challenges', fontSize: 70,),
              )
          ),
          AnimateElements(controller: _controller, left: 151, top: 337, width: 75, height: 75,
              left2: 95, top2: 64, width2: 75, height2: 75,
              container: Container(
                child: Image(image: AssetImage('assets/images/idea-bulb.png'),
                  fit: BoxFit.fitWidth,),
              )
          ),
          AnimateElements(controller: _controller, left: 35, top: 677, width: 319, height: 144,
              left2: 35, top2: 590, width2: 319, height2: 144,
              container: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PinkTextStyle(text: 'Be happy with them !',),
                    SizedBox(height: 0),
                    Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/mug.png'),
                              fit: BoxFit.fitWidth),
                        )),
                  ],
                ),

              )
          ),
          AnimateElements(controller: _controller, left: 388, top: 207, width: 50, height: 50,
              left2: 243, top2: 207, width2: 50, height2: 50,
              container: Container(
                child: Image(image: AssetImage('assets/images/pencil.png'),
                fit: BoxFit.fitWidth,),
              )
          ),
          AnimateElements(controller: _controller, left: 157, top: 327, width: 75, height: 75,
              left2: 158, top2: 58, width2: 75, height2: 75,
              container: Container(
                child: Image(image: AssetImage('assets/images/medal.png'),
                  fit: BoxFit.fitWidth,),
              )
          ),
          AnimateElements(controller: _controller, left: 158, top: 323, width: 75, height: 75,
              left2: 225, top2: 58, width2: 75, height2: 75,
              container: Container(
                child: Image(image: AssetImage('assets/images/like.png')),
    )
    ),
          AnimateElements(controller: _controller, left: 95, top: 298, width: 200, height: 200,
              left2: 95, top2: 133, width2: 200, height2: 200,
              container: Container(
                child: Image(image: AssetImage('assets/images/trophy.png'),
                  fit: BoxFit.fitWidth,),
              )
          ),
        ]));
  }
}


