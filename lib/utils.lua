--
-- UTIL
--
function M.dec_2_hex( colors )
	return '|c' .. M.DEC_HEX(colors[1]*255) .. M.DEC_HEX(colors[2]*255) .. M.DEC_HEX(colors[3]*255)
end

function M.DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	if IN == 0 then
		OUT=0
		return OUT
	end 	
    while IN > 0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function M.get_table_length(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function M.pairs_by_keys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end

function M.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function M.hide_tooltip()
	MP_Tooltip:SetHidden(true)
	MP_Tooltip:SetText("")
end

function M.show_tooltip(text, anchor)
	if ( anchor == nil ) then anchor = MacroPoetry end
	MP_Tooltip:SetHidden(false)
	local l, t, r, b = anchor:GetScreenRect()
	local x, y = 0, 0
	
	if ( t < 20 ) then --near top
		y = 75
	elseif ( t > 950 ) then
		y = -75
	end
	
	if ( l < 20 ) then
		x = 150
	elseif ( l > 1700 ) then
		x = -150
	end
	
	MP_Tooltip:SetAnchor( CENTER, anchor, CENTER, x, y )
	MP_Tooltip:SetText(text)
end

function M.stopped()
	local x, y = MacroPoetry:GetCenter()
	M.saved.display_position.x = x
	M.saved.display_position.y = y
	M.get_addon_orientation()
end

function M.get_addon_orientation()
	local l, t, r, b = MacroPoetry:GetScreenRect()
	if ( r - l > 150 or b - t < 300 ) then
		M.saved.addon_orientation = 'h'
		return 'h'
	else
		M.saved.adoon_orientation = 'v'
		return 'v'
	end
end

function M.set_addon_orientation()
	if ( M.saved.addon_orientation == 'v' ) then
		MacroPoetry:SetDimensions( 50, 600 )
		M.place_macros()
	elseif ( M.saved.addon_orientation == 'h' ) then
		MacroPoetry:SetDimensions( 600, 50 )
		M.place_macros()
	end
end

function M.toggle_addon_orientation()
	M.get_addon_orientation()
	if ( M.saved.addon_orientation == 'h' ) then
		MacroPoetry:SetDimensions( 50, 600 )
		M.saved.addon_orientation = 'v'
		M.place_macros()
	elseif ( M.saved.addon_orientation == 'v' ) then
		MacroPoetry:SetDimensions( 600, 50 )
		M.saved.addon_orientation = 'h'
		M.place_macros()
	end
end

function M.toggle_addon_visible(toggle)
	if ( toggle == nil ) then
		if ( MacroPoetry:IsHidden() == true ) then
			toggle = true
		else
			toggle = false
		end
	end

	if ( toggle == true ) then
		MacroPoetry:SetHidden(false)
		MacroPoetry.hidden = false
	elseif ( toggle == false ) then
		MacroPoetry:SetHidden(true)
		MacroPoetry.hidden = true
	end
end