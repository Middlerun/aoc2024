-- Check if a file or directory exists in this path.
-- From https://stackoverflow.com/a/40195356
local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

for day = 1, 25 do
  local paddedDay = '' .. day
  if (day < 10) then
    paddedDay = '0' .. day
  end
  if (exists('./' .. paddedDay .. '/')) then
    print('Day ' .. day .. ' part 1:')
    os.execute('lua ./' .. paddedDay .. '/a.lua')
    print('Day ' .. day .. ' part 2:')
    os.execute('lua ./' .. paddedDay .. '/b.lua')
  end
end
