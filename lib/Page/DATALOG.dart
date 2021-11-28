import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DATALOG extends StatefulWidget {
  const DATALOG({Key? key}) : super(key: key);

  @override
  _DATALOGState createState() => _DATALOGState();
}

class _DATALOGState extends State<DATALOG> {
  TooltipBehavior? _tooltipBehavior;
  ZoomPanBehavior? _zoomPanBehavior;

  late List<SalesData> _chartData;
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/datalog-page/bg.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FRP DATALOGGER',
                    style: TextStyle(color: Colors.amber, fontSize: 30),
                  ),
                  Text(
                    '13.71  V',
                    style: TextStyle(color: Colors.amber, fontSize: 30),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 230,
                  width: 200,
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'EN/DIS',
                            style: TextStyle(fontSize: 20),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'FRP',
                            style: TextStyle(fontSize: 20),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'VFRP',
                            style: TextStyle(fontSize: 20),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'SPEED',
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                ),
                Container(
                  height: 240,
                  width: 500,
                  color: Colors.white12,
                  child: SfCartesianChart(
                      plotAreaBorderColor: Colors.green,
                      borderColor: Colors.red,
                      backgroundColor: Colors.blue[200],
                      borderWidth: 1,
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Half yearly sales analysis'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: _tooltipBehavior,
                      zoomPanBehavior: _zoomPanBehavior,
                      series: <LineSeries<SalesData, double>>[
                        LineSeries<SalesData, double>(
                            name: 'Sales',
                            dataSource: _chartData,
                            xValueMapper: (
                              SalesData sales,
                              _,
                            ) =>
                                sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            // Enable data label
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            enableTooltip: true),
                      ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon:
                          Image.asset('assets/images/datalog-page/bt-play.png'),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon:
                          Image.asset('assets/images/datalog-page/bt-stop.png'),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/clear.png'),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'EXIT',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  List<SalesData> getChartData() {
    Random random = new Random();
    double day;
    double sales;
    int i = 0;
    final List<SalesData> chartData = [];
    bool isStopped = false;
    Timer.periodic(new Duration(seconds: 2), (timer) {
      if (i == 50) {
        timer.cancel();
      }
      print('i = ${i}');
      sales = random.nextInt(100).toDouble();
      day = random.nextInt(30).toDouble();
      setState(() {
        chartData.insert(i, SalesData(i.toDouble(), sales));
      });
      i = i + 1;
    });
    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
