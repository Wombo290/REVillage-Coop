local ReflectionProbe = dofile("reframework/autorun/VillageCoop/ReflectionProbe.lua")

local function fake_type(name)
    return { get_full_name = function() return name end }
end

local player_type = {
    get_full_name = function() return "app.PlayerCharacter" end,
    get_parent_type = function() return fake_type("via.Component") end,
    get_fields = function()
        return { { get_name = function() return "Health" end, get_type = function() return fake_type("System.Single") end } }
    end,
    get_methods = function()
        return { { get_name = function() return "get_Health" end, get_return_type = function() return fake_type("System.Single") end, get_param_types = function() return {} end } }
    end,
}

local player = { get_type_definition = function() return player_type end }
local manager = { call = function(_, method) if method == "get_CurrentPlayer" then return player end error("unexpected accessor") end }
local sdk_api = { get_managed_singleton = function(name) assert(name == "app.PlayerManager") return manager end }

local result = ReflectionProbe.run(sdk_api)
assert(result.ok == true)
assert(result.type_name == "app.PlayerCharacter")
assert(result.parent_type == "via.Component")
assert(result.fields[1] == "System.Single Health")
assert(result.methods[1] == "System.Single get_Health()")

local missing = ReflectionProbe.run({ get_managed_singleton = function() return nil end })
assert(missing.ok == false)
assert(missing.error == "No compatible player access path succeeded")

print("reflection_probe_test: ok")
