local socket = require("socket")
local clock = os.clock

local unistd = require 'posix.unistd'

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
  local childpid = unistd.fork()
  if childpid == 0 then
    local line, err = client:receive("*l")
    print("calculate("..line..")")
    if not err then
      client:send(calculate(line))
    else
      print(err)
    end
    client:close()
    unistd._exit(0)
  else
    client:close()
  end
end

while true do
  local client = server:accept()
  if client then
    print("client conected "..client:getpeername())
    clone(client)
  end
end
