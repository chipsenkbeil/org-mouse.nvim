-------------------------------------------------------------------------------
-- ORG-MOUSE.LUA
--
-- Main entrypoint into the org-mouse neovim plugin.
-------------------------------------------------------------------------------

-- Verify that we have orgmode available
if not pcall(require, "orgmode") then
    error("missing dependency: orgmode")
end

---@class OrgMouse
local M = {}

---@type OrgMouseApi
M.api = require("org-mouse.api")

---Initializes the plugin.
M.setup = require("org-mouse.setup")

return M
