
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
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
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 b6 5f 00 00       	call   c010600c <memset>

    cons_init();                // init the console
c0100056:	e8 6b 15 00 00       	call   c01015c6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 61 10 c0 	movl   $0xc01061a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 61 10 c0 	movl   $0xc01061bc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 9f 44 00 00       	call   c0104523 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 a6 16 00 00       	call   c010172f <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 1e 18 00 00       	call   c01018ac <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 e9 0c 00 00       	call   c0100d7c <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 05 16 00 00       	call   c010169d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f2 0b 00 00       	call   c0100cae <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 c1 61 10 c0 	movl   $0xc01061c1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 cf 61 10 c0 	movl   $0xc01061cf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 dd 61 10 c0 	movl   $0xc01061dd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 eb 61 10 c0 	movl   $0xc01061eb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 f9 61 10 c0 	movl   $0xc01061f9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 08 62 10 c0 	movl   $0xc0106208,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 28 62 10 c0 	movl   $0xc0106228,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 47 62 10 c0 	movl   $0xc0106247,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 f8 12 00 00       	call   c01015f2 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ee 54 00 00       	call   c0105825 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 7f 12 00 00       	call   c01015f2 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 5f 12 00 00       	call   c010162e <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 4c 62 10 c0    	movl   $0xc010624c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 4c 62 10 c0 	movl   $0xc010624c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 74 10 c0 	movl   $0xc01074a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 28 21 11 c0 	movl   $0xc0112128,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 29 21 11 c0 	movl   $0xc0112129,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 74 4b 11 c0 	movl   $0xc0114b74,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 94 57 00 00       	call   c0105e80 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 56 62 10 c0 	movl   $0xc0106256,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 95 61 10 	movl   $0xc0106195,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 87 62 10 c0 	movl   $0xc0106287,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 9f 62 10 c0 	movl   $0xc010629f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 b7 62 10 c0 	movl   $0xc01062b7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 62 10 c0 	movl   $0xc01062d0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 fa 62 10 c0 	movl   $0xc01062fa,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 16 63 10 c0 	movl   $0xc0106316,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 28 63 10 c0 	movl   $0xc0106328,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 02             	add    $0x2,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a36:	c7 04 24 4c 63 10 c0 	movl   $0xc010634c,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip - 1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a6b:	0f 8e 6e ff ff ff    	jle    c01009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
c0100a71:	c9                   	leave  
c0100a72:	c3                   	ret    

c0100a73 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a73:	55                   	push   %ebp
c0100a74:	89 e5                	mov    %esp,%ebp
c0100a76:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a80:	eb 0c                	jmp    c0100a8e <parse+0x1b>
            *buf ++ = '\0';
c0100a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a85:	8d 50 01             	lea    0x1(%eax),%edx
c0100a88:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a8b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	0f b6 00             	movzbl (%eax),%eax
c0100a94:	84 c0                	test   %al,%al
c0100a96:	74 1d                	je     c0100ab5 <parse+0x42>
c0100a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9b:	0f b6 00             	movzbl (%eax),%eax
c0100a9e:	0f be c0             	movsbl %al,%eax
c0100aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aa5:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c0100aac:	e8 9c 53 00 00       	call   c0105e4d <strchr>
c0100ab1:	85 c0                	test   %eax,%eax
c0100ab3:	75 cd                	jne    c0100a82 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	84 c0                	test   %al,%al
c0100abd:	75 02                	jne    c0100ac1 <parse+0x4e>
            break;
c0100abf:	eb 67                	jmp    c0100b28 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ac5:	75 14                	jne    c0100adb <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ac7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ace:	00 
c0100acf:	c7 04 24 d5 63 10 c0 	movl   $0xc01063d5,(%esp)
c0100ad6:	e8 61 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ade:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ae4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100aee:	01 c2                	add    %eax,%edx
c0100af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af5:	eb 04                	jmp    c0100afb <parse+0x88>
            buf ++;
c0100af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afe:	0f b6 00             	movzbl (%eax),%eax
c0100b01:	84 c0                	test   %al,%al
c0100b03:	74 1d                	je     c0100b22 <parse+0xaf>
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	0f b6 00             	movzbl (%eax),%eax
c0100b0b:	0f be c0             	movsbl %al,%eax
c0100b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b12:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c0100b19:	e8 2f 53 00 00       	call   c0105e4d <strchr>
c0100b1e:	85 c0                	test   %eax,%eax
c0100b20:	74 d5                	je     c0100af7 <parse+0x84>
            buf ++;
        }
    }
c0100b22:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b23:	e9 66 ff ff ff       	jmp    c0100a8e <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b2b:	c9                   	leave  
c0100b2c:	c3                   	ret    

c0100b2d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b2d:	55                   	push   %ebp
c0100b2e:	89 e5                	mov    %esp,%ebp
c0100b30:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3d:	89 04 24             	mov    %eax,(%esp)
c0100b40:	e8 2e ff ff ff       	call   c0100a73 <parse>
c0100b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b4c:	75 0a                	jne    c0100b58 <runcmd+0x2b>
        return 0;
c0100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b53:	e9 85 00 00 00       	jmp    c0100bdd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b5f:	eb 5c                	jmp    c0100bbd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b61:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b67:	89 d0                	mov    %edx,%eax
c0100b69:	01 c0                	add    %eax,%eax
c0100b6b:	01 d0                	add    %edx,%eax
c0100b6d:	c1 e0 02             	shl    $0x2,%eax
c0100b70:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b75:	8b 00                	mov    (%eax),%eax
c0100b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b7b:	89 04 24             	mov    %eax,(%esp)
c0100b7e:	e8 2b 52 00 00       	call   c0105dae <strcmp>
c0100b83:	85 c0                	test   %eax,%eax
c0100b85:	75 32                	jne    c0100bb9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8a:	89 d0                	mov    %edx,%eax
c0100b8c:	01 c0                	add    %eax,%eax
c0100b8e:	01 d0                	add    %edx,%eax
c0100b90:	c1 e0 02             	shl    $0x2,%eax
c0100b93:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b98:	8b 40 08             	mov    0x8(%eax),%eax
c0100b9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100b9e:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100ba4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ba8:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bab:	83 c2 04             	add    $0x4,%edx
c0100bae:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb2:	89 0c 24             	mov    %ecx,(%esp)
c0100bb5:	ff d0                	call   *%eax
c0100bb7:	eb 24                	jmp    c0100bdd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc0:	83 f8 02             	cmp    $0x2,%eax
c0100bc3:	76 9c                	jbe    c0100b61 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 f3 63 10 c0 	movl   $0xc01063f3,(%esp)
c0100bd3:	e8 64 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bdd:	c9                   	leave  
c0100bde:	c3                   	ret    

c0100bdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bdf:	55                   	push   %ebp
c0100be0:	89 e5                	mov    %esp,%ebp
c0100be2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100be5:	c7 04 24 0c 64 10 c0 	movl   $0xc010640c,(%esp)
c0100bec:	e8 4b f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf1:	c7 04 24 34 64 10 c0 	movl   $0xc0106434,(%esp)
c0100bf8:	e8 3f f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c01:	74 0b                	je     c0100c0e <kmonitor+0x2f>
        print_trapframe(tf);
c0100c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c06:	89 04 24             	mov    %eax,(%esp)
c0100c09:	e8 6e 10 00 00       	call   c0101c7c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c0e:	c7 04 24 59 64 10 c0 	movl   $0xc0106459,(%esp)
c0100c15:	e8 19 f6 ff ff       	call   c0100233 <readline>
c0100c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c21:	74 18                	je     c0100c3b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c2d:	89 04 24             	mov    %eax,(%esp)
c0100c30:	e8 f8 fe ff ff       	call   c0100b2d <runcmd>
c0100c35:	85 c0                	test   %eax,%eax
c0100c37:	79 02                	jns    c0100c3b <kmonitor+0x5c>
                break;
c0100c39:	eb 02                	jmp    c0100c3d <kmonitor+0x5e>
            }
        }
    }
c0100c3b:	eb d1                	jmp    c0100c0e <kmonitor+0x2f>
}
c0100c3d:	c9                   	leave  
c0100c3e:	c3                   	ret    

c0100c3f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c3f:	55                   	push   %ebp
c0100c40:	89 e5                	mov    %esp,%ebp
c0100c42:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c4c:	eb 3f                	jmp    c0100c8d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c51:	89 d0                	mov    %edx,%eax
c0100c53:	01 c0                	add    %eax,%eax
c0100c55:	01 d0                	add    %edx,%eax
c0100c57:	c1 e0 02             	shl    $0x2,%eax
c0100c5a:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c5f:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c65:	89 d0                	mov    %edx,%eax
c0100c67:	01 c0                	add    %eax,%eax
c0100c69:	01 d0                	add    %edx,%eax
c0100c6b:	c1 e0 02             	shl    $0x2,%eax
c0100c6e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c73:	8b 00                	mov    (%eax),%eax
c0100c75:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c7d:	c7 04 24 5d 64 10 c0 	movl   $0xc010645d,(%esp)
c0100c84:	e8 b3 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c90:	83 f8 02             	cmp    $0x2,%eax
c0100c93:	76 b9                	jbe    c0100c4e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9a:	c9                   	leave  
c0100c9b:	c3                   	ret    

c0100c9c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c9c:	55                   	push   %ebp
c0100c9d:	89 e5                	mov    %esp,%ebp
c0100c9f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca2:	e8 c9 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cac:	c9                   	leave  
c0100cad:	c3                   	ret    

c0100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cae:	55                   	push   %ebp
c0100caf:	89 e5                	mov    %esp,%ebp
c0100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cb4:	e8 01 fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	c9                   	leave  
c0100cbf:	c3                   	ret    

c0100cc0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cc6:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100ccb:	85 c0                	test   %eax,%eax
c0100ccd:	74 02                	je     c0100cd1 <__panic+0x11>
        goto panic_dead;
c0100ccf:	eb 48                	jmp    c0100d19 <__panic+0x59>
    }
    is_panic = 1;
c0100cd1:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cd8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cdb:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cef:	c7 04 24 66 64 10 c0 	movl   $0xc0106466,(%esp)
c0100cf6:	e8 41 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d02:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d05:	89 04 24             	mov    %eax,(%esp)
c0100d08:	e8 fc f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d0d:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0100d14:	e8 23 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d19:	e8 85 09 00 00       	call   c01016a3 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d25:	e8 b5 fe ff ff       	call   c0100bdf <kmonitor>
    }
c0100d2a:	eb f2                	jmp    c0100d1e <__panic+0x5e>

c0100d2c <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d2c:	55                   	push   %ebp
c0100d2d:	89 e5                	mov    %esp,%ebp
c0100d2f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d32:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d3b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d46:	c7 04 24 84 64 10 c0 	movl   $0xc0106484,(%esp)
c0100d4d:	e8 ea f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d59:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d5c:	89 04 24             	mov    %eax,(%esp)
c0100d5f:	e8 a5 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d64:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0100d6b:	e8 cc f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d70:	c9                   	leave  
c0100d71:	c3                   	ret    

c0100d72 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d72:	55                   	push   %ebp
c0100d73:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d75:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d7a:	5d                   	pop    %ebp
c0100d7b:	c3                   	ret    

c0100d7c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d7c:	55                   	push   %ebp
c0100d7d:	89 e5                	mov    %esp,%ebp
c0100d7f:	83 ec 28             	sub    $0x28,%esp
c0100d82:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d88:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d94:	ee                   	out    %al,(%dx)
c0100d95:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d9b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da7:	ee                   	out    %al,(%dx)
c0100da8:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dae:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100db6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dba:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dbb:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dc5:	c7 04 24 a2 64 10 c0 	movl   $0xc01064a2,(%esp)
c0100dcc:	e8 6b f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dd8:	e8 24 09 00 00       	call   c0101701 <pic_enable>
}
c0100ddd:	c9                   	leave  
c0100dde:	c3                   	ret    

c0100ddf <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100ddf:	55                   	push   %ebp
c0100de0:	89 e5                	mov    %esp,%ebp
c0100de2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de5:	9c                   	pushf  
c0100de6:	58                   	pop    %eax
c0100de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100ded:	25 00 02 00 00       	and    $0x200,%eax
c0100df2:	85 c0                	test   %eax,%eax
c0100df4:	74 0c                	je     c0100e02 <__intr_save+0x23>
        intr_disable();
c0100df6:	e8 a8 08 00 00       	call   c01016a3 <intr_disable>
        return 1;
c0100dfb:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e00:	eb 05                	jmp    c0100e07 <__intr_save+0x28>
    }
    return 0;
c0100e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e07:	c9                   	leave  
c0100e08:	c3                   	ret    

c0100e09 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e09:	55                   	push   %ebp
c0100e0a:	89 e5                	mov    %esp,%ebp
c0100e0c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e13:	74 05                	je     c0100e1a <__intr_restore+0x11>
        intr_enable();
c0100e15:	e8 83 08 00 00       	call   c010169d <intr_enable>
    }
}
c0100e1a:	c9                   	leave  
c0100e1b:	c3                   	ret    

c0100e1c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e1c:	55                   	push   %ebp
c0100e1d:	89 e5                	mov    %esp,%ebp
c0100e1f:	83 ec 10             	sub    $0x10,%esp
c0100e22:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e28:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e2c:	89 c2                	mov    %eax,%edx
c0100e2e:	ec                   	in     (%dx),%al
c0100e2f:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e32:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e38:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e3c:	89 c2                	mov    %eax,%edx
c0100e3e:	ec                   	in     (%dx),%al
c0100e3f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e42:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e48:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e4c:	89 c2                	mov    %eax,%edx
c0100e4e:	ec                   	in     (%dx),%al
c0100e4f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e52:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e58:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e5c:	89 c2                	mov    %eax,%edx
c0100e5e:	ec                   	in     (%dx),%al
c0100e5f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e62:	c9                   	leave  
c0100e63:	c3                   	ret    

c0100e64 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6a:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e74:	0f b7 00             	movzwl (%eax),%eax
c0100e77:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e86:	0f b7 00             	movzwl (%eax),%eax
c0100e89:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e8d:	74 12                	je     c0100ea1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e8f:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e96:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e9d:	b4 03 
c0100e9f:	eb 13                	jmp    c0100eb4 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eab:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb4:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ebb:	0f b7 c0             	movzwl %ax,%eax
c0100ebe:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ece:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ecf:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ed6:	83 c0 01             	add    $0x1,%eax
c0100ed9:	0f b7 c0             	movzwl %ax,%eax
c0100edc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ee4:	89 c2                	mov    %eax,%edx
c0100ee6:	ec                   	in     (%dx),%al
c0100ee7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eea:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100eee:	0f b6 c0             	movzbl %al,%eax
c0100ef1:	c1 e0 08             	shl    $0x8,%eax
c0100ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ef7:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100efe:	0f b7 c0             	movzwl %ax,%eax
c0100f01:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f05:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f09:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f0d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f11:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f12:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f19:	83 c0 01             	add    $0x1,%eax
c0100f1c:	0f b7 c0             	movzwl %ax,%eax
c0100f1f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f23:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f27:	89 c2                	mov    %eax,%edx
c0100f29:	ec                   	in     (%dx),%al
c0100f2a:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f2d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f31:	0f b6 c0             	movzbl %al,%eax
c0100f34:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3a:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f42:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f48:	c9                   	leave  
c0100f49:	c3                   	ret    

c0100f4a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4a:	55                   	push   %ebp
c0100f4b:	89 e5                	mov    %esp,%ebp
c0100f4d:	83 ec 48             	sub    $0x48,%esp
c0100f50:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f56:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f5e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f62:	ee                   	out    %al,(%dx)
c0100f63:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f69:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f6d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f71:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f75:	ee                   	out    %al,(%dx)
c0100f76:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f7c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f88:	ee                   	out    %al,(%dx)
c0100f89:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f8f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f93:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f97:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f9b:	ee                   	out    %al,(%dx)
c0100f9c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa2:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fa6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100faa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fae:	ee                   	out    %al,(%dx)
c0100faf:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fb5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fb9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fbd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc1:	ee                   	out    %al,(%dx)
c0100fc2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fc8:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fcc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fd4:	ee                   	out    %al,(%dx)
c0100fd5:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fdb:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fdf:	89 c2                	mov    %eax,%edx
c0100fe1:	ec                   	in     (%dx),%al
c0100fe2:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fe5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fe9:	3c ff                	cmp    $0xff,%al
c0100feb:	0f 95 c0             	setne  %al
c0100fee:	0f b6 c0             	movzbl %al,%eax
c0100ff1:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ff6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffc:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101000:	89 c2                	mov    %eax,%edx
c0101002:	ec                   	in     (%dx),%al
c0101003:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101006:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010100c:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101010:	89 c2                	mov    %eax,%edx
c0101012:	ec                   	in     (%dx),%al
c0101013:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101016:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010101b:	85 c0                	test   %eax,%eax
c010101d:	74 0c                	je     c010102b <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010101f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101026:	e8 d6 06 00 00       	call   c0101701 <pic_enable>
    }
}
c010102b:	c9                   	leave  
c010102c:	c3                   	ret    

c010102d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010102d:	55                   	push   %ebp
c010102e:	89 e5                	mov    %esp,%ebp
c0101030:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010103a:	eb 09                	jmp    c0101045 <lpt_putc_sub+0x18>
        delay();
c010103c:	e8 db fd ff ff       	call   c0100e1c <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101041:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101045:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010104f:	89 c2                	mov    %eax,%edx
c0101051:	ec                   	in     (%dx),%al
c0101052:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101055:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101059:	84 c0                	test   %al,%al
c010105b:	78 09                	js     c0101066 <lpt_putc_sub+0x39>
c010105d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101064:	7e d6                	jle    c010103c <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101066:	8b 45 08             	mov    0x8(%ebp),%eax
c0101069:	0f b6 c0             	movzbl %al,%eax
c010106c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101072:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101075:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101079:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010107d:	ee                   	out    %al,(%dx)
c010107e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101084:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101088:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010108c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101090:	ee                   	out    %al,(%dx)
c0101091:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0101097:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c010109b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010109f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a3:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a4:	c9                   	leave  
c01010a5:	c3                   	ret    

c01010a6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010a6:	55                   	push   %ebp
c01010a7:	89 e5                	mov    %esp,%ebp
c01010a9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b0:	74 0d                	je     c01010bf <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b5:	89 04 24             	mov    %eax,(%esp)
c01010b8:	e8 70 ff ff ff       	call   c010102d <lpt_putc_sub>
c01010bd:	eb 24                	jmp    c01010e3 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010bf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010c6:	e8 62 ff ff ff       	call   c010102d <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d2:	e8 56 ff ff ff       	call   c010102d <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010de:	e8 4a ff ff ff       	call   c010102d <lpt_putc_sub>
    }
}
c01010e3:	c9                   	leave  
c01010e4:	c3                   	ret    

c01010e5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e5:	55                   	push   %ebp
c01010e6:	89 e5                	mov    %esp,%ebp
c01010e8:	53                   	push   %ebx
c01010e9:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ef:	b0 00                	mov    $0x0,%al
c01010f1:	85 c0                	test   %eax,%eax
c01010f3:	75 07                	jne    c01010fc <cga_putc+0x17>
        c |= 0x0700;
c01010f5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ff:	0f b6 c0             	movzbl %al,%eax
c0101102:	83 f8 0a             	cmp    $0xa,%eax
c0101105:	74 4c                	je     c0101153 <cga_putc+0x6e>
c0101107:	83 f8 0d             	cmp    $0xd,%eax
c010110a:	74 57                	je     c0101163 <cga_putc+0x7e>
c010110c:	83 f8 08             	cmp    $0x8,%eax
c010110f:	0f 85 88 00 00 00    	jne    c010119d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101115:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010111c:	66 85 c0             	test   %ax,%ax
c010111f:	74 30                	je     c0101151 <cga_putc+0x6c>
            crt_pos --;
c0101121:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101128:	83 e8 01             	sub    $0x1,%eax
c010112b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101131:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101136:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010113d:	0f b7 d2             	movzwl %dx,%edx
c0101140:	01 d2                	add    %edx,%edx
c0101142:	01 c2                	add    %eax,%edx
c0101144:	8b 45 08             	mov    0x8(%ebp),%eax
c0101147:	b0 00                	mov    $0x0,%al
c0101149:	83 c8 20             	or     $0x20,%eax
c010114c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010114f:	eb 72                	jmp    c01011c3 <cga_putc+0xde>
c0101151:	eb 70                	jmp    c01011c3 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101153:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010115a:	83 c0 50             	add    $0x50,%eax
c010115d:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101163:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010116a:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101171:	0f b7 c1             	movzwl %cx,%eax
c0101174:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010117a:	c1 e8 10             	shr    $0x10,%eax
c010117d:	89 c2                	mov    %eax,%edx
c010117f:	66 c1 ea 06          	shr    $0x6,%dx
c0101183:	89 d0                	mov    %edx,%eax
c0101185:	c1 e0 02             	shl    $0x2,%eax
c0101188:	01 d0                	add    %edx,%eax
c010118a:	c1 e0 04             	shl    $0x4,%eax
c010118d:	29 c1                	sub    %eax,%ecx
c010118f:	89 ca                	mov    %ecx,%edx
c0101191:	89 d8                	mov    %ebx,%eax
c0101193:	29 d0                	sub    %edx,%eax
c0101195:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010119b:	eb 26                	jmp    c01011c3 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010119d:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a3:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011aa:	8d 50 01             	lea    0x1(%eax),%edx
c01011ad:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011b4:	0f b7 c0             	movzwl %ax,%eax
c01011b7:	01 c0                	add    %eax,%eax
c01011b9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011bf:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c2:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c3:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ca:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ce:	76 5b                	jbe    c010122b <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d0:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011d5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011db:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e0:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011e7:	00 
c01011e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011ec:	89 04 24             	mov    %eax,(%esp)
c01011ef:	e8 57 4e 00 00       	call   c010604b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011fb:	eb 15                	jmp    c0101212 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c01011fd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101202:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101205:	01 d2                	add    %edx,%edx
c0101207:	01 d0                	add    %edx,%eax
c0101209:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101212:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101219:	7e e2                	jle    c01011fd <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010121b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101222:	83 e8 50             	sub    $0x50,%eax
c0101225:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010122b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101232:	0f b7 c0             	movzwl %ax,%eax
c0101235:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101239:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010123d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101241:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101245:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101246:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010124d:	66 c1 e8 08          	shr    $0x8,%ax
c0101251:	0f b6 c0             	movzbl %al,%eax
c0101254:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010125b:	83 c2 01             	add    $0x1,%edx
c010125e:	0f b7 d2             	movzwl %dx,%edx
c0101261:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101265:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101268:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010126c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101270:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101271:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101278:	0f b7 c0             	movzwl %ax,%eax
c010127b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010127f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101283:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101287:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010128b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010128c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101293:	0f b6 c0             	movzbl %al,%eax
c0101296:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010129d:	83 c2 01             	add    $0x1,%edx
c01012a0:	0f b7 d2             	movzwl %dx,%edx
c01012a3:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012a7:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012aa:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ae:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b2:	ee                   	out    %al,(%dx)
}
c01012b3:	83 c4 34             	add    $0x34,%esp
c01012b6:	5b                   	pop    %ebx
c01012b7:	5d                   	pop    %ebp
c01012b8:	c3                   	ret    

c01012b9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012b9:	55                   	push   %ebp
c01012ba:	89 e5                	mov    %esp,%ebp
c01012bc:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012c6:	eb 09                	jmp    c01012d1 <serial_putc_sub+0x18>
        delay();
c01012c8:	e8 4f fb ff ff       	call   c0100e1c <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012d7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012db:	89 c2                	mov    %eax,%edx
c01012dd:	ec                   	in     (%dx),%al
c01012de:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012e5:	0f b6 c0             	movzbl %al,%eax
c01012e8:	83 e0 20             	and    $0x20,%eax
c01012eb:	85 c0                	test   %eax,%eax
c01012ed:	75 09                	jne    c01012f8 <serial_putc_sub+0x3f>
c01012ef:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012f6:	7e d0                	jle    c01012c8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012fb:	0f b6 c0             	movzbl %al,%eax
c01012fe:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101304:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101307:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010130b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010130f:	ee                   	out    %al,(%dx)
}
c0101310:	c9                   	leave  
c0101311:	c3                   	ret    

c0101312 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101312:	55                   	push   %ebp
c0101313:	89 e5                	mov    %esp,%ebp
c0101315:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101318:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010131c:	74 0d                	je     c010132b <serial_putc+0x19>
        serial_putc_sub(c);
c010131e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101321:	89 04 24             	mov    %eax,(%esp)
c0101324:	e8 90 ff ff ff       	call   c01012b9 <serial_putc_sub>
c0101329:	eb 24                	jmp    c010134f <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010132b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101332:	e8 82 ff ff ff       	call   c01012b9 <serial_putc_sub>
        serial_putc_sub(' ');
c0101337:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010133e:	e8 76 ff ff ff       	call   c01012b9 <serial_putc_sub>
        serial_putc_sub('\b');
c0101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134a:	e8 6a ff ff ff       	call   c01012b9 <serial_putc_sub>
    }
}
c010134f:	c9                   	leave  
c0101350:	c3                   	ret    

c0101351 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101351:	55                   	push   %ebp
c0101352:	89 e5                	mov    %esp,%ebp
c0101354:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101357:	eb 33                	jmp    c010138c <cons_intr+0x3b>
        if (c != 0) {
c0101359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010135d:	74 2d                	je     c010138c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010135f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101364:	8d 50 01             	lea    0x1(%eax),%edx
c0101367:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101370:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101376:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010137b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101380:	75 0a                	jne    c010138c <cons_intr+0x3b>
                cons.wpos = 0;
c0101382:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101389:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010138c:	8b 45 08             	mov    0x8(%ebp),%eax
c010138f:	ff d0                	call   *%eax
c0101391:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101394:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101398:	75 bf                	jne    c0101359 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010139a:	c9                   	leave  
c010139b:	c3                   	ret    

c010139c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010139c:	55                   	push   %ebp
c010139d:	89 e5                	mov    %esp,%ebp
c010139f:	83 ec 10             	sub    $0x10,%esp
c01013a2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013ac:	89 c2                	mov    %eax,%edx
c01013ae:	ec                   	in     (%dx),%al
c01013af:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013b6:	0f b6 c0             	movzbl %al,%eax
c01013b9:	83 e0 01             	and    $0x1,%eax
c01013bc:	85 c0                	test   %eax,%eax
c01013be:	75 07                	jne    c01013c7 <serial_proc_data+0x2b>
        return -1;
c01013c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013c5:	eb 2a                	jmp    c01013f1 <serial_proc_data+0x55>
c01013c7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d1:	89 c2                	mov    %eax,%edx
c01013d3:	ec                   	in     (%dx),%al
c01013d4:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013d7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013db:	0f b6 c0             	movzbl %al,%eax
c01013de:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013e5:	75 07                	jne    c01013ee <serial_proc_data+0x52>
        c = '\b';
c01013e7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f1:	c9                   	leave  
c01013f2:	c3                   	ret    

c01013f3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f3:	55                   	push   %ebp
c01013f4:	89 e5                	mov    %esp,%ebp
c01013f6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013f9:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013fe:	85 c0                	test   %eax,%eax
c0101400:	74 0c                	je     c010140e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101402:	c7 04 24 9c 13 10 c0 	movl   $0xc010139c,(%esp)
c0101409:	e8 43 ff ff ff       	call   c0101351 <cons_intr>
    }
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 38             	sub    $0x38,%esp
c0101416:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101420:	89 c2                	mov    %eax,%edx
c0101422:	ec                   	in     (%dx),%al
c0101423:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101426:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010142a:	0f b6 c0             	movzbl %al,%eax
c010142d:	83 e0 01             	and    $0x1,%eax
c0101430:	85 c0                	test   %eax,%eax
c0101432:	75 0a                	jne    c010143e <kbd_proc_data+0x2e>
        return -1;
c0101434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101439:	e9 59 01 00 00       	jmp    c0101597 <kbd_proc_data+0x187>
c010143e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101444:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101448:	89 c2                	mov    %eax,%edx
c010144a:	ec                   	in     (%dx),%al
c010144b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010144e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101452:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101455:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101459:	75 17                	jne    c0101472 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010145b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101460:	83 c8 40             	or     $0x40,%eax
c0101463:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101468:	b8 00 00 00 00       	mov    $0x0,%eax
c010146d:	e9 25 01 00 00       	jmp    c0101597 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101476:	84 c0                	test   %al,%al
c0101478:	79 47                	jns    c01014c1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010147a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010147f:	83 e0 40             	and    $0x40,%eax
c0101482:	85 c0                	test   %eax,%eax
c0101484:	75 09                	jne    c010148f <kbd_proc_data+0x7f>
c0101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148a:	83 e0 7f             	and    $0x7f,%eax
c010148d:	eb 04                	jmp    c0101493 <kbd_proc_data+0x83>
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149a:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a1:	83 c8 40             	or     $0x40,%eax
c01014a4:	0f b6 c0             	movzbl %al,%eax
c01014a7:	f7 d0                	not    %eax
c01014a9:	89 c2                	mov    %eax,%edx
c01014ab:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b0:	21 d0                	and    %edx,%eax
c01014b2:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014b7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014bc:	e9 d6 00 00 00       	jmp    c0101597 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c6:	83 e0 40             	and    $0x40,%eax
c01014c9:	85 c0                	test   %eax,%eax
c01014cb:	74 11                	je     c01014de <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014cd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d6:	83 e0 bf             	and    $0xffffffbf,%eax
c01014d9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e2:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014e9:	0f b6 d0             	movzbl %al,%edx
c01014ec:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f1:	09 d0                	or     %edx,%eax
c01014f3:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fc:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101503:	0f b6 d0             	movzbl %al,%edx
c0101506:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010150b:	31 d0                	xor    %edx,%eax
c010150d:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101512:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101517:	83 e0 03             	and    $0x3,%eax
c010151a:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101525:	01 d0                	add    %edx,%eax
c0101527:	0f b6 00             	movzbl (%eax),%eax
c010152a:	0f b6 c0             	movzbl %al,%eax
c010152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101530:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101535:	83 e0 08             	and    $0x8,%eax
c0101538:	85 c0                	test   %eax,%eax
c010153a:	74 22                	je     c010155e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010153c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101540:	7e 0c                	jle    c010154e <kbd_proc_data+0x13e>
c0101542:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101546:	7f 06                	jg     c010154e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101548:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010154c:	eb 10                	jmp    c010155e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010154e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101552:	7e 0a                	jle    c010155e <kbd_proc_data+0x14e>
c0101554:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101558:	7f 04                	jg     c010155e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010155a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010155e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101563:	f7 d0                	not    %eax
c0101565:	83 e0 06             	and    $0x6,%eax
c0101568:	85 c0                	test   %eax,%eax
c010156a:	75 28                	jne    c0101594 <kbd_proc_data+0x184>
c010156c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101573:	75 1f                	jne    c0101594 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101575:	c7 04 24 bd 64 10 c0 	movl   $0xc01064bd,(%esp)
c010157c:	e8 bb ed ff ff       	call   c010033c <cprintf>
c0101581:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101587:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010158b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010158f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101593:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101594:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101597:	c9                   	leave  
c0101598:	c3                   	ret    

c0101599 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101599:	55                   	push   %ebp
c010159a:	89 e5                	mov    %esp,%ebp
c010159c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010159f:	c7 04 24 10 14 10 c0 	movl   $0xc0101410,(%esp)
c01015a6:	e8 a6 fd ff ff       	call   c0101351 <cons_intr>
}
c01015ab:	c9                   	leave  
c01015ac:	c3                   	ret    

c01015ad <kbd_init>:

static void
kbd_init(void) {
c01015ad:	55                   	push   %ebp
c01015ae:	89 e5                	mov    %esp,%ebp
c01015b0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b3:	e8 e1 ff ff ff       	call   c0101599 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015bf:	e8 3d 01 00 00       	call   c0101701 <pic_enable>
}
c01015c4:	c9                   	leave  
c01015c5:	c3                   	ret    

c01015c6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015c6:	55                   	push   %ebp
c01015c7:	89 e5                	mov    %esp,%ebp
c01015c9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015cc:	e8 93 f8 ff ff       	call   c0100e64 <cga_init>
    serial_init();
c01015d1:	e8 74 f9 ff ff       	call   c0100f4a <serial_init>
    kbd_init();
c01015d6:	e8 d2 ff ff ff       	call   c01015ad <kbd_init>
    if (!serial_exists) {
c01015db:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e0:	85 c0                	test   %eax,%eax
c01015e2:	75 0c                	jne    c01015f0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015e4:	c7 04 24 c9 64 10 c0 	movl   $0xc01064c9,(%esp)
c01015eb:	e8 4c ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f0:	c9                   	leave  
c01015f1:	c3                   	ret    

c01015f2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f2:	55                   	push   %ebp
c01015f3:	89 e5                	mov    %esp,%ebp
c01015f5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015f8:	e8 e2 f7 ff ff       	call   c0100ddf <__intr_save>
c01015fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101600:	8b 45 08             	mov    0x8(%ebp),%eax
c0101603:	89 04 24             	mov    %eax,(%esp)
c0101606:	e8 9b fa ff ff       	call   c01010a6 <lpt_putc>
        cga_putc(c);
c010160b:	8b 45 08             	mov    0x8(%ebp),%eax
c010160e:	89 04 24             	mov    %eax,(%esp)
c0101611:	e8 cf fa ff ff       	call   c01010e5 <cga_putc>
        serial_putc(c);
c0101616:	8b 45 08             	mov    0x8(%ebp),%eax
c0101619:	89 04 24             	mov    %eax,(%esp)
c010161c:	e8 f1 fc ff ff       	call   c0101312 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101621:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101624:	89 04 24             	mov    %eax,(%esp)
c0101627:	e8 dd f7 ff ff       	call   c0100e09 <__intr_restore>
}
c010162c:	c9                   	leave  
c010162d:	c3                   	ret    

c010162e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010162e:	55                   	push   %ebp
c010162f:	89 e5                	mov    %esp,%ebp
c0101631:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010163b:	e8 9f f7 ff ff       	call   c0100ddf <__intr_save>
c0101640:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101643:	e8 ab fd ff ff       	call   c01013f3 <serial_intr>
        kbd_intr();
c0101648:	e8 4c ff ff ff       	call   c0101599 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010164d:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101653:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101658:	39 c2                	cmp    %eax,%edx
c010165a:	74 31                	je     c010168d <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010165c:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101661:	8d 50 01             	lea    0x1(%eax),%edx
c0101664:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010166a:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101671:	0f b6 c0             	movzbl %al,%eax
c0101674:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101677:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010167c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101681:	75 0a                	jne    c010168d <cons_getc+0x5f>
                cons.rpos = 0;
c0101683:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010168a:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101690:	89 04 24             	mov    %eax,(%esp)
c0101693:	e8 71 f7 ff ff       	call   c0100e09 <__intr_restore>
    return c;
c0101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010169b:	c9                   	leave  
c010169c:	c3                   	ret    

c010169d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a0:	fb                   	sti    
    sti();
}
c01016a1:	5d                   	pop    %ebp
c01016a2:	c3                   	ret    

c01016a3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016a6:	fa                   	cli    
    cli();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
c01016ac:	83 ec 14             	sub    $0x14,%esp
c01016af:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ba:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c0:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016c5:	85 c0                	test   %eax,%eax
c01016c7:	74 36                	je     c01016ff <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016c9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cd:	0f b6 c0             	movzbl %al,%eax
c01016d0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016d6:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016d9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016dd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e1:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e6:	66 c1 e8 08          	shr    $0x8,%ax
c01016ea:	0f b6 c0             	movzbl %al,%eax
c01016ed:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f3:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016fa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016fe:	ee                   	out    %al,(%dx)
    }
}
c01016ff:	c9                   	leave  
c0101700:	c3                   	ret    

c0101701 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101701:	55                   	push   %ebp
c0101702:	89 e5                	mov    %esp,%ebp
c0101704:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101707:	8b 45 08             	mov    0x8(%ebp),%eax
c010170a:	ba 01 00 00 00       	mov    $0x1,%edx
c010170f:	89 c1                	mov    %eax,%ecx
c0101711:	d3 e2                	shl    %cl,%edx
c0101713:	89 d0                	mov    %edx,%eax
c0101715:	f7 d0                	not    %eax
c0101717:	89 c2                	mov    %eax,%edx
c0101719:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101720:	21 d0                	and    %edx,%eax
c0101722:	0f b7 c0             	movzwl %ax,%eax
c0101725:	89 04 24             	mov    %eax,(%esp)
c0101728:	e8 7c ff ff ff       	call   c01016a9 <pic_setmask>
}
c010172d:	c9                   	leave  
c010172e:	c3                   	ret    

c010172f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010172f:	55                   	push   %ebp
c0101730:	89 e5                	mov    %esp,%ebp
c0101732:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101735:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010173c:	00 00 00 
c010173f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101745:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101749:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010174d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101751:	ee                   	out    %al,(%dx)
c0101752:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101758:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010175c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101760:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101764:	ee                   	out    %al,(%dx)
c0101765:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010176b:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010176f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101773:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101777:	ee                   	out    %al,(%dx)
c0101778:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010177e:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101782:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101786:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010178a:	ee                   	out    %al,(%dx)
c010178b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101791:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101795:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101799:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010179d:	ee                   	out    %al,(%dx)
c010179e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017a4:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b0:	ee                   	out    %al,(%dx)
c01017b1:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017b7:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c3:	ee                   	out    %al,(%dx)
c01017c4:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017ca:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017d6:	ee                   	out    %al,(%dx)
c01017d7:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017dd:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017e9:	ee                   	out    %al,(%dx)
c01017ea:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f0:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017f4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017f8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017fc:	ee                   	out    %al,(%dx)
c01017fd:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101803:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101807:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010180b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010180f:	ee                   	out    %al,(%dx)
c0101810:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101816:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010181a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010181e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101822:	ee                   	out    %al,(%dx)
c0101823:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101829:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010182d:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101831:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101835:	ee                   	out    %al,(%dx)
c0101836:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010183c:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101840:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101844:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101848:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101849:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101850:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101854:	74 12                	je     c0101868 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101856:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185d:	0f b7 c0             	movzwl %ax,%eax
c0101860:	89 04 24             	mov    %eax,(%esp)
c0101863:	e8 41 fe ff ff       	call   c01016a9 <pic_setmask>
    }
}
c0101868:	c9                   	leave  
c0101869:	c3                   	ret    

c010186a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010186a:	55                   	push   %ebp
c010186b:	89 e5                	mov    %esp,%ebp
c010186d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101870:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101877:	00 
c0101878:	c7 04 24 00 65 10 c0 	movl   $0xc0106500,(%esp)
c010187f:	e8 b8 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101884:	c7 04 24 0a 65 10 c0 	movl   $0xc010650a,(%esp)
c010188b:	e8 ac ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101890:	c7 44 24 08 18 65 10 	movl   $0xc0106518,0x8(%esp)
c0101897:	c0 
c0101898:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010189f:	00 
c01018a0:	c7 04 24 2e 65 10 c0 	movl   $0xc010652e,(%esp)
c01018a7:	e8 14 f4 ff ff       	call   c0100cc0 <__panic>

c01018ac <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018ac:	55                   	push   %ebp
c01018ad:	89 e5                	mov    %esp,%ebp
c01018af:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c01018b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018b9:	e9 5c 02 00 00       	jmp    c0101b1a <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
c01018be:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01018c5:	0f 85 c1 00 00 00    	jne    c010198c <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
c01018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ce:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018d5:	89 c2                	mov    %eax,%edx
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018e1:	c0 
c01018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018ec:	c0 08 00 
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f9:	c0 
c01018fa:	83 e2 e0             	and    $0xffffffe0,%edx
c01018fd:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 1f             	and    $0x1f,%edx
c0101912:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 ca 0f             	or     $0xf,%edx
c0101927:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101938:	c0 
c0101939:	83 e2 ef             	and    $0xffffffef,%edx
c010193c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010194d:	c0 
c010194e:	83 ca 60             	or     $0x60,%edx
c0101951:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101962:	c0 
c0101963:	83 ca 80             	or     $0xffffff80,%edx
c0101966:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101970:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101977:	c1 e8 10             	shr    $0x10,%eax
c010197a:	89 c2                	mov    %eax,%edx
c010197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197f:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101986:	c0 
c0101987:	e9 8a 01 00 00       	jmp    c0101b16 <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
c010198c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c0101990:	0f 8f c1 00 00 00    	jg     c0101a57 <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101999:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01019a0:	89 c2                	mov    %eax,%edx
c01019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a5:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01019ac:	c0 
c01019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b0:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01019b7:	c0 08 00 
c01019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bd:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019c4:	c0 
c01019c5:	83 e2 e0             	and    $0xffffffe0,%edx
c01019c8:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d2:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019d9:	c0 
c01019da:	83 e2 1f             	and    $0x1f,%edx
c01019dd:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e7:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019ee:	c0 
c01019ef:	83 ca 0f             	or     $0xf,%edx
c01019f2:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fc:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a03:	c0 
c0101a04:	83 e2 ef             	and    $0xffffffef,%edx
c0101a07:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a11:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a18:	c0 
c0101a19:	83 e2 9f             	and    $0xffffff9f,%edx
c0101a1c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a26:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a2d:	c0 
c0101a2e:	83 ca 80             	or     $0xffffff80,%edx
c0101a31:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a3b:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101a42:	c1 e8 10             	shr    $0x10,%eax
c0101a45:	89 c2                	mov    %eax,%edx
c0101a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a4a:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101a51:	c0 
c0101a52:	e9 bf 00 00 00       	jmp    c0101b16 <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5a:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101a61:	89 c2                	mov    %eax,%edx
c0101a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a66:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c0101a6d:	c0 
c0101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a71:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c0101a78:	c0 08 00 
c0101a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a7e:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101a85:	c0 
c0101a86:	83 e2 e0             	and    $0xffffffe0,%edx
c0101a89:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a93:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101a9a:	c0 
c0101a9b:	83 e2 1f             	and    $0x1f,%edx
c0101a9e:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aa8:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101aaf:	c0 
c0101ab0:	83 e2 f0             	and    $0xfffffff0,%edx
c0101ab3:	83 ca 0e             	or     $0xe,%edx
c0101ab6:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ac0:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101ac7:	c0 
c0101ac8:	83 e2 ef             	and    $0xffffffef,%edx
c0101acb:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ad5:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101adc:	c0 
c0101add:	83 e2 9f             	and    $0xffffff9f,%edx
c0101ae0:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aea:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101af1:	c0 
c0101af2:	83 ca 80             	or     $0xffffff80,%edx
c0101af5:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aff:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101b06:	c1 e8 10             	shr    $0x10,%eax
c0101b09:	89 c2                	mov    %eax,%edx
c0101b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b0e:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101b15:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c0101b16:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b1d:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101b22:	0f 86 96 fd ff ff    	jbe    c01018be <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], DPL_USER);
c0101b28:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c0101b2d:	66 a3 80 84 11 c0    	mov    %ax,0xc0118480
c0101b33:	66 c7 05 82 84 11 c0 	movw   $0x8,0xc0118482
c0101b3a:	08 00 
c0101b3c:	0f b6 05 84 84 11 c0 	movzbl 0xc0118484,%eax
c0101b43:	83 e0 e0             	and    $0xffffffe0,%eax
c0101b46:	a2 84 84 11 c0       	mov    %al,0xc0118484
c0101b4b:	0f b6 05 84 84 11 c0 	movzbl 0xc0118484,%eax
c0101b52:	83 e0 1f             	and    $0x1f,%eax
c0101b55:	a2 84 84 11 c0       	mov    %al,0xc0118484
c0101b5a:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101b61:	83 e0 f0             	and    $0xfffffff0,%eax
c0101b64:	83 c8 0e             	or     $0xe,%eax
c0101b67:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101b6c:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101b73:	83 e0 ef             	and    $0xffffffef,%eax
c0101b76:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101b7b:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101b82:	83 c8 60             	or     $0x60,%eax
c0101b85:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101b8a:	0f b6 05 85 84 11 c0 	movzbl 0xc0118485,%eax
c0101b91:	83 c8 80             	or     $0xffffff80,%eax
c0101b94:	a2 85 84 11 c0       	mov    %al,0xc0118485
c0101b99:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c0101b9e:	c1 e8 10             	shr    $0x10,%eax
c0101ba1:	66 a3 86 84 11 c0    	mov    %ax,0xc0118486
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101ba7:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101bac:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101bb2:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101bb9:	08 00 
c0101bbb:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101bc2:	83 e0 e0             	and    $0xffffffe0,%eax
c0101bc5:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101bca:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101bd1:	83 e0 1f             	and    $0x1f,%eax
c0101bd4:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101bd9:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101be0:	83 e0 f0             	and    $0xfffffff0,%eax
c0101be3:	83 c8 0e             	or     $0xe,%eax
c0101be6:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101beb:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101bf2:	83 e0 ef             	and    $0xffffffef,%eax
c0101bf5:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101bfa:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101c01:	83 c8 60             	or     $0x60,%eax
c0101c04:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101c09:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101c10:	83 c8 80             	or     $0xffffff80,%eax
c0101c13:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101c18:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101c1d:	c1 e8 10             	shr    $0x10,%eax
c0101c20:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101c26:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c30:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101c33:	c9                   	leave  
c0101c34:	c3                   	ret    

c0101c35 <trapname>:

static const char *
trapname(int trapno) {
c0101c35:	55                   	push   %ebp
c0101c36:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3b:	83 f8 13             	cmp    $0x13,%eax
c0101c3e:	77 0c                	ja     c0101c4c <trapname+0x17>
        return excnames[trapno];
c0101c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c43:	8b 04 85 80 68 10 c0 	mov    -0x3fef9780(,%eax,4),%eax
c0101c4a:	eb 18                	jmp    c0101c64 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101c4c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101c50:	7e 0d                	jle    c0101c5f <trapname+0x2a>
c0101c52:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101c56:	7f 07                	jg     c0101c5f <trapname+0x2a>
        return "Hardware Interrupt";
c0101c58:	b8 3f 65 10 c0       	mov    $0xc010653f,%eax
c0101c5d:	eb 05                	jmp    c0101c64 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101c5f:	b8 52 65 10 c0       	mov    $0xc0106552,%eax
}
c0101c64:	5d                   	pop    %ebp
c0101c65:	c3                   	ret    

c0101c66 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101c66:	55                   	push   %ebp
c0101c67:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c70:	66 83 f8 08          	cmp    $0x8,%ax
c0101c74:	0f 94 c0             	sete   %al
c0101c77:	0f b6 c0             	movzbl %al,%eax
}
c0101c7a:	5d                   	pop    %ebp
c0101c7b:	c3                   	ret    

c0101c7c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101c7c:	55                   	push   %ebp
c0101c7d:	89 e5                	mov    %esp,%ebp
c0101c7f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c89:	c7 04 24 93 65 10 c0 	movl   $0xc0106593,(%esp)
c0101c90:	e8 a7 e6 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c98:	89 04 24             	mov    %eax,(%esp)
c0101c9b:	e8 a1 01 00 00       	call   c0101e41 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ca7:	0f b7 c0             	movzwl %ax,%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 a4 65 10 c0 	movl   $0xc01065a4,(%esp)
c0101cb5:	e8 82 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101cc1:	0f b7 c0             	movzwl %ax,%eax
c0101cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc8:	c7 04 24 b7 65 10 c0 	movl   $0xc01065b7,(%esp)
c0101ccf:	e8 68 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101cdb:	0f b7 c0             	movzwl %ax,%eax
c0101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce2:	c7 04 24 ca 65 10 c0 	movl   $0xc01065ca,(%esp)
c0101ce9:	e8 4e e6 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101cf5:	0f b7 c0             	movzwl %ax,%eax
c0101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfc:	c7 04 24 dd 65 10 c0 	movl   $0xc01065dd,(%esp)
c0101d03:	e8 34 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0b:	8b 40 30             	mov    0x30(%eax),%eax
c0101d0e:	89 04 24             	mov    %eax,(%esp)
c0101d11:	e8 1f ff ff ff       	call   c0101c35 <trapname>
c0101d16:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d19:	8b 52 30             	mov    0x30(%edx),%edx
c0101d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101d20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101d24:	c7 04 24 f0 65 10 c0 	movl   $0xc01065f0,(%esp)
c0101d2b:	e8 0c e6 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d33:	8b 40 34             	mov    0x34(%eax),%eax
c0101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3a:	c7 04 24 02 66 10 c0 	movl   $0xc0106602,(%esp)
c0101d41:	e8 f6 e5 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d49:	8b 40 38             	mov    0x38(%eax),%eax
c0101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d50:	c7 04 24 11 66 10 c0 	movl   $0xc0106611,(%esp)
c0101d57:	e8 e0 e5 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d63:	0f b7 c0             	movzwl %ax,%eax
c0101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6a:	c7 04 24 20 66 10 c0 	movl   $0xc0106620,(%esp)
c0101d71:	e8 c6 e5 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d79:	8b 40 40             	mov    0x40(%eax),%eax
c0101d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d80:	c7 04 24 33 66 10 c0 	movl   $0xc0106633,(%esp)
c0101d87:	e8 b0 e5 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101d93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101d9a:	eb 3e                	jmp    c0101dda <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d9f:	8b 50 40             	mov    0x40(%eax),%edx
c0101da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101da5:	21 d0                	and    %edx,%eax
c0101da7:	85 c0                	test   %eax,%eax
c0101da9:	74 28                	je     c0101dd3 <print_trapframe+0x157>
c0101dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dae:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101db5:	85 c0                	test   %eax,%eax
c0101db7:	74 1a                	je     c0101dd3 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dbc:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc7:	c7 04 24 42 66 10 c0 	movl   $0xc0106642,(%esp)
c0101dce:	e8 69 e5 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101dd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101dd7:	d1 65 f0             	shll   -0x10(%ebp)
c0101dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ddd:	83 f8 17             	cmp    $0x17,%eax
c0101de0:	76 ba                	jbe    c0101d9c <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101de2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de5:	8b 40 40             	mov    0x40(%eax),%eax
c0101de8:	25 00 30 00 00       	and    $0x3000,%eax
c0101ded:	c1 e8 0c             	shr    $0xc,%eax
c0101df0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df4:	c7 04 24 46 66 10 c0 	movl   $0xc0106646,(%esp)
c0101dfb:	e8 3c e5 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101e00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e03:	89 04 24             	mov    %eax,(%esp)
c0101e06:	e8 5b fe ff ff       	call   c0101c66 <trap_in_kernel>
c0101e0b:	85 c0                	test   %eax,%eax
c0101e0d:	75 30                	jne    c0101e3f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e12:	8b 40 44             	mov    0x44(%eax),%eax
c0101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e19:	c7 04 24 4f 66 10 c0 	movl   $0xc010664f,(%esp)
c0101e20:	e8 17 e5 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e28:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101e2c:	0f b7 c0             	movzwl %ax,%eax
c0101e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e33:	c7 04 24 5e 66 10 c0 	movl   $0xc010665e,(%esp)
c0101e3a:	e8 fd e4 ff ff       	call   c010033c <cprintf>
    }
}
c0101e3f:	c9                   	leave  
c0101e40:	c3                   	ret    

c0101e41 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101e41:	55                   	push   %ebp
c0101e42:	89 e5                	mov    %esp,%ebp
c0101e44:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4a:	8b 00                	mov    (%eax),%eax
c0101e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e50:	c7 04 24 71 66 10 c0 	movl   $0xc0106671,(%esp)
c0101e57:	e8 e0 e4 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5f:	8b 40 04             	mov    0x4(%eax),%eax
c0101e62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e66:	c7 04 24 80 66 10 c0 	movl   $0xc0106680,(%esp)
c0101e6d:	e8 ca e4 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e75:	8b 40 08             	mov    0x8(%eax),%eax
c0101e78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e7c:	c7 04 24 8f 66 10 c0 	movl   $0xc010668f,(%esp)
c0101e83:	e8 b4 e4 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101e88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8b:	8b 40 0c             	mov    0xc(%eax),%eax
c0101e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e92:	c7 04 24 9e 66 10 c0 	movl   $0xc010669e,(%esp)
c0101e99:	e8 9e e4 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea1:	8b 40 10             	mov    0x10(%eax),%eax
c0101ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ea8:	c7 04 24 ad 66 10 c0 	movl   $0xc01066ad,(%esp)
c0101eaf:	e8 88 e4 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb7:	8b 40 14             	mov    0x14(%eax),%eax
c0101eba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ebe:	c7 04 24 bc 66 10 c0 	movl   $0xc01066bc,(%esp)
c0101ec5:	e8 72 e4 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecd:	8b 40 18             	mov    0x18(%eax),%eax
c0101ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ed4:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0101edb:	e8 5c e4 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee3:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101eea:	c7 04 24 da 66 10 c0 	movl   $0xc01066da,(%esp)
c0101ef1:	e8 46 e4 ff ff       	call   c010033c <cprintf>
}
c0101ef6:	c9                   	leave  
c0101ef7:	c3                   	ret    

c0101ef8 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ef8:	55                   	push   %ebp
c0101ef9:	89 e5                	mov    %esp,%ebp
c0101efb:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101efe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f01:	8b 40 30             	mov    0x30(%eax),%eax
c0101f04:	83 f8 2f             	cmp    $0x2f,%eax
c0101f07:	77 21                	ja     c0101f2a <trap_dispatch+0x32>
c0101f09:	83 f8 2e             	cmp    $0x2e,%eax
c0101f0c:	0f 83 04 01 00 00    	jae    c0102016 <trap_dispatch+0x11e>
c0101f12:	83 f8 21             	cmp    $0x21,%eax
c0101f15:	0f 84 81 00 00 00    	je     c0101f9c <trap_dispatch+0xa4>
c0101f1b:	83 f8 24             	cmp    $0x24,%eax
c0101f1e:	74 56                	je     c0101f76 <trap_dispatch+0x7e>
c0101f20:	83 f8 20             	cmp    $0x20,%eax
c0101f23:	74 16                	je     c0101f3b <trap_dispatch+0x43>
c0101f25:	e9 b4 00 00 00       	jmp    c0101fde <trap_dispatch+0xe6>
c0101f2a:	83 e8 78             	sub    $0x78,%eax
c0101f2d:	83 f8 01             	cmp    $0x1,%eax
c0101f30:	0f 87 a8 00 00 00    	ja     c0101fde <trap_dispatch+0xe6>
c0101f36:	e9 87 00 00 00       	jmp    c0101fc2 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks++;
c0101f3b:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101f40:	83 c0 01             	add    $0x1,%eax
c0101f43:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
		if(ticks % TICK_NUM == 0)
c0101f48:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101f4e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101f53:	89 c8                	mov    %ecx,%eax
c0101f55:	f7 e2                	mul    %edx
c0101f57:	89 d0                	mov    %edx,%eax
c0101f59:	c1 e8 05             	shr    $0x5,%eax
c0101f5c:	6b c0 64             	imul   $0x64,%eax,%eax
c0101f5f:	29 c1                	sub    %eax,%ecx
c0101f61:	89 c8                	mov    %ecx,%eax
c0101f63:	85 c0                	test   %eax,%eax
c0101f65:	75 0a                	jne    c0101f71 <trap_dispatch+0x79>
		{
			print_ticks();
c0101f67:	e8 fe f8 ff ff       	call   c010186a <print_ticks>
		}
		break;
c0101f6c:	e9 a6 00 00 00       	jmp    c0102017 <trap_dispatch+0x11f>
c0101f71:	e9 a1 00 00 00       	jmp    c0102017 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101f76:	e8 b3 f6 ff ff       	call   c010162e <cons_getc>
c0101f7b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101f7e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101f82:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101f86:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f8e:	c7 04 24 e9 66 10 c0 	movl   $0xc01066e9,(%esp)
c0101f95:	e8 a2 e3 ff ff       	call   c010033c <cprintf>
        break;
c0101f9a:	eb 7b                	jmp    c0102017 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101f9c:	e8 8d f6 ff ff       	call   c010162e <cons_getc>
c0101fa1:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101fa4:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101fa8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101fac:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101fb4:	c7 04 24 fb 66 10 c0 	movl   $0xc01066fb,(%esp)
c0101fbb:	e8 7c e3 ff ff       	call   c010033c <cprintf>
        break;
c0101fc0:	eb 55                	jmp    c0102017 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101fc2:	c7 44 24 08 0a 67 10 	movl   $0xc010670a,0x8(%esp)
c0101fc9:	c0 
c0101fca:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101fd1:	00 
c0101fd2:	c7 04 24 2e 65 10 c0 	movl   $0xc010652e,(%esp)
c0101fd9:	e8 e2 ec ff ff       	call   c0100cc0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101fde:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fe1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fe5:	0f b7 c0             	movzwl %ax,%eax
c0101fe8:	83 e0 03             	and    $0x3,%eax
c0101feb:	85 c0                	test   %eax,%eax
c0101fed:	75 28                	jne    c0102017 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101fef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff2:	89 04 24             	mov    %eax,(%esp)
c0101ff5:	e8 82 fc ff ff       	call   c0101c7c <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101ffa:	c7 44 24 08 1a 67 10 	movl   $0xc010671a,0x8(%esp)
c0102001:	c0 
c0102002:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0102009:	00 
c010200a:	c7 04 24 2e 65 10 c0 	movl   $0xc010652e,(%esp)
c0102011:	e8 aa ec ff ff       	call   c0100cc0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102016:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102017:	c9                   	leave  
c0102018:	c3                   	ret    

c0102019 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102019:	55                   	push   %ebp
c010201a:	89 e5                	mov    %esp,%ebp
c010201c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010201f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102022:	89 04 24             	mov    %eax,(%esp)
c0102025:	e8 ce fe ff ff       	call   c0101ef8 <trap_dispatch>
}
c010202a:	c9                   	leave  
c010202b:	c3                   	ret    

c010202c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010202c:	1e                   	push   %ds
    pushl %es
c010202d:	06                   	push   %es
    pushl %fs
c010202e:	0f a0                	push   %fs
    pushl %gs
c0102030:	0f a8                	push   %gs
    pushal
c0102032:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102033:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102038:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010203a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010203c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010203d:	e8 d7 ff ff ff       	call   c0102019 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102042:	5c                   	pop    %esp

c0102043 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102043:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102044:	0f a9                	pop    %gs
    popl %fs
c0102046:	0f a1                	pop    %fs
    popl %es
c0102048:	07                   	pop    %es
    popl %ds
c0102049:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010204a:	83 c4 08             	add    $0x8,%esp
    iret
c010204d:	cf                   	iret   

c010204e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $0
c0102050:	6a 00                	push   $0x0
  jmp __alltraps
c0102052:	e9 d5 ff ff ff       	jmp    c010202c <__alltraps>

c0102057 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $1
c0102059:	6a 01                	push   $0x1
  jmp __alltraps
c010205b:	e9 cc ff ff ff       	jmp    c010202c <__alltraps>

c0102060 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $2
c0102062:	6a 02                	push   $0x2
  jmp __alltraps
c0102064:	e9 c3 ff ff ff       	jmp    c010202c <__alltraps>

c0102069 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $3
c010206b:	6a 03                	push   $0x3
  jmp __alltraps
c010206d:	e9 ba ff ff ff       	jmp    c010202c <__alltraps>

c0102072 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $4
c0102074:	6a 04                	push   $0x4
  jmp __alltraps
c0102076:	e9 b1 ff ff ff       	jmp    c010202c <__alltraps>

c010207b <vector5>:
.globl vector5
vector5:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $5
c010207d:	6a 05                	push   $0x5
  jmp __alltraps
c010207f:	e9 a8 ff ff ff       	jmp    c010202c <__alltraps>

c0102084 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $6
c0102086:	6a 06                	push   $0x6
  jmp __alltraps
c0102088:	e9 9f ff ff ff       	jmp    c010202c <__alltraps>

c010208d <vector7>:
.globl vector7
vector7:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $7
c010208f:	6a 07                	push   $0x7
  jmp __alltraps
c0102091:	e9 96 ff ff ff       	jmp    c010202c <__alltraps>

c0102096 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102096:	6a 08                	push   $0x8
  jmp __alltraps
c0102098:	e9 8f ff ff ff       	jmp    c010202c <__alltraps>

c010209d <vector9>:
.globl vector9
vector9:
  pushl $9
c010209d:	6a 09                	push   $0x9
  jmp __alltraps
c010209f:	e9 88 ff ff ff       	jmp    c010202c <__alltraps>

c01020a4 <vector10>:
.globl vector10
vector10:
  pushl $10
c01020a4:	6a 0a                	push   $0xa
  jmp __alltraps
c01020a6:	e9 81 ff ff ff       	jmp    c010202c <__alltraps>

c01020ab <vector11>:
.globl vector11
vector11:
  pushl $11
c01020ab:	6a 0b                	push   $0xb
  jmp __alltraps
c01020ad:	e9 7a ff ff ff       	jmp    c010202c <__alltraps>

c01020b2 <vector12>:
.globl vector12
vector12:
  pushl $12
c01020b2:	6a 0c                	push   $0xc
  jmp __alltraps
c01020b4:	e9 73 ff ff ff       	jmp    c010202c <__alltraps>

c01020b9 <vector13>:
.globl vector13
vector13:
  pushl $13
c01020b9:	6a 0d                	push   $0xd
  jmp __alltraps
c01020bb:	e9 6c ff ff ff       	jmp    c010202c <__alltraps>

c01020c0 <vector14>:
.globl vector14
vector14:
  pushl $14
c01020c0:	6a 0e                	push   $0xe
  jmp __alltraps
c01020c2:	e9 65 ff ff ff       	jmp    c010202c <__alltraps>

c01020c7 <vector15>:
.globl vector15
vector15:
  pushl $0
c01020c7:	6a 00                	push   $0x0
  pushl $15
c01020c9:	6a 0f                	push   $0xf
  jmp __alltraps
c01020cb:	e9 5c ff ff ff       	jmp    c010202c <__alltraps>

c01020d0 <vector16>:
.globl vector16
vector16:
  pushl $0
c01020d0:	6a 00                	push   $0x0
  pushl $16
c01020d2:	6a 10                	push   $0x10
  jmp __alltraps
c01020d4:	e9 53 ff ff ff       	jmp    c010202c <__alltraps>

c01020d9 <vector17>:
.globl vector17
vector17:
  pushl $17
c01020d9:	6a 11                	push   $0x11
  jmp __alltraps
c01020db:	e9 4c ff ff ff       	jmp    c010202c <__alltraps>

c01020e0 <vector18>:
.globl vector18
vector18:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $18
c01020e2:	6a 12                	push   $0x12
  jmp __alltraps
c01020e4:	e9 43 ff ff ff       	jmp    c010202c <__alltraps>

c01020e9 <vector19>:
.globl vector19
vector19:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $19
c01020eb:	6a 13                	push   $0x13
  jmp __alltraps
c01020ed:	e9 3a ff ff ff       	jmp    c010202c <__alltraps>

c01020f2 <vector20>:
.globl vector20
vector20:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $20
c01020f4:	6a 14                	push   $0x14
  jmp __alltraps
c01020f6:	e9 31 ff ff ff       	jmp    c010202c <__alltraps>

c01020fb <vector21>:
.globl vector21
vector21:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $21
c01020fd:	6a 15                	push   $0x15
  jmp __alltraps
c01020ff:	e9 28 ff ff ff       	jmp    c010202c <__alltraps>

c0102104 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $22
c0102106:	6a 16                	push   $0x16
  jmp __alltraps
c0102108:	e9 1f ff ff ff       	jmp    c010202c <__alltraps>

c010210d <vector23>:
.globl vector23
vector23:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $23
c010210f:	6a 17                	push   $0x17
  jmp __alltraps
c0102111:	e9 16 ff ff ff       	jmp    c010202c <__alltraps>

c0102116 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $24
c0102118:	6a 18                	push   $0x18
  jmp __alltraps
c010211a:	e9 0d ff ff ff       	jmp    c010202c <__alltraps>

c010211f <vector25>:
.globl vector25
vector25:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $25
c0102121:	6a 19                	push   $0x19
  jmp __alltraps
c0102123:	e9 04 ff ff ff       	jmp    c010202c <__alltraps>

c0102128 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $26
c010212a:	6a 1a                	push   $0x1a
  jmp __alltraps
c010212c:	e9 fb fe ff ff       	jmp    c010202c <__alltraps>

c0102131 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $27
c0102133:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102135:	e9 f2 fe ff ff       	jmp    c010202c <__alltraps>

c010213a <vector28>:
.globl vector28
vector28:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $28
c010213c:	6a 1c                	push   $0x1c
  jmp __alltraps
c010213e:	e9 e9 fe ff ff       	jmp    c010202c <__alltraps>

c0102143 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $29
c0102145:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102147:	e9 e0 fe ff ff       	jmp    c010202c <__alltraps>

c010214c <vector30>:
.globl vector30
vector30:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $30
c010214e:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102150:	e9 d7 fe ff ff       	jmp    c010202c <__alltraps>

c0102155 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $31
c0102157:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102159:	e9 ce fe ff ff       	jmp    c010202c <__alltraps>

c010215e <vector32>:
.globl vector32
vector32:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $32
c0102160:	6a 20                	push   $0x20
  jmp __alltraps
c0102162:	e9 c5 fe ff ff       	jmp    c010202c <__alltraps>

c0102167 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $33
c0102169:	6a 21                	push   $0x21
  jmp __alltraps
c010216b:	e9 bc fe ff ff       	jmp    c010202c <__alltraps>

c0102170 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $34
c0102172:	6a 22                	push   $0x22
  jmp __alltraps
c0102174:	e9 b3 fe ff ff       	jmp    c010202c <__alltraps>

c0102179 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $35
c010217b:	6a 23                	push   $0x23
  jmp __alltraps
c010217d:	e9 aa fe ff ff       	jmp    c010202c <__alltraps>

c0102182 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $36
c0102184:	6a 24                	push   $0x24
  jmp __alltraps
c0102186:	e9 a1 fe ff ff       	jmp    c010202c <__alltraps>

c010218b <vector37>:
.globl vector37
vector37:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $37
c010218d:	6a 25                	push   $0x25
  jmp __alltraps
c010218f:	e9 98 fe ff ff       	jmp    c010202c <__alltraps>

c0102194 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $38
c0102196:	6a 26                	push   $0x26
  jmp __alltraps
c0102198:	e9 8f fe ff ff       	jmp    c010202c <__alltraps>

c010219d <vector39>:
.globl vector39
vector39:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $39
c010219f:	6a 27                	push   $0x27
  jmp __alltraps
c01021a1:	e9 86 fe ff ff       	jmp    c010202c <__alltraps>

c01021a6 <vector40>:
.globl vector40
vector40:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $40
c01021a8:	6a 28                	push   $0x28
  jmp __alltraps
c01021aa:	e9 7d fe ff ff       	jmp    c010202c <__alltraps>

c01021af <vector41>:
.globl vector41
vector41:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $41
c01021b1:	6a 29                	push   $0x29
  jmp __alltraps
c01021b3:	e9 74 fe ff ff       	jmp    c010202c <__alltraps>

c01021b8 <vector42>:
.globl vector42
vector42:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $42
c01021ba:	6a 2a                	push   $0x2a
  jmp __alltraps
c01021bc:	e9 6b fe ff ff       	jmp    c010202c <__alltraps>

c01021c1 <vector43>:
.globl vector43
vector43:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $43
c01021c3:	6a 2b                	push   $0x2b
  jmp __alltraps
c01021c5:	e9 62 fe ff ff       	jmp    c010202c <__alltraps>

c01021ca <vector44>:
.globl vector44
vector44:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $44
c01021cc:	6a 2c                	push   $0x2c
  jmp __alltraps
c01021ce:	e9 59 fe ff ff       	jmp    c010202c <__alltraps>

c01021d3 <vector45>:
.globl vector45
vector45:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $45
c01021d5:	6a 2d                	push   $0x2d
  jmp __alltraps
c01021d7:	e9 50 fe ff ff       	jmp    c010202c <__alltraps>

c01021dc <vector46>:
.globl vector46
vector46:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $46
c01021de:	6a 2e                	push   $0x2e
  jmp __alltraps
c01021e0:	e9 47 fe ff ff       	jmp    c010202c <__alltraps>

c01021e5 <vector47>:
.globl vector47
vector47:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $47
c01021e7:	6a 2f                	push   $0x2f
  jmp __alltraps
c01021e9:	e9 3e fe ff ff       	jmp    c010202c <__alltraps>

c01021ee <vector48>:
.globl vector48
vector48:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $48
c01021f0:	6a 30                	push   $0x30
  jmp __alltraps
c01021f2:	e9 35 fe ff ff       	jmp    c010202c <__alltraps>

c01021f7 <vector49>:
.globl vector49
vector49:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $49
c01021f9:	6a 31                	push   $0x31
  jmp __alltraps
c01021fb:	e9 2c fe ff ff       	jmp    c010202c <__alltraps>

c0102200 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $50
c0102202:	6a 32                	push   $0x32
  jmp __alltraps
c0102204:	e9 23 fe ff ff       	jmp    c010202c <__alltraps>

c0102209 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $51
c010220b:	6a 33                	push   $0x33
  jmp __alltraps
c010220d:	e9 1a fe ff ff       	jmp    c010202c <__alltraps>

c0102212 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $52
c0102214:	6a 34                	push   $0x34
  jmp __alltraps
c0102216:	e9 11 fe ff ff       	jmp    c010202c <__alltraps>

c010221b <vector53>:
.globl vector53
vector53:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $53
c010221d:	6a 35                	push   $0x35
  jmp __alltraps
c010221f:	e9 08 fe ff ff       	jmp    c010202c <__alltraps>

c0102224 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $54
c0102226:	6a 36                	push   $0x36
  jmp __alltraps
c0102228:	e9 ff fd ff ff       	jmp    c010202c <__alltraps>

c010222d <vector55>:
.globl vector55
vector55:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $55
c010222f:	6a 37                	push   $0x37
  jmp __alltraps
c0102231:	e9 f6 fd ff ff       	jmp    c010202c <__alltraps>

c0102236 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $56
c0102238:	6a 38                	push   $0x38
  jmp __alltraps
c010223a:	e9 ed fd ff ff       	jmp    c010202c <__alltraps>

c010223f <vector57>:
.globl vector57
vector57:
  pushl $0
c010223f:	6a 00                	push   $0x0
  pushl $57
c0102241:	6a 39                	push   $0x39
  jmp __alltraps
c0102243:	e9 e4 fd ff ff       	jmp    c010202c <__alltraps>

c0102248 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $58
c010224a:	6a 3a                	push   $0x3a
  jmp __alltraps
c010224c:	e9 db fd ff ff       	jmp    c010202c <__alltraps>

c0102251 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $59
c0102253:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102255:	e9 d2 fd ff ff       	jmp    c010202c <__alltraps>

c010225a <vector60>:
.globl vector60
vector60:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $60
c010225c:	6a 3c                	push   $0x3c
  jmp __alltraps
c010225e:	e9 c9 fd ff ff       	jmp    c010202c <__alltraps>

c0102263 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $61
c0102265:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102267:	e9 c0 fd ff ff       	jmp    c010202c <__alltraps>

c010226c <vector62>:
.globl vector62
vector62:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $62
c010226e:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102270:	e9 b7 fd ff ff       	jmp    c010202c <__alltraps>

c0102275 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $63
c0102277:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102279:	e9 ae fd ff ff       	jmp    c010202c <__alltraps>

c010227e <vector64>:
.globl vector64
vector64:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $64
c0102280:	6a 40                	push   $0x40
  jmp __alltraps
c0102282:	e9 a5 fd ff ff       	jmp    c010202c <__alltraps>

c0102287 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $65
c0102289:	6a 41                	push   $0x41
  jmp __alltraps
c010228b:	e9 9c fd ff ff       	jmp    c010202c <__alltraps>

c0102290 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $66
c0102292:	6a 42                	push   $0x42
  jmp __alltraps
c0102294:	e9 93 fd ff ff       	jmp    c010202c <__alltraps>

c0102299 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $67
c010229b:	6a 43                	push   $0x43
  jmp __alltraps
c010229d:	e9 8a fd ff ff       	jmp    c010202c <__alltraps>

c01022a2 <vector68>:
.globl vector68
vector68:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $68
c01022a4:	6a 44                	push   $0x44
  jmp __alltraps
c01022a6:	e9 81 fd ff ff       	jmp    c010202c <__alltraps>

c01022ab <vector69>:
.globl vector69
vector69:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $69
c01022ad:	6a 45                	push   $0x45
  jmp __alltraps
c01022af:	e9 78 fd ff ff       	jmp    c010202c <__alltraps>

c01022b4 <vector70>:
.globl vector70
vector70:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $70
c01022b6:	6a 46                	push   $0x46
  jmp __alltraps
c01022b8:	e9 6f fd ff ff       	jmp    c010202c <__alltraps>

c01022bd <vector71>:
.globl vector71
vector71:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $71
c01022bf:	6a 47                	push   $0x47
  jmp __alltraps
c01022c1:	e9 66 fd ff ff       	jmp    c010202c <__alltraps>

c01022c6 <vector72>:
.globl vector72
vector72:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $72
c01022c8:	6a 48                	push   $0x48
  jmp __alltraps
c01022ca:	e9 5d fd ff ff       	jmp    c010202c <__alltraps>

c01022cf <vector73>:
.globl vector73
vector73:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $73
c01022d1:	6a 49                	push   $0x49
  jmp __alltraps
c01022d3:	e9 54 fd ff ff       	jmp    c010202c <__alltraps>

c01022d8 <vector74>:
.globl vector74
vector74:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $74
c01022da:	6a 4a                	push   $0x4a
  jmp __alltraps
c01022dc:	e9 4b fd ff ff       	jmp    c010202c <__alltraps>

c01022e1 <vector75>:
.globl vector75
vector75:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $75
c01022e3:	6a 4b                	push   $0x4b
  jmp __alltraps
c01022e5:	e9 42 fd ff ff       	jmp    c010202c <__alltraps>

c01022ea <vector76>:
.globl vector76
vector76:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $76
c01022ec:	6a 4c                	push   $0x4c
  jmp __alltraps
c01022ee:	e9 39 fd ff ff       	jmp    c010202c <__alltraps>

c01022f3 <vector77>:
.globl vector77
vector77:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $77
c01022f5:	6a 4d                	push   $0x4d
  jmp __alltraps
c01022f7:	e9 30 fd ff ff       	jmp    c010202c <__alltraps>

c01022fc <vector78>:
.globl vector78
vector78:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $78
c01022fe:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102300:	e9 27 fd ff ff       	jmp    c010202c <__alltraps>

c0102305 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $79
c0102307:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102309:	e9 1e fd ff ff       	jmp    c010202c <__alltraps>

c010230e <vector80>:
.globl vector80
vector80:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $80
c0102310:	6a 50                	push   $0x50
  jmp __alltraps
c0102312:	e9 15 fd ff ff       	jmp    c010202c <__alltraps>

c0102317 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $81
c0102319:	6a 51                	push   $0x51
  jmp __alltraps
c010231b:	e9 0c fd ff ff       	jmp    c010202c <__alltraps>

c0102320 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $82
c0102322:	6a 52                	push   $0x52
  jmp __alltraps
c0102324:	e9 03 fd ff ff       	jmp    c010202c <__alltraps>

c0102329 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $83
c010232b:	6a 53                	push   $0x53
  jmp __alltraps
c010232d:	e9 fa fc ff ff       	jmp    c010202c <__alltraps>

c0102332 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $84
c0102334:	6a 54                	push   $0x54
  jmp __alltraps
c0102336:	e9 f1 fc ff ff       	jmp    c010202c <__alltraps>

c010233b <vector85>:
.globl vector85
vector85:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $85
c010233d:	6a 55                	push   $0x55
  jmp __alltraps
c010233f:	e9 e8 fc ff ff       	jmp    c010202c <__alltraps>

c0102344 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $86
c0102346:	6a 56                	push   $0x56
  jmp __alltraps
c0102348:	e9 df fc ff ff       	jmp    c010202c <__alltraps>

c010234d <vector87>:
.globl vector87
vector87:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $87
c010234f:	6a 57                	push   $0x57
  jmp __alltraps
c0102351:	e9 d6 fc ff ff       	jmp    c010202c <__alltraps>

c0102356 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $88
c0102358:	6a 58                	push   $0x58
  jmp __alltraps
c010235a:	e9 cd fc ff ff       	jmp    c010202c <__alltraps>

c010235f <vector89>:
.globl vector89
vector89:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $89
c0102361:	6a 59                	push   $0x59
  jmp __alltraps
c0102363:	e9 c4 fc ff ff       	jmp    c010202c <__alltraps>

c0102368 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $90
c010236a:	6a 5a                	push   $0x5a
  jmp __alltraps
c010236c:	e9 bb fc ff ff       	jmp    c010202c <__alltraps>

c0102371 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $91
c0102373:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102375:	e9 b2 fc ff ff       	jmp    c010202c <__alltraps>

c010237a <vector92>:
.globl vector92
vector92:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $92
c010237c:	6a 5c                	push   $0x5c
  jmp __alltraps
c010237e:	e9 a9 fc ff ff       	jmp    c010202c <__alltraps>

c0102383 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $93
c0102385:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102387:	e9 a0 fc ff ff       	jmp    c010202c <__alltraps>

c010238c <vector94>:
.globl vector94
vector94:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $94
c010238e:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102390:	e9 97 fc ff ff       	jmp    c010202c <__alltraps>

c0102395 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $95
c0102397:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102399:	e9 8e fc ff ff       	jmp    c010202c <__alltraps>

c010239e <vector96>:
.globl vector96
vector96:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $96
c01023a0:	6a 60                	push   $0x60
  jmp __alltraps
c01023a2:	e9 85 fc ff ff       	jmp    c010202c <__alltraps>

c01023a7 <vector97>:
.globl vector97
vector97:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $97
c01023a9:	6a 61                	push   $0x61
  jmp __alltraps
c01023ab:	e9 7c fc ff ff       	jmp    c010202c <__alltraps>

c01023b0 <vector98>:
.globl vector98
vector98:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $98
c01023b2:	6a 62                	push   $0x62
  jmp __alltraps
c01023b4:	e9 73 fc ff ff       	jmp    c010202c <__alltraps>

c01023b9 <vector99>:
.globl vector99
vector99:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $99
c01023bb:	6a 63                	push   $0x63
  jmp __alltraps
c01023bd:	e9 6a fc ff ff       	jmp    c010202c <__alltraps>

c01023c2 <vector100>:
.globl vector100
vector100:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $100
c01023c4:	6a 64                	push   $0x64
  jmp __alltraps
c01023c6:	e9 61 fc ff ff       	jmp    c010202c <__alltraps>

c01023cb <vector101>:
.globl vector101
vector101:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $101
c01023cd:	6a 65                	push   $0x65
  jmp __alltraps
c01023cf:	e9 58 fc ff ff       	jmp    c010202c <__alltraps>

c01023d4 <vector102>:
.globl vector102
vector102:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $102
c01023d6:	6a 66                	push   $0x66
  jmp __alltraps
c01023d8:	e9 4f fc ff ff       	jmp    c010202c <__alltraps>

c01023dd <vector103>:
.globl vector103
vector103:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $103
c01023df:	6a 67                	push   $0x67
  jmp __alltraps
c01023e1:	e9 46 fc ff ff       	jmp    c010202c <__alltraps>

c01023e6 <vector104>:
.globl vector104
vector104:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $104
c01023e8:	6a 68                	push   $0x68
  jmp __alltraps
c01023ea:	e9 3d fc ff ff       	jmp    c010202c <__alltraps>

c01023ef <vector105>:
.globl vector105
vector105:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $105
c01023f1:	6a 69                	push   $0x69
  jmp __alltraps
c01023f3:	e9 34 fc ff ff       	jmp    c010202c <__alltraps>

c01023f8 <vector106>:
.globl vector106
vector106:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $106
c01023fa:	6a 6a                	push   $0x6a
  jmp __alltraps
c01023fc:	e9 2b fc ff ff       	jmp    c010202c <__alltraps>

c0102401 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $107
c0102403:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102405:	e9 22 fc ff ff       	jmp    c010202c <__alltraps>

c010240a <vector108>:
.globl vector108
vector108:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $108
c010240c:	6a 6c                	push   $0x6c
  jmp __alltraps
c010240e:	e9 19 fc ff ff       	jmp    c010202c <__alltraps>

c0102413 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $109
c0102415:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102417:	e9 10 fc ff ff       	jmp    c010202c <__alltraps>

c010241c <vector110>:
.globl vector110
vector110:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $110
c010241e:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102420:	e9 07 fc ff ff       	jmp    c010202c <__alltraps>

c0102425 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $111
c0102427:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102429:	e9 fe fb ff ff       	jmp    c010202c <__alltraps>

c010242e <vector112>:
.globl vector112
vector112:
  pushl $0
c010242e:	6a 00                	push   $0x0
  pushl $112
c0102430:	6a 70                	push   $0x70
  jmp __alltraps
c0102432:	e9 f5 fb ff ff       	jmp    c010202c <__alltraps>

c0102437 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102437:	6a 00                	push   $0x0
  pushl $113
c0102439:	6a 71                	push   $0x71
  jmp __alltraps
c010243b:	e9 ec fb ff ff       	jmp    c010202c <__alltraps>

c0102440 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $114
c0102442:	6a 72                	push   $0x72
  jmp __alltraps
c0102444:	e9 e3 fb ff ff       	jmp    c010202c <__alltraps>

c0102449 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $115
c010244b:	6a 73                	push   $0x73
  jmp __alltraps
c010244d:	e9 da fb ff ff       	jmp    c010202c <__alltraps>

c0102452 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102452:	6a 00                	push   $0x0
  pushl $116
c0102454:	6a 74                	push   $0x74
  jmp __alltraps
c0102456:	e9 d1 fb ff ff       	jmp    c010202c <__alltraps>

c010245b <vector117>:
.globl vector117
vector117:
  pushl $0
c010245b:	6a 00                	push   $0x0
  pushl $117
c010245d:	6a 75                	push   $0x75
  jmp __alltraps
c010245f:	e9 c8 fb ff ff       	jmp    c010202c <__alltraps>

c0102464 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $118
c0102466:	6a 76                	push   $0x76
  jmp __alltraps
c0102468:	e9 bf fb ff ff       	jmp    c010202c <__alltraps>

c010246d <vector119>:
.globl vector119
vector119:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $119
c010246f:	6a 77                	push   $0x77
  jmp __alltraps
c0102471:	e9 b6 fb ff ff       	jmp    c010202c <__alltraps>

c0102476 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $120
c0102478:	6a 78                	push   $0x78
  jmp __alltraps
c010247a:	e9 ad fb ff ff       	jmp    c010202c <__alltraps>

c010247f <vector121>:
.globl vector121
vector121:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $121
c0102481:	6a 79                	push   $0x79
  jmp __alltraps
c0102483:	e9 a4 fb ff ff       	jmp    c010202c <__alltraps>

c0102488 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $122
c010248a:	6a 7a                	push   $0x7a
  jmp __alltraps
c010248c:	e9 9b fb ff ff       	jmp    c010202c <__alltraps>

c0102491 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $123
c0102493:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102495:	e9 92 fb ff ff       	jmp    c010202c <__alltraps>

c010249a <vector124>:
.globl vector124
vector124:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $124
c010249c:	6a 7c                	push   $0x7c
  jmp __alltraps
c010249e:	e9 89 fb ff ff       	jmp    c010202c <__alltraps>

c01024a3 <vector125>:
.globl vector125
vector125:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $125
c01024a5:	6a 7d                	push   $0x7d
  jmp __alltraps
c01024a7:	e9 80 fb ff ff       	jmp    c010202c <__alltraps>

c01024ac <vector126>:
.globl vector126
vector126:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $126
c01024ae:	6a 7e                	push   $0x7e
  jmp __alltraps
c01024b0:	e9 77 fb ff ff       	jmp    c010202c <__alltraps>

c01024b5 <vector127>:
.globl vector127
vector127:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $127
c01024b7:	6a 7f                	push   $0x7f
  jmp __alltraps
c01024b9:	e9 6e fb ff ff       	jmp    c010202c <__alltraps>

c01024be <vector128>:
.globl vector128
vector128:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $128
c01024c0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01024c5:	e9 62 fb ff ff       	jmp    c010202c <__alltraps>

c01024ca <vector129>:
.globl vector129
vector129:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $129
c01024cc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01024d1:	e9 56 fb ff ff       	jmp    c010202c <__alltraps>

c01024d6 <vector130>:
.globl vector130
vector130:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $130
c01024d8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01024dd:	e9 4a fb ff ff       	jmp    c010202c <__alltraps>

c01024e2 <vector131>:
.globl vector131
vector131:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $131
c01024e4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01024e9:	e9 3e fb ff ff       	jmp    c010202c <__alltraps>

c01024ee <vector132>:
.globl vector132
vector132:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $132
c01024f0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01024f5:	e9 32 fb ff ff       	jmp    c010202c <__alltraps>

c01024fa <vector133>:
.globl vector133
vector133:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $133
c01024fc:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102501:	e9 26 fb ff ff       	jmp    c010202c <__alltraps>

c0102506 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $134
c0102508:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010250d:	e9 1a fb ff ff       	jmp    c010202c <__alltraps>

c0102512 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $135
c0102514:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102519:	e9 0e fb ff ff       	jmp    c010202c <__alltraps>

c010251e <vector136>:
.globl vector136
vector136:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $136
c0102520:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102525:	e9 02 fb ff ff       	jmp    c010202c <__alltraps>

c010252a <vector137>:
.globl vector137
vector137:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $137
c010252c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102531:	e9 f6 fa ff ff       	jmp    c010202c <__alltraps>

c0102536 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $138
c0102538:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010253d:	e9 ea fa ff ff       	jmp    c010202c <__alltraps>

c0102542 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $139
c0102544:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102549:	e9 de fa ff ff       	jmp    c010202c <__alltraps>

c010254e <vector140>:
.globl vector140
vector140:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $140
c0102550:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102555:	e9 d2 fa ff ff       	jmp    c010202c <__alltraps>

c010255a <vector141>:
.globl vector141
vector141:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $141
c010255c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102561:	e9 c6 fa ff ff       	jmp    c010202c <__alltraps>

c0102566 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $142
c0102568:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010256d:	e9 ba fa ff ff       	jmp    c010202c <__alltraps>

c0102572 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $143
c0102574:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102579:	e9 ae fa ff ff       	jmp    c010202c <__alltraps>

c010257e <vector144>:
.globl vector144
vector144:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $144
c0102580:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102585:	e9 a2 fa ff ff       	jmp    c010202c <__alltraps>

c010258a <vector145>:
.globl vector145
vector145:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $145
c010258c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102591:	e9 96 fa ff ff       	jmp    c010202c <__alltraps>

c0102596 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $146
c0102598:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010259d:	e9 8a fa ff ff       	jmp    c010202c <__alltraps>

c01025a2 <vector147>:
.globl vector147
vector147:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $147
c01025a4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01025a9:	e9 7e fa ff ff       	jmp    c010202c <__alltraps>

c01025ae <vector148>:
.globl vector148
vector148:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $148
c01025b0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01025b5:	e9 72 fa ff ff       	jmp    c010202c <__alltraps>

c01025ba <vector149>:
.globl vector149
vector149:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $149
c01025bc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01025c1:	e9 66 fa ff ff       	jmp    c010202c <__alltraps>

c01025c6 <vector150>:
.globl vector150
vector150:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $150
c01025c8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01025cd:	e9 5a fa ff ff       	jmp    c010202c <__alltraps>

c01025d2 <vector151>:
.globl vector151
vector151:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $151
c01025d4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01025d9:	e9 4e fa ff ff       	jmp    c010202c <__alltraps>

c01025de <vector152>:
.globl vector152
vector152:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $152
c01025e0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01025e5:	e9 42 fa ff ff       	jmp    c010202c <__alltraps>

c01025ea <vector153>:
.globl vector153
vector153:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $153
c01025ec:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01025f1:	e9 36 fa ff ff       	jmp    c010202c <__alltraps>

c01025f6 <vector154>:
.globl vector154
vector154:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $154
c01025f8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01025fd:	e9 2a fa ff ff       	jmp    c010202c <__alltraps>

c0102602 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $155
c0102604:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102609:	e9 1e fa ff ff       	jmp    c010202c <__alltraps>

c010260e <vector156>:
.globl vector156
vector156:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $156
c0102610:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102615:	e9 12 fa ff ff       	jmp    c010202c <__alltraps>

c010261a <vector157>:
.globl vector157
vector157:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $157
c010261c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102621:	e9 06 fa ff ff       	jmp    c010202c <__alltraps>

c0102626 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $158
c0102628:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010262d:	e9 fa f9 ff ff       	jmp    c010202c <__alltraps>

c0102632 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $159
c0102634:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102639:	e9 ee f9 ff ff       	jmp    c010202c <__alltraps>

c010263e <vector160>:
.globl vector160
vector160:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $160
c0102640:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102645:	e9 e2 f9 ff ff       	jmp    c010202c <__alltraps>

c010264a <vector161>:
.globl vector161
vector161:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $161
c010264c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102651:	e9 d6 f9 ff ff       	jmp    c010202c <__alltraps>

c0102656 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $162
c0102658:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010265d:	e9 ca f9 ff ff       	jmp    c010202c <__alltraps>

c0102662 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $163
c0102664:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102669:	e9 be f9 ff ff       	jmp    c010202c <__alltraps>

c010266e <vector164>:
.globl vector164
vector164:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $164
c0102670:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102675:	e9 b2 f9 ff ff       	jmp    c010202c <__alltraps>

c010267a <vector165>:
.globl vector165
vector165:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $165
c010267c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102681:	e9 a6 f9 ff ff       	jmp    c010202c <__alltraps>

c0102686 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $166
c0102688:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010268d:	e9 9a f9 ff ff       	jmp    c010202c <__alltraps>

c0102692 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $167
c0102694:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102699:	e9 8e f9 ff ff       	jmp    c010202c <__alltraps>

c010269e <vector168>:
.globl vector168
vector168:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $168
c01026a0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01026a5:	e9 82 f9 ff ff       	jmp    c010202c <__alltraps>

c01026aa <vector169>:
.globl vector169
vector169:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $169
c01026ac:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01026b1:	e9 76 f9 ff ff       	jmp    c010202c <__alltraps>

c01026b6 <vector170>:
.globl vector170
vector170:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $170
c01026b8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01026bd:	e9 6a f9 ff ff       	jmp    c010202c <__alltraps>

c01026c2 <vector171>:
.globl vector171
vector171:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $171
c01026c4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01026c9:	e9 5e f9 ff ff       	jmp    c010202c <__alltraps>

c01026ce <vector172>:
.globl vector172
vector172:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $172
c01026d0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01026d5:	e9 52 f9 ff ff       	jmp    c010202c <__alltraps>

c01026da <vector173>:
.globl vector173
vector173:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $173
c01026dc:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01026e1:	e9 46 f9 ff ff       	jmp    c010202c <__alltraps>

c01026e6 <vector174>:
.globl vector174
vector174:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $174
c01026e8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01026ed:	e9 3a f9 ff ff       	jmp    c010202c <__alltraps>

c01026f2 <vector175>:
.globl vector175
vector175:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $175
c01026f4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01026f9:	e9 2e f9 ff ff       	jmp    c010202c <__alltraps>

c01026fe <vector176>:
.globl vector176
vector176:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $176
c0102700:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102705:	e9 22 f9 ff ff       	jmp    c010202c <__alltraps>

c010270a <vector177>:
.globl vector177
vector177:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $177
c010270c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102711:	e9 16 f9 ff ff       	jmp    c010202c <__alltraps>

c0102716 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $178
c0102718:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010271d:	e9 0a f9 ff ff       	jmp    c010202c <__alltraps>

c0102722 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $179
c0102724:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102729:	e9 fe f8 ff ff       	jmp    c010202c <__alltraps>

c010272e <vector180>:
.globl vector180
vector180:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $180
c0102730:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102735:	e9 f2 f8 ff ff       	jmp    c010202c <__alltraps>

c010273a <vector181>:
.globl vector181
vector181:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $181
c010273c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102741:	e9 e6 f8 ff ff       	jmp    c010202c <__alltraps>

c0102746 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $182
c0102748:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010274d:	e9 da f8 ff ff       	jmp    c010202c <__alltraps>

c0102752 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $183
c0102754:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102759:	e9 ce f8 ff ff       	jmp    c010202c <__alltraps>

c010275e <vector184>:
.globl vector184
vector184:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $184
c0102760:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102765:	e9 c2 f8 ff ff       	jmp    c010202c <__alltraps>

c010276a <vector185>:
.globl vector185
vector185:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $185
c010276c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102771:	e9 b6 f8 ff ff       	jmp    c010202c <__alltraps>

c0102776 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $186
c0102778:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010277d:	e9 aa f8 ff ff       	jmp    c010202c <__alltraps>

c0102782 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $187
c0102784:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102789:	e9 9e f8 ff ff       	jmp    c010202c <__alltraps>

c010278e <vector188>:
.globl vector188
vector188:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $188
c0102790:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102795:	e9 92 f8 ff ff       	jmp    c010202c <__alltraps>

c010279a <vector189>:
.globl vector189
vector189:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $189
c010279c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01027a1:	e9 86 f8 ff ff       	jmp    c010202c <__alltraps>

c01027a6 <vector190>:
.globl vector190
vector190:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $190
c01027a8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01027ad:	e9 7a f8 ff ff       	jmp    c010202c <__alltraps>

c01027b2 <vector191>:
.globl vector191
vector191:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $191
c01027b4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01027b9:	e9 6e f8 ff ff       	jmp    c010202c <__alltraps>

c01027be <vector192>:
.globl vector192
vector192:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $192
c01027c0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01027c5:	e9 62 f8 ff ff       	jmp    c010202c <__alltraps>

c01027ca <vector193>:
.globl vector193
vector193:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $193
c01027cc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01027d1:	e9 56 f8 ff ff       	jmp    c010202c <__alltraps>

c01027d6 <vector194>:
.globl vector194
vector194:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $194
c01027d8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01027dd:	e9 4a f8 ff ff       	jmp    c010202c <__alltraps>

c01027e2 <vector195>:
.globl vector195
vector195:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $195
c01027e4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01027e9:	e9 3e f8 ff ff       	jmp    c010202c <__alltraps>

c01027ee <vector196>:
.globl vector196
vector196:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $196
c01027f0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01027f5:	e9 32 f8 ff ff       	jmp    c010202c <__alltraps>

c01027fa <vector197>:
.globl vector197
vector197:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $197
c01027fc:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102801:	e9 26 f8 ff ff       	jmp    c010202c <__alltraps>

c0102806 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $198
c0102808:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010280d:	e9 1a f8 ff ff       	jmp    c010202c <__alltraps>

c0102812 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102812:	6a 00                	push   $0x0
  pushl $199
c0102814:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102819:	e9 0e f8 ff ff       	jmp    c010202c <__alltraps>

c010281e <vector200>:
.globl vector200
vector200:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $200
c0102820:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102825:	e9 02 f8 ff ff       	jmp    c010202c <__alltraps>

c010282a <vector201>:
.globl vector201
vector201:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $201
c010282c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102831:	e9 f6 f7 ff ff       	jmp    c010202c <__alltraps>

c0102836 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102836:	6a 00                	push   $0x0
  pushl $202
c0102838:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010283d:	e9 ea f7 ff ff       	jmp    c010202c <__alltraps>

c0102842 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $203
c0102844:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102849:	e9 de f7 ff ff       	jmp    c010202c <__alltraps>

c010284e <vector204>:
.globl vector204
vector204:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $204
c0102850:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102855:	e9 d2 f7 ff ff       	jmp    c010202c <__alltraps>

c010285a <vector205>:
.globl vector205
vector205:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $205
c010285c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102861:	e9 c6 f7 ff ff       	jmp    c010202c <__alltraps>

c0102866 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $206
c0102868:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010286d:	e9 ba f7 ff ff       	jmp    c010202c <__alltraps>

c0102872 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $207
c0102874:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102879:	e9 ae f7 ff ff       	jmp    c010202c <__alltraps>

c010287e <vector208>:
.globl vector208
vector208:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $208
c0102880:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102885:	e9 a2 f7 ff ff       	jmp    c010202c <__alltraps>

c010288a <vector209>:
.globl vector209
vector209:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $209
c010288c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102891:	e9 96 f7 ff ff       	jmp    c010202c <__alltraps>

c0102896 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $210
c0102898:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010289d:	e9 8a f7 ff ff       	jmp    c010202c <__alltraps>

c01028a2 <vector211>:
.globl vector211
vector211:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $211
c01028a4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01028a9:	e9 7e f7 ff ff       	jmp    c010202c <__alltraps>

c01028ae <vector212>:
.globl vector212
vector212:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $212
c01028b0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01028b5:	e9 72 f7 ff ff       	jmp    c010202c <__alltraps>

c01028ba <vector213>:
.globl vector213
vector213:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $213
c01028bc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01028c1:	e9 66 f7 ff ff       	jmp    c010202c <__alltraps>

c01028c6 <vector214>:
.globl vector214
vector214:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $214
c01028c8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01028cd:	e9 5a f7 ff ff       	jmp    c010202c <__alltraps>

c01028d2 <vector215>:
.globl vector215
vector215:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $215
c01028d4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01028d9:	e9 4e f7 ff ff       	jmp    c010202c <__alltraps>

c01028de <vector216>:
.globl vector216
vector216:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $216
c01028e0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01028e5:	e9 42 f7 ff ff       	jmp    c010202c <__alltraps>

c01028ea <vector217>:
.globl vector217
vector217:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $217
c01028ec:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01028f1:	e9 36 f7 ff ff       	jmp    c010202c <__alltraps>

c01028f6 <vector218>:
.globl vector218
vector218:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $218
c01028f8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01028fd:	e9 2a f7 ff ff       	jmp    c010202c <__alltraps>

c0102902 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $219
c0102904:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102909:	e9 1e f7 ff ff       	jmp    c010202c <__alltraps>

c010290e <vector220>:
.globl vector220
vector220:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $220
c0102910:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102915:	e9 12 f7 ff ff       	jmp    c010202c <__alltraps>

c010291a <vector221>:
.globl vector221
vector221:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $221
c010291c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102921:	e9 06 f7 ff ff       	jmp    c010202c <__alltraps>

c0102926 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $222
c0102928:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010292d:	e9 fa f6 ff ff       	jmp    c010202c <__alltraps>

c0102932 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $223
c0102934:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102939:	e9 ee f6 ff ff       	jmp    c010202c <__alltraps>

c010293e <vector224>:
.globl vector224
vector224:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $224
c0102940:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102945:	e9 e2 f6 ff ff       	jmp    c010202c <__alltraps>

c010294a <vector225>:
.globl vector225
vector225:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $225
c010294c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102951:	e9 d6 f6 ff ff       	jmp    c010202c <__alltraps>

c0102956 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $226
c0102958:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010295d:	e9 ca f6 ff ff       	jmp    c010202c <__alltraps>

c0102962 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $227
c0102964:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102969:	e9 be f6 ff ff       	jmp    c010202c <__alltraps>

c010296e <vector228>:
.globl vector228
vector228:
  pushl $0
c010296e:	6a 00                	push   $0x0
  pushl $228
c0102970:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102975:	e9 b2 f6 ff ff       	jmp    c010202c <__alltraps>

c010297a <vector229>:
.globl vector229
vector229:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $229
c010297c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102981:	e9 a6 f6 ff ff       	jmp    c010202c <__alltraps>

c0102986 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $230
c0102988:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010298d:	e9 9a f6 ff ff       	jmp    c010202c <__alltraps>

c0102992 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $231
c0102994:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102999:	e9 8e f6 ff ff       	jmp    c010202c <__alltraps>

c010299e <vector232>:
.globl vector232
vector232:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $232
c01029a0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01029a5:	e9 82 f6 ff ff       	jmp    c010202c <__alltraps>

c01029aa <vector233>:
.globl vector233
vector233:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $233
c01029ac:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01029b1:	e9 76 f6 ff ff       	jmp    c010202c <__alltraps>

c01029b6 <vector234>:
.globl vector234
vector234:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $234
c01029b8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01029bd:	e9 6a f6 ff ff       	jmp    c010202c <__alltraps>

c01029c2 <vector235>:
.globl vector235
vector235:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $235
c01029c4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01029c9:	e9 5e f6 ff ff       	jmp    c010202c <__alltraps>

c01029ce <vector236>:
.globl vector236
vector236:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $236
c01029d0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01029d5:	e9 52 f6 ff ff       	jmp    c010202c <__alltraps>

c01029da <vector237>:
.globl vector237
vector237:
  pushl $0
c01029da:	6a 00                	push   $0x0
  pushl $237
c01029dc:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01029e1:	e9 46 f6 ff ff       	jmp    c010202c <__alltraps>

c01029e6 <vector238>:
.globl vector238
vector238:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $238
c01029e8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01029ed:	e9 3a f6 ff ff       	jmp    c010202c <__alltraps>

c01029f2 <vector239>:
.globl vector239
vector239:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $239
c01029f4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01029f9:	e9 2e f6 ff ff       	jmp    c010202c <__alltraps>

c01029fe <vector240>:
.globl vector240
vector240:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $240
c0102a00:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102a05:	e9 22 f6 ff ff       	jmp    c010202c <__alltraps>

c0102a0a <vector241>:
.globl vector241
vector241:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $241
c0102a0c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102a11:	e9 16 f6 ff ff       	jmp    c010202c <__alltraps>

c0102a16 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $242
c0102a18:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102a1d:	e9 0a f6 ff ff       	jmp    c010202c <__alltraps>

c0102a22 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $243
c0102a24:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102a29:	e9 fe f5 ff ff       	jmp    c010202c <__alltraps>

c0102a2e <vector244>:
.globl vector244
vector244:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $244
c0102a30:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102a35:	e9 f2 f5 ff ff       	jmp    c010202c <__alltraps>

c0102a3a <vector245>:
.globl vector245
vector245:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $245
c0102a3c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102a41:	e9 e6 f5 ff ff       	jmp    c010202c <__alltraps>

c0102a46 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $246
c0102a48:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102a4d:	e9 da f5 ff ff       	jmp    c010202c <__alltraps>

c0102a52 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $247
c0102a54:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102a59:	e9 ce f5 ff ff       	jmp    c010202c <__alltraps>

c0102a5e <vector248>:
.globl vector248
vector248:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $248
c0102a60:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102a65:	e9 c2 f5 ff ff       	jmp    c010202c <__alltraps>

c0102a6a <vector249>:
.globl vector249
vector249:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $249
c0102a6c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102a71:	e9 b6 f5 ff ff       	jmp    c010202c <__alltraps>

c0102a76 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $250
c0102a78:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102a7d:	e9 aa f5 ff ff       	jmp    c010202c <__alltraps>

c0102a82 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $251
c0102a84:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102a89:	e9 9e f5 ff ff       	jmp    c010202c <__alltraps>

c0102a8e <vector252>:
.globl vector252
vector252:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $252
c0102a90:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102a95:	e9 92 f5 ff ff       	jmp    c010202c <__alltraps>

c0102a9a <vector253>:
.globl vector253
vector253:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $253
c0102a9c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102aa1:	e9 86 f5 ff ff       	jmp    c010202c <__alltraps>

c0102aa6 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $254
c0102aa8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102aad:	e9 7a f5 ff ff       	jmp    c010202c <__alltraps>

c0102ab2 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102ab2:	6a 00                	push   $0x0
  pushl $255
c0102ab4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102ab9:	e9 6e f5 ff ff       	jmp    c010202c <__alltraps>

c0102abe <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102abe:	55                   	push   %ebp
c0102abf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102ac1:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ac4:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102ac9:	29 c2                	sub    %eax,%edx
c0102acb:	89 d0                	mov    %edx,%eax
c0102acd:	c1 f8 02             	sar    $0x2,%eax
c0102ad0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102ad6:	5d                   	pop    %ebp
c0102ad7:	c3                   	ret    

c0102ad8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102ad8:	55                   	push   %ebp
c0102ad9:	89 e5                	mov    %esp,%ebp
c0102adb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae1:	89 04 24             	mov    %eax,(%esp)
c0102ae4:	e8 d5 ff ff ff       	call   c0102abe <page2ppn>
c0102ae9:	c1 e0 0c             	shl    $0xc,%eax
}
c0102aec:	c9                   	leave  
c0102aed:	c3                   	ret    

c0102aee <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102aee:	55                   	push   %ebp
c0102aef:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af4:	8b 00                	mov    (%eax),%eax
}
c0102af6:	5d                   	pop    %ebp
c0102af7:	c3                   	ret    

c0102af8 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102af8:	55                   	push   %ebp
c0102af9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b01:	89 10                	mov    %edx,(%eax)
}
c0102b03:	5d                   	pop    %ebp
c0102b04:	c3                   	ret    

c0102b05 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102b05:	55                   	push   %ebp
c0102b06:	89 e5                	mov    %esp,%ebp
c0102b08:	83 ec 10             	sub    $0x10,%esp
c0102b0b:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102b18:	89 50 04             	mov    %edx,0x4(%eax)
c0102b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b1e:	8b 50 04             	mov    0x4(%eax),%edx
c0102b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b24:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102b26:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102b2d:	00 00 00 
}
c0102b30:	c9                   	leave  
c0102b31:	c3                   	ret    

c0102b32 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102b32:	55                   	push   %ebp
c0102b33:	89 e5                	mov    %esp,%ebp
c0102b35:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102b38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b3c:	75 24                	jne    c0102b62 <default_init_memmap+0x30>
c0102b3e:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c0102b45:	c0 
c0102b46:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102b4d:	c0 
c0102b4e:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102b55:	00 
c0102b56:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102b5d:	e8 5e e1 ff ff       	call   c0100cc0 <__panic>
    struct Page *p = base;
c0102b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102b68:	e9 ef 00 00 00       	jmp    c0102c5c <default_init_memmap+0x12a>
        assert(PageReserved(p));
c0102b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b70:	83 c0 04             	add    $0x4,%eax
c0102b73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102b83:	0f a3 10             	bt     %edx,(%eax)
c0102b86:	19 c0                	sbb    %eax,%eax
c0102b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102b8f:	0f 95 c0             	setne  %al
c0102b92:	0f b6 c0             	movzbl %al,%eax
c0102b95:	85 c0                	test   %eax,%eax
c0102b97:	75 24                	jne    c0102bbd <default_init_memmap+0x8b>
c0102b99:	c7 44 24 0c 01 69 10 	movl   $0xc0106901,0xc(%esp)
c0102ba0:	c0 
c0102ba1:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102ba8:	c0 
c0102ba9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102bb0:	00 
c0102bb1:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102bb8:	e8 03 e1 ff ff       	call   c0100cc0 <__panic>
        p->flags = 0;
c0102bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0102bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bca:	83 c0 04             	add    $0x4,%eax
c0102bcd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102bd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102bdd:	0f ab 10             	bts    %edx,(%eax)
        if(p == base)
c0102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102be6:	75 0b                	jne    c0102bf3 <default_init_memmap+0xc1>
        {
        	p->property = n;
c0102be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102beb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bee:	89 50 08             	mov    %edx,0x8(%eax)
c0102bf1:	eb 0a                	jmp    c0102bfd <default_init_memmap+0xcb>
        }
        else
        {
        	p->property = 0;
c0102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
        set_page_ref(p, 0);
c0102bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c04:	00 
c0102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c08:	89 04 24             	mov    %eax,(%esp)
c0102c0b:	e8 e8 fe ff ff       	call   c0102af8 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c13:	83 c0 0c             	add    $0xc,%eax
c0102c16:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102c1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c20:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c23:	8b 00                	mov    (%eax),%eax
c0102c25:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c31:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c34:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c3a:	89 10                	mov    %edx,(%eax)
c0102c3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c3f:	8b 10                	mov    (%eax),%edx
c0102c41:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c44:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c4a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c4d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c53:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c56:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c58:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c5f:	89 d0                	mov    %edx,%eax
c0102c61:	c1 e0 02             	shl    $0x2,%eax
c0102c64:	01 d0                	add    %edx,%eax
c0102c66:	c1 e0 02             	shl    $0x2,%eax
c0102c69:	89 c2                	mov    %eax,%edx
c0102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6e:	01 d0                	add    %edx,%eax
c0102c70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c73:	0f 85 f4 fe ff ff    	jne    c0102b6d <default_init_memmap+0x3b>
        	p->property = 0;
        }
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c0102c79:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c82:	01 d0                	add    %edx,%eax
c0102c84:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102c89:	c9                   	leave  
c0102c8a:	c3                   	ret    

c0102c8b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102c8b:	55                   	push   %ebp
c0102c8c:	89 e5                	mov    %esp,%ebp
c0102c8e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102c91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c95:	75 24                	jne    c0102cbb <default_alloc_pages+0x30>
c0102c97:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c0102c9e:	c0 
c0102c9f:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102ca6:	c0 
c0102ca7:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0102cae:	00 
c0102caf:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102cb6:	e8 05 e0 ff ff       	call   c0100cc0 <__panic>
    if (n > nr_free) {
c0102cbb:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102cc0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cc3:	73 0a                	jae    c0102ccf <default_alloc_pages+0x44>
        return NULL;
c0102cc5:	b8 00 00 00 00       	mov    $0x0,%eax
c0102cca:	e9 45 01 00 00       	jmp    c0102e14 <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
c0102ccf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *tmp = NULL;
c0102cd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    list_entry_t *le = &free_list;
c0102cdd:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list)
c0102ce4:	e9 0a 01 00 00       	jmp    c0102df3 <default_alloc_pages+0x168>
    {
        struct Page *p = le2page(le, page_link);
c0102ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cec:	83 e8 0c             	sub    $0xc,%eax
c0102cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n)
c0102cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102cf5:	8b 40 08             	mov    0x8(%eax),%eax
c0102cf8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cfb:	0f 82 f2 00 00 00    	jb     c0102df3 <default_alloc_pages+0x168>
        {
            int i;
            for(i = 0;i<n;i++)
c0102d01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102d08:	eb 7c                	jmp    c0102d86 <default_alloc_pages+0xfb>
c0102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d13:	8b 40 04             	mov    0x4(%eax),%eax
            {
            	tmp = list_next(le);
c0102d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *pagetmp = le2page(le, page_link);
c0102d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d1c:	83 e8 0c             	sub    $0xc,%eax
c0102d1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            	SetPageReserved(pagetmp);
c0102d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d25:	83 c0 04             	add    $0x4,%eax
c0102d28:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102d2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102d32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d35:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102d38:	0f ab 10             	bts    %edx,(%eax)
            	ClearPageProperty(pagetmp);
c0102d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d3e:	83 c0 04             	add    $0x4,%eax
c0102d41:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102d48:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d51:	0f b3 10             	btr    %edx,(%eax)
c0102d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d57:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d5d:	8b 40 04             	mov    0x4(%eax),%eax
c0102d60:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d63:	8b 12                	mov    (%edx),%edx
c0102d65:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102d68:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d6e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d71:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d74:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d77:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d7a:	89 10                	mov    %edx,(%eax)
            	list_del(le);
            	le = tmp;
c0102d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n)
        {
            int i;
            for(i = 0;i<n;i++)
c0102d82:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d89:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d8c:	0f 82 78 ff ff ff    	jb     c0102d0a <default_alloc_pages+0x7f>
            	SetPageReserved(pagetmp);
            	ClearPageProperty(pagetmp);
            	list_del(le);
            	le = tmp;
            }
			if(p->property > n)
c0102d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d95:	8b 40 08             	mov    0x8(%eax),%eax
c0102d98:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d9b:	76 12                	jbe    c0102daf <default_alloc_pages+0x124>
			{
				(le2page(le, page_link)->property) = p->property - n;
c0102d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da0:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102da6:	8b 40 08             	mov    0x8(%eax),%eax
c0102da9:	2b 45 08             	sub    0x8(%ebp),%eax
c0102dac:	89 42 08             	mov    %eax,0x8(%edx)
			}
			SetPageReserved(p);
c0102daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102db2:	83 c0 04             	add    $0x4,%eax
c0102db5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c0102dbc:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dbf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dc2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dc5:	0f ab 10             	bts    %edx,(%eax)
			ClearPageProperty(p);
c0102dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102dcb:	83 c0 04             	add    $0x4,%eax
c0102dce:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0102dd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ddb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102dde:	0f b3 10             	btr    %edx,(%eax)
			nr_free -= n;
c0102de1:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102de6:	2b 45 08             	sub    0x8(%ebp),%eax
c0102de9:	a3 58 89 11 c0       	mov    %eax,0xc0118958
			return p;
c0102dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102df1:	eb 21                	jmp    c0102e14 <default_alloc_pages+0x189>
c0102df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df6:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102df9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dfc:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *tmp = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
c0102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e02:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102e09:	0f 85 da fe ff ff    	jne    c0102ce9 <default_alloc_pages+0x5e>
			ClearPageProperty(p);
			nr_free -= n;
			return p;
        }
    }
    return NULL;
c0102e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102e14:	c9                   	leave  
c0102e15:	c3                   	ret    

c0102e16 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102e16:	55                   	push   %ebp
c0102e17:	89 e5                	mov    %esp,%ebp
c0102e19:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102e1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102e20:	75 24                	jne    c0102e46 <default_free_pages+0x30>
c0102e22:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c0102e29:	c0 
c0102e2a:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102e31:	c0 
c0102e32:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0102e39:	00 
c0102e3a:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102e41:	e8 7a de ff ff       	call   c0100cc0 <__panic>
    assert(PageReserved(base));
c0102e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e49:	83 c0 04             	add    $0x4,%eax
c0102e4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102e59:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102e5c:	0f a3 10             	bt     %edx,(%eax)
c0102e5f:	19 c0                	sbb    %eax,%eax
c0102e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0102e64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102e68:	0f 95 c0             	setne  %al
c0102e6b:	0f b6 c0             	movzbl %al,%eax
c0102e6e:	85 c0                	test   %eax,%eax
c0102e70:	75 24                	jne    c0102e96 <default_free_pages+0x80>
c0102e72:	c7 44 24 0c 11 69 10 	movl   $0xc0106911,0xc(%esp)
c0102e79:	c0 
c0102e7a:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102e81:	c0 
c0102e82:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0102e89:	00 
c0102e8a:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102e91:	e8 2a de ff ff       	call   c0100cc0 <__panic>
    list_entry_t *le = &free_list;
c0102e96:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    struct Page* p = NULL;
c0102e9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0102ea4:	eb 13                	jmp    c0102eb9 <default_free_pages+0xa3>
    {
    	p = le2page(le, page_link);
c0102ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea9:	83 e8 0c             	sub    $0xc,%eax
c0102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(p > base)
c0102eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eb2:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102eb5:	76 02                	jbe    c0102eb9 <default_free_pages+0xa3>
    		break;
c0102eb7:	eb 18                	jmp    c0102ed1 <default_free_pages+0xbb>
c0102eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ebc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ec2:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    list_entry_t *le = &free_list;
    struct Page* p = NULL;
    while ((le = list_next(le)) != &free_list)
c0102ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ec8:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102ecf:	75 d5                	jne    c0102ea6 <default_free_pages+0x90>
    	p = le2page(le, page_link);
    	if(p > base)
    		break;
    }
    int i;
    for(i = 0;i<n;i++)
c0102ed1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ed8:	eb 5c                	jmp    c0102f36 <default_free_pages+0x120>
    {
    	list_add_before(le, &((base + i)->page_link));
c0102eda:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102edd:	89 d0                	mov    %edx,%eax
c0102edf:	c1 e0 02             	shl    $0x2,%eax
c0102ee2:	01 d0                	add    %edx,%eax
c0102ee4:	c1 e0 02             	shl    $0x2,%eax
c0102ee7:	89 c2                	mov    %eax,%edx
c0102ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eec:	01 d0                	add    %edx,%eax
c0102eee:	8d 50 0c             	lea    0xc(%eax),%edx
c0102ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ef4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102efa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102efd:	8b 00                	mov    (%eax),%eax
c0102eff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f02:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102f05:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102f0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102f0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f11:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f14:	89 10                	mov    %edx,(%eax)
c0102f16:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f19:	8b 10                	mov    (%eax),%edx
c0102f1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102f1e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f24:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102f27:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f30:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
    	if(p > base)
    		break;
    }
    int i;
    for(i = 0;i<n;i++)
c0102f32:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0102f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f39:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0102f3c:	72 9c                	jb     c0102eda <default_free_pages+0xc4>
    {
    	list_add_before(le, &((base + i)->page_link));
    }
    base->flags = 0;
c0102f3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
c0102f48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f4b:	83 c0 04             	add    $0x4,%eax
c0102f4e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102f55:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f58:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102f5b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102f5e:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102f61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f64:	83 c0 04             	add    $0x4,%eax
c0102f67:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102f6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f71:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f74:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102f77:	0f ab 10             	bts    %edx,(%eax)
    set_page_ref(base, 0);
c0102f7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102f81:	00 
c0102f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f85:	89 04 24             	mov    %eax,(%esp)
c0102f88:	e8 6b fb ff ff       	call   c0102af8 <set_page_ref>
    base->property = n;
c0102f8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f90:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f93:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le, page_link);
c0102f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f99:	83 e8 0c             	sub    $0xc,%eax
c0102f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(base + n == p)
c0102f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102fa2:	89 d0                	mov    %edx,%eax
c0102fa4:	c1 e0 02             	shl    $0x2,%eax
c0102fa7:	01 d0                	add    %edx,%eax
c0102fa9:	c1 e0 02             	shl    $0x2,%eax
c0102fac:	89 c2                	mov    %eax,%edx
c0102fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fb1:	01 d0                	add    %edx,%eax
c0102fb3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fb6:	75 1b                	jne    c0102fd3 <default_free_pages+0x1bd>
    {
    	base->property = n + p->property;
c0102fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fbb:	8b 50 08             	mov    0x8(%eax),%edx
c0102fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fc1:	01 c2                	add    %eax,%edx
c0102fc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fc6:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
c0102fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102fd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fd6:	83 c0 0c             	add    $0xc,%eax
c0102fd9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102fdc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102fdf:	8b 00                	mov    (%eax),%eax
c0102fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe7:	83 e8 0c             	sub    $0xc,%eax
c0102fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //below need to change
    if(le != &free_list && base - 1 == p)
c0102fed:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102ff4:	74 57                	je     c010304d <default_free_pages+0x237>
c0102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ff9:	83 e8 14             	sub    $0x14,%eax
c0102ffc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fff:	75 4c                	jne    c010304d <default_free_pages+0x237>
    {
	  while(le!=&free_list){
c0103001:	eb 41                	jmp    c0103044 <default_free_pages+0x22e>
		if(p->property){
c0103003:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103006:	8b 40 08             	mov    0x8(%eax),%eax
c0103009:	85 c0                	test   %eax,%eax
c010300b:	74 20                	je     c010302d <default_free_pages+0x217>
		  p->property += base->property;
c010300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103010:	8b 50 08             	mov    0x8(%eax),%edx
c0103013:	8b 45 08             	mov    0x8(%ebp),%eax
c0103016:	8b 40 08             	mov    0x8(%eax),%eax
c0103019:	01 c2                	add    %eax,%edx
c010301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010301e:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
c0103021:	8b 45 08             	mov    0x8(%ebp),%eax
c0103024:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
c010302b:	eb 20                	jmp    c010304d <default_free_pages+0x237>
c010302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103030:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103033:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103036:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
c0103038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
c010303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010303e:	83 e8 0c             	sub    $0xc,%eax
c0103041:	89 45 f0             	mov    %eax,-0x10(%ebp)
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    //below need to change
    if(le != &free_list && base - 1 == p)
    {
	  while(le!=&free_list){
c0103044:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c010304b:	75 b6                	jne    c0103003 <default_free_pages+0x1ed>
		}
		le = list_prev(le);
		p = le2page(le,page_link);
	  }
	}
    nr_free += n;
c010304d:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0103053:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103056:	01 d0                	add    %edx,%eax
c0103058:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c010305d:	c9                   	leave  
c010305e:	c3                   	ret    

c010305f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010305f:	55                   	push   %ebp
c0103060:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103062:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0103067:	5d                   	pop    %ebp
c0103068:	c3                   	ret    

c0103069 <basic_check>:

static void
basic_check(void) {
c0103069:	55                   	push   %ebp
c010306a:	89 e5                	mov    %esp,%ebp
c010306c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010306f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103076:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103079:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010307f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103089:	e8 85 0e 00 00       	call   c0103f13 <alloc_pages>
c010308e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103095:	75 24                	jne    c01030bb <basic_check+0x52>
c0103097:	c7 44 24 0c 24 69 10 	movl   $0xc0106924,0xc(%esp)
c010309e:	c0 
c010309f:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01030a6:	c0 
c01030a7:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01030ae:	00 
c01030af:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01030b6:	e8 05 dc ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030c2:	e8 4c 0e 00 00       	call   c0103f13 <alloc_pages>
c01030c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030ce:	75 24                	jne    c01030f4 <basic_check+0x8b>
c01030d0:	c7 44 24 0c 40 69 10 	movl   $0xc0106940,0xc(%esp)
c01030d7:	c0 
c01030d8:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01030df:	c0 
c01030e0:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01030e7:	00 
c01030e8:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01030ef:	e8 cc db ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030fb:	e8 13 0e 00 00       	call   c0103f13 <alloc_pages>
c0103100:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103107:	75 24                	jne    c010312d <basic_check+0xc4>
c0103109:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103110:	c0 
c0103111:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103118:	c0 
c0103119:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103120:	00 
c0103121:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103128:	e8 93 db ff ff       	call   c0100cc0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103133:	74 10                	je     c0103145 <basic_check+0xdc>
c0103135:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103138:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010313b:	74 08                	je     c0103145 <basic_check+0xdc>
c010313d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103140:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103143:	75 24                	jne    c0103169 <basic_check+0x100>
c0103145:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c010314c:	c0 
c010314d:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103154:	c0 
c0103155:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010315c:	00 
c010315d:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103164:	e8 57 db ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103169:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010316c:	89 04 24             	mov    %eax,(%esp)
c010316f:	e8 7a f9 ff ff       	call   c0102aee <page_ref>
c0103174:	85 c0                	test   %eax,%eax
c0103176:	75 1e                	jne    c0103196 <basic_check+0x12d>
c0103178:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010317b:	89 04 24             	mov    %eax,(%esp)
c010317e:	e8 6b f9 ff ff       	call   c0102aee <page_ref>
c0103183:	85 c0                	test   %eax,%eax
c0103185:	75 0f                	jne    c0103196 <basic_check+0x12d>
c0103187:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010318a:	89 04 24             	mov    %eax,(%esp)
c010318d:	e8 5c f9 ff ff       	call   c0102aee <page_ref>
c0103192:	85 c0                	test   %eax,%eax
c0103194:	74 24                	je     c01031ba <basic_check+0x151>
c0103196:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c010319d:	c0 
c010319e:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01031a5:	c0 
c01031a6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01031ad:	00 
c01031ae:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01031b5:	e8 06 db ff ff       	call   c0100cc0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01031ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031bd:	89 04 24             	mov    %eax,(%esp)
c01031c0:	e8 13 f9 ff ff       	call   c0102ad8 <page2pa>
c01031c5:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01031cb:	c1 e2 0c             	shl    $0xc,%edx
c01031ce:	39 d0                	cmp    %edx,%eax
c01031d0:	72 24                	jb     c01031f6 <basic_check+0x18d>
c01031d2:	c7 44 24 0c d8 69 10 	movl   $0xc01069d8,0xc(%esp)
c01031d9:	c0 
c01031da:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01031e1:	c0 
c01031e2:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01031e9:	00 
c01031ea:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01031f1:	e8 ca da ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031f9:	89 04 24             	mov    %eax,(%esp)
c01031fc:	e8 d7 f8 ff ff       	call   c0102ad8 <page2pa>
c0103201:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103207:	c1 e2 0c             	shl    $0xc,%edx
c010320a:	39 d0                	cmp    %edx,%eax
c010320c:	72 24                	jb     c0103232 <basic_check+0x1c9>
c010320e:	c7 44 24 0c f5 69 10 	movl   $0xc01069f5,0xc(%esp)
c0103215:	c0 
c0103216:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010321d:	c0 
c010321e:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103225:	00 
c0103226:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010322d:	e8 8e da ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103232:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103235:	89 04 24             	mov    %eax,(%esp)
c0103238:	e8 9b f8 ff ff       	call   c0102ad8 <page2pa>
c010323d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103243:	c1 e2 0c             	shl    $0xc,%edx
c0103246:	39 d0                	cmp    %edx,%eax
c0103248:	72 24                	jb     c010326e <basic_check+0x205>
c010324a:	c7 44 24 0c 12 6a 10 	movl   $0xc0106a12,0xc(%esp)
c0103251:	c0 
c0103252:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103259:	c0 
c010325a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103261:	00 
c0103262:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103269:	e8 52 da ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c010326e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103273:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103279:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010327c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010327f:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103286:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103289:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010328c:	89 50 04             	mov    %edx,0x4(%eax)
c010328f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103292:	8b 50 04             	mov    0x4(%eax),%edx
c0103295:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103298:	89 10                	mov    %edx,(%eax)
c010329a:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01032a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01032a4:	8b 40 04             	mov    0x4(%eax),%eax
c01032a7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032aa:	0f 94 c0             	sete   %al
c01032ad:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032b0:	85 c0                	test   %eax,%eax
c01032b2:	75 24                	jne    c01032d8 <basic_check+0x26f>
c01032b4:	c7 44 24 0c 2f 6a 10 	movl   $0xc0106a2f,0xc(%esp)
c01032bb:	c0 
c01032bc:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01032c3:	c0 
c01032c4:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01032cb:	00 
c01032cc:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01032d3:	e8 e8 d9 ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c01032d8:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032e0:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01032e7:	00 00 00 

    assert(alloc_page() == NULL);
c01032ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f1:	e8 1d 0c 00 00       	call   c0103f13 <alloc_pages>
c01032f6:	85 c0                	test   %eax,%eax
c01032f8:	74 24                	je     c010331e <basic_check+0x2b5>
c01032fa:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c0103301:	c0 
c0103302:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103309:	c0 
c010330a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103311:	00 
c0103312:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103319:	e8 a2 d9 ff ff       	call   c0100cc0 <__panic>

    free_page(p0);
c010331e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103325:	00 
c0103326:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103329:	89 04 24             	mov    %eax,(%esp)
c010332c:	e8 1a 0c 00 00       	call   c0103f4b <free_pages>
    free_page(p1);
c0103331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103338:	00 
c0103339:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333c:	89 04 24             	mov    %eax,(%esp)
c010333f:	e8 07 0c 00 00       	call   c0103f4b <free_pages>
    free_page(p2);
c0103344:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010334b:	00 
c010334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334f:	89 04 24             	mov    %eax,(%esp)
c0103352:	e8 f4 0b 00 00       	call   c0103f4b <free_pages>
    assert(nr_free == 3);
c0103357:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010335c:	83 f8 03             	cmp    $0x3,%eax
c010335f:	74 24                	je     c0103385 <basic_check+0x31c>
c0103361:	c7 44 24 0c 5b 6a 10 	movl   $0xc0106a5b,0xc(%esp)
c0103368:	c0 
c0103369:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103370:	c0 
c0103371:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103378:	00 
c0103379:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103380:	e8 3b d9 ff ff       	call   c0100cc0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103385:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010338c:	e8 82 0b 00 00       	call   c0103f13 <alloc_pages>
c0103391:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103398:	75 24                	jne    c01033be <basic_check+0x355>
c010339a:	c7 44 24 0c 24 69 10 	movl   $0xc0106924,0xc(%esp)
c01033a1:	c0 
c01033a2:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01033a9:	c0 
c01033aa:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01033b1:	00 
c01033b2:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01033b9:	e8 02 d9 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033c5:	e8 49 0b 00 00       	call   c0103f13 <alloc_pages>
c01033ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033d1:	75 24                	jne    c01033f7 <basic_check+0x38e>
c01033d3:	c7 44 24 0c 40 69 10 	movl   $0xc0106940,0xc(%esp)
c01033da:	c0 
c01033db:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01033ea:	00 
c01033eb:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01033f2:	e8 c9 d8 ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033fe:	e8 10 0b 00 00       	call   c0103f13 <alloc_pages>
c0103403:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010340a:	75 24                	jne    c0103430 <basic_check+0x3c7>
c010340c:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103413:	c0 
c0103414:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010341b:	c0 
c010341c:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103423:	00 
c0103424:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010342b:	e8 90 d8 ff ff       	call   c0100cc0 <__panic>

    assert(alloc_page() == NULL);
c0103430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103437:	e8 d7 0a 00 00       	call   c0103f13 <alloc_pages>
c010343c:	85 c0                	test   %eax,%eax
c010343e:	74 24                	je     c0103464 <basic_check+0x3fb>
c0103440:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c0103447:	c0 
c0103448:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010344f:	c0 
c0103450:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103457:	00 
c0103458:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010345f:	e8 5c d8 ff ff       	call   c0100cc0 <__panic>

    free_page(p0);
c0103464:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010346b:	00 
c010346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346f:	89 04 24             	mov    %eax,(%esp)
c0103472:	e8 d4 0a 00 00       	call   c0103f4b <free_pages>
c0103477:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010347e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103481:	8b 40 04             	mov    0x4(%eax),%eax
c0103484:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103487:	0f 94 c0             	sete   %al
c010348a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010348d:	85 c0                	test   %eax,%eax
c010348f:	74 24                	je     c01034b5 <basic_check+0x44c>
c0103491:	c7 44 24 0c 68 6a 10 	movl   $0xc0106a68,0xc(%esp)
c0103498:	c0 
c0103499:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01034a0:	c0 
c01034a1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01034a8:	00 
c01034a9:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01034b0:	e8 0b d8 ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034bc:	e8 52 0a 00 00       	call   c0103f13 <alloc_pages>
c01034c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034ca:	74 24                	je     c01034f0 <basic_check+0x487>
c01034cc:	c7 44 24 0c 80 6a 10 	movl   $0xc0106a80,0xc(%esp)
c01034d3:	c0 
c01034d4:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01034db:	c0 
c01034dc:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01034e3:	00 
c01034e4:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01034eb:	e8 d0 d7 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c01034f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034f7:	e8 17 0a 00 00       	call   c0103f13 <alloc_pages>
c01034fc:	85 c0                	test   %eax,%eax
c01034fe:	74 24                	je     c0103524 <basic_check+0x4bb>
c0103500:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c0103507:	c0 
c0103508:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010350f:	c0 
c0103510:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103517:	00 
c0103518:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010351f:	e8 9c d7 ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c0103524:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103529:	85 c0                	test   %eax,%eax
c010352b:	74 24                	je     c0103551 <basic_check+0x4e8>
c010352d:	c7 44 24 0c 99 6a 10 	movl   $0xc0106a99,0xc(%esp)
c0103534:	c0 
c0103535:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010353c:	c0 
c010353d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103544:	00 
c0103545:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010354c:	e8 6f d7 ff ff       	call   c0100cc0 <__panic>
    free_list = free_list_store;
c0103551:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103554:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103557:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010355c:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103562:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103565:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c010356a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103571:	00 
c0103572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103575:	89 04 24             	mov    %eax,(%esp)
c0103578:	e8 ce 09 00 00       	call   c0103f4b <free_pages>
    free_page(p1);
c010357d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103584:	00 
c0103585:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103588:	89 04 24             	mov    %eax,(%esp)
c010358b:	e8 bb 09 00 00       	call   c0103f4b <free_pages>
    free_page(p2);
c0103590:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103597:	00 
c0103598:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359b:	89 04 24             	mov    %eax,(%esp)
c010359e:	e8 a8 09 00 00       	call   c0103f4b <free_pages>
}
c01035a3:	c9                   	leave  
c01035a4:	c3                   	ret    

c01035a5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01035a5:	55                   	push   %ebp
c01035a6:	89 e5                	mov    %esp,%ebp
c01035a8:	53                   	push   %ebx
c01035a9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01035af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035bd:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035c4:	eb 6b                	jmp    c0103631 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c9:	83 e8 0c             	sub    $0xc,%eax
c01035cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01035cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035d2:	83 c0 04             	add    $0x4,%eax
c01035d5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035df:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035e5:	0f a3 10             	bt     %edx,(%eax)
c01035e8:	19 c0                	sbb    %eax,%eax
c01035ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035f1:	0f 95 c0             	setne  %al
c01035f4:	0f b6 c0             	movzbl %al,%eax
c01035f7:	85 c0                	test   %eax,%eax
c01035f9:	75 24                	jne    c010361f <default_check+0x7a>
c01035fb:	c7 44 24 0c a6 6a 10 	movl   $0xc0106aa6,0xc(%esp)
c0103602:	c0 
c0103603:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010360a:	c0 
c010360b:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103612:	00 
c0103613:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010361a:	e8 a1 d6 ff ff       	call   c0100cc0 <__panic>
        count ++, total += p->property;
c010361f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103623:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103626:	8b 50 08             	mov    0x8(%eax),%edx
c0103629:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010362c:	01 d0                	add    %edx,%eax
c010362e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103631:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103634:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103637:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010363a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010363d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103640:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103647:	0f 85 79 ff ff ff    	jne    c01035c6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010364d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103650:	e8 28 09 00 00       	call   c0103f7d <nr_free_pages>
c0103655:	39 c3                	cmp    %eax,%ebx
c0103657:	74 24                	je     c010367d <default_check+0xd8>
c0103659:	c7 44 24 0c b6 6a 10 	movl   $0xc0106ab6,0xc(%esp)
c0103660:	c0 
c0103661:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103668:	c0 
c0103669:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103670:	00 
c0103671:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103678:	e8 43 d6 ff ff       	call   c0100cc0 <__panic>

    basic_check();
c010367d:	e8 e7 f9 ff ff       	call   c0103069 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103682:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103689:	e8 85 08 00 00       	call   c0103f13 <alloc_pages>
c010368e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103695:	75 24                	jne    c01036bb <default_check+0x116>
c0103697:	c7 44 24 0c cf 6a 10 	movl   $0xc0106acf,0xc(%esp)
c010369e:	c0 
c010369f:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01036a6:	c0 
c01036a7:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c01036ae:	00 
c01036af:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01036b6:	e8 05 d6 ff ff       	call   c0100cc0 <__panic>
    assert(!PageProperty(p0));
c01036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036be:	83 c0 04             	add    $0x4,%eax
c01036c1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036ce:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036d1:	0f a3 10             	bt     %edx,(%eax)
c01036d4:	19 c0                	sbb    %eax,%eax
c01036d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036d9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036dd:	0f 95 c0             	setne  %al
c01036e0:	0f b6 c0             	movzbl %al,%eax
c01036e3:	85 c0                	test   %eax,%eax
c01036e5:	74 24                	je     c010370b <default_check+0x166>
c01036e7:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c01036ee:	c0 
c01036ef:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01036f6:	c0 
c01036f7:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01036fe:	00 
c01036ff:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103706:	e8 b5 d5 ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c010370b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103710:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103716:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103719:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010371c:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103723:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103726:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103729:	89 50 04             	mov    %edx,0x4(%eax)
c010372c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010372f:	8b 50 04             	mov    0x4(%eax),%edx
c0103732:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103735:	89 10                	mov    %edx,(%eax)
c0103737:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010373e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103741:	8b 40 04             	mov    0x4(%eax),%eax
c0103744:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103747:	0f 94 c0             	sete   %al
c010374a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010374d:	85 c0                	test   %eax,%eax
c010374f:	75 24                	jne    c0103775 <default_check+0x1d0>
c0103751:	c7 44 24 0c 2f 6a 10 	movl   $0xc0106a2f,0xc(%esp)
c0103758:	c0 
c0103759:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103760:	c0 
c0103761:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103768:	00 
c0103769:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103770:	e8 4b d5 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103775:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010377c:	e8 92 07 00 00       	call   c0103f13 <alloc_pages>
c0103781:	85 c0                	test   %eax,%eax
c0103783:	74 24                	je     c01037a9 <default_check+0x204>
c0103785:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c010378c:	c0 
c010378d:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103794:	c0 
c0103795:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010379c:	00 
c010379d:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01037a4:	e8 17 d5 ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c01037a9:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01037ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01037b1:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01037b8:	00 00 00 

    free_pages(p0 + 2, 3);
c01037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037be:	83 c0 28             	add    $0x28,%eax
c01037c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037c8:	00 
c01037c9:	89 04 24             	mov    %eax,(%esp)
c01037cc:	e8 7a 07 00 00       	call   c0103f4b <free_pages>
    assert(alloc_pages(4) == NULL);
c01037d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037d8:	e8 36 07 00 00       	call   c0103f13 <alloc_pages>
c01037dd:	85 c0                	test   %eax,%eax
c01037df:	74 24                	je     c0103805 <default_check+0x260>
c01037e1:	c7 44 24 0c ec 6a 10 	movl   $0xc0106aec,0xc(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01037f8:	00 
c01037f9:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103800:	e8 bb d4 ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103808:	83 c0 28             	add    $0x28,%eax
c010380b:	83 c0 04             	add    $0x4,%eax
c010380e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103815:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103818:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010381b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010381e:	0f a3 10             	bt     %edx,(%eax)
c0103821:	19 c0                	sbb    %eax,%eax
c0103823:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103826:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010382a:	0f 95 c0             	setne  %al
c010382d:	0f b6 c0             	movzbl %al,%eax
c0103830:	85 c0                	test   %eax,%eax
c0103832:	74 0e                	je     c0103842 <default_check+0x29d>
c0103834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103837:	83 c0 28             	add    $0x28,%eax
c010383a:	8b 40 08             	mov    0x8(%eax),%eax
c010383d:	83 f8 03             	cmp    $0x3,%eax
c0103840:	74 24                	je     c0103866 <default_check+0x2c1>
c0103842:	c7 44 24 0c 04 6b 10 	movl   $0xc0106b04,0xc(%esp)
c0103849:	c0 
c010384a:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103851:	c0 
c0103852:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103859:	00 
c010385a:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103861:	e8 5a d4 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103866:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010386d:	e8 a1 06 00 00       	call   c0103f13 <alloc_pages>
c0103872:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103875:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103879:	75 24                	jne    c010389f <default_check+0x2fa>
c010387b:	c7 44 24 0c 30 6b 10 	movl   $0xc0106b30,0xc(%esp)
c0103882:	c0 
c0103883:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010388a:	c0 
c010388b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103892:	00 
c0103893:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010389a:	e8 21 d4 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c010389f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038a6:	e8 68 06 00 00       	call   c0103f13 <alloc_pages>
c01038ab:	85 c0                	test   %eax,%eax
c01038ad:	74 24                	je     c01038d3 <default_check+0x32e>
c01038af:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c01038b6:	c0 
c01038b7:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01038be:	c0 
c01038bf:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01038c6:	00 
c01038c7:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01038ce:	e8 ed d3 ff ff       	call   c0100cc0 <__panic>
    assert(p0 + 2 == p1);
c01038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038d6:	83 c0 28             	add    $0x28,%eax
c01038d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01038dc:	74 24                	je     c0103902 <default_check+0x35d>
c01038de:	c7 44 24 0c 4e 6b 10 	movl   $0xc0106b4e,0xc(%esp)
c01038e5:	c0 
c01038e6:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01038ed:	c0 
c01038ee:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01038f5:	00 
c01038f6:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01038fd:	e8 be d3 ff ff       	call   c0100cc0 <__panic>

    p2 = p0 + 1;
c0103902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103905:	83 c0 14             	add    $0x14,%eax
c0103908:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010390b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103912:	00 
c0103913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103916:	89 04 24             	mov    %eax,(%esp)
c0103919:	e8 2d 06 00 00       	call   c0103f4b <free_pages>
    free_pages(p1, 3);
c010391e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103925:	00 
c0103926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103929:	89 04 24             	mov    %eax,(%esp)
c010392c:	e8 1a 06 00 00       	call   c0103f4b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103934:	83 c0 04             	add    $0x4,%eax
c0103937:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010393e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103941:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103944:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103947:	0f a3 10             	bt     %edx,(%eax)
c010394a:	19 c0                	sbb    %eax,%eax
c010394c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010394f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103953:	0f 95 c0             	setne  %al
c0103956:	0f b6 c0             	movzbl %al,%eax
c0103959:	85 c0                	test   %eax,%eax
c010395b:	74 0b                	je     c0103968 <default_check+0x3c3>
c010395d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103960:	8b 40 08             	mov    0x8(%eax),%eax
c0103963:	83 f8 01             	cmp    $0x1,%eax
c0103966:	74 24                	je     c010398c <default_check+0x3e7>
c0103968:	c7 44 24 0c 5c 6b 10 	movl   $0xc0106b5c,0xc(%esp)
c010396f:	c0 
c0103970:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103977:	c0 
c0103978:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010397f:	00 
c0103980:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103987:	e8 34 d3 ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010398f:	83 c0 04             	add    $0x4,%eax
c0103992:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103999:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010399c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010399f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01039a2:	0f a3 10             	bt     %edx,(%eax)
c01039a5:	19 c0                	sbb    %eax,%eax
c01039a7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01039aa:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01039ae:	0f 95 c0             	setne  %al
c01039b1:	0f b6 c0             	movzbl %al,%eax
c01039b4:	85 c0                	test   %eax,%eax
c01039b6:	74 0b                	je     c01039c3 <default_check+0x41e>
c01039b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039bb:	8b 40 08             	mov    0x8(%eax),%eax
c01039be:	83 f8 03             	cmp    $0x3,%eax
c01039c1:	74 24                	je     c01039e7 <default_check+0x442>
c01039c3:	c7 44 24 0c 84 6b 10 	movl   $0xc0106b84,0xc(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01039da:	00 
c01039db:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01039e2:	e8 d9 d2 ff ff       	call   c0100cc0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039ee:	e8 20 05 00 00       	call   c0103f13 <alloc_pages>
c01039f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039f9:	83 e8 14             	sub    $0x14,%eax
c01039fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01039ff:	74 24                	je     c0103a25 <default_check+0x480>
c0103a01:	c7 44 24 0c aa 6b 10 	movl   $0xc0106baa,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103a20:	e8 9b d2 ff ff       	call   c0100cc0 <__panic>
    free_page(p0);
c0103a25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a2c:	00 
c0103a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a30:	89 04 24             	mov    %eax,(%esp)
c0103a33:	e8 13 05 00 00       	call   c0103f4b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a38:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a3f:	e8 cf 04 00 00       	call   c0103f13 <alloc_pages>
c0103a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a4a:	83 c0 14             	add    $0x14,%eax
c0103a4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a50:	74 24                	je     c0103a76 <default_check+0x4d1>
c0103a52:	c7 44 24 0c c8 6b 10 	movl   $0xc0106bc8,0xc(%esp)
c0103a59:	c0 
c0103a5a:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103a61:	c0 
c0103a62:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103a69:	00 
c0103a6a:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103a71:	e8 4a d2 ff ff       	call   c0100cc0 <__panic>

    free_pages(p0, 2);
c0103a76:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a7d:	00 
c0103a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a81:	89 04 24             	mov    %eax,(%esp)
c0103a84:	e8 c2 04 00 00       	call   c0103f4b <free_pages>
    free_page(p2);
c0103a89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a90:	00 
c0103a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a94:	89 04 24             	mov    %eax,(%esp)
c0103a97:	e8 af 04 00 00       	call   c0103f4b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a9c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103aa3:	e8 6b 04 00 00       	call   c0103f13 <alloc_pages>
c0103aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103aab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103aaf:	75 24                	jne    c0103ad5 <default_check+0x530>
c0103ab1:	c7 44 24 0c e8 6b 10 	movl   $0xc0106be8,0xc(%esp)
c0103ab8:	c0 
c0103ab9:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103ac0:	c0 
c0103ac1:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103ac8:	00 
c0103ac9:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103ad0:	e8 eb d1 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103adc:	e8 32 04 00 00       	call   c0103f13 <alloc_pages>
c0103ae1:	85 c0                	test   %eax,%eax
c0103ae3:	74 24                	je     c0103b09 <default_check+0x564>
c0103ae5:	c7 44 24 0c 46 6a 10 	movl   $0xc0106a46,0xc(%esp)
c0103aec:	c0 
c0103aed:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103af4:	c0 
c0103af5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103afc:	00 
c0103afd:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103b04:	e8 b7 d1 ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c0103b09:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103b0e:	85 c0                	test   %eax,%eax
c0103b10:	74 24                	je     c0103b36 <default_check+0x591>
c0103b12:	c7 44 24 0c 99 6a 10 	movl   $0xc0106a99,0xc(%esp)
c0103b19:	c0 
c0103b1a:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103b21:	c0 
c0103b22:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103b29:	00 
c0103b2a:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103b31:	e8 8a d1 ff ff       	call   c0100cc0 <__panic>
    nr_free = nr_free_store;
c0103b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b39:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103b3e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b41:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b44:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103b49:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103b4f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b56:	00 
c0103b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b5a:	89 04 24             	mov    %eax,(%esp)
c0103b5d:	e8 e9 03 00 00       	call   c0103f4b <free_pages>

    le = &free_list;
c0103b62:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b69:	eb 1d                	jmp    c0103b88 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b6e:	83 e8 0c             	sub    $0xc,%eax
c0103b71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103b74:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b7e:	8b 40 08             	mov    0x8(%eax),%eax
c0103b81:	29 c2                	sub    %eax,%edx
c0103b83:	89 d0                	mov    %edx,%eax
c0103b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b8b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103b8e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b91:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b94:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b97:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103b9e:	75 cb                	jne    c0103b6b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ba4:	74 24                	je     c0103bca <default_check+0x625>
c0103ba6:	c7 44 24 0c 06 6c 10 	movl   $0xc0106c06,0xc(%esp)
c0103bad:	c0 
c0103bae:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103bb5:	c0 
c0103bb6:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103bbd:	00 
c0103bbe:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103bc5:	e8 f6 d0 ff ff       	call   c0100cc0 <__panic>
    assert(total == 0);
c0103bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bce:	74 24                	je     c0103bf4 <default_check+0x64f>
c0103bd0:	c7 44 24 0c 11 6c 10 	movl   $0xc0106c11,0xc(%esp)
c0103bd7:	c0 
c0103bd8:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0103be7:	00 
c0103be8:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103bef:	e8 cc d0 ff ff       	call   c0100cc0 <__panic>
}
c0103bf4:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103bfa:	5b                   	pop    %ebx
c0103bfb:	5d                   	pop    %ebp
c0103bfc:	c3                   	ret    

c0103bfd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103bfd:	55                   	push   %ebp
c0103bfe:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c00:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c03:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103c08:	29 c2                	sub    %eax,%edx
c0103c0a:	89 d0                	mov    %edx,%eax
c0103c0c:	c1 f8 02             	sar    $0x2,%eax
c0103c0f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c15:	5d                   	pop    %ebp
c0103c16:	c3                   	ret    

c0103c17 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103c17:	55                   	push   %ebp
c0103c18:	89 e5                	mov    %esp,%ebp
c0103c1a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c20:	89 04 24             	mov    %eax,(%esp)
c0103c23:	e8 d5 ff ff ff       	call   c0103bfd <page2ppn>
c0103c28:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c2b:	c9                   	leave  
c0103c2c:	c3                   	ret    

c0103c2d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103c2d:	55                   	push   %ebp
c0103c2e:	89 e5                	mov    %esp,%ebp
c0103c30:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c36:	c1 e8 0c             	shr    $0xc,%eax
c0103c39:	89 c2                	mov    %eax,%edx
c0103c3b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c40:	39 c2                	cmp    %eax,%edx
c0103c42:	72 1c                	jb     c0103c60 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c44:	c7 44 24 08 4c 6c 10 	movl   $0xc0106c4c,0x8(%esp)
c0103c4b:	c0 
c0103c4c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c53:	00 
c0103c54:	c7 04 24 6b 6c 10 c0 	movl   $0xc0106c6b,(%esp)
c0103c5b:	e8 60 d0 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c0103c60:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c69:	c1 e8 0c             	shr    $0xc,%eax
c0103c6c:	89 c2                	mov    %eax,%edx
c0103c6e:	89 d0                	mov    %edx,%eax
c0103c70:	c1 e0 02             	shl    $0x2,%eax
c0103c73:	01 d0                	add    %edx,%eax
c0103c75:	c1 e0 02             	shl    $0x2,%eax
c0103c78:	01 c8                	add    %ecx,%eax
}
c0103c7a:	c9                   	leave  
c0103c7b:	c3                   	ret    

c0103c7c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103c7c:	55                   	push   %ebp
c0103c7d:	89 e5                	mov    %esp,%ebp
c0103c7f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c85:	89 04 24             	mov    %eax,(%esp)
c0103c88:	e8 8a ff ff ff       	call   c0103c17 <page2pa>
c0103c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c93:	c1 e8 0c             	shr    $0xc,%eax
c0103c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c99:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c9e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ca1:	72 23                	jb     c0103cc6 <page2kva+0x4a>
c0103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ca6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103caa:	c7 44 24 08 7c 6c 10 	movl   $0xc0106c7c,0x8(%esp)
c0103cb1:	c0 
c0103cb2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cb9:	00 
c0103cba:	c7 04 24 6b 6c 10 c0 	movl   $0xc0106c6b,(%esp)
c0103cc1:	e8 fa cf ff ff       	call   c0100cc0 <__panic>
c0103cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cce:	c9                   	leave  
c0103ccf:	c3                   	ret    

c0103cd0 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103cd0:	55                   	push   %ebp
c0103cd1:	89 e5                	mov    %esp,%ebp
c0103cd3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cd9:	83 e0 01             	and    $0x1,%eax
c0103cdc:	85 c0                	test   %eax,%eax
c0103cde:	75 1c                	jne    c0103cfc <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ce0:	c7 44 24 08 a0 6c 10 	movl   $0xc0106ca0,0x8(%esp)
c0103ce7:	c0 
c0103ce8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cef:	00 
c0103cf0:	c7 04 24 6b 6c 10 c0 	movl   $0xc0106c6b,(%esp)
c0103cf7:	e8 c4 cf ff ff       	call   c0100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d04:	89 04 24             	mov    %eax,(%esp)
c0103d07:	e8 21 ff ff ff       	call   c0103c2d <pa2page>
}
c0103d0c:	c9                   	leave  
c0103d0d:	c3                   	ret    

c0103d0e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103d0e:	55                   	push   %ebp
c0103d0f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d14:	8b 00                	mov    (%eax),%eax
}
c0103d16:	5d                   	pop    %ebp
c0103d17:	c3                   	ret    

c0103d18 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103d18:	55                   	push   %ebp
c0103d19:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d21:	89 10                	mov    %edx,(%eax)
}
c0103d23:	5d                   	pop    %ebp
c0103d24:	c3                   	ret    

c0103d25 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d25:	55                   	push   %ebp
c0103d26:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2b:	8b 00                	mov    (%eax),%eax
c0103d2d:	8d 50 01             	lea    0x1(%eax),%edx
c0103d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d33:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d38:	8b 00                	mov    (%eax),%eax
}
c0103d3a:	5d                   	pop    %ebp
c0103d3b:	c3                   	ret    

c0103d3c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d3c:	55                   	push   %ebp
c0103d3d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d42:	8b 00                	mov    (%eax),%eax
c0103d44:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d4a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d4f:	8b 00                	mov    (%eax),%eax
}
c0103d51:	5d                   	pop    %ebp
c0103d52:	c3                   	ret    

c0103d53 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103d53:	55                   	push   %ebp
c0103d54:	89 e5                	mov    %esp,%ebp
c0103d56:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d59:	9c                   	pushf  
c0103d5a:	58                   	pop    %eax
c0103d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d61:	25 00 02 00 00       	and    $0x200,%eax
c0103d66:	85 c0                	test   %eax,%eax
c0103d68:	74 0c                	je     c0103d76 <__intr_save+0x23>
        intr_disable();
c0103d6a:	e8 34 d9 ff ff       	call   c01016a3 <intr_disable>
        return 1;
c0103d6f:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d74:	eb 05                	jmp    c0103d7b <__intr_save+0x28>
    }
    return 0;
c0103d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d7b:	c9                   	leave  
c0103d7c:	c3                   	ret    

c0103d7d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103d7d:	55                   	push   %ebp
c0103d7e:	89 e5                	mov    %esp,%ebp
c0103d80:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d87:	74 05                	je     c0103d8e <__intr_restore+0x11>
        intr_enable();
c0103d89:	e8 0f d9 ff ff       	call   c010169d <intr_enable>
    }
}
c0103d8e:	c9                   	leave  
c0103d8f:	c3                   	ret    

c0103d90 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d90:	55                   	push   %ebp
c0103d91:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d93:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d96:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d99:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d9e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103da0:	b8 23 00 00 00       	mov    $0x23,%eax
c0103da5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103da7:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dac:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103dae:	b8 10 00 00 00       	mov    $0x10,%eax
c0103db3:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103db5:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dba:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103dbc:	ea c3 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103dc3
}
c0103dc3:	5d                   	pop    %ebp
c0103dc4:	c3                   	ret    

c0103dc5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103dc5:	55                   	push   %ebp
c0103dc6:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103dc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dcb:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103dd0:	5d                   	pop    %ebp
c0103dd1:	c3                   	ret    

c0103dd2 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103dd2:	55                   	push   %ebp
c0103dd3:	89 e5                	mov    %esp,%ebp
c0103dd5:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103dd8:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103ddd:	89 04 24             	mov    %eax,(%esp)
c0103de0:	e8 e0 ff ff ff       	call   c0103dc5 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103de5:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103dec:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103dee:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103df5:	68 00 
c0103df7:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103dfc:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103e02:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103e07:	c1 e8 10             	shr    $0x10,%eax
c0103e0a:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103e0f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e16:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e19:	83 c8 09             	or     $0x9,%eax
c0103e1c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e21:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e28:	83 e0 ef             	and    $0xffffffef,%eax
c0103e2b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e30:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e37:	83 e0 9f             	and    $0xffffff9f,%eax
c0103e3a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e3f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103e46:	83 c8 80             	or     $0xffffff80,%eax
c0103e49:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103e4e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e55:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e58:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e5d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e64:	83 e0 ef             	and    $0xffffffef,%eax
c0103e67:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e6c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e73:	83 e0 df             	and    $0xffffffdf,%eax
c0103e76:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e7b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e82:	83 c8 40             	or     $0x40,%eax
c0103e85:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e8a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103e91:	83 e0 7f             	and    $0x7f,%eax
c0103e94:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e99:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103e9e:	c1 e8 18             	shr    $0x18,%eax
c0103ea1:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ea6:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103ead:	e8 de fe ff ff       	call   c0103d90 <lgdt>
c0103eb2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103eb8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ebc:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103ebf:	c9                   	leave  
c0103ec0:	c3                   	ret    

c0103ec1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ec1:	55                   	push   %ebp
c0103ec2:	89 e5                	mov    %esp,%ebp
c0103ec4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ec7:	c7 05 5c 89 11 c0 30 	movl   $0xc0106c30,0xc011895c
c0103ece:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ed1:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ed6:	8b 00                	mov    (%eax),%eax
c0103ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103edc:	c7 04 24 cc 6c 10 c0 	movl   $0xc0106ccc,(%esp)
c0103ee3:	e8 54 c4 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103ee8:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103eed:	8b 40 04             	mov    0x4(%eax),%eax
c0103ef0:	ff d0                	call   *%eax
}
c0103ef2:	c9                   	leave  
c0103ef3:	c3                   	ret    

c0103ef4 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ef4:	55                   	push   %ebp
c0103ef5:	89 e5                	mov    %esp,%ebp
c0103ef7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103efa:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103eff:	8b 40 08             	mov    0x8(%eax),%eax
c0103f02:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f09:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f0c:	89 14 24             	mov    %edx,(%esp)
c0103f0f:	ff d0                	call   *%eax
}
c0103f11:	c9                   	leave  
c0103f12:	c3                   	ret    

c0103f13 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f13:	55                   	push   %ebp
c0103f14:	89 e5                	mov    %esp,%ebp
c0103f16:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f20:	e8 2e fe ff ff       	call   c0103d53 <__intr_save>
c0103f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f28:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103f2d:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f30:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f33:	89 14 24             	mov    %edx,(%esp)
c0103f36:	ff d0                	call   *%eax
c0103f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f3e:	89 04 24             	mov    %eax,(%esp)
c0103f41:	e8 37 fe ff ff       	call   c0103d7d <__intr_restore>
    return page;
c0103f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f49:	c9                   	leave  
c0103f4a:	c3                   	ret    

c0103f4b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f4b:	55                   	push   %ebp
c0103f4c:	89 e5                	mov    %esp,%ebp
c0103f4e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f51:	e8 fd fd ff ff       	call   c0103d53 <__intr_save>
c0103f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f59:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103f5e:	8b 40 10             	mov    0x10(%eax),%eax
c0103f61:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f64:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f68:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f6b:	89 14 24             	mov    %edx,(%esp)
c0103f6e:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f73:	89 04 24             	mov    %eax,(%esp)
c0103f76:	e8 02 fe ff ff       	call   c0103d7d <__intr_restore>
}
c0103f7b:	c9                   	leave  
c0103f7c:	c3                   	ret    

c0103f7d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f7d:	55                   	push   %ebp
c0103f7e:	89 e5                	mov    %esp,%ebp
c0103f80:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f83:	e8 cb fd ff ff       	call   c0103d53 <__intr_save>
c0103f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f8b:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103f90:	8b 40 14             	mov    0x14(%eax),%eax
c0103f93:	ff d0                	call   *%eax
c0103f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f9b:	89 04 24             	mov    %eax,(%esp)
c0103f9e:	e8 da fd ff ff       	call   c0103d7d <__intr_restore>
    return ret;
c0103fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fa6:	c9                   	leave  
c0103fa7:	c3                   	ret    

c0103fa8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fa8:	55                   	push   %ebp
c0103fa9:	89 e5                	mov    %esp,%ebp
c0103fab:	57                   	push   %edi
c0103fac:	56                   	push   %esi
c0103fad:	53                   	push   %ebx
c0103fae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103fb4:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103fbb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fc2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103fc9:	c7 04 24 e3 6c 10 c0 	movl   $0xc0106ce3,(%esp)
c0103fd0:	e8 67 c3 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fd5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fdc:	e9 15 01 00 00       	jmp    c01040f6 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fe1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe7:	89 d0                	mov    %edx,%eax
c0103fe9:	c1 e0 02             	shl    $0x2,%eax
c0103fec:	01 d0                	add    %edx,%eax
c0103fee:	c1 e0 02             	shl    $0x2,%eax
c0103ff1:	01 c8                	add    %ecx,%eax
c0103ff3:	8b 50 08             	mov    0x8(%eax),%edx
c0103ff6:	8b 40 04             	mov    0x4(%eax),%eax
c0103ff9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103ffc:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103fff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104002:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104005:	89 d0                	mov    %edx,%eax
c0104007:	c1 e0 02             	shl    $0x2,%eax
c010400a:	01 d0                	add    %edx,%eax
c010400c:	c1 e0 02             	shl    $0x2,%eax
c010400f:	01 c8                	add    %ecx,%eax
c0104011:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104014:	8b 58 10             	mov    0x10(%eax),%ebx
c0104017:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010401a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010401d:	01 c8                	add    %ecx,%eax
c010401f:	11 da                	adc    %ebx,%edx
c0104021:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104024:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104027:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010402a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010402d:	89 d0                	mov    %edx,%eax
c010402f:	c1 e0 02             	shl    $0x2,%eax
c0104032:	01 d0                	add    %edx,%eax
c0104034:	c1 e0 02             	shl    $0x2,%eax
c0104037:	01 c8                	add    %ecx,%eax
c0104039:	83 c0 14             	add    $0x14,%eax
c010403c:	8b 00                	mov    (%eax),%eax
c010403e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104044:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104047:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010404a:	83 c0 ff             	add    $0xffffffff,%eax
c010404d:	83 d2 ff             	adc    $0xffffffff,%edx
c0104050:	89 c6                	mov    %eax,%esi
c0104052:	89 d7                	mov    %edx,%edi
c0104054:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104057:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405a:	89 d0                	mov    %edx,%eax
c010405c:	c1 e0 02             	shl    $0x2,%eax
c010405f:	01 d0                	add    %edx,%eax
c0104061:	c1 e0 02             	shl    $0x2,%eax
c0104064:	01 c8                	add    %ecx,%eax
c0104066:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104069:	8b 58 10             	mov    0x10(%eax),%ebx
c010406c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104072:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104076:	89 74 24 14          	mov    %esi,0x14(%esp)
c010407a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010407e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104081:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104084:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104088:	89 54 24 10          	mov    %edx,0x10(%esp)
c010408c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104090:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104094:	c7 04 24 f0 6c 10 c0 	movl   $0xc0106cf0,(%esp)
c010409b:	e8 9c c2 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a6:	89 d0                	mov    %edx,%eax
c01040a8:	c1 e0 02             	shl    $0x2,%eax
c01040ab:	01 d0                	add    %edx,%eax
c01040ad:	c1 e0 02             	shl    $0x2,%eax
c01040b0:	01 c8                	add    %ecx,%eax
c01040b2:	83 c0 14             	add    $0x14,%eax
c01040b5:	8b 00                	mov    (%eax),%eax
c01040b7:	83 f8 01             	cmp    $0x1,%eax
c01040ba:	75 36                	jne    c01040f2 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01040bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040c2:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040c5:	77 2b                	ja     c01040f2 <page_init+0x14a>
c01040c7:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040ca:	72 05                	jb     c01040d1 <page_init+0x129>
c01040cc:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01040cf:	73 21                	jae    c01040f2 <page_init+0x14a>
c01040d1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040d5:	77 1b                	ja     c01040f2 <page_init+0x14a>
c01040d7:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040db:	72 09                	jb     c01040e6 <page_init+0x13e>
c01040dd:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01040e4:	77 0c                	ja     c01040f2 <page_init+0x14a>
                maxpa = end;
c01040e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040e9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01040f2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040f9:	8b 00                	mov    (%eax),%eax
c01040fb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040fe:	0f 8f dd fe ff ff    	jg     c0103fe1 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104104:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104108:	72 1d                	jb     c0104127 <page_init+0x17f>
c010410a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010410e:	77 09                	ja     c0104119 <page_init+0x171>
c0104110:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104117:	76 0e                	jbe    c0104127 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104119:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104120:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104127:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010412a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010412d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104131:	c1 ea 0c             	shr    $0xc,%edx
c0104134:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104139:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104140:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0104145:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104148:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010414b:	01 d0                	add    %edx,%eax
c010414d:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104150:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104153:	ba 00 00 00 00       	mov    $0x0,%edx
c0104158:	f7 75 ac             	divl   -0x54(%ebp)
c010415b:	89 d0                	mov    %edx,%eax
c010415d:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104160:	29 c2                	sub    %eax,%edx
c0104162:	89 d0                	mov    %edx,%eax
c0104164:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0104169:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104170:	eb 2f                	jmp    c01041a1 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0104172:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0104178:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010417b:	89 d0                	mov    %edx,%eax
c010417d:	c1 e0 02             	shl    $0x2,%eax
c0104180:	01 d0                	add    %edx,%eax
c0104182:	c1 e0 02             	shl    $0x2,%eax
c0104185:	01 c8                	add    %ecx,%eax
c0104187:	83 c0 04             	add    $0x4,%eax
c010418a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104191:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104194:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104197:	8b 55 90             	mov    -0x70(%ebp),%edx
c010419a:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010419d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041a4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01041a9:	39 c2                	cmp    %eax,%edx
c01041ab:	72 c5                	jb     c0104172 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041ad:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01041b3:	89 d0                	mov    %edx,%eax
c01041b5:	c1 e0 02             	shl    $0x2,%eax
c01041b8:	01 d0                	add    %edx,%eax
c01041ba:	c1 e0 02             	shl    $0x2,%eax
c01041bd:	89 c2                	mov    %eax,%edx
c01041bf:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01041c4:	01 d0                	add    %edx,%eax
c01041c6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01041c9:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01041d0:	77 23                	ja     c01041f5 <page_init+0x24d>
c01041d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041d9:	c7 44 24 08 20 6d 10 	movl   $0xc0106d20,0x8(%esp)
c01041e0:	c0 
c01041e1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01041e8:	00 
c01041e9:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01041f0:	e8 cb ca ff ff       	call   c0100cc0 <__panic>
c01041f5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041f8:	05 00 00 00 40       	add    $0x40000000,%eax
c01041fd:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104200:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104207:	e9 74 01 00 00       	jmp    c0104380 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010420c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010420f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104212:	89 d0                	mov    %edx,%eax
c0104214:	c1 e0 02             	shl    $0x2,%eax
c0104217:	01 d0                	add    %edx,%eax
c0104219:	c1 e0 02             	shl    $0x2,%eax
c010421c:	01 c8                	add    %ecx,%eax
c010421e:	8b 50 08             	mov    0x8(%eax),%edx
c0104221:	8b 40 04             	mov    0x4(%eax),%eax
c0104224:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104227:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010422a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104230:	89 d0                	mov    %edx,%eax
c0104232:	c1 e0 02             	shl    $0x2,%eax
c0104235:	01 d0                	add    %edx,%eax
c0104237:	c1 e0 02             	shl    $0x2,%eax
c010423a:	01 c8                	add    %ecx,%eax
c010423c:	8b 48 0c             	mov    0xc(%eax),%ecx
c010423f:	8b 58 10             	mov    0x10(%eax),%ebx
c0104242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104245:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104248:	01 c8                	add    %ecx,%eax
c010424a:	11 da                	adc    %ebx,%edx
c010424c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010424f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104252:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104255:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104258:	89 d0                	mov    %edx,%eax
c010425a:	c1 e0 02             	shl    $0x2,%eax
c010425d:	01 d0                	add    %edx,%eax
c010425f:	c1 e0 02             	shl    $0x2,%eax
c0104262:	01 c8                	add    %ecx,%eax
c0104264:	83 c0 14             	add    $0x14,%eax
c0104267:	8b 00                	mov    (%eax),%eax
c0104269:	83 f8 01             	cmp    $0x1,%eax
c010426c:	0f 85 0a 01 00 00    	jne    c010437c <page_init+0x3d4>
            if (begin < freemem) {
c0104272:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104275:	ba 00 00 00 00       	mov    $0x0,%edx
c010427a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010427d:	72 17                	jb     c0104296 <page_init+0x2ee>
c010427f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104282:	77 05                	ja     c0104289 <page_init+0x2e1>
c0104284:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104287:	76 0d                	jbe    c0104296 <page_init+0x2ee>
                begin = freemem;
c0104289:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010428c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010428f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104296:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010429a:	72 1d                	jb     c01042b9 <page_init+0x311>
c010429c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01042a0:	77 09                	ja     c01042ab <page_init+0x303>
c01042a2:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01042a9:	76 0e                	jbe    c01042b9 <page_init+0x311>
                end = KMEMSIZE;
c01042ab:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042b2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042bf:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042c2:	0f 87 b4 00 00 00    	ja     c010437c <page_init+0x3d4>
c01042c8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042cb:	72 09                	jb     c01042d6 <page_init+0x32e>
c01042cd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042d0:	0f 83 a6 00 00 00    	jae    c010437c <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01042d6:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01042dd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042e3:	01 d0                	add    %edx,%eax
c01042e5:	83 e8 01             	sub    $0x1,%eax
c01042e8:	89 45 98             	mov    %eax,-0x68(%ebp)
c01042eb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01042ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01042f3:	f7 75 9c             	divl   -0x64(%ebp)
c01042f6:	89 d0                	mov    %edx,%eax
c01042f8:	8b 55 98             	mov    -0x68(%ebp),%edx
c01042fb:	29 c2                	sub    %eax,%edx
c01042fd:	89 d0                	mov    %edx,%eax
c01042ff:	ba 00 00 00 00       	mov    $0x0,%edx
c0104304:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104307:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010430a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010430d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104310:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104313:	ba 00 00 00 00       	mov    $0x0,%edx
c0104318:	89 c7                	mov    %eax,%edi
c010431a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104320:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104323:	89 d0                	mov    %edx,%eax
c0104325:	83 e0 00             	and    $0x0,%eax
c0104328:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010432b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010432e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104331:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104334:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104337:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010433a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010433d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104340:	77 3a                	ja     c010437c <page_init+0x3d4>
c0104342:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104345:	72 05                	jb     c010434c <page_init+0x3a4>
c0104347:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010434a:	73 30                	jae    c010437c <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010434c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010434f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104352:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104355:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104358:	29 c8                	sub    %ecx,%eax
c010435a:	19 da                	sbb    %ebx,%edx
c010435c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104360:	c1 ea 0c             	shr    $0xc,%edx
c0104363:	89 c3                	mov    %eax,%ebx
c0104365:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104368:	89 04 24             	mov    %eax,(%esp)
c010436b:	e8 bd f8 ff ff       	call   c0103c2d <pa2page>
c0104370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104374:	89 04 24             	mov    %eax,(%esp)
c0104377:	e8 78 fb ff ff       	call   c0103ef4 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010437c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104380:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104383:	8b 00                	mov    (%eax),%eax
c0104385:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104388:	0f 8f 7e fe ff ff    	jg     c010420c <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010438e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104394:	5b                   	pop    %ebx
c0104395:	5e                   	pop    %esi
c0104396:	5f                   	pop    %edi
c0104397:	5d                   	pop    %ebp
c0104398:	c3                   	ret    

c0104399 <enable_paging>:

static void
enable_paging(void) {
c0104399:	55                   	push   %ebp
c010439a:	89 e5                	mov    %esp,%ebp
c010439c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010439f:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01043a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01043a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01043aa:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01043ad:	0f 20 c0             	mov    %cr0,%eax
c01043b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01043b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01043b9:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01043c0:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01043c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01043ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043cd:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01043d0:	c9                   	leave  
c01043d1:	c3                   	ret    

c01043d2 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043d2:	55                   	push   %ebp
c01043d3:	89 e5                	mov    %esp,%ebp
c01043d5:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01043db:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043de:	31 d0                	xor    %edx,%eax
c01043e0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043e5:	85 c0                	test   %eax,%eax
c01043e7:	74 24                	je     c010440d <boot_map_segment+0x3b>
c01043e9:	c7 44 24 0c 52 6d 10 	movl   $0xc0106d52,0xc(%esp)
c01043f0:	c0 
c01043f1:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01043f8:	c0 
c01043f9:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104400:	00 
c0104401:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104408:	e8 b3 c8 ff ff       	call   c0100cc0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010440d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104414:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104417:	25 ff 0f 00 00       	and    $0xfff,%eax
c010441c:	89 c2                	mov    %eax,%edx
c010441e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104421:	01 c2                	add    %eax,%edx
c0104423:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104426:	01 d0                	add    %edx,%eax
c0104428:	83 e8 01             	sub    $0x1,%eax
c010442b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010442e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104431:	ba 00 00 00 00       	mov    $0x0,%edx
c0104436:	f7 75 f0             	divl   -0x10(%ebp)
c0104439:	89 d0                	mov    %edx,%eax
c010443b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010443e:	29 c2                	sub    %eax,%edx
c0104440:	89 d0                	mov    %edx,%eax
c0104442:	c1 e8 0c             	shr    $0xc,%eax
c0104445:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104448:	8b 45 0c             	mov    0xc(%ebp),%eax
c010444b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010444e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104456:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104459:	8b 45 14             	mov    0x14(%ebp),%eax
c010445c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010445f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104467:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010446a:	eb 6b                	jmp    c01044d7 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010446c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104473:	00 
c0104474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104477:	89 44 24 04          	mov    %eax,0x4(%esp)
c010447b:	8b 45 08             	mov    0x8(%ebp),%eax
c010447e:	89 04 24             	mov    %eax,(%esp)
c0104481:	e8 cc 01 00 00       	call   c0104652 <get_pte>
c0104486:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104489:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010448d:	75 24                	jne    c01044b3 <boot_map_segment+0xe1>
c010448f:	c7 44 24 0c 7e 6d 10 	movl   $0xc0106d7e,0xc(%esp)
c0104496:	c0 
c0104497:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c010449e:	c0 
c010449f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01044a6:	00 
c01044a7:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01044ae:	e8 0d c8 ff ff       	call   c0100cc0 <__panic>
        *ptep = pa | PTE_P | perm;
c01044b3:	8b 45 18             	mov    0x18(%ebp),%eax
c01044b6:	8b 55 14             	mov    0x14(%ebp),%edx
c01044b9:	09 d0                	or     %edx,%eax
c01044bb:	83 c8 01             	or     $0x1,%eax
c01044be:	89 c2                	mov    %eax,%edx
c01044c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044c3:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044c5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01044c9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044d0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044db:	75 8f                	jne    c010446c <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01044dd:	c9                   	leave  
c01044de:	c3                   	ret    

c01044df <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044df:	55                   	push   %ebp
c01044e0:	89 e5                	mov    %esp,%ebp
c01044e2:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ec:	e8 22 fa ff ff       	call   c0103f13 <alloc_pages>
c01044f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044f8:	75 1c                	jne    c0104516 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044fa:	c7 44 24 08 8b 6d 10 	movl   $0xc0106d8b,0x8(%esp)
c0104501:	c0 
c0104502:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104509:	00 
c010450a:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104511:	e8 aa c7 ff ff       	call   c0100cc0 <__panic>
    }
    return page2kva(p);
c0104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104519:	89 04 24             	mov    %eax,(%esp)
c010451c:	e8 5b f7 ff ff       	call   c0103c7c <page2kva>
}
c0104521:	c9                   	leave  
c0104522:	c3                   	ret    

c0104523 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104523:	55                   	push   %ebp
c0104524:	89 e5                	mov    %esp,%ebp
c0104526:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104529:	e8 93 f9 ff ff       	call   c0103ec1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010452e:	e8 75 fa ff ff       	call   c0103fa8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104533:	e8 6b 04 00 00       	call   c01049a3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104538:	e8 a2 ff ff ff       	call   c01044df <boot_alloc_page>
c010453d:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0104542:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104547:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010454e:	00 
c010454f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104556:	00 
c0104557:	89 04 24             	mov    %eax,(%esp)
c010455a:	e8 ad 1a 00 00       	call   c010600c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010455f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104564:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104567:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010456e:	77 23                	ja     c0104593 <pmm_init+0x70>
c0104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104573:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104577:	c7 44 24 08 20 6d 10 	movl   $0xc0106d20,0x8(%esp)
c010457e:	c0 
c010457f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104586:	00 
c0104587:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010458e:	e8 2d c7 ff ff       	call   c0100cc0 <__panic>
c0104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104596:	05 00 00 00 40       	add    $0x40000000,%eax
c010459b:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01045a0:	e8 1c 04 00 00       	call   c01049c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01045a5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045aa:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01045b0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045b8:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01045bf:	77 23                	ja     c01045e4 <pmm_init+0xc1>
c01045c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045c8:	c7 44 24 08 20 6d 10 	movl   $0xc0106d20,0x8(%esp)
c01045cf:	c0 
c01045d0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01045d7:	00 
c01045d8:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01045df:	e8 dc c6 ff ff       	call   c0100cc0 <__panic>
c01045e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045e7:	05 00 00 00 40       	add    $0x40000000,%eax
c01045ec:	83 c8 03             	or     $0x3,%eax
c01045ef:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045f1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045f6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045fd:	00 
c01045fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104605:	00 
c0104606:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010460d:	38 
c010460e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104615:	c0 
c0104616:	89 04 24             	mov    %eax,(%esp)
c0104619:	e8 b4 fd ff ff       	call   c01043d2 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010461e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104623:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104629:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010462f:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104631:	e8 63 fd ff ff       	call   c0104399 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104636:	e8 97 f7 ff ff       	call   c0103dd2 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010463b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104646:	e8 11 0a 00 00       	call   c010505c <check_boot_pgdir>

    print_pgdir();
c010464b:	e8 9e 0e 00 00       	call   c01054ee <print_pgdir>

}
c0104650:	c9                   	leave  
c0104651:	c3                   	ret    

c0104652 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104652:	55                   	push   %ebp
c0104653:	89 e5                	mov    %esp,%ebp
c0104655:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t* entry = &pgdir[PDX(la)];
c0104658:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465b:	c1 e8 16             	shr    $0x16,%eax
c010465e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104665:	8b 45 08             	mov    0x8(%ebp),%eax
c0104668:	01 d0                	add    %edx,%eax
c010466a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*entry & PTE_P))
c010466d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104670:	8b 00                	mov    (%eax),%eax
c0104672:	83 e0 01             	and    $0x1,%eax
c0104675:	85 c0                	test   %eax,%eax
c0104677:	0f 85 af 00 00 00    	jne    c010472c <get_pte+0xda>
    {
    	struct Page* p;
    	if((!create) || ((p = alloc_page()) == NULL))
c010467d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104681:	74 15                	je     c0104698 <get_pte+0x46>
c0104683:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010468a:	e8 84 f8 ff ff       	call   c0103f13 <alloc_pages>
c010468f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104696:	75 0a                	jne    c01046a2 <get_pte+0x50>
    	{
    		return NULL;
c0104698:	b8 00 00 00 00       	mov    $0x0,%eax
c010469d:	e9 e6 00 00 00       	jmp    c0104788 <get_pte+0x136>
    	}
    	set_page_ref(p, 1);
c01046a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046a9:	00 
c01046aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ad:	89 04 24             	mov    %eax,(%esp)
c01046b0:	e8 63 f6 ff ff       	call   c0103d18 <set_page_ref>
    	uintptr_t pg_addr = page2pa(p);
c01046b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b8:	89 04 24             	mov    %eax,(%esp)
c01046bb:	e8 57 f5 ff ff       	call   c0103c17 <page2pa>
c01046c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pg_addr), 0, PGSIZE);
c01046c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01046c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046cc:	c1 e8 0c             	shr    $0xc,%eax
c01046cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046d2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01046da:	72 23                	jb     c01046ff <get_pte+0xad>
c01046dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046e3:	c7 44 24 08 7c 6c 10 	movl   $0xc0106c7c,0x8(%esp)
c01046ea:	c0 
c01046eb:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c01046f2:	00 
c01046f3:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01046fa:	e8 c1 c5 ff ff       	call   c0100cc0 <__panic>
c01046ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104702:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104707:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010470e:	00 
c010470f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104716:	00 
c0104717:	89 04 24             	mov    %eax,(%esp)
c010471a:	e8 ed 18 00 00       	call   c010600c <memset>
    	*entry = pg_addr | PTE_U | PTE_W | PTE_P;
c010471f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104722:	83 c8 07             	or     $0x7,%eax
c0104725:	89 c2                	mov    %eax,%edx
c0104727:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472a:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t*)KADDR(PDE_ADDR(*entry)))[PTX(la)];
c010472c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472f:	8b 00                	mov    (%eax),%eax
c0104731:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104736:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104739:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010473c:	c1 e8 0c             	shr    $0xc,%eax
c010473f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104742:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104747:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010474a:	72 23                	jb     c010476f <get_pte+0x11d>
c010474c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010474f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104753:	c7 44 24 08 7c 6c 10 	movl   $0xc0106c7c,0x8(%esp)
c010475a:	c0 
c010475b:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c0104762:	00 
c0104763:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010476a:	e8 51 c5 ff ff       	call   c0100cc0 <__panic>
c010476f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104772:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104777:	8b 55 0c             	mov    0xc(%ebp),%edx
c010477a:	c1 ea 0c             	shr    $0xc,%edx
c010477d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104783:	c1 e2 02             	shl    $0x2,%edx
c0104786:	01 d0                	add    %edx,%eax
}
c0104788:	c9                   	leave  
c0104789:	c3                   	ret    

c010478a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010478a:	55                   	push   %ebp
c010478b:	89 e5                	mov    %esp,%ebp
c010478d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104790:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104797:	00 
c0104798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010479b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010479f:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a2:	89 04 24             	mov    %eax,(%esp)
c01047a5:	e8 a8 fe ff ff       	call   c0104652 <get_pte>
c01047aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01047ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047b1:	74 08                	je     c01047bb <get_page+0x31>
        *ptep_store = ptep;
c01047b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01047b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047b9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01047bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047bf:	74 1b                	je     c01047dc <get_page+0x52>
c01047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c4:	8b 00                	mov    (%eax),%eax
c01047c6:	83 e0 01             	and    $0x1,%eax
c01047c9:	85 c0                	test   %eax,%eax
c01047cb:	74 0f                	je     c01047dc <get_page+0x52>
        return pa2page(*ptep);
c01047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d0:	8b 00                	mov    (%eax),%eax
c01047d2:	89 04 24             	mov    %eax,(%esp)
c01047d5:	e8 53 f4 ff ff       	call   c0103c2d <pa2page>
c01047da:	eb 05                	jmp    c01047e1 <get_page+0x57>
    }
    return NULL;
c01047dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047e1:	c9                   	leave  
c01047e2:	c3                   	ret    

c01047e3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01047e3:	55                   	push   %ebp
c01047e4:	89 e5                	mov    %esp,%ebp
c01047e6:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
c01047e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01047ec:	8b 00                	mov    (%eax),%eax
c01047ee:	83 e0 01             	and    $0x1,%eax
c01047f1:	85 c0                	test   %eax,%eax
c01047f3:	74 52                	je     c0104847 <page_remove_pte+0x64>
    {
    	struct Page* page = pte2page(*ptep);
c01047f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01047f8:	8b 00                	mov    (%eax),%eax
c01047fa:	89 04 24             	mov    %eax,(%esp)
c01047fd:	e8 ce f4 ff ff       	call   c0103cd0 <pte2page>
c0104802:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	int re = page_ref_dec(page);
c0104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104808:	89 04 24             	mov    %eax,(%esp)
c010480b:	e8 2c f5 ff ff       	call   c0103d3c <page_ref_dec>
c0104810:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(re == 0)
c0104813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104817:	75 13                	jne    c010482c <page_remove_pte+0x49>
    	{
    		free_page(page);
c0104819:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104820:	00 
c0104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104824:	89 04 24             	mov    %eax,(%esp)
c0104827:	e8 1f f7 ff ff       	call   c0103f4b <free_pages>
    	}
    	*ptep = 0;
c010482c:	8b 45 10             	mov    0x10(%ebp),%eax
c010482f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir, la);
c0104835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104838:	89 44 24 04          	mov    %eax,0x4(%esp)
c010483c:	8b 45 08             	mov    0x8(%ebp),%eax
c010483f:	89 04 24             	mov    %eax,(%esp)
c0104842:	e8 ff 00 00 00       	call   c0104946 <tlb_invalidate>
    }
}
c0104847:	c9                   	leave  
c0104848:	c3                   	ret    

c0104849 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104849:	55                   	push   %ebp
c010484a:	89 e5                	mov    %esp,%ebp
c010484c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010484f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104856:	00 
c0104857:	8b 45 0c             	mov    0xc(%ebp),%eax
c010485a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010485e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104861:	89 04 24             	mov    %eax,(%esp)
c0104864:	e8 e9 fd ff ff       	call   c0104652 <get_pte>
c0104869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010486c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104870:	74 19                	je     c010488b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104875:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104879:	8b 45 0c             	mov    0xc(%ebp),%eax
c010487c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104880:	8b 45 08             	mov    0x8(%ebp),%eax
c0104883:	89 04 24             	mov    %eax,(%esp)
c0104886:	e8 58 ff ff ff       	call   c01047e3 <page_remove_pte>
    }
}
c010488b:	c9                   	leave  
c010488c:	c3                   	ret    

c010488d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010488d:	55                   	push   %ebp
c010488e:	89 e5                	mov    %esp,%ebp
c0104890:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104893:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010489a:	00 
c010489b:	8b 45 10             	mov    0x10(%ebp),%eax
c010489e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a5:	89 04 24             	mov    %eax,(%esp)
c01048a8:	e8 a5 fd ff ff       	call   c0104652 <get_pte>
c01048ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01048b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048b4:	75 0a                	jne    c01048c0 <page_insert+0x33>
        return -E_NO_MEM;
c01048b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01048bb:	e9 84 00 00 00       	jmp    c0104944 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01048c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048c3:	89 04 24             	mov    %eax,(%esp)
c01048c6:	e8 5a f4 ff ff       	call   c0103d25 <page_ref_inc>
    if (*ptep & PTE_P) {
c01048cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ce:	8b 00                	mov    (%eax),%eax
c01048d0:	83 e0 01             	and    $0x1,%eax
c01048d3:	85 c0                	test   %eax,%eax
c01048d5:	74 3e                	je     c0104915 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048da:	8b 00                	mov    (%eax),%eax
c01048dc:	89 04 24             	mov    %eax,(%esp)
c01048df:	e8 ec f3 ff ff       	call   c0103cd0 <pte2page>
c01048e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01048e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01048ed:	75 0d                	jne    c01048fc <page_insert+0x6f>
            page_ref_dec(page);
c01048ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048f2:	89 04 24             	mov    %eax,(%esp)
c01048f5:	e8 42 f4 ff ff       	call   c0103d3c <page_ref_dec>
c01048fa:	eb 19                	jmp    c0104915 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104903:	8b 45 10             	mov    0x10(%ebp),%eax
c0104906:	89 44 24 04          	mov    %eax,0x4(%esp)
c010490a:	8b 45 08             	mov    0x8(%ebp),%eax
c010490d:	89 04 24             	mov    %eax,(%esp)
c0104910:	e8 ce fe ff ff       	call   c01047e3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104915:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104918:	89 04 24             	mov    %eax,(%esp)
c010491b:	e8 f7 f2 ff ff       	call   c0103c17 <page2pa>
c0104920:	0b 45 14             	or     0x14(%ebp),%eax
c0104923:	83 c8 01             	or     $0x1,%eax
c0104926:	89 c2                	mov    %eax,%edx
c0104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010492d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104930:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104934:	8b 45 08             	mov    0x8(%ebp),%eax
c0104937:	89 04 24             	mov    %eax,(%esp)
c010493a:	e8 07 00 00 00       	call   c0104946 <tlb_invalidate>
    return 0;
c010493f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104944:	c9                   	leave  
c0104945:	c3                   	ret    

c0104946 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104946:	55                   	push   %ebp
c0104947:	89 e5                	mov    %esp,%ebp
c0104949:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010494c:	0f 20 d8             	mov    %cr3,%eax
c010494f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104952:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104955:	89 c2                	mov    %eax,%edx
c0104957:	8b 45 08             	mov    0x8(%ebp),%eax
c010495a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010495d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104964:	77 23                	ja     c0104989 <tlb_invalidate+0x43>
c0104966:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104969:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010496d:	c7 44 24 08 20 6d 10 	movl   $0xc0106d20,0x8(%esp)
c0104974:	c0 
c0104975:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c010497c:	00 
c010497d:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104984:	e8 37 c3 ff ff       	call   c0100cc0 <__panic>
c0104989:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104991:	39 c2                	cmp    %eax,%edx
c0104993:	75 0c                	jne    c01049a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104995:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104998:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010499b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010499e:	0f 01 38             	invlpg (%eax)
    }
}
c01049a1:	c9                   	leave  
c01049a2:	c3                   	ret    

c01049a3 <check_alloc_page>:

static void
check_alloc_page(void) {
c01049a3:	55                   	push   %ebp
c01049a4:	89 e5                	mov    %esp,%ebp
c01049a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01049a9:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01049ae:	8b 40 18             	mov    0x18(%eax),%eax
c01049b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01049b3:	c7 04 24 a4 6d 10 c0 	movl   $0xc0106da4,(%esp)
c01049ba:	e8 7d b9 ff ff       	call   c010033c <cprintf>
}
c01049bf:	c9                   	leave  
c01049c0:	c3                   	ret    

c01049c1 <check_pgdir>:

static void
check_pgdir(void) {
c01049c1:	55                   	push   %ebp
c01049c2:	89 e5                	mov    %esp,%ebp
c01049c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01049c7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01049cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01049d1:	76 24                	jbe    c01049f7 <check_pgdir+0x36>
c01049d3:	c7 44 24 0c c3 6d 10 	movl   $0xc0106dc3,0xc(%esp)
c01049da:	c0 
c01049db:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01049e2:	c0 
c01049e3:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01049ea:	00 
c01049eb:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01049f2:	e8 c9 c2 ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01049f7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049fc:	85 c0                	test   %eax,%eax
c01049fe:	74 0e                	je     c0104a0e <check_pgdir+0x4d>
c0104a00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a05:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a0a:	85 c0                	test   %eax,%eax
c0104a0c:	74 24                	je     c0104a32 <check_pgdir+0x71>
c0104a0e:	c7 44 24 0c e0 6d 10 	movl   $0xc0106de0,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104a2d:	e8 8e c2 ff ff       	call   c0100cc0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104a32:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a3e:	00 
c0104a3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a46:	00 
c0104a47:	89 04 24             	mov    %eax,(%esp)
c0104a4a:	e8 3b fd ff ff       	call   c010478a <get_page>
c0104a4f:	85 c0                	test   %eax,%eax
c0104a51:	74 24                	je     c0104a77 <check_pgdir+0xb6>
c0104a53:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104a5a:	c0 
c0104a5b:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104a62:	c0 
c0104a63:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104a6a:	00 
c0104a6b:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104a72:	e8 49 c2 ff ff       	call   c0100cc0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a7e:	e8 90 f4 ff ff       	call   c0103f13 <alloc_pages>
c0104a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a86:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a8b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a92:	00 
c0104a93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a9a:	00 
c0104a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a9e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104aa2:	89 04 24             	mov    %eax,(%esp)
c0104aa5:	e8 e3 fd ff ff       	call   c010488d <page_insert>
c0104aaa:	85 c0                	test   %eax,%eax
c0104aac:	74 24                	je     c0104ad2 <check_pgdir+0x111>
c0104aae:	c7 44 24 0c 40 6e 10 	movl   $0xc0106e40,0xc(%esp)
c0104ab5:	c0 
c0104ab6:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104abd:	c0 
c0104abe:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104ac5:	00 
c0104ac6:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104acd:	e8 ee c1 ff ff       	call   c0100cc0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104ad2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ad7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ade:	00 
c0104adf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ae6:	00 
c0104ae7:	89 04 24             	mov    %eax,(%esp)
c0104aea:	e8 63 fb ff ff       	call   c0104652 <get_pte>
c0104aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104af6:	75 24                	jne    c0104b1c <check_pgdir+0x15b>
c0104af8:	c7 44 24 0c 6c 6e 10 	movl   $0xc0106e6c,0xc(%esp)
c0104aff:	c0 
c0104b00:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104b07:	c0 
c0104b08:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104b0f:	00 
c0104b10:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104b17:	e8 a4 c1 ff ff       	call   c0100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
c0104b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b1f:	8b 00                	mov    (%eax),%eax
c0104b21:	89 04 24             	mov    %eax,(%esp)
c0104b24:	e8 04 f1 ff ff       	call   c0103c2d <pa2page>
c0104b29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b2c:	74 24                	je     c0104b52 <check_pgdir+0x191>
c0104b2e:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104b35:	c0 
c0104b36:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104b3d:	c0 
c0104b3e:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104b45:	00 
c0104b46:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104b4d:	e8 6e c1 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 1);
c0104b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b55:	89 04 24             	mov    %eax,(%esp)
c0104b58:	e8 b1 f1 ff ff       	call   c0103d0e <page_ref>
c0104b5d:	83 f8 01             	cmp    $0x1,%eax
c0104b60:	74 24                	je     c0104b86 <check_pgdir+0x1c5>
c0104b62:	c7 44 24 0c ae 6e 10 	movl   $0xc0106eae,0xc(%esp)
c0104b69:	c0 
c0104b6a:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104b71:	c0 
c0104b72:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b79:	00 
c0104b7a:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104b81:	e8 3a c1 ff ff       	call   c0100cc0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b86:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b8b:	8b 00                	mov    (%eax),%eax
c0104b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b98:	c1 e8 0c             	shr    $0xc,%eax
c0104b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b9e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104ba3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104ba6:	72 23                	jb     c0104bcb <check_pgdir+0x20a>
c0104ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104baf:	c7 44 24 08 7c 6c 10 	movl   $0xc0106c7c,0x8(%esp)
c0104bb6:	c0 
c0104bb7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104bbe:	00 
c0104bbf:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104bc6:	e8 f5 c0 ff ff       	call   c0100cc0 <__panic>
c0104bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bce:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104bd3:	83 c0 04             	add    $0x4,%eax
c0104bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104bd9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bde:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104be5:	00 
c0104be6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bed:	00 
c0104bee:	89 04 24             	mov    %eax,(%esp)
c0104bf1:	e8 5c fa ff ff       	call   c0104652 <get_pte>
c0104bf6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104bf9:	74 24                	je     c0104c1f <check_pgdir+0x25e>
c0104bfb:	c7 44 24 0c c0 6e 10 	movl   $0xc0106ec0,0xc(%esp)
c0104c02:	c0 
c0104c03:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104c0a:	c0 
c0104c0b:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c12:	00 
c0104c13:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104c1a:	e8 a1 c0 ff ff       	call   c0100cc0 <__panic>

    p2 = alloc_page();
c0104c1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c26:	e8 e8 f2 ff ff       	call   c0103f13 <alloc_pages>
c0104c2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104c2e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c33:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104c3a:	00 
c0104c3b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c42:	00 
c0104c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c46:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c4a:	89 04 24             	mov    %eax,(%esp)
c0104c4d:	e8 3b fc ff ff       	call   c010488d <page_insert>
c0104c52:	85 c0                	test   %eax,%eax
c0104c54:	74 24                	je     c0104c7a <check_pgdir+0x2b9>
c0104c56:	c7 44 24 0c e8 6e 10 	movl   $0xc0106ee8,0xc(%esp)
c0104c5d:	c0 
c0104c5e:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104c65:	c0 
c0104c66:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104c6d:	00 
c0104c6e:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104c75:	e8 46 c0 ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c7a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c86:	00 
c0104c87:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c8e:	00 
c0104c8f:	89 04 24             	mov    %eax,(%esp)
c0104c92:	e8 bb f9 ff ff       	call   c0104652 <get_pte>
c0104c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c9e:	75 24                	jne    c0104cc4 <check_pgdir+0x303>
c0104ca0:	c7 44 24 0c 20 6f 10 	movl   $0xc0106f20,0xc(%esp)
c0104ca7:	c0 
c0104ca8:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104caf:	c0 
c0104cb0:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104cb7:	00 
c0104cb8:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104cbf:	e8 fc bf ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_U);
c0104cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cc7:	8b 00                	mov    (%eax),%eax
c0104cc9:	83 e0 04             	and    $0x4,%eax
c0104ccc:	85 c0                	test   %eax,%eax
c0104cce:	75 24                	jne    c0104cf4 <check_pgdir+0x333>
c0104cd0:	c7 44 24 0c 50 6f 10 	movl   $0xc0106f50,0xc(%esp)
c0104cd7:	c0 
c0104cd8:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104cdf:	c0 
c0104ce0:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104ce7:	00 
c0104ce8:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104cef:	e8 cc bf ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_W);
c0104cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf7:	8b 00                	mov    (%eax),%eax
c0104cf9:	83 e0 02             	and    $0x2,%eax
c0104cfc:	85 c0                	test   %eax,%eax
c0104cfe:	75 24                	jne    c0104d24 <check_pgdir+0x363>
c0104d00:	c7 44 24 0c 5e 6f 10 	movl   $0xc0106f5e,0xc(%esp)
c0104d07:	c0 
c0104d08:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104d0f:	c0 
c0104d10:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104d17:	00 
c0104d18:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104d1f:	e8 9c bf ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104d24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d29:	8b 00                	mov    (%eax),%eax
c0104d2b:	83 e0 04             	and    $0x4,%eax
c0104d2e:	85 c0                	test   %eax,%eax
c0104d30:	75 24                	jne    c0104d56 <check_pgdir+0x395>
c0104d32:	c7 44 24 0c 6c 6f 10 	movl   $0xc0106f6c,0xc(%esp)
c0104d39:	c0 
c0104d3a:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104d41:	c0 
c0104d42:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104d49:	00 
c0104d4a:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104d51:	e8 6a bf ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 1);
c0104d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d59:	89 04 24             	mov    %eax,(%esp)
c0104d5c:	e8 ad ef ff ff       	call   c0103d0e <page_ref>
c0104d61:	83 f8 01             	cmp    $0x1,%eax
c0104d64:	74 24                	je     c0104d8a <check_pgdir+0x3c9>
c0104d66:	c7 44 24 0c 82 6f 10 	movl   $0xc0106f82,0xc(%esp)
c0104d6d:	c0 
c0104d6e:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104d75:	c0 
c0104d76:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104d7d:	00 
c0104d7e:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104d85:	e8 36 bf ff ff       	call   c0100cc0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d8a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d96:	00 
c0104d97:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d9e:	00 
c0104d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104da2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104da6:	89 04 24             	mov    %eax,(%esp)
c0104da9:	e8 df fa ff ff       	call   c010488d <page_insert>
c0104dae:	85 c0                	test   %eax,%eax
c0104db0:	74 24                	je     c0104dd6 <check_pgdir+0x415>
c0104db2:	c7 44 24 0c 94 6f 10 	movl   $0xc0106f94,0xc(%esp)
c0104db9:	c0 
c0104dba:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104dc1:	c0 
c0104dc2:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104dc9:	00 
c0104dca:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104dd1:	e8 ea be ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 2);
c0104dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd9:	89 04 24             	mov    %eax,(%esp)
c0104ddc:	e8 2d ef ff ff       	call   c0103d0e <page_ref>
c0104de1:	83 f8 02             	cmp    $0x2,%eax
c0104de4:	74 24                	je     c0104e0a <check_pgdir+0x449>
c0104de6:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c0104ded:	c0 
c0104dee:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104df5:	c0 
c0104df6:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104dfd:	00 
c0104dfe:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104e05:	e8 b6 be ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e0d:	89 04 24             	mov    %eax,(%esp)
c0104e10:	e8 f9 ee ff ff       	call   c0103d0e <page_ref>
c0104e15:	85 c0                	test   %eax,%eax
c0104e17:	74 24                	je     c0104e3d <check_pgdir+0x47c>
c0104e19:	c7 44 24 0c d2 6f 10 	movl   $0xc0106fd2,0xc(%esp)
c0104e20:	c0 
c0104e21:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104e28:	c0 
c0104e29:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104e30:	00 
c0104e31:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104e38:	e8 83 be ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104e3d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e49:	00 
c0104e4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e51:	00 
c0104e52:	89 04 24             	mov    %eax,(%esp)
c0104e55:	e8 f8 f7 ff ff       	call   c0104652 <get_pte>
c0104e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e61:	75 24                	jne    c0104e87 <check_pgdir+0x4c6>
c0104e63:	c7 44 24 0c 20 6f 10 	movl   $0xc0106f20,0xc(%esp)
c0104e6a:	c0 
c0104e6b:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104e72:	c0 
c0104e73:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104e7a:	00 
c0104e7b:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104e82:	e8 39 be ff ff       	call   c0100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
c0104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e8a:	8b 00                	mov    (%eax),%eax
c0104e8c:	89 04 24             	mov    %eax,(%esp)
c0104e8f:	e8 99 ed ff ff       	call   c0103c2d <pa2page>
c0104e94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e97:	74 24                	je     c0104ebd <check_pgdir+0x4fc>
c0104e99:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104ea0:	c0 
c0104ea1:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104ea8:	c0 
c0104ea9:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104eb0:	00 
c0104eb1:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104eb8:	e8 03 be ff ff       	call   c0100cc0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ec0:	8b 00                	mov    (%eax),%eax
c0104ec2:	83 e0 04             	and    $0x4,%eax
c0104ec5:	85 c0                	test   %eax,%eax
c0104ec7:	74 24                	je     c0104eed <check_pgdir+0x52c>
c0104ec9:	c7 44 24 0c e4 6f 10 	movl   $0xc0106fe4,0xc(%esp)
c0104ed0:	c0 
c0104ed1:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104ed8:	c0 
c0104ed9:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104ee0:	00 
c0104ee1:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104ee8:	e8 d3 bd ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104eed:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ef2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ef9:	00 
c0104efa:	89 04 24             	mov    %eax,(%esp)
c0104efd:	e8 47 f9 ff ff       	call   c0104849 <page_remove>
    assert(page_ref(p1) == 1);
c0104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f05:	89 04 24             	mov    %eax,(%esp)
c0104f08:	e8 01 ee ff ff       	call   c0103d0e <page_ref>
c0104f0d:	83 f8 01             	cmp    $0x1,%eax
c0104f10:	74 24                	je     c0104f36 <check_pgdir+0x575>
c0104f12:	c7 44 24 0c ae 6e 10 	movl   $0xc0106eae,0xc(%esp)
c0104f19:	c0 
c0104f1a:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104f21:	c0 
c0104f22:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104f29:	00 
c0104f2a:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104f31:	e8 8a bd ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f39:	89 04 24             	mov    %eax,(%esp)
c0104f3c:	e8 cd ed ff ff       	call   c0103d0e <page_ref>
c0104f41:	85 c0                	test   %eax,%eax
c0104f43:	74 24                	je     c0104f69 <check_pgdir+0x5a8>
c0104f45:	c7 44 24 0c d2 6f 10 	movl   $0xc0106fd2,0xc(%esp)
c0104f4c:	c0 
c0104f4d:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104f54:	c0 
c0104f55:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104f5c:	00 
c0104f5d:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104f64:	e8 57 bd ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104f69:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f75:	00 
c0104f76:	89 04 24             	mov    %eax,(%esp)
c0104f79:	e8 cb f8 ff ff       	call   c0104849 <page_remove>
    assert(page_ref(p1) == 0);
c0104f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f81:	89 04 24             	mov    %eax,(%esp)
c0104f84:	e8 85 ed ff ff       	call   c0103d0e <page_ref>
c0104f89:	85 c0                	test   %eax,%eax
c0104f8b:	74 24                	je     c0104fb1 <check_pgdir+0x5f0>
c0104f8d:	c7 44 24 0c f9 6f 10 	movl   $0xc0106ff9,0xc(%esp)
c0104f94:	c0 
c0104f95:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104f9c:	c0 
c0104f9d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104fa4:	00 
c0104fa5:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104fac:	e8 0f bd ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fb4:	89 04 24             	mov    %eax,(%esp)
c0104fb7:	e8 52 ed ff ff       	call   c0103d0e <page_ref>
c0104fbc:	85 c0                	test   %eax,%eax
c0104fbe:	74 24                	je     c0104fe4 <check_pgdir+0x623>
c0104fc0:	c7 44 24 0c d2 6f 10 	movl   $0xc0106fd2,0xc(%esp)
c0104fc7:	c0 
c0104fc8:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0104fcf:	c0 
c0104fd0:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104fd7:	00 
c0104fd8:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0104fdf:	e8 dc bc ff ff       	call   c0100cc0 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104fe4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fe9:	8b 00                	mov    (%eax),%eax
c0104feb:	89 04 24             	mov    %eax,(%esp)
c0104fee:	e8 3a ec ff ff       	call   c0103c2d <pa2page>
c0104ff3:	89 04 24             	mov    %eax,(%esp)
c0104ff6:	e8 13 ed ff ff       	call   c0103d0e <page_ref>
c0104ffb:	83 f8 01             	cmp    $0x1,%eax
c0104ffe:	74 24                	je     c0105024 <check_pgdir+0x663>
c0105000:	c7 44 24 0c 0c 70 10 	movl   $0xc010700c,0xc(%esp)
c0105007:	c0 
c0105008:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c010500f:	c0 
c0105010:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105017:	00 
c0105018:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010501f:	e8 9c bc ff ff       	call   c0100cc0 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105024:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105029:	8b 00                	mov    (%eax),%eax
c010502b:	89 04 24             	mov    %eax,(%esp)
c010502e:	e8 fa eb ff ff       	call   c0103c2d <pa2page>
c0105033:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010503a:	00 
c010503b:	89 04 24             	mov    %eax,(%esp)
c010503e:	e8 08 ef ff ff       	call   c0103f4b <free_pages>
    boot_pgdir[0] = 0;
c0105043:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105048:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010504e:	c7 04 24 32 70 10 c0 	movl   $0xc0107032,(%esp)
c0105055:	e8 e2 b2 ff ff       	call   c010033c <cprintf>
}
c010505a:	c9                   	leave  
c010505b:	c3                   	ret    

c010505c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010505c:	55                   	push   %ebp
c010505d:	89 e5                	mov    %esp,%ebp
c010505f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105069:	e9 ca 00 00 00       	jmp    c0105138 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105071:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105077:	c1 e8 0c             	shr    $0xc,%eax
c010507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010507d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0105082:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105085:	72 23                	jb     c01050aa <check_boot_pgdir+0x4e>
c0105087:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010508a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010508e:	c7 44 24 08 7c 6c 10 	movl   $0xc0106c7c,0x8(%esp)
c0105095:	c0 
c0105096:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c010509d:	00 
c010509e:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01050a5:	e8 16 bc ff ff       	call   c0100cc0 <__panic>
c01050aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01050b2:	89 c2                	mov    %eax,%edx
c01050b4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050c0:	00 
c01050c1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050c5:	89 04 24             	mov    %eax,(%esp)
c01050c8:	e8 85 f5 ff ff       	call   c0104652 <get_pte>
c01050cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01050d4:	75 24                	jne    c01050fa <check_boot_pgdir+0x9e>
c01050d6:	c7 44 24 0c 4c 70 10 	movl   $0xc010704c,0xc(%esp)
c01050dd:	c0 
c01050de:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01050e5:	c0 
c01050e6:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01050ed:	00 
c01050ee:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01050f5:	e8 c6 bb ff ff       	call   c0100cc0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01050fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050fd:	8b 00                	mov    (%eax),%eax
c01050ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105104:	89 c2                	mov    %eax,%edx
c0105106:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105109:	39 c2                	cmp    %eax,%edx
c010510b:	74 24                	je     c0105131 <check_boot_pgdir+0xd5>
c010510d:	c7 44 24 0c 89 70 10 	movl   $0xc0107089,0xc(%esp)
c0105114:	c0 
c0105115:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c010511c:	c0 
c010511d:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105124:	00 
c0105125:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010512c:	e8 8f bb ff ff       	call   c0100cc0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105131:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105138:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010513b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0105140:	39 c2                	cmp    %eax,%edx
c0105142:	0f 82 26 ff ff ff    	jb     c010506e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105148:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010514d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105152:	8b 00                	mov    (%eax),%eax
c0105154:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105159:	89 c2                	mov    %eax,%edx
c010515b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105163:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010516a:	77 23                	ja     c010518f <check_boot_pgdir+0x133>
c010516c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010516f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105173:	c7 44 24 08 20 6d 10 	movl   $0xc0106d20,0x8(%esp)
c010517a:	c0 
c010517b:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105182:	00 
c0105183:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010518a:	e8 31 bb ff ff       	call   c0100cc0 <__panic>
c010518f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105192:	05 00 00 00 40       	add    $0x40000000,%eax
c0105197:	39 c2                	cmp    %eax,%edx
c0105199:	74 24                	je     c01051bf <check_boot_pgdir+0x163>
c010519b:	c7 44 24 0c a0 70 10 	movl   $0xc01070a0,0xc(%esp)
c01051a2:	c0 
c01051a3:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01051aa:	c0 
c01051ab:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01051b2:	00 
c01051b3:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01051ba:	e8 01 bb ff ff       	call   c0100cc0 <__panic>

    assert(boot_pgdir[0] == 0);
c01051bf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051c4:	8b 00                	mov    (%eax),%eax
c01051c6:	85 c0                	test   %eax,%eax
c01051c8:	74 24                	je     c01051ee <check_boot_pgdir+0x192>
c01051ca:	c7 44 24 0c d4 70 10 	movl   $0xc01070d4,0xc(%esp)
c01051d1:	c0 
c01051d2:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01051d9:	c0 
c01051da:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01051e1:	00 
c01051e2:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01051e9:	e8 d2 ba ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    p = alloc_page();
c01051ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051f5:	e8 19 ed ff ff       	call   c0103f13 <alloc_pages>
c01051fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01051fd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105202:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105209:	00 
c010520a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105211:	00 
c0105212:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105215:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105219:	89 04 24             	mov    %eax,(%esp)
c010521c:	e8 6c f6 ff ff       	call   c010488d <page_insert>
c0105221:	85 c0                	test   %eax,%eax
c0105223:	74 24                	je     c0105249 <check_boot_pgdir+0x1ed>
c0105225:	c7 44 24 0c e8 70 10 	movl   $0xc01070e8,0xc(%esp)
c010522c:	c0 
c010522d:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0105234:	c0 
c0105235:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c010523c:	00 
c010523d:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0105244:	e8 77 ba ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 1);
c0105249:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010524c:	89 04 24             	mov    %eax,(%esp)
c010524f:	e8 ba ea ff ff       	call   c0103d0e <page_ref>
c0105254:	83 f8 01             	cmp    $0x1,%eax
c0105257:	74 24                	je     c010527d <check_boot_pgdir+0x221>
c0105259:	c7 44 24 0c 16 71 10 	movl   $0xc0107116,0xc(%esp)
c0105260:	c0 
c0105261:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0105268:	c0 
c0105269:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105270:	00 
c0105271:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0105278:	e8 43 ba ff ff       	call   c0100cc0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010527d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105282:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105289:	00 
c010528a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105291:	00 
c0105292:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105295:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105299:	89 04 24             	mov    %eax,(%esp)
c010529c:	e8 ec f5 ff ff       	call   c010488d <page_insert>
c01052a1:	85 c0                	test   %eax,%eax
c01052a3:	74 24                	je     c01052c9 <check_boot_pgdir+0x26d>
c01052a5:	c7 44 24 0c 28 71 10 	movl   $0xc0107128,0xc(%esp)
c01052ac:	c0 
c01052ad:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01052b4:	c0 
c01052b5:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01052bc:	00 
c01052bd:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01052c4:	e8 f7 b9 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 2);
c01052c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052cc:	89 04 24             	mov    %eax,(%esp)
c01052cf:	e8 3a ea ff ff       	call   c0103d0e <page_ref>
c01052d4:	83 f8 02             	cmp    $0x2,%eax
c01052d7:	74 24                	je     c01052fd <check_boot_pgdir+0x2a1>
c01052d9:	c7 44 24 0c 5f 71 10 	movl   $0xc010715f,0xc(%esp)
c01052e0:	c0 
c01052e1:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c01052e8:	c0 
c01052e9:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01052f0:	00 
c01052f1:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c01052f8:	e8 c3 b9 ff ff       	call   c0100cc0 <__panic>

    const char *str = "ucore: Hello world!!";
c01052fd:	c7 45 dc 70 71 10 c0 	movl   $0xc0107170,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105304:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105307:	89 44 24 04          	mov    %eax,0x4(%esp)
c010530b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105312:	e8 1e 0a 00 00       	call   c0105d35 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105317:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010531e:	00 
c010531f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105326:	e8 83 0a 00 00       	call   c0105dae <strcmp>
c010532b:	85 c0                	test   %eax,%eax
c010532d:	74 24                	je     c0105353 <check_boot_pgdir+0x2f7>
c010532f:	c7 44 24 0c 88 71 10 	movl   $0xc0107188,0xc(%esp)
c0105336:	c0 
c0105337:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c010533e:	c0 
c010533f:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105346:	00 
c0105347:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c010534e:	e8 6d b9 ff ff       	call   c0100cc0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105353:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105356:	89 04 24             	mov    %eax,(%esp)
c0105359:	e8 1e e9 ff ff       	call   c0103c7c <page2kva>
c010535e:	05 00 01 00 00       	add    $0x100,%eax
c0105363:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105366:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010536d:	e8 6b 09 00 00       	call   c0105cdd <strlen>
c0105372:	85 c0                	test   %eax,%eax
c0105374:	74 24                	je     c010539a <check_boot_pgdir+0x33e>
c0105376:	c7 44 24 0c c0 71 10 	movl   $0xc01071c0,0xc(%esp)
c010537d:	c0 
c010537e:	c7 44 24 08 69 6d 10 	movl   $0xc0106d69,0x8(%esp)
c0105385:	c0 
c0105386:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c010538d:	00 
c010538e:	c7 04 24 44 6d 10 c0 	movl   $0xc0106d44,(%esp)
c0105395:	e8 26 b9 ff ff       	call   c0100cc0 <__panic>

    free_page(p);
c010539a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053a1:	00 
c01053a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053a5:	89 04 24             	mov    %eax,(%esp)
c01053a8:	e8 9e eb ff ff       	call   c0103f4b <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01053ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01053b2:	8b 00                	mov    (%eax),%eax
c01053b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053b9:	89 04 24             	mov    %eax,(%esp)
c01053bc:	e8 6c e8 ff ff       	call   c0103c2d <pa2page>
c01053c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053c8:	00 
c01053c9:	89 04 24             	mov    %eax,(%esp)
c01053cc:	e8 7a eb ff ff       	call   c0103f4b <free_pages>
    boot_pgdir[0] = 0;
c01053d1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01053d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01053dc:	c7 04 24 e4 71 10 c0 	movl   $0xc01071e4,(%esp)
c01053e3:	e8 54 af ff ff       	call   c010033c <cprintf>
}
c01053e8:	c9                   	leave  
c01053e9:	c3                   	ret    

c01053ea <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01053ea:	55                   	push   %ebp
c01053eb:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01053ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f0:	83 e0 04             	and    $0x4,%eax
c01053f3:	85 c0                	test   %eax,%eax
c01053f5:	74 07                	je     c01053fe <perm2str+0x14>
c01053f7:	b8 75 00 00 00       	mov    $0x75,%eax
c01053fc:	eb 05                	jmp    c0105403 <perm2str+0x19>
c01053fe:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105403:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105408:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010540f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105412:	83 e0 02             	and    $0x2,%eax
c0105415:	85 c0                	test   %eax,%eax
c0105417:	74 07                	je     c0105420 <perm2str+0x36>
c0105419:	b8 77 00 00 00       	mov    $0x77,%eax
c010541e:	eb 05                	jmp    c0105425 <perm2str+0x3b>
c0105420:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105425:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010542a:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105431:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105436:	5d                   	pop    %ebp
c0105437:	c3                   	ret    

c0105438 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105438:	55                   	push   %ebp
c0105439:	89 e5                	mov    %esp,%ebp
c010543b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010543e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105441:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105444:	72 0a                	jb     c0105450 <get_pgtable_items+0x18>
        return 0;
c0105446:	b8 00 00 00 00       	mov    $0x0,%eax
c010544b:	e9 9c 00 00 00       	jmp    c01054ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105450:	eb 04                	jmp    c0105456 <get_pgtable_items+0x1e>
        start ++;
c0105452:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105456:	8b 45 10             	mov    0x10(%ebp),%eax
c0105459:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010545c:	73 18                	jae    c0105476 <get_pgtable_items+0x3e>
c010545e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105468:	8b 45 14             	mov    0x14(%ebp),%eax
c010546b:	01 d0                	add    %edx,%eax
c010546d:	8b 00                	mov    (%eax),%eax
c010546f:	83 e0 01             	and    $0x1,%eax
c0105472:	85 c0                	test   %eax,%eax
c0105474:	74 dc                	je     c0105452 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105476:	8b 45 10             	mov    0x10(%ebp),%eax
c0105479:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010547c:	73 69                	jae    c01054e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010547e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105482:	74 08                	je     c010548c <get_pgtable_items+0x54>
            *left_store = start;
c0105484:	8b 45 18             	mov    0x18(%ebp),%eax
c0105487:	8b 55 10             	mov    0x10(%ebp),%edx
c010548a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010548c:	8b 45 10             	mov    0x10(%ebp),%eax
c010548f:	8d 50 01             	lea    0x1(%eax),%edx
c0105492:	89 55 10             	mov    %edx,0x10(%ebp)
c0105495:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010549c:	8b 45 14             	mov    0x14(%ebp),%eax
c010549f:	01 d0                	add    %edx,%eax
c01054a1:	8b 00                	mov    (%eax),%eax
c01054a3:	83 e0 07             	and    $0x7,%eax
c01054a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01054a9:	eb 04                	jmp    c01054af <get_pgtable_items+0x77>
            start ++;
c01054ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01054af:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054b5:	73 1d                	jae    c01054d4 <get_pgtable_items+0x9c>
c01054b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01054ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01054c4:	01 d0                	add    %edx,%eax
c01054c6:	8b 00                	mov    (%eax),%eax
c01054c8:	83 e0 07             	and    $0x7,%eax
c01054cb:	89 c2                	mov    %eax,%edx
c01054cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054d0:	39 c2                	cmp    %eax,%edx
c01054d2:	74 d7                	je     c01054ab <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01054d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054d8:	74 08                	je     c01054e2 <get_pgtable_items+0xaa>
            *right_store = start;
c01054da:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01054e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054e5:	eb 05                	jmp    c01054ec <get_pgtable_items+0xb4>
    }
    return 0;
c01054e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054ec:	c9                   	leave  
c01054ed:	c3                   	ret    

c01054ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01054ee:	55                   	push   %ebp
c01054ef:	89 e5                	mov    %esp,%ebp
c01054f1:	57                   	push   %edi
c01054f2:	56                   	push   %esi
c01054f3:	53                   	push   %ebx
c01054f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01054f7:	c7 04 24 04 72 10 c0 	movl   $0xc0107204,(%esp)
c01054fe:	e8 39 ae ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105503:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010550a:	e9 fa 00 00 00       	jmp    c0105609 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010550f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105512:	89 04 24             	mov    %eax,(%esp)
c0105515:	e8 d0 fe ff ff       	call   c01053ea <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010551a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010551d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105520:	29 d1                	sub    %edx,%ecx
c0105522:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105524:	89 d6                	mov    %edx,%esi
c0105526:	c1 e6 16             	shl    $0x16,%esi
c0105529:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010552c:	89 d3                	mov    %edx,%ebx
c010552e:	c1 e3 16             	shl    $0x16,%ebx
c0105531:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105534:	89 d1                	mov    %edx,%ecx
c0105536:	c1 e1 16             	shl    $0x16,%ecx
c0105539:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010553c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010553f:	29 d7                	sub    %edx,%edi
c0105541:	89 fa                	mov    %edi,%edx
c0105543:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105547:	89 74 24 10          	mov    %esi,0x10(%esp)
c010554b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010554f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105553:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105557:	c7 04 24 35 72 10 c0 	movl   $0xc0107235,(%esp)
c010555e:	e8 d9 ad ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105563:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105566:	c1 e0 0a             	shl    $0xa,%eax
c0105569:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010556c:	eb 54                	jmp    c01055c2 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010556e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105571:	89 04 24             	mov    %eax,(%esp)
c0105574:	e8 71 fe ff ff       	call   c01053ea <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105579:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010557c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010557f:	29 d1                	sub    %edx,%ecx
c0105581:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105583:	89 d6                	mov    %edx,%esi
c0105585:	c1 e6 0c             	shl    $0xc,%esi
c0105588:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010558b:	89 d3                	mov    %edx,%ebx
c010558d:	c1 e3 0c             	shl    $0xc,%ebx
c0105590:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105593:	c1 e2 0c             	shl    $0xc,%edx
c0105596:	89 d1                	mov    %edx,%ecx
c0105598:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010559b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010559e:	29 d7                	sub    %edx,%edi
c01055a0:	89 fa                	mov    %edi,%edx
c01055a2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01055a6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01055aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01055b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055b6:	c7 04 24 54 72 10 c0 	movl   $0xc0107254,(%esp)
c01055bd:	e8 7a ad ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01055c2:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01055c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01055ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01055cd:	89 ce                	mov    %ecx,%esi
c01055cf:	c1 e6 0a             	shl    $0xa,%esi
c01055d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01055d5:	89 cb                	mov    %ecx,%ebx
c01055d7:	c1 e3 0a             	shl    $0xa,%ebx
c01055da:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01055dd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01055e1:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01055e4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01055e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055f0:	89 74 24 04          	mov    %esi,0x4(%esp)
c01055f4:	89 1c 24             	mov    %ebx,(%esp)
c01055f7:	e8 3c fe ff ff       	call   c0105438 <get_pgtable_items>
c01055fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105603:	0f 85 65 ff ff ff    	jne    c010556e <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105609:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010560e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105611:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105614:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105618:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010561b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010561f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105623:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105627:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010562e:	00 
c010562f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105636:	e8 fd fd ff ff       	call   c0105438 <get_pgtable_items>
c010563b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010563e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105642:	0f 85 c7 fe ff ff    	jne    c010550f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105648:	c7 04 24 78 72 10 c0 	movl   $0xc0107278,(%esp)
c010564f:	e8 e8 ac ff ff       	call   c010033c <cprintf>
}
c0105654:	83 c4 4c             	add    $0x4c,%esp
c0105657:	5b                   	pop    %ebx
c0105658:	5e                   	pop    %esi
c0105659:	5f                   	pop    %edi
c010565a:	5d                   	pop    %ebp
c010565b:	c3                   	ret    

c010565c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010565c:	55                   	push   %ebp
c010565d:	89 e5                	mov    %esp,%ebp
c010565f:	83 ec 58             	sub    $0x58,%esp
c0105662:	8b 45 10             	mov    0x10(%ebp),%eax
c0105665:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105668:	8b 45 14             	mov    0x14(%ebp),%eax
c010566b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010566e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105671:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105674:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105677:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010567a:	8b 45 18             	mov    0x18(%ebp),%eax
c010567d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105680:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105683:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105686:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105689:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010568c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010568f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105696:	74 1c                	je     c01056b4 <printnum+0x58>
c0105698:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010569b:	ba 00 00 00 00       	mov    $0x0,%edx
c01056a0:	f7 75 e4             	divl   -0x1c(%ebp)
c01056a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01056ae:	f7 75 e4             	divl   -0x1c(%ebp)
c01056b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056ba:	f7 75 e4             	divl   -0x1c(%ebp)
c01056bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01056c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01056c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01056cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056d2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01056d5:	8b 45 18             	mov    0x18(%ebp),%eax
c01056d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01056dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056e0:	77 56                	ja     c0105738 <printnum+0xdc>
c01056e2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056e5:	72 05                	jb     c01056ec <printnum+0x90>
c01056e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01056ea:	77 4c                	ja     c0105738 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01056ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01056ef:	8d 50 ff             	lea    -0x1(%eax),%edx
c01056f2:	8b 45 20             	mov    0x20(%ebp),%eax
c01056f5:	89 44 24 18          	mov    %eax,0x18(%esp)
c01056f9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01056fd:	8b 45 18             	mov    0x18(%ebp),%eax
c0105700:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105704:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105707:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010570a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010570e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105712:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105719:	8b 45 08             	mov    0x8(%ebp),%eax
c010571c:	89 04 24             	mov    %eax,(%esp)
c010571f:	e8 38 ff ff ff       	call   c010565c <printnum>
c0105724:	eb 1c                	jmp    c0105742 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105726:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105730:	89 04 24             	mov    %eax,(%esp)
c0105733:	8b 45 08             	mov    0x8(%ebp),%eax
c0105736:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105738:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010573c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105740:	7f e4                	jg     c0105726 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105742:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105745:	05 2c 73 10 c0       	add    $0xc010732c,%eax
c010574a:	0f b6 00             	movzbl (%eax),%eax
c010574d:	0f be c0             	movsbl %al,%eax
c0105750:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105753:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105757:	89 04 24             	mov    %eax,(%esp)
c010575a:	8b 45 08             	mov    0x8(%ebp),%eax
c010575d:	ff d0                	call   *%eax
}
c010575f:	c9                   	leave  
c0105760:	c3                   	ret    

c0105761 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105761:	55                   	push   %ebp
c0105762:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105764:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105768:	7e 14                	jle    c010577e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010576a:	8b 45 08             	mov    0x8(%ebp),%eax
c010576d:	8b 00                	mov    (%eax),%eax
c010576f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105772:	8b 55 08             	mov    0x8(%ebp),%edx
c0105775:	89 0a                	mov    %ecx,(%edx)
c0105777:	8b 50 04             	mov    0x4(%eax),%edx
c010577a:	8b 00                	mov    (%eax),%eax
c010577c:	eb 30                	jmp    c01057ae <getuint+0x4d>
    }
    else if (lflag) {
c010577e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105782:	74 16                	je     c010579a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105784:	8b 45 08             	mov    0x8(%ebp),%eax
c0105787:	8b 00                	mov    (%eax),%eax
c0105789:	8d 48 04             	lea    0x4(%eax),%ecx
c010578c:	8b 55 08             	mov    0x8(%ebp),%edx
c010578f:	89 0a                	mov    %ecx,(%edx)
c0105791:	8b 00                	mov    (%eax),%eax
c0105793:	ba 00 00 00 00       	mov    $0x0,%edx
c0105798:	eb 14                	jmp    c01057ae <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010579a:	8b 45 08             	mov    0x8(%ebp),%eax
c010579d:	8b 00                	mov    (%eax),%eax
c010579f:	8d 48 04             	lea    0x4(%eax),%ecx
c01057a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01057a5:	89 0a                	mov    %ecx,(%edx)
c01057a7:	8b 00                	mov    (%eax),%eax
c01057a9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01057ae:	5d                   	pop    %ebp
c01057af:	c3                   	ret    

c01057b0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01057b0:	55                   	push   %ebp
c01057b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01057b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01057b7:	7e 14                	jle    c01057cd <getint+0x1d>
        return va_arg(*ap, long long);
c01057b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bc:	8b 00                	mov    (%eax),%eax
c01057be:	8d 48 08             	lea    0x8(%eax),%ecx
c01057c1:	8b 55 08             	mov    0x8(%ebp),%edx
c01057c4:	89 0a                	mov    %ecx,(%edx)
c01057c6:	8b 50 04             	mov    0x4(%eax),%edx
c01057c9:	8b 00                	mov    (%eax),%eax
c01057cb:	eb 28                	jmp    c01057f5 <getint+0x45>
    }
    else if (lflag) {
c01057cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057d1:	74 12                	je     c01057e5 <getint+0x35>
        return va_arg(*ap, long);
c01057d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d6:	8b 00                	mov    (%eax),%eax
c01057d8:	8d 48 04             	lea    0x4(%eax),%ecx
c01057db:	8b 55 08             	mov    0x8(%ebp),%edx
c01057de:	89 0a                	mov    %ecx,(%edx)
c01057e0:	8b 00                	mov    (%eax),%eax
c01057e2:	99                   	cltd   
c01057e3:	eb 10                	jmp    c01057f5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01057e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e8:	8b 00                	mov    (%eax),%eax
c01057ea:	8d 48 04             	lea    0x4(%eax),%ecx
c01057ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01057f0:	89 0a                	mov    %ecx,(%edx)
c01057f2:	8b 00                	mov    (%eax),%eax
c01057f4:	99                   	cltd   
    }
}
c01057f5:	5d                   	pop    %ebp
c01057f6:	c3                   	ret    

c01057f7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057f7:	55                   	push   %ebp
c01057f8:	89 e5                	mov    %esp,%ebp
c01057fa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01057fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0105800:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105803:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105806:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010580a:	8b 45 10             	mov    0x10(%ebp),%eax
c010580d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105811:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105814:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105818:	8b 45 08             	mov    0x8(%ebp),%eax
c010581b:	89 04 24             	mov    %eax,(%esp)
c010581e:	e8 02 00 00 00       	call   c0105825 <vprintfmt>
    va_end(ap);
}
c0105823:	c9                   	leave  
c0105824:	c3                   	ret    

c0105825 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105825:	55                   	push   %ebp
c0105826:	89 e5                	mov    %esp,%ebp
c0105828:	56                   	push   %esi
c0105829:	53                   	push   %ebx
c010582a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010582d:	eb 18                	jmp    c0105847 <vprintfmt+0x22>
            if (ch == '\0') {
c010582f:	85 db                	test   %ebx,%ebx
c0105831:	75 05                	jne    c0105838 <vprintfmt+0x13>
                return;
c0105833:	e9 d1 03 00 00       	jmp    c0105c09 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105838:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583f:	89 1c 24             	mov    %ebx,(%esp)
c0105842:	8b 45 08             	mov    0x8(%ebp),%eax
c0105845:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105847:	8b 45 10             	mov    0x10(%ebp),%eax
c010584a:	8d 50 01             	lea    0x1(%eax),%edx
c010584d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105850:	0f b6 00             	movzbl (%eax),%eax
c0105853:	0f b6 d8             	movzbl %al,%ebx
c0105856:	83 fb 25             	cmp    $0x25,%ebx
c0105859:	75 d4                	jne    c010582f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010585b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010585f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105869:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010586c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105873:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105876:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105879:	8b 45 10             	mov    0x10(%ebp),%eax
c010587c:	8d 50 01             	lea    0x1(%eax),%edx
c010587f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105882:	0f b6 00             	movzbl (%eax),%eax
c0105885:	0f b6 d8             	movzbl %al,%ebx
c0105888:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010588b:	83 f8 55             	cmp    $0x55,%eax
c010588e:	0f 87 44 03 00 00    	ja     c0105bd8 <vprintfmt+0x3b3>
c0105894:	8b 04 85 50 73 10 c0 	mov    -0x3fef8cb0(,%eax,4),%eax
c010589b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010589d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01058a1:	eb d6                	jmp    c0105879 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01058a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01058a7:	eb d0                	jmp    c0105879 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01058a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01058b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058b3:	89 d0                	mov    %edx,%eax
c01058b5:	c1 e0 02             	shl    $0x2,%eax
c01058b8:	01 d0                	add    %edx,%eax
c01058ba:	01 c0                	add    %eax,%eax
c01058bc:	01 d8                	add    %ebx,%eax
c01058be:	83 e8 30             	sub    $0x30,%eax
c01058c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01058c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01058c7:	0f b6 00             	movzbl (%eax),%eax
c01058ca:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01058cd:	83 fb 2f             	cmp    $0x2f,%ebx
c01058d0:	7e 0b                	jle    c01058dd <vprintfmt+0xb8>
c01058d2:	83 fb 39             	cmp    $0x39,%ebx
c01058d5:	7f 06                	jg     c01058dd <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01058d7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01058db:	eb d3                	jmp    c01058b0 <vprintfmt+0x8b>
            goto process_precision;
c01058dd:	eb 33                	jmp    c0105912 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01058df:	8b 45 14             	mov    0x14(%ebp),%eax
c01058e2:	8d 50 04             	lea    0x4(%eax),%edx
c01058e5:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e8:	8b 00                	mov    (%eax),%eax
c01058ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01058ed:	eb 23                	jmp    c0105912 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01058ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058f3:	79 0c                	jns    c0105901 <vprintfmt+0xdc>
                width = 0;
c01058f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058fc:	e9 78 ff ff ff       	jmp    c0105879 <vprintfmt+0x54>
c0105901:	e9 73 ff ff ff       	jmp    c0105879 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105906:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010590d:	e9 67 ff ff ff       	jmp    c0105879 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105912:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105916:	79 12                	jns    c010592a <vprintfmt+0x105>
                width = precision, precision = -1;
c0105918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010591b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010591e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105925:	e9 4f ff ff ff       	jmp    c0105879 <vprintfmt+0x54>
c010592a:	e9 4a ff ff ff       	jmp    c0105879 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010592f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105933:	e9 41 ff ff ff       	jmp    c0105879 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105938:	8b 45 14             	mov    0x14(%ebp),%eax
c010593b:	8d 50 04             	lea    0x4(%eax),%edx
c010593e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105941:	8b 00                	mov    (%eax),%eax
c0105943:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105946:	89 54 24 04          	mov    %edx,0x4(%esp)
c010594a:	89 04 24             	mov    %eax,(%esp)
c010594d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105950:	ff d0                	call   *%eax
            break;
c0105952:	e9 ac 02 00 00       	jmp    c0105c03 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105957:	8b 45 14             	mov    0x14(%ebp),%eax
c010595a:	8d 50 04             	lea    0x4(%eax),%edx
c010595d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105960:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105962:	85 db                	test   %ebx,%ebx
c0105964:	79 02                	jns    c0105968 <vprintfmt+0x143>
                err = -err;
c0105966:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105968:	83 fb 06             	cmp    $0x6,%ebx
c010596b:	7f 0b                	jg     c0105978 <vprintfmt+0x153>
c010596d:	8b 34 9d 10 73 10 c0 	mov    -0x3fef8cf0(,%ebx,4),%esi
c0105974:	85 f6                	test   %esi,%esi
c0105976:	75 23                	jne    c010599b <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105978:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010597c:	c7 44 24 08 3d 73 10 	movl   $0xc010733d,0x8(%esp)
c0105983:	c0 
c0105984:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105987:	89 44 24 04          	mov    %eax,0x4(%esp)
c010598b:	8b 45 08             	mov    0x8(%ebp),%eax
c010598e:	89 04 24             	mov    %eax,(%esp)
c0105991:	e8 61 fe ff ff       	call   c01057f7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105996:	e9 68 02 00 00       	jmp    c0105c03 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010599b:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010599f:	c7 44 24 08 46 73 10 	movl   $0xc0107346,0x8(%esp)
c01059a6:	c0 
c01059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b1:	89 04 24             	mov    %eax,(%esp)
c01059b4:	e8 3e fe ff ff       	call   c01057f7 <printfmt>
            }
            break;
c01059b9:	e9 45 02 00 00       	jmp    c0105c03 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01059be:	8b 45 14             	mov    0x14(%ebp),%eax
c01059c1:	8d 50 04             	lea    0x4(%eax),%edx
c01059c4:	89 55 14             	mov    %edx,0x14(%ebp)
c01059c7:	8b 30                	mov    (%eax),%esi
c01059c9:	85 f6                	test   %esi,%esi
c01059cb:	75 05                	jne    c01059d2 <vprintfmt+0x1ad>
                p = "(null)";
c01059cd:	be 49 73 10 c0       	mov    $0xc0107349,%esi
            }
            if (width > 0 && padc != '-') {
c01059d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059d6:	7e 3e                	jle    c0105a16 <vprintfmt+0x1f1>
c01059d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01059dc:	74 38                	je     c0105a16 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01059de:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01059e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e8:	89 34 24             	mov    %esi,(%esp)
c01059eb:	e8 15 03 00 00       	call   c0105d05 <strnlen>
c01059f0:	29 c3                	sub    %eax,%ebx
c01059f2:	89 d8                	mov    %ebx,%eax
c01059f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059f7:	eb 17                	jmp    c0105a10 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01059f9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01059fd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a00:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a04:	89 04 24             	mov    %eax,(%esp)
c0105a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a0c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a14:	7f e3                	jg     c01059f9 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105a16:	eb 38                	jmp    c0105a50 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105a1c:	74 1f                	je     c0105a3d <vprintfmt+0x218>
c0105a1e:	83 fb 1f             	cmp    $0x1f,%ebx
c0105a21:	7e 05                	jle    c0105a28 <vprintfmt+0x203>
c0105a23:	83 fb 7e             	cmp    $0x7e,%ebx
c0105a26:	7e 15                	jle    c0105a3d <vprintfmt+0x218>
                    putch('?', putdat);
c0105a28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a39:	ff d0                	call   *%eax
c0105a3b:	eb 0f                	jmp    c0105a4c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a44:	89 1c 24             	mov    %ebx,(%esp)
c0105a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105a4c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a50:	89 f0                	mov    %esi,%eax
c0105a52:	8d 70 01             	lea    0x1(%eax),%esi
c0105a55:	0f b6 00             	movzbl (%eax),%eax
c0105a58:	0f be d8             	movsbl %al,%ebx
c0105a5b:	85 db                	test   %ebx,%ebx
c0105a5d:	74 10                	je     c0105a6f <vprintfmt+0x24a>
c0105a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a63:	78 b3                	js     c0105a18 <vprintfmt+0x1f3>
c0105a65:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a6d:	79 a9                	jns    c0105a18 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a6f:	eb 17                	jmp    c0105a88 <vprintfmt+0x263>
                putch(' ', putdat);
c0105a71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a78:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a82:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a84:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a8c:	7f e3                	jg     c0105a71 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105a8e:	e9 70 01 00 00       	jmp    c0105c03 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a9a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a9d:	89 04 24             	mov    %eax,(%esp)
c0105aa0:	e8 0b fd ff ff       	call   c01057b0 <getint>
c0105aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ab1:	85 d2                	test   %edx,%edx
c0105ab3:	79 26                	jns    c0105adb <vprintfmt+0x2b6>
                putch('-', putdat);
c0105ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105abc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac6:	ff d0                	call   *%eax
                num = -(long long)num;
c0105ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ace:	f7 d8                	neg    %eax
c0105ad0:	83 d2 00             	adc    $0x0,%edx
c0105ad3:	f7 da                	neg    %edx
c0105ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ad8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105adb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105ae2:	e9 a8 00 00 00       	jmp    c0105b8f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aee:	8d 45 14             	lea    0x14(%ebp),%eax
c0105af1:	89 04 24             	mov    %eax,(%esp)
c0105af4:	e8 68 fc ff ff       	call   c0105761 <getuint>
c0105af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105aff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b06:	e9 84 00 00 00       	jmp    c0105b8f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b12:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b15:	89 04 24             	mov    %eax,(%esp)
c0105b18:	e8 44 fc ff ff       	call   c0105761 <getuint>
c0105b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105b23:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105b2a:	eb 63                	jmp    c0105b8f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b33:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3d:	ff d0                	call   *%eax
            putch('x', putdat);
c0105b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b46:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b50:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105b52:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b55:	8d 50 04             	lea    0x4(%eax),%edx
c0105b58:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b5b:	8b 00                	mov    (%eax),%eax
c0105b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105b67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105b6e:	eb 1f                	jmp    c0105b8f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b77:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b7a:	89 04 24             	mov    %eax,(%esp)
c0105b7d:	e8 df fb ff ff       	call   c0105761 <getuint>
c0105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b88:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b8f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b96:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b9d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105ba1:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bab:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105baf:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbd:	89 04 24             	mov    %eax,(%esp)
c0105bc0:	e8 97 fa ff ff       	call   c010565c <printnum>
            break;
c0105bc5:	eb 3c                	jmp    c0105c03 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bce:	89 1c 24             	mov    %ebx,(%esp)
c0105bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd4:	ff d0                	call   *%eax
            break;
c0105bd6:	eb 2b                	jmp    c0105c03 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bdf:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105be6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105beb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bef:	eb 04                	jmp    c0105bf5 <vprintfmt+0x3d0>
c0105bf1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bf8:	83 e8 01             	sub    $0x1,%eax
c0105bfb:	0f b6 00             	movzbl (%eax),%eax
c0105bfe:	3c 25                	cmp    $0x25,%al
c0105c00:	75 ef                	jne    c0105bf1 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105c02:	90                   	nop
        }
    }
c0105c03:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c04:	e9 3e fc ff ff       	jmp    c0105847 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105c09:	83 c4 40             	add    $0x40,%esp
c0105c0c:	5b                   	pop    %ebx
c0105c0d:	5e                   	pop    %esi
c0105c0e:	5d                   	pop    %ebp
c0105c0f:	c3                   	ret    

c0105c10 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105c10:	55                   	push   %ebp
c0105c11:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105c13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c16:	8b 40 08             	mov    0x8(%eax),%eax
c0105c19:	8d 50 01             	lea    0x1(%eax),%edx
c0105c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c1f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c25:	8b 10                	mov    (%eax),%edx
c0105c27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c2a:	8b 40 04             	mov    0x4(%eax),%eax
c0105c2d:	39 c2                	cmp    %eax,%edx
c0105c2f:	73 12                	jae    c0105c43 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c34:	8b 00                	mov    (%eax),%eax
c0105c36:	8d 48 01             	lea    0x1(%eax),%ecx
c0105c39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c3c:	89 0a                	mov    %ecx,(%edx)
c0105c3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c41:	88 10                	mov    %dl,(%eax)
    }
}
c0105c43:	5d                   	pop    %ebp
c0105c44:	c3                   	ret    

c0105c45 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105c45:	55                   	push   %ebp
c0105c46:	89 e5                	mov    %esp,%ebp
c0105c48:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105c4b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c54:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c58:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c69:	89 04 24             	mov    %eax,(%esp)
c0105c6c:	e8 08 00 00 00       	call   c0105c79 <vsnprintf>
c0105c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c77:	c9                   	leave  
c0105c78:	c3                   	ret    

c0105c79 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105c79:	55                   	push   %ebp
c0105c7a:	89 e5                	mov    %esp,%ebp
c0105c7c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c88:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8e:	01 d0                	add    %edx,%eax
c0105c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c9e:	74 0a                	je     c0105caa <vsnprintf+0x31>
c0105ca0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ca6:	39 c2                	cmp    %eax,%edx
c0105ca8:	76 07                	jbe    c0105cb1 <vsnprintf+0x38>
        return -E_INVAL;
c0105caa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105caf:	eb 2a                	jmp    c0105cdb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105cb1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cb4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105cb8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105cbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cc6:	c7 04 24 10 5c 10 c0 	movl   $0xc0105c10,(%esp)
c0105ccd:	e8 53 fb ff ff       	call   c0105825 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cd5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105cdb:	c9                   	leave  
c0105cdc:	c3                   	ret    

c0105cdd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105cdd:	55                   	push   %ebp
c0105cde:	89 e5                	mov    %esp,%ebp
c0105ce0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ce3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105cea:	eb 04                	jmp    c0105cf0 <strlen+0x13>
        cnt ++;
c0105cec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105cf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf3:	8d 50 01             	lea    0x1(%eax),%edx
c0105cf6:	89 55 08             	mov    %edx,0x8(%ebp)
c0105cf9:	0f b6 00             	movzbl (%eax),%eax
c0105cfc:	84 c0                	test   %al,%al
c0105cfe:	75 ec                	jne    c0105cec <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105d03:	c9                   	leave  
c0105d04:	c3                   	ret    

c0105d05 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105d05:	55                   	push   %ebp
c0105d06:	89 e5                	mov    %esp,%ebp
c0105d08:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105d12:	eb 04                	jmp    c0105d18 <strnlen+0x13>
        cnt ++;
c0105d14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d1e:	73 10                	jae    c0105d30 <strnlen+0x2b>
c0105d20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d23:	8d 50 01             	lea    0x1(%eax),%edx
c0105d26:	89 55 08             	mov    %edx,0x8(%ebp)
c0105d29:	0f b6 00             	movzbl (%eax),%eax
c0105d2c:	84 c0                	test   %al,%al
c0105d2e:	75 e4                	jne    c0105d14 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105d33:	c9                   	leave  
c0105d34:	c3                   	ret    

c0105d35 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105d35:	55                   	push   %ebp
c0105d36:	89 e5                	mov    %esp,%ebp
c0105d38:	57                   	push   %edi
c0105d39:	56                   	push   %esi
c0105d3a:	83 ec 20             	sub    $0x20,%esp
c0105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105d49:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d4f:	89 d1                	mov    %edx,%ecx
c0105d51:	89 c2                	mov    %eax,%edx
c0105d53:	89 ce                	mov    %ecx,%esi
c0105d55:	89 d7                	mov    %edx,%edi
c0105d57:	ac                   	lods   %ds:(%esi),%al
c0105d58:	aa                   	stos   %al,%es:(%edi)
c0105d59:	84 c0                	test   %al,%al
c0105d5b:	75 fa                	jne    c0105d57 <strcpy+0x22>
c0105d5d:	89 fa                	mov    %edi,%edx
c0105d5f:	89 f1                	mov    %esi,%ecx
c0105d61:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d64:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105d6d:	83 c4 20             	add    $0x20,%esp
c0105d70:	5e                   	pop    %esi
c0105d71:	5f                   	pop    %edi
c0105d72:	5d                   	pop    %ebp
c0105d73:	c3                   	ret    

c0105d74 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105d74:	55                   	push   %ebp
c0105d75:	89 e5                	mov    %esp,%ebp
c0105d77:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105d80:	eb 21                	jmp    c0105da3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105d82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d85:	0f b6 10             	movzbl (%eax),%edx
c0105d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d8b:	88 10                	mov    %dl,(%eax)
c0105d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d90:	0f b6 00             	movzbl (%eax),%eax
c0105d93:	84 c0                	test   %al,%al
c0105d95:	74 04                	je     c0105d9b <strncpy+0x27>
            src ++;
c0105d97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105d9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105da7:	75 d9                	jne    c0105d82 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105dac:	c9                   	leave  
c0105dad:	c3                   	ret    

c0105dae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105dae:	55                   	push   %ebp
c0105daf:	89 e5                	mov    %esp,%ebp
c0105db1:	57                   	push   %edi
c0105db2:	56                   	push   %esi
c0105db3:	83 ec 20             	sub    $0x20,%esp
c0105db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dc8:	89 d1                	mov    %edx,%ecx
c0105dca:	89 c2                	mov    %eax,%edx
c0105dcc:	89 ce                	mov    %ecx,%esi
c0105dce:	89 d7                	mov    %edx,%edi
c0105dd0:	ac                   	lods   %ds:(%esi),%al
c0105dd1:	ae                   	scas   %es:(%edi),%al
c0105dd2:	75 08                	jne    c0105ddc <strcmp+0x2e>
c0105dd4:	84 c0                	test   %al,%al
c0105dd6:	75 f8                	jne    c0105dd0 <strcmp+0x22>
c0105dd8:	31 c0                	xor    %eax,%eax
c0105dda:	eb 04                	jmp    c0105de0 <strcmp+0x32>
c0105ddc:	19 c0                	sbb    %eax,%eax
c0105dde:	0c 01                	or     $0x1,%al
c0105de0:	89 fa                	mov    %edi,%edx
c0105de2:	89 f1                	mov    %esi,%ecx
c0105de4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105de7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105dea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105df0:	83 c4 20             	add    $0x20,%esp
c0105df3:	5e                   	pop    %esi
c0105df4:	5f                   	pop    %edi
c0105df5:	5d                   	pop    %ebp
c0105df6:	c3                   	ret    

c0105df7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105df7:	55                   	push   %ebp
c0105df8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105dfa:	eb 0c                	jmp    c0105e08 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105dfc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105e00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e04:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105e08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e0c:	74 1a                	je     c0105e28 <strncmp+0x31>
c0105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e11:	0f b6 00             	movzbl (%eax),%eax
c0105e14:	84 c0                	test   %al,%al
c0105e16:	74 10                	je     c0105e28 <strncmp+0x31>
c0105e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1b:	0f b6 10             	movzbl (%eax),%edx
c0105e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e21:	0f b6 00             	movzbl (%eax),%eax
c0105e24:	38 c2                	cmp    %al,%dl
c0105e26:	74 d4                	je     c0105dfc <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e2c:	74 18                	je     c0105e46 <strncmp+0x4f>
c0105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e31:	0f b6 00             	movzbl (%eax),%eax
c0105e34:	0f b6 d0             	movzbl %al,%edx
c0105e37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3a:	0f b6 00             	movzbl (%eax),%eax
c0105e3d:	0f b6 c0             	movzbl %al,%eax
c0105e40:	29 c2                	sub    %eax,%edx
c0105e42:	89 d0                	mov    %edx,%eax
c0105e44:	eb 05                	jmp    c0105e4b <strncmp+0x54>
c0105e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e4b:	5d                   	pop    %ebp
c0105e4c:	c3                   	ret    

c0105e4d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105e4d:	55                   	push   %ebp
c0105e4e:	89 e5                	mov    %esp,%ebp
c0105e50:	83 ec 04             	sub    $0x4,%esp
c0105e53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e59:	eb 14                	jmp    c0105e6f <strchr+0x22>
        if (*s == c) {
c0105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5e:	0f b6 00             	movzbl (%eax),%eax
c0105e61:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e64:	75 05                	jne    c0105e6b <strchr+0x1e>
            return (char *)s;
c0105e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e69:	eb 13                	jmp    c0105e7e <strchr+0x31>
        }
        s ++;
c0105e6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e72:	0f b6 00             	movzbl (%eax),%eax
c0105e75:	84 c0                	test   %al,%al
c0105e77:	75 e2                	jne    c0105e5b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e7e:	c9                   	leave  
c0105e7f:	c3                   	ret    

c0105e80 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105e80:	55                   	push   %ebp
c0105e81:	89 e5                	mov    %esp,%ebp
c0105e83:	83 ec 04             	sub    $0x4,%esp
c0105e86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e89:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e8c:	eb 11                	jmp    c0105e9f <strfind+0x1f>
        if (*s == c) {
c0105e8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e91:	0f b6 00             	movzbl (%eax),%eax
c0105e94:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e97:	75 02                	jne    c0105e9b <strfind+0x1b>
            break;
c0105e99:	eb 0e                	jmp    c0105ea9 <strfind+0x29>
        }
        s ++;
c0105e9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea2:	0f b6 00             	movzbl (%eax),%eax
c0105ea5:	84 c0                	test   %al,%al
c0105ea7:	75 e5                	jne    c0105e8e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105eac:	c9                   	leave  
c0105ead:	c3                   	ret    

c0105eae <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105eae:	55                   	push   %ebp
c0105eaf:	89 e5                	mov    %esp,%ebp
c0105eb1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ebb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ec2:	eb 04                	jmp    c0105ec8 <strtol+0x1a>
        s ++;
c0105ec4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ec8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ecb:	0f b6 00             	movzbl (%eax),%eax
c0105ece:	3c 20                	cmp    $0x20,%al
c0105ed0:	74 f2                	je     c0105ec4 <strtol+0x16>
c0105ed2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed5:	0f b6 00             	movzbl (%eax),%eax
c0105ed8:	3c 09                	cmp    $0x9,%al
c0105eda:	74 e8                	je     c0105ec4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105edc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edf:	0f b6 00             	movzbl (%eax),%eax
c0105ee2:	3c 2b                	cmp    $0x2b,%al
c0105ee4:	75 06                	jne    c0105eec <strtol+0x3e>
        s ++;
c0105ee6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105eea:	eb 15                	jmp    c0105f01 <strtol+0x53>
    }
    else if (*s == '-') {
c0105eec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eef:	0f b6 00             	movzbl (%eax),%eax
c0105ef2:	3c 2d                	cmp    $0x2d,%al
c0105ef4:	75 0b                	jne    c0105f01 <strtol+0x53>
        s ++, neg = 1;
c0105ef6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105efa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105f01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f05:	74 06                	je     c0105f0d <strtol+0x5f>
c0105f07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105f0b:	75 24                	jne    c0105f31 <strtol+0x83>
c0105f0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f10:	0f b6 00             	movzbl (%eax),%eax
c0105f13:	3c 30                	cmp    $0x30,%al
c0105f15:	75 1a                	jne    c0105f31 <strtol+0x83>
c0105f17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f1a:	83 c0 01             	add    $0x1,%eax
c0105f1d:	0f b6 00             	movzbl (%eax),%eax
c0105f20:	3c 78                	cmp    $0x78,%al
c0105f22:	75 0d                	jne    c0105f31 <strtol+0x83>
        s += 2, base = 16;
c0105f24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105f28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105f2f:	eb 2a                	jmp    c0105f5b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f35:	75 17                	jne    c0105f4e <strtol+0xa0>
c0105f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3a:	0f b6 00             	movzbl (%eax),%eax
c0105f3d:	3c 30                	cmp    $0x30,%al
c0105f3f:	75 0d                	jne    c0105f4e <strtol+0xa0>
        s ++, base = 8;
c0105f41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f45:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105f4c:	eb 0d                	jmp    c0105f5b <strtol+0xad>
    }
    else if (base == 0) {
c0105f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f52:	75 07                	jne    c0105f5b <strtol+0xad>
        base = 10;
c0105f54:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105f5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5e:	0f b6 00             	movzbl (%eax),%eax
c0105f61:	3c 2f                	cmp    $0x2f,%al
c0105f63:	7e 1b                	jle    c0105f80 <strtol+0xd2>
c0105f65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f68:	0f b6 00             	movzbl (%eax),%eax
c0105f6b:	3c 39                	cmp    $0x39,%al
c0105f6d:	7f 11                	jg     c0105f80 <strtol+0xd2>
            dig = *s - '0';
c0105f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f72:	0f b6 00             	movzbl (%eax),%eax
c0105f75:	0f be c0             	movsbl %al,%eax
c0105f78:	83 e8 30             	sub    $0x30,%eax
c0105f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f7e:	eb 48                	jmp    c0105fc8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105f80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f83:	0f b6 00             	movzbl (%eax),%eax
c0105f86:	3c 60                	cmp    $0x60,%al
c0105f88:	7e 1b                	jle    c0105fa5 <strtol+0xf7>
c0105f8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8d:	0f b6 00             	movzbl (%eax),%eax
c0105f90:	3c 7a                	cmp    $0x7a,%al
c0105f92:	7f 11                	jg     c0105fa5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105f94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f97:	0f b6 00             	movzbl (%eax),%eax
c0105f9a:	0f be c0             	movsbl %al,%eax
c0105f9d:	83 e8 57             	sub    $0x57,%eax
c0105fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105fa3:	eb 23                	jmp    c0105fc8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105fa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa8:	0f b6 00             	movzbl (%eax),%eax
c0105fab:	3c 40                	cmp    $0x40,%al
c0105fad:	7e 3d                	jle    c0105fec <strtol+0x13e>
c0105faf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb2:	0f b6 00             	movzbl (%eax),%eax
c0105fb5:	3c 5a                	cmp    $0x5a,%al
c0105fb7:	7f 33                	jg     c0105fec <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105fb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fbc:	0f b6 00             	movzbl (%eax),%eax
c0105fbf:	0f be c0             	movsbl %al,%eax
c0105fc2:	83 e8 37             	sub    $0x37,%eax
c0105fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fcb:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105fce:	7c 02                	jl     c0105fd2 <strtol+0x124>
            break;
c0105fd0:	eb 1a                	jmp    c0105fec <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105fd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fd9:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105fdd:	89 c2                	mov    %eax,%edx
c0105fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fe2:	01 d0                	add    %edx,%eax
c0105fe4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105fe7:	e9 6f ff ff ff       	jmp    c0105f5b <strtol+0xad>

    if (endptr) {
c0105fec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ff0:	74 08                	je     c0105ffa <strtol+0x14c>
        *endptr = (char *) s;
c0105ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ff5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ff8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105ffe:	74 07                	je     c0106007 <strtol+0x159>
c0106000:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106003:	f7 d8                	neg    %eax
c0106005:	eb 03                	jmp    c010600a <strtol+0x15c>
c0106007:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010600a:	c9                   	leave  
c010600b:	c3                   	ret    

c010600c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010600c:	55                   	push   %ebp
c010600d:	89 e5                	mov    %esp,%ebp
c010600f:	57                   	push   %edi
c0106010:	83 ec 24             	sub    $0x24,%esp
c0106013:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106016:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106019:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010601d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106020:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0106023:	88 45 f7             	mov    %al,-0x9(%ebp)
c0106026:	8b 45 10             	mov    0x10(%ebp),%eax
c0106029:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010602c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010602f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0106033:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106036:	89 d7                	mov    %edx,%edi
c0106038:	f3 aa                	rep stos %al,%es:(%edi)
c010603a:	89 fa                	mov    %edi,%edx
c010603c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010603f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0106042:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0106045:	83 c4 24             	add    $0x24,%esp
c0106048:	5f                   	pop    %edi
c0106049:	5d                   	pop    %ebp
c010604a:	c3                   	ret    

c010604b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010604b:	55                   	push   %ebp
c010604c:	89 e5                	mov    %esp,%ebp
c010604e:	57                   	push   %edi
c010604f:	56                   	push   %esi
c0106050:	53                   	push   %ebx
c0106051:	83 ec 30             	sub    $0x30,%esp
c0106054:	8b 45 08             	mov    0x8(%ebp),%eax
c0106057:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010605a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010605d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106060:	8b 45 10             	mov    0x10(%ebp),%eax
c0106063:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0106066:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106069:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010606c:	73 42                	jae    c01060b0 <memmove+0x65>
c010606e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106074:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106077:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010607a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010607d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106080:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106083:	c1 e8 02             	shr    $0x2,%eax
c0106086:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106088:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010608b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010608e:	89 d7                	mov    %edx,%edi
c0106090:	89 c6                	mov    %eax,%esi
c0106092:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106094:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106097:	83 e1 03             	and    $0x3,%ecx
c010609a:	74 02                	je     c010609e <memmove+0x53>
c010609c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010609e:	89 f0                	mov    %esi,%eax
c01060a0:	89 fa                	mov    %edi,%edx
c01060a2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01060a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01060a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01060ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060ae:	eb 36                	jmp    c01060e6 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01060b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01060b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060b9:	01 c2                	add    %eax,%edx
c01060bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060be:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01060c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060c4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01060c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060ca:	89 c1                	mov    %eax,%ecx
c01060cc:	89 d8                	mov    %ebx,%eax
c01060ce:	89 d6                	mov    %edx,%esi
c01060d0:	89 c7                	mov    %eax,%edi
c01060d2:	fd                   	std    
c01060d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01060d5:	fc                   	cld    
c01060d6:	89 f8                	mov    %edi,%eax
c01060d8:	89 f2                	mov    %esi,%edx
c01060da:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01060dd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01060e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01060e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01060e6:	83 c4 30             	add    $0x30,%esp
c01060e9:	5b                   	pop    %ebx
c01060ea:	5e                   	pop    %esi
c01060eb:	5f                   	pop    %edi
c01060ec:	5d                   	pop    %ebp
c01060ed:	c3                   	ret    

c01060ee <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01060ee:	55                   	push   %ebp
c01060ef:	89 e5                	mov    %esp,%ebp
c01060f1:	57                   	push   %edi
c01060f2:	56                   	push   %esi
c01060f3:	83 ec 20             	sub    $0x20,%esp
c01060f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01060f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106102:	8b 45 10             	mov    0x10(%ebp),%eax
c0106105:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106108:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010610b:	c1 e8 02             	shr    $0x2,%eax
c010610e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106110:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106113:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106116:	89 d7                	mov    %edx,%edi
c0106118:	89 c6                	mov    %eax,%esi
c010611a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010611c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010611f:	83 e1 03             	and    $0x3,%ecx
c0106122:	74 02                	je     c0106126 <memcpy+0x38>
c0106124:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106126:	89 f0                	mov    %esi,%eax
c0106128:	89 fa                	mov    %edi,%edx
c010612a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010612d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106130:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0106133:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106136:	83 c4 20             	add    $0x20,%esp
c0106139:	5e                   	pop    %esi
c010613a:	5f                   	pop    %edi
c010613b:	5d                   	pop    %ebp
c010613c:	c3                   	ret    

c010613d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010613d:	55                   	push   %ebp
c010613e:	89 e5                	mov    %esp,%ebp
c0106140:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106143:	8b 45 08             	mov    0x8(%ebp),%eax
c0106146:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106149:	8b 45 0c             	mov    0xc(%ebp),%eax
c010614c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010614f:	eb 30                	jmp    c0106181 <memcmp+0x44>
        if (*s1 != *s2) {
c0106151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106154:	0f b6 10             	movzbl (%eax),%edx
c0106157:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010615a:	0f b6 00             	movzbl (%eax),%eax
c010615d:	38 c2                	cmp    %al,%dl
c010615f:	74 18                	je     c0106179 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106161:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106164:	0f b6 00             	movzbl (%eax),%eax
c0106167:	0f b6 d0             	movzbl %al,%edx
c010616a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010616d:	0f b6 00             	movzbl (%eax),%eax
c0106170:	0f b6 c0             	movzbl %al,%eax
c0106173:	29 c2                	sub    %eax,%edx
c0106175:	89 d0                	mov    %edx,%eax
c0106177:	eb 1a                	jmp    c0106193 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0106179:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010617d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106181:	8b 45 10             	mov    0x10(%ebp),%eax
c0106184:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106187:	89 55 10             	mov    %edx,0x10(%ebp)
c010618a:	85 c0                	test   %eax,%eax
c010618c:	75 c3                	jne    c0106151 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010618e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106193:	c9                   	leave  
c0106194:	c3                   	ret    
