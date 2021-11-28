// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_com/Page/DATALOG.dart';
import 'package:flutter_app_com/Page/Setting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  int speed = 0;
  int frp = 0;
  int vfrp = 0;

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var random = new Random();
    // Timer.periodic(new Duration(seconds: 8), (timer) {
    //   setState(() {
    //     speed = random.nextInt(150) + 1;
    //     frp = random.nextInt(250) + 1;
    //     vfrp = random.nextInt(250) + 1;
    //   });
    // });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: Row(
          children: [
            Container(
              width: size / 2,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Container(
                        height: 300,
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                              minimum: 0,
                              maximum: 200,
                              ranges: [
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 50,
                                  color: Colors.orange[200],
                                ),
                                GaugeRange(
                                  startValue: 50,
                                  endValue: 100,
                                  color: Colors.orange[400],
                                ),
                                GaugeRange(
                                  startValue: 100,
                                  endValue: 150,
                                  color: Colors.orange[600],
                                ),
                                GaugeRange(
                                    startValue: 150,
                                    endValue: 200,
                                    color: Colors.red),
                              ],
                              pointers: [
                                NeedlePointer(
                                    value: speed.toDouble(),
                                    enableAnimation: true,
                                    needleColor: Colors.pink),
                              ],
                              annotations: [
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text('${speed}',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orangeAccent,
                                            ))),
                                    angle: 90,
                                    positionFactor: 0.5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/clear.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: size / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: Image.asset('assets/images/ble-logo.png'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingPage()));
                        },
                      )
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              // ignore: prefer_const_literals_to_create_immutables
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'BATTERY',
                                style: GoogleFonts.sriracha(
                                    color: Colors.orangeAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '   15   ',
                                style: GoogleFonts.sriracha(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'V',
                                style: GoogleFonts.sriracha(
                                    color: Colors.orangeAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'PEAK FRP',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: '   ${frp}   ',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'mp',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'PEAK VFRP',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: '   ${vfrp}   ',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'V',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'TOP SPEED ',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: '   198   ',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'km/h',
                                  style: GoogleFonts.sriracha(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print('DATALOG');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DATALOG()));
                    },
                    child: Text(
                      'DATALOG',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MODE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.orangeAccent),
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/batt.png'),
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage()));
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/frp.png'),
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage()));
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/vfrp.png'),
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage()));
                            },
                          ),
                          IconButton(
                            icon:
                                Image.asset('assets/images/setting-logo3.png'),
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
