import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  // create index to select from the list of route paths
  final int navItemIndex; //#1
  const CustomBottomNavBar({required this.navItemIndex, Key? key})
      : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
// Function that handles navigation based of index received
  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 213, 206, 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          elevation: 0, // to get rid of the shadow
          selectedItemColor: Color.fromRGBO(255, 170, 98, 1),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          backgroundColor: Color.fromRGBO(248, 237, 235, 0.75),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/images/calendar.png"),
                width: 50,
              ),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Image(
                  image: AssetImage("assets/images/favorite.png"), width: 50),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Image(
                  image: AssetImage("assets/images/user-profile.png"),
                  width: 50),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
    // ==========================================//
  }
}
