import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class VoiceTranslationPage extends StatefulWidget {
  const VoiceTranslationPage({Key? key}) : super(key: key);

  @override
  _VoiceTranslationPageState createState() => _VoiceTranslationPageState();
}

class _VoiceTranslationPageState extends State<VoiceTranslationPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _userSpeech = "";
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  // La clé API Gemini n'est PAS codée en dur : elle est injectée au build via
  //   flutter run --dart-define=GEMINI_API_KEY=votre_cle
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  ChatSession? _chat;

  @override
  void initState() {
    super.initState();
    if (_apiKey.isNotEmpty) {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      _chat = model.startChat();
    }
  }

  void _simulateBotResponse(String userMessage) async {
    if (userMessage.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
    });

    if (_chat == null) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "message":
              "Clé API absente. Relancez avec --dart-define=GEMINI_API_KEY=...",
        });
      });
      return;
    }

    try {
      final response = await _chat!.sendMessage(
        Content.text("Traduis ce message et reste concis :\n$userMessage"),
      );
      final botResponse = response.text ?? "(pas de réponse)";
      if (!mounted) return;
      setState(() {
        _messages.add({"sender": "bot", "message": botResponse});
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({"sender": "bot", "message": "Erreur : $e"});
      });
    }
  }

  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() => _userSpeech = result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
    if (_userSpeech.isNotEmpty) {
      _simulateBotResponse(_userSpeech);
      _userSpeech = "";
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _simulateBotResponse(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traduction vocale"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/avatar1.png'), // Remplacez par votre image locale
            ),
            const SizedBox(height: 10),
            const Text(
              "Comment puis-je vous aider ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]["sender"]!,
                      _messages[index]["message"]!);
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Écrivez un message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _userSpeech.isEmpty
                        ? "Appuyez sur le micro pour parler"
                        : _userSpeech,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                  color: Colors.blueAccent,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String sender, String message) {
    bool isUser = sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
