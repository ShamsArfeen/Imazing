import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'dart:io';
import 'dart:async';

void main() {
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
        loaderColor: Colors.blue.shade300);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DoubleBackToCloseApp(
          child: MyHomePage(),
          snackBar: const SnackBar(
            content: Text('Tap back again to exit Imazing'),
          ),
        ),

        // debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

GlobalKey<_MyHomePageState> globalKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  Future<Null> imageSelector() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _screen = 1;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> cameraSelector() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _screen = 1;
      } else {
        print('No image selected.');
      }
    });
  }

  File _image;
  double _currentSliderValue = 5;
  int _screen = 0;
  int _subscreen = 0;
  final picker = ImagePicker();

  void brightChange(double value) {}

  void blurChange(double value) {}

  void sharpChange(double value) {}

  void saturationChange(double value) {}

  Widget paramSlider(String label, void Function(double) callback) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: MediaQuery.of(context).size.width / 3,
        alignment: Alignment.bottomLeft,
        child: Text(label, style: TextStyle(color: Colors.white)),
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
    ]);
  }

  Widget iconBttn(Icon picture, void Function() callback) {
    return Container(
        width: MediaQuery.of(context).size.width / 5,
        alignment: Alignment.center,
        child: IconButton(onPressed: callback, icon: picture));
  }

  void doNothing() {}
  void lightbulb() {
    if (_screen != 2 || _subscreen != 0) {
      setState(() {
        _screen = 2;
        _subscreen = 0;
      });
    } else {
      setState(() {
        _screen = 1;
      });
    }
  }

  void science() {
    if (_screen != 2 || _subscreen != 1) {
      setState(() {
        _screen = 2;
        _subscreen = 1;
      });
    } else {
      setState(() {
        _screen = 1;
      });
    }
  }

  void hardware() {
    if (_screen != 2 || _subscreen != 2) {
      setState(() {
        _screen = 2;
        _subscreen = 2;
      });
    } else {
      setState(() {
        _screen = 1;
      });
    }
  }

  Widget flipRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      iconBttn(
          Icon(Icons.rotate_right_rounded, color: Colors.white), doNothing),
      iconBttn(Icon(Icons.rotate_left_rounded, color: Colors.white), doNothing),
      iconBttn(Icon(Icons.compress, color: Colors.white), doNothing),
      iconBttn(
          Icon(Icons.swap_horizontal_circle, color: Colors.white), doNothing),
      iconBttn(Icon(Icons.swap_vertical_circle, color: Colors.white), doNothing)
    ]);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _savePhoto() async {
    var result = await ImageGallerySaver.saveFile(_image.path);
    print(result);
    if (result['isSuccess'] == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Alert Dialog title"),
            content: new Text("Image saved successfully"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (result['isSuccess'] == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Alert Dialog title"),
            content: new Text("Image failed to save"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _returnToHome() {
    // setState(() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: new Text("Alert Dialog title"),
            content: new Text("Are you sure you want to return to Home"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    setState(() {
                      _screen = 0;
                      Navigator.of(context).pop();
                    });
                  }),
              new TextButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      _screen = 1;
                      Navigator.of(context).pop();
                    });
                  }),
            ],
          );
          // });
        });
  }

  Container imzButton(
      String itext, Color icolor, IconData iicon, void Function() callback) {
    return Container(
      width: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            spreadRadius: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.005,
            blurRadius: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.005,
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
      child: Column(
        children: [
          Container(
            width: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.15,
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.1,
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
    PreferredSizeWidget AppbarWithSave = AppBar(
      title: Text('Imazing'),
      backgroundColor: Colors.black87.withOpacity(0.9),
      actions: [
        IconButton(
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: _savePhoto,
        ),
        IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: _returnToHome,
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Help"),
                  content: new Text(
                      "Edit your image using the options given below. Adjust the brightness, saturation and smoothness of the image. "
                      "You can also rotate, flip and mirror your desired image."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new TextButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );

    if (_screen == 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Imazing'),
            backgroundColor: Colors.black87.withOpacity(0.9),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.info_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("Help"),
                        content: new Text(
                            "Imazing is an image editing application. Upload an image from the gallery or camera and proceed to the edit screen"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          new TextButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: homeScreen());
    } else if (_screen == 1) {
      return Scaffold(appBar: AppbarWithSave, body: viewScreen());
    } else if (_screen == 2) {
      return Scaffold(appBar: AppbarWithSave, body: editScreen());
    }
  }

  Widget viewScreen() {
    return ListView(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top) *
            0.825,
        color: Colors.black87,
        child: PinchZoom(
          image: Image.file(_image),
          zoomedBackgroundColor: Colors.black87,
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 2.5,
          onZoomStart: () {
            print('Start zooming');
          },
          onZoomEnd: () {
            print('Stop zooming');
          },
        ),
      ),
      Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.099,
          color: Colors.black87.withOpacity(0.95),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            iconBttn(getLightbulb(), lightbulb),
            iconBttn(getScience(), science),
            iconBttn(getHandyman(), hardware),
          ])),
    ]);
  }

  Widget widgetLightbulb() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.152,
      color: Colors.black87,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          paramSlider('Brightness', brightChange),
          paramSlider('Smoothness', blurChange),
        ],
      ),
    );
  }

  Widget widgetScience() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.152,
      color: Colors.black87,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          paramSlider('Sharpness', sharpChange),
          paramSlider('Saturation', saturationChange),
        ],
      ),
    );
  }

  Widget widgetHardware() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.152,
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          flipRow(),
        ],
      ),
    );
  }

  Icon getLightbulb() {
    if (_subscreen != 0 || _screen != 2)
      return Icon(Icons.lightbulb, color: Colors.white);
    else
      return Icon(Icons.lightbulb, color: Colors.blue);
  }

  Icon getScience() {
    if (_subscreen != 1 || _screen != 2)
      return Icon(Icons.science, color: Colors.white);
    else
      return Icon(Icons.science, color: Colors.blue);
  }

  Icon getHandyman() {
    if (_subscreen != 2 || _screen != 2)
      return Icon(Icons.handyman, color: Colors.white);
    else
      return Icon(Icons.handyman, color: Colors.blue);
  }

  Widget editScreen() {
    Widget subWidget;

    if (_subscreen == 0)
      subWidget = widgetLightbulb();
    else if (_subscreen == 1)
      subWidget = widgetScience();
    else if (_subscreen == 2) subWidget = widgetHardware();

    return ListView(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top) *
            0.674,
        color: Colors.black87,
        child: PinchZoom(
          image: Image.file(_image),
          zoomedBackgroundColor: Colors.black87,
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 2.5,
          onZoomStart: () {
            print('Start zooming');
          },
          onZoomEnd: () {
            print('Stop zooming');
          },
        ),
      ),
      subWidget,
      Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.099,
          color: Colors.black87.withOpacity(0.95),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            iconBttn(getLightbulb(), lightbulb),
            iconBttn(getScience(), science),
            iconBttn(getHandyman(), hardware),
          ])),
    ]);
  }

  Widget homeScreen() {
    return Container(
      color: Colors.black,
      child: Align(
        child: Row(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          await imageSelector();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: MediaQuery.of(context).size.width / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 14,
                                height: MediaQuery.of(context).size.width /
                                    2 /
                                    0.6625,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Opacity(
                                    opacity: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        color: Colors.black.withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          await cameraSelector();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: MediaQuery.of(context).size.width / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 14,
                                height: MediaQuery.of(context).size.width /
                                    2 /
                                    0.6625,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Opacity(
                                    opacity: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        color: Colors.black.withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     child: Text(
            //       "Select image, and edit them easily in a matter of seconds. Save or share them wherever and whenever you want.",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         fontSize: 13,
            //         color: Theme.of(context).hintColor,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage(context);
  }
}

// import 'package:flutter/material.dart';
//
// import 'package:splashscreen/splashscreen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pinch_zoom/pinch_zoom.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'dart:io';
// import 'dart:async';
//
// void main() {
//   runApp(new MaterialApp(
//     home: new MyApp(),
//   ));
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return new SplashScreen(
//         seconds: 5,
//         navigateAfterSeconds: new AfterSplash(),
//         image: new Image.asset('assets/Logo5.png'), // #1b0753
//         backgroundColor: Colors.black87,
//         styleTextUnderTheLoader: new TextStyle(),
//         photoSize: 120.0,
//         loaderColor: Colors.blue.shade300);
//   }
// }
//
// class AfterSplash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// GlobalKey<_MyHomePageState> globalKey = GlobalKey();
//
// class _MyHomePageState extends State<MyHomePage> {
//   Future<Null> imageSelector() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _screen = 2;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<Null> cameraSelector() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _screen = 1;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   File _image;
//   double _currentSliderValue = 5;
//   int _screen = 0;
//   final picker = ImagePicker();
//   bool savedImage;
//
//   Future<Null> newBttn() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _screen = 1;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future saveImage() async {
//     // renameImage();
//     print("save screen here");
//     await ImageGallerySaver.saveFile(_image.path);
//     // await GallerySaver.saveImage(image.path, albumName: "PhotoEditor");
//     setState(() {
//       savedImage = true;
//     });
//   }
//
//   void brightChange(double value) {}
//
//   void blurChange(double value) {}
//
//   void sharpChange(double value) {}
//
//   void saturationChange(double value) {}
//
//   Widget paramSlider(String label, void Function(double) callback) {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Container(
//         width: MediaQuery.of(context).size.width / 3,
//         alignment: Alignment.bottomLeft,
//         child: Text(label, style: TextStyle(color: Colors.white)),
//       ),
//       Slider(
//         value: _currentSliderValue,
//         min: 0,
//         max: 10,
//         divisions: 10,
//         label: _currentSliderValue.toString(),
//         onChanged: (double value) {
//           callback(value);
//           setState(() {
//             _currentSliderValue = value;
//           });
//         },
//       ),
//     ]);
//   }
//
//   Widget iconBttn() {
//     return Container(
//         width: MediaQuery.of(context).size.width / 5,
//         alignment: Alignment.center,
//         child: IconButton(
//           icon: const Icon(
//             Icons.photo,
//             color: Colors.white,
//           ),
//         ));
//   }
//
//   Widget flipRow() {
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [iconBttn(), iconBttn(), iconBttn(), iconBttn(), iconBttn()]);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Container imzButton(
//       String itext, Color icolor, IconData iicon, void Function() callback) {
//     return Container(
//       width: (MediaQuery.of(context).size.height -
//               MediaQuery.of(context).padding.top) *
//           0.2,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black87,
//             spreadRadius: (MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top) *
//                 0.005,
//             blurRadius: (MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top) *
//                 0.005,
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25.25),
//             bottomRight: Radius.circular(25.25)),
//         border: Border(
//           top: BorderSide(width: 1.0, color: icolor),
//           left: BorderSide(width: 1.0, color: icolor),
//           right: BorderSide(width: 1.0, color: icolor),
//           bottom: BorderSide(width: 1.0, color: icolor),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: (MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top) *
//                 0.15,
//             height: (MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top) *
//                 0.1,
//             child: IconButton(
//               iconSize: 50,
//               icon: Icon(iicon),
//               color: icolor,
//               onPressed: callback,
//             ),
//           ),
//           Text(
//             itext,
//             style: TextStyle(fontSize: 12, color: icolor),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImage(BuildContext context) {
//     if (_screen == 0) {
//       return Scaffold(
//           appBar: AppBar(
//             title: Text('Imazing'),
//             backgroundColor: Colors.black87.withOpacity(0.9),
//             actions: [
//               IconButton(
//                   icon: Icon(
//                     Icons.save,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     _screen = 2;
//                   })
//             ],
//           ),
//           body: homeScreen());
//     } else if (_screen == 1) {
//       return Scaffold(
//           appBar: AppBar(
//             title: Text('Imazing'),
//             backgroundColor: Colors.black87.withOpacity(0.9),
//             actions: [
//               IconButton(
//                   icon: Icon(
//                     Icons.save,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     _screen = 2;
//                   })
//             ],
//           ),
//           body: editScreen());
//     } else if (_screen == 2) {
//       return Scaffold(
//           appBar: AppBar(
//             title: Text('Save Photo'),
//             backgroundColor: Colors.black,
//           ),
//           body: saveScreen());
//     }
//   }
//
//   Widget editScreen() {
//     return ListView(children: <Widget>[
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: (MediaQuery.of(context).size.height -
//                 MediaQuery.of(context).padding.top) *
//             0.615,
//         color: Colors.black87,
//         child: PinchZoom(
//           image: Image.file(_image),
//           zoomedBackgroundColor: Colors.black.withOpacity(0.5),
//           resetDuration: const Duration(milliseconds: 100),
//           maxScale: 2.5,
//           onZoomStart: () {
//             print('Start zooming');
//           },
//           onZoomEnd: () {
//             print('Stop zooming');
//           },
//         ),
//       ),
//       Container(
//         height: (MediaQuery.of(context).size.height -
//                 MediaQuery.of(context).padding.top) *
//             0.3,
//         decoration: BoxDecoration(
//           color: Colors.black54.withOpacity(0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black87,
//               spreadRadius: 10,
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: ListView(
//           scrollDirection: Axis.vertical,
//           children: <Widget>[
//             paramSlider('Brightness', brightChange),
//             Container(height: MediaQuery.of(context).size.height * 0.02),
//             paramSlider('Smoothness', blurChange),
//             Container(height: MediaQuery.of(context).size.height * 0.02),
//             paramSlider('Sharpness', sharpChange),
//             Container(height: MediaQuery.of(context).size.height * 0.02),
//             paramSlider('Saturation', saturationChange),
//             Container(height: MediaQuery.of(context).size.height * 0.02),
//             flipRow(),
//             Container(height: MediaQuery.of(context).size.height * 0.02),
//           ],
//         ),
//       ),
//     ]);
//   }
//
//   Widget homeScreen() {
//     return Align(
//       child: Row(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () async {
//                         await imageSelector();
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width / 2 - 20,
//                         height: MediaQuery.of(context).size.width / 2,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: <Widget>[
//                             Container(
//                               width: MediaQuery.of(context).size.width / 2 - 14,
//                               height: MediaQuery.of(context).size.width /
//                                   2 /
//                                   0.6625,
//                               decoration: BoxDecoration(
//                                 color: Colors.white70,
//                                 border:
//                                     Border.all(color: Colors.black, width: 3),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Opacity(
//                                   opacity: 1,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 60.0),
//                               child: Align(
//                                 alignment: Alignment.topCenter,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.black, width: 1),
//                                       color: Colors.black.withOpacity(0.2),
//                                       shape: BoxShape.circle),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Icon(
//                                       Icons.image,
//                                       color: Colors.black,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Gallery",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () async {
//                         await cameraSelector();
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width / 2 - 20,
//                         height: MediaQuery.of(context).size.width / 2,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: <Widget>[
//                             Container(
//                               width: MediaQuery.of(context).size.width / 2 - 14,
//                               height: MediaQuery.of(context).size.width /
//                                   2 /
//                                   0.6625,
//                               decoration: BoxDecoration(
//                                 color: Colors.white70,
//                                 border:
//                                     Border.all(color: Colors.black, width: 3),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Opacity(
//                                   opacity: 1,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 60.0),
//                               child: Align(
//                                 alignment: Alignment.topCenter,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.black, width: 1),
//                                       color: Colors.black.withOpacity(0.2),
//                                       shape: BoxShape.circle),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Icon(
//                                       Icons.camera_alt_outlined,
//                                       color: Colors.black,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Camera",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ],
//           ),
//
//           // Padding(
//           //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
//           //   child: Container(
//           //     width: MediaQuery.of(context).size.width * 0.8,
//           //     child: Text(
//           //       "Select image, and edit them easily in a matter of seconds. Save or share them wherever and whenever you want.",
//           //       textAlign: TextAlign.center,
//           //       style: TextStyle(
//           //         fontSize: 13,
//           //         color: Theme.of(context).hintColor,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Widget saveScreen() {
//     return Align(
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             ClipRRect(
//               child: Container(
//                 // color: Colors.black12,
//                 margin: EdgeInsets.only(top: 20),
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.width,
//                 child: PhotoView(
//                   imageProvider: FileImage(_image),
//                   backgroundDecoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             //
//             Spacer(),
//             Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: FloatingActionButton.extended(
//                       disabledElevation: 0,
//                       heroTag: "SAVE",
//                       icon: Icon(Icons.save),
//                       label: Text("SAVE"),
//                       backgroundColor: Colors.grey,
//                       onPressed: () {
//                         saveImage();
//                       }),
//                 ),
//               ],
//             ),
//             Spacer(),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.1,
//                     child: Center(
//                       child: Icon(
//                         Icons.info,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(2.0),
//                       child: Center(
//                         child: Text(
//                           "Note - The images are saved in the best possible quality.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildImage(context);
//   }
// }
