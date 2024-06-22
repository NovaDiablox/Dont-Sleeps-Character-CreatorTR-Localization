-- Убедимся, что скрипт выполняется только на клиенте
if SERVER then return end

local russianTexts = {
    menuTitle = "Создание персонажа",
    nameLabel = "Имя персонажа:",
    appearanceLabel = "Внешний вид:",
    characterLabel = "Характер:",
    bioLabel = "Биография:",
    saveButtonText = "Сохранить",
    KeyEdit = "Выберите клавишу для открытия меню:",
    ChooseLanguage = "Выберите язык:",
    Lang = "Русский",
    Char = "Персонаж",
    Options = "Настройки",
}

local turkishTexts = {
    menuTitle = "Karakter Oluşturma",
    nameLabel = "Karakter İsmi:",
    appearanceLabel = "Görünüş:",
    characterLabel = "Kişilik:",
    bioLabel = "Biyografi:",
    saveButtonText = "Kaydet",
    KeyEdit = "Bu menüyü açmak için düğme seçin:",
    ChooseLanguage = "Dil seçin:",
    Lang = "İngilizce",
    Char = "Karakter",
    Options = "Seçenekler",
}

-- Тексты на английском языке
local englishTexts = {
    menuTitle = "Character Creation",
    nameLabel = "Character Name:",
    appearanceLabel = "Appearance:",
    characterLabel = "Character:",
    bioLabel = "Biography:",
    saveButtonText = "Save",
    KeyEdit = "Choose the button to open this menu:",
    ChooseLanguage = "Choose language:",
    Lang = "English",
    Char = "Character",
    Options = "Options",
}

local currentLanguage = englishTexts

local function UpdateLanguage(language)
    if language == "Русский" then
        currentLanguage = russianTexts
    elseif language == "English" then
        currentLanguage = englishTexts
    elseif language == "Türkçe" then
        currentLanguage = turkishTexts  
    end
end

local characterData = {
    name = "",
    appearance = "",
    character = "",
    bio = ""
}

local function OpenMyMenu()

    local frame = vgui.Create("DFrame")
    frame:SetTitle(currentLanguage.menuTitle)
    frame:SetSize(600, 500)
    frame:Center()
    frame:MakePopup()


    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))  -- Цвет фона
        draw.RoundedBox(8, 0, 0, w, 25, Color(30, 30, 30))  -- Цвет заголовка
    end

    -- Создаём панель с вкладками
    local propertySheet = vgui.Create("DPropertySheet", frame)
    propertySheet:Dock(FILL)

    -- Изменяем цвет вкладок
    propertySheet.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))
    end

    for k, v in pairs(propertySheet.Items) do
        if v.Tab then
            v.Tab.Paint = function(self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, self:IsActive() and Color(30, 30, 30) or Color(35, 35, 35))
            end
        end
    end

    local function SendCharacterData(name, appearance)
        net.Start("SendCharacterData") -- Отправляем сетевое сообщение с именем "SendCharacterData"
        net.WriteString(name) -- Отправляем имя персонажа
        net.WriteString(appearance) -- Отправляем внешний вид персонажа
        net.SendToServer() -- Отправляем сообщение на сервер
    end

    -- Создаём панель для вкладки "Персонаж"
    local characterPanel = vgui.Create("DPanel", propertySheet)
    characterPanel:Dock(FILL)
    characterPanel:DockPadding(10, 10, 10, 10)

    characterPanel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 35))
    end

    -- Создаём контейнеры для группировки элементов
    local nameContainer = vgui.Create("DPanel", characterPanel)
    nameContainer:Dock(TOP)
    nameContainer:DockMargin(0, 0, 0, 5)
    nameContainer:SetHeight(50)
    nameContainer.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
    end

    local appearanceContainer = vgui.Create("DPanel", characterPanel)
    appearanceContainer:Dock(TOP)
    appearanceContainer:DockMargin(0, 0, 0, 5)
    appearanceContainer:SetHeight(50)
    appearanceContainer.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
    end

    local characterContainer = vgui.Create("DPanel", characterPanel)
    characterContainer:Dock(TOP)
    characterContainer:DockMargin(0, 0, 0, 5)
    characterContainer:SetHeight(50)
    characterContainer.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
    end

    local bioContainer = vgui.Create("DPanel", characterPanel)
    bioContainer:Dock(FILL)
    bioContainer:DockMargin(0, 0, 0, 5)
    bioContainer.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
    end

    -- Поле ввода для имени персонажа
    local nameLabel = vgui.Create("DLabel", nameContainer)
    nameLabel:SetText(currentLanguage.nameLabel)
    nameLabel:Dock(LEFT)
    nameLabel:DockMargin(10, 0, 10, 0)
    nameLabel:SetWidth(120)
    nameLabel:SetTextColor(Color(255, 255, 255))

    local nameEntry = vgui.Create("DTextEntry", nameContainer)
    nameEntry:Dock(FILL)
    nameEntry:SetTextColor(Color(255, 255, 255))
    nameEntry:SetDrawBackground(true)
    nameEntry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    local maxNameLength = 25
nameEntry.OnTextChanged = function(self)
    local text = self:GetValue()
    if utf8.len(text) > maxNameLength then
        self:SetText(utf8.sub(text, 1, maxNameLength))
        self:SetCaretPos(maxNameLength)
    end
end

    -- Поле ввода для внешнего вида
    local appearanceLabel = vgui.Create("DLabel", appearanceContainer)
    appearanceLabel:SetText(currentLanguage.appearanceLabel)
    appearanceLabel:Dock(LEFT)
    appearanceLabel:DockMargin(10, 0, 10, 0)
    appearanceLabel:SetWidth(120)
    appearanceLabel:SetTextColor(Color(255, 255, 255))

    local appearanceEntry = vgui.Create("DTextEntry", appearanceContainer)
    appearanceEntry:Dock(FILL)
    appearanceEntry:SetTextColor(Color(255, 255, 255))
    appearanceEntry:SetDrawBackground(true)
    appearanceEntry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    local maxAppearanceLength = 60
appearanceEntry.OnTextChanged = function(self)
    local text = self:GetValue()
    if utf8.len(text) > maxAppearanceLength then
        self:SetText(utf8.sub(text, 1, maxAppearanceLength))
        self:SetCaretPos(maxAppearanceLength)
    end
end

    -- Поле ввода для характера
    local characterLabel = vgui.Create("DLabel", characterContainer)
    characterLabel:SetText(currentLanguage.characterLabel)
    characterLabel:Dock(LEFT)
    characterLabel:DockMargin(10, 0, 10, 0)
    characterLabel:SetWidth(120)
    characterLabel:SetTextColor(Color(255, 255, 255))

    local characterEntry = vgui.Create("DTextEntry", characterContainer)
    characterEntry:Dock(FILL)
    characterEntry:SetTextColor(Color(255, 255, 255))
    characterEntry:SetDrawBackground(true)
    characterEntry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    -- Поле ввода для биографии
    local bioLabel = vgui.Create("DLabel", bioContainer)
    bioLabel:SetText(currentLanguage.bioLabel)
    bioLabel:Dock(TOP)
    bioLabel:DockMargin(10, 0, 10, 5)
    bioLabel:SetTextColor(Color(255, 255, 255))
    
    local bioEntry = vgui.Create("DTextEntry", bioContainer)
    bioEntry:SetMultiline(true)
    bioEntry:Dock(FILL)
    bioEntry:SetTextColor(Color(255, 255, 255))
    bioEntry:SetDrawBackground(true)
    bioEntry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
    end

    -- Добавляем кнопку "Сохранить"
    local saveButton = vgui.Create("DButton", characterPanel)
    saveButton:SetText(currentLanguage.saveButtonText)
    saveButton:Dock(BOTTOM)
    saveButton:DockMargin(10, 10, 10, 10)
    saveButton:SetHeight(40)
    saveButton:SetTextColor(Color(255, 255, 255))
    saveButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
    end

-- Функция для сохранения данных персонажа
local function SaveCharacterData()
    characterData.name = nameEntry:GetValue()
    characterData.appearance = appearanceEntry:GetValue()
    characterData.character = characterEntry:GetValue()
    characterData.bio = bioEntry:GetValue()
end

    saveButton.DoClick = function()
        SaveCharacterData()
        local name = nameEntry:GetValue()
        local appearance = appearanceEntry:GetValue()
        local character = characterEntry:GetValue()
        local bio = bioEntry:GetValue()

        net.Start("SaveCharacterInfo")
        net.WriteString(name)
        net.WriteString(appearance)
        net.WriteString(character)
        net.WriteString(bio)
        net.SendToServer()

        chat.AddText("Saved!")
    end

    -- Добавляем панель в PropertySheet
    propertySheet:AddSheet(currentLanguage.Char, characterPanel, "icon16/user.png")


-- Функция для загрузки данных персонажа
local function LoadCharacterData()
    nameEntry:SetText(characterData.name or "")
    appearanceEntry:SetText(characterData.appearance or "")
    characterEntry:SetText(characterData.character or "")
    bioEntry:SetText(characterData.bio or "")
end

    LoadCharacterData()

            -- Создаем панель для вкладки "Настройки"
            local settingsPanel = vgui.Create("DPanel", propertySheet)
            settingsPanel:Dock(FILL)
            settingsPanel:DockPadding(10, 10, 10, 10)
            settingsPanel:SetBackgroundColor(Color(35, 35, 35))
        
            -- Создаем элементы управления для выбора клавиши
local label = vgui.Create("DLabel", settingsPanel)
label:SetText(currentLanguage.KeyEdit)
label:Dock(TOP)
label:SetTextColor(Color(255, 255, 255))
label:DockMargin(0, 0, 0, 10)

local keyPicker = vgui.Create("DBinder", settingsPanel)
keyPicker:Dock(TOP)
keyPicker:SetSize(200, 20)
keyPicker:SetTextColor(Color(255, 255, 255)) -- Это изменение текстового цвета
keyPicker:SetColor(Color(50, 50, 50)) -- Здесь 50, 50, 50 представляют тёмный цвет кнопки

local languageLabel = vgui.Create("DLabel", settingsPanel)
languageLabel:SetText(currentLanguage.ChooseLanguage)
languageLabel:Dock(TOP)
languageLabel:SetTextColor(Color(255, 255, 255))
languageLabel:DockMargin(0, 0, 0, 10)

local languageComboBox = vgui.Create("DComboBox", settingsPanel)
languageComboBox:Dock(TOP)
languageComboBox:SetValue(currentLanguage.Lang)
languageComboBox:AddChoice("Русский")
languageComboBox:AddChoice("English")
languageComboBox:AddChoice("Turkish")
languageComboBox.OnSelect = function(panel, index, value)
    UpdateLanguage(value)
    frame:SetTitle(currentLanguage.menuTitle)
    nameLabel:SetText(currentLanguage.nameLabel)
    appearanceLabel:SetText(currentLanguage.appearanceLabel)
    characterLabel:SetText(currentLanguage.characterLabel)
    bioLabel:SetText(currentLanguage.bioLabel)
    saveButton:SetText(currentLanguage.saveButtonText)
    label:SetText(currentLanguage.KeyEdit)
    languageLabel:SetText(currentLanguage.ChooseLanguage)
    languageComboBox:SetValue(currentLanguage.Lang)
    chat.AddText("Язык изменен на " .. value)

    local language = languageComboBox:GetValue()

    net.Start("SelectedLanguage")
    net.WriteString(language)
    net.SendToServer()

end

-- Устанавливаем значение клавиши
if openMenuKey then
    keyPicker:SetValue(openMenuKey)
else
    keyPicker:SetValue(KEY_F6) -- Значение по умолчанию, если openMenuKey не было инициализировано
end

keyPicker.OnChange = function(self, key)
    openMenuKey = key
    hook.Remove("Think", "OpenMyMenuKeyListener")
    hook.Add("Think", "OpenMyMenuKeyListener", function()
        if input.IsKeyDown(openMenuKey) then
            if not wasKeyDown then
                wasKeyDown = true
                OpenMyMenu()
            end
        else
            wasKeyDown = false
        end
    end)
    chat.AddText("Клавиша для открытия меню изменена на " .. input.GetKeyName(key))
end
        
            -- Добавляем панель в PropertySheet
            propertySheet:AddSheet(currentLanguage.Options, settingsPanel, "icon16/cog.png")

end

local function LoadCharacterData()
    nameEntry:SetValue(characterData.name)
    appearanceEntry:SetValue(characterData.appearance)
    characterEntry:SetValue(characterData.character)
    bioEntry:SetValue(characterData.bio)
end

local function SaveCharacterData()
    characterData.name = nameEntry:GetValue()
    characterData.appearance = appearanceEntry:GetValue()
    characterData.character = characterEntry:GetValue()
    characterData.bio = bioEntry:GetValue()
end

local function UpdateKeyBinding()
    hook.Remove("Think", "OpenMyMenuKeyListener")
    hook.Add("Think", "OpenMyMenuKeyListener", function()
        if input.IsKeyDown(openMenuKey) then
            if not wasKeyDown then
                wasKeyDown = true
                OpenMyMenu()
            end
        else
            wasKeyDown = false
        end
    end)
end

local function SetOpenMenuKey(key)
    openMenuKey = key
    UpdateKeyBinding()
end

-- Определяем кнопку для открытия меню
local openMenuKey = KEY_F6  -- Замени на любую другую клавишу по своему желанию

-- Флаг для отслеживания состояния клавиши
local wasKeyDown = false

-- Хук для отслеживания нажатия клавиши
hook.Add("Think", "OpenMyMenuKeyListener", function()
    if input.IsKeyDown(openMenuKey) then
        if not wasKeyDown then
            wasKeyDown = true
            OpenMyMenu()
        end
    else
        wasKeyDown = false
    end
end)

