-- Based on the NanoAPI 

function InitCardAPI()

    local CardAPI = {}

    local suffixes = {
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'T',
        'J',
        'Q',
        'K',
        'A'
    }

    local suits = {
        'Hearts',
        'Diamonds',
        'Clubs',
        'Spades'
    }

    local seals = {
        "BASE",
        "Red",
        "Blue",
        "Gold",
        "Purple"
    }

    local editions = {
        "BASE",
        "Foil",
        "Holo",
        "Polychrome"
        --{foil = true},
        --{holo = true},
        --{polychrome = true}
    }

    function CardAPI:GetSeals()
        return seals
    end

    function CardAPI:GetSuits()
        return suits
    end

    function CardAPI:GetEditions()
        return editions
    end

    function CardAPI:getMaterialCenters()
        local materials = {
            "BASE",
            G.P_CENTERS.m_stone,
            G.P_CENTERS.m_steel,
            G.P_CENTERS.m_glass,
            G.P_CENTERS.m_gold,
            G.P_CENTERS.m_bonus,
            G.P_CENTERS.m_mult,
            G.P_CENTERS.m_wild,
            G.P_CENTERS.m_lucky
        }
        return materials
    end

    -- TODO
    local Custom_Suits = {}
    local Custom_Ranks = {}

    local MAX_RANK = 14
    local MIN_RANK = 2

    -- get values from cards

    function CardAPI:GetCardRank(card)
        return card.base.id
    end

    function CardAPI:GetCardSuit(card)
        return card.base.suit
    end

    function CardAPI:GetCardSeal(card)
        sendDebugMessage(card.seal)
        return card.seal
    end

    -- functional methods

    function CardAPI:GetSuffixFromRank(rank)
        if (suffixes[rank + 1 - MIN_RANK] ~= nil) then
            return suffixes[rank + 1 - MIN_RANK]
        end
        return '-1'
    end

    function CardAPI:GetCardCenter(card)
        return card.config.center
    end

    function CardAPI:GetCardEdition(card)
        --return card.edition
        if (card.edition == nil) then
            return "BASE"
        end
        if (card.edition.foil) then
            return "Foil"
        end
        if (card.edition.holo) then
            return "Holo"
        end
        if (card.edition.polychrome) then
            return "Polychrome"
        end
    end

    function CardAPI:ChangeCardCenter(card, center)
        card:set_ability(center)
    end

    function CardAPI:ChangeCardSeal(card, seal)
        card:set_seal(seal, true, true)
    end

    function CardAPI:ChangeCardEdition(card, edition)
        if (edition == "BASE") then
            card:set_edition(nil, true, true)
        end
        if (edition == "Foil") then
            card:set_edition({foil = true}, true, true)
        end
        if (edition == "Holo") then
            card:set_edition({holo = true}, true, true)
        end
        if (edition == "Polychrome") then
            card:set_edition({polychrome = true}, true, true)
        end
    end

    function CardAPI:ResetCardCenter(card)
        card:set_ability(G.P_CENTERS.c_base)
    end

    function CardAPI:ResetCardSeal(card)
        card:set_seal(nil, true, true)
    end

    function CardAPI:ResetCardEdition(card)
        card:set_edition(nil, true, true)
    end

    function CardAPI:GetNominalFromRank(rank)
        if (rank <= 9) then
            return rank
        end
        if (rank < 14) then
            return 10
        end
        return 11
    end

    function CardAPI:ChangeCardRank(card, rank_suffix)
        local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
        rank_suffix = CardAPI:GetSuffixFromRank(CardAPI:NormalizeRank(rank_suffix))
        card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
    end

    function CardAPI:NormalizeRank(rank)
        local range = MAX_RANK - MIN_RANK + 1
        return ((rank - MIN_RANK) % range) + MIN_RANK
    end

    function CardAPI:ChangeCardSuit(card, suit)
        local rank = CardAPI:GetCardRank(card)
        local suit_prefix = string.sub(suit, 1, 1)..'_'
        local rank_suffix = CardAPI:GetSuffixFromRank(rank)
        card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
    end

    function CardAPI:AddNewRank(name, suffix)

    end

    function CardAPI:AddNewSuit(name, prefix)
        for i = MIN_RANK, MAX_RANK do
            local suffix = CardAPI:GetSuffixFromRank(CardAPI:NormalizeRank(i))
            local p_card_obj = {
                name = suffix .. " of " .. name,
                value = suffix,
                suit = name,
                pos = {x = i - 2, y = #Custom_Suits + 4}
            }
            G.P_CARDS[prefix.."_"..suffix] = p_card_obj
        end
    end

    -- getter / setter of CardAPI

    function CardAPI:SetMaxRank(rank)
        MAX_RANK = rank
    end

    function CardAPI:SetMinRank(rank)
        MIN_RANK = rank
    end

    -- helper

    function Clamp(min, max, num)
        return math.max(min, math.min(max, num))
    end

    return CardAPI
end