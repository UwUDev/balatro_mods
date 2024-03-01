table.insert(mods,
        {
            mod_id = "sample_mod",
            name = "Sample Mod",
            enabled = true,
            on_pre_render = function()
                love.graphics.print("Sample mod loaded", 500, 80)
            end
        }
)