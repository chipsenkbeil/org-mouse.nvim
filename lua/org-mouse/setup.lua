-------------------------------------------------------------------------------
-- SETUP.LUA
--
-- Contains logic to initialize the plugin.
-------------------------------------------------------------------------------

local CONFIG = require("org-mouse.config")
local AUGROUP = vim.api.nvim_create_augroup("org-mouse", {})

---@param config OrgMouseConfig
---@return OrgMouseConfig
local function merge_config(config)
    -- Merge our configuration options into our global config
    CONFIG(config)

    ---@type OrgMouseConfig
    return CONFIG
end

---@param config OrgMouseConfig
local function define_mouse_features(config)
    -- Force-enable mouse movement if highlighting links
    if not vim.opt.mousemoveevent:get() and config.highlight_links then
        vim.opt.mousemoveevent = true
    end

    -- Register on org filetype to set the mouse keybindings locally to
    -- those buffers to avoid conflicts with other plugins that add mouse
    -- keybindings in specialized ways
    vim.api.nvim_create_autocmd("FileType", {
        group = AUGROUP,
        pattern = config.filetypes,
        callback = function(opts)
            ---@type integer
            local buf = opts.buf

            if config.highlight_links then
                vim.keymap.set("n", "<MouseMove>", function()
                    local hl_group = config.highlight_links_group
                    require("org-mouse.api").highlight_link(hl_group)
                end, { buffer = buf, silent = true })
            end

            if config.click_open_links then
                vim.keymap.set("n", "<LeftRelease>", function()
                    -- NOTE: The cursor moves BEFORE this mapping is fired,
                    --       which is exactly what we want to be able to
                    --       open at point!
                    require("orgmode").org_mappings:open_at_point()
                end, { buffer = buf, silent = true })
            end
        end,
    })
end

---Initializes the plugin.
---@param config OrgMouseConfig|nil
return function(config)
    config = config or {}
    config = merge_config(config)
    define_mouse_features(config)
end
