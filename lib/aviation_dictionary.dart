// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:aviation_data_app/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wikidart/wikidart.dart';
import 'airplane_engine_icons_icons.dart';

class AviationDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Aviation Dictionary")),body: Body(),);
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
    return SingleChildScrollView(child: Column(
      children: <Widget>[
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("ICAO code"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ICAOCode()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("IATA code"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("Yaw, Roll and Pitch"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("NATO Phonetic Alphabet"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("United States Tri-Service aircraft designation system"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("United States Tri-Service missile and drone designation system"), onPressed: (){},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("Flight Dynamics - Introduction"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("Flight Dynamics - Detail"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("Avionics"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
        Container(width: MediaQuery.of(context).size.width,child: TextButton(child: Text("National Airspace System"), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));},),decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)),)),
      ],
    ));
  }
}

TextStyle header =  TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

class ICAOCode extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("ICAO code")),body: IcaoBody(),);
  }
}

class IcaoBody extends StatelessWidget {
  const IcaoBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: Text("The ICAO Code", style: header,)),
        SingleChildScrollView(child: Column(
          children: <Widget>[
            Text("There are different types of ICAO codes. These codes are defined by the International Civil Aviation Organization and published in ICAO Documents. There is the ICAO airport code, the ICAO airline designator, the ICAO aircraft type designator, the ICAO 24-bit address and the ICAO altitude code."),
            Center(child: Text("ICAO airport code",style: header,),),
            Text("The ICAO airport code or location indicator is a four-letter code designating aerodromes around the world. These codes, as defined by the International Civil Aviation Organization and published in ICAO Document 7910: Location Indicators, are used by air traffic control and airline operations such as flight planning.\nTypically, the first one or two letters of the ICAO code indicate the country and the remaining letters identify the airport. ICAO codes provide geographical context. For example, if one knows that the ICAO code for Heathrow is EGLL, then one can deduce that the airport EGGP is somewhere in the UK."),
            Center(child: Text("First 2 ICAO Letters Country Map",style: header,),),
            Image.asset('assets/images/ICAOCountries.png')
          ],
        ),)
      ],
    );
  }
}
