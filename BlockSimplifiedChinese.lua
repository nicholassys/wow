local LPName, LPaddon = ...

local function CreateFrameWithBackdrop(frameType, name, parent, template, backdropTemplate)
    local frame = CreateFrame(frameType, name, parent, template)
    Mixin(frame, BackdropTemplateMixin)
    frame:OnBackdropLoaded()
    if backdropTemplate then
        frame:SetBackdrop(backdropTemplate)
    end
    return frame
end

local whisperFrame = CreateFrame("ScrollingMessageFrame", "FilteredWhispersFrame", UIParent)
whisperFrame:SetSize(400, 300)
whisperFrame:SetPoint("CENTER")
whisperFrame = CreateFrameWithBackdrop("ScrollingMessageFrame", "FilteredWhispersFrame", UIParent, nil, {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
whisperFrame:SetFontObject(GameFontNormal)
whisperFrame:SetJustifyH("LEFT")
whisperFrame:SetFading(false)
whisperFrame:SetMaxLines(500)
whisperFrame:EnableMouseWheel(true)
whisperFrame:SetScript("OnMouseWheel", function(self, delta)
    if delta > 0 then
        self:ScrollUp()
    else
        self:ScrollDown()
    end
end)
whisperFrame:Hide()


-- 創建一個配置介面
local optionsPanel = CreateFrame("Frame", LPName.."OptionsPanel", InterfaceOptionsFramePanelContainer)
optionsPanel.name = LPName
optionsPanel:Hide()

-- 創建一個開關按鈕1：檢查消息中是否包含簡體字
local messageToggleButton = CreateFrame("CheckButton", LPName.."MessageToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
messageToggleButton:SetPoint("TOPLEFT", 16, -16)
messageToggleButton.text:SetText("檢查消息中是否包含簡體字     (僅公開頻道、白字、大喊、密語生效)")
messageToggleButton.tooltipText = "啟用或停用檢查聊天訊息中是否包含簡體字"
messageToggleButton:SetScript("OnClick", function(self)
    LPaddon.checkMessage = self:GetChecked()
end)

-- 創建一個開關按鈕2：檢查發送者的名字是否包含簡體字
local senderToggleButton = CreateFrame("CheckButton", LPName.."SenderToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
senderToggleButton:SetPoint("TOPLEFT", 16, -40)
senderToggleButton.text:SetText("檢查發送者的名字是否包含簡體字     (僅公開頻道、白字、大喊、密語生效)")
senderToggleButton.tooltipText = "啟用或停用檢查聊天發送者名稱中是否包含簡體字"
senderToggleButton:SetScript("OnClick", function(self)
    LPaddon.checkSender = self:GetChecked()
end)

-- 创建小地图按鈕
local myButton = CreateFrame("Button", "MyAddonButton", Minimap)
myButton:SetSize(25, 25)
myButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
myButton:SetFrameStrata("LOW")
myButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
myButton:SetNormalTexture("Interface\\Icons\\inv_misc_bomb_04")
myButton:SetPushedTexture("Interface\\Icons\\inv_misc_bomb_04")
myButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

-- 創建一個開關按鈕3：顯示或隱藏小地圖按鈕
local toggleButton = CreateFrame("CheckButton", LPName.."ToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
toggleButton:SetPoint("TOPLEFT", 16, -64)
toggleButton.text:SetText("顯示小地圖按鈕")
toggleButton.tooltipText = "啟用或停用簡體過濾小地圖按鈕"
toggleButton:SetScript("OnClick", function(self)
    LPaddon.showButton = self:GetChecked()
    LP_DB.showButton = self:GetChecked()
    if self:GetChecked() then
        myButton:Show()
    else
        myButton:Hide()
    end
end)

-- 创建一个开关按钮4：副本内不启用过滤
local disableInInstanceToggleButton = CreateFrame("CheckButton", LPName.."DisableInInstanceToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
disableInInstanceToggleButton:SetPoint("TOPLEFT", 16, -88)
disableInInstanceToggleButton.text:SetText("當玩家處於副本、團隊、場景戰役、競技場、戰場不啟用過濾")
disableInInstanceToggleButton.tooltipText = "启用或停用在副本中禁用过滤的功能"
disableInInstanceToggleButton:SetScript("OnClick", function(self)
    LPaddon.disableInInstance = self:GetChecked()
    LP_DB.disableInInstance = self:GetChecked()
end)

-- 註冊 GUI 選項
InterfaceOptions_AddCategory(optionsPanel)


-- 命令處理函數
SlashCmdList[LPName] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
end

-- 註冊命令
SLASH_BlockSimplifiedChinese1 = "/"..LPName
SLASH_BlockSimplifiedChinese2 = "/BSC"
SlashCmdList[LPName] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
end

-- 過濾函數
local function filter(self, event, msg, sender)
    if not (LPaddon.checkMessage or LPaddon.checkSender) then
        return
    end
    
    -- 检查玩家是否在副本中
    local inInstance, instanceType = IsInInstance()
    if LPaddon.disableInInstance and inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario" or instanceType == "arena" or instanceType == "pvp") then
        return
    end
    
    local lowercase_message = msg:lower()
    local lowercase_name = sender:lower()
    
if event == "CHAT_MSG_WHISPER" then
    if LPaddon.checkMessage then
        for word in pairs(LPaddon.filterWords) do
            if string.find(lowercase_message, word) then
                table.insert(LPaddon.filteredWhispers, {msg, sender})
                myButton:SetNormalTexture("Interface\\Icons\\inv_misc_note_04")
                return true
            end
        end
    end

if LPaddon.checkSender then
            for word in pairs(LPaddon.filterWords) do
                if string.find(lowercase_name, word) then
                    table.insert(LPaddon.filteredWhispers, {msg, sender})
                    myButton:SetNormalTexture("Interface\\Icons\\inv_misc_note_04")
                    return true
                end
            end
        end
    end 
end


-- 创建一个函数用于初始化按钮状态
local function InitializeButtonStatus()
    toggleButton:SetChecked(LP_DB.showButton)
    if LP_DB.showButton then
        myButton:Show()
    else
        myButton:Hide()
    end
end

local function OnLoad(self, event, ...)
    -- 初始化 SavedVariables
    if not LP_DB then
        LP_DB = {}
        LP_DB.enabled = true
        LP_DB.checkSender = false
        LP_DB.showButton = true
        LP_DB.disableInInstance = true
    end

    -- 載入 SavedVariables 中的設定
    LPaddon.checkMessage = LP_DB.enabled
    LPaddon.checkSender = LP_DB.checkSender
    LPaddon.showButton = LP_DB.showButton
    LPaddon.disableInInstance = LP_DB.disableInInstance

    -- 更新配置介面的開關狀態
    messageToggleButton:SetChecked(LPaddon.checkMessage)
    senderToggleButton:SetChecked(LPaddon.checkSender)
    disableInInstanceToggleButton:SetChecked(LPaddon.disableInInstance)

    -- 在此處調用初始化按鈕狀態的函數
    InitializeButtonStatus()

    print("歡迎使用簡體過濾,輸入/bsc 或者 ESC→選項→插件 打開設定")
end

-- 保存插件設定時執行的函數
local function OnSave(self, event, ...)
    -- 保存設定到 SavedVariables
    LP_DB.enabled = LPaddon.checkMessage
    LP_DB.checkSender = LPaddon.checkSender
    LP_DB.showButton = LPaddon.showButton  
    LP_DB.disableInInstance = LPaddon.disableInInstance
end

-- 註冊事件
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

-- 設定事件處理函數
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == LPName then
            OnLoad(self, event, ...)
        end
    elseif event == "PLAYER_LOGOUT" then
        OnSave(self, event, ...)
    end
end)

-- 初始化
LPaddon = {
    checkMessage = true,
    checkSender = true,
    showButton = true,
    filterWords = {},
    filteredWhispers = {},
}

-- 添加要過濾的簡體字
local function addWords(words)
    for word in string.gmatch(words, "[^%s,]+") do
        LPaddon.filterWords[word] = true
    end
end

-- 调用 addWords 函数添加关键字
addWords("猫,枭")

-- 註冊事件
local events = {
"CHAT_MSG_SAY",
"CHAT_MSG_YELL",
"CHAT_MSG_CHANNEL",
"CHAT_MSG_EMOTE",
"CHAT_MSG_WHISPER",
}

for _, v in pairs(events) do
ChatFrame_AddMessageEventFilter(v, filter)
end

-- 開啟拖動功能
myButton:SetMovable(true)
myButton:EnableMouse(true)
myButton:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)
myButton:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()
    end
end)

myButton:SetScript("OnClick", function(self, button, down)
    if button == "LeftButton" then
        if whisperFrameShown then
            whisperFrame:Hide()
            whisperFrameShown = false
            for _, whisper in ipairs(LPaddon.filteredWhispers) do
                whisperFrame:RemoveMessage(whisper[1])
            end
            LPaddon.filteredWhispers = {}
            myButton:SetNormalTexture("Interface\\Icons\\inv_misc_bomb_04")
        else
            for _, whisper in ipairs(LPaddon.filteredWhispers) do
                whisperFrame:AddMessage("|cffffd100" .. whisper[2] .. ":|r " .. whisper[1])
            end
            whisperFrame:Show()
            whisperFrameShown = true
        end
    elseif button == "RightButton" then
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    end
end)


myButton.tooltip = "簡體過濾"
myButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:AddLine(self.tooltip)
    GameTooltip:Show()
end)
myButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)





