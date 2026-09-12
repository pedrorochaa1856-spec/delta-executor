-- Delta Executor - Admin Script para Brookhaven
-- Versão: 2.0 Brookhaven Admin
-- ================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- VARIÁVEIS DO ADMIN
local AdminScript = {}
AdminScript.Version = "2.0 Brookhaven"
AdminScript.Enabled = true
AdminScript.MenuOpen = false
AdminScript.Logs = {}
AdminScript.Settings = {
    speed = 25,
    jumpPower = 50,
    noclipEnabled = false,
    flyEnabled = false,
}

-- ============================================
-- 1. SISTEMA DE LOG
-- ============================================
function AdminScript:Log(message)
    table.insert(self.Logs, message)
    print("[ADMIN] " .. message)
end

function AdminScript:Warn(message)
    warn("[ADMIN WARNING] " .. message)
end

-- ============================================
-- 2. CONTROLES DE MOVIMENTO
-- ============================================

function AdminScript:SetSpeed(speed)
    self.Settings.speed = speed
    humanoid.WalkSpeed = speed
    self:Log("Velocidade alterada para: " .. speed)
end

function AdminScript:SetJumpPower(power)
    self.Settings.jumpPower = power
    humanoid.JumpPower = power
    self:Log("Jump alterado para: " .. power)
end

function AdminScript:Fly()
    if self.Settings.flyEnabled then
        self:Log("Voo desativado!")
        self.Settings.flyEnabled = false
        return
    end
    
    self.Settings.flyEnabled = true
    self:Log("Voo ativado!")
    
    local flying = true
    local speed = 50
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart
    
    RunService.RenderStepped:Connect(function()
        if not flying or not self.Settings.flyEnabled then
            bodyVelocity:Destroy()
            flying = false
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (rootPart.CFrame.LookVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (rootPart.CFrame.RightVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (rootPart.CFrame.LookVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (rootPart.CFrame.RightVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, speed, 0)
        end
        
        bodyVelocity.Velocity = moveDirection
    end)
end

function AdminScript:Noclip()
    if self.Settings.noclipEnabled then
        self:Log("Noclip desativado!")
        self.Settings.noclipEnabled = false
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        return
    end
    
    self.Settings.noclipEnabled = true
    self:Log("Noclip ativado!")
    
    RunService.Stepped:Connect(function()
        if not self.Settings.noclipEnabled then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function AdminScript:InfiniteJump()
    self:Log("Infinite Jump ativado! (Pressione SPACE)")
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Space then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- ============================================
-- 3. TELEPORTE
-- ============================================

function AdminScript:TeleportTo(x, y, z)
    rootPart.CFrame = CFrame.new(x, y, z)
    self:Log("Teleportado para: " .. x .. ", " .. y .. ", " .. z)
end

function AdminScript:TeleportToPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer and targetPlayer.Character then
        local targetChar = targetPlayer.Character
        self:TeleportTo(targetChar.HumanoidRootPart.Position.X, 
                        targetChar.HumanoidRootPart.Position.Y + 5, 
                        targetChar.HumanoidRootPart.Position.Z)
        self:Log("Teleportado para: " .. targetName)
    else
        self:Warn("Jogador " .. targetName .. " não encontrado!")
    end
end

function AdminScript:BringPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer and targetPlayer.Character then
        local targetChar = targetPlayer.Character
        targetChar.HumanoidRootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
        self:Log("Jogador " .. targetName .. " foi trazido!")
    else
        self:Warn("Jogador " .. targetName .. " não encontrado!")
    end
end

-- ============================================
-- 4. CONTROLES DE PERSONAGEM
-- ============================================

function AdminScript:InvisibleBody()
    self:Log("Corpo invisível ativado!")
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
end

function AdminScript:VisibleBody()
    self:Log("Corpo visível novamente!")
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
end

function AdminScript:GodMode()
    self:Log("God Mode ativado!")
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
end

function AdminScript:SpeedBoost(multiplier)
    self:SetSpeed(self.Settings.speed * multiplier)
    self:Log("Speed boost aplicado! Multiplicador: " .. multiplier .. "x")
end

-- ============================================
-- 5. CRIAÇÃO DE OBJETOS
-- ============================================

function AdminScript:SpawnPart(x, y, z, size, color, name)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.Size = Vector3.new(size, size, size)
    part.BrickColor = BrickColor.new(color or "Bright red")
    part.CanCollide = false
    part.CFrame = CFrame.new(x, y, z)
    part.Name = name or "AdminPart"
    part.Parent = workspace
    
    self:Log("Parte criada: " .. name .. " em (" .. x .. ", " .. y .. ", " .. z .. ")")
    return part
end

function AdminScript:SpawnPlataform(x, y, z, width, height, length)
    local platform = Instance.new("Part")
    platform.Shape = Enum.PartType.Block
    platform.Material = Enum.Material.Concrete
    platform.Size = Vector3.new(width, height, length)
    platform.BrickColor = BrickColor.new("Dark stone grey")
    platform.CFrame = CFrame.new(x, y, z)
    platform.Name = "AdminPlatform"
    platform.Parent = workspace
    
    self:Log("Plataforma criada!")
    return platform
end

-- ============================================
-- 6. GERENCIAMENTO DE JOGADORES
-- ============================================

function AdminScript:GetAllPlayers()
    local playerList = {}
    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(playerList, plr.Name)
    end
    return playerList
end

function AdminScript:PrintPlayers()
    local players = self:GetAllPlayers()
    print("\n=== JOGADORES ONLINE ===")
    for i, name in pairs(players) do
        print(i .. ". " .. name)
    end
    print("========================\n")
end

function AdminScript:KickPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer then
        targetPlayer:Kick("Você foi removido pelo admin!")
        self:Log("Jogador " .. targetName .. " foi removido!")
    else
        self:Warn("Jogador não encontrado!")
    end
end

-- ============================================
-- 7. MENU DO ADMIN
-- ============================================

function AdminScript:PrintMenu()
    print("\n" .. string.rep("=", 50))
    print("     ADMIN MENU - BROOKHAVEN v" .. self.Version)
    print(string.rep("=", 50))
    print("\n[MOVIMENTO]")
    print("AdminScript:SetSpeed(25)")
    print("AdminScript:SetJumpPower(50)")
    print("AdminScript:Fly()")
    print("AdminScript:Noclip()")
    print("AdminScript:InfiniteJump()")
    
    print("\n[TELEPORTE]")
    print("AdminScript:TeleportTo(x, y, z)")
    print("AdminScript:TeleportToPlayer('NomeDoJogador')")
    print("AdminScript:BringPlayer('NomeDoJogador')")
    
    print("\n[PERSONAGEM]")
    print("AdminScript:InvisibleBody()")
    print("AdminScript:VisibleBody()")
    print("AdminScript:GodMode()")
    print("AdminScript:SpeedBoost(2)")
    
    print("\n[OBJETOS]")
    print("AdminScript:SpawnPart(0, 50, 0, 5, 'Bright red', 'MinhaParte')")
    print("AdminScript:SpawnPlataform(0, 50, 0, 50, 5, 50)")
    
    print("\n[JOGADORES]")
    print("AdminScript:PrintPlayers()")
    print("AdminScript:GetAllPlayers()")
    print("AdminScript:KickPlayer('NomeDoJogador')")
    
    print("\n[INFORMAÇÕES]")
    print("AdminScript:GetPosition()")
    print(string.rep("=", 50) .. "\n")
end

function AdminScript:GetPosition()
    local pos = rootPart.Position
    return {x = pos.X, y = pos.Y, z = pos.Z}
end

-- ============================================
-- 8. INICIALIZAÇÃO
-- ============================================

print("\n" .. string.rep("*", 50))
print("*  DELTA EXECUTOR - ADMIN BROOKHAVEN v" .. AdminScript.Version .. "  *")
print(string.rep("*", 50) .. "\n")

AdminScript:Log("Script iniciado!")
AdminScript:Log("Jogador: " .. player.Name)
AdminScript:Log("Use AdminScript:PrintMenu() para ver os comandos")

AdminScript:PrintMenu()

-- Atalho de teclado para menu (pressione 'M')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        AdminScript:PrintMenu()
    end
end)

return AdminScript
