import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient(
    'pctgp6c988wr',
    logLevel: Level.INFO,
  );

  Future<String> fetchToken(String userId) async {
    final url = Uri.parse('http://10.0.2.2:5000/token/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to get token');
    }
  }

  final userToken = await fetchToken('mostafa');

  await client.connectUser(
    User(
      id: 'mostafa',
      extraData: {
        'name': 'Mostafa',
        'image': 'https://picsum.photos/200',
      },
    ),
    userToken,
  );

  final channel = client.channel(
    'messaging',
    id: 'flutterdev',
    extraData: {'name': 'Flutter Dev Chat'},
  );
  await channel.watch();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    home: StreamChat(
      client: client,
      child: StreamChannel(
        channel: channel,
        child:  ChannelPage(),
      ),
    ),
  ));
}


class MyApp extends StatelessWidget {
  final StreamChatClient client;
  final Channel channel;

  const MyApp({super.key, required this.client, required this.channel});

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: StreamChannel(
          channel: channel,
          child:  ChannelPage(),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  ChannelPage({super.key}); // شيل const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: [
          Expanded(child: StreamMessageListView()),
          StreamMessageInput(),
        ],
      ),
    );
  }
}

