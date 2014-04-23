--
-- FINAL
--
EVENT_MANAGER:RegisterForEvent( "MacroPoetry", EVENT_ADD_ON_LOADED , M.on_init )

EVENT_MANAGER:RegisterForEvent("MacroPoetry_LayerPushEvent", EVENT_ACTION_LAYER_PUSHED, M.auto_hide )
EVENT_MANAGER:RegisterForEvent("MacroPoetry_LayerPopEvent", EVENT_ACTION_LAYER_POPPED, M.auto_unhide )