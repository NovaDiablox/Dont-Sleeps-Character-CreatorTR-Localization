local russianTexts = {
    name = "Имя:",
    character = "Характер:",
    bio = "Биография:",
    close = "Закрыть",
    saveButtonText = "Сохранить",
    healthy = "Здоров",
    slightly_injured = "Слегка ранен",
    injured = "Ранен",
    heavily_injured = "Тяжело ранен",
    critically_injured = "Серьезные ранения",
    additional = "F3 - Дополнительно",
}

local turkishTexts = {
	name = "İsim",
	character = "Karakter",
	bio = "Biyografi",
	close = "Kapat",
	saveButtonText = "Kaydet",
	healthy = "Sağlıklı",
	slightly_injured = "Hafif Yaralı",
	injured = "Yaralı",
	heavily_injured = "Ağır Yaralı",
	critically_injured = "Ölümün Eşiğinde",
	additional = "F3 - Daha Fazla Bilgi"
}

local englishTexts = {
    name = "Name:",
    character = "Character:",
    bio = "Biography:",
    close = "Close",
    saveButtonText = "Save",
    healthy = "Healthy",
    slightly_injured = "Slightly Injured",
    injured = "Injured",
    heavily_injured = "Heavily Injured",
    critically_injured = "Critically Injured",
    additional = "F3 - More Info",
}

local currentLanguage = englishTexts

-- Функция для обновления языка
local function UpdateLanguage(language)
    if language == "Русский" then
        currentLanguage = russianTexts
    elseif language == "English" then
        currentLanguage = englishTexts
    end
end

local function SetLanguage(language)
    print("Setting ", language)
    if language ~= nil then
        UpdateLanguage(language)
    end
end


net.Receive("SelectedLanguage", function(len)
    local language = net.ReadString()
        SetLanguage(language)
    end)

    local function DrawCharacterInfo()
        local maxDistance = 300
        local font = "Trebuchet24"
    
        for _, ply in pairs(player.GetAll()) do
            if not ply:Alive() or ply:GetMaterial() == "models/effects/vol_light001" then continue end  -- Проверка на невидимость
    
            local localPlayerPos = LocalPlayer():GetPos()
            local playerPos = ply:GetPos()
            local distance = localPlayerPos:Distance(playerPos)
    
            if distance <= maxDistance then
                local headPos = playerPos + Vector(0, 0, 75) 
                local chestPos = playerPos + Vector(0, 0, 40) 
    
                local headScreenPos = headPos:ToScreen()
                local chestScreenPos = chestPos:ToScreen()
    
                local health = ply:Health()
                local healthText
                local healthColor
    
                if health >= 100 then
                    healthText = currentLanguage.healthy
                    healthColor = Color(0, 255, 0)
                elseif health >= 80 then
                    healthText = currentLanguage.slightly_injured
                    healthColor = Color(0, 100, 0)
                elseif health >= 60 then
                    healthText = currentLanguage.injured
                    healthColor = Color(255, 255, 0)
                elseif health >= 40 then
                    healthText = currentLanguage.heavily_injured
                    healthColor = Color(255, 165, 0)
                else
                    healthText = currentLanguage.critically_injured
                    healthColor = Color(255, 0, 0)
                end
    
                local tr = util.TraceLine({
                    start = LocalPlayer():EyePos(),
                    endpos = headPos,
                    filter = {LocalPlayer(), ply}
                })
    
                if not tr.Hit then
                    local name = ply:GetNWString("CharacterName", "Unknown")
                    local appearance = ply:GetNWString("CharacterAppearance", "Unknown")
                    local bio = ply:GetNWString("CharacterBio", "Unknown")
                    local character = ply:GetNWString("CharacterCharacter", "Unknown")
    
                    draw.SimpleTextOutlined(name, font, headScreenPos.x, headScreenPos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
                    draw.SimpleTextOutlined(appearance, "CenterPrintText", chestScreenPos.x, chestScreenPos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
                    draw.SimpleTextOutlined(healthText, "DermaDefault", headScreenPos.x, headScreenPos.y - 20, healthColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
                    draw.SimpleTextOutlined(currentLanguage.additional, "DermaDefault", chestScreenPos.x, chestScreenPos.y + 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
                end
            end
        end
    end


if SERVER then return end

local function OpenCharacterMenu(ply)


    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(700, 500)
    frame:Center()
    frame:MakePopup()

    -- Черные края меню
    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    -- Создаем панель для размещения информации
    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)
    panel:SetBackgroundColor(Color(45, 45, 45))

    -- Создаем модель игрока
    local playerModel = vgui.Create("DModelPanel", panel)
    playerModel:SetSize(300, 500) -- Размер модели
    playerModel:SetModel(ply:GetModel())
    playerModel:Dock(LEFT) -- Размещаем модель слева
    playerModel:SetFOV(45)
    playerModel:SetCamPos(Vector(70, 0, 50))
    playerModel:SetLookAt(Vector(0, 0, 50))

    -- Создаем панель для размещения информации о персонаже
    local infoPanel = vgui.Create("DPanel", panel)
    infoPanel:Dock(FILL)
    infoPanel:DockMargin(10, 10, 10, 10)
    infoPanel:SetBackgroundColor(Color(35, 35, 35))
    infoPanel.Paint = function() end

    -- Создаем метку для отображения имени персонажа
    local nameLabel = vgui.Create("DLabel", infoPanel)
    nameLabel:SetText(currentLanguage.name .. ply:GetNWString("CharacterName", "Unknown"))
    nameLabel:Dock(TOP)
    nameLabel:SetFont("Trebuchet24")
    nameLabel:SetTextColor(Color(255, 255, 255))
    nameLabel:SizeToContents()
    nameLabel:DockMargin(10, 10, 10, 0)

    -- Создаем метку для отображения характера персонажа
    local characterLabel = vgui.Create("DLabel", infoPanel)
    characterLabel:SetText(currentLanguage.character)
    characterLabel:Dock(TOP)
    characterLabel:SetFont("Trebuchet18")
    characterLabel:SetTextColor(Color(255, 255, 255))
    characterLabel:SetWrap(true)
    characterLabel:SetAutoStretchVertical(true)
    characterLabel:DockMargin(10, 10, 10, 0)

    local characterText = vgui.Create("DTextEntry", infoPanel)
    characterText:SetText(ply:GetNWString("CharacterCharacter", "No character description available."))
    characterText:Dock(TOP)
    characterText:SetMultiline(true)
    characterText:SetTall(100) -- Устанавливаем высоту поля
    characterText:SetFont("Trebuchet18")
    characterText:SetTextColor(Color(255, 255, 255))
    characterText:SetDrawBackground(true)
    characterText:SetEditable(false)
    characterText.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    local bioLabel = vgui.Create("DLabel", infoPanel)
    bioLabel:SetText(currentLanguage.bio)
    bioLabel:Dock(TOP)
    bioLabel:SetFont("Trebuchet18")
    bioLabel:SetTextColor(Color(255, 255, 255))
    bioLabel:SetWrap(true)
    bioLabel:SetAutoStretchVertical(true)
    bioLabel:DockMargin(10, 10, 10, 0)

    local bioText = vgui.Create("DTextEntry", infoPanel)
    bioText:SetText(ply:GetNWString("CharacterBio", "No biography available."))
    bioText:Dock(TOP)
    bioText:SetMultiline(true)
    bioText:SetTall(180) -- Устанавливаем высоту поля
    bioText:SetFont("Trebuchet18")
    bioText:SetTextColor(Color(255, 255, 255))
    bioText:SetDrawBackground(true)
    bioText:SetEditable(false)
    bioText.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    -- Создаем кнопку для закрытия меню
    local closeButton = vgui.Create("DButton", panel)
    closeButton:SetText(currentLanguage.close)
    closeButton:Dock(BOTTOM)
    closeButton:DockMargin(0, 10, 0, 10)
    closeButton:SetTall(40)
    closeButton:SetTextColor(Color(255, 255, 255))
    closeButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
    end
    closeButton.DoClick = function()
        frame:Close()
    end
end

-- Обновленный хук для обработки нажатия клавиши F3
hook.Add("Think", "CheckF3KeyPress", function()
    if input.IsKeyDown(KEY_F3) then
        -- Проверяем, была ли клавиша F3 нажата в предыдущем кадре
        if not f3Pressed then
            f3Pressed = true -- Устанавливаем флаг нажатия клавиши F3

            local maxDistance = 50 -- Максимальное расстояние для открытия меню (можно настроить)
            local localPlayerPos = LocalPlayer():GetPos()

            for _, ply in pairs(player.GetAll()) do
                if ply == LocalPlayer() or not ply:Alive() then continue end -- Пропускаем текущего игрока и мертвых игроков

                local playerPos = ply:GetPos()
                local distance = localPlayerPos:Distance(playerPos)

                if distance <= maxDistance then
                    OpenCharacterMenu(ply) -- Открываем меню с информацией о персонаже
                    break -- Прерываем цикл, если мы уже нашли ближайшего игрока
                end
            end
        end
    else
        f3Pressed = false -- Сбрасываем флаг нажатия клавиши F3
    end
end)

-- Создаем хук для отображения информации о персонаже
hook.Add("HUDPaint", "DrawCharacterInfo", DrawCharacterInfo)

-- Функция для рисования нашего собственного HUD
local function DrawCustomHUD()
    -- Получаем локального игрока
    local ply = LocalPlayer()
    -- Получаем его здоровье
    local health = ply:Health()
    -- Получаем его броню
    local armor = ply:Armor()
    -- Получаем его имя
    local name = ply:GetNWString("CharacterName", "Unknown")

    -- Устанавливаем цвет для здоровья (зеленый)
    local healthColor = Color(0, 205, 0, 255)
    -- Устанавливаем цвет для брони (серый)
    local armorColor = Color(169, 169, 169, 255)
    -- Устанавливаем цвет для текста имени (белый)
    local nameColor = Color(255, 255, 255, 255)

    -- Устанавливаем размер шрифта для имени
    surface.SetFont("DermaLarge")
    local nameWidth, nameHeight = surface.GetTextSize(name)

    -- Рассчитываем ширину полос здоровья и брони
    local barWidth = 300
    local barHeight = 20

    -- Рисуем имя персонажа с тенью
    draw.SimpleTextOutlined(name, "DermaLarge", 52, ScrH() - 105, nameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
end

-- Хук для рисования нашего собственного HUD
hook.Add("HUDPaint", "DrawMyHUD", DrawCustomHUD)
