local HttpService = game:GetService("HttpService")

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

local function send_request(data)
	local encoded = ""
	for k, v in pairs(data) do
		encoded ..= k .. "=" .. HttpService:UrlEncode(v) .. "&"
	end
	encoded = string.sub(encoded, 1, -2)

	local success, response = pcall(function()
		return HttpService:PostAsync(AuthVaultix.BASE_URL, encoded, Enum.HttpContentType.ApplicationUrlEncoded)
	end)

	if not success then
		warn("? HTTP Error:", response)
		return nil
	end

	local ok, json = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if ok then
		return json
	else
		warn("? JSON Decode Error:", response)
		return nil
	end
end

function AuthVaultix.Init()
	print("Connecting...")
	local payload = {
		type = "init",
		name = AuthVaultix.name,
		ownerid = AuthVaultix.ownerid,
		secret = AuthVaultix.secret,
		ver = AuthVaultix.version
	}
	local resp = send_request(payload)
	if resp and resp.success then
		AuthVaultix.sessionid = resp.sessionid
		print("? Initialized Successfully!")
	else
		warn("? Init Failed:", resp and resp.message or "Unknown error")
	end
end

function AuthVaultix.Login(username, password)
	local hwid = "Roblox-" .. tostring(game.Players.LocalPlayer.UserId)
	local payload = {
		type = "login",
		sessionid = AuthVaultix.sessionid,
		username = username,
		pass = password,
		hwid = hwid,
		name = AuthVaultix.name,
		ownerid = AuthVaultix.ownerid
	}
	local resp = send_request(payload)
	if resp and resp.success then
		print("? Logged in as " .. username)
	else
		warn("? Login Failed:", resp and resp.message or "Unknown error")
	end
end

return AuthVaultix
