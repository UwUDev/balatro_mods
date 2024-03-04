local mod_id = "magic_hands"
local mod_name = "Magic hands"
local mod_version = "v1.0.3"
local mod_author = "Nanopoison & UwUDev"

local CardAPI = InitCardAPI()

if (sendDebugMessage == nil) then
    sendDebugMessage = function(_)
    end
end

table.insert(mods,
    {
        mod_id = mod_id,
        name = mod_name,
        version = mod_version,
        author = mod_author,
        enabled = true,
        description = {
            "Press up/down to change rank",
            "Press left/right to change suit",
            "Press m to change material",
            "Press s to change seal",
            "Press e to change edition"
        },
        on_enable = function()
            sendDebugMessage("Enabled " .. mod_name .. " " .. mod_version .. ", by: " .. mod_author)
        end,
        on_disable = function()
            sendDebugMessage("Disabled " .. mod_name .. " " .. mod_version .. ", by: " .. mod_author)
        end,
        on_key_pressed = function(key_name)
            if (key_name == "down" or key_name == "up") then
                if (G.hand == nil) then return end
                if (G.hand.highlighted == nil) then return end
                local direction = 1
                if (key_name == "down") then
                    direction = -1
                end
                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local rank = CardAPI:GetCardRank(G.hand.highlighted[i])
                        CardAPI:ChangeCardRank(G.hand.highlighted[i], rank + direction)
                    return true end }))
                end
            end
            if (key_name == "right" or key_name == "left") then
                if (G.hand == nil) then return end
                if (G.hand.highlighted == nil) then return end
                suits = CardAPI:GetSuits()
                local direction = 1
                if (key_name == "left") then
                    direction = -1
                end
                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local currentSuit = CardAPI:GetCardSuit(G.hand.highlighted[i])
                        local currentIndex = 1
                        for j=1, #suits do
                            if (suits[j] == currentSuit) then
                                currentIndex = j
                            end
                        end
                        local nextIndex = currentIndex + direction
                        if (nextIndex > #suits) then
                            nextIndex = 1
                        end
                        if (nextIndex < 1) then
                            nextIndex = #suits
                        end
                        CardAPI:ChangeCardSuit(G.hand.highlighted[i], suits[nextIndex])
                    return true end }))
                end
            end
            if (key_name == "m") then
                if (G.hand == nil) then return end
                if (G.hand.highlighted == nil) then return end
                local materials = CardAPI:getMaterialCenters()
                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local currentCenter = CardAPI:GetCardCenter(G.hand.highlighted[i])
                        local currentIndex = 1
                        for j=1, #materials do
                            if (materials[j] == currentCenter) then
                                currentIndex = j
                            end
                        end
                        local nextIndex = currentIndex + 1
                        if (nextIndex > #materials) then
                            nextIndex = 1
                        end

                        local nextCenter = materials[nextIndex]
                        -- check if string
                        if (type(nextCenter) == "string") and (nextCenter == "BASE") then
                            CardAPI:ResetCardCenter(G.hand.highlighted[i])
                        else
                            CardAPI:ChangeCardCenter(G.hand.highlighted[i], materials[nextIndex])
                        end

                        --CardAPI:ChangeCardCenter(G.hand.highlighted[i], G.P_CENTERS.m_lucky)
                    return true end }))
                end
            end

            if (key_name == "s") then
                if (G.hand == nil) then return end
                if (G.hand.highlighted == nil) then return end
                local seals = CardAPI:GetSeals()

                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local currentSeal = CardAPI:GetCardSeal(G.hand.highlighted[i])
                        sendDebugMessage("Current Seal: ")

                        local currentIndex = 1
                        for j=1, #seals do
                            if (seals[j] == currentSeal) then
                                currentIndex = j
                            end
                        end
                        local nextIndex = currentIndex + 1
                        if (nextIndex > #seals) then
                            nextIndex = 1
                        end
                        local nextSeal = seals[nextIndex]
                        if (nextSeal == "BASE") then
                            CardAPI:ResetCardSeal(G.hand.highlighted[i])
                        else
                            CardAPI:ChangeCardSeal(G.hand.highlighted[i], nextSeal)
                        end
                    return true end }))
                end
            end

            if (key_name == "e") then
                if (G.hand == nil) then return end
                if (G.hand.highlighted == nil) then return end
                local editions = CardAPI:GetEditions()

                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local currentEdition = CardAPI:GetCardEdition(G.hand.highlighted[i])
                        sendDebugMessage("Current Edition: ")
                        sendDebugMessage(currentEdition)

                        local currentIndex = 1
                        for j=1, #editions do
                            if (editions[j] == currentEdition) then
                                currentIndex = j
                            end
                        end
                        local nextIndex = currentIndex + 1
                        if (nextIndex > #editions) then
                            nextIndex = 1
                        end
                        local nextEdition = editions[nextIndex]
                        if (nextEdition == "BASE") then
                            CardAPI:ResetCardEdition(G.hand.highlighted[i])
                        else
                            CardAPI:ChangeCardEdition(G.hand.highlighted[i], nextEdition)
                        end
                    return true end }))
                end
            end
        end,
    }
)
