#!/bin/lua
-- File: /lib/lua/os/isfile.lua
-- File: /lib*/lua/5.4/os/isfile.lua
-- Desc: io - Check if file exists in lua?
-- Url: https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
-- Usage: require('os.isfile')
-- Usage: os.isfile("dir/file")
-- Sample: RET = os.isfile(FILE)

-- This is a way that works on both Unix and Windows, without any external dependencies:

--- Check if a file exists in this path
function os.isfile(path)
  return exists(path)
end