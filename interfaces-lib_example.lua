--[[
    Example of using "interfaces" library made by nn.
    Instruction how to install can be found at weave discord, #scripts.
--]]
local interfaces = require("interfaces")

--[[
    Section name: UI Stuff
--]]

local tab = ui.tab("Example")
-- Callbacks is here bcz it will be ugly if I'll put it in settings :)
local button_callbacks = {
    holding_y = function()
        print(interfaces["input_system"]:is_button_down(35) and "You're holding Y!" or "You aren't holding Y :(")
    end,
    print_x_key = function()
        print(interfaces["input_system"]:string_to_button_code("x"))
    end,
    cursor_pos = function()
        local pos = interfaces["input_system"]:get_cursor_pos()
        print(pos.x .. " | " .. pos.y)
    end,
    set_clipboard = function()
        interfaces["clipboard"]:set_text("Weave > all")
    end,
    get_clipboard = function()
        print("You had following text in ur clipboard: " .. interfaces["clipboard"]:get_text())
    end
}

local settings = {
    ["left"] = {
        ["is_holding_0"] = ui.button("Check if I'm holding Y", button_callbacks.holding_y),
        ["print_cursor_pos"] = ui.button("Print cursor position in console", button_callbacks.cursor_pos),
        ["print_x_buttoncode"] = ui.button("Print X buttoncode in console", button_callbacks.print_x_key)
    },
    ["right"] = {
        ["set_clipboard"] = ui.button("Set clipboard text", button_callbacks.set_clipboard),
        ["get_clipboard"] = ui.button("Print clipboard text in console", button_callbacks.get_clipboard)
    }
}

for side, items in pairs(settings) do
    if side == "left" or side == "right" and items then
        for name, element in pairs(items) do
            tab[side]:add(element)
        end
    end
end
tab:register()