#!/bin/lua
-- File: /var/www/pastecat.cgi
-- Name: pastecat.cgi / pastecat.lua
-- Description: Kop1peCat - Simple pastecat cgi script for webserver.

require('os.isdir')
require('os.isfile')
require('io.execute')

local HTTP_VER, HTTP_CODE, HTTP_MESG, PASTEDIR, RET
local response_header, body, stext, pastename = ""
local HTTP_HOST, REQUEST_URI, REQUEST_METHOD, REMOTE_ADDR
local QUERY_STRING, CONTENT_TYPE, CONTENT_LENGTH
local HTTP_USER_AGENT, HTTP_REFERER
local configfile, base_uri, pastedir, pastefile_url
local maxdirsize, maxfilesize, dirsize, file, cmd

configfile = "/etc/pastecat.conf"

if os.isfile(configfile) then
  dofile(configfile)
end

HTTP_HOST = os.getenv("HTTP_HOST")
REQUEST_URI = os.getenv("REQUEST_URI")
REQUEST_METHOD = os.getenv("REQUEST_METHOD")
REMOTE_ADDR = os.getenv("REMOTE_ADDR")
QUERY_STRING = os.getenv("QUERY_STRING")
CONTENT_TYPE  = os.getenv("CONTENT_TYPE")
CONTENT_LENGTH = tonumber(os.getenv("CONTENT_LENGTH"))
HTTP_USER_AGENT = os.getenv("HTTP_USER_AGENT")
HTTP_REFERER = os.getenv("HTTP_REFERER")

base_uri = string.gsub(REQUEST_URI, "/[^/]*$", "")
response_header = {}
body = {}

-- It fallback
if not WWWDIR then WWWDIR = os.getenv("PWD") end
if not pastedir then pastedir = "/wpastecat/" end
if not maxdirsize then maxdirsize = 8 end
if not maxfilesize then maxfilesize = 32768 end
if not CONTENT_TYPE then CONTENT_TYPE = "text/html" end

if REQUEST_METHOD == "GET" and string.find(QUERY_STRING, "^pastename=[A-z0-9]*%.text") then
  pastename = string.gsub(QUERY_STRING, "^.*pastename=", "")
  pastename = string.gsub(pastename, "&.*$", "")
  pastename = string.gsub(pastename, "%.text$", "")
else

------------------------------     Generic Random Name     ----------------------------------------
local chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789" -- The Char Library

while true do
  local rint = math.random(1, #chars) -- 1 out of length of chars
  local i = chars:sub(rint, rint) -- Pick it (rchar)
  if #pastename == 8 then break end
  pastename = pastename .. i
end
---------------------------------------------------------------------------------------------------
end

pastefile = WWWDIR .. pastedir .. pastename .. ".text"
pastefile_url = "http://" .. HTTP_HOST .. pastedir .. pastename .. ".text"

HTTP_VER = "HTTP/1.0"
HTTP_CODE = 200
HTTP_MESG = "OK"
stext = "Type in here"

if os.isfile(pastefile) then
  file = io.open(pastefile, "r")
  stext = file:read("*all")
  stext = string.gsub(stext, "[\n]+$", "")
  io.close(file)
end

cmd = "du -m " .. WWWDIR .. pastedir
dirsize = io.execute(cmd)
dirsize = string.gsub(dirsize, "[ \t].*$", "")
dirsize = tonumber(dirsize)

if
REQUEST_METHOD == "POST" and
CONTENT_TYPE == "application/x-www-form-urlencoded" and
dirsize < maxdirsize and
CONTENT_LENGTH < maxfilesize and
not os.isfile(pastefile)
then
file = io.open(pastefile, "w+")

local size = 2^12  -- buffer size (4K)
while true do
  local chunk = io.read(size)
  if not chunk then break end
  chunk = string.gsub(chunk, "^paste=", "")
  chunk = string.gsub(chunk, "+", " ")
  chunk = string.gsub(chunk, "%%20", " ")
  chunk = string.gsub(chunk, "%%2[fF]", "/")
  chunk = string.gsub(chunk, "%%2[cC]", ",")
  chunk = string.gsub(chunk, "%%3[aA]", ":")
  chunk = string.gsub(chunk, "%%3[dD]", "=")
  chunk = string.gsub(chunk, "%%0[dD]%%0[aA]", "\n")
  chunk = string.gsub(chunk, "%%2[bB]", "+")
  chunk = string.gsub(chunk, "[\n]+$", "")
  file:write(chunk, "\n")
end
io.close(file)

if
CONTENT_TYPE == "application/x-www-form-urlencoded" and HTTP_REFERER or 
( not ( HTTP_USER_AGENT == "Wget" ) and
not ( HTTP_USER_AGENT == "Curl" ) and
not HTTP_USER_AGENT )
then
response_header = {
  "HTTP/1.0 302 Found",
  "Content-Charset: us-ascii",
  "Content-Type: text/html; charset=us-ascii",
  "Location: " .. REQUEST_URI .. "?pastename=" .. pastename .. ".text",
  "Connection: close" .. "\n"
}
elseif CONTENT_TYPE == "application/x-www-form-urlencoded" then
response_header = {
  "HTTP/1.0 200 OK",
  "Content-Charset: us-ascii",
  "Content-Type: text/plain; charset=us-ascii",
  "Connection: close" .. "\n"
}
body = { pastefile_url }
end

elseif REQUEST_METHOD == "POST" then
response_header = {
  "HTTP/1.0 302 Found",
  "Content-Charset: us-ascii",
  "Content-Type: text/html; charset=us-ascii",
  "Location: " .. base_uri .. pastedir .. pastename .. ".text",
  "Connection: close" .. "\n"
}

elseif REQUEST_METHOD == "GET" then

pastesave = ""
if string.find(QUERY_STRING, "pastename=[A-z0-9]*%.text") then
  pastesave = '<TR><TH ALIGN="left">&nbsp;Save Url:&nbsp;<TH ALIGN="center">'
  pastesave = pastesave .. '&nbsp;' .. pastefile_url .. '&nbsp;</TR>\n'
  REQUEST_URI = string.gsub(REQUEST_URI, "%?pastename=.*$", "")
end

response_header = {
  HTTP_VER .. " " .. HTTP_CODE .. " " .. HTTP_MESG,
  "Content-Charset: us-ascii",
  "Content-Type: " .. CONTENT_TYPE .. "; charset=us-ascii",
  "Connection: close" .. "\n"
}

body = {
'<!DOCTYPE HTML>', '<HTML LANG="en">',
'<HEAD><TITLE>Kop1peCat</TITLE></HEAD>',
'<BODY>',
'<CENTER><H1>My Paste Cat</H1></CENTER>',

'<TABLE BORDER>',
'<TR><TH ALIGN="left"><B>&nbsp;User:&nbsp;</B><TH ALIGN="center">',
'<B><FONT COLOR="red">&nbsp;' .. REMOTE_ADDR .. "&nbsp;</FONT></B></TR>",
pastesave,
'</TABLE>',

-- add paste
'<FORM NAME="Paste" METHOD="POST" ACTION="' .. REQUEST_URI .. '">',

'<TABLE BORDER>',
'<TEXTAREA NAME="paste" ROWS=6 COLS=40>' .. stext .. '</TEXTAREA>',
'</TR></TABLE>',

'<INPUT TYPE="submit" VALUE="Send">',
'</FORM>',

'</BODY>\n</HTML>'
}
end

print(table.concat(response_header, "\n"))
print(table.concat(body, "\n"))

-- Clean from old files.
cmd = "find " .. WWWDIR .. pastedir .. "/*.text -mtime +7 -exec rm {} \\;"
RET = os.execute(cmd)