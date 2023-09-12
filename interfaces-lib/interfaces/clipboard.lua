local ffi = require("ffi")
local base = require("interfaces/__base")

local clipboard = base(); do
    clipboard["interface_name"] = "VGUI_System010"
    clipboard["filename"] = "vgui2.dll"

    if clipboard:initialize() == -1 then
        error("Can't init clipboard!")
        clipboard = -1
        return -1
    end

    clipboard:vcreate("get_text_raw", 11, "int(__thiscall*)(void*, int offset, const char*, int)")
    clipboard:vcreate("set_text_raw", 9, "void(__thiscall*)(void*, const char*, int textLen)")
    clipboard:vcreate("get_text_count", 7, "int(__thiscall*)(void*)")

    function clipboard:get_text()
        print("called")
        local length = self:get_text_count()
        if length < 0 then
            error("Clipboard text length is 0?")
            return ""
        end
        print("called 2")
        local buffer = ffi.new("char[?]", length)
            self:get_text_raw(0, buffer, length)
        return ffi.string(buffer, length - 1)
    end

    function clipboard:set_text(text)
        self:set_text_raw(text, #text)
    end
end

return clipboard