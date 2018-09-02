local socket = require("socket")
local clock = os.clock

function connect()
  local host, port = "127.0.0.1", 2323
  local tcp = assert(socket.tcp())
  tcp:connect(host, port);
  return tcp
end

function serialize(msg)
  return msg..'\n'
end

function calculate(x)
  local conn = connect()
  conn:send(serialize(x))
  local s, status, partial = conn:receive()
  conn:close()
  return s or partial
end

x = arg[1] or 10
time_init = os.time()
print("calculate("..x..")")
print("result: "..calculate(x))
print("time elapsed: "..os.difftime(os.time()-time_init))
