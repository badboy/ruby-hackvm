# Ruby Hack VM

## Information

### The Hack VM is a tiny, trivial, virtual machine.

Its purpose is to be used as a simple execution engine that can run very simple programs.

more Information on <a href="http://www.hacker.org/hvm/">http://www.hacker.org/hvm/</a>

The virtual machine executes a single program and terminates, either by reaching the end of the code, an '!' instruction, or because an exception was thrown during execution.
A program is represented by a string of single-character instructions.
The virtual machine starts with the first instruction, executes it, and moves on to the next instruction, etc... 

The index of the current instruction is called the program counter.
The execution model is simple: the virtual machine has an operand stack, a memory buffer, and a call stack.

Each item on the operand stack or in memory is a cell that can hold a signed integer. 
For implementation reasons, those integers are currently limited to 32 bits, but do not count on it, they could be large in future implementations. 
The call stack is used to push the value of the program counter when jumping to a routine from which we want to return.

## Instructions

<table>
		<tr>
			<th>Instruction </th>
			<th>Description </th>
		</tr>
		<tr>
			<td>&#8217; &#8217; </td>
			<td>Do Nothing </td>
		</tr>
		<tr>
			<td>&#8217;p&#8217; </td>
			<td>Print S0 interpreted as an integer </td>
		</tr>
		<tr>
			<td>&#8217;P&#8217; </td>
			<td>Print S0 interpreted as an ASCII character (only the least significant 7 bits of the value are used) </td>
		</tr>
		<tr>
			<td>&#8217;0&#8217; </td>
			<td>Push the value 0 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;1&#8217; </td>
			<td>Push the value 1 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;2&#8217; </td>
			<td>Push the value 2 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;3&#8217; </td>
			<td>Push the value 3 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;4&#8217; </td>
			<td>Push the value 4 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;5&#8217; </td>
			<td>Push the value 5 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;6&#8217; </td>
			<td>Push the value 6 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;7&#8217; </td>
			<td>Push the value 7 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;8&#8217; </td>
			<td>Push the value 8 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;9&#8217; </td>
			<td>Push the value 9 on the stack </td>
		</tr>
		<tr>
			<td>&#8217;+&#8217; </td>
			<td>Push S1+S0 </td>
		</tr>
		<tr>
			<td>&#8217;-&#8217; </td>
			<td>Push S1-S0 </td>
		</tr>
		<tr>
			<td>&#8217;*&#8217; </td>
			<td>Push S1*S0 </td>
		</tr>
		<tr>
			<td>&#8217;/&#8217; </td>
			<td>Push S1/S0 </td>
		</tr>
		<tr>
			<td>&#8217;:&#8217; </td>
			<td>Push -1 if S1<S0, 0 if S1=S0, or 1 S1>S0 </td>
		</tr>
		<tr>
			<td>&#8217;g&#8217; </td>
			<td>Add S0 to the program counter </td>
		</tr>
		<tr>
			<td>&#8217;?&#8217; </td>
			<td>Add S0 to the program counter if S1 is 0 </td>
		</tr>
		<tr>
			<td>&#8217;c&#8217; </td>
			<td>Push the program counter on the call stack and set the program counter to S0 </td>
		</tr>
		<tr>
			<td>&#8217;$&#8217; </td>
			<td>Set the program counter to the value pop&#8217;ed from the call stack </td>
		</tr>
		<tr>
			<td>&#8217;<&#8217; </td>
			<td>Push the value of memory cell S0 </td>
		</tr>
		<tr>
			<td>&#8217;>&#8217; </td>
			<td>Store S1 into memory cell S0 </td>
		</tr>
		<tr>
			<td>&#8217;<sup>&#8217; </td>
			<td>Push a copy of S<S0+1> (ex: 0</sup> duplicates S0) </td>
		</tr>
		<tr>
			<td>&#8217;v&#8217; </td>
			<td>Remove S<S0+1> from the stack and push it on top (ex: 1v swaps S0 and S1) </td>
		</tr>
		<tr>
			<td>&#8217;d&#8217; </td>
			<td>Drop S0 </td>
		</tr>
		<tr>
			<td>&#8217;!&#8217; </td>
			<td>Terminate the program </td>
		</tr>
	</table>



## Examples

Input: "78*p" Output: 56

Input: "123451^2v5:4?9p2g8pppppp" Output: 945321
