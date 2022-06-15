#! /usr/bin/env lua

local ipv4_list = {}
local ipv6_list = {}

string.split = function(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then table.insert(t, cap) end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

--- masks a list of IPV6 addresses with x characters
-- @param ipv6_list list of IPV6 addresses
function MASK_IPV6(ipv6list)
    local ipv6_list_masked = {}
    for _, ipv6 in ipairs(ipv6list) do
        --- if it starts with `::` ignore it
        if ipv6:sub(1, 2) == "::" then
            ipv6_list_masked[#ipv6_list_masked + 1] = ipv6
        else
            -- split the first part of the ipv6 address
            local ipv6_split = ipv6:split(":")
            -- replace any non colon with `x` in the second part
            for i = 2, #ipv6_split-2 do
                ipv6_split[i] = string.rep("*", #ipv6_split[i])
            end
            -- join the ipv6 address back together
            ipv6_list_masked[#ipv6_list_masked + 1] =
                table.concat(ipv6_split, ":")
        end
    end
    return ipv6_list_masked
end

--- masks a list of IPV4 addresses with x characters
-- @param ipv4_list list of IPV4 addresses
function MASK_IPV4(ipv4list)
    local ipv4_list_masked = {}
    for _, ipv4 in ipairs(ipv4list) do
        --- gsub replace the middle 2 blocks with x
        local masked = ipv4:gsub("(%d+).(%d+).(%d+).(%d+)", "%1.***.***.%4")
        ipv4_list_masked[#ipv4_list_masked + 1] = masked
    end
    return ipv4_list_masked
end

--- try to extract all IPV6 addresses in a string
-- @param str string to extract IPV6 addresses from
function FindAllIPV6(str)
    --- try to extrack all IPV6 addresses anywhere in the string
    for ipv6 in str:gmatch("[0-9a-fA-F:]+") do
        if (not (#ipv6 < 3)) then
            -- count the number of colons
            local num_colons = 0
            for _ in ipv6:gmatch(":") do num_colons = num_colons + 1 end
            -- if there is between 2 and 7 colons it should be an IPV6
            if num_colons >= 2 and num_colons <= 7 then
                ipv6_list[#ipv6_list + 1] = ipv6
            end
        end
    end
end

function FindAllIPV4(str)
    local ipv4_pattern = "(%d+%.%d+%.%d+%.%d+)"
    for ipv4 in str:gmatch(ipv4_pattern) do ipv4_list[#ipv4_list + 1] = ipv4 end
end

-- read text from stdin and mask any IPV4 or IPV6 addresses with x
-- we need to keep the content of the file in memory to be able to
-- replace the IPV4 and IPV6 addresses with x and return the same text
local text_content = {}

local file
--- filepath is the first argument to the lua program
local filepath = args[1]
--- if no filepath is given, read from stdin
if filepath == nil then
    file = io.stdin
else
    file = io.open(filepath, "r")
end

for line in file:lines() do text_content[#text_content + 1] = line end

--- close the file if it was opened
if file ~= io.stdin then file:close() end

for _, line in ipairs(text_content) do
    FindAllIPV4(line)
    FindAllIPV6(line)
end

local ipv4_list_masked = MASK_IPV4(ipv4_list)
local ipv6_list_masked = MASK_IPV6(ipv6_list)

--- using the text content,
for i, line in ipairs(text_content) do
    for index, ipv4 in ipairs(ipv4_list) do
        line = line:gsub(ipv4, ipv4_list_masked[index])
    end
    for index, ipv6 in ipairs(ipv6_list) do
        line = line:gsub(ipv6, ipv6_list_masked[index])
    end
    print(line)
end
