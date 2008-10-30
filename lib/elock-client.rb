require 'socket'
require 'fcntl'

# Exception thrown from with_lock when the lock was not acquired.
class Locked < RuntimeError
end

# A client for elock.
class ELock

  # Construct a new ELock client pointed at the given server.
  def initialize(host, port=11400)
    connect host, port
  end

  # Acquire a lock.  This method should return very quickly except in the
  # case where a timeout is requested and the lock is unavailable.
  def lock(name, timeout=nil)
    do_cmd(timeout.nil? ? "lock #{name}" : "lock #{name} #{timeout}")
  end

  # Release a lock from elock.
  def unlock(name)
    do_cmd("unlock #{name}")
  end

  # Unlock all locks obtained by this client.
  def unlock_all
    do_cmd("unlock_all")
  end

  # Get server stats
  def stats
    @socket.write("stats\r\n")
    line = @socket.gets("\r\n")
    rv={}
    if line.to_i == 200
      line = @socket.gets("\r\n").strip
      while line != 'END'
        s, name, val=line.split
        rv[name]=val
        line = @socket.gets("\r\n").strip
      end
    end
    rv
  end

  # Run a block while holding the named lock.
  # raises Locked if the lock could not be acquired.
  def with_lock(name, timeout=nil)
    if lock(name, timeout).first == 200
      yield
    else
      raise Locked
    end
  ensure
    unlock name
  end

  # Close this connction
  def close
    @socket = @socket.close
  end

  private

  def connect(host, port)
    @socket = TCPSocket.new(host, port.to_i)
    @socket.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)
  end

  def do_cmd(cmd)
    @socket.write(cmd + "\r\n")
    res = @socket.gets("\r\n")
    [res.to_i, res[4..-3]]
  end

end
