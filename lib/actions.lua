--
-- ACTIONS
--
function M.add_edit_macro(num)
	MacroEditor:SetHidden(false)
	MacroIcon:SetHidden(false)

	MacroIconFwd:SetColor( unpack( M.saved.default_color ) )
	MacroIconBk:SetColor( unpack( M.saved.default_color ) )

	MacroEditor:ClearAnchors()
	MacroEditor:SetAnchor( CENTER, GuiRoot, CENTER, 0, 0)
	MacroBody:SetMaxInputChars(65534)
	MacroBody:SetHandler( "OnEscape", function()
		MacroBody:LoseFocus()
	end)
	MacroBody:SetHandler( "OnEnter", function()
		MacroBody:TakeFocus()
	end)

	local n = M.saved.current_editor_icon
	if ( n == nil or n == 0 ) then
		n = M.saved.macros[num]["icon"]
	elseif ( n == nil or n == 0 ) then
		n =  M.saved.default_macro_icon
	end

	local icon = GameImages[n]
	M.saved.current_editor_icon = n
	MacroIcon:SetTexture(icon)

	MacroIconFwd:SetHandler( "OnMouseDown", function()
		local n = M.saved.current_editor_icon
		if ( n == nil or n == 0 ) then
			n = M.saved.macros[num]["icon"]
		elseif ( n == nil or n == 0 ) then
			n =  M.saved.default_macro_icon
		end
		n = n + 1
		if ( n > M.get_table_length(GameImages) ) then
			n = 1
		end
		local icon = GameImages[n]
		M.saved.current_editor_icon = n
		MacroIcon:SetTexture(icon)
	end)

	MacroIconBk:SetHandler( "OnMouseDown", function()
		local n = M.saved.current_editor_icon
		if ( n == nil or n == 0 ) then
			n = M.saved.macros[num]["icon"]
		elseif ( n == nil or n == 0 ) then
			n =  M.saved.default_macro_icon
		end
		n = n - 1
		if ( n < 1 ) then
			n = M.get_table_length(GameImages)
		end
		local icon = GameImages[n]
		M.saved.current_editor_icon = n
		MacroIcon:SetTexture(icon)
	end)

	MacroBodyOk:SetHandler( "OnMouseDown", function()
		local text = MacroBody:GetText()
		local lines = {}
		for line in string.gmatch( text, "([^\n]+)[\n]?" ) do
			table.insert( lines, line )
		end
		M.saved.macros[num]["name"] = MacroName:GetText()
		M.saved.macros[num]["icon"] = M.saved.current_editor_icon
		M.saved.macros[num]["body"] = lines
		M.saved.current_editor_icon = M.saved.default_macro_icon
		MacroEditor:SetHidden(true)
		M.place_macros()
	end)

	MacroBodyCancel:SetHandler( "OnMouseDown", function()
		MacroBody:SetText("")
		MacroEditor:SetHidden(true)
		M.saved.current_editor_icon = M.saved.default_macro_icon
	end)

	MacroDelete:SetHandler( "OnMouseDown", function()
		MacroDelete:SetHidden(true)
		MacroEditor:SetHidden(true)
		M.saved.current_editor_icon = M.saved.default_macro_icon
		M.saved.macros[num]["name"] = ""
		M.saved.macros[num]["icon"] = 0
		M.saved.macros[num]["body"] = {}
		--M.saved.macros[num] = nil
		M.place_macros()
	end)

	if not ( M.saved.macros[num] == nil or M.saved.macros[num] == {} ) then
		MacroDelete:SetHidden(false)
		MacroName:SetText( M.saved.macros[num]["name"] )
		MacroBody:SetText( table.concat( M.saved.macros[num]["body"], "\n" ) )
	end
end

function M.execute_macro( lines )
	for i,c in ipairs( lines ) do
		local cmd, args = c:match( "(%S+)%s*(.*)" )
		if not ( args == nil or args == "" ) then
			args = " " .. args
		end

		if ( cmd == "/echo" ) then
			d( args )
		elseif ( cmd == "/pause" or cmd == "/wait" ) then
			--ignore, QED event_queue
		elseif ( M.saved.emotes[cmd] ~= nil ) then
			PlayEmote( M.saved.emotes[ cmd ] )
		else
			ZO_ChatWindowTextEntryEditBox:SetText( cmd .. args )
		end
	end
end

function M.perform_macro( num, lines )
	if ( type(lines) == "function" ) then
		lines()
	elseif ( M.get_table_length(lines) == 0 ) then
		M.add_edit_macro(num)
	else
		local n = M.get_table_length( M.saved.command_queue ) + 1
		if ( M.saved.command_queue[n] == nil ) then
			M.saved.command_queue[n] = {
				[num] = {}
			}
		end
		for i,c in ipairs(lines) do
			table.insert( M.saved.command_queue[n][num], c )
		end
	end
end

function M.place_macros( pane, spacer )
	if ( pane == nil ) then
		pane = M.saved.current_macro_pane
	elseif ( pane == 0 ) then
		pane = M.saved.maximum_macro_count / 10
	end
	M.saved.current_macro_pane = pane

	if ( spacer == nil or spacer == 0 ) then spacer = 51 end

	local orientation = M.saved.addon_orientation

	local elem = 0
	local delta_y = 1
	local starts = ( pane - 1 ) * 10
	local ends = starts + 10
	
	if ( ends > M.saved.maximum_macro_count ) then
		pane = 1
		starts = 0
		ends = 10
		M.saved.current_macro_pane = 1
	end

	for i = 1 + starts, ends, 1 do
		local title = ""

		elem = elem + 1

		if ( M.saved.macros[i] == nil ) then M.saved.macros[i] = {} end
		if ( M.saved.macros[i]["name"] == nil or M.saved.macros[i]["name"] == "" ) then
			title = i
		else
			title = M.saved.macros[i]["name"]
		end

		if ( M.saved.macros[i]["icon"] == nil ) then
			M.saved.macros[i]["icon"] = 0
		end

		if ( M.saved.macros[i]["body"] == nil ) then
			M.saved.macros[i]["body"] = {}
		end

		local control = {}
		local label = {}

		if not ( wm:GetControlByName( elem ) ) then
			control = wm:CreateControl( elem, MacroPoetry, CT_BACKDROP )
			control:SetParent(MacroPoetry)
			control:SetInheritScale(true)
			control:SetDimensionConstraints(50,50,50,50)
			control:SetResizeToFitDescendents(true)
			control:SetMouseEnabled(true)
			control:SetPixelRoundingEnabled(false)
			control:SetEdgeColor( 0, 0, 0, 0 )

			if ( M.saved.macros[i]["icon"] ~= 0 ) then
				control:SetCenterTexture( GameImages[ M.saved.macros[i]["icon"] ] )
				control:SetCenterColor( unpack( M.saved.default_color ) )
			else
			-- /esoui/art/contacts/notificationicon_friend.dds
				control:SetCenterTexture( GameImages[ 421 ] )
				control:SetCenterColor( unpack( M.saved.slot_color ) )
			end

			control:SetHandler("OnMouseDown", function(self, button)
				if button == 1 then
					M.perform_macro( i, M.saved.macros[i]["body"] )
				else
					M.add_edit_macro( i )
				end
			end)

			label = wm:CreateControl( "label_" .. elem, control, CT_LABEL )
			label:SetInheritScale(true)
			label:SetDimensionConstraints(40,25,40,25)
			label:SetAnchor(CENTER, control, CENTER, 0, 0)
			label:SetFont("ZoFontGame")
			label:SetText( title )
			label:SetColor( unpack( M.saved.text_color ) )
			label:SetWrapMode(0)
			label:SetHorizontalAlignment(1)
		else
			control = wm:GetControlByName( elem )

			if ( M.saved.macros[i]["icon"] ~= 0 ) then
				control:SetCenterTexture( GameImages[ M.saved.macros[i]["icon"] ] )
				control:SetCenterColor( unpack( M.saved.default_color ) )
			else
			-- /esoui/art/contacts/notificationicon_friend.dds
				control:SetCenterTexture( GameImages[ 421 ] )
				control:SetCenterColor( unpack( M.saved.slot_color ) )
			end

			control:SetHandler("OnMouseDown", function(self, button)
				if button == 1 then
					M.perform_macro( i, M.saved.macros[i]["body"] )
				else
					M.add_edit_macro( i )
				end
			end)
			
			label = wm:GetControlByName( "label_" .. elem )
			label:SetAnchor(CENTER, control, CENTER, 0, 0)
			label:SetText( title )
			label:SetColor( unpack( M.saved.text_color ) )
			label:SetWrapMode(0)
		end

		control:SetHandler( "OnMouseEnter", function()
			if ( M.saved.macros[i]["icon"] ~= 0 ) then
				control:SetCenterTexture( GameImages[ M.saved.macros[i]["icon"] ] )
			else
				control:SetCenterTexture("")
			end
			control:SetCenterColor( unpack( M.saved.slot_hover_color ) )
		end )

		control:SetHandler( "OnMouseExit", function()
			if ( M.saved.macros[i]["icon"] ~= 0 ) then
				control:SetCenterColor( unpack( M.saved.default_color ) )
			else
				control:SetCenterColor( unpack( M.saved.slot_color ) )
			end
		end )

		MacroPoetry:SetHandler( "OnMouseEnter", function()
			wm:SetMouseCursor(6)
		end)
		
		MacroPoetry:SetHandler( "OnMouseExit", function()
			wm:SetMouseCursor(0)
		end)

		MP_PaneFwd:SetHandler( "OnMouseDown", function()
			M.place_macros( M.saved.current_macro_pane + 1 )
		end)

		MP_PaneBk:SetHandler( "OnMouseDown", function()
			M.place_macros( M.saved.current_macro_pane - 1 )
		end)

		if ( orientation == 'v' ) then
			MP_Close:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 25, -5)
			MP_About:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 25, 16)
			MP_Orientation:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, -5)
			MP_DumpQueue:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, 15)
			
			MP_PaneFwd:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 35, 581)
			MP_PaneLabel:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 21, 580)
			MP_PaneBk:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, 581)
			
			control:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, 65 + delta_y)
		else
			MP_Close:SetAnchor(TOPLEFT, MacroPoetry, TOPRIGHT, -22, -5)
			MP_About:SetAnchor(TOPLEFT, MacroPoetry, TOPRIGHT, -22, 26)
			MP_Orientation:SetAnchor(TOPLEFT, MacroPoetry, TOPRIGHT, -42, -5)
			MP_DumpQueue:SetAnchor(TOPLEFT, MacroPoetry, TOPRIGHT, -42, 25)
			
			MP_PaneFwd:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, -3)
			MP_PaneLabel:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 5, 15)
			MP_PaneBk:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 0, 35)
			
			control:SetAnchor(TOPLEFT, MacroPoetry, TOPLEFT, 20 + delta_y, 0)
		end

		MP_PaneLabel:SetFont("ZoFontGameSmall")
		MP_PaneLabel:SetText(pane)

		delta_y = delta_y + spacer
	end
end