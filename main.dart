import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

String command;

String database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var webdata;
  web(command) async {
    var url = "http://192.168.99.106/cgi-bin/web.py?x=${command}";
    var r = await http.get(url);
    setState(() {
      webdata = r.body;
    });
    print(webdata);
  }

  @override
  Widget build(BuildContext context) {
    var fs = FirebaseFirestore.instance;
    fs.collection('LinuxCommand').add({
      '$command': '$webdata',
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('LINUX COMMANDS'),
        ),
        body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          color: Colors.blue[200],
          child: Container(
            //margin: EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 200,
                    margin: EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('images/linux.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                    child: TextField(
                      onChanged: (val) {
                        command = val;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              //textBaseline: UnderlineTabIndicator,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          hintText: "Enter Linux Command",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Card(
                      child: FlatButton(
                    onPressed: () {
                      web(command);
                    },
                    child: Text(
                      "Run Command",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.black,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(00),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(00)),
                            side: BorderSide(width: 2, color: Colors.black)),
                        child: Text(
                          "${webdata}" ?? "                 ",
                          style: TextStyle(
                              height: 3,
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sriracha'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      //backgroundColor: Colors.yellow[300],
      //),
    );
  }
}
