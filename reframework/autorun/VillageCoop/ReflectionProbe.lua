local ReflectionProbe = {}

ReflectionProbe.DEFAULT_PLAYER_PATHS = {
    {
        singleton = "PropsManager",
        game_namespace = true,
        accessors = { "get_Player" },
    },
    {
        singleton = "app.PlayerManager",
        accessors = { "get_CurrentPlayer", "get_Player", "get_ManualPlayer" },
    },
}

local function attempt(label, operation)
    local ok, value = pcall(operation)
    if not ok then return nil, label .. " failed: " .. tostring(value) end
    if value == nil then return nil, label .. " returned nil" end
    return value, nil
end

local function type_name(type_definition)
    if type_definition == nil then return "Unknown" end
    local name = attempt("get_full_name", function() return type_definition:get_full_name() end)
    return name and tostring(name) or "Unknown"
end

local function describe_field(field)
    local name = attempt("field.get_name", function() return field:get_name() end)
    local field_type = attempt("field.get_type", function() return field:get_type() end)
    return string.format("%s %s", type_name(field_type), name and tostring(name) or "<unnamed>")
end

local function describe_method(method)
    local name = attempt("method.get_name", function() return method:get_name() end)
    local return_type = attempt("method.get_return_type", function() return method:get_return_type() end)
    local parameter_types = attempt("method.get_param_types", function() return method:get_param_types() end) or {}
    local parameters = {}
    for _, parameter_type in ipairs(parameter_types) do
        table.insert(parameters, type_name(parameter_type))
    end
    return string.format("%s %s(%s)", type_name(return_type), name and tostring(name) or "<unnamed>", table.concat(parameters, ", "))
end

local function enumerate(type_definition, getter_name, describe)
    local members, err = attempt(getter_name, function()
        return type_definition[getter_name](type_definition)
    end)
    if members == nil then return {}, err end

    local results = {}
    for _, member in ipairs(members) do
        local ok, description = pcall(describe, member)
        table.insert(results, ok and description or "<unreadable: " .. tostring(description) .. ">")
    end
    table.sort(results)
    return results, nil
end

function ReflectionProbe.resolve_player(sdk_api, paths)
    local checks = {}
    for _, path in ipairs(paths or ReflectionProbe.DEFAULT_PLAYER_PATHS) do
        local singleton_name = path.singleton
        if path.game_namespace then
            local resolved_name, namespace_err = attempt("sdk.game_namespace(" .. path.singleton .. ")", function()
                return sdk_api.game_namespace(path.singleton)
            end)
            table.insert(checks, { path = "game_namespace:" .. path.singleton, ok = resolved_name ~= nil, detail = namespace_err or tostring(resolved_name) })
            singleton_name = resolved_name
        end

        local manager, manager_err = attempt("sdk.get_managed_singleton(" .. tostring(singleton_name) .. ")", function()
            if singleton_name == nil then return nil end
            return sdk_api.get_managed_singleton(singleton_name)
        end)
        table.insert(checks, { path = tostring(singleton_name), ok = manager ~= nil, detail = manager_err or "managed singleton available" })

        if manager ~= nil then
            for _, accessor in ipairs(path.accessors) do
                local player, accessor_err = attempt(tostring(singleton_name) .. ":" .. accessor, function()
                    return manager:call(accessor)
                end)
                table.insert(checks, { path = tostring(singleton_name) .. ":" .. accessor, ok = player ~= nil, detail = accessor_err or "player object available" })
                if player ~= nil then return player, checks end
            end
        end
    end
    return nil, checks
end

function ReflectionProbe.probe_object(object)
    local result = { ok = false, type_name = "Unknown", parent_type = "None", fields = {}, methods = {}, checks = {} }
    if object == nil then result.error = "Player object is nil" return result end

    local type_definition, type_err = attempt("object.get_type_definition", function() return object:get_type_definition() end)
    if type_definition == nil then result.error = type_err return result end

    result.type_name = type_name(type_definition)
    local parent = attempt("type.get_parent_type", function() return type_definition:get_parent_type() end)
    if parent ~= nil then result.parent_type = type_name(parent) end

    local fields, fields_err = enumerate(type_definition, "get_fields", describe_field)
    local methods, methods_err = enumerate(type_definition, "get_methods", describe_method)
    result.fields = fields
    result.methods = methods
    result.ok = fields_err == nil and methods_err == nil
    result.partial = not result.ok and (#fields > 0 or #methods > 0)
    result.error = fields_err or methods_err
    return result
end

function ReflectionProbe.run(sdk_api, paths)
    local player, checks = ReflectionProbe.resolve_player(sdk_api, paths)
    local result = ReflectionProbe.probe_object(player)
    result.checks = checks
    if player == nil then result.error = "No compatible player access path succeeded" end
    return result
end

return ReflectionProbe
