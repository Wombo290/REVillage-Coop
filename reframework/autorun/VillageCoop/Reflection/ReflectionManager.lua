-- Village Co-op Reflection Manager v0.3.6
-- Read-only, compatibility-first wrapper around REFramework reflection APIs.

local ReflectionManager = {}

local function safe_call(label, fn, fallback)
    local ok, value = pcall(fn)
    if ok then
        if value ~= nil then return value, nil end
        return fallback, label .. " returned nil"
    end
    return fallback, label .. " failed: " .. tostring(value)
end

local function collection_to_table(collection)
    if collection == nil then return {} end
    if type(collection) == "table" then
        local output = {}
        for _, value in pairs(collection) do table.insert(output, value) end
        return output
    end

    local elements = safe_call("get_elements", function()
        return collection:get_elements()
    end, nil)
    if type(elements) == "table" then return elements end

    local count = safe_call("get_size", function()
        return collection:get_size()
    end, nil)
    if type(count) ~= "number" then
        count = safe_call("get_Count", function()
            return collection:call("get_Count")
        end, nil)
    end

    local output = {}
    if type(count) == "number" then
        for index = 0, count - 1 do
            local value = safe_call("get_Item", function()
                return collection:call("get_Item", index)
            end, nil)
            if value == nil then
                value = safe_call("index", function() return collection[index] end, nil)
            end
            if value ~= nil then table.insert(output, value) end
        end
    end
    return output
end

function ReflectionManager.is_valid(object)
    if object == nil then return false, "Object is nil" end
    local type_definition, err = ReflectionManager.get_type_definition(object)
    return type_definition ~= nil, err
end

function ReflectionManager.get_type_definition(object)
    if object == nil then return nil, "Object is nil" end
    return safe_call("get_type_definition", function()
        return object:get_type_definition()
    end, nil)
end

function ReflectionManager.get_type_info(object)
    local type_definition, err = ReflectionManager.get_type_definition(object)
    if type_definition == nil then
        return { full_name = "Unknown", name = "Unknown", namespace = "Unknown", parent = "None" }, err
    end

    local full_name = safe_call("get_full_name", function()
        return type_definition:get_full_name()
    end, "Unknown")
    local name = safe_call("get_name", function()
        return type_definition:get_name()
    end, full_name)
    local namespace = safe_call("get_namespace", function()
        return type_definition:get_namespace()
    end, "Unknown")
    local parent_definition = safe_call("get_parent_type", function()
        return type_definition:get_parent_type()
    end, nil)
    local parent = "None"
    if parent_definition ~= nil then
        parent = safe_call("parent.get_full_name", function()
            return parent_definition:get_full_name()
        end, "Unknown")
    end

    return {
        full_name = tostring(full_name),
        name = tostring(name),
        namespace = tostring(namespace),
        parent = tostring(parent),
    }, nil
end

function ReflectionManager.get_fields(object)
    local type_definition, err = ReflectionManager.get_type_definition(object)
    if type_definition == nil then return {}, err end

    local raw, getter_err = safe_call("get_fields", function()
        return type_definition:get_fields()
    end, nil)
    if raw == nil then return {}, getter_err end

    local output = {}
    for _, field in ipairs(collection_to_table(raw)) do
        local field_name = safe_call("field.get_name", function()
            return field:get_name()
        end, "<unnamed>")
        local field_type = safe_call("field.get_type", function()
            local definition = field:get_type()
            return definition and definition:get_full_name() or "Unknown"
        end, "Unknown")
        table.insert(output, tostring(field_type) .. " " .. tostring(field_name))
    end
    table.sort(output)
    return output, nil
end

function ReflectionManager.get_methods(object)
    local type_definition, err = ReflectionManager.get_type_definition(object)
    if type_definition == nil then return {}, err end

    local raw, getter_err = safe_call("get_methods", function()
        return type_definition:get_methods()
    end, nil)
    if raw == nil then return {}, getter_err end

    local output = {}
    for _, method in ipairs(collection_to_table(raw)) do
        local name = safe_call("method.get_name", function()
            return method:get_name()
        end, "<unnamed>")
        table.insert(output, tostring(name))
    end
    table.sort(output)
    return output, nil
end

function ReflectionManager.probe(object)
    local valid, valid_err = ReflectionManager.is_valid(object)
    if not valid then
        return { ok = false, error = valid_err or "Object is not reflectable", fields = {}, methods = {} }
    end

    local type_info, type_err = ReflectionManager.get_type_info(object)
    local fields, fields_err = ReflectionManager.get_fields(object)
    local methods, methods_err = ReflectionManager.get_methods(object)
    local error_text = type_err or fields_err or methods_err

    return {
        ok = error_text == nil,
        partial = error_text ~= nil,
        error = error_text,
        type_info = type_info,
        fields = fields,
        methods = methods,
    }
end

return ReflectionManager
