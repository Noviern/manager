local UIC_MANAGER = 16777216
local managerWindow

---Corrects the widgets screen position to always be inside the screen.
---@param widget Widget
local function CorrectWidgetScreenPos(widget)
  local x, y = widget:CorrectOffsetByScreen()
  x = x / UIParent:GetUIScale()
  y = y / UIParent:GetUIScale()
  widget:RemoveAllAnchors()
  widget:AddAnchor("TOPLEFT", "UIParent", x, y)
end

---Toggles a widget.
---@param subItem Widget
local function ToggleAddon(subItem)
  local rowWindow = subItem:GetParent() ---@cast rowWindow ListCtrlItem

  rowWindow.addon.enable = not rowWindow.addon.enable
  ADDON:SetAddonEnable(rowWindow.addon.name, rowWindow.addon.enable)
  ADDON:SaveAddonInfos()
  ADDON:ReloadAddon(rowWindow.addon.name)

  SetViewOfRow(rowWindow)
end

---Creates the addon manager window.
---@return Window
local function CreateManagerWindow()
  local addons = ADDON:GetAddonInfos()

  table.sort(addons, function (a, b) return a.name < b.name end)

  local window         = SetViewOfManagerWindow(addons)
  local titleBar       = window.titleBar ---@type Window
  local closeButton    = titleBar.closeButton ---@type Button
  local contentFrame   = window.contentFrame ---@type EmptyWidget
  local scrollFrame    = contentFrame.scrollFrame ---@type EmptyWidget
  local addonsListCtrl = scrollFrame.addonsListCtrl ---@type ListCtrl
  local sliderFrame    = contentFrame.sliderFrame ---@type EmptyWidget
  local upButton       = sliderFrame.upButton ---@type Button
  local downButton     = sliderFrame.downButton ---@type Button
  local slider         = sliderFrame.slider ---@type Slider

  window:SetSounds("bag")
  window:EnableHidingIsRemove(true)
  window:SetAlphaAnimation(0, 1, .1, .1)
  window:SetStartAnimation(true, true)

  titleBar:SetHandler("OnDragStart", function ()
    window:StartMoving()
  end)

  titleBar:SetHandler("OnDragStop", function ()
    window:StopMovingOrSizing()
    CorrectWidgetScreenPos(window)
  end)

  window.isPinned = false

  function titleBar:SetPin(pin)
    if pin then
      titleBar.titleStyle:SetColorByKey("red")
      window:SetUILayer("system")
    else
      titleBar.titleStyle:SetColorByKey("title")
      window:SetUILayer("normal")
    end

    window:Raise()
    window:SetCloseOnEscape(not pin)
  end

  titleBar:SetPin(false)

  titleBar:SetHandler("OnClick", function (self, mouseButton, doubleClick, keyModifier)
    if doubleClick then
      window.isPinned = not window.isPinned
      titleBar:SetPin(window.isPinned)
    end
  end)

  closeButton:SetHandler("OnClick", function ()
    window:Show(false)
  end)

  upButton:SetHandler("OnClick", function ()
    slider:Up(WINDOW.ITEM_DIMENSION)
  end)

  slider:SetHandler("OnSliderChanged", function (self, value)
    scrollFrame:ChangeChildAnchorByScrollValue("vert", value)
  end)

  downButton:SetHandler("OnClick", function ()
    slider:Down(WINDOW.ITEM_DIMENSION)
  end)

  slider:SetPageStep(WINDOW.ITEM_DIMENSION)
  slider:SetValueStep(WINDOW.ITEM_DIMENSION)
  slider:SetFixedThumb(true)

  contentFrame:SetHandler("OnWheelUp", function ()
    slider:Up(WINDOW.ITEM_DIMENSION)
  end)

  contentFrame:SetHandler("OnWheelDown", function ()
    slider:Down(WINDOW.ITEM_DIMENSION)
  end)

  for row, addon in pairs(addons) do
    local rowWindow = addonsListCtrl.items[row]
    local checkButton, addonNameTextbox, settingsButton, refreshButton = unpack(
      rowWindow.subItems
    )

    checkButton:SetHandler("OnClick", ToggleAddon)
    addonNameTextbox:SetHandler("OnClick", ToggleAddon)

    settingsButton:SetHandler("OnClick", function ()
      ADDON:FireAddon(addon.name)
    end)

    refreshButton:SetHandler("OnClick", function ()
      ADDON:ReloadAddon(addon.name)
    end)
  end

  return window
end

---Toggles the addon manager window.
---@param show boolean|nil
local function ToggleManagerWindow(show)
  -- If the window should be shown.
  if show == nil then
    show = managerWindow == nil or not managerWindow:IsVisible()
  end

  -- If the window should be shown and doesn't exist, create it.
  if show == true and managerWindow == nil then
    managerWindow = CreateManagerWindow()

    managerWindow:SetDeletedHandler(function ()
      managerWindow = nil
    end)
  end

  -- If the window exists, Show or Hide it.
  if managerWindow then
    managerWindow:Show(show)
  end
end

ADDON:RegisterContentTriggerFunc(UIC_MANAGER, ToggleManagerWindow)
ADDON:AddEscMenuButton(5, UIC_MANAGER, "optimizer", locale.addon.name)
