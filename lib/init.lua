--
-- INIT
--
function M.init()
	M.saved = {
		["addon_visible"] = true,
		["addon_orientation"] = 'v',
		["account_name"] = GetDisplayName(),

		["default_color"] = { 207, 220, 189 },	--ElderScrolls Default-Text (Cream/Tan)
		["text_color"] = { 0.90, 0.90, 0.90, 1 }, -- Macro Text Color
		["slot_color"] = { 0, 0, 0, 0 }, -- Macro Slot Frame Color		
		["slot_hover_color"] = { 128/255, 128/255, 240/255, 1 },	-- Periwinkle
		["close_hover_color"] = { 255, 192, 1 },	-- Orange

		["title_hover_color"] = { 0, 192, 255 },	-- Aqua

		["default_macro_icon"] = 546,
		["current_editor_icon"] = 546,

		["current_macro_pane"] = 1,
		["maximum_macro_count"] = 100,
		["display_position"] = { ["x"] = 1400, ["y"] = 400 },

		["macros"] = {},
		["emotes"] = {},
		["command_queue"] = {},
		["BufferTable"] = {},
	}

	for i = 0, GetNumEmotes() do
		if ( GetEmoteSlashName(i) ~= nil ) then
			M.saved.emotes[ GetEmoteSlashName(i) ] = i
		end
	end

end

function M.on_init( event, name )
	if name ~= "MacroPoetry" then return end
	EVENT_MANAGER:UnregisterForEvent(name, event)
	M.init()
	M.add_slash_commands()
	M.create_settings_ui()
	M.load_saved_vars()

	-- Event / Command Queue Processor
	MacroPoetry:SetHandler("OnUpdate", function(self, timerun)
		if ( M.get_table_length( M.saved.command_queue ) > 0 ) then
			local first = M.saved.command_queue[1]
			local cmd, args = first:match( "(%S+)%s*(.*)" )
			if ( cmd == "/pause" or cmd == "/wait" ) then
				if M.buffer_reached( 'sleep', tonumber(args) ) then
					table.remove( M.saved.command_queue, 1 )
				else
					return
				end
			end
			M.execute_macro( { M.saved.command_queue[1] } )
			table.remove( M.saved.command_queue, 1 )
		end
	end)

end

local BufferTable = {}
function M.buffer_reached(key, buffer)
    if key == nil then return end
    if BufferTable[key] == nil then BufferTable[key] = {} end
    BufferTable[key].buffer = tonumber(buffer) or 3
    BufferTable[key].now = GetFrameTimeSeconds()
    if BufferTable[key].last == nil then BufferTable[key].last = BufferTable[key].now end
    BufferTable[key].diff = BufferTable[key].now - BufferTable[key].last
    BufferTable[key].eval = BufferTable[key].diff >= BufferTable[key].buffer
    if BufferTable[key].eval then
		BufferTable[key].last = BufferTable[key].now
		BufferTable[key] = nil
		return true
	end
    return false
end

function M.dump_command_queue()
	local count = M.get_table_length( M.saved.command_queue )
	M.saved.command_queue = {}
	d( "Dumped " .. tostring(count) .. " commands." )
end

function M.load_saved_vars()
	M.saved = ZO_SavedVars:NewAccountWide( "MacroPoetry_SavedVariables", M.version, "saved", M.saved )
	local x = M.saved.display_position.x
	local y = M.saved.display_position.y
	M.toggle_addon_visible( M.saved.addon_visible )
	MacroPoetry:ClearAnchors()
	MacroPoetry:SetAnchor( CENTER, GuiRoot, TOPLEFT, x, y )
	M.set_addon_orientation()
	M.place_macros()
end

function M.create_settings_ui()
	M.saved.SettingsWindow = LAM:CreateControlPanel("MacroPoetry_Settings", "|c77DAFFMacro|cFF77DAPoetry|r")
	LAM:AddHeader(M.saved.SettingsWindow, "MacroPoetry_UIAbout", "About")
	LAM:AddDescription(M.saved.SettingsWindow, "MacroPoetry_About", "by @archpoet.")
	LAM:AddHeader(M.saved.SettingsWindow, "MacroPoetry_UIOptions", "Options")
	LAM:AddEditBox(M.saved.SettingsWindow, "MacroPoetry_MaxMacros",  "|cFF9999* Max Number of Macros|r", "Change to anything you want, but remeber it all costs system resources.", false, M.get_maxmacros_setting, M.set_maxmacros_setting, false, "")
	LAM:AddColorPicker(M.saved.SettingsWindow, "MacroPoetry_ChatColor", "Macro Text Color", "This changes the color of the macro UI text.", M.get_textcolor_setting, M.set_textcolor_setting, false, "")
	LAM:AddColorPicker(M.saved.SettingsWindow, "MacroPoetry_SlotHoverColor", "Macro Slot Hover Color", "This changes the hover color of the macro UI slot.", M.get_slothovercolor_setting, M.set_slothovercolor_setting, false, "")	
end

function M.get_maxmacros_setting() return M.saved.maximum_macro_count end
function M.set_maxmacros_setting( n )
	M.saved.maximum_macro_count = n
end

function M.get_slotcolor_setting() return unpack( M.saved.slot_color ) end
function M.set_slotcolor_setting( r, g, b, a )
	M.saved.slot_color = { r, g, b, a }
end

function M.get_slothovercolor_setting() return unpack( M.saved.slot_hover_color ) end
function M.set_slothovercolor_setting( r, g, b, a )
	M.saved.slot_hover_color = { r, g, b, a }
end

function M.get_textcolor_setting() return unpack( M.saved.text_color ) end
function M.set_textcolor_setting( r, g, b, a )
	M.saved.text_color = { r, g, b, a }
end

function M.auto_hide( layer, active )
	if ( active == 2 or active == 11 or active == 12 or active == 16 ) then
		M.toggle_addon_visible(false)
	end
end

function M.auto_unhide( layer, active )
	if ( active == 2 or active == 11 or active == 12 or active == 16) then
		M.toggle_addon_visible(true)
	end
end