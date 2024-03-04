local console_file = io.open(love.filesystem.getSaveDirectory() .. "/console.txt", "w")
console_file:write("")
console_file:close()

function sendDebugMessage(message)
    if message == nil then
        message = "nil"
    end

    -- if it's a table, convert it to a string
    if type(message) == "table" then
        message = tableToString(message)
    end
    message = tostring(message)
    local console = io.open(love.filesystem.getSaveDirectory() .. "/console.txt", "a")
    console:write(message .. "\n")
    console:close()
end

function tableToString(table)
    local string = ""
    for key, value in pairs(table) do
        string = string .. tostring(key) .. ": " .. tostring(value) .. "\n"
    end
    return string
end