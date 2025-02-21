# Teams Hue Status

## 📌 Description
This script controls a **Philips Hue light** to indicate whether a **Microsoft Teams meeting** is active. It monitors the **CPU usage** of the Teams process to determine meeting activity:
- If **CPU usage is high** (indicating an active meeting), the **Hue light turns red**.
- If **CPU usage is low** (indicating no meeting), the **Hue light turns off**.

## 🚀 Features
- **Detects active Microsoft Teams meetings** based on CPU usage.
- **Automatically controls a Philips Hue light** via the Hue API.
- **Runs in the background** and continuously monitors Teams activity.
- **Optimized polling** to minimize system impact.

---

## 🛠 Setup & Usage

### 1️⃣ Configure the Hue Bridge
Before running the script, you need to configure your **Hue Bridge**.

1. **Find the Hue Bridge IP Address**
   - Open the **Philips Hue app** on your smartphone.
   - Go to **Settings → Hue Bridges** and note the **IP address**.

2. **Generate a Hue API Username**
   - Open a web browser and go to:
     `http://<HUE_BRIDGE_IP>/debug/clip.html`
   - In the **URL** field, enter: `/api`
   - In the **Message Body** field, paste:
     ```json
     {"devicetype":"my_hue_app"}
     ```
   - **Press the button** on your Hue Bridge, then click **POST**.
   - Copy the generated **username** and use it in the script.

3. **Find the Light ID**
   - Open a web browser and go to:
     `http://<HUE_BRIDGE_IP>/api/<USERNAME>/lights`
   - Identify the **ID** of the light you want to control.

---

### 2️⃣ Edit the Script
Open `teams_hue.sh` and update the following variables:

```sh
HUE_BRIDGE_IP="YOUR_HUE_BRIDGE_IP"
USERNAME="YOUR_HUE_USERNAME"
LIGHT_ID="YOUR_LIGHT_ID"
```

---

### 3️⃣ Run the Script
Make the script executable and start it:

```sh
chmod +x teams_hue.sh
./teams_hue.sh
```

To run the script **in the background**, use:

```sh
nohup ./teams_hue.sh > /dev/null 2>&1 &
```

---

## 🔄 Auto-start on macOS
To run the script **automatically at startup**, you can use a macOS LaunchAgent.

### 1️⃣ Create a LaunchAgent
1. Open a terminal and create the LaunchAgents directory:
   ```sh
   mkdir -p ~/Library/LaunchAgents
   ```
2. Create a new plist file:
   ```sh
   nano ~/Library/LaunchAgents/com.teams.hue.plist
   ```
3. Add the following content (replace `PATH_TO_SCRIPT`):
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.teams.hue</string>
       <key>ProgramArguments</key>
       <array>
           <string>/bin/bash</string>
           <string>PATH_TO_SCRIPT/teams_hue.sh</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
   </dict>
   </plist>
   ```
4. Save the file and load the LaunchAgent:
   ```sh
   launchctl load ~/Library/LaunchAgents/com.teams.hue.plist
   ```

---

## 🛠 Requirements
- **macOS**
- **Philips Hue Bridge & Light**
- **Microsoft Teams** installed
- **Bash & curl** (pre-installed on macOS)

## 🐟 License
This project is licensed under the **MIT License**.

---

This script ensures that your Hue light reflects your Teams meeting status **automatically**. 🚀 Let me know if you need any modifications!
