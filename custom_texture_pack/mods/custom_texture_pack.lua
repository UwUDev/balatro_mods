function loadImageDataFromPath(filePath)
    sendDebugMessage("Loading image data from path: " .. filePath)
    local img_data = nil
    local f = io.open(filePath, "rb")
    if f then
        local data = f:read("*all")
        f:close()
        if data then
            data = love.filesystem.newFileData(data, "tempname")
            data = love.image.newImageData(data)
            img_data = data
        end
    end

    if not img_data then
        sendDebugMessage("File does not exist: " .. filePath)
        local patch = love.filesystem.getSaveDirectory() .. "/pack/"
        local original_name = string.gsub(filePath, patch:gsub("([^%w])", "%%%1"), "resources/textures/")
        sendDebugMessage("Original name: " .. original_name)
        return original_name
    end
    return img_data
end

table.insert(mods,
        {
            mod_id = "custom_texture_pack",
            name = "Custom texture pack",
            author = "UwUDev",
            version = "0.1",
            description = {
                "This mod will replaces files",
                "in %appdata%/Balatro/pack/ with",
                "the ones in the resources/textures/",
                "folder"
            },
            enabled = true,
            on_enable = function()
                sendDebugMessage("Custom texture pack enabled")
                local function_body = extractFunctionBody("game.lua", "Game:set_render_settings")
                local save_path = love.filesystem.getSaveDirectory() .. "/pack/"
                local modified_function_code = string.gsub(function_body, "\"resources/textures/\"", "\"" .. save_path .. "\"")

                local to_patch1 = "love.graphics.newImage(self.animation_atli[i].path"
                local to_patch2 = "love.graphics.newImage(self.asset_atli[i].path"
                local to_patch3 = "love.graphics.newImage(self.asset_images[i].path"
                local to_patch4 = "resources/textures/1x/playstack-logo.png"
                local to_patch5 = "resources/textures/1x/localthunk-logo.png"

                local patch1 = "love.graphics.newImage(loadImageDataFromPath(self.animation_atli[i].path)"
                local patch2 = "love.graphics.newImage(loadImageDataFromPath(self.asset_atli[i].path)"
                local patch3 = "love.graphics.newImage(loadImageDataFromPath(self.asset_images[i].path)"
                local patch4 = save_path .. "1x/playstack-logo.png"
                local patch5 = save_path .. "1x/localthunk-logo.png"

                modified_function_code = string.gsub(modified_function_code, to_patch1:gsub("([^%w])", "%%%1"), patch1:gsub("([^%w])", "%%%1"))
                modified_function_code = string.gsub(modified_function_code, to_patch2:gsub("([^%w])", "%%%1"), patch2:gsub("([^%w])", "%%%1"))
                modified_function_code = string.gsub(modified_function_code, to_patch3:gsub("([^%w])", "%%%1"), patch3:gsub("([^%w])", "%%%1"))
                modified_function_code = string.gsub(modified_function_code, to_patch4:gsub("([^%w])", "%%%1"), patch4:gsub("([^%w])", "%%%1"))
                modified_function_code = string.gsub(modified_function_code, to_patch5:gsub("([^%w])", "%%%1"), patch5:gsub("([^%w])", "%%%1"))



                local escaped_function_body = function_body:gsub("([^%w])", "%%%1")
                current_game_code["game.lua"] = current_game_code["game.lua"]:gsub(escaped_function_body, modified_function_code)

                sendDebugMessage("Game code updated")

                local new_function, load_error = load(modified_function_code)
                if new_function then
                    sendDebugMessage("Function loaded")
                    local success, result = pcall(new_function)
                    if success then
                        sendDebugMessage("Function executed")
                    else
                        sendDebugMessage("Function execution failed: " .. result)
                    end
                else
                    sendDebugMessage("Function load failed: " .. load_error)
                end

              sendDebugMessage(modified_function_code)

              G:set_render_settings()
              G:init_item_prototypes()
            end
        }
)