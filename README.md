# 🎣 Fischnished - Ultimate Fisch Cheat

A powerful, modular cheat for the Roblox game **Fisch** featuring auto farming, movement hacks, ESP, teleports, and much more.

## ✨ Features

### 🎯 **Auto Farm**
- **Auto Fishing**: Automated fishing with human-like behavior
- **Stealth Mode**: Advanced anti-detection measures
- **Shake Multiplier**: Configurable shake automation
- **Random Failures**: Intentional failures to appear human
- **Auto Sell**: Automatic item selling

### 🏃 **Movement**
- **Speed Hack**: Customizable walk speed
- **Fly Hack**: Full 6-directional flight
- **No Clip**: Walk through walls
- **Anti Void**: Prevents falling into the void

### 👁️ **ESP (Wallhacks)**
- **Player ESP**: See other players through walls
- **NPC ESP**: Highlight NPCs and merchants
- **Treasure ESP**: Find treasure chests with distance indicators

### 🗺️ **Teleports**
- **Zone Teleports**: Quick travel to all game zones
- **Fishing Zones**: Auto-detected fishing areas
- **Player Zones**: Auto-detected player areas
- **Treasure Teleports**: Find and collect treasures

### 📦 **Crates**
- **Auto Buy**: Automated crate purchasing
- **Bulk Purchase**: Buy multiple crates at once
- **All Types**: Purchase one of each crate type

### 🎁 **Creator Codes**
- **Auto Claim**: Automatically claim all creator codes
- **Bulk Claim**: Claim multiple codes at once
- **Code Management**: View and manage available codes

### 🫧 **Unlimited Oxygen**
- **Oxygen Bypass**: Never run out of oxygen underwater
- **UI Hiding**: Hides oxygen-related UI elements
- **Anti-Drown**: Prevents drowning events

## 🚀 Installation

### Method 1: Direct Loadstring (Recommended)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/pwd0kernel/Fischnished/main/init.lua"))()
```

### Method 2: Manual Installation
1. Download all files from this repository
2. Place them in your executor's workspace
3. Execute the `init.lua` file

## 📁 Project Structure

```
fischnished-cheat/
├── init.lua                    # Main loader file
├── src/
│   ├── core/
│   │   └── services.lua        # Core services and state management
│   ├── ui/
│   │   └── rayfield.lua        # Rayfield UI implementation
│   ├── features/
│   │   ├── autofarm.lua        # Auto farming functionality
│   │   ├── movement.lua        # Movement hacks
│   │   ├── esp.lua             # ESP/wallhacks
│   │   ├── teleports.lua       # Teleportation features
│   │   ├── crates.lua          # Crate management
│   │   ├── codes.lua           # Creator codes
│   │   └── oxygen.lua          # Unlimited oxygen
│   ├── utils/
│   │   └── helpers.lua         # Utility functions
│   └── data/
│       └── zones.lua           # Zone data and management
└── README.md
```

## 🔑 License Keys

The cheat uses a key system for premium features. Valid keys include:
- `FSH-7K9M-X3QR-BVNP-2L8D-YE4C`
- `FSH-9P6W-M2ZX-QRTN-5K8J-VL3F`
- `FSH-4N7B-R8QM-XZPW-3L9K-YE6D`
- And more... (see full list in the script)

## 🎮 Usage

1. Execute the loadstring in your favorite Roblox executor
2. Enter a valid license key when prompted
3. The Rayfield UI will appear with all features organized in tabs
4. Configure your desired settings and enable features

### 🎯 Auto Farm Usage
1. Go to the **Hacks** tab
2. Enable **Auto Farm**
3. Adjust **Shake Multiplier** for effectiveness
4. Enable **Stealth Mode** for anti-detection
5. Optionally enable **Auto Sell** for hands-free operation

### 🏃 Movement Usage
1. Go to the **Movement** tab
2. Enable desired movement hacks
3. Adjust speed/fly speed as needed
4. Use WASD + Space/Ctrl for flying

### 👁️ ESP Usage
1. Go to the **Visuals** tab
2. Enable desired ESP types
3. ESP will automatically highlight objects

## ⚙️ Configuration

The cheat is highly configurable with options for:
- **Human-like Delays**: Configurable timing to avoid detection
- **Random Failures**: Intentional failures for realism
- **Stealth Mode**: Advanced anti-detection measures
- **Custom Speeds**: Adjustable movement speeds
- **UI Themes**: Rayfield UI customization

## 🛠️ Development

### Adding New Features
1. Create a new module in the appropriate `src/` directory
2. Follow the existing module structure
3. Add the module to the `CONFIG.FILES` list in `init.lua`
4. Export your module functions for use by the UI

### Module Structure
```lua
local ModuleName = {}
local Services = _G.Fischnished.core.services

function ModuleName.createUI()
    -- Create UI elements
end

function ModuleName.toggle(enabled)
    -- Handle feature toggle
end

return ModuleName
```

## 🔒 Security Features

- **Modular Design**: Each feature is isolated for better security
- **Safe Execution**: All dangerous operations wrapped in pcall
- **Anti-Detection**: Stealth mode with randomization
- **Name Spoofing**: Player name spoofing for oxygen bypass
- **Remote Spoofing**: Modified remote calls to avoid detection

## 📞 Support

- **Discord**: [discord.gg/Tesm6dDcDC](https://discord.gg/Tesm6dDcDC)
- **Issues**: Open an issue on GitHub
- **Updates**: Check the repository for latest versions

## ⚠️ Disclaimer

This cheat is for **educational purposes only**. Use at your own risk. The developers are not responsible for any consequences, including but not limited to:
- Account bans or suspensions
- Data loss
- Game crashes
- Other adverse effects

## 🏆 Credits

- **Developer**: Buffer_0verflow
- **UI Library**: Rayfield by Sirius

## 📄 License

---

**⭐ If you found this helpful, please give the repository a star!**
