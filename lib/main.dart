import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  ui.Image image;
  bool isImageloaded = true;
  final picker = ImagePicker();
  ImageEditor editor;

  void initState() {
    super.initState();
  }

  Future <Null> openButton() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // source can be camera
    if (pickedFile != null) {      
      setState(() {
        isImageloaded = false;
      });
      final ByteData data = await rootBundle.load(pickedFile.path);
      image = await loadImage( Uint8List.view(data.buffer));
      setState(() {
        isImageloaded = true;
        editor= ImageEditor(image: image);
      });
    }
  }

  void filterButton(String filter) {
    editor.setFilter(filter);
    globalKey.currentContext.findRenderObject().markNeedsPaint();
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer =  Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage(BuildContext context) {
    if (this.isImageloaded) {
      return  Scaffold(
        appBar: AppBar(
          title: Text('Imazing'),
          backgroundColor: Color(0xFF444444),
        ),
        body: ListView(
          children: <Widget>[
          PlutoMenuBarDemo(scaffoldKey: globalKey,
            openButton: () => this.openButton(),
            filterButton: (String text) => this.filterButton(text),
            
          ),
          GestureDetector(
            onPanStart: (detailData){
              editor.down(detailData.localPosition);
              globalKey.currentContext.findRenderObject().markNeedsPaint();
            },
            onPanUpdate: (detailData){
              editor.update(detailData.localPosition);
              globalKey.currentContext.findRenderObject().markNeedsPaint();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                key: globalKey,
                painter:  editor,
              ),
            ),
          ),
        ]),
      );
    } else {  
      return  Scaffold(
        appBar: AppBar(
          title: Text('Imazing'),
          backgroundColor: Color(0xFF444444),
        ),
        body: ListView(children: <Widget>[
          PlutoMenuBarDemo(scaffoldKey: globalKey),
          Center(child:  Text('loading ...')),
        ]),
      );
    }
  }
  @override
  Widget build(BuildContext context) {

    return  _buildImage(context);
  }
}

class ImageEditor extends CustomPainter {

  ImageEditor({
    this.image,
  });

  String filterCurr = '';
  void setFilter(String ifilter) {
    filterCurr = ifilter;
  }

  final Float64List transformMatrix = Float64List.fromList(
    [1, 0, 0, 0, 
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1]);

  ui.Image image;

  int curveCount = 0;
  double brushThickness = 2.5;
  List<List<Offset>> curve = List();

  final Paint painter = new Paint()
    ..color = Colors.blue[400]
    ..style = PaintingStyle.fill
    ..strokeWidth = 5;

  void down(Offset offset){
    List<Offset> tap = new List();
    curve.add(tap);
    curveCount += 1;
    curve[curveCount-1].add(offset);
  }
  void update(Offset offset){
    curve[curveCount-1].add(offset);
  }
  void end(){
    List<Offset> tap = new List();
    curve.add(tap);
    curveCount += 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double x = globalKey.currentContext.size.width / image.width;
    double y = globalKey.currentContext.size.height / image.height;
    if (x > y) canvas.scale(y, y);
    else canvas.scale(x, x);

    Paint painter = new Paint();
    if (filterCurr == 'filter1')
      painter.invertColors = true;
    else if (filterCurr == 'filter2')
      painter.imageFilter = ui.ImageFilter.blur(sigmaX: image.width/500, sigmaY: image.height/500);
    else if (filterCurr == 'filter3')
      painter.imageFilter = ui.ImageFilter.matrix(transformMatrix);
    canvas.drawImage(image,  Offset(0.0, 0.0),  painter);

    if (x > y) canvas.scale(1/y, 1/y);
    else canvas.scale(1/x, 1/x);
    for(List<Offset> icurve in curve) {
      Offset start = icurve[0];
      canvas.drawCircle(start, 2, painter);
      for(Offset offset in icurve){
        canvas.drawLine(start, offset, painter);
        canvas.drawCircle(offset, brushThickness, painter);
        start = offset;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class PlutoMenuBarDemo extends StatelessWidget {
  final scaffoldKey;
  final void Function() openButton;
  final void Function(String) filterButton;

  PlutoMenuBarDemo({
    this.scaffoldKey,
    this.openButton,
    this.filterButton,
  });

  void message(context, String text) {
    if (text == 'Open') {
      print('open button');
      openButton();
    }
    else if (text == 'filter1') {
      print('filter1 button');
      filterButton(text);
    }
    else if (text == 'filter2') {
      print('filter2 button');
      filterButton(text);
    }
    else if (text == 'filter3') {
      print('filter3 button');
      filterButton(text);
    }
    scaffoldKey.currentState.hideCurrentSnackBar();
    

    final snackBar = SnackBar(
      content: Text(text),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  List<MenuItem> getMenus(BuildContext context) {
    return [
      MenuItem(
        title: 'Open',
        icon: Icons.folder_open,
        onTap: () => message(context, 'Open'),
      ),
      MenuItem(
        title: 'Save',
        icon: Icons.save,
        onTap: () => message(context, 'Save'),
      ),
      MenuItem(
        title: 'Tools',
        icon: Icons.apps_outlined,
        onTap: () => message(context, 'Tools'),
        children: [
          MenuItem(
            title: 'tool1',
            onTap: () => message(context, 'tool1'),
          ),
          MenuItem(
            title: 'tool2',
            onTap: () => message(context, 'tool2'),
          ),
        ],
      ),
      MenuItem(
        title: 'Filters',
        icon: Icons.science,
        children: [
          MenuItem(
            title: 'filter1',
            onTap: () => message(context, 'filter1'),
          ),
          MenuItem(
            title: 'filter2',
            onTap: () => message(context, 'filter2'),
          ),
          MenuItem(
            title: 'filter3',
            onTap: () => message(context, 'filter3'),
          ),
        ],
      ),
      MenuItem(
        title: 'Menu 5',
        onTap: () => message(context, 'Menu 5 tap'),
      ),
      MenuItem(
        title: 'Menu 6',
        children: [
          MenuItem(
            title: 'Menu 6-1',
            onTap: () => message(context, 'Menu 6-1 tap'),
          ),
          MenuItem(
            title: 'Menu 6-2',
            onTap: () => message(context, 'Menu 6-2 tap'),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PlutoMenuBar(
            menus: getMenus(context),
          ),
        ],
      ),
    );
  }
}
