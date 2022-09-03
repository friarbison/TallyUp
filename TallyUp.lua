
local TallyUp = LibStub("AceAddon-3.0"):NewAddon("TallyUp", "AceConsole-3.0", "AceEvent-3.0")
local MainFrame1 = CreateFrame("Frame","MFrame1",UIParent, BackdropTemplateMixin and "BackdropTemplate")
local MsgFrame = CreateFrame("Frame","msgFrame", MainFrame1, "BackdropTemplate")
local ColorFrame = CreateFrame("Frame","Color", MainFrame1, "BackdropTemplate")
local RedFrame = CreateFrame("Frame","Red", ColorFrame, BackdropTemplateMixin and "BackdropTemplate")
local GreenFrame = CreateFrame("Frame","Green", ColorFrame, BackdropTemplateMixin and "BackdropTemplate")
local BlueFrame = CreateFrame("Frame","Blue", ColorFrame, BackdropTemplateMixin and "BackdropTemplate")
local WhiteFrame = CreateFrame("Frame","White", ColorFrame, BackdropTemplateMixin and "BackdropTemplate")
local BlackFrame = CreateFrame("Frame","Black", ColorFrame, BackdropTemplateMixin and "BackdropTemplate")

local ClearButton = CreateFrame("Button", "ClearButton", MainFrame1)
local PauseButton = CreateFrame("Button", "PauseButton", MainFrame1)
local nFrame = CreateFrame("Frame","highlightLabels", MainFrame1, "BackdropTemplate")
local FHeight, FWidth, MainFrame1Shown, TallyUpStatus, TallyUpVERSION, FrameLocked = 35, 144, 0, "Inactive", "1.0.0.19", 0
local _TotalCount, ReLoad = 0, 0
local highlightLabels = {} 
local STip = {}
local cItemCnt = {}
local _HName, Ln, _CName = "", 1, ""

local cItems  = {
  --cata
  ["Lifegiving Seed"] = 0,
  ["Twilight Jasmine"] = 0,
  ["Volatile Life"] = 0,
  ["Volatile Water"] = 0,
  ["Volatile Earth"] = 0,
  ["Volatile Fire"] = 0,
  ["Volatile Air"] = 0,
  ["Elementium Ore"] = 0,
  ["Cinderbloom"] = 0,
  ["Pyrite Ore"] = 0,
  ["Ocean Sapphire"] = 0,
  ["Whiptail"] = 0,
  ["Gershal Shrub"] = 0,
  ["Alicite"] = 0,
  ["Hessonite"] = 0,
  ["Obsidium Ore"] = 0,
  ["Stormvine"] = 0,
  ["Highland Guppy"] = 0,
  ["Deepsea Sagefish"] = 0,
  ["Aberrant Voidfin"] = 0,
  ["Malformed Gnasher"] = 0,
  --Herbs
  ["Widowbloom"] = 0, 
  ["Vigil's Torch"] = 0, 
  ["Rising Glory"] = 0,  
  ["Marrowroot"] = 0,  
  ["Death Blossom"] = 0,  
  ["Nightshade"] = 0, 
  ["First Flower"] = 0,  -- 9.2
  -- Ore
  ["Coarse Stone"] = 0,
  ["Rough Stone"] = 0,
  ["Solid Stone"] = 0,
  ["Obsidium Ore"] = 0,  --Mt. Hyjal
  ["Ghost Iron Ore"] = 0,  --Pandaria
  ["Dense Stone"] = 0, --Winterspring
  ["Thorium Ore"] = 0, --Winterspring
  ["Truesilver Ore"] = 0, --Winterspring
  ["Mithril Ore"] = 0, --Felwood
  ["Tin Ore"] = 0,
  ["Copper Ore"] = 0,  --Azshara
  ["Platinum Ore"] = 0,  --Zandalar; Vol'dun, Nazmir
  ["Monelite Ore"] = 0,   --Zandalar; Vol'dun, Nazmir
  ["Storm Silver Ore"] = 0, --Zandalar; Vol'dun, Nazmir
  ["Laestrite Ore"] = 0, 
  ["Elethium Ore"] = 0, 
  ["Solenium Ore"] = 0,
  ["Porous Stone"] = 0,
  ["Shaded Stone"] = 0,
  ["Oxxein Ore"] = 0, 
  ["Phaedrum Ore"] = 0, 
  ["Sinvyr Ore"] = 0,
  ["Elementium Ore"] = 0,
  ["Pyrite Ore"] = 0,
  ["Progenium Ore"] = 0,  -- 9.2
  -- Fish
  ["Sharptooth"] = 0,  --Mt. Hyjal
  ["Mountain Trout"] = 0,  --Mt. Hyjal
  ["Golden Carp"] = 0,  --Pandaria
  ["Jade Lungfish"] = 0,  --Pandaria
  ["Raw Sagefish"] = 0,
  ["Sand Shifter"] = 0,
  ["Midnight Salmon"] = 0,
  ["Redtail Loach"] = 0, 
  ["Great Sea Catfish"] = 0,
  ["Lost Sole"] = 0, 
  ["Elysian Thade"] = 0, 
  ["Silvergill Pike"] = 0, 
  ["Pocked Bonefish"] = 0, 
  ["Iridescent Amberjack"] = 0, 
  ["Spinefin Piranha"] = 0,
  ["Precursor Placoderm"] = 0,  -- 9.2
  -- Skinning
  ["Desolate Leather"] = 0,
  ["Heavey Desolate Leather"] = 0,
  ["Callous Hide"] = 0,
  ["Heavy Callous Hide"] = 0,
  ["Pallid Bone"] = 0,
  ["Gaunt Sinew"] = 0,
  ["Protogenic Pelt"] = 0, -- 9.2
  -- Meat
  ["Aethereal Meat"] = 0,
  ["Creeping Crawler Meat"] = 0,
  ["Phantasmal Haunch"] = 0,
  ["Raw Seraphic Wing"] = 0,
  ["Shadowy Shank"] = 0,
  ["Tenebrous Ribs"] = 0,
  ["Protoflesh"] = 0,  -- 9.2
  -- Cloth
  ["Shrouded Cloth"] = 0,
  ["Lightless Silk"] = 0,
  ["Penumbra Thread"] = 0,
  ["Orboreal Shard"] = 0,
  ["Silken Protofiber"] = 0  -- 9.2
}

local function initItems()
  --print("initItems started")
  ReLoad = 1
  _TotalCount = 0
  cItemCnt = {}
  highlightLabels = {}
  for index, data in pairs(cItems) do
    local cntr = GetItemCount(index)
    if cntr == nil then
      cntr = 0
    end    
    lindex = index .. " +" .. tostring(cntr)    
    cItemCnt[lindex] = 0
    _TotalCount = _TotalCount + 1
  end
  --print("initItems complete")
end

local function myNull()
end


local function reInitialize() 
  local lblRows
  --print("reInitialize started")

  for i, v in pairs(highlightLabels) do
    local nf = v
    v:Hide()
    v:SetParent(nil) 
  end

  --print("Re-intit1")
  for i, v in pairs(highlightLabels) do
    highlightLabels[i] = nil
  end

  --print("Re-intit2")
  for i, v in pairs(cItemCnt) do
    cItemCnt[i] = nil
  end

  --print("Re-intit3")
  if nFrame then                       --Added this if because nFrame is not initialized at the beginning
    for i, v in pairs(nFrame) do      --and was locking up the commands that called this function.
      nFrame = nil
    end
  end

  --print("Re-intit4")
  cItemCnt = {}
  highlightLabels = {}
  initItems()

  --print("Re-intit5")
  MainFrame1:SetSize(180,24)
  FHeight = 24
  --print("reInitialize completed")
end

function rtrim(s)
  return s:match'^(.*%S)%s*$'
end

local function formatHerbName(str, sp)
  for i in string.gmatch(str, "([^"..sp.."]+)") do
    return rtrim(i)
  end
end

local function formatName(str, sep)
  local iStr1
  iStr = str:gsub("[%s%']",'')
  for i in string.gmatch(iStr, "([^"..sep.."]+)") do
    return rtrim(iStr1)
  end
end

local function GetUseName(str)
  local newindex
  for index, data in pairs(cItemCnt) do
    if string.find(index, str) then
      return index
    end 
  end
  return nil
end

local function AddToIt(nName, nCnt)
  local newindex, newCnt

  for index, data in pairs(cItemCnt) do
    --print("ADDToIt: nName: " .. nName .. ", index:  " .. index)

    if string.find(index, nName, 1, 1) then
--      print("1. Type: " .. type(cItemCnt[index]))
--      print("2. Type: " .. type(tonumber(cItemCnt[index])))
--      print("3. Type: " .. type(nCnt))
--      print("4. Type: " .. type(tonumber(nCnt)))      
      newCnt = data + nCnt
      --print("Old cnt: " .. tostring(data) .. ", Looted: " .. tostring(nCnt) .. ", new cnt: " .. tostring(newCnt))
      cItemCnt[index] = newCnt 
      --print("ADDToIt: Match -> " .. newindex .. " and " .. nNameMod .. ".  " ..  "Returning <" .. index .. ">.")
      return newCnt
    end     
  end
  return nil
end

local function ShowMyPoints(mframe)
  local point, relativeTo, relativePoint, xOfs, yOfs
  point, relativeTo, relativePoint, xOfs, yOfs = mframe:GetPoint()
  mFrameName = mframe:GetName()
  print(mFrameName .. ": Point: " .. point)
  --print("RelativeTo: " .. relativeTo:GetName(mframe))
  print(mFrameName .. ": RelativePnt: " .. relativePoint)
  print(mFrameName .. ": X: " .. xOfs)
  print(mFrameName .. ": Y: " .. yOfs)
  return xOfs, yOfs, point
end

local function GetMyPoints(mframe)
  local point, relativeTo, relativePoint, xOfs, yOfs
  point, relativeTo, relativePoint, xOfs, yOfs = mframe:GetPoint()
  return xOfs, yOfs, point
end

local function ResetData()
  local point, relativeTo, relativePoint, xOfs, yOfs = MainFrame1:GetPoint()

  MainFrame1:UnregisterEvent("CHAT_MSG_LOOT")
  if MainFrame1Shown == 1 then MainFrame1:Hide() MainFrame1Shown=0 end
  reInitialize()    
  MainFrame1:SetPoint(point, xOfs, yOfs)  
  MainFrame1:RegisterEvent("CHAT_MSG_LOOT")  
  MainFrame1:Show()
  ClearButton:Hide()
end

local function SetFrameWidth(HerbName)
  local fw = (string.len(HerbName) + 18) * 6
  if fw > FWidth then
    FWidth = fw
  end
end

local function SetFrameHeight(fh)
  --print("Line: " .. fh .. ", FrameHeight is: " .. tostring(FHeight))
  if FHeight < ((fh * 18) + 20) then
    FHeight = ((fh * 18) + 24)
  end
end

local function ShowMyToolTip(tt, txt, lnum, cnt)
  --local n = tostring(GetItemCount(txt))
  local n = GetItemCount(txt)
  --n = n + cnt
  local str = txt .. ": " .. tostring(n)
  local ln = (string.len(str) * 10) + 16
  --print("Len: " .. ln * 8)
  MsgFrame:SetWidth(ln)
  MsgFrame.text:SetText(str)
  MsgFrame:Show()
end

function HideMyToolTip(tt, txt)
  MsgFrame.text:SetText("")  
  MsgFrame:Hide() 
end

local function SelectColor(sel,n)
  _CName = n
  --print("SC.CName = " .. _CName)

  if sel == 1 then
    ColorFrame:Show()
    RedFrame:Show()
    GreenFrame:Show()
    BlueFrame:Show()
    WhiteFrame:Show()
    BlackFrame:Show()
  else 
    ColorFrame:Hide()
    RedFrame:Hide()
    GreenFrame:Hide()
    BlueFrame:Hide()
    WhiteFrame:Hide()
    BlackFrame:Hide()
  end 
end

local function AddNewEntry(HerbName, HerbCount, LineNum)
  local useName = nil
  local tt = nil

  if LineNum <= 1 then initItems() end

  useName = GetUseName(HerbName)
  SetFrameWidth(useName)  
  SetFrameHeight(LineNum)
  --print("AddNewEntry " .. useName .. ", " .. tostring(HerbCount) .. ", " .. tostring(LineNum))
  --print("AE: Frame x,y are: " .. FWidth .. " and " .. FHeight)
  MainFrame1:SetSize(FWidth, FHeight)
  nFrame = CreateFrame("Frame", HerbName, MainFrame1, "BackdropTemplate") -- BackdropTemplateMixin and "BackdropTemplate"))
  nFrame:SetPoint("TOPLEFT", 1, (12 - ((LineNum ) * 18)) )
  nFrame:SetSize(196,20)
  nFrame.text = nFrame:CreateFontString(nil,"ARTWORK") 
  nFrame.text:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
  nFrame.text:SetPoint("LEFT", 2, 0)
  nFrame.text:SetText(useName .. "..........." .. tostring(HerbCount))
  nFrame:SetScript("OnEnter", function() ShowMyToolTip(tt, HerbName, LineNum, HerbCount) end)
  nFrame:SetScript("OnLeave", function() HideMyToolTip(tt, HerbName) end)
  nFrame:SetScript("OnMouseDown", function(self, button) 
      --print("Name is " .. nFrame:GetName()  .. " and HerbName is " .. HerbName)
      if button=='LeftButton' then 
        SelectColor(1, HerbName)
      else
        SelectColor(2, HerbName)
      end
    end)
  table.insert(highlightLabels, nFrame)
end

local function displayupdate(show, HerbName, HerbCount)
  local cCnt, lblRows = 1, 0
  if show == 1 then
    HerbCount = AddToIt(HerbName, HerbCount)
    for i, v in pairs(highlightLabels) do 
      lblRows = lblRows + 1
      dbgName1 = v.text:GetText()
      --if ReLoad == 1 then
      -- print("INSIDE: Row: " .. lblRows .. " - <" .. HerbName .. ">.  ReLoad: " .. tostring(ReLoad))
      --end
      if v:GetName() == HerbName then
        v.text:SetText(formatHerbName(dbgName1, "%.") .. "..........." .. tostring(HerbCount))
        if ReLoad == 1 then ReLoad = 0 end
        return nil
      end      
    end

    --print("OUTSIDE: Row: " .. lblRows .. " - <" .. HerbName .. ">.  ReLoad: " .. tostring(ReLoad))
    if ReLoad == 1 then ReLoad = 0 end
    lblRows = lblRows + 1
    AddNewEntry(HerbName, HerbCount, lblRows)
    ClearButton:Show()   
  else
    if MainFrame1Shown == 1 then MainFrame1:Hide() MainFrame1Shown = 0 end
  end
end

local function CollectionState(state)
  if state == "pause" then
    PauseButton:SetText("resume")
    MainFrame1:UnregisterEvent("CHAT_MSG_LOOT")
    PauseButton:SetWidth(50)
  else
    PauseButton:SetText("pause")
    MainFrame1:RegisterEvent("CHAT_MSG_LOOT")
    PauseButton:SetWidth(40)
  end
end    

local function StripStr(str)
  return str:gsub("%s+", "")
end

local options = {
  name = "TallyUp",
  handler = TallyUp,
  type = 'group',
  args = {
    intro = {
      order = 1,
      type = "description",
      name = "\"TallyUp\" with no commands toggles the on/off status.\n" ..
      "        \"/TallyUp on\" enables the display.\n"   ..
      "        \"/TallyUp off\" disables the display.\n" ..
      "        \"/TallyUp reset\" clears frame content and values.\n" ..
      "        \"/TallyUp h\" or \"?\" or \"help\" shows valid commands.\n" ..
      "        \"/TallyUp v\" or \"version\" shows current version.\n"
    }
  },
}

local defaults = {
  profile = {
    vStatus = false,
  }
}

function ShowCommands()
  print(" TallyUp addon command line options:\n" ..
    "        \"TallyUp\" with no commands toggles the on/off status.\n" ..
    "        \"/TallyUp on\" enables the display.\n"   ..
    "        \"/TallyUp off\" disables the display.\n" ..
    "        \"/TallyUp reset\" clears frame content and values.\n" ..
    "        \"/TallyUp h\" or \"?\" or \"help\" shows valid commands.\n" ..
    "        \"/TallyUp v\" or \"version\" shows current version.\n")
end

function TallyUp:OnCommand(input)
  if self:GetName() == "TallyUp" then  
    if input == "hide" then
      if MainFrame1Shown == 1 then MainFrame1Shown = 0 end
      MainFrame1:Hide()
    elseif input == "show" then
      if MainFrame1Shown == 0 then MainFrame1Shown = 1 end
      MainFrame1:Show()
    elseif input == "on" then
      --print("Re-init called ...")
      reInitialize() 
      --print("Re-init completed, Registering events ...")
      MainFrame1:RegisterEvent("CHAT_MSG_LOOT")
      MainFrame1:RegisterEvent("ENCOUNTER_START")
      MainFrame1:RegisterEvent("ENCOUNTER_END")
      MainFrame1:RegisterEvent("PLAYER_REGEN_ENABLED")
      MainFrame1:RegisterEvent("PLAYER_REGEN_DISABLED")
      if MainFrame1Shown == 0 then MainFrame1:Show() MainFrame1Shown=1 end
      print("TallyUp is on.")
      TallyUpStatus = "Active"
      self.Db.global.vStatus = false
      self.Db.profile.vStatus = true
    elseif input == "off" then
      reInitialize()
      MainFrame1:UnregisterEvent("CHAT_MSG_LOOT")
      MainFrame1:Hide()
      if MainFrame1Shown == 1 then MainFrame1Shown = 0 end
      ClearButton:Hide()
      print("TallyUp is off.")
      TallyUpStatus = "Inactive"
      self.Db.global.vStatus = false
      self.Db.profile.vStatus = false
    elseif input == "v" or input == "version" then
      print("TallyUp " .. TallyUpVERSION .. " is " .. TallyUpStatus)
    elseif input == "reset" then
      reInitialize()
      --print("All values have been reset")
      --print("TallyUp is " .. TallyUpStatus)
    elseif input == "d1" then
      TallyUp:mysim("Death Blossom", 2)
    elseif input == "d2" then
      TallyUp:mysim("Widowbloom", 3)
    elseif input == "d3" then
      TallyUp:mysim("Phaedrum Ore", 4)
    elseif input == "h" or input == "help" or input == "?" then
      ShowCommands()
    else
--      ShowCommands()
      if TallyUpStatus == "Active" then
        TallyUp:OnCommand("off")
      else
        TallyUp:OnCommand("on")
      end
      print("TallyUp " .. TallyUpVERSION .. " is " .. TallyUpStatus)
    end
  end
end

function TallyUp:OnInitialize()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("TallyUp", options, {"TallyUp"})
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TallyUp", "TallyUp")
  LibStub("AceConfigDialog-3.0"):SetDefaultSize("TallyUp", 400, 250)
  self:RegisterChatCommand("TallyUp", "OnCommand")
  self.Db = LibStub("AceDB-3.0"):New("TallyupContent", defaults, true)
end

function TallyUp:ADDON_LOADED()   
  AddonHasLoaded = true
  if self.Db.profile.vStatus == true then
    TallyUp:OnCommand("on")
  end
  self:UnregisterEvent("ADDON_LOADED")
end

function TallyUp:OnEnable()
  self:RegisterEvent("ADDON_LOADED")
end

function TallyUp:OnDisable()
  print("TallyUp is disabled.")
  self:RegisterEvent("ADDON_LOADED")
end

ColorFrame:SetPoint("TOPRIGHT", 80, 10)
ColorFrame:SetSize(82,80)
ColorFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",  --"Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
ColorFrame:SetBackdropColor(1, 1, 1, 1) 
ColorFrame:SetFrameLevel(500)
ColorFrame:Hide()

RedFrame:SetPoint("TOPLEFT", 6, -5)
RedFrame:SetSize(70,14)
RedFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
RedFrame:SetBackdropColor(1, 0, 0, 1) 
RedFrame:SetFrameLevel(600)
RedFrame:SetScript("OnMouseDown", function(self, btn) 
    for i, v in pairs(highlightLabels) do
      if v:GetName() == _CName then
        v.text:SetTextColor(1,0,0,1)
        --print("Setting Color to Red on " .. _CName)
        break
      end
    end  
    ColorFrame:Hide()
  end)
RedFrame:Hide()

GreenFrame:SetPoint("TOpLEFT", 6, -19)
GreenFrame:SetSize(70,14)
GreenFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
GreenFrame:SetBackdropColor(0, 1, 0, 1) 
GreenFrame:SetFrameLevel(600)
GreenFrame:SetScript("OnMouseDown", function(self, btn) 
    for i, v in pairs(highlightLabels) do
      if v:GetName() == _CName then
        --print("Setting Color to Green on " .. _CName)
        v.text:SetTextColor(0,1,0,1)
        break
      end
    end  
    ColorFrame:Hide()
  end)
GreenFrame:Hide() 

BlueFrame:SetPoint("TOPLEFT", 6, -33)
BlueFrame:SetSize(70,14)
BlueFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
BlueFrame:SetBackdropColor(0, 0, 1, 1)
BlueFrame:SetScript("OnMouseDown", function(self, btn) 
    for i, v in pairs(highlightLabels) do
      if v:GetName() == _CName then
        v.text:SetTextColor(0,0,1,1)
        break
      end
    end  
    ColorFrame:Hide()
  end)
BlueFrame:Hide()

WhiteFrame:SetPoint("TOPLEFT", 6, -47)
WhiteFrame:SetSize(70,14)
WhiteFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
WhiteFrame:SetBackdropColor(1, 1, 1, 1) 
WhiteFrame:SetScript("OnMouseDown", function(self, btn) 
    for i, v in pairs(highlightLabels) do
      if v:GetName() == _CName then
        v.text:SetTextColor(1,1,1,1)
        break
      end
    end  
    ColorFrame:Hide()
  end)
WhiteFrame:Hide()

BlackFrame:SetPoint("TOPLEFT", 6, -61)
BlackFrame:SetSize(70,14)
BlackFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })
BlackFrame:SetBackdropColor(0, 0, 0, 1) 
BlackFrame:SetScript("OnMouseDown", function(self, btn) 
    for i, v in pairs(highlightLabels) do
      if v:GetName() == _CName then
        v.text:SetTextColor(0,0,0,1)
        break
      end
    end  
    ColorFrame:Hide()
  end) 
BlackFrame:Hide() 

MsgFrame:SetPoint("CENTER", 110, 34)
MsgFrame.text = MsgFrame:CreateFontString(nil,"ARTWORK", "GameFontNormal")
MsgFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 16) --SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
MsgFrame.text:SetPoint("LEFT", 10, 0)
MsgFrame:SetSize(160,28)
MsgFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",  --"Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
MsgFrame:SetBackdropColor(1, 1, 1, 1) 
MsgFrame:SetFrameLevel(999)
MsgFrame:Hide()

MainFrame1:SetPoint("CENTER", 0, 0)
MainFrame1:SetSize(144,32)
MainFrame1:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 10,
    insets = { left = 1, right = 1, top = 1, bottom = 1 },
  })
MainFrame1:SetBackdropColor(0, 0, 1, .33)
MainFrame1:SetMovable(true)
MainFrame1:EnableMouse(true)
MainFrame1:RegisterForDrag("LeftButton")
MainFrame1:SetScript("OnDragStart", function() 
    if FrameLocked == 0 then  
      MainFrame1:StartMoving()  
    end
  end)
MainFrame1:SetScript("OnDragStop", function(self)
    MainFrame1:StopMovingOrSizing() end)
  MainFrame1:Hide()

  local function FrameLock(tBtn, unlockedTexture)
    if FrameLocked == 0 then    
      tBtn.text:SetText("TallyUp - Locked")
      local lockedTexture = tBtn:CreateTexture()
      lockedTexture:SetTexture([[Interface\AddOns\TallyUp\Icons\Locked]])
      lockedTexture:SetTexCoord(10, -0.3, -0.3, 1.3)
      lockedTexture:SetAllPoints(tBtn)
      tBtn:SetNormalTexture(lockedTexture)
      FrameLocked = 1
    else     
      tBtn.text:SetText("TallyUp - UnLocked")
      tBtn:SetNormalTexture(unlockedTexture)
      FrameLocked = 0
    end
  end

  local TitleButton = CreateFrame("Button","TitleButton", MainFrame1, "UIGoldBorderButtonTemplate")
  TitleButton:SetHeight(24)
  TitleButton:SetWidth(180)
--Odds and ends while ironing out the bumps with texture
--mynormal:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
--mynormal:SetTexture("Interface\AddOns\TallyUp\Icons\Locked")
--mynormal:SetTexture("Interface/Buttons/LockButton-Locked-up")
--mynormal:SetTexCoord(-4, 0.9, 0, 1)
--TitleButton:SetNormalTexture([[Interface\AddOns\TallyUp\Icons\Locked]])
--TitleButton:SetNormalTexture([[Interface\Buttons\UI-SquareButton-Up]]);

  local unlockedTexture = TitleButton:CreateTexture()
  unlockedTexture:SetTexture([[Interface\AddOns\TallyUp\Icons\UnLocked]])
  unlockedTexture:SetTexCoord(10, -0.3, -0.3, 1.3)
  unlockedTexture:SetAllPoints(TitleButton)
  TitleButton:SetNormalTexture(unlockedTexture)

--Start off unlocked, only deal with this when locking.
--It was causing both textures to be visible at startup.
--Did not take time to trouble shoot.
--local lockedTexture = TitleButton:CreateTexture()
--lockedTexture:SetTexture([[Interface\AddOns\TallyUp\Icons\Locked]])
--lockedTexture:SetTexCoord(10, -0.3, -0.3, 1.3)
--lockedTexture:SetAllPoints(TitleButton)
--TitleButton:SetNormalTexture(lockedTexture)

--Causing too much screen jitter around the button, not necessary!
--TitleButton:SetPushedTexture([[Interface\Buttons\UI-SquareButton-Down]]);
--TitleButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]]);
  TitleButton:SetPoint("BOTTOM", MainFrame1, "TOP", 0, 0)
  TitleButton.text = TitleButton:CreateFontString(nil,"OVERLAY", "GameFontNormal") 
  TitleButton.text:SetPoint("CENTER")
  if FrameLocked == 0 then  
    TitleButton.text:SetText("Tallyup - UnLocked") 
  else
    TitleButton.text:SetText("Tallyup - Locked")
    local lockedTexture = TitleButton:CreateTexture()
    lockedTexture:SetTexture([[Interface\AddOns\TallyUp\Icons\Locked]])
    lockedTexture:SetTexCoord(10, -0.3, -0.3, 1.3)
    lockedTexture:SetAllPoints(TitleButton)
    TitleButton:SetNormalTexture(lockedTexture)
  end
  TitleButton:SetScript("OnClick", function(self) FrameLock(TitleButton, unlockedTexture) end)

  local TTip = CreateFrame("GameToolTip", "Locked", TitleButton, "GameTooltipTemplate")
  TTip:SetOwner(TitleButton, "ANCHOR_RIGHT")

  TitleButton:SetScript("OnEnter", function()
      if FrameLocked == 0 then
        TTip:AddLine("Click to lock Frame", 1,0,0,1)
      else
        TTip:AddLine("Click to move Frame", 1,0,0,1)
      end

      TTip:Show()
    end);
  TitleButton:SetScript("OnLeave", function()
      TTip:Hide();
      TTip:SetOwner(TitleButton, "ANCHOR_RIGHT")
    end);

  local function CheckGlobalName(hname, sep)
    --print("CheckGlobalName started")
    for i in string.gmatch(hname, "([^"..sep.."]+)") do
      iStr1 = i
      --print("CheckGlobalName returning ", iStr1)
      return iStr1
    end
    --print("CheckGlobalName completed")
  end

  function TallyUp:mysim (h, c)
    local ncntr = 1
    print("Debugging")
    ShowMyPoints(MainFrame1)
    print("Start for loop")
    for i,v in pairs(cItemCnt) do
      print("1- " .. i .. ", " .. v)
      hname = CheckGlobalName(i, "%+")
      print("2. [" .. ncntr .. "] h is <".. hname ..">")
      ncntr = ncntr + 1
      print("HerbName: <" .. HerbName .. "> and hname: <" .. hname .. ">")
      print("3. hname is <" .. hname .. ">")
      if (h .. " ") == hname then
        _HName = i
        if c == nil then
          c = 1
        end
        print("Calling displayupdate")
        displayupdate(1, h, c)
        print("Returned from displayupdate")
        HerbCnt = nil
        break
      end
    end
    print("End for loop")
  end  

  local function checkStatus(stat)
    --print("checkStatus")
    if TallyUpStatus == "Active" then
      if stat == 1 then
        MainFrame1:Hide()
        return 1 
      else
        MainFrame1:Show()
        return 0
      end
    else
      return 0
    end
  end

  MainFrame1:SetScript("OnEvent", function(self, event, ...) 
      local rtn = 0
      --print("Event is " .. event)
      if event == "PLAYER_REGEN_ENABLED" then 
        rtn = checkStatus(0)
      elseif event == "PLAYER_REGEN_DISABLED" then
        rtn = checkStatus(1)
      elseif rtn == 0 then

        local tStr, HerbName, HerbStr, HerbCnt, beginning1, beginning2, ending1, ending2, PlayerName, PlayerNameLooting, hname
        _HName = nil
        HerbStr = select(1, ...)
        PlayerNameLooting = select(2, ...)
        PlayerName = UnitName("player") .. "-" .. GetRealmName():gsub("%s+", "")

        if PlayerNameLooting == PlayerName then 
          beginning1, beginning2=string.find(HerbStr, "%[")
          ending1, ending2=string.find(HerbStr,"%]")
          HerbName=string.sub(HerbStr,(beginning2 + 1), (ending1 - 1))
          tStr = string.sub(HerbStr, (string.len(HerbStr) - 2) , string.len(HerbStr))
          for c in string.gmatch(tStr, '.') do  
            --print("c. :" .. c .. ", " .. type(c) .. " <" .. tStr .. ">")
            if tonumber(c) ~= nil then
              if HerbCnt == nil then
                HerbCnt = c
              else
                HerbCnt = HerbCnt .. c
              end
            end
          end 

          for i,v in pairs(cItemCnt) do
            hname = CheckGlobalName(i, "%+")
            if (HerbName .. " ") == hname then
              _HName = i
              if HerbCnt == nil then
                HerbCnt = 1
              end
              displayupdate(1, HerbName, HerbCnt)
              HerbCnt = nil
              break
            end
          end
        end
      end
    end)

  ClearButton:SetPoint("CENTER", MainFrame1, "BOTTOM", 0, 10)
  ClearButton:SetWidth(40)
  ClearButton:SetHeight(15)

  ClearButton:SetText("clear")
  ClearButton:SetNormalFontObject("GameFontNormal")

  local cbntex = ClearButton:CreateTexture()
  cbntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  cbntex:SetTexCoord(0, 0.625, 0, 0.6875)
  cbntex:SetAllPoints()	
  ClearButton:SetNormalTexture(cbntex)

  local cbhtex = ClearButton:CreateTexture()
  cbhtex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  cbhtex:SetTexCoord(0, 0.625, 0, 0.6875)
  cbhtex:SetAllPoints()
  ClearButton:SetHighlightTexture(cbhtex)

  local cbptex = ClearButton:CreateTexture()
  cbptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  cbptex:SetTexCoord(0, 0.625, 0, 0.6875)
  cbptex:SetAllPoints()
  ClearButton:SetPushedTexture(cbptex)

  ClearButton:SetScript("OnClick", function(self) ResetData() end)

  ClearButton:Hide()

  PauseButton:SetPoint("BOTTOMLEFT", MainFrame1, 3, 3) --(FHeight - 15), 1)
  PauseButton:SetWidth(40)
  PauseButton:SetHeight(15)

  PauseButton:SetText("pause")
  PauseButton:SetNormalFontObject("GameFontNormal")

  local pntex = PauseButton:CreateTexture()
  pntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  pntex:SetTexCoord(0, 0.625, 0, 0.6875)
  pntex:SetAllPoints()	
  PauseButton:SetNormalTexture(pntex)

  local phtex = PauseButton:CreateTexture()
  phtex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  phtex:SetTexCoord(0, 0.625, 0, 0.6875)
  phtex:SetAllPoints()
  PauseButton:SetHighlightTexture(phtex)

  local pptex = PauseButton:CreateTexture()
  pptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  pptex:SetTexCoord(0, 0.625, 0, 0.6875)
  pptex:SetAllPoints()
  PauseButton:SetPushedTexture(pptex)

  PauseButton:SetScript("OnClick", function(self) CollectionState(PauseButton:GetText()) end)
