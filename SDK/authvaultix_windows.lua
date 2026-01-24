-- =========================================
-- ?? AuthVaultix Lua (PowerShell HTTPS version � no LuaSec required)
-- =========================================

local json = require("dkjson")

local BASE_URL = "https://api.authvaultix.com/api/1.2/"

local AuthVaultix = {
    name = "",
    ownerid = "",
    secret = "",
    version = "",
    sessionid = nil,
}

function AuthVaultix.Api(name, ownerid, secret, version)
    AuthVaultix.name = name
    AuthVaultix.ownerid = ownerid
    AuthVaultix.secret = secret
    AuthVaultix.version = version
end

-- =========================================
-- ?? Internal: Send HTTPS request via PowerShell
-- =========================================
local function send_request(payload)
    local cmd = string.format(
        [[powershell -Command "$body = '%s'; $resp = Invoke-WebRequest -Uri '%s' -Method POST -Body $body -UseBasicParsing; Write-Output $resp.Content"]],
        payload:gsub("'", "''"),
        BASE_URL
    )

    local handle = io.popen(cmd)
    local response = handle:read("*a")
    handle:close()

    if not response or response == "" then
        print("? HTTP Error: No response from server.")
        os.exit()
    end

    local decoded, pos, err = json.decode(response, 1, nil)
    if err then
        print("? JSON Decode Error:", err)
        print("Raw Response:", response)
        os.exit()
    end

    return decoded
end

-- =========================================
-- ?? HWID (Windows SID)
-- =========================================
local function get_hwid()
    local handle = io.popen([[powershell -Command "[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value"]])
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("%s+", "")
    if result == "" then result = "UNKNOWN_HWID" end
    return result
end

-- =========================================
-- ?? Init / Login / Register / License
-- =========================================
function AuthVaultix.Init()
    print("Connecting...")
    local postData = string.format("type=init&name=%s&ownerid=%s&secret=%s&ver=%s",
        AuthVaultix.name, AuthVaultix.ownerid, AuthVaultix.secret, AuthVaultix.version)

    local resp = send_request(postData)
    if resp.success then
        AuthVaultix.sessionid = resp.sessionid
        print("? Initialized Successfully!")
    else
        print("? Init Failed:", resp.message or "Unknown error")
        os.exit()
    end
end

function AuthVaultix.Login(username, password)
    local hwid = get_hwid()
    local postData = string.format(
        "type=login&sessionid=%s&username=%s&pass=%s&hwid=%s&name=%s&ownerid=%s",
        AuthVaultix.sessionid, username, password, hwid, AuthVaultix.name, AuthVaultix.ownerid
    )

    local resp = send_request(postData)
    if resp.success then
        print("? Logged in!")
        print_user_info(resp.info)
    else
        print("? Login Failed:", resp.message or "Unknown error")
    end
end

function AuthVaultix.Register(username, password, license)
    local hwid = get_hwid()
    local postData = string.format(
        "type=register&sessionid=%s&username=%s&pass=%s&key=%s&hwid=%s&name=%s&ownerid=%s",
        AuthVaultix.sessionid, username, password, license, hwid, AuthVaultix.name, AuthVaultix.ownerid
    )

    local resp = send_request(postData)
    if resp.success then
        print("? Registered Successfully!")
        print_user_info(resp.info)
    else
        print("? Register Failed:", resp.message or "Unknown error")
    end
end

function AuthVaultix.License(license)
    local hwid = get_hwid()
    local postData = string.format(
        "type=license&sessionid=%s&key=%s&hwid=%s&name=%s&ownerid=%s",
        AuthVaultix.sessionid, license, hwid, AuthVaultix.name, AuthVaultix.ownerid
    )

    local resp = send_request(postData)
    if resp.success then
        print("? License Login Successful!")
        print_user_info(resp.info)
    else
        print("? License Login Failed:", resp.message or "Unknown error")
    end
end

-- =========================================
-- ?? Print User Info
-- =========================================
function print_user_info(info)
    if not info then return end
    print("\n?? User Info:")
    print(" Username:", info.username)
    if info.ip then print(" IP:", info.ip) end
    if info.hwid then print(" HWID:", info.hwid) end
    if info.subscriptions then
        print(" Subscriptions:")
        for _, sub in ipairs(info.subscriptions) do
            print(string.format("  - %s | Expires: %s | Left: %s",
                sub.subscription or "N/A", sub.expiry or "?", sub.timeleft or "?"))
        end
    end
    print()
end

return AuthVaultix
