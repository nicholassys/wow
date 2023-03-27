local LPName, LPaddon = ...

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
LPaddon.showButton = LP_DB.showButton
LPaddon.disableInInstance = LP_DB.disableInInstance

-- 更新配置介面的按鈕狀態
messageToggleButton:SetChecked(LPaddon.checkMessage)
senderToggleButton:SetChecked(LPaddon.checkSender)
toggleButton:SetChecked(LPaddon.showButton)
disableInInstanceToggleButton:SetChecked(LPaddon.disableInInstance)

-- 註冊事件
self:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 初始化小地圖按鈕狀態
InitializeButtonStatus()

-- 聊天過濾
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
end

local function OnEvent(self, event, ...)
if event == "PLAYER_ENTERING_WORLD" then
-- 刷新按鈕狀態
InitializeButtonStatus()
end
end

-- 注册事件处理器
optionsPanel:SetScript("OnEvent", OnEvent)
optionsPanel:RegisterEvent("ADDON_LOADED")

-- 設定小地圖按鈕點擊事件
myButton:SetScript("OnClick", function(self, button)
if button == "LeftButton" then
InterfaceOptionsFrame_OpenToCategory(optionsPanel)
InterfaceOptionsFrame_OpenToCategory(optionsPanel)
elseif button == "RightButton" then
LPaddon.checkMessage = not LPaddon.checkMessage
LP_DB.enabled = LPaddon.checkMessage
messageToggleButton:SetChecked(LPaddon.checkMessage)
end
end)

-- 設定小地圖按鈕的懸停提示
myButton:SetScript("OnEnter", function(self)
GameTooltip:SetOwner(self, "ANCHOR_LEFT")
GameTooltip:AddLine("魔獸世界過濾簡體字插件", 1, 1, 1)
GameTooltip:AddLine("左鍵：打開設置界面", 0.5, 0.5, 0.5)
GameTooltip:AddLine("右鍵：開/關過濾", 0.5, 0.5, 0.5)
GameTooltip:Show()
end)
myButton:SetScript("OnLeave", function(self)
GameTooltip:Hide()
end)

