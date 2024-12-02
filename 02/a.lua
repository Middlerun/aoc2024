require('utils')
require('02/common')

local safeReportCount = 0

for line in readInput() do
  if isReportSafeWithSkip(parseLine(line), nil) then
    safeReportCount = safeReportCount + 1
  end
end

print(safeReportCount)
