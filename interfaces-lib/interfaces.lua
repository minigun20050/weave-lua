--[[
    Interfaces library. File is made only to easily include every interface.
    Can be used anywhere, but cheats without ffi.
    WARNING: DO NOT INCLUDE FILES STARTING WITH _!
--]]

local interfaces = {}; do
    interfaces["clipboard"] = require("interfaces/clipboard")
    interfaces["input_system"] = require("interfaces/input_system")
end

for k, v in pairs(interfaces) do
    if v == -1 then
        error("Can't init interfaces.")
        return -1
    end
end

return interfaces
