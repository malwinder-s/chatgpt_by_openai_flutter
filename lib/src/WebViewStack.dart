import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, Key? key})
      : super(key: key); // Modify

  final Completer<WebViewController> controller; // Add this attribute

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: 'https://chat.openai.com/chat',
          onWebViewCreated: (webViewController) {
            setState(() {
              widget.controller.complete(webViewController);
            });
          },
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) async {
            setState(() async {
              loadingPercentage = 100;
            });
          },
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          zoomEnabled: false,
          gestureRecognizers: Set()
            ..add(
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                    ..onDown = (DragDownDetails dragDownDetails) {
                      widget.controller.getScrollY().then((value) {
                        if (value == 0 &&
                            dragDownDetails.globalPosition.direction < 1) {
                          widget.controller.reload();
                        }
                      });
                    }),
            ),
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
