# 📨 **Flutter Stream Chat MVP**
### *(Flutter + Stream + Python Token Server)*

---

A **minimal, production-leaning starter** that uses [**Stream**](https://getstream.io/) as both the **chat UI** and **backend service**,  
with a **tiny Python (Flask) server** to mint user tokens securely.

The Flutter app connects to Stream using a **publishable key** (client side),  
while the **server holds the secret** and generates scoped user tokens on demand.

> ⚠️ **Security:** Never commit your Stream **secret** to the repo.  
> Keep it only on the server — the Flutter app uses the **public key**.

---

## ✨ **Features**
- 🔌 **Stream Chat integrated** — channels, message list, composer  
- 🧪 Minimal **ChannelPage** with `StreamMessageListView` + `StreamMessageInput`  
- 🔐 **Python Token Server (Flask)** issuing Stream user tokens  
- 🧱 Clean separation between **Client (Flutter)** and **Server (Python)**  
- 🛠️ Works seamlessly on **Android Emulator** (`10.0.2.2`)

---


📸 Screenshots

<img width="445" height="933" alt="Screenshot 2025-10-05 042726" src="https://github.com/user-attachments/assets/9e74786d-f67c-4123-aae4-f7a05f4c1a19" />

---

## 🧭 **Architecture Overview**
```text
Flutter App (StreamChatClient + UI)
        |
        |  HTTP (GET /token/:userId)
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
│  └─ features/...                   # your future modules
├─ server/
│  ├─ app.py                         # Flask token endpoint
│  └─ .env                           # STREAM_KEY / STREAM_SECRET (NOT COMMITTED)
├─ README.md
└─ .gitignore

🚀 Quick Start

🧩 1. Stream Dashboard

Create a Stream app

Get your Stream Key (public) and Stream Secret (private)

🧩 2. Run the Token Server (Python)
Install dependencies

cd server
python -m venv .venv
# Windows:
.venv\Scripts\activate
pip install flask python-dotenv stream-chat

Create .env

STREAM_KEY=your_stream_public_key_here
STREAM_SECRET=your_stream_secret_here
PORT=5000
HOST=0.0.0.0

app.py

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
    token = client.create_token(user_id)
    return jsonify({"token": token})

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    host = os.getenv("HOST", "0.0.0.0")
    app.run(host=host, port=port, debug=True)

Run

python app.py


Test locally
curl http://127.0.0.1:5000/token/

🧩 3. Run the Flutter App
pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  stream_chat_flutter: ^6.8.0
  http: ^1.2.0


Run the app

flutter pub get
flutter run


🔧 Configuration Notes

🖥️ Emulator Networking

Android → 10.0.2.2

iOS → 127.0.0.1

🌐 Production URL: Replace emulator host with deployed HTTPS URL

🔐 Secrets: Keep STREAM_SECRET only in server .env

🧹 Environment & Secrets

server/.env → contains your STREAM_KEY & STREAM_SECRET

Flutter app → uses only the public key


📄 License

MIT License — feel free to use and adapt.


🙏 Acknowledgements

Stream Chat Flutter SDK

Flutter
 & Dart teams

Flask
 & Python ecosystem
