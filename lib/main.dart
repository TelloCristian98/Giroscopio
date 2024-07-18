import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gyroscope App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GyroscopePage(),
    );
  }
}

class GyroscopePage extends StatefulWidget {
  @override
  _GyroscopePageState createState() => _GyroscopePageState();
}

class _GyroscopePageState extends State<GyroscopePage> {
  double _gyroscopeX = 0.0;
  double _rotationAngle = 0.0;
  bool _gyroscopeAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkGyroscopeAvailability();
  }

  void _checkGyroscopeAvailability() async {
    try {
      final stream = gyroscopeEvents;
      if (stream != null) {
        stream.listen((GyroscopeEvent event) {
          setState(() {
            _gyroscopeX = event.x;
            _rotationAngle = _gyroscopeX;
            _handleGyroscopeEvent(_gyroscopeX);
          });
        });
      } else {
        setState(() {
          _gyroscopeAvailable = false;
        });
      }
    } catch (e) {
      setState(() {
        _gyroscopeAvailable = false;
      });
    }
  }

  void _handleGyroscopeEvent(double gyroscopeX) {
    if (gyroscopeX > 2) {
      _launchURL('http://your-pc-web-page.com');
    } else if (gyroscopeX < -2) {
      _launchURL('https://docs.google.com/spreadsheets/create');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openWhatsAppWeb() {
    _launchURL('https://web.whatsapp.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gyroscope App'),
      ),
      body: Center(
        child: _gyroscopeAvailable
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: _rotationAngle,
              child: Icon(
                Icons.arrow_upward,
                size: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Gyroscope X: $_gyroscopeX',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openWhatsAppWeb,
              child: Text('Open WhatsApp Web'),
            ),
          ],
        )
            : Text(
          'Gyroscope sensor is not available on this device.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
