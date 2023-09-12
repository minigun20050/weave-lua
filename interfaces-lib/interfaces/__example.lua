local ffi = require("ffi")
local base = require("interfaces/__base")

local RENAME_THIS_CTRL_H = base(); do
    RENAME_THIS_CTRL_H["interface_name"] = "VClientEntityList003"
    RENAME_THIS_CTRL_H["filename"] = "client.dll"

    if RENAME_THIS_CTRL_H:initialize() == -1 then
        error("Can't init RENAME_THIS_CTRL_H!")
        RENAME_THIS_CTRL_H = -1
        return -1
    end
end

return RENAME_THIS_CTRL_H