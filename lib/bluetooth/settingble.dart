import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_app_com/Page/Home.dart';
import 'package:flutter_app_com/bluetooth/valueProvider.dart';
import 'package:flutter_app_com/bluetooth/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SettingBle());
}

class SettingBle extends StatelessWidget {
  BluetoothCharacteristic? _characteristic;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  final String NAME_DIVCE = "ESP-01";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text('Search Devices'),
        leading: FlatButton(
          onPressed: () {
            if (_characteristicTX != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            characteristicRX: _characteristicRX,
                            characteristicTX: _characteristicTX,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            characteristicRX: null,
                            characteristicTX: null,
                          )));
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                      child: Text('OPEN'),
                                      onPressed: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeviceScreen(
                                                            device: d))),
                                          });
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),

              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!.map((r) {
                    // if (r.device.name
                    //     .toLowerCase()
                    //     .contains(NAME_DIVCE.toLowerCase())) {
                    return ScanResultTile(
                        result: r,
                        onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              r.device.connect();
                              return DeviceScreen(device: r.device);
                            })));
                    // } else {
                    //   return SizedBox();
                    // }
                  }).toList(),
                ),
              ),
              // StreamBuilder<List<ScanResult>>(
              //   stream: FlutterBlue.instance.scanResults,
              //   initialData: [],
              //   builder: (c, snapshot) => Column(
              //     children: snapshot.data!
              //         .map(
              //           (r) => ScanResultTile(
              //             result: r,
              //             onTap: () => Navigator.of(context)
              //                 .push(MaterialPageRoute(builder: (context) {
              //               r.device.connect();
              //               return DeviceScreen(device: r.device);
              //             })),
              //           ),
              //         )
              //         .toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ),

      //   /////////// find name device bluetooth
      // if(result.device.name == "ESP-01"){
      //   print('name ESP-32 successfuly');
      // }
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.search,
              ),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              ),

              // onPressed: finddveicename,
            );
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

BluetoothCharacteristic? _characteristicTX;
BluetoothCharacteristic? _characteristicRX;
// late BluetoothService _bleService;
BluetoothService? _bleService;

class _DeviceScreenState extends State<DeviceScreen> {
  // List<Widget> _buildServiceTiles(List<BluetoothService> services) {
  List<int>? _valueNotify;
  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  checkConnectDevice() async {
    var connectDevices = await FlutterBlue.instance.connectedDevices;
    for (var device in connectDevices) {
      print(device.name);
      device.disconnect();
    }
  }

  final String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  final String CHARACTERISTIC_UUID_RX = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  final String CHARACTERISTIC_UUID_TX = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";

  void _handleBleValue() async {
    // int index = context.watch<valueProvider>().count;
    if (_bleService == null) return;
    var charateristics = _bleService!.characteristics;
    charateristics.forEach((charateristic) {
      if (charateristic.uuid.toString().toLowerCase() ==
          CHARACTERISTIC_UUID_TX.toString().toLowerCase()) {
        _characteristicTX = charateristic;
      }
      if (charateristic.uuid.toString().toLowerCase() ==
          CHARACTERISTIC_UUID_RX.toString().toLowerCase()) {
        _characteristicRX = charateristic;
      }
    });

    if (_characteristicTX != null) {
      _characteristicTX!.setNotifyValue(true);

      _characteristicTX!.value.listen((value) async {
        print(_dataParser(value));
        final command = _dataParser(value).toString();
        if (command.contains('bat=')) {
          final start = 'bat=';
          final end = '#';
          final startIndex = command.indexOf(start);
          final endIndex = command.indexOf(end);
          final result =
              command.substring(startIndex + start.length, endIndex).trim();
          // value_bat.bat = double.parse(result);
          context.read<valueProvider>().battery = double.parse(result);

          // print('############ Provider Bat   = ${value_bat.bat}');
          print('########## bat = ${result}');
        } else if (command.contains('frp1=')) {
          final start = 'frp1=';
          final end = '#';

          final startIndex = command.indexOf(start);
          final endIndex = command.indexOf(end);
          final result =
              command.substring(startIndex + start.length, endIndex).trim();
          context.read<valueProvider>().frp = double.parse(result);

          print('########## frp = ${result}');
        } else if (command.contains('vfrp_=')) {
          final start = 'vfrp_=';
          final end = '#';

          final startIndex = command.indexOf(start);
          final endIndex = command.indexOf(end);
          final result =
              command.substring(startIndex + start.length, endIndex).trim();
          context.read<valueProvider>().vfrp = double.parse(result);

          print('########## vfrp_= = ${result}');
        }
      });
    }
  }

  // void getStatusBle() async {
  //   if (_characteristicTX != null &&
  //       _characteristicTX!.uuid.toString().toLowerCase() ==
  //           CHARACTERISTIC_UUID_TX.toLowerCase()) {
  //     // sendData('NID=${genuidble}#');
  //     // if (_characteristicTX != null) {
  //     //   _characteristicRX!.write(utf8.encode('REQ#'));
  //     // }
  //   } else {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => Home(
  //                   characteristic: null,
  //                 )));
  //   }
  // }

  Future connect() async {
    await checkConnectDevice();
    await widget.device.connect();
    // await widget.device.discoverServices();

    // List<BluetoothService> services = await widget.device.discoverServices();
    widget.device.discoverServices().then((services) => {
          services.forEach((service) {
            print("server uuid ===>" + service.uuid.toString());
            if (service.uuid.toString().toLowerCase() ==
                SERVICE_UUID.toLowerCase()) {
              print("service ====>" + services.toString());
              _bleService = service;
              _handleBleValue();
              // widget.device.state.listen((event) {
              //   if (_characteristicTX != null &&
              //       _characteristicTX!.uuid.toString().toLowerCase() ==
              //           CHARACTERISTIC_UUID_TX.toLowerCase()) {
              //     if (event == BluetoothDeviceState.connected) {
              //       print(
              //           'Device State -------> BluetoothDeviceState.connected');
              //       // getStatusBle();
              //       // Future.delayed(const Duration(seconds: 4), () {
              //       //   if (event != BluetoothDeviceState.disconnected) {
              //       //     Navigator.push(
              //       //         context,
              //       //         MaterialPageRoute(
              //       //             builder: (context) =>
              //       //                 Home(characteristic: _characteristicRX)));
              //       //   }
              //       // });
              //       // sendData('REQ#');
              //     }
              //   }
              // });

            }
          })
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text(widget.device.name),
        leading: FlatButton(
            onPressed: () {
              if (_characteristicRX != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              characteristicRX: _characteristicRX,
                              characteristicTX: _characteristicTX,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              characteristicRX: null,
                              characteristicTX: null,
                            )));
              }
            },
            //   getStatusBle();

            // },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () async {
                    await widget.device.disconnect();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingBle()));
                  };
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () async {
                    await checkConnectDevice();
                    await widget.device.connect();
                    await widget.device.discoverServices();
                  };
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              StreamBuilder<BluetoothDeviceState>(
                stream: widget.device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) => ListTile(
                  leading: (snapshot.data == BluetoothDeviceState.connected)
                      ? Icon(Icons.bluetooth_connected)
                      : Icon(Icons.bluetooth_disabled),
                  title: Text(
                      'Device is ${snapshot.data.toString().split('.')[1]}.'),
                  subtitle: Text('${widget.device.id}'),
                  trailing: StreamBuilder<bool>(
                    stream: widget.device.isDiscoveringServices,
                    initialData: false,
                    builder: (c, snapshot) => IndexedStack(
                      index: snapshot.data! ? 1 : 0,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => {
                                  widget.device.discoverServices(),
                                  // connect(),
                                }),
                        IconButton(
                          icon: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.grey),
                            ),
                            width: 18.0,
                            height: 18.0,
                          ),
                          onPressed: null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // StreamBuilder<int>(
              //   stream: widget.device.mtu,
              //   initialData: 0,
              //   builder: (c, snapshot) => ListTile(
              //     title: Text('MTU Size'),
              //     subtitle: Text('${snapshot.data} bytes'),
              //     trailing: IconButton(
              //       icon: Icon(Icons.edit),
              //       onPressed: () => widget.device.requestMtu(223),
              //     ),
              //   ),
              // ),
              FlatButton(
                  onPressed: () {
                    //  _characteristicTX!.write(utf8.encode('Test'));

                    if (_characteristicTX != null) {
                      // print('_characteristicTX -------> null');
                      // _characteristicTX!.write(utf8.encode('Test'));
                      sendData('Test sendData');
                    } else {
                      print('_characteristicTX -------> null');
                    }
                    // print('Test');
                  },
                  child: Text('sendData')),
            ],
          ),
        ),
      ),
    );
  }

  void sendData(String value) async {
    if (_characteristicRX!.uuid != null &&
        _characteristicRX!.uuid.toString().toLowerCase() ==
            CHARACTERISTIC_UUID_RX.toLowerCase()) {
      print('_characteristicRX --------- > ${_characteristicRX!.uuid}');

      _characteristicRX!.write(utf8.encode(value));
    }
  }
}
