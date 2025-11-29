#!/bin/lua
-- File: /lib/lua/io/execute.lua
-- File: /lib*/lua/5.4/io/execute.lua

function io.execute(cmd)
  local f = io.popen(cmd, 'r')
  local out = f:read('*a')
  f:close()
  out = string.gsub(out, '[\n\r\t ]+$', '')
  return out
end