---
title: Android 逆向工具之 --- frida stalker
date: 2020-09-17 21:06:36
tags:
- Android逆向
- 逆向工程
- 逆向工具
categories:
- 逆向工程
description: Stalker 是一个代码码跟踪工具, 本文主要翻译frida stalker 作者写的一篇blog。
---

## 译文
> 注: 原文在译文下面, 


## 原文

### Anatomy of a code tracer

Ole André Vadla Ravnås Oct 24, 2014 · 5 min read

A few years back I found myself reverse-engineering a vendor lock-in handshake in a proprietary application. It was clear to me: I needed a code tracer.
In my mind the ultimate code tracer should be able to trace code with minimal slowdown, it should provide high granularity and not require me to trace the entire process, and it should be able to cope with anti-debug trickery. The conventional approaches relying on software and hardware breakpoints/traps have some issues. Software breakpoints modify the original code in memory and may be detected by applications that periodically checksum their own code. Hardware breakpoints may be detected or sabotaged quite easily. More importantly though, each trap will require a context switch to the kernel, then to the debugger process which takes an action, back to the kernel, then back to the target process again. That’s a lot of round-trips, and even for branch-level tracing it’s just way too much overhead. Granularity-wise it should be really easy to start tracing when the application calls an API of interest, for example recv(), and stop tracing on the next call. Now, how do we achieve all of this? The answer is dynamic recompilation. Enter the Stalker.
The idea is quite simple. As a thread is about to execute its next instructions, you make a copy of those instructions and interlace the copy with the logging code that you need. You thus leave the original instructions untouched in order to keep anti-debug checksum logic happy, and execute the copy instead. For instance, before each instruction you would put a CALL to the log handler and give it details about the instruction that’s about to get executed.
Here’s a simplified illustration:

![](images/frida_stalker_1.png)
{% asset_img images/frida_stalker_1.png %}

The beauty of dynamic recompilation in this context is performance. Want to trace every single instruction? Add logging code between every single instruction that you copy. Only interested in CALL instructions? Add logging code next to those instructions only. This means you add runtime overhead based on what you actually need.
There are some challenges though. First off, instructions on x86 are variable length, so you need a really good disassembler with support for the latest instructions. Capstone to the rescue. Next, you can’t just copy instructions elsewhere in memory and expect them to work like before. Lots of instructions are position-dependent and will have to be adjusted for their new location in memory. Also, the code being traced might be hostile, so only copy instructions up until the first branch instruction (one basic block at a time). Then just replace that instruction with a control transfer back into the engine, telling it to generate code for the branch target, and resume execution there.
This obviously has a cost, as it means we have to save and restore lots of state for each such context-switch. What we can easily optimize though, is to re-use the code we already recompiled before. Also, when a block ends with a static branch, like jmp +56, we can backpatch that with a direct branch to the recompiled version of the target. However, we have to be really careful, as the application might be modifying its own code at runtime. Because of this we introduce a trust-threshold parameter that can be adjusted based on the application. The idea is that we keep checking whether a block changed every time we’re about to execute it, and once it’s been successfully recycled trust-threshold times we consider it trusted, and backpatch static branches with a branch straight to the recompiled target. Zero overhead.
There is still room for further optimization, though. As only static branches are currently optimized, those involving a register or memory location require a context-switch back into the engine. A future improvement here would be to implement inline caching, where there’s some padding NOPs in front of the branch into the engine, and those would get dynamically overwritten with something along the lines of:
CMP branch_target, 1234
JZ precompiled_block_a
CMP branch_target, 5678
JZ precompiled_block_b
<NOP-padding for future cache entries>
JMP enter_engine_for_dynamic_lookup
The block recycling and static branch optimization go a long way performance-wise though. I put together a synthetic benchmark and measured roughly 14000x slowdown before these optimizations, and with them it was improved to ~30x.
Some instructions require special treatment. For example a CALL instruction will have to be rewritten so it has the exact same side-effect on the stack as if the original code was the one executing. One aspect of this is of course resilience against anti-debug logic, but we also need to be able to stop tracing a thread deep down in a call-stack, without having to replace the return addresses on the stack. (Which would soon be pointing to freed memory.) Also, we cannot assume that a CALL instruction performs an actual function call. It could be used just to get the address of the code being executed. This is commonly used in self-modifying code, and for position-independent code on x86–32, which unlike x86-64 lacks PC-relative addressing.
Now, with the core mechanics covered, how do we start the tracing? There are two cases we need to handle. First, there’s the synchronous case where we intercepted an API call like recv(), and we want to start tracing the thread that we’re executing in. Here we simply call gum_stalker_follow_me(), and it will recompile the instructions at its return address, and replace the return address with the address of the first recompiled instruction. For the second case we call gum_stalker_follow(target_thread_id) which suspends the target thread, then reads out its PC (Program Counter: EIP or RIP on x86) register and recompiles the instructions there, then updates that thread’s PC register with the address of the first recompiled instruction, and finally resumes the thread.
Now you might be wondering what all of this looks like in a real-world application built on top of Frida, where this code tracer lives. Here’s a 43 second screencast showing it in action:

CryptoShark
Want to get a better understanding of the internals? Have a look at the test-suite here, dig into the implementation, or leave a comment below.

