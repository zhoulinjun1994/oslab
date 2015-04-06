
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 00 12 00 	lgdtl  0x120018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 1b 12 c0       	mov    $0xc0121bb0,%edx
c0100035:	b8 68 0a 12 c0       	mov    $0xc0120a68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 0a 12 c0 	movl   $0xc0120a68,(%esp)
c0100051:	e8 e6 8b 00 00       	call   c0108c3c <memset>

    cons_init();                // init the console
c0100056:	e8 7a 15 00 00       	call   c01015d5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 e0 8d 10 c0 	movl   $0xc0108de0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 fc 8d 10 c0 	movl   $0xc0108dfc,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 1c 4e 00 00       	call   c0104ea0 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 2a 1f 00 00       	call   c0101fb3 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 a2 20 00 00       	call   c0102130 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 e3 75 00 00       	call   c0107676 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 6e 16 00 00       	call   c0101706 <ide_init>
    swap_init();                // init swap
c0100098:	e8 c4 61 00 00       	call   c0106261 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 e9 0c 00 00       	call   c0100d8b <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 7a 1e 00 00       	call   c0101f21 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 f2 0b 00 00       	call   c0100cbd <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 01 8e 10 c0 	movl   $0xc0108e01,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 0f 8e 10 c0 	movl   $0xc0108e0f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 1d 8e 10 c0 	movl   $0xc0108e1d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 2b 8e 10 c0 	movl   $0xc0108e2b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 39 8e 10 c0 	movl   $0xc0108e39,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 0a 12 c0       	mov    %eax,0xc0120a80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 48 8e 10 c0 	movl   $0xc0108e48,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 87 8e 10 c0 	movl   $0xc0108e87,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 0a 12 c0    	mov    %dl,-0x3fedf560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 0a 12 c0       	add    $0xc0120aa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 0a 12 c0       	mov    $0xc0120aa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 f8 12 00 00       	call   c0101601 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 37 80 00 00       	call   c010837d <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 7f 12 00 00       	call   c0101601 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 5f 12 00 00       	call   c010163d <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 8c 8e 10 c0    	movl   $0xc0108e8c,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 8c 8e 10 c0 	movl   $0xc0108e8c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 8c ad 10 c0 	movl   $0xc010ad8c,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 ac 9b 11 c0 	movl   $0xc0119bac,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec ad 9b 11 c0 	movl   $0xc0119bad,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 56 d4 11 c0 	movl   $0xc011d456,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 b5 83 00 00       	call   c0108ab0 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 96 8e 10 c0 	movl   $0xc0108e96,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 af 8e 10 c0 	movl   $0xc0108eaf,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 c5 8d 10 	movl   $0xc0108dc5,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 c7 8e 10 c0 	movl   $0xc0108ec7,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 0a 12 	movl   $0xc0120a68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 df 8e 10 c0 	movl   $0xc0108edf,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 1b 12 	movl   $0xc0121bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 f7 8e 10 c0 	movl   $0xc0108ef7,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 10 8f 10 c0 	movl   $0xc0108f10,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 3a 8f 10 c0 	movl   $0xc0108f3a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 56 8f 10 c0 	movl   $0xc0108f56,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	e9 88 00 00 00       	jmp    c0100a76 <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fc:	c7 04 24 68 8f 10 c0 	movl   $0xc0108f68,(%esp)
c0100a03:	e8 43 f9 ff ff       	call   c010034b <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
c0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0b:	83 c0 02             	add    $0x2,%eax
c0100a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
c0100a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a18:	eb 25                	jmp    c0100a3f <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a27:	01 d0                	add    %edx,%eax
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2f:	c7 04 24 84 8f 10 c0 	movl   $0xc0108f84,(%esp)
c0100a36:	e8 10 f9 ff ff       	call   c010034b <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
c0100a3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a43:	7e d5                	jle    c0100a1a <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a45:	c7 04 24 8c 8f 10 c0 	movl   $0xc0108f8c,(%esp)
c0100a4c:	e8 fa f8 ff ff       	call   c010034b <cprintf>
		print_debuginfo(eip - 1);
c0100a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a54:	83 e8 01             	sub    $0x1,%eax
c0100a57:	89 04 24             	mov    %eax,(%esp)
c0100a5a:	e8 b6 fe ff ff       	call   c0100915 <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
c0100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a62:	83 c0 04             	add    $0x4,%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c0100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7a:	0f 8e 6e ff ff ff    	jle    c01009ee <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
c0100a80:	c9                   	leave  
c0100a81:	c3                   	ret    

c0100a82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a82:	55                   	push   %ebp
c0100a83:	89 e5                	mov    %esp,%ebp
c0100a85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8f:	eb 0c                	jmp    c0100a9d <parse+0x1b>
            *buf ++ = '\0';
c0100a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a94:	8d 50 01             	lea    0x1(%eax),%edx
c0100a97:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa0:	0f b6 00             	movzbl (%eax),%eax
c0100aa3:	84 c0                	test   %al,%al
c0100aa5:	74 1d                	je     c0100ac4 <parse+0x42>
c0100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaa:	0f b6 00             	movzbl (%eax),%eax
c0100aad:	0f be c0             	movsbl %al,%eax
c0100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab4:	c7 04 24 10 90 10 c0 	movl   $0xc0109010,(%esp)
c0100abb:	e8 bd 7f 00 00       	call   c0108a7d <strchr>
c0100ac0:	85 c0                	test   %eax,%eax
c0100ac2:	75 cd                	jne    c0100a91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac7:	0f b6 00             	movzbl (%eax),%eax
c0100aca:	84 c0                	test   %al,%al
c0100acc:	75 02                	jne    c0100ad0 <parse+0x4e>
            break;
c0100ace:	eb 67                	jmp    c0100b37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad4:	75 14                	jne    c0100aea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100add:	00 
c0100ade:	c7 04 24 15 90 10 c0 	movl   $0xc0109015,(%esp)
c0100ae5:	e8 61 f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	8d 50 01             	lea    0x1(%eax),%edx
c0100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afd:	01 c2                	add    %eax,%edx
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b04:	eb 04                	jmp    c0100b0a <parse+0x88>
            buf ++;
c0100b06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0d:	0f b6 00             	movzbl (%eax),%eax
c0100b10:	84 c0                	test   %al,%al
c0100b12:	74 1d                	je     c0100b31 <parse+0xaf>
c0100b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b17:	0f b6 00             	movzbl (%eax),%eax
c0100b1a:	0f be c0             	movsbl %al,%eax
c0100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b21:	c7 04 24 10 90 10 c0 	movl   $0xc0109010,(%esp)
c0100b28:	e8 50 7f 00 00       	call   c0108a7d <strchr>
c0100b2d:	85 c0                	test   %eax,%eax
c0100b2f:	74 d5                	je     c0100b06 <parse+0x84>
            buf ++;
        }
    }
c0100b31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b32:	e9 66 ff ff ff       	jmp    c0100a9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3a:	c9                   	leave  
c0100b3b:	c3                   	ret    

c0100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b42:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4c:	89 04 24             	mov    %eax,(%esp)
c0100b4f:	e8 2e ff ff ff       	call   c0100a82 <parse>
c0100b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5b:	75 0a                	jne    c0100b67 <runcmd+0x2b>
        return 0;
c0100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b62:	e9 85 00 00 00       	jmp    c0100bec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6e:	eb 5c                	jmp    c0100bcc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b76:	89 d0                	mov    %edx,%eax
c0100b78:	01 c0                	add    %eax,%eax
c0100b7a:	01 d0                	add    %edx,%eax
c0100b7c:	c1 e0 02             	shl    $0x2,%eax
c0100b7f:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100b84:	8b 00                	mov    (%eax),%eax
c0100b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8a:	89 04 24             	mov    %eax,(%esp)
c0100b8d:	e8 4c 7e 00 00       	call   c01089de <strcmp>
c0100b92:	85 c0                	test   %eax,%eax
c0100b94:	75 32                	jne    c0100bc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b99:	89 d0                	mov    %edx,%eax
c0100b9b:	01 c0                	add    %eax,%eax
c0100b9d:	01 d0                	add    %edx,%eax
c0100b9f:	c1 e0 02             	shl    $0x2,%eax
c0100ba2:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100ba7:	8b 40 08             	mov    0x8(%eax),%eax
c0100baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bad:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bba:	83 c2 04             	add    $0x4,%edx
c0100bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc1:	89 0c 24             	mov    %ecx,(%esp)
c0100bc4:	ff d0                	call   *%eax
c0100bc6:	eb 24                	jmp    c0100bec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcf:	83 f8 02             	cmp    $0x2,%eax
c0100bd2:	76 9c                	jbe    c0100b70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdb:	c7 04 24 33 90 10 c0 	movl   $0xc0109033,(%esp)
c0100be2:	e8 64 f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bec:	c9                   	leave  
c0100bed:	c3                   	ret    

c0100bee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bee:	55                   	push   %ebp
c0100bef:	89 e5                	mov    %esp,%ebp
c0100bf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf4:	c7 04 24 4c 90 10 c0 	movl   $0xc010904c,(%esp)
c0100bfb:	e8 4b f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c00:	c7 04 24 74 90 10 c0 	movl   $0xc0109074,(%esp)
c0100c07:	e8 3f f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c10:	74 0b                	je     c0100c1d <kmonitor+0x2f>
        print_trapframe(tf);
c0100c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c15:	89 04 24             	mov    %eax,(%esp)
c0100c18:	e8 64 18 00 00       	call   c0102481 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1d:	c7 04 24 99 90 10 c0 	movl   $0xc0109099,(%esp)
c0100c24:	e8 19 f6 ff ff       	call   c0100242 <readline>
c0100c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c30:	74 18                	je     c0100c4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3c:	89 04 24             	mov    %eax,(%esp)
c0100c3f:	e8 f8 fe ff ff       	call   c0100b3c <runcmd>
c0100c44:	85 c0                	test   %eax,%eax
c0100c46:	79 02                	jns    c0100c4a <kmonitor+0x5c>
                break;
c0100c48:	eb 02                	jmp    c0100c4c <kmonitor+0x5e>
            }
        }
    }
c0100c4a:	eb d1                	jmp    c0100c1d <kmonitor+0x2f>
}
c0100c4c:	c9                   	leave  
c0100c4d:	c3                   	ret    

c0100c4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4e:	55                   	push   %ebp
c0100c4f:	89 e5                	mov    %esp,%ebp
c0100c51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5b:	eb 3f                	jmp    c0100c9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c60:	89 d0                	mov    %edx,%eax
c0100c62:	01 c0                	add    %eax,%eax
c0100c64:	01 d0                	add    %edx,%eax
c0100c66:	c1 e0 02             	shl    $0x2,%eax
c0100c69:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c6e:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c74:	89 d0                	mov    %edx,%eax
c0100c76:	01 c0                	add    %eax,%eax
c0100c78:	01 d0                	add    %edx,%eax
c0100c7a:	c1 e0 02             	shl    $0x2,%eax
c0100c7d:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c82:	8b 00                	mov    (%eax),%eax
c0100c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8c:	c7 04 24 9d 90 10 c0 	movl   $0xc010909d,(%esp)
c0100c93:	e8 b3 f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9f:	83 f8 02             	cmp    $0x2,%eax
c0100ca2:	76 b9                	jbe    c0100c5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca9:	c9                   	leave  
c0100caa:	c3                   	ret    

c0100cab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cab:	55                   	push   %ebp
c0100cac:	89 e5                	mov    %esp,%ebp
c0100cae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb1:	e8 c9 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc3:	e8 01 fd ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd5:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
c0100cda:	85 c0                	test   %eax,%eax
c0100cdc:	74 02                	je     c0100ce0 <__panic+0x11>
        goto panic_dead;
c0100cde:	eb 48                	jmp    c0100d28 <__panic+0x59>
    }
    is_panic = 1;
c0100ce0:	c7 05 a0 0e 12 c0 01 	movl   $0x1,0xc0120ea0
c0100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cea:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfe:	c7 04 24 a6 90 10 c0 	movl   $0xc01090a6,(%esp)
c0100d05:	e8 41 f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d14:	89 04 24             	mov    %eax,(%esp)
c0100d17:	e8 fc f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d1c:	c7 04 24 c2 90 10 c0 	movl   $0xc01090c2,(%esp)
c0100d23:	e8 23 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d28:	e8 fa 11 00 00       	call   c0101f27 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d34:	e8 b5 fe ff ff       	call   c0100bee <kmonitor>
    }
c0100d39:	eb f2                	jmp    c0100d2d <__panic+0x5e>

c0100d3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d3b:	55                   	push   %ebp
c0100d3c:	89 e5                	mov    %esp,%ebp
c0100d3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d41:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d55:	c7 04 24 c4 90 10 c0 	movl   $0xc01090c4,(%esp)
c0100d5c:	e8 ea f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d68:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d6b:	89 04 24             	mov    %eax,(%esp)
c0100d6e:	e8 a5 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d73:	c7 04 24 c2 90 10 c0 	movl   $0xc01090c2,(%esp)
c0100d7a:	e8 cc f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d7f:	c9                   	leave  
c0100d80:	c3                   	ret    

c0100d81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d81:	55                   	push   %ebp
c0100d82:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d84:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
}
c0100d89:	5d                   	pop    %ebp
c0100d8a:	c3                   	ret    

c0100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8b:	55                   	push   %ebp
c0100d8c:	89 e5                	mov    %esp,%ebp
c0100d8e:	83 ec 28             	sub    $0x28,%esp
c0100d91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da3:	ee                   	out    %al,(%dx)
c0100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db6:	ee                   	out    %al,(%dx)
c0100db7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dca:	c7 05 bc 1a 12 c0 00 	movl   $0x0,0xc0121abc
c0100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd4:	c7 04 24 e2 90 10 c0 	movl   $0xc01090e2,(%esp)
c0100ddb:	e8 6b f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de7:	e8 99 11 00 00       	call   c0101f85 <pic_enable>
}
c0100dec:	c9                   	leave  
c0100ded:	c3                   	ret    

c0100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dee:	55                   	push   %ebp
c0100def:	89 e5                	mov    %esp,%ebp
c0100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df4:	9c                   	pushf  
c0100df5:	58                   	pop    %eax
c0100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfc:	25 00 02 00 00       	and    $0x200,%eax
c0100e01:	85 c0                	test   %eax,%eax
c0100e03:	74 0c                	je     c0100e11 <__intr_save+0x23>
        intr_disable();
c0100e05:	e8 1d 11 00 00       	call   c0101f27 <intr_disable>
        return 1;
c0100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0f:	eb 05                	jmp    c0100e16 <__intr_save+0x28>
    }
    return 0;
c0100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e16:	c9                   	leave  
c0100e17:	c3                   	ret    

c0100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e18:	55                   	push   %ebp
c0100e19:	89 e5                	mov    %esp,%ebp
c0100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e22:	74 05                	je     c0100e29 <__intr_restore+0x11>
        intr_enable();
c0100e24:	e8 f8 10 00 00       	call   c0101f21 <intr_enable>
    }
}
c0100e29:	c9                   	leave  
c0100e2a:	c3                   	ret    

c0100e2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2b:	55                   	push   %ebp
c0100e2c:	89 e5                	mov    %esp,%ebp
c0100e2e:	83 ec 10             	sub    $0x10,%esp
c0100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e3b:	89 c2                	mov    %eax,%edx
c0100e3d:	ec                   	in     (%dx),%al
c0100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4b:	89 c2                	mov    %eax,%edx
c0100e4d:	ec                   	in     (%dx),%al
c0100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5b:	89 c2                	mov    %eax,%edx
c0100e5d:	ec                   	in     (%dx),%al
c0100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e6b:	89 c2                	mov    %eax,%edx
c0100e6d:	ec                   	in     (%dx),%al
c0100e6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e71:	c9                   	leave  
c0100e72:	c3                   	ret    

c0100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e73:	55                   	push   %ebp
c0100e74:	89 e5                	mov    %esp,%ebp
c0100e76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e83:	0f b7 00             	movzwl (%eax),%eax
c0100e86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	0f b7 00             	movzwl (%eax),%eax
c0100e98:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9c:	74 12                	je     c0100eb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea5:	66 c7 05 c6 0e 12 c0 	movw   $0x3b4,0xc0120ec6
c0100eac:	b4 03 
c0100eae:	eb 13                	jmp    c0100ec3 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eba:	66 c7 05 c6 0e 12 c0 	movw   $0x3d4,0xc0120ec6
c0100ec1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec3:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100eca:	0f b7 c0             	movzwl %ax,%eax
c0100ecd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ede:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100ee5:	83 c0 01             	add    $0x1,%eax
c0100ee8:	0f b7 c0             	movzwl %ax,%eax
c0100eeb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef3:	89 c2                	mov    %eax,%edx
c0100ef5:	ec                   	in     (%dx),%al
c0100ef6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efd:	0f b6 c0             	movzbl %al,%eax
c0100f00:	c1 e0 08             	shl    $0x8,%eax
c0100f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f06:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f14:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f18:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f21:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f28:	83 c0 01             	add    $0x1,%eax
c0100f2b:	0f b7 c0             	movzwl %ax,%eax
c0100f2e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f32:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f36:	89 c2                	mov    %eax,%edx
c0100f38:	ec                   	in     (%dx),%al
c0100f39:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f40:	0f b6 c0             	movzbl %al,%eax
c0100f43:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f49:	a3 c0 0e 12 c0       	mov    %eax,0xc0120ec0
    crt_pos = pos;
c0100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f51:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
}
c0100f57:	c9                   	leave  
c0100f58:	c3                   	ret    

c0100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f59:	55                   	push   %ebp
c0100f5a:	89 e5                	mov    %esp,%ebp
c0100f5c:	83 ec 48             	sub    $0x48,%esp
c0100f5f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f65:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f69:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f71:	ee                   	out    %al,(%dx)
c0100f72:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f78:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f84:	ee                   	out    %al,(%dx)
c0100f85:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f8b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f93:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f97:	ee                   	out    %al,(%dx)
c0100f98:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100faa:	ee                   	out    %al,(%dx)
c0100fab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbd:	ee                   	out    %al,(%dx)
c0100fbe:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
c0100fd1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fdb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
c0100fe4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fee:	89 c2                	mov    %eax,%edx
c0100ff0:	ec                   	in     (%dx),%al
c0100ff1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff8:	3c ff                	cmp    $0xff,%al
c0100ffa:	0f 95 c0             	setne  %al
c0100ffd:	0f b6 c0             	movzbl %al,%eax
c0101000:	a3 c8 0e 12 c0       	mov    %eax,0xc0120ec8
c0101005:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100f:	89 c2                	mov    %eax,%edx
c0101011:	ec                   	in     (%dx),%al
c0101012:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101015:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010101b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101f:	89 c2                	mov    %eax,%edx
c0101021:	ec                   	in     (%dx),%al
c0101022:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101025:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010102a:	85 c0                	test   %eax,%eax
c010102c:	74 0c                	je     c010103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101035:	e8 4b 0f 00 00       	call   c0101f85 <pic_enable>
    }
}
c010103a:	c9                   	leave  
c010103b:	c3                   	ret    

c010103c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103c:	55                   	push   %ebp
c010103d:	89 e5                	mov    %esp,%ebp
c010103f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101049:	eb 09                	jmp    c0101054 <lpt_putc_sub+0x18>
        delay();
c010104b:	e8 db fd ff ff       	call   c0100e2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105e:	89 c2                	mov    %eax,%edx
c0101060:	ec                   	in     (%dx),%al
c0101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101068:	84 c0                	test   %al,%al
c010106a:	78 09                	js     c0101075 <lpt_putc_sub+0x39>
c010106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101073:	7e d6                	jle    c010104b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101075:	8b 45 08             	mov    0x8(%ebp),%eax
c0101078:	0f b6 c0             	movzbl %al,%eax
c010107b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101081:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101084:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101088:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108c:	ee                   	out    %al,(%dx)
c010108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
c01010a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b3:	c9                   	leave  
c01010b4:	c3                   	ret    

c01010b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b5:	55                   	push   %ebp
c01010b6:	89 e5                	mov    %esp,%ebp
c01010b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bf:	74 0d                	je     c01010ce <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c4:	89 04 24             	mov    %eax,(%esp)
c01010c7:	e8 70 ff ff ff       	call   c010103c <lpt_putc_sub>
c01010cc:	eb 24                	jmp    c01010f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d5:	e8 62 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e1:	e8 56 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ed:	e8 4a ff ff ff       	call   c010103c <lpt_putc_sub>
    }
}
c01010f2:	c9                   	leave  
c01010f3:	c3                   	ret    

c01010f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f4:	55                   	push   %ebp
c01010f5:	89 e5                	mov    %esp,%ebp
c01010f7:	53                   	push   %ebx
c01010f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fe:	b0 00                	mov    $0x0,%al
c0101100:	85 c0                	test   %eax,%eax
c0101102:	75 07                	jne    c010110b <cga_putc+0x17>
        c |= 0x0700;
c0101104:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010110b:	8b 45 08             	mov    0x8(%ebp),%eax
c010110e:	0f b6 c0             	movzbl %al,%eax
c0101111:	83 f8 0a             	cmp    $0xa,%eax
c0101114:	74 4c                	je     c0101162 <cga_putc+0x6e>
c0101116:	83 f8 0d             	cmp    $0xd,%eax
c0101119:	74 57                	je     c0101172 <cga_putc+0x7e>
c010111b:	83 f8 08             	cmp    $0x8,%eax
c010111e:	0f 85 88 00 00 00    	jne    c01011ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101124:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010112b:	66 85 c0             	test   %ax,%ax
c010112e:	74 30                	je     c0101160 <cga_putc+0x6c>
            crt_pos --;
c0101130:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101137:	83 e8 01             	sub    $0x1,%eax
c010113a:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101140:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101145:	0f b7 15 c4 0e 12 c0 	movzwl 0xc0120ec4,%edx
c010114c:	0f b7 d2             	movzwl %dx,%edx
c010114f:	01 d2                	add    %edx,%edx
c0101151:	01 c2                	add    %eax,%edx
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	b0 00                	mov    $0x0,%al
c0101158:	83 c8 20             	or     $0x20,%eax
c010115b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115e:	eb 72                	jmp    c01011d2 <cga_putc+0xde>
c0101160:	eb 70                	jmp    c01011d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101162:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101169:	83 c0 50             	add    $0x50,%eax
c010116c:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101172:	0f b7 1d c4 0e 12 c0 	movzwl 0xc0120ec4,%ebx
c0101179:	0f b7 0d c4 0e 12 c0 	movzwl 0xc0120ec4,%ecx
c0101180:	0f b7 c1             	movzwl %cx,%eax
c0101183:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101189:	c1 e8 10             	shr    $0x10,%eax
c010118c:	89 c2                	mov    %eax,%edx
c010118e:	66 c1 ea 06          	shr    $0x6,%dx
c0101192:	89 d0                	mov    %edx,%eax
c0101194:	c1 e0 02             	shl    $0x2,%eax
c0101197:	01 d0                	add    %edx,%eax
c0101199:	c1 e0 04             	shl    $0x4,%eax
c010119c:	29 c1                	sub    %eax,%ecx
c010119e:	89 ca                	mov    %ecx,%edx
c01011a0:	89 d8                	mov    %ebx,%eax
c01011a2:	29 d0                	sub    %edx,%eax
c01011a4:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c01011aa:	eb 26                	jmp    c01011d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ac:	8b 0d c0 0e 12 c0    	mov    0xc0120ec0,%ecx
c01011b2:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011b9:	8d 50 01             	lea    0x1(%eax),%edx
c01011bc:	66 89 15 c4 0e 12 c0 	mov    %dx,0xc0120ec4
c01011c3:	0f b7 c0             	movzwl %ax,%eax
c01011c6:	01 c0                	add    %eax,%eax
c01011c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ce:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d2:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011d9:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011dd:	76 5b                	jbe    c010123a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011df:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ea:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f6:	00 
c01011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fb:	89 04 24             	mov    %eax,(%esp)
c01011fe:	e8 78 7a 00 00       	call   c0108c7b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101203:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120a:	eb 15                	jmp    c0101221 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120c:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101211:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101214:	01 d2                	add    %edx,%edx
c0101216:	01 d0                	add    %edx,%eax
c0101218:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101221:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101228:	7e e2                	jle    c010120c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122a:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101231:	83 e8 50             	sub    $0x50,%eax
c0101234:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123a:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0101241:	0f b7 c0             	movzwl %ax,%eax
c0101244:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101248:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101250:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101254:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101255:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010125c:	66 c1 e8 08          	shr    $0x8,%ax
c0101260:	0f b6 c0             	movzbl %al,%eax
c0101263:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c010126a:	83 c2 01             	add    $0x1,%edx
c010126d:	0f b7 d2             	movzwl %dx,%edx
c0101270:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101274:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101277:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101280:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0101287:	0f b7 c0             	movzwl %ax,%eax
c010128a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101292:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101296:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129b:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01012a2:	0f b6 c0             	movzbl %al,%eax
c01012a5:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c01012ac:	83 c2 01             	add    $0x1,%edx
c01012af:	0f b7 d2             	movzwl %dx,%edx
c01012b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c1:	ee                   	out    %al,(%dx)
}
c01012c2:	83 c4 34             	add    $0x34,%esp
c01012c5:	5b                   	pop    %ebx
c01012c6:	5d                   	pop    %ebp
c01012c7:	c3                   	ret    

c01012c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c8:	55                   	push   %ebp
c01012c9:	89 e5                	mov    %esp,%ebp
c01012cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d5:	eb 09                	jmp    c01012e0 <serial_putc_sub+0x18>
        delay();
c01012d7:	e8 4f fb ff ff       	call   c0100e2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ea:	89 c2                	mov    %eax,%edx
c01012ec:	ec                   	in     (%dx),%al
c01012ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f4:	0f b6 c0             	movzbl %al,%eax
c01012f7:	83 e0 20             	and    $0x20,%eax
c01012fa:	85 c0                	test   %eax,%eax
c01012fc:	75 09                	jne    c0101307 <serial_putc_sub+0x3f>
c01012fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101305:	7e d0                	jle    c01012d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101307:	8b 45 08             	mov    0x8(%ebp),%eax
c010130a:	0f b6 c0             	movzbl %al,%eax
c010130d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101313:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101316:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131e:	ee                   	out    %al,(%dx)
}
c010131f:	c9                   	leave  
c0101320:	c3                   	ret    

c0101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101321:	55                   	push   %ebp
c0101322:	89 e5                	mov    %esp,%ebp
c0101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010132b:	74 0d                	je     c010133a <serial_putc+0x19>
        serial_putc_sub(c);
c010132d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101330:	89 04 24             	mov    %eax,(%esp)
c0101333:	e8 90 ff ff ff       	call   c01012c8 <serial_putc_sub>
c0101338:	eb 24                	jmp    c010135e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101341:	e8 82 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub(' ');
c0101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134d:	e8 76 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub('\b');
c0101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101359:	e8 6a ff ff ff       	call   c01012c8 <serial_putc_sub>
    }
}
c010135e:	c9                   	leave  
c010135f:	c3                   	ret    

c0101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101360:	55                   	push   %ebp
c0101361:	89 e5                	mov    %esp,%ebp
c0101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101366:	eb 33                	jmp    c010139b <cons_intr+0x3b>
        if (c != 0) {
c0101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136c:	74 2d                	je     c010139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136e:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101373:	8d 50 01             	lea    0x1(%eax),%edx
c0101376:	89 15 e4 10 12 c0    	mov    %edx,0xc01210e4
c010137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137f:	88 90 e0 0e 12 c0    	mov    %dl,-0x3fedf120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101385:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c010138a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138f:	75 0a                	jne    c010139b <cons_intr+0x3b>
                cons.wpos = 0;
c0101391:	c7 05 e4 10 12 c0 00 	movl   $0x0,0xc01210e4
c0101398:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010139b:	8b 45 08             	mov    0x8(%ebp),%eax
c010139e:	ff d0                	call   *%eax
c01013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a7:	75 bf                	jne    c0101368 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a9:	c9                   	leave  
c01013aa:	c3                   	ret    

c01013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ab:	55                   	push   %ebp
c01013ac:	89 e5                	mov    %esp,%ebp
c01013ae:	83 ec 10             	sub    $0x10,%esp
c01013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	83 e0 01             	and    $0x1,%eax
c01013cb:	85 c0                	test   %eax,%eax
c01013cd:	75 07                	jne    c01013d6 <serial_proc_data+0x2b>
        return -1;
c01013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d4:	eb 2a                	jmp    c0101400 <serial_proc_data+0x55>
c01013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e0:	89 c2                	mov    %eax,%edx
c01013e2:	ec                   	in     (%dx),%al
c01013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ea:	0f b6 c0             	movzbl %al,%eax
c01013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f4:	75 07                	jne    c01013fd <serial_proc_data+0x52>
        c = '\b';
c01013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101400:	c9                   	leave  
c0101401:	c3                   	ret    

c0101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101402:	55                   	push   %ebp
c0101403:	89 e5                	mov    %esp,%ebp
c0101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101408:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010140d:	85 c0                	test   %eax,%eax
c010140f:	74 0c                	je     c010141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101411:	c7 04 24 ab 13 10 c0 	movl   $0xc01013ab,(%esp)
c0101418:	e8 43 ff ff ff       	call   c0101360 <cons_intr>
    }
}
c010141d:	c9                   	leave  
c010141e:	c3                   	ret    

c010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 38             	sub    $0x38,%esp
c0101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2e>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 59 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101457:	89 c2                	mov    %eax,%edx
c0101459:	ec                   	in     (%dx),%al
c010145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101468:	75 17                	jne    c0101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146a:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010146f:	83 c8 40             	or     $0x40,%eax
c0101472:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c0101477:	b8 00 00 00 00       	mov    $0x0,%eax
c010147c:	e9 25 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	84 c0                	test   %al,%al
c0101487:	79 47                	jns    c01014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101489:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010148e:	83 e0 40             	and    $0x40,%eax
c0101491:	85 c0                	test   %eax,%eax
c0101493:	75 09                	jne    c010149e <kbd_proc_data+0x7f>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	83 e0 7f             	and    $0x7f,%eax
c010149c:	eb 04                	jmp    c01014a2 <kbd_proc_data+0x83>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014b0:	83 c8 40             	or     $0x40,%eax
c01014b3:	0f b6 c0             	movzbl %al,%eax
c01014b6:	f7 d0                	not    %eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014bf:	21 d0                	and    %edx,%eax
c01014c1:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c01014c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cb:	e9 d6 00 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d0:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014d5:	83 e0 40             	and    $0x40,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 11                	je     c01014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e0:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e8:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    }

    shift |= shiftcode[data];
c01014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f1:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014f8:	0f b6 d0             	movzbl %al,%edx
c01014fb:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101500:	09 d0                	or     %edx,%eax
c0101502:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    shift ^= togglecode[data];
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	0f b6 80 60 01 12 c0 	movzbl -0x3fedfea0(%eax),%eax
c0101512:	0f b6 d0             	movzbl %al,%edx
c0101515:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010151a:	31 d0                	xor    %edx,%eax
c010151c:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101521:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101526:	83 e0 03             	and    $0x3,%eax
c0101529:	8b 14 85 60 05 12 c0 	mov    -0x3fedfaa0(,%eax,4),%edx
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	01 d0                	add    %edx,%eax
c0101536:	0f b6 00             	movzbl (%eax),%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153f:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101544:	83 e0 08             	and    $0x8,%eax
c0101547:	85 c0                	test   %eax,%eax
c0101549:	74 22                	je     c010156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154f:	7e 0c                	jle    c010155d <kbd_proc_data+0x13e>
c0101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101555:	7f 06                	jg     c010155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155b:	eb 10                	jmp    c010156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101561:	7e 0a                	jle    c010156d <kbd_proc_data+0x14e>
c0101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101567:	7f 04                	jg     c010156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156d:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101572:	f7 d0                	not    %eax
c0101574:	83 e0 06             	and    $0x6,%eax
c0101577:	85 c0                	test   %eax,%eax
c0101579:	75 28                	jne    c01015a3 <kbd_proc_data+0x184>
c010157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101582:	75 1f                	jne    c01015a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101584:	c7 04 24 fd 90 10 c0 	movl   $0xc01090fd,(%esp)
c010158b:	e8 bb ed ff ff       	call   c010034b <cprintf>
c0101590:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101596:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a6:	c9                   	leave  
c01015a7:	c3                   	ret    

c01015a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a8:	55                   	push   %ebp
c01015a9:	89 e5                	mov    %esp,%ebp
c01015ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ae:	c7 04 24 1f 14 10 c0 	movl   $0xc010141f,(%esp)
c01015b5:	e8 a6 fd ff ff       	call   c0101360 <cons_intr>
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_init>:

static void
kbd_init(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c2:	e8 e1 ff ff ff       	call   c01015a8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ce:	e8 b2 09 00 00       	call   c0101f85 <pic_enable>
}
c01015d3:	c9                   	leave  
c01015d4:	c3                   	ret    

c01015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d5:	55                   	push   %ebp
c01015d6:	89 e5                	mov    %esp,%ebp
c01015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015db:	e8 93 f8 ff ff       	call   c0100e73 <cga_init>
    serial_init();
c01015e0:	e8 74 f9 ff ff       	call   c0100f59 <serial_init>
    kbd_init();
c01015e5:	e8 d2 ff ff ff       	call   c01015bc <kbd_init>
    if (!serial_exists) {
c01015ea:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c01015ef:	85 c0                	test   %eax,%eax
c01015f1:	75 0c                	jne    c01015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f3:	c7 04 24 09 91 10 c0 	movl   $0xc0109109,(%esp)
c01015fa:	e8 4c ed ff ff       	call   c010034b <cprintf>
    }
}
c01015ff:	c9                   	leave  
c0101600:	c3                   	ret    

c0101601 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101601:	55                   	push   %ebp
c0101602:	89 e5                	mov    %esp,%ebp
c0101604:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101607:	e8 e2 f7 ff ff       	call   c0100dee <__intr_save>
c010160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101612:	89 04 24             	mov    %eax,(%esp)
c0101615:	e8 9b fa ff ff       	call   c01010b5 <lpt_putc>
        cga_putc(c);
c010161a:	8b 45 08             	mov    0x8(%ebp),%eax
c010161d:	89 04 24             	mov    %eax,(%esp)
c0101620:	e8 cf fa ff ff       	call   c01010f4 <cga_putc>
        serial_putc(c);
c0101625:	8b 45 08             	mov    0x8(%ebp),%eax
c0101628:	89 04 24             	mov    %eax,(%esp)
c010162b:	e8 f1 fc ff ff       	call   c0101321 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101633:	89 04 24             	mov    %eax,(%esp)
c0101636:	e8 dd f7 ff ff       	call   c0100e18 <__intr_restore>
}
c010163b:	c9                   	leave  
c010163c:	c3                   	ret    

c010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163d:	55                   	push   %ebp
c010163e:	89 e5                	mov    %esp,%ebp
c0101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164a:	e8 9f f7 ff ff       	call   c0100dee <__intr_save>
c010164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101652:	e8 ab fd ff ff       	call   c0101402 <serial_intr>
        kbd_intr();
c0101657:	e8 4c ff ff ff       	call   c01015a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165c:	8b 15 e0 10 12 c0    	mov    0xc01210e0,%edx
c0101662:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101667:	39 c2                	cmp    %eax,%edx
c0101669:	74 31                	je     c010169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166b:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101670:	8d 50 01             	lea    0x1(%eax),%edx
c0101673:	89 15 e0 10 12 c0    	mov    %edx,0xc01210e0
c0101679:	0f b6 80 e0 0e 12 c0 	movzbl -0x3fedf120(%eax),%eax
c0101680:	0f b6 c0             	movzbl %al,%eax
c0101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101686:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c010168b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101690:	75 0a                	jne    c010169c <cons_getc+0x5f>
                cons.rpos = 0;
c0101692:	c7 05 e0 10 12 c0 00 	movl   $0x0,0xc01210e0
c0101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169f:	89 04 24             	mov    %eax,(%esp)
c01016a2:	e8 71 f7 ff ff       	call   c0100e18 <__intr_restore>
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
c01016af:	83 ec 14             	sub    $0x14,%esp
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016b9:	90                   	nop
c01016ba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016be:	83 c0 07             	add    $0x7,%eax
c01016c1:	0f b7 c0             	movzwl %ax,%eax
c01016c4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016c8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016cc:	89 c2                	mov    %eax,%edx
c01016ce:	ec                   	in     (%dx),%al
c01016cf:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016d2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016d6:	0f b6 c0             	movzbl %al,%eax
c01016d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016df:	25 80 00 00 00       	and    $0x80,%eax
c01016e4:	85 c0                	test   %eax,%eax
c01016e6:	75 d2                	jne    c01016ba <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016ec:	74 11                	je     c01016ff <ide_wait_ready+0x53>
c01016ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f1:	83 e0 21             	and    $0x21,%eax
c01016f4:	85 c0                	test   %eax,%eax
c01016f6:	74 07                	je     c01016ff <ide_wait_ready+0x53>
        return -1;
c01016f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01016fd:	eb 05                	jmp    c0101704 <ide_wait_ready+0x58>
    }
    return 0;
c01016ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101704:	c9                   	leave  
c0101705:	c3                   	ret    

c0101706 <ide_init>:

void
ide_init(void) {
c0101706:	55                   	push   %ebp
c0101707:	89 e5                	mov    %esp,%ebp
c0101709:	57                   	push   %edi
c010170a:	53                   	push   %ebx
c010170b:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101711:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101717:	e9 d6 02 00 00       	jmp    c01019f2 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010171c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101720:	c1 e0 03             	shl    $0x3,%eax
c0101723:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010172a:	29 c2                	sub    %eax,%edx
c010172c:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101732:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101735:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101739:	66 d1 e8             	shr    %ax
c010173c:	0f b7 c0             	movzwl %ax,%eax
c010173f:	0f b7 04 85 28 91 10 	movzwl -0x3fef6ed8(,%eax,4),%eax
c0101746:	c0 
c0101747:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c010174b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010174f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101756:	00 
c0101757:	89 04 24             	mov    %eax,(%esp)
c010175a:	e8 4d ff ff ff       	call   c01016ac <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010175f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101763:	83 e0 01             	and    $0x1,%eax
c0101766:	c1 e0 04             	shl    $0x4,%eax
c0101769:	83 c8 e0             	or     $0xffffffe0,%eax
c010176c:	0f b6 c0             	movzbl %al,%eax
c010176f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101773:	83 c2 06             	add    $0x6,%edx
c0101776:	0f b7 d2             	movzwl %dx,%edx
c0101779:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010177d:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101780:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101784:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101789:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010178d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101794:	00 
c0101795:	89 04 24             	mov    %eax,(%esp)
c0101798:	e8 0f ff ff ff       	call   c01016ac <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c010179d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a1:	83 c0 07             	add    $0x7,%eax
c01017a4:	0f b7 c0             	movzwl %ax,%eax
c01017a7:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017ab:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017af:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017b3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017b7:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017b8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017c3:	00 
c01017c4:	89 04 24             	mov    %eax,(%esp)
c01017c7:	e8 e0 fe ff ff       	call   c01016ac <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017cc:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d0:	83 c0 07             	add    $0x7,%eax
c01017d3:	0f b7 c0             	movzwl %ax,%eax
c01017d6:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017da:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017de:	89 c2                	mov    %eax,%edx
c01017e0:	ec                   	in     (%dx),%al
c01017e1:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017e4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017e8:	84 c0                	test   %al,%al
c01017ea:	0f 84 f7 01 00 00    	je     c01019e7 <ide_init+0x2e1>
c01017f0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01017fb:	00 
c01017fc:	89 04 24             	mov    %eax,(%esp)
c01017ff:	e8 a8 fe ff ff       	call   c01016ac <ide_wait_ready>
c0101804:	85 c0                	test   %eax,%eax
c0101806:	0f 85 db 01 00 00    	jne    c01019e7 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010180c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101810:	c1 e0 03             	shl    $0x3,%eax
c0101813:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010181a:	29 c2                	sub    %eax,%edx
c010181c:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101822:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101825:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101829:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010182c:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101832:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101835:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010183c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010183f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101842:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101845:	89 cb                	mov    %ecx,%ebx
c0101847:	89 df                	mov    %ebx,%edi
c0101849:	89 c1                	mov    %eax,%ecx
c010184b:	fc                   	cld    
c010184c:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010184e:	89 c8                	mov    %ecx,%eax
c0101850:	89 fb                	mov    %edi,%ebx
c0101852:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101855:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101858:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010185e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101864:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010186a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010186d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101870:	25 00 00 00 04       	and    $0x4000000,%eax
c0101875:	85 c0                	test   %eax,%eax
c0101877:	74 0e                	je     c0101887 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010187c:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101882:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101885:	eb 09                	jmp    c0101890 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188a:	8b 40 78             	mov    0x78(%eax),%eax
c010188d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101890:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101894:	c1 e0 03             	shl    $0x3,%eax
c0101897:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010189e:	29 c2                	sub    %eax,%edx
c01018a0:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018a9:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018ac:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b0:	c1 e0 03             	shl    $0x3,%eax
c01018b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ba:	29 c2                	sub    %eax,%edx
c01018bc:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018c5:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018cb:	83 c0 62             	add    $0x62,%eax
c01018ce:	0f b7 00             	movzwl (%eax),%eax
c01018d1:	0f b7 c0             	movzwl %ax,%eax
c01018d4:	25 00 02 00 00       	and    $0x200,%eax
c01018d9:	85 c0                	test   %eax,%eax
c01018db:	75 24                	jne    c0101901 <ide_init+0x1fb>
c01018dd:	c7 44 24 0c 30 91 10 	movl   $0xc0109130,0xc(%esp)
c01018e4:	c0 
c01018e5:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c01018ec:	c0 
c01018ed:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018f4:	00 
c01018f5:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c01018fc:	e8 ce f3 ff ff       	call   c0100ccf <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101901:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101905:	c1 e0 03             	shl    $0x3,%eax
c0101908:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010190f:	29 c2                	sub    %eax,%edx
c0101911:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101917:	83 c0 0c             	add    $0xc,%eax
c010191a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010191d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101920:	83 c0 36             	add    $0x36,%eax
c0101923:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101926:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010192d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101934:	eb 34                	jmp    c010196a <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101936:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101939:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010193c:	01 c2                	add    %eax,%edx
c010193e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101941:	8d 48 01             	lea    0x1(%eax),%ecx
c0101944:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101947:	01 c8                	add    %ecx,%eax
c0101949:	0f b6 00             	movzbl (%eax),%eax
c010194c:	88 02                	mov    %al,(%edx)
c010194e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101951:	8d 50 01             	lea    0x1(%eax),%edx
c0101954:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101957:	01 c2                	add    %eax,%edx
c0101959:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010195f:	01 c8                	add    %ecx,%eax
c0101961:	0f b6 00             	movzbl (%eax),%eax
c0101964:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101966:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010196a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101970:	72 c4                	jb     c0101936 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101975:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101978:	01 d0                	add    %edx,%eax
c010197a:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101980:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101983:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101986:	85 c0                	test   %eax,%eax
c0101988:	74 0f                	je     c0101999 <ide_init+0x293>
c010198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101990:	01 d0                	add    %edx,%eax
c0101992:	0f b6 00             	movzbl (%eax),%eax
c0101995:	3c 20                	cmp    $0x20,%al
c0101997:	74 d9                	je     c0101972 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101999:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199d:	c1 e0 03             	shl    $0x3,%eax
c01019a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a7:	29 c2                	sub    %eax,%edx
c01019a9:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019af:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b6:	c1 e0 03             	shl    $0x3,%eax
c01019b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c0:	29 c2                	sub    %eax,%edx
c01019c2:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019c8:	8b 50 08             	mov    0x8(%eax),%edx
c01019cb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019d3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019db:	c7 04 24 9a 91 10 c0 	movl   $0xc010919a,(%esp)
c01019e2:	e8 64 e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019e7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019eb:	83 c0 01             	add    $0x1,%eax
c01019ee:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019f2:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019f7:	0f 86 1f fd ff ff    	jbe    c010171c <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01019fd:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a04:	e8 7c 05 00 00       	call   c0101f85 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a09:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a10:	e8 70 05 00 00       	call   c0101f85 <pic_enable>
}
c0101a15:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a1b:	5b                   	pop    %ebx
c0101a1c:	5f                   	pop    %edi
c0101a1d:	5d                   	pop    %ebp
c0101a1e:	c3                   	ret    

c0101a1f <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a1f:	55                   	push   %ebp
c0101a20:	89 e5                	mov    %esp,%ebp
c0101a22:	83 ec 04             	sub    $0x4,%esp
c0101a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a28:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a2c:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a31:	77 24                	ja     c0101a57 <ide_device_valid+0x38>
c0101a33:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a37:	c1 e0 03             	shl    $0x3,%eax
c0101a3a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a41:	29 c2                	sub    %eax,%edx
c0101a43:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a49:	0f b6 00             	movzbl (%eax),%eax
c0101a4c:	84 c0                	test   %al,%al
c0101a4e:	74 07                	je     c0101a57 <ide_device_valid+0x38>
c0101a50:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a55:	eb 05                	jmp    c0101a5c <ide_device_valid+0x3d>
c0101a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a5c:	c9                   	leave  
c0101a5d:	c3                   	ret    

c0101a5e <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a5e:	55                   	push   %ebp
c0101a5f:	89 e5                	mov    %esp,%ebp
c0101a61:	83 ec 08             	sub    $0x8,%esp
c0101a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a67:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a6b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a6f:	89 04 24             	mov    %eax,(%esp)
c0101a72:	e8 a8 ff ff ff       	call   c0101a1f <ide_device_valid>
c0101a77:	85 c0                	test   %eax,%eax
c0101a79:	74 1b                	je     c0101a96 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a7b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7f:	c1 e0 03             	shl    $0x3,%eax
c0101a82:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a89:	29 c2                	sub    %eax,%edx
c0101a8b:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a91:	8b 40 08             	mov    0x8(%eax),%eax
c0101a94:	eb 05                	jmp    c0101a9b <ide_device_size+0x3d>
    }
    return 0;
c0101a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a9b:	c9                   	leave  
c0101a9c:	c3                   	ret    

c0101a9d <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101a9d:	55                   	push   %ebp
c0101a9e:	89 e5                	mov    %esp,%ebp
c0101aa0:	57                   	push   %edi
c0101aa1:	53                   	push   %ebx
c0101aa2:	83 ec 50             	sub    $0x50,%esp
c0101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101aac:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ab3:	77 24                	ja     c0101ad9 <ide_read_secs+0x3c>
c0101ab5:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101aba:	77 1d                	ja     c0101ad9 <ide_read_secs+0x3c>
c0101abc:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac0:	c1 e0 03             	shl    $0x3,%eax
c0101ac3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aca:	29 c2                	sub    %eax,%edx
c0101acc:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101ad2:	0f b6 00             	movzbl (%eax),%eax
c0101ad5:	84 c0                	test   %al,%al
c0101ad7:	75 24                	jne    c0101afd <ide_read_secs+0x60>
c0101ad9:	c7 44 24 0c b8 91 10 	movl   $0xc01091b8,0xc(%esp)
c0101ae0:	c0 
c0101ae1:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0101ae8:	c0 
c0101ae9:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af0:	00 
c0101af1:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0101af8:	e8 d2 f1 ff ff       	call   c0100ccf <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101afd:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b04:	77 0f                	ja     c0101b15 <ide_read_secs+0x78>
c0101b06:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b09:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b0c:	01 d0                	add    %edx,%eax
c0101b0e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b13:	76 24                	jbe    c0101b39 <ide_read_secs+0x9c>
c0101b15:	c7 44 24 0c e0 91 10 	movl   $0xc01091e0,0xc(%esp)
c0101b1c:	c0 
c0101b1d:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0101b24:	c0 
c0101b25:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b2c:	00 
c0101b2d:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0101b34:	e8 96 f1 ff ff       	call   c0100ccf <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b39:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b3d:	66 d1 e8             	shr    %ax
c0101b40:	0f b7 c0             	movzwl %ax,%eax
c0101b43:	0f b7 04 85 28 91 10 	movzwl -0x3fef6ed8(,%eax,4),%eax
c0101b4a:	c0 
c0101b4b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b4f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b53:	66 d1 e8             	shr    %ax
c0101b56:	0f b7 c0             	movzwl %ax,%eax
c0101b59:	0f b7 04 85 2a 91 10 	movzwl -0x3fef6ed6(,%eax,4),%eax
c0101b60:	c0 
c0101b61:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b69:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b70:	00 
c0101b71:	89 04 24             	mov    %eax,(%esp)
c0101b74:	e8 33 fb ff ff       	call   c01016ac <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b79:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b7d:	83 c0 02             	add    $0x2,%eax
c0101b80:	0f b7 c0             	movzwl %ax,%eax
c0101b83:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b87:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b93:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b94:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b97:	0f b6 c0             	movzbl %al,%eax
c0101b9a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b9e:	83 c2 02             	add    $0x2,%edx
c0101ba1:	0f b7 d2             	movzwl %dx,%edx
c0101ba4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ba8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101baf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bb3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bb7:	0f b6 c0             	movzbl %al,%eax
c0101bba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bbe:	83 c2 03             	add    $0x3,%edx
c0101bc1:	0f b7 d2             	movzwl %dx,%edx
c0101bc4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bc8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bcb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bcf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bd3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bd7:	c1 e8 08             	shr    $0x8,%eax
c0101bda:	0f b6 c0             	movzbl %al,%eax
c0101bdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be1:	83 c2 04             	add    $0x4,%edx
c0101be4:	0f b7 d2             	movzwl %dx,%edx
c0101be7:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101beb:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bee:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bf2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bf6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bfa:	c1 e8 10             	shr    $0x10,%eax
c0101bfd:	0f b6 c0             	movzbl %al,%eax
c0101c00:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c04:	83 c2 05             	add    $0x5,%edx
c0101c07:	0f b7 d2             	movzwl %dx,%edx
c0101c0a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c0e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c11:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c15:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c19:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c1a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c1e:	83 e0 01             	and    $0x1,%eax
c0101c21:	c1 e0 04             	shl    $0x4,%eax
c0101c24:	89 c2                	mov    %eax,%edx
c0101c26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c29:	c1 e8 18             	shr    $0x18,%eax
c0101c2c:	83 e0 0f             	and    $0xf,%eax
c0101c2f:	09 d0                	or     %edx,%eax
c0101c31:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c34:	0f b6 c0             	movzbl %al,%eax
c0101c37:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c3b:	83 c2 06             	add    $0x6,%edx
c0101c3e:	0f b7 d2             	movzwl %dx,%edx
c0101c41:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c45:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c48:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c4c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c50:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c51:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c55:	83 c0 07             	add    $0x7,%eax
c0101c58:	0f b7 c0             	movzwl %ax,%eax
c0101c5b:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c5f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c63:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c67:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c6b:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c73:	eb 5a                	jmp    c0101ccf <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c80:	00 
c0101c81:	89 04 24             	mov    %eax,(%esp)
c0101c84:	e8 23 fa ff ff       	call   c01016ac <ide_wait_ready>
c0101c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c90:	74 02                	je     c0101c94 <ide_read_secs+0x1f7>
            goto out;
c0101c92:	eb 41                	jmp    c0101cd5 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c94:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c98:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101c9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0101c9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101ca8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cab:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cae:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb1:	89 cb                	mov    %ecx,%ebx
c0101cb3:	89 df                	mov    %ebx,%edi
c0101cb5:	89 c1                	mov    %eax,%ecx
c0101cb7:	fc                   	cld    
c0101cb8:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cba:	89 c8                	mov    %ecx,%eax
c0101cbc:	89 fb                	mov    %edi,%ebx
c0101cbe:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cc4:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cc8:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101ccf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cd3:	75 a0                	jne    c0101c75 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cd8:	83 c4 50             	add    $0x50,%esp
c0101cdb:	5b                   	pop    %ebx
c0101cdc:	5f                   	pop    %edi
c0101cdd:	5d                   	pop    %ebp
c0101cde:	c3                   	ret    

c0101cdf <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101cdf:	55                   	push   %ebp
c0101ce0:	89 e5                	mov    %esp,%ebp
c0101ce2:	56                   	push   %esi
c0101ce3:	53                   	push   %ebx
c0101ce4:	83 ec 50             	sub    $0x50,%esp
c0101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cea:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cee:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cf5:	77 24                	ja     c0101d1b <ide_write_secs+0x3c>
c0101cf7:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101cfc:	77 1d                	ja     c0101d1b <ide_write_secs+0x3c>
c0101cfe:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d02:	c1 e0 03             	shl    $0x3,%eax
c0101d05:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d0c:	29 c2                	sub    %eax,%edx
c0101d0e:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101d14:	0f b6 00             	movzbl (%eax),%eax
c0101d17:	84 c0                	test   %al,%al
c0101d19:	75 24                	jne    c0101d3f <ide_write_secs+0x60>
c0101d1b:	c7 44 24 0c b8 91 10 	movl   $0xc01091b8,0xc(%esp)
c0101d22:	c0 
c0101d23:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0101d2a:	c0 
c0101d2b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d32:	00 
c0101d33:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0101d3a:	e8 90 ef ff ff       	call   c0100ccf <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d3f:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d46:	77 0f                	ja     c0101d57 <ide_write_secs+0x78>
c0101d48:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d4e:	01 d0                	add    %edx,%eax
c0101d50:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d55:	76 24                	jbe    c0101d7b <ide_write_secs+0x9c>
c0101d57:	c7 44 24 0c e0 91 10 	movl   $0xc01091e0,0xc(%esp)
c0101d5e:	c0 
c0101d5f:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0101d66:	c0 
c0101d67:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d6e:	00 
c0101d6f:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0101d76:	e8 54 ef ff ff       	call   c0100ccf <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d7b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d7f:	66 d1 e8             	shr    %ax
c0101d82:	0f b7 c0             	movzwl %ax,%eax
c0101d85:	0f b7 04 85 28 91 10 	movzwl -0x3fef6ed8(,%eax,4),%eax
c0101d8c:	c0 
c0101d8d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d91:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d95:	66 d1 e8             	shr    %ax
c0101d98:	0f b7 c0             	movzwl %ax,%eax
c0101d9b:	0f b7 04 85 2a 91 10 	movzwl -0x3fef6ed6(,%eax,4),%eax
c0101da2:	c0 
c0101da3:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101da7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101dab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101db2:	00 
c0101db3:	89 04 24             	mov    %eax,(%esp)
c0101db6:	e8 f1 f8 ff ff       	call   c01016ac <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dbb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dbf:	83 c0 02             	add    $0x2,%eax
c0101dc2:	0f b7 c0             	movzwl %ax,%eax
c0101dc5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dc9:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dcd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101dd5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101dd6:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dd9:	0f b6 c0             	movzbl %al,%eax
c0101ddc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de0:	83 c2 02             	add    $0x2,%edx
c0101de3:	0f b7 d2             	movzwl %dx,%edx
c0101de6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101dea:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ded:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101df5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101df9:	0f b6 c0             	movzbl %al,%eax
c0101dfc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e00:	83 c2 03             	add    $0x3,%edx
c0101e03:	0f b7 d2             	movzwl %dx,%edx
c0101e06:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e0a:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e0d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e11:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e15:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e19:	c1 e8 08             	shr    $0x8,%eax
c0101e1c:	0f b6 c0             	movzbl %al,%eax
c0101e1f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e23:	83 c2 04             	add    $0x4,%edx
c0101e26:	0f b7 d2             	movzwl %dx,%edx
c0101e29:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e2d:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e30:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e34:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e38:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e3c:	c1 e8 10             	shr    $0x10,%eax
c0101e3f:	0f b6 c0             	movzbl %al,%eax
c0101e42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e46:	83 c2 05             	add    $0x5,%edx
c0101e49:	0f b7 d2             	movzwl %dx,%edx
c0101e4c:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e50:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e53:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e57:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e5b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e60:	83 e0 01             	and    $0x1,%eax
c0101e63:	c1 e0 04             	shl    $0x4,%eax
c0101e66:	89 c2                	mov    %eax,%edx
c0101e68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e6b:	c1 e8 18             	shr    $0x18,%eax
c0101e6e:	83 e0 0f             	and    $0xf,%eax
c0101e71:	09 d0                	or     %edx,%eax
c0101e73:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e76:	0f b6 c0             	movzbl %al,%eax
c0101e79:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e7d:	83 c2 06             	add    $0x6,%edx
c0101e80:	0f b7 d2             	movzwl %dx,%edx
c0101e83:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e87:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e8a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e8e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e92:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e93:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e97:	83 c0 07             	add    $0x7,%eax
c0101e9a:	0f b7 c0             	movzwl %ax,%eax
c0101e9d:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea1:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ea5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101ea9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ead:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101eb5:	eb 5a                	jmp    c0101f11 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101eb7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ebb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ec2:	00 
c0101ec3:	89 04 24             	mov    %eax,(%esp)
c0101ec6:	e8 e1 f7 ff ff       	call   c01016ac <ide_wait_ready>
c0101ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ed2:	74 02                	je     c0101ed6 <ide_write_secs+0x1f7>
            goto out;
c0101ed4:	eb 41                	jmp    c0101f17 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ed6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eda:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101edd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee0:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ee3:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101eea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101eed:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ef3:	89 cb                	mov    %ecx,%ebx
c0101ef5:	89 de                	mov    %ebx,%esi
c0101ef7:	89 c1                	mov    %eax,%ecx
c0101ef9:	fc                   	cld    
c0101efa:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101efc:	89 c8                	mov    %ecx,%eax
c0101efe:	89 f3                	mov    %esi,%ebx
c0101f00:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f03:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f06:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f0a:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f11:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f15:	75 a0                	jne    c0101eb7 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f1a:	83 c4 50             	add    $0x50,%esp
c0101f1d:	5b                   	pop    %ebx
c0101f1e:	5e                   	pop    %esi
c0101f1f:	5d                   	pop    %ebp
c0101f20:	c3                   	ret    

c0101f21 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f21:	55                   	push   %ebp
c0101f22:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f24:	fb                   	sti    
    sti();
}
c0101f25:	5d                   	pop    %ebp
c0101f26:	c3                   	ret    

c0101f27 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f27:	55                   	push   %ebp
c0101f28:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f2a:	fa                   	cli    
    cli();
}
c0101f2b:	5d                   	pop    %ebp
c0101f2c:	c3                   	ret    

c0101f2d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f2d:	55                   	push   %ebp
c0101f2e:	89 e5                	mov    %esp,%ebp
c0101f30:	83 ec 14             	sub    $0x14,%esp
c0101f33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f36:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f3a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f3e:	66 a3 70 05 12 c0    	mov    %ax,0xc0120570
    if (did_init) {
c0101f44:	a1 e0 11 12 c0       	mov    0xc01211e0,%eax
c0101f49:	85 c0                	test   %eax,%eax
c0101f4b:	74 36                	je     c0101f83 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f4d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f51:	0f b6 c0             	movzbl %al,%eax
c0101f54:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f5a:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f5d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f61:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f65:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f66:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f6a:	66 c1 e8 08          	shr    $0x8,%ax
c0101f6e:	0f b6 c0             	movzbl %al,%eax
c0101f71:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f77:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f7a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f7e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f82:	ee                   	out    %al,(%dx)
    }
}
c0101f83:	c9                   	leave  
c0101f84:	c3                   	ret    

c0101f85 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f85:	55                   	push   %ebp
c0101f86:	89 e5                	mov    %esp,%ebp
c0101f88:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f93:	89 c1                	mov    %eax,%ecx
c0101f95:	d3 e2                	shl    %cl,%edx
c0101f97:	89 d0                	mov    %edx,%eax
c0101f99:	f7 d0                	not    %eax
c0101f9b:	89 c2                	mov    %eax,%edx
c0101f9d:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0101fa4:	21 d0                	and    %edx,%eax
c0101fa6:	0f b7 c0             	movzwl %ax,%eax
c0101fa9:	89 04 24             	mov    %eax,(%esp)
c0101fac:	e8 7c ff ff ff       	call   c0101f2d <pic_setmask>
}
c0101fb1:	c9                   	leave  
c0101fb2:	c3                   	ret    

c0101fb3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fb3:	55                   	push   %ebp
c0101fb4:	89 e5                	mov    %esp,%ebp
c0101fb6:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fb9:	c7 05 e0 11 12 c0 01 	movl   $0x1,0xc01211e0
c0101fc0:	00 00 00 
c0101fc3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fc9:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fcd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fd5:	ee                   	out    %al,(%dx)
c0101fd6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fdc:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fe4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fe8:	ee                   	out    %al,(%dx)
c0101fe9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101fef:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ff3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ff7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101ffb:	ee                   	out    %al,(%dx)
c0101ffc:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102002:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102006:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010200a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010200e:	ee                   	out    %al,(%dx)
c010200f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102015:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102019:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010201d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102021:	ee                   	out    %al,(%dx)
c0102022:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102028:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010202c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102030:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102034:	ee                   	out    %al,(%dx)
c0102035:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010203b:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010203f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102043:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102047:	ee                   	out    %al,(%dx)
c0102048:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010204e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102052:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102056:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010205a:	ee                   	out    %al,(%dx)
c010205b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102061:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102065:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102069:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010206d:	ee                   	out    %al,(%dx)
c010206e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102074:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102078:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010207c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102080:	ee                   	out    %al,(%dx)
c0102081:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102087:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010208b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010208f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102093:	ee                   	out    %al,(%dx)
c0102094:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010209a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010209e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020a2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020a6:	ee                   	out    %al,(%dx)
c01020a7:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020ad:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020b5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020b9:	ee                   	out    %al,(%dx)
c01020ba:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c0:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020c4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020c8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020cc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020cd:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020d4:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020d8:	74 12                	je     c01020ec <pic_init+0x139>
        pic_setmask(irq_mask);
c01020da:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020e1:	0f b7 c0             	movzwl %ax,%eax
c01020e4:	89 04 24             	mov    %eax,(%esp)
c01020e7:	e8 41 fe ff ff       	call   c0101f2d <pic_setmask>
    }
}
c01020ec:	c9                   	leave  
c01020ed:	c3                   	ret    

c01020ee <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020ee:	55                   	push   %ebp
c01020ef:	89 e5                	mov    %esp,%ebp
c01020f1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020f4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01020fb:	00 
c01020fc:	c7 04 24 20 92 10 c0 	movl   $0xc0109220,(%esp)
c0102103:	e8 43 e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102108:	c7 04 24 2a 92 10 c0 	movl   $0xc010922a,(%esp)
c010210f:	e8 37 e2 ff ff       	call   c010034b <cprintf>
    panic("EOT: kernel seems ok.");
c0102114:	c7 44 24 08 38 92 10 	movl   $0xc0109238,0x8(%esp)
c010211b:	c0 
c010211c:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102123:	00 
c0102124:	c7 04 24 4e 92 10 c0 	movl   $0xc010924e,(%esp)
c010212b:	e8 9f eb ff ff       	call   c0100ccf <__panic>

c0102130 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102130:	55                   	push   %ebp
c0102131:	89 e5                	mov    %esp,%ebp
c0102133:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c0102136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010213d:	e9 5c 02 00 00       	jmp    c010239e <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
c0102142:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c0102149:	0f 85 c1 00 00 00    	jne    c0102210 <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
c010214f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102152:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c0102159:	89 c2                	mov    %eax,%edx
c010215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215e:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c0102165:	c0 
c0102166:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102169:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c0102170:	c0 08 00 
c0102173:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102176:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010217d:	c0 
c010217e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102181:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102192:	c0 
c0102193:	83 e2 1f             	and    $0x1f,%edx
c0102196:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 ca 0f             	or     $0xf,%edx
c01021ab:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b5:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021bc:	c0 
c01021bd:	83 e2 ef             	and    $0xffffffef,%edx
c01021c0:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ca:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021d1:	c0 
c01021d2:	83 ca 60             	or     $0x60,%edx
c01021d5:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021df:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021e6:	c0 
c01021e7:	83 ca 80             	or     $0xffffff80,%edx
c01021ea:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f4:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01021fb:	c1 e8 10             	shr    $0x10,%eax
c01021fe:	89 c2                	mov    %eax,%edx
c0102200:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102203:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c010220a:	c0 
c010220b:	e9 8a 01 00 00       	jmp    c010239a <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
c0102210:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c0102214:	0f 8f c1 00 00 00    	jg     c01022db <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010221a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010221d:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c0102224:	89 c2                	mov    %eax,%edx
c0102226:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102229:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c0102230:	c0 
c0102231:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102234:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c010223b:	c0 08 00 
c010223e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102241:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102248:	c0 
c0102249:	83 e2 e0             	and    $0xffffffe0,%edx
c010224c:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102253:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102256:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010225d:	c0 
c010225e:	83 e2 1f             	and    $0x1f,%edx
c0102261:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102268:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226b:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102272:	c0 
c0102273:	83 ca 0f             	or     $0xf,%edx
c0102276:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c010227d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102280:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102287:	c0 
c0102288:	83 e2 ef             	and    $0xffffffef,%edx
c010228b:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102292:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102295:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c010229c:	c0 
c010229d:	83 e2 9f             	and    $0xffffff9f,%edx
c01022a0:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01022a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022aa:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01022b1:	c0 
c01022b2:	83 ca 80             	or     $0xffffff80,%edx
c01022b5:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01022bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022bf:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01022c6:	c1 e8 10             	shr    $0x10,%eax
c01022c9:	89 c2                	mov    %eax,%edx
c01022cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ce:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c01022d5:	c0 
c01022d6:	e9 bf 00 00 00       	jmp    c010239a <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01022db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022de:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01022e5:	89 c2                	mov    %eax,%edx
c01022e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ea:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c01022f1:	c0 
c01022f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f5:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c01022fc:	c0 08 00 
c01022ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102302:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102309:	c0 
c010230a:	83 e2 e0             	and    $0xffffffe0,%edx
c010230d:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102314:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102317:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010231e:	c0 
c010231f:	83 e2 1f             	and    $0x1f,%edx
c0102322:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102329:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010232c:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102333:	c0 
c0102334:	83 e2 f0             	and    $0xfffffff0,%edx
c0102337:	83 ca 0e             	or     $0xe,%edx
c010233a:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102341:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102344:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c010234b:	c0 
c010234c:	83 e2 ef             	and    $0xffffffef,%edx
c010234f:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102356:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102359:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102360:	c0 
c0102361:	83 e2 9f             	and    $0xffffff9f,%edx
c0102364:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c010236b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010236e:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102375:	c0 
c0102376:	83 ca 80             	or     $0xffffff80,%edx
c0102379:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102380:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102383:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c010238a:	c1 e8 10             	shr    $0x10,%eax
c010238d:	89 c2                	mov    %eax,%edx
c010238f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102392:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c0102399:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c010239a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010239e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023a1:	3d ff 00 00 00       	cmp    $0xff,%eax
c01023a6:	0f 86 96 fd ff ff    	jbe    c0102142 <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01023ac:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c01023b1:	66 a3 c8 15 12 c0    	mov    %ax,0xc01215c8
c01023b7:	66 c7 05 ca 15 12 c0 	movw   $0x8,0xc01215ca
c01023be:	08 00 
c01023c0:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c01023c7:	83 e0 e0             	and    $0xffffffe0,%eax
c01023ca:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c01023cf:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c01023d6:	83 e0 1f             	and    $0x1f,%eax
c01023d9:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c01023de:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c01023e5:	83 e0 f0             	and    $0xfffffff0,%eax
c01023e8:	83 c8 0e             	or     $0xe,%eax
c01023eb:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c01023f0:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c01023f7:	83 e0 ef             	and    $0xffffffef,%eax
c01023fa:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c01023ff:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102406:	83 c8 60             	or     $0x60,%eax
c0102409:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010240e:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102415:	83 c8 80             	or     $0xffffff80,%eax
c0102418:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010241d:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c0102422:	c1 e8 10             	shr    $0x10,%eax
c0102425:	66 a3 ce 15 12 c0    	mov    %ax,0xc01215ce
c010242b:	c7 45 f8 80 05 12 c0 	movl   $0xc0120580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102432:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102435:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0102438:	c9                   	leave  
c0102439:	c3                   	ret    

c010243a <trapname>:

static const char *
trapname(int trapno) {
c010243a:	55                   	push   %ebp
c010243b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010243d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102440:	83 f8 13             	cmp    $0x13,%eax
c0102443:	77 0c                	ja     c0102451 <trapname+0x17>
        return excnames[trapno];
c0102445:	8b 45 08             	mov    0x8(%ebp),%eax
c0102448:	8b 04 85 20 96 10 c0 	mov    -0x3fef69e0(,%eax,4),%eax
c010244f:	eb 18                	jmp    c0102469 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102451:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102455:	7e 0d                	jle    c0102464 <trapname+0x2a>
c0102457:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010245b:	7f 07                	jg     c0102464 <trapname+0x2a>
        return "Hardware Interrupt";
c010245d:	b8 5f 92 10 c0       	mov    $0xc010925f,%eax
c0102462:	eb 05                	jmp    c0102469 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102464:	b8 72 92 10 c0       	mov    $0xc0109272,%eax
}
c0102469:	5d                   	pop    %ebp
c010246a:	c3                   	ret    

c010246b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010246b:	55                   	push   %ebp
c010246c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010246e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102471:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102475:	66 83 f8 08          	cmp    $0x8,%ax
c0102479:	0f 94 c0             	sete   %al
c010247c:	0f b6 c0             	movzbl %al,%eax
}
c010247f:	5d                   	pop    %ebp
c0102480:	c3                   	ret    

c0102481 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102481:	55                   	push   %ebp
c0102482:	89 e5                	mov    %esp,%ebp
c0102484:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102487:	8b 45 08             	mov    0x8(%ebp),%eax
c010248a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248e:	c7 04 24 b3 92 10 c0 	movl   $0xc01092b3,(%esp)
c0102495:	e8 b1 de ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	89 04 24             	mov    %eax,(%esp)
c01024a0:	e8 a1 01 00 00       	call   c0102646 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01024a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01024ac:	0f b7 c0             	movzwl %ax,%eax
c01024af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b3:	c7 04 24 c4 92 10 c0 	movl   $0xc01092c4,(%esp)
c01024ba:	e8 8c de ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01024bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01024c6:	0f b7 c0             	movzwl %ax,%eax
c01024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024cd:	c7 04 24 d7 92 10 c0 	movl   $0xc01092d7,(%esp)
c01024d4:	e8 72 de ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01024d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024dc:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01024e0:	0f b7 c0             	movzwl %ax,%eax
c01024e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e7:	c7 04 24 ea 92 10 c0 	movl   $0xc01092ea,(%esp)
c01024ee:	e8 58 de ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01024f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f6:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01024fa:	0f b7 c0             	movzwl %ax,%eax
c01024fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102501:	c7 04 24 fd 92 10 c0 	movl   $0xc01092fd,(%esp)
c0102508:	e8 3e de ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010250d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102510:	8b 40 30             	mov    0x30(%eax),%eax
c0102513:	89 04 24             	mov    %eax,(%esp)
c0102516:	e8 1f ff ff ff       	call   c010243a <trapname>
c010251b:	8b 55 08             	mov    0x8(%ebp),%edx
c010251e:	8b 52 30             	mov    0x30(%edx),%edx
c0102521:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102525:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102529:	c7 04 24 10 93 10 c0 	movl   $0xc0109310,(%esp)
c0102530:	e8 16 de ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102535:	8b 45 08             	mov    0x8(%ebp),%eax
c0102538:	8b 40 34             	mov    0x34(%eax),%eax
c010253b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253f:	c7 04 24 22 93 10 c0 	movl   $0xc0109322,(%esp)
c0102546:	e8 00 de ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010254b:	8b 45 08             	mov    0x8(%ebp),%eax
c010254e:	8b 40 38             	mov    0x38(%eax),%eax
c0102551:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102555:	c7 04 24 31 93 10 c0 	movl   $0xc0109331,(%esp)
c010255c:	e8 ea dd ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102561:	8b 45 08             	mov    0x8(%ebp),%eax
c0102564:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102568:	0f b7 c0             	movzwl %ax,%eax
c010256b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010256f:	c7 04 24 40 93 10 c0 	movl   $0xc0109340,(%esp)
c0102576:	e8 d0 dd ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010257b:	8b 45 08             	mov    0x8(%ebp),%eax
c010257e:	8b 40 40             	mov    0x40(%eax),%eax
c0102581:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102585:	c7 04 24 53 93 10 c0 	movl   $0xc0109353,(%esp)
c010258c:	e8 ba dd ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102598:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010259f:	eb 3e                	jmp    c01025df <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01025a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a4:	8b 50 40             	mov    0x40(%eax),%edx
c01025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025aa:	21 d0                	and    %edx,%eax
c01025ac:	85 c0                	test   %eax,%eax
c01025ae:	74 28                	je     c01025d8 <print_trapframe+0x157>
c01025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025b3:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c01025ba:	85 c0                	test   %eax,%eax
c01025bc:	74 1a                	je     c01025d8 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025c1:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c01025c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025cc:	c7 04 24 62 93 10 c0 	movl   $0xc0109362,(%esp)
c01025d3:	e8 73 dd ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01025d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01025dc:	d1 65 f0             	shll   -0x10(%ebp)
c01025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025e2:	83 f8 17             	cmp    $0x17,%eax
c01025e5:	76 ba                	jbe    c01025a1 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01025e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ea:	8b 40 40             	mov    0x40(%eax),%eax
c01025ed:	25 00 30 00 00       	and    $0x3000,%eax
c01025f2:	c1 e8 0c             	shr    $0xc,%eax
c01025f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f9:	c7 04 24 66 93 10 c0 	movl   $0xc0109366,(%esp)
c0102600:	e8 46 dd ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c0102605:	8b 45 08             	mov    0x8(%ebp),%eax
c0102608:	89 04 24             	mov    %eax,(%esp)
c010260b:	e8 5b fe ff ff       	call   c010246b <trap_in_kernel>
c0102610:	85 c0                	test   %eax,%eax
c0102612:	75 30                	jne    c0102644 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	8b 40 44             	mov    0x44(%eax),%eax
c010261a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010261e:	c7 04 24 6f 93 10 c0 	movl   $0xc010936f,(%esp)
c0102625:	e8 21 dd ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010262a:	8b 45 08             	mov    0x8(%ebp),%eax
c010262d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102631:	0f b7 c0             	movzwl %ax,%eax
c0102634:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102638:	c7 04 24 7e 93 10 c0 	movl   $0xc010937e,(%esp)
c010263f:	e8 07 dd ff ff       	call   c010034b <cprintf>
    }
}
c0102644:	c9                   	leave  
c0102645:	c3                   	ret    

c0102646 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102646:	55                   	push   %ebp
c0102647:	89 e5                	mov    %esp,%ebp
c0102649:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010264c:	8b 45 08             	mov    0x8(%ebp),%eax
c010264f:	8b 00                	mov    (%eax),%eax
c0102651:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102655:	c7 04 24 91 93 10 c0 	movl   $0xc0109391,(%esp)
c010265c:	e8 ea dc ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102661:	8b 45 08             	mov    0x8(%ebp),%eax
c0102664:	8b 40 04             	mov    0x4(%eax),%eax
c0102667:	89 44 24 04          	mov    %eax,0x4(%esp)
c010266b:	c7 04 24 a0 93 10 c0 	movl   $0xc01093a0,(%esp)
c0102672:	e8 d4 dc ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102677:	8b 45 08             	mov    0x8(%ebp),%eax
c010267a:	8b 40 08             	mov    0x8(%eax),%eax
c010267d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102681:	c7 04 24 af 93 10 c0 	movl   $0xc01093af,(%esp)
c0102688:	e8 be dc ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010268d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102690:	8b 40 0c             	mov    0xc(%eax),%eax
c0102693:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102697:	c7 04 24 be 93 10 c0 	movl   $0xc01093be,(%esp)
c010269e:	e8 a8 dc ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01026a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a6:	8b 40 10             	mov    0x10(%eax),%eax
c01026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026ad:	c7 04 24 cd 93 10 c0 	movl   $0xc01093cd,(%esp)
c01026b4:	e8 92 dc ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01026b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01026bc:	8b 40 14             	mov    0x14(%eax),%eax
c01026bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026c3:	c7 04 24 dc 93 10 c0 	movl   $0xc01093dc,(%esp)
c01026ca:	e8 7c dc ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01026cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d2:	8b 40 18             	mov    0x18(%eax),%eax
c01026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026d9:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01026e0:	e8 66 dc ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01026e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01026eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026ef:	c7 04 24 fa 93 10 c0 	movl   $0xc01093fa,(%esp)
c01026f6:	e8 50 dc ff ff       	call   c010034b <cprintf>
}
c01026fb:	c9                   	leave  
c01026fc:	c3                   	ret    

c01026fd <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01026fd:	55                   	push   %ebp
c01026fe:	89 e5                	mov    %esp,%ebp
c0102700:	53                   	push   %ebx
c0102701:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102704:	8b 45 08             	mov    0x8(%ebp),%eax
c0102707:	8b 40 34             	mov    0x34(%eax),%eax
c010270a:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010270d:	85 c0                	test   %eax,%eax
c010270f:	74 07                	je     c0102718 <print_pgfault+0x1b>
c0102711:	b9 09 94 10 c0       	mov    $0xc0109409,%ecx
c0102716:	eb 05                	jmp    c010271d <print_pgfault+0x20>
c0102718:	b9 1a 94 10 c0       	mov    $0xc010941a,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010271d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102720:	8b 40 34             	mov    0x34(%eax),%eax
c0102723:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102726:	85 c0                	test   %eax,%eax
c0102728:	74 07                	je     c0102731 <print_pgfault+0x34>
c010272a:	ba 57 00 00 00       	mov    $0x57,%edx
c010272f:	eb 05                	jmp    c0102736 <print_pgfault+0x39>
c0102731:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102736:	8b 45 08             	mov    0x8(%ebp),%eax
c0102739:	8b 40 34             	mov    0x34(%eax),%eax
c010273c:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010273f:	85 c0                	test   %eax,%eax
c0102741:	74 07                	je     c010274a <print_pgfault+0x4d>
c0102743:	b8 55 00 00 00       	mov    $0x55,%eax
c0102748:	eb 05                	jmp    c010274f <print_pgfault+0x52>
c010274a:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010274f:	0f 20 d3             	mov    %cr2,%ebx
c0102752:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102755:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102758:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010275c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102760:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102764:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102768:	c7 04 24 28 94 10 c0 	movl   $0xc0109428,(%esp)
c010276f:	e8 d7 db ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102774:	83 c4 34             	add    $0x34,%esp
c0102777:	5b                   	pop    %ebx
c0102778:	5d                   	pop    %ebp
c0102779:	c3                   	ret    

c010277a <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010277a:	55                   	push   %ebp
c010277b:	89 e5                	mov    %esp,%ebp
c010277d:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102780:	8b 45 08             	mov    0x8(%ebp),%eax
c0102783:	89 04 24             	mov    %eax,(%esp)
c0102786:	e8 72 ff ff ff       	call   c01026fd <print_pgfault>
    if (check_mm_struct != NULL) {
c010278b:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0102790:	85 c0                	test   %eax,%eax
c0102792:	74 28                	je     c01027bc <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102794:	0f 20 d0             	mov    %cr2,%eax
c0102797:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c010279d:	89 c1                	mov    %eax,%ecx
c010279f:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a2:	8b 50 34             	mov    0x34(%eax),%edx
c01027a5:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01027aa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01027ae:	89 54 24 04          	mov    %edx,0x4(%esp)
c01027b2:	89 04 24             	mov    %eax,(%esp)
c01027b5:	e8 29 56 00 00       	call   c0107de3 <do_pgfault>
c01027ba:	eb 1c                	jmp    c01027d8 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01027bc:	c7 44 24 08 4b 94 10 	movl   $0xc010944b,0x8(%esp)
c01027c3:	c0 
c01027c4:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c01027cb:	00 
c01027cc:	c7 04 24 4e 92 10 c0 	movl   $0xc010924e,(%esp)
c01027d3:	e8 f7 e4 ff ff       	call   c0100ccf <__panic>
}
c01027d8:	c9                   	leave  
c01027d9:	c3                   	ret    

c01027da <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01027da:	55                   	push   %ebp
c01027db:	89 e5                	mov    %esp,%ebp
c01027dd:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01027e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e3:	8b 40 30             	mov    0x30(%eax),%eax
c01027e6:	83 f8 24             	cmp    $0x24,%eax
c01027e9:	0f 84 c2 00 00 00    	je     c01028b1 <trap_dispatch+0xd7>
c01027ef:	83 f8 24             	cmp    $0x24,%eax
c01027f2:	77 18                	ja     c010280c <trap_dispatch+0x32>
c01027f4:	83 f8 20             	cmp    $0x20,%eax
c01027f7:	74 7d                	je     c0102876 <trap_dispatch+0x9c>
c01027f9:	83 f8 21             	cmp    $0x21,%eax
c01027fc:	0f 84 d5 00 00 00    	je     c01028d7 <trap_dispatch+0xfd>
c0102802:	83 f8 0e             	cmp    $0xe,%eax
c0102805:	74 28                	je     c010282f <trap_dispatch+0x55>
c0102807:	e9 0d 01 00 00       	jmp    c0102919 <trap_dispatch+0x13f>
c010280c:	83 f8 2e             	cmp    $0x2e,%eax
c010280f:	0f 82 04 01 00 00    	jb     c0102919 <trap_dispatch+0x13f>
c0102815:	83 f8 2f             	cmp    $0x2f,%eax
c0102818:	0f 86 33 01 00 00    	jbe    c0102951 <trap_dispatch+0x177>
c010281e:	83 e8 78             	sub    $0x78,%eax
c0102821:	83 f8 01             	cmp    $0x1,%eax
c0102824:	0f 87 ef 00 00 00    	ja     c0102919 <trap_dispatch+0x13f>
c010282a:	e9 ce 00 00 00       	jmp    c01028fd <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010282f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102832:	89 04 24             	mov    %eax,(%esp)
c0102835:	e8 40 ff ff ff       	call   c010277a <pgfault_handler>
c010283a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010283d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102841:	74 2e                	je     c0102871 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102843:	8b 45 08             	mov    0x8(%ebp),%eax
c0102846:	89 04 24             	mov    %eax,(%esp)
c0102849:	e8 33 fc ff ff       	call   c0102481 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c010284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102851:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102855:	c7 44 24 08 62 94 10 	movl   $0xc0109462,0x8(%esp)
c010285c:	c0 
c010285d:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0102864:	00 
c0102865:	c7 04 24 4e 92 10 c0 	movl   $0xc010924e,(%esp)
c010286c:	e8 5e e4 ff ff       	call   c0100ccf <__panic>
        }
        break;
c0102871:	e9 dc 00 00 00       	jmp    c0102952 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks++;
c0102876:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c010287b:	83 c0 01             	add    $0x1,%eax
c010287e:	a3 bc 1a 12 c0       	mov    %eax,0xc0121abc
		if(ticks % TICK_NUM == 0)
c0102883:	8b 0d bc 1a 12 c0    	mov    0xc0121abc,%ecx
c0102889:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c010288e:	89 c8                	mov    %ecx,%eax
c0102890:	f7 e2                	mul    %edx
c0102892:	89 d0                	mov    %edx,%eax
c0102894:	c1 e8 05             	shr    $0x5,%eax
c0102897:	6b c0 64             	imul   $0x64,%eax,%eax
c010289a:	29 c1                	sub    %eax,%ecx
c010289c:	89 c8                	mov    %ecx,%eax
c010289e:	85 c0                	test   %eax,%eax
c01028a0:	75 0a                	jne    c01028ac <trap_dispatch+0xd2>
		{
			print_ticks();
c01028a2:	e8 47 f8 ff ff       	call   c01020ee <print_ticks>
		}
        break;
c01028a7:	e9 a6 00 00 00       	jmp    c0102952 <trap_dispatch+0x178>
c01028ac:	e9 a1 00 00 00       	jmp    c0102952 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01028b1:	e8 87 ed ff ff       	call   c010163d <cons_getc>
c01028b6:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01028b9:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028bd:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028c9:	c7 04 24 7d 94 10 c0 	movl   $0xc010947d,(%esp)
c01028d0:	e8 76 da ff ff       	call   c010034b <cprintf>
        break;
c01028d5:	eb 7b                	jmp    c0102952 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01028d7:	e8 61 ed ff ff       	call   c010163d <cons_getc>
c01028dc:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01028df:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028e3:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028e7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028ef:	c7 04 24 8f 94 10 c0 	movl   $0xc010948f,(%esp)
c01028f6:	e8 50 da ff ff       	call   c010034b <cprintf>
        break;
c01028fb:	eb 55                	jmp    c0102952 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01028fd:	c7 44 24 08 9e 94 10 	movl   $0xc010949e,0x8(%esp)
c0102904:	c0 
c0102905:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010290c:	00 
c010290d:	c7 04 24 4e 92 10 c0 	movl   $0xc010924e,(%esp)
c0102914:	e8 b6 e3 ff ff       	call   c0100ccf <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102919:	8b 45 08             	mov    0x8(%ebp),%eax
c010291c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102920:	0f b7 c0             	movzwl %ax,%eax
c0102923:	83 e0 03             	and    $0x3,%eax
c0102926:	85 c0                	test   %eax,%eax
c0102928:	75 28                	jne    c0102952 <trap_dispatch+0x178>
            print_trapframe(tf);
c010292a:	8b 45 08             	mov    0x8(%ebp),%eax
c010292d:	89 04 24             	mov    %eax,(%esp)
c0102930:	e8 4c fb ff ff       	call   c0102481 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102935:	c7 44 24 08 ae 94 10 	movl   $0xc01094ae,0x8(%esp)
c010293c:	c0 
c010293d:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0102944:	00 
c0102945:	c7 04 24 4e 92 10 c0 	movl   $0xc010924e,(%esp)
c010294c:	e8 7e e3 ff ff       	call   c0100ccf <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102951:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102952:	c9                   	leave  
c0102953:	c3                   	ret    

c0102954 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102954:	55                   	push   %ebp
c0102955:	89 e5                	mov    %esp,%ebp
c0102957:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010295a:	8b 45 08             	mov    0x8(%ebp),%eax
c010295d:	89 04 24             	mov    %eax,(%esp)
c0102960:	e8 75 fe ff ff       	call   c01027da <trap_dispatch>
}
c0102965:	c9                   	leave  
c0102966:	c3                   	ret    

c0102967 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102967:	1e                   	push   %ds
    pushl %es
c0102968:	06                   	push   %es
    pushl %fs
c0102969:	0f a0                	push   %fs
    pushl %gs
c010296b:	0f a8                	push   %gs
    pushal
c010296d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010296e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102973:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102975:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102977:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102978:	e8 d7 ff ff ff       	call   c0102954 <trap>

    # pop the pushed stack pointer
    popl %esp
c010297d:	5c                   	pop    %esp

c010297e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010297e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010297f:	0f a9                	pop    %gs
    popl %fs
c0102981:	0f a1                	pop    %fs
    popl %es
c0102983:	07                   	pop    %es
    popl %ds
c0102984:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102985:	83 c4 08             	add    $0x8,%esp
    iret
c0102988:	cf                   	iret   

c0102989 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102989:	6a 00                	push   $0x0
  pushl $0
c010298b:	6a 00                	push   $0x0
  jmp __alltraps
c010298d:	e9 d5 ff ff ff       	jmp    c0102967 <__alltraps>

c0102992 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $1
c0102994:	6a 01                	push   $0x1
  jmp __alltraps
c0102996:	e9 cc ff ff ff       	jmp    c0102967 <__alltraps>

c010299b <vector2>:
.globl vector2
vector2:
  pushl $0
c010299b:	6a 00                	push   $0x0
  pushl $2
c010299d:	6a 02                	push   $0x2
  jmp __alltraps
c010299f:	e9 c3 ff ff ff       	jmp    c0102967 <__alltraps>

c01029a4 <vector3>:
.globl vector3
vector3:
  pushl $0
c01029a4:	6a 00                	push   $0x0
  pushl $3
c01029a6:	6a 03                	push   $0x3
  jmp __alltraps
c01029a8:	e9 ba ff ff ff       	jmp    c0102967 <__alltraps>

c01029ad <vector4>:
.globl vector4
vector4:
  pushl $0
c01029ad:	6a 00                	push   $0x0
  pushl $4
c01029af:	6a 04                	push   $0x4
  jmp __alltraps
c01029b1:	e9 b1 ff ff ff       	jmp    c0102967 <__alltraps>

c01029b6 <vector5>:
.globl vector5
vector5:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $5
c01029b8:	6a 05                	push   $0x5
  jmp __alltraps
c01029ba:	e9 a8 ff ff ff       	jmp    c0102967 <__alltraps>

c01029bf <vector6>:
.globl vector6
vector6:
  pushl $0
c01029bf:	6a 00                	push   $0x0
  pushl $6
c01029c1:	6a 06                	push   $0x6
  jmp __alltraps
c01029c3:	e9 9f ff ff ff       	jmp    c0102967 <__alltraps>

c01029c8 <vector7>:
.globl vector7
vector7:
  pushl $0
c01029c8:	6a 00                	push   $0x0
  pushl $7
c01029ca:	6a 07                	push   $0x7
  jmp __alltraps
c01029cc:	e9 96 ff ff ff       	jmp    c0102967 <__alltraps>

c01029d1 <vector8>:
.globl vector8
vector8:
  pushl $8
c01029d1:	6a 08                	push   $0x8
  jmp __alltraps
c01029d3:	e9 8f ff ff ff       	jmp    c0102967 <__alltraps>

c01029d8 <vector9>:
.globl vector9
vector9:
  pushl $9
c01029d8:	6a 09                	push   $0x9
  jmp __alltraps
c01029da:	e9 88 ff ff ff       	jmp    c0102967 <__alltraps>

c01029df <vector10>:
.globl vector10
vector10:
  pushl $10
c01029df:	6a 0a                	push   $0xa
  jmp __alltraps
c01029e1:	e9 81 ff ff ff       	jmp    c0102967 <__alltraps>

c01029e6 <vector11>:
.globl vector11
vector11:
  pushl $11
c01029e6:	6a 0b                	push   $0xb
  jmp __alltraps
c01029e8:	e9 7a ff ff ff       	jmp    c0102967 <__alltraps>

c01029ed <vector12>:
.globl vector12
vector12:
  pushl $12
c01029ed:	6a 0c                	push   $0xc
  jmp __alltraps
c01029ef:	e9 73 ff ff ff       	jmp    c0102967 <__alltraps>

c01029f4 <vector13>:
.globl vector13
vector13:
  pushl $13
c01029f4:	6a 0d                	push   $0xd
  jmp __alltraps
c01029f6:	e9 6c ff ff ff       	jmp    c0102967 <__alltraps>

c01029fb <vector14>:
.globl vector14
vector14:
  pushl $14
c01029fb:	6a 0e                	push   $0xe
  jmp __alltraps
c01029fd:	e9 65 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a02 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102a02:	6a 00                	push   $0x0
  pushl $15
c0102a04:	6a 0f                	push   $0xf
  jmp __alltraps
c0102a06:	e9 5c ff ff ff       	jmp    c0102967 <__alltraps>

c0102a0b <vector16>:
.globl vector16
vector16:
  pushl $0
c0102a0b:	6a 00                	push   $0x0
  pushl $16
c0102a0d:	6a 10                	push   $0x10
  jmp __alltraps
c0102a0f:	e9 53 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a14 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102a14:	6a 11                	push   $0x11
  jmp __alltraps
c0102a16:	e9 4c ff ff ff       	jmp    c0102967 <__alltraps>

c0102a1b <vector18>:
.globl vector18
vector18:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $18
c0102a1d:	6a 12                	push   $0x12
  jmp __alltraps
c0102a1f:	e9 43 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a24 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $19
c0102a26:	6a 13                	push   $0x13
  jmp __alltraps
c0102a28:	e9 3a ff ff ff       	jmp    c0102967 <__alltraps>

c0102a2d <vector20>:
.globl vector20
vector20:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $20
c0102a2f:	6a 14                	push   $0x14
  jmp __alltraps
c0102a31:	e9 31 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a36 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $21
c0102a38:	6a 15                	push   $0x15
  jmp __alltraps
c0102a3a:	e9 28 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a3f <vector22>:
.globl vector22
vector22:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $22
c0102a41:	6a 16                	push   $0x16
  jmp __alltraps
c0102a43:	e9 1f ff ff ff       	jmp    c0102967 <__alltraps>

c0102a48 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $23
c0102a4a:	6a 17                	push   $0x17
  jmp __alltraps
c0102a4c:	e9 16 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a51 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $24
c0102a53:	6a 18                	push   $0x18
  jmp __alltraps
c0102a55:	e9 0d ff ff ff       	jmp    c0102967 <__alltraps>

c0102a5a <vector25>:
.globl vector25
vector25:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $25
c0102a5c:	6a 19                	push   $0x19
  jmp __alltraps
c0102a5e:	e9 04 ff ff ff       	jmp    c0102967 <__alltraps>

c0102a63 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $26
c0102a65:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102a67:	e9 fb fe ff ff       	jmp    c0102967 <__alltraps>

c0102a6c <vector27>:
.globl vector27
vector27:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $27
c0102a6e:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102a70:	e9 f2 fe ff ff       	jmp    c0102967 <__alltraps>

c0102a75 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $28
c0102a77:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102a79:	e9 e9 fe ff ff       	jmp    c0102967 <__alltraps>

c0102a7e <vector29>:
.globl vector29
vector29:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $29
c0102a80:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102a82:	e9 e0 fe ff ff       	jmp    c0102967 <__alltraps>

c0102a87 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $30
c0102a89:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102a8b:	e9 d7 fe ff ff       	jmp    c0102967 <__alltraps>

c0102a90 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $31
c0102a92:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102a94:	e9 ce fe ff ff       	jmp    c0102967 <__alltraps>

c0102a99 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $32
c0102a9b:	6a 20                	push   $0x20
  jmp __alltraps
c0102a9d:	e9 c5 fe ff ff       	jmp    c0102967 <__alltraps>

c0102aa2 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $33
c0102aa4:	6a 21                	push   $0x21
  jmp __alltraps
c0102aa6:	e9 bc fe ff ff       	jmp    c0102967 <__alltraps>

c0102aab <vector34>:
.globl vector34
vector34:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $34
c0102aad:	6a 22                	push   $0x22
  jmp __alltraps
c0102aaf:	e9 b3 fe ff ff       	jmp    c0102967 <__alltraps>

c0102ab4 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $35
c0102ab6:	6a 23                	push   $0x23
  jmp __alltraps
c0102ab8:	e9 aa fe ff ff       	jmp    c0102967 <__alltraps>

c0102abd <vector36>:
.globl vector36
vector36:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $36
c0102abf:	6a 24                	push   $0x24
  jmp __alltraps
c0102ac1:	e9 a1 fe ff ff       	jmp    c0102967 <__alltraps>

c0102ac6 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $37
c0102ac8:	6a 25                	push   $0x25
  jmp __alltraps
c0102aca:	e9 98 fe ff ff       	jmp    c0102967 <__alltraps>

c0102acf <vector38>:
.globl vector38
vector38:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $38
c0102ad1:	6a 26                	push   $0x26
  jmp __alltraps
c0102ad3:	e9 8f fe ff ff       	jmp    c0102967 <__alltraps>

c0102ad8 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $39
c0102ada:	6a 27                	push   $0x27
  jmp __alltraps
c0102adc:	e9 86 fe ff ff       	jmp    c0102967 <__alltraps>

c0102ae1 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $40
c0102ae3:	6a 28                	push   $0x28
  jmp __alltraps
c0102ae5:	e9 7d fe ff ff       	jmp    c0102967 <__alltraps>

c0102aea <vector41>:
.globl vector41
vector41:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $41
c0102aec:	6a 29                	push   $0x29
  jmp __alltraps
c0102aee:	e9 74 fe ff ff       	jmp    c0102967 <__alltraps>

c0102af3 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $42
c0102af5:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102af7:	e9 6b fe ff ff       	jmp    c0102967 <__alltraps>

c0102afc <vector43>:
.globl vector43
vector43:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $43
c0102afe:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102b00:	e9 62 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b05 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $44
c0102b07:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102b09:	e9 59 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b0e <vector45>:
.globl vector45
vector45:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $45
c0102b10:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102b12:	e9 50 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b17 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $46
c0102b19:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102b1b:	e9 47 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b20 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $47
c0102b22:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102b24:	e9 3e fe ff ff       	jmp    c0102967 <__alltraps>

c0102b29 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $48
c0102b2b:	6a 30                	push   $0x30
  jmp __alltraps
c0102b2d:	e9 35 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b32 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $49
c0102b34:	6a 31                	push   $0x31
  jmp __alltraps
c0102b36:	e9 2c fe ff ff       	jmp    c0102967 <__alltraps>

c0102b3b <vector50>:
.globl vector50
vector50:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $50
c0102b3d:	6a 32                	push   $0x32
  jmp __alltraps
c0102b3f:	e9 23 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b44 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $51
c0102b46:	6a 33                	push   $0x33
  jmp __alltraps
c0102b48:	e9 1a fe ff ff       	jmp    c0102967 <__alltraps>

c0102b4d <vector52>:
.globl vector52
vector52:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $52
c0102b4f:	6a 34                	push   $0x34
  jmp __alltraps
c0102b51:	e9 11 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b56 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $53
c0102b58:	6a 35                	push   $0x35
  jmp __alltraps
c0102b5a:	e9 08 fe ff ff       	jmp    c0102967 <__alltraps>

c0102b5f <vector54>:
.globl vector54
vector54:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $54
c0102b61:	6a 36                	push   $0x36
  jmp __alltraps
c0102b63:	e9 ff fd ff ff       	jmp    c0102967 <__alltraps>

c0102b68 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $55
c0102b6a:	6a 37                	push   $0x37
  jmp __alltraps
c0102b6c:	e9 f6 fd ff ff       	jmp    c0102967 <__alltraps>

c0102b71 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $56
c0102b73:	6a 38                	push   $0x38
  jmp __alltraps
c0102b75:	e9 ed fd ff ff       	jmp    c0102967 <__alltraps>

c0102b7a <vector57>:
.globl vector57
vector57:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $57
c0102b7c:	6a 39                	push   $0x39
  jmp __alltraps
c0102b7e:	e9 e4 fd ff ff       	jmp    c0102967 <__alltraps>

c0102b83 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $58
c0102b85:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102b87:	e9 db fd ff ff       	jmp    c0102967 <__alltraps>

c0102b8c <vector59>:
.globl vector59
vector59:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $59
c0102b8e:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102b90:	e9 d2 fd ff ff       	jmp    c0102967 <__alltraps>

c0102b95 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $60
c0102b97:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102b99:	e9 c9 fd ff ff       	jmp    c0102967 <__alltraps>

c0102b9e <vector61>:
.globl vector61
vector61:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $61
c0102ba0:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102ba2:	e9 c0 fd ff ff       	jmp    c0102967 <__alltraps>

c0102ba7 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $62
c0102ba9:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102bab:	e9 b7 fd ff ff       	jmp    c0102967 <__alltraps>

c0102bb0 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $63
c0102bb2:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102bb4:	e9 ae fd ff ff       	jmp    c0102967 <__alltraps>

c0102bb9 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $64
c0102bbb:	6a 40                	push   $0x40
  jmp __alltraps
c0102bbd:	e9 a5 fd ff ff       	jmp    c0102967 <__alltraps>

c0102bc2 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $65
c0102bc4:	6a 41                	push   $0x41
  jmp __alltraps
c0102bc6:	e9 9c fd ff ff       	jmp    c0102967 <__alltraps>

c0102bcb <vector66>:
.globl vector66
vector66:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $66
c0102bcd:	6a 42                	push   $0x42
  jmp __alltraps
c0102bcf:	e9 93 fd ff ff       	jmp    c0102967 <__alltraps>

c0102bd4 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $67
c0102bd6:	6a 43                	push   $0x43
  jmp __alltraps
c0102bd8:	e9 8a fd ff ff       	jmp    c0102967 <__alltraps>

c0102bdd <vector68>:
.globl vector68
vector68:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $68
c0102bdf:	6a 44                	push   $0x44
  jmp __alltraps
c0102be1:	e9 81 fd ff ff       	jmp    c0102967 <__alltraps>

c0102be6 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $69
c0102be8:	6a 45                	push   $0x45
  jmp __alltraps
c0102bea:	e9 78 fd ff ff       	jmp    c0102967 <__alltraps>

c0102bef <vector70>:
.globl vector70
vector70:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $70
c0102bf1:	6a 46                	push   $0x46
  jmp __alltraps
c0102bf3:	e9 6f fd ff ff       	jmp    c0102967 <__alltraps>

c0102bf8 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $71
c0102bfa:	6a 47                	push   $0x47
  jmp __alltraps
c0102bfc:	e9 66 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c01 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $72
c0102c03:	6a 48                	push   $0x48
  jmp __alltraps
c0102c05:	e9 5d fd ff ff       	jmp    c0102967 <__alltraps>

c0102c0a <vector73>:
.globl vector73
vector73:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $73
c0102c0c:	6a 49                	push   $0x49
  jmp __alltraps
c0102c0e:	e9 54 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c13 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $74
c0102c15:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102c17:	e9 4b fd ff ff       	jmp    c0102967 <__alltraps>

c0102c1c <vector75>:
.globl vector75
vector75:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $75
c0102c1e:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102c20:	e9 42 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c25 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $76
c0102c27:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102c29:	e9 39 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c2e <vector77>:
.globl vector77
vector77:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $77
c0102c30:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102c32:	e9 30 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c37 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $78
c0102c39:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102c3b:	e9 27 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c40 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $79
c0102c42:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102c44:	e9 1e fd ff ff       	jmp    c0102967 <__alltraps>

c0102c49 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $80
c0102c4b:	6a 50                	push   $0x50
  jmp __alltraps
c0102c4d:	e9 15 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c52 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $81
c0102c54:	6a 51                	push   $0x51
  jmp __alltraps
c0102c56:	e9 0c fd ff ff       	jmp    c0102967 <__alltraps>

c0102c5b <vector82>:
.globl vector82
vector82:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $82
c0102c5d:	6a 52                	push   $0x52
  jmp __alltraps
c0102c5f:	e9 03 fd ff ff       	jmp    c0102967 <__alltraps>

c0102c64 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $83
c0102c66:	6a 53                	push   $0x53
  jmp __alltraps
c0102c68:	e9 fa fc ff ff       	jmp    c0102967 <__alltraps>

c0102c6d <vector84>:
.globl vector84
vector84:
  pushl $0
c0102c6d:	6a 00                	push   $0x0
  pushl $84
c0102c6f:	6a 54                	push   $0x54
  jmp __alltraps
c0102c71:	e9 f1 fc ff ff       	jmp    c0102967 <__alltraps>

c0102c76 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102c76:	6a 00                	push   $0x0
  pushl $85
c0102c78:	6a 55                	push   $0x55
  jmp __alltraps
c0102c7a:	e9 e8 fc ff ff       	jmp    c0102967 <__alltraps>

c0102c7f <vector86>:
.globl vector86
vector86:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $86
c0102c81:	6a 56                	push   $0x56
  jmp __alltraps
c0102c83:	e9 df fc ff ff       	jmp    c0102967 <__alltraps>

c0102c88 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $87
c0102c8a:	6a 57                	push   $0x57
  jmp __alltraps
c0102c8c:	e9 d6 fc ff ff       	jmp    c0102967 <__alltraps>

c0102c91 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102c91:	6a 00                	push   $0x0
  pushl $88
c0102c93:	6a 58                	push   $0x58
  jmp __alltraps
c0102c95:	e9 cd fc ff ff       	jmp    c0102967 <__alltraps>

c0102c9a <vector89>:
.globl vector89
vector89:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $89
c0102c9c:	6a 59                	push   $0x59
  jmp __alltraps
c0102c9e:	e9 c4 fc ff ff       	jmp    c0102967 <__alltraps>

c0102ca3 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $90
c0102ca5:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102ca7:	e9 bb fc ff ff       	jmp    c0102967 <__alltraps>

c0102cac <vector91>:
.globl vector91
vector91:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $91
c0102cae:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102cb0:	e9 b2 fc ff ff       	jmp    c0102967 <__alltraps>

c0102cb5 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102cb5:	6a 00                	push   $0x0
  pushl $92
c0102cb7:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102cb9:	e9 a9 fc ff ff       	jmp    c0102967 <__alltraps>

c0102cbe <vector93>:
.globl vector93
vector93:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $93
c0102cc0:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102cc2:	e9 a0 fc ff ff       	jmp    c0102967 <__alltraps>

c0102cc7 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $94
c0102cc9:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102ccb:	e9 97 fc ff ff       	jmp    c0102967 <__alltraps>

c0102cd0 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $95
c0102cd2:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102cd4:	e9 8e fc ff ff       	jmp    c0102967 <__alltraps>

c0102cd9 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102cd9:	6a 00                	push   $0x0
  pushl $96
c0102cdb:	6a 60                	push   $0x60
  jmp __alltraps
c0102cdd:	e9 85 fc ff ff       	jmp    c0102967 <__alltraps>

c0102ce2 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $97
c0102ce4:	6a 61                	push   $0x61
  jmp __alltraps
c0102ce6:	e9 7c fc ff ff       	jmp    c0102967 <__alltraps>

c0102ceb <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $98
c0102ced:	6a 62                	push   $0x62
  jmp __alltraps
c0102cef:	e9 73 fc ff ff       	jmp    c0102967 <__alltraps>

c0102cf4 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $99
c0102cf6:	6a 63                	push   $0x63
  jmp __alltraps
c0102cf8:	e9 6a fc ff ff       	jmp    c0102967 <__alltraps>

c0102cfd <vector100>:
.globl vector100
vector100:
  pushl $0
c0102cfd:	6a 00                	push   $0x0
  pushl $100
c0102cff:	6a 64                	push   $0x64
  jmp __alltraps
c0102d01:	e9 61 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d06 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $101
c0102d08:	6a 65                	push   $0x65
  jmp __alltraps
c0102d0a:	e9 58 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d0f <vector102>:
.globl vector102
vector102:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $102
c0102d11:	6a 66                	push   $0x66
  jmp __alltraps
c0102d13:	e9 4f fc ff ff       	jmp    c0102967 <__alltraps>

c0102d18 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $103
c0102d1a:	6a 67                	push   $0x67
  jmp __alltraps
c0102d1c:	e9 46 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d21 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102d21:	6a 00                	push   $0x0
  pushl $104
c0102d23:	6a 68                	push   $0x68
  jmp __alltraps
c0102d25:	e9 3d fc ff ff       	jmp    c0102967 <__alltraps>

c0102d2a <vector105>:
.globl vector105
vector105:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $105
c0102d2c:	6a 69                	push   $0x69
  jmp __alltraps
c0102d2e:	e9 34 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d33 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102d33:	6a 00                	push   $0x0
  pushl $106
c0102d35:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102d37:	e9 2b fc ff ff       	jmp    c0102967 <__alltraps>

c0102d3c <vector107>:
.globl vector107
vector107:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $107
c0102d3e:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102d40:	e9 22 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d45 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102d45:	6a 00                	push   $0x0
  pushl $108
c0102d47:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102d49:	e9 19 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d4e <vector109>:
.globl vector109
vector109:
  pushl $0
c0102d4e:	6a 00                	push   $0x0
  pushl $109
c0102d50:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102d52:	e9 10 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d57 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102d57:	6a 00                	push   $0x0
  pushl $110
c0102d59:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102d5b:	e9 07 fc ff ff       	jmp    c0102967 <__alltraps>

c0102d60 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $111
c0102d62:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102d64:	e9 fe fb ff ff       	jmp    c0102967 <__alltraps>

c0102d69 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102d69:	6a 00                	push   $0x0
  pushl $112
c0102d6b:	6a 70                	push   $0x70
  jmp __alltraps
c0102d6d:	e9 f5 fb ff ff       	jmp    c0102967 <__alltraps>

c0102d72 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102d72:	6a 00                	push   $0x0
  pushl $113
c0102d74:	6a 71                	push   $0x71
  jmp __alltraps
c0102d76:	e9 ec fb ff ff       	jmp    c0102967 <__alltraps>

c0102d7b <vector114>:
.globl vector114
vector114:
  pushl $0
c0102d7b:	6a 00                	push   $0x0
  pushl $114
c0102d7d:	6a 72                	push   $0x72
  jmp __alltraps
c0102d7f:	e9 e3 fb ff ff       	jmp    c0102967 <__alltraps>

c0102d84 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $115
c0102d86:	6a 73                	push   $0x73
  jmp __alltraps
c0102d88:	e9 da fb ff ff       	jmp    c0102967 <__alltraps>

c0102d8d <vector116>:
.globl vector116
vector116:
  pushl $0
c0102d8d:	6a 00                	push   $0x0
  pushl $116
c0102d8f:	6a 74                	push   $0x74
  jmp __alltraps
c0102d91:	e9 d1 fb ff ff       	jmp    c0102967 <__alltraps>

c0102d96 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102d96:	6a 00                	push   $0x0
  pushl $117
c0102d98:	6a 75                	push   $0x75
  jmp __alltraps
c0102d9a:	e9 c8 fb ff ff       	jmp    c0102967 <__alltraps>

c0102d9f <vector118>:
.globl vector118
vector118:
  pushl $0
c0102d9f:	6a 00                	push   $0x0
  pushl $118
c0102da1:	6a 76                	push   $0x76
  jmp __alltraps
c0102da3:	e9 bf fb ff ff       	jmp    c0102967 <__alltraps>

c0102da8 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $119
c0102daa:	6a 77                	push   $0x77
  jmp __alltraps
c0102dac:	e9 b6 fb ff ff       	jmp    c0102967 <__alltraps>

c0102db1 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102db1:	6a 00                	push   $0x0
  pushl $120
c0102db3:	6a 78                	push   $0x78
  jmp __alltraps
c0102db5:	e9 ad fb ff ff       	jmp    c0102967 <__alltraps>

c0102dba <vector121>:
.globl vector121
vector121:
  pushl $0
c0102dba:	6a 00                	push   $0x0
  pushl $121
c0102dbc:	6a 79                	push   $0x79
  jmp __alltraps
c0102dbe:	e9 a4 fb ff ff       	jmp    c0102967 <__alltraps>

c0102dc3 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102dc3:	6a 00                	push   $0x0
  pushl $122
c0102dc5:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102dc7:	e9 9b fb ff ff       	jmp    c0102967 <__alltraps>

c0102dcc <vector123>:
.globl vector123
vector123:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $123
c0102dce:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102dd0:	e9 92 fb ff ff       	jmp    c0102967 <__alltraps>

c0102dd5 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102dd5:	6a 00                	push   $0x0
  pushl $124
c0102dd7:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102dd9:	e9 89 fb ff ff       	jmp    c0102967 <__alltraps>

c0102dde <vector125>:
.globl vector125
vector125:
  pushl $0
c0102dde:	6a 00                	push   $0x0
  pushl $125
c0102de0:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102de2:	e9 80 fb ff ff       	jmp    c0102967 <__alltraps>

c0102de7 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102de7:	6a 00                	push   $0x0
  pushl $126
c0102de9:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102deb:	e9 77 fb ff ff       	jmp    c0102967 <__alltraps>

c0102df0 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $127
c0102df2:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102df4:	e9 6e fb ff ff       	jmp    c0102967 <__alltraps>

c0102df9 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102df9:	6a 00                	push   $0x0
  pushl $128
c0102dfb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102e00:	e9 62 fb ff ff       	jmp    c0102967 <__alltraps>

c0102e05 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102e05:	6a 00                	push   $0x0
  pushl $129
c0102e07:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102e0c:	e9 56 fb ff ff       	jmp    c0102967 <__alltraps>

c0102e11 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102e11:	6a 00                	push   $0x0
  pushl $130
c0102e13:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102e18:	e9 4a fb ff ff       	jmp    c0102967 <__alltraps>

c0102e1d <vector131>:
.globl vector131
vector131:
  pushl $0
c0102e1d:	6a 00                	push   $0x0
  pushl $131
c0102e1f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102e24:	e9 3e fb ff ff       	jmp    c0102967 <__alltraps>

c0102e29 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102e29:	6a 00                	push   $0x0
  pushl $132
c0102e2b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102e30:	e9 32 fb ff ff       	jmp    c0102967 <__alltraps>

c0102e35 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102e35:	6a 00                	push   $0x0
  pushl $133
c0102e37:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102e3c:	e9 26 fb ff ff       	jmp    c0102967 <__alltraps>

c0102e41 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102e41:	6a 00                	push   $0x0
  pushl $134
c0102e43:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102e48:	e9 1a fb ff ff       	jmp    c0102967 <__alltraps>

c0102e4d <vector135>:
.globl vector135
vector135:
  pushl $0
c0102e4d:	6a 00                	push   $0x0
  pushl $135
c0102e4f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102e54:	e9 0e fb ff ff       	jmp    c0102967 <__alltraps>

c0102e59 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102e59:	6a 00                	push   $0x0
  pushl $136
c0102e5b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102e60:	e9 02 fb ff ff       	jmp    c0102967 <__alltraps>

c0102e65 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102e65:	6a 00                	push   $0x0
  pushl $137
c0102e67:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102e6c:	e9 f6 fa ff ff       	jmp    c0102967 <__alltraps>

c0102e71 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102e71:	6a 00                	push   $0x0
  pushl $138
c0102e73:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102e78:	e9 ea fa ff ff       	jmp    c0102967 <__alltraps>

c0102e7d <vector139>:
.globl vector139
vector139:
  pushl $0
c0102e7d:	6a 00                	push   $0x0
  pushl $139
c0102e7f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102e84:	e9 de fa ff ff       	jmp    c0102967 <__alltraps>

c0102e89 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102e89:	6a 00                	push   $0x0
  pushl $140
c0102e8b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102e90:	e9 d2 fa ff ff       	jmp    c0102967 <__alltraps>

c0102e95 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102e95:	6a 00                	push   $0x0
  pushl $141
c0102e97:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102e9c:	e9 c6 fa ff ff       	jmp    c0102967 <__alltraps>

c0102ea1 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102ea1:	6a 00                	push   $0x0
  pushl $142
c0102ea3:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102ea8:	e9 ba fa ff ff       	jmp    c0102967 <__alltraps>

c0102ead <vector143>:
.globl vector143
vector143:
  pushl $0
c0102ead:	6a 00                	push   $0x0
  pushl $143
c0102eaf:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102eb4:	e9 ae fa ff ff       	jmp    c0102967 <__alltraps>

c0102eb9 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102eb9:	6a 00                	push   $0x0
  pushl $144
c0102ebb:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ec0:	e9 a2 fa ff ff       	jmp    c0102967 <__alltraps>

c0102ec5 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102ec5:	6a 00                	push   $0x0
  pushl $145
c0102ec7:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102ecc:	e9 96 fa ff ff       	jmp    c0102967 <__alltraps>

c0102ed1 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102ed1:	6a 00                	push   $0x0
  pushl $146
c0102ed3:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ed8:	e9 8a fa ff ff       	jmp    c0102967 <__alltraps>

c0102edd <vector147>:
.globl vector147
vector147:
  pushl $0
c0102edd:	6a 00                	push   $0x0
  pushl $147
c0102edf:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ee4:	e9 7e fa ff ff       	jmp    c0102967 <__alltraps>

c0102ee9 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102ee9:	6a 00                	push   $0x0
  pushl $148
c0102eeb:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102ef0:	e9 72 fa ff ff       	jmp    c0102967 <__alltraps>

c0102ef5 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102ef5:	6a 00                	push   $0x0
  pushl $149
c0102ef7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102efc:	e9 66 fa ff ff       	jmp    c0102967 <__alltraps>

c0102f01 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102f01:	6a 00                	push   $0x0
  pushl $150
c0102f03:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102f08:	e9 5a fa ff ff       	jmp    c0102967 <__alltraps>

c0102f0d <vector151>:
.globl vector151
vector151:
  pushl $0
c0102f0d:	6a 00                	push   $0x0
  pushl $151
c0102f0f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102f14:	e9 4e fa ff ff       	jmp    c0102967 <__alltraps>

c0102f19 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102f19:	6a 00                	push   $0x0
  pushl $152
c0102f1b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102f20:	e9 42 fa ff ff       	jmp    c0102967 <__alltraps>

c0102f25 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102f25:	6a 00                	push   $0x0
  pushl $153
c0102f27:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102f2c:	e9 36 fa ff ff       	jmp    c0102967 <__alltraps>

c0102f31 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102f31:	6a 00                	push   $0x0
  pushl $154
c0102f33:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102f38:	e9 2a fa ff ff       	jmp    c0102967 <__alltraps>

c0102f3d <vector155>:
.globl vector155
vector155:
  pushl $0
c0102f3d:	6a 00                	push   $0x0
  pushl $155
c0102f3f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102f44:	e9 1e fa ff ff       	jmp    c0102967 <__alltraps>

c0102f49 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102f49:	6a 00                	push   $0x0
  pushl $156
c0102f4b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102f50:	e9 12 fa ff ff       	jmp    c0102967 <__alltraps>

c0102f55 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102f55:	6a 00                	push   $0x0
  pushl $157
c0102f57:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102f5c:	e9 06 fa ff ff       	jmp    c0102967 <__alltraps>

c0102f61 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102f61:	6a 00                	push   $0x0
  pushl $158
c0102f63:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102f68:	e9 fa f9 ff ff       	jmp    c0102967 <__alltraps>

c0102f6d <vector159>:
.globl vector159
vector159:
  pushl $0
c0102f6d:	6a 00                	push   $0x0
  pushl $159
c0102f6f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102f74:	e9 ee f9 ff ff       	jmp    c0102967 <__alltraps>

c0102f79 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102f79:	6a 00                	push   $0x0
  pushl $160
c0102f7b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102f80:	e9 e2 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102f85 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102f85:	6a 00                	push   $0x0
  pushl $161
c0102f87:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102f8c:	e9 d6 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102f91 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102f91:	6a 00                	push   $0x0
  pushl $162
c0102f93:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102f98:	e9 ca f9 ff ff       	jmp    c0102967 <__alltraps>

c0102f9d <vector163>:
.globl vector163
vector163:
  pushl $0
c0102f9d:	6a 00                	push   $0x0
  pushl $163
c0102f9f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102fa4:	e9 be f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fa9 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102fa9:	6a 00                	push   $0x0
  pushl $164
c0102fab:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102fb0:	e9 b2 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fb5 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102fb5:	6a 00                	push   $0x0
  pushl $165
c0102fb7:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102fbc:	e9 a6 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fc1 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102fc1:	6a 00                	push   $0x0
  pushl $166
c0102fc3:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102fc8:	e9 9a f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fcd <vector167>:
.globl vector167
vector167:
  pushl $0
c0102fcd:	6a 00                	push   $0x0
  pushl $167
c0102fcf:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102fd4:	e9 8e f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fd9 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102fd9:	6a 00                	push   $0x0
  pushl $168
c0102fdb:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102fe0:	e9 82 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102fe5 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102fe5:	6a 00                	push   $0x0
  pushl $169
c0102fe7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102fec:	e9 76 f9 ff ff       	jmp    c0102967 <__alltraps>

c0102ff1 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102ff1:	6a 00                	push   $0x0
  pushl $170
c0102ff3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ff8:	e9 6a f9 ff ff       	jmp    c0102967 <__alltraps>

c0102ffd <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ffd:	6a 00                	push   $0x0
  pushl $171
c0102fff:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0103004:	e9 5e f9 ff ff       	jmp    c0102967 <__alltraps>

c0103009 <vector172>:
.globl vector172
vector172:
  pushl $0
c0103009:	6a 00                	push   $0x0
  pushl $172
c010300b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0103010:	e9 52 f9 ff ff       	jmp    c0102967 <__alltraps>

c0103015 <vector173>:
.globl vector173
vector173:
  pushl $0
c0103015:	6a 00                	push   $0x0
  pushl $173
c0103017:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010301c:	e9 46 f9 ff ff       	jmp    c0102967 <__alltraps>

c0103021 <vector174>:
.globl vector174
vector174:
  pushl $0
c0103021:	6a 00                	push   $0x0
  pushl $174
c0103023:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0103028:	e9 3a f9 ff ff       	jmp    c0102967 <__alltraps>

c010302d <vector175>:
.globl vector175
vector175:
  pushl $0
c010302d:	6a 00                	push   $0x0
  pushl $175
c010302f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0103034:	e9 2e f9 ff ff       	jmp    c0102967 <__alltraps>

c0103039 <vector176>:
.globl vector176
vector176:
  pushl $0
c0103039:	6a 00                	push   $0x0
  pushl $176
c010303b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0103040:	e9 22 f9 ff ff       	jmp    c0102967 <__alltraps>

c0103045 <vector177>:
.globl vector177
vector177:
  pushl $0
c0103045:	6a 00                	push   $0x0
  pushl $177
c0103047:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010304c:	e9 16 f9 ff ff       	jmp    c0102967 <__alltraps>

c0103051 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103051:	6a 00                	push   $0x0
  pushl $178
c0103053:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0103058:	e9 0a f9 ff ff       	jmp    c0102967 <__alltraps>

c010305d <vector179>:
.globl vector179
vector179:
  pushl $0
c010305d:	6a 00                	push   $0x0
  pushl $179
c010305f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0103064:	e9 fe f8 ff ff       	jmp    c0102967 <__alltraps>

c0103069 <vector180>:
.globl vector180
vector180:
  pushl $0
c0103069:	6a 00                	push   $0x0
  pushl $180
c010306b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0103070:	e9 f2 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103075 <vector181>:
.globl vector181
vector181:
  pushl $0
c0103075:	6a 00                	push   $0x0
  pushl $181
c0103077:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010307c:	e9 e6 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103081 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103081:	6a 00                	push   $0x0
  pushl $182
c0103083:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103088:	e9 da f8 ff ff       	jmp    c0102967 <__alltraps>

c010308d <vector183>:
.globl vector183
vector183:
  pushl $0
c010308d:	6a 00                	push   $0x0
  pushl $183
c010308f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103094:	e9 ce f8 ff ff       	jmp    c0102967 <__alltraps>

c0103099 <vector184>:
.globl vector184
vector184:
  pushl $0
c0103099:	6a 00                	push   $0x0
  pushl $184
c010309b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01030a0:	e9 c2 f8 ff ff       	jmp    c0102967 <__alltraps>

c01030a5 <vector185>:
.globl vector185
vector185:
  pushl $0
c01030a5:	6a 00                	push   $0x0
  pushl $185
c01030a7:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01030ac:	e9 b6 f8 ff ff       	jmp    c0102967 <__alltraps>

c01030b1 <vector186>:
.globl vector186
vector186:
  pushl $0
c01030b1:	6a 00                	push   $0x0
  pushl $186
c01030b3:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01030b8:	e9 aa f8 ff ff       	jmp    c0102967 <__alltraps>

c01030bd <vector187>:
.globl vector187
vector187:
  pushl $0
c01030bd:	6a 00                	push   $0x0
  pushl $187
c01030bf:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01030c4:	e9 9e f8 ff ff       	jmp    c0102967 <__alltraps>

c01030c9 <vector188>:
.globl vector188
vector188:
  pushl $0
c01030c9:	6a 00                	push   $0x0
  pushl $188
c01030cb:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01030d0:	e9 92 f8 ff ff       	jmp    c0102967 <__alltraps>

c01030d5 <vector189>:
.globl vector189
vector189:
  pushl $0
c01030d5:	6a 00                	push   $0x0
  pushl $189
c01030d7:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01030dc:	e9 86 f8 ff ff       	jmp    c0102967 <__alltraps>

c01030e1 <vector190>:
.globl vector190
vector190:
  pushl $0
c01030e1:	6a 00                	push   $0x0
  pushl $190
c01030e3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01030e8:	e9 7a f8 ff ff       	jmp    c0102967 <__alltraps>

c01030ed <vector191>:
.globl vector191
vector191:
  pushl $0
c01030ed:	6a 00                	push   $0x0
  pushl $191
c01030ef:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01030f4:	e9 6e f8 ff ff       	jmp    c0102967 <__alltraps>

c01030f9 <vector192>:
.globl vector192
vector192:
  pushl $0
c01030f9:	6a 00                	push   $0x0
  pushl $192
c01030fb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0103100:	e9 62 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103105 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103105:	6a 00                	push   $0x0
  pushl $193
c0103107:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010310c:	e9 56 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103111 <vector194>:
.globl vector194
vector194:
  pushl $0
c0103111:	6a 00                	push   $0x0
  pushl $194
c0103113:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103118:	e9 4a f8 ff ff       	jmp    c0102967 <__alltraps>

c010311d <vector195>:
.globl vector195
vector195:
  pushl $0
c010311d:	6a 00                	push   $0x0
  pushl $195
c010311f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0103124:	e9 3e f8 ff ff       	jmp    c0102967 <__alltraps>

c0103129 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103129:	6a 00                	push   $0x0
  pushl $196
c010312b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0103130:	e9 32 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103135 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103135:	6a 00                	push   $0x0
  pushl $197
c0103137:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010313c:	e9 26 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103141 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103141:	6a 00                	push   $0x0
  pushl $198
c0103143:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103148:	e9 1a f8 ff ff       	jmp    c0102967 <__alltraps>

c010314d <vector199>:
.globl vector199
vector199:
  pushl $0
c010314d:	6a 00                	push   $0x0
  pushl $199
c010314f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103154:	e9 0e f8 ff ff       	jmp    c0102967 <__alltraps>

c0103159 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103159:	6a 00                	push   $0x0
  pushl $200
c010315b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103160:	e9 02 f8 ff ff       	jmp    c0102967 <__alltraps>

c0103165 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103165:	6a 00                	push   $0x0
  pushl $201
c0103167:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010316c:	e9 f6 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103171 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103171:	6a 00                	push   $0x0
  pushl $202
c0103173:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103178:	e9 ea f7 ff ff       	jmp    c0102967 <__alltraps>

c010317d <vector203>:
.globl vector203
vector203:
  pushl $0
c010317d:	6a 00                	push   $0x0
  pushl $203
c010317f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103184:	e9 de f7 ff ff       	jmp    c0102967 <__alltraps>

c0103189 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103189:	6a 00                	push   $0x0
  pushl $204
c010318b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103190:	e9 d2 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103195 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103195:	6a 00                	push   $0x0
  pushl $205
c0103197:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010319c:	e9 c6 f7 ff ff       	jmp    c0102967 <__alltraps>

c01031a1 <vector206>:
.globl vector206
vector206:
  pushl $0
c01031a1:	6a 00                	push   $0x0
  pushl $206
c01031a3:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01031a8:	e9 ba f7 ff ff       	jmp    c0102967 <__alltraps>

c01031ad <vector207>:
.globl vector207
vector207:
  pushl $0
c01031ad:	6a 00                	push   $0x0
  pushl $207
c01031af:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01031b4:	e9 ae f7 ff ff       	jmp    c0102967 <__alltraps>

c01031b9 <vector208>:
.globl vector208
vector208:
  pushl $0
c01031b9:	6a 00                	push   $0x0
  pushl $208
c01031bb:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01031c0:	e9 a2 f7 ff ff       	jmp    c0102967 <__alltraps>

c01031c5 <vector209>:
.globl vector209
vector209:
  pushl $0
c01031c5:	6a 00                	push   $0x0
  pushl $209
c01031c7:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01031cc:	e9 96 f7 ff ff       	jmp    c0102967 <__alltraps>

c01031d1 <vector210>:
.globl vector210
vector210:
  pushl $0
c01031d1:	6a 00                	push   $0x0
  pushl $210
c01031d3:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01031d8:	e9 8a f7 ff ff       	jmp    c0102967 <__alltraps>

c01031dd <vector211>:
.globl vector211
vector211:
  pushl $0
c01031dd:	6a 00                	push   $0x0
  pushl $211
c01031df:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01031e4:	e9 7e f7 ff ff       	jmp    c0102967 <__alltraps>

c01031e9 <vector212>:
.globl vector212
vector212:
  pushl $0
c01031e9:	6a 00                	push   $0x0
  pushl $212
c01031eb:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01031f0:	e9 72 f7 ff ff       	jmp    c0102967 <__alltraps>

c01031f5 <vector213>:
.globl vector213
vector213:
  pushl $0
c01031f5:	6a 00                	push   $0x0
  pushl $213
c01031f7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01031fc:	e9 66 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103201 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103201:	6a 00                	push   $0x0
  pushl $214
c0103203:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103208:	e9 5a f7 ff ff       	jmp    c0102967 <__alltraps>

c010320d <vector215>:
.globl vector215
vector215:
  pushl $0
c010320d:	6a 00                	push   $0x0
  pushl $215
c010320f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103214:	e9 4e f7 ff ff       	jmp    c0102967 <__alltraps>

c0103219 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103219:	6a 00                	push   $0x0
  pushl $216
c010321b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103220:	e9 42 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103225 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103225:	6a 00                	push   $0x0
  pushl $217
c0103227:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010322c:	e9 36 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103231 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103231:	6a 00                	push   $0x0
  pushl $218
c0103233:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103238:	e9 2a f7 ff ff       	jmp    c0102967 <__alltraps>

c010323d <vector219>:
.globl vector219
vector219:
  pushl $0
c010323d:	6a 00                	push   $0x0
  pushl $219
c010323f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103244:	e9 1e f7 ff ff       	jmp    c0102967 <__alltraps>

c0103249 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103249:	6a 00                	push   $0x0
  pushl $220
c010324b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103250:	e9 12 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103255 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103255:	6a 00                	push   $0x0
  pushl $221
c0103257:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010325c:	e9 06 f7 ff ff       	jmp    c0102967 <__alltraps>

c0103261 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103261:	6a 00                	push   $0x0
  pushl $222
c0103263:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103268:	e9 fa f6 ff ff       	jmp    c0102967 <__alltraps>

c010326d <vector223>:
.globl vector223
vector223:
  pushl $0
c010326d:	6a 00                	push   $0x0
  pushl $223
c010326f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103274:	e9 ee f6 ff ff       	jmp    c0102967 <__alltraps>

c0103279 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103279:	6a 00                	push   $0x0
  pushl $224
c010327b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103280:	e9 e2 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103285 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103285:	6a 00                	push   $0x0
  pushl $225
c0103287:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010328c:	e9 d6 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103291 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103291:	6a 00                	push   $0x0
  pushl $226
c0103293:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103298:	e9 ca f6 ff ff       	jmp    c0102967 <__alltraps>

c010329d <vector227>:
.globl vector227
vector227:
  pushl $0
c010329d:	6a 00                	push   $0x0
  pushl $227
c010329f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01032a4:	e9 be f6 ff ff       	jmp    c0102967 <__alltraps>

c01032a9 <vector228>:
.globl vector228
vector228:
  pushl $0
c01032a9:	6a 00                	push   $0x0
  pushl $228
c01032ab:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01032b0:	e9 b2 f6 ff ff       	jmp    c0102967 <__alltraps>

c01032b5 <vector229>:
.globl vector229
vector229:
  pushl $0
c01032b5:	6a 00                	push   $0x0
  pushl $229
c01032b7:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01032bc:	e9 a6 f6 ff ff       	jmp    c0102967 <__alltraps>

c01032c1 <vector230>:
.globl vector230
vector230:
  pushl $0
c01032c1:	6a 00                	push   $0x0
  pushl $230
c01032c3:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01032c8:	e9 9a f6 ff ff       	jmp    c0102967 <__alltraps>

c01032cd <vector231>:
.globl vector231
vector231:
  pushl $0
c01032cd:	6a 00                	push   $0x0
  pushl $231
c01032cf:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01032d4:	e9 8e f6 ff ff       	jmp    c0102967 <__alltraps>

c01032d9 <vector232>:
.globl vector232
vector232:
  pushl $0
c01032d9:	6a 00                	push   $0x0
  pushl $232
c01032db:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01032e0:	e9 82 f6 ff ff       	jmp    c0102967 <__alltraps>

c01032e5 <vector233>:
.globl vector233
vector233:
  pushl $0
c01032e5:	6a 00                	push   $0x0
  pushl $233
c01032e7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01032ec:	e9 76 f6 ff ff       	jmp    c0102967 <__alltraps>

c01032f1 <vector234>:
.globl vector234
vector234:
  pushl $0
c01032f1:	6a 00                	push   $0x0
  pushl $234
c01032f3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01032f8:	e9 6a f6 ff ff       	jmp    c0102967 <__alltraps>

c01032fd <vector235>:
.globl vector235
vector235:
  pushl $0
c01032fd:	6a 00                	push   $0x0
  pushl $235
c01032ff:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103304:	e9 5e f6 ff ff       	jmp    c0102967 <__alltraps>

c0103309 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103309:	6a 00                	push   $0x0
  pushl $236
c010330b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103310:	e9 52 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103315 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103315:	6a 00                	push   $0x0
  pushl $237
c0103317:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010331c:	e9 46 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103321 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103321:	6a 00                	push   $0x0
  pushl $238
c0103323:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103328:	e9 3a f6 ff ff       	jmp    c0102967 <__alltraps>

c010332d <vector239>:
.globl vector239
vector239:
  pushl $0
c010332d:	6a 00                	push   $0x0
  pushl $239
c010332f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103334:	e9 2e f6 ff ff       	jmp    c0102967 <__alltraps>

c0103339 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103339:	6a 00                	push   $0x0
  pushl $240
c010333b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103340:	e9 22 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103345 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103345:	6a 00                	push   $0x0
  pushl $241
c0103347:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010334c:	e9 16 f6 ff ff       	jmp    c0102967 <__alltraps>

c0103351 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103351:	6a 00                	push   $0x0
  pushl $242
c0103353:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103358:	e9 0a f6 ff ff       	jmp    c0102967 <__alltraps>

c010335d <vector243>:
.globl vector243
vector243:
  pushl $0
c010335d:	6a 00                	push   $0x0
  pushl $243
c010335f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103364:	e9 fe f5 ff ff       	jmp    c0102967 <__alltraps>

c0103369 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103369:	6a 00                	push   $0x0
  pushl $244
c010336b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103370:	e9 f2 f5 ff ff       	jmp    c0102967 <__alltraps>

c0103375 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103375:	6a 00                	push   $0x0
  pushl $245
c0103377:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010337c:	e9 e6 f5 ff ff       	jmp    c0102967 <__alltraps>

c0103381 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103381:	6a 00                	push   $0x0
  pushl $246
c0103383:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103388:	e9 da f5 ff ff       	jmp    c0102967 <__alltraps>

c010338d <vector247>:
.globl vector247
vector247:
  pushl $0
c010338d:	6a 00                	push   $0x0
  pushl $247
c010338f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103394:	e9 ce f5 ff ff       	jmp    c0102967 <__alltraps>

c0103399 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103399:	6a 00                	push   $0x0
  pushl $248
c010339b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01033a0:	e9 c2 f5 ff ff       	jmp    c0102967 <__alltraps>

c01033a5 <vector249>:
.globl vector249
vector249:
  pushl $0
c01033a5:	6a 00                	push   $0x0
  pushl $249
c01033a7:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01033ac:	e9 b6 f5 ff ff       	jmp    c0102967 <__alltraps>

c01033b1 <vector250>:
.globl vector250
vector250:
  pushl $0
c01033b1:	6a 00                	push   $0x0
  pushl $250
c01033b3:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01033b8:	e9 aa f5 ff ff       	jmp    c0102967 <__alltraps>

c01033bd <vector251>:
.globl vector251
vector251:
  pushl $0
c01033bd:	6a 00                	push   $0x0
  pushl $251
c01033bf:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01033c4:	e9 9e f5 ff ff       	jmp    c0102967 <__alltraps>

c01033c9 <vector252>:
.globl vector252
vector252:
  pushl $0
c01033c9:	6a 00                	push   $0x0
  pushl $252
c01033cb:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01033d0:	e9 92 f5 ff ff       	jmp    c0102967 <__alltraps>

c01033d5 <vector253>:
.globl vector253
vector253:
  pushl $0
c01033d5:	6a 00                	push   $0x0
  pushl $253
c01033d7:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01033dc:	e9 86 f5 ff ff       	jmp    c0102967 <__alltraps>

c01033e1 <vector254>:
.globl vector254
vector254:
  pushl $0
c01033e1:	6a 00                	push   $0x0
  pushl $254
c01033e3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01033e8:	e9 7a f5 ff ff       	jmp    c0102967 <__alltraps>

c01033ed <vector255>:
.globl vector255
vector255:
  pushl $0
c01033ed:	6a 00                	push   $0x0
  pushl $255
c01033ef:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01033f4:	e9 6e f5 ff ff       	jmp    c0102967 <__alltraps>

c01033f9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01033f9:	55                   	push   %ebp
c01033fa:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01033fc:	8b 55 08             	mov    0x8(%ebp),%edx
c01033ff:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0103404:	29 c2                	sub    %eax,%edx
c0103406:	89 d0                	mov    %edx,%eax
c0103408:	c1 f8 05             	sar    $0x5,%eax
}
c010340b:	5d                   	pop    %ebp
c010340c:	c3                   	ret    

c010340d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010340d:	55                   	push   %ebp
c010340e:	89 e5                	mov    %esp,%ebp
c0103410:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103413:	8b 45 08             	mov    0x8(%ebp),%eax
c0103416:	89 04 24             	mov    %eax,(%esp)
c0103419:	e8 db ff ff ff       	call   c01033f9 <page2ppn>
c010341e:	c1 e0 0c             	shl    $0xc,%eax
}
c0103421:	c9                   	leave  
c0103422:	c3                   	ret    

c0103423 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103423:	55                   	push   %ebp
c0103424:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103426:	8b 45 08             	mov    0x8(%ebp),%eax
c0103429:	8b 00                	mov    (%eax),%eax
}
c010342b:	5d                   	pop    %ebp
c010342c:	c3                   	ret    

c010342d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010342d:	55                   	push   %ebp
c010342e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103430:	8b 45 08             	mov    0x8(%ebp),%eax
c0103433:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103436:	89 10                	mov    %edx,(%eax)
}
c0103438:	5d                   	pop    %ebp
c0103439:	c3                   	ret    

c010343a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010343a:	55                   	push   %ebp
c010343b:	89 e5                	mov    %esp,%ebp
c010343d:	83 ec 10             	sub    $0x10,%esp
c0103440:	c7 45 fc c0 1a 12 c0 	movl   $0xc0121ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103447:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010344a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010344d:	89 50 04             	mov    %edx,0x4(%eax)
c0103450:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103453:	8b 50 04             	mov    0x4(%eax),%edx
c0103456:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103459:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010345b:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103462:	00 00 00 
}
c0103465:	c9                   	leave  
c0103466:	c3                   	ret    

c0103467 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103467:	55                   	push   %ebp
c0103468:	89 e5                	mov    %esp,%ebp
c010346a:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
c010346d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103471:	75 24                	jne    c0103497 <default_init_memmap+0x30>
c0103473:	c7 44 24 0c 70 96 10 	movl   $0xc0109670,0xc(%esp)
c010347a:	c0 
c010347b:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103482:	c0 
c0103483:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010348a:	00 
c010348b:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103492:	e8 38 d8 ff ff       	call   c0100ccf <__panic>
	struct Page *p = base;
c0103497:	8b 45 08             	mov    0x8(%ebp),%eax
c010349a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
c010349d:	e9 ef 00 00 00       	jmp    c0103591 <default_init_memmap+0x12a>
		assert(PageReserved(p));
c01034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034a5:	83 c0 04             	add    $0x4,%eax
c01034a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01034af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01034b8:	0f a3 10             	bt     %edx,(%eax)
c01034bb:	19 c0                	sbb    %eax,%eax
c01034bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01034c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01034c4:	0f 95 c0             	setne  %al
c01034c7:	0f b6 c0             	movzbl %al,%eax
c01034ca:	85 c0                	test   %eax,%eax
c01034cc:	75 24                	jne    c01034f2 <default_init_memmap+0x8b>
c01034ce:	c7 44 24 0c a1 96 10 	movl   $0xc01096a1,0xc(%esp)
c01034d5:	c0 
c01034d6:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01034dd:	c0 
c01034de:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01034e5:	00 
c01034e6:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01034ed:	e8 dd d7 ff ff       	call   c0100ccf <__panic>
		p->flags = 0;
c01034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c01034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ff:	83 c0 04             	add    $0x4,%eax
c0103502:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103509:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010350c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010350f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103512:	0f ab 10             	bts    %edx,(%eax)
		if(p == base)
c0103515:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103518:	3b 45 08             	cmp    0x8(%ebp),%eax
c010351b:	75 0b                	jne    c0103528 <default_init_memmap+0xc1>
		{
			p->property = n;
c010351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103520:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103523:	89 50 08             	mov    %edx,0x8(%eax)
c0103526:	eb 0a                	jmp    c0103532 <default_init_memmap+0xcb>
		}
		else
		{
			p->property = 0;
c0103528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		}
		set_page_ref(p, 0);
c0103532:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103539:	00 
c010353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353d:	89 04 24             	mov    %eax,(%esp)
c0103540:	e8 e8 fe ff ff       	call   c010342d <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
c0103545:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103548:	83 c0 0c             	add    $0xc,%eax
c010354b:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
c0103552:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103555:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103558:	8b 00                	mov    (%eax),%eax
c010355a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010355d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103560:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103563:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103566:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103569:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010356c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010356f:	89 10                	mov    %edx,(%eax)
c0103571:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103574:	8b 10                	mov    (%eax),%edx
c0103576:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103579:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010357f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103582:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103588:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010358b:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
c010358d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103594:	c1 e0 05             	shl    $0x5,%eax
c0103597:	89 c2                	mov    %eax,%edx
c0103599:	8b 45 08             	mov    0x8(%ebp),%eax
c010359c:	01 d0                	add    %edx,%eax
c010359e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01035a1:	0f 85 fb fe ff ff    	jne    c01034a2 <default_init_memmap+0x3b>
			p->property = 0;
		}
		set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
	}
	nr_free += n;
c01035a7:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c01035ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035b0:	01 d0                	add    %edx,%eax
c01035b2:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
}
c01035b7:	c9                   	leave  
c01035b8:	c3                   	ret    

c01035b9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01035b9:	55                   	push   %ebp
c01035ba:	89 e5                	mov    %esp,%ebp
c01035bc:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c01035bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01035c3:	75 24                	jne    c01035e9 <default_alloc_pages+0x30>
c01035c5:	c7 44 24 0c 70 96 10 	movl   $0xc0109670,0xc(%esp)
c01035cc:	c0 
c01035cd:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01035d4:	c0 
c01035d5:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c01035dc:	00 
c01035dd:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01035e4:	e8 e6 d6 ff ff       	call   c0100ccf <__panic>
	if (n > nr_free) {
c01035e9:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01035ee:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035f1:	73 0a                	jae    c01035fd <default_alloc_pages+0x44>
		return NULL;
c01035f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01035f8:	e9 45 01 00 00       	jmp    c0103742 <default_alloc_pages+0x189>
	}
	struct Page *page = NULL;
c01035fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	list_entry_t *tmp = NULL;
c0103604:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	list_entry_t *le = &free_list;
c010360b:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)
	while ((le = list_next(le)) != &free_list)
c0103612:	e9 0a 01 00 00       	jmp    c0103721 <default_alloc_pages+0x168>
	{
		struct Page *p = le2page(le, page_link);
c0103617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361a:	83 e8 0c             	sub    $0xc,%eax
c010361d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (p->property >= n)
c0103620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103623:	8b 40 08             	mov    0x8(%eax),%eax
c0103626:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103629:	0f 82 f2 00 00 00    	jb     c0103721 <default_alloc_pages+0x168>
		{
			int i;
			for(i = 0;i<n;i++)
c010362f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103636:	eb 7c                	jmp    c01036b4 <default_alloc_pages+0xfb>
c0103638:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010363b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010363e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103641:	8b 40 04             	mov    0x4(%eax),%eax
			{
				tmp = list_next(le);
c0103644:	89 45 e8             	mov    %eax,-0x18(%ebp)
				struct Page *pagetmp = le2page(le, page_link);
c0103647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010364a:	83 e8 0c             	sub    $0xc,%eax
c010364d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				SetPageReserved(pagetmp);
c0103650:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103653:	83 c0 04             	add    $0x4,%eax
c0103656:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c010365d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103663:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103666:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(pagetmp);
c0103669:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010366c:	83 c0 04             	add    $0x4,%eax
c010366f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103676:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103679:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010367c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010367f:	0f b3 10             	btr    %edx,(%eax)
c0103682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103685:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103688:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010368b:	8b 40 04             	mov    0x4(%eax),%eax
c010368e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103691:	8b 12                	mov    (%edx),%edx
c0103693:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0103696:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103699:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010369c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010369f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01036a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036a5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01036a8:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = tmp;
c01036aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		struct Page *p = le2page(le, page_link);
		if (p->property >= n)
		{
			int i;
			for(i = 0;i<n;i++)
c01036b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036ba:	0f 82 78 ff ff ff    	jb     c0103638 <default_alloc_pages+0x7f>
				SetPageReserved(pagetmp);
				ClearPageProperty(pagetmp);
				list_del(le);
				le = tmp;
			}
			if(p->property > n)
c01036c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c3:	8b 40 08             	mov    0x8(%eax),%eax
c01036c6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036c9:	76 12                	jbe    c01036dd <default_alloc_pages+0x124>
			{
				(le2page(le, page_link)->property) = p->property - n;
c01036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ce:	8d 50 f4             	lea    -0xc(%eax),%edx
c01036d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d4:	8b 40 08             	mov    0x8(%eax),%eax
c01036d7:	2b 45 08             	sub    0x8(%ebp),%eax
c01036da:	89 42 08             	mov    %eax,0x8(%edx)
			}
			SetPageReserved(p);
c01036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036e0:	83 c0 04             	add    $0x4,%eax
c01036e3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c01036ea:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036f0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01036f3:	0f ab 10             	bts    %edx,(%eax)
			ClearPageProperty(p);
c01036f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f9:	83 c0 04             	add    $0x4,%eax
c01036fc:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0103703:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103706:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103709:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010370c:	0f b3 10             	btr    %edx,(%eax)
			nr_free -= n;
c010370f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103714:	2b 45 08             	sub    0x8(%ebp),%eax
c0103717:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
			return p;
c010371c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010371f:	eb 21                	jmp    c0103742 <default_alloc_pages+0x189>
c0103721:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103724:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103727:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010372a:	8b 40 04             	mov    0x4(%eax),%eax
		return NULL;
	}
	struct Page *page = NULL;
	list_entry_t *tmp = NULL;
	list_entry_t *le = &free_list;
	while ((le = list_next(le)) != &free_list)
c010372d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103730:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c0103737:	0f 85 da fe ff ff    	jne    c0103617 <default_alloc_pages+0x5e>
			ClearPageProperty(p);
			nr_free -= n;
			return p;
		}
	}
	return NULL;
c010373d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103742:	c9                   	leave  
c0103743:	c3                   	ret    

c0103744 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103744:	55                   	push   %ebp
c0103745:	89 e5                	mov    %esp,%ebp
c0103747:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c010374a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010374e:	75 24                	jne    c0103774 <default_free_pages+0x30>
c0103750:	c7 44 24 0c 70 96 10 	movl   $0xc0109670,0xc(%esp)
c0103757:	c0 
c0103758:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c010375f:	c0 
c0103760:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0103767:	00 
c0103768:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c010376f:	e8 5b d5 ff ff       	call   c0100ccf <__panic>
	assert(PageReserved(base));
c0103774:	8b 45 08             	mov    0x8(%ebp),%eax
c0103777:	83 c0 04             	add    $0x4,%eax
c010377a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0103781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103787:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010378a:	0f a3 10             	bt     %edx,(%eax)
c010378d:	19 c0                	sbb    %eax,%eax
c010378f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0103792:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103796:	0f 95 c0             	setne  %al
c0103799:	0f b6 c0             	movzbl %al,%eax
c010379c:	85 c0                	test   %eax,%eax
c010379e:	75 24                	jne    c01037c4 <default_free_pages+0x80>
c01037a0:	c7 44 24 0c b1 96 10 	movl   $0xc01096b1,0xc(%esp)
c01037a7:	c0 
c01037a8:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01037af:	c0 
c01037b0:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c01037b7:	00 
c01037b8:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01037bf:	e8 0b d5 ff ff       	call   c0100ccf <__panic>
	list_entry_t *le = &free_list;
c01037c4:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)
	struct Page* p = NULL;
c01037cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((le = list_next(le)) != &free_list)
c01037d2:	eb 13                	jmp    c01037e7 <default_free_pages+0xa3>
	{
		p = le2page(le, page_link);
c01037d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d7:	83 e8 0c             	sub    $0xc,%eax
c01037da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(p > base)
c01037dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037e0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037e3:	76 02                	jbe    c01037e7 <default_free_pages+0xa3>
			break;
c01037e5:	eb 18                	jmp    c01037ff <default_free_pages+0xbb>
c01037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01037ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037f0:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
	assert(n > 0);
	assert(PageReserved(base));
	list_entry_t *le = &free_list;
	struct Page* p = NULL;
	while ((le = list_next(le)) != &free_list)
c01037f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037f6:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c01037fd:	75 d5                	jne    c01037d4 <default_free_pages+0x90>
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c01037ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103806:	eb 55                	jmp    c010385d <default_free_pages+0x119>
	{
		list_add_before(le, &((base + i)->page_link));
c0103808:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010380b:	c1 e0 05             	shl    $0x5,%eax
c010380e:	89 c2                	mov    %eax,%edx
c0103810:	8b 45 08             	mov    0x8(%ebp),%eax
c0103813:	01 d0                	add    %edx,%eax
c0103815:	8d 50 0c             	lea    0xc(%eax),%edx
c0103818:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010381b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010381e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103821:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103824:	8b 00                	mov    (%eax),%eax
c0103826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103829:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010382c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010382f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103832:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103835:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103838:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010383b:	89 10                	mov    %edx,(%eax)
c010383d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103840:	8b 10                	mov    (%eax),%edx
c0103842:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103845:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103848:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010384b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010384e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103851:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103854:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103857:	89 10                	mov    %edx,(%eax)
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c0103859:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010385d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103860:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103863:	72 a3                	jb     c0103808 <default_free_pages+0xc4>
	{
		list_add_before(le, &((base + i)->page_link));
	}
	base->flags = 0;
c0103865:	8b 45 08             	mov    0x8(%ebp),%eax
c0103868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	ClearPageProperty(base);
c010386f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103872:	83 c0 04             	add    $0x4,%eax
c0103875:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010387c:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010387f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103882:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103885:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
c0103888:	8b 45 08             	mov    0x8(%ebp),%eax
c010388b:	83 c0 04             	add    $0x4,%eax
c010388e:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0103895:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103898:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010389b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010389e:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
c01038a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038a8:	00 
c01038a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ac:	89 04 24             	mov    %eax,(%esp)
c01038af:	e8 79 fb ff ff       	call   c010342d <set_page_ref>
	base->property = n;
c01038b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01038ba:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le, page_link);
c01038bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038c0:	83 e8 0c             	sub    $0xc,%eax
c01038c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(base + n == p)
c01038c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038c9:	c1 e0 05             	shl    $0x5,%eax
c01038cc:	89 c2                	mov    %eax,%edx
c01038ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01038d1:	01 d0                	add    %edx,%eax
c01038d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038d6:	75 1b                	jne    c01038f3 <default_free_pages+0x1af>
	{
		base->property = n + p->property;
c01038d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038db:	8b 50 08             	mov    0x8(%eax),%edx
c01038de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038e1:	01 c2                	add    %eax,%edx
c01038e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e6:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c01038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
c01038f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01038f6:	83 c0 0c             	add    $0xc,%eax
c01038f9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01038fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01038ff:	8b 00                	mov    (%eax),%eax
c0103901:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
c0103904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103907:	83 e8 0c             	sub    $0xc,%eax
c010390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//below need to change
	if(le != &free_list && base - 1 == p)
c010390d:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c0103914:	74 57                	je     c010396d <default_free_pages+0x229>
c0103916:	8b 45 08             	mov    0x8(%ebp),%eax
c0103919:	83 e8 20             	sub    $0x20,%eax
c010391c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010391f:	75 4c                	jne    c010396d <default_free_pages+0x229>
	{
	  while(le!=&free_list){
c0103921:	eb 41                	jmp    c0103964 <default_free_pages+0x220>
		if(p->property){
c0103923:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103926:	8b 40 08             	mov    0x8(%eax),%eax
c0103929:	85 c0                	test   %eax,%eax
c010392b:	74 20                	je     c010394d <default_free_pages+0x209>
		  p->property += base->property;
c010392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103930:	8b 50 08             	mov    0x8(%eax),%edx
c0103933:	8b 45 08             	mov    0x8(%ebp),%eax
c0103936:	8b 40 08             	mov    0x8(%eax),%eax
c0103939:	01 c2                	add    %eax,%edx
c010393b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010393e:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
c0103941:	8b 45 08             	mov    0x8(%ebp),%eax
c0103944:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
c010394b:	eb 20                	jmp    c010396d <default_free_pages+0x229>
c010394d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103950:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103953:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103956:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
c0103958:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
c010395b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010395e:	83 e8 0c             	sub    $0xc,%eax
c0103961:	89 45 f0             	mov    %eax,-0x10(%ebp)
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	//below need to change
	if(le != &free_list && base - 1 == p)
	{
	  while(le!=&free_list){
c0103964:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c010396b:	75 b6                	jne    c0103923 <default_free_pages+0x1df>
		}
		le = list_prev(le);
		p = le2page(le,page_link);
	  }
	}
	nr_free += n;
c010396d:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c0103973:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103976:	01 d0                	add    %edx,%eax
c0103978:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
}
c010397d:	c9                   	leave  
c010397e:	c3                   	ret    

c010397f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010397f:	55                   	push   %ebp
c0103980:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103982:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
}
c0103987:	5d                   	pop    %ebp
c0103988:	c3                   	ret    

c0103989 <basic_check>:

static void
basic_check(void) {
c0103989:	55                   	push   %ebp
c010398a:	89 e5                	mov    %esp,%ebp
c010398c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010398f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103999:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010399c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010399f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01039a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039a9:	e8 bf 0e 00 00       	call   c010486d <alloc_pages>
c01039ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01039b5:	75 24                	jne    c01039db <basic_check+0x52>
c01039b7:	c7 44 24 0c c4 96 10 	movl   $0xc01096c4,0xc(%esp)
c01039be:	c0 
c01039bf:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01039c6:	c0 
c01039c7:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01039ce:	00 
c01039cf:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01039d6:	e8 f4 d2 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c01039db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039e2:	e8 86 0e 00 00       	call   c010486d <alloc_pages>
c01039e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039ee:	75 24                	jne    c0103a14 <basic_check+0x8b>
c01039f0:	c7 44 24 0c e0 96 10 	movl   $0xc01096e0,0xc(%esp)
c01039f7:	c0 
c01039f8:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01039ff:	c0 
c0103a00:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103a07:	00 
c0103a08:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103a0f:	e8 bb d2 ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103a14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a1b:	e8 4d 0e 00 00       	call   c010486d <alloc_pages>
c0103a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a27:	75 24                	jne    c0103a4d <basic_check+0xc4>
c0103a29:	c7 44 24 0c fc 96 10 	movl   $0xc01096fc,0xc(%esp)
c0103a30:	c0 
c0103a31:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103a38:	c0 
c0103a39:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103a40:	00 
c0103a41:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103a48:	e8 82 d2 ff ff       	call   c0100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a53:	74 10                	je     c0103a65 <basic_check+0xdc>
c0103a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a5b:	74 08                	je     c0103a65 <basic_check+0xdc>
c0103a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a60:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a63:	75 24                	jne    c0103a89 <basic_check+0x100>
c0103a65:	c7 44 24 0c 18 97 10 	movl   $0xc0109718,0xc(%esp)
c0103a6c:	c0 
c0103a6d:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103a74:	c0 
c0103a75:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103a7c:	00 
c0103a7d:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103a84:	e8 46 d2 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a8c:	89 04 24             	mov    %eax,(%esp)
c0103a8f:	e8 8f f9 ff ff       	call   c0103423 <page_ref>
c0103a94:	85 c0                	test   %eax,%eax
c0103a96:	75 1e                	jne    c0103ab6 <basic_check+0x12d>
c0103a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a9b:	89 04 24             	mov    %eax,(%esp)
c0103a9e:	e8 80 f9 ff ff       	call   c0103423 <page_ref>
c0103aa3:	85 c0                	test   %eax,%eax
c0103aa5:	75 0f                	jne    c0103ab6 <basic_check+0x12d>
c0103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aaa:	89 04 24             	mov    %eax,(%esp)
c0103aad:	e8 71 f9 ff ff       	call   c0103423 <page_ref>
c0103ab2:	85 c0                	test   %eax,%eax
c0103ab4:	74 24                	je     c0103ada <basic_check+0x151>
c0103ab6:	c7 44 24 0c 3c 97 10 	movl   $0xc010973c,0xc(%esp)
c0103abd:	c0 
c0103abe:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103ac5:	c0 
c0103ac6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103acd:	00 
c0103ace:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103ad5:	e8 f5 d1 ff ff       	call   c0100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103add:	89 04 24             	mov    %eax,(%esp)
c0103ae0:	e8 28 f9 ff ff       	call   c010340d <page2pa>
c0103ae5:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103aeb:	c1 e2 0c             	shl    $0xc,%edx
c0103aee:	39 d0                	cmp    %edx,%eax
c0103af0:	72 24                	jb     c0103b16 <basic_check+0x18d>
c0103af2:	c7 44 24 0c 78 97 10 	movl   $0xc0109778,0xc(%esp)
c0103af9:	c0 
c0103afa:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103b01:	c0 
c0103b02:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103b09:	00 
c0103b0a:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103b11:	e8 b9 d1 ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b19:	89 04 24             	mov    %eax,(%esp)
c0103b1c:	e8 ec f8 ff ff       	call   c010340d <page2pa>
c0103b21:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103b27:	c1 e2 0c             	shl    $0xc,%edx
c0103b2a:	39 d0                	cmp    %edx,%eax
c0103b2c:	72 24                	jb     c0103b52 <basic_check+0x1c9>
c0103b2e:	c7 44 24 0c 95 97 10 	movl   $0xc0109795,0xc(%esp)
c0103b35:	c0 
c0103b36:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103b3d:	c0 
c0103b3e:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103b45:	00 
c0103b46:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103b4d:	e8 7d d1 ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b55:	89 04 24             	mov    %eax,(%esp)
c0103b58:	e8 b0 f8 ff ff       	call   c010340d <page2pa>
c0103b5d:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103b63:	c1 e2 0c             	shl    $0xc,%edx
c0103b66:	39 d0                	cmp    %edx,%eax
c0103b68:	72 24                	jb     c0103b8e <basic_check+0x205>
c0103b6a:	c7 44 24 0c b2 97 10 	movl   $0xc01097b2,0xc(%esp)
c0103b71:	c0 
c0103b72:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103b79:	c0 
c0103b7a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103b81:	00 
c0103b82:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103b89:	e8 41 d1 ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c0103b8e:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103b93:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103b99:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103b9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103b9f:	c7 45 e0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ba6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103bac:	89 50 04             	mov    %edx,0x4(%eax)
c0103baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bb2:	8b 50 04             	mov    0x4(%eax),%edx
c0103bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bb8:	89 10                	mov    %edx,(%eax)
c0103bba:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103bc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bc4:	8b 40 04             	mov    0x4(%eax),%eax
c0103bc7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103bca:	0f 94 c0             	sete   %al
c0103bcd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103bd0:	85 c0                	test   %eax,%eax
c0103bd2:	75 24                	jne    c0103bf8 <basic_check+0x26f>
c0103bd4:	c7 44 24 0c cf 97 10 	movl   $0xc01097cf,0xc(%esp)
c0103bdb:	c0 
c0103bdc:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103be3:	c0 
c0103be4:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103beb:	00 
c0103bec:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103bf3:	e8 d7 d0 ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c0103bf8:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103bfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103c00:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103c07:	00 00 00 

    assert(alloc_page() == NULL);
c0103c0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c11:	e8 57 0c 00 00       	call   c010486d <alloc_pages>
c0103c16:	85 c0                	test   %eax,%eax
c0103c18:	74 24                	je     c0103c3e <basic_check+0x2b5>
c0103c1a:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c0103c21:	c0 
c0103c22:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103c29:	c0 
c0103c2a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103c31:	00 
c0103c32:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103c39:	e8 91 d0 ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c0103c3e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c45:	00 
c0103c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c49:	89 04 24             	mov    %eax,(%esp)
c0103c4c:	e8 87 0c 00 00       	call   c01048d8 <free_pages>
    free_page(p1);
c0103c51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c58:	00 
c0103c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c5c:	89 04 24             	mov    %eax,(%esp)
c0103c5f:	e8 74 0c 00 00       	call   c01048d8 <free_pages>
    free_page(p2);
c0103c64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c6b:	00 
c0103c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c6f:	89 04 24             	mov    %eax,(%esp)
c0103c72:	e8 61 0c 00 00       	call   c01048d8 <free_pages>
    assert(nr_free == 3);
c0103c77:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103c7c:	83 f8 03             	cmp    $0x3,%eax
c0103c7f:	74 24                	je     c0103ca5 <basic_check+0x31c>
c0103c81:	c7 44 24 0c fb 97 10 	movl   $0xc01097fb,0xc(%esp)
c0103c88:	c0 
c0103c89:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103c90:	c0 
c0103c91:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103c98:	00 
c0103c99:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103ca0:	e8 2a d0 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103ca5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cac:	e8 bc 0b 00 00       	call   c010486d <alloc_pages>
c0103cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103cb8:	75 24                	jne    c0103cde <basic_check+0x355>
c0103cba:	c7 44 24 0c c4 96 10 	movl   $0xc01096c4,0xc(%esp)
c0103cc1:	c0 
c0103cc2:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103cc9:	c0 
c0103cca:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103cd1:	00 
c0103cd2:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103cd9:	e8 f1 cf ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ce5:	e8 83 0b 00 00       	call   c010486d <alloc_pages>
c0103cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ced:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103cf1:	75 24                	jne    c0103d17 <basic_check+0x38e>
c0103cf3:	c7 44 24 0c e0 96 10 	movl   $0xc01096e0,0xc(%esp)
c0103cfa:	c0 
c0103cfb:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103d02:	c0 
c0103d03:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103d0a:	00 
c0103d0b:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103d12:	e8 b8 cf ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103d17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d1e:	e8 4a 0b 00 00       	call   c010486d <alloc_pages>
c0103d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d2a:	75 24                	jne    c0103d50 <basic_check+0x3c7>
c0103d2c:	c7 44 24 0c fc 96 10 	movl   $0xc01096fc,0xc(%esp)
c0103d33:	c0 
c0103d34:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103d3b:	c0 
c0103d3c:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103d43:	00 
c0103d44:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103d4b:	e8 7f cf ff ff       	call   c0100ccf <__panic>

    assert(alloc_page() == NULL);
c0103d50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d57:	e8 11 0b 00 00       	call   c010486d <alloc_pages>
c0103d5c:	85 c0                	test   %eax,%eax
c0103d5e:	74 24                	je     c0103d84 <basic_check+0x3fb>
c0103d60:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c0103d67:	c0 
c0103d68:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103d6f:	c0 
c0103d70:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103d77:	00 
c0103d78:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103d7f:	e8 4b cf ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c0103d84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d8b:	00 
c0103d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d8f:	89 04 24             	mov    %eax,(%esp)
c0103d92:	e8 41 0b 00 00       	call   c01048d8 <free_pages>
c0103d97:	c7 45 d8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x28(%ebp)
c0103d9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103da1:	8b 40 04             	mov    0x4(%eax),%eax
c0103da4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103da7:	0f 94 c0             	sete   %al
c0103daa:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103dad:	85 c0                	test   %eax,%eax
c0103daf:	74 24                	je     c0103dd5 <basic_check+0x44c>
c0103db1:	c7 44 24 0c 08 98 10 	movl   $0xc0109808,0xc(%esp)
c0103db8:	c0 
c0103db9:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103dc0:	c0 
c0103dc1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103dc8:	00 
c0103dc9:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103dd0:	e8 fa ce ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ddc:	e8 8c 0a 00 00       	call   c010486d <alloc_pages>
c0103de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103de7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103dea:	74 24                	je     c0103e10 <basic_check+0x487>
c0103dec:	c7 44 24 0c 20 98 10 	movl   $0xc0109820,0xc(%esp)
c0103df3:	c0 
c0103df4:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103dfb:	c0 
c0103dfc:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103e03:	00 
c0103e04:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103e0b:	e8 bf ce ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0103e10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e17:	e8 51 0a 00 00       	call   c010486d <alloc_pages>
c0103e1c:	85 c0                	test   %eax,%eax
c0103e1e:	74 24                	je     c0103e44 <basic_check+0x4bb>
c0103e20:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c0103e27:	c0 
c0103e28:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103e2f:	c0 
c0103e30:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103e37:	00 
c0103e38:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103e3f:	e8 8b ce ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c0103e44:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103e49:	85 c0                	test   %eax,%eax
c0103e4b:	74 24                	je     c0103e71 <basic_check+0x4e8>
c0103e4d:	c7 44 24 0c 39 98 10 	movl   $0xc0109839,0xc(%esp)
c0103e54:	c0 
c0103e55:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103e5c:	c0 
c0103e5d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103e64:	00 
c0103e65:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103e6c:	e8 5e ce ff ff       	call   c0100ccf <__panic>
    free_list = free_list_store;
c0103e71:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e77:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0103e7c:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    nr_free = nr_free_store;
c0103e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e85:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_page(p);
c0103e8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e91:	00 
c0103e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e95:	89 04 24             	mov    %eax,(%esp)
c0103e98:	e8 3b 0a 00 00       	call   c01048d8 <free_pages>
    free_page(p1);
c0103e9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ea4:	00 
c0103ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ea8:	89 04 24             	mov    %eax,(%esp)
c0103eab:	e8 28 0a 00 00       	call   c01048d8 <free_pages>
    free_page(p2);
c0103eb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103eb7:	00 
c0103eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ebb:	89 04 24             	mov    %eax,(%esp)
c0103ebe:	e8 15 0a 00 00       	call   c01048d8 <free_pages>
}
c0103ec3:	c9                   	leave  
c0103ec4:	c3                   	ret    

c0103ec5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103ec5:	55                   	push   %ebp
c0103ec6:	89 e5                	mov    %esp,%ebp
c0103ec8:	53                   	push   %ebx
c0103ec9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103ecf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ed6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103edd:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ee4:	eb 6b                	jmp    c0103f51 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ee9:	83 e8 0c             	sub    $0xc,%eax
c0103eec:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ef2:	83 c0 04             	add    $0x4,%eax
c0103ef5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103efc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103eff:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103f02:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f05:	0f a3 10             	bt     %edx,(%eax)
c0103f08:	19 c0                	sbb    %eax,%eax
c0103f0a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103f0d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103f11:	0f 95 c0             	setne  %al
c0103f14:	0f b6 c0             	movzbl %al,%eax
c0103f17:	85 c0                	test   %eax,%eax
c0103f19:	75 24                	jne    c0103f3f <default_check+0x7a>
c0103f1b:	c7 44 24 0c 46 98 10 	movl   $0xc0109846,0xc(%esp)
c0103f22:	c0 
c0103f23:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103f2a:	c0 
c0103f2b:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103f32:	00 
c0103f33:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103f3a:	e8 90 cd ff ff       	call   c0100ccf <__panic>
        count ++, total += p->property;
c0103f3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f46:	8b 50 08             	mov    0x8(%eax),%edx
c0103f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f4c:	01 d0                	add    %edx,%eax
c0103f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f54:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103f57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f5a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103f5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f60:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c0103f67:	0f 85 79 ff ff ff    	jne    c0103ee6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103f6d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103f70:	e8 95 09 00 00       	call   c010490a <nr_free_pages>
c0103f75:	39 c3                	cmp    %eax,%ebx
c0103f77:	74 24                	je     c0103f9d <default_check+0xd8>
c0103f79:	c7 44 24 0c 56 98 10 	movl   $0xc0109856,0xc(%esp)
c0103f80:	c0 
c0103f81:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103f88:	c0 
c0103f89:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103f90:	00 
c0103f91:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103f98:	e8 32 cd ff ff       	call   c0100ccf <__panic>

    basic_check();
c0103f9d:	e8 e7 f9 ff ff       	call   c0103989 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103fa2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103fa9:	e8 bf 08 00 00       	call   c010486d <alloc_pages>
c0103fae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103fb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fb5:	75 24                	jne    c0103fdb <default_check+0x116>
c0103fb7:	c7 44 24 0c 6f 98 10 	movl   $0xc010986f,0xc(%esp)
c0103fbe:	c0 
c0103fbf:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0103fc6:	c0 
c0103fc7:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103fce:	00 
c0103fcf:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0103fd6:	e8 f4 cc ff ff       	call   c0100ccf <__panic>
    assert(!PageProperty(p0));
c0103fdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fde:	83 c0 04             	add    $0x4,%eax
c0103fe1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103fe8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103feb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103fee:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ff1:	0f a3 10             	bt     %edx,(%eax)
c0103ff4:	19 c0                	sbb    %eax,%eax
c0103ff6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103ff9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ffd:	0f 95 c0             	setne  %al
c0104000:	0f b6 c0             	movzbl %al,%eax
c0104003:	85 c0                	test   %eax,%eax
c0104005:	74 24                	je     c010402b <default_check+0x166>
c0104007:	c7 44 24 0c 7a 98 10 	movl   $0xc010987a,0xc(%esp)
c010400e:	c0 
c010400f:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104016:	c0 
c0104017:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010401e:	00 
c010401f:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104026:	e8 a4 cc ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c010402b:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0104030:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0104036:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104039:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010403c:	c7 45 b4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104043:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104046:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104049:	89 50 04             	mov    %edx,0x4(%eax)
c010404c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010404f:	8b 50 04             	mov    0x4(%eax),%edx
c0104052:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104055:	89 10                	mov    %edx,(%eax)
c0104057:	c7 45 b0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010405e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104061:	8b 40 04             	mov    0x4(%eax),%eax
c0104064:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104067:	0f 94 c0             	sete   %al
c010406a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010406d:	85 c0                	test   %eax,%eax
c010406f:	75 24                	jne    c0104095 <default_check+0x1d0>
c0104071:	c7 44 24 0c cf 97 10 	movl   $0xc01097cf,0xc(%esp)
c0104078:	c0 
c0104079:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104080:	c0 
c0104081:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104088:	00 
c0104089:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104090:	e8 3a cc ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0104095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010409c:	e8 cc 07 00 00       	call   c010486d <alloc_pages>
c01040a1:	85 c0                	test   %eax,%eax
c01040a3:	74 24                	je     c01040c9 <default_check+0x204>
c01040a5:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c01040ac:	c0 
c01040ad:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01040b4:	c0 
c01040b5:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01040bc:	00 
c01040bd:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01040c4:	e8 06 cc ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c01040c9:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01040ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01040d1:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01040d8:	00 00 00 

    free_pages(p0 + 2, 3);
c01040db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040de:	83 c0 40             	add    $0x40,%eax
c01040e1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040e8:	00 
c01040e9:	89 04 24             	mov    %eax,(%esp)
c01040ec:	e8 e7 07 00 00       	call   c01048d8 <free_pages>
    assert(alloc_pages(4) == NULL);
c01040f1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01040f8:	e8 70 07 00 00       	call   c010486d <alloc_pages>
c01040fd:	85 c0                	test   %eax,%eax
c01040ff:	74 24                	je     c0104125 <default_check+0x260>
c0104101:	c7 44 24 0c 8c 98 10 	movl   $0xc010988c,0xc(%esp)
c0104108:	c0 
c0104109:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104110:	c0 
c0104111:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104118:	00 
c0104119:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104120:	e8 aa cb ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104128:	83 c0 40             	add    $0x40,%eax
c010412b:	83 c0 04             	add    $0x4,%eax
c010412e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104135:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104138:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010413b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010413e:	0f a3 10             	bt     %edx,(%eax)
c0104141:	19 c0                	sbb    %eax,%eax
c0104143:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104146:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010414a:	0f 95 c0             	setne  %al
c010414d:	0f b6 c0             	movzbl %al,%eax
c0104150:	85 c0                	test   %eax,%eax
c0104152:	74 0e                	je     c0104162 <default_check+0x29d>
c0104154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104157:	83 c0 40             	add    $0x40,%eax
c010415a:	8b 40 08             	mov    0x8(%eax),%eax
c010415d:	83 f8 03             	cmp    $0x3,%eax
c0104160:	74 24                	je     c0104186 <default_check+0x2c1>
c0104162:	c7 44 24 0c a4 98 10 	movl   $0xc01098a4,0xc(%esp)
c0104169:	c0 
c010416a:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104171:	c0 
c0104172:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104179:	00 
c010417a:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104181:	e8 49 cb ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104186:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010418d:	e8 db 06 00 00       	call   c010486d <alloc_pages>
c0104192:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104195:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104199:	75 24                	jne    c01041bf <default_check+0x2fa>
c010419b:	c7 44 24 0c d0 98 10 	movl   $0xc01098d0,0xc(%esp)
c01041a2:	c0 
c01041a3:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01041aa:	c0 
c01041ab:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041b2:	00 
c01041b3:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01041ba:	e8 10 cb ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01041bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041c6:	e8 a2 06 00 00       	call   c010486d <alloc_pages>
c01041cb:	85 c0                	test   %eax,%eax
c01041cd:	74 24                	je     c01041f3 <default_check+0x32e>
c01041cf:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c01041d6:	c0 
c01041d7:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01041de:	c0 
c01041df:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01041e6:	00 
c01041e7:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01041ee:	e8 dc ca ff ff       	call   c0100ccf <__panic>
    assert(p0 + 2 == p1);
c01041f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041f6:	83 c0 40             	add    $0x40,%eax
c01041f9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041fc:	74 24                	je     c0104222 <default_check+0x35d>
c01041fe:	c7 44 24 0c ee 98 10 	movl   $0xc01098ee,0xc(%esp)
c0104205:	c0 
c0104206:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c010420d:	c0 
c010420e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104215:	00 
c0104216:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c010421d:	e8 ad ca ff ff       	call   c0100ccf <__panic>

    p2 = p0 + 1;
c0104222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104225:	83 c0 20             	add    $0x20,%eax
c0104228:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010422b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104232:	00 
c0104233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104236:	89 04 24             	mov    %eax,(%esp)
c0104239:	e8 9a 06 00 00       	call   c01048d8 <free_pages>
    free_pages(p1, 3);
c010423e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104245:	00 
c0104246:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104249:	89 04 24             	mov    %eax,(%esp)
c010424c:	e8 87 06 00 00       	call   c01048d8 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104254:	83 c0 04             	add    $0x4,%eax
c0104257:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010425e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104261:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104264:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104267:	0f a3 10             	bt     %edx,(%eax)
c010426a:	19 c0                	sbb    %eax,%eax
c010426c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010426f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104273:	0f 95 c0             	setne  %al
c0104276:	0f b6 c0             	movzbl %al,%eax
c0104279:	85 c0                	test   %eax,%eax
c010427b:	74 0b                	je     c0104288 <default_check+0x3c3>
c010427d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104280:	8b 40 08             	mov    0x8(%eax),%eax
c0104283:	83 f8 01             	cmp    $0x1,%eax
c0104286:	74 24                	je     c01042ac <default_check+0x3e7>
c0104288:	c7 44 24 0c fc 98 10 	movl   $0xc01098fc,0xc(%esp)
c010428f:	c0 
c0104290:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104297:	c0 
c0104298:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010429f:	00 
c01042a0:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01042a7:	e8 23 ca ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01042ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042af:	83 c0 04             	add    $0x4,%eax
c01042b2:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01042b9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042bc:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042bf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042c2:	0f a3 10             	bt     %edx,(%eax)
c01042c5:	19 c0                	sbb    %eax,%eax
c01042c7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01042ca:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01042ce:	0f 95 c0             	setne  %al
c01042d1:	0f b6 c0             	movzbl %al,%eax
c01042d4:	85 c0                	test   %eax,%eax
c01042d6:	74 0b                	je     c01042e3 <default_check+0x41e>
c01042d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042db:	8b 40 08             	mov    0x8(%eax),%eax
c01042de:	83 f8 03             	cmp    $0x3,%eax
c01042e1:	74 24                	je     c0104307 <default_check+0x442>
c01042e3:	c7 44 24 0c 24 99 10 	movl   $0xc0109924,0xc(%esp)
c01042ea:	c0 
c01042eb:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01042f2:	c0 
c01042f3:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01042fa:	00 
c01042fb:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104302:	e8 c8 c9 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010430e:	e8 5a 05 00 00       	call   c010486d <alloc_pages>
c0104313:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104316:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104319:	83 e8 20             	sub    $0x20,%eax
c010431c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010431f:	74 24                	je     c0104345 <default_check+0x480>
c0104321:	c7 44 24 0c 4a 99 10 	movl   $0xc010994a,0xc(%esp)
c0104328:	c0 
c0104329:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104330:	c0 
c0104331:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104338:	00 
c0104339:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104340:	e8 8a c9 ff ff       	call   c0100ccf <__panic>
    free_page(p0);
c0104345:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010434c:	00 
c010434d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104350:	89 04 24             	mov    %eax,(%esp)
c0104353:	e8 80 05 00 00       	call   c01048d8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104358:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010435f:	e8 09 05 00 00       	call   c010486d <alloc_pages>
c0104364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104367:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010436a:	83 c0 20             	add    $0x20,%eax
c010436d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104370:	74 24                	je     c0104396 <default_check+0x4d1>
c0104372:	c7 44 24 0c 68 99 10 	movl   $0xc0109968,0xc(%esp)
c0104379:	c0 
c010437a:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104381:	c0 
c0104382:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0104389:	00 
c010438a:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104391:	e8 39 c9 ff ff       	call   c0100ccf <__panic>

    free_pages(p0, 2);
c0104396:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010439d:	00 
c010439e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043a1:	89 04 24             	mov    %eax,(%esp)
c01043a4:	e8 2f 05 00 00       	call   c01048d8 <free_pages>
    free_page(p2);
c01043a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043b0:	00 
c01043b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043b4:	89 04 24             	mov    %eax,(%esp)
c01043b7:	e8 1c 05 00 00       	call   c01048d8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01043bc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01043c3:	e8 a5 04 00 00       	call   c010486d <alloc_pages>
c01043c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043cf:	75 24                	jne    c01043f5 <default_check+0x530>
c01043d1:	c7 44 24 0c 88 99 10 	movl   $0xc0109988,0xc(%esp)
c01043d8:	c0 
c01043d9:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01043e0:	c0 
c01043e1:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01043e8:	00 
c01043e9:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01043f0:	e8 da c8 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01043f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043fc:	e8 6c 04 00 00       	call   c010486d <alloc_pages>
c0104401:	85 c0                	test   %eax,%eax
c0104403:	74 24                	je     c0104429 <default_check+0x564>
c0104405:	c7 44 24 0c e6 97 10 	movl   $0xc01097e6,0xc(%esp)
c010440c:	c0 
c010440d:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104414:	c0 
c0104415:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010441c:	00 
c010441d:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104424:	e8 a6 c8 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c0104429:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010442e:	85 c0                	test   %eax,%eax
c0104430:	74 24                	je     c0104456 <default_check+0x591>
c0104432:	c7 44 24 0c 39 98 10 	movl   $0xc0109839,0xc(%esp)
c0104439:	c0 
c010443a:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c0104441:	c0 
c0104442:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0104449:	00 
c010444a:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c0104451:	e8 79 c8 ff ff       	call   c0100ccf <__panic>
    nr_free = nr_free_store;
c0104456:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104459:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_list = free_list_store;
c010445e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104461:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104464:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0104469:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    free_pages(p0, 5);
c010446f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104476:	00 
c0104477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010447a:	89 04 24             	mov    %eax,(%esp)
c010447d:	e8 56 04 00 00       	call   c01048d8 <free_pages>

    le = &free_list;
c0104482:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104489:	eb 1d                	jmp    c01044a8 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010448b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010448e:	83 e8 0c             	sub    $0xc,%eax
c0104491:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104494:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104498:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010449b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010449e:	8b 40 08             	mov    0x8(%eax),%eax
c01044a1:	29 c2                	sub    %eax,%edx
c01044a3:	89 d0                	mov    %edx,%eax
c01044a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044ab:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01044ae:	8b 45 88             	mov    -0x78(%ebp),%eax
c01044b1:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01044b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044b7:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c01044be:	75 cb                	jne    c010448b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01044c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044c4:	74 24                	je     c01044ea <default_check+0x625>
c01044c6:	c7 44 24 0c a6 99 10 	movl   $0xc01099a6,0xc(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01044d5:	c0 
c01044d6:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01044dd:	00 
c01044de:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01044e5:	e8 e5 c7 ff ff       	call   c0100ccf <__panic>
    assert(total == 0);
c01044ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044ee:	74 24                	je     c0104514 <default_check+0x64f>
c01044f0:	c7 44 24 0c b1 99 10 	movl   $0xc01099b1,0xc(%esp)
c01044f7:	c0 
c01044f8:	c7 44 24 08 76 96 10 	movl   $0xc0109676,0x8(%esp)
c01044ff:	c0 
c0104500:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0104507:	00 
c0104508:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c010450f:	e8 bb c7 ff ff       	call   c0100ccf <__panic>
}
c0104514:	81 c4 94 00 00 00    	add    $0x94,%esp
c010451a:	5b                   	pop    %ebx
c010451b:	5d                   	pop    %ebp
c010451c:	c3                   	ret    

c010451d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010451d:	55                   	push   %ebp
c010451e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104520:	8b 55 08             	mov    0x8(%ebp),%edx
c0104523:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104528:	29 c2                	sub    %eax,%edx
c010452a:	89 d0                	mov    %edx,%eax
c010452c:	c1 f8 05             	sar    $0x5,%eax
}
c010452f:	5d                   	pop    %ebp
c0104530:	c3                   	ret    

c0104531 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104531:	55                   	push   %ebp
c0104532:	89 e5                	mov    %esp,%ebp
c0104534:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104537:	8b 45 08             	mov    0x8(%ebp),%eax
c010453a:	89 04 24             	mov    %eax,(%esp)
c010453d:	e8 db ff ff ff       	call   c010451d <page2ppn>
c0104542:	c1 e0 0c             	shl    $0xc,%eax
}
c0104545:	c9                   	leave  
c0104546:	c3                   	ret    

c0104547 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104547:	55                   	push   %ebp
c0104548:	89 e5                	mov    %esp,%ebp
c010454a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	c1 e8 0c             	shr    $0xc,%eax
c0104553:	89 c2                	mov    %eax,%edx
c0104555:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010455a:	39 c2                	cmp    %eax,%edx
c010455c:	72 1c                	jb     c010457a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010455e:	c7 44 24 08 ec 99 10 	movl   $0xc01099ec,0x8(%esp)
c0104565:	c0 
c0104566:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010456d:	00 
c010456e:	c7 04 24 0b 9a 10 c0 	movl   $0xc0109a0b,(%esp)
c0104575:	e8 55 c7 ff ff       	call   c0100ccf <__panic>
    }
    return &pages[PPN(pa)];
c010457a:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010457f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104582:	c1 ea 0c             	shr    $0xc,%edx
c0104585:	c1 e2 05             	shl    $0x5,%edx
c0104588:	01 d0                	add    %edx,%eax
}
c010458a:	c9                   	leave  
c010458b:	c3                   	ret    

c010458c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010458c:	55                   	push   %ebp
c010458d:	89 e5                	mov    %esp,%ebp
c010458f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104592:	8b 45 08             	mov    0x8(%ebp),%eax
c0104595:	89 04 24             	mov    %eax,(%esp)
c0104598:	e8 94 ff ff ff       	call   c0104531 <page2pa>
c010459d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a3:	c1 e8 0c             	shr    $0xc,%eax
c01045a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045a9:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01045ae:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01045b1:	72 23                	jb     c01045d6 <page2kva+0x4a>
c01045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045ba:	c7 44 24 08 1c 9a 10 	movl   $0xc0109a1c,0x8(%esp)
c01045c1:	c0 
c01045c2:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01045c9:	00 
c01045ca:	c7 04 24 0b 9a 10 c0 	movl   $0xc0109a0b,(%esp)
c01045d1:	e8 f9 c6 ff ff       	call   c0100ccf <__panic>
c01045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01045de:	c9                   	leave  
c01045df:	c3                   	ret    

c01045e0 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01045e0:	55                   	push   %ebp
c01045e1:	89 e5                	mov    %esp,%ebp
c01045e3:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01045e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045ec:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045f3:	77 23                	ja     c0104618 <kva2page+0x38>
c01045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045fc:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c0104603:	c0 
c0104604:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010460b:	00 
c010460c:	c7 04 24 0b 9a 10 c0 	movl   $0xc0109a0b,(%esp)
c0104613:	e8 b7 c6 ff ff       	call   c0100ccf <__panic>
c0104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104620:	89 04 24             	mov    %eax,(%esp)
c0104623:	e8 1f ff ff ff       	call   c0104547 <pa2page>
}
c0104628:	c9                   	leave  
c0104629:	c3                   	ret    

c010462a <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c010462a:	55                   	push   %ebp
c010462b:	89 e5                	mov    %esp,%ebp
c010462d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104630:	8b 45 08             	mov    0x8(%ebp),%eax
c0104633:	83 e0 01             	and    $0x1,%eax
c0104636:	85 c0                	test   %eax,%eax
c0104638:	75 1c                	jne    c0104656 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010463a:	c7 44 24 08 64 9a 10 	movl   $0xc0109a64,0x8(%esp)
c0104641:	c0 
c0104642:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104649:	00 
c010464a:	c7 04 24 0b 9a 10 c0 	movl   $0xc0109a0b,(%esp)
c0104651:	e8 79 c6 ff ff       	call   c0100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104656:	8b 45 08             	mov    0x8(%ebp),%eax
c0104659:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010465e:	89 04 24             	mov    %eax,(%esp)
c0104661:	e8 e1 fe ff ff       	call   c0104547 <pa2page>
}
c0104666:	c9                   	leave  
c0104667:	c3                   	ret    

c0104668 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104668:	55                   	push   %ebp
c0104669:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010466b:	8b 45 08             	mov    0x8(%ebp),%eax
c010466e:	8b 00                	mov    (%eax),%eax
}
c0104670:	5d                   	pop    %ebp
c0104671:	c3                   	ret    

c0104672 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104672:	55                   	push   %ebp
c0104673:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104675:	8b 45 08             	mov    0x8(%ebp),%eax
c0104678:	8b 55 0c             	mov    0xc(%ebp),%edx
c010467b:	89 10                	mov    %edx,(%eax)
}
c010467d:	5d                   	pop    %ebp
c010467e:	c3                   	ret    

c010467f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010467f:	55                   	push   %ebp
c0104680:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104682:	8b 45 08             	mov    0x8(%ebp),%eax
c0104685:	8b 00                	mov    (%eax),%eax
c0104687:	8d 50 01             	lea    0x1(%eax),%edx
c010468a:	8b 45 08             	mov    0x8(%ebp),%eax
c010468d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010468f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104692:	8b 00                	mov    (%eax),%eax
}
c0104694:	5d                   	pop    %ebp
c0104695:	c3                   	ret    

c0104696 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104696:	55                   	push   %ebp
c0104697:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104699:	8b 45 08             	mov    0x8(%ebp),%eax
c010469c:	8b 00                	mov    (%eax),%eax
c010469e:	8d 50 ff             	lea    -0x1(%eax),%edx
c01046a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a4:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01046a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a9:	8b 00                	mov    (%eax),%eax
}
c01046ab:	5d                   	pop    %ebp
c01046ac:	c3                   	ret    

c01046ad <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01046ad:	55                   	push   %ebp
c01046ae:	89 e5                	mov    %esp,%ebp
c01046b0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01046b3:	9c                   	pushf  
c01046b4:	58                   	pop    %eax
c01046b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01046bb:	25 00 02 00 00       	and    $0x200,%eax
c01046c0:	85 c0                	test   %eax,%eax
c01046c2:	74 0c                	je     c01046d0 <__intr_save+0x23>
        intr_disable();
c01046c4:	e8 5e d8 ff ff       	call   c0101f27 <intr_disable>
        return 1;
c01046c9:	b8 01 00 00 00       	mov    $0x1,%eax
c01046ce:	eb 05                	jmp    c01046d5 <__intr_save+0x28>
    }
    return 0;
c01046d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046d5:	c9                   	leave  
c01046d6:	c3                   	ret    

c01046d7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01046d7:	55                   	push   %ebp
c01046d8:	89 e5                	mov    %esp,%ebp
c01046da:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01046dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01046e1:	74 05                	je     c01046e8 <__intr_restore+0x11>
        intr_enable();
c01046e3:	e8 39 d8 ff ff       	call   c0101f21 <intr_enable>
    }
}
c01046e8:	c9                   	leave  
c01046e9:	c3                   	ret    

c01046ea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01046ea:	55                   	push   %ebp
c01046eb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01046ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01046f0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01046f3:	b8 23 00 00 00       	mov    $0x23,%eax
c01046f8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01046fa:	b8 23 00 00 00       	mov    $0x23,%eax
c01046ff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104701:	b8 10 00 00 00       	mov    $0x10,%eax
c0104706:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104708:	b8 10 00 00 00       	mov    $0x10,%eax
c010470d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c010470f:	b8 10 00 00 00       	mov    $0x10,%eax
c0104714:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104716:	ea 1d 47 10 c0 08 00 	ljmp   $0x8,$0xc010471d
}
c010471d:	5d                   	pop    %ebp
c010471e:	c3                   	ret    

c010471f <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c010471f:	55                   	push   %ebp
c0104720:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104722:	8b 45 08             	mov    0x8(%ebp),%eax
c0104725:	a3 44 1a 12 c0       	mov    %eax,0xc0121a44
}
c010472a:	5d                   	pop    %ebp
c010472b:	c3                   	ret    

c010472c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c010472c:	55                   	push   %ebp
c010472d:	89 e5                	mov    %esp,%ebp
c010472f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104732:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0104737:	89 04 24             	mov    %eax,(%esp)
c010473a:	e8 e0 ff ff ff       	call   c010471f <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c010473f:	66 c7 05 48 1a 12 c0 	movw   $0x10,0xc0121a48
c0104746:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104748:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c010474f:	68 00 
c0104751:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104756:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c010475c:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104761:	c1 e8 10             	shr    $0x10,%eax
c0104764:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0104769:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104770:	83 e0 f0             	and    $0xfffffff0,%eax
c0104773:	83 c8 09             	or     $0x9,%eax
c0104776:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010477b:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104782:	83 e0 ef             	and    $0xffffffef,%eax
c0104785:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010478a:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104791:	83 e0 9f             	and    $0xffffff9f,%eax
c0104794:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104799:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c01047a0:	83 c8 80             	or     $0xffffff80,%eax
c01047a3:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c01047a8:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01047af:	83 e0 f0             	and    $0xfffffff0,%eax
c01047b2:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01047b7:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01047be:	83 e0 ef             	and    $0xffffffef,%eax
c01047c1:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01047c6:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01047cd:	83 e0 df             	and    $0xffffffdf,%eax
c01047d0:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01047d5:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01047dc:	83 c8 40             	or     $0x40,%eax
c01047df:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01047e4:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01047eb:	83 e0 7f             	and    $0x7f,%eax
c01047ee:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01047f3:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c01047f8:	c1 e8 18             	shr    $0x18,%eax
c01047fb:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104800:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c0104807:	e8 de fe ff ff       	call   c01046ea <lgdt>
c010480c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104812:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104816:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104819:	c9                   	leave  
c010481a:	c3                   	ret    

c010481b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010481b:	55                   	push   %ebp
c010481c:	89 e5                	mov    %esp,%ebp
c010481e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104821:	c7 05 cc 1a 12 c0 d0 	movl   $0xc01099d0,0xc0121acc
c0104828:	99 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010482b:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104830:	8b 00                	mov    (%eax),%eax
c0104832:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104836:	c7 04 24 90 9a 10 c0 	movl   $0xc0109a90,(%esp)
c010483d:	e8 09 bb ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c0104842:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104847:	8b 40 04             	mov    0x4(%eax),%eax
c010484a:	ff d0                	call   *%eax
}
c010484c:	c9                   	leave  
c010484d:	c3                   	ret    

c010484e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010484e:	55                   	push   %ebp
c010484f:	89 e5                	mov    %esp,%ebp
c0104851:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104854:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104859:	8b 40 08             	mov    0x8(%eax),%eax
c010485c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010485f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104863:	8b 55 08             	mov    0x8(%ebp),%edx
c0104866:	89 14 24             	mov    %edx,(%esp)
c0104869:	ff d0                	call   *%eax
}
c010486b:	c9                   	leave  
c010486c:	c3                   	ret    

c010486d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010486d:	55                   	push   %ebp
c010486e:	89 e5                	mov    %esp,%ebp
c0104870:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010487a:	e8 2e fe ff ff       	call   c01046ad <__intr_save>
c010487f:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104882:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104887:	8b 40 0c             	mov    0xc(%eax),%eax
c010488a:	8b 55 08             	mov    0x8(%ebp),%edx
c010488d:	89 14 24             	mov    %edx,(%esp)
c0104890:	ff d0                	call   *%eax
c0104892:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104895:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104898:	89 04 24             	mov    %eax,(%esp)
c010489b:	e8 37 fe ff ff       	call   c01046d7 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01048a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048a4:	75 2d                	jne    c01048d3 <alloc_pages+0x66>
c01048a6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01048aa:	77 27                	ja     c01048d3 <alloc_pages+0x66>
c01048ac:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c01048b1:	85 c0                	test   %eax,%eax
c01048b3:	74 1e                	je     c01048d3 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01048b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01048b8:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01048bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048c4:	00 
c01048c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048c9:	89 04 24             	mov    %eax,(%esp)
c01048cc:	e8 9c 1a 00 00       	call   c010636d <swap_out>
    }
c01048d1:	eb a7                	jmp    c010487a <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01048d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01048d6:	c9                   	leave  
c01048d7:	c3                   	ret    

c01048d8 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01048d8:	55                   	push   %ebp
c01048d9:	89 e5                	mov    %esp,%ebp
c01048db:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01048de:	e8 ca fd ff ff       	call   c01046ad <__intr_save>
c01048e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01048e6:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01048eb:	8b 40 10             	mov    0x10(%eax),%eax
c01048ee:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01048f8:	89 14 24             	mov    %edx,(%esp)
c01048fb:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01048fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104900:	89 04 24             	mov    %eax,(%esp)
c0104903:	e8 cf fd ff ff       	call   c01046d7 <__intr_restore>
}
c0104908:	c9                   	leave  
c0104909:	c3                   	ret    

c010490a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010490a:	55                   	push   %ebp
c010490b:	89 e5                	mov    %esp,%ebp
c010490d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104910:	e8 98 fd ff ff       	call   c01046ad <__intr_save>
c0104915:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104918:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c010491d:	8b 40 14             	mov    0x14(%eax),%eax
c0104920:	ff d0                	call   *%eax
c0104922:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104928:	89 04 24             	mov    %eax,(%esp)
c010492b:	e8 a7 fd ff ff       	call   c01046d7 <__intr_restore>
    return ret;
c0104930:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104933:	c9                   	leave  
c0104934:	c3                   	ret    

c0104935 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104935:	55                   	push   %ebp
c0104936:	89 e5                	mov    %esp,%ebp
c0104938:	57                   	push   %edi
c0104939:	56                   	push   %esi
c010493a:	53                   	push   %ebx
c010493b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104941:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104948:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010494f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104956:	c7 04 24 a7 9a 10 c0 	movl   $0xc0109aa7,(%esp)
c010495d:	e8 e9 b9 ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104962:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104969:	e9 15 01 00 00       	jmp    c0104a83 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010496e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104971:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104974:	89 d0                	mov    %edx,%eax
c0104976:	c1 e0 02             	shl    $0x2,%eax
c0104979:	01 d0                	add    %edx,%eax
c010497b:	c1 e0 02             	shl    $0x2,%eax
c010497e:	01 c8                	add    %ecx,%eax
c0104980:	8b 50 08             	mov    0x8(%eax),%edx
c0104983:	8b 40 04             	mov    0x4(%eax),%eax
c0104986:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104989:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010498c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010498f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104992:	89 d0                	mov    %edx,%eax
c0104994:	c1 e0 02             	shl    $0x2,%eax
c0104997:	01 d0                	add    %edx,%eax
c0104999:	c1 e0 02             	shl    $0x2,%eax
c010499c:	01 c8                	add    %ecx,%eax
c010499e:	8b 48 0c             	mov    0xc(%eax),%ecx
c01049a1:	8b 58 10             	mov    0x10(%eax),%ebx
c01049a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01049a7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01049aa:	01 c8                	add    %ecx,%eax
c01049ac:	11 da                	adc    %ebx,%edx
c01049ae:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01049b1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01049b4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049ba:	89 d0                	mov    %edx,%eax
c01049bc:	c1 e0 02             	shl    $0x2,%eax
c01049bf:	01 d0                	add    %edx,%eax
c01049c1:	c1 e0 02             	shl    $0x2,%eax
c01049c4:	01 c8                	add    %ecx,%eax
c01049c6:	83 c0 14             	add    $0x14,%eax
c01049c9:	8b 00                	mov    (%eax),%eax
c01049cb:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01049d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01049d4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01049d7:	83 c0 ff             	add    $0xffffffff,%eax
c01049da:	83 d2 ff             	adc    $0xffffffff,%edx
c01049dd:	89 c6                	mov    %eax,%esi
c01049df:	89 d7                	mov    %edx,%edi
c01049e1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049e7:	89 d0                	mov    %edx,%eax
c01049e9:	c1 e0 02             	shl    $0x2,%eax
c01049ec:	01 d0                	add    %edx,%eax
c01049ee:	c1 e0 02             	shl    $0x2,%eax
c01049f1:	01 c8                	add    %ecx,%eax
c01049f3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01049f6:	8b 58 10             	mov    0x10(%eax),%ebx
c01049f9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01049ff:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104a03:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104a07:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104a0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104a0e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104a11:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a15:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104a19:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104a1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104a21:	c7 04 24 b4 9a 10 c0 	movl   $0xc0109ab4,(%esp)
c0104a28:	e8 1e b9 ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104a2d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a30:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a33:	89 d0                	mov    %edx,%eax
c0104a35:	c1 e0 02             	shl    $0x2,%eax
c0104a38:	01 d0                	add    %edx,%eax
c0104a3a:	c1 e0 02             	shl    $0x2,%eax
c0104a3d:	01 c8                	add    %ecx,%eax
c0104a3f:	83 c0 14             	add    $0x14,%eax
c0104a42:	8b 00                	mov    (%eax),%eax
c0104a44:	83 f8 01             	cmp    $0x1,%eax
c0104a47:	75 36                	jne    c0104a7f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a4f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104a52:	77 2b                	ja     c0104a7f <page_init+0x14a>
c0104a54:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104a57:	72 05                	jb     c0104a5e <page_init+0x129>
c0104a59:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104a5c:	73 21                	jae    c0104a7f <page_init+0x14a>
c0104a5e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104a62:	77 1b                	ja     c0104a7f <page_init+0x14a>
c0104a64:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104a68:	72 09                	jb     c0104a73 <page_init+0x13e>
c0104a6a:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104a71:	77 0c                	ja     c0104a7f <page_init+0x14a>
                maxpa = end;
c0104a73:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104a76:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104a7c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104a7f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104a83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104a86:	8b 00                	mov    (%eax),%eax
c0104a88:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104a8b:	0f 8f dd fe ff ff    	jg     c010496e <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104a91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104a95:	72 1d                	jb     c0104ab4 <page_init+0x17f>
c0104a97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104a9b:	77 09                	ja     c0104aa6 <page_init+0x171>
c0104a9d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104aa4:	76 0e                	jbe    c0104ab4 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104aa6:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104aad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ab7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104aba:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104abe:	c1 ea 0c             	shr    $0xc,%edx
c0104ac1:	a3 20 1a 12 c0       	mov    %eax,0xc0121a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104ac6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104acd:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c0104ad2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104ad5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104ad8:	01 d0                	add    %edx,%eax
c0104ada:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104add:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104ae0:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ae5:	f7 75 ac             	divl   -0x54(%ebp)
c0104ae8:	89 d0                	mov    %edx,%eax
c0104aea:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104aed:	29 c2                	sub    %eax,%edx
c0104aef:	89 d0                	mov    %edx,%eax
c0104af1:	a3 d4 1a 12 c0       	mov    %eax,0xc0121ad4

    for (i = 0; i < npage; i ++) {
c0104af6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104afd:	eb 27                	jmp    c0104b26 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104aff:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104b04:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b07:	c1 e2 05             	shl    $0x5,%edx
c0104b0a:	01 d0                	add    %edx,%eax
c0104b0c:	83 c0 04             	add    $0x4,%eax
c0104b0f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104b16:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104b19:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104b1c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104b1f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104b22:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104b26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b29:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104b2e:	39 c2                	cmp    %eax,%edx
c0104b30:	72 cd                	jb     c0104aff <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104b32:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104b37:	c1 e0 05             	shl    $0x5,%eax
c0104b3a:	89 c2                	mov    %eax,%edx
c0104b3c:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104b41:	01 d0                	add    %edx,%eax
c0104b43:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104b46:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104b4d:	77 23                	ja     c0104b72 <page_init+0x23d>
c0104b4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b56:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c0104b5d:	c0 
c0104b5e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104b65:	00 
c0104b66:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104b6d:	e8 5d c1 ff ff       	call   c0100ccf <__panic>
c0104b72:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b75:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b7a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104b7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104b84:	e9 74 01 00 00       	jmp    c0104cfd <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104b89:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b8f:	89 d0                	mov    %edx,%eax
c0104b91:	c1 e0 02             	shl    $0x2,%eax
c0104b94:	01 d0                	add    %edx,%eax
c0104b96:	c1 e0 02             	shl    $0x2,%eax
c0104b99:	01 c8                	add    %ecx,%eax
c0104b9b:	8b 50 08             	mov    0x8(%eax),%edx
c0104b9e:	8b 40 04             	mov    0x4(%eax),%eax
c0104ba1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ba4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104ba7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104baa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104bad:	89 d0                	mov    %edx,%eax
c0104baf:	c1 e0 02             	shl    $0x2,%eax
c0104bb2:	01 d0                	add    %edx,%eax
c0104bb4:	c1 e0 02             	shl    $0x2,%eax
c0104bb7:	01 c8                	add    %ecx,%eax
c0104bb9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104bbc:	8b 58 10             	mov    0x10(%eax),%ebx
c0104bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bc2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104bc5:	01 c8                	add    %ecx,%eax
c0104bc7:	11 da                	adc    %ebx,%edx
c0104bc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104bcc:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104bcf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104bd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104bd5:	89 d0                	mov    %edx,%eax
c0104bd7:	c1 e0 02             	shl    $0x2,%eax
c0104bda:	01 d0                	add    %edx,%eax
c0104bdc:	c1 e0 02             	shl    $0x2,%eax
c0104bdf:	01 c8                	add    %ecx,%eax
c0104be1:	83 c0 14             	add    $0x14,%eax
c0104be4:	8b 00                	mov    (%eax),%eax
c0104be6:	83 f8 01             	cmp    $0x1,%eax
c0104be9:	0f 85 0a 01 00 00    	jne    c0104cf9 <page_init+0x3c4>
            if (begin < freemem) {
c0104bef:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104bf2:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bf7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104bfa:	72 17                	jb     c0104c13 <page_init+0x2de>
c0104bfc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104bff:	77 05                	ja     c0104c06 <page_init+0x2d1>
c0104c01:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104c04:	76 0d                	jbe    c0104c13 <page_init+0x2de>
                begin = freemem;
c0104c06:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104c09:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c0c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104c13:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104c17:	72 1d                	jb     c0104c36 <page_init+0x301>
c0104c19:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104c1d:	77 09                	ja     c0104c28 <page_init+0x2f3>
c0104c1f:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104c26:	76 0e                	jbe    c0104c36 <page_init+0x301>
                end = KMEMSIZE;
c0104c28:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104c2f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104c36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c3c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104c3f:	0f 87 b4 00 00 00    	ja     c0104cf9 <page_init+0x3c4>
c0104c45:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104c48:	72 09                	jb     c0104c53 <page_init+0x31e>
c0104c4a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104c4d:	0f 83 a6 00 00 00    	jae    c0104cf9 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104c53:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104c5a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c5d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c60:	01 d0                	add    %edx,%eax
c0104c62:	83 e8 01             	sub    $0x1,%eax
c0104c65:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104c68:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104c6b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c70:	f7 75 9c             	divl   -0x64(%ebp)
c0104c73:	89 d0                	mov    %edx,%eax
c0104c75:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104c78:	29 c2                	sub    %eax,%edx
c0104c7a:	89 d0                	mov    %edx,%eax
c0104c7c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c81:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104c87:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c8a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104c8d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104c90:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c95:	89 c7                	mov    %eax,%edi
c0104c97:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104c9d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104ca0:	89 d0                	mov    %edx,%eax
c0104ca2:	83 e0 00             	and    $0x0,%eax
c0104ca5:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104ca8:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104cab:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104cae:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104cb1:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104cb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104cb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104cba:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104cbd:	77 3a                	ja     c0104cf9 <page_init+0x3c4>
c0104cbf:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104cc2:	72 05                	jb     c0104cc9 <page_init+0x394>
c0104cc4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104cc7:	73 30                	jae    c0104cf9 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104cc9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104ccc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104cd2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104cd5:	29 c8                	sub    %ecx,%eax
c0104cd7:	19 da                	sbb    %ebx,%edx
c0104cd9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104cdd:	c1 ea 0c             	shr    $0xc,%edx
c0104ce0:	89 c3                	mov    %eax,%ebx
c0104ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ce5:	89 04 24             	mov    %eax,(%esp)
c0104ce8:	e8 5a f8 ff ff       	call   c0104547 <pa2page>
c0104ced:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104cf1:	89 04 24             	mov    %eax,(%esp)
c0104cf4:	e8 55 fb ff ff       	call   c010484e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104cf9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104cfd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d00:	8b 00                	mov    (%eax),%eax
c0104d02:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104d05:	0f 8f 7e fe ff ff    	jg     c0104b89 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104d0b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104d11:	5b                   	pop    %ebx
c0104d12:	5e                   	pop    %esi
c0104d13:	5f                   	pop    %edi
c0104d14:	5d                   	pop    %ebp
c0104d15:	c3                   	ret    

c0104d16 <enable_paging>:

static void
enable_paging(void) {
c0104d16:	55                   	push   %ebp
c0104d17:	89 e5                	mov    %esp,%ebp
c0104d19:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104d1c:	a1 d0 1a 12 c0       	mov    0xc0121ad0,%eax
c0104d21:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104d27:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104d2a:	0f 20 c0             	mov    %cr0,%eax
c0104d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104d30:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104d36:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104d3d:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d4a:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104d4d:	c9                   	leave  
c0104d4e:	c3                   	ret    

c0104d4f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104d4f:	55                   	push   %ebp
c0104d50:	89 e5                	mov    %esp,%ebp
c0104d52:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104d55:	8b 45 14             	mov    0x14(%ebp),%eax
c0104d58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d5b:	31 d0                	xor    %edx,%eax
c0104d5d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104d62:	85 c0                	test   %eax,%eax
c0104d64:	74 24                	je     c0104d8a <boot_map_segment+0x3b>
c0104d66:	c7 44 24 0c f2 9a 10 	movl   $0xc0109af2,0xc(%esp)
c0104d6d:	c0 
c0104d6e:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0104d75:	c0 
c0104d76:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104d7d:	00 
c0104d7e:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104d85:	e8 45 bf ff ff       	call   c0100ccf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104d8a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104d91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d94:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104d99:	89 c2                	mov    %eax,%edx
c0104d9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d9e:	01 c2                	add    %eax,%edx
c0104da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da3:	01 d0                	add    %edx,%eax
c0104da5:	83 e8 01             	sub    $0x1,%eax
c0104da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dae:	ba 00 00 00 00       	mov    $0x0,%edx
c0104db3:	f7 75 f0             	divl   -0x10(%ebp)
c0104db6:	89 d0                	mov    %edx,%eax
c0104db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104dbb:	29 c2                	sub    %eax,%edx
c0104dbd:	89 d0                	mov    %edx,%eax
c0104dbf:	c1 e8 0c             	shr    $0xc,%eax
c0104dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104dc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dd3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104dd6:	8b 45 14             	mov    0x14(%ebp),%eax
c0104dd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ddf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104de4:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104de7:	eb 6b                	jmp    c0104e54 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104de9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104df0:	00 
c0104df1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104df4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dfb:	89 04 24             	mov    %eax,(%esp)
c0104dfe:	e8 cc 01 00 00       	call   c0104fcf <get_pte>
c0104e03:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104e06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e0a:	75 24                	jne    c0104e30 <boot_map_segment+0xe1>
c0104e0c:	c7 44 24 0c 1e 9b 10 	movl   $0xc0109b1e,0xc(%esp)
c0104e13:	c0 
c0104e14:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0104e1b:	c0 
c0104e1c:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104e23:	00 
c0104e24:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104e2b:	e8 9f be ff ff       	call   c0100ccf <__panic>
        *ptep = pa | PTE_P | perm;
c0104e30:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e33:	8b 55 14             	mov    0x14(%ebp),%edx
c0104e36:	09 d0                	or     %edx,%eax
c0104e38:	83 c8 01             	or     $0x1,%eax
c0104e3b:	89 c2                	mov    %eax,%edx
c0104e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e40:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104e42:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104e46:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104e4d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e58:	75 8f                	jne    c0104de9 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104e5a:	c9                   	leave  
c0104e5b:	c3                   	ret    

c0104e5c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104e5c:	55                   	push   %ebp
c0104e5d:	89 e5                	mov    %esp,%ebp
c0104e5f:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104e62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e69:	e8 ff f9 ff ff       	call   c010486d <alloc_pages>
c0104e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e75:	75 1c                	jne    c0104e93 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104e77:	c7 44 24 08 2b 9b 10 	movl   $0xc0109b2b,0x8(%esp)
c0104e7e:	c0 
c0104e7f:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104e86:	00 
c0104e87:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104e8e:	e8 3c be ff ff       	call   c0100ccf <__panic>
    }
    return page2kva(p);
c0104e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e96:	89 04 24             	mov    %eax,(%esp)
c0104e99:	e8 ee f6 ff ff       	call   c010458c <page2kva>
}
c0104e9e:	c9                   	leave  
c0104e9f:	c3                   	ret    

c0104ea0 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104ea0:	55                   	push   %ebp
c0104ea1:	89 e5                	mov    %esp,%ebp
c0104ea3:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104ea6:	e8 70 f9 ff ff       	call   c010481b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104eab:	e8 85 fa ff ff       	call   c0104935 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104eb0:	e8 36 05 00 00       	call   c01053eb <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104eb5:	e8 a2 ff ff ff       	call   c0104e5c <boot_alloc_page>
c0104eba:	a3 24 1a 12 c0       	mov    %eax,0xc0121a24
    memset(boot_pgdir, 0, PGSIZE);
c0104ebf:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104ec4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ecb:	00 
c0104ecc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ed3:	00 
c0104ed4:	89 04 24             	mov    %eax,(%esp)
c0104ed7:	e8 60 3d 00 00       	call   c0108c3c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104edc:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ee4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104eeb:	77 23                	ja     c0104f10 <pmm_init+0x70>
c0104eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ef4:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c0104efb:	c0 
c0104efc:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104f03:	00 
c0104f04:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104f0b:	e8 bf bd ff ff       	call   c0100ccf <__panic>
c0104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f13:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f18:	a3 d0 1a 12 c0       	mov    %eax,0xc0121ad0

    check_pgdir();
c0104f1d:	e8 e7 04 00 00       	call   c0105409 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104f22:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104f27:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104f2d:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f35:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104f3c:	77 23                	ja     c0104f61 <pmm_init+0xc1>
c0104f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f41:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f45:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c0104f4c:	c0 
c0104f4d:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104f54:	00 
c0104f55:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0104f5c:	e8 6e bd ff ff       	call   c0100ccf <__panic>
c0104f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f64:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f69:	83 c8 03             	or     $0x3,%eax
c0104f6c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104f6e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104f73:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104f7a:	00 
c0104f7b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104f82:	00 
c0104f83:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104f8a:	38 
c0104f8b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104f92:	c0 
c0104f93:	89 04 24             	mov    %eax,(%esp)
c0104f96:	e8 b4 fd ff ff       	call   c0104d4f <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104f9b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104fa0:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0104fa6:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104fac:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104fae:	e8 63 fd ff ff       	call   c0104d16 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104fb3:	e8 74 f7 ff ff       	call   c010472c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104fb8:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104fc3:	e8 dc 0a 00 00       	call   c0105aa4 <check_boot_pgdir>

    print_pgdir();
c0104fc8:	e8 69 0f 00 00       	call   c0105f36 <print_pgdir>

}
c0104fcd:	c9                   	leave  
c0104fce:	c3                   	ret    

c0104fcf <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104fcf:	55                   	push   %ebp
c0104fd0:	89 e5                	mov    %esp,%ebp
c0104fd2:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t* entry = &pgdir[PDX(la)];
c0104fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fd8:	c1 e8 16             	shr    $0x16,%eax
c0104fdb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104fe2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe5:	01 d0                	add    %edx,%eax
c0104fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*entry & PTE_P))
c0104fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fed:	8b 00                	mov    (%eax),%eax
c0104fef:	83 e0 01             	and    $0x1,%eax
c0104ff2:	85 c0                	test   %eax,%eax
c0104ff4:	0f 85 af 00 00 00    	jne    c01050a9 <get_pte+0xda>
    {
    	struct Page* p;
    	if((!create) || ((p = alloc_page()) == NULL))
c0104ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104ffe:	74 15                	je     c0105015 <get_pte+0x46>
c0105000:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105007:	e8 61 f8 ff ff       	call   c010486d <alloc_pages>
c010500c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010500f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105013:	75 0a                	jne    c010501f <get_pte+0x50>
    	{
			return NULL;
c0105015:	b8 00 00 00 00       	mov    $0x0,%eax
c010501a:	e9 e6 00 00 00       	jmp    c0105105 <get_pte+0x136>
    	}
		set_page_ref(p, 1);
c010501f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105026:	00 
c0105027:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010502a:	89 04 24             	mov    %eax,(%esp)
c010502d:	e8 40 f6 ff ff       	call   c0104672 <set_page_ref>
		uintptr_t pg_addr = page2pa(p);
c0105032:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105035:	89 04 24             	mov    %eax,(%esp)
c0105038:	e8 f4 f4 ff ff       	call   c0104531 <page2pa>
c010503d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pg_addr), 0, PGSIZE);
c0105040:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105043:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105046:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105049:	c1 e8 0c             	shr    $0xc,%eax
c010504c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010504f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105054:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105057:	72 23                	jb     c010507c <get_pte+0xad>
c0105059:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010505c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105060:	c7 44 24 08 1c 9a 10 	movl   $0xc0109a1c,0x8(%esp)
c0105067:	c0 
c0105068:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c010506f:	00 
c0105070:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105077:	e8 53 bc ff ff       	call   c0100ccf <__panic>
c010507c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010507f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105084:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010508b:	00 
c010508c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105093:	00 
c0105094:	89 04 24             	mov    %eax,(%esp)
c0105097:	e8 a0 3b 00 00       	call   c0108c3c <memset>
		*entry = pg_addr | PTE_U | PTE_W | PTE_P;
c010509c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010509f:	83 c8 07             	or     $0x7,%eax
c01050a2:	89 c2                	mov    %eax,%edx
c01050a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050a7:	89 10                	mov    %edx,(%eax)
   	}
    return &((pte_t*)KADDR(PDE_ADDR(*entry)))[PTX(la)];
c01050a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050ac:	8b 00                	mov    (%eax),%eax
c01050ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01050b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050b9:	c1 e8 0c             	shr    $0xc,%eax
c01050bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01050bf:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01050c4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01050c7:	72 23                	jb     c01050ec <get_pte+0x11d>
c01050c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050d0:	c7 44 24 08 1c 9a 10 	movl   $0xc0109a1c,0x8(%esp)
c01050d7:	c0 
c01050d8:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c01050df:	00 
c01050e0:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01050e7:	e8 e3 bb ff ff       	call   c0100ccf <__panic>
c01050ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ef:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01050f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050f7:	c1 ea 0c             	shr    $0xc,%edx
c01050fa:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105100:	c1 e2 02             	shl    $0x2,%edx
c0105103:	01 d0                	add    %edx,%eax
}
c0105105:	c9                   	leave  
c0105106:	c3                   	ret    

c0105107 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105107:	55                   	push   %ebp
c0105108:	89 e5                	mov    %esp,%ebp
c010510a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010510d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105114:	00 
c0105115:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010511c:	8b 45 08             	mov    0x8(%ebp),%eax
c010511f:	89 04 24             	mov    %eax,(%esp)
c0105122:	e8 a8 fe ff ff       	call   c0104fcf <get_pte>
c0105127:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010512a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010512e:	74 08                	je     c0105138 <get_page+0x31>
        *ptep_store = ptep;
c0105130:	8b 45 10             	mov    0x10(%ebp),%eax
c0105133:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105136:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010513c:	74 1b                	je     c0105159 <get_page+0x52>
c010513e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105141:	8b 00                	mov    (%eax),%eax
c0105143:	83 e0 01             	and    $0x1,%eax
c0105146:	85 c0                	test   %eax,%eax
c0105148:	74 0f                	je     c0105159 <get_page+0x52>
        return pa2page(*ptep);
c010514a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010514d:	8b 00                	mov    (%eax),%eax
c010514f:	89 04 24             	mov    %eax,(%esp)
c0105152:	e8 f0 f3 ff ff       	call   c0104547 <pa2page>
c0105157:	eb 05                	jmp    c010515e <get_page+0x57>
    }
    return NULL;
c0105159:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010515e:	c9                   	leave  
c010515f:	c3                   	ret    

c0105160 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105160:	55                   	push   %ebp
c0105161:	89 e5                	mov    %esp,%ebp
c0105163:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
c0105166:	8b 45 10             	mov    0x10(%ebp),%eax
c0105169:	8b 00                	mov    (%eax),%eax
c010516b:	83 e0 01             	and    $0x1,%eax
c010516e:	85 c0                	test   %eax,%eax
c0105170:	74 52                	je     c01051c4 <page_remove_pte+0x64>
	{
		struct Page* page = pte2page(*ptep);
c0105172:	8b 45 10             	mov    0x10(%ebp),%eax
c0105175:	8b 00                	mov    (%eax),%eax
c0105177:	89 04 24             	mov    %eax,(%esp)
c010517a:	e8 ab f4 ff ff       	call   c010462a <pte2page>
c010517f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int re = page_ref_dec(page);
c0105182:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105185:	89 04 24             	mov    %eax,(%esp)
c0105188:	e8 09 f5 ff ff       	call   c0104696 <page_ref_dec>
c010518d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(re == 0)
c0105190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105194:	75 13                	jne    c01051a9 <page_remove_pte+0x49>
		{
			free_page(page);
c0105196:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010519d:	00 
c010519e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051a1:	89 04 24             	mov    %eax,(%esp)
c01051a4:	e8 2f f7 ff ff       	call   c01048d8 <free_pages>
		}
		*ptep = 0;
c01051a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01051ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c01051b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bc:	89 04 24             	mov    %eax,(%esp)
c01051bf:	e8 ff 00 00 00       	call   c01052c3 <tlb_invalidate>
	}
}
c01051c4:	c9                   	leave  
c01051c5:	c3                   	ret    

c01051c6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01051c6:	55                   	push   %ebp
c01051c7:	89 e5                	mov    %esp,%ebp
c01051c9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01051cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01051d3:	00 
c01051d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051db:	8b 45 08             	mov    0x8(%ebp),%eax
c01051de:	89 04 24             	mov    %eax,(%esp)
c01051e1:	e8 e9 fd ff ff       	call   c0104fcf <get_pte>
c01051e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01051e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051ed:	74 19                	je     c0105208 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01051ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105200:	89 04 24             	mov    %eax,(%esp)
c0105203:	e8 58 ff ff ff       	call   c0105160 <page_remove_pte>
    }
}
c0105208:	c9                   	leave  
c0105209:	c3                   	ret    

c010520a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010520a:	55                   	push   %ebp
c010520b:	89 e5                	mov    %esp,%ebp
c010520d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105210:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105217:	00 
c0105218:	8b 45 10             	mov    0x10(%ebp),%eax
c010521b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010521f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105222:	89 04 24             	mov    %eax,(%esp)
c0105225:	e8 a5 fd ff ff       	call   c0104fcf <get_pte>
c010522a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010522d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105231:	75 0a                	jne    c010523d <page_insert+0x33>
        return -E_NO_MEM;
c0105233:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105238:	e9 84 00 00 00       	jmp    c01052c1 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010523d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105240:	89 04 24             	mov    %eax,(%esp)
c0105243:	e8 37 f4 ff ff       	call   c010467f <page_ref_inc>
    if (*ptep & PTE_P) {
c0105248:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010524b:	8b 00                	mov    (%eax),%eax
c010524d:	83 e0 01             	and    $0x1,%eax
c0105250:	85 c0                	test   %eax,%eax
c0105252:	74 3e                	je     c0105292 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105254:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105257:	8b 00                	mov    (%eax),%eax
c0105259:	89 04 24             	mov    %eax,(%esp)
c010525c:	e8 c9 f3 ff ff       	call   c010462a <pte2page>
c0105261:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105264:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105267:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010526a:	75 0d                	jne    c0105279 <page_insert+0x6f>
            page_ref_dec(page);
c010526c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010526f:	89 04 24             	mov    %eax,(%esp)
c0105272:	e8 1f f4 ff ff       	call   c0104696 <page_ref_dec>
c0105277:	eb 19                	jmp    c0105292 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105279:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010527c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105280:	8b 45 10             	mov    0x10(%ebp),%eax
c0105283:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105287:	8b 45 08             	mov    0x8(%ebp),%eax
c010528a:	89 04 24             	mov    %eax,(%esp)
c010528d:	e8 ce fe ff ff       	call   c0105160 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105292:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105295:	89 04 24             	mov    %eax,(%esp)
c0105298:	e8 94 f2 ff ff       	call   c0104531 <page2pa>
c010529d:	0b 45 14             	or     0x14(%ebp),%eax
c01052a0:	83 c8 01             	or     $0x1,%eax
c01052a3:	89 c2                	mov    %eax,%edx
c01052a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052a8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01052aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01052b4:	89 04 24             	mov    %eax,(%esp)
c01052b7:	e8 07 00 00 00       	call   c01052c3 <tlb_invalidate>
    return 0;
c01052bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052c1:	c9                   	leave  
c01052c2:	c3                   	ret    

c01052c3 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01052c3:	55                   	push   %ebp
c01052c4:	89 e5                	mov    %esp,%ebp
c01052c6:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01052c9:	0f 20 d8             	mov    %cr3,%eax
c01052cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01052cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01052d2:	89 c2                	mov    %eax,%edx
c01052d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052da:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01052e1:	77 23                	ja     c0105306 <tlb_invalidate+0x43>
c01052e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01052ea:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c01052f1:	c0 
c01052f2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01052f9:	00 
c01052fa:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105301:	e8 c9 b9 ff ff       	call   c0100ccf <__panic>
c0105306:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105309:	05 00 00 00 40       	add    $0x40000000,%eax
c010530e:	39 c2                	cmp    %eax,%edx
c0105310:	75 0c                	jne    c010531e <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105312:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105315:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531b:	0f 01 38             	invlpg (%eax)
    }
}
c010531e:	c9                   	leave  
c010531f:	c3                   	ret    

c0105320 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105320:	55                   	push   %ebp
c0105321:	89 e5                	mov    %esp,%ebp
c0105323:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105326:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010532d:	e8 3b f5 ff ff       	call   c010486d <alloc_pages>
c0105332:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105335:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105339:	0f 84 a7 00 00 00    	je     c01053e6 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010533f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105342:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105346:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105349:	89 44 24 08          	mov    %eax,0x8(%esp)
c010534d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105350:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105354:	8b 45 08             	mov    0x8(%ebp),%eax
c0105357:	89 04 24             	mov    %eax,(%esp)
c010535a:	e8 ab fe ff ff       	call   c010520a <page_insert>
c010535f:	85 c0                	test   %eax,%eax
c0105361:	74 1a                	je     c010537d <pgdir_alloc_page+0x5d>
            free_page(page);
c0105363:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010536a:	00 
c010536b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010536e:	89 04 24             	mov    %eax,(%esp)
c0105371:	e8 62 f5 ff ff       	call   c01048d8 <free_pages>
            return NULL;
c0105376:	b8 00 00 00 00       	mov    $0x0,%eax
c010537b:	eb 6c                	jmp    c01053e9 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c010537d:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0105382:	85 c0                	test   %eax,%eax
c0105384:	74 60                	je     c01053e6 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105386:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010538b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105392:	00 
c0105393:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105396:	89 54 24 08          	mov    %edx,0x8(%esp)
c010539a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010539d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053a1:	89 04 24             	mov    %eax,(%esp)
c01053a4:	e8 78 0f 00 00       	call   c0106321 <swap_map_swappable>
            page->pra_vaddr=la;
c01053a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053ac:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053af:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01053b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053b5:	89 04 24             	mov    %eax,(%esp)
c01053b8:	e8 ab f2 ff ff       	call   c0104668 <page_ref>
c01053bd:	83 f8 01             	cmp    $0x1,%eax
c01053c0:	74 24                	je     c01053e6 <pgdir_alloc_page+0xc6>
c01053c2:	c7 44 24 0c 44 9b 10 	movl   $0xc0109b44,0xc(%esp)
c01053c9:	c0 
c01053ca:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01053d1:	c0 
c01053d2:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c01053d9:	00 
c01053da:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01053e1:	e8 e9 b8 ff ff       	call   c0100ccf <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01053e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01053e9:	c9                   	leave  
c01053ea:	c3                   	ret    

c01053eb <check_alloc_page>:

static void
check_alloc_page(void) {
c01053eb:	55                   	push   %ebp
c01053ec:	89 e5                	mov    %esp,%ebp
c01053ee:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01053f1:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01053f6:	8b 40 18             	mov    0x18(%eax),%eax
c01053f9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01053fb:	c7 04 24 58 9b 10 c0 	movl   $0xc0109b58,(%esp)
c0105402:	e8 44 af ff ff       	call   c010034b <cprintf>
}
c0105407:	c9                   	leave  
c0105408:	c3                   	ret    

c0105409 <check_pgdir>:

static void
check_pgdir(void) {
c0105409:	55                   	push   %ebp
c010540a:	89 e5                	mov    %esp,%ebp
c010540c:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010540f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105414:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105419:	76 24                	jbe    c010543f <check_pgdir+0x36>
c010541b:	c7 44 24 0c 77 9b 10 	movl   $0xc0109b77,0xc(%esp)
c0105422:	c0 
c0105423:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c010542a:	c0 
c010542b:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105432:	00 
c0105433:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c010543a:	e8 90 b8 ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010543f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105444:	85 c0                	test   %eax,%eax
c0105446:	74 0e                	je     c0105456 <check_pgdir+0x4d>
c0105448:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010544d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105452:	85 c0                	test   %eax,%eax
c0105454:	74 24                	je     c010547a <check_pgdir+0x71>
c0105456:	c7 44 24 0c 94 9b 10 	movl   $0xc0109b94,0xc(%esp)
c010545d:	c0 
c010545e:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105465:	c0 
c0105466:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010546d:	00 
c010546e:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105475:	e8 55 b8 ff ff       	call   c0100ccf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010547a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010547f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105486:	00 
c0105487:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010548e:	00 
c010548f:	89 04 24             	mov    %eax,(%esp)
c0105492:	e8 70 fc ff ff       	call   c0105107 <get_page>
c0105497:	85 c0                	test   %eax,%eax
c0105499:	74 24                	je     c01054bf <check_pgdir+0xb6>
c010549b:	c7 44 24 0c cc 9b 10 	movl   $0xc0109bcc,0xc(%esp)
c01054a2:	c0 
c01054a3:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01054aa:	c0 
c01054ab:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01054b2:	00 
c01054b3:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01054ba:	e8 10 b8 ff ff       	call   c0100ccf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01054bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054c6:	e8 a2 f3 ff ff       	call   c010486d <alloc_pages>
c01054cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01054ce:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01054d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01054da:	00 
c01054db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054e2:	00 
c01054e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054e6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054ea:	89 04 24             	mov    %eax,(%esp)
c01054ed:	e8 18 fd ff ff       	call   c010520a <page_insert>
c01054f2:	85 c0                	test   %eax,%eax
c01054f4:	74 24                	je     c010551a <check_pgdir+0x111>
c01054f6:	c7 44 24 0c f4 9b 10 	movl   $0xc0109bf4,0xc(%esp)
c01054fd:	c0 
c01054fe:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105505:	c0 
c0105506:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010550d:	00 
c010550e:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105515:	e8 b5 b7 ff ff       	call   c0100ccf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010551a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010551f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105526:	00 
c0105527:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010552e:	00 
c010552f:	89 04 24             	mov    %eax,(%esp)
c0105532:	e8 98 fa ff ff       	call   c0104fcf <get_pte>
c0105537:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010553a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010553e:	75 24                	jne    c0105564 <check_pgdir+0x15b>
c0105540:	c7 44 24 0c 20 9c 10 	movl   $0xc0109c20,0xc(%esp)
c0105547:	c0 
c0105548:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c010554f:	c0 
c0105550:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105557:	00 
c0105558:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c010555f:	e8 6b b7 ff ff       	call   c0100ccf <__panic>
    assert(pa2page(*ptep) == p1);
c0105564:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105567:	8b 00                	mov    (%eax),%eax
c0105569:	89 04 24             	mov    %eax,(%esp)
c010556c:	e8 d6 ef ff ff       	call   c0104547 <pa2page>
c0105571:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105574:	74 24                	je     c010559a <check_pgdir+0x191>
c0105576:	c7 44 24 0c 4d 9c 10 	movl   $0xc0109c4d,0xc(%esp)
c010557d:	c0 
c010557e:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105585:	c0 
c0105586:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010558d:	00 
c010558e:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105595:	e8 35 b7 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 1);
c010559a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010559d:	89 04 24             	mov    %eax,(%esp)
c01055a0:	e8 c3 f0 ff ff       	call   c0104668 <page_ref>
c01055a5:	83 f8 01             	cmp    $0x1,%eax
c01055a8:	74 24                	je     c01055ce <check_pgdir+0x1c5>
c01055aa:	c7 44 24 0c 62 9c 10 	movl   $0xc0109c62,0xc(%esp)
c01055b1:	c0 
c01055b2:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01055b9:	c0 
c01055ba:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01055c1:	00 
c01055c2:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01055c9:	e8 01 b7 ff ff       	call   c0100ccf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01055ce:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01055d3:	8b 00                	mov    (%eax),%eax
c01055d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055e0:	c1 e8 0c             	shr    $0xc,%eax
c01055e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055e6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01055eb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01055ee:	72 23                	jb     c0105613 <check_pgdir+0x20a>
c01055f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055f7:	c7 44 24 08 1c 9a 10 	movl   $0xc0109a1c,0x8(%esp)
c01055fe:	c0 
c01055ff:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105606:	00 
c0105607:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c010560e:	e8 bc b6 ff ff       	call   c0100ccf <__panic>
c0105613:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105616:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010561b:	83 c0 04             	add    $0x4,%eax
c010561e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105621:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105626:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010562d:	00 
c010562e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105635:	00 
c0105636:	89 04 24             	mov    %eax,(%esp)
c0105639:	e8 91 f9 ff ff       	call   c0104fcf <get_pte>
c010563e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105641:	74 24                	je     c0105667 <check_pgdir+0x25e>
c0105643:	c7 44 24 0c 74 9c 10 	movl   $0xc0109c74,0xc(%esp)
c010564a:	c0 
c010564b:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105652:	c0 
c0105653:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010565a:	00 
c010565b:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105662:	e8 68 b6 ff ff       	call   c0100ccf <__panic>

    p2 = alloc_page();
c0105667:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010566e:	e8 fa f1 ff ff       	call   c010486d <alloc_pages>
c0105673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105676:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010567b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105682:	00 
c0105683:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010568a:	00 
c010568b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010568e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105692:	89 04 24             	mov    %eax,(%esp)
c0105695:	e8 70 fb ff ff       	call   c010520a <page_insert>
c010569a:	85 c0                	test   %eax,%eax
c010569c:	74 24                	je     c01056c2 <check_pgdir+0x2b9>
c010569e:	c7 44 24 0c 9c 9c 10 	movl   $0xc0109c9c,0xc(%esp)
c01056a5:	c0 
c01056a6:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01056ad:	c0 
c01056ae:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c01056b5:	00 
c01056b6:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01056bd:	e8 0d b6 ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01056c2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01056c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056ce:	00 
c01056cf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056d6:	00 
c01056d7:	89 04 24             	mov    %eax,(%esp)
c01056da:	e8 f0 f8 ff ff       	call   c0104fcf <get_pte>
c01056df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056e6:	75 24                	jne    c010570c <check_pgdir+0x303>
c01056e8:	c7 44 24 0c d4 9c 10 	movl   $0xc0109cd4,0xc(%esp)
c01056ef:	c0 
c01056f0:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01056f7:	c0 
c01056f8:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01056ff:	00 
c0105700:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105707:	e8 c3 b5 ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_U);
c010570c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010570f:	8b 00                	mov    (%eax),%eax
c0105711:	83 e0 04             	and    $0x4,%eax
c0105714:	85 c0                	test   %eax,%eax
c0105716:	75 24                	jne    c010573c <check_pgdir+0x333>
c0105718:	c7 44 24 0c 04 9d 10 	movl   $0xc0109d04,0xc(%esp)
c010571f:	c0 
c0105720:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105727:	c0 
c0105728:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c010572f:	00 
c0105730:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105737:	e8 93 b5 ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_W);
c010573c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010573f:	8b 00                	mov    (%eax),%eax
c0105741:	83 e0 02             	and    $0x2,%eax
c0105744:	85 c0                	test   %eax,%eax
c0105746:	75 24                	jne    c010576c <check_pgdir+0x363>
c0105748:	c7 44 24 0c 12 9d 10 	movl   $0xc0109d12,0xc(%esp)
c010574f:	c0 
c0105750:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105757:	c0 
c0105758:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c010575f:	00 
c0105760:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105767:	e8 63 b5 ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010576c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105771:	8b 00                	mov    (%eax),%eax
c0105773:	83 e0 04             	and    $0x4,%eax
c0105776:	85 c0                	test   %eax,%eax
c0105778:	75 24                	jne    c010579e <check_pgdir+0x395>
c010577a:	c7 44 24 0c 20 9d 10 	movl   $0xc0109d20,0xc(%esp)
c0105781:	c0 
c0105782:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105789:	c0 
c010578a:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105791:	00 
c0105792:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105799:	e8 31 b5 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 1);
c010579e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a1:	89 04 24             	mov    %eax,(%esp)
c01057a4:	e8 bf ee ff ff       	call   c0104668 <page_ref>
c01057a9:	83 f8 01             	cmp    $0x1,%eax
c01057ac:	74 24                	je     c01057d2 <check_pgdir+0x3c9>
c01057ae:	c7 44 24 0c 36 9d 10 	movl   $0xc0109d36,0xc(%esp)
c01057b5:	c0 
c01057b6:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01057bd:	c0 
c01057be:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c01057c5:	00 
c01057c6:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01057cd:	e8 fd b4 ff ff       	call   c0100ccf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01057d2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01057d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01057de:	00 
c01057df:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01057e6:	00 
c01057e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ee:	89 04 24             	mov    %eax,(%esp)
c01057f1:	e8 14 fa ff ff       	call   c010520a <page_insert>
c01057f6:	85 c0                	test   %eax,%eax
c01057f8:	74 24                	je     c010581e <check_pgdir+0x415>
c01057fa:	c7 44 24 0c 48 9d 10 	movl   $0xc0109d48,0xc(%esp)
c0105801:	c0 
c0105802:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105809:	c0 
c010580a:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105811:	00 
c0105812:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105819:	e8 b1 b4 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 2);
c010581e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105821:	89 04 24             	mov    %eax,(%esp)
c0105824:	e8 3f ee ff ff       	call   c0104668 <page_ref>
c0105829:	83 f8 02             	cmp    $0x2,%eax
c010582c:	74 24                	je     c0105852 <check_pgdir+0x449>
c010582e:	c7 44 24 0c 74 9d 10 	movl   $0xc0109d74,0xc(%esp)
c0105835:	c0 
c0105836:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c010583d:	c0 
c010583e:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105845:	00 
c0105846:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c010584d:	e8 7d b4 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c0105852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105855:	89 04 24             	mov    %eax,(%esp)
c0105858:	e8 0b ee ff ff       	call   c0104668 <page_ref>
c010585d:	85 c0                	test   %eax,%eax
c010585f:	74 24                	je     c0105885 <check_pgdir+0x47c>
c0105861:	c7 44 24 0c 86 9d 10 	movl   $0xc0109d86,0xc(%esp)
c0105868:	c0 
c0105869:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105870:	c0 
c0105871:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105878:	00 
c0105879:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105880:	e8 4a b4 ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105885:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010588a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105891:	00 
c0105892:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105899:	00 
c010589a:	89 04 24             	mov    %eax,(%esp)
c010589d:	e8 2d f7 ff ff       	call   c0104fcf <get_pte>
c01058a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058a9:	75 24                	jne    c01058cf <check_pgdir+0x4c6>
c01058ab:	c7 44 24 0c d4 9c 10 	movl   $0xc0109cd4,0xc(%esp)
c01058b2:	c0 
c01058b3:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01058ba:	c0 
c01058bb:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01058c2:	00 
c01058c3:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01058ca:	e8 00 b4 ff ff       	call   c0100ccf <__panic>
    assert(pa2page(*ptep) == p1);
c01058cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d2:	8b 00                	mov    (%eax),%eax
c01058d4:	89 04 24             	mov    %eax,(%esp)
c01058d7:	e8 6b ec ff ff       	call   c0104547 <pa2page>
c01058dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01058df:	74 24                	je     c0105905 <check_pgdir+0x4fc>
c01058e1:	c7 44 24 0c 4d 9c 10 	movl   $0xc0109c4d,0xc(%esp)
c01058e8:	c0 
c01058e9:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01058f0:	c0 
c01058f1:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01058f8:	00 
c01058f9:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105900:	e8 ca b3 ff ff       	call   c0100ccf <__panic>
    assert((*ptep & PTE_U) == 0);
c0105905:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105908:	8b 00                	mov    (%eax),%eax
c010590a:	83 e0 04             	and    $0x4,%eax
c010590d:	85 c0                	test   %eax,%eax
c010590f:	74 24                	je     c0105935 <check_pgdir+0x52c>
c0105911:	c7 44 24 0c 98 9d 10 	movl   $0xc0109d98,0xc(%esp)
c0105918:	c0 
c0105919:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105920:	c0 
c0105921:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105928:	00 
c0105929:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105930:	e8 9a b3 ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, 0x0);
c0105935:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010593a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105941:	00 
c0105942:	89 04 24             	mov    %eax,(%esp)
c0105945:	e8 7c f8 ff ff       	call   c01051c6 <page_remove>
    assert(page_ref(p1) == 1);
c010594a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010594d:	89 04 24             	mov    %eax,(%esp)
c0105950:	e8 13 ed ff ff       	call   c0104668 <page_ref>
c0105955:	83 f8 01             	cmp    $0x1,%eax
c0105958:	74 24                	je     c010597e <check_pgdir+0x575>
c010595a:	c7 44 24 0c 62 9c 10 	movl   $0xc0109c62,0xc(%esp)
c0105961:	c0 
c0105962:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105969:	c0 
c010596a:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105971:	00 
c0105972:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105979:	e8 51 b3 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c010597e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105981:	89 04 24             	mov    %eax,(%esp)
c0105984:	e8 df ec ff ff       	call   c0104668 <page_ref>
c0105989:	85 c0                	test   %eax,%eax
c010598b:	74 24                	je     c01059b1 <check_pgdir+0x5a8>
c010598d:	c7 44 24 0c 86 9d 10 	movl   $0xc0109d86,0xc(%esp)
c0105994:	c0 
c0105995:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c010599c:	c0 
c010599d:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01059a4:	00 
c01059a5:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01059ac:	e8 1e b3 ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01059b1:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059b6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01059bd:	00 
c01059be:	89 04 24             	mov    %eax,(%esp)
c01059c1:	e8 00 f8 ff ff       	call   c01051c6 <page_remove>
    assert(page_ref(p1) == 0);
c01059c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c9:	89 04 24             	mov    %eax,(%esp)
c01059cc:	e8 97 ec ff ff       	call   c0104668 <page_ref>
c01059d1:	85 c0                	test   %eax,%eax
c01059d3:	74 24                	je     c01059f9 <check_pgdir+0x5f0>
c01059d5:	c7 44 24 0c ad 9d 10 	movl   $0xc0109dad,0xc(%esp)
c01059dc:	c0 
c01059dd:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01059e4:	c0 
c01059e5:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01059ec:	00 
c01059ed:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01059f4:	e8 d6 b2 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c01059f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059fc:	89 04 24             	mov    %eax,(%esp)
c01059ff:	e8 64 ec ff ff       	call   c0104668 <page_ref>
c0105a04:	85 c0                	test   %eax,%eax
c0105a06:	74 24                	je     c0105a2c <check_pgdir+0x623>
c0105a08:	c7 44 24 0c 86 9d 10 	movl   $0xc0109d86,0xc(%esp)
c0105a0f:	c0 
c0105a10:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105a17:	c0 
c0105a18:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105a1f:	00 
c0105a20:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105a27:	e8 a3 b2 ff ff       	call   c0100ccf <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105a2c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a31:	8b 00                	mov    (%eax),%eax
c0105a33:	89 04 24             	mov    %eax,(%esp)
c0105a36:	e8 0c eb ff ff       	call   c0104547 <pa2page>
c0105a3b:	89 04 24             	mov    %eax,(%esp)
c0105a3e:	e8 25 ec ff ff       	call   c0104668 <page_ref>
c0105a43:	83 f8 01             	cmp    $0x1,%eax
c0105a46:	74 24                	je     c0105a6c <check_pgdir+0x663>
c0105a48:	c7 44 24 0c c0 9d 10 	movl   $0xc0109dc0,0xc(%esp)
c0105a4f:	c0 
c0105a50:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105a57:	c0 
c0105a58:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0105a5f:	00 
c0105a60:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105a67:	e8 63 b2 ff ff       	call   c0100ccf <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105a6c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a71:	8b 00                	mov    (%eax),%eax
c0105a73:	89 04 24             	mov    %eax,(%esp)
c0105a76:	e8 cc ea ff ff       	call   c0104547 <pa2page>
c0105a7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a82:	00 
c0105a83:	89 04 24             	mov    %eax,(%esp)
c0105a86:	e8 4d ee ff ff       	call   c01048d8 <free_pages>
    boot_pgdir[0] = 0;
c0105a8b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105a96:	c7 04 24 e6 9d 10 c0 	movl   $0xc0109de6,(%esp)
c0105a9d:	e8 a9 a8 ff ff       	call   c010034b <cprintf>
}
c0105aa2:	c9                   	leave  
c0105aa3:	c3                   	ret    

c0105aa4 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105aa4:	55                   	push   %ebp
c0105aa5:	89 e5                	mov    %esp,%ebp
c0105aa7:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105ab1:	e9 ca 00 00 00       	jmp    c0105b80 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105abf:	c1 e8 0c             	shr    $0xc,%eax
c0105ac2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac5:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105aca:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105acd:	72 23                	jb     c0105af2 <check_boot_pgdir+0x4e>
c0105acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ad6:	c7 44 24 08 1c 9a 10 	movl   $0xc0109a1c,0x8(%esp)
c0105add:	c0 
c0105ade:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0105ae5:	00 
c0105ae6:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105aed:	e8 dd b1 ff ff       	call   c0100ccf <__panic>
c0105af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105afa:	89 c2                	mov    %eax,%edx
c0105afc:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b08:	00 
c0105b09:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b0d:	89 04 24             	mov    %eax,(%esp)
c0105b10:	e8 ba f4 ff ff       	call   c0104fcf <get_pte>
c0105b15:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b1c:	75 24                	jne    c0105b42 <check_boot_pgdir+0x9e>
c0105b1e:	c7 44 24 0c 00 9e 10 	movl   $0xc0109e00,0xc(%esp)
c0105b25:	c0 
c0105b26:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105b2d:	c0 
c0105b2e:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0105b35:	00 
c0105b36:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105b3d:	e8 8d b1 ff ff       	call   c0100ccf <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b45:	8b 00                	mov    (%eax),%eax
c0105b47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105b4c:	89 c2                	mov    %eax,%edx
c0105b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b51:	39 c2                	cmp    %eax,%edx
c0105b53:	74 24                	je     c0105b79 <check_boot_pgdir+0xd5>
c0105b55:	c7 44 24 0c 3d 9e 10 	movl   $0xc0109e3d,0xc(%esp)
c0105b5c:	c0 
c0105b5d:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105b64:	c0 
c0105b65:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105b6c:	00 
c0105b6d:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105b74:	e8 56 b1 ff ff       	call   c0100ccf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105b79:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b83:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105b88:	39 c2                	cmp    %eax,%edx
c0105b8a:	0f 82 26 ff ff ff    	jb     c0105ab6 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105b90:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b95:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105b9a:	8b 00                	mov    (%eax),%eax
c0105b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ba1:	89 c2                	mov    %eax,%edx
c0105ba3:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105ba8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105bab:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105bb2:	77 23                	ja     c0105bd7 <check_boot_pgdir+0x133>
c0105bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bbb:	c7 44 24 08 40 9a 10 	movl   $0xc0109a40,0x8(%esp)
c0105bc2:	c0 
c0105bc3:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105bca:	00 
c0105bcb:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105bd2:	e8 f8 b0 ff ff       	call   c0100ccf <__panic>
c0105bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bda:	05 00 00 00 40       	add    $0x40000000,%eax
c0105bdf:	39 c2                	cmp    %eax,%edx
c0105be1:	74 24                	je     c0105c07 <check_boot_pgdir+0x163>
c0105be3:	c7 44 24 0c 54 9e 10 	movl   $0xc0109e54,0xc(%esp)
c0105bea:	c0 
c0105beb:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105bf2:	c0 
c0105bf3:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105bfa:	00 
c0105bfb:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105c02:	e8 c8 b0 ff ff       	call   c0100ccf <__panic>

    assert(boot_pgdir[0] == 0);
c0105c07:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105c0c:	8b 00                	mov    (%eax),%eax
c0105c0e:	85 c0                	test   %eax,%eax
c0105c10:	74 24                	je     c0105c36 <check_boot_pgdir+0x192>
c0105c12:	c7 44 24 0c 88 9e 10 	movl   $0xc0109e88,0xc(%esp)
c0105c19:	c0 
c0105c1a:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105c21:	c0 
c0105c22:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0105c29:	00 
c0105c2a:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105c31:	e8 99 b0 ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    p = alloc_page();
c0105c36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c3d:	e8 2b ec ff ff       	call   c010486d <alloc_pages>
c0105c42:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105c45:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105c4a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105c51:	00 
c0105c52:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105c59:	00 
c0105c5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105c5d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c61:	89 04 24             	mov    %eax,(%esp)
c0105c64:	e8 a1 f5 ff ff       	call   c010520a <page_insert>
c0105c69:	85 c0                	test   %eax,%eax
c0105c6b:	74 24                	je     c0105c91 <check_boot_pgdir+0x1ed>
c0105c6d:	c7 44 24 0c 9c 9e 10 	movl   $0xc0109e9c,0xc(%esp)
c0105c74:	c0 
c0105c75:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105c7c:	c0 
c0105c7d:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c0105c84:	00 
c0105c85:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105c8c:	e8 3e b0 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 1);
c0105c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c94:	89 04 24             	mov    %eax,(%esp)
c0105c97:	e8 cc e9 ff ff       	call   c0104668 <page_ref>
c0105c9c:	83 f8 01             	cmp    $0x1,%eax
c0105c9f:	74 24                	je     c0105cc5 <check_boot_pgdir+0x221>
c0105ca1:	c7 44 24 0c ca 9e 10 	movl   $0xc0109eca,0xc(%esp)
c0105ca8:	c0 
c0105ca9:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105cb0:	c0 
c0105cb1:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c0105cb8:	00 
c0105cb9:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105cc0:	e8 0a b0 ff ff       	call   c0100ccf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105cc5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105cca:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105cd1:	00 
c0105cd2:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105cd9:	00 
c0105cda:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105cdd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ce1:	89 04 24             	mov    %eax,(%esp)
c0105ce4:	e8 21 f5 ff ff       	call   c010520a <page_insert>
c0105ce9:	85 c0                	test   %eax,%eax
c0105ceb:	74 24                	je     c0105d11 <check_boot_pgdir+0x26d>
c0105ced:	c7 44 24 0c dc 9e 10 	movl   $0xc0109edc,0xc(%esp)
c0105cf4:	c0 
c0105cf5:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105cfc:	c0 
c0105cfd:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105d04:	00 
c0105d05:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105d0c:	e8 be af ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 2);
c0105d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d14:	89 04 24             	mov    %eax,(%esp)
c0105d17:	e8 4c e9 ff ff       	call   c0104668 <page_ref>
c0105d1c:	83 f8 02             	cmp    $0x2,%eax
c0105d1f:	74 24                	je     c0105d45 <check_boot_pgdir+0x2a1>
c0105d21:	c7 44 24 0c 13 9f 10 	movl   $0xc0109f13,0xc(%esp)
c0105d28:	c0 
c0105d29:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105d30:	c0 
c0105d31:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c0105d38:	00 
c0105d39:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105d40:	e8 8a af ff ff       	call   c0100ccf <__panic>

    const char *str = "ucore: Hello world!!";
c0105d45:	c7 45 dc 24 9f 10 c0 	movl   $0xc0109f24,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d53:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105d5a:	e8 06 2c 00 00       	call   c0108965 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105d5f:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105d66:	00 
c0105d67:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105d6e:	e8 6b 2c 00 00       	call   c01089de <strcmp>
c0105d73:	85 c0                	test   %eax,%eax
c0105d75:	74 24                	je     c0105d9b <check_boot_pgdir+0x2f7>
c0105d77:	c7 44 24 0c 3c 9f 10 	movl   $0xc0109f3c,0xc(%esp)
c0105d7e:	c0 
c0105d7f:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105d86:	c0 
c0105d87:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0105d8e:	00 
c0105d8f:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105d96:	e8 34 af ff ff       	call   c0100ccf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d9e:	89 04 24             	mov    %eax,(%esp)
c0105da1:	e8 e6 e7 ff ff       	call   c010458c <page2kva>
c0105da6:	05 00 01 00 00       	add    $0x100,%eax
c0105dab:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105dae:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105db5:	e8 53 2b 00 00       	call   c010890d <strlen>
c0105dba:	85 c0                	test   %eax,%eax
c0105dbc:	74 24                	je     c0105de2 <check_boot_pgdir+0x33e>
c0105dbe:	c7 44 24 0c 74 9f 10 	movl   $0xc0109f74,0xc(%esp)
c0105dc5:	c0 
c0105dc6:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0105dcd:	c0 
c0105dce:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c0105dd5:	00 
c0105dd6:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0105ddd:	e8 ed ae ff ff       	call   c0100ccf <__panic>

    free_page(p);
c0105de2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105de9:	00 
c0105dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ded:	89 04 24             	mov    %eax,(%esp)
c0105df0:	e8 e3 ea ff ff       	call   c01048d8 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105df5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105dfa:	8b 00                	mov    (%eax),%eax
c0105dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105e01:	89 04 24             	mov    %eax,(%esp)
c0105e04:	e8 3e e7 ff ff       	call   c0104547 <pa2page>
c0105e09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105e10:	00 
c0105e11:	89 04 24             	mov    %eax,(%esp)
c0105e14:	e8 bf ea ff ff       	call   c01048d8 <free_pages>
    boot_pgdir[0] = 0;
c0105e19:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105e24:	c7 04 24 98 9f 10 c0 	movl   $0xc0109f98,(%esp)
c0105e2b:	e8 1b a5 ff ff       	call   c010034b <cprintf>
}
c0105e30:	c9                   	leave  
c0105e31:	c3                   	ret    

c0105e32 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105e32:	55                   	push   %ebp
c0105e33:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e38:	83 e0 04             	and    $0x4,%eax
c0105e3b:	85 c0                	test   %eax,%eax
c0105e3d:	74 07                	je     c0105e46 <perm2str+0x14>
c0105e3f:	b8 75 00 00 00       	mov    $0x75,%eax
c0105e44:	eb 05                	jmp    c0105e4b <perm2str+0x19>
c0105e46:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105e4b:	a2 a8 1a 12 c0       	mov    %al,0xc0121aa8
    str[1] = 'r';
c0105e50:	c6 05 a9 1a 12 c0 72 	movb   $0x72,0xc0121aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5a:	83 e0 02             	and    $0x2,%eax
c0105e5d:	85 c0                	test   %eax,%eax
c0105e5f:	74 07                	je     c0105e68 <perm2str+0x36>
c0105e61:	b8 77 00 00 00       	mov    $0x77,%eax
c0105e66:	eb 05                	jmp    c0105e6d <perm2str+0x3b>
c0105e68:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105e6d:	a2 aa 1a 12 c0       	mov    %al,0xc0121aaa
    str[3] = '\0';
c0105e72:	c6 05 ab 1a 12 c0 00 	movb   $0x0,0xc0121aab
    return str;
c0105e79:	b8 a8 1a 12 c0       	mov    $0xc0121aa8,%eax
}
c0105e7e:	5d                   	pop    %ebp
c0105e7f:	c3                   	ret    

c0105e80 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105e80:	55                   	push   %ebp
c0105e81:	89 e5                	mov    %esp,%ebp
c0105e83:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105e86:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e89:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e8c:	72 0a                	jb     c0105e98 <get_pgtable_items+0x18>
        return 0;
c0105e8e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105e93:	e9 9c 00 00 00       	jmp    c0105f34 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105e98:	eb 04                	jmp    c0105e9e <get_pgtable_items+0x1e>
        start ++;
c0105e9a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105e9e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ea4:	73 18                	jae    c0105ebe <get_pgtable_items+0x3e>
c0105ea6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105eb0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105eb3:	01 d0                	add    %edx,%eax
c0105eb5:	8b 00                	mov    (%eax),%eax
c0105eb7:	83 e0 01             	and    $0x1,%eax
c0105eba:	85 c0                	test   %eax,%eax
c0105ebc:	74 dc                	je     c0105e9a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105ebe:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ec1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ec4:	73 69                	jae    c0105f2f <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105ec6:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105eca:	74 08                	je     c0105ed4 <get_pgtable_items+0x54>
            *left_store = start;
c0105ecc:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ecf:	8b 55 10             	mov    0x10(%ebp),%edx
c0105ed2:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105ed4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed7:	8d 50 01             	lea    0x1(%eax),%edx
c0105eda:	89 55 10             	mov    %edx,0x10(%ebp)
c0105edd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105ee4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ee7:	01 d0                	add    %edx,%eax
c0105ee9:	8b 00                	mov    (%eax),%eax
c0105eeb:	83 e0 07             	and    $0x7,%eax
c0105eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105ef1:	eb 04                	jmp    c0105ef7 <get_pgtable_items+0x77>
            start ++;
c0105ef3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105ef7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105efa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105efd:	73 1d                	jae    c0105f1c <get_pgtable_items+0x9c>
c0105eff:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105f09:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f0c:	01 d0                	add    %edx,%eax
c0105f0e:	8b 00                	mov    (%eax),%eax
c0105f10:	83 e0 07             	and    $0x7,%eax
c0105f13:	89 c2                	mov    %eax,%edx
c0105f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f18:	39 c2                	cmp    %eax,%edx
c0105f1a:	74 d7                	je     c0105ef3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105f1c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105f20:	74 08                	je     c0105f2a <get_pgtable_items+0xaa>
            *right_store = start;
c0105f22:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105f25:	8b 55 10             	mov    0x10(%ebp),%edx
c0105f28:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f2d:	eb 05                	jmp    c0105f34 <get_pgtable_items+0xb4>
    }
    return 0;
c0105f2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f34:	c9                   	leave  
c0105f35:	c3                   	ret    

c0105f36 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105f36:	55                   	push   %ebp
c0105f37:	89 e5                	mov    %esp,%ebp
c0105f39:	57                   	push   %edi
c0105f3a:	56                   	push   %esi
c0105f3b:	53                   	push   %ebx
c0105f3c:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105f3f:	c7 04 24 b8 9f 10 c0 	movl   $0xc0109fb8,(%esp)
c0105f46:	e8 00 a4 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105f4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105f52:	e9 fa 00 00 00       	jmp    c0106051 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f5a:	89 04 24             	mov    %eax,(%esp)
c0105f5d:	e8 d0 fe ff ff       	call   c0105e32 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105f62:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f65:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105f68:	29 d1                	sub    %edx,%ecx
c0105f6a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105f6c:	89 d6                	mov    %edx,%esi
c0105f6e:	c1 e6 16             	shl    $0x16,%esi
c0105f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105f74:	89 d3                	mov    %edx,%ebx
c0105f76:	c1 e3 16             	shl    $0x16,%ebx
c0105f79:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105f7c:	89 d1                	mov    %edx,%ecx
c0105f7e:	c1 e1 16             	shl    $0x16,%ecx
c0105f81:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105f84:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105f87:	29 d7                	sub    %edx,%edi
c0105f89:	89 fa                	mov    %edi,%edx
c0105f8b:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105f8f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105f93:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105f97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105f9b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f9f:	c7 04 24 e9 9f 10 c0 	movl   $0xc0109fe9,(%esp)
c0105fa6:	e8 a0 a3 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105fab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fae:	c1 e0 0a             	shl    $0xa,%eax
c0105fb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105fb4:	eb 54                	jmp    c010600a <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fb9:	89 04 24             	mov    %eax,(%esp)
c0105fbc:	e8 71 fe ff ff       	call   c0105e32 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105fc1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105fc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105fc7:	29 d1                	sub    %edx,%ecx
c0105fc9:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105fcb:	89 d6                	mov    %edx,%esi
c0105fcd:	c1 e6 0c             	shl    $0xc,%esi
c0105fd0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105fd3:	89 d3                	mov    %edx,%ebx
c0105fd5:	c1 e3 0c             	shl    $0xc,%ebx
c0105fd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105fdb:	c1 e2 0c             	shl    $0xc,%edx
c0105fde:	89 d1                	mov    %edx,%ecx
c0105fe0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105fe3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105fe6:	29 d7                	sub    %edx,%edi
c0105fe8:	89 fa                	mov    %edi,%edx
c0105fea:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105fee:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105ff2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ff6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105ffa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ffe:	c7 04 24 08 a0 10 c0 	movl   $0xc010a008,(%esp)
c0106005:	e8 41 a3 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010600a:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010600f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106012:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106015:	89 ce                	mov    %ecx,%esi
c0106017:	c1 e6 0a             	shl    $0xa,%esi
c010601a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010601d:	89 cb                	mov    %ecx,%ebx
c010601f:	c1 e3 0a             	shl    $0xa,%ebx
c0106022:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106025:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106029:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010602c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106030:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106034:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106038:	89 74 24 04          	mov    %esi,0x4(%esp)
c010603c:	89 1c 24             	mov    %ebx,(%esp)
c010603f:	e8 3c fe ff ff       	call   c0105e80 <get_pgtable_items>
c0106044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106047:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010604b:	0f 85 65 ff ff ff    	jne    c0105fb6 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106051:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106056:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106059:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010605c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106060:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106063:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106067:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010606b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010606f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106076:	00 
c0106077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010607e:	e8 fd fd ff ff       	call   c0105e80 <get_pgtable_items>
c0106083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106086:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010608a:	0f 85 c7 fe ff ff    	jne    c0105f57 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106090:	c7 04 24 2c a0 10 c0 	movl   $0xc010a02c,(%esp)
c0106097:	e8 af a2 ff ff       	call   c010034b <cprintf>
}
c010609c:	83 c4 4c             	add    $0x4c,%esp
c010609f:	5b                   	pop    %ebx
c01060a0:	5e                   	pop    %esi
c01060a1:	5f                   	pop    %edi
c01060a2:	5d                   	pop    %ebp
c01060a3:	c3                   	ret    

c01060a4 <kmalloc>:

void *
kmalloc(size_t n) {
c01060a4:	55                   	push   %ebp
c01060a5:	89 e5                	mov    %esp,%ebp
c01060a7:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c01060aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c01060b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c01060b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01060bc:	74 09                	je     c01060c7 <kmalloc+0x23>
c01060be:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c01060c5:	76 24                	jbe    c01060eb <kmalloc+0x47>
c01060c7:	c7 44 24 0c 5d a0 10 	movl   $0xc010a05d,0xc(%esp)
c01060ce:	c0 
c01060cf:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c01060d6:	c0 
c01060d7:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c01060de:	00 
c01060df:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01060e6:	e8 e4 ab ff ff       	call   c0100ccf <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c01060eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ee:	05 ff 0f 00 00       	add    $0xfff,%eax
c01060f3:	c1 e8 0c             	shr    $0xc,%eax
c01060f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c01060f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060fc:	89 04 24             	mov    %eax,(%esp)
c01060ff:	e8 69 e7 ff ff       	call   c010486d <alloc_pages>
c0106104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0106107:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010610b:	75 24                	jne    c0106131 <kmalloc+0x8d>
c010610d:	c7 44 24 0c 74 a0 10 	movl   $0xc010a074,0xc(%esp)
c0106114:	c0 
c0106115:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c010611c:	c0 
c010611d:	c7 44 24 04 b8 02 00 	movl   $0x2b8,0x4(%esp)
c0106124:	00 
c0106125:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c010612c:	e8 9e ab ff ff       	call   c0100ccf <__panic>
    ptr=page2kva(base);
c0106131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106134:	89 04 24             	mov    %eax,(%esp)
c0106137:	e8 50 e4 ff ff       	call   c010458c <page2kva>
c010613c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c010613f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106142:	c9                   	leave  
c0106143:	c3                   	ret    

c0106144 <kfree>:

void 
kfree(void *ptr, size_t n) {
c0106144:	55                   	push   %ebp
c0106145:	89 e5                	mov    %esp,%ebp
c0106147:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c010614a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010614e:	74 09                	je     c0106159 <kfree+0x15>
c0106150:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0106157:	76 24                	jbe    c010617d <kfree+0x39>
c0106159:	c7 44 24 0c 5d a0 10 	movl   $0xc010a05d,0xc(%esp)
c0106160:	c0 
c0106161:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0106168:	c0 
c0106169:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c0106170:	00 
c0106171:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c0106178:	e8 52 ab ff ff       	call   c0100ccf <__panic>
    assert(ptr != NULL);
c010617d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106181:	75 24                	jne    c01061a7 <kfree+0x63>
c0106183:	c7 44 24 0c 81 a0 10 	movl   $0xc010a081,0xc(%esp)
c010618a:	c0 
c010618b:	c7 44 24 08 09 9b 10 	movl   $0xc0109b09,0x8(%esp)
c0106192:	c0 
c0106193:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c010619a:	00 
c010619b:	c7 04 24 e4 9a 10 c0 	movl   $0xc0109ae4,(%esp)
c01061a2:	e8 28 ab ff ff       	call   c0100ccf <__panic>
    struct Page *base=NULL;
c01061a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c01061ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061b1:	05 ff 0f 00 00       	add    $0xfff,%eax
c01061b6:	c1 e8 0c             	shr    $0xc,%eax
c01061b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c01061bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01061bf:	89 04 24             	mov    %eax,(%esp)
c01061c2:	e8 19 e4 ff ff       	call   c01045e0 <kva2page>
c01061c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c01061ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d4:	89 04 24             	mov    %eax,(%esp)
c01061d7:	e8 fc e6 ff ff       	call   c01048d8 <free_pages>
}
c01061dc:	c9                   	leave  
c01061dd:	c3                   	ret    

c01061de <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01061de:	55                   	push   %ebp
c01061df:	89 e5                	mov    %esp,%ebp
c01061e1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01061e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01061e7:	c1 e8 0c             	shr    $0xc,%eax
c01061ea:	89 c2                	mov    %eax,%edx
c01061ec:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01061f1:	39 c2                	cmp    %eax,%edx
c01061f3:	72 1c                	jb     c0106211 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01061f5:	c7 44 24 08 90 a0 10 	movl   $0xc010a090,0x8(%esp)
c01061fc:	c0 
c01061fd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106204:	00 
c0106205:	c7 04 24 af a0 10 c0 	movl   $0xc010a0af,(%esp)
c010620c:	e8 be aa ff ff       	call   c0100ccf <__panic>
    }
    return &pages[PPN(pa)];
c0106211:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0106216:	8b 55 08             	mov    0x8(%ebp),%edx
c0106219:	c1 ea 0c             	shr    $0xc,%edx
c010621c:	c1 e2 05             	shl    $0x5,%edx
c010621f:	01 d0                	add    %edx,%eax
}
c0106221:	c9                   	leave  
c0106222:	c3                   	ret    

c0106223 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106223:	55                   	push   %ebp
c0106224:	89 e5                	mov    %esp,%ebp
c0106226:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106229:	8b 45 08             	mov    0x8(%ebp),%eax
c010622c:	83 e0 01             	and    $0x1,%eax
c010622f:	85 c0                	test   %eax,%eax
c0106231:	75 1c                	jne    c010624f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106233:	c7 44 24 08 c0 a0 10 	movl   $0xc010a0c0,0x8(%esp)
c010623a:	c0 
c010623b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106242:	00 
c0106243:	c7 04 24 af a0 10 c0 	movl   $0xc010a0af,(%esp)
c010624a:	e8 80 aa ff ff       	call   c0100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010624f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106252:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106257:	89 04 24             	mov    %eax,(%esp)
c010625a:	e8 7f ff ff ff       	call   c01061de <pa2page>
}
c010625f:	c9                   	leave  
c0106260:	c3                   	ret    

c0106261 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106261:	55                   	push   %ebp
c0106262:	89 e5                	mov    %esp,%ebp
c0106264:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106267:	e8 1c 1e 00 00       	call   c0108088 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010626c:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106271:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106276:	76 0c                	jbe    c0106284 <swap_init+0x23>
c0106278:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c010627d:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106282:	76 25                	jbe    c01062a9 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106284:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106289:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010628d:	c7 44 24 08 e1 a0 10 	movl   $0xc010a0e1,0x8(%esp)
c0106294:	c0 
c0106295:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010629c:	00 
c010629d:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01062a4:	e8 26 aa ff ff       	call   c0100ccf <__panic>
     }
     

     sm = &swap_manager_fifo;
c01062a9:	c7 05 b4 1a 12 c0 40 	movl   $0xc0120a40,0xc0121ab4
c01062b0:	0a 12 c0 
     int r = sm->init();
c01062b3:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01062b8:	8b 40 04             	mov    0x4(%eax),%eax
c01062bb:	ff d0                	call   *%eax
c01062bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01062c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01062c4:	75 26                	jne    c01062ec <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01062c6:	c7 05 ac 1a 12 c0 01 	movl   $0x1,0xc0121aac
c01062cd:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01062d0:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01062d5:	8b 00                	mov    (%eax),%eax
c01062d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062db:	c7 04 24 0b a1 10 c0 	movl   $0xc010a10b,(%esp)
c01062e2:	e8 64 a0 ff ff       	call   c010034b <cprintf>
          check_swap();
c01062e7:	e8 a4 04 00 00       	call   c0106790 <check_swap>
     }

     return r;
c01062ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062ef:	c9                   	leave  
c01062f0:	c3                   	ret    

c01062f1 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01062f1:	55                   	push   %ebp
c01062f2:	89 e5                	mov    %esp,%ebp
c01062f4:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01062f7:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01062fc:	8b 40 08             	mov    0x8(%eax),%eax
c01062ff:	8b 55 08             	mov    0x8(%ebp),%edx
c0106302:	89 14 24             	mov    %edx,(%esp)
c0106305:	ff d0                	call   *%eax
}
c0106307:	c9                   	leave  
c0106308:	c3                   	ret    

c0106309 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106309:	55                   	push   %ebp
c010630a:	89 e5                	mov    %esp,%ebp
c010630c:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c010630f:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106314:	8b 40 0c             	mov    0xc(%eax),%eax
c0106317:	8b 55 08             	mov    0x8(%ebp),%edx
c010631a:	89 14 24             	mov    %edx,(%esp)
c010631d:	ff d0                	call   *%eax
}
c010631f:	c9                   	leave  
c0106320:	c3                   	ret    

c0106321 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106321:	55                   	push   %ebp
c0106322:	89 e5                	mov    %esp,%ebp
c0106324:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106327:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010632c:	8b 40 10             	mov    0x10(%eax),%eax
c010632f:	8b 55 14             	mov    0x14(%ebp),%edx
c0106332:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106336:	8b 55 10             	mov    0x10(%ebp),%edx
c0106339:	89 54 24 08          	mov    %edx,0x8(%esp)
c010633d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106340:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106344:	8b 55 08             	mov    0x8(%ebp),%edx
c0106347:	89 14 24             	mov    %edx,(%esp)
c010634a:	ff d0                	call   *%eax
}
c010634c:	c9                   	leave  
c010634d:	c3                   	ret    

c010634e <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010634e:	55                   	push   %ebp
c010634f:	89 e5                	mov    %esp,%ebp
c0106351:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106354:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106359:	8b 40 14             	mov    0x14(%eax),%eax
c010635c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010635f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106363:	8b 55 08             	mov    0x8(%ebp),%edx
c0106366:	89 14 24             	mov    %edx,(%esp)
c0106369:	ff d0                	call   *%eax
}
c010636b:	c9                   	leave  
c010636c:	c3                   	ret    

c010636d <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010636d:	55                   	push   %ebp
c010636e:	89 e5                	mov    %esp,%ebp
c0106370:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010637a:	e9 5a 01 00 00       	jmp    c01064d9 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010637f:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106384:	8b 40 18             	mov    0x18(%eax),%eax
c0106387:	8b 55 10             	mov    0x10(%ebp),%edx
c010638a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010638e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106391:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106395:	8b 55 08             	mov    0x8(%ebp),%edx
c0106398:	89 14 24             	mov    %edx,(%esp)
c010639b:	ff d0                	call   *%eax
c010639d:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01063a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01063a4:	74 18                	je     c01063be <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01063a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063ad:	c7 04 24 20 a1 10 c0 	movl   $0xc010a120,(%esp)
c01063b4:	e8 92 9f ff ff       	call   c010034b <cprintf>
c01063b9:	e9 27 01 00 00       	jmp    c01064e5 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01063be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063c1:	8b 40 1c             	mov    0x1c(%eax),%eax
c01063c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01063c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ca:	8b 40 0c             	mov    0xc(%eax),%eax
c01063cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01063d4:	00 
c01063d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063d8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063dc:	89 04 24             	mov    %eax,(%esp)
c01063df:	e8 eb eb ff ff       	call   c0104fcf <get_pte>
c01063e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01063e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01063ea:	8b 00                	mov    (%eax),%eax
c01063ec:	83 e0 01             	and    $0x1,%eax
c01063ef:	85 c0                	test   %eax,%eax
c01063f1:	75 24                	jne    c0106417 <swap_out+0xaa>
c01063f3:	c7 44 24 0c 4d a1 10 	movl   $0xc010a14d,0xc(%esp)
c01063fa:	c0 
c01063fb:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106402:	c0 
c0106403:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010640a:	00 
c010640b:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106412:	e8 b8 a8 ff ff       	call   c0100ccf <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010641a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010641d:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106420:	c1 ea 0c             	shr    $0xc,%edx
c0106423:	83 c2 01             	add    $0x1,%edx
c0106426:	c1 e2 08             	shl    $0x8,%edx
c0106429:	89 44 24 04          	mov    %eax,0x4(%esp)
c010642d:	89 14 24             	mov    %edx,(%esp)
c0106430:	e8 0d 1d 00 00       	call   c0108142 <swapfs_write>
c0106435:	85 c0                	test   %eax,%eax
c0106437:	74 34                	je     c010646d <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106439:	c7 04 24 77 a1 10 c0 	movl   $0xc010a177,(%esp)
c0106440:	e8 06 9f ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106445:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010644a:	8b 40 10             	mov    0x10(%eax),%eax
c010644d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106450:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106457:	00 
c0106458:	89 54 24 08          	mov    %edx,0x8(%esp)
c010645c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010645f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106463:	8b 55 08             	mov    0x8(%ebp),%edx
c0106466:	89 14 24             	mov    %edx,(%esp)
c0106469:	ff d0                	call   *%eax
c010646b:	eb 68                	jmp    c01064d5 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c010646d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106470:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106473:	c1 e8 0c             	shr    $0xc,%eax
c0106476:	83 c0 01             	add    $0x1,%eax
c0106479:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010647d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106480:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106484:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010648b:	c7 04 24 90 a1 10 c0 	movl   $0xc010a190,(%esp)
c0106492:	e8 b4 9e ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010649a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010649d:	c1 e8 0c             	shr    $0xc,%eax
c01064a0:	83 c0 01             	add    $0x1,%eax
c01064a3:	c1 e0 08             	shl    $0x8,%eax
c01064a6:	89 c2                	mov    %eax,%edx
c01064a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064ab:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01064ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01064b7:	00 
c01064b8:	89 04 24             	mov    %eax,(%esp)
c01064bb:	e8 18 e4 ff ff       	call   c01048d8 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01064c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01064c3:	8b 40 0c             	mov    0xc(%eax),%eax
c01064c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01064c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064cd:	89 04 24             	mov    %eax,(%esp)
c01064d0:	e8 ee ed ff ff       	call   c01052c3 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01064d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01064d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01064df:	0f 85 9a fe ff ff    	jne    c010637f <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01064e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01064e8:	c9                   	leave  
c01064e9:	c3                   	ret    

c01064ea <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01064ea:	55                   	push   %ebp
c01064eb:	89 e5                	mov    %esp,%ebp
c01064ed:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01064f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01064f7:	e8 71 e3 ff ff       	call   c010486d <alloc_pages>
c01064fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01064ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106503:	75 24                	jne    c0106529 <swap_in+0x3f>
c0106505:	c7 44 24 0c d0 a1 10 	movl   $0xc010a1d0,0xc(%esp)
c010650c:	c0 
c010650d:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106514:	c0 
c0106515:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c010651c:	00 
c010651d:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106524:	e8 a6 a7 ff ff       	call   c0100ccf <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106529:	8b 45 08             	mov    0x8(%ebp),%eax
c010652c:	8b 40 0c             	mov    0xc(%eax),%eax
c010652f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106536:	00 
c0106537:	8b 55 0c             	mov    0xc(%ebp),%edx
c010653a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010653e:	89 04 24             	mov    %eax,(%esp)
c0106541:	e8 89 ea ff ff       	call   c0104fcf <get_pte>
c0106546:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106549:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010654c:	8b 00                	mov    (%eax),%eax
c010654e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106551:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106555:	89 04 24             	mov    %eax,(%esp)
c0106558:	e8 73 1b 00 00       	call   c01080d0 <swapfs_read>
c010655d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106560:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106564:	74 2a                	je     c0106590 <swap_in+0xa6>
     {
        assert(r!=0);
c0106566:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010656a:	75 24                	jne    c0106590 <swap_in+0xa6>
c010656c:	c7 44 24 0c dd a1 10 	movl   $0xc010a1dd,0xc(%esp)
c0106573:	c0 
c0106574:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c010657b:	c0 
c010657c:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106583:	00 
c0106584:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c010658b:	e8 3f a7 ff ff       	call   c0100ccf <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106590:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106593:	8b 00                	mov    (%eax),%eax
c0106595:	c1 e8 08             	shr    $0x8,%eax
c0106598:	89 c2                	mov    %eax,%edx
c010659a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010659d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01065a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065a5:	c7 04 24 e4 a1 10 c0 	movl   $0xc010a1e4,(%esp)
c01065ac:	e8 9a 9d ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c01065b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01065b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01065b7:	89 10                	mov    %edx,(%eax)
     return 0;
c01065b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01065be:	c9                   	leave  
c01065bf:	c3                   	ret    

c01065c0 <check_content_set>:



static inline void
check_content_set(void)
{
c01065c0:	55                   	push   %ebp
c01065c1:	89 e5                	mov    %esp,%ebp
c01065c3:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01065c6:	b8 00 10 00 00       	mov    $0x1000,%eax
c01065cb:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01065ce:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065d3:	83 f8 01             	cmp    $0x1,%eax
c01065d6:	74 24                	je     c01065fc <check_content_set+0x3c>
c01065d8:	c7 44 24 0c 22 a2 10 	movl   $0xc010a222,0xc(%esp)
c01065df:	c0 
c01065e0:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01065e7:	c0 
c01065e8:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01065ef:	00 
c01065f0:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01065f7:	e8 d3 a6 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01065fc:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106601:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106604:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106609:	83 f8 01             	cmp    $0x1,%eax
c010660c:	74 24                	je     c0106632 <check_content_set+0x72>
c010660e:	c7 44 24 0c 22 a2 10 	movl   $0xc010a222,0xc(%esp)
c0106615:	c0 
c0106616:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c010661d:	c0 
c010661e:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106625:	00 
c0106626:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c010662d:	e8 9d a6 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106632:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106637:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010663a:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010663f:	83 f8 02             	cmp    $0x2,%eax
c0106642:	74 24                	je     c0106668 <check_content_set+0xa8>
c0106644:	c7 44 24 0c 31 a2 10 	movl   $0xc010a231,0xc(%esp)
c010664b:	c0 
c010664c:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106653:	c0 
c0106654:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010665b:	00 
c010665c:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106663:	e8 67 a6 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106668:	b8 10 20 00 00       	mov    $0x2010,%eax
c010666d:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106670:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106675:	83 f8 02             	cmp    $0x2,%eax
c0106678:	74 24                	je     c010669e <check_content_set+0xde>
c010667a:	c7 44 24 0c 31 a2 10 	movl   $0xc010a231,0xc(%esp)
c0106681:	c0 
c0106682:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106689:	c0 
c010668a:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106691:	00 
c0106692:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106699:	e8 31 a6 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c010669e:	b8 00 30 00 00       	mov    $0x3000,%eax
c01066a3:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01066a6:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01066ab:	83 f8 03             	cmp    $0x3,%eax
c01066ae:	74 24                	je     c01066d4 <check_content_set+0x114>
c01066b0:	c7 44 24 0c 40 a2 10 	movl   $0xc010a240,0xc(%esp)
c01066b7:	c0 
c01066b8:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01066bf:	c0 
c01066c0:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01066c7:	00 
c01066c8:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01066cf:	e8 fb a5 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01066d4:	b8 10 30 00 00       	mov    $0x3010,%eax
c01066d9:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01066dc:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01066e1:	83 f8 03             	cmp    $0x3,%eax
c01066e4:	74 24                	je     c010670a <check_content_set+0x14a>
c01066e6:	c7 44 24 0c 40 a2 10 	movl   $0xc010a240,0xc(%esp)
c01066ed:	c0 
c01066ee:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01066f5:	c0 
c01066f6:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01066fd:	00 
c01066fe:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106705:	e8 c5 a5 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010670a:	b8 00 40 00 00       	mov    $0x4000,%eax
c010670f:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106712:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106717:	83 f8 04             	cmp    $0x4,%eax
c010671a:	74 24                	je     c0106740 <check_content_set+0x180>
c010671c:	c7 44 24 0c 4f a2 10 	movl   $0xc010a24f,0xc(%esp)
c0106723:	c0 
c0106724:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c010672b:	c0 
c010672c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106733:	00 
c0106734:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c010673b:	e8 8f a5 ff ff       	call   c0100ccf <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106740:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106745:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106748:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010674d:	83 f8 04             	cmp    $0x4,%eax
c0106750:	74 24                	je     c0106776 <check_content_set+0x1b6>
c0106752:	c7 44 24 0c 4f a2 10 	movl   $0xc010a24f,0xc(%esp)
c0106759:	c0 
c010675a:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106761:	c0 
c0106762:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106769:	00 
c010676a:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106771:	e8 59 a5 ff ff       	call   c0100ccf <__panic>
}
c0106776:	c9                   	leave  
c0106777:	c3                   	ret    

c0106778 <check_content_access>:

static inline int
check_content_access(void)
{
c0106778:	55                   	push   %ebp
c0106779:	89 e5                	mov    %esp,%ebp
c010677b:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010677e:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106783:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106786:	ff d0                	call   *%eax
c0106788:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010678b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010678e:	c9                   	leave  
c010678f:	c3                   	ret    

c0106790 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106790:	55                   	push   %ebp
c0106791:	89 e5                	mov    %esp,%ebp
c0106793:	53                   	push   %ebx
c0106794:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010679e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01067a5:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01067ac:	eb 6b                	jmp    c0106819 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01067ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067b1:	83 e8 0c             	sub    $0xc,%eax
c01067b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01067b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067ba:	83 c0 04             	add    $0x4,%eax
c01067bd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01067c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01067ca:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01067cd:	0f a3 10             	bt     %edx,(%eax)
c01067d0:	19 c0                	sbb    %eax,%eax
c01067d2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01067d5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01067d9:	0f 95 c0             	setne  %al
c01067dc:	0f b6 c0             	movzbl %al,%eax
c01067df:	85 c0                	test   %eax,%eax
c01067e1:	75 24                	jne    c0106807 <check_swap+0x77>
c01067e3:	c7 44 24 0c 5e a2 10 	movl   $0xc010a25e,0xc(%esp)
c01067ea:	c0 
c01067eb:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01067f2:	c0 
c01067f3:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01067fa:	00 
c01067fb:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106802:	e8 c8 a4 ff ff       	call   c0100ccf <__panic>
        count ++, total += p->property;
c0106807:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010680b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010680e:	8b 50 08             	mov    0x8(%eax),%edx
c0106811:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106814:	01 d0                	add    %edx,%eax
c0106816:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106819:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010681c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010681f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106822:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106825:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106828:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c010682f:	0f 85 79 ff ff ff    	jne    c01067ae <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106835:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106838:	e8 cd e0 ff ff       	call   c010490a <nr_free_pages>
c010683d:	39 c3                	cmp    %eax,%ebx
c010683f:	74 24                	je     c0106865 <check_swap+0xd5>
c0106841:	c7 44 24 0c 6e a2 10 	movl   $0xc010a26e,0xc(%esp)
c0106848:	c0 
c0106849:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106850:	c0 
c0106851:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106858:	00 
c0106859:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106860:	e8 6a a4 ff ff       	call   c0100ccf <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106865:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106868:	89 44 24 08          	mov    %eax,0x8(%esp)
c010686c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010686f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106873:	c7 04 24 88 a2 10 c0 	movl   $0xc010a288,(%esp)
c010687a:	e8 cc 9a ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010687f:	e8 3b 0a 00 00       	call   c01072bf <mm_create>
c0106884:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106887:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010688b:	75 24                	jne    c01068b1 <check_swap+0x121>
c010688d:	c7 44 24 0c ae a2 10 	movl   $0xc010a2ae,0xc(%esp)
c0106894:	c0 
c0106895:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c010689c:	c0 
c010689d:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01068a4:	00 
c01068a5:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01068ac:	e8 1e a4 ff ff       	call   c0100ccf <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01068b1:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01068b6:	85 c0                	test   %eax,%eax
c01068b8:	74 24                	je     c01068de <check_swap+0x14e>
c01068ba:	c7 44 24 0c b9 a2 10 	movl   $0xc010a2b9,0xc(%esp)
c01068c1:	c0 
c01068c2:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01068c9:	c0 
c01068ca:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01068d1:	00 
c01068d2:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01068d9:	e8 f1 a3 ff ff       	call   c0100ccf <__panic>

     check_mm_struct = mm;
c01068de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068e1:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01068e6:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c01068ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068ef:	89 50 0c             	mov    %edx,0xc(%eax)
c01068f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068f5:	8b 40 0c             	mov    0xc(%eax),%eax
c01068f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01068fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068fe:	8b 00                	mov    (%eax),%eax
c0106900:	85 c0                	test   %eax,%eax
c0106902:	74 24                	je     c0106928 <check_swap+0x198>
c0106904:	c7 44 24 0c d1 a2 10 	movl   $0xc010a2d1,0xc(%esp)
c010690b:	c0 
c010690c:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106913:	c0 
c0106914:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010691b:	00 
c010691c:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106923:	e8 a7 a3 ff ff       	call   c0100ccf <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106928:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c010692f:	00 
c0106930:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106937:	00 
c0106938:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c010693f:	e8 f3 09 00 00       	call   c0107337 <vma_create>
c0106944:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106947:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010694b:	75 24                	jne    c0106971 <check_swap+0x1e1>
c010694d:	c7 44 24 0c df a2 10 	movl   $0xc010a2df,0xc(%esp)
c0106954:	c0 
c0106955:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c010695c:	c0 
c010695d:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106964:	00 
c0106965:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c010696c:	e8 5e a3 ff ff       	call   c0100ccf <__panic>

     insert_vma_struct(mm, vma);
c0106971:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106974:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106978:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010697b:	89 04 24             	mov    %eax,(%esp)
c010697e:	e8 44 0b 00 00       	call   c01074c7 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106983:	c7 04 24 ec a2 10 c0 	movl   $0xc010a2ec,(%esp)
c010698a:	e8 bc 99 ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c010698f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106996:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106999:	8b 40 0c             	mov    0xc(%eax),%eax
c010699c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01069a3:	00 
c01069a4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01069ab:	00 
c01069ac:	89 04 24             	mov    %eax,(%esp)
c01069af:	e8 1b e6 ff ff       	call   c0104fcf <get_pte>
c01069b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01069b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01069bb:	75 24                	jne    c01069e1 <check_swap+0x251>
c01069bd:	c7 44 24 0c 20 a3 10 	movl   $0xc010a320,0xc(%esp)
c01069c4:	c0 
c01069c5:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c01069cc:	c0 
c01069cd:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01069d4:	00 
c01069d5:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c01069dc:	e8 ee a2 ff ff       	call   c0100ccf <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01069e1:	c7 04 24 34 a3 10 c0 	movl   $0xc010a334,(%esp)
c01069e8:	e8 5e 99 ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069f4:	e9 a3 00 00 00       	jmp    c0106a9c <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01069f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a00:	e8 68 de ff ff       	call   c010486d <alloc_pages>
c0106a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a08:	89 04 95 e0 1a 12 c0 	mov    %eax,-0x3fede520(,%edx,4)
          assert(check_rp[i] != NULL );
c0106a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a12:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106a19:	85 c0                	test   %eax,%eax
c0106a1b:	75 24                	jne    c0106a41 <check_swap+0x2b1>
c0106a1d:	c7 44 24 0c 58 a3 10 	movl   $0xc010a358,0xc(%esp)
c0106a24:	c0 
c0106a25:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106a2c:	c0 
c0106a2d:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106a34:	00 
c0106a35:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106a3c:	e8 8e a2 ff ff       	call   c0100ccf <__panic>
          assert(!PageProperty(check_rp[i]));
c0106a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a44:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106a4b:	83 c0 04             	add    $0x4,%eax
c0106a4e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106a55:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106a58:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106a5b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106a5e:	0f a3 10             	bt     %edx,(%eax)
c0106a61:	19 c0                	sbb    %eax,%eax
c0106a63:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106a66:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106a6a:	0f 95 c0             	setne  %al
c0106a6d:	0f b6 c0             	movzbl %al,%eax
c0106a70:	85 c0                	test   %eax,%eax
c0106a72:	74 24                	je     c0106a98 <check_swap+0x308>
c0106a74:	c7 44 24 0c 6c a3 10 	movl   $0xc010a36c,0xc(%esp)
c0106a7b:	c0 
c0106a7c:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106a83:	c0 
c0106a84:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106a8b:	00 
c0106a8c:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106a93:	e8 37 a2 ff ff       	call   c0100ccf <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a98:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a9c:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106aa0:	0f 8e 53 ff ff ff    	jle    c01069f9 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106aa6:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0106aab:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0106ab1:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106ab4:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106ab7:	c7 45 a8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106abe:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106ac1:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106ac4:	89 50 04             	mov    %edx,0x4(%eax)
c0106ac7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106aca:	8b 50 04             	mov    0x4(%eax),%edx
c0106acd:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106ad0:	89 10                	mov    %edx,(%eax)
c0106ad2:	c7 45 a4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106ad9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106adc:	8b 40 04             	mov    0x4(%eax),%eax
c0106adf:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106ae2:	0f 94 c0             	sete   %al
c0106ae5:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106ae8:	85 c0                	test   %eax,%eax
c0106aea:	75 24                	jne    c0106b10 <check_swap+0x380>
c0106aec:	c7 44 24 0c 87 a3 10 	movl   $0xc010a387,0xc(%esp)
c0106af3:	c0 
c0106af4:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106afb:	c0 
c0106afc:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106b03:	00 
c0106b04:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106b0b:	e8 bf a1 ff ff       	call   c0100ccf <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106b10:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106b15:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106b18:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0106b1f:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b29:	eb 1e                	jmp    c0106b49 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b2e:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106b35:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b3c:	00 
c0106b3d:	89 04 24             	mov    %eax,(%esp)
c0106b40:	e8 93 dd ff ff       	call   c01048d8 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b45:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b49:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b4d:	7e dc                	jle    c0106b2b <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106b4f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106b54:	83 f8 04             	cmp    $0x4,%eax
c0106b57:	74 24                	je     c0106b7d <check_swap+0x3ed>
c0106b59:	c7 44 24 0c a0 a3 10 	movl   $0xc010a3a0,0xc(%esp)
c0106b60:	c0 
c0106b61:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106b68:	c0 
c0106b69:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106b70:	00 
c0106b71:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106b78:	e8 52 a1 ff ff       	call   c0100ccf <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106b7d:	c7 04 24 c4 a3 10 c0 	movl   $0xc010a3c4,(%esp)
c0106b84:	e8 c2 97 ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106b89:	c7 05 b8 1a 12 c0 00 	movl   $0x0,0xc0121ab8
c0106b90:	00 00 00 
     
     check_content_set();
c0106b93:	e8 28 fa ff ff       	call   c01065c0 <check_content_set>
     assert( nr_free == 0);         
c0106b98:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106b9d:	85 c0                	test   %eax,%eax
c0106b9f:	74 24                	je     c0106bc5 <check_swap+0x435>
c0106ba1:	c7 44 24 0c eb a3 10 	movl   $0xc010a3eb,0xc(%esp)
c0106ba8:	c0 
c0106ba9:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106bb0:	c0 
c0106bb1:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106bb8:	00 
c0106bb9:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106bc0:	e8 0a a1 ff ff       	call   c0100ccf <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106bc5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106bcc:	eb 26                	jmp    c0106bf4 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bd1:	c7 04 85 00 1b 12 c0 	movl   $0xffffffff,-0x3fede500(,%eax,4)
c0106bd8:	ff ff ff ff 
c0106bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bdf:	8b 14 85 00 1b 12 c0 	mov    -0x3fede500(,%eax,4),%edx
c0106be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106be9:	89 14 85 40 1b 12 c0 	mov    %edx,-0x3fede4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106bf0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106bf4:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106bf8:	7e d4                	jle    c0106bce <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106bfa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106c01:	e9 eb 00 00 00       	jmp    c0106cf1 <check_swap+0x561>
         check_ptep[i]=0;
c0106c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c09:	c7 04 85 94 1b 12 c0 	movl   $0x0,-0x3fede46c(,%eax,4)
c0106c10:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c17:	83 c0 01             	add    $0x1,%eax
c0106c1a:	c1 e0 0c             	shl    $0xc,%eax
c0106c1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106c24:	00 
c0106c25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c2c:	89 04 24             	mov    %eax,(%esp)
c0106c2f:	e8 9b e3 ff ff       	call   c0104fcf <get_pte>
c0106c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c37:	89 04 95 94 1b 12 c0 	mov    %eax,-0x3fede46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c41:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106c48:	85 c0                	test   %eax,%eax
c0106c4a:	75 24                	jne    c0106c70 <check_swap+0x4e0>
c0106c4c:	c7 44 24 0c f8 a3 10 	movl   $0xc010a3f8,0xc(%esp)
c0106c53:	c0 
c0106c54:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106c5b:	c0 
c0106c5c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106c63:	00 
c0106c64:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106c6b:	e8 5f a0 ff ff       	call   c0100ccf <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c73:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106c7a:	8b 00                	mov    (%eax),%eax
c0106c7c:	89 04 24             	mov    %eax,(%esp)
c0106c7f:	e8 9f f5 ff ff       	call   c0106223 <pte2page>
c0106c84:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c87:	8b 14 95 e0 1a 12 c0 	mov    -0x3fede520(,%edx,4),%edx
c0106c8e:	39 d0                	cmp    %edx,%eax
c0106c90:	74 24                	je     c0106cb6 <check_swap+0x526>
c0106c92:	c7 44 24 0c 10 a4 10 	movl   $0xc010a410,0xc(%esp)
c0106c99:	c0 
c0106c9a:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106ca1:	c0 
c0106ca2:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106ca9:	00 
c0106caa:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106cb1:	e8 19 a0 ff ff       	call   c0100ccf <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106cb9:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106cc0:	8b 00                	mov    (%eax),%eax
c0106cc2:	83 e0 01             	and    $0x1,%eax
c0106cc5:	85 c0                	test   %eax,%eax
c0106cc7:	75 24                	jne    c0106ced <check_swap+0x55d>
c0106cc9:	c7 44 24 0c 38 a4 10 	movl   $0xc010a438,0xc(%esp)
c0106cd0:	c0 
c0106cd1:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106cd8:	c0 
c0106cd9:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106ce0:	00 
c0106ce1:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106ce8:	e8 e2 9f ff ff       	call   c0100ccf <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ced:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106cf1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106cf5:	0f 8e 0b ff ff ff    	jle    c0106c06 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106cfb:	c7 04 24 54 a4 10 c0 	movl   $0xc010a454,(%esp)
c0106d02:	e8 44 96 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106d07:	e8 6c fa ff ff       	call   c0106778 <check_content_access>
c0106d0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106d0f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106d13:	74 24                	je     c0106d39 <check_swap+0x5a9>
c0106d15:	c7 44 24 0c 7a a4 10 	movl   $0xc010a47a,0xc(%esp)
c0106d1c:	c0 
c0106d1d:	c7 44 24 08 62 a1 10 	movl   $0xc010a162,0x8(%esp)
c0106d24:	c0 
c0106d25:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106d2c:	00 
c0106d2d:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0106d34:	e8 96 9f ff ff       	call   c0100ccf <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106d40:	eb 1e                	jmp    c0106d60 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d45:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106d4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106d53:	00 
c0106d54:	89 04 24             	mov    %eax,(%esp)
c0106d57:	e8 7c db ff ff       	call   c01048d8 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d5c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106d60:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106d64:	7e dc                	jle    c0106d42 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d69:	89 04 24             	mov    %eax,(%esp)
c0106d6c:	e8 86 08 00 00       	call   c01075f7 <mm_destroy>
         
     nr_free = nr_free_store;
c0106d71:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d74:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
     free_list = free_list_store;
c0106d79:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106d7c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106d7f:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0106d84:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4

     
     le = &free_list;
c0106d8a:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106d91:	eb 1d                	jmp    c0106db0 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d96:	83 e8 0c             	sub    $0xc,%eax
c0106d99:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106d9c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106da0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106da3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106da6:	8b 40 08             	mov    0x8(%eax),%eax
c0106da9:	29 c2                	sub    %eax,%edx
c0106dab:	89 d0                	mov    %edx,%eax
c0106dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106db0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106db3:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106db6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106db9:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106dbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106dbf:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106dc6:	75 cb                	jne    c0106d93 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dcb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dd6:	c7 04 24 81 a4 10 c0 	movl   $0xc010a481,(%esp)
c0106ddd:	e8 69 95 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106de2:	c7 04 24 9b a4 10 c0 	movl   $0xc010a49b,(%esp)
c0106de9:	e8 5d 95 ff ff       	call   c010034b <cprintf>
}
c0106dee:	83 c4 74             	add    $0x74,%esp
c0106df1:	5b                   	pop    %ebx
c0106df2:	5d                   	pop    %ebp
c0106df3:	c3                   	ret    

c0106df4 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106df4:	55                   	push   %ebp
c0106df5:	89 e5                	mov    %esp,%ebp
c0106df7:	83 ec 10             	sub    $0x10,%esp
c0106dfa:	c7 45 fc a4 1b 12 c0 	movl   $0xc0121ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e04:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106e07:	89 50 04             	mov    %edx,0x4(%eax)
c0106e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e0d:	8b 50 04             	mov    0x4(%eax),%edx
c0106e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e13:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e18:	c7 40 14 a4 1b 12 c0 	movl   $0xc0121ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e24:	c9                   	leave  
c0106e25:	c3                   	ret    

c0106e26 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106e26:	55                   	push   %ebp
c0106e27:	89 e5                	mov    %esp,%ebp
c0106e29:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e2f:	8b 40 14             	mov    0x14(%eax),%eax
c0106e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106e35:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e38:	83 c0 14             	add    $0x14,%eax
c0106e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e42:	74 06                	je     c0106e4a <_fifo_map_swappable+0x24>
c0106e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e48:	75 24                	jne    c0106e6e <_fifo_map_swappable+0x48>
c0106e4a:	c7 44 24 0c b4 a4 10 	movl   $0xc010a4b4,0xc(%esp)
c0106e51:	c0 
c0106e52:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106e59:	c0 
c0106e5a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106e61:	00 
c0106e62:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106e69:	e8 61 9e ff ff       	call   c0100ccf <__panic>
c0106e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e77:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e7d:	8b 40 04             	mov    0x4(%eax),%eax
c0106e80:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106e83:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e89:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0106e8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106e8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e95:	89 10                	mov    %edx,(%eax)
c0106e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e9a:	8b 10                	mov    (%eax),%edx
c0106e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e9f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ea5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ea8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106eae:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106eb1:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
c0106eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106eb8:	c9                   	leave  
c0106eb9:	c3                   	ret    

c0106eba <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106eba:	55                   	push   %ebp
c0106ebb:	89 e5                	mov    %esp,%ebp
c0106ebd:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106ec0:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ec3:	8b 40 14             	mov    0x14(%eax),%eax
c0106ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ecd:	75 24                	jne    c0106ef3 <_fifo_swap_out_victim+0x39>
c0106ecf:	c7 44 24 0c fb a4 10 	movl   $0xc010a4fb,0xc(%esp)
c0106ed6:	c0 
c0106ed7:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106ede:	c0 
c0106edf:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106ee6:	00 
c0106ee7:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106eee:	e8 dc 9d ff ff       	call   c0100ccf <__panic>
     assert(in_tick==0);
c0106ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106ef7:	74 24                	je     c0106f1d <_fifo_swap_out_victim+0x63>
c0106ef9:	c7 44 24 0c 08 a5 10 	movl   $0xc010a508,0xc(%esp)
c0106f00:	c0 
c0106f01:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106f08:	c0 
c0106f09:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106f10:	00 
c0106f11:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106f18:	e8 b2 9d ff ff       	call   c0100ccf <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t* tar = head->prev;
c0106f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f20:	8b 00                	mov    (%eax),%eax
c0106f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(tar != head);
c0106f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106f2b:	75 24                	jne    c0106f51 <_fifo_swap_out_victim+0x97>
c0106f2d:	c7 44 24 0c 13 a5 10 	movl   $0xc010a513,0xc(%esp)
c0106f34:	c0 
c0106f35:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106f3c:	c0 
c0106f3d:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0106f44:	00 
c0106f45:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106f4c:	e8 7e 9d ff ff       	call   c0100ccf <__panic>
     struct Page* p = le2page(tar, pra_page_link);
c0106f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f54:	83 e8 14             	sub    $0x14,%eax
c0106f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f63:	8b 40 04             	mov    0x4(%eax),%eax
c0106f66:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106f69:	8b 12                	mov    (%edx),%edx
c0106f6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f74:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106f77:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f80:	89 10                	mov    %edx,(%eax)
     list_del(tar);
     assert(p != NULL);
c0106f82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106f86:	75 24                	jne    c0106fac <_fifo_swap_out_victim+0xf2>
c0106f88:	c7 44 24 0c 1f a5 10 	movl   $0xc010a51f,0xc(%esp)
c0106f8f:	c0 
c0106f90:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106f97:	c0 
c0106f98:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0106f9f:	00 
c0106fa0:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106fa7:	e8 23 9d ff ff       	call   c0100ccf <__panic>
     *ptr_page = p;
c0106fac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106faf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106fb2:	89 10                	mov    %edx,(%eax)
     return 0;
c0106fb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fb9:	c9                   	leave  
c0106fba:	c3                   	ret    

c0106fbb <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106fbb:	55                   	push   %ebp
c0106fbc:	89 e5                	mov    %esp,%ebp
c0106fbe:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106fc1:	c7 04 24 2c a5 10 c0 	movl   $0xc010a52c,(%esp)
c0106fc8:	e8 7e 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106fcd:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106fd2:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106fd5:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fda:	83 f8 04             	cmp    $0x4,%eax
c0106fdd:	74 24                	je     c0107003 <_fifo_check_swap+0x48>
c0106fdf:	c7 44 24 0c 52 a5 10 	movl   $0xc010a552,0xc(%esp)
c0106fe6:	c0 
c0106fe7:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0106fee:	c0 
c0106fef:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0106ff6:	00 
c0106ff7:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0106ffe:	e8 cc 9c ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107003:	c7 04 24 64 a5 10 c0 	movl   $0xc010a564,(%esp)
c010700a:	e8 3c 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010700f:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107014:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107017:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010701c:	83 f8 04             	cmp    $0x4,%eax
c010701f:	74 24                	je     c0107045 <_fifo_check_swap+0x8a>
c0107021:	c7 44 24 0c 52 a5 10 	movl   $0xc010a552,0xc(%esp)
c0107028:	c0 
c0107029:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0107030:	c0 
c0107031:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107038:	00 
c0107039:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0107040:	e8 8a 9c ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107045:	c7 04 24 8c a5 10 c0 	movl   $0xc010a58c,(%esp)
c010704c:	e8 fa 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107051:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107056:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107059:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010705e:	83 f8 04             	cmp    $0x4,%eax
c0107061:	74 24                	je     c0107087 <_fifo_check_swap+0xcc>
c0107063:	c7 44 24 0c 52 a5 10 	movl   $0xc010a552,0xc(%esp)
c010706a:	c0 
c010706b:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0107072:	c0 
c0107073:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010707a:	00 
c010707b:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0107082:	e8 48 9c ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107087:	c7 04 24 b4 a5 10 c0 	movl   $0xc010a5b4,(%esp)
c010708e:	e8 b8 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107093:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107098:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010709b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070a0:	83 f8 04             	cmp    $0x4,%eax
c01070a3:	74 24                	je     c01070c9 <_fifo_check_swap+0x10e>
c01070a5:	c7 44 24 0c 52 a5 10 	movl   $0xc010a552,0xc(%esp)
c01070ac:	c0 
c01070ad:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c01070b4:	c0 
c01070b5:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c01070bc:	00 
c01070bd:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c01070c4:	e8 06 9c ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01070c9:	c7 04 24 dc a5 10 c0 	movl   $0xc010a5dc,(%esp)
c01070d0:	e8 76 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01070d5:	b8 00 50 00 00       	mov    $0x5000,%eax
c01070da:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01070dd:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070e2:	83 f8 05             	cmp    $0x5,%eax
c01070e5:	74 24                	je     c010710b <_fifo_check_swap+0x150>
c01070e7:	c7 44 24 0c 02 a6 10 	movl   $0xc010a602,0xc(%esp)
c01070ee:	c0 
c01070ef:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c01070f6:	c0 
c01070f7:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c01070fe:	00 
c01070ff:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0107106:	e8 c4 9b ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010710b:	c7 04 24 b4 a5 10 c0 	movl   $0xc010a5b4,(%esp)
c0107112:	e8 34 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107117:	b8 00 20 00 00       	mov    $0x2000,%eax
c010711c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010711f:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107124:	83 f8 05             	cmp    $0x5,%eax
c0107127:	74 24                	je     c010714d <_fifo_check_swap+0x192>
c0107129:	c7 44 24 0c 02 a6 10 	movl   $0xc010a602,0xc(%esp)
c0107130:	c0 
c0107131:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0107138:	c0 
c0107139:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107140:	00 
c0107141:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0107148:	e8 82 9b ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010714d:	c7 04 24 64 a5 10 c0 	movl   $0xc010a564,(%esp)
c0107154:	e8 f2 91 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107159:	b8 00 10 00 00       	mov    $0x1000,%eax
c010715e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107161:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107166:	83 f8 06             	cmp    $0x6,%eax
c0107169:	74 24                	je     c010718f <_fifo_check_swap+0x1d4>
c010716b:	c7 44 24 0c 11 a6 10 	movl   $0xc010a611,0xc(%esp)
c0107172:	c0 
c0107173:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c010717a:	c0 
c010717b:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107182:	00 
c0107183:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c010718a:	e8 40 9b ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010718f:	c7 04 24 b4 a5 10 c0 	movl   $0xc010a5b4,(%esp)
c0107196:	e8 b0 91 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010719b:	b8 00 20 00 00       	mov    $0x2000,%eax
c01071a0:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01071a3:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01071a8:	83 f8 07             	cmp    $0x7,%eax
c01071ab:	74 24                	je     c01071d1 <_fifo_check_swap+0x216>
c01071ad:	c7 44 24 0c 20 a6 10 	movl   $0xc010a620,0xc(%esp)
c01071b4:	c0 
c01071b5:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c01071bc:	c0 
c01071bd:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01071c4:	00 
c01071c5:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c01071cc:	e8 fe 9a ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01071d1:	c7 04 24 2c a5 10 c0 	movl   $0xc010a52c,(%esp)
c01071d8:	e8 6e 91 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01071dd:	b8 00 30 00 00       	mov    $0x3000,%eax
c01071e2:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01071e5:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01071ea:	83 f8 08             	cmp    $0x8,%eax
c01071ed:	74 24                	je     c0107213 <_fifo_check_swap+0x258>
c01071ef:	c7 44 24 0c 2f a6 10 	movl   $0xc010a62f,0xc(%esp)
c01071f6:	c0 
c01071f7:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c01071fe:	c0 
c01071ff:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107206:	00 
c0107207:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c010720e:	e8 bc 9a ff ff       	call   c0100ccf <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107213:	c7 04 24 8c a5 10 c0 	movl   $0xc010a58c,(%esp)
c010721a:	e8 2c 91 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010721f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107224:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107227:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010722c:	83 f8 09             	cmp    $0x9,%eax
c010722f:	74 24                	je     c0107255 <_fifo_check_swap+0x29a>
c0107231:	c7 44 24 0c 3e a6 10 	movl   $0xc010a63e,0xc(%esp)
c0107238:	c0 
c0107239:	c7 44 24 08 d2 a4 10 	movl   $0xc010a4d2,0x8(%esp)
c0107240:	c0 
c0107241:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107248:	00 
c0107249:	c7 04 24 e7 a4 10 c0 	movl   $0xc010a4e7,(%esp)
c0107250:	e8 7a 9a ff ff       	call   c0100ccf <__panic>
    return 0;
c0107255:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010725a:	c9                   	leave  
c010725b:	c3                   	ret    

c010725c <_fifo_init>:


static int
_fifo_init(void)
{
c010725c:	55                   	push   %ebp
c010725d:	89 e5                	mov    %esp,%ebp
    return 0;
c010725f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107264:	5d                   	pop    %ebp
c0107265:	c3                   	ret    

c0107266 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107266:	55                   	push   %ebp
c0107267:	89 e5                	mov    %esp,%ebp
    return 0;
c0107269:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010726e:	5d                   	pop    %ebp
c010726f:	c3                   	ret    

c0107270 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107270:	55                   	push   %ebp
c0107271:	89 e5                	mov    %esp,%ebp
c0107273:	b8 00 00 00 00       	mov    $0x0,%eax
c0107278:	5d                   	pop    %ebp
c0107279:	c3                   	ret    

c010727a <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010727a:	55                   	push   %ebp
c010727b:	89 e5                	mov    %esp,%ebp
c010727d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107280:	8b 45 08             	mov    0x8(%ebp),%eax
c0107283:	c1 e8 0c             	shr    $0xc,%eax
c0107286:	89 c2                	mov    %eax,%edx
c0107288:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010728d:	39 c2                	cmp    %eax,%edx
c010728f:	72 1c                	jb     c01072ad <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107291:	c7 44 24 08 60 a6 10 	movl   $0xc010a660,0x8(%esp)
c0107298:	c0 
c0107299:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01072a0:	00 
c01072a1:	c7 04 24 7f a6 10 c0 	movl   $0xc010a67f,(%esp)
c01072a8:	e8 22 9a ff ff       	call   c0100ccf <__panic>
    }
    return &pages[PPN(pa)];
c01072ad:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01072b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01072b5:	c1 ea 0c             	shr    $0xc,%edx
c01072b8:	c1 e2 05             	shl    $0x5,%edx
c01072bb:	01 d0                	add    %edx,%eax
}
c01072bd:	c9                   	leave  
c01072be:	c3                   	ret    

c01072bf <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01072bf:	55                   	push   %ebp
c01072c0:	89 e5                	mov    %esp,%ebp
c01072c2:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01072c5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01072cc:	e8 d3 ed ff ff       	call   c01060a4 <kmalloc>
c01072d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01072d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01072d8:	74 58                	je     c0107332 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01072da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01072e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01072e6:	89 50 04             	mov    %edx,0x4(%eax)
c01072e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072ec:	8b 50 04             	mov    0x4(%eax),%edx
c01072ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072f2:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01072f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01072fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107301:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107308:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010730b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107312:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107317:	85 c0                	test   %eax,%eax
c0107319:	74 0d                	je     c0107328 <mm_create+0x69>
c010731b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010731e:	89 04 24             	mov    %eax,(%esp)
c0107321:	e8 cb ef ff ff       	call   c01062f1 <swap_init_mm>
c0107326:	eb 0a                	jmp    c0107332 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107328:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010732b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107332:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107335:	c9                   	leave  
c0107336:	c3                   	ret    

c0107337 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107337:	55                   	push   %ebp
c0107338:	89 e5                	mov    %esp,%ebp
c010733a:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010733d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107344:	e8 5b ed ff ff       	call   c01060a4 <kmalloc>
c0107349:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010734c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107350:	74 1b                	je     c010736d <vma_create+0x36>
        vma->vm_start = vm_start;
c0107352:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107355:	8b 55 08             	mov    0x8(%ebp),%edx
c0107358:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010735b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010735e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107361:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107364:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107367:	8b 55 10             	mov    0x10(%ebp),%edx
c010736a:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010736d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107370:	c9                   	leave  
c0107371:	c3                   	ret    

c0107372 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107372:	55                   	push   %ebp
c0107373:	89 e5                	mov    %esp,%ebp
c0107375:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010737f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107383:	0f 84 95 00 00 00    	je     c010741e <find_vma+0xac>
        vma = mm->mmap_cache;
c0107389:	8b 45 08             	mov    0x8(%ebp),%eax
c010738c:	8b 40 08             	mov    0x8(%eax),%eax
c010738f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107392:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107396:	74 16                	je     c01073ae <find_vma+0x3c>
c0107398:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010739b:	8b 40 04             	mov    0x4(%eax),%eax
c010739e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073a1:	77 0b                	ja     c01073ae <find_vma+0x3c>
c01073a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073a6:	8b 40 08             	mov    0x8(%eax),%eax
c01073a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073ac:	77 61                	ja     c010740f <find_vma+0x9d>
                bool found = 0;
c01073ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01073b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01073b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073be:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01073c1:	eb 28                	jmp    c01073eb <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01073c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073c6:	83 e8 10             	sub    $0x10,%eax
c01073c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01073cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073cf:	8b 40 04             	mov    0x4(%eax),%eax
c01073d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073d5:	77 14                	ja     c01073eb <find_vma+0x79>
c01073d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073da:	8b 40 08             	mov    0x8(%eax),%eax
c01073dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073e0:	76 09                	jbe    c01073eb <find_vma+0x79>
                        found = 1;
c01073e2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01073e9:	eb 17                	jmp    c0107402 <find_vma+0x90>
c01073eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01073f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073f4:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01073f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01073fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107400:	75 c1                	jne    c01073c3 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107402:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107406:	75 07                	jne    c010740f <find_vma+0x9d>
                    vma = NULL;
c0107408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c010740f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107413:	74 09                	je     c010741e <find_vma+0xac>
            mm->mmap_cache = vma;
c0107415:	8b 45 08             	mov    0x8(%ebp),%eax
c0107418:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010741b:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c010741e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107421:	c9                   	leave  
c0107422:	c3                   	ret    

c0107423 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107423:	55                   	push   %ebp
c0107424:	89 e5                	mov    %esp,%ebp
c0107426:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107429:	8b 45 08             	mov    0x8(%ebp),%eax
c010742c:	8b 50 04             	mov    0x4(%eax),%edx
c010742f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107432:	8b 40 08             	mov    0x8(%eax),%eax
c0107435:	39 c2                	cmp    %eax,%edx
c0107437:	72 24                	jb     c010745d <check_vma_overlap+0x3a>
c0107439:	c7 44 24 0c 8d a6 10 	movl   $0xc010a68d,0xc(%esp)
c0107440:	c0 
c0107441:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107448:	c0 
c0107449:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107450:	00 
c0107451:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107458:	e8 72 98 ff ff       	call   c0100ccf <__panic>
    assert(prev->vm_end <= next->vm_start);
c010745d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107460:	8b 50 08             	mov    0x8(%eax),%edx
c0107463:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107466:	8b 40 04             	mov    0x4(%eax),%eax
c0107469:	39 c2                	cmp    %eax,%edx
c010746b:	76 24                	jbe    c0107491 <check_vma_overlap+0x6e>
c010746d:	c7 44 24 0c d0 a6 10 	movl   $0xc010a6d0,0xc(%esp)
c0107474:	c0 
c0107475:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c010747c:	c0 
c010747d:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107484:	00 
c0107485:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c010748c:	e8 3e 98 ff ff       	call   c0100ccf <__panic>
    assert(next->vm_start < next->vm_end);
c0107491:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107494:	8b 50 04             	mov    0x4(%eax),%edx
c0107497:	8b 45 0c             	mov    0xc(%ebp),%eax
c010749a:	8b 40 08             	mov    0x8(%eax),%eax
c010749d:	39 c2                	cmp    %eax,%edx
c010749f:	72 24                	jb     c01074c5 <check_vma_overlap+0xa2>
c01074a1:	c7 44 24 0c ef a6 10 	movl   $0xc010a6ef,0xc(%esp)
c01074a8:	c0 
c01074a9:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01074b0:	c0 
c01074b1:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01074b8:	00 
c01074b9:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01074c0:	e8 0a 98 ff ff       	call   c0100ccf <__panic>
}
c01074c5:	c9                   	leave  
c01074c6:	c3                   	ret    

c01074c7 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01074c7:	55                   	push   %ebp
c01074c8:	89 e5                	mov    %esp,%ebp
c01074ca:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01074cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074d0:	8b 50 04             	mov    0x4(%eax),%edx
c01074d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074d6:	8b 40 08             	mov    0x8(%eax),%eax
c01074d9:	39 c2                	cmp    %eax,%edx
c01074db:	72 24                	jb     c0107501 <insert_vma_struct+0x3a>
c01074dd:	c7 44 24 0c 0d a7 10 	movl   $0xc010a70d,0xc(%esp)
c01074e4:	c0 
c01074e5:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01074ec:	c0 
c01074ed:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01074f4:	00 
c01074f5:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01074fc:	e8 ce 97 ff ff       	call   c0100ccf <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107501:	8b 45 08             	mov    0x8(%ebp),%eax
c0107504:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107507:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010750a:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010750d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107510:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107513:	eb 21                	jmp    c0107536 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107515:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107518:	83 e8 10             	sub    $0x10,%eax
c010751b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010751e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107521:	8b 50 04             	mov    0x4(%eax),%edx
c0107524:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107527:	8b 40 04             	mov    0x4(%eax),%eax
c010752a:	39 c2                	cmp    %eax,%edx
c010752c:	76 02                	jbe    c0107530 <insert_vma_struct+0x69>
                break;
c010752e:	eb 1d                	jmp    c010754d <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107530:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107533:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107536:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107539:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010753c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010753f:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107542:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107545:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107548:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010754b:	75 c8                	jne    c0107515 <insert_vma_struct+0x4e>
c010754d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107550:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107553:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107556:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107559:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c010755c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010755f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107562:	74 15                	je     c0107579 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107567:	8d 50 f0             	lea    -0x10(%eax),%edx
c010756a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010756d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107571:	89 14 24             	mov    %edx,(%esp)
c0107574:	e8 aa fe ff ff       	call   c0107423 <check_vma_overlap>
    }
    if (le_next != list) {
c0107579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010757c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010757f:	74 15                	je     c0107596 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107584:	83 e8 10             	sub    $0x10,%eax
c0107587:	89 44 24 04          	mov    %eax,0x4(%esp)
c010758b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010758e:	89 04 24             	mov    %eax,(%esp)
c0107591:	e8 8d fe ff ff       	call   c0107423 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107599:	8b 55 08             	mov    0x8(%ebp),%edx
c010759c:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c010759e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075a1:	8d 50 10             	lea    0x10(%eax),%edx
c01075a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01075aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01075ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01075b0:	8b 40 04             	mov    0x4(%eax),%eax
c01075b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01075b6:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01075b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01075bc:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01075bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01075c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01075c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01075c8:	89 10                	mov    %edx,(%eax)
c01075ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01075cd:	8b 10                	mov    (%eax),%edx
c01075cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01075d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01075d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01075d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01075db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01075de:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01075e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01075e4:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01075e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01075e9:	8b 40 10             	mov    0x10(%eax),%eax
c01075ec:	8d 50 01             	lea    0x1(%eax),%edx
c01075ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01075f2:	89 50 10             	mov    %edx,0x10(%eax)
}
c01075f5:	c9                   	leave  
c01075f6:	c3                   	ret    

c01075f7 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01075f7:	55                   	push   %ebp
c01075f8:	89 e5                	mov    %esp,%ebp
c01075fa:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01075fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107600:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107603:	eb 3e                	jmp    c0107643 <mm_destroy+0x4c>
c0107605:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107608:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010760b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010760e:	8b 40 04             	mov    0x4(%eax),%eax
c0107611:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107614:	8b 12                	mov    (%edx),%edx
c0107616:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010761c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010761f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107622:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107628:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010762b:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c010762d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107630:	83 e8 10             	sub    $0x10,%eax
c0107633:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010763a:	00 
c010763b:	89 04 24             	mov    %eax,(%esp)
c010763e:	e8 01 eb ff ff       	call   c0106144 <kfree>
c0107643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107646:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107649:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010764c:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010764f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107652:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107655:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107658:	75 ab                	jne    c0107605 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c010765a:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107661:	00 
c0107662:	8b 45 08             	mov    0x8(%ebp),%eax
c0107665:	89 04 24             	mov    %eax,(%esp)
c0107668:	e8 d7 ea ff ff       	call   c0106144 <kfree>
    mm=NULL;
c010766d:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107674:	c9                   	leave  
c0107675:	c3                   	ret    

c0107676 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107676:	55                   	push   %ebp
c0107677:	89 e5                	mov    %esp,%ebp
c0107679:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010767c:	e8 02 00 00 00       	call   c0107683 <check_vmm>
}
c0107681:	c9                   	leave  
c0107682:	c3                   	ret    

c0107683 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107683:	55                   	push   %ebp
c0107684:	89 e5                	mov    %esp,%ebp
c0107686:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107689:	e8 7c d2 ff ff       	call   c010490a <nr_free_pages>
c010768e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107691:	e8 41 00 00 00       	call   c01076d7 <check_vma_struct>
    check_pgfault();
c0107696:	e8 03 05 00 00       	call   c0107b9e <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c010769b:	e8 6a d2 ff ff       	call   c010490a <nr_free_pages>
c01076a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01076a3:	74 24                	je     c01076c9 <check_vmm+0x46>
c01076a5:	c7 44 24 0c 2c a7 10 	movl   $0xc010a72c,0xc(%esp)
c01076ac:	c0 
c01076ad:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01076b4:	c0 
c01076b5:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01076bc:	00 
c01076bd:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01076c4:	e8 06 96 ff ff       	call   c0100ccf <__panic>

    cprintf("check_vmm() succeeded.\n");
c01076c9:	c7 04 24 53 a7 10 c0 	movl   $0xc010a753,(%esp)
c01076d0:	e8 76 8c ff ff       	call   c010034b <cprintf>
}
c01076d5:	c9                   	leave  
c01076d6:	c3                   	ret    

c01076d7 <check_vma_struct>:

static void
check_vma_struct(void) {
c01076d7:	55                   	push   %ebp
c01076d8:	89 e5                	mov    %esp,%ebp
c01076da:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01076dd:	e8 28 d2 ff ff       	call   c010490a <nr_free_pages>
c01076e2:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01076e5:	e8 d5 fb ff ff       	call   c01072bf <mm_create>
c01076ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01076ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01076f1:	75 24                	jne    c0107717 <check_vma_struct+0x40>
c01076f3:	c7 44 24 0c 6b a7 10 	movl   $0xc010a76b,0xc(%esp)
c01076fa:	c0 
c01076fb:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107702:	c0 
c0107703:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010770a:	00 
c010770b:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107712:	e8 b8 95 ff ff       	call   c0100ccf <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107717:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010771e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107721:	89 d0                	mov    %edx,%eax
c0107723:	c1 e0 02             	shl    $0x2,%eax
c0107726:	01 d0                	add    %edx,%eax
c0107728:	01 c0                	add    %eax,%eax
c010772a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010772d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107730:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107733:	eb 70                	jmp    c01077a5 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107735:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107738:	89 d0                	mov    %edx,%eax
c010773a:	c1 e0 02             	shl    $0x2,%eax
c010773d:	01 d0                	add    %edx,%eax
c010773f:	83 c0 02             	add    $0x2,%eax
c0107742:	89 c1                	mov    %eax,%ecx
c0107744:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107747:	89 d0                	mov    %edx,%eax
c0107749:	c1 e0 02             	shl    $0x2,%eax
c010774c:	01 d0                	add    %edx,%eax
c010774e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107755:	00 
c0107756:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010775a:	89 04 24             	mov    %eax,(%esp)
c010775d:	e8 d5 fb ff ff       	call   c0107337 <vma_create>
c0107762:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107765:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107769:	75 24                	jne    c010778f <check_vma_struct+0xb8>
c010776b:	c7 44 24 0c 76 a7 10 	movl   $0xc010a776,0xc(%esp)
c0107772:	c0 
c0107773:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c010777a:	c0 
c010777b:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0107782:	00 
c0107783:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c010778a:	e8 40 95 ff ff       	call   c0100ccf <__panic>
        insert_vma_struct(mm, vma);
c010778f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107792:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107796:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107799:	89 04 24             	mov    %eax,(%esp)
c010779c:	e8 26 fd ff ff       	call   c01074c7 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01077a1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01077a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077a9:	7f 8a                	jg     c0107735 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01077ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077ae:	83 c0 01             	add    $0x1,%eax
c01077b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01077b4:	eb 70                	jmp    c0107826 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01077b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077b9:	89 d0                	mov    %edx,%eax
c01077bb:	c1 e0 02             	shl    $0x2,%eax
c01077be:	01 d0                	add    %edx,%eax
c01077c0:	83 c0 02             	add    $0x2,%eax
c01077c3:	89 c1                	mov    %eax,%ecx
c01077c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077c8:	89 d0                	mov    %edx,%eax
c01077ca:	c1 e0 02             	shl    $0x2,%eax
c01077cd:	01 d0                	add    %edx,%eax
c01077cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01077d6:	00 
c01077d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01077db:	89 04 24             	mov    %eax,(%esp)
c01077de:	e8 54 fb ff ff       	call   c0107337 <vma_create>
c01077e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01077e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01077ea:	75 24                	jne    c0107810 <check_vma_struct+0x139>
c01077ec:	c7 44 24 0c 76 a7 10 	movl   $0xc010a776,0xc(%esp)
c01077f3:	c0 
c01077f4:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01077fb:	c0 
c01077fc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107803:	00 
c0107804:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c010780b:	e8 bf 94 ff ff       	call   c0100ccf <__panic>
        insert_vma_struct(mm, vma);
c0107810:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107813:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107817:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010781a:	89 04 24             	mov    %eax,(%esp)
c010781d:	e8 a5 fc ff ff       	call   c01074c7 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107822:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107826:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107829:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010782c:	7e 88                	jle    c01077b6 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010782e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107831:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107834:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107837:	8b 40 04             	mov    0x4(%eax),%eax
c010783a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010783d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107844:	e9 97 00 00 00       	jmp    c01078e0 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107849:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010784c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010784f:	75 24                	jne    c0107875 <check_vma_struct+0x19e>
c0107851:	c7 44 24 0c 82 a7 10 	movl   $0xc010a782,0xc(%esp)
c0107858:	c0 
c0107859:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107860:	c0 
c0107861:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107868:	00 
c0107869:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107870:	e8 5a 94 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107875:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107878:	83 e8 10             	sub    $0x10,%eax
c010787b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010787e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107881:	8b 48 04             	mov    0x4(%eax),%ecx
c0107884:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107887:	89 d0                	mov    %edx,%eax
c0107889:	c1 e0 02             	shl    $0x2,%eax
c010788c:	01 d0                	add    %edx,%eax
c010788e:	39 c1                	cmp    %eax,%ecx
c0107890:	75 17                	jne    c01078a9 <check_vma_struct+0x1d2>
c0107892:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107895:	8b 48 08             	mov    0x8(%eax),%ecx
c0107898:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010789b:	89 d0                	mov    %edx,%eax
c010789d:	c1 e0 02             	shl    $0x2,%eax
c01078a0:	01 d0                	add    %edx,%eax
c01078a2:	83 c0 02             	add    $0x2,%eax
c01078a5:	39 c1                	cmp    %eax,%ecx
c01078a7:	74 24                	je     c01078cd <check_vma_struct+0x1f6>
c01078a9:	c7 44 24 0c 9c a7 10 	movl   $0xc010a79c,0xc(%esp)
c01078b0:	c0 
c01078b1:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01078b8:	c0 
c01078b9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01078c0:	00 
c01078c1:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01078c8:	e8 02 94 ff ff       	call   c0100ccf <__panic>
c01078cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01078d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01078d6:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01078d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01078dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01078e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01078e6:	0f 8e 5d ff ff ff    	jle    c0107849 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01078ec:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01078f3:	e9 cd 01 00 00       	jmp    c0107ac5 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01078f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107902:	89 04 24             	mov    %eax,(%esp)
c0107905:	e8 68 fa ff ff       	call   c0107372 <find_vma>
c010790a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c010790d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107911:	75 24                	jne    c0107937 <check_vma_struct+0x260>
c0107913:	c7 44 24 0c d1 a7 10 	movl   $0xc010a7d1,0xc(%esp)
c010791a:	c0 
c010791b:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107922:	c0 
c0107923:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010792a:	00 
c010792b:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107932:	e8 98 93 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107937:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010793a:	83 c0 01             	add    $0x1,%eax
c010793d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107941:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107944:	89 04 24             	mov    %eax,(%esp)
c0107947:	e8 26 fa ff ff       	call   c0107372 <find_vma>
c010794c:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010794f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107953:	75 24                	jne    c0107979 <check_vma_struct+0x2a2>
c0107955:	c7 44 24 0c de a7 10 	movl   $0xc010a7de,0xc(%esp)
c010795c:	c0 
c010795d:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107964:	c0 
c0107965:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010796c:	00 
c010796d:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107974:	e8 56 93 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010797c:	83 c0 02             	add    $0x2,%eax
c010797f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107983:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107986:	89 04 24             	mov    %eax,(%esp)
c0107989:	e8 e4 f9 ff ff       	call   c0107372 <find_vma>
c010798e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107991:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107995:	74 24                	je     c01079bb <check_vma_struct+0x2e4>
c0107997:	c7 44 24 0c eb a7 10 	movl   $0xc010a7eb,0xc(%esp)
c010799e:	c0 
c010799f:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01079a6:	c0 
c01079a7:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01079ae:	00 
c01079af:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01079b6:	e8 14 93 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01079bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079be:	83 c0 03             	add    $0x3,%eax
c01079c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079c8:	89 04 24             	mov    %eax,(%esp)
c01079cb:	e8 a2 f9 ff ff       	call   c0107372 <find_vma>
c01079d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01079d3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01079d7:	74 24                	je     c01079fd <check_vma_struct+0x326>
c01079d9:	c7 44 24 0c f8 a7 10 	movl   $0xc010a7f8,0xc(%esp)
c01079e0:	c0 
c01079e1:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c01079e8:	c0 
c01079e9:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01079f0:	00 
c01079f1:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c01079f8:	e8 d2 92 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01079fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a00:	83 c0 04             	add    $0x4,%eax
c0107a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a0a:	89 04 24             	mov    %eax,(%esp)
c0107a0d:	e8 60 f9 ff ff       	call   c0107372 <find_vma>
c0107a12:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107a15:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107a19:	74 24                	je     c0107a3f <check_vma_struct+0x368>
c0107a1b:	c7 44 24 0c 05 a8 10 	movl   $0xc010a805,0xc(%esp)
c0107a22:	c0 
c0107a23:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107a2a:	c0 
c0107a2b:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107a32:	00 
c0107a33:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107a3a:	e8 90 92 ff ff       	call   c0100ccf <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a42:	8b 50 04             	mov    0x4(%eax),%edx
c0107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a48:	39 c2                	cmp    %eax,%edx
c0107a4a:	75 10                	jne    c0107a5c <check_vma_struct+0x385>
c0107a4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a4f:	8b 50 08             	mov    0x8(%eax),%edx
c0107a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a55:	83 c0 02             	add    $0x2,%eax
c0107a58:	39 c2                	cmp    %eax,%edx
c0107a5a:	74 24                	je     c0107a80 <check_vma_struct+0x3a9>
c0107a5c:	c7 44 24 0c 14 a8 10 	movl   $0xc010a814,0xc(%esp)
c0107a63:	c0 
c0107a64:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107a6b:	c0 
c0107a6c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107a73:	00 
c0107a74:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107a7b:	e8 4f 92 ff ff       	call   c0100ccf <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107a80:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107a83:	8b 50 04             	mov    0x4(%eax),%edx
c0107a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a89:	39 c2                	cmp    %eax,%edx
c0107a8b:	75 10                	jne    c0107a9d <check_vma_struct+0x3c6>
c0107a8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107a90:	8b 50 08             	mov    0x8(%eax),%edx
c0107a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a96:	83 c0 02             	add    $0x2,%eax
c0107a99:	39 c2                	cmp    %eax,%edx
c0107a9b:	74 24                	je     c0107ac1 <check_vma_struct+0x3ea>
c0107a9d:	c7 44 24 0c 44 a8 10 	movl   $0xc010a844,0xc(%esp)
c0107aa4:	c0 
c0107aa5:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107aac:	c0 
c0107aad:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107ab4:	00 
c0107ab5:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107abc:	e8 0e 92 ff ff       	call   c0100ccf <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107ac1:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107ac5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107ac8:	89 d0                	mov    %edx,%eax
c0107aca:	c1 e0 02             	shl    $0x2,%eax
c0107acd:	01 d0                	add    %edx,%eax
c0107acf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107ad2:	0f 8d 20 fe ff ff    	jge    c01078f8 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107ad8:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107adf:	eb 70                	jmp    c0107b51 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107aeb:	89 04 24             	mov    %eax,(%esp)
c0107aee:	e8 7f f8 ff ff       	call   c0107372 <find_vma>
c0107af3:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107af6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107afa:	74 27                	je     c0107b23 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107afc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107aff:	8b 50 08             	mov    0x8(%eax),%edx
c0107b02:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107b05:	8b 40 04             	mov    0x4(%eax),%eax
c0107b08:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b17:	c7 04 24 74 a8 10 c0 	movl   $0xc010a874,(%esp)
c0107b1e:	e8 28 88 ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107b23:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107b27:	74 24                	je     c0107b4d <check_vma_struct+0x476>
c0107b29:	c7 44 24 0c 99 a8 10 	movl   $0xc010a899,0xc(%esp)
c0107b30:	c0 
c0107b31:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107b38:	c0 
c0107b39:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107b40:	00 
c0107b41:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107b48:	e8 82 91 ff ff       	call   c0100ccf <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107b4d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107b55:	79 8a                	jns    c0107ae1 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b5a:	89 04 24             	mov    %eax,(%esp)
c0107b5d:	e8 95 fa ff ff       	call   c01075f7 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107b62:	e8 a3 cd ff ff       	call   c010490a <nr_free_pages>
c0107b67:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b6a:	74 24                	je     c0107b90 <check_vma_struct+0x4b9>
c0107b6c:	c7 44 24 0c 2c a7 10 	movl   $0xc010a72c,0xc(%esp)
c0107b73:	c0 
c0107b74:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107b7b:	c0 
c0107b7c:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107b83:	00 
c0107b84:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107b8b:	e8 3f 91 ff ff       	call   c0100ccf <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107b90:	c7 04 24 b0 a8 10 c0 	movl   $0xc010a8b0,(%esp)
c0107b97:	e8 af 87 ff ff       	call   c010034b <cprintf>
}
c0107b9c:	c9                   	leave  
c0107b9d:	c3                   	ret    

c0107b9e <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107b9e:	55                   	push   %ebp
c0107b9f:	89 e5                	mov    %esp,%ebp
c0107ba1:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107ba4:	e8 61 cd ff ff       	call   c010490a <nr_free_pages>
c0107ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107bac:	e8 0e f7 ff ff       	call   c01072bf <mm_create>
c0107bb1:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac
    assert(check_mm_struct != NULL);
c0107bb6:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107bbb:	85 c0                	test   %eax,%eax
c0107bbd:	75 24                	jne    c0107be3 <check_pgfault+0x45>
c0107bbf:	c7 44 24 0c cf a8 10 	movl   $0xc010a8cf,0xc(%esp)
c0107bc6:	c0 
c0107bc7:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107bce:	c0 
c0107bcf:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107bd6:	00 
c0107bd7:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107bde:	e8 ec 90 ff ff       	call   c0100ccf <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107be3:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107be8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107beb:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0107bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bf4:	89 50 0c             	mov    %edx,0xc(%eax)
c0107bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bfa:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c03:	8b 00                	mov    (%eax),%eax
c0107c05:	85 c0                	test   %eax,%eax
c0107c07:	74 24                	je     c0107c2d <check_pgfault+0x8f>
c0107c09:	c7 44 24 0c e7 a8 10 	movl   $0xc010a8e7,0xc(%esp)
c0107c10:	c0 
c0107c11:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107c18:	c0 
c0107c19:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107c20:	00 
c0107c21:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107c28:	e8 a2 90 ff ff       	call   c0100ccf <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107c2d:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107c34:	00 
c0107c35:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107c3c:	00 
c0107c3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107c44:	e8 ee f6 ff ff       	call   c0107337 <vma_create>
c0107c49:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107c4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107c50:	75 24                	jne    c0107c76 <check_pgfault+0xd8>
c0107c52:	c7 44 24 0c 76 a7 10 	movl   $0xc010a776,0xc(%esp)
c0107c59:	c0 
c0107c5a:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107c61:	c0 
c0107c62:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107c69:	00 
c0107c6a:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107c71:	e8 59 90 ff ff       	call   c0100ccf <__panic>

    insert_vma_struct(mm, vma);
c0107c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c80:	89 04 24             	mov    %eax,(%esp)
c0107c83:	e8 3f f8 ff ff       	call   c01074c7 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107c88:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107c8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c99:	89 04 24             	mov    %eax,(%esp)
c0107c9c:	e8 d1 f6 ff ff       	call   c0107372 <find_vma>
c0107ca1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107ca4:	74 24                	je     c0107cca <check_pgfault+0x12c>
c0107ca6:	c7 44 24 0c f5 a8 10 	movl   $0xc010a8f5,0xc(%esp)
c0107cad:	c0 
c0107cae:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107cb5:	c0 
c0107cb6:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107cbd:	00 
c0107cbe:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107cc5:	e8 05 90 ff ff       	call   c0100ccf <__panic>

    int i, sum = 0;
c0107cca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107cd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107cd8:	eb 17                	jmp    c0107cf1 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ce0:	01 d0                	add    %edx,%eax
c0107ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ce5:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cea:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107ced:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107cf1:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107cf5:	7e e3                	jle    c0107cda <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107cfe:	eb 15                	jmp    c0107d15 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d06:	01 d0                	add    %edx,%eax
c0107d08:	0f b6 00             	movzbl (%eax),%eax
c0107d0b:	0f be c0             	movsbl %al,%eax
c0107d0e:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107d11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107d15:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107d19:	7e e5                	jle    c0107d00 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107d1f:	74 24                	je     c0107d45 <check_pgfault+0x1a7>
c0107d21:	c7 44 24 0c 0f a9 10 	movl   $0xc010a90f,0xc(%esp)
c0107d28:	c0 
c0107d29:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107d30:	c0 
c0107d31:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107d38:	00 
c0107d39:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107d40:	e8 8a 8f ff ff       	call   c0100ccf <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107d45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d48:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107d4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107d53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d5a:	89 04 24             	mov    %eax,(%esp)
c0107d5d:	e8 64 d4 ff ff       	call   c01051c6 <page_remove>
    free_page(pa2page(pgdir[0]));
c0107d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d65:	8b 00                	mov    (%eax),%eax
c0107d67:	89 04 24             	mov    %eax,(%esp)
c0107d6a:	e8 0b f5 ff ff       	call   c010727a <pa2page>
c0107d6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107d76:	00 
c0107d77:	89 04 24             	mov    %eax,(%esp)
c0107d7a:	e8 59 cb ff ff       	call   c01048d8 <free_pages>
    pgdir[0] = 0;
c0107d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d95:	89 04 24             	mov    %eax,(%esp)
c0107d98:	e8 5a f8 ff ff       	call   c01075f7 <mm_destroy>
    check_mm_struct = NULL;
c0107d9d:	c7 05 ac 1b 12 c0 00 	movl   $0x0,0xc0121bac
c0107da4:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107da7:	e8 5e cb ff ff       	call   c010490a <nr_free_pages>
c0107dac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107daf:	74 24                	je     c0107dd5 <check_pgfault+0x237>
c0107db1:	c7 44 24 0c 2c a7 10 	movl   $0xc010a72c,0xc(%esp)
c0107db8:	c0 
c0107db9:	c7 44 24 08 ab a6 10 	movl   $0xc010a6ab,0x8(%esp)
c0107dc0:	c0 
c0107dc1:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107dc8:	00 
c0107dc9:	c7 04 24 c0 a6 10 c0 	movl   $0xc010a6c0,(%esp)
c0107dd0:	e8 fa 8e ff ff       	call   c0100ccf <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107dd5:	c7 04 24 18 a9 10 c0 	movl   $0xc010a918,(%esp)
c0107ddc:	e8 6a 85 ff ff       	call   c010034b <cprintf>
}
c0107de1:	c9                   	leave  
c0107de2:	c3                   	ret    

c0107de3 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107de3:	55                   	push   %ebp
c0107de4:	89 e5                	mov    %esp,%ebp
c0107de6:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107de9:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107df0:	8b 45 10             	mov    0x10(%ebp),%eax
c0107df3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dfa:	89 04 24             	mov    %eax,(%esp)
c0107dfd:	e8 70 f5 ff ff       	call   c0107372 <find_vma>
c0107e02:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107e05:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107e0a:	83 c0 01             	add    $0x1,%eax
c0107e0d:	a3 b8 1a 12 c0       	mov    %eax,0xc0121ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107e12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107e16:	74 0b                	je     c0107e23 <do_pgfault+0x40>
c0107e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e1b:	8b 40 04             	mov    0x4(%eax),%eax
c0107e1e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107e21:	76 18                	jbe    c0107e3b <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107e23:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e2a:	c7 04 24 34 a9 10 c0 	movl   $0xc010a934,(%esp)
c0107e31:	e8 15 85 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107e36:	e9 ca 01 00 00       	jmp    c0108005 <do_pgfault+0x222>
    }
    //check the error_code
    switch (error_code & 3) {
c0107e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e3e:	83 e0 03             	and    $0x3,%eax
c0107e41:	85 c0                	test   %eax,%eax
c0107e43:	74 36                	je     c0107e7b <do_pgfault+0x98>
c0107e45:	83 f8 01             	cmp    $0x1,%eax
c0107e48:	74 20                	je     c0107e6a <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e50:	83 e0 02             	and    $0x2,%eax
c0107e53:	85 c0                	test   %eax,%eax
c0107e55:	75 11                	jne    c0107e68 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107e57:	c7 04 24 64 a9 10 c0 	movl   $0xc010a964,(%esp)
c0107e5e:	e8 e8 84 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107e63:	e9 9d 01 00 00       	jmp    c0108005 <do_pgfault+0x222>
        }
        break;
c0107e68:	eb 2f                	jmp    c0107e99 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107e6a:	c7 04 24 c4 a9 10 c0 	movl   $0xc010a9c4,(%esp)
c0107e71:	e8 d5 84 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107e76:	e9 8a 01 00 00       	jmp    c0108005 <do_pgfault+0x222>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e7e:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e81:	83 e0 05             	and    $0x5,%eax
c0107e84:	85 c0                	test   %eax,%eax
c0107e86:	75 11                	jne    c0107e99 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107e88:	c7 04 24 fc a9 10 c0 	movl   $0xc010a9fc,(%esp)
c0107e8f:	e8 b7 84 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107e94:	e9 6c 01 00 00       	jmp    c0108005 <do_pgfault+0x222>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107e99:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107ea3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ea6:	83 e0 02             	and    $0x2,%eax
c0107ea9:	85 c0                	test   %eax,%eax
c0107eab:	74 04                	je     c0107eb1 <do_pgfault+0xce>
        perm |= PTE_W;
c0107ead:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107eb1:	8b 45 10             	mov    0x10(%ebp),%eax
c0107eb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ebf:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107ec2:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107ec9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: YOUR CODE*/
    //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    if((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
c0107ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ed3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ed6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107edd:	00 
c0107ede:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ee1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ee5:	89 04 24             	mov    %eax,(%esp)
c0107ee8:	e8 e2 d0 ff ff       	call   c0104fcf <get_pte>
c0107eed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107ef4:	75 11                	jne    c0107f07 <do_pgfault+0x124>
    {
    	cprintf("get_pte in do_pgfault failed\n");
c0107ef6:	c7 04 24 5f aa 10 c0 	movl   $0xc010aa5f,(%esp)
c0107efd:	e8 49 84 ff ff       	call   c010034b <cprintf>
    	goto failed;
c0107f02:	e9 fe 00 00 00       	jmp    c0108005 <do_pgfault+0x222>
    }
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0)
c0107f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f0a:	8b 00                	mov    (%eax),%eax
c0107f0c:	85 c0                	test   %eax,%eax
c0107f0e:	75 35                	jne    c0107f45 <do_pgfault+0x162>
    {
    	if(pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
c0107f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f13:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f19:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107f1d:	8b 55 10             	mov    0x10(%ebp),%edx
c0107f20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f24:	89 04 24             	mov    %eax,(%esp)
c0107f27:	e8 f4 d3 ff ff       	call   c0105320 <pgdir_alloc_page>
c0107f2c:	85 c0                	test   %eax,%eax
c0107f2e:	0f 85 ca 00 00 00    	jne    c0107ffe <do_pgfault+0x21b>
    	{
    		cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0107f34:	c7 04 24 80 aa 10 c0 	movl   $0xc010aa80,(%esp)
c0107f3b:	e8 0b 84 ff ff       	call   c010034b <cprintf>
    		goto failed;
c0107f40:	e9 c0 00 00 00       	jmp    c0108005 <do_pgfault+0x222>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok)
c0107f45:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107f4a:	85 c0                	test   %eax,%eax
c0107f4c:	0f 84 95 00 00 00    	je     c0107fe7 <do_pgfault+0x204>
        {
            struct Page *page=NULL;
c0107f52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
            if((ret = swap_in(mm, addr, &page)) != 0)
c0107f59:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107f5c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f60:	8b 45 10             	mov    0x10(%ebp),%eax
c0107f63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6a:	89 04 24             	mov    %eax,(%esp)
c0107f6d:	e8 78 e5 ff ff       	call   c01064ea <swap_in>
c0107f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f79:	74 0e                	je     c0107f89 <do_pgfault+0x1a6>
            {
            	cprintf("swap_in in do_pgfault failed\n");
c0107f7b:	c7 04 24 a7 aa 10 c0 	movl   $0xc010aaa7,(%esp)
c0107f82:	e8 c4 83 ff ff       	call   c010034b <cprintf>
            	goto failed;
c0107f87:	eb 7c                	jmp    c0108005 <do_pgfault+0x222>
            }
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            if((ret = page_insert(mm->pgdir, page, addr, perm)) != 0)
c0107f89:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107f8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f8f:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107f95:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107f99:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107f9c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107fa0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fa4:	89 04 24             	mov    %eax,(%esp)
c0107fa7:	e8 5e d2 ff ff       	call   c010520a <page_insert>
c0107fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fb3:	74 0f                	je     c0107fc4 <do_pgfault+0x1e1>
            {
            	cprintf("page_insert in do_pgfault failed\n");
c0107fb5:	c7 04 24 c8 aa 10 c0 	movl   $0xc010aac8,(%esp)
c0107fbc:	e8 8a 83 ff ff       	call   c010034b <cprintf>
            	goto failed;
c0107fc1:	90                   	nop
c0107fc2:	eb 41                	jmp    c0108005 <do_pgfault+0x222>
            }
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c0107fc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fc7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107fce:	00 
c0107fcf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0107fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fda:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fdd:	89 04 24             	mov    %eax,(%esp)
c0107fe0:	e8 3c e3 ff ff       	call   c0106321 <swap_map_swappable>
c0107fe5:	eb 17                	jmp    c0107ffe <do_pgfault+0x21b>
        }
        else
        {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fea:	8b 00                	mov    (%eax),%eax
c0107fec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ff0:	c7 04 24 ec aa 10 c0 	movl   $0xc010aaec,(%esp)
c0107ff7:	e8 4f 83 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107ffc:	eb 07                	jmp    c0108005 <do_pgfault+0x222>
        }
   }
   ret = 0;
c0107ffe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108005:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108008:	c9                   	leave  
c0108009:	c3                   	ret    

c010800a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010800a:	55                   	push   %ebp
c010800b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010800d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108010:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0108015:	29 c2                	sub    %eax,%edx
c0108017:	89 d0                	mov    %edx,%eax
c0108019:	c1 f8 05             	sar    $0x5,%eax
}
c010801c:	5d                   	pop    %ebp
c010801d:	c3                   	ret    

c010801e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010801e:	55                   	push   %ebp
c010801f:	89 e5                	mov    %esp,%ebp
c0108021:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108024:	8b 45 08             	mov    0x8(%ebp),%eax
c0108027:	89 04 24             	mov    %eax,(%esp)
c010802a:	e8 db ff ff ff       	call   c010800a <page2ppn>
c010802f:	c1 e0 0c             	shl    $0xc,%eax
}
c0108032:	c9                   	leave  
c0108033:	c3                   	ret    

c0108034 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108034:	55                   	push   %ebp
c0108035:	89 e5                	mov    %esp,%ebp
c0108037:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010803a:	8b 45 08             	mov    0x8(%ebp),%eax
c010803d:	89 04 24             	mov    %eax,(%esp)
c0108040:	e8 d9 ff ff ff       	call   c010801e <page2pa>
c0108045:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010804b:	c1 e8 0c             	shr    $0xc,%eax
c010804e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108051:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0108056:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108059:	72 23                	jb     c010807e <page2kva+0x4a>
c010805b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010805e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108062:	c7 44 24 08 14 ab 10 	movl   $0xc010ab14,0x8(%esp)
c0108069:	c0 
c010806a:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0108071:	00 
c0108072:	c7 04 24 37 ab 10 c0 	movl   $0xc010ab37,(%esp)
c0108079:	e8 51 8c ff ff       	call   c0100ccf <__panic>
c010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108081:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108086:	c9                   	leave  
c0108087:	c3                   	ret    

c0108088 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108088:	55                   	push   %ebp
c0108089:	89 e5                	mov    %esp,%ebp
c010808b:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010808e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108095:	e8 85 99 ff ff       	call   c0101a1f <ide_device_valid>
c010809a:	85 c0                	test   %eax,%eax
c010809c:	75 1c                	jne    c01080ba <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c010809e:	c7 44 24 08 45 ab 10 	movl   $0xc010ab45,0x8(%esp)
c01080a5:	c0 
c01080a6:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01080ad:	00 
c01080ae:	c7 04 24 5f ab 10 c0 	movl   $0xc010ab5f,(%esp)
c01080b5:	e8 15 8c ff ff       	call   c0100ccf <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01080ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01080c1:	e8 98 99 ff ff       	call   c0101a5e <ide_device_size>
c01080c6:	c1 e8 03             	shr    $0x3,%eax
c01080c9:	a3 7c 1b 12 c0       	mov    %eax,0xc0121b7c
}
c01080ce:	c9                   	leave  
c01080cf:	c3                   	ret    

c01080d0 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01080d0:	55                   	push   %ebp
c01080d1:	89 e5                	mov    %esp,%ebp
c01080d3:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01080d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080d9:	89 04 24             	mov    %eax,(%esp)
c01080dc:	e8 53 ff ff ff       	call   c0108034 <page2kva>
c01080e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01080e4:	c1 ea 08             	shr    $0x8,%edx
c01080e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01080ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01080ee:	74 0b                	je     c01080fb <swapfs_read+0x2b>
c01080f0:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c01080f6:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01080f9:	72 23                	jb     c010811e <swapfs_read+0x4e>
c01080fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01080fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108102:	c7 44 24 08 70 ab 10 	movl   $0xc010ab70,0x8(%esp)
c0108109:	c0 
c010810a:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108111:	00 
c0108112:	c7 04 24 5f ab 10 c0 	movl   $0xc010ab5f,(%esp)
c0108119:	e8 b1 8b ff ff       	call   c0100ccf <__panic>
c010811e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108121:	c1 e2 03             	shl    $0x3,%edx
c0108124:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010812b:	00 
c010812c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108130:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010813b:	e8 5d 99 ff ff       	call   c0101a9d <ide_read_secs>
}
c0108140:	c9                   	leave  
c0108141:	c3                   	ret    

c0108142 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108142:	55                   	push   %ebp
c0108143:	89 e5                	mov    %esp,%ebp
c0108145:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108148:	8b 45 0c             	mov    0xc(%ebp),%eax
c010814b:	89 04 24             	mov    %eax,(%esp)
c010814e:	e8 e1 fe ff ff       	call   c0108034 <page2kva>
c0108153:	8b 55 08             	mov    0x8(%ebp),%edx
c0108156:	c1 ea 08             	shr    $0x8,%edx
c0108159:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010815c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108160:	74 0b                	je     c010816d <swapfs_write+0x2b>
c0108162:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0108168:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010816b:	72 23                	jb     c0108190 <swapfs_write+0x4e>
c010816d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108170:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108174:	c7 44 24 08 70 ab 10 	movl   $0xc010ab70,0x8(%esp)
c010817b:	c0 
c010817c:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108183:	00 
c0108184:	c7 04 24 5f ab 10 c0 	movl   $0xc010ab5f,(%esp)
c010818b:	e8 3f 8b ff ff       	call   c0100ccf <__panic>
c0108190:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108193:	c1 e2 03             	shl    $0x3,%edx
c0108196:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010819d:	00 
c010819e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01081ad:	e8 2d 9b ff ff       	call   c0101cdf <ide_write_secs>
}
c01081b2:	c9                   	leave  
c01081b3:	c3                   	ret    

c01081b4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01081b4:	55                   	push   %ebp
c01081b5:	89 e5                	mov    %esp,%ebp
c01081b7:	83 ec 58             	sub    $0x58,%esp
c01081ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01081bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01081c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01081c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01081c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01081cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01081d2:	8b 45 18             	mov    0x18(%ebp),%eax
c01081d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01081d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081db:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01081de:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01081e1:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01081e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01081ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01081ee:	74 1c                	je     c010820c <printnum+0x58>
c01081f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01081f8:	f7 75 e4             	divl   -0x1c(%ebp)
c01081fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01081fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108201:	ba 00 00 00 00       	mov    $0x0,%edx
c0108206:	f7 75 e4             	divl   -0x1c(%ebp)
c0108209:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010820c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010820f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108212:	f7 75 e4             	divl   -0x1c(%ebp)
c0108215:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108218:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010821b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010821e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108221:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108224:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108227:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010822a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010822d:	8b 45 18             	mov    0x18(%ebp),%eax
c0108230:	ba 00 00 00 00       	mov    $0x0,%edx
c0108235:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108238:	77 56                	ja     c0108290 <printnum+0xdc>
c010823a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010823d:	72 05                	jb     c0108244 <printnum+0x90>
c010823f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108242:	77 4c                	ja     c0108290 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108244:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108247:	8d 50 ff             	lea    -0x1(%eax),%edx
c010824a:	8b 45 20             	mov    0x20(%ebp),%eax
c010824d:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108251:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108255:	8b 45 18             	mov    0x18(%ebp),%eax
c0108258:	89 44 24 10          	mov    %eax,0x10(%esp)
c010825c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010825f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108262:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108266:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010826a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010826d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108271:	8b 45 08             	mov    0x8(%ebp),%eax
c0108274:	89 04 24             	mov    %eax,(%esp)
c0108277:	e8 38 ff ff ff       	call   c01081b4 <printnum>
c010827c:	eb 1c                	jmp    c010829a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010827e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108281:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108285:	8b 45 20             	mov    0x20(%ebp),%eax
c0108288:	89 04 24             	mov    %eax,(%esp)
c010828b:	8b 45 08             	mov    0x8(%ebp),%eax
c010828e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108290:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108294:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108298:	7f e4                	jg     c010827e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010829a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010829d:	05 10 ac 10 c0       	add    $0xc010ac10,%eax
c01082a2:	0f b6 00             	movzbl (%eax),%eax
c01082a5:	0f be c0             	movsbl %al,%eax
c01082a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01082ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082af:	89 04 24             	mov    %eax,(%esp)
c01082b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01082b5:	ff d0                	call   *%eax
}
c01082b7:	c9                   	leave  
c01082b8:	c3                   	ret    

c01082b9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01082b9:	55                   	push   %ebp
c01082ba:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01082bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01082c0:	7e 14                	jle    c01082d6 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01082c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c5:	8b 00                	mov    (%eax),%eax
c01082c7:	8d 48 08             	lea    0x8(%eax),%ecx
c01082ca:	8b 55 08             	mov    0x8(%ebp),%edx
c01082cd:	89 0a                	mov    %ecx,(%edx)
c01082cf:	8b 50 04             	mov    0x4(%eax),%edx
c01082d2:	8b 00                	mov    (%eax),%eax
c01082d4:	eb 30                	jmp    c0108306 <getuint+0x4d>
    }
    else if (lflag) {
c01082d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01082da:	74 16                	je     c01082f2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01082dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01082df:	8b 00                	mov    (%eax),%eax
c01082e1:	8d 48 04             	lea    0x4(%eax),%ecx
c01082e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01082e7:	89 0a                	mov    %ecx,(%edx)
c01082e9:	8b 00                	mov    (%eax),%eax
c01082eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01082f0:	eb 14                	jmp    c0108306 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01082f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01082f5:	8b 00                	mov    (%eax),%eax
c01082f7:	8d 48 04             	lea    0x4(%eax),%ecx
c01082fa:	8b 55 08             	mov    0x8(%ebp),%edx
c01082fd:	89 0a                	mov    %ecx,(%edx)
c01082ff:	8b 00                	mov    (%eax),%eax
c0108301:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108306:	5d                   	pop    %ebp
c0108307:	c3                   	ret    

c0108308 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108308:	55                   	push   %ebp
c0108309:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010830b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010830f:	7e 14                	jle    c0108325 <getint+0x1d>
        return va_arg(*ap, long long);
c0108311:	8b 45 08             	mov    0x8(%ebp),%eax
c0108314:	8b 00                	mov    (%eax),%eax
c0108316:	8d 48 08             	lea    0x8(%eax),%ecx
c0108319:	8b 55 08             	mov    0x8(%ebp),%edx
c010831c:	89 0a                	mov    %ecx,(%edx)
c010831e:	8b 50 04             	mov    0x4(%eax),%edx
c0108321:	8b 00                	mov    (%eax),%eax
c0108323:	eb 28                	jmp    c010834d <getint+0x45>
    }
    else if (lflag) {
c0108325:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108329:	74 12                	je     c010833d <getint+0x35>
        return va_arg(*ap, long);
c010832b:	8b 45 08             	mov    0x8(%ebp),%eax
c010832e:	8b 00                	mov    (%eax),%eax
c0108330:	8d 48 04             	lea    0x4(%eax),%ecx
c0108333:	8b 55 08             	mov    0x8(%ebp),%edx
c0108336:	89 0a                	mov    %ecx,(%edx)
c0108338:	8b 00                	mov    (%eax),%eax
c010833a:	99                   	cltd   
c010833b:	eb 10                	jmp    c010834d <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010833d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108340:	8b 00                	mov    (%eax),%eax
c0108342:	8d 48 04             	lea    0x4(%eax),%ecx
c0108345:	8b 55 08             	mov    0x8(%ebp),%edx
c0108348:	89 0a                	mov    %ecx,(%edx)
c010834a:	8b 00                	mov    (%eax),%eax
c010834c:	99                   	cltd   
    }
}
c010834d:	5d                   	pop    %ebp
c010834e:	c3                   	ret    

c010834f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010834f:	55                   	push   %ebp
c0108350:	89 e5                	mov    %esp,%ebp
c0108352:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108355:	8d 45 14             	lea    0x14(%ebp),%eax
c0108358:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010835e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108362:	8b 45 10             	mov    0x10(%ebp),%eax
c0108365:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108369:	8b 45 0c             	mov    0xc(%ebp),%eax
c010836c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108370:	8b 45 08             	mov    0x8(%ebp),%eax
c0108373:	89 04 24             	mov    %eax,(%esp)
c0108376:	e8 02 00 00 00       	call   c010837d <vprintfmt>
    va_end(ap);
}
c010837b:	c9                   	leave  
c010837c:	c3                   	ret    

c010837d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010837d:	55                   	push   %ebp
c010837e:	89 e5                	mov    %esp,%ebp
c0108380:	56                   	push   %esi
c0108381:	53                   	push   %ebx
c0108382:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108385:	eb 18                	jmp    c010839f <vprintfmt+0x22>
            if (ch == '\0') {
c0108387:	85 db                	test   %ebx,%ebx
c0108389:	75 05                	jne    c0108390 <vprintfmt+0x13>
                return;
c010838b:	e9 d1 03 00 00       	jmp    c0108761 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108390:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108393:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108397:	89 1c 24             	mov    %ebx,(%esp)
c010839a:	8b 45 08             	mov    0x8(%ebp),%eax
c010839d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010839f:	8b 45 10             	mov    0x10(%ebp),%eax
c01083a2:	8d 50 01             	lea    0x1(%eax),%edx
c01083a5:	89 55 10             	mov    %edx,0x10(%ebp)
c01083a8:	0f b6 00             	movzbl (%eax),%eax
c01083ab:	0f b6 d8             	movzbl %al,%ebx
c01083ae:	83 fb 25             	cmp    $0x25,%ebx
c01083b1:	75 d4                	jne    c0108387 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01083b3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01083b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01083be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01083c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01083cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01083ce:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01083d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01083d4:	8d 50 01             	lea    0x1(%eax),%edx
c01083d7:	89 55 10             	mov    %edx,0x10(%ebp)
c01083da:	0f b6 00             	movzbl (%eax),%eax
c01083dd:	0f b6 d8             	movzbl %al,%ebx
c01083e0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01083e3:	83 f8 55             	cmp    $0x55,%eax
c01083e6:	0f 87 44 03 00 00    	ja     c0108730 <vprintfmt+0x3b3>
c01083ec:	8b 04 85 34 ac 10 c0 	mov    -0x3fef53cc(,%eax,4),%eax
c01083f3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01083f5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01083f9:	eb d6                	jmp    c01083d1 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01083fb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01083ff:	eb d0                	jmp    c01083d1 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108401:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108408:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010840b:	89 d0                	mov    %edx,%eax
c010840d:	c1 e0 02             	shl    $0x2,%eax
c0108410:	01 d0                	add    %edx,%eax
c0108412:	01 c0                	add    %eax,%eax
c0108414:	01 d8                	add    %ebx,%eax
c0108416:	83 e8 30             	sub    $0x30,%eax
c0108419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010841c:	8b 45 10             	mov    0x10(%ebp),%eax
c010841f:	0f b6 00             	movzbl (%eax),%eax
c0108422:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108425:	83 fb 2f             	cmp    $0x2f,%ebx
c0108428:	7e 0b                	jle    c0108435 <vprintfmt+0xb8>
c010842a:	83 fb 39             	cmp    $0x39,%ebx
c010842d:	7f 06                	jg     c0108435 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010842f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108433:	eb d3                	jmp    c0108408 <vprintfmt+0x8b>
            goto process_precision;
c0108435:	eb 33                	jmp    c010846a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108437:	8b 45 14             	mov    0x14(%ebp),%eax
c010843a:	8d 50 04             	lea    0x4(%eax),%edx
c010843d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108440:	8b 00                	mov    (%eax),%eax
c0108442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108445:	eb 23                	jmp    c010846a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108447:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010844b:	79 0c                	jns    c0108459 <vprintfmt+0xdc>
                width = 0;
c010844d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108454:	e9 78 ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>
c0108459:	e9 73 ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010845e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108465:	e9 67 ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010846a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010846e:	79 12                	jns    c0108482 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108473:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010847d:	e9 4f ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>
c0108482:	e9 4a ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108487:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010848b:	e9 41 ff ff ff       	jmp    c01083d1 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108490:	8b 45 14             	mov    0x14(%ebp),%eax
c0108493:	8d 50 04             	lea    0x4(%eax),%edx
c0108496:	89 55 14             	mov    %edx,0x14(%ebp)
c0108499:	8b 00                	mov    (%eax),%eax
c010849b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010849e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084a2:	89 04 24             	mov    %eax,(%esp)
c01084a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01084a8:	ff d0                	call   *%eax
            break;
c01084aa:	e9 ac 02 00 00       	jmp    c010875b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01084af:	8b 45 14             	mov    0x14(%ebp),%eax
c01084b2:	8d 50 04             	lea    0x4(%eax),%edx
c01084b5:	89 55 14             	mov    %edx,0x14(%ebp)
c01084b8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01084ba:	85 db                	test   %ebx,%ebx
c01084bc:	79 02                	jns    c01084c0 <vprintfmt+0x143>
                err = -err;
c01084be:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01084c0:	83 fb 06             	cmp    $0x6,%ebx
c01084c3:	7f 0b                	jg     c01084d0 <vprintfmt+0x153>
c01084c5:	8b 34 9d f4 ab 10 c0 	mov    -0x3fef540c(,%ebx,4),%esi
c01084cc:	85 f6                	test   %esi,%esi
c01084ce:	75 23                	jne    c01084f3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01084d0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01084d4:	c7 44 24 08 21 ac 10 	movl   $0xc010ac21,0x8(%esp)
c01084db:	c0 
c01084dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01084e6:	89 04 24             	mov    %eax,(%esp)
c01084e9:	e8 61 fe ff ff       	call   c010834f <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01084ee:	e9 68 02 00 00       	jmp    c010875b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01084f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01084f7:	c7 44 24 08 2a ac 10 	movl   $0xc010ac2a,0x8(%esp)
c01084fe:	c0 
c01084ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108502:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108506:	8b 45 08             	mov    0x8(%ebp),%eax
c0108509:	89 04 24             	mov    %eax,(%esp)
c010850c:	e8 3e fe ff ff       	call   c010834f <printfmt>
            }
            break;
c0108511:	e9 45 02 00 00       	jmp    c010875b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108516:	8b 45 14             	mov    0x14(%ebp),%eax
c0108519:	8d 50 04             	lea    0x4(%eax),%edx
c010851c:	89 55 14             	mov    %edx,0x14(%ebp)
c010851f:	8b 30                	mov    (%eax),%esi
c0108521:	85 f6                	test   %esi,%esi
c0108523:	75 05                	jne    c010852a <vprintfmt+0x1ad>
                p = "(null)";
c0108525:	be 2d ac 10 c0       	mov    $0xc010ac2d,%esi
            }
            if (width > 0 && padc != '-') {
c010852a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010852e:	7e 3e                	jle    c010856e <vprintfmt+0x1f1>
c0108530:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108534:	74 38                	je     c010856e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108536:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010853c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108540:	89 34 24             	mov    %esi,(%esp)
c0108543:	e8 ed 03 00 00       	call   c0108935 <strnlen>
c0108548:	29 c3                	sub    %eax,%ebx
c010854a:	89 d8                	mov    %ebx,%eax
c010854c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010854f:	eb 17                	jmp    c0108568 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108551:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108555:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108558:	89 54 24 04          	mov    %edx,0x4(%esp)
c010855c:	89 04 24             	mov    %eax,(%esp)
c010855f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108562:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108564:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108568:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010856c:	7f e3                	jg     c0108551 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010856e:	eb 38                	jmp    c01085a8 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108574:	74 1f                	je     c0108595 <vprintfmt+0x218>
c0108576:	83 fb 1f             	cmp    $0x1f,%ebx
c0108579:	7e 05                	jle    c0108580 <vprintfmt+0x203>
c010857b:	83 fb 7e             	cmp    $0x7e,%ebx
c010857e:	7e 15                	jle    c0108595 <vprintfmt+0x218>
                    putch('?', putdat);
c0108580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108583:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108587:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010858e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108591:	ff d0                	call   *%eax
c0108593:	eb 0f                	jmp    c01085a4 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108595:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108598:	89 44 24 04          	mov    %eax,0x4(%esp)
c010859c:	89 1c 24             	mov    %ebx,(%esp)
c010859f:	8b 45 08             	mov    0x8(%ebp),%eax
c01085a2:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01085a4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01085a8:	89 f0                	mov    %esi,%eax
c01085aa:	8d 70 01             	lea    0x1(%eax),%esi
c01085ad:	0f b6 00             	movzbl (%eax),%eax
c01085b0:	0f be d8             	movsbl %al,%ebx
c01085b3:	85 db                	test   %ebx,%ebx
c01085b5:	74 10                	je     c01085c7 <vprintfmt+0x24a>
c01085b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01085bb:	78 b3                	js     c0108570 <vprintfmt+0x1f3>
c01085bd:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01085c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01085c5:	79 a9                	jns    c0108570 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01085c7:	eb 17                	jmp    c01085e0 <vprintfmt+0x263>
                putch(' ', putdat);
c01085c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01085d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01085da:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01085dc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01085e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085e4:	7f e3                	jg     c01085c9 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01085e6:	e9 70 01 00 00       	jmp    c010875b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01085eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085f2:	8d 45 14             	lea    0x14(%ebp),%eax
c01085f5:	89 04 24             	mov    %eax,(%esp)
c01085f8:	e8 0b fd ff ff       	call   c0108308 <getint>
c01085fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108600:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108603:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108606:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108609:	85 d2                	test   %edx,%edx
c010860b:	79 26                	jns    c0108633 <vprintfmt+0x2b6>
                putch('-', putdat);
c010860d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108610:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108614:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010861b:	8b 45 08             	mov    0x8(%ebp),%eax
c010861e:	ff d0                	call   *%eax
                num = -(long long)num;
c0108620:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108623:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108626:	f7 d8                	neg    %eax
c0108628:	83 d2 00             	adc    $0x0,%edx
c010862b:	f7 da                	neg    %edx
c010862d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108630:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108633:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010863a:	e9 a8 00 00 00       	jmp    c01086e7 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010863f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108646:	8d 45 14             	lea    0x14(%ebp),%eax
c0108649:	89 04 24             	mov    %eax,(%esp)
c010864c:	e8 68 fc ff ff       	call   c01082b9 <getuint>
c0108651:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108654:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108657:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010865e:	e9 84 00 00 00       	jmp    c01086e7 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108663:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108666:	89 44 24 04          	mov    %eax,0x4(%esp)
c010866a:	8d 45 14             	lea    0x14(%ebp),%eax
c010866d:	89 04 24             	mov    %eax,(%esp)
c0108670:	e8 44 fc ff ff       	call   c01082b9 <getuint>
c0108675:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108678:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010867b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108682:	eb 63                	jmp    c01086e7 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108684:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108687:	89 44 24 04          	mov    %eax,0x4(%esp)
c010868b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108692:	8b 45 08             	mov    0x8(%ebp),%eax
c0108695:	ff d0                	call   *%eax
            putch('x', putdat);
c0108697:	8b 45 0c             	mov    0xc(%ebp),%eax
c010869a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010869e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01086a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086a8:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01086aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01086ad:	8d 50 04             	lea    0x4(%eax),%edx
c01086b0:	89 55 14             	mov    %edx,0x14(%ebp)
c01086b3:	8b 00                	mov    (%eax),%eax
c01086b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01086bf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01086c6:	eb 1f                	jmp    c01086e7 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01086c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086cf:	8d 45 14             	lea    0x14(%ebp),%eax
c01086d2:	89 04 24             	mov    %eax,(%esp)
c01086d5:	e8 df fb ff ff       	call   c01082b9 <getuint>
c01086da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01086e0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01086e7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01086eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01086ee:	89 54 24 18          	mov    %edx,0x18(%esp)
c01086f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01086f5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01086f9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01086fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108700:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108703:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108707:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010870b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010870e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108712:	8b 45 08             	mov    0x8(%ebp),%eax
c0108715:	89 04 24             	mov    %eax,(%esp)
c0108718:	e8 97 fa ff ff       	call   c01081b4 <printnum>
            break;
c010871d:	eb 3c                	jmp    c010875b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010871f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108722:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108726:	89 1c 24             	mov    %ebx,(%esp)
c0108729:	8b 45 08             	mov    0x8(%ebp),%eax
c010872c:	ff d0                	call   *%eax
            break;
c010872e:	eb 2b                	jmp    c010875b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108730:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108733:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108737:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010873e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108741:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108743:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108747:	eb 04                	jmp    c010874d <vprintfmt+0x3d0>
c0108749:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010874d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108750:	83 e8 01             	sub    $0x1,%eax
c0108753:	0f b6 00             	movzbl (%eax),%eax
c0108756:	3c 25                	cmp    $0x25,%al
c0108758:	75 ef                	jne    c0108749 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010875a:	90                   	nop
        }
    }
c010875b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010875c:	e9 3e fc ff ff       	jmp    c010839f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108761:	83 c4 40             	add    $0x40,%esp
c0108764:	5b                   	pop    %ebx
c0108765:	5e                   	pop    %esi
c0108766:	5d                   	pop    %ebp
c0108767:	c3                   	ret    

c0108768 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108768:	55                   	push   %ebp
c0108769:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010876b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010876e:	8b 40 08             	mov    0x8(%eax),%eax
c0108771:	8d 50 01             	lea    0x1(%eax),%edx
c0108774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108777:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010877a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010877d:	8b 10                	mov    (%eax),%edx
c010877f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108782:	8b 40 04             	mov    0x4(%eax),%eax
c0108785:	39 c2                	cmp    %eax,%edx
c0108787:	73 12                	jae    c010879b <sprintputch+0x33>
        *b->buf ++ = ch;
c0108789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010878c:	8b 00                	mov    (%eax),%eax
c010878e:	8d 48 01             	lea    0x1(%eax),%ecx
c0108791:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108794:	89 0a                	mov    %ecx,(%edx)
c0108796:	8b 55 08             	mov    0x8(%ebp),%edx
c0108799:	88 10                	mov    %dl,(%eax)
    }
}
c010879b:	5d                   	pop    %ebp
c010879c:	c3                   	ret    

c010879d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010879d:	55                   	push   %ebp
c010879e:	89 e5                	mov    %esp,%ebp
c01087a0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01087a3:	8d 45 14             	lea    0x14(%ebp),%eax
c01087a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01087a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01087b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01087b3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01087b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087be:	8b 45 08             	mov    0x8(%ebp),%eax
c01087c1:	89 04 24             	mov    %eax,(%esp)
c01087c4:	e8 08 00 00 00       	call   c01087d1 <vsnprintf>
c01087c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01087cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01087cf:	c9                   	leave  
c01087d0:	c3                   	ret    

c01087d1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01087d1:	55                   	push   %ebp
c01087d2:	89 e5                	mov    %esp,%ebp
c01087d4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01087d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01087da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01087dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087e0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01087e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e6:	01 d0                	add    %edx,%eax
c01087e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01087eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01087f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01087f6:	74 0a                	je     c0108802 <vsnprintf+0x31>
c01087f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01087fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087fe:	39 c2                	cmp    %eax,%edx
c0108800:	76 07                	jbe    c0108809 <vsnprintf+0x38>
        return -E_INVAL;
c0108802:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108807:	eb 2a                	jmp    c0108833 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108809:	8b 45 14             	mov    0x14(%ebp),%eax
c010880c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108810:	8b 45 10             	mov    0x10(%ebp),%eax
c0108813:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108817:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010881a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010881e:	c7 04 24 68 87 10 c0 	movl   $0xc0108768,(%esp)
c0108825:	e8 53 fb ff ff       	call   c010837d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010882a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010882d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108830:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108833:	c9                   	leave  
c0108834:	c3                   	ret    

c0108835 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108835:	55                   	push   %ebp
c0108836:	89 e5                	mov    %esp,%ebp
c0108838:	57                   	push   %edi
c0108839:	56                   	push   %esi
c010883a:	53                   	push   %ebx
c010883b:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010883e:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108843:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c0108849:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010884f:	6b f0 05             	imul   $0x5,%eax,%esi
c0108852:	01 f7                	add    %esi,%edi
c0108854:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0108859:	f7 e6                	mul    %esi
c010885b:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010885e:	89 f2                	mov    %esi,%edx
c0108860:	83 c0 0b             	add    $0xb,%eax
c0108863:	83 d2 00             	adc    $0x0,%edx
c0108866:	89 c7                	mov    %eax,%edi
c0108868:	83 e7 ff             	and    $0xffffffff,%edi
c010886b:	89 f9                	mov    %edi,%ecx
c010886d:	0f b7 da             	movzwl %dx,%ebx
c0108870:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c0108876:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c010887c:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108881:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c0108887:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010888b:	c1 ea 0c             	shr    $0xc,%edx
c010888e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108891:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108894:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010889b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010889e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01088a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01088a4:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01088a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01088ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01088b1:	74 1c                	je     c01088cf <rand+0x9a>
c01088b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088b6:	ba 00 00 00 00       	mov    $0x0,%edx
c01088bb:	f7 75 dc             	divl   -0x24(%ebp)
c01088be:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01088c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088c4:	ba 00 00 00 00       	mov    $0x0,%edx
c01088c9:	f7 75 dc             	divl   -0x24(%ebp)
c01088cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01088cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01088d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01088d5:	f7 75 dc             	divl   -0x24(%ebp)
c01088d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01088db:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01088de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01088e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01088e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01088e7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01088ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01088ed:	83 c4 24             	add    $0x24,%esp
c01088f0:	5b                   	pop    %ebx
c01088f1:	5e                   	pop    %esi
c01088f2:	5f                   	pop    %edi
c01088f3:	5d                   	pop    %ebp
c01088f4:	c3                   	ret    

c01088f5 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01088f5:	55                   	push   %ebp
c01088f6:	89 e5                	mov    %esp,%ebp
    next = seed;
c01088f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01088fb:	ba 00 00 00 00       	mov    $0x0,%edx
c0108900:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c0108905:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c010890b:	5d                   	pop    %ebp
c010890c:	c3                   	ret    

c010890d <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010890d:	55                   	push   %ebp
c010890e:	89 e5                	mov    %esp,%ebp
c0108910:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010891a:	eb 04                	jmp    c0108920 <strlen+0x13>
        cnt ++;
c010891c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108920:	8b 45 08             	mov    0x8(%ebp),%eax
c0108923:	8d 50 01             	lea    0x1(%eax),%edx
c0108926:	89 55 08             	mov    %edx,0x8(%ebp)
c0108929:	0f b6 00             	movzbl (%eax),%eax
c010892c:	84 c0                	test   %al,%al
c010892e:	75 ec                	jne    c010891c <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108930:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108933:	c9                   	leave  
c0108934:	c3                   	ret    

c0108935 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108935:	55                   	push   %ebp
c0108936:	89 e5                	mov    %esp,%ebp
c0108938:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010893b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108942:	eb 04                	jmp    c0108948 <strnlen+0x13>
        cnt ++;
c0108944:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108948:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010894b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010894e:	73 10                	jae    c0108960 <strnlen+0x2b>
c0108950:	8b 45 08             	mov    0x8(%ebp),%eax
c0108953:	8d 50 01             	lea    0x1(%eax),%edx
c0108956:	89 55 08             	mov    %edx,0x8(%ebp)
c0108959:	0f b6 00             	movzbl (%eax),%eax
c010895c:	84 c0                	test   %al,%al
c010895e:	75 e4                	jne    c0108944 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108960:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108963:	c9                   	leave  
c0108964:	c3                   	ret    

c0108965 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108965:	55                   	push   %ebp
c0108966:	89 e5                	mov    %esp,%ebp
c0108968:	57                   	push   %edi
c0108969:	56                   	push   %esi
c010896a:	83 ec 20             	sub    $0x20,%esp
c010896d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108970:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108973:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108976:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108979:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010897c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010897f:	89 d1                	mov    %edx,%ecx
c0108981:	89 c2                	mov    %eax,%edx
c0108983:	89 ce                	mov    %ecx,%esi
c0108985:	89 d7                	mov    %edx,%edi
c0108987:	ac                   	lods   %ds:(%esi),%al
c0108988:	aa                   	stos   %al,%es:(%edi)
c0108989:	84 c0                	test   %al,%al
c010898b:	75 fa                	jne    c0108987 <strcpy+0x22>
c010898d:	89 fa                	mov    %edi,%edx
c010898f:	89 f1                	mov    %esi,%ecx
c0108991:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108994:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010899a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010899d:	83 c4 20             	add    $0x20,%esp
c01089a0:	5e                   	pop    %esi
c01089a1:	5f                   	pop    %edi
c01089a2:	5d                   	pop    %ebp
c01089a3:	c3                   	ret    

c01089a4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01089a4:	55                   	push   %ebp
c01089a5:	89 e5                	mov    %esp,%ebp
c01089a7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01089aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01089b0:	eb 21                	jmp    c01089d3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01089b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089b5:	0f b6 10             	movzbl (%eax),%edx
c01089b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01089bb:	88 10                	mov    %dl,(%eax)
c01089bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01089c0:	0f b6 00             	movzbl (%eax),%eax
c01089c3:	84 c0                	test   %al,%al
c01089c5:	74 04                	je     c01089cb <strncpy+0x27>
            src ++;
c01089c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01089cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01089cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01089d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089d7:	75 d9                	jne    c01089b2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01089d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01089dc:	c9                   	leave  
c01089dd:	c3                   	ret    

c01089de <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01089de:	55                   	push   %ebp
c01089df:	89 e5                	mov    %esp,%ebp
c01089e1:	57                   	push   %edi
c01089e2:	56                   	push   %esi
c01089e3:	83 ec 20             	sub    $0x20,%esp
c01089e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01089f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01089f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089f8:	89 d1                	mov    %edx,%ecx
c01089fa:	89 c2                	mov    %eax,%edx
c01089fc:	89 ce                	mov    %ecx,%esi
c01089fe:	89 d7                	mov    %edx,%edi
c0108a00:	ac                   	lods   %ds:(%esi),%al
c0108a01:	ae                   	scas   %es:(%edi),%al
c0108a02:	75 08                	jne    c0108a0c <strcmp+0x2e>
c0108a04:	84 c0                	test   %al,%al
c0108a06:	75 f8                	jne    c0108a00 <strcmp+0x22>
c0108a08:	31 c0                	xor    %eax,%eax
c0108a0a:	eb 04                	jmp    c0108a10 <strcmp+0x32>
c0108a0c:	19 c0                	sbb    %eax,%eax
c0108a0e:	0c 01                	or     $0x1,%al
c0108a10:	89 fa                	mov    %edi,%edx
c0108a12:	89 f1                	mov    %esi,%ecx
c0108a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a17:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108a1a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108a20:	83 c4 20             	add    $0x20,%esp
c0108a23:	5e                   	pop    %esi
c0108a24:	5f                   	pop    %edi
c0108a25:	5d                   	pop    %ebp
c0108a26:	c3                   	ret    

c0108a27 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108a27:	55                   	push   %ebp
c0108a28:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108a2a:	eb 0c                	jmp    c0108a38 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108a2c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108a30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a3c:	74 1a                	je     c0108a58 <strncmp+0x31>
c0108a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a41:	0f b6 00             	movzbl (%eax),%eax
c0108a44:	84 c0                	test   %al,%al
c0108a46:	74 10                	je     c0108a58 <strncmp+0x31>
c0108a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a4b:	0f b6 10             	movzbl (%eax),%edx
c0108a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a51:	0f b6 00             	movzbl (%eax),%eax
c0108a54:	38 c2                	cmp    %al,%dl
c0108a56:	74 d4                	je     c0108a2c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108a58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a5c:	74 18                	je     c0108a76 <strncmp+0x4f>
c0108a5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a61:	0f b6 00             	movzbl (%eax),%eax
c0108a64:	0f b6 d0             	movzbl %al,%edx
c0108a67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a6a:	0f b6 00             	movzbl (%eax),%eax
c0108a6d:	0f b6 c0             	movzbl %al,%eax
c0108a70:	29 c2                	sub    %eax,%edx
c0108a72:	89 d0                	mov    %edx,%eax
c0108a74:	eb 05                	jmp    c0108a7b <strncmp+0x54>
c0108a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108a7b:	5d                   	pop    %ebp
c0108a7c:	c3                   	ret    

c0108a7d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108a7d:	55                   	push   %ebp
c0108a7e:	89 e5                	mov    %esp,%ebp
c0108a80:	83 ec 04             	sub    $0x4,%esp
c0108a83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a86:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108a89:	eb 14                	jmp    c0108a9f <strchr+0x22>
        if (*s == c) {
c0108a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a8e:	0f b6 00             	movzbl (%eax),%eax
c0108a91:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108a94:	75 05                	jne    c0108a9b <strchr+0x1e>
            return (char *)s;
c0108a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a99:	eb 13                	jmp    c0108aae <strchr+0x31>
        }
        s ++;
c0108a9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa2:	0f b6 00             	movzbl (%eax),%eax
c0108aa5:	84 c0                	test   %al,%al
c0108aa7:	75 e2                	jne    c0108a8b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108aae:	c9                   	leave  
c0108aaf:	c3                   	ret    

c0108ab0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108ab0:	55                   	push   %ebp
c0108ab1:	89 e5                	mov    %esp,%ebp
c0108ab3:	83 ec 04             	sub    $0x4,%esp
c0108ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ab9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108abc:	eb 11                	jmp    c0108acf <strfind+0x1f>
        if (*s == c) {
c0108abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ac1:	0f b6 00             	movzbl (%eax),%eax
c0108ac4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108ac7:	75 02                	jne    c0108acb <strfind+0x1b>
            break;
c0108ac9:	eb 0e                	jmp    c0108ad9 <strfind+0x29>
        }
        s ++;
c0108acb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad2:	0f b6 00             	movzbl (%eax),%eax
c0108ad5:	84 c0                	test   %al,%al
c0108ad7:	75 e5                	jne    c0108abe <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0108ad9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108adc:	c9                   	leave  
c0108add:	c3                   	ret    

c0108ade <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108ade:	55                   	push   %ebp
c0108adf:	89 e5                	mov    %esp,%ebp
c0108ae1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108ae4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108aeb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108af2:	eb 04                	jmp    c0108af8 <strtol+0x1a>
        s ++;
c0108af4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afb:	0f b6 00             	movzbl (%eax),%eax
c0108afe:	3c 20                	cmp    $0x20,%al
c0108b00:	74 f2                	je     c0108af4 <strtol+0x16>
c0108b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b05:	0f b6 00             	movzbl (%eax),%eax
c0108b08:	3c 09                	cmp    $0x9,%al
c0108b0a:	74 e8                	je     c0108af4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0108b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b0f:	0f b6 00             	movzbl (%eax),%eax
c0108b12:	3c 2b                	cmp    $0x2b,%al
c0108b14:	75 06                	jne    c0108b1c <strtol+0x3e>
        s ++;
c0108b16:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108b1a:	eb 15                	jmp    c0108b31 <strtol+0x53>
    }
    else if (*s == '-') {
c0108b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1f:	0f b6 00             	movzbl (%eax),%eax
c0108b22:	3c 2d                	cmp    $0x2d,%al
c0108b24:	75 0b                	jne    c0108b31 <strtol+0x53>
        s ++, neg = 1;
c0108b26:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108b2a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108b31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108b35:	74 06                	je     c0108b3d <strtol+0x5f>
c0108b37:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108b3b:	75 24                	jne    c0108b61 <strtol+0x83>
c0108b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b40:	0f b6 00             	movzbl (%eax),%eax
c0108b43:	3c 30                	cmp    $0x30,%al
c0108b45:	75 1a                	jne    c0108b61 <strtol+0x83>
c0108b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b4a:	83 c0 01             	add    $0x1,%eax
c0108b4d:	0f b6 00             	movzbl (%eax),%eax
c0108b50:	3c 78                	cmp    $0x78,%al
c0108b52:	75 0d                	jne    c0108b61 <strtol+0x83>
        s += 2, base = 16;
c0108b54:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108b58:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108b5f:	eb 2a                	jmp    c0108b8b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108b61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108b65:	75 17                	jne    c0108b7e <strtol+0xa0>
c0108b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b6a:	0f b6 00             	movzbl (%eax),%eax
c0108b6d:	3c 30                	cmp    $0x30,%al
c0108b6f:	75 0d                	jne    c0108b7e <strtol+0xa0>
        s ++, base = 8;
c0108b71:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108b75:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108b7c:	eb 0d                	jmp    c0108b8b <strtol+0xad>
    }
    else if (base == 0) {
c0108b7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108b82:	75 07                	jne    c0108b8b <strtol+0xad>
        base = 10;
c0108b84:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b8e:	0f b6 00             	movzbl (%eax),%eax
c0108b91:	3c 2f                	cmp    $0x2f,%al
c0108b93:	7e 1b                	jle    c0108bb0 <strtol+0xd2>
c0108b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b98:	0f b6 00             	movzbl (%eax),%eax
c0108b9b:	3c 39                	cmp    $0x39,%al
c0108b9d:	7f 11                	jg     c0108bb0 <strtol+0xd2>
            dig = *s - '0';
c0108b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ba2:	0f b6 00             	movzbl (%eax),%eax
c0108ba5:	0f be c0             	movsbl %al,%eax
c0108ba8:	83 e8 30             	sub    $0x30,%eax
c0108bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bae:	eb 48                	jmp    c0108bf8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb3:	0f b6 00             	movzbl (%eax),%eax
c0108bb6:	3c 60                	cmp    $0x60,%al
c0108bb8:	7e 1b                	jle    c0108bd5 <strtol+0xf7>
c0108bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bbd:	0f b6 00             	movzbl (%eax),%eax
c0108bc0:	3c 7a                	cmp    $0x7a,%al
c0108bc2:	7f 11                	jg     c0108bd5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bc7:	0f b6 00             	movzbl (%eax),%eax
c0108bca:	0f be c0             	movsbl %al,%eax
c0108bcd:	83 e8 57             	sub    $0x57,%eax
c0108bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bd3:	eb 23                	jmp    c0108bf8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bd8:	0f b6 00             	movzbl (%eax),%eax
c0108bdb:	3c 40                	cmp    $0x40,%al
c0108bdd:	7e 3d                	jle    c0108c1c <strtol+0x13e>
c0108bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108be2:	0f b6 00             	movzbl (%eax),%eax
c0108be5:	3c 5a                	cmp    $0x5a,%al
c0108be7:	7f 33                	jg     c0108c1c <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bec:	0f b6 00             	movzbl (%eax),%eax
c0108bef:	0f be c0             	movsbl %al,%eax
c0108bf2:	83 e8 37             	sub    $0x37,%eax
c0108bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bfb:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108bfe:	7c 02                	jl     c0108c02 <strtol+0x124>
            break;
c0108c00:	eb 1a                	jmp    c0108c1c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108c02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108c06:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c09:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108c0d:	89 c2                	mov    %eax,%edx
c0108c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c12:	01 d0                	add    %edx,%eax
c0108c14:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108c17:	e9 6f ff ff ff       	jmp    c0108b8b <strtol+0xad>

    if (endptr) {
c0108c1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108c20:	74 08                	je     c0108c2a <strtol+0x14c>
        *endptr = (char *) s;
c0108c22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c25:	8b 55 08             	mov    0x8(%ebp),%edx
c0108c28:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108c2e:	74 07                	je     c0108c37 <strtol+0x159>
c0108c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c33:	f7 d8                	neg    %eax
c0108c35:	eb 03                	jmp    c0108c3a <strtol+0x15c>
c0108c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108c3a:	c9                   	leave  
c0108c3b:	c3                   	ret    

c0108c3c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108c3c:	55                   	push   %ebp
c0108c3d:	89 e5                	mov    %esp,%ebp
c0108c3f:	57                   	push   %edi
c0108c40:	83 ec 24             	sub    $0x24,%esp
c0108c43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c46:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108c49:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108c4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108c50:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108c53:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108c56:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108c5c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108c5f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108c63:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108c66:	89 d7                	mov    %edx,%edi
c0108c68:	f3 aa                	rep stos %al,%es:(%edi)
c0108c6a:	89 fa                	mov    %edi,%edx
c0108c6c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108c6f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108c72:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108c75:	83 c4 24             	add    $0x24,%esp
c0108c78:	5f                   	pop    %edi
c0108c79:	5d                   	pop    %ebp
c0108c7a:	c3                   	ret    

c0108c7b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108c7b:	55                   	push   %ebp
c0108c7c:	89 e5                	mov    %esp,%ebp
c0108c7e:	57                   	push   %edi
c0108c7f:	56                   	push   %esi
c0108c80:	53                   	push   %ebx
c0108c81:	83 ec 30             	sub    $0x30,%esp
c0108c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108c90:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c93:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108c9c:	73 42                	jae    c0108ce0 <memmove+0x65>
c0108c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ca1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cad:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108cb0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108cb3:	c1 e8 02             	shr    $0x2,%eax
c0108cb6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108cb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108cbe:	89 d7                	mov    %edx,%edi
c0108cc0:	89 c6                	mov    %eax,%esi
c0108cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108cc4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108cc7:	83 e1 03             	and    $0x3,%ecx
c0108cca:	74 02                	je     c0108cce <memmove+0x53>
c0108ccc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108cce:	89 f0                	mov    %esi,%eax
c0108cd0:	89 fa                	mov    %edi,%edx
c0108cd2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108cd5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108cd8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108cdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108cde:	eb 36                	jmp    c0108d16 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108ce0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ce3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ce9:	01 c2                	add    %eax,%edx
c0108ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cee:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cf4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cfa:	89 c1                	mov    %eax,%ecx
c0108cfc:	89 d8                	mov    %ebx,%eax
c0108cfe:	89 d6                	mov    %edx,%esi
c0108d00:	89 c7                	mov    %eax,%edi
c0108d02:	fd                   	std    
c0108d03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108d05:	fc                   	cld    
c0108d06:	89 f8                	mov    %edi,%eax
c0108d08:	89 f2                	mov    %esi,%edx
c0108d0a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108d0d:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108d10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108d16:	83 c4 30             	add    $0x30,%esp
c0108d19:	5b                   	pop    %ebx
c0108d1a:	5e                   	pop    %esi
c0108d1b:	5f                   	pop    %edi
c0108d1c:	5d                   	pop    %ebp
c0108d1d:	c3                   	ret    

c0108d1e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108d1e:	55                   	push   %ebp
c0108d1f:	89 e5                	mov    %esp,%ebp
c0108d21:	57                   	push   %edi
c0108d22:	56                   	push   %esi
c0108d23:	83 ec 20             	sub    $0x20,%esp
c0108d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d32:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d3b:	c1 e8 02             	shr    $0x2,%eax
c0108d3e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d46:	89 d7                	mov    %edx,%edi
c0108d48:	89 c6                	mov    %eax,%esi
c0108d4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108d4c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108d4f:	83 e1 03             	and    $0x3,%ecx
c0108d52:	74 02                	je     c0108d56 <memcpy+0x38>
c0108d54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108d56:	89 f0                	mov    %esi,%eax
c0108d58:	89 fa                	mov    %edi,%edx
c0108d5a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108d5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108d60:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108d66:	83 c4 20             	add    $0x20,%esp
c0108d69:	5e                   	pop    %esi
c0108d6a:	5f                   	pop    %edi
c0108d6b:	5d                   	pop    %ebp
c0108d6c:	c3                   	ret    

c0108d6d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108d6d:	55                   	push   %ebp
c0108d6e:	89 e5                	mov    %esp,%ebp
c0108d70:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108d79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108d7f:	eb 30                	jmp    c0108db1 <memcmp+0x44>
        if (*s1 != *s2) {
c0108d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108d84:	0f b6 10             	movzbl (%eax),%edx
c0108d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108d8a:	0f b6 00             	movzbl (%eax),%eax
c0108d8d:	38 c2                	cmp    %al,%dl
c0108d8f:	74 18                	je     c0108da9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108d94:	0f b6 00             	movzbl (%eax),%eax
c0108d97:	0f b6 d0             	movzbl %al,%edx
c0108d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108d9d:	0f b6 00             	movzbl (%eax),%eax
c0108da0:	0f b6 c0             	movzbl %al,%eax
c0108da3:	29 c2                	sub    %eax,%edx
c0108da5:	89 d0                	mov    %edx,%eax
c0108da7:	eb 1a                	jmp    c0108dc3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108da9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108dad:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108db1:	8b 45 10             	mov    0x10(%ebp),%eax
c0108db4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108db7:	89 55 10             	mov    %edx,0x10(%ebp)
c0108dba:	85 c0                	test   %eax,%eax
c0108dbc:	75 c3                	jne    c0108d81 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108dc3:	c9                   	leave  
c0108dc4:	c3                   	ret    
