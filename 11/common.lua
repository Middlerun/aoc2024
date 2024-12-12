function getNextStones(stone)
  if stone == 0 then return { 1 } end
  local stoneStr = tostring(stone)
  local strLength = stoneStr:len()
  if strLength % 2 == 0 then
    return {
      tonumber(stoneStr:sub(1, strLength / 2)),
      tonumber(stoneStr:sub(strLength / 2 + 1))
    }
  end
  return { stone * 2024 }
end
