local socket = require("socket")
local clock = os.clock

local posix = require 'posix.unistd'

local server = assert(socket.bind("*", 2323))

function sleep(n)
  local t0 = clock()
  while clock() - t0 <= n do end
end

function calculate(x)
  x = tonumber(x)
  sleep(10)
  return x*x
end

function clone(client)
  local childpid = posix.fork()
  if childpid == 0 then
    local line, err = client:receive()
    print("calculate("..line..")")
    if not err then client:send(calculate(line)) end
    client:close()
    posix._exit(0)
  else
    require 'posix.sys.wait'.wait(childpid)
  end
end

while true do
  local client = server:accept()
  print("client conected "..client:getpeername())
  clone(client)
end
