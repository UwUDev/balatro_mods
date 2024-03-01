table.insert(mods,
        {
            mod_id = "sample_mod",
            name = "Sample Mod",
            enabled = true,
            on_post_render = function()
                love.graphics.print("Sample mod loaded", 500, 30)
            end
        }
)