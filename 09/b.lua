require('utils')
require('09/common')

function printGapIndex(gapIndex)
  for size, gaps in pairs(gapIndex) do
    if (#gaps > 0) then
      print('Gaps of ' .. size .. ':')
      for _, g in ipairs(gaps) do
        print('  Start position ' .. g.startLocation)
      end
    end
  end
end

function addGapToIndex(gapIndex, gap)
  if not gapIndex[gap.size] then gapIndex[gap.size] = {} end
  local gaps = gapIndex[gap.size]
  local i = 1
  while gaps[i] and gaps[i].startLocation < gap.startLocation do
    i = i + 1
  end
  table.insert(gaps, i, gap)
end

local function compactMemory(memory)
  -- build indices
  local fileIndex = {}
  local gapIndex = {}
  local pointer = 1
  local maxFileId = 0
  while pointer <= #memory do
    if memory[pointer].type == 'file' then
      local file = { id = memory[pointer].id, startLocation = pointer, blockDescriptor = memory[pointer] }
      while pointer <= #memory and memory[pointer].id == file.id do
        pointer = pointer + 1
      end
      file.size = pointer - file.startLocation
      fileIndex[file.id] = file
      if file.id > maxFileId then maxFileId = file.id end
    else
      local gap = { startLocation = pointer }
      while pointer <= #memory and memory[pointer].type == 'empty' do
        pointer = pointer + 1
      end
      gap.size = pointer - gap.startLocation
      if not gapIndex[gap.size] then gapIndex[gap.size] = {} end
      table.insert(gapIndex[gap.size], gap)
    end
  end

  -- move files
  for fileId = maxFileId, 1, -1 do
    local file = fileIndex[fileId]
    -- find suitable gap
    local targetGap = nil
    for gapSize, gaps in pairs(gapIndex) do
      if gapSize >= file.size and gaps[1] then
        local candidateGap = gaps[1]
        if (not targetGap or candidateGap.startLocation < targetGap.startLocation) and candidateGap.startLocation < file.startLocation then
          targetGap = candidateGap
        end
      end
    end

    if targetGap then
      -- find gaps around where the file is to be removed

      local gapBefore = nil
      local gapBeforeIndex = nil
      local gapAfter = nil
      local gapAfterIndex = nil
      if memory[file.startLocation - 1] and memory[file.startLocation - 1].type == 'empty' then
        local beforePointer = file.startLocation - 1
        while memory[beforePointer] and memory[beforePointer].type == 'empty' do
          beforePointer = beforePointer - 1
        end
        beforePointer = beforePointer + 1
        local gapSize = file.startLocation - beforePointer
        gapBefore, gapBeforeIndex = findWhere(gapIndex[gapSize],
          function(gap) return gap.startLocation == beforePointer end)
      end
      if memory[file.startLocation + file.size] and memory[file.startLocation + file.size].type == 'empty' then
        local afterPointer = file.startLocation + file.size
        while memory[afterPointer] and memory[afterPointer].type == 'empty' do
          afterPointer = afterPointer + 1
        end
        local gapSize = afterPointer - (file.startLocation + file.size)
        gapAfter = findWhere(
          gapIndex[gapSize],
          function(gap) return gap.startLocation == file.startLocation + file.size end
        )
      end

      local newGap = { startLocation = file.startLocation, size = file.size }
      if gapBefore then
        -- print('Found gap before file ' .. fileId .. ':')
        newGap.startLocation = gapBefore.startLocation
        newGap.size = newGap.size + gapBefore.size
        table.remove(gapIndex[gapBefore.size], gapBeforeIndex)
      end
      if gapAfter then
        -- print('Found gap after file ' .. fileId .. ':')
        newGap.size = newGap.size + gapAfter.size
        _, gapAfterIndex = findWhere(
          gapIndex[gapAfter.size],
          function(gap) return gap.startLocation == file.startLocation + file.size end
        )
        table.remove(gapIndex[gapAfter.size], gapAfterIndex)
      end

      addGapToIndex(gapIndex, newGap)

      local prevStartLocation = file.startLocation
      file.startLocation = targetGap.startLocation

      -- remove gap we just filled
      table.remove(gapIndex[targetGap.size], 1)
      -- generate new smaller gap record if needed
      if file.size < targetGap.size then
        local newGap = { size = targetGap.size - file.size, startLocation = targetGap.startLocation + file.size }
        addGapToIndex(gapIndex, newGap)
      end

      -- update memory
      for i = file.startLocation, file.startLocation + file.size - 1 do
        memory[i] = file.blockDescriptor
      end
      for i = prevStartLocation, prevStartLocation + file.size - 1 do
        memory[i] = EMPTY_BLOCK_DESCRIPTOR
      end

      -- printMemory(memory)
      -- printGapIndex(gapIndex)
    else
      -- print('nowhere to put file ' .. fileId)
    end
  end

  -- printMemory(memory)
  -- printGapIndex(gapIndex)
end

local memory = parseInput()
compactMemory(memory)

print(checksum(memory))
