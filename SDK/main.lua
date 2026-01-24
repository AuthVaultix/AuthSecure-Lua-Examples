-- Import the AuthVaultix module
local AuthVaultix = require("authvaultix_windows")

local name = "Teamdeveloperxd"
local ownerid = "5d36476ca4"
local secret = "4e1d8a87787f8af61c5462d12ee16e1f06d53fe314c78e985571db65f0007178"
local version = "1.0"



-- Initialize API with your config
AuthVaultix.Api(name, ownerid, secret, version)

-- Start initialization
AuthVaultix.Init()

-- CLI Menu
print("\n[1] Login\n[2] Register\n[3] License Login\n[4] Exit")
io.write("Choose option: ")
local choice = io.read()

-- Menu handler
if choice == "1" then
    io.write("Username: ") local username = io.read()
    io.write("Password: ") local password = io.read()
    AuthVaultix.Login(username, password)

elseif choice == "2" then
    io.write("Username: ") local username = io.read()
    io.write("Password: ") local password = io.read()
    io.write("License: ") local license = io.read()
    AuthVaultix.Register(username, password, license)

elseif choice == "3" then
    io.write("License: ") local license = io.read()
    AuthVaultix.License(license)

else
    print("Goodbye!")
end
