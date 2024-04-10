-------------------------------------------------------------------------------
-- CONFIG.LUA
--
-- Contains global config logic used by the plugin.
-------------------------------------------------------------------------------

---Overwrites configuration options with those specified.
---@param tbl OrgMouseConfig
---@param opts OrgMouseConfig
local function replace(tbl, opts)
    if type(opts) ~= "table" then
        return
    end

    -- Create a new config based on old config, ovewriting
    -- with supplied options
    local config = vim.tbl_deep_extend("force", tbl, opts)

    -- Replace all top-level keys of old config with new
    ---@diagnostic disable-next-line:no-unknown
    for key, value in pairs(config) do
        ---@diagnostic disable-next-line:no-unknown
        tbl[key] = value
    end
end

---Global configuration settings leveraged through org-mouse.
---@class OrgMouseConfig
---@overload fun(config:OrgMouseConfig)
local config = setmetatable({
    ---If true, clicking on links will open them.
    ---@type boolean
    click_open_links = true,

    ---Pattern of filetypes to support for mouse operations.
    ---@type string[]
    filetypes = { "org", "org-roam-*" },

    ---If true, highlights links when mousing over them.
    ---This will enable `vim.opt.mouseoverevent` if disabled!
    ---@type boolean
    highlight_links = true,

    ---Highlight group to apply when highlighting links.
    ---@type string
    highlight_links_group = "WarningMsg",
}, { __call = replace })

return config
