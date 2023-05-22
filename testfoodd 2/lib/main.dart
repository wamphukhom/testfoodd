import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, //ลบรูปมุมขวาบนที่โชว์คำว่า debug
    home: HomePage(),
  ));
}
