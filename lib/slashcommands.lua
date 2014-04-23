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

	SLASH_COMMANDS["/echo"]	= function (extra) d(extra) end
	SLASH_COMMANDS["/emotes"] = function (extra) for e in M.pairs_by_keys(M.saved.emotes) do d( e ) end end
end