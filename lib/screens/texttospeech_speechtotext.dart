import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(SpeechTextApp());
}

class SpeechTextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechToTextScreen(),
    );
  }
}

class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _statusMessage = "Press the mic to start listening";
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech to Text & Text to Speech"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text or use the mic",
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: _textToSpeech,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _textController.clear(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _speechToTextToggle,
              backgroundColor: _isListening ? Colors.lightBlue : Colors.grey,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _textToSpeech() async {
    if (_textController.text.isNotEmpty) {
      await _flutterTts.speak(_textController.text);
    }
  }

  void _speechToTextToggle() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          print("Status: $status");
          if (status == "notListening") {
            setState(() {
              _isListening = false;
              _statusMessage = "Press the mic to start listening";
            });
          }
        },
        onError: (error) {
          print("Error: $error");
          setState(() {
            _statusMessage = "Error: $error";
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _statusMessage = "Listening...";
        });
        _speechToText.listen(onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        });
      } else {
        setState(() {
          _statusMessage = "Speech to text not available";
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _statusMessage = "Processing...";
      });
      _speechToText.stop();
    }
  }
}
