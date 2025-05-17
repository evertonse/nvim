local text = [[
dasdas dsad - "/usr/local/bin" some more garbage
- /etc/nginx/nginx.conf
- ./relative/path/to/file
- ../another/relative/path
- /home/user/
- invalid/path/with"quote
- invalid/path/with'singlequote
]]

local pattern = [[.*(/[^"\'\\0]+).*]]
print 'We bouta print them pattens gmathsed'

local a = string.gmatch(text, pattern)
print(a)
for path in a do
  print(path)
end
-- lua lua/functions/pattern.lua
