import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:location/location.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/html.dart';




class MyHomePage extends StatefulWidget {
  final String title;
  final HtmlWebSocketChannel channel;

  const MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final Location location = Location();

  LocationData locationData;
  String _error;
  String jsonString;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
            children: [
              
               qrcodeBuilderSection()
            ],
          ),
    );
  }


  Widget qrcodeBuilderSection(){
    return Container(
     padding: const EdgeInsets.all(32),
     child: Row(
       children: [
         Expanded(
           child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot){
                  return snapshot.hasData
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        // child: Text(snapshot.hasData ? '${snapshot.data}' : 'no data'),
                        child: QrImage(
                          data: '${snapshot.data}',
                          version: QrVersions.auto,
                          embeddedImage: AssetImage('images/checks.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(30, 30),
                          ),
                          size: 300.0,
                        ),
                      )
                    : CircularProgressIndicator();
                }
             )
           ],
           )
          )
       ],
     ),
  );
  }
    


  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();

      setState(() {
        locationData = _locationResult;
      });

      if (locationData != null) {
        widget.channel.sink.add(locationData);

        print('from get locationFunction: $locationData');
      }
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
