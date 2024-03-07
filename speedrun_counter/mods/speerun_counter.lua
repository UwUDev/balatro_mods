counter_start = -1
final_time = -1
ante_timings = {}

function print_ante_timings()
    local r, g, b, a = love.graphics.getColor()
    for i, v in pairs(ante_timings) do
        local scale_factor = 0.9
        local time = v
        if love.keyboard.isDown("tab") then
            -- calculate if possible the time minus the previous time
            if (i > 1) then
                time = time - ante_timings[i - 1]
            end
        end

        time = string.format("%02d:%02d.%03d", math.floor(time / 60), math.floor(time % 60), (time * 1000) % 1000)
        time = "Ante " .. i .. ": " .. time

        -- calculate the width of the text
        local width = love.graphics.getFont():getWidth(time) * scale_factor
        -- calculate the window width
        local window_width = love.graphics.getWidth()

        -- draw the text bigger
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(time, window_width - width - 8, 18 + (i * 20), 0, scale_factor, scale_factor)

        -- draw the text in whit so it makes a shadow
        love.graphics.setColor(255, 255, 255, 255)
        if love.keyboard.isDown("tab") then
            love.graphics.setColor(255, 128, 0, 255)
        end
        love.graphics.print(time, window_width - width - 10, 16 + (i * 20), 0, scale_factor, scale_factor)

    end

    love.graphics.setColor(r, g, b, a)
end

function print_speerun_timer(red, green, blue, alpha, time)
    local scale_factor = 1.3
    -- format to xx:xx.xxx
    time = string.format("%02d:%02d.%03d", math.floor(time / 60), math.floor(time % 60), (time * 1000) % 1000)
    -- calculate the width of the text
    local width = love.graphics.getFont():getWidth(time) * scale_factor
    -- calculate the window width
    local window_width = love.graphics.getWidth()

    -- get current color
    local r, g, b, a = love.graphics.getColor()
    -- set the color to black
    love.graphics.setColor(0, 0, 0, 255)

    -- draw the text bigger
    love.graphics.print(time, window_width - width - 8, 12, 0, scale_factor, scale_factor)

    -- draw the text in whit so it makes a shadow
    love.graphics.setColor(red, green, blue, alpha)

    love.graphics.print(time, window_width - width - 10, 10, 0, scale_factor, scale_factor)

    -- set the color back to the original
    love.graphics.setColor(r, g, b, a)

end

table.insert(mods,
        {
            mod_id = "speedrun_counter",
            name = "Speedrun Counter",
            version = "0.2",
            author = "UwUdev",
            description = {
                "A simple speedrun counter",
                "",
                "Press tab to see the time between each ante",
                "instead of the total time."
            },
            enabled = true,
            on_enable = function()
                local patch = [[
                if (counter_start == -1) then
                    counter_start = love.timer.getTime()
                end
                ]]

                injectHead("game.lua", "Game:start_run", patch)
            end,
            on_post_render = function()
                if G.STAGE == G.STAGES.MAIN_MENU then
                    counter_start = -1
                    final_time = -1
                    ante_timings = {}
                    return
                end
                if (counter_start ~= -1) then
                    if not G.GAME.won then

                        local ante_num = G.GAME.round_resets.ante
                        ante_timings[ante_num] = love.timer.getTime() - counter_start

                        print_speerun_timer(255, 255, 255, 255, love.timer.getTime() - counter_start)

                    else
                        if (final_time == -1) then
                            final_time = love.timer.getTime() - counter_start
                        end

                        print_speerun_timer(0, 255, 0, 255, final_time)
                    end

                    print_ante_timings()
                end
            end
        }
)

