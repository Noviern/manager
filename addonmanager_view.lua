ADDON:ImportObject(OBJECT.Window)
ADDON:ImportObject(OBJECT.NinePartDrawable)
ADDON:ImportObject(OBJECT.ImageDrawable)
ADDON:ImportObject(OBJECT.TextStyle)
ADDON:ImportObject(OBJECT.Button)
ADDON:ImportObject(OBJECT.EmptyWidget)
ADDON:ImportObject(OBJECT.ListCtrl)
ADDON:ImportObject(OBJECT.Textbox)
ADDON:ImportObject(OBJECT.Slider)

WINDOW = {
  UIBOUND_NAME      = "ui_bound_manager",
  WIDTH             = 350,
  -- HEIGHT         = 515,
  TITLE_HEIGHT      = 45,
  MARGIN            = 20,
  ITEM_DIMENSION    = 30,
  VISIBLE_ROW_COUNT = 15,
}

WINDOW.HEIGHT = WINDOW.TITLE_HEIGHT + WINDOW.ITEM_DIMENSION * WINDOW.VISIBLE_ROW_COUNT + WINDOW.MARGIN

local currentAddonName = ADDON:GetName()

---Sets the view of the row.
---@param rowWindow Widget
function SetViewOfRow(rowWindow)
  local checkButton, addonNameTextbox, settingsButton, refreshButton = unpack(
    rowWindow.subItems
  )
  local enabled = rowWindow.addon.enable

  checkButton.checkedBackground:SetVisible(enabled)

  if rowWindow.addon.name == currentAddonName then
    checkButton:Enable(false)
    checkButton.checkedBackground:SetTextureInfo("btn_chk_dis")
    checkButton.checkedBackground:SetExtent(20, 20)
    addonNameTextbox.style:SetColorByKey("default_gray")
    addonNameTextbox:Enable(false)
    settingsButton:Enable(false)
    refreshButton:Enable(false)
  else
    settingsButton:Enable(enabled)
    refreshButton:Enable(enabled)
  end
end

---Sets the view of the addon manager window.
---@param addons AddonInfo[]
---@return Window
function SetViewOfManagerWindow(addons)
  -- Create a window.
  local window = UIParent:CreateWidget("window", "manager", "UIParent")
  window:SetExtent(WINDOW.WIDTH, WINDOW.HEIGHT)
  window:AddAnchor("CENTER", 0, 0)

  -- Create a background.
  local background = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg", "background")
  background:AddAnchor("TOPLEFT", window, -5, -5)
  background:AddAnchor("BOTTOMRIGHT", window, 5, 5)

  -- Create a title decoration.
  local decoration = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg_deco", "background")
  decoration:AddAnchor("TOPLEFT", window, 0, -5)
  decoration:AddAnchor("TOPRIGHT", window, 0, -5)

  -- Create a title bar.
  local titleBar = window:CreateChildWidget("window", "titleBar", 0, true)
  titleBar.titleStyle:SetAlign(ALIGN_CENTER)
  titleBar.titleStyle:SetSnap(true)
  titleBar.titleStyle:SetFont(FONT_PATH.SUB, FONT_SIZE.XLARGE)
  titleBar.titleStyle:SetColorByKey("title")
  titleBar:AddAnchor("TOPLEFT", window, 0, 0)
  titleBar:AddAnchor("TOPRIGHT", window, 0, 0)
  titleBar:SetTitleText(locale.addon.name)
  titleBar:EnableDrag(true)
  titleBar:SetHeight(WINDOW.TITLE_HEIGHT)

  -- Create a close button for the title bar.
  local closeButton = titleBar:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", titleBar, 3, -3)
  closeButton:SetStyle("btn_close_default")

  -- Create a content frame.
  local contentFrame = window:CreateChildWidget("emptywidget", "contentFrame", 0, true)
  contentFrame:AddAnchor("TOPLEFT", titleBar, "BOTTOMLEFT", WINDOW.MARGIN, 0)
  contentFrame:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", -WINDOW.MARGIN, -WINDOW.MARGIN)

  -- Create a scroll frame.
  local scrollFrame = contentFrame:CreateChildWidget("emptywidget", "scrollFrame", 0, true)
  scrollFrame:AddAnchor("TOPLEFT", contentFrame, 0, 0)
  scrollFrame:EnableScroll(true)

  -- Create a slider frame.
  local sliderFrame = contentFrame:CreateChildWidget("emptywidget", "sliderFrame", 0, true)
  sliderFrame:AddAnchor("TOPRIGHT", contentFrame, "TOPRIGHT", 0, 0)
  sliderFrame:AddAnchor("BOTTOMLEFT", contentFrame, "BOTTOMRIGHT", -WINDOW.MARGIN, 0)

  scrollFrame:AddAnchor("BOTTOMRIGHT", sliderFrame, "BOTTOMLEFT", 0, 0)

  -- Create a up button for the slider frame.
  local upButton = sliderFrame:CreateChildWidget("button", "upButton", 0, true)
  upButton:SetExtent(20, 12)
  upButton:AddAnchor("TOPRIGHT", sliderFrame, 0, 0)
  -- upButton:SetStyle("slider_scroll_button_up") -- This doesn't exist yet.

  local upButtonNormalBackground = assert(upButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  upButtonNormalBackground:SetTextureInfo("scroll_button_up", "normal")
  upButtonNormalBackground:AddAnchor("TOPLEFT", upButton, 0, 0)
  upButtonNormalBackground:AddAnchor("BOTTOMRIGHT", upButton, 0, 0)
  upButton:SetNormalBackground(upButtonNormalBackground)

  local upButtonHighlightBackground = assert(upButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  upButtonHighlightBackground:SetTextureInfo("scroll_button_up", "over")
  upButtonHighlightBackground:AddAnchor("TOPLEFT", upButton, 0, 0)
  upButtonHighlightBackground:AddAnchor("BOTTOMRIGHT", upButton, 0, 0)
  upButton:SetHighlightBackground(upButtonHighlightBackground)

  local upButtonPushedBackground = assert(upButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  upButtonPushedBackground:SetTextureInfo("scroll_button_up", "click")
  upButtonPushedBackground:AddAnchor("TOPLEFT", upButton, 0, 0)
  upButtonPushedBackground:AddAnchor("BOTTOMRIGHT", upButton, 0, 0)
  upButton:SetPushedBackground(upButtonPushedBackground)

  local upButtonDisabledBackground = assert(upButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  upButtonDisabledBackground:SetTextureInfo("scroll_button_up", "disable")
  upButtonDisabledBackground:AddAnchor("TOPLEFT", upButton, 0, 0)
  upButtonDisabledBackground:AddAnchor("BOTTOMRIGHT", upButton, 0, 0)
  upButton:SetDisabledBackground(upButtonDisabledBackground)

  -- Create a slider for the slider frame.
  local slider = sliderFrame:CreateChildWidget("slider", "slider", 0, true)
  slider:AddAnchor("TOPLEFT", upButton, "BOTTOMLEFT", 0, 0)

  local sliderBackground = slider:CreateDrawable(TEXTURE_PATH.SCROLL, "scroll_frame_bg", "background")
  sliderBackground:SetTextureColor("default")
  sliderBackground:AddAnchor("TOPLEFT", slider, 3, -9)
  sliderBackground:AddAnchor("BOTTOMRIGHT", slider, -3, 9)

  -- Create a thumb for the slider.
  local thumb = slider:CreateChildWidget("button", "thumb", 0, true)
  thumb:EnableDrag(true)
  thumb:SetWidth(20)

  local normalBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_df", "background")
  normalBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  normalBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetNormalBackground(normalBackground)

  local highlightBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_ov", "background")
  highlightBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  highlightBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetHighlightBackground(highlightBackground)

  local pushedBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_on", "background")
  pushedBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  pushedBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetPushedBackground(pushedBackground)

  slider:SetThumbButtonWidget(thumb)

  -- Create a down button for the slider frame.
  local downButton = sliderFrame:CreateChildWidget("button", "downButton", 0, true)
  downButton:SetExtent(20, 12)
  downButton:AddAnchor("BOTTOMRIGHT", sliderFrame, 0, 0)
  -- upButton:SetStyle("slider_scroll_button_down") -- This doesn't exist yet.

  local downButtonNormalBackground = assert(downButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  downButtonNormalBackground:SetTextureInfo("scroll_button_down", "normal")
  downButtonNormalBackground:AddAnchor("TOPLEFT", downButton, 0, 0)
  downButtonNormalBackground:AddAnchor("BOTTOMRIGHT", downButton, 0, 0)
  downButton:SetNormalBackground(downButtonNormalBackground)

  local downButtonHighlightBackground = assert(downButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  downButtonHighlightBackground:SetTextureInfo("scroll_button_down", "over")
  downButtonHighlightBackground:AddAnchor("TOPLEFT", downButton, 0, 0)
  downButtonHighlightBackground:AddAnchor("BOTTOMRIGHT", downButton, 0, 0)
  downButton:SetHighlightBackground(downButtonHighlightBackground)

  local downButtonPushedBackground = assert(downButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  downButtonPushedBackground:SetTextureInfo("scroll_button_down", "click")
  downButtonPushedBackground:AddAnchor("TOPLEFT", downButton, 0, 0)
  downButtonPushedBackground:AddAnchor("BOTTOMRIGHT", downButton, 0, 0)
  downButton:SetPushedBackground(downButtonPushedBackground)

  local downButtonDisabledBackground = assert(downButton:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background"))
  downButtonDisabledBackground:SetTextureInfo("scroll_button_down", "disable")
  downButtonDisabledBackground:AddAnchor("TOPLEFT", downButton, 0, 0)
  downButtonDisabledBackground:AddAnchor("BOTTOMRIGHT", downButton, 0, 0)
  downButton:SetDisabledBackground(downButtonDisabledBackground)

  slider:AddAnchor("BOTTOMRIGHT", downButton, "TOPRIGHT", 0, 0)

  -- Create a list for the content frame.
  local addonsListCtrl = scrollFrame:CreateChildWidget("listctrl", "addonsListCtrl", 0, true)
  addonsListCtrl:AddAnchor("TOPLEFT", 0, 0)
  addonsListCtrl:SetWidth(scrollFrame:GetWidth())
  addonsListCtrl:SetHeight(WINDOW.ITEM_DIMENSION * #addons)
  addonsListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)
  addonsListCtrl:InsertColumn(addonsListCtrl:GetWidth() - WINDOW.ITEM_DIMENSION * 3, LCCIT_TEXTBOX)
  addonsListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)
  addonsListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)
  addonsListCtrl:InsertRows(#addons, false)
  addonsListCtrl:SetHeaderColumnHeight(0)

  local overedImage = addonsListCtrl:CreateOveredImage()
  overedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
  overedImage:SetTextureInfo("enchant_info_bg", "listctrl_overed_default")

  -- Without InsertData overedImage won't work. Putting InsertData inside the
  -- main loop was causing a bug where addonNameTextbox.style:SetEllipsis(true)
  -- wouldn't work so it has been moved to its own loop.
  for row, _ in pairs(addons) do
    addonsListCtrl:InsertData(row, 2, "")
  end

  for row, addon in pairs(addons) do
    local rowWindow = addonsListCtrl.items[row]
    local checkButton, addonNameTextbox, settingsButton, refreshButton = unpack(
      rowWindow.subItems
    )
    rowWindow.addon = addon

    local checkButtonBackground = checkButton:CreateDrawable(TEXTURE_PATH.CHECK_BTN, "btn_df", "background")
    checkButtonBackground:SetExtent(20, 20)
    checkButtonBackground:AddAnchor("CENTER", checkButton, 0, 0)
    checkButton.background = checkButtonBackground

    local checkButtonCheckedBackground = checkButton:CreateDrawable(TEXTURE_PATH.CHECK_BTN, "btn_chk_df", "background")
    checkButtonCheckedBackground:SetExtent(20, 20)
    checkButtonCheckedBackground:AddAnchor("CENTER", checkButton, 0, 0)
    checkButton.checkedBackground = checkButtonCheckedBackground

    addonNameTextbox.style:SetColorByKey("default")
    addonNameTextbox.style:SetAlign(ALIGN_LEFT)
    addonNameTextbox.style:SetFontSize(FONT_SIZE.LARGE)
    addonNameTextbox.style:SetEllipsis(true)
    addonNameTextbox:SetAutoWordwrap(false)
    addonNameTextbox:SetText(addon.name)

    settingsButton:SetStyle("button_common_option")

    refreshButton:SetExtent(20, 20)

    local refreshNormalBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
      "background"))
    refreshNormalBackground:SetTextureInfo("reset_df")
    refreshNormalBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
    refreshNormalBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
    refreshButton:SetNormalBackground(refreshNormalBackground)

    local refreshHighlightBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
      "background"))
    refreshHighlightBackground:SetTextureInfo("reset_ov")
    refreshHighlightBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
    refreshHighlightBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
    refreshButton:SetHighlightBackground(refreshHighlightBackground)

    local refreshPushedBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
      "background"))
    refreshPushedBackground:SetTextureInfo("reset_on")
    refreshPushedBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
    refreshPushedBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
    refreshButton:SetPushedBackground(refreshPushedBackground)

    local refreshDisabledBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
      "background"))
    refreshDisabledBackground:SetTextureInfo("reset_dis")
    refreshDisabledBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
    refreshDisabledBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
    refreshButton:SetDisabledBackground(refreshDisabledBackground)

    SetViewOfRow(rowWindow)
  end

  local min = 0
  local max = math.max(min, addonsListCtrl:GetHeight() - scrollFrame:GetHeight())

  slider:SetMinMaxValues(min, max)

  if max == min then
    upButton:Enable(false)
    thumb:Enable(false)
    downButton:Enable(false)
    sliderBackground:SetTextureColor("disable")
  end

  return window
end
