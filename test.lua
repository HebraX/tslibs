local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/HebraX/Libs/main/6th%20sense%202.lua",true))()

local Manager = {}
Manager = {
    Settings = {},

    Visuals = {},
    CurrentObjects = {},
    Objects = {
        ["Players"] = {},
        ["DeadPlayers"] = {}
    },
    CreateVisuals = {
        ["Name"] = function(Args)
            Args.Text = Args.Object.Name

            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Name(Args.Object, Args.Text, Args.Settings))
        end,
        ["Box"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Box(Args.Object, Args.Settings))
        end,
        ["Skeleton"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Skeleton(Args.Object, Args.Settings))
        end,
        ["Chams"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Chams(Args.Object, Args.Settings))
        end,
        ["HealthBar"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:HealthBar(Args.Object, Args.Settings))
        end
    }
}

function Manager:toggle(State)
    if State then
        ESP:Start()
    else
        ESP:Stop()
    end
end

function Manager:vtoggle(Type, Name, State, ObjectData)
    if not self.Visuals[Type] then
        self.Visuals[Type] = {}
    end

    if not self.Visuals[Type][Name] then
        self.Visuals[Type][Name] = {}
    end

    if not self.Settings[Type] then
        self.Settings[Type] = {}
    end

    if not self.Settings[Type][Name] then
        self.Settings[Type][Name] = {}
    end

    self.Settings[Type][Name].Enabled = State

    if State then
        if self.Objects[ObjectData] then
            for i,v in pairs(self.Objects[ObjectData]) do
                self.CreateVisuals[Name]({
                    Object = v,
                    Visuals = self.Visuals[Type][Name],
                    Settings = self.Settings[Type][Name]
                })
            end
        end
    else
        for i,v in pairs(self.Visuals[Type][Name]) do
            v:Remove()
        end
        
        self.Visuals[Type][Name] = nil
    end
end

function Manager:UpdateSetting(Type, Visual, Setting, Value)
    if not self.Settings[Type] then
        self.Settings[Type] = {}
    end

    if not self.Settings[Type][Visual] then
        self.Settings[Type][Visual] = {}
    end

    self.Settings[Type][Visual][Setting] = Value

    if self.Visuals[Type] and self.Visuals[Type][Visual] then
        for i,v in pairs(self.Visuals[Type][Visual]) do
            if v and v.ChangeSetting then
                v:ChangeSetting(Setting, Value)
            end
        end
    end
end

-- Players
workspace.Players.ChildAdded:Connect(function(Character)
    repeat
        task.wait()
    until Character:FindFirstChild("Humanoid") and Character.PrimaryPart and Character:FindFirstChild("Head")

    table.insert(Manager.Objects["Players"], Character)

    if Manager.Settings["Players"] then
        for i,v in pairs(Manager.Settings["Players"]) do
            if v.Enabled then
                Manager.CreateVisuals[i]({
                    Object = Character,
                    Visuals = Manager.Visuals["Players"][i],
                    Settings = Manager.Settings["Players"][i]
                })
            end
        end
    end
end)
for _,Character in next, workspace.Players:GetChildren() do
    repeat
        task.wait()
    until Character:FindFirstChild("Humanoid") and Character.PrimaryPart and Character:FindFirstChild("Head")

    table.insert(Manager.Objects["Players"], Character)

    if Manager.Settings["Players"] then
        for i,v in pairs(Manager.Settings["Players"]) do
            if v.Enabled then
                Manager.CreateVisuals[i]({
                    Object = Character,
                    Visuals = Manager.Visuals["Players"][i],
                    Settings = Manager.Settings["Players"][i]
                })
            end
        end
    end
end

return Manager
