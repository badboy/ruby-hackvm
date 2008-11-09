#!/usr/bin/env ruby

# http://www.hacker.org/hvm/

class HackVM
  class StackUnderFlow < Exception; end
  class IntegerOverflow < Exception; end
  class InitMemoryToBig < Exception; end
  class OutOfStackException < Exception; end
  class OutOfCodeBoundsException < Exception; end
  class TooManyCyclesException < Exception; end
  class WrongOpCode < Exception; end
  class MemoryReadAccessViolation < Exception; end
  class MemoryWriteAccessViolation < Exception; end
  
  MAX_CYCLES=10000
  MIN_INT=-(1<<63)
  MAX_INT=(1<<63)-1

  OPS = {
	' ' => lambda {},
	"\n" => lambda {},
	'p' => :printi,
	'P' => :printc,
	'0' => [:push, 0],
	'1' => [:push, 1],
	'2' => [:push, 2],
	'3' => [:push, 3],
	'4' => [:push, 4],
	'5' => [:push, 5],
	'6' => [:push, 6],
	'7' => [:push, 7],
	'8' => [:push, 8],
	'9' => [:push, 9],
	'+' => :add,
	'-' => :sub,
	'*' => :mul,
	'/' => :div,
	':' => :cmp,
	'g' => :goto,
	'?' => :goto_if_zero,
	'c' => :call,
	'$' => :doreturn,
	'<' => :peek,
	'>' => :poke,
	'^' => :pick,
	'v' => :roll,
	'd' => :drop,
	'!' => :exit
  }

  def initialize
    @memory = [0]*16384
    @callstack = []
    @operandstack = []
    @programcounter = 0
    @cyclecounter = 0
  end
  
  def init(memory)
    if memory.size > 16384
      raise InitMemoryToBig
    end
    memory.each_with_index do |e, i|
      @memory[i] = e
    end
  end
  
  def execute(code, trace)
    codel = code.size
    @codel = codel
    while @programcounter != codel
      op_code = code[@programcounter, 1]
      STDERR.print('@'+@programcounter.to_s+' '+op_code) if trace
      @programcounter += 1
      @cyclecounter += 1
      if @cyclecounter > MAX_CYCLES
        raise TooManyCyclesException, 'too many cycles'
      end
      if OPS[op_code]
        if OPS[op_code].kind_of? Symbol
          method(OPS[op_code]).call
        elsif OPS[op_code].kind_of? Proc
          OPS[op_code].call
        elsif OPS[op_code].kind_of? Array
          m = method(OPS[op_code][0])
          m.call(OPS[op_code][1])
        else
          raise WrongOpCode, "wrong op-code '#{op_code}'"
        end
      else
        raise WrongOpCode, "wrong op-code '#{op_code}'"
      end
      if @programcounter < 0 || @programcounter > codel
        raise OutOfCodeBoundsException, 'out of code bounds'
      end
      STDERR.puts(' ['+@operandstack.join(',')+']') if trace
    end
    puts
    
    rescue Exception => e
      STDERR.puts("!ERROR: exception while executing I=#{op_code} PC=#{@programcounter-1} STACK_SIZE=#{@operandstack.size}")
      puts e
      Kernel.exit(1)
  end

  private
  def push(v)
    if v < MIN_INT || v > MAX_INT
      raise IntegerOverflow
    end
    @operandstack.push(v)
  end
    
  def pop
    if @operandstack.size == 0
      raise StackUnderFlow
    end
    @operandstack.pop
  end
  
  def printc
    print( pop.chr )
  end

  def printi
    print pop
  end
  
  def add
    push(pop+pop)
  end
    
  def sub
    a = pop
    b = pop
    push(b-a)
  end

  def mul
    push(pop*pop)
  end
  
  def div
    a = pop
    b = pop
    push(b/a)
  end
  
  def cmp
    a = pop
    b = pop
    push( b<=>a )
  end
  
  def goto
    @programcounter += pop
  end

  def goto_if_zero
    offset = pop
    @programcounter += offset if pop == 0
  end

  def call
    @callstack.push(@programcounter)
    @programcounter = pop
  end

  def doreturn
    @programcounter = @callstack.pop
  end
  
  def peek
    addr = pop
    if addr < 0 || addr >= @memory.size
      raise MemoryReadAccessViolation, 'memory read access violation @'+addr.to_s
    end
    push(@memory[addr])
  end
  
  def poke
    addr = pop
    if addr < 0 || addr >= @memory.size
      raise MemoryWriteAccessViolation, 'memory write access violation @'+addr.to_s
    end
    @memory[addr] = pop
  end

  def pick
    where = pop
    if where < 0 || where >= @operandstack.size
      raise OutOfStackException, 'out of stack @'+where.to_s
    end
    push(@operandstack[-1-where])
  end

  def roll
    where = pop
    if where < 0 || where >= @operandstack.size
      raise OutOfStackException, 'out of stack @'+where.to_s
    end
    v = @perandstack[-1-where]
    @perandStack.delete_at(-1-where)
    push(v)
  end
    
  def drop
    pop
  end
    
  def exit
    @programcounter = @codel
  end
end

require 'optparse'

trace = false
memory = []
ARGV.options do |o|
  o.banner = "hackvm.rb [--init <init-mem-filename>] [--trace] <code-filename>\n"
  o.banner += "The format for the initial memory file is: cell0,cell1,...\n"
  o.banner += "More on http://www.hacker.org/hvm/"
  o.separator('')

  o.on('-t', '--trace', 'trace commands') do |t|
    trace = t
  end
  
  o.on('-i', '--init FILE', 'init-mem-filename') do |i|
    f = File.read(i)
    memory = f.chomp.split(',').map{|e|Integer(e)}
  end
end
begin
  ARGV.parse!
rescue OptionParser::InvalidOption => e
  STDERR.puts "!ERROR: #{e}"
  exit 1
end

raise "not enough arguments" if ARGV.size < 1
hvm = HackVM.new
hvm.execute(File.read(ARGV[0]), trace)
