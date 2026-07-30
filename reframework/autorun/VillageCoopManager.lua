-- Resident Evil Village Co-op Manager v0.3.6
-- Modular, compatibility-first foundation for REFramework v1.5.9.

local VK_F8 = 0x77
local ROOT = "reframework/autorun/VillageCoop/"

local function load_module(relative_path)
    local candidates = {
        ROOT .. relative_path,
        "autorun/VillageCoop/" .. relative_path,
        "VillageCoop/" .. relative_path,
    }

    local errors = {}
    for _, path in ipairs(candidates) do
        local ok, result = pcall(dofile, path)
        if ok and result ~= nil then
            return result
        end
        table.insert(errors, path .. ": " .. tostring(result))
    end

    error("Could not load module " .. relative_path .. "\n" .. table.concat(errors, "\n"))
end

local State = load_module("Core/State.lua")
local Logger = load_module("Core/Logger.lua")
local Events = load_module("Core/Events.lua")
local Config = load_module("Core/Config.lua")
local NativeBridge = load_module("Native/NativeBridge.lua")
local ReflectionManager = load_module("Reflection/ReflectionManager.lua")
local Window = load_module("UI/Window.lua")

local context = {
    state = State,
    logger = Logger,
    events = Events,
    config = Config,
    native = NativeBridge,
    reflection = ReflectionManager,
}

local function key_down(key)
    local ok, value = pcall(function()
        return reframework:is_key_down(key)
    end)
    return ok and value == true
end

local config_ok, config_error = Config.load()
Config.apply_to_state(State)
if config_ok then
    Logger.info("Configuration loaded.")
else
    Logger.warn("Configuration fallback used: " .. tostring(config_error))
end

Events.on("network.host_intent", function()
    Logger.debug("Host intent event received.")
end)
Events.on("network.join_intent", function()
    Logger.debug("Join intent event received.")
end)

State.runtime.status = "Ready"
State.runtime.last_action = "Village Co-op modular foundation loaded."
Logger.info("Village Co-op Manager v" .. State.version .. " loaded.")

re.on_frame(function()
    State.runtime.frame_count = State.runtime.frame_count + 1
    State.runtime.fps_frames = State.runtime.fps_frames + 1

    local now = os.clock()
    if now - State.runtime.fps_timer >= 1.0 then
        State.runtime.fps = State.runtime.fps_frames
        State.runtime.fps_frames = 0
        State.runtime.fps_timer = now
    end

    NativeBridge.refresh(State)

    local down = key_down(VK_F8)
    if down and not State.ui.f8_was_down then
        State.ui.window_open = not State.ui.window_open
        Logger.info(State.ui.window_open and "Window opened with F8." or "Window hidden with F8.")
    end
    State.ui.f8_was_down = down

    if not State.ui.window_open then return end

    imgui.set_next_window_size({760, 560}, 4)

    local ok, result = xpcall(function()
        local title = string.format(
            "Resident Evil Village Co-op - Alpha v%s##VillageCoopStableWindow",
            State.version
        )
        local visible = imgui.begin_window(title, true, 0)
        if visible then Window.draw(context) end
        imgui.end_window()
        return visible
    end, debug.traceback)

    if ok then
        State.ui.window_open = result == true
    else
        State.ui.fatal_error = tostring(result)
        Logger.error("UI failure: " .. State.ui.fatal_error)
        State.ui.window_open = false
    end
end)

re.on_draw_ui(function()
    local label = State.ui.window_open and "Hide Village Co-op Window (F8)" or "Show Village Co-op Window (F8)"
    if imgui.button(label .. "##VillageCoopRecovery") then
        State.ui.window_open = not State.ui.window_open
    end
    imgui.text("Village Co-op Manager v" .. State.version .. " modular build")
    if State.ui.fatal_error then
        imgui.text("Last UI error: " .. State.ui.fatal_error)
    end
end)
