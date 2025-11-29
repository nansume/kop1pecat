#!/bin/lua
-- File: /lib/lua/os/isdir.lua
-- File: /lib*/lua/5.4/os/isdir.lua
-- Desc: io - Check if directory exists in lua?
-- Url: https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
-- Usage: require('os.isdir')
-- Usage: os.isdir("dir1/dir2")
-- Sample: RET = os.isdir(DIR .. "/")

-- This is a way that works on both Unix and Windows, without any external dependencies:

--- Check if a file or directory exists in this path
function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    else
      return false  -- BUGFIX: add return error 
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function os.isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path.."/")
end