import 'package:flutter/material.dart';
import 'package:checksweb/home_page.dart';
import 'package:web_socket_channel/html.dart';



void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}



class MyApp extends StatelessWidget {
  final title = 'checks';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        channel: HtmlWebSocketChannel.connect('ws://localhost:8080/ws-web'),
      ),
    );
  }
}