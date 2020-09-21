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

[原文链接](https://medium.com/@oleavr/anatomy-of-a-code-tracer-b081aadb0df8)

### 代码跟踪器的剖析

Ole André Vadla Ravnås Oct 24, 2014 · 5 min read

几年前，我发现自己对专有应用程序中的供应商锁定握手进行了反向工程。我很清楚：我需要一个代码跟踪器。

在我看来，最终的代码跟踪器应该能够以最小的速度跟踪代码，它应该提供高粒度，并且不需要我跟踪整个过程，并且应该能够应对反调试的麻烦。依赖于软件和硬件断点/陷阱的常规方法存在一些问题。软件断点会修改内存中的原始代码，并且可能被定期校验和自己代码的应用程序检测到。硬件断点可能很容易被检测到或破坏。但是，更重要的是，每个陷阱都需要先将上下文切换到内核，然后再切换到执行操作的调试器进程，再回到内核，然后再回到目标进程。这是很多往返，甚至对于分支机构级的跟踪来说，开销也太大了。从粒度角度来看，当应用程序调用感兴趣的API（例如recv（））时开始跟踪非常容易，而在下一次调用时停止跟踪。现在，我们如何实现所有这些目标？答案是动态重新编译。请看[Stalker](https://github.com/frida/frida-gum/blob/eace9f5deeca2de6e3fc92f73da71f43d9325d63/gum/backend-x86/gumstalker-x86.c) 及[Stalker使用文档](https://frida.re/docs/stalker/)。

这个想法很简单。当线程将要执行其下一条指令时，您需要复制这些指令并将其与所需的日志代码交织。因此，您保持原始指令不变，以使反调试校验和逻辑保持满意状态，而是执行复制。例如，在每条指令之前，您都应将CALL放入日志处理程序，并向其提供有关将要执行的指令的详细信息。这是一个简化的插图：

![stalker_illustration](/images/frida_stalker_1.png)

在这种情况下，动态重新编译的好处在于性能。是否想追踪每条指令？在您复制的每条指令之间添加日志记录代码。只对CALL指令感兴趣吗？仅在这些说明旁边添加日志记录代码。这意味着您将根据实际需要添加运行时开销。

虽然有一些挑战。首先，x86上的指令的长度是可变的，因此您需要一个非常好的反汇编程序并支持最新的指令。用Capstone保全。接下来，您不仅可以将指令复制到内存中的其他位置，而且希望它们像以前一样工作。许多指令是与位置相关的，因此必须针对它们在内存中的新位置进行调整。同样，被跟踪的代码可能是有对抗的，因此只能复制指令直到第一个分支指令（一次一个基本块）为止。然后只需将该指令替换为控制转移回引擎，告诉它为分支目标生成代码，然后在该处继续执行。

这显然是有代价的，因为这意味着我们必须为每个此类上下文切换保存和恢复很多状态。但是，我们可以轻松优化的是重用我们之前已经重新编译的代码。同样，当一个块以静态分支（例如jmp +56）结尾时，我们可以使用直接分支将其回补到目标的重新编译版本。但是，我们必须非常小心，因为应用程序可能会在运行时修改其自己的代码。因此，我们引入了一个可基于应用程序进行调整的信任阈值参数。我们的想法是，每次执行块时，我们都会不断检查是否发生了更改；一旦成功回收了信任阈值时间，我们就将其视为受信任的对象，并使用直接指向重新编译目标的分支对静态分支进行修补。零开销。

但是，仍然存在进一步优化的空间。由于目前仅优化静态分支，因此涉及寄存器或存储器位置的静态分支需要上下文切换回引擎。未来的改进将是实现内联缓存，其中在引擎的分支前面有一些填充NOP，并且这些填充NOP将被以下内容动态覆盖：
```asm
CMP branch_target，1234 
JZ precompiled_block_a 
CMP branch_target，5678 
JZ precompiled_block_b 
<Nop-padding for future cache entries> 
JMP enter_engine_for_dynamic_lookup
```

不过，块回收和静态分支优化在性能方面大有帮助。我汇总了一个综合基准，并在进行这些优化之前测得了大约14000倍的降速，并通过这些优化将其提高到了约30倍。

有些指令需要特殊处理。例如，必须重写一条CALL指令，以便它在堆栈上执行具有与原始代码完全相同的影响。这方面的一个方面当然是针对反调试逻辑的弹性，但是我们还需要能够停止在调用堆栈中深入跟踪线程，而不必替换堆栈上的返回地址。 （这将很快指向释放的内存。）而且，我们不能假定CALL指令执行了实际的函数调用。它可以仅用于获取正在执行的代码的地址。这通常用于自修改代码以及x86–32上与位置无关的代码，与x86-64不同，该代码缺少PC相对寻址。

现在，在涵盖了核心机制的情况下，我们如何开始跟踪？我们需要处理两种情况。首先，在同步情况下，我们拦截了诸如recv（）之类的API调用，并且我们想开始跟踪正在执行的线程。在这里，我们只需调用gum_stalker_follow_me（），它将在其返回地址处重新编译指令，并将返回地址替换为第一个重新编译的指令的地址。对于第二种情况，我们调用gum_stalker_follow（target_thread_id）挂起目标线程，然后读出其PC（程序计数器：x86上的EIP或RIP）寄存器并在那里重新编译指令，然后用第一个线程的地址更新该线程的PC寄存器。重新编译指令，最后恢复线程。

现在，您可能想知道在此代码跟踪程序所在的Frida之上构建的真实应用程序中，所有这些看起来如何。这是一个43秒的截屏视频，显示了它的运行情况：
是否想更好地了解内部原理？ 在这里查看测试套件，深入研究实现或在下面发表评论。

## 原文

### Anatomy of a code tracer

Ole André Vadla Ravnås Oct 24, 2014 · 5 min read

A few years back I found myself reverse-engineering a vendor lock-in handshake in a proprietary application. It was clear to me: I needed a code tracer.
In my mind the ultimate code tracer should be able to trace code with minimal slowdown, it should provide high granularity and not require me to trace the entire process, and it should be able to cope with anti-debug trickery. The conventional approaches relying on software and hardware breakpoints/traps have some issues. Software breakpoints modify the original code in memory and may be detected by applications that periodically checksum their own code. Hardware breakpoints may be detected or sabotaged quite easily. More importantly though, each trap will require a context switch to the kernel, then to the debugger process which takes an action, back to the kernel, then back to the target process again. That’s a lot of round-trips, and even for branch-level tracing it’s just way too much overhead. Granularity-wise it should be really easy to start tracing when the application calls an API of interest, for example recv(), and stop tracing on the next call. Now, how do we achieve all of this? The answer is dynamic recompilation. Enter the Stalker.
The idea is quite simple. As a thread is about to execute its next instructions, you make a copy of those instructions and interlace the copy with the logging code that you need. You thus leave the original instructions untouched in order to keep anti-debug checksum logic happy, and execute the copy instead. For instance, before each instruction you would put a CALL to the log handler and give it details about the instruction that’s about to get executed.
Here’s a simplified illustration:

![stalker_illustration](/images/frida_stalker_1.png)

The beauty of dynamic recompilation in this context is performance. Want to trace every single instruction? Add logging code between every single instruction that you copy. Only interested in CALL instructions? Add logging code next to those instructions only. This means you add runtime overhead based on what you actually need.

There are some challenges though. First off, instructions on x86 are variable length, so you need a really good disassembler with support for the latest instructions. Capstone to the rescue. Next, you can’t just copy instructions elsewhere in memory and expect them to work like before. Lots of instructions are position-dependent and will have to be adjusted for their new location in memory. Also, the code being traced might be hostile, so only copy instructions up until the first branch instruction (one basic block at a time). Then just replace that instruction with a control transfer back into the engine, telling it to generate code for the branch target, and resume execution there.

This obviously has a cost, as it means we have to save and restore lots of state for each such context-switch. What we can easily optimize though, is to re-use the code we already recompiled before. Also, when a block ends with a static branch, like jmp +56, we can backpatch that with a direct branch to the recompiled version of the target. However, we have to be really careful, as the application might be modifying its own code at runtime. Because of this we introduce a trust-threshold parameter that can be adjusted based on the application. The idea is that we keep checking whether a block changed every time we’re about to execute it, and once it’s been successfully recycled trust-threshold times we consider it trusted, and backpatch static branches with a branch straight to the recompiled target. Zero overhead.

There is still room for further optimization, though. As only static branches are currently optimized, those involving a register or memory location require a context-switch back into the engine. A future improvement here would be to implement inline caching, where there’s some padding NOPs in front of the branch into the engine, and those would get dynamically overwritten with something along the lines of:

```asm
CMP branch_target, 1234
JZ precompiled_block_a
CMP branch_target, 5678
JZ precompiled_block_b
<NOP-padding for future cache entries>
JMP enter_engine_for_dynamic_lookup
```

The block recycling and static branch optimization go a long way performance-wise though. I put together a synthetic benchmark and measured roughly 14000x slowdown before these optimizations, and with them it was improved to ~30x.

Some instructions require special treatment. For example a CALL instruction will have to be rewritten so it has the exact same side-effect on the stack as if the original code was the one executing. One aspect of this is of course resilience against anti-debug logic, but we also need to be able to stop tracing a thread deep down in a call-stack, without having to replace the return addresses on the stack. (Which would soon be pointing to freed memory.) Also, we cannot assume that a CALL instruction performs an actual function call. It could be used just to get the address of the code being executed. This is commonly used in self-modifying code, and for position-independent code on x86–32, which unlike x86-64 lacks PC-relative addressing.

Now, with the core mechanics covered, how do we start the tracing? There are two cases we need to handle. First, there’s the synchronous case where we intercepted an API call like recv(), and we want to start tracing the thread that we’re executing in. Here we simply call gum_stalker_follow_me(), and it will recompile the instructions at its return address, and replace the return address with the address of the first recompiled instruction. For the second case we call gum_stalker_follow(target_thread_id) which suspends the target thread, then reads out its PC (Program Counter: EIP or RIP on x86) register and recompiles the instructions there, then updates that thread’s PC register with the address of the first recompiled instruction, and finally resumes the thread.

Now you might be wondering what all of this looks like in a real-world application built on top of Frida, where this code tracer lives. Here’s a 43 second screencast showing it in action:

Want to get a better understanding of the internals? Have a look at the test-suite [here](https://github.com/frida/frida-gum/blob/eace9f5deeca2de6e3fc92f73da71f43d9325d63/tests/core/arch-x86/stalker-x86.c), dig into the implementation, or leave a comment below.

