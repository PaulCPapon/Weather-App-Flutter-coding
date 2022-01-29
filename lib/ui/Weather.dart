import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Weather extends StatefulWidget {
  @override

  _WeatherState createState() => new _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _cityEntred;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context) {
        return new Changecity();
      }),
    );

    if (results != null && results.containsKey('enter')) {
      _cityEntred = results['enter'];
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appID, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('WEATHER APP'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              color: Colors.blue,
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/background.jpg",
                height: 560.0, fit: BoxFit.fill),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 0.0),
            child: new Text(
              "${_cityEntred == null ? util.defaultCity : _cityEntred}",
              style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 50.0, 0.0, 0.0),
            child: updateTempeWidget(_cityEntred),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appID, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appID}&units=metric';
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }

  Widget updateTempeWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appID, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          // Dentro la quale abbiamo tutte le info di Json e abbiamo settato come widget.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() + "°C",
                      style: new TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.red,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: new ListTile(
                      title: Text(
                          "Umidità: ${content['main']['humidity'].toString()}\n"
                          "Temperatura Max: ${content['main']['temp_max'].toString()}°C\n"
                          "Temperatura Min: ${content['main']['temp_min'].toString()}\°C",
                       style: ExtraDati(),),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

class Changecity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change city'),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/pic1.jpg",
              width: 490.0,
              height: 560.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Metti la città',
                    fillColor: Colors.red,
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(
                          context, {'enter': _cityFieldController.text});
                    },
                    color: Colors.blue,
                    textColor: Colors.red,
                    child: new Text("Ottieni Temperatura")),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.red,
    fontSize: 20.0,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.red,
    fontSize: 50.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}

TextStyle ExtraDati() {
  return new TextStyle(
    color: Colors.red,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}