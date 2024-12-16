require('priorityQueue')

-- It's not really worth setting up a full unit testing library here
-- but I still needed a way to test this class...

local q1 = PriorityQueue:new()
q1:add('a', 5)
q1:add('c', 12)
q1:add('b', 8)
q1:add('d', 18)

q1:print()
print('Should be: a b c d')

print('Has a:', q1:has('a'))
print('Popped ' .. q1:pop())
print('Has a:', q1:has('a'))

q1:print()
print('Should be: b c d')

q1:updatePriority('d', 10)
q1:print()
print('Should be: b d c')

q1:updatePriority('b', 11)
q1:print()
print('Should be: d b c')

print('Popped ' .. q1:pop())
print('Popped ' .. q1:pop())
print('Popped ' .. q1:pop())

q1:print()
print('Should be empty')
