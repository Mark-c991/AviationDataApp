// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'dart:convert';
import 'package:aviation_data_app/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:aviation_data_app/aviation_dictionary.dart';
import 'package:aviation_data_app/engine_info.dart';
import 'package:aviation_data_app/airplane_info.dart';
import 'package:wikidart/wikidart.dart';
import 'airplane_engine_icons_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aviation Data App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyStatefulWidget(),
    );
  }
}

const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TextInputWidget(),
    AviationInfo(),
    FlightInfo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aviation Data App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.airport),
            label: 'Airport Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.airplane),
            label: 'Aviation Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.airplaneTakeoff),
            label: 'Flights',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({Key? key}) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();
  var label = "";
  var resultRaw = "";
  var resultFinal = "";
  String airportsFreeText = "";
  String text = "";
  String codeType = "";
  String depAirportCode = "";
  String destAirportCode = "";
  bool falseInput = false;
  void click() async{
    controller.clear();
    FocusScope.of(context).unfocus();
    String searchUrl = "https://";
    if (selectedValue == "Distance / Flight time to another airport by IATA/ICAO-codes"){
      String query = this.text.trim();
      if (query.length == 7){
        codeType = "iata";
        depAirportCode = query.substring(0,3);
        destAirportCode = query.substring(4,7);
      } else if(query.length == 9){
        codeType = "icao";
        depAirportCode = query.substring(0,4);
        destAirportCode = query.substring(5,9);
      } else {
        this.resultFinal = "False Input! Please Enter like this: ICAO or IATA of Departure Airport/ICAO or IATA of Deistination Airport\nFor Example: LAX/LHR\nIf you don't know what the IATA or ICAO code is, you should take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/" + codeType + "/" + depAirportCode + "/distance-time/" + destAirportCode;
      var result = await http.get(
        Uri.parse(searchUrl), 
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        }, 
      );
      try{
        //Departure Airport Data
        final res = json.decode(result.body);
        final deptIcao = res["from"]["icao"];
        final deptIata = res["from"]["iata"];
        final deptName = res["from"]["name"];
        final deptShortname = res["from"]["shortName"];
        final deptMunicipalityName = res["from"]["municipalityName"];
        final deptLat = res["from"]["location"]["lat"].toString();
        final deptLong = res["from"]["location"]["lon"].toString();
        final deptCountryCode = res["from"]["countryCode"];
        final deptAirport = "Departure Airport Data: \nICAO: " + deptIcao + "\nIATA: " + deptIata + "\nName: " + deptName + "\nShort Name: " + deptShortname + "\nMunicipality: " + deptMunicipalityName + "\nLocation: Longtitude: " + deptLong + " Latitude: " + deptLat + "\nCountry Code: " + deptCountryCode + "\n";
        //Destination Airport Data
        final destIcao = res["to"]["icao"];
        final destIata = res["to"]["iata"];
        final destName = res["to"]["name"];
        final destShortname = res["to"]["shortName"];
        final destMunicipalityName = res["to"]["municipalityName"];
        final destLat = res["to"]["location"]["lat"].toString();
        final destLong = res["to"]["location"]["lon"].toString();
        final destCountryCode = res["to"]["countryCode"];
        final destAirport = "\nDestination Airport Data: \nICAO: " + destIcao + "\nIATA: " + destIata + "\nName: " + destName + "\nShort Name: " + destShortname + "\nMunicipality: " + destMunicipalityName + "\nLocation: Longtitude: " + destLong + " Latitude: " + destLat + "\nCountry Code: " + destCountryCode + "\n";
        //Great Circle Distance
        final gcdMeter = res["greatCircleDistance"]["meter"].toString();
        final gcdKilometer = res["greatCircleDistance"]["km"].toString();
        final gcdMile = res["greatCircleDistance"]["mile"].toString();
        final gcdNm = res["greatCircleDistance"]["nm"].toString();
        final gcdFeet = res["greatCircleDistance"]["feet"].toString();
        final gcd = "\nGreat Circle Distance:\n" + gcdMeter + " Meter\n" + gcdKilometer + " Km\n" + gcdMile + " Miles\n" + gcdNm + " Nm\n" + gcdFeet + " feet\n";
        //Approximate Flight Time
        final approxFlightTime = "\nApproximate Flight Time: " + res["approxFlightTime"].toString();
        //Final Data
        this.resultFinal = deptAirport + destAirport + gcd + approxFlightTime;
      } on Exception catch(e){
        try{
          final res = json.decode(result.body);
          this.resultFinal = res["messages"];
        } on Exception catch(e){
          try{
            final res = json.decode(result.body);
            this.resultFinal = res["message"];
          } on Exception catch(e){
            this.resultFinal = "API Error";
          }
        } 
      }
    } else if(selectedValue == "Search airports by free text"){
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/search/term?q=";
      var result = await http.get(
        Uri.parse(searchUrl+this.text+"&limit=5"),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      final res = json.decode(result.body);
      final airportList = res["items"];
      airportsFreeText = "Airport which fit the search term " + this.text + ":\n";
      for (var airport in airportList){
        airportsFreeText = airportsFreeText + "\nICAO: "+airport["icao"]+"\nIATA: "+airport["iata"]+"\nName: "+airport["name"]+"\nShort Name: "+airport["shortName"]+"\nMunicipality Name: "+airport["municipalityName"]+"\nLocation: Latitude: "+airport["location"]["lat"].toString()+" Longitude: "+airport["location"]["lon"].toString()+"\nCountry Code: "+airport["countryCode"]+"\n";
      }
      this.resultFinal = airportsFreeText;
    } else if(selectedValue == "Search airports by location (co-ordinates)"){
      String query = this.text.trim();
      var querySplit = query.split("/");
      if(querySplit.length != 3){
        this.resultFinal = "False input! Please enter like this: Latitude/Longitude/Radius around coordinate which is searched for Airports (max. 1000) (unit = kilometers)\nFor example: 51.511142/-0.103869/100";
        setState(() => resultRaw = resultFinal);
        return;
      }
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/search/location/"+querySplit[0]+"/"+querySplit[1]+"/km/"+querySplit[2]+"/10";
      var airportInAreaResult = await http.get(
        Uri.parse(searchUrl),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      var res = json.decode(airportInAreaResult.body);
      if(res.toString().contains("message")){
        this.resultFinal = res["message"];
        setState(() => resultRaw = resultFinal);
        return;
      }
      if(res == null){
        this.resultFinal = "False input! Please enter like this: Latitude/Longitude/Radius around coordinate which is searched for Airports (max. 1000) (unit = kilometers)\nFor example: 51.511142/-0.103869/100";
        setState(() => resultRaw = resultFinal);
        return;
      }
      String airportFinal = "";
      for (var airport in res["items"]){
        airportFinal = airportFinal + "\nICAO: "+airport["icao"].toString()+"\nIATA: "+airport["iata"].toString()+"\nName: "+airport["name"].toString()+"\nMunicipality Name: "+airport["municipalityName"].toString()+"\nLocation: Latitude: "+airport["location"]["lat"].toString()+" Longitude: "+airport["location"]["lon"].toString()+"\nCountry Code: "+airport["countryCode"].toString()+"\n";
      }
      airportFinal = airportFinal.replaceAll("null", "N/A");
      this.resultFinal = airportFinal;
    } else if(selectedValue == "Airport routes and daily flights by ICAO code"){
      String query = this.text.trim();
      if (query.length == 3){
        codeType = "iata";
        searchUrl = "https://aerodatabox.p.rapidapi.com/airports/"+codeType+"/"+query;
        var airportCodeResult = await http.get(
          Uri.parse(searchUrl),
          headers: {
            "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	          "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
          },
        );
        var airportres = json.decode(airportCodeResult.body);
        query = airportres["icao"];
        if(airportres == null){
          this.resultFinal = "Airport with IATA code "+query+" not found. You may try the Airports ICAO code.";
          setState(() => resultRaw = resultFinal);
          return;
        }
      } else if(query.length == 4){
        codeType = "icao";
      } else {
        this.resultFinal = "False Input! Please Enter a valid ICAO or IATA code\nFor Example: LAX or KLAX\nIf you don't know what the IATA or ICAO code is, you should take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/icao/"+query+"/stats/routes/daily";
      var result = await http.get(
        Uri.parse(searchUrl),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      if(result.body == ""){
        this.resultFinal = query+" is not a valid "+codeType.toUpperCase()+" code!\nPlease enter a valid ICAO or IATA code. If you don't know what the ICAO or IATA code is take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      final res = json.decode(result.body);
      String finalRoutes = res["routes"].length.toString()+" Routes from "+query+" to other destinations:\n";
      String finalOperators = "";
      String finalLocation = "";
      for (var route in res["routes"]){
        for (var operators in route["operators"]){
          finalOperators = finalOperators + operators["name"]+",";
        }
        if (route["destination"]["location"] == null){finalLocation = "\n   Location: N/A";}
        else{
          finalLocation = "\n   Location: Latitude: "+route["destination"]["location"]["lat"].toString()+" Longitude: "+route["destination"]["location"]["lon"].toString();
        }
        finalRoutes = finalRoutes + "\nDestination: "+"\n   ICAO: "+route["destination"]["icao"].toString()+"\n   IATA: "+route["destination"]["iata"].toString()+"\n   Name: "+route["destination"]["name"].toString()+"\n   Municipality Name: "+route["destination"]["municipalityName"].toString()+finalLocation+"\n   Country Code: "+route["destination"]["countryCode"].toString()+"\nAverage daily flights from "+query.toString()+" to this destination: "+route["destination"]["averageDailyFligths"].toString()+"\nOperators: "+finalOperators+"\n";
      }
      finalRoutes = finalRoutes.replaceAll("null", "N/A");
      this.resultFinal = finalRoutes;
    } else if(selectedValue == "Aiport Info by IATA/ICAO code"){
      String query = this.text.trim();
      if (query.length == 3){
        codeType = "iata";
      } else if(query.length == 4){
        codeType = "icao";
      } else {
        this.resultFinal = "False Input! Please Enter a valid ICAO or IATA code\nFor Example: LAX or KLAX\nIf you don't know what the IATA or ICAO code is, you should take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      } 
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/"+codeType+"/"+query;
      var result = await http.get(
        Uri.parse(searchUrl),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      if(result.body == ""){
        this.resultFinal = query+" is not a valid "+codeType.toUpperCase()+" code!\nPlease enter a valid ICAO or IATA code. If you don't know what the ICAO or IATA code is take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      final res = json.decode(result.body);
      var airportInfo = "No matching Airport Found";
      airportInfo = "Airport matching "+codeType.toUpperCase()+" code: "+query+"\n\nICAO: "+res["icao"].toString()+"\nIATA: "+res["iata"].toString()+"\nShort Name: "+res["shortName"].toString()+"\nFull Name: "+res["fullName"].toString()+"\nMunicipality Name: "+res["municipalityName"].toString()+"\nLocation: Latitude: "+res["location"]["lat"].toString()+" Longitude: "+res["location"]["lon"].toString()+"\nCountry: Code: "+res["country"]["code"].toString()+" Name: "+res["country"]["name"].toString()+"\nContinent: Code: "+res["continent"]["code"].toString()+" Name: "+res["continent"]["name"].toString()+"\nWebsites related to the Airport: "+"\nAirport Website: "+res["urls"]["webSite"].toString()+"\nWikipedia: "+res["urls"]["wikipedia"].toString()+"\nGoogle Maps: "+res["urls"]["googleMaps"].toString()+"\nFlight Radar: "+res["urls"]["flightRadar"].toString()+"\nLive ATC: "+res["urls"]["liveAtc"].toString();
      airportInfo = airportInfo.replaceAll("null", "N/A");
      this.resultFinal = airportInfo;
    } else if(selectedValue == "Airport local time by ICAO code"){
      String query = this.text.trim();
      if (query.length == 3){
        codeType = "iata";
      } else if(query.length == 4){
        codeType = "icao";
      } else {
        this.resultFinal = "False Input! Please Enter a valid ICAO or IATA code\nFor Example: LAX or KLAX\nIf you don't know what the IATA or ICAO code is, you should take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/"+codeType+"/"+query+"/time/local";
      var result = await http.get(
        Uri.parse(searchUrl),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      if(result.body == ""){
        this.resultFinal = query+" is not a valid "+codeType.toUpperCase()+" code!\nPlease enter a valid ICAO or IATA code. If you don't know what the ICAO or IATA code is take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      final res = json.decode(result.body);
      List utcDateTime = res["utcTime"].split("T");
      List utcTimeRaw = utcDateTime[1].split("+");
      String utcTime = utcTimeRaw[0];
      List localDateTime = res["localTime"].split("T");
      List localTimeRaw = [];
      if (localDateTime.contains("+")){
        localTimeRaw = localDateTime[1].split("+");
      }else{
        localTimeRaw = localDateTime[1].split("-");
      }
      String localTime = localTimeRaw[0];
      String localTimeDiffToUtc = localTimeRaw[1];
      if(localDateTime.contains("+")){
        localTimeDiffToUtc = "+"+localTimeDiffToUtc;
      }else{
        localTimeDiffToUtc = "-"+localTimeDiffToUtc;
      }
      var airportLocalTime = "Local time at Airport with "+codeType.toUpperCase()+" code "+query+"\n\nUTC Time: Date: "+utcDateTime[0]+" Time: "+utcTime+"\nLocal Date and Time:\n\bDate: "+localDateTime[0]+"\n\bTime: "+localTime+"\n\bDifference to UTC: "+localTimeDiffToUtc;
      this.resultFinal = airportLocalTime;
    } else if(selectedValue == "Airport runways by ICAO code"){
      String query = this.text.trim();
      if (query.length == 3){
        codeType = "iata";
        searchUrl = "https://aerodatabox.p.rapidapi.com/airports/"+codeType+"/"+query;
        var airportCodeResult = await http.get(
          Uri.parse(searchUrl),
          headers: {
            "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	          "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
          },
        );
        var airportres = json.decode(airportCodeResult.body);
        query = airportres["icao"];
        if(airportres == null){
          this.resultFinal = "Airport with IATA code "+query+" not found. You may try the Airports ICAO code.";
          setState(() => resultRaw = resultFinal);
          return;
        }
      } else if(query.length == 4){
        codeType = "icao";
      } else {
        this.resultFinal = "False Input! Please Enter a valid ICAO or IATA code\nFor Example: LAX or KLAX\nIf you don't know what the IATA or ICAO code is, you should take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      searchUrl = "https://aerodatabox.p.rapidapi.com/airports/icao/"+query+"/runways";
      var result = await http.get(
        Uri.parse(searchUrl),
        headers: {
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
	        "X-RapidAPI-Key": "f67599df02msh5aab2f28a8e3096p1720c3jsn2bbedab0d6c6"
        },
      );
      if(result.body == ""){
        this.resultFinal = query+" is not a valid "+codeType.toUpperCase()+" code!\nPlease enter a valid ICAO or IATA code. If you don't know what the ICAO or IATA code is take a look into the aviation dictionary.";
        setState(() => resultRaw = resultFinal);
        return;
      }
      final res = json.decode(result.body);
      int len = res.length;
      String runwayFinal = query+" Airport has "+len.toString()+" Runways:\n";
      String status = "";
      for (var runway in res){
        if(runway["isClosed"]){
          status = "Closed";
        } else if (runway["isClosed"] == null){
          status = "N/A";
        } else{
          status = "Open";
        }
      runwayFinal = runwayFinal + "\nName: "+runway["name"].toString()+"\nTrue Heading: "+runway["trueHdg"].toString()+"\nLength: "+runway["length"]["km"].toString()+" km/"+runway["length"]["mile"].toString()+" miles/"+runway["length"]["feet"].toString()+" feet"+"\nWidth: "+runway["width"]["meter"].toString()+" meter/"+runway["width"]["feet"].toString()+" feet"+"\nStatus: "+status+"\nLocation: Latitude: "+runway["location"]["lat"].toString()+" Longitude: "+runway["location"]["lon"].toString()+"\nSurface: "+runway["surface"].toString()+"\nHas Lighting: "+runway["hasLighting"].toString()+"\nDisplaced Threshold: "+runway["displacedThreshold"]["meter"].toString()+" meter/"+runway["displacedThreshold"]["feet"].toString()+" feet\n";
      }
      runwayFinal = runwayFinal.replaceAll("null", "N/A");
      this.resultFinal = runwayFinal;
    } else if(selectedValue == null){
      resultFinal = "Select a request type from the dropdown list above";
    }
    setState(() => resultRaw = resultFinal);
  }

  String? selectedValue;
  List<String> items = [
    'Distance / Flight time to another airport by IATA/ICAO-codes',
    'Search airports by free text',
    'Search airports by location (co-ordinates)',
    'Airport routes and daily flights by IATA/ICAO code',
    'Aiport Info by IATA/ICAO code',
    'Airport local time by IATA/ICAO code',
    'Airport runways by IATA/ICAO code',
  ];
  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  void changeText(text){
    this.text = text;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text("Select Item", style: TextStyle(fontSize: 14,color: Theme.of(context).hintColor),),
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
              if (selectedValue == "Distance / Flight time to another airport by IATA/ICAO-codes") {label = "Enter IATA or ICAO start code/end code";}
              else if (selectedValue == "Search airports by free text") {label = "Enter city or airport name";}
              else if(selectedValue == "Search airports by location (co-ordinates)") {label = "Enter latitude/longitude/radius(0-1000)";}
              else if(selectedValue == "Airport routes and daily flights by IATA/ICAO code") {label = "Enter IATA or ICAO code";}
              else if(selectedValue == "Aiport Info by IATA/ICAO code") {label = "Enter IATA or ICAO code";}
              else if(selectedValue == "Airport local time by IATA/ICAO code") {label = "Enter IATA or ICAO code";}
              else if(selectedValue == "Airport runways by IATA/ICAO code") {label = "Enter IATA or ICAO code";}
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
        Expanded(flex: 1, child: SingleChildScrollView(child: Text(resultRaw), scrollDirection: Axis.vertical,)),
        TextField(
          controller: controller,
          onChanged: (text) => this.changeText(text),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search), 
            labelText: label,
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              splashColor: Colors.blue,
              tooltip: "Send request", 
              onPressed: this.click,
              ) 
            ),
        ),
      ]
    );
  }
}

class AviationInfo extends StatefulWidget {
  const AviationInfo({ Key? key }) : super(key: key);

  @override
  State<AviationInfo> createState() => _AviationInfoState();
}

class _AviationInfoState extends State<AviationInfo> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AirplaneInfo()));
        } , icon: Icon(MdiIcons.airplaneSearch), label: Text("Aircraft Info")),
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EngineInfo()));
        } , icon: Icon(AirplaneEngineIcons.jetengine1), label: Text("Airplane Engine Info")),
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AviationDictionary()));
        } , icon: Icon(MdiIcons.bookSearch), label: Text("Aviation Dictionary")),
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));
        } , icon: Icon(MdiIcons.airplaneCog), label: Text("Aircraft Systems")),
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));
        } , icon: Icon(MdiIcons.alphabetLatin), label: Text("Aviation Abbreviations")),
        OutlinedButton.icon(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComingSoon()));
        } , icon: Icon(MdiIcons.book), label: Text("FAA Regulations"))
      ],
    );
  }
}

class FlightInfo extends StatefulWidget {
  const FlightInfo({ Key? key }) : super(key: key);

  @override
  State<FlightInfo> createState() => _FlightInfoState();
}

class _FlightInfoState extends State<FlightInfo> {
  @override
  Widget build(BuildContext context) {
    return Text("Live Flight Tracker \n Coming Soon...", style: optionStyle,);
  }
}