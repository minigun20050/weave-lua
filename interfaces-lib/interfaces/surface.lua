local ffi = require("ffi")
local base = require("interfaces/__base")

local surface = base(); do
    surface["interface_name"] = "VClientEntityList003"
    surface["filename"] = "client.dll"

    if surface:initialize() == -1 then
        error("Can't init surface!")
        surface = -1
        return -1
    end
end

return surface