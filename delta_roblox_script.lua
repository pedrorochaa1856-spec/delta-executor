-- Delta Executor Script - Roblox
-- Script básico educacional para usar com Delta Executor
-- ================================================

-- 1. OBTER SERVIÇOS PRINCIPAIS
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 2. VARIÁVEIS GLOBAIS
local DeltaExecutor = {}
DeltaExecutor.Version = "1.0"
DeltaExecutor.Running = true
DeltaExecutor.Logs = {}

-- 3. FUNÇÕES ÚTEIS
function DeltaExecutor:Log(message)
    table.insert(self.Logs, message)
    print("[Delta] " .. message)
end

function DeltaExecutor:Warn(message)
    warn("[Delta WARNING] " .. message)
end

function DeltaExecutor:SetSpeed(speed)
    humanoid.WalkSpeed = speed
    self:Log("Velocidade alterada para: " .. speed)
end

function DeltaExecutor:SetJumpPower(power)
    humanoid.JumpPower = power
    self:Log("Jump alterado para: " .. power)
end

function DeltaExecutor:TeleportTo(x, y, z)
    rootPart.CFrame = CFrame.new(x, y, z)
    self:Log("Teleportado para: " .. x .. ", " .. y .. ", " .. z)
end

function DeltaExecutor:GetPlayerPosition()
    local pos = rootPart.Position
    return {x = pos.X, y = pos.Y, z = pos.Z}
end

function DeltaExecutor:InfiniteJump(enabled)
    if enabled then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                self:Log("Infinite Jump ativado!")
            end
        end)
    end
end

function DeltaExecutor:Noclip(enabled)
    if enabled then
        RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        self:Log("Noclip ativado!")
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        self:Log("Noclip desativado!")
    end
end

function DeltaExecutor:GetAllPlayers()
    local playerList = {}
    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(playerList, plr.Name)
    end
    return playerList
end

function DeltaExecutor:SpawnPart(x, y, z, size, color)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.Size = Vector3.new(size, size, size)
    part.BrickColor = BrickColor.new(color or "Bright red")
    part.CanCollide = false
    part.CFrame = CFrame.new(x, y, z)
    part.Parent = workspace
    
    self:Log("Parte criada em: " .. x .. ", " .. y .. ", " .. z)
    return part
end

-- 4. MENU DE CONTROLES (OPCIONAL)
print("=== Delta Executor v" .. DeltaExecutor.Version .. " ===")
print("Comandos disponíveis:")
print("DeltaExecutor:SetSpeed(25)")
print("DeltaExecutor:SetJumpPower(50)")
print("DeltaExecutor:TeleportTo(0, 50, 0)")
print("DeltaExecutor:InfiniteJump(true)")
print("DeltaExecutor:Noclip(true)")
print("DeltaExecutor:GetPlayerPosition()")
print("DeltaExecutor:GetAllPlayers()")
print("=====================================")

-- 5. EXEMPLO DE USO
DeltaExecutor:Log("Delta Executor iniciado!")
DeltaExecutor:Log("Jogador: " .. player.Name)
DeltaExecutor:Log("Posição: " .. tostring(DeltaExecutor:GetPlayerPosition()))

return DeltaExecutor
