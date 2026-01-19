import 'dart:async';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    // 1. Listen for links while app is in memory (Warm Start)
    _intentDataStreamSubscription = ReceiveSharingIntentPlus.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
         _handleSharedText(value.first.path); // path contains text/URL for SharedMediaType.text
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // 2. Handle link when app is opened from closed state (Cold Start)
    ReceiveSharingIntentPlus.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        _handleSharedText(value.first.path);
      }
    });
  }

  void _handleSharedText(String text) {
     setState(() {
      _sharedText = text;
    });
    debugPrint("Fluxo Shared Link Received: $text");
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fluxo Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Esperando enlace...'),
            if (_sharedText != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Enlace Recibido:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _sharedText!,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
