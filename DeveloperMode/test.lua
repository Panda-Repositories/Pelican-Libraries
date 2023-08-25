-- PandaAuth.lua (Module Script)

local PandaAuth = {}

getgenv().SendDiagnostic = false
getgenv().DebugPrint = false
getgenv().Client = game.Players.LocalPlayer

LOADSTRING  = clonefunction(loadstring)
HttpGet  = clonefunction(game.HttpGet)

function DebugPrint(msg)
    if getgenv().DebugPrint then
        warn("[PANDA DEBUG] - "..msg)
    end
end

function RandomString(length)
    local randomString = ""
    for i = 1, length do
        local randomNumber = math.random(97, 122)
        randomString = randomString .. string.char(randomNumber)
    end
    return tostring(randomString)
end

function exceptionmessage(message)
    print("Exception:", message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error (" .. identifyexecutor() .. ")", -- the title (ofc)
        Text = message, -- what the text says (ofc)
        Duration = 6 -- how long the notification should in secounds
    })
    -- 
    if getgenv().SendDiagnostic then
        print('shit')
    else
        print('shit')
    end
end

local function ExecutorUse()
    local scriptutility = identifyexecutor()
    if not game:GetService("UserInputService").TouchEnabled and
        not game:GetService("UserInputService").KeyboardEnabled == false then
        return scriptutility .. " ( Windows Version )"
    else
        return scriptutility .. " ( Android/Ios Version )"
    end
end

local server_configuration = "https://pandadevelopment.net";
local executor = ExecutorUse()
local _request = (request) or (syn.request)

print("Panda Development (DEBUG MODE)")

print("________________________________________________________")
print("Version: 1.5.0.2 Alpha (Panda Authentication Lib)")
print("Script Utility: " .. executor)
print("________________________________________________________")

local function rblxTokenID(service)
    -- Hardware Identication Code
    DebugPrint("Fetching Data from Server that associated with "..service)
    local authtype = tostring(game:HttpGet("https://pandadevelopment.net/serviceapi?service="..service.."&command=GetAuthType", true))
    local client_id = game:GetService("RbxAnalyticsService"):GetClientId()
    local generate_ip = tostring(game:HttpGet("https://pandadevelopment.net/serviceapi?service="..service.."&command=GetUserIPAddress", true)) 
    if authtype == "playerid" then
        DebugPrint("Using Player ID Only")
        -- Returns Only Player ID
        return tostring(game:GetService("Players").LocalPlayer.UserId) .."_MOBILE"
    elseif authtype == "hwidandip" then
        -- Returns Both IP & Client ID with Hashed
        DebugPrint("Using Combined Mixed")
        local hashedata = tostring(game:HttpGet("https://pandadevelopment.net/serviceapi?service="..service.."&command=Hashed&param="..generate_ip..client_id, true))
        return hashedata
    elseif authtype == "hwidonly" then
        -- Returns Client ID
        DebugPrint("Using Client ID / Hardware ID")
        return client_id
    elseif authtype == "iponly" then       
        -- Returns Only IP Address of the User's who Execute this Script & Hashed it with SHA256  
        DebugPrint("Using Hashed IP as Hardware ID")
        local hashedata = tostring(game:HttpGet("https://pandadevelopment.net/serviceapi?service="..service.."&command=Hashed&param="..generate_ip, true))
        return hashedata
    end
end

local function GenerateLink(URL, Exploit)
    return URL .. "/getkey?service=" .. Exploit .. "&hwid=" .. rblxTokenID(Exploit);
end

local function Validate(URL, Exploit, Key, TokenCmd)
        local Blob = "";
        for i = -1, #Key do Blob = Blob .. "_"; end

        local Response = _request({
            Url = URL .. "/validate?service=" .. Exploit .. "&key=" .. Key ..
                "&hwid=" .. TokenCmd .. "&blob=" .. Blob,
            Method = "GET",
            Headers = {["User-Agent"] = "Mobile-Auth-Client/1.0"}
        });

        if (Response.Success and Response.Body ~= "") then
            DebugPrint("Successfully Authenticated")
            return true;
        else
            DebugPrint("Failed to Authenticated")
            return false;
        end
end


function PandaAuth:GetLink(service_name)
    local thisisretard = GenerateLink(server_configuration, service_name)
    print("Your Generated Link is -> "..thisisretard)
    return thisisretard
end

function PandaAuth:LoadScript(GithubUser,SecondGithub,Fake,ScriptLink)
    print("LoadScript")
    local randomx = math.random(5,13)
    for i = 1,20 do
        spawn(function()
            warn(i,randomx)
            if randomx == i then
                LOADSTRING(HttpGet(ScriptLink))();
            end
            local randomNum = math.random(1,2)
            if randomNum == 1 then
                local randomuser = math.random(1,#GithubUser)
                text = "https://raw.githubusercontent.com/"..GithubUser[randomuser].."/"..SecondGithub.."/main/"
            elseif randomNum == 2 then
                text = "https://raw.githubusercontent.com/"..RandomString(7).."/"..SecondGithub.."/main/"
            end
            HttpGet(text..Fake[math.random(1,#Fake)])
        end)
        wait(.25)
    end
    STOPCHECK = true
end

function PandaAuth:ValidateKey(service_name, Key)
    print("Validating your Key.. Please Wait")
    local service_authtype = rblxTokenID(service_name)
    -- Validation Starts
    if (Validate(server_configuration, service_name, Key, service_authtype)) then
        return true;
    elseif (Validate(server_configuration, service_name, Key, tostring(game:GetService("Players").LocalPlayer.UserId) .."_MOBILE")) then
        -- FOR THE LOVE OF GOD, I ADD THIS COMPATIBLE
        return true;
    else
        warn('Sorry.. It did not validate the key (Probably Wrong Key or Authentication Type)')
        return false;
    end
end

STOPCHECK = false
spawn(function()
    while true do
        if STOPCHECK == false then
            if PandaAuth:GetLink("pandadevkit") == nil and PandaAuth:ValidateKey("pandadevkit", RandomString(10)) then
                warn("[+] The Validation Function has been Tampered")
                game.Players.LocalPlayer:Kick("9PASA SAID | STOP SPOOF US NO ONE CAN 😉")
                wait(2)
                game:Shutdown()
                while true do end
            end    
            wait(2) 
        end
    end
end)

return PandaAuth
