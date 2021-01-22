local module = {}
function module.create(instance, attributes)
    local new = Instance.new(instance)
    for attribute_name, value in pairs(attributes) do
        new[attribute_name] = value
    end
    return new
end
return module