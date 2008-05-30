Ruby Client for elock

This library provides an easy-to-use ruby client for
elock (https://github.com/dustin/elock).

== Example Usage (automatic lock management)

    require 'elock-client'
    l = ELock.new 'localhost'
    l.with_lock('some_lock') { puts "I got the lock!" }