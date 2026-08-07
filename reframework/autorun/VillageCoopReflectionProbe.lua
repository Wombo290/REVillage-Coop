local ReflectionProbe = require("VillageCoop/ReflectionProbe")

local result = nil
local MAX_VISIBLE_MEMBERS = 20

local function run_probe()
    local ok, value = xpcall(function() return ReflectionProbe.run(sdk) end, debug.traceback)
    if ok then
        result = value
        log.info(string.format("[VillageCoop] Reflection probe complete: ok=%s type=%s fields=%d methods=%d", tostring(result.ok), result.type_name, #result.fields, #result.methods))
    else
        result = { ok = false, error = tostring(value), type_name = "Unknown", parent_type = "None", fields = {}, methods = {}, checks = {} }
        log.error("[VillageCoop] Reflection probe failed safely: " .. result.error)
    end
end

local function draw_members(label, members)
    imgui.text(string.format("%s (%d)", label, #members))
    for index = 1, math.min(#members, MAX_VISIBLE_MEMBERS) do imgui.text("- " .. members[index]) end
    if #members > MAX_VISIBLE_MEMBERS then imgui.text(string.format("... %d more", #members - MAX_VISIBLE_MEMBERS)) end
end

re.on_draw_ui(function()
    imgui.text("Village Co-op v0.3.6 - Reflection Probe")
    imgui.text("Read-only check; only known player getters are invoked.")
    if imgui.button("Run player reflection probe") then run_probe() end
    if result == nil then imgui.text("Status: not run") return end

    imgui.text("Status: " .. (result.ok and "compatible" or (result.partial and "partial" or "unavailable")))
    imgui.text("Type: " .. result.type_name)
    imgui.text("Parent: " .. result.parent_type)
    if result.error then imgui.text("Last error: " .. result.error) end
    imgui.text("Player access checks:")
    for _, check in ipairs(result.checks) do
        imgui.text(string.format("- [%s] %s - %s", check.ok and "OK" or "--", check.path, check.detail))
    end
    draw_members("Fields", result.fields)
    draw_members("Methods", result.methods)
end)

log.info("[VillageCoop] v0.3.6 Reflection Probe loaded")
