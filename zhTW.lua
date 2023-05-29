if (GetLocale() ~= "zhTW") then
  return
end

local LPName, LPaddon = ...
local optionsPanel = CreateFrame("Frame", LPName.."OptionsPanel", InterfaceOptionsFramePanelContainer)
optionsPanel.name = LPName
optionsPanel:Hide()
local strangerGroupToggleButton = CreateFrame("CheckButton", LPName.."StrangerGroupToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
strangerGroupToggleButton:SetPoint("TOPLEFT", 16, -360)
strangerGroupToggleButton.Text:SetText("拒絕所有陌生組隊邀請     (限公會、社群、好友、密語對象邀請)")
strangerGroupToggleButton:SetScript("OnClick", function(self)
LPaddon.strangerGroupEnabled = self:GetChecked()
end)

--"聊天過濾功能和他的分隔線
local function CreateSeparator(parent, xOffset, yOffset, width, height)
    local separator = parent:CreateTexture(nil, "OVERLAY")
    separator:SetSize(width, height)
    separator:SetColorTexture(0.8, 0.8, 0.8, 1)
    separator:SetPoint("TOPLEFT", xOffset, -yOffset)
   return separator
end
local filterSeparator = CreateSeparator(optionsPanel, 600, 36, optionsPanel:GetWidth() - 200, 1)
local filterSeparator = CreateSeparator(optionsPanel, 221, 36, optionsPanel:GetWidth() - 200, 1)
local filterTitle = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
filterTitle:SetPoint("TOPLEFT", 258, -28)
filterTitle:SetText("聊天過濾功能")

local messageToggleButton = CreateFrame("CheckButton", LPName.."MessageToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
messageToggleButton:SetPoint("TOPLEFT", 16, -44)
messageToggleButton.Text:SetText("隱藏任何包含簡體字的訊息     (只有頻道、說、大喊、耳語生效)")
messageToggleButton:SetScript("OnClick", function(self)
    LPaddon.checkMessage = self:GetChecked()
end)

local senderToggleButton = CreateFrame("CheckButton", LPName.."SenderToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
senderToggleButton:SetPoint("TOPLEFT", 16, -66)
senderToggleButton.Text:SetText("隱藏角色名稱含有簡體字的玩家訊息     (只有頻道、說、大喊、耳語生效)")
senderToggleButton:SetScript("OnClick", function(self)
    LPaddon.checkSender = self:GetChecked()
end)

local myButton = CreateFrame("Button", "MyAddonButton", Minimap)
myButton:SetSize(25, 25)
myButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
myButton:SetFrameStrata("LOW")
myButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
myButton:SetNormalTexture("Interface\\Icons\\inv_misc_bomb_04")
myButton:SetPushedTexture("Interface\\Icons\\inv_misc_bomb_04")
myButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
local toggleButton = CreateFrame("CheckButton", LPName.."ToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
toggleButton:SetPoint("TOPLEFT", 16, -5)
toggleButton.Text:SetText("顯示小地圖按鈕")
toggleButton:SetScript("OnClick", function(self)
    LPaddon.showButton = self:GetChecked()
    LP_DB.showButton = self:GetChecked()
    if self:GetChecked() then
        myButton:Show()
    else
        myButton:Hide()
    end
end)

local disableInInstanceToggleButton = CreateFrame("CheckButton", LPName.."DisableInInstanceToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
disableInInstanceToggleButton:SetPoint("TOPLEFT", 16, -88)
disableInInstanceToggleButton.Text:SetText("當玩家處於副本、戰場、競技場時，自動關閉訊息過濾")
disableInInstanceToggleButton:SetScript("OnClick", function(self)
    LPaddon.disableInInstance = self:GetChecked()
    LP_DB.disableInInstance = self:GetChecked()
end)

local declineInviteToggleButton = CreateFrame("CheckButton", LPName.."DeclineInviteToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
declineInviteToggleButton:SetPoint("TOPLEFT", 16, -380)
declineInviteToggleButton.Text:SetText("自訂:     拒絕角色名稱包含以下自訂詞的玩家邀請")
declineInviteToggleButton:SetScript("OnClick", function(self)
    LPaddon.declineInvite = self:GetChecked()
    LP_DB.declineInvite = self:GetChecked()
end)

local wordsScrollFrame = CreateFrame("ScrollFrame", nil, optionsPanel, "UIPanelScrollFrameTemplate")
wordsScrollFrame:SetSize(280, 110)
wordsScrollFrame:SetPoint("TOPLEFT", 40, -408)
local wordsBackground = optionsPanel:CreateTexture(nil, "BACKGROUND")
wordsBackground:SetColorTexture(0, 0, 0, 0.5)
wordsBackground:SetSize(304, 115)
wordsBackground:SetPoint("TOPLEFT", 40, -404)
local wordsEditBox = CreateFrame("EditBox", nil, wordsScrollFrame)
wordsEditBox:SetMultiLine(true)
wordsEditBox:SetSize(280, 110)
wordsEditBox:SetFontObject(ChatFontNormal)
wordsEditBox:SetAutoFocus(false)
wordsEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
wordsScrollFrame:SetScrollChild(wordsEditBox)
local function DisplayAdIds()
    local words = ""
    for _, adId in ipairs(LPaddon.adIdList) do
        words = words .. adId .. ", "
    end
    words = words:sub(1, -3) 
    wordsEditBox:SetText(words)
end
addAdIdEditBox = CreateFrame("EditBox", nil, optionsPanel)
addAdIdEditBox:SetSize(216, 20)
addAdIdEditBox:SetPoint("TOPLEFT", 40, -521)
addAdIdEditBox:SetFontObject(ChatFontNormal)
addAdIdEditBox:SetAutoFocus(false)
addAdIdEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
local addAdIdEditBoxBackground = addAdIdEditBox:CreateTexture(nil, "BACKGROUND")
addAdIdEditBoxBackground:SetAllPoints(addAdIdEditBox)
addAdIdEditBoxBackground:SetColorTexture(0, 0, 0, 0.5)
local addAdIdLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
addAdIdLabel:SetPoint("BOTTOMLEFT", addAdIdEditBox, "TOPLEFT", 0, 4)
local addButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
addButton:SetPoint("LEFT", addAdIdEditBox, "RIGHT", 3, 0)
addButton:SetSize(86, 25)
addButton:SetText("添加\\刪除")
addButton:SetScript("OnClick", function(self)
    local newAdId = addAdIdEditBox:GetText()
    ToggleAdId(newAdId)
    addAdIdEditBox:SetText("")
end)
local function CreateSeparator(parent, xOffset, yOffset, width, height)
    local separator = parent:CreateTexture(nil, "OVERLAY")
    separator:SetSize(width, height)
    separator:SetColorTexture(0.8, 0.8, 0.8, 1)
    separator:SetPoint("TOPLEFT", xOffset, -yOffset)
   return separator
end

--組隊邀請功能和他的分隔線
local filterSeparator = CreateSeparator(optionsPanel, 600, 310, optionsPanel:GetWidth() - 200, 1)
local filterSeparator = CreateSeparator(optionsPanel, 221, 310, optionsPanel:GetWidth() - 200, 1)
local filterTitle = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
filterTitle:SetPoint("TOPLEFT", 258, -302)
filterTitle:SetText("組隊邀請功能")

local declineSimplifiedChineseToggleButton = CreateFrame("CheckButton", LPName.."DeclineSimplifiedChineseToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
declineSimplifiedChineseToggleButton:SetPoint("TOPLEFT", 16, -317)
declineSimplifiedChineseToggleButton.Text:SetText("拒絕名稱含簡體字的玩家組隊邀請")
declineSimplifiedChineseToggleButton:SetScript("OnClick", function(self)
    LPaddon.declineSimplifiedChinese = self:GetChecked()
    LP_DB.declineSimplifiedChinese = self:GetChecked()
end)
local declineBladeOfKrolToggleButton = CreateFrame("CheckButton", LPName.."DeclineBladeOfKrolToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
declineBladeOfKrolToggleButton:SetPoint("TOPLEFT", 16, -339)
declineBladeOfKrolToggleButton.Text:SetText("拒絕所有克羅之刃的玩家組隊邀請")
declineBladeOfKrolToggleButton:SetScript("OnClick", function(self)
    LPaddon.declineBladeOfKrol = self:GetChecked()
    LP_DB.declineBladeOfKrol = self:GetChecked()
end)
local function toggleKeyword(keyword)
    if LPaddon.customFilterWords[keyword] then
        LPaddon.customFilterWords[keyword] = nil
    else
        LPaddon.customFilterWords[keyword] = true
    end
end
local customFilterToggleButton = CreateFrame("CheckButton", LPName.."CustomFilterToggleButton", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
customFilterToggleButton:SetPoint("TOPLEFT", 16, -110)
customFilterToggleButton.Text:SetText("自訂:     隱藏包含以下關鍵字的訊息")
customFilterToggleButton:SetScript("OnClick", function(self)
    LPaddon.customFilter = self:GetChecked()
    LP_DB.customFilter = self:GetChecked()
end)
local customKeywordsScrollFrame = CreateFrame("ScrollFrame", nil, optionsPanel, "UIPanelScrollFrameTemplate")
customKeywordsScrollFrame:SetSize(280, 110)
customKeywordsScrollFrame:SetPoint("TOPLEFT", 40, -137)
local customKeywordsBackground = optionsPanel:CreateTexture(nil, "BACKGROUND")
customKeywordsBackground:SetColorTexture(0, 0, 0, 0.5)
customKeywordsBackground:SetSize(304, 115)
customKeywordsBackground:SetPoint("TOPLEFT", 40, -134)
local customKeywordsEditBox = CreateFrame("EditBox", nil, customKeywordsScrollFrame)
customKeywordsEditBox:SetMultiLine(true)
customKeywordsEditBox:SetSize(280, 100)
customKeywordsEditBox:SetFontObject(ChatFontNormal)
customKeywordsEditBox:SetAutoFocus(false)
customKeywordsEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
customKeywordsScrollFrame:SetScrollChild(customKeywordsEditBox)
local function DisplayCustomKeywords()
    local keywords = ""
    for keyword in pairs(LPaddon.customFilterWords) do
        keywords = keywords .. keyword .. ", "
    end
    keywords = keywords:sub(1, -3)
    customKeywordsEditBox:SetText(keywords)
end
optionsPanel:SetScript("OnShow", function()
    DisplayCustomKeywords()
end)
local newKeywordEditBox = CreateFrame("EditBox", nil, optionsPanel)
newKeywordEditBox:SetSize(216, 20)
newKeywordEditBox:SetPoint("TOPLEFT", 40, -251)
newKeywordEditBox:SetFontObject(ChatFontNormal)
newKeywordEditBox:SetAutoFocus(false)
newKeywordEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
local addKeywordButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
addKeywordButton:SetSize(88	, 23)
addKeywordButton:SetPoint("LEFT", newKeywordEditBox, "RIGHT", 2, 0)
addKeywordButton:SetText("添加\\刪除")
addKeywordButton:SetScript("OnClick", function()
    local newKeyword = newKeywordEditBox:GetText()
    if newKeyword and newKeyword ~= "" then
        toggleKeyWord(newKeyword)
        LP_DB.customFilterWords = LPaddon.customFilterWords
        newKeywordEditBox:SetText("")
        newKeywordEditBox:ClearFocus()
        DisplayCustomKeywords()
    end
end)
local editBoxBackground = newKeywordEditBox:CreateTexture(nil, "BACKGROUND")
editBoxBackground:SetAllPoints(newKeywordEditBox)
editBoxBackground:SetColorTexture(0, 0, 0, 0.5)
InterfaceOptions_AddCategory(optionsPanel)
SlashCmdList[LPName] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
end
SLASH_BlockMessageTeamGuard1 = "/"..LPName
SLASH_BlockMessageTeamGuard2 = "/BSC"
SlashCmdList[LPName] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
end

local whisperWithKeyword = {}
local chatBubbleSenders = {}

local function filter(self, event, msg, sender)
    if not (LPaddon.checkMessage or LPaddon.checkSender or LPaddon.customFilter) then
        return
    end
    local inInstance, instanceType = IsInInstance()
    if LPaddon.disableInInstance and inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario" or instanceType == "arena" or instanceType == "pvp") then
        return
    end
    local lowercase_message = msg:lower()
    local lowercase_name = sender:lower()

    local close_chat_frame = function()
        if strsub(event, 10) == 'WHISPER' then
            for frameIndex = 2, #CHAT_FRAMES do
                local currentChatFrame = _G[CHAT_FRAMES[frameIndex]]
                if currentChatFrame.name == sender then
                    FCF_Close(currentChatFrame)
                    break
                end
            end
        end
    end

    local isFiltered = false

    if LPaddon.checkMessage then
        for word in pairs(LPaddon.filterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_message, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end
    if not isFiltered and LPaddon.customFilter then
        for word in pairs(LPaddon.customFilterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_message, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end
    if not isFiltered and LPaddon.checkSender then
        for word in pairs(LPaddon.filterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_name, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end

    if isFiltered then
        if whisperWithKeyword[sender] == nil then
            whisperWithKeyword[sender] = true
            close_chat_frame()
        elseif whisperWithKeyword[sender] then
            close_chat_frame()
        end
    else
        whisperWithKeyword[sender] = false
    end

    return isFiltered
end

local function ShouldHideChatBubble(text, sender)
    local isFiltered = false
    local lowercase_text = text:lower()

    if LPaddon.checkMessage then
        for word in pairs(LPaddon.filterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_text, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end

    if not isFiltered and LPaddon.customFilter then
        for word in pairs(LPaddon.customFilterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_text, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end

    if not isFiltered and LPaddon.checkSender and sender then
        local lowercase_sender = sender:lower()
        for word in pairs(LPaddon.filterWords) do
            local lowercase_word = word:lower()
            if string.find(lowercase_sender, lowercase_word) then
                isFiltered = true
                break
            end
        end
    end

    return isFiltered
end

local function HideWChatBubbles(sender)
    for i, chatBubble in ipairs(C_ChatBubbles.GetAllChatBubbles()) do
        local frame = chatBubble:GetChildren()
        if frame then
            local fontString = frame:GetRegions()
            if fontString then
                local text = fontString:GetText()
                if sender then
                    chatBubbleSenders[fontString] = sender
                end
                if ShouldHideChatBubble(text, chatBubbleSenders[fontString]) then
                    frame:Hide()
                else
                    frame:Show()
                end
            end
        end
    end
end

local function OnEvent(self, event, ...)
    local msg, sender = ...
    if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" then
        C_Timer.After(0.01, function()
            HideWChatBubbles(sender)
        end)
    end
end

local chatBubbleFrame = CreateFrame("Frame")
chatBubbleFrame:RegisterEvent("CHAT_MSG_SAY")
chatBubbleFrame:RegisterEvent("CHAT_MSG_YELL")
chatBubbleFrame:SetScript("OnEvent", OnEvent)

local function InitializeButtonStatus()
    toggleButton:SetChecked(LP_DB.showButton)
    if LP_DB.showButton then
        myButton:Show()
    else
        myButton:Hide()
    end
end
local function OnLoad(self, event, ...)
    if not LP_DB then
        LP_DB = {}
        LP_DB.enabled = false
        LP_DB.checkSender = false
        LP_DB.showButton = true
        LP_DB.disableInInstance = true
        LP_DB.declineInvite = true
        LP_DB.customFilterWords = {}
    end
    if not LP_DB.adIdList or #LP_DB.adIdList == 0 then
        LP_DB.adIdList = LPaddon.defaultAdIdList
    end
    LPaddon.adIdList = LP_DB.adIdList
    DisplayAdIds()
    LPaddon.checkMessage = LP_DB.enabled
    LPaddon.checkSender = LP_DB.checkSender
    LPaddon.showButton = LP_DB.showButton
    LPaddon.disableInInstance = LP_DB.disableInInstance
    LPaddon.declineInvite = LP_DB.declineInvite or false
    LPaddon.declineSimplifiedChinese = LP_DB.declineSimplifiedChinese or false
    LPaddon.declineBladeOfKrol = LP_DB.declineBladeOfKrol or false
    LPaddon.customFilter = LP_DB.customFilter == nil and true or LP_DB.customFilter
    LPaddon.strangerGroupEnabled = LP_DB.strangerGroupEnabled == nil and true or LP_DB.strangerGroupEnabled
    if not LP_DB.customFilterWords or next(LP_DB.customFilterWords) == nil then
    LP_DB.customFilterWords = {["包赔"] = true, ["站桩"] = true, ["零封号"] = true, ["包团"] = true, ["散拍"] = true, ["快速到滿級"] = true, ["自己上随时打"] = true, ["来消费"] = true, ["淘宝"] = true, ["淘 宝"] = true, ["现在有团"] = true, ["为您服务"] = true, ["装备全送"] = true, ["同甲低保"] = true, ["免費送低保"] = true, ["掏宝"] = true, ["淘寶"] = true, ["自己上号"] = true, ["安全效率"] = true, ["送低保"] = true, ["上号躺"] = true, ["消費團本"] = true, ["满级即可参加"] = true}
end
    LPaddon.customFilterWords = LP_DB.customFilterWords    
    customFilterToggleButton:SetChecked(LPaddon.customFilter)
    declineBladeOfKrolToggleButton:SetChecked(LPaddon.declineBladeOfKrol)
    declineSimplifiedChineseToggleButton:SetChecked(LPaddon.declineSimplifiedChinese)
    messageToggleButton:SetChecked(LPaddon.checkMessage)
    senderToggleButton:SetChecked(LPaddon.checkSender)
    strangerGroupToggleButton:SetChecked(LPaddon.strangerGroupEnabled)
    disableInInstanceToggleButton:SetChecked(LPaddon.disableInInstance)
    declineInviteToggleButton:SetChecked(LP_DB.declineInvite)
    InitializeButtonStatus()
    print("BlockMessageV1.4已載入,輸入/bsc設定.")
end
local function OnSave(self, event, ...)
    LP_DB.enabled = LPaddon.checkMessage
    LP_DB.checkSender = LPaddon.checkSender
    LP_DB.showButton = LPaddon.showButton  
    LP_DB.disableInInstance = LPaddon.disableInInstance
    LP_DB.declineSimplifiedChinese = LPaddon.declineSimplifiedChinese
    LP_DB.declineInvite = LPaddon.declineInvite
    LP_DB.customFilter = LPaddon.customFilter
    LP_DB.customFilterWords = LPaddon.customFilterWords
    LP_DB.adIdList = LPaddon.adIdList
    LP_DB.strangerGroupEnabled = LPaddon.strangerGroupEnabled
end
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:RegisterEvent("PARTY_INVITE_REQUEST")
eventFrame:RegisterEvent("GROUP_INVITE_CONFIRMATION")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == LPName then
            OnLoad(self, event, ...)
        end
    elseif event == "PLAYER_LOGOUT" then
        OnSave(self, event, ...)
    elseif event == "PARTY_INVITE_REQUEST" then
        local sender = ...
        OnPartyInviteRequest(self, event, sender)
    elseif event == "GROUP_INVITE_CONFIRMATION" then
        local guid = GetNextPendingInviteConfirmation()
        local _, sender = GetInviteConfirmationInfo(guid)
        local declined = false
        local lowercase_sender = string.lower(sender)

if not declined and LPaddon.declineSimplifiedChinese then
    for word in pairs(LPaddon.filterWords) do
        if string.find(lowercase_sender, word) then
            RespondToInviteConfirmation(guid, false)
            StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
            declined = true
            break
        end
    end
end
        if not declined and LPaddon.declineBladeOfKrol then
            if string.find(lowercase_sender, "克羅之刃") then
                RespondToInviteConfirmation(guid, false)
                StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
                declined = true
            end
        end

        if not declined and LPaddon.declineInvite then
            for _, adId in ipairs(LPaddon.adIdList) do
                if string.find(lowercase_sender, adId) then
                    RespondToInviteConfirmation(guid, false)
                    StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
                    declined = true
                    break
                end
            end
        end

            if not declined then
        if isInviteAllowed(sender) then
            UnmuteSoundFile(567451)
            PlaySoundFile(567451)
            MuteSoundFile(567451)
        end
    end
    end
end)


LPaddon = {
    checkMessage = false,
    checkSender = true,
    showButton = true,
    strangerGroupEnabled = true,
    filterWords = {},
    filterNames = {},
    declineSimplifiedChinese = false,
    customFilter = true,
    customFilterWords = {},
    adIdList = {},
    defaultAdIdList = {"满级", "消费", "小时", "站桩", "微信", "来看看", "小莳", "毕业", "史诗", "有团", "装备", "提升", "找我", "到满", "升满", "马上", "开团", "喊我", "团本", "团队", "副本", "大米"},
}
function AddAdId(adId)
    if not LPaddon.adIdList then
        LPaddon.adIdList = {}
    end
    adId = adId:lower()
    local adIdExists = false
    for _, existingAdId in ipairs(LPaddon.adIdList) do
        if existingAdId == adId then
            adIdExists = true
            break
        end
    end
    if not adIdExists then
        table.insert(LPaddon.adIdList, adId)
        LP_DB.adIdList = LPaddon.adIdList
    end
end

addButton:SetScript("OnClick", function()
    local adId = addAdIdEditBox:GetText()
    AddAdId(adId)
    addAdIdEditBox:SetText("")
    DisplayAdIds()
end)

local function addWords(words)
    for word in string.gmatch(words, "[^%s,]+") do
        LPaddon.filterWords[word] = true
    end
end
addWords("装,册")
local function ToggleAdId(newAdId)
    if newAdId ~= "" then
        newAdId = newAdId:lower()
        local foundIndex = nil
        for index, adId in ipairs(LPaddon.adIdList) do
            if adId:lower() == newAdId:lower() then
                foundIndex = index
                break
            end
        end
        if foundIndex then
            table.remove(LPaddon.adIdList, foundIndex)
        else
            table.insert(LPaddon.adIdList, newAdId)
        end

        DisplayAdIds()
    end
end
addButton:SetScript("OnClick", function(self)
    local newAdId = addAdIdEditBox:GetText()
    ToggleAdId(newAdId)
    addAdIdEditBox:SetText("")
end)
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
function OnPartyInviteRequest(self, event, sender)
    local declined = false
    local lowercase_sender = sender:lower()
    
    if not declined and LPaddon.declineSimplifiedChinese then
        for word in pairs(LPaddon.filterWords) do
            if string.find(lowercase_sender, word) then
                DeclineGroup()
                StaticPopup_Hide("PARTY_INVITE")
                declined = true
                break
            end
        end
    end
    if not declined and LPaddon.declineBladeOfKrol then
        if string.find(lowercase_sender, "克羅之刃") then
            DeclineGroup()
            StaticPopup_Hide("PARTY_INVITE")
            declined = true
        end
    end
    if not declined and LPaddon.declineInvite then
        for _, adId in ipairs(LPaddon.adIdList) do
            if string.find(lowercase_sender, adId) then
                DeclineGroup()
                StaticPopup_Hide("PARTY_INVITE")
                declined = true
                break
            end
        end
    end

        if not declined then
        if isInviteAllowed(sender) then
        UnmuteSoundFile(567451)
        PlaySoundFile(567451)
        MuteSoundFile(567451)
    end
    end
end

function toggleKeyWord(word)
    if LPaddon.customFilterWords[word] then
        LPaddon.customFilterWords[word] = nil
    else
        LPaddon.customFilterWords[word] = true
    end
end
local function addKeyWords(words)
    words = words or ""
    for word in string.gmatch(words, "[^%s,]+") do
        toggleKeyWord(word)
    end
end
addKeyWords()

local function MyAddon_OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        MuteSoundFile(567464)
        MuteSoundFile(567490)
        MuteSoundFile(567451)
    end
end

local MyAddon = CreateFrame("Frame")
MyAddon:RegisterEvent("PLAYER_LOGIN")
MyAddon:SetScript("OnEvent", MyAddon_OnEvent)
local function StrPartition(inputStr, delimiter)
local outcome = {}
local start = 1
local delimStart, delimEnd = string.find(inputStr, delimiter, start)
while delimStart do
table.insert(outcome, string.sub(inputStr, start, delimStart - 1))
start = delimEnd + 1
delimStart, delimEnd = string.find(inputStr, delimiter, start)
end
table.insert(outcome, string.sub(inputStr, start))
return outcome
end
local whisperedUsers = {}
local allowedUsers = {}
local function RefreshAllowedUsers()
    local userList = {}
    allowedUsers = userList
    for i = 1, BNGetNumFriends() do 
        local friendData = C_BattleNet.GetFriendAccountInfo(i)
        local friendName = friendData and friendData.gameAccountInfo and friendData.gameAccountInfo.characterName
        if friendName and #friendName > 0 then 
            userList[StrPartition(friendName, '-')[1]] = true 
        end
    end
    for i = 1, C_FriendList.GetNumFriends() do
        local userInfo = C_FriendList.GetFriendInfoByIndex(i)
        if userInfo.name and #userInfo.name > 0 then
            userList[StrPartition(userInfo.name, '-')[1]] = true
        end
    end
    for i = 1, GetNumGuildMembers() do
        local name = GetGuildRosterInfo(i)
        if name then
            userList[StrPartition(name, '-')[1]] = true
        end
    end
    local clubs = C_Club.GetSubscribedClubs()
    if clubs then
        for _, club in pairs(clubs) do
            if club and club.clubId and club.clubType == 1 then
                local sortedMemberList = CommunitiesUtil.GetAndSortMemberInfo(club.clubId);
                for _, m in pairs(sortedMemberList) do
                    if m.name then
                        userList[StrPartition(m.name, '-')[1]] = true
                    end
                end
            end
        end
    end
end
local function RegisterWhisper(event, srcPlayer, destPlayer)
local playerName = StrPartition(event == "CHAT_MSG_WHISPER" and srcPlayer or destPlayer, '-')[1]
whisperedUsers[playerName] = true
end

local function RejectInvite(sender)
DeclineGroup()
StaticPopup_Hide("PARTY_INVITE")
end

local function RejectInviteConfirmation(guid)
RespondToInviteConfirmation(guid, false)
StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
end

local function MustRejectInvite(playerName)
if not LPaddon.strangerGroupEnabled then
return false
end

local senderName = StrPartition(playerName, '-')[1]
RefreshAllowedUsers()

if not allowedUsers[senderName] and not whisperedUsers[senderName] then
    return true
end

return false

end

local stranger = CreateFrame("Frame")
stranger:RegisterEvent("PARTY_INVITE_REQUEST")
stranger:RegisterEvent("CHAT_MSG_WHISPER")
stranger:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
stranger:RegisterEvent("GROUP_INVITE_CONFIRMATION")
stranger:SetScript("OnEvent", function(self, event, ...)
    if event == "PARTY_INVITE_REQUEST" then
        local sender = ...
        if MustRejectInvite(sender) then
            RejectInvite(sender)
        end
    elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
        local srcPlayer, destPlayer = ...
        RegisterWhisper(event, srcPlayer, destPlayer)
elseif event == "GROUP_INVITE_CONFIRMATION" then
    local guid = GetNextPendingInviteConfirmation()
    if guid and guid ~= "" then  -- 檢查 guid 是否有效
        local _, sender = GetInviteConfirmationInfo(guid)
        local playerName = StrPartition(sender, '-')[1]
        if MustRejectInvite(playerName) then
            RejectInviteConfirmation(guid)
         end
      end
   end
end)

function isInviteAllowed(inviterName)
    if not inviterName then
        return true
    end
    local lowercase_sender = inviterName:lower()
    if LPaddon.declineSimplifiedChinese then
        for word in pairs(LPaddon.filterWords) do
            if string.find(lowercase_sender, word) then
                return false
            end
        end
    end
    if LPaddon.declineBladeOfKrol then
        if string.find(lowercase_sender, "克羅之刃") then
            return false
        end
    end
    if LPaddon.declineInvite then
        for _, adId in ipairs(LPaddon.adIdList) do
            if string.find(lowercase_sender, adId) then
                return false
            end
        end
    end
    if MustRejectInvite(inviterName) then
        return false
    end
    return true
end

local frame = CreateFrame("Frame", "ModifiedInviteDemo")
local event1 = false
local event2 = false

local function getFullName(name, server)
    return server and name .. "-" .. server or name
end

local function printDungeonDifficulty()
    local difficultyIndex = GetDungeonDifficultyID()
    local difficultyName = "普通"
    if difficultyIndex == 1 then
        difficultyName = "普通"
    elseif difficultyIndex == 2 then
        difficultyName = "英雄"
    elseif difficultyIndex == 23 then
        difficultyName = "傳奇"
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00地城難度設定為" .. difficultyName .. "。|r")
end

local inviterNameForConfirmation
local inviterServerForConfirmation

local function onEvent(self, event, ...)
    if event == "PARTY_INVITE_REQUEST" then
        event1 = true
        inviterNameForConfirmation, inviterServerForConfirmation = ...
        if isInviteAllowed(inviterNameForConfirmation) then
            local fullName = getFullName(inviterNameForConfirmation, inviterServerForConfirmation)
            local hyperlink = "|Hplayer:" .. fullName .. "|h[" .. fullName .. "]|h"
            local message = hyperlink .. "邀請你加入隊伍。"
            DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 0)
        end
    elseif event == "GROUP_JOINED" then
        event2 = true
    elseif event == "GROUP_LEFT" then
        event1 = false
        event2 = false
        confirmationEvent = false
    elseif event == "GROUP_INVITE_CONFIRMATION" then
        confirmationEvent = true
    end

    if event1 and event2 then
        C_Timer.After(0.5, function()
            if not confirmationEvent then
                printDungeonDifficulty()
            end
            event1 = false
            event2 = false
        end)
    end

    if event == "GROUP_INVITE_CONFIRMATION" then
        local guid = GetNextPendingInviteConfirmation()
        if guid then
            local _, name = GetInviteConfirmationInfo(guid)
            if name and not isInviteAllowed(name) then
            else
                local fullName = getFullName(name, inviterServerForConfirmation)
                local hyperlink = "|Hplayer:" .. fullName .. "|h[" .. fullName .. "]|h"
                local message = hyperlink .. "要求加入你的隊伍。"
                DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 0)
                printDungeonDifficulty()
            end
        end
    end
end
local function filterinvite(self, event, msg, ...)
    if string.match(msg, "邀請你加入一個隊伍，但你無法接受。因為你已經在一個隊伍中。") then       
        local inviter = string.match(msg, "%[(.-)%]")        
        if inviter then
            for _, adId in ipairs(LPaddon.adIdList) do
                if string.find(string.lower(inviter), adId) then
                    
                    return true
                end
            end
        end
    end
    return false, msg, ...
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterinvite)
local function filterSystemMessage(_, _, message, ...)
    if message:find("邀請你加入隊伍") or message:find("要求加入你的隊伍") or message:find("地城難度設定為") or message:find("推薦邀你加入他們的隊伍") then
        return true
    end
    return false
end
frame:SetScript("OnEvent", onEvent)
frame:RegisterEvent("PARTY_INVITE_REQUEST")
frame:RegisterEvent("GROUP_JOINED")
frame:RegisterEvent("GROUP_INVITE_CONFIRMATION")
frame:RegisterEvent("GROUP_LEFT")
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterSystemMessage)
