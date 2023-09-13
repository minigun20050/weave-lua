<p style="margin-bottom: 5px;">Codestyle is a big problem in scripts for any cheat.</p>
<p style="margin-bottom: 5px;">I hope this will make (at least few people) write somewhat readable code. Yes, this isn't perfect and I hope this isn't as bad as I thought.</p>
<p style="margin-bottom: 5px;">My english is very very very bad, it isn't my native. Create issue/pull request if you want to fix something (or, if you don't want to register github, pm me on discord: LiterallyNN).</p>
Feel free to post it wherever you want, criticism is not only allowed, but it is necessary - write on discord or create an issue.

# Codestyle
**You should use snake_case.**
**Write code as clean as you can, comment complicated parts.**
**Indent with 4 spaces.** (except for code in documentation - use 2 or 4)

## File structure
File should have following structure:
  1. Square-brackets comment, that can include:
     1. Author
     2. File purpose
     3. Libraries [newline if not end]
     4. Short explanation of features (if file purpose isn't enough to explain)
     5. Necessary information about code [newline if not end]
     6. Useful links to documentation (example: link to winapi methods used) [newline if not end]
     7. ToDo (what you need to do + line + explanation if needed on next line with 2 more spaces, do not write ToDo's that will be done at the same day) [newline if needed]
     8. Unnecessary information about code
  2. Includes (ffi & others)
  3. FFI Section:
     1. Separated cdef's for every logical section
      (example: WinApi definitions, function definitions (set_clantag, get_interface), interface definitions, other interface definitions, ...)
     2. Enums (if needed)
     3. Tables or functions that will contain FFI interfaces/functions wrappers.
      **Should be filled right after definition (in do ... end block starting at same line), definition must be just {}**
     4. Other ffi-related stuff
  4. Utils section (utils table)
  5. UI section (**utils shouldn't use ui, but can have functions like get_selectable_value**)
  6. Main code (**you should still separate sections inside of main code**)
  7. Callbacks section (if separated from main code section)

```lua
--[[
  Author: NoName
  Part of interfaces library that implements IInputSystem
  Requires FFI

  Source:
    https://github.com/LWSS/Fuzion/blob/master/src/SDK/IInputSystem.h
    https://docs.gamesense.gs/docs/snippets/ffi/basic_input_system

  ToDo:
    - input_system.is_enabled
    - input_system.button_code_to_string, input_system.string_to_button_code
    - Fix issues with is_down - wrong index?
--]]

-- Code
```

## Section info
It contains following information:
  1. Section name
  2. Short info about section or explanation (necessary if functions are complicated)
  3. Sources
  4. Necessary information
  5. Unnecessary information
  6. ToDo

Reason why everyone should mark sections is simple - it improves overall readability and it helps you with searching needed stuff. Not needed if file contains only one class or doing one thing (example: small libraries)

```lua
--[[
  Section name: Example
  This section contains everything that is (somehow) related to InputSystem interface.

  Source:
    https://github.com/LWSS/Fuzion/blob/master/src/SDK/IInputSystem.h
    https://docs.gamesense.gs/docs/snippets/ffi/basic_input_system

  ToDo:
    - input_system.is_enabled
    - input_system.button_code_to_string, input_system.string_to_button_code
    - Fix issues with is_down - wrong index?
--]]
```

## Table
Rules for tables are as simple as possible:
  1. Use [] for variables (while initializing or calling or whatever you're doing)
  2. Don't use [] for functions (while initializing or calling or whatever you're doing)

Why? It helps a lot when you're working on unknown project. You know where is functions and where is variables so you'll never make really stupid mistakes related to this.

```lua
local example_table = {
  ["variable"] = "example",
  newfunction = function()
    print("test")
  end
}
print(example_data["variable"]) -- example
example_data.newfunction() -- test
```

## Functions
Functions rules:
  1. Function should have newline before and after definition
    (doesn't work when readability will be better without newlines)
  2. You should put link to source right before definition if you took it from somewhere
    (if it's described better and/or it's only small part of code and there is chance that you'll need to edit this shit)
  3. It should be defined in **one way** everywhere (variables or functions), excluding methods (example:method()), it can't be defined as variable

```lua
local first_function = function()
  print("UwU")
end

-- https://stackoverflow.com/questions/25779670/how-do-you-print-the-text-from-a-file-in-lua
local function_name = function()
  print("Hello, lua!")
end

local another_function = function()
  print("^_^")
end
```

```lua
local example_table = {}; do
  local user = c_user.new("Andryusha")
  function example_table:method()
    print("Hello, " .. user.name)
  end
end
```

## Comments
Square brackets:
  1. Should have -- before (both at start and end of comment)
  2. Never should have text at same line (where brackets is located)

```lua
--[[
    That's example of square brackets comment.
    This is second line of comment.
--]]
```

Double dash:
  1. More than one line = use square brackets
  2. Put after code only if line is short and comment doesn't take too much space (to improve readability)
  3. Short-time ToDo (no code before comment)

```lua
-- ToDo: 
local short_thing = a + a - a + b - c -- Short explanation of complicated math operations

-- Well, I have no idea what I can put here as example.
local looooooong_thing = looooooong_function("looooooooooooooooong argument")
```

When you have to write [[ ]]:
  1. Start of the file (ToDo, file explanation, credits, etc etc)
  2. Section info
  3. Long explanation of functions (more than 1 line)
  
```lua
--[[
  This function does really complicated math operations
  It gets squared root of variable and returns it
  I have no idea what I can put here and not make example long x2 :/
  I hope you will understand why examples is stupid (kind of)
--]]
math.sqrt = function(integer)
  return integer ^ 0.5
end
```

When you have to write --:
  1. Short explanation (1 line)
  2. Short ToDo

```lua
-- This functions print "example" in console
local example_function = function()
  -- ToDo: make it print "Minecraft"
  print("example")
end
```

# Tables that only contains definitions or nothing (and will be filled right after)
They **should be filled inside do end block of code**. That's all.

```lua
local base_interface = {}; do
  local some_variable_used_only_inside_this = 1337
  base_interface["vtable"] = 0xDEADBEEF
  
  base_interface.print_thing = function()
    print(some_variable_used_only_inside_this)
  end
end
base_interface.print_thing() -- 1337
print(some_variable_used_only_inside_this) -- nil - Variable is not avaiable outside.
```

I guess I'll explain more stuff later.
