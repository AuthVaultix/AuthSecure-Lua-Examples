local json = require "json"

local AuthVaultix = {}
AuthVaultix.BASE_URL = "https://api.authvaultix.com/api/1.2/"
AuthVaultix.sessionid = nil
AuthVaultix.name = ""
AuthVaultix.ownerid = ""
AuthVaultix.secret = ""
AuthVaultix.version = ""

function AuthVaultix.Api(name, ownerid, secret, version)
    AuthVaultix.name = name
    AuthVaultix.ownerid = ownerid
    AuthVaultix.secret = secret
    AuthVaultix.version = version
end

local function send_request(data, callback)
    local form = ""
    for k, v in pairs(data) do
        form = form .. k .. "=" .. v .. "&"
    end
    form = string.sub(form, 1, -2)

    PerformHttpRequest(AuthVaultix.BASE_URL, function(status, body)
        if status == 200 then
            local ok, resp = pcall(function() return json.decode(body) end)
            if ok then callback(resp)
            else print("? JSON Decode Error:", body) end
        else
            print("? HTTP Error:", status)
        end
    end, 'POST', form, { ['Content-Type'] = 'application/x-www-form-urlencoded' })
end

function AuthVaultix.Init()
    print("Connecting...")
    send_request({
        type = "init",
        name = AuthVaultix.name,
        ownerid = AuthVaultix.ownerid,
        secret = AuthVaultix.secret,
        ver = AuthVaultix.version
    }, function(resp)
        if resp.success then
            AuthVaultix.sessionid = resp.sessionid
            print("? Initialized Successfully!")
        else
            print("? Init Failed:", resp.message)
        end
    end)
end

function AuthVaultix.Login(src, username, password)
    local hwid = "FIVEM-" .. GetPlayerIdentifier(src, 0)
    send_request({
        type = "login",
        sessionid = AuthVaultix.sessionid,
        username = username,
        pass = password,
        hwid = hwid,
        name = AuthVaultix.name,
        ownerid = AuthVaultix.ownerid
    }, function(resp)
        if resp.success then
            print("? " .. username .. " Logged in successfully!")
            TriggerClientEvent("auth:loginSuccess", src, resp.info)
        else
            TriggerClientEvent("auth:loginFailed", src, resp.message)
        end
    end)
end

return AuthVaultix
