import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assetmanager/essential_icons_icons.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            bodyText1: TextStyle(fontFamily: 'Times New Roman'),
          )),
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
    2: Text("Explore"),
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

class Portfolio {
  final String date;
  final int amount;
  final charts.Color color;

  Portfolio(this.date, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Overview extends StatefulWidget {
  const Overview({Key key}) : super(key: key);

  @override
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> with RestorationMixin {
  double width;

  @override
  String get restorationId => 'asset_manager';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) {
    var data = [
      Portfolio('Sep 7', 9562, Colors.blue),
      Portfolio('Sep 14', 9864, Colors.blue),
      Portfolio('Sep 21', 10142, Colors.blue),
      Portfolio('Sep 28', 10487, Colors.blue),
      Portfolio('Oct 5', 10326, Colors.blue),
    ];
    var series = [
      charts.Series(
        domainFn: (Portfolio portfolio, _) => portfolio.date,
        measureFn: (Portfolio portfolio, _) => portfolio.amount,
        colorFn: (Portfolio portfolio, _) => portfolio.color,
        id: 'portfolio',
        data: data,
      ),
    ];
    width = MediaQuery.of(context).size.width - 24;
    Widget leader = getLeader(series);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        leader,
      ],
    );
  }

  Widget getLeader(var series) {
    return Container(
      width: width,
      child: Column(
        children: <Widget>[
          //Title
          Text("Total Worth:",
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.left),
          //CALCULATED WORTH HERE
          Text(
            "\$10326",
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.left,
          ),
          //Small Graph?
          SizedBox(
            height: 200,
            child: charts.LineChart(
              series,
              animate: true,
            ),
          )
        ],
      ),
    );
  }
}

class Explore extends StatefulWidget {
  const Explore({Key key}) : super(key: key);

  @override
  _Explore createState() => _Explore();
}

class _Explore extends State<Explore> with RestorationMixin {
  double width;
  @override
  String get restorationId => 'asset_manager';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {}
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 24;
    Widget search = getSearchBar(context);
    return search;
  }

  Widget getSearchBar(BuildContext context) {
    return Container();
  }
}
