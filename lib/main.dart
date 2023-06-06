import 'dart:convert';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voxart/components/snackbar.dart';
import 'package:voxart/settings.dart';
import 'package:voxart/theme.dart';
import 'package:voxart/components/card.dart';
import 'package:voxart/components/chip.dart';
import 'package:voxart/utils/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _defaultLightColorScheme = lightColorScheme;

  static const _defaultDarkColorScheme = darkColorScheme;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'VoxArt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const MyHomePage(title: 'VoxArt  🎨'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  final myTextFieldController = TextEditingController();
  final apiManager = ApiManager();
  double _currentSliderValue = 2;
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    myTextFieldController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      myTextFieldController.value =
          myTextFieldController.value.copyWith(text: result.recognizedWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VoxElevatedCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      autofocus: false,
                      controller: myTextFieldController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Speak or type your prompt here!',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Images:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _currentSliderValue,
                              min: 1,
                              max: 4,
                              divisions: 3,
                              label: _currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              myTextFieldController.value.text.isEmpty
                                  ? const VoxSnackBar(
                                      text: 'No prompt! Speak or type here',
                                    ).show(context)
                                  : const VoxSnackBar(
                                      text: 'Processing...',
                                    ).show(context);
                              final body = {
                                'text': myTextFieldController.value.text,
                                'num_images': _currentSliderValue.round()
                              };
                              await apiManager.generate(body: body);
                              setState(() {});
                              ;
                            },
                            child: const Text(
                              'Generate!',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        apiManager.result['prompt'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        scrollDirection: Axis.vertical,
                        itemCount: apiManager.result['generatedImgs'].length,
                        itemBuilder: (context, index) {
                          Uint8List imageBytes = base64.decode(
                              apiManager.result['generatedImgs'][index]);
                          // print('Here with $imageBytes!');
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ),
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Wrap(
          spacing: 8.0,
          children: [
            VoxActionChip(
              icon: const Icon(Icons.settings),
              text: 'Set API',
              child: Settings(),
            ),
            const VoxActionChip(
              icon: Icon(Icons.group_rounded),
              text: 'About',
              child: VoxElevatedCard(
                child: Text('This is an amazing learning project.'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening
              ? Icons.mic_off_rounded
              : Icons.mic_rounded,
        ),
      ),
    );
  }
}
