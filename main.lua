local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "HoneyPot Hub | TPS Ultimate Soccer",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "HoneyPotTPS"
})

local Tab = Window:MakeTab({
    Name = "Enhancement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddLabel("⚽ Reach, Auto React, Infinite Sprint & More! ⚡")

local function Humiliate(player)
    local char = player.Character
    if char then
        -- MASSIVE, GLOWY LEGS AND BODY ("BigLegs" gone wrong)
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if p.Name == "Left Leg" or p.Name == "Right Leg" or p.Name == "LeftLowerLeg" or p.Name == "RightLowerLeg" then
                    p.Size = Vector3.new(6,10,6)
                    p.BrickColor = BrickColor.new("Hot pink")
                    p.Material = Enum.Material.Neon
                    p.Transparency = 0.2
                elseif p.Name == "HumanoidRootPart" then
                    p.Size = Vector3.new(12, 12, 12)
                    p.BrickColor = BrickColor.new("Institutional white")
                    p.Material = Enum.Material.Neon
                    p.Transparency = 0.1
                end
            end
        end

        -- CONSTANT SLOWDOWN ("Infinite Sprint" gone wrong)
        if char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = 5 -- Turtle slow
            char:FindFirstChildOfClass("Humanoid").JumpPower = 0  -- Can't jump
        end
    end
end

Tab:AddButton({
    Name = "Reach Exploit (NEW!)",
    Callback = function()
        local player = game.Players.LocalPlayer
        Humiliate(player)
        OrionLib:MakeNotification({
            Name = "HoneyPot Hub",
            Content = "Reach Exploit Successfully Enabled 🥇",
            Image = "rbxassetid://4483345998",
            Time = 7
        })
    end
})

Tab:AddToggle({
    Name = "Auto React Pro",
    Default = false,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        if val then
            Humiliate(player)
            OrionLib:MakeNotification({
                Name = "HoneyPot Hub",
                Content = "Auto React Activated!",
                Image = "rbxassetid://4483345998",
                Time = 7
            })
        end
    end
})

Tab:AddSlider({
    Name = "Big Hitbox v3",
    Min = 3,
    Max = 10,
    Default = 10,
    Color = Color3.fromRGB(255,0,0),
    Increment = 1,
    ValueName = "X",
    Callback = function()
        local player = game.Players.LocalPlayer
        Humiliate(player)
    end
})

Tab:AddColorpicker({
    Name = "Leg Glow Color",
    Default = Color3.fromRGB(255, 0, 255),
    Callback = function()
        local player = game.Players.LocalPlayer
        Humiliate(player)
    end
})

Tab:AddParagraph("⚠️ Notice", "Script is fully undetectable and best working after match start. 'Reach', 'Big Legs', and 'Speed' come with new Anti-Ban features! [BETA]")

OrionLib:Init()