-- From https://stackoverflow.com/a/27028488
local function anythingToString(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. anythingToString(v) .. ', '
    end
    return s .. ' } '
  else
    return tostring(o)
  end
end

-- It's like print, but cooler
function dump(o)
  print(anythingToString(o))
end
