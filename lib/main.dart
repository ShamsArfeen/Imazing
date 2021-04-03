import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:async';

void main(){
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AfterSplash(),
      image: new Image.asset('assets/Logo5.png'), // #1b0753
      backgroundColor: Colors.black87,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 120.0,
      loaderColor: Colors.blue.shade300
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() =>  _MyHomePageState();
}

GlobalKey<_MyHomePageState> globalKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  double _currentSliderValue = 5;
  final picker = ImagePicker();

  Future <Null> newBttn() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void brightChange(double value) {
  }
  
  void blurChange(double value) {
  }
  
  void sharpChange(double value) {
  }
  
  void saturationChange(double value) {
  }

  Widget paramSlider(String label, void Function(double) callback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3,
          alignment: Alignment.bottomLeft, child: 
          Text(
            label,
            style: TextStyle(color: Colors.white)
          ),
        ),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: 10,
          divisions: 10,
          label: _currentSliderValue.toString(),
          onChanged: (double value) {
            callback(value);
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
      ]
    );
  }

  Widget iconBttn() {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      alignment: Alignment.center, 
      child: IconButton(
        icon: const Icon(
          Icons.photo, 
          color: Colors.white,
        ),
      )
    );
  }


  Widget flipRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconBttn(),
        iconBttn(),
        iconBttn(),
        iconBttn(),
        iconBttn()
      ]
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Container imzButton(String itext, Color icolor, IconData iicon, void Function() callback) {
    return Container(
      width: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2,
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            spreadRadius: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.005,
            blurRadius: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.005,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.25),
          bottomRight: Radius.circular(25.25)),
        border: Border(
          top: BorderSide(width: 1.0, color: icolor),
          left: BorderSide(width: 1.0, color: icolor),
          right: BorderSide(width: 1.0, color: icolor),
          bottom: BorderSide(width: 1.0, color: icolor),
        ),
      ),
      child:  Column(
        children: [
          Container(
            width: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.15,
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            child: IconButton(
              iconSize: 50,
              icon: Icon(iicon),
              color: icolor,
              onPressed: callback,
            ),
          ),
          Text(
            itext,
            style: TextStyle(fontSize: 12, color: icolor),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return  Scaffold(
      appBar: AppBar( 
            title: Text('Imazing'),
            backgroundColor: Colors.black87.withOpacity(0.9),
            actions: [
              IconButton(icon: Icon(Icons.save, color: Colors.white,), onPressed: null)
            ],
          ),
      body: ListView(
        children: <Widget>[
        
        Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.615,
          color: Colors.black87,
        ),

        Container(
          height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.3,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                spreadRadius: 10,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              paramSlider('Brightness', brightChange),
              Container(height: MediaQuery.of(context).size.height * 0.02),
              paramSlider('Smoothness', blurChange),
              Container(height: MediaQuery.of(context).size.height * 0.02),
              paramSlider('Sharpness', sharpChange),
              Container(height: MediaQuery.of(context).size.height * 0.02),
              paramSlider('Saturation', saturationChange),
              Container(height: MediaQuery.of(context).size.height * 0.02),
              flipRow(),
              Container(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ]),
    );
  }
  @override
  Widget build(BuildContext context) {

    return  _buildImage(context);
  }
}
