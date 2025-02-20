# Hue Meeting Light Script

## 📌 Description
This script controls a **Philips Hue light** to indicate whether a virtual meeting is active. If a conference call is detected (e.g., in **Microsoft Teams**), the light turns **red**. When no meeting is active, the light **turns off**.

## 🚀 Features
- **Automatic meeting detection** based on **microphone activity**.
- Reads **microphone status on macOS** using:
  ```sh
  ioreg -c "AppleHDAEngineInput" | grep "IOAudioEngine"
  ```
- Controls a **Philips Hue light** via the Hue Bridge API.
- **Automatic color and brightness adjustment**.
- **Easy setup** with just a few configuration steps.

## 🛠 Setup & Usage

### 1️⃣ Find the Hue Bridge IP Address
1. Open the **Philips Hue app** on your smartphone.
2. Go to **Settings → Hue Bridges** and tap on your bridge.
3. Find the **IP address** under network settings.

### 2️⃣ Generate a Hue API Username
1. Open a web browser and go to:
   `http://<HUE_BRIDGE_IP>/debug/clip.html`
2. In the **URL** field, enter: `/api`
3. In the **Message Body** field, paste the following JSON data:
   ```json
   {"devicetype":"my_hue_app"}
   ```
4. **Press the button** on your Hue Bridge, then click **POST**.
5. Copy the generated **username** and use it in the script.

### 3️⃣ Find the Light ID
1. Open a web browser and go to:
   `http://<HUE_BRIDGE_IP>/api/<USERNAME>/lights`
2. Find the **ID of the light** you want to control.

### 4️⃣ Run the Script
Save the script as `hue-meeting.sh`, make it executable, and run it:
```sh
chmod +x hue-meeting.sh
./hue-meeting.sh
```

---

## 🔄 Auto-start on macOS with launchAgents
To run the script automatically in the background on macOS, follow these steps:

### 1️⃣ Create a LaunchAgent
1. Open a terminal and create the LaunchAgent directory (if it doesn't exist):
   ```sh
   mkdir -p ~/Library/LaunchAgents
   ```
2. Create a new plist file:
   ```sh
   nano ~/Library/LaunchAgents/com.meetinglight.hue.plist
   ```
3. Add the following content to the file:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.meetinglight.hue</string>
       <key>ProgramArguments</key>
       <array>
           <string>/bin/bash</string>
           <string>/path/to/hue-meeting.sh</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
   </dict>
   </plist>
   ```
   *(Replace `/path/to/hue-meeting.sh` with the actual path to your script.)*

### 2️⃣ Load the LaunchAgent
Run the following command to load and start the script automatically:
```sh
launchctl load ~/Library/LaunchAgents/com.meetinglight.hue.plist
```

### 3️⃣ Unload the LaunchAgent (if needed)
If you want to stop the script from running automatically, unload the LaunchAgent:
```sh
launchctl unload ~/Library/LaunchAgents/com.meetinglight.hue.plist
```

---

## 🛠 Requirements
- **macOS / Linux** with Bash
- **Philips Hue Bridge & Lights**
- **Microsoft Teams** or other meeting software using microphone activity
- **macOS microphone access**, detected via:
  ```sh
  ioreg -c "AppleHDAEngineInput" | grep "IOAudioEngine"
  ```

## 🐟 License
This project is licensed under the **MIT License**. Free to use and modify.

---

Now your script will run **automatically in the background** whenever you log in to your macOS system. 🚀 Let me know if you need any modifications!
