local LPName, LPaddon = ...

-- 在此處添加全局變量
local blockedWhispers = {}

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

if LPaddon.checkMessage then
    for word in pairs(LPaddon.filterWords) do
        if string.find(lowercase_message, word) then
            return true
        end
    end
end

if LPaddon.checkSender then
    for word in pairs(LPaddon.filterWords) do
        if string.find(lowercase_name, word) then
            return true
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
LPaddon.showButton= LP_DB.showButton
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
InterfaceOptionsFrame_OpenToCategory(optionsPanel)
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

-- 添加顯示被過濾的耳語功能

-- 初始化被過濾的耳語存儲
LPaddon.filteredWhispers = {}

-- 新建一個顯示被過濾耳語的框體
local filteredWhispersFrame = CreateFrame("Frame", "FilteredWhispersFrame", UIParent, "BasicFrameTemplateWithInset")
filteredWhispersFrame:SetSize(350, 400)
filteredWhispersFrame:SetPoint("CENTER")
filteredWhispersFrame:SetMovable(true)
filteredWhispersFrame:EnableMouse(true)
filteredWhispersFrame:RegisterForDrag("LeftButton")
filteredWhispersFrame:SetScript("OnDragStart", filteredWhispersFrame.StartMoving)
filteredWhispersFrame:SetScript("OnDragStop", filteredWhispersFrame.StopMovingOrSizing)
filteredWhispersFrame:Hide()

-- 添加標題
filteredWhispersFrame.Title = filteredWhispersFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
filteredWhispersFrame.Title:SetPoint("CENTER", filteredWhispersFrame.TitleBg, "CENTER", 0, 0)
filteredWhispersFrame.Title:SetText("被過濾的耳語")

-- 添加滾動區域
local whispersScrollArea = CreateFrame("ScrollFrame", nil, filteredWhispersFrame, "UIPanelScrollFrameTemplate")
whispersScrollArea:SetSize(300, 300)
whispersScrollArea:SetPoint("CENTER", filteredWhispersFrame, "CENTER", 0, -10)

-- 添加滾動區域的內容框
local whispersScrollContent = CreateFrame("Frame", nil, whispersScrollArea)
whispersScrollContent:SetSize(300, 300)
whispersScrollArea:SetScrollChild(whispersScrollContent)

-- 設置添加被過濾的耳語的函數
local function AddFilteredWhisper(sender, msg)
table.insert(LPaddon.filteredWhispers, {sender = sender, msg = msg})
local filteredWhisperText = whispersScrollContent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
filteredWhisperText:SetPoint("TOPLEFT", whispersScrollContent, "TOPLEFT", 0, -10 - (#LPaddon.filteredWhispers - 1) * 20)
filteredWhisperText:SetText(sender .. ": " .. msg)
end

-- 修改過濾函數以保存被過濾的耳語
local function filter(self, event, msg, sender)
-- ...其他原始過濾函數代碼...

if LPaddon.checkSender then
    for word in pairs(LPaddon.filterWords) do
        if string.find(lowercase_name, word) then
            if event == "CHAT_MSG_WHISPER" then
                AddFilteredWhisper(sender, msg)
            end
            return true
        end
    end
end
end

-- 在耳語框創建一個圖標
local whisperIcon = CreateFrame("Button", "WhisperIcon", ChatFrame1)
whisperIcon:SetSize(18, 18)
whisperIcon:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", -35, -5)
whisperIcon:SetNormalTexture("Interface\Icons\inv_misc_note_06")
whisperIcon:SetHighlightTexture("Interface\Buttons\ButtonHilight-Square")
whisperIcon:SetScript("OnClick", function()
if filteredWhispersFrame:IsVisible() then
    filteredWhispersFrame:Hide()
else
    filteredWhispersFrame:Show()
end
end)

-- 圖標提示
whisperIcon.tooltipText = "顯示被過濾的耳語"
whisperIcon:SetScript("OnEnter", function(self)
GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
GameTooltip:AddLine(self.tooltipText)
GameTooltip:Show()
end)
whisperIcon:SetScript("OnLeave", function(self)
GameTooltip:Hide()
end)

-- 添加一個關閉按鈕到被過濾耳語框
local closeFilteredWhispersButton = CreateFrame("Button", nil, filteredWhispersFrame, "UIPanelCloseButton")
closeFilteredWhispersButton:SetPoint("TOPRIGHT", filteredWhispersFrame, "TOPRIGHT", -6, -6)
closeFilteredWhispersButton:SetScript("OnClick", function()
filteredWhispersFrame:Hide()
end)

