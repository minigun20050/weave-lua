--[[
    Base of every interface. Shouldn't be included into interfaces.lua
--]]
local ffi = require("ffi")

ffi.cdef [[
    typedef void* (__cdecl* fnCreateInterface)(const char* name, int* returnCode);
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
]]

local create_interface = function(module_name, interface_name)
    local handle = ffi.C.GetModuleHandleA(module_name)
    if handle == nil then
        error("Handle is nil! Trying to get: " .. module_name .. " [" .. interface_name .. "]")
        return
    end
    local create_interface_fn = ffi.C.GetProcAddress(handle, "CreateInterface")
    if handle == nil then
        error("create_interface_fn is nil! Trying to get: " .. module_name .. " [" .. interface_name .. "]")
        return
    end
    return ffi.cast("fnCreateInterface", create_interface_fn)(interface_name, ffi.new("int[1]"))
end

local base = function()
    local tbl = {}

    function tbl:initialize()
        if not self.interface_name then
            error("No interface name!")
            return -1
        end
        if not self.filename then
            error("[".. self.interface .. "] No filename!")
            return -1
        end

        self.interface = create_interface(self.filename, self.interface_name)
        self.vtable = ffi.cast("void***", self.interface)

        if self.vtable == nil or self.vtable[0] == nil then
            return -1
        end
        self.vtable = self.vtable[0]
    end

    function tbl:vcreate(name, idx, definition)
        if self.vtable == nil then
            error("VTable is nil. Initialize interface before using, please.")
            return -1
        end
        local func = ffi.cast(ffi.typeof(definition), self.vtable[idx])
        self[name] = function(arg0, ...)
            if type(arg0) ~= "table" then
                error("Interface methods should be only called with :")
                return -1
            end
            if self.interface == nil then
                error("Interface is nil!")
                return -1
            end
            return func(self.interface, ...)
        end
    end

    return tbl
end

return base