import 'package:flutter/material.dart';

class ElementsAnimation extends StatelessWidget {
  const ElementsAnimation({super.key});

  static const String _title = 'Elements Animation';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
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
    return AnimateElements(
        controller: _controller,
        left: 158,
        top: 323,
        width: 75,
        height: 75,
        left2: 225,
        top2: 58,
        width2: 75,
        height2: 75,
        container: Container(
          child: Image(image: AssetImage('assets/images/like.png')),
        ));
  }
}

class AnimateElements extends StatelessWidget {
  const AnimateElements({
    Key? key,
    required AnimationController controller,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.left2,
    required this.top2,
    required this.width2,
    required this.height2,
    required this.container,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Container container;
  final double left;
  final double top;
  final double width;
  final double height;
  final double left2;
  final double top2;
  final double width2;
  final double height2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        return Stack(
          children: <Widget>[
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    Rect.fromLTWH(left, top, width, height), size),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(left2, top2, width2, height2), size),
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticInOut,
              )),
              child: container,
            ),
          ],
        );
      },
    );
  }
}
