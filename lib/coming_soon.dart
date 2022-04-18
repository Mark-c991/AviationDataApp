// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wikidart/wikidart.dart';
import 'airplane_engine_icons_icons.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Coming Soon...")),body: Body(),);
  }
}

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Coming Soon",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),));
  }
}