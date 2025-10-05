Flutter Stream Chat MVP (Flutter + Stream + Python Token Server)








A minimal, production-leaning starter that uses Stream as the chat UI + backend service, and a tiny Python server to mint user tokens securely.
The Flutter app connects to Stream using a publishable key (client side) while the server holds the secret and generates scoped user tokens on demand.

⚠️ Security: Never commit your Stream secret to the repo. The secret belongs on the server only. The Flutter app should use the public key.

✨ Features

🔌 Stream Chat integrated (channels, message list, composer)

🧪 Minimal ChannelPage with StreamMessageListView + StreamMessageInput

🔐 Token server (Python/Flask) that issues Stream user tokens

🧱 Clean separation: Client (Flutter) vs Server (Python)

🛠️ Works on Android Emulator (10.0.2.2) out of the box

🧭 Architecture (High Level)
Flutter App (StreamChatClient + UI)
        |
        | HTTP (GET /token/:userId)
        v
Tiny Python Server (Flask)
  - loads STREAM_KEY (public) & STREAM_SECRET (private)
  - creates user token via Stream server SDK
        |
        v
Stream (Hosted Chat Backend)

📦 Project Structure
.
├─ lib/
│  ├─ main.dart                      # Stream client init + simple channel UI
│  └─ features/... (your future code)
├─ server/
│  ├─ app.py                         # Flask token endpoint
│  └─ .env                           # STREAM_KEY / STREAM_SECRET (NOT COMMITTED)
├─ README.md
└─ .gitignore

🚀 Quick Start
1) Stream Dashboard

Create a Stream app and get:

Stream Key (public — used in Flutter)

Stream Secret (private — used on the server)

2) Run the Token Server (Python)

Install deps

cd server
python -m venv .venv
# Windows:
.venv\Scripts\activate
pip install flask python-dotenv stream-chat


Create .env (server/.env)

STREAM_KEY=your_stream_public_key_here
STREAM_SECRET=your_stream_secret_here
PORT=5000
HOST=0.0.0.0


server/app.py

from flask import Flask, jsonify
from stream_chat import StreamChat
from dotenv import load_dotenv
import os

load_dotenv()
STREAM_KEY = os.getenv("STREAM_KEY")
STREAM_SECRET = os.getenv("STREAM_SECRET")

app = Flask(__name__)
client = StreamChat(api_key=STREAM_KEY, api_secret=STREAM_SECRET)

@app.get("/token/<user_id>")
def token(user_id):
    token = client.create_token(user_id)  # scoped user token
    return jsonify({"token": token})

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    host = os.getenv("HOST", "0.0.0.0")
    app.run(host=host, port=port, debug=True)


Run

python app.py


Test locally:

curl http://127.0.0.1:5000/token/


On Android Emulator, your PC’s localhost is accessible via http://10.0.2.2:<port>.

3) Run the Flutter App

pubspec.yaml should include:

dependencies:
  flutter:
    sdk: flutter
  stream_chat_flutter: ^6.8.0 # example
  http: ^1.2.0


lib/main.dart (key parts)

Use your Stream Key (public) in StreamChatClient.

Token is fetched from the Python server: http://10.0.2.2:5000/token/<userId>.

Your provided snippet (simplified):

final client = StreamChatClient('YOUR_STREAM_KEY', logLevel: Level.INFO);

Future<String> fetchToken(String userId) async {
  final url = Uri.parse('http://10.0.2.2:5000/token/$userId'); // Emulator loopback
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['token'];
  } else {
    throw Exception('Failed to get token');
  }
}

final userToken = await fetchToken('user_token');
await client.connectUser(
  User(
    id: 'user_id',
    extraData: {'name': 'user_name', 'image': 'https://picsum.photos/200'},
  ),
  userToken,
);

final channel = client.channel('messaging', id: 'flutterdev', extraData: {'name': 'Flutter Dev Chat'});
await channel.watch();


Run:

flutter pub get
flutter run

🔧 Configuration Notes

Emulator networking:

Android Emulator → host machine = 10.0.2.2

iOS Simulator → host machine = http://127.0.0.1 (you may need App Transport Security exceptions)

Production base URL:
Replace 10.0.2.2 with your deployed server URL (HTTPS).

Do not hardcode secrets:
Keep Stream Secret only on the server in .env.

🧹 Environment & Secrets

server/.env (not committed): STREAM_KEY + STREAM_SECRET

Flutter app uses public Stream key only.

Consider adding:

# .gitignore
server/.env
*.env

🧪 Troubleshooting

403/401 from server: Check STREAM_SECRET and that your userId is consistent.

Android can’t reach server: Use http://10.0.2.2:5000 on emulator. Ensure the server is running.

CORS not needed for simple token GET; if you switch to web, configure CORS.

Push protection (GitHub) rejects commits: Ensure you didn’t commit secrets. Rotate keys if you did.

📌 Roadmap / TODO

 Add message reactions, typing indicators, read receipts

 Add authentication flow (sign-in → get token)

 Move base URL to a config layer / .env (Flutter flavors)

 Unit tests for token client + error handling

 CI workflow (format, analyze, build)

📸 Screenshots



📄 License

MIT — feel free to use and adapt.

🙏 Acknowledgements

Stream Chat Flutter SDK

Flutter & Dart teams

Flask & Python ecosystem