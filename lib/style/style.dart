import 'package:flutter/material.dart';
import 'package:tyrasoft_attendance/style/color.dart';

InputDecoration getInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: inputColor,
    contentPadding: const EdgeInsets.all(16),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
  );
}

Widget getButton(String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 48,
      decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(color: Colors.white),),
    ),
  );
}