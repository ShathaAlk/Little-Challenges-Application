import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
@override
  Size get preferredSize => const Size.fromHeight(55);
  const CustomAppBar({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Image.asset('assets/images/logo.png', width: 100,),
        backgroundColor: Color.fromRGBO(252, 213, 206, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
    );

    /*
        actions: <Widget>[
          IconButton(
            icon: Image(
                  image: AssetImage("images/logo.png"), width: 30),
            onPressed: () {
              // do something
            },
          )
        ],
         */
  }
}
