import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_sample/secret_keys.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatGPT Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter ChatGPT Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _answer = '';
  var _isLoading = false;

  final _textEditingController =
      TextEditingController(text: 'What is Flutter?');

  final openAI = OpenAI.instance.build(
    token: openApiKey,
    baseOption: HttpSetup(receiveTimeout: 60 * 1000),
    isLogger: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final answer = await _sendMessage(
                      _textEditingController.text,
                    );
                    setState(() {
                      _answer = answer;
                      _isLoading = false;
                    });
                    ;
                  },
                  icon: Icon(
                    _isLoading ? Icons.timer : Icons.send,
                  ),
                ),
              ],
            ),
            Text(_answer),
          ],
        ),
      ),
    );
  }

  Future<String> _sendMessage(String message) async {
    final request = CompleteText(
      prompt: message,
      model: kTranslateModelV3,
      maxTokens: 200,
    );

    final response = await openAI.onCompleteText(
      request: request,
    );
    return response!.choices.first.text;
  }
}
