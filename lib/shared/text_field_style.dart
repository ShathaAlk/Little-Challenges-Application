import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldStyle extends StatelessWidget {
  TextFieldStyle(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.errorText = '',
      required this.textInputFormatter,
      this.maxLength = 5})
      : super(key: key);
  final String labelText;
  final TextEditingController controller;
  final String errorText;
  FilteringTextInputFormatter textInputFormatter;
  int maxLength;

  int validateEmptyField(String txtField) {
    if (txtField.isEmpty || txtField.length == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  RegExp numeric = RegExp(r'^-?[0-9]+$');

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    return numeric.hasMatch(str);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      textAlign: TextAlign.center,
      onChanged: (value) {},
      validator: (value) {
        int res = validateEmptyField(value!);

        if (res == 1) {
          return errorText;
        } else {
          return null;
        }
      },
      maxLength: maxLength,
      inputFormatters: [textInputFormatter],
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(248, 237, 235, 0.75),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(248, 237, 235, 0.75),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),

        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),

        labelText: labelText,
        labelStyle: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          fontFamily: 'Itim',
          fontSize: 24,
        ),
        //labelStyle: STY
      ),
    );
  }
}

class PinkTextStyle extends StatelessWidget {
  const PinkTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color.fromRGBO(255, 160, 142, 1),
        fontFamily: 'Itim',
        fontSize: 30,
        fontWeight: FontWeight.normal,
        height: 1,
      ),
      child: BorderedText(
        strokeWidth: 1.50,
        strokeColor: Color.fromRGBO(0, 0, 0, 0.60),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class LargeOrangeTextStyle extends StatelessWidget {
  const LargeOrangeTextStyle({
    Key? key,
    required this.text, required this.fontSize,
  }) : super(key: key);

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color.fromRGBO(255, 170, 97, 1),
        fontFamily: 'Itim',
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        height: 1,
      ),
      child: BorderedText(
        strokeWidth: 1.75,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class GrayTextStyle extends StatelessWidget {
  const GrayTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color.fromRGBO(30, 30, 30, 0.4),
        fontFamily: 'Itim',
        fontSize: 20,
        fontWeight: FontWeight.normal,
        height: 1,
      ),
      child: BorderedText(
        strokeWidth: 0,
        strokeColor: Color.fromRGBO(0, 0, 0, 0.60),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
