--[[
    Part of interfaces library for weave.

    Source:
      https://github.com/rollraw/qo0-csgo/blob/c477e85116d43a534dcb8e887c48091ae4146514/base/sdk/interfaces/iinputsystem.h#L149
      https://github.com/LWSS/Fuzion/blob/master/src/SDK/IInputSystem.h
      https://github.com/perilouswithadollarsign/cstrike15_src/blob/f82112a2388b841d72cb62ca48ab1846dfcc11c8/public/inputsystem/iinputsystem.h#L65

    Notes:
      Seems like IInputSystem is 1:1 same on linux & windows and haven't updated since 2015 (at least) :/
        Because of this, you can paste from anywhere. Literally from anywhere.
      You can copy whole IInputSystem from leaked source, but you have to add 8 to index,
        because of IAppSystem. Example:
          EnableInput is 3rd from start in IInputSystem, 3 + 8 = 11
          ButtonCodeToString is 32 from start in IInputSystem, 32 + 8 = 40
--]]

local ffi = require("ffi")
local base = require("interfaces/__base")

ffi.cdef[[
    typedef enum {
        button_code_invalid = -1,
        button_code_none = 0,
    
        key_first = 0,
    
        key_none = 0,
        key_0,
        key_1,
        key_2,
        key_3,
        key_4,
        key_5,
        key_6,
        key_7,
        key_8,
        key_9,
        key_a,
        key_b,
        key_c,
        key_d,
        key_e,
        key_f,
        key_g,
        key_h,
        key_i,
        key_j,
        key_k,
        key_l,
        key_m,
        key_n,
        key_o,
        key_p,
        key_q,
        key_r,
        key_s,
        key_t,
        key_u,
        key_v,
        key_w,
        key_x,
        key_y,
        key_z,
        key_pad_0,
        key_pad_1,
        key_pad_2,
        key_pad_3,
        key_pad_4,
        key_pad_5,
        key_pad_6,
        key_pad_7,
        key_pad_8,
        key_pad_9,
        key_pad_divide,
        key_pad_multiply,
        key_pad_minus,
        key_pad_plus,
        key_pad_enter,
        key_pad_decimal,
        key_lbracket,
        key_rbracket,
        key_semicolon,
        key_apostrophe,
        key_backquote,
        key_comma,
        key_period,
        key_slash,
        key_backslash,
        key_minus,
        key_equal,
        key_enter,
        key_space,
        key_backspace,
        key_tab,
        key_capslock,
        key_numlock,
        key_escape,
        key_scrolllock,
        key_insert,
        key_delete,
        key_home,
        key_end,
        key_pageup,
        key_pagedown,
        key_break,
        key_lshift,
        key_rshift,
        key_lalt,
        key_ralt,
        key_lcontrol,
        key_rcontrol,
        key_lwin,
        key_rwin,
        key_app,
        key_up,
        key_left,
        key_down,
        key_right,
        key_f1,
        key_f2,
        key_f3,
        key_f4,
        key_f5,
        key_f6,
        key_f7,
        key_f8,
        key_f9,
        key_f10,
        key_f11,
        key_f12,
        key_capslocktoggle,
        key_numlocktoggle,
        key_scrolllocktoggle,

        mouse_left,
        mouse_right,
        mouse_middle,
        mouse_4,
        mouse_5,

        IGNORE_NOT_AVAIABLE
    } e_button_code;
]]

local input_system = base(); do
    input_system["interface_name"] = "InputSystemVersion001"
    input_system["filename"] = "inputsystem.dll"

    if input_system:initialize() == -1 then
        error("Can't init input_system!")
        input_system = -1
        return -1
    end

    --[[
        Section name: VTable bindings
    --]]

    input_system:vcreate("enable_input", 11, "void(__thiscall*)(void*, bool)")
    input_system:vcreate("is_button_down", 15, "bool(__thiscall*)(void*, e_button_code)")
    input_system:vcreate("button_code_to_string", 40, "const char*(__thiscall*)(void*, e_button_code)")
    input_system:vcreate("string_to_button_code", 42, "e_button_code(__thiscall*)(void*, const char*)")
    input_system:vcreate("vk_to_button_code", 44, "e_button_code(__thiscall*)(void*, int)")
    input_system:vcreate("button_code_to_vk", 45, "int(__thiscall*)(void*, e_button_code)")
    input_system:vcreate("get_cursor_pos_raw", 56, "void(__thiscall*)(void*, int*, int*)")

    --[[
        Section name: Wrappers
    --]]

    function input_system:get_cursor_pos()
        local tmp_x, tmp_y = ffi.new("int[1]"), ffi.new("int[1]")
        self:get_cursor_pos_raw(tmp_x, tmp_y)
        return {
            ["x"] = tmp_x[0],
            ["y"] = tmp_y[0]
        }
    end
end


return input_system