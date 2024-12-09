EMPTY_BLOCK_DESCRIPTOR = { type = 'empty', id = 'empty' }

function parseInput()
  local input = readInput()()
  local inputNums = map(stringSplit(input, ''), function(n) return tonumber(n) end)

  local memory = {}

  local fileId = 0
  local pointer1 = 1

  for i, num in ipairs(inputNums) do
    local blockDescriptor
    if i % 2 == 1 then
      -- file
      blockDescriptor = { type = 'file', id = fileId }
      fileId = fileId + 1
    else
      -- empty space
      blockDescriptor = EMPTY_BLOCK_DESCRIPTOR
    end
    for _ = 1, num do
      memory[pointer1] = blockDescriptor
      pointer1 = pointer1 + 1
    end
  end

  return memory
end

function printMemory(mem)
  print(table.concat(map(mem, function(block)
    if block.type == 'file' then
      return block.id
    else
      return '.'
    end
  end), ''))
end

function checksum(memory)
  local sum = 0
  for i = 1, #memory do
    local blockDescriptor = memory[i]
    if blockDescriptor.type == 'file' then
      sum = sum + (i - 1) * blockDescriptor.id
    end
  end
  return sum
end
