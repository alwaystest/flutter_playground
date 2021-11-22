import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => const MyHomePage(title: 'Welcome aboard'),
        "/weather": (context) => const WeatherPage()
      },
      initialRoute: "/",
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();

  static const key = "key";

  void _handleLaunch(String text) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(key, text);
      _textController.text = text;
      FocusScope.of(context).unfocus();
      _enterLandingPage();
    });
  }

  void _enterLandingPage() {
    Navigator.pushReplacementNamed(context, "/weather");
  }

  void _loadKey() async {
    final prefs = await SharedPreferences.getInstance();
    String savedKey = prefs.getString(key) ?? "";
    if (savedKey.isNotEmpty) {
      _enterLandingPage();
    } else {
      setState(() {
        _textController.text = savedKey;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleLaunch,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(hintText: 'Enter your token'),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleLaunch(_textController.text),
        tooltip: 'Get start',
        child: const Icon(Icons.arrow_forward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
