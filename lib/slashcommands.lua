--
-- SLASH COMMANDS
--
function M.add_slash_commands()
	SLASH_COMMANDS["/macro"] = function()
		if ( MacroPoetry.hidden ) then
			M.toggle_addon_visible(true)
			M.saved.addon_visible = true
		else
			M.toggle_addon_visible(false)
			M.saved.addon_visible = false
		end
	end

	SLASH_COMMANDS["/dump"] = function() M.dump_command_queue() end
	SLASH_COMMANDS["/echo"]	= function (extra) d(extra) end
	SLASH_COMMANDS["/emotes"] = function (extra) for e in M.pairs_by_keys(M.saved.emotes) do d( e ) end end
	SLASH_COMMANDS["/money"] = function ()
		local cash = GetCurrentMoney()
		local bank = GetBankedMoney()
		d( "|cFF6633Cash: |c66FF33" .. tostring(cash) .. "|r" )
		d( "|cFF6633Bank: |c66FF33" .. tostring(bank) .. "|r" )
	end

	SLASH_COMMANDS["/mail"] = function(extra)
		if ( extra ~= "" ) then
			d( "|c33FF66Sending Mail...|r" )
			local to, sub, body = extra:match( "(%S+)%s*(%S+)%s*(.*)" )
			SendMail( to, sub, body)
		else
			d("|cFF6633Usage: /mail [to] [subject] [body]|r")
			d("|cFF6633	Send an in game mail to another player.|r")
		end
	end

	SLASH_COMMANDS["/playtime"] = function()
		d( "|cFF6633Time Played: |c66FF33" .. tostring( M.round( GetSecondsPlayed() / 86400, 2 ) ) .. " days.|r" )
	end

	SLASH_COMMANDS["/repair"] = function()
		d( "|c33FF66Attempting Repair...|r" )
		RepairAll()
	end

	SLASH_COMMANDS["/repaircost"] = function()
		d( "|cFF6633Total Repair Cost: |c66FF33" .. tostring(GetRepairAllCost()) .. "|r" )
	end

	SLASH_COMMANDS["/whereami"] = function()
		d( "|c66FF33" .. GetPlayerLocationName() .. "|r" )
	end

	SLASH_COMMANDS["/whoami"] = function()
		d( "|c66FF33" .. GetDisplayName() .. "|r" )
	end

end