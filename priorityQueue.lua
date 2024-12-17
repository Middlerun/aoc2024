---@alias QueueNode { value: any, key: any, priority: number, next: QueueNode | nil }

---@class PriorityQueue
---@field head QueueNode | nil
---@field new fun(self: PriorityQueue): PriorityQueue
---@field add fun(self: PriorityQueue, value: any, priority: number, key: any)
---@field pop fun(self: PriorityQueue): any
---@field has fun(self: PriorityQueue, key: any): boolean
---@field isEmpty fun(self: PriorityQueue): boolean
---@field updatePriority fun(self: PriorityQueue, key: any, priority: number)
---@field print fun(self: PriorityQueue)

---@type PriorityQueue
PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

---@return PriorityQueue
function PriorityQueue:new()
  ---@type PriorityQueue
  local q = {}
  setmetatable(q, self)
  q.head = nil
  return q
end

---@overload fun(self: PriorityQueue, value: any, priority: number)
function PriorityQueue:add(value, priority, key)
  if key == nil then key = value end

  ---@type QueueNode
  local newNode = { value = value, key = key, priority = priority }

  if not self.head or self.head.priority > priority then
    newNode.next = self.head
    self.head = newNode
    return
  end

  ---@type QueueNode
  local prev = self.head
  ---@type QueueNode
  local next = prev.next

  while true do
    if not next or next.priority > priority then
      newNode.next = next
      prev.next = newNode
      return
    end
    prev = next
    next = next.next
  end
end

function PriorityQueue:pop()
  local node = self.head
  if node then
    self.head = node.next
    return node.value
  end
end

function PriorityQueue:has(key)
  local node = self.head
  while node do
    if node.key == key then return true end
    node = node.next
  end
  return false
end

---@return boolean
function PriorityQueue:isEmpty()
  return self.head == nil
end

function PriorityQueue:updatePriority(key, priority)
  -- Find target node and remove it from queue
  local targetNode
  if self.head and self.head.key == key then
    ---@type QueueNode
    targetNode = self.head
    self.head = targetNode.next
  else
    ---@type QueueNode
    local prev = self.head
    local node = prev.next
    while node do
      if node.key == key then
        targetNode = node
        break
      end
      prev = node
      node = node.next
    end
    if targetNode then
      prev.next = node.next
    end
  end

  -- Re-add it with new priority
  self:add(targetNode.value, priority, key)
end

function PriorityQueue:print()
  local str = '#'
  local node = self.head
  while node do
    str = str .. ' -> ' .. tostring(node.value) .. ':' .. node.priority
    node = node.next
  end
  print(str)
end
