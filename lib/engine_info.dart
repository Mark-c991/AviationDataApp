// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wikidart/wikidart.dart';
import 'airplane_engine_icons_icons.dart';

class EngineInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Engine Info")),body: Body(),);
  }
}

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final controller = TextEditingController();
  var resultRaw = "";
  var resultFinal = "";
  var titleFinal = "";
  String text = "";
  String imgUrl = "";
  String websites = "";
  String finalInfo = "";
  String finalResponse = "";
  bool infobox = false;
  bool article = false;
  bool specificEngine = false;
  bool infoAboutPropulsion = false;
  bool imgBackupSearch2 = false;

  void click() async{
    controller.clear();
    FocusScope.of(context).unfocus();
    finalInfo = "";
    imgUrl = "";
    resultFinal = "";
    var res = await Wikidart.searchQuery(this.text+" engine", limit: 10);
    var webSearch = await http.get(
      Uri.parse("https://google-web-search.p.rapidapi.com/?query="+this.text+"&gl=US&max=3"),
      headers: {
        "X-RapidAPI-Host": "google-web-search.p.rapidapi.com",
	      "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
      },
    );
    var resWebSearch = json.decode(webSearch.body);
    if (resWebSearch["knowledge_panel"] != null){
      infobox = true;
      if (resWebSearch["knowledge_panel"]["image"] != null){
        imgUrl = resWebSearch["knowledge_panel"]["image"]["url"];
        print("Primary Url: "+imgUrl);
      }
      for(var info in resWebSearch["knowledge_panel"]["info"]){
        finalInfo = finalInfo + info["title"] + ": ";
        for (var label in info["labels"]){
          finalInfo = finalInfo + label + ",";
        }
        finalInfo = finalInfo + "\n";
      }
    }
    if (resWebSearch["results"] != null){
      websites = "\n\nWebsites about the " + this.text +" engine:\n";
      for (var results in resWebSearch["results"]){
        websites = websites +results["url"] + "\n";
      }
    } else{
      websites = "";
    }
    if (imgUrl == "" || webSearch.statusCode != 200){
      var imgBackupSearch1 = await http.get(
        Uri.parse("https://google-image-search1.p.rapidapi.com/v2/?q="+this.text),
        headers: {
          "X-RapidAPI-Host": "google-image-search1.p.rapidapi.com",
	        "X-RapidAPI-Key": "d1a69339fcmsh399a86b2b49332cp1378d3jsn44de4624deea"
        },
      );
      if(imgBackupSearch1.statusCode == 200){
        var resImgBackupSearch = json.decode(imgBackupSearch1.body);
        if (resImgBackupSearch["response"]["images"][0]["thumbnail"]["url"] != null){
          imgUrl = resImgBackupSearch["response"]["images"][0]["thumbnail"]["url"];
          print("Bakckup Img: "+imgUrl);
        }else{imgBackupSearch2 = true;}
      }
    }
    if (imgBackupSearch2){

    }
    var pageid = res?.results?.first.pageId;
    if(pageid != null){
      article = true;
      var response = await Wikidart.summary(pageid);
      var title = response?.title;
      var description = response?.extract;
      resultFinal = description.toString() + "\nSource: Wikipedia";
      titleFinal = title.toString();
      setState(() => titleFinal.toString());
    }
    finalResponse = resultFinal.toString() + websites;
    setState(() => finalInfo.toString());
    setState(() => resultRaw = finalResponse.toString());
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  void changeText(text){
    this.text = text;
  }


  String? selectedValue;
  List<String> items = [
    'Learn about different aircraft propulsion systems',
    'Get data about a specific engine',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text("What do you want? Select an Item", style: TextStyle(fontSize: 14,color: Theme.of(context).hintColor),),
            items: items
                  .map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                  .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
              if(selectedValue == "Get data about a specific engine"){specificEngine = true; infoAboutPropulsion = false;}
              if(selectedValue == "Learn about different aircraft propulsion systems"){Navigator.push(context, MaterialPageRoute(builder: (context) => InfoAboutAircraftProp()));}
            });
          },
          buttonHeight: 55,
          buttonWidth: MediaQuery.of(context).size.width,
          itemHeight: 55,
          buttonDecoration: BoxDecoration(
            border: Border.all(color: Colors.black26)
            ),
          dropdownDecoration: BoxDecoration(
            border: Border.all(color: Colors.black26)
            ),
          )
        ),
        Visibility(visible: specificEngine,child: Text(titleFinal, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        Visibility(visible: specificEngine,child: Expanded(child: SingleChildScrollView(child: Column(children: <Widget>[if (imgUrl != "") Image.network(imgUrl, width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,),if(infobox) Container(child: Column(children: <Widget>[if (infobox) Center(child: Text("Infobox", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),),Text(finalInfo)],), decoration: BoxDecoration(border: Border.all()),), if (article) Text("Article", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),Text(resultRaw)],), scrollDirection: Axis.vertical,))),
        Visibility(
          visible: specificEngine,
          child: TextField(
            controller: controller,
            onChanged: (text) => this.changeText(text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), 
              labelText: "Enter engine name",
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                splashColor: Colors.blue,
                tooltip: "Send request", 
                onPressed: this.click,
              ) 
            ),
          ),
        ),
      ],
    );
  }
}

class InfoAboutAircraftProp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Aircraft Propulsion Systems")),body: AircraftPropBody(),);
  }
}

class AircraftPropBody extends StatelessWidget {
  const AircraftPropBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => IntroductionAircraftProp()));
        } , icon: Icon(AirplaneEngineIcons.jetengine2), label: Text("Introduction into Aircraft Propulsion Systems")),
      ],
    );
  }
}

class IntroductionAircraftProp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Introduction into Aircraft Propulsion Systems")),body: IntAircraftPropBody(),);
  }
}


class IntAircraftPropBody extends StatelessWidget {
  const IntAircraftPropBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Coming Soon",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
    );
  }
}

