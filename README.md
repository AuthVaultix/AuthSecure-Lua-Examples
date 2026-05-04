# AuthVaultix Lua - Multi-Platform Integration

![AuthVaultix](https://img.shields.io/badge/AuthVaultix-Lua-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Windows%20|%20FiveM%20|%20Roblox-orange?style=for-the-badge)

A powerful and lightweight Lua wrapper for [AuthVaultix](https://authvaultix.com), providing secure authentication and licensing for your Lua-based projects. 

## ?? Features

- **Multi-Platform Support:** Ready-to-use scripts for Windows (Standalone), FiveM, and Roblox.
- **HWID Protection:** Built-in hardware ID locking to prevent account sharing.
- **Session Management:** Secure initialization and session tracking.
- **Easy Integration:** Simple functions for Login, Registration, and License Key activation.
- **No Dependencies (Windows):** Uses PowerShell for HTTPS requests, so you don't need `LuaSec` or `Socket`.

---

## ?? Getting Started

### 1. Configuration
Open the corresponding Lua file for your platform and set up your application credentials:

```lua
local name = "YourAppName"
local ownerid = "YourOwnerID"
local secret = "YourAppSecret"
local version = "1.0"

AuthVaultix.Api(name, ownerid, secret, version)
```

### 2. Initialization
Every session must be initialized before performing any actions:

```lua
AuthVaultix.Init()
```

---

## ?? Platform Usage

### ?? Windows (Standalone)
Requires `dkjson.lua` in the same directory (you can download it from [GitHub](https://github.com/BertrandMansiet/dkjson)). It uses PowerShell to handle HTTPS requests natively.

```lua
local AuthVaultix = require("authvaultix_windows")
AuthVaultix.Api(...)
AuthVaultix.Init()

-- Example Login
AuthVaultix.Login("username", "password")
```

### ?? FiveM (Server-side)
Uses `PerformHttpRequest` for seamless integration into your GTA V resources.

```lua
local AuthVaultix = require("authvaultix_fivem")
AuthVaultix.Api(...)
AuthVaultix.Init()

-- Example Login (Server-side)
AuthVaultix.Login(source, "username", "password")
```

### ?? Roblox (Script)
Uses `HttpService` for game scripts.

```lua
local AuthVaultix = require("authvaultix_roblox")
AuthVaultix.Api(...)
AuthVaultix.Init()

-- Example Login
AuthVaultix.Login("username", "password")
```

---

## ?? API Reference

| Function | Description |
| :--- | :--- |
| `Api(name, ownerid, secret, version)` | Configures the application credentials. |
| `Init()` | Starts the session and connects to the server. |
| `Login(user, pass)` | Authenticates a user with username and password. |
| `Register(user, pass, key)` | Registers a new user using a license key. |
| `License(key)` | Simple license-only login (no username required). |

---

## ?? Requirements

- **Windows:** PowerShell must be enabled (default on Win 10/11).
- **FiveM:** Ensure you have a JSON library (usually built-in).
- **Roblox:** `HttpService` must be enabled in Game Settings.

## ?? Disclaimer
This project is intended for use with the AuthVaultix.com authentication service. Ensure you comply with their Terms of Service.

---

