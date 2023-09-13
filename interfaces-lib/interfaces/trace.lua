local ffi = require("ffi")
local base = require("interfaces/__base")

ffi.cdef [[
    typedef struct {
        float x, y, z;
    } c_vec3;

    typedef struct {
        c_vec3 start;
        char pad0[4];
        c_vec3 delta;
        char pad1[40];
        bool is_swept;
    } ray_t;

    typedef struct {
        c_vec3 start;
        c_vec3 end;
        char pad0[20];
        float fraction;
        int contents;
        unsigned short disp_flags;
        bool all_solid;
        bool start_solid;
        char pad1[4];
        struct {
            const char* name;
            short surface_props;
            unsigned short flags;
        } surface;
        int hitgroup;
        char pad1[4];
        void* entity;
    } trace_t;
]]

local trace = base(); do
    trace["interface_name"] = "VClientEntityList003"
    trace["filename"] = "client.dll"

    if trace:initialize() == -1 then
        error("Can't init trace!")
        trace = -1
        return -1
    end

    -- trace["trace_ray"] = 
end

return trace