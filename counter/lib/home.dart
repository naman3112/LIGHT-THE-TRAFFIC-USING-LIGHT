import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Light.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _time = 30;
  String _onLight = "red";
  TabController _tabController;

  DatabaseReference _database = FirebaseDatabase().reference();
  StreamSubscription _dbSubscription, _lightStream, _timeSubscription,_priorSubscription;

  Timer _timer;

  Light _light = Light();
  int _index=0;
  int priority=0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _timeSubscription = _database.child("timer").onValue.listen((snap) {
      var factor =int.parse(snap.snapshot.value.toString())??0;
      if(_onLight=="green"){
        _time=_time+factor;
      }
      if(_onLight=="red"){
        var diff=_time-factor;
        if(diff>0){
          _time=_time-factor;
        }
      }
      _time =_time<0?0:_time;
      if (this.mounted) setState(() {});
    });
    _dbSubscription = _database.child("light").onValue.listen((snap) {
      var lightColor = snap.snapshot.value;
      switch (lightColor) {
        case 'green':
          _light.green();
          break;
        case 'red':
          _light.red();
          break;
        case 'yellow':
          _light.yellow();
          break;
      }
    });
    _lightStream = _light.lightColor().listen((lightColor) {
      switch (lightColor) {
        case 'green':
          setOnLight('green', 30);
          break;
        case 'red':
          setOnLight('red', 30);
          break;
        case 'yellow':
          setOnLight('yellow', 10);
          break;
      }
    });
    _priorSubscription=_database.child("prior").onValue.listen((priority){
      var pr=  priority.snapshot.value;
      if(pr==-1){
        _database.child("timer").set(0);
      }else{
        this.priority=priority.snapshot.value;
      }
    });
    timer();
  }

  void timer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
//      print(_time);
      _time--;
      if (_time == 0) {
        switch (_onLight) {
          case 'green':
            setOnLight('red', 30);
            break;
          case 'red':
            setOnLight('yellow', 10);
            break;
          case 'yellow':
            setOnLight('green', 30);
            break;
        }
      }
      setState(() {});
    });
  }

  void setOnLight(String value, int time) {
    _database.child("light").set(value);
    _time = time;
    if (this.mounted)
      setState(() {
        _onLight = value;
      });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    _lightStream?.cancel();
    _timer?.cancel();
    _timeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(bottomNavigationBar: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
        IconButton(icon: Icon(Icons.traffic,color: _index==0?Colors.red:Colors.black,), onPressed: (){setState(() {
          _index=0;
        });}),
        IconButton(icon: Icon(Icons.track_changes,color: _index==1?Colors.red:Colors.black), onPressed: (){
          setState(() {
            _index=1;
          });
        }),
      ],),
        body: Stack(
          children: <Widget>[
            Image.asset(
              "images/traffic.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child:_index==0?trafficLight(): statusTab(),
            )
          ],
        ),
      ),
    );
  }

  Widget tabBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(55.0),
        ),
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: TabBar(
              indicator: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(55.0),
                  )),
              controller: _tabController,
              tabs: [
                Text(
                  "Light",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  "Status",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget trafficLight() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Container(
          color: Colors.black.withOpacity(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              Container(
                  width: 20.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  )),
              Container(
                height: 400.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  width: 120.0,
                                  height: 80.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 1000,
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 4.0),
                                          itemBuilder: (c, i) {
                                            return CircleAvatar(
                                              backgroundColor: Colors.amber,
                                            );
                                          },
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        _time.toString(),
                                        style: TextStyle(
                                            fontFamily: "DsDigital",
                                            fontSize: 80.0),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  color: Colors.black,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 500,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 4.0),
                                    itemBuilder: (c, i) {
                                      return CircleAvatar(
                                        backgroundColor: _onLight == "red"
                                            ? Colors.red.shade800
                                            : Colors.red.withAlpha(100),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  color: Colors.black,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 500,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 4.0),
                                    itemBuilder: (c, i) {
                                      return CircleAvatar(
                                        backgroundColor: _onLight == "yellow"
                                            ? Colors.amber
                                            : Colors.amber.withAlpha(100),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  color: Colors.black,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 500,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 4.0),
                                    itemBuilder: (c, i) {
                                      return CircleAvatar(
                                        backgroundColor: _onLight == "green"
                                            ? Colors.greenAccent.shade700
                                            : Colors.green.withAlpha(100),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget statusTab() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: _onLight == "red"
                        ? Colors.red
                        : _onLight=="green"?Colors.greenAccent.shade700:Colors.amber,
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(leading: CircleAvatar(backgroundColor: Colors.white,child:  Text(_time.toString(),style: TextStyle(color: Colors.black),),),
                  title: Text("Traffic Rating: $priority/4",),
                  subtitle: Text("1st Main Road, J P Nagar"),
//                  trailing: Container(
//                    width: 100.0,
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                  backgroundColor: _onLight == "red"
//                                      ? Colors.red.shade800
//                                      : Colors.red.withAlpha(100),
//                                );
//                              },
//                            ),
//                          ),
//                        ),
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                  backgroundColor: _onLight == "yellow"
//                                      ? Colors.amber
//                                      : Colors.amber.withAlpha(100),
//                                );
//                              },
//                            ),
//                          ),
//                        ),
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                  backgroundColor: _onLight == "green"
//                                      ? Colors.greenAccent.shade700
//                                      : Colors.green.withAlpha(100),
//                                );
//                              },
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(_time.toString()),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Text("Traffic Rating: $priority/4",),
                      ),
                    ],
                  ),
                  subtitle: Text("St 1,Green Park,Delhi"),
                  trailing: Container(
                    width: 100.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            color: Colors.black,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 500,
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 2.0),
                              itemBuilder: (c, i) {
                                return CircleAvatar(
                                  backgroundColor: _onLight == "red"
                                      ? Colors.red.shade800
                                      : Colors.red.withAlpha(100),
                                );
                              },
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            color: Colors.black,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 500,
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 2.0),
                              itemBuilder: (c, i) {
                                return CircleAvatar(
                                  backgroundColor: _onLight == "yellow"
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                );
                              },
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            color: Colors.black,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 500,
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 2.0),
                              itemBuilder: (c, i) {
                                return CircleAvatar(
                                  backgroundColor: _onLight == "green"
                                      ? Colors.greenAccent.shade700
                                      : Colors.green.withAlpha(100),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(leading: CircleAvatar(child:  Text(_time.toString()),backgroundColor:  _onLight == "red"
                    ? Colors.red
                    : _onLight=="green"?Colors.greenAccent.shade700:Colors.amber,),
                  title: Text("Traffic Rating: $priority/4",),
                  subtitle: Text("Main Road, Sehri Nagar"),
//                  trailing: Container(
//                    width: 100.0,
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                    backgroundColor: Colors.red.shade800);
//                              },
//                            ),
//                          ),
//                        ),
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                  backgroundColor: Colors.amber.withAlpha(100),
//                                );
//                              },
//                            ),
//                          ),
//                        ),
//                        ClipRRect(
//                          borderRadius: BorderRadius.circular(50.0),
//                          child: Container(
//                            width: 20.0,
//                            height: 20.0,
//                            color: Colors.black,
//                            child: GridView.builder(
//                              physics: NeverScrollableScrollPhysics(),
//                              shrinkWrap: true,
//                              itemCount: 500,
//                              gridDelegate:
//                                  SliverGridDelegateWithMaxCrossAxisExtent(
//                                      maxCrossAxisExtent: 2.0),
//                              itemBuilder: (c, i) {
//                                return CircleAvatar(
//                                  backgroundColor: Colors.green.withAlpha(100),
//                                );
//                              },
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title:  Text("Traffic Rating: $priority/4",),
                  subtitle: Text("Mahatma Gandhi Road "),
                  trailing:    CircleAvatar(
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            color: Colors.black,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 500,
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 2.0),
                              itemBuilder: (c, i) {
                                return CircleAvatar(
                                  backgroundColor:   _onLight == "red"
                                      ? Colors.red
                                      : _onLight=="green"?Colors.greenAccent.shade700:Colors.amber,
                                );
                              },
                            ),
                          ),
                        ),
                        Center(child: Text(_time.toString()))
                      ],
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_time.toString()),
                  ),
                  subtitle: Text("2nd Cross Road, J P Nagar"),
trailing: Text("Traffic Rating: $priority/4",),
                  title:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              color: Colors.black,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 500,
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 2.0),
                                itemBuilder: (c, i) {
                                  return CircleAvatar(
                                    backgroundColor: _onLight == "red"
                                        ? Colors.red.shade800
                                        : Colors.red.withAlpha(100),
                                  );
                                },
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              color: Colors.black,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 500,
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 2.0),
                                itemBuilder: (c, i) {
                                  return CircleAvatar(
                                    backgroundColor: _onLight == "yellow"
                                        ? Colors.amber
                                        : Colors.amber.withAlpha(100),
                                  );
                                },
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              color: Colors.black,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 500,
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 2.0),
                                itemBuilder: (c, i) {
                                  return CircleAvatar(
                                    backgroundColor: _onLight == "green"
                                        ? Colors.greenAccent.shade700
                                        : Colors.green.withAlpha(100),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
