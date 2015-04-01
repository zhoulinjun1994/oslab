
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 b6 5f 00 00       	call   10600c <memset>

    cons_init();                // init the console
  100056:	e8 6b 15 00 00       	call   1015c6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 a0 61 10 00 	movl   $0x1061a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 bc 61 10 00 	movl   $0x1061bc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 9f 44 00 00       	call   104523 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 a6 16 00 00       	call   10172f <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 1e 18 00 00       	call   1018ac <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 e9 0c 00 00       	call   100d7c <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 05 16 00 00       	call   10169d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f2 0b 00 00       	call   100cae <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 c1 61 10 00 	movl   $0x1061c1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 cf 61 10 00 	movl   $0x1061cf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 dd 61 10 00 	movl   $0x1061dd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 eb 61 10 00 	movl   $0x1061eb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 f9 61 10 00 	movl   $0x1061f9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 08 62 10 00 	movl   $0x106208,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 28 62 10 00 	movl   $0x106228,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 47 62 10 00 	movl   $0x106247,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 f8 12 00 00       	call   1015f2 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 ee 54 00 00       	call   105825 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 7f 12 00 00       	call   1015f2 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 5f 12 00 00       	call   10162e <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 4c 62 10 00    	movl   $0x10624c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 4c 62 10 00 	movl   $0x10624c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a8 74 10 00 	movl   $0x1074a8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 28 21 11 00 	movl   $0x112128,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 29 21 11 00 	movl   $0x112129,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 74 4b 11 00 	movl   $0x114b74,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 94 57 00 00       	call   105e80 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 56 62 10 00 	movl   $0x106256,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 95 61 10 	movl   $0x106195,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 87 62 10 00 	movl   $0x106287,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 9f 62 10 00 	movl   $0x10629f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 b7 62 10 00 	movl   $0x1062b7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 d0 62 10 00 	movl   $0x1062d0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 fa 62 10 00 	movl   $0x1062fa,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 16 63 10 00 	movl   $0x106316,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 28 63 10 00 	movl   $0x106328,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 02             	add    $0x2,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
  100a36:	c7 04 24 4c 63 10 00 	movl   $0x10634c,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip - 1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a6b:	0f 8e 6e ff ff ff    	jle    1009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
  100a71:	c9                   	leave  
  100a72:	c3                   	ret    

00100a73 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a73:	55                   	push   %ebp
  100a74:	89 e5                	mov    %esp,%ebp
  100a76:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a80:	eb 0c                	jmp    100a8e <parse+0x1b>
            *buf ++ = '\0';
  100a82:	8b 45 08             	mov    0x8(%ebp),%eax
  100a85:	8d 50 01             	lea    0x1(%eax),%edx
  100a88:	89 55 08             	mov    %edx,0x8(%ebp)
  100a8b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a91:	0f b6 00             	movzbl (%eax),%eax
  100a94:	84 c0                	test   %al,%al
  100a96:	74 1d                	je     100ab5 <parse+0x42>
  100a98:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9b:	0f b6 00             	movzbl (%eax),%eax
  100a9e:	0f be c0             	movsbl %al,%eax
  100aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa5:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  100aac:	e8 9c 53 00 00       	call   105e4d <strchr>
  100ab1:	85 c0                	test   %eax,%eax
  100ab3:	75 cd                	jne    100a82 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab8:	0f b6 00             	movzbl (%eax),%eax
  100abb:	84 c0                	test   %al,%al
  100abd:	75 02                	jne    100ac1 <parse+0x4e>
            break;
  100abf:	eb 67                	jmp    100b28 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ac5:	75 14                	jne    100adb <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ac7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ace:	00 
  100acf:	c7 04 24 d5 63 10 00 	movl   $0x1063d5,(%esp)
  100ad6:	e8 61 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ade:	8d 50 01             	lea    0x1(%eax),%edx
  100ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aee:	01 c2                	add    %eax,%edx
  100af0:	8b 45 08             	mov    0x8(%ebp),%eax
  100af3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af5:	eb 04                	jmp    100afb <parse+0x88>
            buf ++;
  100af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	0f b6 00             	movzbl (%eax),%eax
  100b01:	84 c0                	test   %al,%al
  100b03:	74 1d                	je     100b22 <parse+0xaf>
  100b05:	8b 45 08             	mov    0x8(%ebp),%eax
  100b08:	0f b6 00             	movzbl (%eax),%eax
  100b0b:	0f be c0             	movsbl %al,%eax
  100b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b12:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  100b19:	e8 2f 53 00 00       	call   105e4d <strchr>
  100b1e:	85 c0                	test   %eax,%eax
  100b20:	74 d5                	je     100af7 <parse+0x84>
            buf ++;
        }
    }
  100b22:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b23:	e9 66 ff ff ff       	jmp    100a8e <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b2b:	c9                   	leave  
  100b2c:	c3                   	ret    

00100b2d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b2d:	55                   	push   %ebp
  100b2e:	89 e5                	mov    %esp,%ebp
  100b30:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3d:	89 04 24             	mov    %eax,(%esp)
  100b40:	e8 2e ff ff ff       	call   100a73 <parse>
  100b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b4c:	75 0a                	jne    100b58 <runcmd+0x2b>
        return 0;
  100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b53:	e9 85 00 00 00       	jmp    100bdd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b5f:	eb 5c                	jmp    100bbd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b61:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b67:	89 d0                	mov    %edx,%eax
  100b69:	01 c0                	add    %eax,%eax
  100b6b:	01 d0                	add    %edx,%eax
  100b6d:	c1 e0 02             	shl    $0x2,%eax
  100b70:	05 20 70 11 00       	add    $0x117020,%eax
  100b75:	8b 00                	mov    (%eax),%eax
  100b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b7b:	89 04 24             	mov    %eax,(%esp)
  100b7e:	e8 2b 52 00 00       	call   105dae <strcmp>
  100b83:	85 c0                	test   %eax,%eax
  100b85:	75 32                	jne    100bb9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b8a:	89 d0                	mov    %edx,%eax
  100b8c:	01 c0                	add    %eax,%eax
  100b8e:	01 d0                	add    %edx,%eax
  100b90:	c1 e0 02             	shl    $0x2,%eax
  100b93:	05 20 70 11 00       	add    $0x117020,%eax
  100b98:	8b 40 08             	mov    0x8(%eax),%eax
  100b9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b9e:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ba4:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ba8:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bab:	83 c2 04             	add    $0x4,%edx
  100bae:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb2:	89 0c 24             	mov    %ecx,(%esp)
  100bb5:	ff d0                	call   *%eax
  100bb7:	eb 24                	jmp    100bdd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc0:	83 f8 02             	cmp    $0x2,%eax
  100bc3:	76 9c                	jbe    100b61 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcc:	c7 04 24 f3 63 10 00 	movl   $0x1063f3,(%esp)
  100bd3:	e8 64 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bdd:	c9                   	leave  
  100bde:	c3                   	ret    

00100bdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bdf:	55                   	push   %ebp
  100be0:	89 e5                	mov    %esp,%ebp
  100be2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be5:	c7 04 24 0c 64 10 00 	movl   $0x10640c,(%esp)
  100bec:	e8 4b f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf1:	c7 04 24 34 64 10 00 	movl   $0x106434,(%esp)
  100bf8:	e8 3f f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c01:	74 0b                	je     100c0e <kmonitor+0x2f>
        print_trapframe(tf);
  100c03:	8b 45 08             	mov    0x8(%ebp),%eax
  100c06:	89 04 24             	mov    %eax,(%esp)
  100c09:	e8 6e 10 00 00       	call   101c7c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c0e:	c7 04 24 59 64 10 00 	movl   $0x106459,(%esp)
  100c15:	e8 19 f6 ff ff       	call   100233 <readline>
  100c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c21:	74 18                	je     100c3b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c23:	8b 45 08             	mov    0x8(%ebp),%eax
  100c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2d:	89 04 24             	mov    %eax,(%esp)
  100c30:	e8 f8 fe ff ff       	call   100b2d <runcmd>
  100c35:	85 c0                	test   %eax,%eax
  100c37:	79 02                	jns    100c3b <kmonitor+0x5c>
                break;
  100c39:	eb 02                	jmp    100c3d <kmonitor+0x5e>
            }
        }
    }
  100c3b:	eb d1                	jmp    100c0e <kmonitor+0x2f>
}
  100c3d:	c9                   	leave  
  100c3e:	c3                   	ret    

00100c3f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3f:	55                   	push   %ebp
  100c40:	89 e5                	mov    %esp,%ebp
  100c42:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c4c:	eb 3f                	jmp    100c8d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c51:	89 d0                	mov    %edx,%eax
  100c53:	01 c0                	add    %eax,%eax
  100c55:	01 d0                	add    %edx,%eax
  100c57:	c1 e0 02             	shl    $0x2,%eax
  100c5a:	05 20 70 11 00       	add    $0x117020,%eax
  100c5f:	8b 48 04             	mov    0x4(%eax),%ecx
  100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c65:	89 d0                	mov    %edx,%eax
  100c67:	01 c0                	add    %eax,%eax
  100c69:	01 d0                	add    %edx,%eax
  100c6b:	c1 e0 02             	shl    $0x2,%eax
  100c6e:	05 20 70 11 00       	add    $0x117020,%eax
  100c73:	8b 00                	mov    (%eax),%eax
  100c75:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7d:	c7 04 24 5d 64 10 00 	movl   $0x10645d,(%esp)
  100c84:	e8 b3 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c90:	83 f8 02             	cmp    $0x2,%eax
  100c93:	76 b9                	jbe    100c4e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca2:	e8 c9 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cac:	c9                   	leave  
  100cad:	c3                   	ret    

00100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cae:	55                   	push   %ebp
  100caf:	89 e5                	mov    %esp,%ebp
  100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb4:	e8 01 fd ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbe:	c9                   	leave  
  100cbf:	c3                   	ret    

00100cc0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc6:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100ccb:	85 c0                	test   %eax,%eax
  100ccd:	74 02                	je     100cd1 <__panic+0x11>
        goto panic_dead;
  100ccf:	eb 48                	jmp    100d19 <__panic+0x59>
    }
    is_panic = 1;
  100cd1:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cd8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cdb:	8d 45 14             	lea    0x14(%ebp),%eax
  100cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cef:	c7 04 24 66 64 10 00 	movl   $0x106466,(%esp)
  100cf6:	e8 41 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d02:	8b 45 10             	mov    0x10(%ebp),%eax
  100d05:	89 04 24             	mov    %eax,(%esp)
  100d08:	e8 fc f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d0d:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  100d14:	e8 23 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d19:	e8 85 09 00 00       	call   1016a3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d25:	e8 b5 fe ff ff       	call   100bdf <kmonitor>
    }
  100d2a:	eb f2                	jmp    100d1e <__panic+0x5e>

00100d2c <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d2c:	55                   	push   %ebp
  100d2d:	89 e5                	mov    %esp,%ebp
  100d2f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d32:	8d 45 14             	lea    0x14(%ebp),%eax
  100d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d46:	c7 04 24 84 64 10 00 	movl   $0x106484,(%esp)
  100d4d:	e8 ea f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d59:	8b 45 10             	mov    0x10(%ebp),%eax
  100d5c:	89 04 24             	mov    %eax,(%esp)
  100d5f:	e8 a5 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d64:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  100d6b:	e8 cc f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d70:	c9                   	leave  
  100d71:	c3                   	ret    

00100d72 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d75:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d7a:	5d                   	pop    %ebp
  100d7b:	c3                   	ret    

00100d7c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d7c:	55                   	push   %ebp
  100d7d:	89 e5                	mov    %esp,%ebp
  100d7f:	83 ec 28             	sub    $0x28,%esp
  100d82:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d88:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d94:	ee                   	out    %al,(%dx)
  100d95:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d9b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da7:	ee                   	out    %al,(%dx)
  100da8:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dae:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dba:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dbb:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc5:	c7 04 24 a2 64 10 00 	movl   $0x1064a2,(%esp)
  100dcc:	e8 6b f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd8:	e8 24 09 00 00       	call   101701 <pic_enable>
}
  100ddd:	c9                   	leave  
  100dde:	c3                   	ret    

00100ddf <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100ddf:	55                   	push   %ebp
  100de0:	89 e5                	mov    %esp,%ebp
  100de2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100de5:	9c                   	pushf  
  100de6:	58                   	pop    %eax
  100de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100ded:	25 00 02 00 00       	and    $0x200,%eax
  100df2:	85 c0                	test   %eax,%eax
  100df4:	74 0c                	je     100e02 <__intr_save+0x23>
        intr_disable();
  100df6:	e8 a8 08 00 00       	call   1016a3 <intr_disable>
        return 1;
  100dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  100e00:	eb 05                	jmp    100e07 <__intr_save+0x28>
    }
    return 0;
  100e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e07:	c9                   	leave  
  100e08:	c3                   	ret    

00100e09 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e09:	55                   	push   %ebp
  100e0a:	89 e5                	mov    %esp,%ebp
  100e0c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e13:	74 05                	je     100e1a <__intr_restore+0x11>
        intr_enable();
  100e15:	e8 83 08 00 00       	call   10169d <intr_enable>
    }
}
  100e1a:	c9                   	leave  
  100e1b:	c3                   	ret    

00100e1c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e1c:	55                   	push   %ebp
  100e1d:	89 e5                	mov    %esp,%ebp
  100e1f:	83 ec 10             	sub    $0x10,%esp
  100e22:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e28:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e2c:	89 c2                	mov    %eax,%edx
  100e2e:	ec                   	in     (%dx),%al
  100e2f:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e32:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e38:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e3c:	89 c2                	mov    %eax,%edx
  100e3e:	ec                   	in     (%dx),%al
  100e3f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e42:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e48:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e4c:	89 c2                	mov    %eax,%edx
  100e4e:	ec                   	in     (%dx),%al
  100e4f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e52:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e58:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e5c:	89 c2                	mov    %eax,%edx
  100e5e:	ec                   	in     (%dx),%al
  100e5f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e62:	c9                   	leave  
  100e63:	c3                   	ret    

00100e64 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e6a:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e74:	0f b7 00             	movzwl (%eax),%eax
  100e77:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	0f b7 00             	movzwl (%eax),%eax
  100e89:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e8d:	74 12                	je     100ea1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e8f:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e96:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e9d:	b4 03 
  100e9f:	eb 13                	jmp    100eb4 <cga_init+0x50>
    } else {
        *cp = was;
  100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ea8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eab:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb4:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ec6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ece:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ecf:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ed6:	83 c0 01             	add    $0x1,%eax
  100ed9:	0f b7 c0             	movzwl %ax,%eax
  100edc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ee4:	89 c2                	mov    %eax,%edx
  100ee6:	ec                   	in     (%dx),%al
  100ee7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eea:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eee:	0f b6 c0             	movzbl %al,%eax
  100ef1:	c1 e0 08             	shl    $0x8,%eax
  100ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ef7:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100efe:	0f b7 c0             	movzwl %ax,%eax
  100f01:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f05:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f09:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f0d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f11:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f12:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f19:	83 c0 01             	add    $0x1,%eax
  100f1c:	0f b7 c0             	movzwl %ax,%eax
  100f1f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f23:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f27:	89 c2                	mov    %eax,%edx
  100f29:	ec                   	in     (%dx),%al
  100f2a:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f2d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f31:	0f b6 c0             	movzbl %al,%eax
  100f34:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3a:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f42:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f48:	c9                   	leave  
  100f49:	c3                   	ret    

00100f4a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f4a:	55                   	push   %ebp
  100f4b:	89 e5                	mov    %esp,%ebp
  100f4d:	83 ec 48             	sub    $0x48,%esp
  100f50:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f56:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f5e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
  100f63:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f69:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f6d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f71:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f75:	ee                   	out    %al,(%dx)
  100f76:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f7c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f88:	ee                   	out    %al,(%dx)
  100f89:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f8f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f93:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f97:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f9b:	ee                   	out    %al,(%dx)
  100f9c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa2:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fa6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100faa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fae:	ee                   	out    %al,(%dx)
  100faf:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fb5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fb9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fbd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc1:	ee                   	out    %al,(%dx)
  100fc2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fc8:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fcc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fd4:	ee                   	out    %al,(%dx)
  100fd5:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fdb:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fe5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fe9:	3c ff                	cmp    $0xff,%al
  100feb:	0f 95 c0             	setne  %al
  100fee:	0f b6 c0             	movzbl %al,%eax
  100ff1:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ff6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ffc:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101000:	89 c2                	mov    %eax,%edx
  101002:	ec                   	in     (%dx),%al
  101003:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101006:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10100c:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101010:	89 c2                	mov    %eax,%edx
  101012:	ec                   	in     (%dx),%al
  101013:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101016:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10101b:	85 c0                	test   %eax,%eax
  10101d:	74 0c                	je     10102b <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10101f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101026:	e8 d6 06 00 00       	call   101701 <pic_enable>
    }
}
  10102b:	c9                   	leave  
  10102c:	c3                   	ret    

0010102d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10102d:	55                   	push   %ebp
  10102e:	89 e5                	mov    %esp,%ebp
  101030:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10103a:	eb 09                	jmp    101045 <lpt_putc_sub+0x18>
        delay();
  10103c:	e8 db fd ff ff       	call   100e1c <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101041:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101045:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10104b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10104f:	89 c2                	mov    %eax,%edx
  101051:	ec                   	in     (%dx),%al
  101052:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101055:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101059:	84 c0                	test   %al,%al
  10105b:	78 09                	js     101066 <lpt_putc_sub+0x39>
  10105d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101064:	7e d6                	jle    10103c <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101066:	8b 45 08             	mov    0x8(%ebp),%eax
  101069:	0f b6 c0             	movzbl %al,%eax
  10106c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101072:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101075:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101079:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10107d:	ee                   	out    %al,(%dx)
  10107e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101084:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101088:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10108c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101090:	ee                   	out    %al,(%dx)
  101091:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101097:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10109b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10109f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a3:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a4:	c9                   	leave  
  1010a5:	c3                   	ret    

001010a6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010a6:	55                   	push   %ebp
  1010a7:	89 e5                	mov    %esp,%ebp
  1010a9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b0:	74 0d                	je     1010bf <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b5:	89 04 24             	mov    %eax,(%esp)
  1010b8:	e8 70 ff ff ff       	call   10102d <lpt_putc_sub>
  1010bd:	eb 24                	jmp    1010e3 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010bf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c6:	e8 62 ff ff ff       	call   10102d <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d2:	e8 56 ff ff ff       	call   10102d <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010de:	e8 4a ff ff ff       	call   10102d <lpt_putc_sub>
    }
}
  1010e3:	c9                   	leave  
  1010e4:	c3                   	ret    

001010e5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010e5:	55                   	push   %ebp
  1010e6:	89 e5                	mov    %esp,%ebp
  1010e8:	53                   	push   %ebx
  1010e9:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ef:	b0 00                	mov    $0x0,%al
  1010f1:	85 c0                	test   %eax,%eax
  1010f3:	75 07                	jne    1010fc <cga_putc+0x17>
        c |= 0x0700;
  1010f5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ff:	0f b6 c0             	movzbl %al,%eax
  101102:	83 f8 0a             	cmp    $0xa,%eax
  101105:	74 4c                	je     101153 <cga_putc+0x6e>
  101107:	83 f8 0d             	cmp    $0xd,%eax
  10110a:	74 57                	je     101163 <cga_putc+0x7e>
  10110c:	83 f8 08             	cmp    $0x8,%eax
  10110f:	0f 85 88 00 00 00    	jne    10119d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101115:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10111c:	66 85 c0             	test   %ax,%ax
  10111f:	74 30                	je     101151 <cga_putc+0x6c>
            crt_pos --;
  101121:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101128:	83 e8 01             	sub    $0x1,%eax
  10112b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101131:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101136:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10113d:	0f b7 d2             	movzwl %dx,%edx
  101140:	01 d2                	add    %edx,%edx
  101142:	01 c2                	add    %eax,%edx
  101144:	8b 45 08             	mov    0x8(%ebp),%eax
  101147:	b0 00                	mov    $0x0,%al
  101149:	83 c8 20             	or     $0x20,%eax
  10114c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10114f:	eb 72                	jmp    1011c3 <cga_putc+0xde>
  101151:	eb 70                	jmp    1011c3 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101153:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10115a:	83 c0 50             	add    $0x50,%eax
  10115d:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101163:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10116a:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101171:	0f b7 c1             	movzwl %cx,%eax
  101174:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10117a:	c1 e8 10             	shr    $0x10,%eax
  10117d:	89 c2                	mov    %eax,%edx
  10117f:	66 c1 ea 06          	shr    $0x6,%dx
  101183:	89 d0                	mov    %edx,%eax
  101185:	c1 e0 02             	shl    $0x2,%eax
  101188:	01 d0                	add    %edx,%eax
  10118a:	c1 e0 04             	shl    $0x4,%eax
  10118d:	29 c1                	sub    %eax,%ecx
  10118f:	89 ca                	mov    %ecx,%edx
  101191:	89 d8                	mov    %ebx,%eax
  101193:	29 d0                	sub    %edx,%eax
  101195:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10119b:	eb 26                	jmp    1011c3 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10119d:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a3:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011aa:	8d 50 01             	lea    0x1(%eax),%edx
  1011ad:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011b4:	0f b7 c0             	movzwl %ax,%eax
  1011b7:	01 c0                	add    %eax,%eax
  1011b9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1011bf:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c2:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c3:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ca:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011ce:	76 5b                	jbe    10122b <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d0:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011d5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011db:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e0:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011e7:	00 
  1011e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ec:	89 04 24             	mov    %eax,(%esp)
  1011ef:	e8 57 4e 00 00       	call   10604b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011fb:	eb 15                	jmp    101212 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011fd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101205:	01 d2                	add    %edx,%edx
  101207:	01 d0                	add    %edx,%eax
  101209:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101212:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101219:	7e e2                	jle    1011fd <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10121b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101222:	83 e8 50             	sub    $0x50,%eax
  101225:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10122b:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101232:	0f b7 c0             	movzwl %ax,%eax
  101235:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101239:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10123d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101241:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101245:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101246:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10124d:	66 c1 e8 08          	shr    $0x8,%ax
  101251:	0f b6 c0             	movzbl %al,%eax
  101254:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10125b:	83 c2 01             	add    $0x1,%edx
  10125e:	0f b7 d2             	movzwl %dx,%edx
  101261:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101265:	88 45 ed             	mov    %al,-0x13(%ebp)
  101268:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10126c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101270:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101271:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101278:	0f b7 c0             	movzwl %ax,%eax
  10127b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10127f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101283:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101287:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10128b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10128c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101293:	0f b6 c0             	movzbl %al,%eax
  101296:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10129d:	83 c2 01             	add    $0x1,%edx
  1012a0:	0f b7 d2             	movzwl %dx,%edx
  1012a3:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012a7:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012aa:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012ae:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b2:	ee                   	out    %al,(%dx)
}
  1012b3:	83 c4 34             	add    $0x34,%esp
  1012b6:	5b                   	pop    %ebx
  1012b7:	5d                   	pop    %ebp
  1012b8:	c3                   	ret    

001012b9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012b9:	55                   	push   %ebp
  1012ba:	89 e5                	mov    %esp,%ebp
  1012bc:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012c6:	eb 09                	jmp    1012d1 <serial_putc_sub+0x18>
        delay();
  1012c8:	e8 4f fb ff ff       	call   100e1c <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012d7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012db:	89 c2                	mov    %eax,%edx
  1012dd:	ec                   	in     (%dx),%al
  1012de:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012e5:	0f b6 c0             	movzbl %al,%eax
  1012e8:	83 e0 20             	and    $0x20,%eax
  1012eb:	85 c0                	test   %eax,%eax
  1012ed:	75 09                	jne    1012f8 <serial_putc_sub+0x3f>
  1012ef:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012f6:	7e d0                	jle    1012c8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012fb:	0f b6 c0             	movzbl %al,%eax
  1012fe:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101304:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101307:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10130b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10130f:	ee                   	out    %al,(%dx)
}
  101310:	c9                   	leave  
  101311:	c3                   	ret    

00101312 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101312:	55                   	push   %ebp
  101313:	89 e5                	mov    %esp,%ebp
  101315:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101318:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10131c:	74 0d                	je     10132b <serial_putc+0x19>
        serial_putc_sub(c);
  10131e:	8b 45 08             	mov    0x8(%ebp),%eax
  101321:	89 04 24             	mov    %eax,(%esp)
  101324:	e8 90 ff ff ff       	call   1012b9 <serial_putc_sub>
  101329:	eb 24                	jmp    10134f <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10132b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101332:	e8 82 ff ff ff       	call   1012b9 <serial_putc_sub>
        serial_putc_sub(' ');
  101337:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10133e:	e8 76 ff ff ff       	call   1012b9 <serial_putc_sub>
        serial_putc_sub('\b');
  101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134a:	e8 6a ff ff ff       	call   1012b9 <serial_putc_sub>
    }
}
  10134f:	c9                   	leave  
  101350:	c3                   	ret    

00101351 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101351:	55                   	push   %ebp
  101352:	89 e5                	mov    %esp,%ebp
  101354:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101357:	eb 33                	jmp    10138c <cons_intr+0x3b>
        if (c != 0) {
  101359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10135d:	74 2d                	je     10138c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10135f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101364:	8d 50 01             	lea    0x1(%eax),%edx
  101367:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101370:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101376:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10137b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101380:	75 0a                	jne    10138c <cons_intr+0x3b>
                cons.wpos = 0;
  101382:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101389:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10138c:	8b 45 08             	mov    0x8(%ebp),%eax
  10138f:	ff d0                	call   *%eax
  101391:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101394:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101398:	75 bf                	jne    101359 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10139a:	c9                   	leave  
  10139b:	c3                   	ret    

0010139c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10139c:	55                   	push   %ebp
  10139d:	89 e5                	mov    %esp,%ebp
  10139f:	83 ec 10             	sub    $0x10,%esp
  1013a2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013ac:	89 c2                	mov    %eax,%edx
  1013ae:	ec                   	in     (%dx),%al
  1013af:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013b6:	0f b6 c0             	movzbl %al,%eax
  1013b9:	83 e0 01             	and    $0x1,%eax
  1013bc:	85 c0                	test   %eax,%eax
  1013be:	75 07                	jne    1013c7 <serial_proc_data+0x2b>
        return -1;
  1013c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c5:	eb 2a                	jmp    1013f1 <serial_proc_data+0x55>
  1013c7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013cd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d1:	89 c2                	mov    %eax,%edx
  1013d3:	ec                   	in     (%dx),%al
  1013d4:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013d7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013db:	0f b6 c0             	movzbl %al,%eax
  1013de:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013e5:	75 07                	jne    1013ee <serial_proc_data+0x52>
        c = '\b';
  1013e7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f1:	c9                   	leave  
  1013f2:	c3                   	ret    

001013f3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f3:	55                   	push   %ebp
  1013f4:	89 e5                	mov    %esp,%ebp
  1013f6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013f9:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013fe:	85 c0                	test   %eax,%eax
  101400:	74 0c                	je     10140e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101402:	c7 04 24 9c 13 10 00 	movl   $0x10139c,(%esp)
  101409:	e8 43 ff ff ff       	call   101351 <cons_intr>
    }
}
  10140e:	c9                   	leave  
  10140f:	c3                   	ret    

00101410 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101410:	55                   	push   %ebp
  101411:	89 e5                	mov    %esp,%ebp
  101413:	83 ec 38             	sub    $0x38,%esp
  101416:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101420:	89 c2                	mov    %eax,%edx
  101422:	ec                   	in     (%dx),%al
  101423:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101426:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10142a:	0f b6 c0             	movzbl %al,%eax
  10142d:	83 e0 01             	and    $0x1,%eax
  101430:	85 c0                	test   %eax,%eax
  101432:	75 0a                	jne    10143e <kbd_proc_data+0x2e>
        return -1;
  101434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101439:	e9 59 01 00 00       	jmp    101597 <kbd_proc_data+0x187>
  10143e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101444:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101448:	89 c2                	mov    %eax,%edx
  10144a:	ec                   	in     (%dx),%al
  10144b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10144e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101452:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101455:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101459:	75 17                	jne    101472 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10145b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101460:	83 c8 40             	or     $0x40,%eax
  101463:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101468:	b8 00 00 00 00       	mov    $0x0,%eax
  10146d:	e9 25 01 00 00       	jmp    101597 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101476:	84 c0                	test   %al,%al
  101478:	79 47                	jns    1014c1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10147a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10147f:	83 e0 40             	and    $0x40,%eax
  101482:	85 c0                	test   %eax,%eax
  101484:	75 09                	jne    10148f <kbd_proc_data+0x7f>
  101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148a:	83 e0 7f             	and    $0x7f,%eax
  10148d:	eb 04                	jmp    101493 <kbd_proc_data+0x83>
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149a:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a1:	83 c8 40             	or     $0x40,%eax
  1014a4:	0f b6 c0             	movzbl %al,%eax
  1014a7:	f7 d0                	not    %eax
  1014a9:	89 c2                	mov    %eax,%edx
  1014ab:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b0:	21 d0                	and    %edx,%eax
  1014b2:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014bc:	e9 d6 00 00 00       	jmp    101597 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c6:	83 e0 40             	and    $0x40,%eax
  1014c9:	85 c0                	test   %eax,%eax
  1014cb:	74 11                	je     1014de <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014cd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d6:	83 e0 bf             	and    $0xffffffbf,%eax
  1014d9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e2:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014e9:	0f b6 d0             	movzbl %al,%edx
  1014ec:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f1:	09 d0                	or     %edx,%eax
  1014f3:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fc:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101503:	0f b6 d0             	movzbl %al,%edx
  101506:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10150b:	31 d0                	xor    %edx,%eax
  10150d:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101512:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101517:	83 e0 03             	and    $0x3,%eax
  10151a:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101525:	01 d0                	add    %edx,%eax
  101527:	0f b6 00             	movzbl (%eax),%eax
  10152a:	0f b6 c0             	movzbl %al,%eax
  10152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101530:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101535:	83 e0 08             	and    $0x8,%eax
  101538:	85 c0                	test   %eax,%eax
  10153a:	74 22                	je     10155e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10153c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101540:	7e 0c                	jle    10154e <kbd_proc_data+0x13e>
  101542:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101546:	7f 06                	jg     10154e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101548:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10154c:	eb 10                	jmp    10155e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10154e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101552:	7e 0a                	jle    10155e <kbd_proc_data+0x14e>
  101554:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101558:	7f 04                	jg     10155e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10155a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10155e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101563:	f7 d0                	not    %eax
  101565:	83 e0 06             	and    $0x6,%eax
  101568:	85 c0                	test   %eax,%eax
  10156a:	75 28                	jne    101594 <kbd_proc_data+0x184>
  10156c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101573:	75 1f                	jne    101594 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101575:	c7 04 24 bd 64 10 00 	movl   $0x1064bd,(%esp)
  10157c:	e8 bb ed ff ff       	call   10033c <cprintf>
  101581:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101587:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10158b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10158f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101593:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101594:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101597:	c9                   	leave  
  101598:	c3                   	ret    

00101599 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101599:	55                   	push   %ebp
  10159a:	89 e5                	mov    %esp,%ebp
  10159c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10159f:	c7 04 24 10 14 10 00 	movl   $0x101410,(%esp)
  1015a6:	e8 a6 fd ff ff       	call   101351 <cons_intr>
}
  1015ab:	c9                   	leave  
  1015ac:	c3                   	ret    

001015ad <kbd_init>:

static void
kbd_init(void) {
  1015ad:	55                   	push   %ebp
  1015ae:	89 e5                	mov    %esp,%ebp
  1015b0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b3:	e8 e1 ff ff ff       	call   101599 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015bf:	e8 3d 01 00 00       	call   101701 <pic_enable>
}
  1015c4:	c9                   	leave  
  1015c5:	c3                   	ret    

001015c6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015c6:	55                   	push   %ebp
  1015c7:	89 e5                	mov    %esp,%ebp
  1015c9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015cc:	e8 93 f8 ff ff       	call   100e64 <cga_init>
    serial_init();
  1015d1:	e8 74 f9 ff ff       	call   100f4a <serial_init>
    kbd_init();
  1015d6:	e8 d2 ff ff ff       	call   1015ad <kbd_init>
    if (!serial_exists) {
  1015db:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e0:	85 c0                	test   %eax,%eax
  1015e2:	75 0c                	jne    1015f0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015e4:	c7 04 24 c9 64 10 00 	movl   $0x1064c9,(%esp)
  1015eb:	e8 4c ed ff ff       	call   10033c <cprintf>
    }
}
  1015f0:	c9                   	leave  
  1015f1:	c3                   	ret    

001015f2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f2:	55                   	push   %ebp
  1015f3:	89 e5                	mov    %esp,%ebp
  1015f5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015f8:	e8 e2 f7 ff ff       	call   100ddf <__intr_save>
  1015fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101600:	8b 45 08             	mov    0x8(%ebp),%eax
  101603:	89 04 24             	mov    %eax,(%esp)
  101606:	e8 9b fa ff ff       	call   1010a6 <lpt_putc>
        cga_putc(c);
  10160b:	8b 45 08             	mov    0x8(%ebp),%eax
  10160e:	89 04 24             	mov    %eax,(%esp)
  101611:	e8 cf fa ff ff       	call   1010e5 <cga_putc>
        serial_putc(c);
  101616:	8b 45 08             	mov    0x8(%ebp),%eax
  101619:	89 04 24             	mov    %eax,(%esp)
  10161c:	e8 f1 fc ff ff       	call   101312 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 dd f7 ff ff       	call   100e09 <__intr_restore>
}
  10162c:	c9                   	leave  
  10162d:	c3                   	ret    

0010162e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10162e:	55                   	push   %ebp
  10162f:	89 e5                	mov    %esp,%ebp
  101631:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10163b:	e8 9f f7 ff ff       	call   100ddf <__intr_save>
  101640:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101643:	e8 ab fd ff ff       	call   1013f3 <serial_intr>
        kbd_intr();
  101648:	e8 4c ff ff ff       	call   101599 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10164d:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101653:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101658:	39 c2                	cmp    %eax,%edx
  10165a:	74 31                	je     10168d <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10165c:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101661:	8d 50 01             	lea    0x1(%eax),%edx
  101664:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10166a:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101671:	0f b6 c0             	movzbl %al,%eax
  101674:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101677:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10167c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101681:	75 0a                	jne    10168d <cons_getc+0x5f>
                cons.rpos = 0;
  101683:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10168a:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101690:	89 04 24             	mov    %eax,(%esp)
  101693:	e8 71 f7 ff ff       	call   100e09 <__intr_restore>
    return c;
  101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10169b:	c9                   	leave  
  10169c:	c3                   	ret    

0010169d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10169d:	55                   	push   %ebp
  10169e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a0:	fb                   	sti    
    sti();
}
  1016a1:	5d                   	pop    %ebp
  1016a2:	c3                   	ret    

001016a3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016a6:	fa                   	cli    
    cli();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
  1016ac:	83 ec 14             	sub    $0x14,%esp
  1016af:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ba:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c0:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016c5:	85 c0                	test   %eax,%eax
  1016c7:	74 36                	je     1016ff <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016c9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016cd:	0f b6 c0             	movzbl %al,%eax
  1016d0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d6:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016d9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016dd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e1:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e6:	66 c1 e8 08          	shr    $0x8,%ax
  1016ea:	0f b6 c0             	movzbl %al,%eax
  1016ed:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f3:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016fe:	ee                   	out    %al,(%dx)
    }
}
  1016ff:	c9                   	leave  
  101700:	c3                   	ret    

00101701 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101701:	55                   	push   %ebp
  101702:	89 e5                	mov    %esp,%ebp
  101704:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101707:	8b 45 08             	mov    0x8(%ebp),%eax
  10170a:	ba 01 00 00 00       	mov    $0x1,%edx
  10170f:	89 c1                	mov    %eax,%ecx
  101711:	d3 e2                	shl    %cl,%edx
  101713:	89 d0                	mov    %edx,%eax
  101715:	f7 d0                	not    %eax
  101717:	89 c2                	mov    %eax,%edx
  101719:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101720:	21 d0                	and    %edx,%eax
  101722:	0f b7 c0             	movzwl %ax,%eax
  101725:	89 04 24             	mov    %eax,(%esp)
  101728:	e8 7c ff ff ff       	call   1016a9 <pic_setmask>
}
  10172d:	c9                   	leave  
  10172e:	c3                   	ret    

0010172f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10172f:	55                   	push   %ebp
  101730:	89 e5                	mov    %esp,%ebp
  101732:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101735:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10173c:	00 00 00 
  10173f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101745:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101749:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10174d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101751:	ee                   	out    %al,(%dx)
  101752:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101758:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10175c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101760:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101764:	ee                   	out    %al,(%dx)
  101765:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10176b:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10176f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101773:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101777:	ee                   	out    %al,(%dx)
  101778:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10177e:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101782:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101786:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
  10178b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101791:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101795:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101799:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10179d:	ee                   	out    %al,(%dx)
  10179e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017a4:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
  1017b1:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017b7:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c3:	ee                   	out    %al,(%dx)
  1017c4:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017ca:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
  1017d7:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017dd:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017e9:	ee                   	out    %al,(%dx)
  1017ea:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f0:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017f4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017f8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017fc:	ee                   	out    %al,(%dx)
  1017fd:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101803:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101807:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10180b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10180f:	ee                   	out    %al,(%dx)
  101810:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101816:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10181a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10181e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101822:	ee                   	out    %al,(%dx)
  101823:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101829:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10182d:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101831:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101835:	ee                   	out    %al,(%dx)
  101836:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10183c:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101840:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101844:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101848:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101849:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101850:	66 83 f8 ff          	cmp    $0xffff,%ax
  101854:	74 12                	je     101868 <pic_init+0x139>
        pic_setmask(irq_mask);
  101856:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185d:	0f b7 c0             	movzwl %ax,%eax
  101860:	89 04 24             	mov    %eax,(%esp)
  101863:	e8 41 fe ff ff       	call   1016a9 <pic_setmask>
    }
}
  101868:	c9                   	leave  
  101869:	c3                   	ret    

0010186a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10186a:	55                   	push   %ebp
  10186b:	89 e5                	mov    %esp,%ebp
  10186d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101870:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101877:	00 
  101878:	c7 04 24 00 65 10 00 	movl   $0x106500,(%esp)
  10187f:	e8 b8 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101884:	c7 04 24 0a 65 10 00 	movl   $0x10650a,(%esp)
  10188b:	e8 ac ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101890:	c7 44 24 08 18 65 10 	movl   $0x106518,0x8(%esp)
  101897:	00 
  101898:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10189f:	00 
  1018a0:	c7 04 24 2e 65 10 00 	movl   $0x10652e,(%esp)
  1018a7:	e8 14 f4 ff ff       	call   100cc0 <__panic>

001018ac <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018ac:	55                   	push   %ebp
  1018ad:	89 e5                	mov    %esp,%ebp
  1018af:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
  1018b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018b9:	e9 5c 02 00 00       	jmp    101b1a <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
  1018be:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  1018c5:	0f 85 c1 00 00 00    	jne    10198c <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018d5:	89 c2                	mov    %eax,%edx
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e1:	00 
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018ec:	00 08 00 
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f9:	00 
  1018fa:	83 e2 e0             	and    $0xffffffe0,%edx
  1018fd:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 1f             	and    $0x1f,%edx
  101912:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 ca 0f             	or     $0xf,%edx
  101927:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101938:	00 
  101939:	83 e2 ef             	and    $0xffffffef,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10194d:	00 
  10194e:	83 ca 60             	or     $0x60,%edx
  101951:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101962:	00 
  101963:	83 ca 80             	or     $0xffffff80,%edx
  101966:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101970:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101977:	c1 e8 10             	shr    $0x10,%eax
  10197a:	89 c2                	mov    %eax,%edx
  10197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197f:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101986:	00 
  101987:	e9 8a 01 00 00       	jmp    101b16 <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
  10198c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101990:	0f 8f c1 00 00 00    	jg     101a57 <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1019a0:	89 c2                	mov    %eax,%edx
  1019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a5:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1019ac:	00 
  1019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b0:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1019b7:	00 08 00 
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019c4:	00 
  1019c5:	83 e2 e0             	and    $0xffffffe0,%edx
  1019c8:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d2:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019d9:	00 
  1019da:	83 e2 1f             	and    $0x1f,%edx
  1019dd:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e7:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019ee:	00 
  1019ef:	83 ca 0f             	or     $0xf,%edx
  1019f2:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fc:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a03:	00 
  101a04:	83 e2 ef             	and    $0xffffffef,%edx
  101a07:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a11:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a18:	00 
  101a19:	83 e2 9f             	and    $0xffffff9f,%edx
  101a1c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a26:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a2d:	00 
  101a2e:	83 ca 80             	or     $0xffffff80,%edx
  101a31:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3b:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101a42:	c1 e8 10             	shr    $0x10,%eax
  101a45:	89 c2                	mov    %eax,%edx
  101a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a4a:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101a51:	00 
  101a52:	e9 bf 00 00 00       	jmp    101b16 <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5a:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101a61:	89 c2                	mov    %eax,%edx
  101a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a66:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  101a6d:	00 
  101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a71:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  101a78:	00 08 00 
  101a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a7e:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101a85:	00 
  101a86:	83 e2 e0             	and    $0xffffffe0,%edx
  101a89:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a93:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101a9a:	00 
  101a9b:	83 e2 1f             	and    $0x1f,%edx
  101a9e:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aa8:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101aaf:	00 
  101ab0:	83 e2 f0             	and    $0xfffffff0,%edx
  101ab3:	83 ca 0e             	or     $0xe,%edx
  101ab6:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ac0:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101ac7:	00 
  101ac8:	83 e2 ef             	and    $0xffffffef,%edx
  101acb:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ad5:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101adc:	00 
  101add:	83 e2 9f             	and    $0xffffff9f,%edx
  101ae0:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aea:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101af1:	00 
  101af2:	83 ca 80             	or     $0xffffff80,%edx
  101af5:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aff:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101b06:	c1 e8 10             	shr    $0x10,%eax
  101b09:	89 c2                	mov    %eax,%edx
  101b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b0e:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101b15:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
  101b16:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b1d:	3d ff 00 00 00       	cmp    $0xff,%eax
  101b22:	0f 86 96 fd ff ff    	jbe    1018be <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], DPL_USER);
  101b28:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  101b2d:	66 a3 80 84 11 00    	mov    %ax,0x118480
  101b33:	66 c7 05 82 84 11 00 	movw   $0x8,0x118482
  101b3a:	08 00 
  101b3c:	0f b6 05 84 84 11 00 	movzbl 0x118484,%eax
  101b43:	83 e0 e0             	and    $0xffffffe0,%eax
  101b46:	a2 84 84 11 00       	mov    %al,0x118484
  101b4b:	0f b6 05 84 84 11 00 	movzbl 0x118484,%eax
  101b52:	83 e0 1f             	and    $0x1f,%eax
  101b55:	a2 84 84 11 00       	mov    %al,0x118484
  101b5a:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101b61:	83 e0 f0             	and    $0xfffffff0,%eax
  101b64:	83 c8 0e             	or     $0xe,%eax
  101b67:	a2 85 84 11 00       	mov    %al,0x118485
  101b6c:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101b73:	83 e0 ef             	and    $0xffffffef,%eax
  101b76:	a2 85 84 11 00       	mov    %al,0x118485
  101b7b:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101b82:	83 c8 60             	or     $0x60,%eax
  101b85:	a2 85 84 11 00       	mov    %al,0x118485
  101b8a:	0f b6 05 85 84 11 00 	movzbl 0x118485,%eax
  101b91:	83 c8 80             	or     $0xffffff80,%eax
  101b94:	a2 85 84 11 00       	mov    %al,0x118485
  101b99:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  101b9e:	c1 e8 10             	shr    $0x10,%eax
  101ba1:	66 a3 86 84 11 00    	mov    %ax,0x118486
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101ba7:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101bac:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101bb2:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101bb9:	08 00 
  101bbb:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101bc2:	83 e0 e0             	and    $0xffffffe0,%eax
  101bc5:	a2 8c 84 11 00       	mov    %al,0x11848c
  101bca:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101bd1:	83 e0 1f             	and    $0x1f,%eax
  101bd4:	a2 8c 84 11 00       	mov    %al,0x11848c
  101bd9:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101be0:	83 e0 f0             	and    $0xfffffff0,%eax
  101be3:	83 c8 0e             	or     $0xe,%eax
  101be6:	a2 8d 84 11 00       	mov    %al,0x11848d
  101beb:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101bf2:	83 e0 ef             	and    $0xffffffef,%eax
  101bf5:	a2 8d 84 11 00       	mov    %al,0x11848d
  101bfa:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101c01:	83 c8 60             	or     $0x60,%eax
  101c04:	a2 8d 84 11 00       	mov    %al,0x11848d
  101c09:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101c10:	83 c8 80             	or     $0xffffff80,%eax
  101c13:	a2 8d 84 11 00       	mov    %al,0x11848d
  101c18:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101c1d:	c1 e8 10             	shr    $0x10,%eax
  101c20:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101c26:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101c30:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101c33:	c9                   	leave  
  101c34:	c3                   	ret    

00101c35 <trapname>:

static const char *
trapname(int trapno) {
  101c35:	55                   	push   %ebp
  101c36:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101c38:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3b:	83 f8 13             	cmp    $0x13,%eax
  101c3e:	77 0c                	ja     101c4c <trapname+0x17>
        return excnames[trapno];
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 04 85 80 68 10 00 	mov    0x106880(,%eax,4),%eax
  101c4a:	eb 18                	jmp    101c64 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101c4c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101c50:	7e 0d                	jle    101c5f <trapname+0x2a>
  101c52:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101c56:	7f 07                	jg     101c5f <trapname+0x2a>
        return "Hardware Interrupt";
  101c58:	b8 3f 65 10 00       	mov    $0x10653f,%eax
  101c5d:	eb 05                	jmp    101c64 <trapname+0x2f>
    }
    return "(unknown trap)";
  101c5f:	b8 52 65 10 00       	mov    $0x106552,%eax
}
  101c64:	5d                   	pop    %ebp
  101c65:	c3                   	ret    

00101c66 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101c66:	55                   	push   %ebp
  101c67:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c70:	66 83 f8 08          	cmp    $0x8,%ax
  101c74:	0f 94 c0             	sete   %al
  101c77:	0f b6 c0             	movzbl %al,%eax
}
  101c7a:	5d                   	pop    %ebp
  101c7b:	c3                   	ret    

00101c7c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101c7c:	55                   	push   %ebp
  101c7d:	89 e5                	mov    %esp,%ebp
  101c7f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c89:	c7 04 24 93 65 10 00 	movl   $0x106593,(%esp)
  101c90:	e8 a7 e6 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101c95:	8b 45 08             	mov    0x8(%ebp),%eax
  101c98:	89 04 24             	mov    %eax,(%esp)
  101c9b:	e8 a1 01 00 00       	call   101e41 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ca7:	0f b7 c0             	movzwl %ax,%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 a4 65 10 00 	movl   $0x1065a4,(%esp)
  101cb5:	e8 82 e6 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101cc1:	0f b7 c0             	movzwl %ax,%eax
  101cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc8:	c7 04 24 b7 65 10 00 	movl   $0x1065b7,(%esp)
  101ccf:	e8 68 e6 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101cdb:	0f b7 c0             	movzwl %ax,%eax
  101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce2:	c7 04 24 ca 65 10 00 	movl   $0x1065ca,(%esp)
  101ce9:	e8 4e e6 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101cee:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101cf5:	0f b7 c0             	movzwl %ax,%eax
  101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfc:	c7 04 24 dd 65 10 00 	movl   $0x1065dd,(%esp)
  101d03:	e8 34 e6 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	8b 40 30             	mov    0x30(%eax),%eax
  101d0e:	89 04 24             	mov    %eax,(%esp)
  101d11:	e8 1f ff ff ff       	call   101c35 <trapname>
  101d16:	8b 55 08             	mov    0x8(%ebp),%edx
  101d19:	8b 52 30             	mov    0x30(%edx),%edx
  101d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  101d20:	89 54 24 04          	mov    %edx,0x4(%esp)
  101d24:	c7 04 24 f0 65 10 00 	movl   $0x1065f0,(%esp)
  101d2b:	e8 0c e6 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101d30:	8b 45 08             	mov    0x8(%ebp),%eax
  101d33:	8b 40 34             	mov    0x34(%eax),%eax
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 02 66 10 00 	movl   $0x106602,(%esp)
  101d41:	e8 f6 e5 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101d46:	8b 45 08             	mov    0x8(%ebp),%eax
  101d49:	8b 40 38             	mov    0x38(%eax),%eax
  101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d50:	c7 04 24 11 66 10 00 	movl   $0x106611,(%esp)
  101d57:	e8 e0 e5 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d63:	0f b7 c0             	movzwl %ax,%eax
  101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6a:	c7 04 24 20 66 10 00 	movl   $0x106620,(%esp)
  101d71:	e8 c6 e5 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101d76:	8b 45 08             	mov    0x8(%ebp),%eax
  101d79:	8b 40 40             	mov    0x40(%eax),%eax
  101d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d80:	c7 04 24 33 66 10 00 	movl   $0x106633,(%esp)
  101d87:	e8 b0 e5 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101d93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d9a:	eb 3e                	jmp    101dda <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9f:	8b 50 40             	mov    0x40(%eax),%edx
  101da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101da5:	21 d0                	and    %edx,%eax
  101da7:	85 c0                	test   %eax,%eax
  101da9:	74 28                	je     101dd3 <print_trapframe+0x157>
  101dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101dae:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101db5:	85 c0                	test   %eax,%eax
  101db7:	74 1a                	je     101dd3 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101dbc:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc7:	c7 04 24 42 66 10 00 	movl   $0x106642,(%esp)
  101dce:	e8 69 e5 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101dd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101dd7:	d1 65 f0             	shll   -0x10(%ebp)
  101dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ddd:	83 f8 17             	cmp    $0x17,%eax
  101de0:	76 ba                	jbe    101d9c <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101de2:	8b 45 08             	mov    0x8(%ebp),%eax
  101de5:	8b 40 40             	mov    0x40(%eax),%eax
  101de8:	25 00 30 00 00       	and    $0x3000,%eax
  101ded:	c1 e8 0c             	shr    $0xc,%eax
  101df0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df4:	c7 04 24 46 66 10 00 	movl   $0x106646,(%esp)
  101dfb:	e8 3c e5 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	89 04 24             	mov    %eax,(%esp)
  101e06:	e8 5b fe ff ff       	call   101c66 <trap_in_kernel>
  101e0b:	85 c0                	test   %eax,%eax
  101e0d:	75 30                	jne    101e3f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e12:	8b 40 44             	mov    0x44(%eax),%eax
  101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e19:	c7 04 24 4f 66 10 00 	movl   $0x10664f,(%esp)
  101e20:	e8 17 e5 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101e25:	8b 45 08             	mov    0x8(%ebp),%eax
  101e28:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101e2c:	0f b7 c0             	movzwl %ax,%eax
  101e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e33:	c7 04 24 5e 66 10 00 	movl   $0x10665e,(%esp)
  101e3a:	e8 fd e4 ff ff       	call   10033c <cprintf>
    }
}
  101e3f:	c9                   	leave  
  101e40:	c3                   	ret    

00101e41 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101e41:	55                   	push   %ebp
  101e42:	89 e5                	mov    %esp,%ebp
  101e44:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	8b 00                	mov    (%eax),%eax
  101e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e50:	c7 04 24 71 66 10 00 	movl   $0x106671,(%esp)
  101e57:	e8 e0 e4 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5f:	8b 40 04             	mov    0x4(%eax),%eax
  101e62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e66:	c7 04 24 80 66 10 00 	movl   $0x106680,(%esp)
  101e6d:	e8 ca e4 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	8b 40 08             	mov    0x8(%eax),%eax
  101e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e7c:	c7 04 24 8f 66 10 00 	movl   $0x10668f,(%esp)
  101e83:	e8 b4 e4 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101e88:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  101e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e92:	c7 04 24 9e 66 10 00 	movl   $0x10669e,(%esp)
  101e99:	e8 9e e4 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	8b 40 10             	mov    0x10(%eax),%eax
  101ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ea8:	c7 04 24 ad 66 10 00 	movl   $0x1066ad,(%esp)
  101eaf:	e8 88 e4 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb7:	8b 40 14             	mov    0x14(%eax),%eax
  101eba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ebe:	c7 04 24 bc 66 10 00 	movl   $0x1066bc,(%esp)
  101ec5:	e8 72 e4 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101eca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecd:	8b 40 18             	mov    0x18(%eax),%eax
  101ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed4:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  101edb:	e8 5c e4 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee3:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eea:	c7 04 24 da 66 10 00 	movl   $0x1066da,(%esp)
  101ef1:	e8 46 e4 ff ff       	call   10033c <cprintf>
}
  101ef6:	c9                   	leave  
  101ef7:	c3                   	ret    

00101ef8 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ef8:	55                   	push   %ebp
  101ef9:	89 e5                	mov    %esp,%ebp
  101efb:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101efe:	8b 45 08             	mov    0x8(%ebp),%eax
  101f01:	8b 40 30             	mov    0x30(%eax),%eax
  101f04:	83 f8 2f             	cmp    $0x2f,%eax
  101f07:	77 21                	ja     101f2a <trap_dispatch+0x32>
  101f09:	83 f8 2e             	cmp    $0x2e,%eax
  101f0c:	0f 83 04 01 00 00    	jae    102016 <trap_dispatch+0x11e>
  101f12:	83 f8 21             	cmp    $0x21,%eax
  101f15:	0f 84 81 00 00 00    	je     101f9c <trap_dispatch+0xa4>
  101f1b:	83 f8 24             	cmp    $0x24,%eax
  101f1e:	74 56                	je     101f76 <trap_dispatch+0x7e>
  101f20:	83 f8 20             	cmp    $0x20,%eax
  101f23:	74 16                	je     101f3b <trap_dispatch+0x43>
  101f25:	e9 b4 00 00 00       	jmp    101fde <trap_dispatch+0xe6>
  101f2a:	83 e8 78             	sub    $0x78,%eax
  101f2d:	83 f8 01             	cmp    $0x1,%eax
  101f30:	0f 87 a8 00 00 00    	ja     101fde <trap_dispatch+0xe6>
  101f36:	e9 87 00 00 00       	jmp    101fc2 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks++;
  101f3b:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101f40:	83 c0 01             	add    $0x1,%eax
  101f43:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if(ticks % TICK_NUM == 0)
  101f48:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101f4e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101f53:	89 c8                	mov    %ecx,%eax
  101f55:	f7 e2                	mul    %edx
  101f57:	89 d0                	mov    %edx,%eax
  101f59:	c1 e8 05             	shr    $0x5,%eax
  101f5c:	6b c0 64             	imul   $0x64,%eax,%eax
  101f5f:	29 c1                	sub    %eax,%ecx
  101f61:	89 c8                	mov    %ecx,%eax
  101f63:	85 c0                	test   %eax,%eax
  101f65:	75 0a                	jne    101f71 <trap_dispatch+0x79>
		{
			print_ticks();
  101f67:	e8 fe f8 ff ff       	call   10186a <print_ticks>
		}
		break;
  101f6c:	e9 a6 00 00 00       	jmp    102017 <trap_dispatch+0x11f>
  101f71:	e9 a1 00 00 00       	jmp    102017 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f76:	e8 b3 f6 ff ff       	call   10162e <cons_getc>
  101f7b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f7e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f82:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f86:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f8e:	c7 04 24 e9 66 10 00 	movl   $0x1066e9,(%esp)
  101f95:	e8 a2 e3 ff ff       	call   10033c <cprintf>
        break;
  101f9a:	eb 7b                	jmp    102017 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f9c:	e8 8d f6 ff ff       	call   10162e <cons_getc>
  101fa1:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101fa4:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101fa8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101fac:	89 54 24 08          	mov    %edx,0x8(%esp)
  101fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101fb4:	c7 04 24 fb 66 10 00 	movl   $0x1066fb,(%esp)
  101fbb:	e8 7c e3 ff ff       	call   10033c <cprintf>
        break;
  101fc0:	eb 55                	jmp    102017 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101fc2:	c7 44 24 08 0a 67 10 	movl   $0x10670a,0x8(%esp)
  101fc9:	00 
  101fca:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  101fd1:	00 
  101fd2:	c7 04 24 2e 65 10 00 	movl   $0x10652e,(%esp)
  101fd9:	e8 e2 ec ff ff       	call   100cc0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fde:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe5:	0f b7 c0             	movzwl %ax,%eax
  101fe8:	83 e0 03             	and    $0x3,%eax
  101feb:	85 c0                	test   %eax,%eax
  101fed:	75 28                	jne    102017 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101fef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff2:	89 04 24             	mov    %eax,(%esp)
  101ff5:	e8 82 fc ff ff       	call   101c7c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ffa:	c7 44 24 08 1a 67 10 	movl   $0x10671a,0x8(%esp)
  102001:	00 
  102002:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  102009:	00 
  10200a:	c7 04 24 2e 65 10 00 	movl   $0x10652e,(%esp)
  102011:	e8 aa ec ff ff       	call   100cc0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  102016:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  102017:	c9                   	leave  
  102018:	c3                   	ret    

00102019 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102019:	55                   	push   %ebp
  10201a:	89 e5                	mov    %esp,%ebp
  10201c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10201f:	8b 45 08             	mov    0x8(%ebp),%eax
  102022:	89 04 24             	mov    %eax,(%esp)
  102025:	e8 ce fe ff ff       	call   101ef8 <trap_dispatch>
}
  10202a:	c9                   	leave  
  10202b:	c3                   	ret    

0010202c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10202c:	1e                   	push   %ds
    pushl %es
  10202d:	06                   	push   %es
    pushl %fs
  10202e:	0f a0                	push   %fs
    pushl %gs
  102030:	0f a8                	push   %gs
    pushal
  102032:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102033:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102038:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10203a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10203c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10203d:	e8 d7 ff ff ff       	call   102019 <trap>

    # pop the pushed stack pointer
    popl %esp
  102042:	5c                   	pop    %esp

00102043 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102043:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102044:	0f a9                	pop    %gs
    popl %fs
  102046:	0f a1                	pop    %fs
    popl %es
  102048:	07                   	pop    %es
    popl %ds
  102049:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10204a:	83 c4 08             	add    $0x8,%esp
    iret
  10204d:	cf                   	iret   

0010204e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $0
  102050:	6a 00                	push   $0x0
  jmp __alltraps
  102052:	e9 d5 ff ff ff       	jmp    10202c <__alltraps>

00102057 <vector1>:
.globl vector1
vector1:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $1
  102059:	6a 01                	push   $0x1
  jmp __alltraps
  10205b:	e9 cc ff ff ff       	jmp    10202c <__alltraps>

00102060 <vector2>:
.globl vector2
vector2:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $2
  102062:	6a 02                	push   $0x2
  jmp __alltraps
  102064:	e9 c3 ff ff ff       	jmp    10202c <__alltraps>

00102069 <vector3>:
.globl vector3
vector3:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $3
  10206b:	6a 03                	push   $0x3
  jmp __alltraps
  10206d:	e9 ba ff ff ff       	jmp    10202c <__alltraps>

00102072 <vector4>:
.globl vector4
vector4:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $4
  102074:	6a 04                	push   $0x4
  jmp __alltraps
  102076:	e9 b1 ff ff ff       	jmp    10202c <__alltraps>

0010207b <vector5>:
.globl vector5
vector5:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $5
  10207d:	6a 05                	push   $0x5
  jmp __alltraps
  10207f:	e9 a8 ff ff ff       	jmp    10202c <__alltraps>

00102084 <vector6>:
.globl vector6
vector6:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $6
  102086:	6a 06                	push   $0x6
  jmp __alltraps
  102088:	e9 9f ff ff ff       	jmp    10202c <__alltraps>

0010208d <vector7>:
.globl vector7
vector7:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $7
  10208f:	6a 07                	push   $0x7
  jmp __alltraps
  102091:	e9 96 ff ff ff       	jmp    10202c <__alltraps>

00102096 <vector8>:
.globl vector8
vector8:
  pushl $8
  102096:	6a 08                	push   $0x8
  jmp __alltraps
  102098:	e9 8f ff ff ff       	jmp    10202c <__alltraps>

0010209d <vector9>:
.globl vector9
vector9:
  pushl $9
  10209d:	6a 09                	push   $0x9
  jmp __alltraps
  10209f:	e9 88 ff ff ff       	jmp    10202c <__alltraps>

001020a4 <vector10>:
.globl vector10
vector10:
  pushl $10
  1020a4:	6a 0a                	push   $0xa
  jmp __alltraps
  1020a6:	e9 81 ff ff ff       	jmp    10202c <__alltraps>

001020ab <vector11>:
.globl vector11
vector11:
  pushl $11
  1020ab:	6a 0b                	push   $0xb
  jmp __alltraps
  1020ad:	e9 7a ff ff ff       	jmp    10202c <__alltraps>

001020b2 <vector12>:
.globl vector12
vector12:
  pushl $12
  1020b2:	6a 0c                	push   $0xc
  jmp __alltraps
  1020b4:	e9 73 ff ff ff       	jmp    10202c <__alltraps>

001020b9 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020b9:	6a 0d                	push   $0xd
  jmp __alltraps
  1020bb:	e9 6c ff ff ff       	jmp    10202c <__alltraps>

001020c0 <vector14>:
.globl vector14
vector14:
  pushl $14
  1020c0:	6a 0e                	push   $0xe
  jmp __alltraps
  1020c2:	e9 65 ff ff ff       	jmp    10202c <__alltraps>

001020c7 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $15
  1020c9:	6a 0f                	push   $0xf
  jmp __alltraps
  1020cb:	e9 5c ff ff ff       	jmp    10202c <__alltraps>

001020d0 <vector16>:
.globl vector16
vector16:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $16
  1020d2:	6a 10                	push   $0x10
  jmp __alltraps
  1020d4:	e9 53 ff ff ff       	jmp    10202c <__alltraps>

001020d9 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020d9:	6a 11                	push   $0x11
  jmp __alltraps
  1020db:	e9 4c ff ff ff       	jmp    10202c <__alltraps>

001020e0 <vector18>:
.globl vector18
vector18:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $18
  1020e2:	6a 12                	push   $0x12
  jmp __alltraps
  1020e4:	e9 43 ff ff ff       	jmp    10202c <__alltraps>

001020e9 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $19
  1020eb:	6a 13                	push   $0x13
  jmp __alltraps
  1020ed:	e9 3a ff ff ff       	jmp    10202c <__alltraps>

001020f2 <vector20>:
.globl vector20
vector20:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $20
  1020f4:	6a 14                	push   $0x14
  jmp __alltraps
  1020f6:	e9 31 ff ff ff       	jmp    10202c <__alltraps>

001020fb <vector21>:
.globl vector21
vector21:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $21
  1020fd:	6a 15                	push   $0x15
  jmp __alltraps
  1020ff:	e9 28 ff ff ff       	jmp    10202c <__alltraps>

00102104 <vector22>:
.globl vector22
vector22:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $22
  102106:	6a 16                	push   $0x16
  jmp __alltraps
  102108:	e9 1f ff ff ff       	jmp    10202c <__alltraps>

0010210d <vector23>:
.globl vector23
vector23:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $23
  10210f:	6a 17                	push   $0x17
  jmp __alltraps
  102111:	e9 16 ff ff ff       	jmp    10202c <__alltraps>

00102116 <vector24>:
.globl vector24
vector24:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $24
  102118:	6a 18                	push   $0x18
  jmp __alltraps
  10211a:	e9 0d ff ff ff       	jmp    10202c <__alltraps>

0010211f <vector25>:
.globl vector25
vector25:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $25
  102121:	6a 19                	push   $0x19
  jmp __alltraps
  102123:	e9 04 ff ff ff       	jmp    10202c <__alltraps>

00102128 <vector26>:
.globl vector26
vector26:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $26
  10212a:	6a 1a                	push   $0x1a
  jmp __alltraps
  10212c:	e9 fb fe ff ff       	jmp    10202c <__alltraps>

00102131 <vector27>:
.globl vector27
vector27:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $27
  102133:	6a 1b                	push   $0x1b
  jmp __alltraps
  102135:	e9 f2 fe ff ff       	jmp    10202c <__alltraps>

0010213a <vector28>:
.globl vector28
vector28:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $28
  10213c:	6a 1c                	push   $0x1c
  jmp __alltraps
  10213e:	e9 e9 fe ff ff       	jmp    10202c <__alltraps>

00102143 <vector29>:
.globl vector29
vector29:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $29
  102145:	6a 1d                	push   $0x1d
  jmp __alltraps
  102147:	e9 e0 fe ff ff       	jmp    10202c <__alltraps>

0010214c <vector30>:
.globl vector30
vector30:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $30
  10214e:	6a 1e                	push   $0x1e
  jmp __alltraps
  102150:	e9 d7 fe ff ff       	jmp    10202c <__alltraps>

00102155 <vector31>:
.globl vector31
vector31:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $31
  102157:	6a 1f                	push   $0x1f
  jmp __alltraps
  102159:	e9 ce fe ff ff       	jmp    10202c <__alltraps>

0010215e <vector32>:
.globl vector32
vector32:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $32
  102160:	6a 20                	push   $0x20
  jmp __alltraps
  102162:	e9 c5 fe ff ff       	jmp    10202c <__alltraps>

00102167 <vector33>:
.globl vector33
vector33:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $33
  102169:	6a 21                	push   $0x21
  jmp __alltraps
  10216b:	e9 bc fe ff ff       	jmp    10202c <__alltraps>

00102170 <vector34>:
.globl vector34
vector34:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $34
  102172:	6a 22                	push   $0x22
  jmp __alltraps
  102174:	e9 b3 fe ff ff       	jmp    10202c <__alltraps>

00102179 <vector35>:
.globl vector35
vector35:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $35
  10217b:	6a 23                	push   $0x23
  jmp __alltraps
  10217d:	e9 aa fe ff ff       	jmp    10202c <__alltraps>

00102182 <vector36>:
.globl vector36
vector36:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $36
  102184:	6a 24                	push   $0x24
  jmp __alltraps
  102186:	e9 a1 fe ff ff       	jmp    10202c <__alltraps>

0010218b <vector37>:
.globl vector37
vector37:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $37
  10218d:	6a 25                	push   $0x25
  jmp __alltraps
  10218f:	e9 98 fe ff ff       	jmp    10202c <__alltraps>

00102194 <vector38>:
.globl vector38
vector38:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $38
  102196:	6a 26                	push   $0x26
  jmp __alltraps
  102198:	e9 8f fe ff ff       	jmp    10202c <__alltraps>

0010219d <vector39>:
.globl vector39
vector39:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $39
  10219f:	6a 27                	push   $0x27
  jmp __alltraps
  1021a1:	e9 86 fe ff ff       	jmp    10202c <__alltraps>

001021a6 <vector40>:
.globl vector40
vector40:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $40
  1021a8:	6a 28                	push   $0x28
  jmp __alltraps
  1021aa:	e9 7d fe ff ff       	jmp    10202c <__alltraps>

001021af <vector41>:
.globl vector41
vector41:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $41
  1021b1:	6a 29                	push   $0x29
  jmp __alltraps
  1021b3:	e9 74 fe ff ff       	jmp    10202c <__alltraps>

001021b8 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $42
  1021ba:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021bc:	e9 6b fe ff ff       	jmp    10202c <__alltraps>

001021c1 <vector43>:
.globl vector43
vector43:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $43
  1021c3:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021c5:	e9 62 fe ff ff       	jmp    10202c <__alltraps>

001021ca <vector44>:
.globl vector44
vector44:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $44
  1021cc:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021ce:	e9 59 fe ff ff       	jmp    10202c <__alltraps>

001021d3 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $45
  1021d5:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021d7:	e9 50 fe ff ff       	jmp    10202c <__alltraps>

001021dc <vector46>:
.globl vector46
vector46:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $46
  1021de:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021e0:	e9 47 fe ff ff       	jmp    10202c <__alltraps>

001021e5 <vector47>:
.globl vector47
vector47:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $47
  1021e7:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021e9:	e9 3e fe ff ff       	jmp    10202c <__alltraps>

001021ee <vector48>:
.globl vector48
vector48:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $48
  1021f0:	6a 30                	push   $0x30
  jmp __alltraps
  1021f2:	e9 35 fe ff ff       	jmp    10202c <__alltraps>

001021f7 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $49
  1021f9:	6a 31                	push   $0x31
  jmp __alltraps
  1021fb:	e9 2c fe ff ff       	jmp    10202c <__alltraps>

00102200 <vector50>:
.globl vector50
vector50:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $50
  102202:	6a 32                	push   $0x32
  jmp __alltraps
  102204:	e9 23 fe ff ff       	jmp    10202c <__alltraps>

00102209 <vector51>:
.globl vector51
vector51:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $51
  10220b:	6a 33                	push   $0x33
  jmp __alltraps
  10220d:	e9 1a fe ff ff       	jmp    10202c <__alltraps>

00102212 <vector52>:
.globl vector52
vector52:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $52
  102214:	6a 34                	push   $0x34
  jmp __alltraps
  102216:	e9 11 fe ff ff       	jmp    10202c <__alltraps>

0010221b <vector53>:
.globl vector53
vector53:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $53
  10221d:	6a 35                	push   $0x35
  jmp __alltraps
  10221f:	e9 08 fe ff ff       	jmp    10202c <__alltraps>

00102224 <vector54>:
.globl vector54
vector54:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $54
  102226:	6a 36                	push   $0x36
  jmp __alltraps
  102228:	e9 ff fd ff ff       	jmp    10202c <__alltraps>

0010222d <vector55>:
.globl vector55
vector55:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $55
  10222f:	6a 37                	push   $0x37
  jmp __alltraps
  102231:	e9 f6 fd ff ff       	jmp    10202c <__alltraps>

00102236 <vector56>:
.globl vector56
vector56:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $56
  102238:	6a 38                	push   $0x38
  jmp __alltraps
  10223a:	e9 ed fd ff ff       	jmp    10202c <__alltraps>

0010223f <vector57>:
.globl vector57
vector57:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $57
  102241:	6a 39                	push   $0x39
  jmp __alltraps
  102243:	e9 e4 fd ff ff       	jmp    10202c <__alltraps>

00102248 <vector58>:
.globl vector58
vector58:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $58
  10224a:	6a 3a                	push   $0x3a
  jmp __alltraps
  10224c:	e9 db fd ff ff       	jmp    10202c <__alltraps>

00102251 <vector59>:
.globl vector59
vector59:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $59
  102253:	6a 3b                	push   $0x3b
  jmp __alltraps
  102255:	e9 d2 fd ff ff       	jmp    10202c <__alltraps>

0010225a <vector60>:
.globl vector60
vector60:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $60
  10225c:	6a 3c                	push   $0x3c
  jmp __alltraps
  10225e:	e9 c9 fd ff ff       	jmp    10202c <__alltraps>

00102263 <vector61>:
.globl vector61
vector61:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $61
  102265:	6a 3d                	push   $0x3d
  jmp __alltraps
  102267:	e9 c0 fd ff ff       	jmp    10202c <__alltraps>

0010226c <vector62>:
.globl vector62
vector62:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $62
  10226e:	6a 3e                	push   $0x3e
  jmp __alltraps
  102270:	e9 b7 fd ff ff       	jmp    10202c <__alltraps>

00102275 <vector63>:
.globl vector63
vector63:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $63
  102277:	6a 3f                	push   $0x3f
  jmp __alltraps
  102279:	e9 ae fd ff ff       	jmp    10202c <__alltraps>

0010227e <vector64>:
.globl vector64
vector64:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $64
  102280:	6a 40                	push   $0x40
  jmp __alltraps
  102282:	e9 a5 fd ff ff       	jmp    10202c <__alltraps>

00102287 <vector65>:
.globl vector65
vector65:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $65
  102289:	6a 41                	push   $0x41
  jmp __alltraps
  10228b:	e9 9c fd ff ff       	jmp    10202c <__alltraps>

00102290 <vector66>:
.globl vector66
vector66:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $66
  102292:	6a 42                	push   $0x42
  jmp __alltraps
  102294:	e9 93 fd ff ff       	jmp    10202c <__alltraps>

00102299 <vector67>:
.globl vector67
vector67:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $67
  10229b:	6a 43                	push   $0x43
  jmp __alltraps
  10229d:	e9 8a fd ff ff       	jmp    10202c <__alltraps>

001022a2 <vector68>:
.globl vector68
vector68:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $68
  1022a4:	6a 44                	push   $0x44
  jmp __alltraps
  1022a6:	e9 81 fd ff ff       	jmp    10202c <__alltraps>

001022ab <vector69>:
.globl vector69
vector69:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $69
  1022ad:	6a 45                	push   $0x45
  jmp __alltraps
  1022af:	e9 78 fd ff ff       	jmp    10202c <__alltraps>

001022b4 <vector70>:
.globl vector70
vector70:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $70
  1022b6:	6a 46                	push   $0x46
  jmp __alltraps
  1022b8:	e9 6f fd ff ff       	jmp    10202c <__alltraps>

001022bd <vector71>:
.globl vector71
vector71:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $71
  1022bf:	6a 47                	push   $0x47
  jmp __alltraps
  1022c1:	e9 66 fd ff ff       	jmp    10202c <__alltraps>

001022c6 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $72
  1022c8:	6a 48                	push   $0x48
  jmp __alltraps
  1022ca:	e9 5d fd ff ff       	jmp    10202c <__alltraps>

001022cf <vector73>:
.globl vector73
vector73:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $73
  1022d1:	6a 49                	push   $0x49
  jmp __alltraps
  1022d3:	e9 54 fd ff ff       	jmp    10202c <__alltraps>

001022d8 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $74
  1022da:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022dc:	e9 4b fd ff ff       	jmp    10202c <__alltraps>

001022e1 <vector75>:
.globl vector75
vector75:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $75
  1022e3:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022e5:	e9 42 fd ff ff       	jmp    10202c <__alltraps>

001022ea <vector76>:
.globl vector76
vector76:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $76
  1022ec:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022ee:	e9 39 fd ff ff       	jmp    10202c <__alltraps>

001022f3 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $77
  1022f5:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022f7:	e9 30 fd ff ff       	jmp    10202c <__alltraps>

001022fc <vector78>:
.globl vector78
vector78:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $78
  1022fe:	6a 4e                	push   $0x4e
  jmp __alltraps
  102300:	e9 27 fd ff ff       	jmp    10202c <__alltraps>

00102305 <vector79>:
.globl vector79
vector79:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $79
  102307:	6a 4f                	push   $0x4f
  jmp __alltraps
  102309:	e9 1e fd ff ff       	jmp    10202c <__alltraps>

0010230e <vector80>:
.globl vector80
vector80:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $80
  102310:	6a 50                	push   $0x50
  jmp __alltraps
  102312:	e9 15 fd ff ff       	jmp    10202c <__alltraps>

00102317 <vector81>:
.globl vector81
vector81:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $81
  102319:	6a 51                	push   $0x51
  jmp __alltraps
  10231b:	e9 0c fd ff ff       	jmp    10202c <__alltraps>

00102320 <vector82>:
.globl vector82
vector82:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $82
  102322:	6a 52                	push   $0x52
  jmp __alltraps
  102324:	e9 03 fd ff ff       	jmp    10202c <__alltraps>

00102329 <vector83>:
.globl vector83
vector83:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $83
  10232b:	6a 53                	push   $0x53
  jmp __alltraps
  10232d:	e9 fa fc ff ff       	jmp    10202c <__alltraps>

00102332 <vector84>:
.globl vector84
vector84:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $84
  102334:	6a 54                	push   $0x54
  jmp __alltraps
  102336:	e9 f1 fc ff ff       	jmp    10202c <__alltraps>

0010233b <vector85>:
.globl vector85
vector85:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $85
  10233d:	6a 55                	push   $0x55
  jmp __alltraps
  10233f:	e9 e8 fc ff ff       	jmp    10202c <__alltraps>

00102344 <vector86>:
.globl vector86
vector86:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $86
  102346:	6a 56                	push   $0x56
  jmp __alltraps
  102348:	e9 df fc ff ff       	jmp    10202c <__alltraps>

0010234d <vector87>:
.globl vector87
vector87:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $87
  10234f:	6a 57                	push   $0x57
  jmp __alltraps
  102351:	e9 d6 fc ff ff       	jmp    10202c <__alltraps>

00102356 <vector88>:
.globl vector88
vector88:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $88
  102358:	6a 58                	push   $0x58
  jmp __alltraps
  10235a:	e9 cd fc ff ff       	jmp    10202c <__alltraps>

0010235f <vector89>:
.globl vector89
vector89:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $89
  102361:	6a 59                	push   $0x59
  jmp __alltraps
  102363:	e9 c4 fc ff ff       	jmp    10202c <__alltraps>

00102368 <vector90>:
.globl vector90
vector90:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $90
  10236a:	6a 5a                	push   $0x5a
  jmp __alltraps
  10236c:	e9 bb fc ff ff       	jmp    10202c <__alltraps>

00102371 <vector91>:
.globl vector91
vector91:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $91
  102373:	6a 5b                	push   $0x5b
  jmp __alltraps
  102375:	e9 b2 fc ff ff       	jmp    10202c <__alltraps>

0010237a <vector92>:
.globl vector92
vector92:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $92
  10237c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10237e:	e9 a9 fc ff ff       	jmp    10202c <__alltraps>

00102383 <vector93>:
.globl vector93
vector93:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $93
  102385:	6a 5d                	push   $0x5d
  jmp __alltraps
  102387:	e9 a0 fc ff ff       	jmp    10202c <__alltraps>

0010238c <vector94>:
.globl vector94
vector94:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $94
  10238e:	6a 5e                	push   $0x5e
  jmp __alltraps
  102390:	e9 97 fc ff ff       	jmp    10202c <__alltraps>

00102395 <vector95>:
.globl vector95
vector95:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $95
  102397:	6a 5f                	push   $0x5f
  jmp __alltraps
  102399:	e9 8e fc ff ff       	jmp    10202c <__alltraps>

0010239e <vector96>:
.globl vector96
vector96:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $96
  1023a0:	6a 60                	push   $0x60
  jmp __alltraps
  1023a2:	e9 85 fc ff ff       	jmp    10202c <__alltraps>

001023a7 <vector97>:
.globl vector97
vector97:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $97
  1023a9:	6a 61                	push   $0x61
  jmp __alltraps
  1023ab:	e9 7c fc ff ff       	jmp    10202c <__alltraps>

001023b0 <vector98>:
.globl vector98
vector98:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $98
  1023b2:	6a 62                	push   $0x62
  jmp __alltraps
  1023b4:	e9 73 fc ff ff       	jmp    10202c <__alltraps>

001023b9 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $99
  1023bb:	6a 63                	push   $0x63
  jmp __alltraps
  1023bd:	e9 6a fc ff ff       	jmp    10202c <__alltraps>

001023c2 <vector100>:
.globl vector100
vector100:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $100
  1023c4:	6a 64                	push   $0x64
  jmp __alltraps
  1023c6:	e9 61 fc ff ff       	jmp    10202c <__alltraps>

001023cb <vector101>:
.globl vector101
vector101:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $101
  1023cd:	6a 65                	push   $0x65
  jmp __alltraps
  1023cf:	e9 58 fc ff ff       	jmp    10202c <__alltraps>

001023d4 <vector102>:
.globl vector102
vector102:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $102
  1023d6:	6a 66                	push   $0x66
  jmp __alltraps
  1023d8:	e9 4f fc ff ff       	jmp    10202c <__alltraps>

001023dd <vector103>:
.globl vector103
vector103:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $103
  1023df:	6a 67                	push   $0x67
  jmp __alltraps
  1023e1:	e9 46 fc ff ff       	jmp    10202c <__alltraps>

001023e6 <vector104>:
.globl vector104
vector104:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $104
  1023e8:	6a 68                	push   $0x68
  jmp __alltraps
  1023ea:	e9 3d fc ff ff       	jmp    10202c <__alltraps>

001023ef <vector105>:
.globl vector105
vector105:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $105
  1023f1:	6a 69                	push   $0x69
  jmp __alltraps
  1023f3:	e9 34 fc ff ff       	jmp    10202c <__alltraps>

001023f8 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $106
  1023fa:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023fc:	e9 2b fc ff ff       	jmp    10202c <__alltraps>

00102401 <vector107>:
.globl vector107
vector107:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $107
  102403:	6a 6b                	push   $0x6b
  jmp __alltraps
  102405:	e9 22 fc ff ff       	jmp    10202c <__alltraps>

0010240a <vector108>:
.globl vector108
vector108:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $108
  10240c:	6a 6c                	push   $0x6c
  jmp __alltraps
  10240e:	e9 19 fc ff ff       	jmp    10202c <__alltraps>

00102413 <vector109>:
.globl vector109
vector109:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $109
  102415:	6a 6d                	push   $0x6d
  jmp __alltraps
  102417:	e9 10 fc ff ff       	jmp    10202c <__alltraps>

0010241c <vector110>:
.globl vector110
vector110:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $110
  10241e:	6a 6e                	push   $0x6e
  jmp __alltraps
  102420:	e9 07 fc ff ff       	jmp    10202c <__alltraps>

00102425 <vector111>:
.globl vector111
vector111:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $111
  102427:	6a 6f                	push   $0x6f
  jmp __alltraps
  102429:	e9 fe fb ff ff       	jmp    10202c <__alltraps>

0010242e <vector112>:
.globl vector112
vector112:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $112
  102430:	6a 70                	push   $0x70
  jmp __alltraps
  102432:	e9 f5 fb ff ff       	jmp    10202c <__alltraps>

00102437 <vector113>:
.globl vector113
vector113:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $113
  102439:	6a 71                	push   $0x71
  jmp __alltraps
  10243b:	e9 ec fb ff ff       	jmp    10202c <__alltraps>

00102440 <vector114>:
.globl vector114
vector114:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $114
  102442:	6a 72                	push   $0x72
  jmp __alltraps
  102444:	e9 e3 fb ff ff       	jmp    10202c <__alltraps>

00102449 <vector115>:
.globl vector115
vector115:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $115
  10244b:	6a 73                	push   $0x73
  jmp __alltraps
  10244d:	e9 da fb ff ff       	jmp    10202c <__alltraps>

00102452 <vector116>:
.globl vector116
vector116:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $116
  102454:	6a 74                	push   $0x74
  jmp __alltraps
  102456:	e9 d1 fb ff ff       	jmp    10202c <__alltraps>

0010245b <vector117>:
.globl vector117
vector117:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $117
  10245d:	6a 75                	push   $0x75
  jmp __alltraps
  10245f:	e9 c8 fb ff ff       	jmp    10202c <__alltraps>

00102464 <vector118>:
.globl vector118
vector118:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $118
  102466:	6a 76                	push   $0x76
  jmp __alltraps
  102468:	e9 bf fb ff ff       	jmp    10202c <__alltraps>

0010246d <vector119>:
.globl vector119
vector119:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $119
  10246f:	6a 77                	push   $0x77
  jmp __alltraps
  102471:	e9 b6 fb ff ff       	jmp    10202c <__alltraps>

00102476 <vector120>:
.globl vector120
vector120:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $120
  102478:	6a 78                	push   $0x78
  jmp __alltraps
  10247a:	e9 ad fb ff ff       	jmp    10202c <__alltraps>

0010247f <vector121>:
.globl vector121
vector121:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $121
  102481:	6a 79                	push   $0x79
  jmp __alltraps
  102483:	e9 a4 fb ff ff       	jmp    10202c <__alltraps>

00102488 <vector122>:
.globl vector122
vector122:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $122
  10248a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10248c:	e9 9b fb ff ff       	jmp    10202c <__alltraps>

00102491 <vector123>:
.globl vector123
vector123:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $123
  102493:	6a 7b                	push   $0x7b
  jmp __alltraps
  102495:	e9 92 fb ff ff       	jmp    10202c <__alltraps>

0010249a <vector124>:
.globl vector124
vector124:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $124
  10249c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10249e:	e9 89 fb ff ff       	jmp    10202c <__alltraps>

001024a3 <vector125>:
.globl vector125
vector125:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $125
  1024a5:	6a 7d                	push   $0x7d
  jmp __alltraps
  1024a7:	e9 80 fb ff ff       	jmp    10202c <__alltraps>

001024ac <vector126>:
.globl vector126
vector126:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $126
  1024ae:	6a 7e                	push   $0x7e
  jmp __alltraps
  1024b0:	e9 77 fb ff ff       	jmp    10202c <__alltraps>

001024b5 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $127
  1024b7:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024b9:	e9 6e fb ff ff       	jmp    10202c <__alltraps>

001024be <vector128>:
.globl vector128
vector128:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $128
  1024c0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024c5:	e9 62 fb ff ff       	jmp    10202c <__alltraps>

001024ca <vector129>:
.globl vector129
vector129:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $129
  1024cc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024d1:	e9 56 fb ff ff       	jmp    10202c <__alltraps>

001024d6 <vector130>:
.globl vector130
vector130:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $130
  1024d8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024dd:	e9 4a fb ff ff       	jmp    10202c <__alltraps>

001024e2 <vector131>:
.globl vector131
vector131:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $131
  1024e4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024e9:	e9 3e fb ff ff       	jmp    10202c <__alltraps>

001024ee <vector132>:
.globl vector132
vector132:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $132
  1024f0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024f5:	e9 32 fb ff ff       	jmp    10202c <__alltraps>

001024fa <vector133>:
.globl vector133
vector133:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $133
  1024fc:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102501:	e9 26 fb ff ff       	jmp    10202c <__alltraps>

00102506 <vector134>:
.globl vector134
vector134:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $134
  102508:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10250d:	e9 1a fb ff ff       	jmp    10202c <__alltraps>

00102512 <vector135>:
.globl vector135
vector135:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $135
  102514:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102519:	e9 0e fb ff ff       	jmp    10202c <__alltraps>

0010251e <vector136>:
.globl vector136
vector136:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $136
  102520:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102525:	e9 02 fb ff ff       	jmp    10202c <__alltraps>

0010252a <vector137>:
.globl vector137
vector137:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $137
  10252c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102531:	e9 f6 fa ff ff       	jmp    10202c <__alltraps>

00102536 <vector138>:
.globl vector138
vector138:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $138
  102538:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10253d:	e9 ea fa ff ff       	jmp    10202c <__alltraps>

00102542 <vector139>:
.globl vector139
vector139:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $139
  102544:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102549:	e9 de fa ff ff       	jmp    10202c <__alltraps>

0010254e <vector140>:
.globl vector140
vector140:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $140
  102550:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102555:	e9 d2 fa ff ff       	jmp    10202c <__alltraps>

0010255a <vector141>:
.globl vector141
vector141:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $141
  10255c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102561:	e9 c6 fa ff ff       	jmp    10202c <__alltraps>

00102566 <vector142>:
.globl vector142
vector142:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $142
  102568:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10256d:	e9 ba fa ff ff       	jmp    10202c <__alltraps>

00102572 <vector143>:
.globl vector143
vector143:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $143
  102574:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102579:	e9 ae fa ff ff       	jmp    10202c <__alltraps>

0010257e <vector144>:
.globl vector144
vector144:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $144
  102580:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102585:	e9 a2 fa ff ff       	jmp    10202c <__alltraps>

0010258a <vector145>:
.globl vector145
vector145:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $145
  10258c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102591:	e9 96 fa ff ff       	jmp    10202c <__alltraps>

00102596 <vector146>:
.globl vector146
vector146:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $146
  102598:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10259d:	e9 8a fa ff ff       	jmp    10202c <__alltraps>

001025a2 <vector147>:
.globl vector147
vector147:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $147
  1025a4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1025a9:	e9 7e fa ff ff       	jmp    10202c <__alltraps>

001025ae <vector148>:
.globl vector148
vector148:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $148
  1025b0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025b5:	e9 72 fa ff ff       	jmp    10202c <__alltraps>

001025ba <vector149>:
.globl vector149
vector149:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $149
  1025bc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025c1:	e9 66 fa ff ff       	jmp    10202c <__alltraps>

001025c6 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $150
  1025c8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025cd:	e9 5a fa ff ff       	jmp    10202c <__alltraps>

001025d2 <vector151>:
.globl vector151
vector151:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $151
  1025d4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025d9:	e9 4e fa ff ff       	jmp    10202c <__alltraps>

001025de <vector152>:
.globl vector152
vector152:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $152
  1025e0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025e5:	e9 42 fa ff ff       	jmp    10202c <__alltraps>

001025ea <vector153>:
.globl vector153
vector153:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $153
  1025ec:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025f1:	e9 36 fa ff ff       	jmp    10202c <__alltraps>

001025f6 <vector154>:
.globl vector154
vector154:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $154
  1025f8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025fd:	e9 2a fa ff ff       	jmp    10202c <__alltraps>

00102602 <vector155>:
.globl vector155
vector155:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $155
  102604:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102609:	e9 1e fa ff ff       	jmp    10202c <__alltraps>

0010260e <vector156>:
.globl vector156
vector156:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $156
  102610:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102615:	e9 12 fa ff ff       	jmp    10202c <__alltraps>

0010261a <vector157>:
.globl vector157
vector157:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $157
  10261c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102621:	e9 06 fa ff ff       	jmp    10202c <__alltraps>

00102626 <vector158>:
.globl vector158
vector158:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $158
  102628:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10262d:	e9 fa f9 ff ff       	jmp    10202c <__alltraps>

00102632 <vector159>:
.globl vector159
vector159:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $159
  102634:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102639:	e9 ee f9 ff ff       	jmp    10202c <__alltraps>

0010263e <vector160>:
.globl vector160
vector160:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $160
  102640:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102645:	e9 e2 f9 ff ff       	jmp    10202c <__alltraps>

0010264a <vector161>:
.globl vector161
vector161:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $161
  10264c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102651:	e9 d6 f9 ff ff       	jmp    10202c <__alltraps>

00102656 <vector162>:
.globl vector162
vector162:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $162
  102658:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10265d:	e9 ca f9 ff ff       	jmp    10202c <__alltraps>

00102662 <vector163>:
.globl vector163
vector163:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $163
  102664:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102669:	e9 be f9 ff ff       	jmp    10202c <__alltraps>

0010266e <vector164>:
.globl vector164
vector164:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $164
  102670:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102675:	e9 b2 f9 ff ff       	jmp    10202c <__alltraps>

0010267a <vector165>:
.globl vector165
vector165:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $165
  10267c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102681:	e9 a6 f9 ff ff       	jmp    10202c <__alltraps>

00102686 <vector166>:
.globl vector166
vector166:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $166
  102688:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10268d:	e9 9a f9 ff ff       	jmp    10202c <__alltraps>

00102692 <vector167>:
.globl vector167
vector167:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $167
  102694:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102699:	e9 8e f9 ff ff       	jmp    10202c <__alltraps>

0010269e <vector168>:
.globl vector168
vector168:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $168
  1026a0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1026a5:	e9 82 f9 ff ff       	jmp    10202c <__alltraps>

001026aa <vector169>:
.globl vector169
vector169:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $169
  1026ac:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1026b1:	e9 76 f9 ff ff       	jmp    10202c <__alltraps>

001026b6 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $170
  1026b8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026bd:	e9 6a f9 ff ff       	jmp    10202c <__alltraps>

001026c2 <vector171>:
.globl vector171
vector171:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $171
  1026c4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026c9:	e9 5e f9 ff ff       	jmp    10202c <__alltraps>

001026ce <vector172>:
.globl vector172
vector172:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $172
  1026d0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026d5:	e9 52 f9 ff ff       	jmp    10202c <__alltraps>

001026da <vector173>:
.globl vector173
vector173:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $173
  1026dc:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026e1:	e9 46 f9 ff ff       	jmp    10202c <__alltraps>

001026e6 <vector174>:
.globl vector174
vector174:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $174
  1026e8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026ed:	e9 3a f9 ff ff       	jmp    10202c <__alltraps>

001026f2 <vector175>:
.globl vector175
vector175:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $175
  1026f4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026f9:	e9 2e f9 ff ff       	jmp    10202c <__alltraps>

001026fe <vector176>:
.globl vector176
vector176:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $176
  102700:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102705:	e9 22 f9 ff ff       	jmp    10202c <__alltraps>

0010270a <vector177>:
.globl vector177
vector177:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $177
  10270c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102711:	e9 16 f9 ff ff       	jmp    10202c <__alltraps>

00102716 <vector178>:
.globl vector178
vector178:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $178
  102718:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10271d:	e9 0a f9 ff ff       	jmp    10202c <__alltraps>

00102722 <vector179>:
.globl vector179
vector179:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $179
  102724:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102729:	e9 fe f8 ff ff       	jmp    10202c <__alltraps>

0010272e <vector180>:
.globl vector180
vector180:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $180
  102730:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102735:	e9 f2 f8 ff ff       	jmp    10202c <__alltraps>

0010273a <vector181>:
.globl vector181
vector181:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $181
  10273c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102741:	e9 e6 f8 ff ff       	jmp    10202c <__alltraps>

00102746 <vector182>:
.globl vector182
vector182:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $182
  102748:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10274d:	e9 da f8 ff ff       	jmp    10202c <__alltraps>

00102752 <vector183>:
.globl vector183
vector183:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $183
  102754:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102759:	e9 ce f8 ff ff       	jmp    10202c <__alltraps>

0010275e <vector184>:
.globl vector184
vector184:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $184
  102760:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102765:	e9 c2 f8 ff ff       	jmp    10202c <__alltraps>

0010276a <vector185>:
.globl vector185
vector185:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $185
  10276c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102771:	e9 b6 f8 ff ff       	jmp    10202c <__alltraps>

00102776 <vector186>:
.globl vector186
vector186:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $186
  102778:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10277d:	e9 aa f8 ff ff       	jmp    10202c <__alltraps>

00102782 <vector187>:
.globl vector187
vector187:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $187
  102784:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102789:	e9 9e f8 ff ff       	jmp    10202c <__alltraps>

0010278e <vector188>:
.globl vector188
vector188:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $188
  102790:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102795:	e9 92 f8 ff ff       	jmp    10202c <__alltraps>

0010279a <vector189>:
.globl vector189
vector189:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $189
  10279c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1027a1:	e9 86 f8 ff ff       	jmp    10202c <__alltraps>

001027a6 <vector190>:
.globl vector190
vector190:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $190
  1027a8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1027ad:	e9 7a f8 ff ff       	jmp    10202c <__alltraps>

001027b2 <vector191>:
.globl vector191
vector191:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $191
  1027b4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027b9:	e9 6e f8 ff ff       	jmp    10202c <__alltraps>

001027be <vector192>:
.globl vector192
vector192:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $192
  1027c0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027c5:	e9 62 f8 ff ff       	jmp    10202c <__alltraps>

001027ca <vector193>:
.globl vector193
vector193:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $193
  1027cc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027d1:	e9 56 f8 ff ff       	jmp    10202c <__alltraps>

001027d6 <vector194>:
.globl vector194
vector194:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $194
  1027d8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027dd:	e9 4a f8 ff ff       	jmp    10202c <__alltraps>

001027e2 <vector195>:
.globl vector195
vector195:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $195
  1027e4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027e9:	e9 3e f8 ff ff       	jmp    10202c <__alltraps>

001027ee <vector196>:
.globl vector196
vector196:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $196
  1027f0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027f5:	e9 32 f8 ff ff       	jmp    10202c <__alltraps>

001027fa <vector197>:
.globl vector197
vector197:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $197
  1027fc:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102801:	e9 26 f8 ff ff       	jmp    10202c <__alltraps>

00102806 <vector198>:
.globl vector198
vector198:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $198
  102808:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10280d:	e9 1a f8 ff ff       	jmp    10202c <__alltraps>

00102812 <vector199>:
.globl vector199
vector199:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $199
  102814:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102819:	e9 0e f8 ff ff       	jmp    10202c <__alltraps>

0010281e <vector200>:
.globl vector200
vector200:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $200
  102820:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102825:	e9 02 f8 ff ff       	jmp    10202c <__alltraps>

0010282a <vector201>:
.globl vector201
vector201:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $201
  10282c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102831:	e9 f6 f7 ff ff       	jmp    10202c <__alltraps>

00102836 <vector202>:
.globl vector202
vector202:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $202
  102838:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10283d:	e9 ea f7 ff ff       	jmp    10202c <__alltraps>

00102842 <vector203>:
.globl vector203
vector203:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $203
  102844:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102849:	e9 de f7 ff ff       	jmp    10202c <__alltraps>

0010284e <vector204>:
.globl vector204
vector204:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $204
  102850:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102855:	e9 d2 f7 ff ff       	jmp    10202c <__alltraps>

0010285a <vector205>:
.globl vector205
vector205:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $205
  10285c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102861:	e9 c6 f7 ff ff       	jmp    10202c <__alltraps>

00102866 <vector206>:
.globl vector206
vector206:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $206
  102868:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10286d:	e9 ba f7 ff ff       	jmp    10202c <__alltraps>

00102872 <vector207>:
.globl vector207
vector207:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $207
  102874:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102879:	e9 ae f7 ff ff       	jmp    10202c <__alltraps>

0010287e <vector208>:
.globl vector208
vector208:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $208
  102880:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102885:	e9 a2 f7 ff ff       	jmp    10202c <__alltraps>

0010288a <vector209>:
.globl vector209
vector209:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $209
  10288c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102891:	e9 96 f7 ff ff       	jmp    10202c <__alltraps>

00102896 <vector210>:
.globl vector210
vector210:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $210
  102898:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10289d:	e9 8a f7 ff ff       	jmp    10202c <__alltraps>

001028a2 <vector211>:
.globl vector211
vector211:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $211
  1028a4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1028a9:	e9 7e f7 ff ff       	jmp    10202c <__alltraps>

001028ae <vector212>:
.globl vector212
vector212:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $212
  1028b0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028b5:	e9 72 f7 ff ff       	jmp    10202c <__alltraps>

001028ba <vector213>:
.globl vector213
vector213:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $213
  1028bc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028c1:	e9 66 f7 ff ff       	jmp    10202c <__alltraps>

001028c6 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $214
  1028c8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028cd:	e9 5a f7 ff ff       	jmp    10202c <__alltraps>

001028d2 <vector215>:
.globl vector215
vector215:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $215
  1028d4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028d9:	e9 4e f7 ff ff       	jmp    10202c <__alltraps>

001028de <vector216>:
.globl vector216
vector216:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $216
  1028e0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028e5:	e9 42 f7 ff ff       	jmp    10202c <__alltraps>

001028ea <vector217>:
.globl vector217
vector217:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $217
  1028ec:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028f1:	e9 36 f7 ff ff       	jmp    10202c <__alltraps>

001028f6 <vector218>:
.globl vector218
vector218:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $218
  1028f8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028fd:	e9 2a f7 ff ff       	jmp    10202c <__alltraps>

00102902 <vector219>:
.globl vector219
vector219:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $219
  102904:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102909:	e9 1e f7 ff ff       	jmp    10202c <__alltraps>

0010290e <vector220>:
.globl vector220
vector220:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $220
  102910:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102915:	e9 12 f7 ff ff       	jmp    10202c <__alltraps>

0010291a <vector221>:
.globl vector221
vector221:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $221
  10291c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102921:	e9 06 f7 ff ff       	jmp    10202c <__alltraps>

00102926 <vector222>:
.globl vector222
vector222:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $222
  102928:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10292d:	e9 fa f6 ff ff       	jmp    10202c <__alltraps>

00102932 <vector223>:
.globl vector223
vector223:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $223
  102934:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102939:	e9 ee f6 ff ff       	jmp    10202c <__alltraps>

0010293e <vector224>:
.globl vector224
vector224:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $224
  102940:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102945:	e9 e2 f6 ff ff       	jmp    10202c <__alltraps>

0010294a <vector225>:
.globl vector225
vector225:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $225
  10294c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102951:	e9 d6 f6 ff ff       	jmp    10202c <__alltraps>

00102956 <vector226>:
.globl vector226
vector226:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $226
  102958:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10295d:	e9 ca f6 ff ff       	jmp    10202c <__alltraps>

00102962 <vector227>:
.globl vector227
vector227:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $227
  102964:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102969:	e9 be f6 ff ff       	jmp    10202c <__alltraps>

0010296e <vector228>:
.globl vector228
vector228:
  pushl $0
  10296e:	6a 00                	push   $0x0
  pushl $228
  102970:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102975:	e9 b2 f6 ff ff       	jmp    10202c <__alltraps>

0010297a <vector229>:
.globl vector229
vector229:
  pushl $0
  10297a:	6a 00                	push   $0x0
  pushl $229
  10297c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102981:	e9 a6 f6 ff ff       	jmp    10202c <__alltraps>

00102986 <vector230>:
.globl vector230
vector230:
  pushl $0
  102986:	6a 00                	push   $0x0
  pushl $230
  102988:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10298d:	e9 9a f6 ff ff       	jmp    10202c <__alltraps>

00102992 <vector231>:
.globl vector231
vector231:
  pushl $0
  102992:	6a 00                	push   $0x0
  pushl $231
  102994:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102999:	e9 8e f6 ff ff       	jmp    10202c <__alltraps>

0010299e <vector232>:
.globl vector232
vector232:
  pushl $0
  10299e:	6a 00                	push   $0x0
  pushl $232
  1029a0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1029a5:	e9 82 f6 ff ff       	jmp    10202c <__alltraps>

001029aa <vector233>:
.globl vector233
vector233:
  pushl $0
  1029aa:	6a 00                	push   $0x0
  pushl $233
  1029ac:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1029b1:	e9 76 f6 ff ff       	jmp    10202c <__alltraps>

001029b6 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029b6:	6a 00                	push   $0x0
  pushl $234
  1029b8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029bd:	e9 6a f6 ff ff       	jmp    10202c <__alltraps>

001029c2 <vector235>:
.globl vector235
vector235:
  pushl $0
  1029c2:	6a 00                	push   $0x0
  pushl $235
  1029c4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029c9:	e9 5e f6 ff ff       	jmp    10202c <__alltraps>

001029ce <vector236>:
.globl vector236
vector236:
  pushl $0
  1029ce:	6a 00                	push   $0x0
  pushl $236
  1029d0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029d5:	e9 52 f6 ff ff       	jmp    10202c <__alltraps>

001029da <vector237>:
.globl vector237
vector237:
  pushl $0
  1029da:	6a 00                	push   $0x0
  pushl $237
  1029dc:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029e1:	e9 46 f6 ff ff       	jmp    10202c <__alltraps>

001029e6 <vector238>:
.globl vector238
vector238:
  pushl $0
  1029e6:	6a 00                	push   $0x0
  pushl $238
  1029e8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029ed:	e9 3a f6 ff ff       	jmp    10202c <__alltraps>

001029f2 <vector239>:
.globl vector239
vector239:
  pushl $0
  1029f2:	6a 00                	push   $0x0
  pushl $239
  1029f4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029f9:	e9 2e f6 ff ff       	jmp    10202c <__alltraps>

001029fe <vector240>:
.globl vector240
vector240:
  pushl $0
  1029fe:	6a 00                	push   $0x0
  pushl $240
  102a00:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a05:	e9 22 f6 ff ff       	jmp    10202c <__alltraps>

00102a0a <vector241>:
.globl vector241
vector241:
  pushl $0
  102a0a:	6a 00                	push   $0x0
  pushl $241
  102a0c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a11:	e9 16 f6 ff ff       	jmp    10202c <__alltraps>

00102a16 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a16:	6a 00                	push   $0x0
  pushl $242
  102a18:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a1d:	e9 0a f6 ff ff       	jmp    10202c <__alltraps>

00102a22 <vector243>:
.globl vector243
vector243:
  pushl $0
  102a22:	6a 00                	push   $0x0
  pushl $243
  102a24:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a29:	e9 fe f5 ff ff       	jmp    10202c <__alltraps>

00102a2e <vector244>:
.globl vector244
vector244:
  pushl $0
  102a2e:	6a 00                	push   $0x0
  pushl $244
  102a30:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a35:	e9 f2 f5 ff ff       	jmp    10202c <__alltraps>

00102a3a <vector245>:
.globl vector245
vector245:
  pushl $0
  102a3a:	6a 00                	push   $0x0
  pushl $245
  102a3c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a41:	e9 e6 f5 ff ff       	jmp    10202c <__alltraps>

00102a46 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a46:	6a 00                	push   $0x0
  pushl $246
  102a48:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a4d:	e9 da f5 ff ff       	jmp    10202c <__alltraps>

00102a52 <vector247>:
.globl vector247
vector247:
  pushl $0
  102a52:	6a 00                	push   $0x0
  pushl $247
  102a54:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a59:	e9 ce f5 ff ff       	jmp    10202c <__alltraps>

00102a5e <vector248>:
.globl vector248
vector248:
  pushl $0
  102a5e:	6a 00                	push   $0x0
  pushl $248
  102a60:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a65:	e9 c2 f5 ff ff       	jmp    10202c <__alltraps>

00102a6a <vector249>:
.globl vector249
vector249:
  pushl $0
  102a6a:	6a 00                	push   $0x0
  pushl $249
  102a6c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a71:	e9 b6 f5 ff ff       	jmp    10202c <__alltraps>

00102a76 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a76:	6a 00                	push   $0x0
  pushl $250
  102a78:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a7d:	e9 aa f5 ff ff       	jmp    10202c <__alltraps>

00102a82 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a82:	6a 00                	push   $0x0
  pushl $251
  102a84:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a89:	e9 9e f5 ff ff       	jmp    10202c <__alltraps>

00102a8e <vector252>:
.globl vector252
vector252:
  pushl $0
  102a8e:	6a 00                	push   $0x0
  pushl $252
  102a90:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a95:	e9 92 f5 ff ff       	jmp    10202c <__alltraps>

00102a9a <vector253>:
.globl vector253
vector253:
  pushl $0
  102a9a:	6a 00                	push   $0x0
  pushl $253
  102a9c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102aa1:	e9 86 f5 ff ff       	jmp    10202c <__alltraps>

00102aa6 <vector254>:
.globl vector254
vector254:
  pushl $0
  102aa6:	6a 00                	push   $0x0
  pushl $254
  102aa8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102aad:	e9 7a f5 ff ff       	jmp    10202c <__alltraps>

00102ab2 <vector255>:
.globl vector255
vector255:
  pushl $0
  102ab2:	6a 00                	push   $0x0
  pushl $255
  102ab4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102ab9:	e9 6e f5 ff ff       	jmp    10202c <__alltraps>

00102abe <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102abe:	55                   	push   %ebp
  102abf:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac4:	a1 64 89 11 00       	mov    0x118964,%eax
  102ac9:	29 c2                	sub    %eax,%edx
  102acb:	89 d0                	mov    %edx,%eax
  102acd:	c1 f8 02             	sar    $0x2,%eax
  102ad0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102ad6:	5d                   	pop    %ebp
  102ad7:	c3                   	ret    

00102ad8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102ad8:	55                   	push   %ebp
  102ad9:	89 e5                	mov    %esp,%ebp
  102adb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102ade:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae1:	89 04 24             	mov    %eax,(%esp)
  102ae4:	e8 d5 ff ff ff       	call   102abe <page2ppn>
  102ae9:	c1 e0 0c             	shl    $0xc,%eax
}
  102aec:	c9                   	leave  
  102aed:	c3                   	ret    

00102aee <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102aee:	55                   	push   %ebp
  102aef:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102af1:	8b 45 08             	mov    0x8(%ebp),%eax
  102af4:	8b 00                	mov    (%eax),%eax
}
  102af6:	5d                   	pop    %ebp
  102af7:	c3                   	ret    

00102af8 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102af8:	55                   	push   %ebp
  102af9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102afb:	8b 45 08             	mov    0x8(%ebp),%eax
  102afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b01:	89 10                	mov    %edx,(%eax)
}
  102b03:	5d                   	pop    %ebp
  102b04:	c3                   	ret    

00102b05 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102b05:	55                   	push   %ebp
  102b06:	89 e5                	mov    %esp,%ebp
  102b08:	83 ec 10             	sub    $0x10,%esp
  102b0b:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102b18:	89 50 04             	mov    %edx,0x4(%eax)
  102b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b1e:	8b 50 04             	mov    0x4(%eax),%edx
  102b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b24:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102b26:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102b2d:	00 00 00 
}
  102b30:	c9                   	leave  
  102b31:	c3                   	ret    

00102b32 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102b32:	55                   	push   %ebp
  102b33:	89 e5                	mov    %esp,%ebp
  102b35:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102b38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b3c:	75 24                	jne    102b62 <default_init_memmap+0x30>
  102b3e:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  102b45:	00 
  102b46:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102b4d:	00 
  102b4e:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102b55:	00 
  102b56:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102b5d:	e8 5e e1 ff ff       	call   100cc0 <__panic>
    struct Page *p = base;
  102b62:	8b 45 08             	mov    0x8(%ebp),%eax
  102b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102b68:	e9 ef 00 00 00       	jmp    102c5c <default_init_memmap+0x12a>
        assert(PageReserved(p));
  102b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b70:	83 c0 04             	add    $0x4,%eax
  102b73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b83:	0f a3 10             	bt     %edx,(%eax)
  102b86:	19 c0                	sbb    %eax,%eax
  102b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b8f:	0f 95 c0             	setne  %al
  102b92:	0f b6 c0             	movzbl %al,%eax
  102b95:	85 c0                	test   %eax,%eax
  102b97:	75 24                	jne    102bbd <default_init_memmap+0x8b>
  102b99:	c7 44 24 0c 01 69 10 	movl   $0x106901,0xc(%esp)
  102ba0:	00 
  102ba1:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102ba8:	00 
  102ba9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102bb0:	00 
  102bb1:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102bb8:	e8 03 e1 ff ff       	call   100cc0 <__panic>
        p->flags = 0;
  102bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  102bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bca:	83 c0 04             	add    $0x4,%eax
  102bcd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102bd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bdd:	0f ab 10             	bts    %edx,(%eax)
        if(p == base)
  102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be3:	3b 45 08             	cmp    0x8(%ebp),%eax
  102be6:	75 0b                	jne    102bf3 <default_init_memmap+0xc1>
        {
        	p->property = n;
  102be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bee:	89 50 08             	mov    %edx,0x8(%eax)
  102bf1:	eb 0a                	jmp    102bfd <default_init_memmap+0xcb>
        }
        else
        {
        	p->property = 0;
  102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
        set_page_ref(p, 0);
  102bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c04:	00 
  102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c08:	89 04 24             	mov    %eax,(%esp)
  102c0b:	e8 e8 fe ff ff       	call   102af8 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  102c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c13:	83 c0 0c             	add    $0xc,%eax
  102c16:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102c1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c23:	8b 00                	mov    (%eax),%eax
  102c25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c31:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c3a:	89 10                	mov    %edx,(%eax)
  102c3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c3f:	8b 10                	mov    (%eax),%edx
  102c41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c44:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c4a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c4d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c53:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c56:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102c58:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c5f:	89 d0                	mov    %edx,%eax
  102c61:	c1 e0 02             	shl    $0x2,%eax
  102c64:	01 d0                	add    %edx,%eax
  102c66:	c1 e0 02             	shl    $0x2,%eax
  102c69:	89 c2                	mov    %eax,%edx
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	01 d0                	add    %edx,%eax
  102c70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c73:	0f 85 f4 fe ff ff    	jne    102b6d <default_init_memmap+0x3b>
        	p->property = 0;
        }
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
  102c79:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c82:	01 d0                	add    %edx,%eax
  102c84:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102c89:	c9                   	leave  
  102c8a:	c3                   	ret    

00102c8b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102c8b:	55                   	push   %ebp
  102c8c:	89 e5                	mov    %esp,%ebp
  102c8e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102c91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102c95:	75 24                	jne    102cbb <default_alloc_pages+0x30>
  102c97:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  102c9e:	00 
  102c9f:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102ca6:	00 
  102ca7:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  102cae:	00 
  102caf:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102cb6:	e8 05 e0 ff ff       	call   100cc0 <__panic>
    if (n > nr_free) {
  102cbb:	a1 58 89 11 00       	mov    0x118958,%eax
  102cc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  102cc3:	73 0a                	jae    102ccf <default_alloc_pages+0x44>
        return NULL;
  102cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  102cca:	e9 45 01 00 00       	jmp    102e14 <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
  102ccf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *tmp = NULL;
  102cd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    list_entry_t *le = &free_list;
  102cdd:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list)
  102ce4:	e9 0a 01 00 00       	jmp    102df3 <default_alloc_pages+0x168>
    {
        struct Page *p = le2page(le, page_link);
  102ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cec:	83 e8 0c             	sub    $0xc,%eax
  102cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n)
  102cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cf5:	8b 40 08             	mov    0x8(%eax),%eax
  102cf8:	3b 45 08             	cmp    0x8(%ebp),%eax
  102cfb:	0f 82 f2 00 00 00    	jb     102df3 <default_alloc_pages+0x168>
        {
            int i;
            for(i = 0;i<n;i++)
  102d01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102d08:	eb 7c                	jmp    102d86 <default_alloc_pages+0xfb>
  102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d13:	8b 40 04             	mov    0x4(%eax),%eax
            {
            	tmp = list_next(le);
  102d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *pagetmp = le2page(le, page_link);
  102d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d1c:	83 e8 0c             	sub    $0xc,%eax
  102d1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            	SetPageReserved(pagetmp);
  102d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d25:	83 c0 04             	add    $0x4,%eax
  102d28:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102d2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102d32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d35:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102d38:	0f ab 10             	bts    %edx,(%eax)
            	ClearPageProperty(pagetmp);
  102d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d3e:	83 c0 04             	add    $0x4,%eax
  102d41:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102d48:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d51:	0f b3 10             	btr    %edx,(%eax)
  102d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d57:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d5d:	8b 40 04             	mov    0x4(%eax),%eax
  102d60:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d63:	8b 12                	mov    (%edx),%edx
  102d65:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102d68:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d6e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d71:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d74:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d77:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d7a:	89 10                	mov    %edx,(%eax)
            	list_del(le);
            	le = tmp;
  102d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n)
        {
            int i;
            for(i = 0;i<n;i++)
  102d82:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d89:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d8c:	0f 82 78 ff ff ff    	jb     102d0a <default_alloc_pages+0x7f>
            	SetPageReserved(pagetmp);
            	ClearPageProperty(pagetmp);
            	list_del(le);
            	le = tmp;
            }
			if(p->property > n)
  102d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d95:	8b 40 08             	mov    0x8(%eax),%eax
  102d98:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d9b:	76 12                	jbe    102daf <default_alloc_pages+0x124>
			{
				(le2page(le, page_link)->property) = p->property - n;
  102d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da0:	8d 50 f4             	lea    -0xc(%eax),%edx
  102da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102da6:	8b 40 08             	mov    0x8(%eax),%eax
  102da9:	2b 45 08             	sub    0x8(%ebp),%eax
  102dac:	89 42 08             	mov    %eax,0x8(%edx)
			}
			SetPageReserved(p);
  102daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102db2:	83 c0 04             	add    $0x4,%eax
  102db5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  102dbc:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dbf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dc2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dc5:	0f ab 10             	bts    %edx,(%eax)
			ClearPageProperty(p);
  102dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dcb:	83 c0 04             	add    $0x4,%eax
  102dce:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  102dd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ddb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102dde:	0f b3 10             	btr    %edx,(%eax)
			nr_free -= n;
  102de1:	a1 58 89 11 00       	mov    0x118958,%eax
  102de6:	2b 45 08             	sub    0x8(%ebp),%eax
  102de9:	a3 58 89 11 00       	mov    %eax,0x118958
			return p;
  102dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102df1:	eb 21                	jmp    102e14 <default_alloc_pages+0x189>
  102df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df6:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102df9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dfc:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *tmp = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
  102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e02:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102e09:	0f 85 da fe ff ff    	jne    102ce9 <default_alloc_pages+0x5e>
			ClearPageProperty(p);
			nr_free -= n;
			return p;
        }
    }
    return NULL;
  102e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e14:	c9                   	leave  
  102e15:	c3                   	ret    

00102e16 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102e16:	55                   	push   %ebp
  102e17:	89 e5                	mov    %esp,%ebp
  102e19:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102e1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e20:	75 24                	jne    102e46 <default_free_pages+0x30>
  102e22:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  102e29:	00 
  102e2a:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102e31:	00 
  102e32:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  102e39:	00 
  102e3a:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102e41:	e8 7a de ff ff       	call   100cc0 <__panic>
    assert(PageReserved(base));
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	83 c0 04             	add    $0x4,%eax
  102e4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e5c:	0f a3 10             	bt     %edx,(%eax)
  102e5f:	19 c0                	sbb    %eax,%eax
  102e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  102e64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102e68:	0f 95 c0             	setne  %al
  102e6b:	0f b6 c0             	movzbl %al,%eax
  102e6e:	85 c0                	test   %eax,%eax
  102e70:	75 24                	jne    102e96 <default_free_pages+0x80>
  102e72:	c7 44 24 0c 11 69 10 	movl   $0x106911,0xc(%esp)
  102e79:	00 
  102e7a:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102e81:	00 
  102e82:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  102e89:	00 
  102e8a:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102e91:	e8 2a de ff ff       	call   100cc0 <__panic>
    list_entry_t *le = &free_list;
  102e96:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    struct Page* p = NULL;
  102e9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  102ea4:	eb 13                	jmp    102eb9 <default_free_pages+0xa3>
    {
    	p = le2page(le, page_link);
  102ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea9:	83 e8 0c             	sub    $0xc,%eax
  102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(p > base)
  102eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102eb5:	76 02                	jbe    102eb9 <default_free_pages+0xa3>
    		break;
  102eb7:	eb 18                	jmp    102ed1 <default_free_pages+0xbb>
  102eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ebc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ec2:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    list_entry_t *le = &free_list;
    struct Page* p = NULL;
    while ((le = list_next(le)) != &free_list)
  102ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec8:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102ecf:	75 d5                	jne    102ea6 <default_free_pages+0x90>
    	p = le2page(le, page_link);
    	if(p > base)
    		break;
    }
    int i;
    for(i = 0;i<n;i++)
  102ed1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102ed8:	eb 5c                	jmp    102f36 <default_free_pages+0x120>
    {
    	list_add_before(le, &((base + i)->page_link));
  102eda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102edd:	89 d0                	mov    %edx,%eax
  102edf:	c1 e0 02             	shl    $0x2,%eax
  102ee2:	01 d0                	add    %edx,%eax
  102ee4:	c1 e0 02             	shl    $0x2,%eax
  102ee7:	89 c2                	mov    %eax,%edx
  102ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eec:	01 d0                	add    %edx,%eax
  102eee:	8d 50 0c             	lea    0xc(%eax),%edx
  102ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ef4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102efa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102efd:	8b 00                	mov    (%eax),%eax
  102eff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f02:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102f05:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102f0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f11:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f14:	89 10                	mov    %edx,(%eax)
  102f16:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f19:	8b 10                	mov    (%eax),%edx
  102f1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102f1e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f24:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102f27:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102f30:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
    	if(p > base)
    		break;
    }
    int i;
    for(i = 0;i<n;i++)
  102f32:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  102f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f39:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102f3c:	72 9c                	jb     102eda <default_free_pages+0xc4>
    {
    	list_add_before(le, &((base + i)->page_link));
    }
    base->flags = 0;
  102f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
  102f48:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4b:	83 c0 04             	add    $0x4,%eax
  102f4e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102f55:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f58:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102f5b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102f5e:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102f61:	8b 45 08             	mov    0x8(%ebp),%eax
  102f64:	83 c0 04             	add    $0x4,%eax
  102f67:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102f6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f71:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f74:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102f77:	0f ab 10             	bts    %edx,(%eax)
    set_page_ref(base, 0);
  102f7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102f81:	00 
  102f82:	8b 45 08             	mov    0x8(%ebp),%eax
  102f85:	89 04 24             	mov    %eax,(%esp)
  102f88:	e8 6b fb ff ff       	call   102af8 <set_page_ref>
    base->property = n;
  102f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f93:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le, page_link);
  102f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f99:	83 e8 0c             	sub    $0xc,%eax
  102f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(base + n == p)
  102f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fa2:	89 d0                	mov    %edx,%eax
  102fa4:	c1 e0 02             	shl    $0x2,%eax
  102fa7:	01 d0                	add    %edx,%eax
  102fa9:	c1 e0 02             	shl    $0x2,%eax
  102fac:	89 c2                	mov    %eax,%edx
  102fae:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb1:	01 d0                	add    %edx,%eax
  102fb3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102fb6:	75 1b                	jne    102fd3 <default_free_pages+0x1bd>
    {
    	base->property = n + p->property;
  102fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbb:	8b 50 08             	mov    0x8(%eax),%edx
  102fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc1:	01 c2                	add    %eax,%edx
  102fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc6:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
  102fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd6:	83 c0 0c             	add    $0xc,%eax
  102fd9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102fdc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102fdf:	8b 00                	mov    (%eax),%eax
  102fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe7:	83 e8 0c             	sub    $0xc,%eax
  102fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //below need to change
    if(le != &free_list && base - 1 == p)
  102fed:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102ff4:	74 57                	je     10304d <default_free_pages+0x237>
  102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff9:	83 e8 14             	sub    $0x14,%eax
  102ffc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102fff:	75 4c                	jne    10304d <default_free_pages+0x237>
    {
	  while(le!=&free_list){
  103001:	eb 41                	jmp    103044 <default_free_pages+0x22e>
		if(p->property){
  103003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103006:	8b 40 08             	mov    0x8(%eax),%eax
  103009:	85 c0                	test   %eax,%eax
  10300b:	74 20                	je     10302d <default_free_pages+0x217>
		  p->property += base->property;
  10300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103010:	8b 50 08             	mov    0x8(%eax),%edx
  103013:	8b 45 08             	mov    0x8(%ebp),%eax
  103016:	8b 40 08             	mov    0x8(%eax),%eax
  103019:	01 c2                	add    %eax,%edx
  10301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301e:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
  103021:	8b 45 08             	mov    0x8(%ebp),%eax
  103024:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
  10302b:	eb 20                	jmp    10304d <default_free_pages+0x237>
  10302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103030:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103033:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103036:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
  103038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
  10303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303e:	83 e8 0c             	sub    $0xc,%eax
  103041:	89 45 f0             	mov    %eax,-0x10(%ebp)
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    //below need to change
    if(le != &free_list && base - 1 == p)
    {
	  while(le!=&free_list){
  103044:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  10304b:	75 b6                	jne    103003 <default_free_pages+0x1ed>
		}
		le = list_prev(le);
		p = le2page(le,page_link);
	  }
	}
    nr_free += n;
  10304d:	8b 15 58 89 11 00    	mov    0x118958,%edx
  103053:	8b 45 0c             	mov    0xc(%ebp),%eax
  103056:	01 d0                	add    %edx,%eax
  103058:	a3 58 89 11 00       	mov    %eax,0x118958
}
  10305d:	c9                   	leave  
  10305e:	c3                   	ret    

0010305f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10305f:	55                   	push   %ebp
  103060:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103062:	a1 58 89 11 00       	mov    0x118958,%eax
}
  103067:	5d                   	pop    %ebp
  103068:	c3                   	ret    

00103069 <basic_check>:

static void
basic_check(void) {
  103069:	55                   	push   %ebp
  10306a:	89 e5                	mov    %esp,%ebp
  10306c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10306f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103079:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103089:	e8 85 0e 00 00       	call   103f13 <alloc_pages>
  10308e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103095:	75 24                	jne    1030bb <basic_check+0x52>
  103097:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  10309e:	00 
  10309f:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1030a6:	00 
  1030a7:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  1030ae:	00 
  1030af:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1030b6:	e8 05 dc ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030c2:	e8 4c 0e 00 00       	call   103f13 <alloc_pages>
  1030c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030ce:	75 24                	jne    1030f4 <basic_check+0x8b>
  1030d0:	c7 44 24 0c 40 69 10 	movl   $0x106940,0xc(%esp)
  1030d7:	00 
  1030d8:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1030df:	00 
  1030e0:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  1030e7:	00 
  1030e8:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1030ef:	e8 cc db ff ff       	call   100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030fb:	e8 13 0e 00 00       	call   103f13 <alloc_pages>
  103100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103107:	75 24                	jne    10312d <basic_check+0xc4>
  103109:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103110:	00 
  103111:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103118:	00 
  103119:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  103120:	00 
  103121:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103128:	e8 93 db ff ff       	call   100cc0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103133:	74 10                	je     103145 <basic_check+0xdc>
  103135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103138:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10313b:	74 08                	je     103145 <basic_check+0xdc>
  10313d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103140:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103143:	75 24                	jne    103169 <basic_check+0x100>
  103145:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  10314c:	00 
  10314d:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103154:	00 
  103155:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10315c:	00 
  10315d:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103164:	e8 57 db ff ff       	call   100cc0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10316c:	89 04 24             	mov    %eax,(%esp)
  10316f:	e8 7a f9 ff ff       	call   102aee <page_ref>
  103174:	85 c0                	test   %eax,%eax
  103176:	75 1e                	jne    103196 <basic_check+0x12d>
  103178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317b:	89 04 24             	mov    %eax,(%esp)
  10317e:	e8 6b f9 ff ff       	call   102aee <page_ref>
  103183:	85 c0                	test   %eax,%eax
  103185:	75 0f                	jne    103196 <basic_check+0x12d>
  103187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10318a:	89 04 24             	mov    %eax,(%esp)
  10318d:	e8 5c f9 ff ff       	call   102aee <page_ref>
  103192:	85 c0                	test   %eax,%eax
  103194:	74 24                	je     1031ba <basic_check+0x151>
  103196:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  10319d:	00 
  10319e:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1031a5:	00 
  1031a6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1031ad:	00 
  1031ae:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1031b5:	e8 06 db ff ff       	call   100cc0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1031ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031bd:	89 04 24             	mov    %eax,(%esp)
  1031c0:	e8 13 f9 ff ff       	call   102ad8 <page2pa>
  1031c5:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1031cb:	c1 e2 0c             	shl    $0xc,%edx
  1031ce:	39 d0                	cmp    %edx,%eax
  1031d0:	72 24                	jb     1031f6 <basic_check+0x18d>
  1031d2:	c7 44 24 0c d8 69 10 	movl   $0x1069d8,0xc(%esp)
  1031d9:	00 
  1031da:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1031e1:	00 
  1031e2:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  1031e9:	00 
  1031ea:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1031f1:	e8 ca da ff ff       	call   100cc0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f9:	89 04 24             	mov    %eax,(%esp)
  1031fc:	e8 d7 f8 ff ff       	call   102ad8 <page2pa>
  103201:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103207:	c1 e2 0c             	shl    $0xc,%edx
  10320a:	39 d0                	cmp    %edx,%eax
  10320c:	72 24                	jb     103232 <basic_check+0x1c9>
  10320e:	c7 44 24 0c f5 69 10 	movl   $0x1069f5,0xc(%esp)
  103215:	00 
  103216:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10321d:	00 
  10321e:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  103225:	00 
  103226:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10322d:	e8 8e da ff ff       	call   100cc0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103235:	89 04 24             	mov    %eax,(%esp)
  103238:	e8 9b f8 ff ff       	call   102ad8 <page2pa>
  10323d:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103243:	c1 e2 0c             	shl    $0xc,%edx
  103246:	39 d0                	cmp    %edx,%eax
  103248:	72 24                	jb     10326e <basic_check+0x205>
  10324a:	c7 44 24 0c 12 6a 10 	movl   $0x106a12,0xc(%esp)
  103251:	00 
  103252:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103259:	00 
  10325a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  103261:	00 
  103262:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103269:	e8 52 da ff ff       	call   100cc0 <__panic>

    list_entry_t free_list_store = free_list;
  10326e:	a1 50 89 11 00       	mov    0x118950,%eax
  103273:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103279:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10327c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10327f:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103289:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10328c:	89 50 04             	mov    %edx,0x4(%eax)
  10328f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103292:	8b 50 04             	mov    0x4(%eax),%edx
  103295:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103298:	89 10                	mov    %edx,(%eax)
  10329a:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1032a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032a4:	8b 40 04             	mov    0x4(%eax),%eax
  1032a7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1032aa:	0f 94 c0             	sete   %al
  1032ad:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032b0:	85 c0                	test   %eax,%eax
  1032b2:	75 24                	jne    1032d8 <basic_check+0x26f>
  1032b4:	c7 44 24 0c 2f 6a 10 	movl   $0x106a2f,0xc(%esp)
  1032bb:	00 
  1032bc:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1032c3:	00 
  1032c4:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  1032cb:	00 
  1032cc:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1032d3:	e8 e8 d9 ff ff       	call   100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
  1032d8:	a1 58 89 11 00       	mov    0x118958,%eax
  1032dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032e0:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1032e7:	00 00 00 

    assert(alloc_page() == NULL);
  1032ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032f1:	e8 1d 0c 00 00       	call   103f13 <alloc_pages>
  1032f6:	85 c0                	test   %eax,%eax
  1032f8:	74 24                	je     10331e <basic_check+0x2b5>
  1032fa:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  103301:	00 
  103302:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103309:	00 
  10330a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103311:	00 
  103312:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103319:	e8 a2 d9 ff ff       	call   100cc0 <__panic>

    free_page(p0);
  10331e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103325:	00 
  103326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103329:	89 04 24             	mov    %eax,(%esp)
  10332c:	e8 1a 0c 00 00       	call   103f4b <free_pages>
    free_page(p1);
  103331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103338:	00 
  103339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333c:	89 04 24             	mov    %eax,(%esp)
  10333f:	e8 07 0c 00 00       	call   103f4b <free_pages>
    free_page(p2);
  103344:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10334b:	00 
  10334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10334f:	89 04 24             	mov    %eax,(%esp)
  103352:	e8 f4 0b 00 00       	call   103f4b <free_pages>
    assert(nr_free == 3);
  103357:	a1 58 89 11 00       	mov    0x118958,%eax
  10335c:	83 f8 03             	cmp    $0x3,%eax
  10335f:	74 24                	je     103385 <basic_check+0x31c>
  103361:	c7 44 24 0c 5b 6a 10 	movl   $0x106a5b,0xc(%esp)
  103368:	00 
  103369:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103370:	00 
  103371:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103378:	00 
  103379:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103380:	e8 3b d9 ff ff       	call   100cc0 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103385:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10338c:	e8 82 0b 00 00       	call   103f13 <alloc_pages>
  103391:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103398:	75 24                	jne    1033be <basic_check+0x355>
  10339a:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  1033a1:	00 
  1033a2:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1033a9:	00 
  1033aa:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  1033b1:	00 
  1033b2:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1033b9:	e8 02 d9 ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c5:	e8 49 0b 00 00       	call   103f13 <alloc_pages>
  1033ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033d1:	75 24                	jne    1033f7 <basic_check+0x38e>
  1033d3:	c7 44 24 0c 40 69 10 	movl   $0x106940,0xc(%esp)
  1033da:	00 
  1033db:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1033ea:	00 
  1033eb:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1033f2:	e8 c9 d8 ff ff       	call   100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033fe:	e8 10 0b 00 00       	call   103f13 <alloc_pages>
  103403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10340a:	75 24                	jne    103430 <basic_check+0x3c7>
  10340c:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103413:	00 
  103414:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10341b:	00 
  10341c:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  103423:	00 
  103424:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10342b:	e8 90 d8 ff ff       	call   100cc0 <__panic>

    assert(alloc_page() == NULL);
  103430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103437:	e8 d7 0a 00 00       	call   103f13 <alloc_pages>
  10343c:	85 c0                	test   %eax,%eax
  10343e:	74 24                	je     103464 <basic_check+0x3fb>
  103440:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  103447:	00 
  103448:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10344f:	00 
  103450:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  103457:	00 
  103458:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10345f:	e8 5c d8 ff ff       	call   100cc0 <__panic>

    free_page(p0);
  103464:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10346b:	00 
  10346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10346f:	89 04 24             	mov    %eax,(%esp)
  103472:	e8 d4 0a 00 00       	call   103f4b <free_pages>
  103477:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10347e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103481:	8b 40 04             	mov    0x4(%eax),%eax
  103484:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103487:	0f 94 c0             	sete   %al
  10348a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10348d:	85 c0                	test   %eax,%eax
  10348f:	74 24                	je     1034b5 <basic_check+0x44c>
  103491:	c7 44 24 0c 68 6a 10 	movl   $0x106a68,0xc(%esp)
  103498:	00 
  103499:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1034a0:	00 
  1034a1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  1034a8:	00 
  1034a9:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1034b0:	e8 0b d8 ff ff       	call   100cc0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034bc:	e8 52 0a 00 00       	call   103f13 <alloc_pages>
  1034c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034ca:	74 24                	je     1034f0 <basic_check+0x487>
  1034cc:	c7 44 24 0c 80 6a 10 	movl   $0x106a80,0xc(%esp)
  1034d3:	00 
  1034d4:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1034db:	00 
  1034dc:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  1034e3:	00 
  1034e4:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1034eb:	e8 d0 d7 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  1034f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034f7:	e8 17 0a 00 00       	call   103f13 <alloc_pages>
  1034fc:	85 c0                	test   %eax,%eax
  1034fe:	74 24                	je     103524 <basic_check+0x4bb>
  103500:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  103507:	00 
  103508:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10350f:	00 
  103510:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103517:	00 
  103518:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10351f:	e8 9c d7 ff ff       	call   100cc0 <__panic>

    assert(nr_free == 0);
  103524:	a1 58 89 11 00       	mov    0x118958,%eax
  103529:	85 c0                	test   %eax,%eax
  10352b:	74 24                	je     103551 <basic_check+0x4e8>
  10352d:	c7 44 24 0c 99 6a 10 	movl   $0x106a99,0xc(%esp)
  103534:	00 
  103535:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10353c:	00 
  10353d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  103544:	00 
  103545:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10354c:	e8 6f d7 ff ff       	call   100cc0 <__panic>
    free_list = free_list_store;
  103551:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103554:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103557:	a3 50 89 11 00       	mov    %eax,0x118950
  10355c:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  103562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103565:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  10356a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103571:	00 
  103572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103575:	89 04 24             	mov    %eax,(%esp)
  103578:	e8 ce 09 00 00       	call   103f4b <free_pages>
    free_page(p1);
  10357d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103584:	00 
  103585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103588:	89 04 24             	mov    %eax,(%esp)
  10358b:	e8 bb 09 00 00       	call   103f4b <free_pages>
    free_page(p2);
  103590:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103597:	00 
  103598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10359b:	89 04 24             	mov    %eax,(%esp)
  10359e:	e8 a8 09 00 00       	call   103f4b <free_pages>
}
  1035a3:	c9                   	leave  
  1035a4:	c3                   	ret    

001035a5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1035a5:	55                   	push   %ebp
  1035a6:	89 e5                	mov    %esp,%ebp
  1035a8:	53                   	push   %ebx
  1035a9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1035af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035bd:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1035c4:	eb 6b                	jmp    103631 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c9:	83 e8 0c             	sub    $0xc,%eax
  1035cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1035cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035d2:	83 c0 04             	add    $0x4,%eax
  1035d5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035e5:	0f a3 10             	bt     %edx,(%eax)
  1035e8:	19 c0                	sbb    %eax,%eax
  1035ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035f1:	0f 95 c0             	setne  %al
  1035f4:	0f b6 c0             	movzbl %al,%eax
  1035f7:	85 c0                	test   %eax,%eax
  1035f9:	75 24                	jne    10361f <default_check+0x7a>
  1035fb:	c7 44 24 0c a6 6a 10 	movl   $0x106aa6,0xc(%esp)
  103602:	00 
  103603:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10360a:	00 
  10360b:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103612:	00 
  103613:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10361a:	e8 a1 d6 ff ff       	call   100cc0 <__panic>
        count ++, total += p->property;
  10361f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103626:	8b 50 08             	mov    0x8(%eax),%edx
  103629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10362c:	01 d0                	add    %edx,%eax
  10362e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103634:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103637:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10363a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10363d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103640:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103647:	0f 85 79 ff ff ff    	jne    1035c6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10364d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103650:	e8 28 09 00 00       	call   103f7d <nr_free_pages>
  103655:	39 c3                	cmp    %eax,%ebx
  103657:	74 24                	je     10367d <default_check+0xd8>
  103659:	c7 44 24 0c b6 6a 10 	movl   $0x106ab6,0xc(%esp)
  103660:	00 
  103661:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103668:	00 
  103669:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103670:	00 
  103671:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103678:	e8 43 d6 ff ff       	call   100cc0 <__panic>

    basic_check();
  10367d:	e8 e7 f9 ff ff       	call   103069 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103682:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103689:	e8 85 08 00 00       	call   103f13 <alloc_pages>
  10368e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103695:	75 24                	jne    1036bb <default_check+0x116>
  103697:	c7 44 24 0c cf 6a 10 	movl   $0x106acf,0xc(%esp)
  10369e:	00 
  10369f:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1036a6:	00 
  1036a7:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  1036ae:	00 
  1036af:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1036b6:	e8 05 d6 ff ff       	call   100cc0 <__panic>
    assert(!PageProperty(p0));
  1036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036be:	83 c0 04             	add    $0x4,%eax
  1036c1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036ce:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036d1:	0f a3 10             	bt     %edx,(%eax)
  1036d4:	19 c0                	sbb    %eax,%eax
  1036d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036d9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036dd:	0f 95 c0             	setne  %al
  1036e0:	0f b6 c0             	movzbl %al,%eax
  1036e3:	85 c0                	test   %eax,%eax
  1036e5:	74 24                	je     10370b <default_check+0x166>
  1036e7:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  1036ee:	00 
  1036ef:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1036f6:	00 
  1036f7:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  1036fe:	00 
  1036ff:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103706:	e8 b5 d5 ff ff       	call   100cc0 <__panic>

    list_entry_t free_list_store = free_list;
  10370b:	a1 50 89 11 00       	mov    0x118950,%eax
  103710:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103716:	89 45 80             	mov    %eax,-0x80(%ebp)
  103719:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10371c:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103723:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103726:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103729:	89 50 04             	mov    %edx,0x4(%eax)
  10372c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10372f:	8b 50 04             	mov    0x4(%eax),%edx
  103732:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103735:	89 10                	mov    %edx,(%eax)
  103737:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10373e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103741:	8b 40 04             	mov    0x4(%eax),%eax
  103744:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103747:	0f 94 c0             	sete   %al
  10374a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10374d:	85 c0                	test   %eax,%eax
  10374f:	75 24                	jne    103775 <default_check+0x1d0>
  103751:	c7 44 24 0c 2f 6a 10 	movl   $0x106a2f,0xc(%esp)
  103758:	00 
  103759:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103760:	00 
  103761:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103768:	00 
  103769:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103770:	e8 4b d5 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  103775:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10377c:	e8 92 07 00 00       	call   103f13 <alloc_pages>
  103781:	85 c0                	test   %eax,%eax
  103783:	74 24                	je     1037a9 <default_check+0x204>
  103785:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  10378c:	00 
  10378d:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103794:	00 
  103795:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  10379c:	00 
  10379d:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1037a4:	e8 17 d5 ff ff       	call   100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
  1037a9:	a1 58 89 11 00       	mov    0x118958,%eax
  1037ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1037b1:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1037b8:	00 00 00 

    free_pages(p0 + 2, 3);
  1037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037be:	83 c0 28             	add    $0x28,%eax
  1037c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037c8:	00 
  1037c9:	89 04 24             	mov    %eax,(%esp)
  1037cc:	e8 7a 07 00 00       	call   103f4b <free_pages>
    assert(alloc_pages(4) == NULL);
  1037d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037d8:	e8 36 07 00 00       	call   103f13 <alloc_pages>
  1037dd:	85 c0                	test   %eax,%eax
  1037df:	74 24                	je     103805 <default_check+0x260>
  1037e1:	c7 44 24 0c ec 6a 10 	movl   $0x106aec,0xc(%esp)
  1037e8:	00 
  1037e9:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1037f8:	00 
  1037f9:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103800:	e8 bb d4 ff ff       	call   100cc0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103808:	83 c0 28             	add    $0x28,%eax
  10380b:	83 c0 04             	add    $0x4,%eax
  10380e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103815:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103818:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10381b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10381e:	0f a3 10             	bt     %edx,(%eax)
  103821:	19 c0                	sbb    %eax,%eax
  103823:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103826:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10382a:	0f 95 c0             	setne  %al
  10382d:	0f b6 c0             	movzbl %al,%eax
  103830:	85 c0                	test   %eax,%eax
  103832:	74 0e                	je     103842 <default_check+0x29d>
  103834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103837:	83 c0 28             	add    $0x28,%eax
  10383a:	8b 40 08             	mov    0x8(%eax),%eax
  10383d:	83 f8 03             	cmp    $0x3,%eax
  103840:	74 24                	je     103866 <default_check+0x2c1>
  103842:	c7 44 24 0c 04 6b 10 	movl   $0x106b04,0xc(%esp)
  103849:	00 
  10384a:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103851:	00 
  103852:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103859:	00 
  10385a:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103861:	e8 5a d4 ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103866:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10386d:	e8 a1 06 00 00       	call   103f13 <alloc_pages>
  103872:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103875:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103879:	75 24                	jne    10389f <default_check+0x2fa>
  10387b:	c7 44 24 0c 30 6b 10 	movl   $0x106b30,0xc(%esp)
  103882:	00 
  103883:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10388a:	00 
  10388b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103892:	00 
  103893:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10389a:	e8 21 d4 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  10389f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038a6:	e8 68 06 00 00       	call   103f13 <alloc_pages>
  1038ab:	85 c0                	test   %eax,%eax
  1038ad:	74 24                	je     1038d3 <default_check+0x32e>
  1038af:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  1038b6:	00 
  1038b7:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1038be:	00 
  1038bf:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1038c6:	00 
  1038c7:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1038ce:	e8 ed d3 ff ff       	call   100cc0 <__panic>
    assert(p0 + 2 == p1);
  1038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038d6:	83 c0 28             	add    $0x28,%eax
  1038d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1038dc:	74 24                	je     103902 <default_check+0x35d>
  1038de:	c7 44 24 0c 4e 6b 10 	movl   $0x106b4e,0xc(%esp)
  1038e5:	00 
  1038e6:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1038ed:	00 
  1038ee:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1038f5:	00 
  1038f6:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1038fd:	e8 be d3 ff ff       	call   100cc0 <__panic>

    p2 = p0 + 1;
  103902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103905:	83 c0 14             	add    $0x14,%eax
  103908:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  10390b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103912:	00 
  103913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103916:	89 04 24             	mov    %eax,(%esp)
  103919:	e8 2d 06 00 00       	call   103f4b <free_pages>
    free_pages(p1, 3);
  10391e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103925:	00 
  103926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103929:	89 04 24             	mov    %eax,(%esp)
  10392c:	e8 1a 06 00 00       	call   103f4b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103934:	83 c0 04             	add    $0x4,%eax
  103937:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10393e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103941:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103944:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103947:	0f a3 10             	bt     %edx,(%eax)
  10394a:	19 c0                	sbb    %eax,%eax
  10394c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10394f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103953:	0f 95 c0             	setne  %al
  103956:	0f b6 c0             	movzbl %al,%eax
  103959:	85 c0                	test   %eax,%eax
  10395b:	74 0b                	je     103968 <default_check+0x3c3>
  10395d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103960:	8b 40 08             	mov    0x8(%eax),%eax
  103963:	83 f8 01             	cmp    $0x1,%eax
  103966:	74 24                	je     10398c <default_check+0x3e7>
  103968:	c7 44 24 0c 5c 6b 10 	movl   $0x106b5c,0xc(%esp)
  10396f:	00 
  103970:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103977:	00 
  103978:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  10397f:	00 
  103980:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103987:	e8 34 d3 ff ff       	call   100cc0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10398f:	83 c0 04             	add    $0x4,%eax
  103992:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103999:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10399c:	8b 45 90             	mov    -0x70(%ebp),%eax
  10399f:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1039a2:	0f a3 10             	bt     %edx,(%eax)
  1039a5:	19 c0                	sbb    %eax,%eax
  1039a7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1039aa:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1039ae:	0f 95 c0             	setne  %al
  1039b1:	0f b6 c0             	movzbl %al,%eax
  1039b4:	85 c0                	test   %eax,%eax
  1039b6:	74 0b                	je     1039c3 <default_check+0x41e>
  1039b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039bb:	8b 40 08             	mov    0x8(%eax),%eax
  1039be:	83 f8 03             	cmp    $0x3,%eax
  1039c1:	74 24                	je     1039e7 <default_check+0x442>
  1039c3:	c7 44 24 0c 84 6b 10 	movl   $0x106b84,0xc(%esp)
  1039ca:	00 
  1039cb:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1039d2:	00 
  1039d3:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1039da:	00 
  1039db:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1039e2:	e8 d9 d2 ff ff       	call   100cc0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039ee:	e8 20 05 00 00       	call   103f13 <alloc_pages>
  1039f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039f9:	83 e8 14             	sub    $0x14,%eax
  1039fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1039ff:	74 24                	je     103a25 <default_check+0x480>
  103a01:	c7 44 24 0c aa 6b 10 	movl   $0x106baa,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103a20:	e8 9b d2 ff ff       	call   100cc0 <__panic>
    free_page(p0);
  103a25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a2c:	00 
  103a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a30:	89 04 24             	mov    %eax,(%esp)
  103a33:	e8 13 05 00 00       	call   103f4b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a38:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a3f:	e8 cf 04 00 00       	call   103f13 <alloc_pages>
  103a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a4a:	83 c0 14             	add    $0x14,%eax
  103a4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a50:	74 24                	je     103a76 <default_check+0x4d1>
  103a52:	c7 44 24 0c c8 6b 10 	movl   $0x106bc8,0xc(%esp)
  103a59:	00 
  103a5a:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103a61:	00 
  103a62:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103a69:	00 
  103a6a:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103a71:	e8 4a d2 ff ff       	call   100cc0 <__panic>

    free_pages(p0, 2);
  103a76:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a7d:	00 
  103a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a81:	89 04 24             	mov    %eax,(%esp)
  103a84:	e8 c2 04 00 00       	call   103f4b <free_pages>
    free_page(p2);
  103a89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a90:	00 
  103a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a94:	89 04 24             	mov    %eax,(%esp)
  103a97:	e8 af 04 00 00       	call   103f4b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a9c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103aa3:	e8 6b 04 00 00       	call   103f13 <alloc_pages>
  103aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103aab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103aaf:	75 24                	jne    103ad5 <default_check+0x530>
  103ab1:	c7 44 24 0c e8 6b 10 	movl   $0x106be8,0xc(%esp)
  103ab8:	00 
  103ab9:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103ac0:	00 
  103ac1:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  103ac8:	00 
  103ac9:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103ad0:	e8 eb d1 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  103ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103adc:	e8 32 04 00 00       	call   103f13 <alloc_pages>
  103ae1:	85 c0                	test   %eax,%eax
  103ae3:	74 24                	je     103b09 <default_check+0x564>
  103ae5:	c7 44 24 0c 46 6a 10 	movl   $0x106a46,0xc(%esp)
  103aec:	00 
  103aed:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103af4:	00 
  103af5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103afc:	00 
  103afd:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103b04:	e8 b7 d1 ff ff       	call   100cc0 <__panic>

    assert(nr_free == 0);
  103b09:	a1 58 89 11 00       	mov    0x118958,%eax
  103b0e:	85 c0                	test   %eax,%eax
  103b10:	74 24                	je     103b36 <default_check+0x591>
  103b12:	c7 44 24 0c 99 6a 10 	movl   $0x106a99,0xc(%esp)
  103b19:	00 
  103b1a:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103b21:	00 
  103b22:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103b29:	00 
  103b2a:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103b31:	e8 8a d1 ff ff       	call   100cc0 <__panic>
    nr_free = nr_free_store;
  103b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b39:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103b3e:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b41:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b44:	a3 50 89 11 00       	mov    %eax,0x118950
  103b49:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103b4f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b56:	00 
  103b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b5a:	89 04 24             	mov    %eax,(%esp)
  103b5d:	e8 e9 03 00 00       	call   103f4b <free_pages>

    le = &free_list;
  103b62:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b69:	eb 1d                	jmp    103b88 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b6e:	83 e8 0c             	sub    $0xc,%eax
  103b71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103b74:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103b7e:	8b 40 08             	mov    0x8(%eax),%eax
  103b81:	29 c2                	sub    %eax,%edx
  103b83:	89 d0                	mov    %edx,%eax
  103b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b8b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103b8e:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b91:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103b94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b97:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103b9e:	75 cb                	jne    103b6b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103ba4:	74 24                	je     103bca <default_check+0x625>
  103ba6:	c7 44 24 0c 06 6c 10 	movl   $0x106c06,0xc(%esp)
  103bad:	00 
  103bae:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103bb5:	00 
  103bb6:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  103bbd:	00 
  103bbe:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103bc5:	e8 f6 d0 ff ff       	call   100cc0 <__panic>
    assert(total == 0);
  103bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bce:	74 24                	je     103bf4 <default_check+0x64f>
  103bd0:	c7 44 24 0c 11 6c 10 	movl   $0x106c11,0xc(%esp)
  103bd7:	00 
  103bd8:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103bdf:	00 
  103be0:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  103be7:	00 
  103be8:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103bef:	e8 cc d0 ff ff       	call   100cc0 <__panic>
}
  103bf4:	81 c4 94 00 00 00    	add    $0x94,%esp
  103bfa:	5b                   	pop    %ebx
  103bfb:	5d                   	pop    %ebp
  103bfc:	c3                   	ret    

00103bfd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103bfd:	55                   	push   %ebp
  103bfe:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c00:	8b 55 08             	mov    0x8(%ebp),%edx
  103c03:	a1 64 89 11 00       	mov    0x118964,%eax
  103c08:	29 c2                	sub    %eax,%edx
  103c0a:	89 d0                	mov    %edx,%eax
  103c0c:	c1 f8 02             	sar    $0x2,%eax
  103c0f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c15:	5d                   	pop    %ebp
  103c16:	c3                   	ret    

00103c17 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103c17:	55                   	push   %ebp
  103c18:	89 e5                	mov    %esp,%ebp
  103c1a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c20:	89 04 24             	mov    %eax,(%esp)
  103c23:	e8 d5 ff ff ff       	call   103bfd <page2ppn>
  103c28:	c1 e0 0c             	shl    $0xc,%eax
}
  103c2b:	c9                   	leave  
  103c2c:	c3                   	ret    

00103c2d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103c2d:	55                   	push   %ebp
  103c2e:	89 e5                	mov    %esp,%ebp
  103c30:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c33:	8b 45 08             	mov    0x8(%ebp),%eax
  103c36:	c1 e8 0c             	shr    $0xc,%eax
  103c39:	89 c2                	mov    %eax,%edx
  103c3b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c40:	39 c2                	cmp    %eax,%edx
  103c42:	72 1c                	jb     103c60 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c44:	c7 44 24 08 4c 6c 10 	movl   $0x106c4c,0x8(%esp)
  103c4b:	00 
  103c4c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c53:	00 
  103c54:	c7 04 24 6b 6c 10 00 	movl   $0x106c6b,(%esp)
  103c5b:	e8 60 d0 ff ff       	call   100cc0 <__panic>
    }
    return &pages[PPN(pa)];
  103c60:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103c66:	8b 45 08             	mov    0x8(%ebp),%eax
  103c69:	c1 e8 0c             	shr    $0xc,%eax
  103c6c:	89 c2                	mov    %eax,%edx
  103c6e:	89 d0                	mov    %edx,%eax
  103c70:	c1 e0 02             	shl    $0x2,%eax
  103c73:	01 d0                	add    %edx,%eax
  103c75:	c1 e0 02             	shl    $0x2,%eax
  103c78:	01 c8                	add    %ecx,%eax
}
  103c7a:	c9                   	leave  
  103c7b:	c3                   	ret    

00103c7c <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103c7c:	55                   	push   %ebp
  103c7d:	89 e5                	mov    %esp,%ebp
  103c7f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c82:	8b 45 08             	mov    0x8(%ebp),%eax
  103c85:	89 04 24             	mov    %eax,(%esp)
  103c88:	e8 8a ff ff ff       	call   103c17 <page2pa>
  103c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c93:	c1 e8 0c             	shr    $0xc,%eax
  103c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c99:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c9e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ca1:	72 23                	jb     103cc6 <page2kva+0x4a>
  103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ca6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103caa:	c7 44 24 08 7c 6c 10 	movl   $0x106c7c,0x8(%esp)
  103cb1:	00 
  103cb2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103cb9:	00 
  103cba:	c7 04 24 6b 6c 10 00 	movl   $0x106c6b,(%esp)
  103cc1:	e8 fa cf ff ff       	call   100cc0 <__panic>
  103cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cc9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cce:	c9                   	leave  
  103ccf:	c3                   	ret    

00103cd0 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103cd0:	55                   	push   %ebp
  103cd1:	89 e5                	mov    %esp,%ebp
  103cd3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  103cd9:	83 e0 01             	and    $0x1,%eax
  103cdc:	85 c0                	test   %eax,%eax
  103cde:	75 1c                	jne    103cfc <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ce0:	c7 44 24 08 a0 6c 10 	movl   $0x106ca0,0x8(%esp)
  103ce7:	00 
  103ce8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cef:	00 
  103cf0:	c7 04 24 6b 6c 10 00 	movl   $0x106c6b,(%esp)
  103cf7:	e8 c4 cf ff ff       	call   100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  103cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d04:	89 04 24             	mov    %eax,(%esp)
  103d07:	e8 21 ff ff ff       	call   103c2d <pa2page>
}
  103d0c:	c9                   	leave  
  103d0d:	c3                   	ret    

00103d0e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103d0e:	55                   	push   %ebp
  103d0f:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d11:	8b 45 08             	mov    0x8(%ebp),%eax
  103d14:	8b 00                	mov    (%eax),%eax
}
  103d16:	5d                   	pop    %ebp
  103d17:	c3                   	ret    

00103d18 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103d18:	55                   	push   %ebp
  103d19:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d21:	89 10                	mov    %edx,(%eax)
}
  103d23:	5d                   	pop    %ebp
  103d24:	c3                   	ret    

00103d25 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d25:	55                   	push   %ebp
  103d26:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d28:	8b 45 08             	mov    0x8(%ebp),%eax
  103d2b:	8b 00                	mov    (%eax),%eax
  103d2d:	8d 50 01             	lea    0x1(%eax),%edx
  103d30:	8b 45 08             	mov    0x8(%ebp),%eax
  103d33:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d35:	8b 45 08             	mov    0x8(%ebp),%eax
  103d38:	8b 00                	mov    (%eax),%eax
}
  103d3a:	5d                   	pop    %ebp
  103d3b:	c3                   	ret    

00103d3c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d3c:	55                   	push   %ebp
  103d3d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103d42:	8b 00                	mov    (%eax),%eax
  103d44:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d47:	8b 45 08             	mov    0x8(%ebp),%eax
  103d4a:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d4f:	8b 00                	mov    (%eax),%eax
}
  103d51:	5d                   	pop    %ebp
  103d52:	c3                   	ret    

00103d53 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103d53:	55                   	push   %ebp
  103d54:	89 e5                	mov    %esp,%ebp
  103d56:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d59:	9c                   	pushf  
  103d5a:	58                   	pop    %eax
  103d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d61:	25 00 02 00 00       	and    $0x200,%eax
  103d66:	85 c0                	test   %eax,%eax
  103d68:	74 0c                	je     103d76 <__intr_save+0x23>
        intr_disable();
  103d6a:	e8 34 d9 ff ff       	call   1016a3 <intr_disable>
        return 1;
  103d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  103d74:	eb 05                	jmp    103d7b <__intr_save+0x28>
    }
    return 0;
  103d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d7b:	c9                   	leave  
  103d7c:	c3                   	ret    

00103d7d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103d7d:	55                   	push   %ebp
  103d7e:	89 e5                	mov    %esp,%ebp
  103d80:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d87:	74 05                	je     103d8e <__intr_restore+0x11>
        intr_enable();
  103d89:	e8 0f d9 ff ff       	call   10169d <intr_enable>
    }
}
  103d8e:	c9                   	leave  
  103d8f:	c3                   	ret    

00103d90 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d90:	55                   	push   %ebp
  103d91:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d93:	8b 45 08             	mov    0x8(%ebp),%eax
  103d96:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d99:	b8 23 00 00 00       	mov    $0x23,%eax
  103d9e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103da0:	b8 23 00 00 00       	mov    $0x23,%eax
  103da5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103da7:	b8 10 00 00 00       	mov    $0x10,%eax
  103dac:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103dae:	b8 10 00 00 00       	mov    $0x10,%eax
  103db3:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103db5:	b8 10 00 00 00       	mov    $0x10,%eax
  103dba:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103dbc:	ea c3 3d 10 00 08 00 	ljmp   $0x8,$0x103dc3
}
  103dc3:	5d                   	pop    %ebp
  103dc4:	c3                   	ret    

00103dc5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103dc5:	55                   	push   %ebp
  103dc6:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  103dcb:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103dd0:	5d                   	pop    %ebp
  103dd1:	c3                   	ret    

00103dd2 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103dd2:	55                   	push   %ebp
  103dd3:	89 e5                	mov    %esp,%ebp
  103dd5:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103dd8:	b8 00 70 11 00       	mov    $0x117000,%eax
  103ddd:	89 04 24             	mov    %eax,(%esp)
  103de0:	e8 e0 ff ff ff       	call   103dc5 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103de5:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103dec:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103dee:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103df5:	68 00 
  103df7:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103dfc:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103e02:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103e07:	c1 e8 10             	shr    $0x10,%eax
  103e0a:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103e0f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e16:	83 e0 f0             	and    $0xfffffff0,%eax
  103e19:	83 c8 09             	or     $0x9,%eax
  103e1c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e21:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e28:	83 e0 ef             	and    $0xffffffef,%eax
  103e2b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e30:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e37:	83 e0 9f             	and    $0xffffff9f,%eax
  103e3a:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e3f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103e46:	83 c8 80             	or     $0xffffff80,%eax
  103e49:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103e4e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e55:	83 e0 f0             	and    $0xfffffff0,%eax
  103e58:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e5d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e64:	83 e0 ef             	and    $0xffffffef,%eax
  103e67:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e6c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e73:	83 e0 df             	and    $0xffffffdf,%eax
  103e76:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e7b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e82:	83 c8 40             	or     $0x40,%eax
  103e85:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e8a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103e91:	83 e0 7f             	and    $0x7f,%eax
  103e94:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e99:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103e9e:	c1 e8 18             	shr    $0x18,%eax
  103ea1:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ea6:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103ead:	e8 de fe ff ff       	call   103d90 <lgdt>
  103eb2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103eb8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103ebc:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103ebf:	c9                   	leave  
  103ec0:	c3                   	ret    

00103ec1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103ec1:	55                   	push   %ebp
  103ec2:	89 e5                	mov    %esp,%ebp
  103ec4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ec7:	c7 05 5c 89 11 00 30 	movl   $0x106c30,0x11895c
  103ece:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ed1:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ed6:	8b 00                	mov    (%eax),%eax
  103ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  103edc:	c7 04 24 cc 6c 10 00 	movl   $0x106ccc,(%esp)
  103ee3:	e8 54 c4 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103ee8:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103eed:	8b 40 04             	mov    0x4(%eax),%eax
  103ef0:	ff d0                	call   *%eax
}
  103ef2:	c9                   	leave  
  103ef3:	c3                   	ret    

00103ef4 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ef4:	55                   	push   %ebp
  103ef5:	89 e5                	mov    %esp,%ebp
  103ef7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103efa:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103eff:	8b 40 08             	mov    0x8(%eax),%eax
  103f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f05:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f09:	8b 55 08             	mov    0x8(%ebp),%edx
  103f0c:	89 14 24             	mov    %edx,(%esp)
  103f0f:	ff d0                	call   *%eax
}
  103f11:	c9                   	leave  
  103f12:	c3                   	ret    

00103f13 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f13:	55                   	push   %ebp
  103f14:	89 e5                	mov    %esp,%ebp
  103f16:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f20:	e8 2e fe ff ff       	call   103d53 <__intr_save>
  103f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f28:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  103f30:	8b 55 08             	mov    0x8(%ebp),%edx
  103f33:	89 14 24             	mov    %edx,(%esp)
  103f36:	ff d0                	call   *%eax
  103f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f3e:	89 04 24             	mov    %eax,(%esp)
  103f41:	e8 37 fe ff ff       	call   103d7d <__intr_restore>
    return page;
  103f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f49:	c9                   	leave  
  103f4a:	c3                   	ret    

00103f4b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f4b:	55                   	push   %ebp
  103f4c:	89 e5                	mov    %esp,%ebp
  103f4e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f51:	e8 fd fd ff ff       	call   103d53 <__intr_save>
  103f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f59:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103f5e:	8b 40 10             	mov    0x10(%eax),%eax
  103f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f64:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f68:	8b 55 08             	mov    0x8(%ebp),%edx
  103f6b:	89 14 24             	mov    %edx,(%esp)
  103f6e:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f73:	89 04 24             	mov    %eax,(%esp)
  103f76:	e8 02 fe ff ff       	call   103d7d <__intr_restore>
}
  103f7b:	c9                   	leave  
  103f7c:	c3                   	ret    

00103f7d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f7d:	55                   	push   %ebp
  103f7e:	89 e5                	mov    %esp,%ebp
  103f80:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f83:	e8 cb fd ff ff       	call   103d53 <__intr_save>
  103f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f8b:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103f90:	8b 40 14             	mov    0x14(%eax),%eax
  103f93:	ff d0                	call   *%eax
  103f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f9b:	89 04 24             	mov    %eax,(%esp)
  103f9e:	e8 da fd ff ff       	call   103d7d <__intr_restore>
    return ret;
  103fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103fa6:	c9                   	leave  
  103fa7:	c3                   	ret    

00103fa8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103fa8:	55                   	push   %ebp
  103fa9:	89 e5                	mov    %esp,%ebp
  103fab:	57                   	push   %edi
  103fac:	56                   	push   %esi
  103fad:	53                   	push   %ebx
  103fae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103fb4:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103fbb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fc2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103fc9:	c7 04 24 e3 6c 10 00 	movl   $0x106ce3,(%esp)
  103fd0:	e8 67 c3 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fd5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fdc:	e9 15 01 00 00       	jmp    1040f6 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fe1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fe7:	89 d0                	mov    %edx,%eax
  103fe9:	c1 e0 02             	shl    $0x2,%eax
  103fec:	01 d0                	add    %edx,%eax
  103fee:	c1 e0 02             	shl    $0x2,%eax
  103ff1:	01 c8                	add    %ecx,%eax
  103ff3:	8b 50 08             	mov    0x8(%eax),%edx
  103ff6:	8b 40 04             	mov    0x4(%eax),%eax
  103ff9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103ffc:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103fff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104002:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104005:	89 d0                	mov    %edx,%eax
  104007:	c1 e0 02             	shl    $0x2,%eax
  10400a:	01 d0                	add    %edx,%eax
  10400c:	c1 e0 02             	shl    $0x2,%eax
  10400f:	01 c8                	add    %ecx,%eax
  104011:	8b 48 0c             	mov    0xc(%eax),%ecx
  104014:	8b 58 10             	mov    0x10(%eax),%ebx
  104017:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10401a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10401d:	01 c8                	add    %ecx,%eax
  10401f:	11 da                	adc    %ebx,%edx
  104021:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104024:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104027:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10402a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10402d:	89 d0                	mov    %edx,%eax
  10402f:	c1 e0 02             	shl    $0x2,%eax
  104032:	01 d0                	add    %edx,%eax
  104034:	c1 e0 02             	shl    $0x2,%eax
  104037:	01 c8                	add    %ecx,%eax
  104039:	83 c0 14             	add    $0x14,%eax
  10403c:	8b 00                	mov    (%eax),%eax
  10403e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104044:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104047:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10404a:	83 c0 ff             	add    $0xffffffff,%eax
  10404d:	83 d2 ff             	adc    $0xffffffff,%edx
  104050:	89 c6                	mov    %eax,%esi
  104052:	89 d7                	mov    %edx,%edi
  104054:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104057:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405a:	89 d0                	mov    %edx,%eax
  10405c:	c1 e0 02             	shl    $0x2,%eax
  10405f:	01 d0                	add    %edx,%eax
  104061:	c1 e0 02             	shl    $0x2,%eax
  104064:	01 c8                	add    %ecx,%eax
  104066:	8b 48 0c             	mov    0xc(%eax),%ecx
  104069:	8b 58 10             	mov    0x10(%eax),%ebx
  10406c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104072:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104076:	89 74 24 14          	mov    %esi,0x14(%esp)
  10407a:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10407e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104081:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104084:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104088:	89 54 24 10          	mov    %edx,0x10(%esp)
  10408c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104090:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104094:	c7 04 24 f0 6c 10 00 	movl   $0x106cf0,(%esp)
  10409b:	e8 9c c2 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040a6:	89 d0                	mov    %edx,%eax
  1040a8:	c1 e0 02             	shl    $0x2,%eax
  1040ab:	01 d0                	add    %edx,%eax
  1040ad:	c1 e0 02             	shl    $0x2,%eax
  1040b0:	01 c8                	add    %ecx,%eax
  1040b2:	83 c0 14             	add    $0x14,%eax
  1040b5:	8b 00                	mov    (%eax),%eax
  1040b7:	83 f8 01             	cmp    $0x1,%eax
  1040ba:	75 36                	jne    1040f2 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  1040bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040c2:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040c5:	77 2b                	ja     1040f2 <page_init+0x14a>
  1040c7:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040ca:	72 05                	jb     1040d1 <page_init+0x129>
  1040cc:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1040cf:	73 21                	jae    1040f2 <page_init+0x14a>
  1040d1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040d5:	77 1b                	ja     1040f2 <page_init+0x14a>
  1040d7:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040db:	72 09                	jb     1040e6 <page_init+0x13e>
  1040dd:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  1040e4:	77 0c                	ja     1040f2 <page_init+0x14a>
                maxpa = end;
  1040e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1040e9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1040ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1040f2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1040f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040f9:	8b 00                	mov    (%eax),%eax
  1040fb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1040fe:	0f 8f dd fe ff ff    	jg     103fe1 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104104:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104108:	72 1d                	jb     104127 <page_init+0x17f>
  10410a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10410e:	77 09                	ja     104119 <page_init+0x171>
  104110:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104117:	76 0e                	jbe    104127 <page_init+0x17f>
        maxpa = KMEMSIZE;
  104119:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104120:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10412a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10412d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104131:	c1 ea 0c             	shr    $0xc,%edx
  104134:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104139:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  104140:	b8 68 89 11 00       	mov    $0x118968,%eax
  104145:	8d 50 ff             	lea    -0x1(%eax),%edx
  104148:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10414b:	01 d0                	add    %edx,%eax
  10414d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104150:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104153:	ba 00 00 00 00       	mov    $0x0,%edx
  104158:	f7 75 ac             	divl   -0x54(%ebp)
  10415b:	89 d0                	mov    %edx,%eax
  10415d:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104160:	29 c2                	sub    %eax,%edx
  104162:	89 d0                	mov    %edx,%eax
  104164:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  104169:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104170:	eb 2f                	jmp    1041a1 <page_init+0x1f9>
        SetPageReserved(pages + i);
  104172:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  104178:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10417b:	89 d0                	mov    %edx,%eax
  10417d:	c1 e0 02             	shl    $0x2,%eax
  104180:	01 d0                	add    %edx,%eax
  104182:	c1 e0 02             	shl    $0x2,%eax
  104185:	01 c8                	add    %ecx,%eax
  104187:	83 c0 04             	add    $0x4,%eax
  10418a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104191:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104194:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104197:	8b 55 90             	mov    -0x70(%ebp),%edx
  10419a:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10419d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041a4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1041a9:	39 c2                	cmp    %eax,%edx
  1041ab:	72 c5                	jb     104172 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041ad:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1041b3:	89 d0                	mov    %edx,%eax
  1041b5:	c1 e0 02             	shl    $0x2,%eax
  1041b8:	01 d0                	add    %edx,%eax
  1041ba:	c1 e0 02             	shl    $0x2,%eax
  1041bd:	89 c2                	mov    %eax,%edx
  1041bf:	a1 64 89 11 00       	mov    0x118964,%eax
  1041c4:	01 d0                	add    %edx,%eax
  1041c6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1041c9:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1041d0:	77 23                	ja     1041f5 <page_init+0x24d>
  1041d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041d9:	c7 44 24 08 20 6d 10 	movl   $0x106d20,0x8(%esp)
  1041e0:	00 
  1041e1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1041e8:	00 
  1041e9:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1041f0:	e8 cb ca ff ff       	call   100cc0 <__panic>
  1041f5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041f8:	05 00 00 00 40       	add    $0x40000000,%eax
  1041fd:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104200:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104207:	e9 74 01 00 00       	jmp    104380 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10420c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10420f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104212:	89 d0                	mov    %edx,%eax
  104214:	c1 e0 02             	shl    $0x2,%eax
  104217:	01 d0                	add    %edx,%eax
  104219:	c1 e0 02             	shl    $0x2,%eax
  10421c:	01 c8                	add    %ecx,%eax
  10421e:	8b 50 08             	mov    0x8(%eax),%edx
  104221:	8b 40 04             	mov    0x4(%eax),%eax
  104224:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104227:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10422a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104230:	89 d0                	mov    %edx,%eax
  104232:	c1 e0 02             	shl    $0x2,%eax
  104235:	01 d0                	add    %edx,%eax
  104237:	c1 e0 02             	shl    $0x2,%eax
  10423a:	01 c8                	add    %ecx,%eax
  10423c:	8b 48 0c             	mov    0xc(%eax),%ecx
  10423f:	8b 58 10             	mov    0x10(%eax),%ebx
  104242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104245:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104248:	01 c8                	add    %ecx,%eax
  10424a:	11 da                	adc    %ebx,%edx
  10424c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10424f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104252:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104255:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104258:	89 d0                	mov    %edx,%eax
  10425a:	c1 e0 02             	shl    $0x2,%eax
  10425d:	01 d0                	add    %edx,%eax
  10425f:	c1 e0 02             	shl    $0x2,%eax
  104262:	01 c8                	add    %ecx,%eax
  104264:	83 c0 14             	add    $0x14,%eax
  104267:	8b 00                	mov    (%eax),%eax
  104269:	83 f8 01             	cmp    $0x1,%eax
  10426c:	0f 85 0a 01 00 00    	jne    10437c <page_init+0x3d4>
            if (begin < freemem) {
  104272:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104275:	ba 00 00 00 00       	mov    $0x0,%edx
  10427a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10427d:	72 17                	jb     104296 <page_init+0x2ee>
  10427f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104282:	77 05                	ja     104289 <page_init+0x2e1>
  104284:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104287:	76 0d                	jbe    104296 <page_init+0x2ee>
                begin = freemem;
  104289:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10428c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10428f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104296:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10429a:	72 1d                	jb     1042b9 <page_init+0x311>
  10429c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1042a0:	77 09                	ja     1042ab <page_init+0x303>
  1042a2:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1042a9:	76 0e                	jbe    1042b9 <page_init+0x311>
                end = KMEMSIZE;
  1042ab:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042b2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042bf:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042c2:	0f 87 b4 00 00 00    	ja     10437c <page_init+0x3d4>
  1042c8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042cb:	72 09                	jb     1042d6 <page_init+0x32e>
  1042cd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042d0:	0f 83 a6 00 00 00    	jae    10437c <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1042d6:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1042dd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1042e3:	01 d0                	add    %edx,%eax
  1042e5:	83 e8 01             	sub    $0x1,%eax
  1042e8:	89 45 98             	mov    %eax,-0x68(%ebp)
  1042eb:	8b 45 98             	mov    -0x68(%ebp),%eax
  1042ee:	ba 00 00 00 00       	mov    $0x0,%edx
  1042f3:	f7 75 9c             	divl   -0x64(%ebp)
  1042f6:	89 d0                	mov    %edx,%eax
  1042f8:	8b 55 98             	mov    -0x68(%ebp),%edx
  1042fb:	29 c2                	sub    %eax,%edx
  1042fd:	89 d0                	mov    %edx,%eax
  1042ff:	ba 00 00 00 00       	mov    $0x0,%edx
  104304:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104307:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10430a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10430d:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104310:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104313:	ba 00 00 00 00       	mov    $0x0,%edx
  104318:	89 c7                	mov    %eax,%edi
  10431a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104320:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104323:	89 d0                	mov    %edx,%eax
  104325:	83 e0 00             	and    $0x0,%eax
  104328:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10432b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10432e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104331:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104334:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104337:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10433a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10433d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104340:	77 3a                	ja     10437c <page_init+0x3d4>
  104342:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104345:	72 05                	jb     10434c <page_init+0x3a4>
  104347:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10434a:	73 30                	jae    10437c <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10434c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10434f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104352:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104355:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104358:	29 c8                	sub    %ecx,%eax
  10435a:	19 da                	sbb    %ebx,%edx
  10435c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104360:	c1 ea 0c             	shr    $0xc,%edx
  104363:	89 c3                	mov    %eax,%ebx
  104365:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104368:	89 04 24             	mov    %eax,(%esp)
  10436b:	e8 bd f8 ff ff       	call   103c2d <pa2page>
  104370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104374:	89 04 24             	mov    %eax,(%esp)
  104377:	e8 78 fb ff ff       	call   103ef4 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10437c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104380:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104383:	8b 00                	mov    (%eax),%eax
  104385:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104388:	0f 8f 7e fe ff ff    	jg     10420c <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10438e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104394:	5b                   	pop    %ebx
  104395:	5e                   	pop    %esi
  104396:	5f                   	pop    %edi
  104397:	5d                   	pop    %ebp
  104398:	c3                   	ret    

00104399 <enable_paging>:

static void
enable_paging(void) {
  104399:	55                   	push   %ebp
  10439a:	89 e5                	mov    %esp,%ebp
  10439c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10439f:	a1 60 89 11 00       	mov    0x118960,%eax
  1043a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1043a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1043aa:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1043ad:	0f 20 c0             	mov    %cr0,%eax
  1043b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1043b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1043b9:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1043c0:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1043c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1043ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043cd:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1043d0:	c9                   	leave  
  1043d1:	c3                   	ret    

001043d2 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043d2:	55                   	push   %ebp
  1043d3:	89 e5                	mov    %esp,%ebp
  1043d5:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043d8:	8b 45 14             	mov    0x14(%ebp),%eax
  1043db:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043de:	31 d0                	xor    %edx,%eax
  1043e0:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043e5:	85 c0                	test   %eax,%eax
  1043e7:	74 24                	je     10440d <boot_map_segment+0x3b>
  1043e9:	c7 44 24 0c 52 6d 10 	movl   $0x106d52,0xc(%esp)
  1043f0:	00 
  1043f1:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1043f8:	00 
  1043f9:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104400:	00 
  104401:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104408:	e8 b3 c8 ff ff       	call   100cc0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10440d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104414:	8b 45 0c             	mov    0xc(%ebp),%eax
  104417:	25 ff 0f 00 00       	and    $0xfff,%eax
  10441c:	89 c2                	mov    %eax,%edx
  10441e:	8b 45 10             	mov    0x10(%ebp),%eax
  104421:	01 c2                	add    %eax,%edx
  104423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104426:	01 d0                	add    %edx,%eax
  104428:	83 e8 01             	sub    $0x1,%eax
  10442b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10442e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104431:	ba 00 00 00 00       	mov    $0x0,%edx
  104436:	f7 75 f0             	divl   -0x10(%ebp)
  104439:	89 d0                	mov    %edx,%eax
  10443b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10443e:	29 c2                	sub    %eax,%edx
  104440:	89 d0                	mov    %edx,%eax
  104442:	c1 e8 0c             	shr    $0xc,%eax
  104445:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104448:	8b 45 0c             	mov    0xc(%ebp),%eax
  10444b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10444e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104456:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104459:	8b 45 14             	mov    0x14(%ebp),%eax
  10445c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10445f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104467:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10446a:	eb 6b                	jmp    1044d7 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10446c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104473:	00 
  104474:	8b 45 0c             	mov    0xc(%ebp),%eax
  104477:	89 44 24 04          	mov    %eax,0x4(%esp)
  10447b:	8b 45 08             	mov    0x8(%ebp),%eax
  10447e:	89 04 24             	mov    %eax,(%esp)
  104481:	e8 cc 01 00 00       	call   104652 <get_pte>
  104486:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104489:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10448d:	75 24                	jne    1044b3 <boot_map_segment+0xe1>
  10448f:	c7 44 24 0c 7e 6d 10 	movl   $0x106d7e,0xc(%esp)
  104496:	00 
  104497:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  10449e:	00 
  10449f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1044a6:	00 
  1044a7:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1044ae:	e8 0d c8 ff ff       	call   100cc0 <__panic>
        *ptep = pa | PTE_P | perm;
  1044b3:	8b 45 18             	mov    0x18(%ebp),%eax
  1044b6:	8b 55 14             	mov    0x14(%ebp),%edx
  1044b9:	09 d0                	or     %edx,%eax
  1044bb:	83 c8 01             	or     $0x1,%eax
  1044be:	89 c2                	mov    %eax,%edx
  1044c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044c3:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044c5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1044c9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044d0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044db:	75 8f                	jne    10446c <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1044dd:	c9                   	leave  
  1044de:	c3                   	ret    

001044df <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044df:	55                   	push   %ebp
  1044e0:	89 e5                	mov    %esp,%ebp
  1044e2:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044ec:	e8 22 fa ff ff       	call   103f13 <alloc_pages>
  1044f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044f8:	75 1c                	jne    104516 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044fa:	c7 44 24 08 8b 6d 10 	movl   $0x106d8b,0x8(%esp)
  104501:	00 
  104502:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104509:	00 
  10450a:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104511:	e8 aa c7 ff ff       	call   100cc0 <__panic>
    }
    return page2kva(p);
  104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104519:	89 04 24             	mov    %eax,(%esp)
  10451c:	e8 5b f7 ff ff       	call   103c7c <page2kva>
}
  104521:	c9                   	leave  
  104522:	c3                   	ret    

00104523 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104523:	55                   	push   %ebp
  104524:	89 e5                	mov    %esp,%ebp
  104526:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104529:	e8 93 f9 ff ff       	call   103ec1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10452e:	e8 75 fa ff ff       	call   103fa8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104533:	e8 6b 04 00 00       	call   1049a3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104538:	e8 a2 ff ff ff       	call   1044df <boot_alloc_page>
  10453d:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104542:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104547:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10454e:	00 
  10454f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104556:	00 
  104557:	89 04 24             	mov    %eax,(%esp)
  10455a:	e8 ad 1a 00 00       	call   10600c <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10455f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104567:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10456e:	77 23                	ja     104593 <pmm_init+0x70>
  104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104573:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104577:	c7 44 24 08 20 6d 10 	movl   $0x106d20,0x8(%esp)
  10457e:	00 
  10457f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104586:	00 
  104587:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10458e:	e8 2d c7 ff ff       	call   100cc0 <__panic>
  104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104596:	05 00 00 00 40       	add    $0x40000000,%eax
  10459b:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1045a0:	e8 1c 04 00 00       	call   1049c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1045a5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045aa:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1045b0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045b8:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1045bf:	77 23                	ja     1045e4 <pmm_init+0xc1>
  1045c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045c8:	c7 44 24 08 20 6d 10 	movl   $0x106d20,0x8(%esp)
  1045cf:	00 
  1045d0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1045d7:	00 
  1045d8:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1045df:	e8 dc c6 ff ff       	call   100cc0 <__panic>
  1045e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045e7:	05 00 00 00 40       	add    $0x40000000,%eax
  1045ec:	83 c8 03             	or     $0x3,%eax
  1045ef:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045f1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045f6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045fd:	00 
  1045fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104605:	00 
  104606:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10460d:	38 
  10460e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104615:	c0 
  104616:	89 04 24             	mov    %eax,(%esp)
  104619:	e8 b4 fd ff ff       	call   1043d2 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10461e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104623:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104629:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10462f:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104631:	e8 63 fd ff ff       	call   104399 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104636:	e8 97 f7 ff ff       	call   103dd2 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10463b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104646:	e8 11 0a 00 00       	call   10505c <check_boot_pgdir>

    print_pgdir();
  10464b:	e8 9e 0e 00 00       	call   1054ee <print_pgdir>

}
  104650:	c9                   	leave  
  104651:	c3                   	ret    

00104652 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104652:	55                   	push   %ebp
  104653:	89 e5                	mov    %esp,%ebp
  104655:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t* entry = &pgdir[PDX(la)];
  104658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465b:	c1 e8 16             	shr    $0x16,%eax
  10465e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104665:	8b 45 08             	mov    0x8(%ebp),%eax
  104668:	01 d0                	add    %edx,%eax
  10466a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*entry & PTE_P))
  10466d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104670:	8b 00                	mov    (%eax),%eax
  104672:	83 e0 01             	and    $0x1,%eax
  104675:	85 c0                	test   %eax,%eax
  104677:	0f 85 af 00 00 00    	jne    10472c <get_pte+0xda>
    {
    	struct Page* p;
    	if((!create) || ((p = alloc_page()) == NULL))
  10467d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104681:	74 15                	je     104698 <get_pte+0x46>
  104683:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10468a:	e8 84 f8 ff ff       	call   103f13 <alloc_pages>
  10468f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104696:	75 0a                	jne    1046a2 <get_pte+0x50>
    	{
    		return NULL;
  104698:	b8 00 00 00 00       	mov    $0x0,%eax
  10469d:	e9 e6 00 00 00       	jmp    104788 <get_pte+0x136>
    	}
    	set_page_ref(p, 1);
  1046a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046a9:	00 
  1046aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ad:	89 04 24             	mov    %eax,(%esp)
  1046b0:	e8 63 f6 ff ff       	call   103d18 <set_page_ref>
    	uintptr_t pg_addr = page2pa(p);
  1046b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046b8:	89 04 24             	mov    %eax,(%esp)
  1046bb:	e8 57 f5 ff ff       	call   103c17 <page2pa>
  1046c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pg_addr), 0, PGSIZE);
  1046c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1046c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046cc:	c1 e8 0c             	shr    $0xc,%eax
  1046cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046d2:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1046da:	72 23                	jb     1046ff <get_pte+0xad>
  1046dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046e3:	c7 44 24 08 7c 6c 10 	movl   $0x106c7c,0x8(%esp)
  1046ea:	00 
  1046eb:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  1046f2:	00 
  1046f3:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1046fa:	e8 c1 c5 ff ff       	call   100cc0 <__panic>
  1046ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104702:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104707:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10470e:	00 
  10470f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104716:	00 
  104717:	89 04 24             	mov    %eax,(%esp)
  10471a:	e8 ed 18 00 00       	call   10600c <memset>
    	*entry = pg_addr | PTE_U | PTE_W | PTE_P;
  10471f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104722:	83 c8 07             	or     $0x7,%eax
  104725:	89 c2                	mov    %eax,%edx
  104727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472a:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t*)KADDR(PDE_ADDR(*entry)))[PTX(la)];
  10472c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472f:	8b 00                	mov    (%eax),%eax
  104731:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104736:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10473c:	c1 e8 0c             	shr    $0xc,%eax
  10473f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104742:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104747:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10474a:	72 23                	jb     10476f <get_pte+0x11d>
  10474c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10474f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104753:	c7 44 24 08 7c 6c 10 	movl   $0x106c7c,0x8(%esp)
  10475a:	00 
  10475b:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  104762:	00 
  104763:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10476a:	e8 51 c5 ff ff       	call   100cc0 <__panic>
  10476f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104772:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104777:	8b 55 0c             	mov    0xc(%ebp),%edx
  10477a:	c1 ea 0c             	shr    $0xc,%edx
  10477d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104783:	c1 e2 02             	shl    $0x2,%edx
  104786:	01 d0                	add    %edx,%eax
}
  104788:	c9                   	leave  
  104789:	c3                   	ret    

0010478a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10478a:	55                   	push   %ebp
  10478b:	89 e5                	mov    %esp,%ebp
  10478d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104790:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104797:	00 
  104798:	8b 45 0c             	mov    0xc(%ebp),%eax
  10479b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10479f:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a2:	89 04 24             	mov    %eax,(%esp)
  1047a5:	e8 a8 fe ff ff       	call   104652 <get_pte>
  1047aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1047ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1047b1:	74 08                	je     1047bb <get_page+0x31>
        *ptep_store = ptep;
  1047b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1047b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047b9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1047bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047bf:	74 1b                	je     1047dc <get_page+0x52>
  1047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c4:	8b 00                	mov    (%eax),%eax
  1047c6:	83 e0 01             	and    $0x1,%eax
  1047c9:	85 c0                	test   %eax,%eax
  1047cb:	74 0f                	je     1047dc <get_page+0x52>
        return pa2page(*ptep);
  1047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d0:	8b 00                	mov    (%eax),%eax
  1047d2:	89 04 24             	mov    %eax,(%esp)
  1047d5:	e8 53 f4 ff ff       	call   103c2d <pa2page>
  1047da:	eb 05                	jmp    1047e1 <get_page+0x57>
    }
    return NULL;
  1047dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047e1:	c9                   	leave  
  1047e2:	c3                   	ret    

001047e3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1047e3:	55                   	push   %ebp
  1047e4:	89 e5                	mov    %esp,%ebp
  1047e6:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
  1047e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1047ec:	8b 00                	mov    (%eax),%eax
  1047ee:	83 e0 01             	and    $0x1,%eax
  1047f1:	85 c0                	test   %eax,%eax
  1047f3:	74 52                	je     104847 <page_remove_pte+0x64>
    {
    	struct Page* page = pte2page(*ptep);
  1047f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1047f8:	8b 00                	mov    (%eax),%eax
  1047fa:	89 04 24             	mov    %eax,(%esp)
  1047fd:	e8 ce f4 ff ff       	call   103cd0 <pte2page>
  104802:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	int re = page_ref_dec(page);
  104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104808:	89 04 24             	mov    %eax,(%esp)
  10480b:	e8 2c f5 ff ff       	call   103d3c <page_ref_dec>
  104810:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(re == 0)
  104813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104817:	75 13                	jne    10482c <page_remove_pte+0x49>
    	{
    		free_page(page);
  104819:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104820:	00 
  104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104824:	89 04 24             	mov    %eax,(%esp)
  104827:	e8 1f f7 ff ff       	call   103f4b <free_pages>
    	}
    	*ptep = 0;
  10482c:	8b 45 10             	mov    0x10(%ebp),%eax
  10482f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir, la);
  104835:	8b 45 0c             	mov    0xc(%ebp),%eax
  104838:	89 44 24 04          	mov    %eax,0x4(%esp)
  10483c:	8b 45 08             	mov    0x8(%ebp),%eax
  10483f:	89 04 24             	mov    %eax,(%esp)
  104842:	e8 ff 00 00 00       	call   104946 <tlb_invalidate>
    }
}
  104847:	c9                   	leave  
  104848:	c3                   	ret    

00104849 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104849:	55                   	push   %ebp
  10484a:	89 e5                	mov    %esp,%ebp
  10484c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10484f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104856:	00 
  104857:	8b 45 0c             	mov    0xc(%ebp),%eax
  10485a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10485e:	8b 45 08             	mov    0x8(%ebp),%eax
  104861:	89 04 24             	mov    %eax,(%esp)
  104864:	e8 e9 fd ff ff       	call   104652 <get_pte>
  104869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10486c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104870:	74 19                	je     10488b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104875:	89 44 24 08          	mov    %eax,0x8(%esp)
  104879:	8b 45 0c             	mov    0xc(%ebp),%eax
  10487c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104880:	8b 45 08             	mov    0x8(%ebp),%eax
  104883:	89 04 24             	mov    %eax,(%esp)
  104886:	e8 58 ff ff ff       	call   1047e3 <page_remove_pte>
    }
}
  10488b:	c9                   	leave  
  10488c:	c3                   	ret    

0010488d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10488d:	55                   	push   %ebp
  10488e:	89 e5                	mov    %esp,%ebp
  104890:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104893:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10489a:	00 
  10489b:	8b 45 10             	mov    0x10(%ebp),%eax
  10489e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a5:	89 04 24             	mov    %eax,(%esp)
  1048a8:	e8 a5 fd ff ff       	call   104652 <get_pte>
  1048ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1048b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048b4:	75 0a                	jne    1048c0 <page_insert+0x33>
        return -E_NO_MEM;
  1048b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1048bb:	e9 84 00 00 00       	jmp    104944 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1048c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048c3:	89 04 24             	mov    %eax,(%esp)
  1048c6:	e8 5a f4 ff ff       	call   103d25 <page_ref_inc>
    if (*ptep & PTE_P) {
  1048cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ce:	8b 00                	mov    (%eax),%eax
  1048d0:	83 e0 01             	and    $0x1,%eax
  1048d3:	85 c0                	test   %eax,%eax
  1048d5:	74 3e                	je     104915 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048da:	8b 00                	mov    (%eax),%eax
  1048dc:	89 04 24             	mov    %eax,(%esp)
  1048df:	e8 ec f3 ff ff       	call   103cd0 <pte2page>
  1048e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1048e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1048ed:	75 0d                	jne    1048fc <page_insert+0x6f>
            page_ref_dec(page);
  1048ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048f2:	89 04 24             	mov    %eax,(%esp)
  1048f5:	e8 42 f4 ff ff       	call   103d3c <page_ref_dec>
  1048fa:	eb 19                	jmp    104915 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  104903:	8b 45 10             	mov    0x10(%ebp),%eax
  104906:	89 44 24 04          	mov    %eax,0x4(%esp)
  10490a:	8b 45 08             	mov    0x8(%ebp),%eax
  10490d:	89 04 24             	mov    %eax,(%esp)
  104910:	e8 ce fe ff ff       	call   1047e3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104915:	8b 45 0c             	mov    0xc(%ebp),%eax
  104918:	89 04 24             	mov    %eax,(%esp)
  10491b:	e8 f7 f2 ff ff       	call   103c17 <page2pa>
  104920:	0b 45 14             	or     0x14(%ebp),%eax
  104923:	83 c8 01             	or     $0x1,%eax
  104926:	89 c2                	mov    %eax,%edx
  104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10492b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10492d:	8b 45 10             	mov    0x10(%ebp),%eax
  104930:	89 44 24 04          	mov    %eax,0x4(%esp)
  104934:	8b 45 08             	mov    0x8(%ebp),%eax
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 07 00 00 00       	call   104946 <tlb_invalidate>
    return 0;
  10493f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104944:	c9                   	leave  
  104945:	c3                   	ret    

00104946 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104946:	55                   	push   %ebp
  104947:	89 e5                	mov    %esp,%ebp
  104949:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10494c:	0f 20 d8             	mov    %cr3,%eax
  10494f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104952:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104955:	89 c2                	mov    %eax,%edx
  104957:	8b 45 08             	mov    0x8(%ebp),%eax
  10495a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10495d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104964:	77 23                	ja     104989 <tlb_invalidate+0x43>
  104966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104969:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10496d:	c7 44 24 08 20 6d 10 	movl   $0x106d20,0x8(%esp)
  104974:	00 
  104975:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  10497c:	00 
  10497d:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104984:	e8 37 c3 ff ff       	call   100cc0 <__panic>
  104989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10498c:	05 00 00 00 40       	add    $0x40000000,%eax
  104991:	39 c2                	cmp    %eax,%edx
  104993:	75 0c                	jne    1049a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104995:	8b 45 0c             	mov    0xc(%ebp),%eax
  104998:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10499b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10499e:	0f 01 38             	invlpg (%eax)
    }
}
  1049a1:	c9                   	leave  
  1049a2:	c3                   	ret    

001049a3 <check_alloc_page>:

static void
check_alloc_page(void) {
  1049a3:	55                   	push   %ebp
  1049a4:	89 e5                	mov    %esp,%ebp
  1049a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1049a9:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1049ae:	8b 40 18             	mov    0x18(%eax),%eax
  1049b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1049b3:	c7 04 24 a4 6d 10 00 	movl   $0x106da4,(%esp)
  1049ba:	e8 7d b9 ff ff       	call   10033c <cprintf>
}
  1049bf:	c9                   	leave  
  1049c0:	c3                   	ret    

001049c1 <check_pgdir>:

static void
check_pgdir(void) {
  1049c1:	55                   	push   %ebp
  1049c2:	89 e5                	mov    %esp,%ebp
  1049c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1049c7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1049cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1049d1:	76 24                	jbe    1049f7 <check_pgdir+0x36>
  1049d3:	c7 44 24 0c c3 6d 10 	movl   $0x106dc3,0xc(%esp)
  1049da:	00 
  1049db:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1049e2:	00 
  1049e3:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1049ea:	00 
  1049eb:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1049f2:	e8 c9 c2 ff ff       	call   100cc0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1049f7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049fc:	85 c0                	test   %eax,%eax
  1049fe:	74 0e                	je     104a0e <check_pgdir+0x4d>
  104a00:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a05:	25 ff 0f 00 00       	and    $0xfff,%eax
  104a0a:	85 c0                	test   %eax,%eax
  104a0c:	74 24                	je     104a32 <check_pgdir+0x71>
  104a0e:	c7 44 24 0c e0 6d 10 	movl   $0x106de0,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104a2d:	e8 8e c2 ff ff       	call   100cc0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104a32:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a3e:	00 
  104a3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a46:	00 
  104a47:	89 04 24             	mov    %eax,(%esp)
  104a4a:	e8 3b fd ff ff       	call   10478a <get_page>
  104a4f:	85 c0                	test   %eax,%eax
  104a51:	74 24                	je     104a77 <check_pgdir+0xb6>
  104a53:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104a5a:	00 
  104a5b:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104a62:	00 
  104a63:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104a6a:	00 
  104a6b:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104a72:	e8 49 c2 ff ff       	call   100cc0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a7e:	e8 90 f4 ff ff       	call   103f13 <alloc_pages>
  104a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a86:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a8b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a92:	00 
  104a93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a9a:	00 
  104a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a9e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104aa2:	89 04 24             	mov    %eax,(%esp)
  104aa5:	e8 e3 fd ff ff       	call   10488d <page_insert>
  104aaa:	85 c0                	test   %eax,%eax
  104aac:	74 24                	je     104ad2 <check_pgdir+0x111>
  104aae:	c7 44 24 0c 40 6e 10 	movl   $0x106e40,0xc(%esp)
  104ab5:	00 
  104ab6:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104abd:	00 
  104abe:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104ac5:	00 
  104ac6:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104acd:	e8 ee c1 ff ff       	call   100cc0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104ad2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ad7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ade:	00 
  104adf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ae6:	00 
  104ae7:	89 04 24             	mov    %eax,(%esp)
  104aea:	e8 63 fb ff ff       	call   104652 <get_pte>
  104aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104af6:	75 24                	jne    104b1c <check_pgdir+0x15b>
  104af8:	c7 44 24 0c 6c 6e 10 	movl   $0x106e6c,0xc(%esp)
  104aff:	00 
  104b00:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104b07:	00 
  104b08:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104b0f:	00 
  104b10:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104b17:	e8 a4 c1 ff ff       	call   100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
  104b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b1f:	8b 00                	mov    (%eax),%eax
  104b21:	89 04 24             	mov    %eax,(%esp)
  104b24:	e8 04 f1 ff ff       	call   103c2d <pa2page>
  104b29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b2c:	74 24                	je     104b52 <check_pgdir+0x191>
  104b2e:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104b35:	00 
  104b36:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104b45:	00 
  104b46:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104b4d:	e8 6e c1 ff ff       	call   100cc0 <__panic>
    assert(page_ref(p1) == 1);
  104b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b55:	89 04 24             	mov    %eax,(%esp)
  104b58:	e8 b1 f1 ff ff       	call   103d0e <page_ref>
  104b5d:	83 f8 01             	cmp    $0x1,%eax
  104b60:	74 24                	je     104b86 <check_pgdir+0x1c5>
  104b62:	c7 44 24 0c ae 6e 10 	movl   $0x106eae,0xc(%esp)
  104b69:	00 
  104b6a:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104b71:	00 
  104b72:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104b79:	00 
  104b7a:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104b81:	e8 3a c1 ff ff       	call   100cc0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b86:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b8b:	8b 00                	mov    (%eax),%eax
  104b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b98:	c1 e8 0c             	shr    $0xc,%eax
  104b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b9e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104ba3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104ba6:	72 23                	jb     104bcb <check_pgdir+0x20a>
  104ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104baf:	c7 44 24 08 7c 6c 10 	movl   $0x106c7c,0x8(%esp)
  104bb6:	00 
  104bb7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104bbe:	00 
  104bbf:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104bc6:	e8 f5 c0 ff ff       	call   100cc0 <__panic>
  104bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bce:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104bd3:	83 c0 04             	add    $0x4,%eax
  104bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104bd9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bde:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104be5:	00 
  104be6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bed:	00 
  104bee:	89 04 24             	mov    %eax,(%esp)
  104bf1:	e8 5c fa ff ff       	call   104652 <get_pte>
  104bf6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104bf9:	74 24                	je     104c1f <check_pgdir+0x25e>
  104bfb:	c7 44 24 0c c0 6e 10 	movl   $0x106ec0,0xc(%esp)
  104c02:	00 
  104c03:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104c0a:	00 
  104c0b:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c12:	00 
  104c13:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104c1a:	e8 a1 c0 ff ff       	call   100cc0 <__panic>

    p2 = alloc_page();
  104c1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c26:	e8 e8 f2 ff ff       	call   103f13 <alloc_pages>
  104c2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104c2e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c33:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104c3a:	00 
  104c3b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c42:	00 
  104c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c46:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c4a:	89 04 24             	mov    %eax,(%esp)
  104c4d:	e8 3b fc ff ff       	call   10488d <page_insert>
  104c52:	85 c0                	test   %eax,%eax
  104c54:	74 24                	je     104c7a <check_pgdir+0x2b9>
  104c56:	c7 44 24 0c e8 6e 10 	movl   $0x106ee8,0xc(%esp)
  104c5d:	00 
  104c5e:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104c65:	00 
  104c66:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104c6d:	00 
  104c6e:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104c75:	e8 46 c0 ff ff       	call   100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c7a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c86:	00 
  104c87:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c8e:	00 
  104c8f:	89 04 24             	mov    %eax,(%esp)
  104c92:	e8 bb f9 ff ff       	call   104652 <get_pte>
  104c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c9e:	75 24                	jne    104cc4 <check_pgdir+0x303>
  104ca0:	c7 44 24 0c 20 6f 10 	movl   $0x106f20,0xc(%esp)
  104ca7:	00 
  104ca8:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104caf:	00 
  104cb0:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104cb7:	00 
  104cb8:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104cbf:	e8 fc bf ff ff       	call   100cc0 <__panic>
    assert(*ptep & PTE_U);
  104cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cc7:	8b 00                	mov    (%eax),%eax
  104cc9:	83 e0 04             	and    $0x4,%eax
  104ccc:	85 c0                	test   %eax,%eax
  104cce:	75 24                	jne    104cf4 <check_pgdir+0x333>
  104cd0:	c7 44 24 0c 50 6f 10 	movl   $0x106f50,0xc(%esp)
  104cd7:	00 
  104cd8:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104cdf:	00 
  104ce0:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104ce7:	00 
  104ce8:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104cef:	e8 cc bf ff ff       	call   100cc0 <__panic>
    assert(*ptep & PTE_W);
  104cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cf7:	8b 00                	mov    (%eax),%eax
  104cf9:	83 e0 02             	and    $0x2,%eax
  104cfc:	85 c0                	test   %eax,%eax
  104cfe:	75 24                	jne    104d24 <check_pgdir+0x363>
  104d00:	c7 44 24 0c 5e 6f 10 	movl   $0x106f5e,0xc(%esp)
  104d07:	00 
  104d08:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104d0f:	00 
  104d10:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104d17:	00 
  104d18:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104d1f:	e8 9c bf ff ff       	call   100cc0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104d24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d29:	8b 00                	mov    (%eax),%eax
  104d2b:	83 e0 04             	and    $0x4,%eax
  104d2e:	85 c0                	test   %eax,%eax
  104d30:	75 24                	jne    104d56 <check_pgdir+0x395>
  104d32:	c7 44 24 0c 6c 6f 10 	movl   $0x106f6c,0xc(%esp)
  104d39:	00 
  104d3a:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104d41:	00 
  104d42:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104d49:	00 
  104d4a:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104d51:	e8 6a bf ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 1);
  104d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d59:	89 04 24             	mov    %eax,(%esp)
  104d5c:	e8 ad ef ff ff       	call   103d0e <page_ref>
  104d61:	83 f8 01             	cmp    $0x1,%eax
  104d64:	74 24                	je     104d8a <check_pgdir+0x3c9>
  104d66:	c7 44 24 0c 82 6f 10 	movl   $0x106f82,0xc(%esp)
  104d6d:	00 
  104d6e:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104d75:	00 
  104d76:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104d7d:	00 
  104d7e:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104d85:	e8 36 bf ff ff       	call   100cc0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d8a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d96:	00 
  104d97:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d9e:	00 
  104d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104da2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104da6:	89 04 24             	mov    %eax,(%esp)
  104da9:	e8 df fa ff ff       	call   10488d <page_insert>
  104dae:	85 c0                	test   %eax,%eax
  104db0:	74 24                	je     104dd6 <check_pgdir+0x415>
  104db2:	c7 44 24 0c 94 6f 10 	movl   $0x106f94,0xc(%esp)
  104db9:	00 
  104dba:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104dc1:	00 
  104dc2:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104dc9:	00 
  104dca:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104dd1:	e8 ea be ff ff       	call   100cc0 <__panic>
    assert(page_ref(p1) == 2);
  104dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dd9:	89 04 24             	mov    %eax,(%esp)
  104ddc:	e8 2d ef ff ff       	call   103d0e <page_ref>
  104de1:	83 f8 02             	cmp    $0x2,%eax
  104de4:	74 24                	je     104e0a <check_pgdir+0x449>
  104de6:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  104ded:	00 
  104dee:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104df5:	00 
  104df6:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104dfd:	00 
  104dfe:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104e05:	e8 b6 be ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e0d:	89 04 24             	mov    %eax,(%esp)
  104e10:	e8 f9 ee ff ff       	call   103d0e <page_ref>
  104e15:	85 c0                	test   %eax,%eax
  104e17:	74 24                	je     104e3d <check_pgdir+0x47c>
  104e19:	c7 44 24 0c d2 6f 10 	movl   $0x106fd2,0xc(%esp)
  104e20:	00 
  104e21:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104e28:	00 
  104e29:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104e30:	00 
  104e31:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104e38:	e8 83 be ff ff       	call   100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104e3d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e49:	00 
  104e4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e51:	00 
  104e52:	89 04 24             	mov    %eax,(%esp)
  104e55:	e8 f8 f7 ff ff       	call   104652 <get_pte>
  104e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e61:	75 24                	jne    104e87 <check_pgdir+0x4c6>
  104e63:	c7 44 24 0c 20 6f 10 	movl   $0x106f20,0xc(%esp)
  104e6a:	00 
  104e6b:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104e72:	00 
  104e73:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104e7a:	00 
  104e7b:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104e82:	e8 39 be ff ff       	call   100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
  104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e8a:	8b 00                	mov    (%eax),%eax
  104e8c:	89 04 24             	mov    %eax,(%esp)
  104e8f:	e8 99 ed ff ff       	call   103c2d <pa2page>
  104e94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e97:	74 24                	je     104ebd <check_pgdir+0x4fc>
  104e99:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104ea0:	00 
  104ea1:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104ea8:	00 
  104ea9:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104eb0:	00 
  104eb1:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104eb8:	e8 03 be ff ff       	call   100cc0 <__panic>
    assert((*ptep & PTE_U) == 0);
  104ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ec0:	8b 00                	mov    (%eax),%eax
  104ec2:	83 e0 04             	and    $0x4,%eax
  104ec5:	85 c0                	test   %eax,%eax
  104ec7:	74 24                	je     104eed <check_pgdir+0x52c>
  104ec9:	c7 44 24 0c e4 6f 10 	movl   $0x106fe4,0xc(%esp)
  104ed0:	00 
  104ed1:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104ed8:	00 
  104ed9:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104ee0:	00 
  104ee1:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104ee8:	e8 d3 bd ff ff       	call   100cc0 <__panic>

    page_remove(boot_pgdir, 0x0);
  104eed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ef2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ef9:	00 
  104efa:	89 04 24             	mov    %eax,(%esp)
  104efd:	e8 47 f9 ff ff       	call   104849 <page_remove>
    assert(page_ref(p1) == 1);
  104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f05:	89 04 24             	mov    %eax,(%esp)
  104f08:	e8 01 ee ff ff       	call   103d0e <page_ref>
  104f0d:	83 f8 01             	cmp    $0x1,%eax
  104f10:	74 24                	je     104f36 <check_pgdir+0x575>
  104f12:	c7 44 24 0c ae 6e 10 	movl   $0x106eae,0xc(%esp)
  104f19:	00 
  104f1a:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104f21:	00 
  104f22:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104f29:	00 
  104f2a:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104f31:	e8 8a bd ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f39:	89 04 24             	mov    %eax,(%esp)
  104f3c:	e8 cd ed ff ff       	call   103d0e <page_ref>
  104f41:	85 c0                	test   %eax,%eax
  104f43:	74 24                	je     104f69 <check_pgdir+0x5a8>
  104f45:	c7 44 24 0c d2 6f 10 	movl   $0x106fd2,0xc(%esp)
  104f4c:	00 
  104f4d:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104f54:	00 
  104f55:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104f5c:	00 
  104f5d:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104f64:	e8 57 bd ff ff       	call   100cc0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104f69:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f75:	00 
  104f76:	89 04 24             	mov    %eax,(%esp)
  104f79:	e8 cb f8 ff ff       	call   104849 <page_remove>
    assert(page_ref(p1) == 0);
  104f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f81:	89 04 24             	mov    %eax,(%esp)
  104f84:	e8 85 ed ff ff       	call   103d0e <page_ref>
  104f89:	85 c0                	test   %eax,%eax
  104f8b:	74 24                	je     104fb1 <check_pgdir+0x5f0>
  104f8d:	c7 44 24 0c f9 6f 10 	movl   $0x106ff9,0xc(%esp)
  104f94:	00 
  104f95:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104f9c:	00 
  104f9d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104fa4:	00 
  104fa5:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104fac:	e8 0f bd ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fb4:	89 04 24             	mov    %eax,(%esp)
  104fb7:	e8 52 ed ff ff       	call   103d0e <page_ref>
  104fbc:	85 c0                	test   %eax,%eax
  104fbe:	74 24                	je     104fe4 <check_pgdir+0x623>
  104fc0:	c7 44 24 0c d2 6f 10 	movl   $0x106fd2,0xc(%esp)
  104fc7:	00 
  104fc8:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  104fcf:	00 
  104fd0:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104fd7:	00 
  104fd8:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  104fdf:	e8 dc bc ff ff       	call   100cc0 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104fe4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fe9:	8b 00                	mov    (%eax),%eax
  104feb:	89 04 24             	mov    %eax,(%esp)
  104fee:	e8 3a ec ff ff       	call   103c2d <pa2page>
  104ff3:	89 04 24             	mov    %eax,(%esp)
  104ff6:	e8 13 ed ff ff       	call   103d0e <page_ref>
  104ffb:	83 f8 01             	cmp    $0x1,%eax
  104ffe:	74 24                	je     105024 <check_pgdir+0x663>
  105000:	c7 44 24 0c 0c 70 10 	movl   $0x10700c,0xc(%esp)
  105007:	00 
  105008:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  10500f:	00 
  105010:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  105017:	00 
  105018:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10501f:	e8 9c bc ff ff       	call   100cc0 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  105024:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105029:	8b 00                	mov    (%eax),%eax
  10502b:	89 04 24             	mov    %eax,(%esp)
  10502e:	e8 fa eb ff ff       	call   103c2d <pa2page>
  105033:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10503a:	00 
  10503b:	89 04 24             	mov    %eax,(%esp)
  10503e:	e8 08 ef ff ff       	call   103f4b <free_pages>
    boot_pgdir[0] = 0;
  105043:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105048:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  10504e:	c7 04 24 32 70 10 00 	movl   $0x107032,(%esp)
  105055:	e8 e2 b2 ff ff       	call   10033c <cprintf>
}
  10505a:	c9                   	leave  
  10505b:	c3                   	ret    

0010505c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  10505c:	55                   	push   %ebp
  10505d:	89 e5                	mov    %esp,%ebp
  10505f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105069:	e9 ca 00 00 00       	jmp    105138 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  10506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105077:	c1 e8 0c             	shr    $0xc,%eax
  10507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10507d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  105082:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105085:	72 23                	jb     1050aa <check_boot_pgdir+0x4e>
  105087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10508a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10508e:	c7 44 24 08 7c 6c 10 	movl   $0x106c7c,0x8(%esp)
  105095:	00 
  105096:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  10509d:	00 
  10509e:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1050a5:	e8 16 bc ff ff       	call   100cc0 <__panic>
  1050aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1050b2:	89 c2                	mov    %eax,%edx
  1050b4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1050c0:	00 
  1050c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050c5:	89 04 24             	mov    %eax,(%esp)
  1050c8:	e8 85 f5 ff ff       	call   104652 <get_pte>
  1050cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1050d4:	75 24                	jne    1050fa <check_boot_pgdir+0x9e>
  1050d6:	c7 44 24 0c 4c 70 10 	movl   $0x10704c,0xc(%esp)
  1050dd:	00 
  1050de:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1050e5:	00 
  1050e6:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  1050ed:	00 
  1050ee:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1050f5:	e8 c6 bb ff ff       	call   100cc0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1050fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050fd:	8b 00                	mov    (%eax),%eax
  1050ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105104:	89 c2                	mov    %eax,%edx
  105106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105109:	39 c2                	cmp    %eax,%edx
  10510b:	74 24                	je     105131 <check_boot_pgdir+0xd5>
  10510d:	c7 44 24 0c 89 70 10 	movl   $0x107089,0xc(%esp)
  105114:	00 
  105115:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  10511c:	00 
  10511d:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  105124:	00 
  105125:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10512c:	e8 8f bb ff ff       	call   100cc0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105131:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10513b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  105140:	39 c2                	cmp    %eax,%edx
  105142:	0f 82 26 ff ff ff    	jb     10506e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105148:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10514d:	05 ac 0f 00 00       	add    $0xfac,%eax
  105152:	8b 00                	mov    (%eax),%eax
  105154:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105159:	89 c2                	mov    %eax,%edx
  10515b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105163:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  10516a:	77 23                	ja     10518f <check_boot_pgdir+0x133>
  10516c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10516f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105173:	c7 44 24 08 20 6d 10 	movl   $0x106d20,0x8(%esp)
  10517a:	00 
  10517b:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105182:	00 
  105183:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10518a:	e8 31 bb ff ff       	call   100cc0 <__panic>
  10518f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105192:	05 00 00 00 40       	add    $0x40000000,%eax
  105197:	39 c2                	cmp    %eax,%edx
  105199:	74 24                	je     1051bf <check_boot_pgdir+0x163>
  10519b:	c7 44 24 0c a0 70 10 	movl   $0x1070a0,0xc(%esp)
  1051a2:	00 
  1051a3:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1051aa:	00 
  1051ab:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1051b2:	00 
  1051b3:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1051ba:	e8 01 bb ff ff       	call   100cc0 <__panic>

    assert(boot_pgdir[0] == 0);
  1051bf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051c4:	8b 00                	mov    (%eax),%eax
  1051c6:	85 c0                	test   %eax,%eax
  1051c8:	74 24                	je     1051ee <check_boot_pgdir+0x192>
  1051ca:	c7 44 24 0c d4 70 10 	movl   $0x1070d4,0xc(%esp)
  1051d1:	00 
  1051d2:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1051d9:	00 
  1051da:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1051e1:	00 
  1051e2:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1051e9:	e8 d2 ba ff ff       	call   100cc0 <__panic>

    struct Page *p;
    p = alloc_page();
  1051ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051f5:	e8 19 ed ff ff       	call   103f13 <alloc_pages>
  1051fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1051fd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105202:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105209:	00 
  10520a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105211:	00 
  105212:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105215:	89 54 24 04          	mov    %edx,0x4(%esp)
  105219:	89 04 24             	mov    %eax,(%esp)
  10521c:	e8 6c f6 ff ff       	call   10488d <page_insert>
  105221:	85 c0                	test   %eax,%eax
  105223:	74 24                	je     105249 <check_boot_pgdir+0x1ed>
  105225:	c7 44 24 0c e8 70 10 	movl   $0x1070e8,0xc(%esp)
  10522c:	00 
  10522d:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  105234:	00 
  105235:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  10523c:	00 
  10523d:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  105244:	e8 77 ba ff ff       	call   100cc0 <__panic>
    assert(page_ref(p) == 1);
  105249:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10524c:	89 04 24             	mov    %eax,(%esp)
  10524f:	e8 ba ea ff ff       	call   103d0e <page_ref>
  105254:	83 f8 01             	cmp    $0x1,%eax
  105257:	74 24                	je     10527d <check_boot_pgdir+0x221>
  105259:	c7 44 24 0c 16 71 10 	movl   $0x107116,0xc(%esp)
  105260:	00 
  105261:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  105268:	00 
  105269:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105270:	00 
  105271:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  105278:	e8 43 ba ff ff       	call   100cc0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10527d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105282:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105289:	00 
  10528a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105291:	00 
  105292:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105295:	89 54 24 04          	mov    %edx,0x4(%esp)
  105299:	89 04 24             	mov    %eax,(%esp)
  10529c:	e8 ec f5 ff ff       	call   10488d <page_insert>
  1052a1:	85 c0                	test   %eax,%eax
  1052a3:	74 24                	je     1052c9 <check_boot_pgdir+0x26d>
  1052a5:	c7 44 24 0c 28 71 10 	movl   $0x107128,0xc(%esp)
  1052ac:	00 
  1052ad:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1052b4:	00 
  1052b5:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1052bc:	00 
  1052bd:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1052c4:	e8 f7 b9 ff ff       	call   100cc0 <__panic>
    assert(page_ref(p) == 2);
  1052c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052cc:	89 04 24             	mov    %eax,(%esp)
  1052cf:	e8 3a ea ff ff       	call   103d0e <page_ref>
  1052d4:	83 f8 02             	cmp    $0x2,%eax
  1052d7:	74 24                	je     1052fd <check_boot_pgdir+0x2a1>
  1052d9:	c7 44 24 0c 5f 71 10 	movl   $0x10715f,0xc(%esp)
  1052e0:	00 
  1052e1:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  1052e8:	00 
  1052e9:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1052f0:	00 
  1052f1:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  1052f8:	e8 c3 b9 ff ff       	call   100cc0 <__panic>

    const char *str = "ucore: Hello world!!";
  1052fd:	c7 45 dc 70 71 10 00 	movl   $0x107170,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105304:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105307:	89 44 24 04          	mov    %eax,0x4(%esp)
  10530b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105312:	e8 1e 0a 00 00       	call   105d35 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105317:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10531e:	00 
  10531f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105326:	e8 83 0a 00 00       	call   105dae <strcmp>
  10532b:	85 c0                	test   %eax,%eax
  10532d:	74 24                	je     105353 <check_boot_pgdir+0x2f7>
  10532f:	c7 44 24 0c 88 71 10 	movl   $0x107188,0xc(%esp)
  105336:	00 
  105337:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  10533e:	00 
  10533f:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  105346:	00 
  105347:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  10534e:	e8 6d b9 ff ff       	call   100cc0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105356:	89 04 24             	mov    %eax,(%esp)
  105359:	e8 1e e9 ff ff       	call   103c7c <page2kva>
  10535e:	05 00 01 00 00       	add    $0x100,%eax
  105363:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105366:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10536d:	e8 6b 09 00 00       	call   105cdd <strlen>
  105372:	85 c0                	test   %eax,%eax
  105374:	74 24                	je     10539a <check_boot_pgdir+0x33e>
  105376:	c7 44 24 0c c0 71 10 	movl   $0x1071c0,0xc(%esp)
  10537d:	00 
  10537e:	c7 44 24 08 69 6d 10 	movl   $0x106d69,0x8(%esp)
  105385:	00 
  105386:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  10538d:	00 
  10538e:	c7 04 24 44 6d 10 00 	movl   $0x106d44,(%esp)
  105395:	e8 26 b9 ff ff       	call   100cc0 <__panic>

    free_page(p);
  10539a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053a1:	00 
  1053a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053a5:	89 04 24             	mov    %eax,(%esp)
  1053a8:	e8 9e eb ff ff       	call   103f4b <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1053ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1053b2:	8b 00                	mov    (%eax),%eax
  1053b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1053b9:	89 04 24             	mov    %eax,(%esp)
  1053bc:	e8 6c e8 ff ff       	call   103c2d <pa2page>
  1053c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053c8:	00 
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 7a eb ff ff       	call   103f4b <free_pages>
    boot_pgdir[0] = 0;
  1053d1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1053d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1053dc:	c7 04 24 e4 71 10 00 	movl   $0x1071e4,(%esp)
  1053e3:	e8 54 af ff ff       	call   10033c <cprintf>
}
  1053e8:	c9                   	leave  
  1053e9:	c3                   	ret    

001053ea <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1053ea:	55                   	push   %ebp
  1053eb:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1053ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f0:	83 e0 04             	and    $0x4,%eax
  1053f3:	85 c0                	test   %eax,%eax
  1053f5:	74 07                	je     1053fe <perm2str+0x14>
  1053f7:	b8 75 00 00 00       	mov    $0x75,%eax
  1053fc:	eb 05                	jmp    105403 <perm2str+0x19>
  1053fe:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105403:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105408:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10540f:	8b 45 08             	mov    0x8(%ebp),%eax
  105412:	83 e0 02             	and    $0x2,%eax
  105415:	85 c0                	test   %eax,%eax
  105417:	74 07                	je     105420 <perm2str+0x36>
  105419:	b8 77 00 00 00       	mov    $0x77,%eax
  10541e:	eb 05                	jmp    105425 <perm2str+0x3b>
  105420:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105425:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10542a:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105431:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105436:	5d                   	pop    %ebp
  105437:	c3                   	ret    

00105438 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105438:	55                   	push   %ebp
  105439:	89 e5                	mov    %esp,%ebp
  10543b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10543e:	8b 45 10             	mov    0x10(%ebp),%eax
  105441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105444:	72 0a                	jb     105450 <get_pgtable_items+0x18>
        return 0;
  105446:	b8 00 00 00 00       	mov    $0x0,%eax
  10544b:	e9 9c 00 00 00       	jmp    1054ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105450:	eb 04                	jmp    105456 <get_pgtable_items+0x1e>
        start ++;
  105452:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105456:	8b 45 10             	mov    0x10(%ebp),%eax
  105459:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10545c:	73 18                	jae    105476 <get_pgtable_items+0x3e>
  10545e:	8b 45 10             	mov    0x10(%ebp),%eax
  105461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105468:	8b 45 14             	mov    0x14(%ebp),%eax
  10546b:	01 d0                	add    %edx,%eax
  10546d:	8b 00                	mov    (%eax),%eax
  10546f:	83 e0 01             	and    $0x1,%eax
  105472:	85 c0                	test   %eax,%eax
  105474:	74 dc                	je     105452 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105476:	8b 45 10             	mov    0x10(%ebp),%eax
  105479:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10547c:	73 69                	jae    1054e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10547e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105482:	74 08                	je     10548c <get_pgtable_items+0x54>
            *left_store = start;
  105484:	8b 45 18             	mov    0x18(%ebp),%eax
  105487:	8b 55 10             	mov    0x10(%ebp),%edx
  10548a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10548c:	8b 45 10             	mov    0x10(%ebp),%eax
  10548f:	8d 50 01             	lea    0x1(%eax),%edx
  105492:	89 55 10             	mov    %edx,0x10(%ebp)
  105495:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10549c:	8b 45 14             	mov    0x14(%ebp),%eax
  10549f:	01 d0                	add    %edx,%eax
  1054a1:	8b 00                	mov    (%eax),%eax
  1054a3:	83 e0 07             	and    $0x7,%eax
  1054a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1054a9:	eb 04                	jmp    1054af <get_pgtable_items+0x77>
            start ++;
  1054ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1054af:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054b5:	73 1d                	jae    1054d4 <get_pgtable_items+0x9c>
  1054b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1054ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1054c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1054c4:	01 d0                	add    %edx,%eax
  1054c6:	8b 00                	mov    (%eax),%eax
  1054c8:	83 e0 07             	and    $0x7,%eax
  1054cb:	89 c2                	mov    %eax,%edx
  1054cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054d0:	39 c2                	cmp    %eax,%edx
  1054d2:	74 d7                	je     1054ab <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1054d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054d8:	74 08                	je     1054e2 <get_pgtable_items+0xaa>
            *right_store = start;
  1054da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054dd:	8b 55 10             	mov    0x10(%ebp),%edx
  1054e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054e5:	eb 05                	jmp    1054ec <get_pgtable_items+0xb4>
    }
    return 0;
  1054e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1054ec:	c9                   	leave  
  1054ed:	c3                   	ret    

001054ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1054ee:	55                   	push   %ebp
  1054ef:	89 e5                	mov    %esp,%ebp
  1054f1:	57                   	push   %edi
  1054f2:	56                   	push   %esi
  1054f3:	53                   	push   %ebx
  1054f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1054f7:	c7 04 24 04 72 10 00 	movl   $0x107204,(%esp)
  1054fe:	e8 39 ae ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105503:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10550a:	e9 fa 00 00 00       	jmp    105609 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10550f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105512:	89 04 24             	mov    %eax,(%esp)
  105515:	e8 d0 fe ff ff       	call   1053ea <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10551a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10551d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105520:	29 d1                	sub    %edx,%ecx
  105522:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105524:	89 d6                	mov    %edx,%esi
  105526:	c1 e6 16             	shl    $0x16,%esi
  105529:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10552c:	89 d3                	mov    %edx,%ebx
  10552e:	c1 e3 16             	shl    $0x16,%ebx
  105531:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105534:	89 d1                	mov    %edx,%ecx
  105536:	c1 e1 16             	shl    $0x16,%ecx
  105539:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10553c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10553f:	29 d7                	sub    %edx,%edi
  105541:	89 fa                	mov    %edi,%edx
  105543:	89 44 24 14          	mov    %eax,0x14(%esp)
  105547:	89 74 24 10          	mov    %esi,0x10(%esp)
  10554b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10554f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105553:	89 54 24 04          	mov    %edx,0x4(%esp)
  105557:	c7 04 24 35 72 10 00 	movl   $0x107235,(%esp)
  10555e:	e8 d9 ad ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105566:	c1 e0 0a             	shl    $0xa,%eax
  105569:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10556c:	eb 54                	jmp    1055c2 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10556e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105571:	89 04 24             	mov    %eax,(%esp)
  105574:	e8 71 fe ff ff       	call   1053ea <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105579:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10557c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10557f:	29 d1                	sub    %edx,%ecx
  105581:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105583:	89 d6                	mov    %edx,%esi
  105585:	c1 e6 0c             	shl    $0xc,%esi
  105588:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10558b:	89 d3                	mov    %edx,%ebx
  10558d:	c1 e3 0c             	shl    $0xc,%ebx
  105590:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105593:	c1 e2 0c             	shl    $0xc,%edx
  105596:	89 d1                	mov    %edx,%ecx
  105598:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10559b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10559e:	29 d7                	sub    %edx,%edi
  1055a0:	89 fa                	mov    %edi,%edx
  1055a2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1055a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1055aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1055b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055b6:	c7 04 24 54 72 10 00 	movl   $0x107254,(%esp)
  1055bd:	e8 7a ad ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1055c2:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1055c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1055ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1055cd:	89 ce                	mov    %ecx,%esi
  1055cf:	c1 e6 0a             	shl    $0xa,%esi
  1055d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1055d5:	89 cb                	mov    %ecx,%ebx
  1055d7:	c1 e3 0a             	shl    $0xa,%ebx
  1055da:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1055dd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1055e1:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1055e4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1055e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  1055f4:	89 1c 24             	mov    %ebx,(%esp)
  1055f7:	e8 3c fe ff ff       	call   105438 <get_pgtable_items>
  1055fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105603:	0f 85 65 ff ff ff    	jne    10556e <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105609:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10560e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105611:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105614:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105618:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10561b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10561f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105623:	89 44 24 08          	mov    %eax,0x8(%esp)
  105627:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10562e:	00 
  10562f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105636:	e8 fd fd ff ff       	call   105438 <get_pgtable_items>
  10563b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10563e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105642:	0f 85 c7 fe ff ff    	jne    10550f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105648:	c7 04 24 78 72 10 00 	movl   $0x107278,(%esp)
  10564f:	e8 e8 ac ff ff       	call   10033c <cprintf>
}
  105654:	83 c4 4c             	add    $0x4c,%esp
  105657:	5b                   	pop    %ebx
  105658:	5e                   	pop    %esi
  105659:	5f                   	pop    %edi
  10565a:	5d                   	pop    %ebp
  10565b:	c3                   	ret    

0010565c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10565c:	55                   	push   %ebp
  10565d:	89 e5                	mov    %esp,%ebp
  10565f:	83 ec 58             	sub    $0x58,%esp
  105662:	8b 45 10             	mov    0x10(%ebp),%eax
  105665:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105668:	8b 45 14             	mov    0x14(%ebp),%eax
  10566b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10566e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105671:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105674:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105677:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10567a:	8b 45 18             	mov    0x18(%ebp),%eax
  10567d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105683:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105686:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105689:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10568c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10568f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105696:	74 1c                	je     1056b4 <printnum+0x58>
  105698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10569b:	ba 00 00 00 00       	mov    $0x0,%edx
  1056a0:	f7 75 e4             	divl   -0x1c(%ebp)
  1056a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1056ae:	f7 75 e4             	divl   -0x1c(%ebp)
  1056b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056ba:	f7 75 e4             	divl   -0x1c(%ebp)
  1056bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1056c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1056c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1056cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056d2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1056d5:	8b 45 18             	mov    0x18(%ebp),%eax
  1056d8:	ba 00 00 00 00       	mov    $0x0,%edx
  1056dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056e0:	77 56                	ja     105738 <printnum+0xdc>
  1056e2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056e5:	72 05                	jb     1056ec <printnum+0x90>
  1056e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1056ea:	77 4c                	ja     105738 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1056ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1056ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1056f2:	8b 45 20             	mov    0x20(%ebp),%eax
  1056f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  1056f9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1056fd:	8b 45 18             	mov    0x18(%ebp),%eax
  105700:	89 44 24 10          	mov    %eax,0x10(%esp)
  105704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105707:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10570a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10570e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105712:	8b 45 0c             	mov    0xc(%ebp),%eax
  105715:	89 44 24 04          	mov    %eax,0x4(%esp)
  105719:	8b 45 08             	mov    0x8(%ebp),%eax
  10571c:	89 04 24             	mov    %eax,(%esp)
  10571f:	e8 38 ff ff ff       	call   10565c <printnum>
  105724:	eb 1c                	jmp    105742 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105726:	8b 45 0c             	mov    0xc(%ebp),%eax
  105729:	89 44 24 04          	mov    %eax,0x4(%esp)
  10572d:	8b 45 20             	mov    0x20(%ebp),%eax
  105730:	89 04 24             	mov    %eax,(%esp)
  105733:	8b 45 08             	mov    0x8(%ebp),%eax
  105736:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105738:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10573c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105740:	7f e4                	jg     105726 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105742:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105745:	05 2c 73 10 00       	add    $0x10732c,%eax
  10574a:	0f b6 00             	movzbl (%eax),%eax
  10574d:	0f be c0             	movsbl %al,%eax
  105750:	8b 55 0c             	mov    0xc(%ebp),%edx
  105753:	89 54 24 04          	mov    %edx,0x4(%esp)
  105757:	89 04 24             	mov    %eax,(%esp)
  10575a:	8b 45 08             	mov    0x8(%ebp),%eax
  10575d:	ff d0                	call   *%eax
}
  10575f:	c9                   	leave  
  105760:	c3                   	ret    

00105761 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105761:	55                   	push   %ebp
  105762:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105764:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105768:	7e 14                	jle    10577e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10576a:	8b 45 08             	mov    0x8(%ebp),%eax
  10576d:	8b 00                	mov    (%eax),%eax
  10576f:	8d 48 08             	lea    0x8(%eax),%ecx
  105772:	8b 55 08             	mov    0x8(%ebp),%edx
  105775:	89 0a                	mov    %ecx,(%edx)
  105777:	8b 50 04             	mov    0x4(%eax),%edx
  10577a:	8b 00                	mov    (%eax),%eax
  10577c:	eb 30                	jmp    1057ae <getuint+0x4d>
    }
    else if (lflag) {
  10577e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105782:	74 16                	je     10579a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105784:	8b 45 08             	mov    0x8(%ebp),%eax
  105787:	8b 00                	mov    (%eax),%eax
  105789:	8d 48 04             	lea    0x4(%eax),%ecx
  10578c:	8b 55 08             	mov    0x8(%ebp),%edx
  10578f:	89 0a                	mov    %ecx,(%edx)
  105791:	8b 00                	mov    (%eax),%eax
  105793:	ba 00 00 00 00       	mov    $0x0,%edx
  105798:	eb 14                	jmp    1057ae <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10579a:	8b 45 08             	mov    0x8(%ebp),%eax
  10579d:	8b 00                	mov    (%eax),%eax
  10579f:	8d 48 04             	lea    0x4(%eax),%ecx
  1057a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1057a5:	89 0a                	mov    %ecx,(%edx)
  1057a7:	8b 00                	mov    (%eax),%eax
  1057a9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1057ae:	5d                   	pop    %ebp
  1057af:	c3                   	ret    

001057b0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1057b0:	55                   	push   %ebp
  1057b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1057b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1057b7:	7e 14                	jle    1057cd <getint+0x1d>
        return va_arg(*ap, long long);
  1057b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bc:	8b 00                	mov    (%eax),%eax
  1057be:	8d 48 08             	lea    0x8(%eax),%ecx
  1057c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1057c4:	89 0a                	mov    %ecx,(%edx)
  1057c6:	8b 50 04             	mov    0x4(%eax),%edx
  1057c9:	8b 00                	mov    (%eax),%eax
  1057cb:	eb 28                	jmp    1057f5 <getint+0x45>
    }
    else if (lflag) {
  1057cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1057d1:	74 12                	je     1057e5 <getint+0x35>
        return va_arg(*ap, long);
  1057d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d6:	8b 00                	mov    (%eax),%eax
  1057d8:	8d 48 04             	lea    0x4(%eax),%ecx
  1057db:	8b 55 08             	mov    0x8(%ebp),%edx
  1057de:	89 0a                	mov    %ecx,(%edx)
  1057e0:	8b 00                	mov    (%eax),%eax
  1057e2:	99                   	cltd   
  1057e3:	eb 10                	jmp    1057f5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1057e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e8:	8b 00                	mov    (%eax),%eax
  1057ea:	8d 48 04             	lea    0x4(%eax),%ecx
  1057ed:	8b 55 08             	mov    0x8(%ebp),%edx
  1057f0:	89 0a                	mov    %ecx,(%edx)
  1057f2:	8b 00                	mov    (%eax),%eax
  1057f4:	99                   	cltd   
    }
}
  1057f5:	5d                   	pop    %ebp
  1057f6:	c3                   	ret    

001057f7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1057f7:	55                   	push   %ebp
  1057f8:	89 e5                	mov    %esp,%ebp
  1057fa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1057fd:	8d 45 14             	lea    0x14(%ebp),%eax
  105800:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105806:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10580a:	8b 45 10             	mov    0x10(%ebp),%eax
  10580d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105811:	8b 45 0c             	mov    0xc(%ebp),%eax
  105814:	89 44 24 04          	mov    %eax,0x4(%esp)
  105818:	8b 45 08             	mov    0x8(%ebp),%eax
  10581b:	89 04 24             	mov    %eax,(%esp)
  10581e:	e8 02 00 00 00       	call   105825 <vprintfmt>
    va_end(ap);
}
  105823:	c9                   	leave  
  105824:	c3                   	ret    

00105825 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105825:	55                   	push   %ebp
  105826:	89 e5                	mov    %esp,%ebp
  105828:	56                   	push   %esi
  105829:	53                   	push   %ebx
  10582a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10582d:	eb 18                	jmp    105847 <vprintfmt+0x22>
            if (ch == '\0') {
  10582f:	85 db                	test   %ebx,%ebx
  105831:	75 05                	jne    105838 <vprintfmt+0x13>
                return;
  105833:	e9 d1 03 00 00       	jmp    105c09 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105838:	8b 45 0c             	mov    0xc(%ebp),%eax
  10583b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583f:	89 1c 24             	mov    %ebx,(%esp)
  105842:	8b 45 08             	mov    0x8(%ebp),%eax
  105845:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105847:	8b 45 10             	mov    0x10(%ebp),%eax
  10584a:	8d 50 01             	lea    0x1(%eax),%edx
  10584d:	89 55 10             	mov    %edx,0x10(%ebp)
  105850:	0f b6 00             	movzbl (%eax),%eax
  105853:	0f b6 d8             	movzbl %al,%ebx
  105856:	83 fb 25             	cmp    $0x25,%ebx
  105859:	75 d4                	jne    10582f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10585b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10585f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105869:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10586c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105873:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105876:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105879:	8b 45 10             	mov    0x10(%ebp),%eax
  10587c:	8d 50 01             	lea    0x1(%eax),%edx
  10587f:	89 55 10             	mov    %edx,0x10(%ebp)
  105882:	0f b6 00             	movzbl (%eax),%eax
  105885:	0f b6 d8             	movzbl %al,%ebx
  105888:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10588b:	83 f8 55             	cmp    $0x55,%eax
  10588e:	0f 87 44 03 00 00    	ja     105bd8 <vprintfmt+0x3b3>
  105894:	8b 04 85 50 73 10 00 	mov    0x107350(,%eax,4),%eax
  10589b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10589d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1058a1:	eb d6                	jmp    105879 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1058a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1058a7:	eb d0                	jmp    105879 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1058a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1058b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058b3:	89 d0                	mov    %edx,%eax
  1058b5:	c1 e0 02             	shl    $0x2,%eax
  1058b8:	01 d0                	add    %edx,%eax
  1058ba:	01 c0                	add    %eax,%eax
  1058bc:	01 d8                	add    %ebx,%eax
  1058be:	83 e8 30             	sub    $0x30,%eax
  1058c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1058c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1058c7:	0f b6 00             	movzbl (%eax),%eax
  1058ca:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1058cd:	83 fb 2f             	cmp    $0x2f,%ebx
  1058d0:	7e 0b                	jle    1058dd <vprintfmt+0xb8>
  1058d2:	83 fb 39             	cmp    $0x39,%ebx
  1058d5:	7f 06                	jg     1058dd <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1058d7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1058db:	eb d3                	jmp    1058b0 <vprintfmt+0x8b>
            goto process_precision;
  1058dd:	eb 33                	jmp    105912 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1058df:	8b 45 14             	mov    0x14(%ebp),%eax
  1058e2:	8d 50 04             	lea    0x4(%eax),%edx
  1058e5:	89 55 14             	mov    %edx,0x14(%ebp)
  1058e8:	8b 00                	mov    (%eax),%eax
  1058ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1058ed:	eb 23                	jmp    105912 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1058ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058f3:	79 0c                	jns    105901 <vprintfmt+0xdc>
                width = 0;
  1058f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1058fc:	e9 78 ff ff ff       	jmp    105879 <vprintfmt+0x54>
  105901:	e9 73 ff ff ff       	jmp    105879 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105906:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10590d:	e9 67 ff ff ff       	jmp    105879 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105912:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105916:	79 12                	jns    10592a <vprintfmt+0x105>
                width = precision, precision = -1;
  105918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10591b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10591e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105925:	e9 4f ff ff ff       	jmp    105879 <vprintfmt+0x54>
  10592a:	e9 4a ff ff ff       	jmp    105879 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10592f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105933:	e9 41 ff ff ff       	jmp    105879 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105938:	8b 45 14             	mov    0x14(%ebp),%eax
  10593b:	8d 50 04             	lea    0x4(%eax),%edx
  10593e:	89 55 14             	mov    %edx,0x14(%ebp)
  105941:	8b 00                	mov    (%eax),%eax
  105943:	8b 55 0c             	mov    0xc(%ebp),%edx
  105946:	89 54 24 04          	mov    %edx,0x4(%esp)
  10594a:	89 04 24             	mov    %eax,(%esp)
  10594d:	8b 45 08             	mov    0x8(%ebp),%eax
  105950:	ff d0                	call   *%eax
            break;
  105952:	e9 ac 02 00 00       	jmp    105c03 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105957:	8b 45 14             	mov    0x14(%ebp),%eax
  10595a:	8d 50 04             	lea    0x4(%eax),%edx
  10595d:	89 55 14             	mov    %edx,0x14(%ebp)
  105960:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105962:	85 db                	test   %ebx,%ebx
  105964:	79 02                	jns    105968 <vprintfmt+0x143>
                err = -err;
  105966:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105968:	83 fb 06             	cmp    $0x6,%ebx
  10596b:	7f 0b                	jg     105978 <vprintfmt+0x153>
  10596d:	8b 34 9d 10 73 10 00 	mov    0x107310(,%ebx,4),%esi
  105974:	85 f6                	test   %esi,%esi
  105976:	75 23                	jne    10599b <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105978:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10597c:	c7 44 24 08 3d 73 10 	movl   $0x10733d,0x8(%esp)
  105983:	00 
  105984:	8b 45 0c             	mov    0xc(%ebp),%eax
  105987:	89 44 24 04          	mov    %eax,0x4(%esp)
  10598b:	8b 45 08             	mov    0x8(%ebp),%eax
  10598e:	89 04 24             	mov    %eax,(%esp)
  105991:	e8 61 fe ff ff       	call   1057f7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105996:	e9 68 02 00 00       	jmp    105c03 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10599b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10599f:	c7 44 24 08 46 73 10 	movl   $0x107346,0x8(%esp)
  1059a6:	00 
  1059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b1:	89 04 24             	mov    %eax,(%esp)
  1059b4:	e8 3e fe ff ff       	call   1057f7 <printfmt>
            }
            break;
  1059b9:	e9 45 02 00 00       	jmp    105c03 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1059be:	8b 45 14             	mov    0x14(%ebp),%eax
  1059c1:	8d 50 04             	lea    0x4(%eax),%edx
  1059c4:	89 55 14             	mov    %edx,0x14(%ebp)
  1059c7:	8b 30                	mov    (%eax),%esi
  1059c9:	85 f6                	test   %esi,%esi
  1059cb:	75 05                	jne    1059d2 <vprintfmt+0x1ad>
                p = "(null)";
  1059cd:	be 49 73 10 00       	mov    $0x107349,%esi
            }
            if (width > 0 && padc != '-') {
  1059d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059d6:	7e 3e                	jle    105a16 <vprintfmt+0x1f1>
  1059d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1059dc:	74 38                	je     105a16 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1059de:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1059e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e8:	89 34 24             	mov    %esi,(%esp)
  1059eb:	e8 15 03 00 00       	call   105d05 <strnlen>
  1059f0:	29 c3                	sub    %eax,%ebx
  1059f2:	89 d8                	mov    %ebx,%eax
  1059f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059f7:	eb 17                	jmp    105a10 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1059f9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1059fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a00:	89 54 24 04          	mov    %edx,0x4(%esp)
  105a04:	89 04 24             	mov    %eax,(%esp)
  105a07:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a0c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a14:	7f e3                	jg     1059f9 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105a16:	eb 38                	jmp    105a50 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105a1c:	74 1f                	je     105a3d <vprintfmt+0x218>
  105a1e:	83 fb 1f             	cmp    $0x1f,%ebx
  105a21:	7e 05                	jle    105a28 <vprintfmt+0x203>
  105a23:	83 fb 7e             	cmp    $0x7e,%ebx
  105a26:	7e 15                	jle    105a3d <vprintfmt+0x218>
                    putch('?', putdat);
  105a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105a36:	8b 45 08             	mov    0x8(%ebp),%eax
  105a39:	ff d0                	call   *%eax
  105a3b:	eb 0f                	jmp    105a4c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a44:	89 1c 24             	mov    %ebx,(%esp)
  105a47:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105a4c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a50:	89 f0                	mov    %esi,%eax
  105a52:	8d 70 01             	lea    0x1(%eax),%esi
  105a55:	0f b6 00             	movzbl (%eax),%eax
  105a58:	0f be d8             	movsbl %al,%ebx
  105a5b:	85 db                	test   %ebx,%ebx
  105a5d:	74 10                	je     105a6f <vprintfmt+0x24a>
  105a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a63:	78 b3                	js     105a18 <vprintfmt+0x1f3>
  105a65:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a6d:	79 a9                	jns    105a18 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a6f:	eb 17                	jmp    105a88 <vprintfmt+0x263>
                putch(' ', putdat);
  105a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a78:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a82:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a84:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a8c:	7f e3                	jg     105a71 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105a8e:	e9 70 01 00 00       	jmp    105c03 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a9a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a9d:	89 04 24             	mov    %eax,(%esp)
  105aa0:	e8 0b fd ff ff       	call   1057b0 <getint>
  105aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ab1:	85 d2                	test   %edx,%edx
  105ab3:	79 26                	jns    105adb <vprintfmt+0x2b6>
                putch('-', putdat);
  105ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac6:	ff d0                	call   *%eax
                num = -(long long)num;
  105ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ace:	f7 d8                	neg    %eax
  105ad0:	83 d2 00             	adc    $0x0,%edx
  105ad3:	f7 da                	neg    %edx
  105ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ad8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105adb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105ae2:	e9 a8 00 00 00       	jmp    105b8f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aee:	8d 45 14             	lea    0x14(%ebp),%eax
  105af1:	89 04 24             	mov    %eax,(%esp)
  105af4:	e8 68 fc ff ff       	call   105761 <getuint>
  105af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105aff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b06:	e9 84 00 00 00       	jmp    105b8f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b12:	8d 45 14             	lea    0x14(%ebp),%eax
  105b15:	89 04 24             	mov    %eax,(%esp)
  105b18:	e8 44 fc ff ff       	call   105761 <getuint>
  105b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105b23:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105b2a:	eb 63                	jmp    105b8f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b33:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3d:	ff d0                	call   *%eax
            putch('x', putdat);
  105b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b46:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b50:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105b52:	8b 45 14             	mov    0x14(%ebp),%eax
  105b55:	8d 50 04             	lea    0x4(%eax),%edx
  105b58:	89 55 14             	mov    %edx,0x14(%ebp)
  105b5b:	8b 00                	mov    (%eax),%eax
  105b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105b67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105b6e:	eb 1f                	jmp    105b8f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b77:	8d 45 14             	lea    0x14(%ebp),%eax
  105b7a:	89 04 24             	mov    %eax,(%esp)
  105b7d:	e8 df fb ff ff       	call   105761 <getuint>
  105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b88:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b8f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b96:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b9d:	89 54 24 14          	mov    %edx,0x14(%esp)
  105ba1:	89 44 24 10          	mov    %eax,0x10(%esp)
  105ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bab:	89 44 24 08          	mov    %eax,0x8(%esp)
  105baf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bba:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbd:	89 04 24             	mov    %eax,(%esp)
  105bc0:	e8 97 fa ff ff       	call   10565c <printnum>
            break;
  105bc5:	eb 3c                	jmp    105c03 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bce:	89 1c 24             	mov    %ebx,(%esp)
  105bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd4:	ff d0                	call   *%eax
            break;
  105bd6:	eb 2b                	jmp    105c03 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bdf:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105be6:	8b 45 08             	mov    0x8(%ebp),%eax
  105be9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105beb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bef:	eb 04                	jmp    105bf5 <vprintfmt+0x3d0>
  105bf1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  105bf8:	83 e8 01             	sub    $0x1,%eax
  105bfb:	0f b6 00             	movzbl (%eax),%eax
  105bfe:	3c 25                	cmp    $0x25,%al
  105c00:	75 ef                	jne    105bf1 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105c02:	90                   	nop
        }
    }
  105c03:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c04:	e9 3e fc ff ff       	jmp    105847 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105c09:	83 c4 40             	add    $0x40,%esp
  105c0c:	5b                   	pop    %ebx
  105c0d:	5e                   	pop    %esi
  105c0e:	5d                   	pop    %ebp
  105c0f:	c3                   	ret    

00105c10 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105c10:	55                   	push   %ebp
  105c11:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c16:	8b 40 08             	mov    0x8(%eax),%eax
  105c19:	8d 50 01             	lea    0x1(%eax),%edx
  105c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c1f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c25:	8b 10                	mov    (%eax),%edx
  105c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c2a:	8b 40 04             	mov    0x4(%eax),%eax
  105c2d:	39 c2                	cmp    %eax,%edx
  105c2f:	73 12                	jae    105c43 <sprintputch+0x33>
        *b->buf ++ = ch;
  105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c34:	8b 00                	mov    (%eax),%eax
  105c36:	8d 48 01             	lea    0x1(%eax),%ecx
  105c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c3c:	89 0a                	mov    %ecx,(%edx)
  105c3e:	8b 55 08             	mov    0x8(%ebp),%edx
  105c41:	88 10                	mov    %dl,(%eax)
    }
}
  105c43:	5d                   	pop    %ebp
  105c44:	c3                   	ret    

00105c45 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105c45:	55                   	push   %ebp
  105c46:	89 e5                	mov    %esp,%ebp
  105c48:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105c4b:	8d 45 14             	lea    0x14(%ebp),%eax
  105c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c58:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c66:	8b 45 08             	mov    0x8(%ebp),%eax
  105c69:	89 04 24             	mov    %eax,(%esp)
  105c6c:	e8 08 00 00 00       	call   105c79 <vsnprintf>
  105c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c77:	c9                   	leave  
  105c78:	c3                   	ret    

00105c79 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105c79:	55                   	push   %ebp
  105c7a:	89 e5                	mov    %esp,%ebp
  105c7c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c88:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8e:	01 d0                	add    %edx,%eax
  105c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c9e:	74 0a                	je     105caa <vsnprintf+0x31>
  105ca0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ca6:	39 c2                	cmp    %eax,%edx
  105ca8:	76 07                	jbe    105cb1 <vsnprintf+0x38>
        return -E_INVAL;
  105caa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105caf:	eb 2a                	jmp    105cdb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  105cb4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  105cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  105cbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cc6:	c7 04 24 10 5c 10 00 	movl   $0x105c10,(%esp)
  105ccd:	e8 53 fb ff ff       	call   105825 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cd5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105cdb:	c9                   	leave  
  105cdc:	c3                   	ret    

00105cdd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105cdd:	55                   	push   %ebp
  105cde:	89 e5                	mov    %esp,%ebp
  105ce0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ce3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105cea:	eb 04                	jmp    105cf0 <strlen+0x13>
        cnt ++;
  105cec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf3:	8d 50 01             	lea    0x1(%eax),%edx
  105cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  105cf9:	0f b6 00             	movzbl (%eax),%eax
  105cfc:	84 c0                	test   %al,%al
  105cfe:	75 ec                	jne    105cec <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d03:	c9                   	leave  
  105d04:	c3                   	ret    

00105d05 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105d05:	55                   	push   %ebp
  105d06:	89 e5                	mov    %esp,%ebp
  105d08:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105d12:	eb 04                	jmp    105d18 <strnlen+0x13>
        cnt ++;
  105d14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105d1e:	73 10                	jae    105d30 <strnlen+0x2b>
  105d20:	8b 45 08             	mov    0x8(%ebp),%eax
  105d23:	8d 50 01             	lea    0x1(%eax),%edx
  105d26:	89 55 08             	mov    %edx,0x8(%ebp)
  105d29:	0f b6 00             	movzbl (%eax),%eax
  105d2c:	84 c0                	test   %al,%al
  105d2e:	75 e4                	jne    105d14 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d33:	c9                   	leave  
  105d34:	c3                   	ret    

00105d35 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105d35:	55                   	push   %ebp
  105d36:	89 e5                	mov    %esp,%ebp
  105d38:	57                   	push   %edi
  105d39:	56                   	push   %esi
  105d3a:	83 ec 20             	sub    $0x20,%esp
  105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105d49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d4f:	89 d1                	mov    %edx,%ecx
  105d51:	89 c2                	mov    %eax,%edx
  105d53:	89 ce                	mov    %ecx,%esi
  105d55:	89 d7                	mov    %edx,%edi
  105d57:	ac                   	lods   %ds:(%esi),%al
  105d58:	aa                   	stos   %al,%es:(%edi)
  105d59:	84 c0                	test   %al,%al
  105d5b:	75 fa                	jne    105d57 <strcpy+0x22>
  105d5d:	89 fa                	mov    %edi,%edx
  105d5f:	89 f1                	mov    %esi,%ecx
  105d61:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d64:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105d6d:	83 c4 20             	add    $0x20,%esp
  105d70:	5e                   	pop    %esi
  105d71:	5f                   	pop    %edi
  105d72:	5d                   	pop    %ebp
  105d73:	c3                   	ret    

00105d74 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105d74:	55                   	push   %ebp
  105d75:	89 e5                	mov    %esp,%ebp
  105d77:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105d80:	eb 21                	jmp    105da3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d85:	0f b6 10             	movzbl (%eax),%edx
  105d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d8b:	88 10                	mov    %dl,(%eax)
  105d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d90:	0f b6 00             	movzbl (%eax),%eax
  105d93:	84 c0                	test   %al,%al
  105d95:	74 04                	je     105d9b <strncpy+0x27>
            src ++;
  105d97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105d9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105da7:	75 d9                	jne    105d82 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105dac:	c9                   	leave  
  105dad:	c3                   	ret    

00105dae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105dae:	55                   	push   %ebp
  105daf:	89 e5                	mov    %esp,%ebp
  105db1:	57                   	push   %edi
  105db2:	56                   	push   %esi
  105db3:	83 ec 20             	sub    $0x20,%esp
  105db6:	8b 45 08             	mov    0x8(%ebp),%eax
  105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dc8:	89 d1                	mov    %edx,%ecx
  105dca:	89 c2                	mov    %eax,%edx
  105dcc:	89 ce                	mov    %ecx,%esi
  105dce:	89 d7                	mov    %edx,%edi
  105dd0:	ac                   	lods   %ds:(%esi),%al
  105dd1:	ae                   	scas   %es:(%edi),%al
  105dd2:	75 08                	jne    105ddc <strcmp+0x2e>
  105dd4:	84 c0                	test   %al,%al
  105dd6:	75 f8                	jne    105dd0 <strcmp+0x22>
  105dd8:	31 c0                	xor    %eax,%eax
  105dda:	eb 04                	jmp    105de0 <strcmp+0x32>
  105ddc:	19 c0                	sbb    %eax,%eax
  105dde:	0c 01                	or     $0x1,%al
  105de0:	89 fa                	mov    %edi,%edx
  105de2:	89 f1                	mov    %esi,%ecx
  105de4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105de7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105dea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105df0:	83 c4 20             	add    $0x20,%esp
  105df3:	5e                   	pop    %esi
  105df4:	5f                   	pop    %edi
  105df5:	5d                   	pop    %ebp
  105df6:	c3                   	ret    

00105df7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105df7:	55                   	push   %ebp
  105df8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105dfa:	eb 0c                	jmp    105e08 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105dfc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105e00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e04:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e0c:	74 1a                	je     105e28 <strncmp+0x31>
  105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e11:	0f b6 00             	movzbl (%eax),%eax
  105e14:	84 c0                	test   %al,%al
  105e16:	74 10                	je     105e28 <strncmp+0x31>
  105e18:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1b:	0f b6 10             	movzbl (%eax),%edx
  105e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e21:	0f b6 00             	movzbl (%eax),%eax
  105e24:	38 c2                	cmp    %al,%dl
  105e26:	74 d4                	je     105dfc <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e2c:	74 18                	je     105e46 <strncmp+0x4f>
  105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e31:	0f b6 00             	movzbl (%eax),%eax
  105e34:	0f b6 d0             	movzbl %al,%edx
  105e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3a:	0f b6 00             	movzbl (%eax),%eax
  105e3d:	0f b6 c0             	movzbl %al,%eax
  105e40:	29 c2                	sub    %eax,%edx
  105e42:	89 d0                	mov    %edx,%eax
  105e44:	eb 05                	jmp    105e4b <strncmp+0x54>
  105e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e4b:	5d                   	pop    %ebp
  105e4c:	c3                   	ret    

00105e4d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105e4d:	55                   	push   %ebp
  105e4e:	89 e5                	mov    %esp,%ebp
  105e50:	83 ec 04             	sub    $0x4,%esp
  105e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e59:	eb 14                	jmp    105e6f <strchr+0x22>
        if (*s == c) {
  105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5e:	0f b6 00             	movzbl (%eax),%eax
  105e61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e64:	75 05                	jne    105e6b <strchr+0x1e>
            return (char *)s;
  105e66:	8b 45 08             	mov    0x8(%ebp),%eax
  105e69:	eb 13                	jmp    105e7e <strchr+0x31>
        }
        s ++;
  105e6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e72:	0f b6 00             	movzbl (%eax),%eax
  105e75:	84 c0                	test   %al,%al
  105e77:	75 e2                	jne    105e5b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e7e:	c9                   	leave  
  105e7f:	c3                   	ret    

00105e80 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105e80:	55                   	push   %ebp
  105e81:	89 e5                	mov    %esp,%ebp
  105e83:	83 ec 04             	sub    $0x4,%esp
  105e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e89:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e8c:	eb 11                	jmp    105e9f <strfind+0x1f>
        if (*s == c) {
  105e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e91:	0f b6 00             	movzbl (%eax),%eax
  105e94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e97:	75 02                	jne    105e9b <strfind+0x1b>
            break;
  105e99:	eb 0e                	jmp    105ea9 <strfind+0x29>
        }
        s ++;
  105e9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea2:	0f b6 00             	movzbl (%eax),%eax
  105ea5:	84 c0                	test   %al,%al
  105ea7:	75 e5                	jne    105e8e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105eac:	c9                   	leave  
  105ead:	c3                   	ret    

00105eae <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105eae:	55                   	push   %ebp
  105eaf:	89 e5                	mov    %esp,%ebp
  105eb1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ebb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ec2:	eb 04                	jmp    105ec8 <strtol+0x1a>
        s ++;
  105ec4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ecb:	0f b6 00             	movzbl (%eax),%eax
  105ece:	3c 20                	cmp    $0x20,%al
  105ed0:	74 f2                	je     105ec4 <strtol+0x16>
  105ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed5:	0f b6 00             	movzbl (%eax),%eax
  105ed8:	3c 09                	cmp    $0x9,%al
  105eda:	74 e8                	je     105ec4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105edc:	8b 45 08             	mov    0x8(%ebp),%eax
  105edf:	0f b6 00             	movzbl (%eax),%eax
  105ee2:	3c 2b                	cmp    $0x2b,%al
  105ee4:	75 06                	jne    105eec <strtol+0x3e>
        s ++;
  105ee6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105eea:	eb 15                	jmp    105f01 <strtol+0x53>
    }
    else if (*s == '-') {
  105eec:	8b 45 08             	mov    0x8(%ebp),%eax
  105eef:	0f b6 00             	movzbl (%eax),%eax
  105ef2:	3c 2d                	cmp    $0x2d,%al
  105ef4:	75 0b                	jne    105f01 <strtol+0x53>
        s ++, neg = 1;
  105ef6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105efa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105f01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f05:	74 06                	je     105f0d <strtol+0x5f>
  105f07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105f0b:	75 24                	jne    105f31 <strtol+0x83>
  105f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f10:	0f b6 00             	movzbl (%eax),%eax
  105f13:	3c 30                	cmp    $0x30,%al
  105f15:	75 1a                	jne    105f31 <strtol+0x83>
  105f17:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1a:	83 c0 01             	add    $0x1,%eax
  105f1d:	0f b6 00             	movzbl (%eax),%eax
  105f20:	3c 78                	cmp    $0x78,%al
  105f22:	75 0d                	jne    105f31 <strtol+0x83>
        s += 2, base = 16;
  105f24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105f28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105f2f:	eb 2a                	jmp    105f5b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f35:	75 17                	jne    105f4e <strtol+0xa0>
  105f37:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3a:	0f b6 00             	movzbl (%eax),%eax
  105f3d:	3c 30                	cmp    $0x30,%al
  105f3f:	75 0d                	jne    105f4e <strtol+0xa0>
        s ++, base = 8;
  105f41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f45:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105f4c:	eb 0d                	jmp    105f5b <strtol+0xad>
    }
    else if (base == 0) {
  105f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f52:	75 07                	jne    105f5b <strtol+0xad>
        base = 10;
  105f54:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5e:	0f b6 00             	movzbl (%eax),%eax
  105f61:	3c 2f                	cmp    $0x2f,%al
  105f63:	7e 1b                	jle    105f80 <strtol+0xd2>
  105f65:	8b 45 08             	mov    0x8(%ebp),%eax
  105f68:	0f b6 00             	movzbl (%eax),%eax
  105f6b:	3c 39                	cmp    $0x39,%al
  105f6d:	7f 11                	jg     105f80 <strtol+0xd2>
            dig = *s - '0';
  105f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f72:	0f b6 00             	movzbl (%eax),%eax
  105f75:	0f be c0             	movsbl %al,%eax
  105f78:	83 e8 30             	sub    $0x30,%eax
  105f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f7e:	eb 48                	jmp    105fc8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105f80:	8b 45 08             	mov    0x8(%ebp),%eax
  105f83:	0f b6 00             	movzbl (%eax),%eax
  105f86:	3c 60                	cmp    $0x60,%al
  105f88:	7e 1b                	jle    105fa5 <strtol+0xf7>
  105f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f8d:	0f b6 00             	movzbl (%eax),%eax
  105f90:	3c 7a                	cmp    $0x7a,%al
  105f92:	7f 11                	jg     105fa5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105f94:	8b 45 08             	mov    0x8(%ebp),%eax
  105f97:	0f b6 00             	movzbl (%eax),%eax
  105f9a:	0f be c0             	movsbl %al,%eax
  105f9d:	83 e8 57             	sub    $0x57,%eax
  105fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105fa3:	eb 23                	jmp    105fc8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa8:	0f b6 00             	movzbl (%eax),%eax
  105fab:	3c 40                	cmp    $0x40,%al
  105fad:	7e 3d                	jle    105fec <strtol+0x13e>
  105faf:	8b 45 08             	mov    0x8(%ebp),%eax
  105fb2:	0f b6 00             	movzbl (%eax),%eax
  105fb5:	3c 5a                	cmp    $0x5a,%al
  105fb7:	7f 33                	jg     105fec <strtol+0x13e>
            dig = *s - 'A' + 10;
  105fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbc:	0f b6 00             	movzbl (%eax),%eax
  105fbf:	0f be c0             	movsbl %al,%eax
  105fc2:	83 e8 37             	sub    $0x37,%eax
  105fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fcb:	3b 45 10             	cmp    0x10(%ebp),%eax
  105fce:	7c 02                	jl     105fd2 <strtol+0x124>
            break;
  105fd0:	eb 1a                	jmp    105fec <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105fd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  105fdd:	89 c2                	mov    %eax,%edx
  105fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fe2:	01 d0                	add    %edx,%eax
  105fe4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105fe7:	e9 6f ff ff ff       	jmp    105f5b <strtol+0xad>

    if (endptr) {
  105fec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ff0:	74 08                	je     105ffa <strtol+0x14c>
        *endptr = (char *) s;
  105ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  105ff8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ffe:	74 07                	je     106007 <strtol+0x159>
  106000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106003:	f7 d8                	neg    %eax
  106005:	eb 03                	jmp    10600a <strtol+0x15c>
  106007:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10600a:	c9                   	leave  
  10600b:	c3                   	ret    

0010600c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10600c:	55                   	push   %ebp
  10600d:	89 e5                	mov    %esp,%ebp
  10600f:	57                   	push   %edi
  106010:	83 ec 24             	sub    $0x24,%esp
  106013:	8b 45 0c             	mov    0xc(%ebp),%eax
  106016:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106019:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10601d:	8b 55 08             	mov    0x8(%ebp),%edx
  106020:	89 55 f8             	mov    %edx,-0x8(%ebp)
  106023:	88 45 f7             	mov    %al,-0x9(%ebp)
  106026:	8b 45 10             	mov    0x10(%ebp),%eax
  106029:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10602c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10602f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106033:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106036:	89 d7                	mov    %edx,%edi
  106038:	f3 aa                	rep stos %al,%es:(%edi)
  10603a:	89 fa                	mov    %edi,%edx
  10603c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10603f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  106042:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106045:	83 c4 24             	add    $0x24,%esp
  106048:	5f                   	pop    %edi
  106049:	5d                   	pop    %ebp
  10604a:	c3                   	ret    

0010604b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10604b:	55                   	push   %ebp
  10604c:	89 e5                	mov    %esp,%ebp
  10604e:	57                   	push   %edi
  10604f:	56                   	push   %esi
  106050:	53                   	push   %ebx
  106051:	83 ec 30             	sub    $0x30,%esp
  106054:	8b 45 08             	mov    0x8(%ebp),%eax
  106057:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10605a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10605d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106060:	8b 45 10             	mov    0x10(%ebp),%eax
  106063:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106069:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10606c:	73 42                	jae    1060b0 <memmove+0x65>
  10606e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106077:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10607a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10607d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106080:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106083:	c1 e8 02             	shr    $0x2,%eax
  106086:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106088:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10608b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10608e:	89 d7                	mov    %edx,%edi
  106090:	89 c6                	mov    %eax,%esi
  106092:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106094:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106097:	83 e1 03             	and    $0x3,%ecx
  10609a:	74 02                	je     10609e <memmove+0x53>
  10609c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10609e:	89 f0                	mov    %esi,%eax
  1060a0:	89 fa                	mov    %edi,%edx
  1060a2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1060a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1060a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1060ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060ae:	eb 36                	jmp    1060e6 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1060b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060b9:	01 c2                	add    %eax,%edx
  1060bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060be:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1060c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060c4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1060c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060ca:	89 c1                	mov    %eax,%ecx
  1060cc:	89 d8                	mov    %ebx,%eax
  1060ce:	89 d6                	mov    %edx,%esi
  1060d0:	89 c7                	mov    %eax,%edi
  1060d2:	fd                   	std    
  1060d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060d5:	fc                   	cld    
  1060d6:	89 f8                	mov    %edi,%eax
  1060d8:	89 f2                	mov    %esi,%edx
  1060da:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1060dd:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1060e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1060e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1060e6:	83 c4 30             	add    $0x30,%esp
  1060e9:	5b                   	pop    %ebx
  1060ea:	5e                   	pop    %esi
  1060eb:	5f                   	pop    %edi
  1060ec:	5d                   	pop    %ebp
  1060ed:	c3                   	ret    

001060ee <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1060ee:	55                   	push   %ebp
  1060ef:	89 e5                	mov    %esp,%ebp
  1060f1:	57                   	push   %edi
  1060f2:	56                   	push   %esi
  1060f3:	83 ec 20             	sub    $0x20,%esp
  1060f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1060f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106102:	8b 45 10             	mov    0x10(%ebp),%eax
  106105:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10610b:	c1 e8 02             	shr    $0x2,%eax
  10610e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106116:	89 d7                	mov    %edx,%edi
  106118:	89 c6                	mov    %eax,%esi
  10611a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10611c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10611f:	83 e1 03             	and    $0x3,%ecx
  106122:	74 02                	je     106126 <memcpy+0x38>
  106124:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106126:	89 f0                	mov    %esi,%eax
  106128:	89 fa                	mov    %edi,%edx
  10612a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10612d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106130:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106133:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106136:	83 c4 20             	add    $0x20,%esp
  106139:	5e                   	pop    %esi
  10613a:	5f                   	pop    %edi
  10613b:	5d                   	pop    %ebp
  10613c:	c3                   	ret    

0010613d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10613d:	55                   	push   %ebp
  10613e:	89 e5                	mov    %esp,%ebp
  106140:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106143:	8b 45 08             	mov    0x8(%ebp),%eax
  106146:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106149:	8b 45 0c             	mov    0xc(%ebp),%eax
  10614c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10614f:	eb 30                	jmp    106181 <memcmp+0x44>
        if (*s1 != *s2) {
  106151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106154:	0f b6 10             	movzbl (%eax),%edx
  106157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10615a:	0f b6 00             	movzbl (%eax),%eax
  10615d:	38 c2                	cmp    %al,%dl
  10615f:	74 18                	je     106179 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106164:	0f b6 00             	movzbl (%eax),%eax
  106167:	0f b6 d0             	movzbl %al,%edx
  10616a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10616d:	0f b6 00             	movzbl (%eax),%eax
  106170:	0f b6 c0             	movzbl %al,%eax
  106173:	29 c2                	sub    %eax,%edx
  106175:	89 d0                	mov    %edx,%eax
  106177:	eb 1a                	jmp    106193 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  106179:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10617d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106181:	8b 45 10             	mov    0x10(%ebp),%eax
  106184:	8d 50 ff             	lea    -0x1(%eax),%edx
  106187:	89 55 10             	mov    %edx,0x10(%ebp)
  10618a:	85 c0                	test   %eax,%eax
  10618c:	75 c3                	jne    106151 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10618e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106193:	c9                   	leave  
  106194:	c3                   	ret    
