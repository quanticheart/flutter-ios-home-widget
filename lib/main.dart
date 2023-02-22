import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String dataKey = 'widgetData';
  final String appGroupId = 'group.com.quanticheart.ioswidgetscreen';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    WidgetKit.reloadAllTimelines();
    WidgetKit.reloadTimelines(dataKey);
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle btnStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      textStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.only(left: 20, right: 20),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Where\'s My Widget?'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                      hintText: 'Enter text to render on Widget'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Fluttertoast.showToast(
                        msg: "Text Updated",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green.shade700,
                        textColor: Colors.white,
                      );

                      WidgetKit.setItem(
                        dataKey,
                        jsonEncode(FlutterWidgetData(textController.text)),
                        appGroupId,
                      );
                      WidgetKit.reloadAllTimelines();
                    },
                    child: const Text('Update'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: () {
                      textController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      Fluttertoast.showToast(
                        msg: "Text Removed",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                      );

                      WidgetKit.removeItem(dataKey, appGroupId);
                      WidgetKit.reloadAllTimelines();
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlutterWidgetData {
  final String text;

  FlutterWidgetData(this.text);

  FlutterWidgetData.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {'text': text};
}
