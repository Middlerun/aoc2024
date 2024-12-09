require('utils')
require('09/common')

local function compactMemory(memory)
  local pointer1 = 1
  local pointer2 = #memory

  while true do
    local blockDescriptor = memory[pointer2]
    if blockDescriptor.type == 'file' then
      -- find next empty block
      while memory[pointer1].type == 'file' do
        pointer1 = pointer1 + 1
      end

      if pointer2 <= pointer1 then
        break
      end

      memory[pointer1] = memory[pointer2]
      memory[pointer2] = EMPTY_BLOCK_DESCRIPTOR
    end

    pointer2 = pointer2 - 1

    if pointer2 <= pointer1 then
      break
    end
  end
end

local memory = parseInput()
compactMemory(memory)

print(checksum(memory))
