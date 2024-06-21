import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


void main() {
  runApp(const MainApp());
}
enum CustomStatus { sent, delivered, read }

extension CustomStatusExtension on CustomStatus {
  types.Status toTypesStatus() {
    switch (this) {
      case CustomStatus.sent:
        return types.Status.sent;
      case CustomStatus.delivered:
        return types.Status.delivered;
      case CustomStatus.read:
        return types.Status.sent; // Use 'sent' as a placeholder
      default:
        return types.Status.sent;
    }
  }

  String get name {
    switch (this) {
      case CustomStatus.sent:
        return "Sent";
      case CustomStatus.delivered:
        return "Delivered";
      case CustomStatus.read:
        return "Read";
      default:
        return "Sent";
    }
  }
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(
        consultantName: 'Consultant Name',
        consultantImage: 'assets/consultant_image.png',
        consultantPhoneNumber: '1234567890',
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String consultantName;
  final String consultantImage;
  final String consultantPhoneNumber;

  ChatPage({
    required this.consultantName,
    required this.consultantImage,
    required this.consultantPhoneNumber,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = types.User(id: 'user-id');
  final _otherUser = types.User(id: 'other-user-id');
  final _textController = TextEditingController();
  bool _isConnected = true;
  final ImagePicker _picker = ImagePicker();
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _voiceInputText = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  void _onSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: message.text,
      status: CustomStatus.sent.toTypesStatus(),
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    // Simulate message delivery after a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        final index = _messages.indexWhere((msg) => msg.id == textMessage.id);
        if (index != -1) {
          _messages[index] = (textMessage as types.TextMessage).copyWith(
            status: CustomStatus.delivered.toTypesStatus(),
          );
        }
      });
    });

    // Simulate message read after another delay
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        final index = _messages.indexWhere((msg) => msg.id == textMessage.id);
        if (index != -1) {
          _messages[index] = (textMessage as types.TextMessage).copyWith(
            status: CustomStatus.sent.toTypesStatus(), // Using 'sent' as placeholder
          );
        }
      });
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageMessage = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: Uuid().v4(),
        name: image.name,
        size: await image.length(),
        uri: image.path,
      );

      setState(() {
        _messages.insert(0, imageMessage);
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (val) => setState(() {
          _voiceInputText = val.recognizedWords;
        }));
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
      if (_voiceInputText.isNotEmpty) {
        _onSendPressed(types.PartialText(text: _voiceInputText));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.consultantImage),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.consultantName,
                  style: TextStyle(color: Colors.amber),
                ),
                Row(
                  children: [
                    _isConnected
                        ? Icon(Icons.circle, color: Colors.green, size: 12)
                        : Icon(Icons.circle, color: Colors.red, size: 12),
                    SizedBox(width: 5),
                    Text(
                      _isConnected ? "Connected" : "Offline",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              launch("tel:${widget.consultantPhoneNumber}");
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _onSendPressed,
        user: _user,
        customBottomWidget: _buildCustomInput(),
        customMessageBuilder: _buildMessage, // Use custom message builder
      ),
    );
  }

  Widget _buildCustomInput() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color: Colors.blueGrey, // Change this color to the desired background color
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image, color: Colors.cyan),
              onPressed: _pickImage,
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.cyan),
              onPressed: _listen,
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _onSendPressed(types.PartialText(text: value));
                    _textController.clear();
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.cyan),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _onSendPressed(types.PartialText(text: _textController.text));
                  _textController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(types.Message message, {required int messageWidth}) {
    if (message is types.TextMessage) {
      return Row(
        mainAxisAlignment: message.author.id == _user.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            constraints: BoxConstraints(maxWidth: messageWidth.toDouble()),
            decoration: BoxDecoration(
              color: message.author.id == _user.id ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: Colors.white),
                ),
                if (message.status != null) // Check if status is not null
                  Row(
                    children: [
                      if (message.status == types.Status.sent)
                        Icon(Icons.check, color: Colors.white, size: 12),
                      if (message.status == types.Status.delivered)
                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            Icon(Icons.check, color: Colors.white, size: 12),
                          ],
                        ),
                      if (message.status == CustomStatus.sent.toTypesStatus())
                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            Icon(Icons.check, color: Colors.green, size: 12),
                          ],
                        ),
                      SizedBox(width: 5),
                      Text(
                        message.status == types.Status.sent
                            ? CustomStatus.sent.name
                            : message.status == types.Status.delivered
                            ? CustomStatus.delivered.name
                            : CustomStatus.read.name,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (message is types.ImageMessage) {
      return Row(
        mainAxisAlignment: message.author.id == _user.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            constraints: BoxConstraints(maxWidth: messageWidth.toDouble()),
            decoration: BoxDecoration(
              color: message.author.id == _user.id ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  message.uri,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                if (message.status != null) // Check if status is not null
                  Row(
                    children: [
                      if (message.status == types.Status.sent)
                        Icon(Icons.check, color: Colors.white, size: 12),
                      if (message.status == types.Status.delivered)
                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            Icon(Icons.check, color: Colors.white, size: 12),
                          ],
                        ),
                      if (message.status == CustomStatus.sent.toTypesStatus())
                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            Icon(Icons.check, color: Colors.green, size: 12),
                          ],
                        ),
                      SizedBox(width: 5),
                      Text(
                        message.status == types.Status.sent
                            ? CustomStatus.sent.name
                            : message.status == types.Status.delivered
                            ? CustomStatus.delivered.name
                            : CustomStatus.read.name,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    }
    // Handle other message types if needed
    return Container();
  }

}