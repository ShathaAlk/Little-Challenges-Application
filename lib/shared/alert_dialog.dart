import 'package:flutter/material.dart';

class AlertDialogStyle extends StatefulWidget {
  const AlertDialogStyle({super.key});

  @override
  AlertDialogStyleState createState() => AlertDialogStyleState();
}

class AlertDialogStyleState extends State<AlertDialogStyle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          width: 1.0,
          color: Color.fromRGBO(255, 160, 142, 1),
        ),
        padding: EdgeInsets.only(left: 26, right: 26, top: 12, bottom: 12),
      ),
      onPressed: () {
        Navigator.pop(context, false); // showDialog() returns false
      },
      child: Text(
        'Cancel',
        style: TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(255, 160, 142, 1),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color.fromRGBO(255, 160, 142, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.only(left: 26, right: 26, top: 12, bottom: 12),
        //alignment: Alignment.center,
      ),
      onPressed: () {
        Navigator.pop(context, true); // showDialog() returns true
      },
      child: Text(
        'Confirm',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class OkButton extends StatelessWidget {
  const OkButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color.fromRGBO(255, 160, 142, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.only(left: 26, right: 26, top: 12, bottom: 12),
        //alignment: Alignment.center,
      ),
      onPressed: () {
        Navigator.pop(context, true); // showDialog() returns true
      },
      child: Text(
        'OK',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
