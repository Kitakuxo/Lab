local _info = rconsoleinfo or print
local _warn = rconsolewarn or warn
local _error = rconsolerror or error
local _debug = debug
getgenv(0).title = rconsolename or function() end
getgenv(0).clear = rconsoleclear or function() end

getgenv(0).printwelcome = function()
    rconsoleprint("@@LIGHT_GREEN@@")
    rconsoleprint("                                                \n")
    rconsoleprint("                     Welcome !                     \n")
    rconsoleprint("                                                \n")
    rconsoleprint("@@LIGHT_RED@@")
    rconsoleprint("     Bitch , Nigga. this is my First Project  \n")
    rconsoleprint("                                                \n")
    rconsoleprint("@@LIGHT_CYAN@@")
    rconsoleprint("               Cheat Made By Kitaku    \n")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("\n")
end
getgenv(0).info = function(...)
    local args = {...}
    local str = ""
    for i=1,#args do
        str = str .. " " .. tostring(args[i])
    end
    str = str:sub(2, str:len())
    rconsoleprint("[")
    rconsoleprint("@@CYAN@@")
    rconsoleprint("INFO")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("]: " .. str .. "\n")
end
getgenv(0).debug = setmetatable({}, {
    __call = function(_, ...)
        local args = {...}
        local str = ""
        for i=1,#args do
            str = str .. " " .. tostring(args[i])
        end
        str = str:sub(2, str:len())
        rconsoleprint("[")
        rconsoleprint("@@LIGHT_MAGENTA@@")
        rconsoleprint("DEBUG")
        rconsoleprint("@@WHITE@@")
        rconsoleprint("]: " .. str .. "\n")
    end,
    __index = _debug
})
getgenv(0).ok = function(...)
    local args = {...}
    local str = ""
    for i=1,#args do
        str = str .. " " .. tostring(args[i])
    end
    str = str:sub(2, str:len())
    rconsoleprint("[")
    rconsoleprint("@@GREEN@@")
    rconsoleprint(" OK ")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("]: " .. str .. "\n")
end
getgenv(0).warn = function(...)
    local args = {...}
    local str = ""
    for i=1,#args do
        str = str .. " " .. tostring(args[i])
    end
    str = str:sub(2, str:len())
    rconsoleprint("[")
    rconsoleprint("@@YELLOW@@")
    rconsoleprint("WARN")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("]: " .. str .. "\n")
end
getgenv(0).error = function(...)
    local args = {...}
    local str = ""
    for i=1,#args do
        str = str .. " " .. tostring(args[i])
    end
    str = str:sub(2, str:len())
    rconsoleprint("[")
    rconsoleprint("@@LIGHT_RED@@")
    rconsoleprint("ERR")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("]: " .. str .. "\n")
end
do
  local colors = {
      ["Black"] = "@@BLACK@@",
      ["Blue"] = "@@BLUE@@",
      ["Green"] = "@@GREEN@@",
      ["Cyan"] = "@@CYAN@@",
      ["Red"] = "@@RED@@",
      ["Magenta"] = "@@MAGENTA@@",
      ["Brown"] = "@@BROWN@@",
      ["LightGray"] = "@@LIGHT_GRAY@@",
      ["DarkGray"] = "@@DARK_GRAY@@",
      ["LightBlue"] = "@@LIGHT_BLUE@@",
      ["LightGreen"] = "@@LIGHT_GREEN@@",
      ["LightCyan"] = "@@LIGHT_CYAN@@",
      ["LightRed"] = "@@LIGHT_RED@@",
      ["LightMagenta"] = "@@LIGHT_MAGENTA@@",
      ["Yellow"] = "@@YELLOW@@",
      ["White"] = "@@WHITE@@"
  }
  local function fmt(v)
      return type(v) == "string" and "\"" .. tostring(v) .. "\""
          or tostring(v)
              :gsub("table: 0x", "")
              :gsub("userdata: 0x", "")
              :gsub("function: 0x", "")
  end
  getgenv(0).printTable = function(p, t, i, o)
      i = i and i + 1 or 1
      t = type(t) == "table" and t or { t }
      o = o or t
      if type(t) ~= "table" then return end
      if i > 5 then return end
      local space = "    "
      local spaces = string.rep(space, i)
      local stub = string.sub(spaces, 1, spaces:len() - space:len()) .. " "
      p(colors.White)
      p(stub .. "{\n")
      for k, v in pairs(t) do
          local key = fmt(k)
          local value = fmt(v)
          local isVTable = type(v) == "table"
          p(spaces .. " ")
          p(colors.White)
          p("[")
          p(colors.DarkGray)
          p("<")
          p(colors.LightBlue)
          p(typeof(k))
          p(colors.DarkGray)
          p(">")
          p(colors.Yellow)
          p(tostring(key))
          p(colors.White)
          p("]")
          p(" = ")
          p(colors.DarkGray)
          p("<")
          p(colors.LightBlue)
          p(typeof(v))
          p(colors.DarkGray)
          p(">")
          p(colors.LightGreen)
          p(tostring(value))
          p(type(v) ~= table and "\n" or "")
          if type(v) == "table" then
              if v == t or v == o then
                  local prestubs = spaces:rep(1) .. " "
                  p(colors.White)
                  p(prestubs .. "{\n")
                  local relative = v == o and "topmost" or v == t and tostring(value)
                  p(spaces:rep(2) .. " ")
                  p(colors.DarkGray)
                  p("<")
                  p(colors.LightBlue)
                  p("circular")
                  p(colors.DarkGray)
                  p("<")
                  p(colors.LightBlue)
                  p(typeof(v))
                  p(colors.DarkGray)
                  p(">>")
                  p(colors.LightGreen)
                  p(relative)
                  p("\n")
                  p(colors.White)
                  p(prestubs .. "}\n")
              else
                  printTable(p, v, i, o)
              end
          end
      end
      p(colors.White)
      p(stub .. "}\n")
  end
end
