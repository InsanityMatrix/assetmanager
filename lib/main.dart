import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assetmanager/essential_icons_icons.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AssetManager(),
    );
  }
}

class AssetManager extends StatefulWidget {
  const AssetManager({Key key}) : super(key: key);

  @override
  _AssetManager createState() => _AssetManager();
}

class _AssetManager extends State<AssetManager> with RestorationMixin {
  RestorableInt currentSegment = RestorableInt(0);
  Widget body = Center(child: Text("Loading..."));
  @override
  String get restorationId => 'asset_manager';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(currentSegment, 'current_segment');
    body = getBody(currentSegment.value);
  }

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment.value = newValue;
      body = getBody(newValue);
    });
  }

  Widget getBody(int b) {
    switch (b) {
      case 0:
        return Overview();
      case 1:
        return Manager();
      case 2:
        return Center(child: Text("Loading..."));
    }
    return Center(child: Text("Loading..."));
  }

  final segmentedControlMaxWidth = 500.0;
  final children = <int, Widget>{
    0: Text("Overview"),
    1: Text("Manager"),
    2: Text("Settings"),
  };
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Asset Manager"),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context)
            .textTheme
            .textStyle
            .copyWith(fontSize: 13),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                width: segmentedControlMaxWidth,
                child: CupertinoSegmentedControl<int>(
                  children: children,
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment.value,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Manager extends StatefulWidget {
  const Manager({Key key}) : super(key: key);

  @override
  _Manager createState() => _Manager();
}

class _Manager extends State<Manager> with RestorationMixin {
  double width;
  @override
  String get restorationId => 'asset_manager';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 24;
    return ListView(children: getManagers());
  }

  List<Widget> getManagers() {
    List<Widget> managers = List<Widget>();
    //TODO: CUSTOM ICONS
    managers
        .add(buildUniqueManager("Car(s)", new Icon(EssentialIcons.car_side)));
    managers.add(buildUniqueManager(
        "Cryptocurrencies", new Icon(EssentialIcons.bitcoin)));
    return managers;
  }

  Widget buildUniqueManager(String manager, Icon icon) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 150,
          width: width,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                //TODO: UNIQUE MANAGERS,
              },
              splashColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(.12),
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: width * .25,
                    alignment: Alignment.center,
                    //Icon of manager
                    child: icon,
                  ),
                  Container(
                    width: width * .75,
                    alignment: Alignment.centerLeft,
                    child: Text(manager),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class Overview extends StatefulWidget {
  const Overview({Key key}) : super(key: key);

  @override
  _Overview createState() => _Overview();
}
class _Overview extends State<Overview> with RestorationMixin {
  double width;
  final List<Feature> totalFeatures = [
    Feature(
      title: "Total",
      color: Colors.blue,
      data: [9572,9624,9854,10732,10326],
    ),
  ];
  
  @override
  String get restorationId => 'asset_manager';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 24;
    Widget leader = getLeader();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        leader,
      ],
    );
  }
  
  Widget getLeader() {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.left,
        children: <Widget>[
          //Title
          Text("Total Worth:"),
          //CALCULATED WORTH HERE
          Text("$10,326"),
          //Small Graph?
          LineGraph(
             features: totalFeatures,
             size: Size(width, 300),
             labelX:['Sep 7', 'Sep 14', 'Sep 21', 'Sep 28', 'Oct 5'],
             labelY: ['7000','8000','9000','10000','11000'],
             graphColor: Colors.black87,
             showDescription: false,
          ),
        ],
      ),
    );
  }
}
