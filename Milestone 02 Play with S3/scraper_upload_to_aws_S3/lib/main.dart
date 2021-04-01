import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:scraper/detailPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Scraper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Scraper | BCSF17A505'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  List<String> cats = List();
  List<String> dogs = List();
  List<String> cars = List();
  List<String> bikes = List();
  List<String> cycles = List();
  bool flag = false;

  Future<List<String>> _getData({String query = "cat"}) async {
    List<String> images = List();
    String url = 'https://www.google.com/search?q=' + query + '&tbm=isch';
    print(url);
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    //
    final imagesElement = document.getElementsByClassName('RAyV4b'); //bRMDJf

    //
    setState(() {
      images = imagesElement
          .map((element) =>
              element.getElementsByTagName("img")[0].attributes['src'])
          .toList();
    });
    return images;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: flag,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scraping imges of\n Cat, Dog, Car, Bike and Cycle',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () async {
                  setState(() {
                    flag = true;
                  });
                  this.cats = await _getData(query: "cat");
                  this.dogs = await _getData(query: "dog");
                  this.cars = await _getData(query: "car");
                  this.bikes = await _getData(query: "bike");
                  this.cycles = await _getData(query: "cycle");
                  setState(() {
                    flag = false;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ResultPages(
                          cats: cats,
                          dogs: dogs,
                          cars: cars,
                          bikes: bikes,
                          cycles: cycles,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Start Scrap',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
