table.insert(mods,
        {
            mod_id = "dev_tools",
            name = "Dev tools",
            version = "0.1",
            author = "UwUDev",
            description = {
                "F1: Open console",
                "F3: Restart the game",
                "F4: Enable/Disable debug mode",
                "Longpress TAB: Open dev tools menu"
            },
            enabled = true,
            on_enable = function()
                _RELEASE_MODE = false
            end,
            on_disable = function()

            end,
            on_key_pressed = function(key_name)
                if key_name == "f3" then
                    sendDebugMessage("Restarting the game")
                    batch_file = io.open(love.filesystem.getSaveDirectory() .. "/restart_game.bat", "w")
                    batch_file:write("@echo off\n")
                    batch_file:write("start \"\" \"" .. love.filesystem.getSource() .. "\"\n")
                    batch_file:write("del \"%~f0\"\n")
                    batch_file:write("exit\n")
                    batch_file:close()

                    love.system.openURL("file:///" .. love.filesystem.getSaveDirectory() .. "/restart_game.bat")
                    love.event.quit()
                end

                if key_name == "f1" then
                    batch_file = io.open(love.filesystem.getSaveDirectory() .. "/console.bat", "w")
                    batch_file:write("@echo off\n")
                    batch_file:write("powershell -Command \"Start-Process PowerShell -ArgumentList 'Get-Content \"" .. love.filesystem.getSaveDirectory() .. "/console.txt\" -Wait'\"\n")
                    --batch_file:write("del \"%~f0\"\n")
                    batch_file:write("pause\n")
                    batch_file:close()

                    love.system.openURL("file:///" .. love.filesystem.getSaveDirectory() .. "/console.bat")
                end

                if key_name == "f4" then
                    G.DEBUG = not G.DEBUG
                    if G.DEBUG then
                        sendDebugMessage("Debug mode enabled")
                    else
                        sendDebugMessage("Debug mode disabled")
                    end
                end

                return false
            end,
            on_post_render = function()
                love.graphics.print("Dev tools :3", 500, 30)
            end,
        }
)