
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 99 9d 00 00       	call   c0109def <memset>

    cons_init();                // init the console
c0100056:	e8 82 15 00 00       	call   c01015dd <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 9f 10 c0 	movl   $0xc0109f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 9f 10 c0 	movl   $0xc0109f9c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 32 55 00 00       	call   c01055b6 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 32 1f 00 00       	call   c0101fbb <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 aa 20 00 00       	call   c0102138 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 b4 7b 00 00       	call   c0107c47 <vmm_init>
    proc_init();                // init process table
c0100093:	e8 4d 8f 00 00       	call   c0108fe5 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 71 16 00 00       	call   c010170e <ide_init>
    swap_init();                // init swap
c010009d:	e8 a0 67 00 00       	call   c0106842 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 ec 0c 00 00       	call   c0100d93 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 7d 1e 00 00       	call   c0101f29 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 f3 90 00 00       	call   c01091a4 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f2 0b 00 00       	call   c0100cc5 <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 a1 9f 10 c0 	movl   $0xc0109fa1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 af 9f 10 c0 	movl   $0xc0109faf,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 bd 9f 10 c0 	movl   $0xc0109fbd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 cb 9f 10 c0 	movl   $0xc0109fcb,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 d9 9f 10 c0 	movl   $0xc0109fd9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 e8 9f 10 c0 	movl   $0xc0109fe8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 08 a0 10 c0 	movl   $0xc010a008,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 27 a0 10 c0 	movl   $0xc010a027,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 f8 12 00 00       	call   c0101609 <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 e2 91 00 00       	call   c0109530 <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 7f 12 00 00       	call   c0101609 <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 5f 12 00 00       	call   c0101645 <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 2c a0 10 c0    	movl   $0xc010a02c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 2c a0 10 c0 	movl   $0xc010a02c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 04 c2 10 c0 	movl   $0xc010c204,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 a4 d5 11 c0 	movl   $0xc011d5a4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec a5 d5 11 c0 	movl   $0xc011d5a5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 89 1d 12 c0 	movl   $0xc0121d89,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 60 95 00 00       	call   c0109c63 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 36 a0 10 c0 	movl   $0xc010a036,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 4f a0 10 c0 	movl   $0xc010a04f,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 78 9f 10 	movl   $0xc0109f78,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 67 a0 10 c0 	movl   $0xc010a067,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 7f a0 10 c0 	movl   $0xc010a07f,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 97 a0 10 c0 	movl   $0xc010a097,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 b0 a0 10 c0 	movl   $0xc010a0b0,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 da a0 10 c0 	movl   $0xc010a0da,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 f6 a0 10 c0 	movl   $0xc010a0f6,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 88 00 00 00       	jmp    c0100a7e <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 08 a1 10 c0 	movl   $0xc010a108,(%esp)
c0100a0b:	e8 43 f9 ff ff       	call   c0100353 <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 02             	add    $0x2,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 24 a1 10 c0 	movl   $0xc010a124,(%esp)
c0100a3e:	e8 10 f9 ff ff       	call   c0100353 <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a4d:	c7 04 24 2c a1 10 c0 	movl   $0xc010a12c,(%esp)
c0100a54:	e8 fa f8 ff ff       	call   c0100353 <cprintf>
		print_debuginfo(eip - 1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b6 fe ff ff       	call   c010091d <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a82:	0f 8e 6e ff ff ff    	jle    c01009f6 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
c0100a88:	c9                   	leave  
c0100a89:	c3                   	ret    

c0100a8a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a8a:	55                   	push   %ebp
c0100a8b:	89 e5                	mov    %esp,%ebp
c0100a8d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a97:	eb 0c                	jmp    c0100aa5 <parse+0x1b>
            *buf ++ = '\0';
c0100a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9c:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9f:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa2:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	84 c0                	test   %al,%al
c0100aad:	74 1d                	je     c0100acc <parse+0x42>
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	0f be c0             	movsbl %al,%eax
c0100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100abc:	c7 04 24 b0 a1 10 c0 	movl   $0xc010a1b0,(%esp)
c0100ac3:	e8 68 91 00 00       	call   c0109c30 <strchr>
c0100ac8:	85 c0                	test   %eax,%eax
c0100aca:	75 cd                	jne    c0100a99 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acf:	0f b6 00             	movzbl (%eax),%eax
c0100ad2:	84 c0                	test   %al,%al
c0100ad4:	75 02                	jne    c0100ad8 <parse+0x4e>
            break;
c0100ad6:	eb 67                	jmp    c0100b3f <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100adc:	75 14                	jne    c0100af2 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ade:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae5:	00 
c0100ae6:	c7 04 24 b5 a1 10 c0 	movl   $0xc010a1b5,(%esp)
c0100aed:	e8 61 f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af5:	8d 50 01             	lea    0x1(%eax),%edx
c0100af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100afb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b05:	01 c2                	add    %eax,%edx
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0c:	eb 04                	jmp    c0100b12 <parse+0x88>
            buf ++;
c0100b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	84 c0                	test   %al,%al
c0100b1a:	74 1d                	je     c0100b39 <parse+0xaf>
c0100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1f:	0f b6 00             	movzbl (%eax),%eax
c0100b22:	0f be c0             	movsbl %al,%eax
c0100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b29:	c7 04 24 b0 a1 10 c0 	movl   $0xc010a1b0,(%esp)
c0100b30:	e8 fb 90 00 00       	call   c0109c30 <strchr>
c0100b35:	85 c0                	test   %eax,%eax
c0100b37:	74 d5                	je     c0100b0e <parse+0x84>
            buf ++;
        }
    }
c0100b39:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3a:	e9 66 ff ff ff       	jmp    c0100aa5 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b42:	c9                   	leave  
c0100b43:	c3                   	ret    

c0100b44 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b44:	55                   	push   %ebp
c0100b45:	89 e5                	mov    %esp,%ebp
c0100b47:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b54:	89 04 24             	mov    %eax,(%esp)
c0100b57:	e8 2e ff ff ff       	call   c0100a8a <parse>
c0100b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b63:	75 0a                	jne    c0100b6f <runcmd+0x2b>
        return 0;
c0100b65:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b6a:	e9 85 00 00 00       	jmp    c0100bf4 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b76:	eb 5c                	jmp    c0100bd4 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b78:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7e:	89 d0                	mov    %edx,%eax
c0100b80:	01 c0                	add    %eax,%eax
c0100b82:	01 d0                	add    %edx,%eax
c0100b84:	c1 e0 02             	shl    $0x2,%eax
c0100b87:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b8c:	8b 00                	mov    (%eax),%eax
c0100b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b92:	89 04 24             	mov    %eax,(%esp)
c0100b95:	e8 f7 8f 00 00       	call   c0109b91 <strcmp>
c0100b9a:	85 c0                	test   %eax,%eax
c0100b9c:	75 32                	jne    c0100bd0 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba1:	89 d0                	mov    %edx,%eax
c0100ba3:	01 c0                	add    %eax,%eax
c0100ba5:	01 d0                	add    %edx,%eax
c0100ba7:	c1 e0 02             	shl    $0x2,%eax
c0100baa:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100baf:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb5:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbf:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc2:	83 c2 04             	add    $0x4,%edx
c0100bc5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc9:	89 0c 24             	mov    %ecx,(%esp)
c0100bcc:	ff d0                	call   *%eax
c0100bce:	eb 24                	jmp    c0100bf4 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd7:	83 f8 02             	cmp    $0x2,%eax
c0100bda:	76 9c                	jbe    c0100b78 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be3:	c7 04 24 d3 a1 10 c0 	movl   $0xc010a1d3,(%esp)
c0100bea:	e8 64 f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf4:	c9                   	leave  
c0100bf5:	c3                   	ret    

c0100bf6 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf6:	55                   	push   %ebp
c0100bf7:	89 e5                	mov    %esp,%ebp
c0100bf9:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfc:	c7 04 24 ec a1 10 c0 	movl   $0xc010a1ec,(%esp)
c0100c03:	e8 4b f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c08:	c7 04 24 14 a2 10 c0 	movl   $0xc010a214,(%esp)
c0100c0f:	e8 3f f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c18:	74 0b                	je     c0100c25 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	89 04 24             	mov    %eax,(%esp)
c0100c20:	e8 64 18 00 00       	call   c0102489 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c25:	c7 04 24 39 a2 10 c0 	movl   $0xc010a239,(%esp)
c0100c2c:	e8 19 f6 ff ff       	call   c010024a <readline>
c0100c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c38:	74 18                	je     c0100c52 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c44:	89 04 24             	mov    %eax,(%esp)
c0100c47:	e8 f8 fe ff ff       	call   c0100b44 <runcmd>
c0100c4c:	85 c0                	test   %eax,%eax
c0100c4e:	79 02                	jns    c0100c52 <kmonitor+0x5c>
                break;
c0100c50:	eb 02                	jmp    c0100c54 <kmonitor+0x5e>
            }
        }
    }
c0100c52:	eb d1                	jmp    c0100c25 <kmonitor+0x2f>
}
c0100c54:	c9                   	leave  
c0100c55:	c3                   	ret    

c0100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c56:	55                   	push   %ebp
c0100c57:	89 e5                	mov    %esp,%ebp
c0100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c63:	eb 3f                	jmp    c0100ca4 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c68:	89 d0                	mov    %edx,%eax
c0100c6a:	01 c0                	add    %eax,%eax
c0100c6c:	01 d0                	add    %edx,%eax
c0100c6e:	c1 e0 02             	shl    $0x2,%eax
c0100c71:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c76:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c94:	c7 04 24 3d a2 10 c0 	movl   $0xc010a23d,(%esp)
c0100c9b:	e8 b3 f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca7:	83 f8 02             	cmp    $0x2,%eax
c0100caa:	76 b9                	jbe    c0100c65 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb9:	e8 c9 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc3:	c9                   	leave  
c0100cc4:	c3                   	ret    

c0100cc5 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc5:	55                   	push   %ebp
c0100cc6:	89 e5                	mov    %esp,%ebp
c0100cc8:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ccb:	e8 01 fd ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd5:	c9                   	leave  
c0100cd6:	c3                   	ret    

c0100cd7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd7:	55                   	push   %ebp
c0100cd8:	89 e5                	mov    %esp,%ebp
c0100cda:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdd:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce2:	85 c0                	test   %eax,%eax
c0100ce4:	74 02                	je     c0100ce8 <__panic+0x11>
        goto panic_dead;
c0100ce6:	eb 48                	jmp    c0100d30 <__panic+0x59>
    }
    is_panic = 1;
c0100ce8:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cef:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf2:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d06:	c7 04 24 46 a2 10 c0 	movl   $0xc010a246,(%esp)
c0100d0d:	e8 41 f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d19:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1c:	89 04 24             	mov    %eax,(%esp)
c0100d1f:	e8 fc f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d24:	c7 04 24 62 a2 10 c0 	movl   $0xc010a262,(%esp)
c0100d2b:	e8 23 f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d30:	e8 fa 11 00 00       	call   c0101f2f <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d3c:	e8 b5 fe ff ff       	call   c0100bf6 <kmonitor>
    }
c0100d41:	eb f2                	jmp    c0100d35 <__panic+0x5e>

c0100d43 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d43:	55                   	push   %ebp
c0100d44:	89 e5                	mov    %esp,%ebp
c0100d46:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d49:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5d:	c7 04 24 64 a2 10 c0 	movl   $0xc010a264,(%esp)
c0100d64:	e8 ea f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d70:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d73:	89 04 24             	mov    %eax,(%esp)
c0100d76:	e8 a5 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d7b:	c7 04 24 62 a2 10 c0 	movl   $0xc010a262,(%esp)
c0100d82:	e8 cc f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d87:	c9                   	leave  
c0100d88:	c3                   	ret    

c0100d89 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d8c:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d91:	5d                   	pop    %ebp
c0100d92:	c3                   	ret    

c0100d93 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d93:	55                   	push   %ebp
c0100d94:	89 e5                	mov    %esp,%ebp
c0100d96:	83 ec 28             	sub    $0x28,%esp
c0100d99:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dab:	ee                   	out    %al,(%dx)
c0100dac:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbe:	ee                   	out    %al,(%dx)
c0100dbf:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd2:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100dd9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ddc:	c7 04 24 82 a2 10 c0 	movl   $0xc010a282,(%esp)
c0100de3:	e8 6b f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100def:	e8 99 11 00 00       	call   c0101f8d <pic_enable>
}
c0100df4:	c9                   	leave  
c0100df5:	c3                   	ret    

c0100df6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df6:	55                   	push   %ebp
c0100df7:	89 e5                	mov    %esp,%ebp
c0100df9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfc:	9c                   	pushf  
c0100dfd:	58                   	pop    %eax
c0100dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e04:	25 00 02 00 00       	and    $0x200,%eax
c0100e09:	85 c0                	test   %eax,%eax
c0100e0b:	74 0c                	je     c0100e19 <__intr_save+0x23>
        intr_disable();
c0100e0d:	e8 1d 11 00 00       	call   c0101f2f <intr_disable>
        return 1;
c0100e12:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e17:	eb 05                	jmp    c0100e1e <__intr_save+0x28>
    }
    return 0;
c0100e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1e:	c9                   	leave  
c0100e1f:	c3                   	ret    

c0100e20 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e20:	55                   	push   %ebp
c0100e21:	89 e5                	mov    %esp,%ebp
c0100e23:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2a:	74 05                	je     c0100e31 <__intr_restore+0x11>
        intr_enable();
c0100e2c:	e8 f8 10 00 00       	call   c0101f29 <intr_enable>
    }
}
c0100e31:	c9                   	leave  
c0100e32:	c3                   	ret    

c0100e33 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e33:	55                   	push   %ebp
c0100e34:	89 e5                	mov    %esp,%ebp
c0100e36:	83 ec 10             	sub    $0x10,%esp
c0100e39:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e43:	89 c2                	mov    %eax,%edx
c0100e45:	ec                   	in     (%dx),%al
c0100e46:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e49:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e53:	89 c2                	mov    %eax,%edx
c0100e55:	ec                   	in     (%dx),%al
c0100e56:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e59:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e63:	89 c2                	mov    %eax,%edx
c0100e65:	ec                   	in     (%dx),%al
c0100e66:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e69:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e73:	89 c2                	mov    %eax,%edx
c0100e75:	ec                   	in     (%dx),%al
c0100e76:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e79:	c9                   	leave  
c0100e7a:	c3                   	ret    

c0100e7b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7b:	55                   	push   %ebp
c0100e7c:	89 e5                	mov    %esp,%ebp
c0100e7e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e81:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	0f b7 00             	movzwl (%eax),%eax
c0100e8e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9d:	0f b7 00             	movzwl (%eax),%eax
c0100ea0:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea4:	74 12                	je     c0100eb8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ead:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eb4:	b4 03 
c0100eb6:	eb 13                	jmp    c0100ecb <cga_init+0x50>
    } else {
        *cp = was;
c0100eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec2:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ec9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ecb:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed2:	0f b7 c0             	movzwl %ax,%eax
c0100ed5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100edd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee6:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100eed:	83 c0 01             	add    $0x1,%eax
c0100ef0:	0f b7 c0             	movzwl %ax,%eax
c0100ef3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100efb:	89 c2                	mov    %eax,%edx
c0100efd:	ec                   	in     (%dx),%al
c0100efe:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f01:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f05:	0f b6 c0             	movzbl %al,%eax
c0100f08:	c1 e0 08             	shl    $0x8,%eax
c0100f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f15:	0f b7 c0             	movzwl %ax,%eax
c0100f18:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f20:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f24:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f28:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f29:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f30:	83 c0 01             	add    $0x1,%eax
c0100f33:	0f b7 c0             	movzwl %ax,%eax
c0100f36:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3e:	89 c2                	mov    %eax,%edx
c0100f40:	ec                   	in     (%dx),%al
c0100f41:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f44:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f48:	0f b6 c0             	movzbl %al,%eax
c0100f4b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f51:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f59:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f5f:	c9                   	leave  
c0100f60:	c3                   	ret    

c0100f61 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f61:	55                   	push   %ebp
c0100f62:	89 e5                	mov    %esp,%ebp
c0100f64:	83 ec 48             	sub    $0x48,%esp
c0100f67:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f71:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f75:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f79:	ee                   	out    %al,(%dx)
c0100f7a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f80:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f88:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8c:	ee                   	out    %al,(%dx)
c0100f8d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f93:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f97:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f9b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9f:	ee                   	out    %al,(%dx)
c0100fa0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa6:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100faa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb2:	ee                   	out    %al,(%dx)
c0100fb3:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb9:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc5:	ee                   	out    %al,(%dx)
c0100fc6:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fcc:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd8:	ee                   	out    %al,(%dx)
c0100fd9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdf:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100feb:	ee                   	out    %al,(%dx)
c0100fec:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff2:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff6:	89 c2                	mov    %eax,%edx
c0100ff8:	ec                   	in     (%dx),%al
c0100ff9:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101000:	3c ff                	cmp    $0xff,%al
c0101002:	0f 95 c0             	setne  %al
c0101005:	0f b6 c0             	movzbl %al,%eax
c0101008:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c010100d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101013:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101017:	89 c2                	mov    %eax,%edx
c0101019:	ec                   	in     (%dx),%al
c010101a:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101d:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101023:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101027:	89 c2                	mov    %eax,%edx
c0101029:	ec                   	in     (%dx),%al
c010102a:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102d:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101032:	85 c0                	test   %eax,%eax
c0101034:	74 0c                	je     c0101042 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101036:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103d:	e8 4b 0f 00 00       	call   c0101f8d <pic_enable>
    }
}
c0101042:	c9                   	leave  
c0101043:	c3                   	ret    

c0101044 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101044:	55                   	push   %ebp
c0101045:	89 e5                	mov    %esp,%ebp
c0101047:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101051:	eb 09                	jmp    c010105c <lpt_putc_sub+0x18>
        delay();
c0101053:	e8 db fd ff ff       	call   c0100e33 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101058:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101062:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101066:	89 c2                	mov    %eax,%edx
c0101068:	ec                   	in     (%dx),%al
c0101069:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101070:	84 c0                	test   %al,%al
c0101072:	78 09                	js     c010107d <lpt_putc_sub+0x39>
c0101074:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010107b:	7e d6                	jle    c0101053 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101080:	0f b6 c0             	movzbl %al,%eax
c0101083:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101089:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101090:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101094:	ee                   	out    %al,(%dx)
c0101095:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010109b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a7:	ee                   	out    %al,(%dx)
c01010a8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ae:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ba:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010bb:	c9                   	leave  
c01010bc:	c3                   	ret    

c01010bd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010bd:	55                   	push   %ebp
c01010be:	89 e5                	mov    %esp,%ebp
c01010c0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c7:	74 0d                	je     c01010d6 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cc:	89 04 24             	mov    %eax,(%esp)
c01010cf:	e8 70 ff ff ff       	call   c0101044 <lpt_putc_sub>
c01010d4:	eb 24                	jmp    c01010fa <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010dd:	e8 62 ff ff ff       	call   c0101044 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e9:	e8 56 ff ff ff       	call   c0101044 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f5:	e8 4a ff ff ff       	call   c0101044 <lpt_putc_sub>
    }
}
c01010fa:	c9                   	leave  
c01010fb:	c3                   	ret    

c01010fc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fc:	55                   	push   %ebp
c01010fd:	89 e5                	mov    %esp,%ebp
c01010ff:	53                   	push   %ebx
c0101100:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101103:	8b 45 08             	mov    0x8(%ebp),%eax
c0101106:	b0 00                	mov    $0x0,%al
c0101108:	85 c0                	test   %eax,%eax
c010110a:	75 07                	jne    c0101113 <cga_putc+0x17>
        c |= 0x0700;
c010110c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101113:	8b 45 08             	mov    0x8(%ebp),%eax
c0101116:	0f b6 c0             	movzbl %al,%eax
c0101119:	83 f8 0a             	cmp    $0xa,%eax
c010111c:	74 4c                	je     c010116a <cga_putc+0x6e>
c010111e:	83 f8 0d             	cmp    $0xd,%eax
c0101121:	74 57                	je     c010117a <cga_putc+0x7e>
c0101123:	83 f8 08             	cmp    $0x8,%eax
c0101126:	0f 85 88 00 00 00    	jne    c01011b4 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112c:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101133:	66 85 c0             	test   %ax,%ax
c0101136:	74 30                	je     c0101168 <cga_putc+0x6c>
            crt_pos --;
c0101138:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010113f:	83 e8 01             	sub    $0x1,%eax
c0101142:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101148:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010114d:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c0101154:	0f b7 d2             	movzwl %dx,%edx
c0101157:	01 d2                	add    %edx,%edx
c0101159:	01 c2                	add    %eax,%edx
c010115b:	8b 45 08             	mov    0x8(%ebp),%eax
c010115e:	b0 00                	mov    $0x0,%al
c0101160:	83 c8 20             	or     $0x20,%eax
c0101163:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101166:	eb 72                	jmp    c01011da <cga_putc+0xde>
c0101168:	eb 70                	jmp    c01011da <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116a:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101171:	83 c0 50             	add    $0x50,%eax
c0101174:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117a:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101181:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c0101188:	0f b7 c1             	movzwl %cx,%eax
c010118b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101191:	c1 e8 10             	shr    $0x10,%eax
c0101194:	89 c2                	mov    %eax,%edx
c0101196:	66 c1 ea 06          	shr    $0x6,%dx
c010119a:	89 d0                	mov    %edx,%eax
c010119c:	c1 e0 02             	shl    $0x2,%eax
c010119f:	01 d0                	add    %edx,%eax
c01011a1:	c1 e0 04             	shl    $0x4,%eax
c01011a4:	29 c1                	sub    %eax,%ecx
c01011a6:	89 ca                	mov    %ecx,%edx
c01011a8:	89 d8                	mov    %ebx,%eax
c01011aa:	29 d0                	sub    %edx,%eax
c01011ac:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b2:	eb 26                	jmp    c01011da <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b4:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011ba:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c1:	8d 50 01             	lea    0x1(%eax),%edx
c01011c4:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011cb:	0f b7 c0             	movzwl %ax,%eax
c01011ce:	01 c0                	add    %eax,%eax
c01011d0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d6:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011da:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e1:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e5:	76 5b                	jbe    c0101242 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e7:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f2:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fe:	00 
c01011ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101203:	89 04 24             	mov    %eax,(%esp)
c0101206:	e8 23 8c 00 00       	call   c0109e2e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101212:	eb 15                	jmp    c0101229 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101214:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101219:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121c:	01 d2                	add    %edx,%edx
c010121e:	01 d0                	add    %edx,%eax
c0101220:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101225:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101229:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101230:	7e e2                	jle    c0101214 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101232:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101239:	83 e8 50             	sub    $0x50,%eax
c010123c:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101242:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101249:	0f b7 c0             	movzwl %ax,%eax
c010124c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101250:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101254:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101258:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125d:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101264:	66 c1 e8 08          	shr    $0x8,%ax
c0101268:	0f b6 c0             	movzbl %al,%eax
c010126b:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101272:	83 c2 01             	add    $0x1,%edx
c0101275:	0f b7 d2             	movzwl %dx,%edx
c0101278:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127c:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101283:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101287:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101288:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010128f:	0f b7 c0             	movzwl %ax,%eax
c0101292:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101296:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a3:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012aa:	0f b6 c0             	movzbl %al,%eax
c01012ad:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012b4:	83 c2 01             	add    $0x1,%edx
c01012b7:	0f b7 d2             	movzwl %dx,%edx
c01012ba:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012be:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c9:	ee                   	out    %al,(%dx)
}
c01012ca:	83 c4 34             	add    $0x34,%esp
c01012cd:	5b                   	pop    %ebx
c01012ce:	5d                   	pop    %ebp
c01012cf:	c3                   	ret    

c01012d0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d0:	55                   	push   %ebp
c01012d1:	89 e5                	mov    %esp,%ebp
c01012d3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012dd:	eb 09                	jmp    c01012e8 <serial_putc_sub+0x18>
        delay();
c01012df:	e8 4f fb ff ff       	call   c0100e33 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ee:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f2:	89 c2                	mov    %eax,%edx
c01012f4:	ec                   	in     (%dx),%al
c01012f5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fc:	0f b6 c0             	movzbl %al,%eax
c01012ff:	83 e0 20             	and    $0x20,%eax
c0101302:	85 c0                	test   %eax,%eax
c0101304:	75 09                	jne    c010130f <serial_putc_sub+0x3f>
c0101306:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130d:	7e d0                	jle    c01012df <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101312:	0f b6 c0             	movzbl %al,%eax
c0101315:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010131b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101322:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101326:	ee                   	out    %al,(%dx)
}
c0101327:	c9                   	leave  
c0101328:	c3                   	ret    

c0101329 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101329:	55                   	push   %ebp
c010132a:	89 e5                	mov    %esp,%ebp
c010132c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101333:	74 0d                	je     c0101342 <serial_putc+0x19>
        serial_putc_sub(c);
c0101335:	8b 45 08             	mov    0x8(%ebp),%eax
c0101338:	89 04 24             	mov    %eax,(%esp)
c010133b:	e8 90 ff ff ff       	call   c01012d0 <serial_putc_sub>
c0101340:	eb 24                	jmp    c0101366 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101342:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101349:	e8 82 ff ff ff       	call   c01012d0 <serial_putc_sub>
        serial_putc_sub(' ');
c010134e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101355:	e8 76 ff ff ff       	call   c01012d0 <serial_putc_sub>
        serial_putc_sub('\b');
c010135a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101361:	e8 6a ff ff ff       	call   c01012d0 <serial_putc_sub>
    }
}
c0101366:	c9                   	leave  
c0101367:	c3                   	ret    

c0101368 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101368:	55                   	push   %ebp
c0101369:	89 e5                	mov    %esp,%ebp
c010136b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136e:	eb 33                	jmp    c01013a3 <cons_intr+0x3b>
        if (c != 0) {
c0101370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101374:	74 2d                	je     c01013a3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101376:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c010137b:	8d 50 01             	lea    0x1(%eax),%edx
c010137e:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c0101384:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101387:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138d:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101392:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101397:	75 0a                	jne    c01013a3 <cons_intr+0x3b>
                cons.wpos = 0;
c0101399:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a0:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a6:	ff d0                	call   *%eax
c01013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013af:	75 bf                	jne    c0101370 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b1:	c9                   	leave  
c01013b2:	c3                   	ret    

c01013b3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b3:	55                   	push   %ebp
c01013b4:	89 e5                	mov    %esp,%ebp
c01013b6:	83 ec 10             	sub    $0x10,%esp
c01013b9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c3:	89 c2                	mov    %eax,%edx
c01013c5:	ec                   	in     (%dx),%al
c01013c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cd:	0f b6 c0             	movzbl %al,%eax
c01013d0:	83 e0 01             	and    $0x1,%eax
c01013d3:	85 c0                	test   %eax,%eax
c01013d5:	75 07                	jne    c01013de <serial_proc_data+0x2b>
        return -1;
c01013d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013dc:	eb 2a                	jmp    c0101408 <serial_proc_data+0x55>
c01013de:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e8:	89 c2                	mov    %eax,%edx
c01013ea:	ec                   	in     (%dx),%al
c01013eb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ee:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f2:	0f b6 c0             	movzbl %al,%eax
c01013f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fc:	75 07                	jne    c0101405 <serial_proc_data+0x52>
        c = '\b';
c01013fe:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101405:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101408:	c9                   	leave  
c0101409:	c3                   	ret    

c010140a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140a:	55                   	push   %ebp
c010140b:	89 e5                	mov    %esp,%ebp
c010140d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101410:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101415:	85 c0                	test   %eax,%eax
c0101417:	74 0c                	je     c0101425 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101419:	c7 04 24 b3 13 10 c0 	movl   $0xc01013b3,(%esp)
c0101420:	e8 43 ff ff ff       	call   c0101368 <cons_intr>
    }
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 38             	sub    $0x38,%esp
c010142d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101437:	89 c2                	mov    %eax,%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101441:	0f b6 c0             	movzbl %al,%eax
c0101444:	83 e0 01             	and    $0x1,%eax
c0101447:	85 c0                	test   %eax,%eax
c0101449:	75 0a                	jne    c0101455 <kbd_proc_data+0x2e>
        return -1;
c010144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101450:	e9 59 01 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
c0101455:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145f:	89 c2                	mov    %eax,%edx
c0101461:	ec                   	in     (%dx),%al
c0101462:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101465:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101469:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101470:	75 17                	jne    c0101489 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101472:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101477:	83 c8 40             	or     $0x40,%eax
c010147a:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c010147f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101484:	e9 25 01 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148d:	84 c0                	test   %al,%al
c010148f:	79 47                	jns    c01014d8 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101491:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101496:	83 e0 40             	and    $0x40,%eax
c0101499:	85 c0                	test   %eax,%eax
c010149b:	75 09                	jne    c01014a6 <kbd_proc_data+0x7f>
c010149d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a1:	83 e0 7f             	and    $0x7f,%eax
c01014a4:	eb 04                	jmp    c01014aa <kbd_proc_data+0x83>
c01014a6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014aa:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b1:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014b8:	83 c8 40             	or     $0x40,%eax
c01014bb:	0f b6 c0             	movzbl %al,%eax
c01014be:	f7 d0                	not    %eax
c01014c0:	89 c2                	mov    %eax,%edx
c01014c2:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014c7:	21 d0                	and    %edx,%eax
c01014c9:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014ce:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d3:	e9 d6 00 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014dd:	83 e0 40             	and    $0x40,%eax
c01014e0:	85 c0                	test   %eax,%eax
c01014e2:	74 11                	je     c01014f5 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014ed:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f0:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f9:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101500:	0f b6 d0             	movzbl %al,%edx
c0101503:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101508:	09 d0                	or     %edx,%eax
c010150a:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c010150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101513:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c010151a:	0f b6 d0             	movzbl %al,%edx
c010151d:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101522:	31 d0                	xor    %edx,%eax
c0101524:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c0101529:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010152e:	83 e0 03             	and    $0x3,%eax
c0101531:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c0101538:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153c:	01 d0                	add    %edx,%eax
c010153e:	0f b6 00             	movzbl (%eax),%eax
c0101541:	0f b6 c0             	movzbl %al,%eax
c0101544:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101547:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010154c:	83 e0 08             	and    $0x8,%eax
c010154f:	85 c0                	test   %eax,%eax
c0101551:	74 22                	je     c0101575 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101553:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101557:	7e 0c                	jle    c0101565 <kbd_proc_data+0x13e>
c0101559:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155d:	7f 06                	jg     c0101565 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101563:	eb 10                	jmp    c0101575 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101565:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101569:	7e 0a                	jle    c0101575 <kbd_proc_data+0x14e>
c010156b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156f:	7f 04                	jg     c0101575 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101571:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101575:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010157a:	f7 d0                	not    %eax
c010157c:	83 e0 06             	and    $0x6,%eax
c010157f:	85 c0                	test   %eax,%eax
c0101581:	75 28                	jne    c01015ab <kbd_proc_data+0x184>
c0101583:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158a:	75 1f                	jne    c01015ab <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158c:	c7 04 24 9d a2 10 c0 	movl   $0xc010a29d,(%esp)
c0101593:	e8 bb ed ff ff       	call   c0100353 <cprintf>
c0101598:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015aa:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ae:	c9                   	leave  
c01015af:	c3                   	ret    

c01015b0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b0:	55                   	push   %ebp
c01015b1:	89 e5                	mov    %esp,%ebp
c01015b3:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b6:	c7 04 24 27 14 10 c0 	movl   $0xc0101427,(%esp)
c01015bd:	e8 a6 fd ff ff       	call   c0101368 <cons_intr>
}
c01015c2:	c9                   	leave  
c01015c3:	c3                   	ret    

c01015c4 <kbd_init>:

static void
kbd_init(void) {
c01015c4:	55                   	push   %ebp
c01015c5:	89 e5                	mov    %esp,%ebp
c01015c7:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ca:	e8 e1 ff ff ff       	call   c01015b0 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d6:	e8 b2 09 00 00       	call   c0101f8d <pic_enable>
}
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e3:	e8 93 f8 ff ff       	call   c0100e7b <cga_init>
    serial_init();
c01015e8:	e8 74 f9 ff ff       	call   c0100f61 <serial_init>
    kbd_init();
c01015ed:	e8 d2 ff ff ff       	call   c01015c4 <kbd_init>
    if (!serial_exists) {
c01015f2:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015f7:	85 c0                	test   %eax,%eax
c01015f9:	75 0c                	jne    c0101607 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015fb:	c7 04 24 a9 a2 10 c0 	movl   $0xc010a2a9,(%esp)
c0101602:	e8 4c ed ff ff       	call   c0100353 <cprintf>
    }
}
c0101607:	c9                   	leave  
c0101608:	c3                   	ret    

c0101609 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101609:	55                   	push   %ebp
c010160a:	89 e5                	mov    %esp,%ebp
c010160c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160f:	e8 e2 f7 ff ff       	call   c0100df6 <__intr_save>
c0101614:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101617:	8b 45 08             	mov    0x8(%ebp),%eax
c010161a:	89 04 24             	mov    %eax,(%esp)
c010161d:	e8 9b fa ff ff       	call   c01010bd <lpt_putc>
        cga_putc(c);
c0101622:	8b 45 08             	mov    0x8(%ebp),%eax
c0101625:	89 04 24             	mov    %eax,(%esp)
c0101628:	e8 cf fa ff ff       	call   c01010fc <cga_putc>
        serial_putc(c);
c010162d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101630:	89 04 24             	mov    %eax,(%esp)
c0101633:	e8 f1 fc ff ff       	call   c0101329 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101638:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010163b:	89 04 24             	mov    %eax,(%esp)
c010163e:	e8 dd f7 ff ff       	call   c0100e20 <__intr_restore>
}
c0101643:	c9                   	leave  
c0101644:	c3                   	ret    

c0101645 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101645:	55                   	push   %ebp
c0101646:	89 e5                	mov    %esp,%ebp
c0101648:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010164b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101652:	e8 9f f7 ff ff       	call   c0100df6 <__intr_save>
c0101657:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165a:	e8 ab fd ff ff       	call   c010140a <serial_intr>
        kbd_intr();
c010165f:	e8 4c ff ff ff       	call   c01015b0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101664:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c010166a:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c010166f:	39 c2                	cmp    %eax,%edx
c0101671:	74 31                	je     c01016a4 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101673:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101678:	8d 50 01             	lea    0x1(%eax),%edx
c010167b:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101681:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c0101688:	0f b6 c0             	movzbl %al,%eax
c010168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168e:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101693:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101698:	75 0a                	jne    c01016a4 <cons_getc+0x5f>
                cons.rpos = 0;
c010169a:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a1:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a7:	89 04 24             	mov    %eax,(%esp)
c01016aa:	e8 71 f7 ff ff       	call   c0100e20 <__intr_restore>
    return c;
c01016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b2:	c9                   	leave  
c01016b3:	c3                   	ret    

c01016b4 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
c01016b7:	83 ec 14             	sub    $0x14,%esp
c01016ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c1:	90                   	nop
c01016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c6:	83 c0 07             	add    $0x7,%eax
c01016c9:	0f b7 c0             	movzwl %ax,%eax
c01016cc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d4:	89 c2                	mov    %eax,%edx
c01016d6:	ec                   	in     (%dx),%al
c01016d7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016da:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016de:	0f b6 c0             	movzbl %al,%eax
c01016e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e7:	25 80 00 00 00       	and    $0x80,%eax
c01016ec:	85 c0                	test   %eax,%eax
c01016ee:	75 d2                	jne    c01016c2 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f4:	74 11                	je     c0101707 <ide_wait_ready+0x53>
c01016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f9:	83 e0 21             	and    $0x21,%eax
c01016fc:	85 c0                	test   %eax,%eax
c01016fe:	74 07                	je     c0101707 <ide_wait_ready+0x53>
        return -1;
c0101700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101705:	eb 05                	jmp    c010170c <ide_wait_ready+0x58>
    }
    return 0;
c0101707:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010170c:	c9                   	leave  
c010170d:	c3                   	ret    

c010170e <ide_init>:

void
ide_init(void) {
c010170e:	55                   	push   %ebp
c010170f:	89 e5                	mov    %esp,%ebp
c0101711:	57                   	push   %edi
c0101712:	53                   	push   %ebx
c0101713:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101719:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010171f:	e9 d6 02 00 00       	jmp    c01019fa <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101724:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101728:	c1 e0 03             	shl    $0x3,%eax
c010172b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101732:	29 c2                	sub    %eax,%edx
c0101734:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010173a:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010173d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101741:	66 d1 e8             	shr    %ax
c0101744:	0f b7 c0             	movzwl %ax,%eax
c0101747:	0f b7 04 85 c8 a2 10 	movzwl -0x3fef5d38(,%eax,4),%eax
c010174e:	c0 
c010174f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101753:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101757:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010175e:	00 
c010175f:	89 04 24             	mov    %eax,(%esp)
c0101762:	e8 4d ff ff ff       	call   c01016b4 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101767:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010176b:	83 e0 01             	and    $0x1,%eax
c010176e:	c1 e0 04             	shl    $0x4,%eax
c0101771:	83 c8 e0             	or     $0xffffffe0,%eax
c0101774:	0f b6 c0             	movzbl %al,%eax
c0101777:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010177b:	83 c2 06             	add    $0x6,%edx
c010177e:	0f b7 d2             	movzwl %dx,%edx
c0101781:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101785:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101788:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010178c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101791:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101795:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010179c:	00 
c010179d:	89 04 24             	mov    %eax,(%esp)
c01017a0:	e8 0f ff ff ff       	call   c01016b4 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017a5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a9:	83 c0 07             	add    $0x7,%eax
c01017ac:	0f b7 c0             	movzwl %ax,%eax
c01017af:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b3:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017bf:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017cb:	00 
c01017cc:	89 04 24             	mov    %eax,(%esp)
c01017cf:	e8 e0 fe ff ff       	call   c01016b4 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d8:	83 c0 07             	add    $0x7,%eax
c01017db:	0f b7 c0             	movzwl %ax,%eax
c01017de:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e2:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017e6:	89 c2                	mov    %eax,%edx
c01017e8:	ec                   	in     (%dx),%al
c01017e9:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017ec:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f0:	84 c0                	test   %al,%al
c01017f2:	0f 84 f7 01 00 00    	je     c01019ef <ide_init+0x2e1>
c01017f8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101803:	00 
c0101804:	89 04 24             	mov    %eax,(%esp)
c0101807:	e8 a8 fe ff ff       	call   c01016b4 <ide_wait_ready>
c010180c:	85 c0                	test   %eax,%eax
c010180e:	0f 85 db 01 00 00    	jne    c01019ef <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101814:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101818:	c1 e0 03             	shl    $0x3,%eax
c010181b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101822:	29 c2                	sub    %eax,%edx
c0101824:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010182a:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101831:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101834:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010183a:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183d:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101844:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101847:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010184a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184d:	89 cb                	mov    %ecx,%ebx
c010184f:	89 df                	mov    %ebx,%edi
c0101851:	89 c1                	mov    %eax,%ecx
c0101853:	fc                   	cld    
c0101854:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101856:	89 c8                	mov    %ecx,%eax
c0101858:	89 fb                	mov    %edi,%ebx
c010185a:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185d:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101860:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101872:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101875:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101878:	25 00 00 00 04       	and    $0x4000000,%eax
c010187d:	85 c0                	test   %eax,%eax
c010187f:	74 0e                	je     c010188f <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101884:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010188d:	eb 09                	jmp    c0101898 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010188f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101892:	8b 40 78             	mov    0x78(%eax),%eax
c0101895:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101898:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010189c:	c1 e0 03             	shl    $0x3,%eax
c010189f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018a6:	29 c2                	sub    %eax,%edx
c01018a8:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b1:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b8:	c1 e0 03             	shl    $0x3,%eax
c01018bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c2:	29 c2                	sub    %eax,%edx
c01018c4:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018cd:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d3:	83 c0 62             	add    $0x62,%eax
c01018d6:	0f b7 00             	movzwl (%eax),%eax
c01018d9:	0f b7 c0             	movzwl %ax,%eax
c01018dc:	25 00 02 00 00       	and    $0x200,%eax
c01018e1:	85 c0                	test   %eax,%eax
c01018e3:	75 24                	jne    c0101909 <ide_init+0x1fb>
c01018e5:	c7 44 24 0c d0 a2 10 	movl   $0xc010a2d0,0xc(%esp)
c01018ec:	c0 
c01018ed:	c7 44 24 08 13 a3 10 	movl   $0xc010a313,0x8(%esp)
c01018f4:	c0 
c01018f5:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018fc:	00 
c01018fd:	c7 04 24 28 a3 10 c0 	movl   $0xc010a328,(%esp)
c0101904:	e8 ce f3 ff ff       	call   c0100cd7 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101909:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010190d:	c1 e0 03             	shl    $0x3,%eax
c0101910:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101917:	29 c2                	sub    %eax,%edx
c0101919:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010191f:	83 c0 0c             	add    $0xc,%eax
c0101922:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101928:	83 c0 36             	add    $0x36,%eax
c010192b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010192e:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101935:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010193c:	eb 34                	jmp    c0101972 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010193e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101941:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101944:	01 c2                	add    %eax,%edx
c0101946:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101949:	8d 48 01             	lea    0x1(%eax),%ecx
c010194c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010194f:	01 c8                	add    %ecx,%eax
c0101951:	0f b6 00             	movzbl (%eax),%eax
c0101954:	88 02                	mov    %al,(%edx)
c0101956:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101959:	8d 50 01             	lea    0x1(%eax),%edx
c010195c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010195f:	01 c2                	add    %eax,%edx
c0101961:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101964:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101967:	01 c8                	add    %ecx,%eax
c0101969:	0f b6 00             	movzbl (%eax),%eax
c010196c:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010196e:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101975:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101978:	72 c4                	jb     c010193e <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010197a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101980:	01 d0                	add    %edx,%eax
c0101982:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101985:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101988:	8d 50 ff             	lea    -0x1(%eax),%edx
c010198b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010198e:	85 c0                	test   %eax,%eax
c0101990:	74 0f                	je     c01019a1 <ide_init+0x293>
c0101992:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101995:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101998:	01 d0                	add    %edx,%eax
c010199a:	0f b6 00             	movzbl (%eax),%eax
c010199d:	3c 20                	cmp    $0x20,%al
c010199f:	74 d9                	je     c010197a <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019a5:	c1 e0 03             	shl    $0x3,%eax
c01019a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019af:	29 c2                	sub    %eax,%edx
c01019b1:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019b7:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019be:	c1 e0 03             	shl    $0x3,%eax
c01019c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c8:	29 c2                	sub    %eax,%edx
c01019ca:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d0:	8b 50 08             	mov    0x8(%eax),%edx
c01019d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e3:	c7 04 24 3a a3 10 c0 	movl   $0xc010a33a,(%esp)
c01019ea:	e8 64 e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ef:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f3:	83 c0 01             	add    $0x1,%eax
c01019f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019fa:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019ff:	0f 86 1f fd ff ff    	jbe    c0101724 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a05:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a0c:	e8 7c 05 00 00       	call   c0101f8d <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a11:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a18:	e8 70 05 00 00       	call   c0101f8d <pic_enable>
}
c0101a1d:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a23:	5b                   	pop    %ebx
c0101a24:	5f                   	pop    %edi
c0101a25:	5d                   	pop    %ebp
c0101a26:	c3                   	ret    

c0101a27 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a27:	55                   	push   %ebp
c0101a28:	89 e5                	mov    %esp,%ebp
c0101a2a:	83 ec 04             	sub    $0x4,%esp
c0101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a30:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a34:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a39:	77 24                	ja     c0101a5f <ide_device_valid+0x38>
c0101a3b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3f:	c1 e0 03             	shl    $0x3,%eax
c0101a42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a49:	29 c2                	sub    %eax,%edx
c0101a4b:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a51:	0f b6 00             	movzbl (%eax),%eax
c0101a54:	84 c0                	test   %al,%al
c0101a56:	74 07                	je     c0101a5f <ide_device_valid+0x38>
c0101a58:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a5d:	eb 05                	jmp    c0101a64 <ide_device_valid+0x3d>
c0101a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a64:	c9                   	leave  
c0101a65:	c3                   	ret    

c0101a66 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a66:	55                   	push   %ebp
c0101a67:	89 e5                	mov    %esp,%ebp
c0101a69:	83 ec 08             	sub    $0x8,%esp
c0101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a73:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a77:	89 04 24             	mov    %eax,(%esp)
c0101a7a:	e8 a8 ff ff ff       	call   c0101a27 <ide_device_valid>
c0101a7f:	85 c0                	test   %eax,%eax
c0101a81:	74 1b                	je     c0101a9e <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a83:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a87:	c1 e0 03             	shl    $0x3,%eax
c0101a8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a91:	29 c2                	sub    %eax,%edx
c0101a93:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a99:	8b 40 08             	mov    0x8(%eax),%eax
c0101a9c:	eb 05                	jmp    c0101aa3 <ide_device_size+0x3d>
    }
    return 0;
c0101a9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa3:	c9                   	leave  
c0101aa4:	c3                   	ret    

c0101aa5 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aa5:	55                   	push   %ebp
c0101aa6:	89 e5                	mov    %esp,%ebp
c0101aa8:	57                   	push   %edi
c0101aa9:	53                   	push   %ebx
c0101aaa:	83 ec 50             	sub    $0x50,%esp
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101abb:	77 24                	ja     c0101ae1 <ide_read_secs+0x3c>
c0101abd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac2:	77 1d                	ja     c0101ae1 <ide_read_secs+0x3c>
c0101ac4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac8:	c1 e0 03             	shl    $0x3,%eax
c0101acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad2:	29 c2                	sub    %eax,%edx
c0101ad4:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101ada:	0f b6 00             	movzbl (%eax),%eax
c0101add:	84 c0                	test   %al,%al
c0101adf:	75 24                	jne    c0101b05 <ide_read_secs+0x60>
c0101ae1:	c7 44 24 0c 58 a3 10 	movl   $0xc010a358,0xc(%esp)
c0101ae8:	c0 
c0101ae9:	c7 44 24 08 13 a3 10 	movl   $0xc010a313,0x8(%esp)
c0101af0:	c0 
c0101af1:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af8:	00 
c0101af9:	c7 04 24 28 a3 10 c0 	movl   $0xc010a328,(%esp)
c0101b00:	e8 d2 f1 ff ff       	call   c0100cd7 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b05:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b0c:	77 0f                	ja     c0101b1d <ide_read_secs+0x78>
c0101b0e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b11:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b14:	01 d0                	add    %edx,%eax
c0101b16:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b1b:	76 24                	jbe    c0101b41 <ide_read_secs+0x9c>
c0101b1d:	c7 44 24 0c 80 a3 10 	movl   $0xc010a380,0xc(%esp)
c0101b24:	c0 
c0101b25:	c7 44 24 08 13 a3 10 	movl   $0xc010a313,0x8(%esp)
c0101b2c:	c0 
c0101b2d:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b34:	00 
c0101b35:	c7 04 24 28 a3 10 c0 	movl   $0xc010a328,(%esp)
c0101b3c:	e8 96 f1 ff ff       	call   c0100cd7 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b41:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b45:	66 d1 e8             	shr    %ax
c0101b48:	0f b7 c0             	movzwl %ax,%eax
c0101b4b:	0f b7 04 85 c8 a2 10 	movzwl -0x3fef5d38(,%eax,4),%eax
c0101b52:	c0 
c0101b53:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b57:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b5b:	66 d1 e8             	shr    %ax
c0101b5e:	0f b7 c0             	movzwl %ax,%eax
c0101b61:	0f b7 04 85 ca a2 10 	movzwl -0x3fef5d36(,%eax,4),%eax
c0101b68:	c0 
c0101b69:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b78:	00 
c0101b79:	89 04 24             	mov    %eax,(%esp)
c0101b7c:	e8 33 fb ff ff       	call   c01016b4 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b81:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b85:	83 c0 02             	add    $0x2,%eax
c0101b88:	0f b7 c0             	movzwl %ax,%eax
c0101b8b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b8f:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b93:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b97:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b9b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b9c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b9f:	0f b6 c0             	movzbl %al,%eax
c0101ba2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ba6:	83 c2 02             	add    $0x2,%edx
c0101ba9:	0f b7 d2             	movzwl %dx,%edx
c0101bac:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bb7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bbb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbf:	0f b6 c0             	movzbl %al,%eax
c0101bc2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc6:	83 c2 03             	add    $0x3,%edx
c0101bc9:	0f b7 d2             	movzwl %dx,%edx
c0101bcc:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd0:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bd7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bdb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bdf:	c1 e8 08             	shr    $0x8,%eax
c0101be2:	0f b6 c0             	movzbl %al,%eax
c0101be5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be9:	83 c2 04             	add    $0x4,%edx
c0101bec:	0f b7 d2             	movzwl %dx,%edx
c0101bef:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf3:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bf6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bfa:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bfe:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c02:	c1 e8 10             	shr    $0x10,%eax
c0101c05:	0f b6 c0             	movzbl %al,%eax
c0101c08:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c0c:	83 c2 05             	add    $0x5,%edx
c0101c0f:	0f b7 d2             	movzwl %dx,%edx
c0101c12:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c16:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c19:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c1d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c21:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c22:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c26:	83 e0 01             	and    $0x1,%eax
c0101c29:	c1 e0 04             	shl    $0x4,%eax
c0101c2c:	89 c2                	mov    %eax,%edx
c0101c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c31:	c1 e8 18             	shr    $0x18,%eax
c0101c34:	83 e0 0f             	and    $0xf,%eax
c0101c37:	09 d0                	or     %edx,%eax
c0101c39:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c3c:	0f b6 c0             	movzbl %al,%eax
c0101c3f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c43:	83 c2 06             	add    $0x6,%edx
c0101c46:	0f b7 d2             	movzwl %dx,%edx
c0101c49:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c4d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c50:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c54:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c58:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c59:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c5d:	83 c0 07             	add    $0x7,%eax
c0101c60:	0f b7 c0             	movzwl %ax,%eax
c0101c63:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c67:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c6b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c6f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c73:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c7b:	eb 5a                	jmp    c0101cd7 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c7d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c88:	00 
c0101c89:	89 04 24             	mov    %eax,(%esp)
c0101c8c:	e8 23 fa ff ff       	call   c01016b4 <ide_wait_ready>
c0101c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c98:	74 02                	je     c0101c9c <ide_read_secs+0x1f7>
            goto out;
c0101c9a:	eb 41                	jmp    c0101cdd <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c9c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ca6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cb6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb9:	89 cb                	mov    %ecx,%ebx
c0101cbb:	89 df                	mov    %ebx,%edi
c0101cbd:	89 c1                	mov    %eax,%ecx
c0101cbf:	fc                   	cld    
c0101cc0:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc2:	89 c8                	mov    %ecx,%eax
c0101cc4:	89 fb                	mov    %edi,%ebx
c0101cc6:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101ccc:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd0:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cd7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cdb:	75 a0                	jne    c0101c7d <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce0:	83 c4 50             	add    $0x50,%esp
c0101ce3:	5b                   	pop    %ebx
c0101ce4:	5f                   	pop    %edi
c0101ce5:	5d                   	pop    %ebp
c0101ce6:	c3                   	ret    

c0101ce7 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ce7:	55                   	push   %ebp
c0101ce8:	89 e5                	mov    %esp,%ebp
c0101cea:	56                   	push   %esi
c0101ceb:	53                   	push   %ebx
c0101cec:	83 ec 50             	sub    $0x50,%esp
c0101cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf2:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cf6:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cfd:	77 24                	ja     c0101d23 <ide_write_secs+0x3c>
c0101cff:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d04:	77 1d                	ja     c0101d23 <ide_write_secs+0x3c>
c0101d06:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d0a:	c1 e0 03             	shl    $0x3,%eax
c0101d0d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d14:	29 c2                	sub    %eax,%edx
c0101d16:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d1c:	0f b6 00             	movzbl (%eax),%eax
c0101d1f:	84 c0                	test   %al,%al
c0101d21:	75 24                	jne    c0101d47 <ide_write_secs+0x60>
c0101d23:	c7 44 24 0c 58 a3 10 	movl   $0xc010a358,0xc(%esp)
c0101d2a:	c0 
c0101d2b:	c7 44 24 08 13 a3 10 	movl   $0xc010a313,0x8(%esp)
c0101d32:	c0 
c0101d33:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d3a:	00 
c0101d3b:	c7 04 24 28 a3 10 c0 	movl   $0xc010a328,(%esp)
c0101d42:	e8 90 ef ff ff       	call   c0100cd7 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d47:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d4e:	77 0f                	ja     c0101d5f <ide_write_secs+0x78>
c0101d50:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d53:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d56:	01 d0                	add    %edx,%eax
c0101d58:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d5d:	76 24                	jbe    c0101d83 <ide_write_secs+0x9c>
c0101d5f:	c7 44 24 0c 80 a3 10 	movl   $0xc010a380,0xc(%esp)
c0101d66:	c0 
c0101d67:	c7 44 24 08 13 a3 10 	movl   $0xc010a313,0x8(%esp)
c0101d6e:	c0 
c0101d6f:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d76:	00 
c0101d77:	c7 04 24 28 a3 10 c0 	movl   $0xc010a328,(%esp)
c0101d7e:	e8 54 ef ff ff       	call   c0100cd7 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d83:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d87:	66 d1 e8             	shr    %ax
c0101d8a:	0f b7 c0             	movzwl %ax,%eax
c0101d8d:	0f b7 04 85 c8 a2 10 	movzwl -0x3fef5d38(,%eax,4),%eax
c0101d94:	c0 
c0101d95:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d99:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d9d:	66 d1 e8             	shr    %ax
c0101da0:	0f b7 c0             	movzwl %ax,%eax
c0101da3:	0f b7 04 85 ca a2 10 	movzwl -0x3fef5d36(,%eax,4),%eax
c0101daa:	c0 
c0101dab:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101daf:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dba:	00 
c0101dbb:	89 04 24             	mov    %eax,(%esp)
c0101dbe:	e8 f1 f8 ff ff       	call   c01016b4 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dc7:	83 c0 02             	add    $0x2,%eax
c0101dca:	0f b7 c0             	movzwl %ax,%eax
c0101dcd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd1:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dd5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ddd:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101dde:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de1:	0f b6 c0             	movzbl %al,%eax
c0101de4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de8:	83 c2 02             	add    $0x2,%edx
c0101deb:	0f b7 d2             	movzwl %dx,%edx
c0101dee:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df2:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101df5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101dfd:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e01:	0f b6 c0             	movzbl %al,%eax
c0101e04:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e08:	83 c2 03             	add    $0x3,%edx
c0101e0b:	0f b7 d2             	movzwl %dx,%edx
c0101e0e:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e12:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e15:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e19:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e1d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e21:	c1 e8 08             	shr    $0x8,%eax
c0101e24:	0f b6 c0             	movzbl %al,%eax
c0101e27:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e2b:	83 c2 04             	add    $0x4,%edx
c0101e2e:	0f b7 d2             	movzwl %dx,%edx
c0101e31:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e35:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e38:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e3c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e40:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e44:	c1 e8 10             	shr    $0x10,%eax
c0101e47:	0f b6 c0             	movzbl %al,%eax
c0101e4a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4e:	83 c2 05             	add    $0x5,%edx
c0101e51:	0f b7 d2             	movzwl %dx,%edx
c0101e54:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e58:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e5b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e5f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e63:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e64:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e68:	83 e0 01             	and    $0x1,%eax
c0101e6b:	c1 e0 04             	shl    $0x4,%eax
c0101e6e:	89 c2                	mov    %eax,%edx
c0101e70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e73:	c1 e8 18             	shr    $0x18,%eax
c0101e76:	83 e0 0f             	and    $0xf,%eax
c0101e79:	09 d0                	or     %edx,%eax
c0101e7b:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e7e:	0f b6 c0             	movzbl %al,%eax
c0101e81:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e85:	83 c2 06             	add    $0x6,%edx
c0101e88:	0f b7 d2             	movzwl %dx,%edx
c0101e8b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e8f:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e92:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e96:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e9a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e9b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e9f:	83 c0 07             	add    $0x7,%eax
c0101ea2:	0f b7 c0             	movzwl %ax,%eax
c0101ea5:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea9:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ead:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eb5:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ebd:	eb 5a                	jmp    c0101f19 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ebf:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101eca:	00 
c0101ecb:	89 04 24             	mov    %eax,(%esp)
c0101ece:	e8 e1 f7 ff ff       	call   c01016b4 <ide_wait_ready>
c0101ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101eda:	74 02                	je     c0101ede <ide_write_secs+0x1f7>
            goto out;
c0101edc:	eb 41                	jmp    c0101f1f <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ede:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ee5:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee8:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101eeb:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ef5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101efb:	89 cb                	mov    %ecx,%ebx
c0101efd:	89 de                	mov    %ebx,%esi
c0101eff:	89 c1                	mov    %eax,%ecx
c0101f01:	fc                   	cld    
c0101f02:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f04:	89 c8                	mov    %ecx,%eax
c0101f06:	89 f3                	mov    %esi,%ebx
c0101f08:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f0e:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f12:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f19:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f1d:	75 a0                	jne    c0101ebf <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f22:	83 c4 50             	add    $0x50,%esp
c0101f25:	5b                   	pop    %ebx
c0101f26:	5e                   	pop    %esi
c0101f27:	5d                   	pop    %ebp
c0101f28:	c3                   	ret    

c0101f29 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f29:	55                   	push   %ebp
c0101f2a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f2c:	fb                   	sti    
    sti();
}
c0101f2d:	5d                   	pop    %ebp
c0101f2e:	c3                   	ret    

c0101f2f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f2f:	55                   	push   %ebp
c0101f30:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f32:	fa                   	cli    
    cli();
}
c0101f33:	5d                   	pop    %ebp
c0101f34:	c3                   	ret    

c0101f35 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f35:	55                   	push   %ebp
c0101f36:	89 e5                	mov    %esp,%ebp
c0101f38:	83 ec 14             	sub    $0x14,%esp
c0101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f42:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f46:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f4c:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f51:	85 c0                	test   %eax,%eax
c0101f53:	74 36                	je     c0101f8b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f55:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f59:	0f b6 c0             	movzbl %al,%eax
c0101f5c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f62:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f65:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f69:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f6d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f6e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f72:	66 c1 e8 08          	shr    $0x8,%ax
c0101f76:	0f b6 c0             	movzbl %al,%eax
c0101f79:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f7f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f82:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f86:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f8a:	ee                   	out    %al,(%dx)
    }
}
c0101f8b:	c9                   	leave  
c0101f8c:	c3                   	ret    

c0101f8d <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f8d:	55                   	push   %ebp
c0101f8e:	89 e5                	mov    %esp,%ebp
c0101f90:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f96:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f9b:	89 c1                	mov    %eax,%ecx
c0101f9d:	d3 e2                	shl    %cl,%edx
c0101f9f:	89 d0                	mov    %edx,%eax
c0101fa1:	f7 d0                	not    %eax
c0101fa3:	89 c2                	mov    %eax,%edx
c0101fa5:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fac:	21 d0                	and    %edx,%eax
c0101fae:	0f b7 c0             	movzwl %ax,%eax
c0101fb1:	89 04 24             	mov    %eax,(%esp)
c0101fb4:	e8 7c ff ff ff       	call   c0101f35 <pic_setmask>
}
c0101fb9:	c9                   	leave  
c0101fba:	c3                   	ret    

c0101fbb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fbb:	55                   	push   %ebp
c0101fbc:	89 e5                	mov    %esp,%ebp
c0101fbe:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc1:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fc8:	00 00 00 
c0101fcb:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd1:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fd5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fdd:	ee                   	out    %al,(%dx)
c0101fde:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff0:	ee                   	out    %al,(%dx)
c0101ff1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ff7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ffb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101fff:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102003:	ee                   	out    %al,(%dx)
c0102004:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010200a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010200e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102012:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102016:	ee                   	out    %al,(%dx)
c0102017:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010201d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102021:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102025:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102029:	ee                   	out    %al,(%dx)
c010202a:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102030:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102034:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102038:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010203c:	ee                   	out    %al,(%dx)
c010203d:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102043:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102047:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010204b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010204f:	ee                   	out    %al,(%dx)
c0102050:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102056:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010205a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010205e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102062:	ee                   	out    %al,(%dx)
c0102063:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102069:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010206d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102071:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102075:	ee                   	out    %al,(%dx)
c0102076:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010207c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102080:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102084:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102088:	ee                   	out    %al,(%dx)
c0102089:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010208f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102093:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102097:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010209b:	ee                   	out    %al,(%dx)
c010209c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a2:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020a6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020aa:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020ae:	ee                   	out    %al,(%dx)
c01020af:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020b5:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b9:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020bd:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c1:	ee                   	out    %al,(%dx)
c01020c2:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c8:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020cc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d4:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020d5:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020dc:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e0:	74 12                	je     c01020f4 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e2:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e9:	0f b7 c0             	movzwl %ax,%eax
c01020ec:	89 04 24             	mov    %eax,(%esp)
c01020ef:	e8 41 fe ff ff       	call   c0101f35 <pic_setmask>
    }
}
c01020f4:	c9                   	leave  
c01020f5:	c3                   	ret    

c01020f6 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020f6:	55                   	push   %ebp
c01020f7:	89 e5                	mov    %esp,%ebp
c01020f9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020fc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102103:	00 
c0102104:	c7 04 24 c0 a3 10 c0 	movl   $0xc010a3c0,(%esp)
c010210b:	e8 43 e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102110:	c7 04 24 ca a3 10 c0 	movl   $0xc010a3ca,(%esp)
c0102117:	e8 37 e2 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c010211c:	c7 44 24 08 d8 a3 10 	movl   $0xc010a3d8,0x8(%esp)
c0102123:	c0 
c0102124:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010212b:	00 
c010212c:	c7 04 24 ee a3 10 c0 	movl   $0xc010a3ee,(%esp)
c0102133:	e8 9f eb ff ff       	call   c0100cd7 <__panic>

c0102138 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102138:	55                   	push   %ebp
c0102139:	89 e5                	mov    %esp,%ebp
c010213b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c010213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102145:	e9 5c 02 00 00       	jmp    c01023a6 <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
c010214a:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c0102151:	0f 85 c1 00 00 00    	jne    c0102218 <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
c0102157:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215a:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102161:	89 c2                	mov    %eax,%edx
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c010216d:	c0 
c010216e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102171:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c0102178:	c0 08 00 
c010217b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217e:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102185:	c0 
c0102186:	83 e2 e0             	and    $0xffffffe0,%edx
c0102189:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010219a:	c0 
c010219b:	83 e2 1f             	and    $0x1f,%edx
c010219e:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 ca 0f             	or     $0xf,%edx
c01021b3:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 e2 ef             	and    $0xffffffef,%edx
c01021c8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021d9:	c0 
c01021da:	83 ca 60             	or     $0x60,%edx
c01021dd:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e7:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021ee:	c0 
c01021ef:	83 ca 80             	or     $0xffffff80,%edx
c01021f2:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021fc:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102203:	c1 e8 10             	shr    $0x10,%eax
c0102206:	89 c2                	mov    %eax,%edx
c0102208:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220b:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c0102212:	c0 
c0102213:	e9 8a 01 00 00       	jmp    c01023a2 <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
c0102218:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c010221c:	0f 8f c1 00 00 00    	jg     c01022e3 <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102222:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102225:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c010222c:	89 c2                	mov    %eax,%edx
c010222e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102231:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102238:	c0 
c0102239:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223c:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c0102243:	c0 08 00 
c0102246:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102249:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102250:	c0 
c0102251:	83 e2 e0             	and    $0xffffffe0,%edx
c0102254:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c010225b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010225e:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102265:	c0 
c0102266:	83 e2 1f             	and    $0x1f,%edx
c0102269:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102270:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102273:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010227a:	c0 
c010227b:	83 ca 0f             	or     $0xf,%edx
c010227e:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102285:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102288:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010228f:	c0 
c0102290:	83 e2 ef             	and    $0xffffffef,%edx
c0102293:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c010229a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229d:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01022a4:	c0 
c01022a5:	83 e2 9f             	and    $0xffffff9f,%edx
c01022a8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01022af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b2:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01022b9:	c0 
c01022ba:	83 ca 80             	or     $0xffffff80,%edx
c01022bd:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01022c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022c7:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01022ce:	c1 e8 10             	shr    $0x10,%eax
c01022d1:	89 c2                	mov    %eax,%edx
c01022d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022d6:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c01022dd:	c0 
c01022de:	e9 bf 00 00 00       	jmp    c01023a2 <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01022e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022e6:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01022ed:	89 c2                	mov    %eax,%edx
c01022ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f2:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c01022f9:	c0 
c01022fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022fd:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c0102304:	c0 08 00 
c0102307:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010230a:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102311:	c0 
c0102312:	83 e2 e0             	and    $0xffffffe0,%edx
c0102315:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c010231c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010231f:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102326:	c0 
c0102327:	83 e2 1f             	and    $0x1f,%edx
c010232a:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102331:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102334:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010233b:	c0 
c010233c:	83 e2 f0             	and    $0xfffffff0,%edx
c010233f:	83 ca 0e             	or     $0xe,%edx
c0102342:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102349:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010234c:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102353:	c0 
c0102354:	83 e2 ef             	and    $0xffffffef,%edx
c0102357:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c010235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102361:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102368:	c0 
c0102369:	83 e2 9f             	and    $0xffffff9f,%edx
c010236c:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102373:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102376:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010237d:	c0 
c010237e:	83 ca 80             	or     $0xffffff80,%edx
c0102381:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102388:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010238b:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102392:	c1 e8 10             	shr    $0x10,%eax
c0102395:	89 c2                	mov    %eax,%edx
c0102397:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010239a:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c01023a1:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c01023a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01023a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023a9:	3d ff 00 00 00       	cmp    $0xff,%eax
c01023ae:	0f 86 96 fd ff ff    	jbe    c010214a <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01023b4:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c01023b9:	66 a3 e8 55 12 c0    	mov    %ax,0xc01255e8
c01023bf:	66 c7 05 ea 55 12 c0 	movw   $0x8,0xc01255ea
c01023c6:	08 00 
c01023c8:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c01023cf:	83 e0 e0             	and    $0xffffffe0,%eax
c01023d2:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c01023d7:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c01023de:	83 e0 1f             	and    $0x1f,%eax
c01023e1:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c01023e6:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c01023ed:	83 e0 f0             	and    $0xfffffff0,%eax
c01023f0:	83 c8 0e             	or     $0xe,%eax
c01023f3:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c01023f8:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c01023ff:	83 e0 ef             	and    $0xffffffef,%eax
c0102402:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c0102407:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c010240e:	83 c8 60             	or     $0x60,%eax
c0102411:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c0102416:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c010241d:	83 c8 80             	or     $0xffffff80,%eax
c0102420:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c0102425:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c010242a:	c1 e8 10             	shr    $0x10,%eax
c010242d:	66 a3 ee 55 12 c0    	mov    %ax,0xc01255ee
c0102433:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010243a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010243d:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0102440:	c9                   	leave  
c0102441:	c3                   	ret    

c0102442 <trapname>:

static const char *
trapname(int trapno) {
c0102442:	55                   	push   %ebp
c0102443:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102445:	8b 45 08             	mov    0x8(%ebp),%eax
c0102448:	83 f8 13             	cmp    $0x13,%eax
c010244b:	77 0c                	ja     c0102459 <trapname+0x17>
        return excnames[trapno];
c010244d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102450:	8b 04 85 c0 a7 10 c0 	mov    -0x3fef5840(,%eax,4),%eax
c0102457:	eb 18                	jmp    c0102471 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102459:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010245d:	7e 0d                	jle    c010246c <trapname+0x2a>
c010245f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102463:	7f 07                	jg     c010246c <trapname+0x2a>
        return "Hardware Interrupt";
c0102465:	b8 ff a3 10 c0       	mov    $0xc010a3ff,%eax
c010246a:	eb 05                	jmp    c0102471 <trapname+0x2f>
    }
    return "(unknown trap)";
c010246c:	b8 12 a4 10 c0       	mov    $0xc010a412,%eax
}
c0102471:	5d                   	pop    %ebp
c0102472:	c3                   	ret    

c0102473 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102473:	55                   	push   %ebp
c0102474:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102476:	8b 45 08             	mov    0x8(%ebp),%eax
c0102479:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010247d:	66 83 f8 08          	cmp    $0x8,%ax
c0102481:	0f 94 c0             	sete   %al
c0102484:	0f b6 c0             	movzbl %al,%eax
}
c0102487:	5d                   	pop    %ebp
c0102488:	c3                   	ret    

c0102489 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102489:	55                   	push   %ebp
c010248a:	89 e5                	mov    %esp,%ebp
c010248c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010248f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102496:	c7 04 24 53 a4 10 c0 	movl   $0xc010a453,(%esp)
c010249d:	e8 b1 de ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c01024a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a5:	89 04 24             	mov    %eax,(%esp)
c01024a8:	e8 a1 01 00 00       	call   c010264e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01024ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01024b4:	0f b7 c0             	movzwl %ax,%eax
c01024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bb:	c7 04 24 64 a4 10 c0 	movl   $0xc010a464,(%esp)
c01024c2:	e8 8c de ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01024c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ca:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01024ce:	0f b7 c0             	movzwl %ax,%eax
c01024d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d5:	c7 04 24 77 a4 10 c0 	movl   $0xc010a477,(%esp)
c01024dc:	e8 72 de ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01024e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01024e8:	0f b7 c0             	movzwl %ax,%eax
c01024eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ef:	c7 04 24 8a a4 10 c0 	movl   $0xc010a48a,(%esp)
c01024f6:	e8 58 de ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01024fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fe:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102502:	0f b7 c0             	movzwl %ax,%eax
c0102505:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102509:	c7 04 24 9d a4 10 c0 	movl   $0xc010a49d,(%esp)
c0102510:	e8 3e de ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102515:	8b 45 08             	mov    0x8(%ebp),%eax
c0102518:	8b 40 30             	mov    0x30(%eax),%eax
c010251b:	89 04 24             	mov    %eax,(%esp)
c010251e:	e8 1f ff ff ff       	call   c0102442 <trapname>
c0102523:	8b 55 08             	mov    0x8(%ebp),%edx
c0102526:	8b 52 30             	mov    0x30(%edx),%edx
c0102529:	89 44 24 08          	mov    %eax,0x8(%esp)
c010252d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102531:	c7 04 24 b0 a4 10 c0 	movl   $0xc010a4b0,(%esp)
c0102538:	e8 16 de ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010253d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102540:	8b 40 34             	mov    0x34(%eax),%eax
c0102543:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102547:	c7 04 24 c2 a4 10 c0 	movl   $0xc010a4c2,(%esp)
c010254e:	e8 00 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102553:	8b 45 08             	mov    0x8(%ebp),%eax
c0102556:	8b 40 38             	mov    0x38(%eax),%eax
c0102559:	89 44 24 04          	mov    %eax,0x4(%esp)
c010255d:	c7 04 24 d1 a4 10 c0 	movl   $0xc010a4d1,(%esp)
c0102564:	e8 ea dd ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102569:	8b 45 08             	mov    0x8(%ebp),%eax
c010256c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102570:	0f b7 c0             	movzwl %ax,%eax
c0102573:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102577:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010257e:	e8 d0 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102583:	8b 45 08             	mov    0x8(%ebp),%eax
c0102586:	8b 40 40             	mov    0x40(%eax),%eax
c0102589:	89 44 24 04          	mov    %eax,0x4(%esp)
c010258d:	c7 04 24 f3 a4 10 c0 	movl   $0xc010a4f3,(%esp)
c0102594:	e8 ba dd ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01025a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01025a7:	eb 3e                	jmp    c01025e7 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01025a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ac:	8b 50 40             	mov    0x40(%eax),%edx
c01025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025b2:	21 d0                	and    %edx,%eax
c01025b4:	85 c0                	test   %eax,%eax
c01025b6:	74 28                	je     c01025e0 <print_trapframe+0x157>
c01025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025bb:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01025c2:	85 c0                	test   %eax,%eax
c01025c4:	74 1a                	je     c01025e0 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025c9:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01025d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025d4:	c7 04 24 02 a5 10 c0 	movl   $0xc010a502,(%esp)
c01025db:	e8 73 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01025e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01025e4:	d1 65 f0             	shll   -0x10(%ebp)
c01025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025ea:	83 f8 17             	cmp    $0x17,%eax
c01025ed:	76 ba                	jbe    c01025a9 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01025ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f2:	8b 40 40             	mov    0x40(%eax),%eax
c01025f5:	25 00 30 00 00       	and    $0x3000,%eax
c01025fa:	c1 e8 0c             	shr    $0xc,%eax
c01025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102601:	c7 04 24 06 a5 10 c0 	movl   $0xc010a506,(%esp)
c0102608:	e8 46 dd ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c010260d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102610:	89 04 24             	mov    %eax,(%esp)
c0102613:	e8 5b fe ff ff       	call   c0102473 <trap_in_kernel>
c0102618:	85 c0                	test   %eax,%eax
c010261a:	75 30                	jne    c010264c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010261c:	8b 45 08             	mov    0x8(%ebp),%eax
c010261f:	8b 40 44             	mov    0x44(%eax),%eax
c0102622:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102626:	c7 04 24 0f a5 10 c0 	movl   $0xc010a50f,(%esp)
c010262d:	e8 21 dd ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102632:	8b 45 08             	mov    0x8(%ebp),%eax
c0102635:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102639:	0f b7 c0             	movzwl %ax,%eax
c010263c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102640:	c7 04 24 1e a5 10 c0 	movl   $0xc010a51e,(%esp)
c0102647:	e8 07 dd ff ff       	call   c0100353 <cprintf>
    }
}
c010264c:	c9                   	leave  
c010264d:	c3                   	ret    

c010264e <print_regs>:

void
print_regs(struct pushregs *regs) {
c010264e:	55                   	push   %ebp
c010264f:	89 e5                	mov    %esp,%ebp
c0102651:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102654:	8b 45 08             	mov    0x8(%ebp),%eax
c0102657:	8b 00                	mov    (%eax),%eax
c0102659:	89 44 24 04          	mov    %eax,0x4(%esp)
c010265d:	c7 04 24 31 a5 10 c0 	movl   $0xc010a531,(%esp)
c0102664:	e8 ea dc ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102669:	8b 45 08             	mov    0x8(%ebp),%eax
c010266c:	8b 40 04             	mov    0x4(%eax),%eax
c010266f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102673:	c7 04 24 40 a5 10 c0 	movl   $0xc010a540,(%esp)
c010267a:	e8 d4 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010267f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102682:	8b 40 08             	mov    0x8(%eax),%eax
c0102685:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102689:	c7 04 24 4f a5 10 c0 	movl   $0xc010a54f,(%esp)
c0102690:	e8 be dc ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102695:	8b 45 08             	mov    0x8(%ebp),%eax
c0102698:	8b 40 0c             	mov    0xc(%eax),%eax
c010269b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010269f:	c7 04 24 5e a5 10 c0 	movl   $0xc010a55e,(%esp)
c01026a6:	e8 a8 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01026ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ae:	8b 40 10             	mov    0x10(%eax),%eax
c01026b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026b5:	c7 04 24 6d a5 10 c0 	movl   $0xc010a56d,(%esp)
c01026bc:	e8 92 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01026c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01026c4:	8b 40 14             	mov    0x14(%eax),%eax
c01026c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026cb:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01026d2:	e8 7c dc ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01026d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01026da:	8b 40 18             	mov    0x18(%eax),%eax
c01026dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026e1:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01026e8:	e8 66 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01026ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01026f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026f7:	c7 04 24 9a a5 10 c0 	movl   $0xc010a59a,(%esp)
c01026fe:	e8 50 dc ff ff       	call   c0100353 <cprintf>
}
c0102703:	c9                   	leave  
c0102704:	c3                   	ret    

c0102705 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102705:	55                   	push   %ebp
c0102706:	89 e5                	mov    %esp,%ebp
c0102708:	53                   	push   %ebx
c0102709:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010270c:	8b 45 08             	mov    0x8(%ebp),%eax
c010270f:	8b 40 34             	mov    0x34(%eax),%eax
c0102712:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102715:	85 c0                	test   %eax,%eax
c0102717:	74 07                	je     c0102720 <print_pgfault+0x1b>
c0102719:	b9 a9 a5 10 c0       	mov    $0xc010a5a9,%ecx
c010271e:	eb 05                	jmp    c0102725 <print_pgfault+0x20>
c0102720:	b9 ba a5 10 c0       	mov    $0xc010a5ba,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102725:	8b 45 08             	mov    0x8(%ebp),%eax
c0102728:	8b 40 34             	mov    0x34(%eax),%eax
c010272b:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010272e:	85 c0                	test   %eax,%eax
c0102730:	74 07                	je     c0102739 <print_pgfault+0x34>
c0102732:	ba 57 00 00 00       	mov    $0x57,%edx
c0102737:	eb 05                	jmp    c010273e <print_pgfault+0x39>
c0102739:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010273e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102741:	8b 40 34             	mov    0x34(%eax),%eax
c0102744:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102747:	85 c0                	test   %eax,%eax
c0102749:	74 07                	je     c0102752 <print_pgfault+0x4d>
c010274b:	b8 55 00 00 00       	mov    $0x55,%eax
c0102750:	eb 05                	jmp    c0102757 <print_pgfault+0x52>
c0102752:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102757:	0f 20 d3             	mov    %cr2,%ebx
c010275a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010275d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102760:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102764:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102768:	89 44 24 08          	mov    %eax,0x8(%esp)
c010276c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102770:	c7 04 24 c8 a5 10 c0 	movl   $0xc010a5c8,(%esp)
c0102777:	e8 d7 db ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010277c:	83 c4 34             	add    $0x34,%esp
c010277f:	5b                   	pop    %ebx
c0102780:	5d                   	pop    %ebp
c0102781:	c3                   	ret    

c0102782 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102782:	55                   	push   %ebp
c0102783:	89 e5                	mov    %esp,%ebp
c0102785:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102788:	8b 45 08             	mov    0x8(%ebp),%eax
c010278b:	89 04 24             	mov    %eax,(%esp)
c010278e:	e8 72 ff ff ff       	call   c0102705 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102793:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0102798:	85 c0                	test   %eax,%eax
c010279a:	74 28                	je     c01027c4 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010279c:	0f 20 d0             	mov    %cr2,%eax
c010279f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01027a5:	89 c1                	mov    %eax,%ecx
c01027a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027aa:	8b 50 34             	mov    0x34(%eax),%edx
c01027ad:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01027b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01027b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01027ba:	89 04 24             	mov    %eax,(%esp)
c01027bd:	e8 96 5b 00 00       	call   c0108358 <do_pgfault>
c01027c2:	eb 1c                	jmp    c01027e0 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01027c4:	c7 44 24 08 eb a5 10 	movl   $0xc010a5eb,0x8(%esp)
c01027cb:	c0 
c01027cc:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c01027d3:	00 
c01027d4:	c7 04 24 ee a3 10 c0 	movl   $0xc010a3ee,(%esp)
c01027db:	e8 f7 e4 ff ff       	call   c0100cd7 <__panic>
}
c01027e0:	c9                   	leave  
c01027e1:	c3                   	ret    

c01027e2 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01027e2:	55                   	push   %ebp
c01027e3:	89 e5                	mov    %esp,%ebp
c01027e5:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01027e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01027eb:	8b 40 30             	mov    0x30(%eax),%eax
c01027ee:	83 f8 24             	cmp    $0x24,%eax
c01027f1:	0f 84 c2 00 00 00    	je     c01028b9 <trap_dispatch+0xd7>
c01027f7:	83 f8 24             	cmp    $0x24,%eax
c01027fa:	77 18                	ja     c0102814 <trap_dispatch+0x32>
c01027fc:	83 f8 20             	cmp    $0x20,%eax
c01027ff:	74 7d                	je     c010287e <trap_dispatch+0x9c>
c0102801:	83 f8 21             	cmp    $0x21,%eax
c0102804:	0f 84 d5 00 00 00    	je     c01028df <trap_dispatch+0xfd>
c010280a:	83 f8 0e             	cmp    $0xe,%eax
c010280d:	74 28                	je     c0102837 <trap_dispatch+0x55>
c010280f:	e9 0d 01 00 00       	jmp    c0102921 <trap_dispatch+0x13f>
c0102814:	83 f8 2e             	cmp    $0x2e,%eax
c0102817:	0f 82 04 01 00 00    	jb     c0102921 <trap_dispatch+0x13f>
c010281d:	83 f8 2f             	cmp    $0x2f,%eax
c0102820:	0f 86 33 01 00 00    	jbe    c0102959 <trap_dispatch+0x177>
c0102826:	83 e8 78             	sub    $0x78,%eax
c0102829:	83 f8 01             	cmp    $0x1,%eax
c010282c:	0f 87 ef 00 00 00    	ja     c0102921 <trap_dispatch+0x13f>
c0102832:	e9 ce 00 00 00       	jmp    c0102905 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102837:	8b 45 08             	mov    0x8(%ebp),%eax
c010283a:	89 04 24             	mov    %eax,(%esp)
c010283d:	e8 40 ff ff ff       	call   c0102782 <pgfault_handler>
c0102842:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102849:	74 2e                	je     c0102879 <trap_dispatch+0x97>
            print_trapframe(tf);
c010284b:	8b 45 08             	mov    0x8(%ebp),%eax
c010284e:	89 04 24             	mov    %eax,(%esp)
c0102851:	e8 33 fc ff ff       	call   c0102489 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102859:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010285d:	c7 44 24 08 02 a6 10 	movl   $0xc010a602,0x8(%esp)
c0102864:	c0 
c0102865:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010286c:	00 
c010286d:	c7 04 24 ee a3 10 c0 	movl   $0xc010a3ee,(%esp)
c0102874:	e8 5e e4 ff ff       	call   c0100cd7 <__panic>
        }
        break;
c0102879:	e9 dc 00 00 00       	jmp    c010295a <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks++;
c010287e:	a1 14 7b 12 c0       	mov    0xc0127b14,%eax
c0102883:	83 c0 01             	add    $0x1,%eax
c0102886:	a3 14 7b 12 c0       	mov    %eax,0xc0127b14
		if(ticks % TICK_NUM == 0)
c010288b:	8b 0d 14 7b 12 c0    	mov    0xc0127b14,%ecx
c0102891:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102896:	89 c8                	mov    %ecx,%eax
c0102898:	f7 e2                	mul    %edx
c010289a:	89 d0                	mov    %edx,%eax
c010289c:	c1 e8 05             	shr    $0x5,%eax
c010289f:	6b c0 64             	imul   $0x64,%eax,%eax
c01028a2:	29 c1                	sub    %eax,%ecx
c01028a4:	89 c8                	mov    %ecx,%eax
c01028a6:	85 c0                	test   %eax,%eax
c01028a8:	75 0a                	jne    c01028b4 <trap_dispatch+0xd2>
		{
			print_ticks();
c01028aa:	e8 47 f8 ff ff       	call   c01020f6 <print_ticks>
		}
        break;
c01028af:	e9 a6 00 00 00       	jmp    c010295a <trap_dispatch+0x178>
c01028b4:	e9 a1 00 00 00       	jmp    c010295a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01028b9:	e8 87 ed ff ff       	call   c0101645 <cons_getc>
c01028be:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01028c1:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028c5:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028c9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028d1:	c7 04 24 1d a6 10 c0 	movl   $0xc010a61d,(%esp)
c01028d8:	e8 76 da ff ff       	call   c0100353 <cprintf>
        break;
c01028dd:	eb 7b                	jmp    c010295a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01028df:	e8 61 ed ff ff       	call   c0101645 <cons_getc>
c01028e4:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01028e7:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028eb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028f7:	c7 04 24 2f a6 10 c0 	movl   $0xc010a62f,(%esp)
c01028fe:	e8 50 da ff ff       	call   c0100353 <cprintf>
        break;
c0102903:	eb 55                	jmp    c010295a <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102905:	c7 44 24 08 3e a6 10 	movl   $0xc010a63e,0x8(%esp)
c010290c:	c0 
c010290d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0102914:	00 
c0102915:	c7 04 24 ee a3 10 c0 	movl   $0xc010a3ee,(%esp)
c010291c:	e8 b6 e3 ff ff       	call   c0100cd7 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102921:	8b 45 08             	mov    0x8(%ebp),%eax
c0102924:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102928:	0f b7 c0             	movzwl %ax,%eax
c010292b:	83 e0 03             	and    $0x3,%eax
c010292e:	85 c0                	test   %eax,%eax
c0102930:	75 28                	jne    c010295a <trap_dispatch+0x178>
            print_trapframe(tf);
c0102932:	8b 45 08             	mov    0x8(%ebp),%eax
c0102935:	89 04 24             	mov    %eax,(%esp)
c0102938:	e8 4c fb ff ff       	call   c0102489 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010293d:	c7 44 24 08 4e a6 10 	movl   $0xc010a64e,0x8(%esp)
c0102944:	c0 
c0102945:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010294c:	00 
c010294d:	c7 04 24 ee a3 10 c0 	movl   $0xc010a3ee,(%esp)
c0102954:	e8 7e e3 ff ff       	call   c0100cd7 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102959:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010295a:	c9                   	leave  
c010295b:	c3                   	ret    

c010295c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010295c:	55                   	push   %ebp
c010295d:	89 e5                	mov    %esp,%ebp
c010295f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102962:	8b 45 08             	mov    0x8(%ebp),%eax
c0102965:	89 04 24             	mov    %eax,(%esp)
c0102968:	e8 75 fe ff ff       	call   c01027e2 <trap_dispatch>
}
c010296d:	c9                   	leave  
c010296e:	c3                   	ret    

c010296f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010296f:	1e                   	push   %ds
    pushl %es
c0102970:	06                   	push   %es
    pushl %fs
c0102971:	0f a0                	push   %fs
    pushl %gs
c0102973:	0f a8                	push   %gs
    pushal
c0102975:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102976:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010297b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010297d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010297f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102980:	e8 d7 ff ff ff       	call   c010295c <trap>

    # pop the pushed stack pointer
    popl %esp
c0102985:	5c                   	pop    %esp

c0102986 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102986:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102987:	0f a9                	pop    %gs
    popl %fs
c0102989:	0f a1                	pop    %fs
    popl %es
c010298b:	07                   	pop    %es
    popl %ds
c010298c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010298d:	83 c4 08             	add    $0x8,%esp
    iret
c0102990:	cf                   	iret   

c0102991 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102991:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102995:	e9 ec ff ff ff       	jmp    c0102986 <__trapret>

c010299a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $0
c010299c:	6a 00                	push   $0x0
  jmp __alltraps
c010299e:	e9 cc ff ff ff       	jmp    c010296f <__alltraps>

c01029a3 <vector1>:
.globl vector1
vector1:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $1
c01029a5:	6a 01                	push   $0x1
  jmp __alltraps
c01029a7:	e9 c3 ff ff ff       	jmp    c010296f <__alltraps>

c01029ac <vector2>:
.globl vector2
vector2:
  pushl $0
c01029ac:	6a 00                	push   $0x0
  pushl $2
c01029ae:	6a 02                	push   $0x2
  jmp __alltraps
c01029b0:	e9 ba ff ff ff       	jmp    c010296f <__alltraps>

c01029b5 <vector3>:
.globl vector3
vector3:
  pushl $0
c01029b5:	6a 00                	push   $0x0
  pushl $3
c01029b7:	6a 03                	push   $0x3
  jmp __alltraps
c01029b9:	e9 b1 ff ff ff       	jmp    c010296f <__alltraps>

c01029be <vector4>:
.globl vector4
vector4:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $4
c01029c0:	6a 04                	push   $0x4
  jmp __alltraps
c01029c2:	e9 a8 ff ff ff       	jmp    c010296f <__alltraps>

c01029c7 <vector5>:
.globl vector5
vector5:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $5
c01029c9:	6a 05                	push   $0x5
  jmp __alltraps
c01029cb:	e9 9f ff ff ff       	jmp    c010296f <__alltraps>

c01029d0 <vector6>:
.globl vector6
vector6:
  pushl $0
c01029d0:	6a 00                	push   $0x0
  pushl $6
c01029d2:	6a 06                	push   $0x6
  jmp __alltraps
c01029d4:	e9 96 ff ff ff       	jmp    c010296f <__alltraps>

c01029d9 <vector7>:
.globl vector7
vector7:
  pushl $0
c01029d9:	6a 00                	push   $0x0
  pushl $7
c01029db:	6a 07                	push   $0x7
  jmp __alltraps
c01029dd:	e9 8d ff ff ff       	jmp    c010296f <__alltraps>

c01029e2 <vector8>:
.globl vector8
vector8:
  pushl $8
c01029e2:	6a 08                	push   $0x8
  jmp __alltraps
c01029e4:	e9 86 ff ff ff       	jmp    c010296f <__alltraps>

c01029e9 <vector9>:
.globl vector9
vector9:
  pushl $9
c01029e9:	6a 09                	push   $0x9
  jmp __alltraps
c01029eb:	e9 7f ff ff ff       	jmp    c010296f <__alltraps>

c01029f0 <vector10>:
.globl vector10
vector10:
  pushl $10
c01029f0:	6a 0a                	push   $0xa
  jmp __alltraps
c01029f2:	e9 78 ff ff ff       	jmp    c010296f <__alltraps>

c01029f7 <vector11>:
.globl vector11
vector11:
  pushl $11
c01029f7:	6a 0b                	push   $0xb
  jmp __alltraps
c01029f9:	e9 71 ff ff ff       	jmp    c010296f <__alltraps>

c01029fe <vector12>:
.globl vector12
vector12:
  pushl $12
c01029fe:	6a 0c                	push   $0xc
  jmp __alltraps
c0102a00:	e9 6a ff ff ff       	jmp    c010296f <__alltraps>

c0102a05 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102a05:	6a 0d                	push   $0xd
  jmp __alltraps
c0102a07:	e9 63 ff ff ff       	jmp    c010296f <__alltraps>

c0102a0c <vector14>:
.globl vector14
vector14:
  pushl $14
c0102a0c:	6a 0e                	push   $0xe
  jmp __alltraps
c0102a0e:	e9 5c ff ff ff       	jmp    c010296f <__alltraps>

c0102a13 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102a13:	6a 00                	push   $0x0
  pushl $15
c0102a15:	6a 0f                	push   $0xf
  jmp __alltraps
c0102a17:	e9 53 ff ff ff       	jmp    c010296f <__alltraps>

c0102a1c <vector16>:
.globl vector16
vector16:
  pushl $0
c0102a1c:	6a 00                	push   $0x0
  pushl $16
c0102a1e:	6a 10                	push   $0x10
  jmp __alltraps
c0102a20:	e9 4a ff ff ff       	jmp    c010296f <__alltraps>

c0102a25 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102a25:	6a 11                	push   $0x11
  jmp __alltraps
c0102a27:	e9 43 ff ff ff       	jmp    c010296f <__alltraps>

c0102a2c <vector18>:
.globl vector18
vector18:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $18
c0102a2e:	6a 12                	push   $0x12
  jmp __alltraps
c0102a30:	e9 3a ff ff ff       	jmp    c010296f <__alltraps>

c0102a35 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $19
c0102a37:	6a 13                	push   $0x13
  jmp __alltraps
c0102a39:	e9 31 ff ff ff       	jmp    c010296f <__alltraps>

c0102a3e <vector20>:
.globl vector20
vector20:
  pushl $0
c0102a3e:	6a 00                	push   $0x0
  pushl $20
c0102a40:	6a 14                	push   $0x14
  jmp __alltraps
c0102a42:	e9 28 ff ff ff       	jmp    c010296f <__alltraps>

c0102a47 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102a47:	6a 00                	push   $0x0
  pushl $21
c0102a49:	6a 15                	push   $0x15
  jmp __alltraps
c0102a4b:	e9 1f ff ff ff       	jmp    c010296f <__alltraps>

c0102a50 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102a50:	6a 00                	push   $0x0
  pushl $22
c0102a52:	6a 16                	push   $0x16
  jmp __alltraps
c0102a54:	e9 16 ff ff ff       	jmp    c010296f <__alltraps>

c0102a59 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $23
c0102a5b:	6a 17                	push   $0x17
  jmp __alltraps
c0102a5d:	e9 0d ff ff ff       	jmp    c010296f <__alltraps>

c0102a62 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102a62:	6a 00                	push   $0x0
  pushl $24
c0102a64:	6a 18                	push   $0x18
  jmp __alltraps
c0102a66:	e9 04 ff ff ff       	jmp    c010296f <__alltraps>

c0102a6b <vector25>:
.globl vector25
vector25:
  pushl $0
c0102a6b:	6a 00                	push   $0x0
  pushl $25
c0102a6d:	6a 19                	push   $0x19
  jmp __alltraps
c0102a6f:	e9 fb fe ff ff       	jmp    c010296f <__alltraps>

c0102a74 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102a74:	6a 00                	push   $0x0
  pushl $26
c0102a76:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102a78:	e9 f2 fe ff ff       	jmp    c010296f <__alltraps>

c0102a7d <vector27>:
.globl vector27
vector27:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $27
c0102a7f:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102a81:	e9 e9 fe ff ff       	jmp    c010296f <__alltraps>

c0102a86 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102a86:	6a 00                	push   $0x0
  pushl $28
c0102a88:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102a8a:	e9 e0 fe ff ff       	jmp    c010296f <__alltraps>

c0102a8f <vector29>:
.globl vector29
vector29:
  pushl $0
c0102a8f:	6a 00                	push   $0x0
  pushl $29
c0102a91:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102a93:	e9 d7 fe ff ff       	jmp    c010296f <__alltraps>

c0102a98 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102a98:	6a 00                	push   $0x0
  pushl $30
c0102a9a:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102a9c:	e9 ce fe ff ff       	jmp    c010296f <__alltraps>

c0102aa1 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $31
c0102aa3:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102aa5:	e9 c5 fe ff ff       	jmp    c010296f <__alltraps>

c0102aaa <vector32>:
.globl vector32
vector32:
  pushl $0
c0102aaa:	6a 00                	push   $0x0
  pushl $32
c0102aac:	6a 20                	push   $0x20
  jmp __alltraps
c0102aae:	e9 bc fe ff ff       	jmp    c010296f <__alltraps>

c0102ab3 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102ab3:	6a 00                	push   $0x0
  pushl $33
c0102ab5:	6a 21                	push   $0x21
  jmp __alltraps
c0102ab7:	e9 b3 fe ff ff       	jmp    c010296f <__alltraps>

c0102abc <vector34>:
.globl vector34
vector34:
  pushl $0
c0102abc:	6a 00                	push   $0x0
  pushl $34
c0102abe:	6a 22                	push   $0x22
  jmp __alltraps
c0102ac0:	e9 aa fe ff ff       	jmp    c010296f <__alltraps>

c0102ac5 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $35
c0102ac7:	6a 23                	push   $0x23
  jmp __alltraps
c0102ac9:	e9 a1 fe ff ff       	jmp    c010296f <__alltraps>

c0102ace <vector36>:
.globl vector36
vector36:
  pushl $0
c0102ace:	6a 00                	push   $0x0
  pushl $36
c0102ad0:	6a 24                	push   $0x24
  jmp __alltraps
c0102ad2:	e9 98 fe ff ff       	jmp    c010296f <__alltraps>

c0102ad7 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102ad7:	6a 00                	push   $0x0
  pushl $37
c0102ad9:	6a 25                	push   $0x25
  jmp __alltraps
c0102adb:	e9 8f fe ff ff       	jmp    c010296f <__alltraps>

c0102ae0 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102ae0:	6a 00                	push   $0x0
  pushl $38
c0102ae2:	6a 26                	push   $0x26
  jmp __alltraps
c0102ae4:	e9 86 fe ff ff       	jmp    c010296f <__alltraps>

c0102ae9 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $39
c0102aeb:	6a 27                	push   $0x27
  jmp __alltraps
c0102aed:	e9 7d fe ff ff       	jmp    c010296f <__alltraps>

c0102af2 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102af2:	6a 00                	push   $0x0
  pushl $40
c0102af4:	6a 28                	push   $0x28
  jmp __alltraps
c0102af6:	e9 74 fe ff ff       	jmp    c010296f <__alltraps>

c0102afb <vector41>:
.globl vector41
vector41:
  pushl $0
c0102afb:	6a 00                	push   $0x0
  pushl $41
c0102afd:	6a 29                	push   $0x29
  jmp __alltraps
c0102aff:	e9 6b fe ff ff       	jmp    c010296f <__alltraps>

c0102b04 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102b04:	6a 00                	push   $0x0
  pushl $42
c0102b06:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102b08:	e9 62 fe ff ff       	jmp    c010296f <__alltraps>

c0102b0d <vector43>:
.globl vector43
vector43:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $43
c0102b0f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102b11:	e9 59 fe ff ff       	jmp    c010296f <__alltraps>

c0102b16 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102b16:	6a 00                	push   $0x0
  pushl $44
c0102b18:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102b1a:	e9 50 fe ff ff       	jmp    c010296f <__alltraps>

c0102b1f <vector45>:
.globl vector45
vector45:
  pushl $0
c0102b1f:	6a 00                	push   $0x0
  pushl $45
c0102b21:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102b23:	e9 47 fe ff ff       	jmp    c010296f <__alltraps>

c0102b28 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102b28:	6a 00                	push   $0x0
  pushl $46
c0102b2a:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102b2c:	e9 3e fe ff ff       	jmp    c010296f <__alltraps>

c0102b31 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $47
c0102b33:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102b35:	e9 35 fe ff ff       	jmp    c010296f <__alltraps>

c0102b3a <vector48>:
.globl vector48
vector48:
  pushl $0
c0102b3a:	6a 00                	push   $0x0
  pushl $48
c0102b3c:	6a 30                	push   $0x30
  jmp __alltraps
c0102b3e:	e9 2c fe ff ff       	jmp    c010296f <__alltraps>

c0102b43 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102b43:	6a 00                	push   $0x0
  pushl $49
c0102b45:	6a 31                	push   $0x31
  jmp __alltraps
c0102b47:	e9 23 fe ff ff       	jmp    c010296f <__alltraps>

c0102b4c <vector50>:
.globl vector50
vector50:
  pushl $0
c0102b4c:	6a 00                	push   $0x0
  pushl $50
c0102b4e:	6a 32                	push   $0x32
  jmp __alltraps
c0102b50:	e9 1a fe ff ff       	jmp    c010296f <__alltraps>

c0102b55 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $51
c0102b57:	6a 33                	push   $0x33
  jmp __alltraps
c0102b59:	e9 11 fe ff ff       	jmp    c010296f <__alltraps>

c0102b5e <vector52>:
.globl vector52
vector52:
  pushl $0
c0102b5e:	6a 00                	push   $0x0
  pushl $52
c0102b60:	6a 34                	push   $0x34
  jmp __alltraps
c0102b62:	e9 08 fe ff ff       	jmp    c010296f <__alltraps>

c0102b67 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102b67:	6a 00                	push   $0x0
  pushl $53
c0102b69:	6a 35                	push   $0x35
  jmp __alltraps
c0102b6b:	e9 ff fd ff ff       	jmp    c010296f <__alltraps>

c0102b70 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102b70:	6a 00                	push   $0x0
  pushl $54
c0102b72:	6a 36                	push   $0x36
  jmp __alltraps
c0102b74:	e9 f6 fd ff ff       	jmp    c010296f <__alltraps>

c0102b79 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $55
c0102b7b:	6a 37                	push   $0x37
  jmp __alltraps
c0102b7d:	e9 ed fd ff ff       	jmp    c010296f <__alltraps>

c0102b82 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102b82:	6a 00                	push   $0x0
  pushl $56
c0102b84:	6a 38                	push   $0x38
  jmp __alltraps
c0102b86:	e9 e4 fd ff ff       	jmp    c010296f <__alltraps>

c0102b8b <vector57>:
.globl vector57
vector57:
  pushl $0
c0102b8b:	6a 00                	push   $0x0
  pushl $57
c0102b8d:	6a 39                	push   $0x39
  jmp __alltraps
c0102b8f:	e9 db fd ff ff       	jmp    c010296f <__alltraps>

c0102b94 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102b94:	6a 00                	push   $0x0
  pushl $58
c0102b96:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102b98:	e9 d2 fd ff ff       	jmp    c010296f <__alltraps>

c0102b9d <vector59>:
.globl vector59
vector59:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $59
c0102b9f:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102ba1:	e9 c9 fd ff ff       	jmp    c010296f <__alltraps>

c0102ba6 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102ba6:	6a 00                	push   $0x0
  pushl $60
c0102ba8:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102baa:	e9 c0 fd ff ff       	jmp    c010296f <__alltraps>

c0102baf <vector61>:
.globl vector61
vector61:
  pushl $0
c0102baf:	6a 00                	push   $0x0
  pushl $61
c0102bb1:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102bb3:	e9 b7 fd ff ff       	jmp    c010296f <__alltraps>

c0102bb8 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102bb8:	6a 00                	push   $0x0
  pushl $62
c0102bba:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102bbc:	e9 ae fd ff ff       	jmp    c010296f <__alltraps>

c0102bc1 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $63
c0102bc3:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102bc5:	e9 a5 fd ff ff       	jmp    c010296f <__alltraps>

c0102bca <vector64>:
.globl vector64
vector64:
  pushl $0
c0102bca:	6a 00                	push   $0x0
  pushl $64
c0102bcc:	6a 40                	push   $0x40
  jmp __alltraps
c0102bce:	e9 9c fd ff ff       	jmp    c010296f <__alltraps>

c0102bd3 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102bd3:	6a 00                	push   $0x0
  pushl $65
c0102bd5:	6a 41                	push   $0x41
  jmp __alltraps
c0102bd7:	e9 93 fd ff ff       	jmp    c010296f <__alltraps>

c0102bdc <vector66>:
.globl vector66
vector66:
  pushl $0
c0102bdc:	6a 00                	push   $0x0
  pushl $66
c0102bde:	6a 42                	push   $0x42
  jmp __alltraps
c0102be0:	e9 8a fd ff ff       	jmp    c010296f <__alltraps>

c0102be5 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102be5:	6a 00                	push   $0x0
  pushl $67
c0102be7:	6a 43                	push   $0x43
  jmp __alltraps
c0102be9:	e9 81 fd ff ff       	jmp    c010296f <__alltraps>

c0102bee <vector68>:
.globl vector68
vector68:
  pushl $0
c0102bee:	6a 00                	push   $0x0
  pushl $68
c0102bf0:	6a 44                	push   $0x44
  jmp __alltraps
c0102bf2:	e9 78 fd ff ff       	jmp    c010296f <__alltraps>

c0102bf7 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102bf7:	6a 00                	push   $0x0
  pushl $69
c0102bf9:	6a 45                	push   $0x45
  jmp __alltraps
c0102bfb:	e9 6f fd ff ff       	jmp    c010296f <__alltraps>

c0102c00 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102c00:	6a 00                	push   $0x0
  pushl $70
c0102c02:	6a 46                	push   $0x46
  jmp __alltraps
c0102c04:	e9 66 fd ff ff       	jmp    c010296f <__alltraps>

c0102c09 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102c09:	6a 00                	push   $0x0
  pushl $71
c0102c0b:	6a 47                	push   $0x47
  jmp __alltraps
c0102c0d:	e9 5d fd ff ff       	jmp    c010296f <__alltraps>

c0102c12 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102c12:	6a 00                	push   $0x0
  pushl $72
c0102c14:	6a 48                	push   $0x48
  jmp __alltraps
c0102c16:	e9 54 fd ff ff       	jmp    c010296f <__alltraps>

c0102c1b <vector73>:
.globl vector73
vector73:
  pushl $0
c0102c1b:	6a 00                	push   $0x0
  pushl $73
c0102c1d:	6a 49                	push   $0x49
  jmp __alltraps
c0102c1f:	e9 4b fd ff ff       	jmp    c010296f <__alltraps>

c0102c24 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102c24:	6a 00                	push   $0x0
  pushl $74
c0102c26:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102c28:	e9 42 fd ff ff       	jmp    c010296f <__alltraps>

c0102c2d <vector75>:
.globl vector75
vector75:
  pushl $0
c0102c2d:	6a 00                	push   $0x0
  pushl $75
c0102c2f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102c31:	e9 39 fd ff ff       	jmp    c010296f <__alltraps>

c0102c36 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102c36:	6a 00                	push   $0x0
  pushl $76
c0102c38:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102c3a:	e9 30 fd ff ff       	jmp    c010296f <__alltraps>

c0102c3f <vector77>:
.globl vector77
vector77:
  pushl $0
c0102c3f:	6a 00                	push   $0x0
  pushl $77
c0102c41:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102c43:	e9 27 fd ff ff       	jmp    c010296f <__alltraps>

c0102c48 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102c48:	6a 00                	push   $0x0
  pushl $78
c0102c4a:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102c4c:	e9 1e fd ff ff       	jmp    c010296f <__alltraps>

c0102c51 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $79
c0102c53:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102c55:	e9 15 fd ff ff       	jmp    c010296f <__alltraps>

c0102c5a <vector80>:
.globl vector80
vector80:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $80
c0102c5c:	6a 50                	push   $0x50
  jmp __alltraps
c0102c5e:	e9 0c fd ff ff       	jmp    c010296f <__alltraps>

c0102c63 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102c63:	6a 00                	push   $0x0
  pushl $81
c0102c65:	6a 51                	push   $0x51
  jmp __alltraps
c0102c67:	e9 03 fd ff ff       	jmp    c010296f <__alltraps>

c0102c6c <vector82>:
.globl vector82
vector82:
  pushl $0
c0102c6c:	6a 00                	push   $0x0
  pushl $82
c0102c6e:	6a 52                	push   $0x52
  jmp __alltraps
c0102c70:	e9 fa fc ff ff       	jmp    c010296f <__alltraps>

c0102c75 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $83
c0102c77:	6a 53                	push   $0x53
  jmp __alltraps
c0102c79:	e9 f1 fc ff ff       	jmp    c010296f <__alltraps>

c0102c7e <vector84>:
.globl vector84
vector84:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $84
c0102c80:	6a 54                	push   $0x54
  jmp __alltraps
c0102c82:	e9 e8 fc ff ff       	jmp    c010296f <__alltraps>

c0102c87 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102c87:	6a 00                	push   $0x0
  pushl $85
c0102c89:	6a 55                	push   $0x55
  jmp __alltraps
c0102c8b:	e9 df fc ff ff       	jmp    c010296f <__alltraps>

c0102c90 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102c90:	6a 00                	push   $0x0
  pushl $86
c0102c92:	6a 56                	push   $0x56
  jmp __alltraps
c0102c94:	e9 d6 fc ff ff       	jmp    c010296f <__alltraps>

c0102c99 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102c99:	6a 00                	push   $0x0
  pushl $87
c0102c9b:	6a 57                	push   $0x57
  jmp __alltraps
c0102c9d:	e9 cd fc ff ff       	jmp    c010296f <__alltraps>

c0102ca2 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $88
c0102ca4:	6a 58                	push   $0x58
  jmp __alltraps
c0102ca6:	e9 c4 fc ff ff       	jmp    c010296f <__alltraps>

c0102cab <vector89>:
.globl vector89
vector89:
  pushl $0
c0102cab:	6a 00                	push   $0x0
  pushl $89
c0102cad:	6a 59                	push   $0x59
  jmp __alltraps
c0102caf:	e9 bb fc ff ff       	jmp    c010296f <__alltraps>

c0102cb4 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102cb4:	6a 00                	push   $0x0
  pushl $90
c0102cb6:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102cb8:	e9 b2 fc ff ff       	jmp    c010296f <__alltraps>

c0102cbd <vector91>:
.globl vector91
vector91:
  pushl $0
c0102cbd:	6a 00                	push   $0x0
  pushl $91
c0102cbf:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102cc1:	e9 a9 fc ff ff       	jmp    c010296f <__alltraps>

c0102cc6 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $92
c0102cc8:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102cca:	e9 a0 fc ff ff       	jmp    c010296f <__alltraps>

c0102ccf <vector93>:
.globl vector93
vector93:
  pushl $0
c0102ccf:	6a 00                	push   $0x0
  pushl $93
c0102cd1:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102cd3:	e9 97 fc ff ff       	jmp    c010296f <__alltraps>

c0102cd8 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102cd8:	6a 00                	push   $0x0
  pushl $94
c0102cda:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102cdc:	e9 8e fc ff ff       	jmp    c010296f <__alltraps>

c0102ce1 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102ce1:	6a 00                	push   $0x0
  pushl $95
c0102ce3:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102ce5:	e9 85 fc ff ff       	jmp    c010296f <__alltraps>

c0102cea <vector96>:
.globl vector96
vector96:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $96
c0102cec:	6a 60                	push   $0x60
  jmp __alltraps
c0102cee:	e9 7c fc ff ff       	jmp    c010296f <__alltraps>

c0102cf3 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102cf3:	6a 00                	push   $0x0
  pushl $97
c0102cf5:	6a 61                	push   $0x61
  jmp __alltraps
c0102cf7:	e9 73 fc ff ff       	jmp    c010296f <__alltraps>

c0102cfc <vector98>:
.globl vector98
vector98:
  pushl $0
c0102cfc:	6a 00                	push   $0x0
  pushl $98
c0102cfe:	6a 62                	push   $0x62
  jmp __alltraps
c0102d00:	e9 6a fc ff ff       	jmp    c010296f <__alltraps>

c0102d05 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102d05:	6a 00                	push   $0x0
  pushl $99
c0102d07:	6a 63                	push   $0x63
  jmp __alltraps
c0102d09:	e9 61 fc ff ff       	jmp    c010296f <__alltraps>

c0102d0e <vector100>:
.globl vector100
vector100:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $100
c0102d10:	6a 64                	push   $0x64
  jmp __alltraps
c0102d12:	e9 58 fc ff ff       	jmp    c010296f <__alltraps>

c0102d17 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102d17:	6a 00                	push   $0x0
  pushl $101
c0102d19:	6a 65                	push   $0x65
  jmp __alltraps
c0102d1b:	e9 4f fc ff ff       	jmp    c010296f <__alltraps>

c0102d20 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102d20:	6a 00                	push   $0x0
  pushl $102
c0102d22:	6a 66                	push   $0x66
  jmp __alltraps
c0102d24:	e9 46 fc ff ff       	jmp    c010296f <__alltraps>

c0102d29 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102d29:	6a 00                	push   $0x0
  pushl $103
c0102d2b:	6a 67                	push   $0x67
  jmp __alltraps
c0102d2d:	e9 3d fc ff ff       	jmp    c010296f <__alltraps>

c0102d32 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $104
c0102d34:	6a 68                	push   $0x68
  jmp __alltraps
c0102d36:	e9 34 fc ff ff       	jmp    c010296f <__alltraps>

c0102d3b <vector105>:
.globl vector105
vector105:
  pushl $0
c0102d3b:	6a 00                	push   $0x0
  pushl $105
c0102d3d:	6a 69                	push   $0x69
  jmp __alltraps
c0102d3f:	e9 2b fc ff ff       	jmp    c010296f <__alltraps>

c0102d44 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102d44:	6a 00                	push   $0x0
  pushl $106
c0102d46:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102d48:	e9 22 fc ff ff       	jmp    c010296f <__alltraps>

c0102d4d <vector107>:
.globl vector107
vector107:
  pushl $0
c0102d4d:	6a 00                	push   $0x0
  pushl $107
c0102d4f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102d51:	e9 19 fc ff ff       	jmp    c010296f <__alltraps>

c0102d56 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $108
c0102d58:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102d5a:	e9 10 fc ff ff       	jmp    c010296f <__alltraps>

c0102d5f <vector109>:
.globl vector109
vector109:
  pushl $0
c0102d5f:	6a 00                	push   $0x0
  pushl $109
c0102d61:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102d63:	e9 07 fc ff ff       	jmp    c010296f <__alltraps>

c0102d68 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102d68:	6a 00                	push   $0x0
  pushl $110
c0102d6a:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102d6c:	e9 fe fb ff ff       	jmp    c010296f <__alltraps>

c0102d71 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102d71:	6a 00                	push   $0x0
  pushl $111
c0102d73:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102d75:	e9 f5 fb ff ff       	jmp    c010296f <__alltraps>

c0102d7a <vector112>:
.globl vector112
vector112:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $112
c0102d7c:	6a 70                	push   $0x70
  jmp __alltraps
c0102d7e:	e9 ec fb ff ff       	jmp    c010296f <__alltraps>

c0102d83 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102d83:	6a 00                	push   $0x0
  pushl $113
c0102d85:	6a 71                	push   $0x71
  jmp __alltraps
c0102d87:	e9 e3 fb ff ff       	jmp    c010296f <__alltraps>

c0102d8c <vector114>:
.globl vector114
vector114:
  pushl $0
c0102d8c:	6a 00                	push   $0x0
  pushl $114
c0102d8e:	6a 72                	push   $0x72
  jmp __alltraps
c0102d90:	e9 da fb ff ff       	jmp    c010296f <__alltraps>

c0102d95 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102d95:	6a 00                	push   $0x0
  pushl $115
c0102d97:	6a 73                	push   $0x73
  jmp __alltraps
c0102d99:	e9 d1 fb ff ff       	jmp    c010296f <__alltraps>

c0102d9e <vector116>:
.globl vector116
vector116:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $116
c0102da0:	6a 74                	push   $0x74
  jmp __alltraps
c0102da2:	e9 c8 fb ff ff       	jmp    c010296f <__alltraps>

c0102da7 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102da7:	6a 00                	push   $0x0
  pushl $117
c0102da9:	6a 75                	push   $0x75
  jmp __alltraps
c0102dab:	e9 bf fb ff ff       	jmp    c010296f <__alltraps>

c0102db0 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102db0:	6a 00                	push   $0x0
  pushl $118
c0102db2:	6a 76                	push   $0x76
  jmp __alltraps
c0102db4:	e9 b6 fb ff ff       	jmp    c010296f <__alltraps>

c0102db9 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102db9:	6a 00                	push   $0x0
  pushl $119
c0102dbb:	6a 77                	push   $0x77
  jmp __alltraps
c0102dbd:	e9 ad fb ff ff       	jmp    c010296f <__alltraps>

c0102dc2 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $120
c0102dc4:	6a 78                	push   $0x78
  jmp __alltraps
c0102dc6:	e9 a4 fb ff ff       	jmp    c010296f <__alltraps>

c0102dcb <vector121>:
.globl vector121
vector121:
  pushl $0
c0102dcb:	6a 00                	push   $0x0
  pushl $121
c0102dcd:	6a 79                	push   $0x79
  jmp __alltraps
c0102dcf:	e9 9b fb ff ff       	jmp    c010296f <__alltraps>

c0102dd4 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102dd4:	6a 00                	push   $0x0
  pushl $122
c0102dd6:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102dd8:	e9 92 fb ff ff       	jmp    c010296f <__alltraps>

c0102ddd <vector123>:
.globl vector123
vector123:
  pushl $0
c0102ddd:	6a 00                	push   $0x0
  pushl $123
c0102ddf:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102de1:	e9 89 fb ff ff       	jmp    c010296f <__alltraps>

c0102de6 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $124
c0102de8:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102dea:	e9 80 fb ff ff       	jmp    c010296f <__alltraps>

c0102def <vector125>:
.globl vector125
vector125:
  pushl $0
c0102def:	6a 00                	push   $0x0
  pushl $125
c0102df1:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102df3:	e9 77 fb ff ff       	jmp    c010296f <__alltraps>

c0102df8 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102df8:	6a 00                	push   $0x0
  pushl $126
c0102dfa:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102dfc:	e9 6e fb ff ff       	jmp    c010296f <__alltraps>

c0102e01 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102e01:	6a 00                	push   $0x0
  pushl $127
c0102e03:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102e05:	e9 65 fb ff ff       	jmp    c010296f <__alltraps>

c0102e0a <vector128>:
.globl vector128
vector128:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $128
c0102e0c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102e11:	e9 59 fb ff ff       	jmp    c010296f <__alltraps>

c0102e16 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $129
c0102e18:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102e1d:	e9 4d fb ff ff       	jmp    c010296f <__alltraps>

c0102e22 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $130
c0102e24:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102e29:	e9 41 fb ff ff       	jmp    c010296f <__alltraps>

c0102e2e <vector131>:
.globl vector131
vector131:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $131
c0102e30:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102e35:	e9 35 fb ff ff       	jmp    c010296f <__alltraps>

c0102e3a <vector132>:
.globl vector132
vector132:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $132
c0102e3c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102e41:	e9 29 fb ff ff       	jmp    c010296f <__alltraps>

c0102e46 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $133
c0102e48:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102e4d:	e9 1d fb ff ff       	jmp    c010296f <__alltraps>

c0102e52 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $134
c0102e54:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102e59:	e9 11 fb ff ff       	jmp    c010296f <__alltraps>

c0102e5e <vector135>:
.globl vector135
vector135:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $135
c0102e60:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102e65:	e9 05 fb ff ff       	jmp    c010296f <__alltraps>

c0102e6a <vector136>:
.globl vector136
vector136:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $136
c0102e6c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102e71:	e9 f9 fa ff ff       	jmp    c010296f <__alltraps>

c0102e76 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $137
c0102e78:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102e7d:	e9 ed fa ff ff       	jmp    c010296f <__alltraps>

c0102e82 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $138
c0102e84:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102e89:	e9 e1 fa ff ff       	jmp    c010296f <__alltraps>

c0102e8e <vector139>:
.globl vector139
vector139:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $139
c0102e90:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102e95:	e9 d5 fa ff ff       	jmp    c010296f <__alltraps>

c0102e9a <vector140>:
.globl vector140
vector140:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $140
c0102e9c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102ea1:	e9 c9 fa ff ff       	jmp    c010296f <__alltraps>

c0102ea6 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $141
c0102ea8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ead:	e9 bd fa ff ff       	jmp    c010296f <__alltraps>

c0102eb2 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $142
c0102eb4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102eb9:	e9 b1 fa ff ff       	jmp    c010296f <__alltraps>

c0102ebe <vector143>:
.globl vector143
vector143:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $143
c0102ec0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102ec5:	e9 a5 fa ff ff       	jmp    c010296f <__alltraps>

c0102eca <vector144>:
.globl vector144
vector144:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $144
c0102ecc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ed1:	e9 99 fa ff ff       	jmp    c010296f <__alltraps>

c0102ed6 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $145
c0102ed8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102edd:	e9 8d fa ff ff       	jmp    c010296f <__alltraps>

c0102ee2 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $146
c0102ee4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ee9:	e9 81 fa ff ff       	jmp    c010296f <__alltraps>

c0102eee <vector147>:
.globl vector147
vector147:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $147
c0102ef0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ef5:	e9 75 fa ff ff       	jmp    c010296f <__alltraps>

c0102efa <vector148>:
.globl vector148
vector148:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $148
c0102efc:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102f01:	e9 69 fa ff ff       	jmp    c010296f <__alltraps>

c0102f06 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $149
c0102f08:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102f0d:	e9 5d fa ff ff       	jmp    c010296f <__alltraps>

c0102f12 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $150
c0102f14:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102f19:	e9 51 fa ff ff       	jmp    c010296f <__alltraps>

c0102f1e <vector151>:
.globl vector151
vector151:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $151
c0102f20:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102f25:	e9 45 fa ff ff       	jmp    c010296f <__alltraps>

c0102f2a <vector152>:
.globl vector152
vector152:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $152
c0102f2c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102f31:	e9 39 fa ff ff       	jmp    c010296f <__alltraps>

c0102f36 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $153
c0102f38:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102f3d:	e9 2d fa ff ff       	jmp    c010296f <__alltraps>

c0102f42 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $154
c0102f44:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102f49:	e9 21 fa ff ff       	jmp    c010296f <__alltraps>

c0102f4e <vector155>:
.globl vector155
vector155:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $155
c0102f50:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102f55:	e9 15 fa ff ff       	jmp    c010296f <__alltraps>

c0102f5a <vector156>:
.globl vector156
vector156:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $156
c0102f5c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102f61:	e9 09 fa ff ff       	jmp    c010296f <__alltraps>

c0102f66 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $157
c0102f68:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102f6d:	e9 fd f9 ff ff       	jmp    c010296f <__alltraps>

c0102f72 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $158
c0102f74:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102f79:	e9 f1 f9 ff ff       	jmp    c010296f <__alltraps>

c0102f7e <vector159>:
.globl vector159
vector159:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $159
c0102f80:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102f85:	e9 e5 f9 ff ff       	jmp    c010296f <__alltraps>

c0102f8a <vector160>:
.globl vector160
vector160:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $160
c0102f8c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102f91:	e9 d9 f9 ff ff       	jmp    c010296f <__alltraps>

c0102f96 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $161
c0102f98:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102f9d:	e9 cd f9 ff ff       	jmp    c010296f <__alltraps>

c0102fa2 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $162
c0102fa4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102fa9:	e9 c1 f9 ff ff       	jmp    c010296f <__alltraps>

c0102fae <vector163>:
.globl vector163
vector163:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $163
c0102fb0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102fb5:	e9 b5 f9 ff ff       	jmp    c010296f <__alltraps>

c0102fba <vector164>:
.globl vector164
vector164:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $164
c0102fbc:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102fc1:	e9 a9 f9 ff ff       	jmp    c010296f <__alltraps>

c0102fc6 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $165
c0102fc8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102fcd:	e9 9d f9 ff ff       	jmp    c010296f <__alltraps>

c0102fd2 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $166
c0102fd4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102fd9:	e9 91 f9 ff ff       	jmp    c010296f <__alltraps>

c0102fde <vector167>:
.globl vector167
vector167:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $167
c0102fe0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102fe5:	e9 85 f9 ff ff       	jmp    c010296f <__alltraps>

c0102fea <vector168>:
.globl vector168
vector168:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $168
c0102fec:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102ff1:	e9 79 f9 ff ff       	jmp    c010296f <__alltraps>

c0102ff6 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $169
c0102ff8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102ffd:	e9 6d f9 ff ff       	jmp    c010296f <__alltraps>

c0103002 <vector170>:
.globl vector170
vector170:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $170
c0103004:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0103009:	e9 61 f9 ff ff       	jmp    c010296f <__alltraps>

c010300e <vector171>:
.globl vector171
vector171:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $171
c0103010:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0103015:	e9 55 f9 ff ff       	jmp    c010296f <__alltraps>

c010301a <vector172>:
.globl vector172
vector172:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $172
c010301c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0103021:	e9 49 f9 ff ff       	jmp    c010296f <__alltraps>

c0103026 <vector173>:
.globl vector173
vector173:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $173
c0103028:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010302d:	e9 3d f9 ff ff       	jmp    c010296f <__alltraps>

c0103032 <vector174>:
.globl vector174
vector174:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $174
c0103034:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0103039:	e9 31 f9 ff ff       	jmp    c010296f <__alltraps>

c010303e <vector175>:
.globl vector175
vector175:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $175
c0103040:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0103045:	e9 25 f9 ff ff       	jmp    c010296f <__alltraps>

c010304a <vector176>:
.globl vector176
vector176:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $176
c010304c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0103051:	e9 19 f9 ff ff       	jmp    c010296f <__alltraps>

c0103056 <vector177>:
.globl vector177
vector177:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $177
c0103058:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010305d:	e9 0d f9 ff ff       	jmp    c010296f <__alltraps>

c0103062 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $178
c0103064:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0103069:	e9 01 f9 ff ff       	jmp    c010296f <__alltraps>

c010306e <vector179>:
.globl vector179
vector179:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $179
c0103070:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0103075:	e9 f5 f8 ff ff       	jmp    c010296f <__alltraps>

c010307a <vector180>:
.globl vector180
vector180:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $180
c010307c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0103081:	e9 e9 f8 ff ff       	jmp    c010296f <__alltraps>

c0103086 <vector181>:
.globl vector181
vector181:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $181
c0103088:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010308d:	e9 dd f8 ff ff       	jmp    c010296f <__alltraps>

c0103092 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $182
c0103094:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103099:	e9 d1 f8 ff ff       	jmp    c010296f <__alltraps>

c010309e <vector183>:
.globl vector183
vector183:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $183
c01030a0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01030a5:	e9 c5 f8 ff ff       	jmp    c010296f <__alltraps>

c01030aa <vector184>:
.globl vector184
vector184:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $184
c01030ac:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01030b1:	e9 b9 f8 ff ff       	jmp    c010296f <__alltraps>

c01030b6 <vector185>:
.globl vector185
vector185:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $185
c01030b8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01030bd:	e9 ad f8 ff ff       	jmp    c010296f <__alltraps>

c01030c2 <vector186>:
.globl vector186
vector186:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $186
c01030c4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01030c9:	e9 a1 f8 ff ff       	jmp    c010296f <__alltraps>

c01030ce <vector187>:
.globl vector187
vector187:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $187
c01030d0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01030d5:	e9 95 f8 ff ff       	jmp    c010296f <__alltraps>

c01030da <vector188>:
.globl vector188
vector188:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $188
c01030dc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01030e1:	e9 89 f8 ff ff       	jmp    c010296f <__alltraps>

c01030e6 <vector189>:
.globl vector189
vector189:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $189
c01030e8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01030ed:	e9 7d f8 ff ff       	jmp    c010296f <__alltraps>

c01030f2 <vector190>:
.globl vector190
vector190:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $190
c01030f4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01030f9:	e9 71 f8 ff ff       	jmp    c010296f <__alltraps>

c01030fe <vector191>:
.globl vector191
vector191:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $191
c0103100:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0103105:	e9 65 f8 ff ff       	jmp    c010296f <__alltraps>

c010310a <vector192>:
.globl vector192
vector192:
  pushl $0
c010310a:	6a 00                	push   $0x0
  pushl $192
c010310c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0103111:	e9 59 f8 ff ff       	jmp    c010296f <__alltraps>

c0103116 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103116:	6a 00                	push   $0x0
  pushl $193
c0103118:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010311d:	e9 4d f8 ff ff       	jmp    c010296f <__alltraps>

c0103122 <vector194>:
.globl vector194
vector194:
  pushl $0
c0103122:	6a 00                	push   $0x0
  pushl $194
c0103124:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103129:	e9 41 f8 ff ff       	jmp    c010296f <__alltraps>

c010312e <vector195>:
.globl vector195
vector195:
  pushl $0
c010312e:	6a 00                	push   $0x0
  pushl $195
c0103130:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0103135:	e9 35 f8 ff ff       	jmp    c010296f <__alltraps>

c010313a <vector196>:
.globl vector196
vector196:
  pushl $0
c010313a:	6a 00                	push   $0x0
  pushl $196
c010313c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0103141:	e9 29 f8 ff ff       	jmp    c010296f <__alltraps>

c0103146 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103146:	6a 00                	push   $0x0
  pushl $197
c0103148:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010314d:	e9 1d f8 ff ff       	jmp    c010296f <__alltraps>

c0103152 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103152:	6a 00                	push   $0x0
  pushl $198
c0103154:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103159:	e9 11 f8 ff ff       	jmp    c010296f <__alltraps>

c010315e <vector199>:
.globl vector199
vector199:
  pushl $0
c010315e:	6a 00                	push   $0x0
  pushl $199
c0103160:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103165:	e9 05 f8 ff ff       	jmp    c010296f <__alltraps>

c010316a <vector200>:
.globl vector200
vector200:
  pushl $0
c010316a:	6a 00                	push   $0x0
  pushl $200
c010316c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103171:	e9 f9 f7 ff ff       	jmp    c010296f <__alltraps>

c0103176 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103176:	6a 00                	push   $0x0
  pushl $201
c0103178:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010317d:	e9 ed f7 ff ff       	jmp    c010296f <__alltraps>

c0103182 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103182:	6a 00                	push   $0x0
  pushl $202
c0103184:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103189:	e9 e1 f7 ff ff       	jmp    c010296f <__alltraps>

c010318e <vector203>:
.globl vector203
vector203:
  pushl $0
c010318e:	6a 00                	push   $0x0
  pushl $203
c0103190:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103195:	e9 d5 f7 ff ff       	jmp    c010296f <__alltraps>

c010319a <vector204>:
.globl vector204
vector204:
  pushl $0
c010319a:	6a 00                	push   $0x0
  pushl $204
c010319c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01031a1:	e9 c9 f7 ff ff       	jmp    c010296f <__alltraps>

c01031a6 <vector205>:
.globl vector205
vector205:
  pushl $0
c01031a6:	6a 00                	push   $0x0
  pushl $205
c01031a8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01031ad:	e9 bd f7 ff ff       	jmp    c010296f <__alltraps>

c01031b2 <vector206>:
.globl vector206
vector206:
  pushl $0
c01031b2:	6a 00                	push   $0x0
  pushl $206
c01031b4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01031b9:	e9 b1 f7 ff ff       	jmp    c010296f <__alltraps>

c01031be <vector207>:
.globl vector207
vector207:
  pushl $0
c01031be:	6a 00                	push   $0x0
  pushl $207
c01031c0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01031c5:	e9 a5 f7 ff ff       	jmp    c010296f <__alltraps>

c01031ca <vector208>:
.globl vector208
vector208:
  pushl $0
c01031ca:	6a 00                	push   $0x0
  pushl $208
c01031cc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01031d1:	e9 99 f7 ff ff       	jmp    c010296f <__alltraps>

c01031d6 <vector209>:
.globl vector209
vector209:
  pushl $0
c01031d6:	6a 00                	push   $0x0
  pushl $209
c01031d8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01031dd:	e9 8d f7 ff ff       	jmp    c010296f <__alltraps>

c01031e2 <vector210>:
.globl vector210
vector210:
  pushl $0
c01031e2:	6a 00                	push   $0x0
  pushl $210
c01031e4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01031e9:	e9 81 f7 ff ff       	jmp    c010296f <__alltraps>

c01031ee <vector211>:
.globl vector211
vector211:
  pushl $0
c01031ee:	6a 00                	push   $0x0
  pushl $211
c01031f0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01031f5:	e9 75 f7 ff ff       	jmp    c010296f <__alltraps>

c01031fa <vector212>:
.globl vector212
vector212:
  pushl $0
c01031fa:	6a 00                	push   $0x0
  pushl $212
c01031fc:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103201:	e9 69 f7 ff ff       	jmp    c010296f <__alltraps>

c0103206 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103206:	6a 00                	push   $0x0
  pushl $213
c0103208:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010320d:	e9 5d f7 ff ff       	jmp    c010296f <__alltraps>

c0103212 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103212:	6a 00                	push   $0x0
  pushl $214
c0103214:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103219:	e9 51 f7 ff ff       	jmp    c010296f <__alltraps>

c010321e <vector215>:
.globl vector215
vector215:
  pushl $0
c010321e:	6a 00                	push   $0x0
  pushl $215
c0103220:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103225:	e9 45 f7 ff ff       	jmp    c010296f <__alltraps>

c010322a <vector216>:
.globl vector216
vector216:
  pushl $0
c010322a:	6a 00                	push   $0x0
  pushl $216
c010322c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103231:	e9 39 f7 ff ff       	jmp    c010296f <__alltraps>

c0103236 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103236:	6a 00                	push   $0x0
  pushl $217
c0103238:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010323d:	e9 2d f7 ff ff       	jmp    c010296f <__alltraps>

c0103242 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103242:	6a 00                	push   $0x0
  pushl $218
c0103244:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103249:	e9 21 f7 ff ff       	jmp    c010296f <__alltraps>

c010324e <vector219>:
.globl vector219
vector219:
  pushl $0
c010324e:	6a 00                	push   $0x0
  pushl $219
c0103250:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103255:	e9 15 f7 ff ff       	jmp    c010296f <__alltraps>

c010325a <vector220>:
.globl vector220
vector220:
  pushl $0
c010325a:	6a 00                	push   $0x0
  pushl $220
c010325c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103261:	e9 09 f7 ff ff       	jmp    c010296f <__alltraps>

c0103266 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103266:	6a 00                	push   $0x0
  pushl $221
c0103268:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010326d:	e9 fd f6 ff ff       	jmp    c010296f <__alltraps>

c0103272 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103272:	6a 00                	push   $0x0
  pushl $222
c0103274:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103279:	e9 f1 f6 ff ff       	jmp    c010296f <__alltraps>

c010327e <vector223>:
.globl vector223
vector223:
  pushl $0
c010327e:	6a 00                	push   $0x0
  pushl $223
c0103280:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103285:	e9 e5 f6 ff ff       	jmp    c010296f <__alltraps>

c010328a <vector224>:
.globl vector224
vector224:
  pushl $0
c010328a:	6a 00                	push   $0x0
  pushl $224
c010328c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103291:	e9 d9 f6 ff ff       	jmp    c010296f <__alltraps>

c0103296 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103296:	6a 00                	push   $0x0
  pushl $225
c0103298:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010329d:	e9 cd f6 ff ff       	jmp    c010296f <__alltraps>

c01032a2 <vector226>:
.globl vector226
vector226:
  pushl $0
c01032a2:	6a 00                	push   $0x0
  pushl $226
c01032a4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01032a9:	e9 c1 f6 ff ff       	jmp    c010296f <__alltraps>

c01032ae <vector227>:
.globl vector227
vector227:
  pushl $0
c01032ae:	6a 00                	push   $0x0
  pushl $227
c01032b0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01032b5:	e9 b5 f6 ff ff       	jmp    c010296f <__alltraps>

c01032ba <vector228>:
.globl vector228
vector228:
  pushl $0
c01032ba:	6a 00                	push   $0x0
  pushl $228
c01032bc:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01032c1:	e9 a9 f6 ff ff       	jmp    c010296f <__alltraps>

c01032c6 <vector229>:
.globl vector229
vector229:
  pushl $0
c01032c6:	6a 00                	push   $0x0
  pushl $229
c01032c8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01032cd:	e9 9d f6 ff ff       	jmp    c010296f <__alltraps>

c01032d2 <vector230>:
.globl vector230
vector230:
  pushl $0
c01032d2:	6a 00                	push   $0x0
  pushl $230
c01032d4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01032d9:	e9 91 f6 ff ff       	jmp    c010296f <__alltraps>

c01032de <vector231>:
.globl vector231
vector231:
  pushl $0
c01032de:	6a 00                	push   $0x0
  pushl $231
c01032e0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01032e5:	e9 85 f6 ff ff       	jmp    c010296f <__alltraps>

c01032ea <vector232>:
.globl vector232
vector232:
  pushl $0
c01032ea:	6a 00                	push   $0x0
  pushl $232
c01032ec:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01032f1:	e9 79 f6 ff ff       	jmp    c010296f <__alltraps>

c01032f6 <vector233>:
.globl vector233
vector233:
  pushl $0
c01032f6:	6a 00                	push   $0x0
  pushl $233
c01032f8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01032fd:	e9 6d f6 ff ff       	jmp    c010296f <__alltraps>

c0103302 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103302:	6a 00                	push   $0x0
  pushl $234
c0103304:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103309:	e9 61 f6 ff ff       	jmp    c010296f <__alltraps>

c010330e <vector235>:
.globl vector235
vector235:
  pushl $0
c010330e:	6a 00                	push   $0x0
  pushl $235
c0103310:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103315:	e9 55 f6 ff ff       	jmp    c010296f <__alltraps>

c010331a <vector236>:
.globl vector236
vector236:
  pushl $0
c010331a:	6a 00                	push   $0x0
  pushl $236
c010331c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103321:	e9 49 f6 ff ff       	jmp    c010296f <__alltraps>

c0103326 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103326:	6a 00                	push   $0x0
  pushl $237
c0103328:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010332d:	e9 3d f6 ff ff       	jmp    c010296f <__alltraps>

c0103332 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103332:	6a 00                	push   $0x0
  pushl $238
c0103334:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103339:	e9 31 f6 ff ff       	jmp    c010296f <__alltraps>

c010333e <vector239>:
.globl vector239
vector239:
  pushl $0
c010333e:	6a 00                	push   $0x0
  pushl $239
c0103340:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103345:	e9 25 f6 ff ff       	jmp    c010296f <__alltraps>

c010334a <vector240>:
.globl vector240
vector240:
  pushl $0
c010334a:	6a 00                	push   $0x0
  pushl $240
c010334c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103351:	e9 19 f6 ff ff       	jmp    c010296f <__alltraps>

c0103356 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103356:	6a 00                	push   $0x0
  pushl $241
c0103358:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010335d:	e9 0d f6 ff ff       	jmp    c010296f <__alltraps>

c0103362 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103362:	6a 00                	push   $0x0
  pushl $242
c0103364:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103369:	e9 01 f6 ff ff       	jmp    c010296f <__alltraps>

c010336e <vector243>:
.globl vector243
vector243:
  pushl $0
c010336e:	6a 00                	push   $0x0
  pushl $243
c0103370:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103375:	e9 f5 f5 ff ff       	jmp    c010296f <__alltraps>

c010337a <vector244>:
.globl vector244
vector244:
  pushl $0
c010337a:	6a 00                	push   $0x0
  pushl $244
c010337c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103381:	e9 e9 f5 ff ff       	jmp    c010296f <__alltraps>

c0103386 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103386:	6a 00                	push   $0x0
  pushl $245
c0103388:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010338d:	e9 dd f5 ff ff       	jmp    c010296f <__alltraps>

c0103392 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103392:	6a 00                	push   $0x0
  pushl $246
c0103394:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103399:	e9 d1 f5 ff ff       	jmp    c010296f <__alltraps>

c010339e <vector247>:
.globl vector247
vector247:
  pushl $0
c010339e:	6a 00                	push   $0x0
  pushl $247
c01033a0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01033a5:	e9 c5 f5 ff ff       	jmp    c010296f <__alltraps>

c01033aa <vector248>:
.globl vector248
vector248:
  pushl $0
c01033aa:	6a 00                	push   $0x0
  pushl $248
c01033ac:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01033b1:	e9 b9 f5 ff ff       	jmp    c010296f <__alltraps>

c01033b6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01033b6:	6a 00                	push   $0x0
  pushl $249
c01033b8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01033bd:	e9 ad f5 ff ff       	jmp    c010296f <__alltraps>

c01033c2 <vector250>:
.globl vector250
vector250:
  pushl $0
c01033c2:	6a 00                	push   $0x0
  pushl $250
c01033c4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01033c9:	e9 a1 f5 ff ff       	jmp    c010296f <__alltraps>

c01033ce <vector251>:
.globl vector251
vector251:
  pushl $0
c01033ce:	6a 00                	push   $0x0
  pushl $251
c01033d0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01033d5:	e9 95 f5 ff ff       	jmp    c010296f <__alltraps>

c01033da <vector252>:
.globl vector252
vector252:
  pushl $0
c01033da:	6a 00                	push   $0x0
  pushl $252
c01033dc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01033e1:	e9 89 f5 ff ff       	jmp    c010296f <__alltraps>

c01033e6 <vector253>:
.globl vector253
vector253:
  pushl $0
c01033e6:	6a 00                	push   $0x0
  pushl $253
c01033e8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01033ed:	e9 7d f5 ff ff       	jmp    c010296f <__alltraps>

c01033f2 <vector254>:
.globl vector254
vector254:
  pushl $0
c01033f2:	6a 00                	push   $0x0
  pushl $254
c01033f4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01033f9:	e9 71 f5 ff ff       	jmp    c010296f <__alltraps>

c01033fe <vector255>:
.globl vector255
vector255:
  pushl $0
c01033fe:	6a 00                	push   $0x0
  pushl $255
c0103400:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103405:	e9 65 f5 ff ff       	jmp    c010296f <__alltraps>

c010340a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010340a:	55                   	push   %ebp
c010340b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010340d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103410:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0103415:	29 c2                	sub    %eax,%edx
c0103417:	89 d0                	mov    %edx,%eax
c0103419:	c1 f8 05             	sar    $0x5,%eax
}
c010341c:	5d                   	pop    %ebp
c010341d:	c3                   	ret    

c010341e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010341e:	55                   	push   %ebp
c010341f:	89 e5                	mov    %esp,%ebp
c0103421:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103424:	8b 45 08             	mov    0x8(%ebp),%eax
c0103427:	89 04 24             	mov    %eax,(%esp)
c010342a:	e8 db ff ff ff       	call   c010340a <page2ppn>
c010342f:	c1 e0 0c             	shl    $0xc,%eax
}
c0103432:	c9                   	leave  
c0103433:	c3                   	ret    

c0103434 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103434:	55                   	push   %ebp
c0103435:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103437:	8b 45 08             	mov    0x8(%ebp),%eax
c010343a:	8b 00                	mov    (%eax),%eax
}
c010343c:	5d                   	pop    %ebp
c010343d:	c3                   	ret    

c010343e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010343e:	55                   	push   %ebp
c010343f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103441:	8b 45 08             	mov    0x8(%ebp),%eax
c0103444:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103447:	89 10                	mov    %edx,(%eax)
}
c0103449:	5d                   	pop    %ebp
c010344a:	c3                   	ret    

c010344b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010344b:	55                   	push   %ebp
c010344c:	89 e5                	mov    %esp,%ebp
c010344e:	83 ec 10             	sub    $0x10,%esp
c0103451:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103458:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010345b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010345e:	89 50 04             	mov    %edx,0x4(%eax)
c0103461:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103464:	8b 50 04             	mov    0x4(%eax),%edx
c0103467:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010346a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010346c:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103473:	00 00 00 
}
c0103476:	c9                   	leave  
c0103477:	c3                   	ret    

c0103478 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103478:	55                   	push   %ebp
c0103479:	89 e5                	mov    %esp,%ebp
c010347b:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
c010347e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103482:	75 24                	jne    c01034a8 <default_init_memmap+0x30>
c0103484:	c7 44 24 0c 10 a8 10 	movl   $0xc010a810,0xc(%esp)
c010348b:	c0 
c010348c:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103493:	c0 
c0103494:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010349b:	00 
c010349c:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01034a3:	e8 2f d8 ff ff       	call   c0100cd7 <__panic>
	struct Page *p = base;
c01034a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
c01034ae:	e9 ef 00 00 00       	jmp    c01035a2 <default_init_memmap+0x12a>
		assert(PageReserved(p));
c01034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b6:	83 c0 04             	add    $0x4,%eax
c01034b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01034c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01034c9:	0f a3 10             	bt     %edx,(%eax)
c01034cc:	19 c0                	sbb    %eax,%eax
c01034ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01034d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01034d5:	0f 95 c0             	setne  %al
c01034d8:	0f b6 c0             	movzbl %al,%eax
c01034db:	85 c0                	test   %eax,%eax
c01034dd:	75 24                	jne    c0103503 <default_init_memmap+0x8b>
c01034df:	c7 44 24 0c 41 a8 10 	movl   $0xc010a841,0xc(%esp)
c01034e6:	c0 
c01034e7:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01034ee:	c0 
c01034ef:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01034f6:	00 
c01034f7:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01034fe:	e8 d4 d7 ff ff       	call   c0100cd7 <__panic>
		p->flags = 0;
c0103503:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c010350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103510:	83 c0 04             	add    $0x4,%eax
c0103513:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010351a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010351d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103523:	0f ab 10             	bts    %edx,(%eax)
		if(p == base)
c0103526:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103529:	3b 45 08             	cmp    0x8(%ebp),%eax
c010352c:	75 0b                	jne    c0103539 <default_init_memmap+0xc1>
		{
			p->property = n;
c010352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103531:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103534:	89 50 08             	mov    %edx,0x8(%eax)
c0103537:	eb 0a                	jmp    c0103543 <default_init_memmap+0xcb>
		}
		else
		{
			p->property = 0;
c0103539:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		}
		set_page_ref(p, 0);
c0103543:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010354a:	00 
c010354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010354e:	89 04 24             	mov    %eax,(%esp)
c0103551:	e8 e8 fe ff ff       	call   c010343e <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
c0103556:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103559:	83 c0 0c             	add    $0xc,%eax
c010355c:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103563:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103566:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103569:	8b 00                	mov    (%eax),%eax
c010356b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010356e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103571:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103574:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103577:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010357a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010357d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103580:	89 10                	mov    %edx,(%eax)
c0103582:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103585:	8b 10                	mov    (%eax),%edx
c0103587:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010358a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010358d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103590:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103593:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103599:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010359c:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
c010359e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01035a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035a5:	c1 e0 05             	shl    $0x5,%eax
c01035a8:	89 c2                	mov    %eax,%edx
c01035aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ad:	01 d0                	add    %edx,%eax
c01035af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01035b2:	0f 85 fb fe ff ff    	jne    c01034b3 <default_init_memmap+0x3b>
			p->property = 0;
		}
		set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
	}
	nr_free += n;
c01035b8:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c01035be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035c1:	01 d0                	add    %edx,%eax
c01035c3:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c01035c8:	c9                   	leave  
c01035c9:	c3                   	ret    

c01035ca <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01035ca:	55                   	push   %ebp
c01035cb:	89 e5                	mov    %esp,%ebp
c01035cd:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c01035d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01035d4:	75 24                	jne    c01035fa <default_alloc_pages+0x30>
c01035d6:	c7 44 24 0c 10 a8 10 	movl   $0xc010a810,0xc(%esp)
c01035dd:	c0 
c01035de:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01035e5:	c0 
c01035e6:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c01035ed:	00 
c01035ee:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01035f5:	e8 dd d6 ff ff       	call   c0100cd7 <__panic>
	if (n > nr_free) {
c01035fa:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01035ff:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103602:	73 0a                	jae    c010360e <default_alloc_pages+0x44>
		return NULL;
c0103604:	b8 00 00 00 00       	mov    $0x0,%eax
c0103609:	e9 45 01 00 00       	jmp    c0103753 <default_alloc_pages+0x189>
	}
	struct Page *page = NULL;
c010360e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	list_entry_t *tmp = NULL;
c0103615:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	list_entry_t *le = &free_list;
c010361c:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)
	while ((le = list_next(le)) != &free_list)
c0103623:	e9 0a 01 00 00       	jmp    c0103732 <default_alloc_pages+0x168>
	{
		struct Page *p = le2page(le, page_link);
c0103628:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010362b:	83 e8 0c             	sub    $0xc,%eax
c010362e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (p->property >= n)
c0103631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103634:	8b 40 08             	mov    0x8(%eax),%eax
c0103637:	3b 45 08             	cmp    0x8(%ebp),%eax
c010363a:	0f 82 f2 00 00 00    	jb     c0103732 <default_alloc_pages+0x168>
		{
			int i;
			for(i = 0;i<n;i++)
c0103640:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103647:	eb 7c                	jmp    c01036c5 <default_alloc_pages+0xfb>
c0103649:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010364c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010364f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103652:	8b 40 04             	mov    0x4(%eax),%eax
			{
				tmp = list_next(le);
c0103655:	89 45 e8             	mov    %eax,-0x18(%ebp)
				struct Page *pagetmp = le2page(le, page_link);
c0103658:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010365b:	83 e8 0c             	sub    $0xc,%eax
c010365e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				SetPageReserved(pagetmp);
c0103661:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103664:	83 c0 04             	add    $0x4,%eax
c0103667:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c010366e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103671:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103674:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103677:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(pagetmp);
c010367a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010367d:	83 c0 04             	add    $0x4,%eax
c0103680:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103687:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010368a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010368d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103690:	0f b3 10             	btr    %edx,(%eax)
c0103693:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103696:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103699:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010369c:	8b 40 04             	mov    0x4(%eax),%eax
c010369f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01036a2:	8b 12                	mov    (%edx),%edx
c01036a4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01036a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01036aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01036ad:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036b0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01036b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01036b9:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = tmp;
c01036bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		struct Page *p = le2page(le, page_link);
		if (p->property >= n)
		{
			int i;
			for(i = 0;i<n;i++)
c01036c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01036c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036cb:	0f 82 78 ff ff ff    	jb     c0103649 <default_alloc_pages+0x7f>
				SetPageReserved(pagetmp);
				ClearPageProperty(pagetmp);
				list_del(le);
				le = tmp;
			}
			if(p->property > n)
c01036d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d4:	8b 40 08             	mov    0x8(%eax),%eax
c01036d7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036da:	76 12                	jbe    c01036ee <default_alloc_pages+0x124>
			{
				(le2page(le, page_link)->property) = p->property - n;
c01036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036df:	8d 50 f4             	lea    -0xc(%eax),%edx
c01036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036e5:	8b 40 08             	mov    0x8(%eax),%eax
c01036e8:	2b 45 08             	sub    0x8(%ebp),%eax
c01036eb:	89 42 08             	mov    %eax,0x8(%edx)
			}
			SetPageReserved(p);
c01036ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f1:	83 c0 04             	add    $0x4,%eax
c01036f4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c01036fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036fe:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103701:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103704:	0f ab 10             	bts    %edx,(%eax)
			ClearPageProperty(p);
c0103707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370a:	83 c0 04             	add    $0x4,%eax
c010370d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0103714:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103717:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010371a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010371d:	0f b3 10             	btr    %edx,(%eax)
			nr_free -= n;
c0103720:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103725:	2b 45 08             	sub    0x8(%ebp),%eax
c0103728:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
			return p;
c010372d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103730:	eb 21                	jmp    c0103753 <default_alloc_pages+0x189>
c0103732:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103735:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103738:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010373b:	8b 40 04             	mov    0x4(%eax),%eax
		return NULL;
	}
	struct Page *page = NULL;
	list_entry_t *tmp = NULL;
	list_entry_t *le = &free_list;
	while ((le = list_next(le)) != &free_list)
c010373e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103741:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103748:	0f 85 da fe ff ff    	jne    c0103628 <default_alloc_pages+0x5e>
			ClearPageProperty(p);
			nr_free -= n;
			return p;
		}
	}
	return NULL;
c010374e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103753:	c9                   	leave  
c0103754:	c3                   	ret    

c0103755 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103755:	55                   	push   %ebp
c0103756:	89 e5                	mov    %esp,%ebp
c0103758:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c010375b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010375f:	75 24                	jne    c0103785 <default_free_pages+0x30>
c0103761:	c7 44 24 0c 10 a8 10 	movl   $0xc010a810,0xc(%esp)
c0103768:	c0 
c0103769:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103770:	c0 
c0103771:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0103778:	00 
c0103779:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103780:	e8 52 d5 ff ff       	call   c0100cd7 <__panic>
	assert(PageReserved(base));
c0103785:	8b 45 08             	mov    0x8(%ebp),%eax
c0103788:	83 c0 04             	add    $0x4,%eax
c010378b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0103792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103798:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010379b:	0f a3 10             	bt     %edx,(%eax)
c010379e:	19 c0                	sbb    %eax,%eax
c01037a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c01037a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01037a7:	0f 95 c0             	setne  %al
c01037aa:	0f b6 c0             	movzbl %al,%eax
c01037ad:	85 c0                	test   %eax,%eax
c01037af:	75 24                	jne    c01037d5 <default_free_pages+0x80>
c01037b1:	c7 44 24 0c 51 a8 10 	movl   $0xc010a851,0xc(%esp)
c01037b8:	c0 
c01037b9:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01037c0:	c0 
c01037c1:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c01037c8:	00 
c01037c9:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01037d0:	e8 02 d5 ff ff       	call   c0100cd7 <__panic>
	list_entry_t *le = &free_list;
c01037d5:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)
	struct Page* p = NULL;
c01037dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((le = list_next(le)) != &free_list)
c01037e3:	eb 13                	jmp    c01037f8 <default_free_pages+0xa3>
	{
		p = le2page(le, page_link);
c01037e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e8:	83 e8 0c             	sub    $0xc,%eax
c01037eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(p > base)
c01037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037f1:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037f4:	76 02                	jbe    c01037f8 <default_free_pages+0xa3>
			break;
c01037f6:	eb 18                	jmp    c0103810 <default_free_pages+0xbb>
c01037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01037fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103801:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
	assert(n > 0);
	assert(PageReserved(base));
	list_entry_t *le = &free_list;
	struct Page* p = NULL;
	while ((le = list_next(le)) != &free_list)
c0103804:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103807:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c010380e:	75 d5                	jne    c01037e5 <default_free_pages+0x90>
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c0103810:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103817:	eb 55                	jmp    c010386e <default_free_pages+0x119>
	{
		list_add_before(le, &((base + i)->page_link));
c0103819:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010381c:	c1 e0 05             	shl    $0x5,%eax
c010381f:	89 c2                	mov    %eax,%edx
c0103821:	8b 45 08             	mov    0x8(%ebp),%eax
c0103824:	01 d0                	add    %edx,%eax
c0103826:	8d 50 0c             	lea    0xc(%eax),%edx
c0103829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010382c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010382f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103832:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103835:	8b 00                	mov    (%eax),%eax
c0103837:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010383a:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010383d:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0103840:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103843:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103846:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103849:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010384c:	89 10                	mov    %edx,(%eax)
c010384e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103851:	8b 10                	mov    (%eax),%edx
c0103853:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103856:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103859:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010385c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010385f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103862:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103865:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103868:	89 10                	mov    %edx,(%eax)
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c010386a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010386e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103871:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103874:	72 a3                	jb     c0103819 <default_free_pages+0xc4>
	{
		list_add_before(le, &((base + i)->page_link));
	}
	base->flags = 0;
c0103876:	8b 45 08             	mov    0x8(%ebp),%eax
c0103879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	ClearPageProperty(base);
c0103880:	8b 45 08             	mov    0x8(%ebp),%eax
c0103883:	83 c0 04             	add    $0x4,%eax
c0103886:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010388d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103890:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103893:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103896:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
c0103899:	8b 45 08             	mov    0x8(%ebp),%eax
c010389c:	83 c0 04             	add    $0x4,%eax
c010389f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01038a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01038a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01038ac:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01038af:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
c01038b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038b9:	00 
c01038ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01038bd:	89 04 24             	mov    %eax,(%esp)
c01038c0:	e8 79 fb ff ff       	call   c010343e <set_page_ref>
	base->property = n;
c01038c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01038cb:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le, page_link);
c01038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038d1:	83 e8 0c             	sub    $0xc,%eax
c01038d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(base + n == p)
c01038d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038da:	c1 e0 05             	shl    $0x5,%eax
c01038dd:	89 c2                	mov    %eax,%edx
c01038df:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e2:	01 d0                	add    %edx,%eax
c01038e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038e7:	75 1b                	jne    c0103904 <default_free_pages+0x1af>
	{
		base->property = n + p->property;
c01038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ec:	8b 50 08             	mov    0x8(%eax),%edx
c01038ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038f2:	01 c2                	add    %eax,%edx
c01038f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038f7:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c01038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
c0103904:	8b 45 08             	mov    0x8(%ebp),%eax
c0103907:	83 c0 0c             	add    $0xc,%eax
c010390a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010390d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103910:	8b 00                	mov    (%eax),%eax
c0103912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
c0103915:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103918:	83 e8 0c             	sub    $0xc,%eax
c010391b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//below need to change
	if(le != &free_list && base - 1 == p)
c010391e:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103925:	74 57                	je     c010397e <default_free_pages+0x229>
c0103927:	8b 45 08             	mov    0x8(%ebp),%eax
c010392a:	83 e8 20             	sub    $0x20,%eax
c010392d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103930:	75 4c                	jne    c010397e <default_free_pages+0x229>
	{
	  while(le!=&free_list){
c0103932:	eb 41                	jmp    c0103975 <default_free_pages+0x220>
		if(p->property){
c0103934:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103937:	8b 40 08             	mov    0x8(%eax),%eax
c010393a:	85 c0                	test   %eax,%eax
c010393c:	74 20                	je     c010395e <default_free_pages+0x209>
		  p->property += base->property;
c010393e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103941:	8b 50 08             	mov    0x8(%eax),%edx
c0103944:	8b 45 08             	mov    0x8(%ebp),%eax
c0103947:	8b 40 08             	mov    0x8(%eax),%eax
c010394a:	01 c2                	add    %eax,%edx
c010394c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010394f:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
c0103952:	8b 45 08             	mov    0x8(%ebp),%eax
c0103955:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
c010395c:	eb 20                	jmp    c010397e <default_free_pages+0x229>
c010395e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103961:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103964:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103967:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
c0103969:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
c010396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010396f:	83 e8 0c             	sub    $0xc,%eax
c0103972:	89 45 f0             	mov    %eax,-0x10(%ebp)
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	//below need to change
	if(le != &free_list && base - 1 == p)
	{
	  while(le!=&free_list){
c0103975:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c010397c:	75 b6                	jne    c0103934 <default_free_pages+0x1df>
		}
		le = list_prev(le);
		p = le2page(le,page_link);
	  }
	}
	nr_free += n;
c010397e:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103984:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103987:	01 d0                	add    %edx,%eax
c0103989:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c010398e:	c9                   	leave  
c010398f:	c3                   	ret    

c0103990 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103990:	55                   	push   %ebp
c0103991:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103993:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103998:	5d                   	pop    %ebp
c0103999:	c3                   	ret    

c010399a <basic_check>:

static void
basic_check(void) {
c010399a:	55                   	push   %ebp
c010399b:	89 e5                	mov    %esp,%ebp
c010399d:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01039a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01039b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039ba:	e8 c4 15 00 00       	call   c0104f83 <alloc_pages>
c01039bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01039c6:	75 24                	jne    c01039ec <basic_check+0x52>
c01039c8:	c7 44 24 0c 64 a8 10 	movl   $0xc010a864,0xc(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01039df:	00 
c01039e0:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01039e7:	e8 eb d2 ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01039ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039f3:	e8 8b 15 00 00       	call   c0104f83 <alloc_pages>
c01039f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039ff:	75 24                	jne    c0103a25 <basic_check+0x8b>
c0103a01:	c7 44 24 0c 80 a8 10 	movl   $0xc010a880,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103a20:	e8 b2 d2 ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a2c:	e8 52 15 00 00       	call   c0104f83 <alloc_pages>
c0103a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a38:	75 24                	jne    c0103a5e <basic_check+0xc4>
c0103a3a:	c7 44 24 0c 9c a8 10 	movl   $0xc010a89c,0xc(%esp)
c0103a41:	c0 
c0103a42:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103a49:	c0 
c0103a4a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103a51:	00 
c0103a52:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103a59:	e8 79 d2 ff ff       	call   c0100cd7 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a64:	74 10                	je     c0103a76 <basic_check+0xdc>
c0103a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a6c:	74 08                	je     c0103a76 <basic_check+0xdc>
c0103a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a74:	75 24                	jne    c0103a9a <basic_check+0x100>
c0103a76:	c7 44 24 0c b8 a8 10 	movl   $0xc010a8b8,0xc(%esp)
c0103a7d:	c0 
c0103a7e:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103a85:	c0 
c0103a86:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103a8d:	00 
c0103a8e:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103a95:	e8 3d d2 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a9d:	89 04 24             	mov    %eax,(%esp)
c0103aa0:	e8 8f f9 ff ff       	call   c0103434 <page_ref>
c0103aa5:	85 c0                	test   %eax,%eax
c0103aa7:	75 1e                	jne    c0103ac7 <basic_check+0x12d>
c0103aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aac:	89 04 24             	mov    %eax,(%esp)
c0103aaf:	e8 80 f9 ff ff       	call   c0103434 <page_ref>
c0103ab4:	85 c0                	test   %eax,%eax
c0103ab6:	75 0f                	jne    c0103ac7 <basic_check+0x12d>
c0103ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103abb:	89 04 24             	mov    %eax,(%esp)
c0103abe:	e8 71 f9 ff ff       	call   c0103434 <page_ref>
c0103ac3:	85 c0                	test   %eax,%eax
c0103ac5:	74 24                	je     c0103aeb <basic_check+0x151>
c0103ac7:	c7 44 24 0c dc a8 10 	movl   $0xc010a8dc,0xc(%esp)
c0103ace:	c0 
c0103acf:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103ad6:	c0 
c0103ad7:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103ade:	00 
c0103adf:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103ae6:	e8 ec d1 ff ff       	call   c0100cd7 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aee:	89 04 24             	mov    %eax,(%esp)
c0103af1:	e8 28 f9 ff ff       	call   c010341e <page2pa>
c0103af6:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103afc:	c1 e2 0c             	shl    $0xc,%edx
c0103aff:	39 d0                	cmp    %edx,%eax
c0103b01:	72 24                	jb     c0103b27 <basic_check+0x18d>
c0103b03:	c7 44 24 0c 18 a9 10 	movl   $0xc010a918,0xc(%esp)
c0103b0a:	c0 
c0103b0b:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103b12:	c0 
c0103b13:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103b1a:	00 
c0103b1b:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103b22:	e8 b0 d1 ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b2a:	89 04 24             	mov    %eax,(%esp)
c0103b2d:	e8 ec f8 ff ff       	call   c010341e <page2pa>
c0103b32:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103b38:	c1 e2 0c             	shl    $0xc,%edx
c0103b3b:	39 d0                	cmp    %edx,%eax
c0103b3d:	72 24                	jb     c0103b63 <basic_check+0x1c9>
c0103b3f:	c7 44 24 0c 35 a9 10 	movl   $0xc010a935,0xc(%esp)
c0103b46:	c0 
c0103b47:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103b4e:	c0 
c0103b4f:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103b56:	00 
c0103b57:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103b5e:	e8 74 d1 ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b66:	89 04 24             	mov    %eax,(%esp)
c0103b69:	e8 b0 f8 ff ff       	call   c010341e <page2pa>
c0103b6e:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103b74:	c1 e2 0c             	shl    $0xc,%edx
c0103b77:	39 d0                	cmp    %edx,%eax
c0103b79:	72 24                	jb     c0103b9f <basic_check+0x205>
c0103b7b:	c7 44 24 0c 52 a9 10 	movl   $0xc010a952,0xc(%esp)
c0103b82:	c0 
c0103b83:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103b8a:	c0 
c0103b8b:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103b92:	00 
c0103b93:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103b9a:	e8 38 d1 ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c0103b9f:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103ba4:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103baa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103bad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103bb0:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103bb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bba:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103bbd:	89 50 04             	mov    %edx,0x4(%eax)
c0103bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bc3:	8b 50 04             	mov    0x4(%eax),%edx
c0103bc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bc9:	89 10                	mov    %edx,(%eax)
c0103bcb:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103bd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bd5:	8b 40 04             	mov    0x4(%eax),%eax
c0103bd8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103bdb:	0f 94 c0             	sete   %al
c0103bde:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103be1:	85 c0                	test   %eax,%eax
c0103be3:	75 24                	jne    c0103c09 <basic_check+0x26f>
c0103be5:	c7 44 24 0c 6f a9 10 	movl   $0xc010a96f,0xc(%esp)
c0103bec:	c0 
c0103bed:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103bf4:	c0 
c0103bf5:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103bfc:	00 
c0103bfd:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103c04:	e8 ce d0 ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c0103c09:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103c11:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103c18:	00 00 00 

    assert(alloc_page() == NULL);
c0103c1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c22:	e8 5c 13 00 00       	call   c0104f83 <alloc_pages>
c0103c27:	85 c0                	test   %eax,%eax
c0103c29:	74 24                	je     c0103c4f <basic_check+0x2b5>
c0103c2b:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c0103c32:	c0 
c0103c33:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103c3a:	c0 
c0103c3b:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103c42:	00 
c0103c43:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103c4a:	e8 88 d0 ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c0103c4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c56:	00 
c0103c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c5a:	89 04 24             	mov    %eax,(%esp)
c0103c5d:	e8 8c 13 00 00       	call   c0104fee <free_pages>
    free_page(p1);
c0103c62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c69:	00 
c0103c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c6d:	89 04 24             	mov    %eax,(%esp)
c0103c70:	e8 79 13 00 00       	call   c0104fee <free_pages>
    free_page(p2);
c0103c75:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c7c:	00 
c0103c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c80:	89 04 24             	mov    %eax,(%esp)
c0103c83:	e8 66 13 00 00       	call   c0104fee <free_pages>
    assert(nr_free == 3);
c0103c88:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103c8d:	83 f8 03             	cmp    $0x3,%eax
c0103c90:	74 24                	je     c0103cb6 <basic_check+0x31c>
c0103c92:	c7 44 24 0c 9b a9 10 	movl   $0xc010a99b,0xc(%esp)
c0103c99:	c0 
c0103c9a:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103ca1:	c0 
c0103ca2:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103ca9:	00 
c0103caa:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103cb1:	e8 21 d0 ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103cb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cbd:	e8 c1 12 00 00       	call   c0104f83 <alloc_pages>
c0103cc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103cc9:	75 24                	jne    c0103cef <basic_check+0x355>
c0103ccb:	c7 44 24 0c 64 a8 10 	movl   $0xc010a864,0xc(%esp)
c0103cd2:	c0 
c0103cd3:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103cda:	c0 
c0103cdb:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103ce2:	00 
c0103ce3:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103cea:	e8 e8 cf ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103cef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cf6:	e8 88 12 00 00       	call   c0104f83 <alloc_pages>
c0103cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d02:	75 24                	jne    c0103d28 <basic_check+0x38e>
c0103d04:	c7 44 24 0c 80 a8 10 	movl   $0xc010a880,0xc(%esp)
c0103d0b:	c0 
c0103d0c:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103d13:	c0 
c0103d14:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103d1b:	00 
c0103d1c:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103d23:	e8 af cf ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103d28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d2f:	e8 4f 12 00 00       	call   c0104f83 <alloc_pages>
c0103d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d3b:	75 24                	jne    c0103d61 <basic_check+0x3c7>
c0103d3d:	c7 44 24 0c 9c a8 10 	movl   $0xc010a89c,0xc(%esp)
c0103d44:	c0 
c0103d45:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103d4c:	c0 
c0103d4d:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103d54:	00 
c0103d55:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103d5c:	e8 76 cf ff ff       	call   c0100cd7 <__panic>

    assert(alloc_page() == NULL);
c0103d61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d68:	e8 16 12 00 00       	call   c0104f83 <alloc_pages>
c0103d6d:	85 c0                	test   %eax,%eax
c0103d6f:	74 24                	je     c0103d95 <basic_check+0x3fb>
c0103d71:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103d80:	c0 
c0103d81:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103d88:	00 
c0103d89:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103d90:	e8 42 cf ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c0103d95:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d9c:	00 
c0103d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103da0:	89 04 24             	mov    %eax,(%esp)
c0103da3:	e8 46 12 00 00       	call   c0104fee <free_pages>
c0103da8:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103daf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103db2:	8b 40 04             	mov    0x4(%eax),%eax
c0103db5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103db8:	0f 94 c0             	sete   %al
c0103dbb:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103dbe:	85 c0                	test   %eax,%eax
c0103dc0:	74 24                	je     c0103de6 <basic_check+0x44c>
c0103dc2:	c7 44 24 0c a8 a9 10 	movl   $0xc010a9a8,0xc(%esp)
c0103dc9:	c0 
c0103dca:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103dd1:	c0 
c0103dd2:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103dd9:	00 
c0103dda:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103de1:	e8 f1 ce ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103de6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ded:	e8 91 11 00 00       	call   c0104f83 <alloc_pages>
c0103df2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103df8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103dfb:	74 24                	je     c0103e21 <basic_check+0x487>
c0103dfd:	c7 44 24 0c c0 a9 10 	movl   $0xc010a9c0,0xc(%esp)
c0103e04:	c0 
c0103e05:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103e0c:	c0 
c0103e0d:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103e14:	00 
c0103e15:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103e1c:	e8 b6 ce ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c0103e21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e28:	e8 56 11 00 00       	call   c0104f83 <alloc_pages>
c0103e2d:	85 c0                	test   %eax,%eax
c0103e2f:	74 24                	je     c0103e55 <basic_check+0x4bb>
c0103e31:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c0103e38:	c0 
c0103e39:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103e40:	c0 
c0103e41:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103e48:	00 
c0103e49:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103e50:	e8 82 ce ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c0103e55:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103e5a:	85 c0                	test   %eax,%eax
c0103e5c:	74 24                	je     c0103e82 <basic_check+0x4e8>
c0103e5e:	c7 44 24 0c d9 a9 10 	movl   $0xc010a9d9,0xc(%esp)
c0103e65:	c0 
c0103e66:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103e6d:	c0 
c0103e6e:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103e75:	00 
c0103e76:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103e7d:	e8 55 ce ff ff       	call   c0100cd7 <__panic>
    free_list = free_list_store;
c0103e82:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e88:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103e8d:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e96:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103e9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ea2:	00 
c0103ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ea6:	89 04 24             	mov    %eax,(%esp)
c0103ea9:	e8 40 11 00 00       	call   c0104fee <free_pages>
    free_page(p1);
c0103eae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103eb5:	00 
c0103eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103eb9:	89 04 24             	mov    %eax,(%esp)
c0103ebc:	e8 2d 11 00 00       	call   c0104fee <free_pages>
    free_page(p2);
c0103ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ec8:	00 
c0103ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ecc:	89 04 24             	mov    %eax,(%esp)
c0103ecf:	e8 1a 11 00 00       	call   c0104fee <free_pages>
}
c0103ed4:	c9                   	leave  
c0103ed5:	c3                   	ret    

c0103ed6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103ed6:	55                   	push   %ebp
c0103ed7:	89 e5                	mov    %esp,%ebp
c0103ed9:	53                   	push   %ebx
c0103eda:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ee7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103eee:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ef5:	eb 6b                	jmp    c0103f62 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103efa:	83 e8 0c             	sub    $0xc,%eax
c0103efd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f03:	83 c0 04             	add    $0x4,%eax
c0103f06:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103f0d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f10:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103f13:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f16:	0f a3 10             	bt     %edx,(%eax)
c0103f19:	19 c0                	sbb    %eax,%eax
c0103f1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103f1e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103f22:	0f 95 c0             	setne  %al
c0103f25:	0f b6 c0             	movzbl %al,%eax
c0103f28:	85 c0                	test   %eax,%eax
c0103f2a:	75 24                	jne    c0103f50 <default_check+0x7a>
c0103f2c:	c7 44 24 0c e6 a9 10 	movl   $0xc010a9e6,0xc(%esp)
c0103f33:	c0 
c0103f34:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103f3b:	c0 
c0103f3c:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103f43:	00 
c0103f44:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103f4b:	e8 87 cd ff ff       	call   c0100cd7 <__panic>
        count ++, total += p->property;
c0103f50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f57:	8b 50 08             	mov    0x8(%eax),%edx
c0103f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f5d:	01 d0                	add    %edx,%eax
c0103f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103f68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f6b:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103f6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f71:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103f78:	0f 85 79 ff ff ff    	jne    c0103ef7 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103f7e:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103f81:	e8 9a 10 00 00       	call   c0105020 <nr_free_pages>
c0103f86:	39 c3                	cmp    %eax,%ebx
c0103f88:	74 24                	je     c0103fae <default_check+0xd8>
c0103f8a:	c7 44 24 0c f6 a9 10 	movl   $0xc010a9f6,0xc(%esp)
c0103f91:	c0 
c0103f92:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103f99:	c0 
c0103f9a:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103fa1:	00 
c0103fa2:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103fa9:	e8 29 cd ff ff       	call   c0100cd7 <__panic>

    basic_check();
c0103fae:	e8 e7 f9 ff ff       	call   c010399a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103fb3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103fba:	e8 c4 0f 00 00       	call   c0104f83 <alloc_pages>
c0103fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fc6:	75 24                	jne    c0103fec <default_check+0x116>
c0103fc8:	c7 44 24 0c 0f aa 10 	movl   $0xc010aa0f,0xc(%esp)
c0103fcf:	c0 
c0103fd0:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0103fd7:	c0 
c0103fd8:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103fdf:	00 
c0103fe0:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0103fe7:	e8 eb cc ff ff       	call   c0100cd7 <__panic>
    assert(!PageProperty(p0));
c0103fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fef:	83 c0 04             	add    $0x4,%eax
c0103ff2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103ff9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ffc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103fff:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104002:	0f a3 10             	bt     %edx,(%eax)
c0104005:	19 c0                	sbb    %eax,%eax
c0104007:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010400a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010400e:	0f 95 c0             	setne  %al
c0104011:	0f b6 c0             	movzbl %al,%eax
c0104014:	85 c0                	test   %eax,%eax
c0104016:	74 24                	je     c010403c <default_check+0x166>
c0104018:	c7 44 24 0c 1a aa 10 	movl   $0xc010aa1a,0xc(%esp)
c010401f:	c0 
c0104020:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104027:	c0 
c0104028:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010402f:	00 
c0104030:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104037:	e8 9b cc ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c010403c:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0104041:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0104047:	89 45 80             	mov    %eax,-0x80(%ebp)
c010404a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010404d:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104054:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104057:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010405a:	89 50 04             	mov    %edx,0x4(%eax)
c010405d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104060:	8b 50 04             	mov    0x4(%eax),%edx
c0104063:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104066:	89 10                	mov    %edx,(%eax)
c0104068:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010406f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104072:	8b 40 04             	mov    0x4(%eax),%eax
c0104075:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104078:	0f 94 c0             	sete   %al
c010407b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010407e:	85 c0                	test   %eax,%eax
c0104080:	75 24                	jne    c01040a6 <default_check+0x1d0>
c0104082:	c7 44 24 0c 6f a9 10 	movl   $0xc010a96f,0xc(%esp)
c0104089:	c0 
c010408a:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104091:	c0 
c0104092:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104099:	00 
c010409a:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01040a1:	e8 31 cc ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01040a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040ad:	e8 d1 0e 00 00       	call   c0104f83 <alloc_pages>
c01040b2:	85 c0                	test   %eax,%eax
c01040b4:	74 24                	je     c01040da <default_check+0x204>
c01040b6:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c01040bd:	c0 
c01040be:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01040c5:	c0 
c01040c6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01040cd:	00 
c01040ce:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01040d5:	e8 fd cb ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c01040da:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01040df:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01040e2:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c01040e9:	00 00 00 

    free_pages(p0 + 2, 3);
c01040ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040ef:	83 c0 40             	add    $0x40,%eax
c01040f2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040f9:	00 
c01040fa:	89 04 24             	mov    %eax,(%esp)
c01040fd:	e8 ec 0e 00 00       	call   c0104fee <free_pages>
    assert(alloc_pages(4) == NULL);
c0104102:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104109:	e8 75 0e 00 00       	call   c0104f83 <alloc_pages>
c010410e:	85 c0                	test   %eax,%eax
c0104110:	74 24                	je     c0104136 <default_check+0x260>
c0104112:	c7 44 24 0c 2c aa 10 	movl   $0xc010aa2c,0xc(%esp)
c0104119:	c0 
c010411a:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104121:	c0 
c0104122:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104129:	00 
c010412a:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104131:	e8 a1 cb ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104139:	83 c0 40             	add    $0x40,%eax
c010413c:	83 c0 04             	add    $0x4,%eax
c010413f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104146:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104149:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010414c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010414f:	0f a3 10             	bt     %edx,(%eax)
c0104152:	19 c0                	sbb    %eax,%eax
c0104154:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104157:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010415b:	0f 95 c0             	setne  %al
c010415e:	0f b6 c0             	movzbl %al,%eax
c0104161:	85 c0                	test   %eax,%eax
c0104163:	74 0e                	je     c0104173 <default_check+0x29d>
c0104165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104168:	83 c0 40             	add    $0x40,%eax
c010416b:	8b 40 08             	mov    0x8(%eax),%eax
c010416e:	83 f8 03             	cmp    $0x3,%eax
c0104171:	74 24                	je     c0104197 <default_check+0x2c1>
c0104173:	c7 44 24 0c 44 aa 10 	movl   $0xc010aa44,0xc(%esp)
c010417a:	c0 
c010417b:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104182:	c0 
c0104183:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010418a:	00 
c010418b:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104192:	e8 40 cb ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104197:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010419e:	e8 e0 0d 00 00       	call   c0104f83 <alloc_pages>
c01041a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01041a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01041aa:	75 24                	jne    c01041d0 <default_check+0x2fa>
c01041ac:	c7 44 24 0c 70 aa 10 	movl   $0xc010aa70,0xc(%esp)
c01041b3:	c0 
c01041b4:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01041bb:	c0 
c01041bc:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041c3:	00 
c01041c4:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01041cb:	e8 07 cb ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01041d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041d7:	e8 a7 0d 00 00       	call   c0104f83 <alloc_pages>
c01041dc:	85 c0                	test   %eax,%eax
c01041de:	74 24                	je     c0104204 <default_check+0x32e>
c01041e0:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c01041e7:	c0 
c01041e8:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01041ef:	c0 
c01041f0:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01041f7:	00 
c01041f8:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01041ff:	e8 d3 ca ff ff       	call   c0100cd7 <__panic>
    assert(p0 + 2 == p1);
c0104204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104207:	83 c0 40             	add    $0x40,%eax
c010420a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010420d:	74 24                	je     c0104233 <default_check+0x35d>
c010420f:	c7 44 24 0c 8e aa 10 	movl   $0xc010aa8e,0xc(%esp)
c0104216:	c0 
c0104217:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c010421e:	c0 
c010421f:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104226:	00 
c0104227:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c010422e:	e8 a4 ca ff ff       	call   c0100cd7 <__panic>

    p2 = p0 + 1;
c0104233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104236:	83 c0 20             	add    $0x20,%eax
c0104239:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010423c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104243:	00 
c0104244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104247:	89 04 24             	mov    %eax,(%esp)
c010424a:	e8 9f 0d 00 00       	call   c0104fee <free_pages>
    free_pages(p1, 3);
c010424f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104256:	00 
c0104257:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010425a:	89 04 24             	mov    %eax,(%esp)
c010425d:	e8 8c 0d 00 00       	call   c0104fee <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104265:	83 c0 04             	add    $0x4,%eax
c0104268:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010426f:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104272:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104275:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104278:	0f a3 10             	bt     %edx,(%eax)
c010427b:	19 c0                	sbb    %eax,%eax
c010427d:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104280:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104284:	0f 95 c0             	setne  %al
c0104287:	0f b6 c0             	movzbl %al,%eax
c010428a:	85 c0                	test   %eax,%eax
c010428c:	74 0b                	je     c0104299 <default_check+0x3c3>
c010428e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104291:	8b 40 08             	mov    0x8(%eax),%eax
c0104294:	83 f8 01             	cmp    $0x1,%eax
c0104297:	74 24                	je     c01042bd <default_check+0x3e7>
c0104299:	c7 44 24 0c 9c aa 10 	movl   $0xc010aa9c,0xc(%esp)
c01042a0:	c0 
c01042a1:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01042a8:	c0 
c01042a9:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01042b0:	00 
c01042b1:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01042b8:	e8 1a ca ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01042bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042c0:	83 c0 04             	add    $0x4,%eax
c01042c3:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01042ca:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042cd:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042d0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042d3:	0f a3 10             	bt     %edx,(%eax)
c01042d6:	19 c0                	sbb    %eax,%eax
c01042d8:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01042db:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01042df:	0f 95 c0             	setne  %al
c01042e2:	0f b6 c0             	movzbl %al,%eax
c01042e5:	85 c0                	test   %eax,%eax
c01042e7:	74 0b                	je     c01042f4 <default_check+0x41e>
c01042e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042ec:	8b 40 08             	mov    0x8(%eax),%eax
c01042ef:	83 f8 03             	cmp    $0x3,%eax
c01042f2:	74 24                	je     c0104318 <default_check+0x442>
c01042f4:	c7 44 24 0c c4 aa 10 	movl   $0xc010aac4,0xc(%esp)
c01042fb:	c0 
c01042fc:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104303:	c0 
c0104304:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010430b:	00 
c010430c:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104313:	e8 bf c9 ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010431f:	e8 5f 0c 00 00       	call   c0104f83 <alloc_pages>
c0104324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104327:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010432a:	83 e8 20             	sub    $0x20,%eax
c010432d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104330:	74 24                	je     c0104356 <default_check+0x480>
c0104332:	c7 44 24 0c ea aa 10 	movl   $0xc010aaea,0xc(%esp)
c0104339:	c0 
c010433a:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104341:	c0 
c0104342:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104349:	00 
c010434a:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104351:	e8 81 c9 ff ff       	call   c0100cd7 <__panic>
    free_page(p0);
c0104356:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010435d:	00 
c010435e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104361:	89 04 24             	mov    %eax,(%esp)
c0104364:	e8 85 0c 00 00       	call   c0104fee <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104369:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104370:	e8 0e 0c 00 00       	call   c0104f83 <alloc_pages>
c0104375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104378:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010437b:	83 c0 20             	add    $0x20,%eax
c010437e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104381:	74 24                	je     c01043a7 <default_check+0x4d1>
c0104383:	c7 44 24 0c 08 ab 10 	movl   $0xc010ab08,0xc(%esp)
c010438a:	c0 
c010438b:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104392:	c0 
c0104393:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c010439a:	00 
c010439b:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01043a2:	e8 30 c9 ff ff       	call   c0100cd7 <__panic>

    free_pages(p0, 2);
c01043a7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01043ae:	00 
c01043af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043b2:	89 04 24             	mov    %eax,(%esp)
c01043b5:	e8 34 0c 00 00       	call   c0104fee <free_pages>
    free_page(p2);
c01043ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043c1:	00 
c01043c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043c5:	89 04 24             	mov    %eax,(%esp)
c01043c8:	e8 21 0c 00 00       	call   c0104fee <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01043cd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01043d4:	e8 aa 0b 00 00       	call   c0104f83 <alloc_pages>
c01043d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043e0:	75 24                	jne    c0104406 <default_check+0x530>
c01043e2:	c7 44 24 0c 28 ab 10 	movl   $0xc010ab28,0xc(%esp)
c01043e9:	c0 
c01043ea:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01043f1:	c0 
c01043f2:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01043f9:	00 
c01043fa:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104401:	e8 d1 c8 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c0104406:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010440d:	e8 71 0b 00 00       	call   c0104f83 <alloc_pages>
c0104412:	85 c0                	test   %eax,%eax
c0104414:	74 24                	je     c010443a <default_check+0x564>
c0104416:	c7 44 24 0c 86 a9 10 	movl   $0xc010a986,0xc(%esp)
c010441d:	c0 
c010441e:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104425:	c0 
c0104426:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010442d:	00 
c010442e:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104435:	e8 9d c8 ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c010443a:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010443f:	85 c0                	test   %eax,%eax
c0104441:	74 24                	je     c0104467 <default_check+0x591>
c0104443:	c7 44 24 0c d9 a9 10 	movl   $0xc010a9d9,0xc(%esp)
c010444a:	c0 
c010444b:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104452:	c0 
c0104453:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010445a:	00 
c010445b:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104462:	e8 70 c8 ff ff       	call   c0100cd7 <__panic>
    nr_free = nr_free_store;
c0104467:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010446a:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c010446f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104472:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104475:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c010447a:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c0104480:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104487:	00 
c0104488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010448b:	89 04 24             	mov    %eax,(%esp)
c010448e:	e8 5b 0b 00 00       	call   c0104fee <free_pages>

    le = &free_list;
c0104493:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010449a:	eb 1d                	jmp    c01044b9 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010449c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010449f:	83 e8 0c             	sub    $0xc,%eax
c01044a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01044a5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01044a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01044ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01044af:	8b 40 08             	mov    0x8(%eax),%eax
c01044b2:	29 c2                	sub    %eax,%edx
c01044b4:	89 d0                	mov    %edx,%eax
c01044b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044bc:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01044bf:	8b 45 88             	mov    -0x78(%ebp),%eax
c01044c2:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01044c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044c8:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c01044cf:	75 cb                	jne    c010449c <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01044d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d5:	74 24                	je     c01044fb <default_check+0x625>
c01044d7:	c7 44 24 0c 46 ab 10 	movl   $0xc010ab46,0xc(%esp)
c01044de:	c0 
c01044df:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c01044e6:	c0 
c01044e7:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01044ee:	00 
c01044ef:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c01044f6:	e8 dc c7 ff ff       	call   c0100cd7 <__panic>
    assert(total == 0);
c01044fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044ff:	74 24                	je     c0104525 <default_check+0x64f>
c0104501:	c7 44 24 0c 51 ab 10 	movl   $0xc010ab51,0xc(%esp)
c0104508:	c0 
c0104509:	c7 44 24 08 16 a8 10 	movl   $0xc010a816,0x8(%esp)
c0104510:	c0 
c0104511:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0104518:	00 
c0104519:	c7 04 24 2b a8 10 c0 	movl   $0xc010a82b,(%esp)
c0104520:	e8 b2 c7 ff ff       	call   c0100cd7 <__panic>
}
c0104525:	81 c4 94 00 00 00    	add    $0x94,%esp
c010452b:	5b                   	pop    %ebx
c010452c:	5d                   	pop    %ebp
c010452d:	c3                   	ret    

c010452e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010452e:	55                   	push   %ebp
c010452f:	89 e5                	mov    %esp,%ebp
c0104531:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104534:	9c                   	pushf  
c0104535:	58                   	pop    %eax
c0104536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010453c:	25 00 02 00 00       	and    $0x200,%eax
c0104541:	85 c0                	test   %eax,%eax
c0104543:	74 0c                	je     c0104551 <__intr_save+0x23>
        intr_disable();
c0104545:	e8 e5 d9 ff ff       	call   c0101f2f <intr_disable>
        return 1;
c010454a:	b8 01 00 00 00       	mov    $0x1,%eax
c010454f:	eb 05                	jmp    c0104556 <__intr_save+0x28>
    }
    return 0;
c0104551:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104556:	c9                   	leave  
c0104557:	c3                   	ret    

c0104558 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104558:	55                   	push   %ebp
c0104559:	89 e5                	mov    %esp,%ebp
c010455b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010455e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104562:	74 05                	je     c0104569 <__intr_restore+0x11>
        intr_enable();
c0104564:	e8 c0 d9 ff ff       	call   c0101f29 <intr_enable>
    }
}
c0104569:	c9                   	leave  
c010456a:	c3                   	ret    

c010456b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010456b:	55                   	push   %ebp
c010456c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010456e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104571:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104576:	29 c2                	sub    %eax,%edx
c0104578:	89 d0                	mov    %edx,%eax
c010457a:	c1 f8 05             	sar    $0x5,%eax
}
c010457d:	5d                   	pop    %ebp
c010457e:	c3                   	ret    

c010457f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010457f:	55                   	push   %ebp
c0104580:	89 e5                	mov    %esp,%ebp
c0104582:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104585:	8b 45 08             	mov    0x8(%ebp),%eax
c0104588:	89 04 24             	mov    %eax,(%esp)
c010458b:	e8 db ff ff ff       	call   c010456b <page2ppn>
c0104590:	c1 e0 0c             	shl    $0xc,%eax
}
c0104593:	c9                   	leave  
c0104594:	c3                   	ret    

c0104595 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104595:	55                   	push   %ebp
c0104596:	89 e5                	mov    %esp,%ebp
c0104598:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010459b:	8b 45 08             	mov    0x8(%ebp),%eax
c010459e:	c1 e8 0c             	shr    $0xc,%eax
c01045a1:	89 c2                	mov    %eax,%edx
c01045a3:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01045a8:	39 c2                	cmp    %eax,%edx
c01045aa:	72 1c                	jb     c01045c8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01045ac:	c7 44 24 08 8c ab 10 	movl   $0xc010ab8c,0x8(%esp)
c01045b3:	c0 
c01045b4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01045bb:	00 
c01045bc:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01045c3:	e8 0f c7 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c01045c8:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01045cd:	8b 55 08             	mov    0x8(%ebp),%edx
c01045d0:	c1 ea 0c             	shr    $0xc,%edx
c01045d3:	c1 e2 05             	shl    $0x5,%edx
c01045d6:	01 d0                	add    %edx,%eax
}
c01045d8:	c9                   	leave  
c01045d9:	c3                   	ret    

c01045da <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01045da:	55                   	push   %ebp
c01045db:	89 e5                	mov    %esp,%ebp
c01045dd:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01045e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e3:	89 04 24             	mov    %eax,(%esp)
c01045e6:	e8 94 ff ff ff       	call   c010457f <page2pa>
c01045eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f1:	c1 e8 0c             	shr    $0xc,%eax
c01045f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045f7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01045fc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01045ff:	72 23                	jb     c0104624 <page2kva+0x4a>
c0104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104604:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104608:	c7 44 24 08 bc ab 10 	movl   $0xc010abbc,0x8(%esp)
c010460f:	c0 
c0104610:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104617:	00 
c0104618:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c010461f:	e8 b3 c6 ff ff       	call   c0100cd7 <__panic>
c0104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104627:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010462c:	c9                   	leave  
c010462d:	c3                   	ret    

c010462e <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010462e:	55                   	push   %ebp
c010462f:	89 e5                	mov    %esp,%ebp
c0104631:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104634:	8b 45 08             	mov    0x8(%ebp),%eax
c0104637:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010463a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104641:	77 23                	ja     c0104666 <kva2page+0x38>
c0104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104646:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010464a:	c7 44 24 08 e0 ab 10 	movl   $0xc010abe0,0x8(%esp)
c0104651:	c0 
c0104652:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104659:	00 
c010465a:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0104661:	e8 71 c6 ff ff       	call   c0100cd7 <__panic>
c0104666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104669:	05 00 00 00 40       	add    $0x40000000,%eax
c010466e:	89 04 24             	mov    %eax,(%esp)
c0104671:	e8 1f ff ff ff       	call   c0104595 <pa2page>
}
c0104676:	c9                   	leave  
c0104677:	c3                   	ret    

c0104678 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104678:	55                   	push   %ebp
c0104679:	89 e5                	mov    %esp,%ebp
c010467b:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010467e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104681:	ba 01 00 00 00       	mov    $0x1,%edx
c0104686:	89 c1                	mov    %eax,%ecx
c0104688:	d3 e2                	shl    %cl,%edx
c010468a:	89 d0                	mov    %edx,%eax
c010468c:	89 04 24             	mov    %eax,(%esp)
c010468f:	e8 ef 08 00 00       	call   c0104f83 <alloc_pages>
c0104694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010469b:	75 07                	jne    c01046a4 <__slob_get_free_pages+0x2c>
    return NULL;
c010469d:	b8 00 00 00 00       	mov    $0x0,%eax
c01046a2:	eb 0b                	jmp    c01046af <__slob_get_free_pages+0x37>
  return page2kva(page);
c01046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a7:	89 04 24             	mov    %eax,(%esp)
c01046aa:	e8 2b ff ff ff       	call   c01045da <page2kva>
}
c01046af:	c9                   	leave  
c01046b0:	c3                   	ret    

c01046b1 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c01046b1:	55                   	push   %ebp
c01046b2:	89 e5                	mov    %esp,%ebp
c01046b4:	53                   	push   %ebx
c01046b5:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c01046b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046bb:	ba 01 00 00 00       	mov    $0x1,%edx
c01046c0:	89 c1                	mov    %eax,%ecx
c01046c2:	d3 e2                	shl    %cl,%edx
c01046c4:	89 d0                	mov    %edx,%eax
c01046c6:	89 c3                	mov    %eax,%ebx
c01046c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046cb:	89 04 24             	mov    %eax,(%esp)
c01046ce:	e8 5b ff ff ff       	call   c010462e <kva2page>
c01046d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01046d7:	89 04 24             	mov    %eax,(%esp)
c01046da:	e8 0f 09 00 00       	call   c0104fee <free_pages>
}
c01046df:	83 c4 14             	add    $0x14,%esp
c01046e2:	5b                   	pop    %ebx
c01046e3:	5d                   	pop    %ebp
c01046e4:	c3                   	ret    

c01046e5 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01046e5:	55                   	push   %ebp
c01046e6:	89 e5                	mov    %esp,%ebp
c01046e8:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01046eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ee:	83 c0 08             	add    $0x8,%eax
c01046f1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01046f6:	76 24                	jbe    c010471c <slob_alloc+0x37>
c01046f8:	c7 44 24 0c 04 ac 10 	movl   $0xc010ac04,0xc(%esp)
c01046ff:	c0 
c0104700:	c7 44 24 08 23 ac 10 	movl   $0xc010ac23,0x8(%esp)
c0104707:	c0 
c0104708:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010470f:	00 
c0104710:	c7 04 24 38 ac 10 c0 	movl   $0xc010ac38,(%esp)
c0104717:	e8 bb c5 ff ff       	call   c0100cd7 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c010471c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104723:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010472a:	8b 45 08             	mov    0x8(%ebp),%eax
c010472d:	83 c0 07             	add    $0x7,%eax
c0104730:	c1 e8 03             	shr    $0x3,%eax
c0104733:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104736:	e8 f3 fd ff ff       	call   c010452e <__intr_save>
c010473b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010473e:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104743:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104749:	8b 40 04             	mov    0x4(%eax),%eax
c010474c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c010474f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104753:	74 25                	je     c010477a <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104755:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104758:	8b 45 10             	mov    0x10(%ebp),%eax
c010475b:	01 d0                	add    %edx,%eax
c010475d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104760:	8b 45 10             	mov    0x10(%ebp),%eax
c0104763:	f7 d8                	neg    %eax
c0104765:	21 d0                	and    %edx,%eax
c0104767:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c010476a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010476d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104770:	29 c2                	sub    %eax,%edx
c0104772:	89 d0                	mov    %edx,%eax
c0104774:	c1 f8 03             	sar    $0x3,%eax
c0104777:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c010477a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477d:	8b 00                	mov    (%eax),%eax
c010477f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104782:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104785:	01 ca                	add    %ecx,%edx
c0104787:	39 d0                	cmp    %edx,%eax
c0104789:	0f 8c aa 00 00 00    	jl     c0104839 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010478f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104793:	74 38                	je     c01047cd <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104795:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104798:	8b 00                	mov    (%eax),%eax
c010479a:	2b 45 e8             	sub    -0x18(%ebp),%eax
c010479d:	89 c2                	mov    %eax,%edx
c010479f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a2:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c01047a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a7:	8b 50 04             	mov    0x4(%eax),%edx
c01047aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ad:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c01047b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01047b6:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c01047b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01047bf:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01047c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01047c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01047cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047d0:	8b 00                	mov    (%eax),%eax
c01047d2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01047d5:	75 0e                	jne    c01047e5 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c01047d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047da:	8b 50 04             	mov    0x4(%eax),%edx
c01047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e0:	89 50 04             	mov    %edx,0x4(%eax)
c01047e3:	eb 3c                	jmp    c0104821 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c01047e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01047ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f2:	01 c2                	add    %eax,%edx
c01047f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f7:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fd:	8b 40 04             	mov    0x4(%eax),%eax
c0104800:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104803:	8b 12                	mov    (%edx),%edx
c0104805:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104808:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480d:	8b 40 04             	mov    0x4(%eax),%eax
c0104810:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104813:	8b 52 04             	mov    0x4(%edx),%edx
c0104816:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010481c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010481f:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104824:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010482c:	89 04 24             	mov    %eax,(%esp)
c010482f:	e8 24 fd ff ff       	call   c0104558 <__intr_restore>
			return cur;
c0104834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104837:	eb 7f                	jmp    c01048b8 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104839:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010483e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104841:	75 61                	jne    c01048a4 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104846:	89 04 24             	mov    %eax,(%esp)
c0104849:	e8 0a fd ff ff       	call   c0104558 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c010484e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104855:	75 07                	jne    c010485e <slob_alloc+0x179>
				return 0;
c0104857:	b8 00 00 00 00       	mov    $0x0,%eax
c010485c:	eb 5a                	jmp    c01048b8 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010485e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104865:	00 
c0104866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104869:	89 04 24             	mov    %eax,(%esp)
c010486c:	e8 07 fe ff ff       	call   c0104678 <__slob_get_free_pages>
c0104871:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104878:	75 07                	jne    c0104881 <slob_alloc+0x19c>
				return 0;
c010487a:	b8 00 00 00 00       	mov    $0x0,%eax
c010487f:	eb 37                	jmp    c01048b8 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104881:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104888:	00 
c0104889:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010488c:	89 04 24             	mov    %eax,(%esp)
c010488f:	e8 26 00 00 00       	call   c01048ba <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104894:	e8 95 fc ff ff       	call   c010452e <__intr_save>
c0104899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c010489c:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01048a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01048a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ad:	8b 40 04             	mov    0x4(%eax),%eax
c01048b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c01048b3:	e9 97 fe ff ff       	jmp    c010474f <slob_alloc+0x6a>
}
c01048b8:	c9                   	leave  
c01048b9:	c3                   	ret    

c01048ba <slob_free>:

static void slob_free(void *block, int size)
{
c01048ba:	55                   	push   %ebp
c01048bb:	89 e5                	mov    %esp,%ebp
c01048bd:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c01048c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01048c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01048ca:	75 05                	jne    c01048d1 <slob_free+0x17>
		return;
c01048cc:	e9 ff 00 00 00       	jmp    c01049d0 <slob_free+0x116>

	if (size)
c01048d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01048d5:	74 10                	je     c01048e7 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c01048d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048da:	83 c0 07             	add    $0x7,%eax
c01048dd:	c1 e8 03             	shr    $0x3,%eax
c01048e0:	89 c2                	mov    %eax,%edx
c01048e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e5:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c01048e7:	e8 42 fc ff ff       	call   c010452e <__intr_save>
c01048ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01048ef:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01048f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048f7:	eb 27                	jmp    c0104920 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01048f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048fc:	8b 40 04             	mov    0x4(%eax),%eax
c01048ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104902:	77 13                	ja     c0104917 <slob_free+0x5d>
c0104904:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104907:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010490a:	77 27                	ja     c0104933 <slob_free+0x79>
c010490c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010490f:	8b 40 04             	mov    0x4(%eax),%eax
c0104912:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104915:	77 1c                	ja     c0104933 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104917:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010491a:	8b 40 04             	mov    0x4(%eax),%eax
c010491d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104920:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104923:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104926:	76 d1                	jbe    c01048f9 <slob_free+0x3f>
c0104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492b:	8b 40 04             	mov    0x4(%eax),%eax
c010492e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104931:	76 c6                	jbe    c01048f9 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104933:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104936:	8b 00                	mov    (%eax),%eax
c0104938:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010493f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104942:	01 c2                	add    %eax,%edx
c0104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104947:	8b 40 04             	mov    0x4(%eax),%eax
c010494a:	39 c2                	cmp    %eax,%edx
c010494c:	75 25                	jne    c0104973 <slob_free+0xb9>
		b->units += cur->next->units;
c010494e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104951:	8b 10                	mov    (%eax),%edx
c0104953:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104956:	8b 40 04             	mov    0x4(%eax),%eax
c0104959:	8b 00                	mov    (%eax),%eax
c010495b:	01 c2                	add    %eax,%edx
c010495d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104960:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104965:	8b 40 04             	mov    0x4(%eax),%eax
c0104968:	8b 50 04             	mov    0x4(%eax),%edx
c010496b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496e:	89 50 04             	mov    %edx,0x4(%eax)
c0104971:	eb 0c                	jmp    c010497f <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104976:	8b 50 04             	mov    0x4(%eax),%edx
c0104979:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497c:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c010497f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104982:	8b 00                	mov    (%eax),%eax
c0104984:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010498b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498e:	01 d0                	add    %edx,%eax
c0104990:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104993:	75 1f                	jne    c01049b4 <slob_free+0xfa>
		cur->units += b->units;
c0104995:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104998:	8b 10                	mov    (%eax),%edx
c010499a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499d:	8b 00                	mov    (%eax),%eax
c010499f:	01 c2                	add    %eax,%edx
c01049a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a4:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c01049a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a9:	8b 50 04             	mov    0x4(%eax),%edx
c01049ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049af:	89 50 04             	mov    %edx,0x4(%eax)
c01049b2:	eb 09                	jmp    c01049bd <slob_free+0x103>
	} else
		cur->next = b;
c01049b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049ba:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c01049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c0:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01049c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049c8:	89 04 24             	mov    %eax,(%esp)
c01049cb:	e8 88 fb ff ff       	call   c0104558 <__intr_restore>
}
c01049d0:	c9                   	leave  
c01049d1:	c3                   	ret    

c01049d2 <slob_init>:



void
slob_init(void) {
c01049d2:	55                   	push   %ebp
c01049d3:	89 e5                	mov    %esp,%ebp
c01049d5:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01049d8:	c7 04 24 4a ac 10 c0 	movl   $0xc010ac4a,(%esp)
c01049df:	e8 6f b9 ff ff       	call   c0100353 <cprintf>
}
c01049e4:	c9                   	leave  
c01049e5:	c3                   	ret    

c01049e6 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c01049e6:	55                   	push   %ebp
c01049e7:	89 e5                	mov    %esp,%ebp
c01049e9:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c01049ec:	e8 e1 ff ff ff       	call   c01049d2 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c01049f1:	c7 04 24 5e ac 10 c0 	movl   $0xc010ac5e,(%esp)
c01049f8:	e8 56 b9 ff ff       	call   c0100353 <cprintf>
}
c01049fd:	c9                   	leave  
c01049fe:	c3                   	ret    

c01049ff <slob_allocated>:

size_t
slob_allocated(void) {
c01049ff:	55                   	push   %ebp
c0104a00:	89 e5                	mov    %esp,%ebp
  return 0;
c0104a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a07:	5d                   	pop    %ebp
c0104a08:	c3                   	ret    

c0104a09 <kallocated>:

size_t
kallocated(void) {
c0104a09:	55                   	push   %ebp
c0104a0a:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104a0c:	e8 ee ff ff ff       	call   c01049ff <slob_allocated>
}
c0104a11:	5d                   	pop    %ebp
c0104a12:	c3                   	ret    

c0104a13 <find_order>:

static int find_order(int size)
{
c0104a13:	55                   	push   %ebp
c0104a14:	89 e5                	mov    %esp,%ebp
c0104a16:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104a19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104a20:	eb 07                	jmp    c0104a29 <find_order+0x16>
		order++;
c0104a22:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104a26:	d1 7d 08             	sarl   0x8(%ebp)
c0104a29:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104a30:	7f f0                	jg     c0104a22 <find_order+0xf>
		order++;
	return order;
c0104a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104a35:	c9                   	leave  
c0104a36:	c3                   	ret    

c0104a37 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104a37:	55                   	push   %ebp
c0104a38:	89 e5                	mov    %esp,%ebp
c0104a3a:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104a3d:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104a44:	77 38                	ja     c0104a7e <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a49:	8d 50 08             	lea    0x8(%eax),%edx
c0104a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a53:	00 
c0104a54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a5b:	89 14 24             	mov    %edx,(%esp)
c0104a5e:	e8 82 fc ff ff       	call   c01046e5 <slob_alloc>
c0104a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a6a:	74 08                	je     c0104a74 <__kmalloc+0x3d>
c0104a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a6f:	83 c0 08             	add    $0x8,%eax
c0104a72:	eb 05                	jmp    c0104a79 <__kmalloc+0x42>
c0104a74:	b8 00 00 00 00       	mov    $0x0,%eax
c0104a79:	e9 a6 00 00 00       	jmp    c0104b24 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104a7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a85:	00 
c0104a86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a8d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104a94:	e8 4c fc ff ff       	call   c01046e5 <slob_alloc>
c0104a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104aa0:	75 07                	jne    c0104aa9 <__kmalloc+0x72>
		return 0;
c0104aa2:	b8 00 00 00 00       	mov    $0x0,%eax
c0104aa7:	eb 7b                	jmp    c0104b24 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aac:	89 04 24             	mov    %eax,(%esp)
c0104aaf:	e8 5f ff ff ff       	call   c0104a13 <find_order>
c0104ab4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ab7:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abc:	8b 00                	mov    (%eax),%eax
c0104abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ac5:	89 04 24             	mov    %eax,(%esp)
c0104ac8:	e8 ab fb ff ff       	call   c0104678 <__slob_get_free_pages>
c0104acd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ad0:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ad9:	85 c0                	test   %eax,%eax
c0104adb:	74 2f                	je     c0104b0c <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104add:	e8 4c fa ff ff       	call   c010452e <__intr_save>
c0104ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104ae5:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c0104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aee:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af4:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c0104af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104afc:	89 04 24             	mov    %eax,(%esp)
c0104aff:	e8 54 fa ff ff       	call   c0104558 <__intr_restore>
		return bb->pages;
c0104b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b07:	8b 40 04             	mov    0x4(%eax),%eax
c0104b0a:	eb 18                	jmp    c0104b24 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104b0c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104b13:	00 
c0104b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b17:	89 04 24             	mov    %eax,(%esp)
c0104b1a:	e8 9b fd ff ff       	call   c01048ba <slob_free>
	return 0;
c0104b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b24:	c9                   	leave  
c0104b25:	c3                   	ret    

c0104b26 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104b26:	55                   	push   %ebp
c0104b27:	89 e5                	mov    %esp,%ebp
c0104b29:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104b2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b33:	00 
c0104b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b37:	89 04 24             	mov    %eax,(%esp)
c0104b3a:	e8 f8 fe ff ff       	call   c0104a37 <__kmalloc>
}
c0104b3f:	c9                   	leave  
c0104b40:	c3                   	ret    

c0104b41 <kfree>:


void kfree(void *block)
{
c0104b41:	55                   	push   %ebp
c0104b42:	89 e5                	mov    %esp,%ebp
c0104b44:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104b47:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b52:	75 05                	jne    c0104b59 <kfree+0x18>
		return;
c0104b54:	e9 a2 00 00 00       	jmp    c0104bfb <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b5c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b61:	85 c0                	test   %eax,%eax
c0104b63:	75 7f                	jne    c0104be4 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104b65:	e8 c4 f9 ff ff       	call   c010452e <__intr_save>
c0104b6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104b6d:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b75:	eb 5c                	jmp    c0104bd3 <kfree+0x92>
			if (bb->pages == block) {
c0104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7a:	8b 40 04             	mov    0x4(%eax),%eax
c0104b7d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b80:	75 3f                	jne    c0104bc1 <kfree+0x80>
				*last = bb->next;
c0104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b85:	8b 50 08             	mov    0x8(%eax),%edx
c0104b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8b:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b90:	89 04 24             	mov    %eax,(%esp)
c0104b93:	e8 c0 f9 ff ff       	call   c0104558 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b9b:	8b 10                	mov    (%eax),%edx
c0104b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ba4:	89 04 24             	mov    %eax,(%esp)
c0104ba7:	e8 05 fb ff ff       	call   c01046b1 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104bac:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104bb3:	00 
c0104bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb7:	89 04 24             	mov    %eax,(%esp)
c0104bba:	e8 fb fc ff ff       	call   c01048ba <slob_free>
				return;
c0104bbf:	eb 3a                	jmp    c0104bfb <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc4:	83 c0 08             	add    $0x8,%eax
c0104bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bcd:	8b 40 08             	mov    0x8(%eax),%eax
c0104bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bd7:	75 9e                	jne    c0104b77 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bdc:	89 04 24             	mov    %eax,(%esp)
c0104bdf:	e8 74 f9 ff ff       	call   c0104558 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be7:	83 e8 08             	sub    $0x8,%eax
c0104bea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104bf1:	00 
c0104bf2:	89 04 24             	mov    %eax,(%esp)
c0104bf5:	e8 c0 fc ff ff       	call   c01048ba <slob_free>
	return;
c0104bfa:	90                   	nop
}
c0104bfb:	c9                   	leave  
c0104bfc:	c3                   	ret    

c0104bfd <ksize>:


unsigned int ksize(const void *block)
{
c0104bfd:	55                   	push   %ebp
c0104bfe:	89 e5                	mov    %esp,%ebp
c0104c00:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104c07:	75 07                	jne    c0104c10 <ksize+0x13>
		return 0;
c0104c09:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c0e:	eb 6b                	jmp    c0104c7b <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c13:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c18:	85 c0                	test   %eax,%eax
c0104c1a:	75 54                	jne    c0104c70 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104c1c:	e8 0d f9 ff ff       	call   c010452e <__intr_save>
c0104c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104c24:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c2c:	eb 31                	jmp    c0104c5f <ksize+0x62>
			if (bb->pages == block) {
c0104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c31:	8b 40 04             	mov    0x4(%eax),%eax
c0104c34:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104c37:	75 1d                	jne    c0104c56 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c3c:	89 04 24             	mov    %eax,(%esp)
c0104c3f:	e8 14 f9 ff ff       	call   c0104558 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c47:	8b 00                	mov    (%eax),%eax
c0104c49:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104c4e:	89 c1                	mov    %eax,%ecx
c0104c50:	d3 e2                	shl    %cl,%edx
c0104c52:	89 d0                	mov    %edx,%eax
c0104c54:	eb 25                	jmp    c0104c7b <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c59:	8b 40 08             	mov    0x8(%eax),%eax
c0104c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c63:	75 c9                	jne    c0104c2e <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c68:	89 04 24             	mov    %eax,(%esp)
c0104c6b:	e8 e8 f8 ff ff       	call   c0104558 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c73:	83 e8 08             	sub    $0x8,%eax
c0104c76:	8b 00                	mov    (%eax),%eax
c0104c78:	c1 e0 03             	shl    $0x3,%eax
}
c0104c7b:	c9                   	leave  
c0104c7c:	c3                   	ret    

c0104c7d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104c7d:	55                   	push   %ebp
c0104c7e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104c80:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c83:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104c88:	29 c2                	sub    %eax,%edx
c0104c8a:	89 d0                	mov    %edx,%eax
c0104c8c:	c1 f8 05             	sar    $0x5,%eax
}
c0104c8f:	5d                   	pop    %ebp
c0104c90:	c3                   	ret    

c0104c91 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104c91:	55                   	push   %ebp
c0104c92:	89 e5                	mov    %esp,%ebp
c0104c94:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9a:	89 04 24             	mov    %eax,(%esp)
c0104c9d:	e8 db ff ff ff       	call   c0104c7d <page2ppn>
c0104ca2:	c1 e0 0c             	shl    $0xc,%eax
}
c0104ca5:	c9                   	leave  
c0104ca6:	c3                   	ret    

c0104ca7 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104ca7:	55                   	push   %ebp
c0104ca8:	89 e5                	mov    %esp,%ebp
c0104caa:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cb0:	c1 e8 0c             	shr    $0xc,%eax
c0104cb3:	89 c2                	mov    %eax,%edx
c0104cb5:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104cba:	39 c2                	cmp    %eax,%edx
c0104cbc:	72 1c                	jb     c0104cda <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104cbe:	c7 44 24 08 7c ac 10 	movl   $0xc010ac7c,0x8(%esp)
c0104cc5:	c0 
c0104cc6:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104ccd:	00 
c0104cce:	c7 04 24 9b ac 10 c0 	movl   $0xc010ac9b,(%esp)
c0104cd5:	e8 fd bf ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c0104cda:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104cdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ce2:	c1 ea 0c             	shr    $0xc,%edx
c0104ce5:	c1 e2 05             	shl    $0x5,%edx
c0104ce8:	01 d0                	add    %edx,%eax
}
c0104cea:	c9                   	leave  
c0104ceb:	c3                   	ret    

c0104cec <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104cec:	55                   	push   %ebp
c0104ced:	89 e5                	mov    %esp,%ebp
c0104cef:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cf5:	89 04 24             	mov    %eax,(%esp)
c0104cf8:	e8 94 ff ff ff       	call   c0104c91 <page2pa>
c0104cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d03:	c1 e8 0c             	shr    $0xc,%eax
c0104d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d09:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104d0e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104d11:	72 23                	jb     c0104d36 <page2kva+0x4a>
c0104d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d16:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d1a:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c0104d21:	c0 
c0104d22:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104d29:	00 
c0104d2a:	c7 04 24 9b ac 10 c0 	movl   $0xc010ac9b,(%esp)
c0104d31:	e8 a1 bf ff ff       	call   c0100cd7 <__panic>
c0104d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d39:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104d3e:	c9                   	leave  
c0104d3f:	c3                   	ret    

c0104d40 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104d40:	55                   	push   %ebp
c0104d41:	89 e5                	mov    %esp,%ebp
c0104d43:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d49:	83 e0 01             	and    $0x1,%eax
c0104d4c:	85 c0                	test   %eax,%eax
c0104d4e:	75 1c                	jne    c0104d6c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104d50:	c7 44 24 08 d0 ac 10 	movl   $0xc010acd0,0x8(%esp)
c0104d57:	c0 
c0104d58:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104d5f:	00 
c0104d60:	c7 04 24 9b ac 10 c0 	movl   $0xc010ac9b,(%esp)
c0104d67:	e8 6b bf ff ff       	call   c0100cd7 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d74:	89 04 24             	mov    %eax,(%esp)
c0104d77:	e8 2b ff ff ff       	call   c0104ca7 <pa2page>
}
c0104d7c:	c9                   	leave  
c0104d7d:	c3                   	ret    

c0104d7e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104d7e:	55                   	push   %ebp
c0104d7f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d84:	8b 00                	mov    (%eax),%eax
}
c0104d86:	5d                   	pop    %ebp
c0104d87:	c3                   	ret    

c0104d88 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104d88:	55                   	push   %ebp
c0104d89:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d91:	89 10                	mov    %edx,(%eax)
}
c0104d93:	5d                   	pop    %ebp
c0104d94:	c3                   	ret    

c0104d95 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104d95:	55                   	push   %ebp
c0104d96:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104d98:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d9b:	8b 00                	mov    (%eax),%eax
c0104d9d:	8d 50 01             	lea    0x1(%eax),%edx
c0104da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da3:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da8:	8b 00                	mov    (%eax),%eax
}
c0104daa:	5d                   	pop    %ebp
c0104dab:	c3                   	ret    

c0104dac <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104dac:	55                   	push   %ebp
c0104dad:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db2:	8b 00                	mov    (%eax),%eax
c0104db4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dba:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dbf:	8b 00                	mov    (%eax),%eax
}
c0104dc1:	5d                   	pop    %ebp
c0104dc2:	c3                   	ret    

c0104dc3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104dc3:	55                   	push   %ebp
c0104dc4:	89 e5                	mov    %esp,%ebp
c0104dc6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104dc9:	9c                   	pushf  
c0104dca:	58                   	pop    %eax
c0104dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104dd1:	25 00 02 00 00       	and    $0x200,%eax
c0104dd6:	85 c0                	test   %eax,%eax
c0104dd8:	74 0c                	je     c0104de6 <__intr_save+0x23>
        intr_disable();
c0104dda:	e8 50 d1 ff ff       	call   c0101f2f <intr_disable>
        return 1;
c0104ddf:	b8 01 00 00 00       	mov    $0x1,%eax
c0104de4:	eb 05                	jmp    c0104deb <__intr_save+0x28>
    }
    return 0;
c0104de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104deb:	c9                   	leave  
c0104dec:	c3                   	ret    

c0104ded <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104ded:	55                   	push   %ebp
c0104dee:	89 e5                	mov    %esp,%ebp
c0104df0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104df3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104df7:	74 05                	je     c0104dfe <__intr_restore+0x11>
        intr_enable();
c0104df9:	e8 2b d1 ff ff       	call   c0101f29 <intr_enable>
    }
}
c0104dfe:	c9                   	leave  
c0104dff:	c3                   	ret    

c0104e00 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104e00:	55                   	push   %ebp
c0104e01:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e06:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104e09:	b8 23 00 00 00       	mov    $0x23,%eax
c0104e0e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104e10:	b8 23 00 00 00       	mov    $0x23,%eax
c0104e15:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104e17:	b8 10 00 00 00       	mov    $0x10,%eax
c0104e1c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104e1e:	b8 10 00 00 00       	mov    $0x10,%eax
c0104e23:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104e25:	b8 10 00 00 00       	mov    $0x10,%eax
c0104e2a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104e2c:	ea 33 4e 10 c0 08 00 	ljmp   $0x8,$0xc0104e33
}
c0104e33:	5d                   	pop    %ebp
c0104e34:	c3                   	ret    

c0104e35 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104e35:	55                   	push   %ebp
c0104e36:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e3b:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104e40:	5d                   	pop    %ebp
c0104e41:	c3                   	ret    

c0104e42 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104e42:	55                   	push   %ebp
c0104e43:	89 e5                	mov    %esp,%ebp
c0104e45:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104e48:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104e4d:	89 04 24             	mov    %eax,(%esp)
c0104e50:	e8 e0 ff ff ff       	call   c0104e35 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104e55:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104e5c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104e5e:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104e65:	68 00 
c0104e67:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104e6c:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104e72:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104e77:	c1 e8 10             	shr    $0x10,%eax
c0104e7a:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104e7f:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104e86:	83 e0 f0             	and    $0xfffffff0,%eax
c0104e89:	83 c8 09             	or     $0x9,%eax
c0104e8c:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104e91:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104e98:	83 e0 ef             	and    $0xffffffef,%eax
c0104e9b:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104ea0:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104ea7:	83 e0 9f             	and    $0xffffff9f,%eax
c0104eaa:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104eaf:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104eb6:	83 c8 80             	or     $0xffffff80,%eax
c0104eb9:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104ebe:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ec5:	83 e0 f0             	and    $0xfffffff0,%eax
c0104ec8:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104ecd:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ed4:	83 e0 ef             	and    $0xffffffef,%eax
c0104ed7:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104edc:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ee3:	83 e0 df             	and    $0xffffffdf,%eax
c0104ee6:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104eeb:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ef2:	83 c8 40             	or     $0x40,%eax
c0104ef5:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104efa:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104f01:	83 e0 7f             	and    $0x7f,%eax
c0104f04:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104f09:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104f0e:	c1 e8 18             	shr    $0x18,%eax
c0104f11:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104f16:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104f1d:	e8 de fe ff ff       	call   c0104e00 <lgdt>
c0104f22:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104f28:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104f2c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104f2f:	c9                   	leave  
c0104f30:	c3                   	ret    

c0104f31 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104f31:	55                   	push   %ebp
c0104f32:	89 e5                	mov    %esp,%ebp
c0104f34:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104f37:	c7 05 24 7b 12 c0 70 	movl   $0xc010ab70,0xc0127b24
c0104f3e:	ab 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104f41:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104f46:	8b 00                	mov    (%eax),%eax
c0104f48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f4c:	c7 04 24 fc ac 10 c0 	movl   $0xc010acfc,(%esp)
c0104f53:	e8 fb b3 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104f58:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104f5d:	8b 40 04             	mov    0x4(%eax),%eax
c0104f60:	ff d0                	call   *%eax
}
c0104f62:	c9                   	leave  
c0104f63:	c3                   	ret    

c0104f64 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104f64:	55                   	push   %ebp
c0104f65:	89 e5                	mov    %esp,%ebp
c0104f67:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104f6a:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104f6f:	8b 40 08             	mov    0x8(%eax),%eax
c0104f72:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f75:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f79:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f7c:	89 14 24             	mov    %edx,(%esp)
c0104f7f:	ff d0                	call   *%eax
}
c0104f81:	c9                   	leave  
c0104f82:	c3                   	ret    

c0104f83 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104f83:	55                   	push   %ebp
c0104f84:	89 e5                	mov    %esp,%ebp
c0104f86:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104f89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104f90:	e8 2e fe ff ff       	call   c0104dc3 <__intr_save>
c0104f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104f98:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104f9d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104fa0:	8b 55 08             	mov    0x8(%ebp),%edx
c0104fa3:	89 14 24             	mov    %edx,(%esp)
c0104fa6:	ff d0                	call   *%eax
c0104fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fae:	89 04 24             	mov    %eax,(%esp)
c0104fb1:	e8 37 fe ff ff       	call   c0104ded <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fba:	75 2d                	jne    c0104fe9 <alloc_pages+0x66>
c0104fbc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104fc0:	77 27                	ja     c0104fe9 <alloc_pages+0x66>
c0104fc2:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104fc7:	85 c0                	test   %eax,%eax
c0104fc9:	74 1e                	je     c0104fe9 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104fcb:	8b 55 08             	mov    0x8(%ebp),%edx
c0104fce:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104fd3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fda:	00 
c0104fdb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fdf:	89 04 24             	mov    %eax,(%esp)
c0104fe2:	e8 67 19 00 00       	call   c010694e <swap_out>
    }
c0104fe7:	eb a7                	jmp    c0104f90 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104fec:	c9                   	leave  
c0104fed:	c3                   	ret    

c0104fee <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104fee:	55                   	push   %ebp
c0104fef:	89 e5                	mov    %esp,%ebp
c0104ff1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104ff4:	e8 ca fd ff ff       	call   c0104dc3 <__intr_save>
c0104ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104ffc:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0105001:	8b 40 10             	mov    0x10(%eax),%eax
c0105004:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105007:	89 54 24 04          	mov    %edx,0x4(%esp)
c010500b:	8b 55 08             	mov    0x8(%ebp),%edx
c010500e:	89 14 24             	mov    %edx,(%esp)
c0105011:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0105013:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105016:	89 04 24             	mov    %eax,(%esp)
c0105019:	e8 cf fd ff ff       	call   c0104ded <__intr_restore>
}
c010501e:	c9                   	leave  
c010501f:	c3                   	ret    

c0105020 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0105020:	55                   	push   %ebp
c0105021:	89 e5                	mov    %esp,%ebp
c0105023:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0105026:	e8 98 fd ff ff       	call   c0104dc3 <__intr_save>
c010502b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010502e:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0105033:	8b 40 14             	mov    0x14(%eax),%eax
c0105036:	ff d0                	call   *%eax
c0105038:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010503b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010503e:	89 04 24             	mov    %eax,(%esp)
c0105041:	e8 a7 fd ff ff       	call   c0104ded <__intr_restore>
    return ret;
c0105046:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0105049:	c9                   	leave  
c010504a:	c3                   	ret    

c010504b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010504b:	55                   	push   %ebp
c010504c:	89 e5                	mov    %esp,%ebp
c010504e:	57                   	push   %edi
c010504f:	56                   	push   %esi
c0105050:	53                   	push   %ebx
c0105051:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0105057:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010505e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105065:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010506c:	c7 04 24 13 ad 10 c0 	movl   $0xc010ad13,(%esp)
c0105073:	e8 db b2 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105078:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010507f:	e9 15 01 00 00       	jmp    c0105199 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105084:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105087:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010508a:	89 d0                	mov    %edx,%eax
c010508c:	c1 e0 02             	shl    $0x2,%eax
c010508f:	01 d0                	add    %edx,%eax
c0105091:	c1 e0 02             	shl    $0x2,%eax
c0105094:	01 c8                	add    %ecx,%eax
c0105096:	8b 50 08             	mov    0x8(%eax),%edx
c0105099:	8b 40 04             	mov    0x4(%eax),%eax
c010509c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010509f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01050a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050a8:	89 d0                	mov    %edx,%eax
c01050aa:	c1 e0 02             	shl    $0x2,%eax
c01050ad:	01 d0                	add    %edx,%eax
c01050af:	c1 e0 02             	shl    $0x2,%eax
c01050b2:	01 c8                	add    %ecx,%eax
c01050b4:	8b 48 0c             	mov    0xc(%eax),%ecx
c01050b7:	8b 58 10             	mov    0x10(%eax),%ebx
c01050ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01050bd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01050c0:	01 c8                	add    %ecx,%eax
c01050c2:	11 da                	adc    %ebx,%edx
c01050c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01050c7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01050ca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050d0:	89 d0                	mov    %edx,%eax
c01050d2:	c1 e0 02             	shl    $0x2,%eax
c01050d5:	01 d0                	add    %edx,%eax
c01050d7:	c1 e0 02             	shl    $0x2,%eax
c01050da:	01 c8                	add    %ecx,%eax
c01050dc:	83 c0 14             	add    $0x14,%eax
c01050df:	8b 00                	mov    (%eax),%eax
c01050e1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01050e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050ea:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01050ed:	83 c0 ff             	add    $0xffffffff,%eax
c01050f0:	83 d2 ff             	adc    $0xffffffff,%edx
c01050f3:	89 c6                	mov    %eax,%esi
c01050f5:	89 d7                	mov    %edx,%edi
c01050f7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050fd:	89 d0                	mov    %edx,%eax
c01050ff:	c1 e0 02             	shl    $0x2,%eax
c0105102:	01 d0                	add    %edx,%eax
c0105104:	c1 e0 02             	shl    $0x2,%eax
c0105107:	01 c8                	add    %ecx,%eax
c0105109:	8b 48 0c             	mov    0xc(%eax),%ecx
c010510c:	8b 58 10             	mov    0x10(%eax),%ebx
c010510f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105115:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105119:	89 74 24 14          	mov    %esi,0x14(%esp)
c010511d:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0105121:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105124:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105127:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010512b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010512f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105133:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105137:	c7 04 24 20 ad 10 c0 	movl   $0xc010ad20,(%esp)
c010513e:	e8 10 b2 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0105143:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105146:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105149:	89 d0                	mov    %edx,%eax
c010514b:	c1 e0 02             	shl    $0x2,%eax
c010514e:	01 d0                	add    %edx,%eax
c0105150:	c1 e0 02             	shl    $0x2,%eax
c0105153:	01 c8                	add    %ecx,%eax
c0105155:	83 c0 14             	add    $0x14,%eax
c0105158:	8b 00                	mov    (%eax),%eax
c010515a:	83 f8 01             	cmp    $0x1,%eax
c010515d:	75 36                	jne    c0105195 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010515f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105165:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105168:	77 2b                	ja     c0105195 <page_init+0x14a>
c010516a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010516d:	72 05                	jb     c0105174 <page_init+0x129>
c010516f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105172:	73 21                	jae    c0105195 <page_init+0x14a>
c0105174:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105178:	77 1b                	ja     c0105195 <page_init+0x14a>
c010517a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010517e:	72 09                	jb     c0105189 <page_init+0x13e>
c0105180:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105187:	77 0c                	ja     c0105195 <page_init+0x14a>
                maxpa = end;
c0105189:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010518c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010518f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105192:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105195:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105199:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010519c:	8b 00                	mov    (%eax),%eax
c010519e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01051a1:	0f 8f dd fe ff ff    	jg     c0105084 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01051a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051ab:	72 1d                	jb     c01051ca <page_init+0x17f>
c01051ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051b1:	77 09                	ja     c01051bc <page_init+0x171>
c01051b3:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01051ba:	76 0e                	jbe    c01051ca <page_init+0x17f>
        maxpa = KMEMSIZE;
c01051bc:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01051c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01051ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01051d0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01051d4:	c1 ea 0c             	shr    $0xc,%edx
c01051d7:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01051dc:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01051e3:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01051e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01051eb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01051ee:	01 d0                	add    %edx,%eax
c01051f0:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01051f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01051f6:	ba 00 00 00 00       	mov    $0x0,%edx
c01051fb:	f7 75 ac             	divl   -0x54(%ebp)
c01051fe:	89 d0                	mov    %edx,%eax
c0105200:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105203:	29 c2                	sub    %eax,%edx
c0105205:	89 d0                	mov    %edx,%eax
c0105207:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c010520c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105213:	eb 27                	jmp    c010523c <page_init+0x1f1>
        SetPageReserved(pages + i);
c0105215:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010521a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010521d:	c1 e2 05             	shl    $0x5,%edx
c0105220:	01 d0                	add    %edx,%eax
c0105222:	83 c0 04             	add    $0x4,%eax
c0105225:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010522c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010522f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105232:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105235:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105238:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010523c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010523f:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105244:	39 c2                	cmp    %eax,%edx
c0105246:	72 cd                	jb     c0105215 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105248:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010524d:	c1 e0 05             	shl    $0x5,%eax
c0105250:	89 c2                	mov    %eax,%edx
c0105252:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105257:	01 d0                	add    %edx,%eax
c0105259:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010525c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105263:	77 23                	ja     c0105288 <page_init+0x23d>
c0105265:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105268:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010526c:	c7 44 24 08 50 ad 10 	movl   $0xc010ad50,0x8(%esp)
c0105273:	c0 
c0105274:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010527b:	00 
c010527c:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105283:	e8 4f ba ff ff       	call   c0100cd7 <__panic>
c0105288:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010528b:	05 00 00 00 40       	add    $0x40000000,%eax
c0105290:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105293:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010529a:	e9 74 01 00 00       	jmp    c0105413 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010529f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01052a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052a5:	89 d0                	mov    %edx,%eax
c01052a7:	c1 e0 02             	shl    $0x2,%eax
c01052aa:	01 d0                	add    %edx,%eax
c01052ac:	c1 e0 02             	shl    $0x2,%eax
c01052af:	01 c8                	add    %ecx,%eax
c01052b1:	8b 50 08             	mov    0x8(%eax),%edx
c01052b4:	8b 40 04             	mov    0x4(%eax),%eax
c01052b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01052bd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01052c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052c3:	89 d0                	mov    %edx,%eax
c01052c5:	c1 e0 02             	shl    $0x2,%eax
c01052c8:	01 d0                	add    %edx,%eax
c01052ca:	c1 e0 02             	shl    $0x2,%eax
c01052cd:	01 c8                	add    %ecx,%eax
c01052cf:	8b 48 0c             	mov    0xc(%eax),%ecx
c01052d2:	8b 58 10             	mov    0x10(%eax),%ebx
c01052d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052db:	01 c8                	add    %ecx,%eax
c01052dd:	11 da                	adc    %ebx,%edx
c01052df:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01052e2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01052e5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01052e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052eb:	89 d0                	mov    %edx,%eax
c01052ed:	c1 e0 02             	shl    $0x2,%eax
c01052f0:	01 d0                	add    %edx,%eax
c01052f2:	c1 e0 02             	shl    $0x2,%eax
c01052f5:	01 c8                	add    %ecx,%eax
c01052f7:	83 c0 14             	add    $0x14,%eax
c01052fa:	8b 00                	mov    (%eax),%eax
c01052fc:	83 f8 01             	cmp    $0x1,%eax
c01052ff:	0f 85 0a 01 00 00    	jne    c010540f <page_init+0x3c4>
            if (begin < freemem) {
c0105305:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105308:	ba 00 00 00 00       	mov    $0x0,%edx
c010530d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105310:	72 17                	jb     c0105329 <page_init+0x2de>
c0105312:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105315:	77 05                	ja     c010531c <page_init+0x2d1>
c0105317:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010531a:	76 0d                	jbe    c0105329 <page_init+0x2de>
                begin = freemem;
c010531c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010531f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105322:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105329:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010532d:	72 1d                	jb     c010534c <page_init+0x301>
c010532f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105333:	77 09                	ja     c010533e <page_init+0x2f3>
c0105335:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010533c:	76 0e                	jbe    c010534c <page_init+0x301>
                end = KMEMSIZE;
c010533e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105345:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010534c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010534f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105352:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105355:	0f 87 b4 00 00 00    	ja     c010540f <page_init+0x3c4>
c010535b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010535e:	72 09                	jb     c0105369 <page_init+0x31e>
c0105360:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105363:	0f 83 a6 00 00 00    	jae    c010540f <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105369:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105370:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105373:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105376:	01 d0                	add    %edx,%eax
c0105378:	83 e8 01             	sub    $0x1,%eax
c010537b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010537e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105381:	ba 00 00 00 00       	mov    $0x0,%edx
c0105386:	f7 75 9c             	divl   -0x64(%ebp)
c0105389:	89 d0                	mov    %edx,%eax
c010538b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010538e:	29 c2                	sub    %eax,%edx
c0105390:	89 d0                	mov    %edx,%eax
c0105392:	ba 00 00 00 00       	mov    $0x0,%edx
c0105397:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010539a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010539d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01053a0:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01053a3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01053a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01053ab:	89 c7                	mov    %eax,%edi
c01053ad:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01053b3:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01053b6:	89 d0                	mov    %edx,%eax
c01053b8:	83 e0 00             	and    $0x0,%eax
c01053bb:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01053be:	8b 45 80             	mov    -0x80(%ebp),%eax
c01053c1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01053c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01053c7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01053ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053d0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01053d3:	77 3a                	ja     c010540f <page_init+0x3c4>
c01053d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01053d8:	72 05                	jb     c01053df <page_init+0x394>
c01053da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01053dd:	73 30                	jae    c010540f <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01053df:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01053e2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01053e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01053e8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01053eb:	29 c8                	sub    %ecx,%eax
c01053ed:	19 da                	sbb    %ebx,%edx
c01053ef:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01053f3:	c1 ea 0c             	shr    $0xc,%edx
c01053f6:	89 c3                	mov    %eax,%ebx
c01053f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053fb:	89 04 24             	mov    %eax,(%esp)
c01053fe:	e8 a4 f8 ff ff       	call   c0104ca7 <pa2page>
c0105403:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105407:	89 04 24             	mov    %eax,(%esp)
c010540a:	e8 55 fb ff ff       	call   c0104f64 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010540f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105413:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105416:	8b 00                	mov    (%eax),%eax
c0105418:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010541b:	0f 8f 7e fe ff ff    	jg     c010529f <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0105421:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105427:	5b                   	pop    %ebx
c0105428:	5e                   	pop    %esi
c0105429:	5f                   	pop    %edi
c010542a:	5d                   	pop    %ebp
c010542b:	c3                   	ret    

c010542c <enable_paging>:

static void
enable_paging(void) {
c010542c:	55                   	push   %ebp
c010542d:	89 e5                	mov    %esp,%ebp
c010542f:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105432:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c0105437:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010543a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010543d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0105440:	0f 20 c0             	mov    %cr0,%eax
c0105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105446:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105449:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010544c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105453:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105457:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010545a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010545d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105460:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105463:	c9                   	leave  
c0105464:	c3                   	ret    

c0105465 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105465:	55                   	push   %ebp
c0105466:	89 e5                	mov    %esp,%ebp
c0105468:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010546b:	8b 45 14             	mov    0x14(%ebp),%eax
c010546e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105471:	31 d0                	xor    %edx,%eax
c0105473:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105478:	85 c0                	test   %eax,%eax
c010547a:	74 24                	je     c01054a0 <boot_map_segment+0x3b>
c010547c:	c7 44 24 0c 82 ad 10 	movl   $0xc010ad82,0xc(%esp)
c0105483:	c0 
c0105484:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010548b:	c0 
c010548c:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105493:	00 
c0105494:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010549b:	e8 37 b8 ff ff       	call   c0100cd7 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01054a0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01054a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054aa:	25 ff 0f 00 00       	and    $0xfff,%eax
c01054af:	89 c2                	mov    %eax,%edx
c01054b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b4:	01 c2                	add    %eax,%edx
c01054b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b9:	01 d0                	add    %edx,%eax
c01054bb:	83 e8 01             	sub    $0x1,%eax
c01054be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054c4:	ba 00 00 00 00       	mov    $0x0,%edx
c01054c9:	f7 75 f0             	divl   -0x10(%ebp)
c01054cc:	89 d0                	mov    %edx,%eax
c01054ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054d1:	29 c2                	sub    %eax,%edx
c01054d3:	89 d0                	mov    %edx,%eax
c01054d5:	c1 e8 0c             	shr    $0xc,%eax
c01054d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01054db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054e9:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01054ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01054ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054fa:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01054fd:	eb 6b                	jmp    c010556a <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01054ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105506:	00 
c0105507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010550a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010550e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105511:	89 04 24             	mov    %eax,(%esp)
c0105514:	e8 d1 01 00 00       	call   c01056ea <get_pte>
c0105519:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010551c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105520:	75 24                	jne    c0105546 <boot_map_segment+0xe1>
c0105522:	c7 44 24 0c ae ad 10 	movl   $0xc010adae,0xc(%esp)
c0105529:	c0 
c010552a:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105531:	c0 
c0105532:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105539:	00 
c010553a:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105541:	e8 91 b7 ff ff       	call   c0100cd7 <__panic>
        *ptep = pa | PTE_P | perm;
c0105546:	8b 45 18             	mov    0x18(%ebp),%eax
c0105549:	8b 55 14             	mov    0x14(%ebp),%edx
c010554c:	09 d0                	or     %edx,%eax
c010554e:	83 c8 01             	or     $0x1,%eax
c0105551:	89 c2                	mov    %eax,%edx
c0105553:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105556:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105558:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010555c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105563:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010556a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010556e:	75 8f                	jne    c01054ff <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105570:	c9                   	leave  
c0105571:	c3                   	ret    

c0105572 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105572:	55                   	push   %ebp
c0105573:	89 e5                	mov    %esp,%ebp
c0105575:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010557f:	e8 ff f9 ff ff       	call   c0104f83 <alloc_pages>
c0105584:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010558b:	75 1c                	jne    c01055a9 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010558d:	c7 44 24 08 bb ad 10 	movl   $0xc010adbb,0x8(%esp)
c0105594:	c0 
c0105595:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010559c:	00 
c010559d:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01055a4:	e8 2e b7 ff ff       	call   c0100cd7 <__panic>
    }
    return page2kva(p);
c01055a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055ac:	89 04 24             	mov    %eax,(%esp)
c01055af:	e8 38 f7 ff ff       	call   c0104cec <page2kva>
}
c01055b4:	c9                   	leave  
c01055b5:	c3                   	ret    

c01055b6 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01055b6:	55                   	push   %ebp
c01055b7:	89 e5                	mov    %esp,%ebp
c01055b9:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01055bc:	e8 70 f9 ff ff       	call   c0104f31 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01055c1:	e8 85 fa ff ff       	call   c010504b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01055c6:	e8 3b 05 00 00       	call   c0105b06 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01055cb:	e8 a2 ff ff ff       	call   c0105572 <boot_alloc_page>
c01055d0:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c01055d5:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01055da:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055e1:	00 
c01055e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01055e9:	00 
c01055ea:	89 04 24             	mov    %eax,(%esp)
c01055ed:	e8 fd 47 00 00       	call   c0109def <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01055f2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01055f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055fa:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105601:	77 23                	ja     c0105626 <pmm_init+0x70>
c0105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105606:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010560a:	c7 44 24 08 50 ad 10 	movl   $0xc010ad50,0x8(%esp)
c0105611:	c0 
c0105612:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105619:	00 
c010561a:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105621:	e8 b1 b6 ff ff       	call   c0100cd7 <__panic>
c0105626:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105629:	05 00 00 00 40       	add    $0x40000000,%eax
c010562e:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c0105633:	e8 ec 04 00 00       	call   c0105b24 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105638:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010563d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105643:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105648:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010564b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105652:	77 23                	ja     c0105677 <pmm_init+0xc1>
c0105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105657:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010565b:	c7 44 24 08 50 ad 10 	movl   $0xc010ad50,0x8(%esp)
c0105662:	c0 
c0105663:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c010566a:	00 
c010566b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105672:	e8 60 b6 ff ff       	call   c0100cd7 <__panic>
c0105677:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010567a:	05 00 00 00 40       	add    $0x40000000,%eax
c010567f:	83 c8 03             	or     $0x3,%eax
c0105682:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105684:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105689:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105690:	00 
c0105691:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105698:	00 
c0105699:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01056a0:	38 
c01056a1:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01056a8:	c0 
c01056a9:	89 04 24             	mov    %eax,(%esp)
c01056ac:	e8 b4 fd ff ff       	call   c0105465 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01056b1:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01056b6:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c01056bc:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01056c2:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01056c4:	e8 63 fd ff ff       	call   c010542c <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01056c9:	e8 74 f7 ff ff       	call   c0104e42 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01056ce:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01056d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01056d9:	e8 e1 0a 00 00       	call   c01061bf <check_boot_pgdir>

    print_pgdir();
c01056de:	e8 6e 0f 00 00       	call   c0106651 <print_pgdir>
    
    kmalloc_init();
c01056e3:	e8 fe f2 ff ff       	call   c01049e6 <kmalloc_init>

}
c01056e8:	c9                   	leave  
c01056e9:	c3                   	ret    

c01056ea <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01056ea:	55                   	push   %ebp
c01056eb:	89 e5                	mov    %esp,%ebp
c01056ed:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t* entry = &pgdir[PDX(la)];
c01056f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056f3:	c1 e8 16             	shr    $0x16,%eax
c01056f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01056fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105700:	01 d0                	add    %edx,%eax
c0105702:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*entry & PTE_P))
c0105705:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105708:	8b 00                	mov    (%eax),%eax
c010570a:	83 e0 01             	and    $0x1,%eax
c010570d:	85 c0                	test   %eax,%eax
c010570f:	0f 85 af 00 00 00    	jne    c01057c4 <get_pte+0xda>
    {
    	struct Page* p;
    	if((!create) || ((p = alloc_page()) == NULL))
c0105715:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105719:	74 15                	je     c0105730 <get_pte+0x46>
c010571b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105722:	e8 5c f8 ff ff       	call   c0104f83 <alloc_pages>
c0105727:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010572a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010572e:	75 0a                	jne    c010573a <get_pte+0x50>
    	{
			return NULL;
c0105730:	b8 00 00 00 00       	mov    $0x0,%eax
c0105735:	e9 e6 00 00 00       	jmp    c0105820 <get_pte+0x136>
    	}
		set_page_ref(p, 1);
c010573a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105741:	00 
c0105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105745:	89 04 24             	mov    %eax,(%esp)
c0105748:	e8 3b f6 ff ff       	call   c0104d88 <set_page_ref>
		uintptr_t pg_addr = page2pa(p);
c010574d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105750:	89 04 24             	mov    %eax,(%esp)
c0105753:	e8 39 f5 ff ff       	call   c0104c91 <page2pa>
c0105758:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pg_addr), 0, PGSIZE);
c010575b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010575e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105761:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105764:	c1 e8 0c             	shr    $0xc,%eax
c0105767:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010576a:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010576f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105772:	72 23                	jb     c0105797 <get_pte+0xad>
c0105774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105777:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010577b:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c0105782:	c0 
c0105783:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c010578a:	00 
c010578b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105792:	e8 40 b5 ff ff       	call   c0100cd7 <__panic>
c0105797:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010579a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010579f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01057a6:	00 
c01057a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01057ae:	00 
c01057af:	89 04 24             	mov    %eax,(%esp)
c01057b2:	e8 38 46 00 00       	call   c0109def <memset>
		*entry = pg_addr | PTE_U | PTE_W | PTE_P;
c01057b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057ba:	83 c8 07             	or     $0x7,%eax
c01057bd:	89 c2                	mov    %eax,%edx
c01057bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057c2:	89 10                	mov    %edx,(%eax)
   	}
    return &((pte_t*)KADDR(PDE_ADDR(*entry)))[PTX(la)];
c01057c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057c7:	8b 00                	mov    (%eax),%eax
c01057c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01057ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01057d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057d4:	c1 e8 0c             	shr    $0xc,%eax
c01057d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01057da:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01057df:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01057e2:	72 23                	jb     c0105807 <get_pte+0x11d>
c01057e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057eb:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c01057f2:	c0 
c01057f3:	c7 44 24 04 9c 01 00 	movl   $0x19c,0x4(%esp)
c01057fa:	00 
c01057fb:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105802:	e8 d0 b4 ff ff       	call   c0100cd7 <__panic>
c0105807:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010580a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010580f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105812:	c1 ea 0c             	shr    $0xc,%edx
c0105815:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010581b:	c1 e2 02             	shl    $0x2,%edx
c010581e:	01 d0                	add    %edx,%eax
}
c0105820:	c9                   	leave  
c0105821:	c3                   	ret    

c0105822 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105822:	55                   	push   %ebp
c0105823:	89 e5                	mov    %esp,%ebp
c0105825:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105828:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010582f:	00 
c0105830:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105833:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105837:	8b 45 08             	mov    0x8(%ebp),%eax
c010583a:	89 04 24             	mov    %eax,(%esp)
c010583d:	e8 a8 fe ff ff       	call   c01056ea <get_pte>
c0105842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105845:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105849:	74 08                	je     c0105853 <get_page+0x31>
        *ptep_store = ptep;
c010584b:	8b 45 10             	mov    0x10(%ebp),%eax
c010584e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105851:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105857:	74 1b                	je     c0105874 <get_page+0x52>
c0105859:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010585c:	8b 00                	mov    (%eax),%eax
c010585e:	83 e0 01             	and    $0x1,%eax
c0105861:	85 c0                	test   %eax,%eax
c0105863:	74 0f                	je     c0105874 <get_page+0x52>
        return pa2page(*ptep);
c0105865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105868:	8b 00                	mov    (%eax),%eax
c010586a:	89 04 24             	mov    %eax,(%esp)
c010586d:	e8 35 f4 ff ff       	call   c0104ca7 <pa2page>
c0105872:	eb 05                	jmp    c0105879 <get_page+0x57>
    }
    return NULL;
c0105874:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105879:	c9                   	leave  
c010587a:	c3                   	ret    

c010587b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010587b:	55                   	push   %ebp
c010587c:	89 e5                	mov    %esp,%ebp
c010587e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
c0105881:	8b 45 10             	mov    0x10(%ebp),%eax
c0105884:	8b 00                	mov    (%eax),%eax
c0105886:	83 e0 01             	and    $0x1,%eax
c0105889:	85 c0                	test   %eax,%eax
c010588b:	74 52                	je     c01058df <page_remove_pte+0x64>
	{
		struct Page* page = pte2page(*ptep);
c010588d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105890:	8b 00                	mov    (%eax),%eax
c0105892:	89 04 24             	mov    %eax,(%esp)
c0105895:	e8 a6 f4 ff ff       	call   c0104d40 <pte2page>
c010589a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int re = page_ref_dec(page);
c010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a0:	89 04 24             	mov    %eax,(%esp)
c01058a3:	e8 04 f5 ff ff       	call   c0104dac <page_ref_dec>
c01058a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(re == 0)
c01058ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058af:	75 13                	jne    c01058c4 <page_remove_pte+0x49>
		{
			free_page(page);
c01058b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058b8:	00 
c01058b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058bc:	89 04 24             	mov    %eax,(%esp)
c01058bf:	e8 2a f7 ff ff       	call   c0104fee <free_pages>
		}
		*ptep = 0;
c01058c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01058c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c01058cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d7:	89 04 24             	mov    %eax,(%esp)
c01058da:	e8 ff 00 00 00       	call   c01059de <tlb_invalidate>
	}
}
c01058df:	c9                   	leave  
c01058e0:	c3                   	ret    

c01058e1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01058e1:	55                   	push   %ebp
c01058e2:	89 e5                	mov    %esp,%ebp
c01058e4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01058e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01058ee:	00 
c01058ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f9:	89 04 24             	mov    %eax,(%esp)
c01058fc:	e8 e9 fd ff ff       	call   c01056ea <get_pte>
c0105901:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105908:	74 19                	je     c0105923 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010590a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105911:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105914:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105918:	8b 45 08             	mov    0x8(%ebp),%eax
c010591b:	89 04 24             	mov    %eax,(%esp)
c010591e:	e8 58 ff ff ff       	call   c010587b <page_remove_pte>
    }
}
c0105923:	c9                   	leave  
c0105924:	c3                   	ret    

c0105925 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105925:	55                   	push   %ebp
c0105926:	89 e5                	mov    %esp,%ebp
c0105928:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010592b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105932:	00 
c0105933:	8b 45 10             	mov    0x10(%ebp),%eax
c0105936:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593a:	8b 45 08             	mov    0x8(%ebp),%eax
c010593d:	89 04 24             	mov    %eax,(%esp)
c0105940:	e8 a5 fd ff ff       	call   c01056ea <get_pte>
c0105945:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010594c:	75 0a                	jne    c0105958 <page_insert+0x33>
        return -E_NO_MEM;
c010594e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105953:	e9 84 00 00 00       	jmp    c01059dc <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105958:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595b:	89 04 24             	mov    %eax,(%esp)
c010595e:	e8 32 f4 ff ff       	call   c0104d95 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105966:	8b 00                	mov    (%eax),%eax
c0105968:	83 e0 01             	and    $0x1,%eax
c010596b:	85 c0                	test   %eax,%eax
c010596d:	74 3e                	je     c01059ad <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010596f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105972:	8b 00                	mov    (%eax),%eax
c0105974:	89 04 24             	mov    %eax,(%esp)
c0105977:	e8 c4 f3 ff ff       	call   c0104d40 <pte2page>
c010597c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010597f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105982:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105985:	75 0d                	jne    c0105994 <page_insert+0x6f>
            page_ref_dec(page);
c0105987:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598a:	89 04 24             	mov    %eax,(%esp)
c010598d:	e8 1a f4 ff ff       	call   c0104dac <page_ref_dec>
c0105992:	eb 19                	jmp    c01059ad <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105997:	89 44 24 08          	mov    %eax,0x8(%esp)
c010599b:	8b 45 10             	mov    0x10(%ebp),%eax
c010599e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a5:	89 04 24             	mov    %eax,(%esp)
c01059a8:	e8 ce fe ff ff       	call   c010587b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01059ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b0:	89 04 24             	mov    %eax,(%esp)
c01059b3:	e8 d9 f2 ff ff       	call   c0104c91 <page2pa>
c01059b8:	0b 45 14             	or     0x14(%ebp),%eax
c01059bb:	83 c8 01             	or     $0x1,%eax
c01059be:	89 c2                	mov    %eax,%edx
c01059c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01059c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cf:	89 04 24             	mov    %eax,(%esp)
c01059d2:	e8 07 00 00 00       	call   c01059de <tlb_invalidate>
    return 0;
c01059d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059dc:	c9                   	leave  
c01059dd:	c3                   	ret    

c01059de <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01059de:	55                   	push   %ebp
c01059df:	89 e5                	mov    %esp,%ebp
c01059e1:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01059e4:	0f 20 d8             	mov    %cr3,%eax
c01059e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01059ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01059ed:	89 c2                	mov    %eax,%edx
c01059ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059f5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01059fc:	77 23                	ja     c0105a21 <tlb_invalidate+0x43>
c01059fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a01:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a05:	c7 44 24 08 50 ad 10 	movl   $0xc010ad50,0x8(%esp)
c0105a0c:	c0 
c0105a0d:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0105a14:	00 
c0105a15:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105a1c:	e8 b6 b2 ff ff       	call   c0100cd7 <__panic>
c0105a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a24:	05 00 00 00 40       	add    $0x40000000,%eax
c0105a29:	39 c2                	cmp    %eax,%edx
c0105a2b:	75 0c                	jne    c0105a39 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a30:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a36:	0f 01 38             	invlpg (%eax)
    }
}
c0105a39:	c9                   	leave  
c0105a3a:	c3                   	ret    

c0105a3b <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105a3b:	55                   	push   %ebp
c0105a3c:	89 e5                	mov    %esp,%ebp
c0105a3e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105a41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a48:	e8 36 f5 ff ff       	call   c0104f83 <alloc_pages>
c0105a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a54:	0f 84 a7 00 00 00    	je     c0105b01 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105a5a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a64:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a72:	89 04 24             	mov    %eax,(%esp)
c0105a75:	e8 ab fe ff ff       	call   c0105925 <page_insert>
c0105a7a:	85 c0                	test   %eax,%eax
c0105a7c:	74 1a                	je     c0105a98 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105a7e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a85:	00 
c0105a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a89:	89 04 24             	mov    %eax,(%esp)
c0105a8c:	e8 5d f5 ff ff       	call   c0104fee <free_pages>
            return NULL;
c0105a91:	b8 00 00 00 00       	mov    $0x0,%eax
c0105a96:	eb 6c                	jmp    c0105b04 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105a98:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0105a9d:	85 c0                	test   %eax,%eax
c0105a9f:	74 60                	je     c0105b01 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105aa1:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0105aa6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105aad:	00 
c0105aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ab1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ab8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105abc:	89 04 24             	mov    %eax,(%esp)
c0105abf:	e8 3e 0e 00 00       	call   c0106902 <swap_map_swappable>
            page->pra_vaddr=la;
c0105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105aca:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ad0:	89 04 24             	mov    %eax,(%esp)
c0105ad3:	e8 a6 f2 ff ff       	call   c0104d7e <page_ref>
c0105ad8:	83 f8 01             	cmp    $0x1,%eax
c0105adb:	74 24                	je     c0105b01 <pgdir_alloc_page+0xc6>
c0105add:	c7 44 24 0c d4 ad 10 	movl   $0xc010add4,0xc(%esp)
c0105ae4:	c0 
c0105ae5:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105aec:	c0 
c0105aed:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0105af4:	00 
c0105af5:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105afc:	e8 d6 b1 ff ff       	call   c0100cd7 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b04:	c9                   	leave  
c0105b05:	c3                   	ret    

c0105b06 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105b06:	55                   	push   %ebp
c0105b07:	89 e5                	mov    %esp,%ebp
c0105b09:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105b0c:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0105b11:	8b 40 18             	mov    0x18(%eax),%eax
c0105b14:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105b16:	c7 04 24 e8 ad 10 c0 	movl   $0xc010ade8,(%esp)
c0105b1d:	e8 31 a8 ff ff       	call   c0100353 <cprintf>
}
c0105b22:	c9                   	leave  
c0105b23:	c3                   	ret    

c0105b24 <check_pgdir>:

static void
check_pgdir(void) {
c0105b24:	55                   	push   %ebp
c0105b25:	89 e5                	mov    %esp,%ebp
c0105b27:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105b2a:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105b2f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105b34:	76 24                	jbe    c0105b5a <check_pgdir+0x36>
c0105b36:	c7 44 24 0c 07 ae 10 	movl   $0xc010ae07,0xc(%esp)
c0105b3d:	c0 
c0105b3e:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105b45:	c0 
c0105b46:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105b4d:	00 
c0105b4e:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105b55:	e8 7d b1 ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105b5a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b5f:	85 c0                	test   %eax,%eax
c0105b61:	74 0e                	je     c0105b71 <check_pgdir+0x4d>
c0105b63:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b68:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105b6d:	85 c0                	test   %eax,%eax
c0105b6f:	74 24                	je     c0105b95 <check_pgdir+0x71>
c0105b71:	c7 44 24 0c 24 ae 10 	movl   $0xc010ae24,0xc(%esp)
c0105b78:	c0 
c0105b79:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105b80:	c0 
c0105b81:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105b88:	00 
c0105b89:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105b90:	e8 42 b1 ff ff       	call   c0100cd7 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105b95:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ba1:	00 
c0105ba2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105ba9:	00 
c0105baa:	89 04 24             	mov    %eax,(%esp)
c0105bad:	e8 70 fc ff ff       	call   c0105822 <get_page>
c0105bb2:	85 c0                	test   %eax,%eax
c0105bb4:	74 24                	je     c0105bda <check_pgdir+0xb6>
c0105bb6:	c7 44 24 0c 5c ae 10 	movl   $0xc010ae5c,0xc(%esp)
c0105bbd:	c0 
c0105bbe:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105bc5:	c0 
c0105bc6:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0105bcd:	00 
c0105bce:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105bd5:	e8 fd b0 ff ff       	call   c0100cd7 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105bda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105be1:	e8 9d f3 ff ff       	call   c0104f83 <alloc_pages>
c0105be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105be9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105bee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105bf5:	00 
c0105bf6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105bfd:	00 
c0105bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c01:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c05:	89 04 24             	mov    %eax,(%esp)
c0105c08:	e8 18 fd ff ff       	call   c0105925 <page_insert>
c0105c0d:	85 c0                	test   %eax,%eax
c0105c0f:	74 24                	je     c0105c35 <check_pgdir+0x111>
c0105c11:	c7 44 24 0c 84 ae 10 	movl   $0xc010ae84,0xc(%esp)
c0105c18:	c0 
c0105c19:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105c20:	c0 
c0105c21:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105c28:	00 
c0105c29:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105c30:	e8 a2 b0 ff ff       	call   c0100cd7 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105c35:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c41:	00 
c0105c42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105c49:	00 
c0105c4a:	89 04 24             	mov    %eax,(%esp)
c0105c4d:	e8 98 fa ff ff       	call   c01056ea <get_pte>
c0105c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c59:	75 24                	jne    c0105c7f <check_pgdir+0x15b>
c0105c5b:	c7 44 24 0c b0 ae 10 	movl   $0xc010aeb0,0xc(%esp)
c0105c62:	c0 
c0105c63:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105c6a:	c0 
c0105c6b:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105c72:	00 
c0105c73:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105c7a:	e8 58 b0 ff ff       	call   c0100cd7 <__panic>
    assert(pa2page(*ptep) == p1);
c0105c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c82:	8b 00                	mov    (%eax),%eax
c0105c84:	89 04 24             	mov    %eax,(%esp)
c0105c87:	e8 1b f0 ff ff       	call   c0104ca7 <pa2page>
c0105c8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105c8f:	74 24                	je     c0105cb5 <check_pgdir+0x191>
c0105c91:	c7 44 24 0c dd ae 10 	movl   $0xc010aedd,0xc(%esp)
c0105c98:	c0 
c0105c99:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105ca0:	c0 
c0105ca1:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105ca8:	00 
c0105ca9:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105cb0:	e8 22 b0 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 1);
c0105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cb8:	89 04 24             	mov    %eax,(%esp)
c0105cbb:	e8 be f0 ff ff       	call   c0104d7e <page_ref>
c0105cc0:	83 f8 01             	cmp    $0x1,%eax
c0105cc3:	74 24                	je     c0105ce9 <check_pgdir+0x1c5>
c0105cc5:	c7 44 24 0c f2 ae 10 	movl   $0xc010aef2,0xc(%esp)
c0105ccc:	c0 
c0105ccd:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105cd4:	c0 
c0105cd5:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105cdc:	00 
c0105cdd:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105ce4:	e8 ee af ff ff       	call   c0100cd7 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105ce9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105cee:	8b 00                	mov    (%eax),%eax
c0105cf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105cf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cfb:	c1 e8 0c             	shr    $0xc,%eax
c0105cfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d01:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105d06:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105d09:	72 23                	jb     c0105d2e <check_pgdir+0x20a>
c0105d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d12:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c0105d19:	c0 
c0105d1a:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105d21:	00 
c0105d22:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105d29:	e8 a9 af ff ff       	call   c0100cd7 <__panic>
c0105d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d31:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105d36:	83 c0 04             	add    $0x4,%eax
c0105d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105d3c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d48:	00 
c0105d49:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d50:	00 
c0105d51:	89 04 24             	mov    %eax,(%esp)
c0105d54:	e8 91 f9 ff ff       	call   c01056ea <get_pte>
c0105d59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105d5c:	74 24                	je     c0105d82 <check_pgdir+0x25e>
c0105d5e:	c7 44 24 0c 04 af 10 	movl   $0xc010af04,0xc(%esp)
c0105d65:	c0 
c0105d66:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105d6d:	c0 
c0105d6e:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105d75:	00 
c0105d76:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105d7d:	e8 55 af ff ff       	call   c0100cd7 <__panic>

    p2 = alloc_page();
c0105d82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d89:	e8 f5 f1 ff ff       	call   c0104f83 <alloc_pages>
c0105d8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105d91:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d96:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105d9d:	00 
c0105d9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105da5:	00 
c0105da6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105da9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dad:	89 04 24             	mov    %eax,(%esp)
c0105db0:	e8 70 fb ff ff       	call   c0105925 <page_insert>
c0105db5:	85 c0                	test   %eax,%eax
c0105db7:	74 24                	je     c0105ddd <check_pgdir+0x2b9>
c0105db9:	c7 44 24 0c 2c af 10 	movl   $0xc010af2c,0xc(%esp)
c0105dc0:	c0 
c0105dc1:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105dc8:	c0 
c0105dc9:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105dd0:	00 
c0105dd1:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105dd8:	e8 fa ae ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105ddd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105de2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105de9:	00 
c0105dea:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105df1:	00 
c0105df2:	89 04 24             	mov    %eax,(%esp)
c0105df5:	e8 f0 f8 ff ff       	call   c01056ea <get_pte>
c0105dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e01:	75 24                	jne    c0105e27 <check_pgdir+0x303>
c0105e03:	c7 44 24 0c 64 af 10 	movl   $0xc010af64,0xc(%esp)
c0105e0a:	c0 
c0105e0b:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105e12:	c0 
c0105e13:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105e1a:	00 
c0105e1b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105e22:	e8 b0 ae ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_U);
c0105e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e2a:	8b 00                	mov    (%eax),%eax
c0105e2c:	83 e0 04             	and    $0x4,%eax
c0105e2f:	85 c0                	test   %eax,%eax
c0105e31:	75 24                	jne    c0105e57 <check_pgdir+0x333>
c0105e33:	c7 44 24 0c 94 af 10 	movl   $0xc010af94,0xc(%esp)
c0105e3a:	c0 
c0105e3b:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105e42:	c0 
c0105e43:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105e4a:	00 
c0105e4b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105e52:	e8 80 ae ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_W);
c0105e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5a:	8b 00                	mov    (%eax),%eax
c0105e5c:	83 e0 02             	and    $0x2,%eax
c0105e5f:	85 c0                	test   %eax,%eax
c0105e61:	75 24                	jne    c0105e87 <check_pgdir+0x363>
c0105e63:	c7 44 24 0c a2 af 10 	movl   $0xc010afa2,0xc(%esp)
c0105e6a:	c0 
c0105e6b:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105e72:	c0 
c0105e73:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105e7a:	00 
c0105e7b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105e82:	e8 50 ae ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105e87:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e8c:	8b 00                	mov    (%eax),%eax
c0105e8e:	83 e0 04             	and    $0x4,%eax
c0105e91:	85 c0                	test   %eax,%eax
c0105e93:	75 24                	jne    c0105eb9 <check_pgdir+0x395>
c0105e95:	c7 44 24 0c b0 af 10 	movl   $0xc010afb0,0xc(%esp)
c0105e9c:	c0 
c0105e9d:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105ea4:	c0 
c0105ea5:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105eac:	00 
c0105ead:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105eb4:	e8 1e ae ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 1);
c0105eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ebc:	89 04 24             	mov    %eax,(%esp)
c0105ebf:	e8 ba ee ff ff       	call   c0104d7e <page_ref>
c0105ec4:	83 f8 01             	cmp    $0x1,%eax
c0105ec7:	74 24                	je     c0105eed <check_pgdir+0x3c9>
c0105ec9:	c7 44 24 0c c6 af 10 	movl   $0xc010afc6,0xc(%esp)
c0105ed0:	c0 
c0105ed1:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105ed8:	c0 
c0105ed9:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105ee0:	00 
c0105ee1:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105ee8:	e8 ea ad ff ff       	call   c0100cd7 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105eed:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ef2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105ef9:	00 
c0105efa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105f01:	00 
c0105f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f09:	89 04 24             	mov    %eax,(%esp)
c0105f0c:	e8 14 fa ff ff       	call   c0105925 <page_insert>
c0105f11:	85 c0                	test   %eax,%eax
c0105f13:	74 24                	je     c0105f39 <check_pgdir+0x415>
c0105f15:	c7 44 24 0c d8 af 10 	movl   $0xc010afd8,0xc(%esp)
c0105f1c:	c0 
c0105f1d:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105f24:	c0 
c0105f25:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105f2c:	00 
c0105f2d:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105f34:	e8 9e ad ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 2);
c0105f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f3c:	89 04 24             	mov    %eax,(%esp)
c0105f3f:	e8 3a ee ff ff       	call   c0104d7e <page_ref>
c0105f44:	83 f8 02             	cmp    $0x2,%eax
c0105f47:	74 24                	je     c0105f6d <check_pgdir+0x449>
c0105f49:	c7 44 24 0c 04 b0 10 	movl   $0xc010b004,0xc(%esp)
c0105f50:	c0 
c0105f51:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105f58:	c0 
c0105f59:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105f60:	00 
c0105f61:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105f68:	e8 6a ad ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0105f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f70:	89 04 24             	mov    %eax,(%esp)
c0105f73:	e8 06 ee ff ff       	call   c0104d7e <page_ref>
c0105f78:	85 c0                	test   %eax,%eax
c0105f7a:	74 24                	je     c0105fa0 <check_pgdir+0x47c>
c0105f7c:	c7 44 24 0c 16 b0 10 	movl   $0xc010b016,0xc(%esp)
c0105f83:	c0 
c0105f84:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105f8b:	c0 
c0105f8c:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105f93:	00 
c0105f94:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105f9b:	e8 37 ad ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105fa0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fa5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fac:	00 
c0105fad:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105fb4:	00 
c0105fb5:	89 04 24             	mov    %eax,(%esp)
c0105fb8:	e8 2d f7 ff ff       	call   c01056ea <get_pte>
c0105fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105fc4:	75 24                	jne    c0105fea <check_pgdir+0x4c6>
c0105fc6:	c7 44 24 0c 64 af 10 	movl   $0xc010af64,0xc(%esp)
c0105fcd:	c0 
c0105fce:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0105fd5:	c0 
c0105fd6:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105fdd:	00 
c0105fde:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0105fe5:	e8 ed ac ff ff       	call   c0100cd7 <__panic>
    assert(pa2page(*ptep) == p1);
c0105fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fed:	8b 00                	mov    (%eax),%eax
c0105fef:	89 04 24             	mov    %eax,(%esp)
c0105ff2:	e8 b0 ec ff ff       	call   c0104ca7 <pa2page>
c0105ff7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ffa:	74 24                	je     c0106020 <check_pgdir+0x4fc>
c0105ffc:	c7 44 24 0c dd ae 10 	movl   $0xc010aedd,0xc(%esp)
c0106003:	c0 
c0106004:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010600b:	c0 
c010600c:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0106013:	00 
c0106014:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010601b:	e8 b7 ac ff ff       	call   c0100cd7 <__panic>
    assert((*ptep & PTE_U) == 0);
c0106020:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106023:	8b 00                	mov    (%eax),%eax
c0106025:	83 e0 04             	and    $0x4,%eax
c0106028:	85 c0                	test   %eax,%eax
c010602a:	74 24                	je     c0106050 <check_pgdir+0x52c>
c010602c:	c7 44 24 0c 28 b0 10 	movl   $0xc010b028,0xc(%esp)
c0106033:	c0 
c0106034:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010603b:	c0 
c010603c:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0106043:	00 
c0106044:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010604b:	e8 87 ac ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106050:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106055:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010605c:	00 
c010605d:	89 04 24             	mov    %eax,(%esp)
c0106060:	e8 7c f8 ff ff       	call   c01058e1 <page_remove>
    assert(page_ref(p1) == 1);
c0106065:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106068:	89 04 24             	mov    %eax,(%esp)
c010606b:	e8 0e ed ff ff       	call   c0104d7e <page_ref>
c0106070:	83 f8 01             	cmp    $0x1,%eax
c0106073:	74 24                	je     c0106099 <check_pgdir+0x575>
c0106075:	c7 44 24 0c f2 ae 10 	movl   $0xc010aef2,0xc(%esp)
c010607c:	c0 
c010607d:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106084:	c0 
c0106085:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c010608c:	00 
c010608d:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106094:	e8 3e ac ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0106099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010609c:	89 04 24             	mov    %eax,(%esp)
c010609f:	e8 da ec ff ff       	call   c0104d7e <page_ref>
c01060a4:	85 c0                	test   %eax,%eax
c01060a6:	74 24                	je     c01060cc <check_pgdir+0x5a8>
c01060a8:	c7 44 24 0c 16 b0 10 	movl   $0xc010b016,0xc(%esp)
c01060af:	c0 
c01060b0:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c01060b7:	c0 
c01060b8:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01060bf:	00 
c01060c0:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01060c7:	e8 0b ac ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01060cc:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01060d1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01060d8:	00 
c01060d9:	89 04 24             	mov    %eax,(%esp)
c01060dc:	e8 00 f8 ff ff       	call   c01058e1 <page_remove>
    assert(page_ref(p1) == 0);
c01060e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060e4:	89 04 24             	mov    %eax,(%esp)
c01060e7:	e8 92 ec ff ff       	call   c0104d7e <page_ref>
c01060ec:	85 c0                	test   %eax,%eax
c01060ee:	74 24                	je     c0106114 <check_pgdir+0x5f0>
c01060f0:	c7 44 24 0c 3d b0 10 	movl   $0xc010b03d,0xc(%esp)
c01060f7:	c0 
c01060f8:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c01060ff:	c0 
c0106100:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0106107:	00 
c0106108:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010610f:	e8 c3 ab ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0106114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106117:	89 04 24             	mov    %eax,(%esp)
c010611a:	e8 5f ec ff ff       	call   c0104d7e <page_ref>
c010611f:	85 c0                	test   %eax,%eax
c0106121:	74 24                	je     c0106147 <check_pgdir+0x623>
c0106123:	c7 44 24 0c 16 b0 10 	movl   $0xc010b016,0xc(%esp)
c010612a:	c0 
c010612b:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106132:	c0 
c0106133:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010613a:	00 
c010613b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106142:	e8 90 ab ff ff       	call   c0100cd7 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0106147:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010614c:	8b 00                	mov    (%eax),%eax
c010614e:	89 04 24             	mov    %eax,(%esp)
c0106151:	e8 51 eb ff ff       	call   c0104ca7 <pa2page>
c0106156:	89 04 24             	mov    %eax,(%esp)
c0106159:	e8 20 ec ff ff       	call   c0104d7e <page_ref>
c010615e:	83 f8 01             	cmp    $0x1,%eax
c0106161:	74 24                	je     c0106187 <check_pgdir+0x663>
c0106163:	c7 44 24 0c 50 b0 10 	movl   $0xc010b050,0xc(%esp)
c010616a:	c0 
c010616b:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106172:	c0 
c0106173:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c010617a:	00 
c010617b:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106182:	e8 50 ab ff ff       	call   c0100cd7 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0106187:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010618c:	8b 00                	mov    (%eax),%eax
c010618e:	89 04 24             	mov    %eax,(%esp)
c0106191:	e8 11 eb ff ff       	call   c0104ca7 <pa2page>
c0106196:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010619d:	00 
c010619e:	89 04 24             	mov    %eax,(%esp)
c01061a1:	e8 48 ee ff ff       	call   c0104fee <free_pages>
    boot_pgdir[0] = 0;
c01061a6:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01061b1:	c7 04 24 76 b0 10 c0 	movl   $0xc010b076,(%esp)
c01061b8:	e8 96 a1 ff ff       	call   c0100353 <cprintf>
}
c01061bd:	c9                   	leave  
c01061be:	c3                   	ret    

c01061bf <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01061bf:	55                   	push   %ebp
c01061c0:	89 e5                	mov    %esp,%ebp
c01061c2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01061c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01061cc:	e9 ca 00 00 00       	jmp    c010629b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01061d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061da:	c1 e8 0c             	shr    $0xc,%eax
c01061dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061e0:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01061e5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01061e8:	72 23                	jb     c010620d <check_boot_pgdir+0x4e>
c01061ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061f1:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c01061f8:	c0 
c01061f9:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0106200:	00 
c0106201:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106208:	e8 ca aa ff ff       	call   c0100cd7 <__panic>
c010620d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106210:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106215:	89 c2                	mov    %eax,%edx
c0106217:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010621c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106223:	00 
c0106224:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106228:	89 04 24             	mov    %eax,(%esp)
c010622b:	e8 ba f4 ff ff       	call   c01056ea <get_pte>
c0106230:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106233:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106237:	75 24                	jne    c010625d <check_boot_pgdir+0x9e>
c0106239:	c7 44 24 0c 90 b0 10 	movl   $0xc010b090,0xc(%esp)
c0106240:	c0 
c0106241:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106248:	c0 
c0106249:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0106250:	00 
c0106251:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106258:	e8 7a aa ff ff       	call   c0100cd7 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010625d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106260:	8b 00                	mov    (%eax),%eax
c0106262:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106267:	89 c2                	mov    %eax,%edx
c0106269:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010626c:	39 c2                	cmp    %eax,%edx
c010626e:	74 24                	je     c0106294 <check_boot_pgdir+0xd5>
c0106270:	c7 44 24 0c cd b0 10 	movl   $0xc010b0cd,0xc(%esp)
c0106277:	c0 
c0106278:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010627f:	c0 
c0106280:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0106287:	00 
c0106288:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010628f:	e8 43 aa ff ff       	call   c0100cd7 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106294:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010629b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010629e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01062a3:	39 c2                	cmp    %eax,%edx
c01062a5:	0f 82 26 ff ff ff    	jb     c01061d1 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01062ab:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062b0:	05 ac 0f 00 00       	add    $0xfac,%eax
c01062b5:	8b 00                	mov    (%eax),%eax
c01062b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062bc:	89 c2                	mov    %eax,%edx
c01062be:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01062c6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01062cd:	77 23                	ja     c01062f2 <check_boot_pgdir+0x133>
c01062cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062d6:	c7 44 24 08 50 ad 10 	movl   $0xc010ad50,0x8(%esp)
c01062dd:	c0 
c01062de:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c01062e5:	00 
c01062e6:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01062ed:	e8 e5 a9 ff ff       	call   c0100cd7 <__panic>
c01062f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062f5:	05 00 00 00 40       	add    $0x40000000,%eax
c01062fa:	39 c2                	cmp    %eax,%edx
c01062fc:	74 24                	je     c0106322 <check_boot_pgdir+0x163>
c01062fe:	c7 44 24 0c e4 b0 10 	movl   $0xc010b0e4,0xc(%esp)
c0106305:	c0 
c0106306:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010630d:	c0 
c010630e:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0106315:	00 
c0106316:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010631d:	e8 b5 a9 ff ff       	call   c0100cd7 <__panic>

    assert(boot_pgdir[0] == 0);
c0106322:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106327:	8b 00                	mov    (%eax),%eax
c0106329:	85 c0                	test   %eax,%eax
c010632b:	74 24                	je     c0106351 <check_boot_pgdir+0x192>
c010632d:	c7 44 24 0c 18 b1 10 	movl   $0xc010b118,0xc(%esp)
c0106334:	c0 
c0106335:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010633c:	c0 
c010633d:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c0106344:	00 
c0106345:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010634c:	e8 86 a9 ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    p = alloc_page();
c0106351:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106358:	e8 26 ec ff ff       	call   c0104f83 <alloc_pages>
c010635d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106360:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106365:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010636c:	00 
c010636d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106374:	00 
c0106375:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106378:	89 54 24 04          	mov    %edx,0x4(%esp)
c010637c:	89 04 24             	mov    %eax,(%esp)
c010637f:	e8 a1 f5 ff ff       	call   c0105925 <page_insert>
c0106384:	85 c0                	test   %eax,%eax
c0106386:	74 24                	je     c01063ac <check_boot_pgdir+0x1ed>
c0106388:	c7 44 24 0c 2c b1 10 	movl   $0xc010b12c,0xc(%esp)
c010638f:	c0 
c0106390:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106397:	c0 
c0106398:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c010639f:	00 
c01063a0:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01063a7:	e8 2b a9 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 1);
c01063ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063af:	89 04 24             	mov    %eax,(%esp)
c01063b2:	e8 c7 e9 ff ff       	call   c0104d7e <page_ref>
c01063b7:	83 f8 01             	cmp    $0x1,%eax
c01063ba:	74 24                	je     c01063e0 <check_boot_pgdir+0x221>
c01063bc:	c7 44 24 0c 5a b1 10 	movl   $0xc010b15a,0xc(%esp)
c01063c3:	c0 
c01063c4:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c01063cb:	c0 
c01063cc:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c01063d3:	00 
c01063d4:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01063db:	e8 f7 a8 ff ff       	call   c0100cd7 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01063e0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01063e5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01063ec:	00 
c01063ed:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01063f4:	00 
c01063f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01063f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063fc:	89 04 24             	mov    %eax,(%esp)
c01063ff:	e8 21 f5 ff ff       	call   c0105925 <page_insert>
c0106404:	85 c0                	test   %eax,%eax
c0106406:	74 24                	je     c010642c <check_boot_pgdir+0x26d>
c0106408:	c7 44 24 0c 6c b1 10 	movl   $0xc010b16c,0xc(%esp)
c010640f:	c0 
c0106410:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c0106417:	c0 
c0106418:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c010641f:	00 
c0106420:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106427:	e8 ab a8 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 2);
c010642c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010642f:	89 04 24             	mov    %eax,(%esp)
c0106432:	e8 47 e9 ff ff       	call   c0104d7e <page_ref>
c0106437:	83 f8 02             	cmp    $0x2,%eax
c010643a:	74 24                	je     c0106460 <check_boot_pgdir+0x2a1>
c010643c:	c7 44 24 0c a3 b1 10 	movl   $0xc010b1a3,0xc(%esp)
c0106443:	c0 
c0106444:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c010644b:	c0 
c010644c:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c0106453:	00 
c0106454:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c010645b:	e8 77 a8 ff ff       	call   c0100cd7 <__panic>

    const char *str = "ucore: Hello world!!";
c0106460:	c7 45 dc b4 b1 10 c0 	movl   $0xc010b1b4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106467:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010646a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010646e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106475:	e8 9e 36 00 00       	call   c0109b18 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010647a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106481:	00 
c0106482:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106489:	e8 03 37 00 00       	call   c0109b91 <strcmp>
c010648e:	85 c0                	test   %eax,%eax
c0106490:	74 24                	je     c01064b6 <check_boot_pgdir+0x2f7>
c0106492:	c7 44 24 0c cc b1 10 	movl   $0xc010b1cc,0xc(%esp)
c0106499:	c0 
c010649a:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c01064a1:	c0 
c01064a2:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c01064a9:	00 
c01064aa:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01064b1:	e8 21 a8 ff ff       	call   c0100cd7 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01064b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064b9:	89 04 24             	mov    %eax,(%esp)
c01064bc:	e8 2b e8 ff ff       	call   c0104cec <page2kva>
c01064c1:	05 00 01 00 00       	add    $0x100,%eax
c01064c6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01064c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01064d0:	e8 eb 35 00 00       	call   c0109ac0 <strlen>
c01064d5:	85 c0                	test   %eax,%eax
c01064d7:	74 24                	je     c01064fd <check_boot_pgdir+0x33e>
c01064d9:	c7 44 24 0c 04 b2 10 	movl   $0xc010b204,0xc(%esp)
c01064e0:	c0 
c01064e1:	c7 44 24 08 99 ad 10 	movl   $0xc010ad99,0x8(%esp)
c01064e8:	c0 
c01064e9:	c7 44 24 04 6c 02 00 	movl   $0x26c,0x4(%esp)
c01064f0:	00 
c01064f1:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c01064f8:	e8 da a7 ff ff       	call   c0100cd7 <__panic>

    free_page(p);
c01064fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106504:	00 
c0106505:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106508:	89 04 24             	mov    %eax,(%esp)
c010650b:	e8 de ea ff ff       	call   c0104fee <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106510:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106515:	8b 00                	mov    (%eax),%eax
c0106517:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010651c:	89 04 24             	mov    %eax,(%esp)
c010651f:	e8 83 e7 ff ff       	call   c0104ca7 <pa2page>
c0106524:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010652b:	00 
c010652c:	89 04 24             	mov    %eax,(%esp)
c010652f:	e8 ba ea ff ff       	call   c0104fee <free_pages>
    boot_pgdir[0] = 0;
c0106534:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010653f:	c7 04 24 28 b2 10 c0 	movl   $0xc010b228,(%esp)
c0106546:	e8 08 9e ff ff       	call   c0100353 <cprintf>
}
c010654b:	c9                   	leave  
c010654c:	c3                   	ret    

c010654d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010654d:	55                   	push   %ebp
c010654e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106550:	8b 45 08             	mov    0x8(%ebp),%eax
c0106553:	83 e0 04             	and    $0x4,%eax
c0106556:	85 c0                	test   %eax,%eax
c0106558:	74 07                	je     c0106561 <perm2str+0x14>
c010655a:	b8 75 00 00 00       	mov    $0x75,%eax
c010655f:	eb 05                	jmp    c0106566 <perm2str+0x19>
c0106561:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106566:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c010656b:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106572:	8b 45 08             	mov    0x8(%ebp),%eax
c0106575:	83 e0 02             	and    $0x2,%eax
c0106578:	85 c0                	test   %eax,%eax
c010657a:	74 07                	je     c0106583 <perm2str+0x36>
c010657c:	b8 77 00 00 00       	mov    $0x77,%eax
c0106581:	eb 05                	jmp    c0106588 <perm2str+0x3b>
c0106583:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106588:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c010658d:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c0106594:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c0106599:	5d                   	pop    %ebp
c010659a:	c3                   	ret    

c010659b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010659b:	55                   	push   %ebp
c010659c:	89 e5                	mov    %esp,%ebp
c010659e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01065a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01065a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01065a7:	72 0a                	jb     c01065b3 <get_pgtable_items+0x18>
        return 0;
c01065a9:	b8 00 00 00 00       	mov    $0x0,%eax
c01065ae:	e9 9c 00 00 00       	jmp    c010664f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01065b3:	eb 04                	jmp    c01065b9 <get_pgtable_items+0x1e>
        start ++;
c01065b5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01065b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01065bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01065bf:	73 18                	jae    c01065d9 <get_pgtable_items+0x3e>
c01065c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01065c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01065cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01065ce:	01 d0                	add    %edx,%eax
c01065d0:	8b 00                	mov    (%eax),%eax
c01065d2:	83 e0 01             	and    $0x1,%eax
c01065d5:	85 c0                	test   %eax,%eax
c01065d7:	74 dc                	je     c01065b5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01065d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01065dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01065df:	73 69                	jae    c010664a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01065e1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01065e5:	74 08                	je     c01065ef <get_pgtable_items+0x54>
            *left_store = start;
c01065e7:	8b 45 18             	mov    0x18(%ebp),%eax
c01065ea:	8b 55 10             	mov    0x10(%ebp),%edx
c01065ed:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01065ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01065f2:	8d 50 01             	lea    0x1(%eax),%edx
c01065f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01065f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01065ff:	8b 45 14             	mov    0x14(%ebp),%eax
c0106602:	01 d0                	add    %edx,%eax
c0106604:	8b 00                	mov    (%eax),%eax
c0106606:	83 e0 07             	and    $0x7,%eax
c0106609:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010660c:	eb 04                	jmp    c0106612 <get_pgtable_items+0x77>
            start ++;
c010660e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106612:	8b 45 10             	mov    0x10(%ebp),%eax
c0106615:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106618:	73 1d                	jae    c0106637 <get_pgtable_items+0x9c>
c010661a:	8b 45 10             	mov    0x10(%ebp),%eax
c010661d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106624:	8b 45 14             	mov    0x14(%ebp),%eax
c0106627:	01 d0                	add    %edx,%eax
c0106629:	8b 00                	mov    (%eax),%eax
c010662b:	83 e0 07             	and    $0x7,%eax
c010662e:	89 c2                	mov    %eax,%edx
c0106630:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106633:	39 c2                	cmp    %eax,%edx
c0106635:	74 d7                	je     c010660e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106637:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010663b:	74 08                	je     c0106645 <get_pgtable_items+0xaa>
            *right_store = start;
c010663d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106640:	8b 55 10             	mov    0x10(%ebp),%edx
c0106643:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106645:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106648:	eb 05                	jmp    c010664f <get_pgtable_items+0xb4>
    }
    return 0;
c010664a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010664f:	c9                   	leave  
c0106650:	c3                   	ret    

c0106651 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106651:	55                   	push   %ebp
c0106652:	89 e5                	mov    %esp,%ebp
c0106654:	57                   	push   %edi
c0106655:	56                   	push   %esi
c0106656:	53                   	push   %ebx
c0106657:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010665a:	c7 04 24 48 b2 10 c0 	movl   $0xc010b248,(%esp)
c0106661:	e8 ed 9c ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106666:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010666d:	e9 fa 00 00 00       	jmp    c010676c <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106675:	89 04 24             	mov    %eax,(%esp)
c0106678:	e8 d0 fe ff ff       	call   c010654d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010667d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106680:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106683:	29 d1                	sub    %edx,%ecx
c0106685:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106687:	89 d6                	mov    %edx,%esi
c0106689:	c1 e6 16             	shl    $0x16,%esi
c010668c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010668f:	89 d3                	mov    %edx,%ebx
c0106691:	c1 e3 16             	shl    $0x16,%ebx
c0106694:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106697:	89 d1                	mov    %edx,%ecx
c0106699:	c1 e1 16             	shl    $0x16,%ecx
c010669c:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010669f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066a2:	29 d7                	sub    %edx,%edi
c01066a4:	89 fa                	mov    %edi,%edx
c01066a6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01066aa:	89 74 24 10          	mov    %esi,0x10(%esp)
c01066ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01066b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01066b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066ba:	c7 04 24 79 b2 10 c0 	movl   $0xc010b279,(%esp)
c01066c1:	e8 8d 9c ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01066c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066c9:	c1 e0 0a             	shl    $0xa,%eax
c01066cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01066cf:	eb 54                	jmp    c0106725 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01066d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066d4:	89 04 24             	mov    %eax,(%esp)
c01066d7:	e8 71 fe ff ff       	call   c010654d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01066dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01066df:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01066e2:	29 d1                	sub    %edx,%ecx
c01066e4:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01066e6:	89 d6                	mov    %edx,%esi
c01066e8:	c1 e6 0c             	shl    $0xc,%esi
c01066eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01066ee:	89 d3                	mov    %edx,%ebx
c01066f0:	c1 e3 0c             	shl    $0xc,%ebx
c01066f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01066f6:	c1 e2 0c             	shl    $0xc,%edx
c01066f9:	89 d1                	mov    %edx,%ecx
c01066fb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01066fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106701:	29 d7                	sub    %edx,%edi
c0106703:	89 fa                	mov    %edi,%edx
c0106705:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106709:	89 74 24 10          	mov    %esi,0x10(%esp)
c010670d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106711:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106715:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106719:	c7 04 24 98 b2 10 c0 	movl   $0xc010b298,(%esp)
c0106720:	e8 2e 9c ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106725:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010672a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010672d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106730:	89 ce                	mov    %ecx,%esi
c0106732:	c1 e6 0a             	shl    $0xa,%esi
c0106735:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106738:	89 cb                	mov    %ecx,%ebx
c010673a:	c1 e3 0a             	shl    $0xa,%ebx
c010673d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106740:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106744:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106747:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010674b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010674f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106753:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106757:	89 1c 24             	mov    %ebx,(%esp)
c010675a:	e8 3c fe ff ff       	call   c010659b <get_pgtable_items>
c010675f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106762:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106766:	0f 85 65 ff ff ff    	jne    c01066d1 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010676c:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106771:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106774:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106777:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010677b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010677e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106782:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106786:	89 44 24 08          	mov    %eax,0x8(%esp)
c010678a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106791:	00 
c0106792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106799:	e8 fd fd ff ff       	call   c010659b <get_pgtable_items>
c010679e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01067a5:	0f 85 c7 fe ff ff    	jne    c0106672 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01067ab:	c7 04 24 bc b2 10 c0 	movl   $0xc010b2bc,(%esp)
c01067b2:	e8 9c 9b ff ff       	call   c0100353 <cprintf>
}
c01067b7:	83 c4 4c             	add    $0x4c,%esp
c01067ba:	5b                   	pop    %ebx
c01067bb:	5e                   	pop    %esi
c01067bc:	5f                   	pop    %edi
c01067bd:	5d                   	pop    %ebp
c01067be:	c3                   	ret    

c01067bf <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01067bf:	55                   	push   %ebp
c01067c0:	89 e5                	mov    %esp,%ebp
c01067c2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01067c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01067c8:	c1 e8 0c             	shr    $0xc,%eax
c01067cb:	89 c2                	mov    %eax,%edx
c01067cd:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01067d2:	39 c2                	cmp    %eax,%edx
c01067d4:	72 1c                	jb     c01067f2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01067d6:	c7 44 24 08 f0 b2 10 	movl   $0xc010b2f0,0x8(%esp)
c01067dd:	c0 
c01067de:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01067e5:	00 
c01067e6:	c7 04 24 0f b3 10 c0 	movl   $0xc010b30f,(%esp)
c01067ed:	e8 e5 a4 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c01067f2:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01067f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01067fa:	c1 ea 0c             	shr    $0xc,%edx
c01067fd:	c1 e2 05             	shl    $0x5,%edx
c0106800:	01 d0                	add    %edx,%eax
}
c0106802:	c9                   	leave  
c0106803:	c3                   	ret    

c0106804 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106804:	55                   	push   %ebp
c0106805:	89 e5                	mov    %esp,%ebp
c0106807:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010680a:	8b 45 08             	mov    0x8(%ebp),%eax
c010680d:	83 e0 01             	and    $0x1,%eax
c0106810:	85 c0                	test   %eax,%eax
c0106812:	75 1c                	jne    c0106830 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106814:	c7 44 24 08 20 b3 10 	movl   $0xc010b320,0x8(%esp)
c010681b:	c0 
c010681c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0106823:	00 
c0106824:	c7 04 24 0f b3 10 c0 	movl   $0xc010b30f,(%esp)
c010682b:	e8 a7 a4 ff ff       	call   c0100cd7 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106830:	8b 45 08             	mov    0x8(%ebp),%eax
c0106833:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106838:	89 04 24             	mov    %eax,(%esp)
c010683b:	e8 7f ff ff ff       	call   c01067bf <pa2page>
}
c0106840:	c9                   	leave  
c0106841:	c3                   	ret    

c0106842 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106842:	55                   	push   %ebp
c0106843:	89 e5                	mov    %esp,%ebp
c0106845:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106848:	e8 b0 1d 00 00       	call   c01085fd <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010684d:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106852:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106857:	76 0c                	jbe    c0106865 <swap_init+0x23>
c0106859:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010685e:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106863:	76 25                	jbe    c010688a <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106865:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010686a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010686e:	c7 44 24 08 41 b3 10 	movl   $0xc010b341,0x8(%esp)
c0106875:	c0 
c0106876:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010687d:	00 
c010687e:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106885:	e8 4d a4 ff ff       	call   c0100cd7 <__panic>
     }
     

     sm = &swap_manager_fifo;
c010688a:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c0106891:	4a 12 c0 
     int r = sm->init();
c0106894:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106899:	8b 40 04             	mov    0x4(%eax),%eax
c010689c:	ff d0                	call   *%eax
c010689e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01068a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068a5:	75 26                	jne    c01068cd <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01068a7:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c01068ae:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01068b1:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01068b6:	8b 00                	mov    (%eax),%eax
c01068b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068bc:	c7 04 24 6b b3 10 c0 	movl   $0xc010b36b,(%esp)
c01068c3:	e8 8b 9a ff ff       	call   c0100353 <cprintf>
          check_swap();
c01068c8:	e8 a4 04 00 00       	call   c0106d71 <check_swap>
     }

     return r;
c01068cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068d0:	c9                   	leave  
c01068d1:	c3                   	ret    

c01068d2 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01068d2:	55                   	push   %ebp
c01068d3:	89 e5                	mov    %esp,%ebp
c01068d5:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01068d8:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01068dd:	8b 40 08             	mov    0x8(%eax),%eax
c01068e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01068e3:	89 14 24             	mov    %edx,(%esp)
c01068e6:	ff d0                	call   *%eax
}
c01068e8:	c9                   	leave  
c01068e9:	c3                   	ret    

c01068ea <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01068ea:	55                   	push   %ebp
c01068eb:	89 e5                	mov    %esp,%ebp
c01068ed:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01068f0:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01068f5:	8b 40 0c             	mov    0xc(%eax),%eax
c01068f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01068fb:	89 14 24             	mov    %edx,(%esp)
c01068fe:	ff d0                	call   *%eax
}
c0106900:	c9                   	leave  
c0106901:	c3                   	ret    

c0106902 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106902:	55                   	push   %ebp
c0106903:	89 e5                	mov    %esp,%ebp
c0106905:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106908:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010690d:	8b 40 10             	mov    0x10(%eax),%eax
c0106910:	8b 55 14             	mov    0x14(%ebp),%edx
c0106913:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106917:	8b 55 10             	mov    0x10(%ebp),%edx
c010691a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010691e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106921:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106925:	8b 55 08             	mov    0x8(%ebp),%edx
c0106928:	89 14 24             	mov    %edx,(%esp)
c010692b:	ff d0                	call   *%eax
}
c010692d:	c9                   	leave  
c010692e:	c3                   	ret    

c010692f <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010692f:	55                   	push   %ebp
c0106930:	89 e5                	mov    %esp,%ebp
c0106932:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106935:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010693a:	8b 40 14             	mov    0x14(%eax),%eax
c010693d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106940:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106944:	8b 55 08             	mov    0x8(%ebp),%edx
c0106947:	89 14 24             	mov    %edx,(%esp)
c010694a:	ff d0                	call   *%eax
}
c010694c:	c9                   	leave  
c010694d:	c3                   	ret    

c010694e <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010694e:	55                   	push   %ebp
c010694f:	89 e5                	mov    %esp,%ebp
c0106951:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010695b:	e9 5a 01 00 00       	jmp    c0106aba <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106960:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106965:	8b 40 18             	mov    0x18(%eax),%eax
c0106968:	8b 55 10             	mov    0x10(%ebp),%edx
c010696b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010696f:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106972:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106976:	8b 55 08             	mov    0x8(%ebp),%edx
c0106979:	89 14 24             	mov    %edx,(%esp)
c010697c:	ff d0                	call   *%eax
c010697e:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106981:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106985:	74 18                	je     c010699f <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106987:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010698a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010698e:	c7 04 24 80 b3 10 c0 	movl   $0xc010b380,(%esp)
c0106995:	e8 b9 99 ff ff       	call   c0100353 <cprintf>
c010699a:	e9 27 01 00 00       	jmp    c0106ac6 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c010699f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069a2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01069a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01069a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ab:	8b 40 0c             	mov    0xc(%eax),%eax
c01069ae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01069b5:	00 
c01069b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01069b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069bd:	89 04 24             	mov    %eax,(%esp)
c01069c0:	e8 25 ed ff ff       	call   c01056ea <get_pte>
c01069c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01069c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01069cb:	8b 00                	mov    (%eax),%eax
c01069cd:	83 e0 01             	and    $0x1,%eax
c01069d0:	85 c0                	test   %eax,%eax
c01069d2:	75 24                	jne    c01069f8 <swap_out+0xaa>
c01069d4:	c7 44 24 0c ad b3 10 	movl   $0xc010b3ad,0xc(%esp)
c01069db:	c0 
c01069dc:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c01069e3:	c0 
c01069e4:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01069eb:	00 
c01069ec:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c01069f3:	e8 df a2 ff ff       	call   c0100cd7 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01069f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01069fe:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106a01:	c1 ea 0c             	shr    $0xc,%edx
c0106a04:	83 c2 01             	add    $0x1,%edx
c0106a07:	c1 e2 08             	shl    $0x8,%edx
c0106a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a0e:	89 14 24             	mov    %edx,(%esp)
c0106a11:	e8 a1 1c 00 00       	call   c01086b7 <swapfs_write>
c0106a16:	85 c0                	test   %eax,%eax
c0106a18:	74 34                	je     c0106a4e <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106a1a:	c7 04 24 d7 b3 10 c0 	movl   $0xc010b3d7,(%esp)
c0106a21:	e8 2d 99 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106a26:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106a2b:	8b 40 10             	mov    0x10(%eax),%eax
c0106a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a31:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106a38:	00 
c0106a39:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106a3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a44:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a47:	89 14 24             	mov    %edx,(%esp)
c0106a4a:	ff d0                	call   *%eax
c0106a4c:	eb 68                	jmp    c0106ab6 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a51:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106a54:	c1 e8 0c             	shr    $0xc,%eax
c0106a57:	83 c0 01             	add    $0x1,%eax
c0106a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a61:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a6c:	c7 04 24 f0 b3 10 c0 	movl   $0xc010b3f0,(%esp)
c0106a73:	e8 db 98 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a7b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106a7e:	c1 e8 0c             	shr    $0xc,%eax
c0106a81:	83 c0 01             	add    $0x1,%eax
c0106a84:	c1 e0 08             	shl    $0x8,%eax
c0106a87:	89 c2                	mov    %eax,%edx
c0106a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106a8c:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a98:	00 
c0106a99:	89 04 24             	mov    %eax,(%esp)
c0106a9c:	e8 4d e5 ff ff       	call   c0104fee <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa4:	8b 40 0c             	mov    0xc(%eax),%eax
c0106aa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106aae:	89 04 24             	mov    %eax,(%esp)
c0106ab1:	e8 28 ef ff ff       	call   c01059de <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106ab6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106abd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106ac0:	0f 85 9a fe ff ff    	jne    c0106960 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106ac9:	c9                   	leave  
c0106aca:	c3                   	ret    

c0106acb <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106acb:	55                   	push   %ebp
c0106acc:	89 e5                	mov    %esp,%ebp
c0106ace:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106ad1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106ad8:	e8 a6 e4 ff ff       	call   c0104f83 <alloc_pages>
c0106add:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ae4:	75 24                	jne    c0106b0a <swap_in+0x3f>
c0106ae6:	c7 44 24 0c 30 b4 10 	movl   $0xc010b430,0xc(%esp)
c0106aed:	c0 
c0106aee:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106af5:	c0 
c0106af6:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106afd:	00 
c0106afe:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106b05:	e8 cd a1 ff ff       	call   c0100cd7 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b0d:	8b 40 0c             	mov    0xc(%eax),%eax
c0106b10:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106b17:	00 
c0106b18:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106b1b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b1f:	89 04 24             	mov    %eax,(%esp)
c0106b22:	e8 c3 eb ff ff       	call   c01056ea <get_pte>
c0106b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b2d:	8b 00                	mov    (%eax),%eax
c0106b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106b32:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b36:	89 04 24             	mov    %eax,(%esp)
c0106b39:	e8 07 1b 00 00       	call   c0108645 <swapfs_read>
c0106b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106b45:	74 2a                	je     c0106b71 <swap_in+0xa6>
     {
        assert(r!=0);
c0106b47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106b4b:	75 24                	jne    c0106b71 <swap_in+0xa6>
c0106b4d:	c7 44 24 0c 3d b4 10 	movl   $0xc010b43d,0xc(%esp)
c0106b54:	c0 
c0106b55:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106b5c:	c0 
c0106b5d:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106b64:	00 
c0106b65:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106b6c:	e8 66 a1 ff ff       	call   c0100cd7 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b74:	8b 00                	mov    (%eax),%eax
c0106b76:	c1 e8 08             	shr    $0x8,%eax
c0106b79:	89 c2                	mov    %eax,%edx
c0106b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b7e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106b82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b86:	c7 04 24 44 b4 10 c0 	movl   $0xc010b444,(%esp)
c0106b8d:	e8 c1 97 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0106b92:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106b98:	89 10                	mov    %edx,(%eax)
     return 0;
c0106b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b9f:	c9                   	leave  
c0106ba0:	c3                   	ret    

c0106ba1 <check_content_set>:



static inline void
check_content_set(void)
{
c0106ba1:	55                   	push   %ebp
c0106ba2:	89 e5                	mov    %esp,%ebp
c0106ba4:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106ba7:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106bac:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106baf:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106bb4:	83 f8 01             	cmp    $0x1,%eax
c0106bb7:	74 24                	je     c0106bdd <check_content_set+0x3c>
c0106bb9:	c7 44 24 0c 82 b4 10 	movl   $0xc010b482,0xc(%esp)
c0106bc0:	c0 
c0106bc1:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106bc8:	c0 
c0106bc9:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106bd0:	00 
c0106bd1:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106bd8:	e8 fa a0 ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106bdd:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106be2:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106be5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106bea:	83 f8 01             	cmp    $0x1,%eax
c0106bed:	74 24                	je     c0106c13 <check_content_set+0x72>
c0106bef:	c7 44 24 0c 82 b4 10 	movl   $0xc010b482,0xc(%esp)
c0106bf6:	c0 
c0106bf7:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106bfe:	c0 
c0106bff:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106c06:	00 
c0106c07:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106c0e:	e8 c4 a0 ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106c13:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106c18:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106c1b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106c20:	83 f8 02             	cmp    $0x2,%eax
c0106c23:	74 24                	je     c0106c49 <check_content_set+0xa8>
c0106c25:	c7 44 24 0c 91 b4 10 	movl   $0xc010b491,0xc(%esp)
c0106c2c:	c0 
c0106c2d:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106c34:	c0 
c0106c35:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106c3c:	00 
c0106c3d:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106c44:	e8 8e a0 ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106c49:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106c4e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106c51:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106c56:	83 f8 02             	cmp    $0x2,%eax
c0106c59:	74 24                	je     c0106c7f <check_content_set+0xde>
c0106c5b:	c7 44 24 0c 91 b4 10 	movl   $0xc010b491,0xc(%esp)
c0106c62:	c0 
c0106c63:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106c6a:	c0 
c0106c6b:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106c72:	00 
c0106c73:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106c7a:	e8 58 a0 ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106c7f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106c84:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106c87:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106c8c:	83 f8 03             	cmp    $0x3,%eax
c0106c8f:	74 24                	je     c0106cb5 <check_content_set+0x114>
c0106c91:	c7 44 24 0c a0 b4 10 	movl   $0xc010b4a0,0xc(%esp)
c0106c98:	c0 
c0106c99:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106ca0:	c0 
c0106ca1:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106ca8:	00 
c0106ca9:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106cb0:	e8 22 a0 ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106cb5:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106cba:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106cbd:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106cc2:	83 f8 03             	cmp    $0x3,%eax
c0106cc5:	74 24                	je     c0106ceb <check_content_set+0x14a>
c0106cc7:	c7 44 24 0c a0 b4 10 	movl   $0xc010b4a0,0xc(%esp)
c0106cce:	c0 
c0106ccf:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106cd6:	c0 
c0106cd7:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106cde:	00 
c0106cdf:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106ce6:	e8 ec 9f ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106ceb:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106cf0:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106cf3:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106cf8:	83 f8 04             	cmp    $0x4,%eax
c0106cfb:	74 24                	je     c0106d21 <check_content_set+0x180>
c0106cfd:	c7 44 24 0c af b4 10 	movl   $0xc010b4af,0xc(%esp)
c0106d04:	c0 
c0106d05:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106d0c:	c0 
c0106d0d:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106d14:	00 
c0106d15:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106d1c:	e8 b6 9f ff ff       	call   c0100cd7 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106d21:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106d26:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106d29:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106d2e:	83 f8 04             	cmp    $0x4,%eax
c0106d31:	74 24                	je     c0106d57 <check_content_set+0x1b6>
c0106d33:	c7 44 24 0c af b4 10 	movl   $0xc010b4af,0xc(%esp)
c0106d3a:	c0 
c0106d3b:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106d42:	c0 
c0106d43:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106d4a:	00 
c0106d4b:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106d52:	e8 80 9f ff ff       	call   c0100cd7 <__panic>
}
c0106d57:	c9                   	leave  
c0106d58:	c3                   	ret    

c0106d59 <check_content_access>:

static inline int
check_content_access(void)
{
c0106d59:	55                   	push   %ebp
c0106d5a:	89 e5                	mov    %esp,%ebp
c0106d5c:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106d5f:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106d64:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106d67:	ff d0                	call   *%eax
c0106d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106d6f:	c9                   	leave  
c0106d70:	c3                   	ret    

c0106d71 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106d71:	55                   	push   %ebp
c0106d72:	89 e5                	mov    %esp,%ebp
c0106d74:	53                   	push   %ebx
c0106d75:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106d7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106d86:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106d8d:	eb 6b                	jmp    c0106dfa <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d92:	83 e8 0c             	sub    $0xc,%eax
c0106d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d9b:	83 c0 04             	add    $0x4,%eax
c0106d9e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106da5:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106da8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106dab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106dae:	0f a3 10             	bt     %edx,(%eax)
c0106db1:	19 c0                	sbb    %eax,%eax
c0106db3:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106db6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106dba:	0f 95 c0             	setne  %al
c0106dbd:	0f b6 c0             	movzbl %al,%eax
c0106dc0:	85 c0                	test   %eax,%eax
c0106dc2:	75 24                	jne    c0106de8 <check_swap+0x77>
c0106dc4:	c7 44 24 0c be b4 10 	movl   $0xc010b4be,0xc(%esp)
c0106dcb:	c0 
c0106dcc:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106dd3:	c0 
c0106dd4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106ddb:	00 
c0106ddc:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106de3:	e8 ef 9e ff ff       	call   c0100cd7 <__panic>
        count ++, total += p->property;
c0106de8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106def:	8b 50 08             	mov    0x8(%eax),%edx
c0106df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106df5:	01 d0                	add    %edx,%eax
c0106df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106dfd:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106e00:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106e03:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106e06:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106e09:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106e10:	0f 85 79 ff ff ff    	jne    c0106d8f <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106e16:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106e19:	e8 02 e2 ff ff       	call   c0105020 <nr_free_pages>
c0106e1e:	39 c3                	cmp    %eax,%ebx
c0106e20:	74 24                	je     c0106e46 <check_swap+0xd5>
c0106e22:	c7 44 24 0c ce b4 10 	movl   $0xc010b4ce,0xc(%esp)
c0106e29:	c0 
c0106e2a:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106e31:	c0 
c0106e32:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106e39:	00 
c0106e3a:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106e41:	e8 91 9e ff ff       	call   c0100cd7 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e49:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e54:	c7 04 24 e8 b4 10 c0 	movl   $0xc010b4e8,(%esp)
c0106e5b:	e8 f3 94 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106e60:	e8 3b 0a 00 00       	call   c01078a0 <mm_create>
c0106e65:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106e68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106e6c:	75 24                	jne    c0106e92 <check_swap+0x121>
c0106e6e:	c7 44 24 0c 0e b5 10 	movl   $0xc010b50e,0xc(%esp)
c0106e75:	c0 
c0106e76:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106e7d:	c0 
c0106e7e:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106e85:	00 
c0106e86:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106e8d:	e8 45 9e ff ff       	call   c0100cd7 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106e92:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106e97:	85 c0                	test   %eax,%eax
c0106e99:	74 24                	je     c0106ebf <check_swap+0x14e>
c0106e9b:	c7 44 24 0c 19 b5 10 	movl   $0xc010b519,0xc(%esp)
c0106ea2:	c0 
c0106ea3:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106eaa:	c0 
c0106eab:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106eb2:	00 
c0106eb3:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106eba:	e8 18 9e ff ff       	call   c0100cd7 <__panic>

     check_mm_struct = mm;
c0106ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ec2:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106ec7:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ed0:	89 50 0c             	mov    %edx,0xc(%eax)
c0106ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ed6:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ed9:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106edf:	8b 00                	mov    (%eax),%eax
c0106ee1:	85 c0                	test   %eax,%eax
c0106ee3:	74 24                	je     c0106f09 <check_swap+0x198>
c0106ee5:	c7 44 24 0c 31 b5 10 	movl   $0xc010b531,0xc(%esp)
c0106eec:	c0 
c0106eed:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106ef4:	c0 
c0106ef5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106efc:	00 
c0106efd:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106f04:	e8 ce 9d ff ff       	call   c0100cd7 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106f09:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106f10:	00 
c0106f11:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106f18:	00 
c0106f19:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106f20:	e8 f3 09 00 00       	call   c0107918 <vma_create>
c0106f25:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106f28:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106f2c:	75 24                	jne    c0106f52 <check_swap+0x1e1>
c0106f2e:	c7 44 24 0c 3f b5 10 	movl   $0xc010b53f,0xc(%esp)
c0106f35:	c0 
c0106f36:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106f3d:	c0 
c0106f3e:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106f45:	00 
c0106f46:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106f4d:	e8 85 9d ff ff       	call   c0100cd7 <__panic>

     insert_vma_struct(mm, vma);
c0106f52:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106f55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f5c:	89 04 24             	mov    %eax,(%esp)
c0106f5f:	e8 44 0b 00 00       	call   c0107aa8 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106f64:	c7 04 24 4c b5 10 c0 	movl   $0xc010b54c,(%esp)
c0106f6b:	e8 e3 93 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106f70:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f7a:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f7d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106f84:	00 
c0106f85:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106f8c:	00 
c0106f8d:	89 04 24             	mov    %eax,(%esp)
c0106f90:	e8 55 e7 ff ff       	call   c01056ea <get_pte>
c0106f95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106f98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106f9c:	75 24                	jne    c0106fc2 <check_swap+0x251>
c0106f9e:	c7 44 24 0c 80 b5 10 	movl   $0xc010b580,0xc(%esp)
c0106fa5:	c0 
c0106fa6:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0106fad:	c0 
c0106fae:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106fb5:	00 
c0106fb6:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0106fbd:	e8 15 9d ff ff       	call   c0100cd7 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106fc2:	c7 04 24 94 b5 10 c0 	movl   $0xc010b594,(%esp)
c0106fc9:	e8 85 93 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106fce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106fd5:	e9 a3 00 00 00       	jmp    c010707d <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106fda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106fe1:	e8 9d df ff ff       	call   c0104f83 <alloc_pages>
c0106fe6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106fe9:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ff3:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106ffa:	85 c0                	test   %eax,%eax
c0106ffc:	75 24                	jne    c0107022 <check_swap+0x2b1>
c0106ffe:	c7 44 24 0c b8 b5 10 	movl   $0xc010b5b8,0xc(%esp)
c0107005:	c0 
c0107006:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c010700d:	c0 
c010700e:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107015:	00 
c0107016:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c010701d:	e8 b5 9c ff ff       	call   c0100cd7 <__panic>
          assert(!PageProperty(check_rp[i]));
c0107022:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107025:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c010702c:	83 c0 04             	add    $0x4,%eax
c010702f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0107036:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107039:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010703c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010703f:	0f a3 10             	bt     %edx,(%eax)
c0107042:	19 c0                	sbb    %eax,%eax
c0107044:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0107047:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010704b:	0f 95 c0             	setne  %al
c010704e:	0f b6 c0             	movzbl %al,%eax
c0107051:	85 c0                	test   %eax,%eax
c0107053:	74 24                	je     c0107079 <check_swap+0x308>
c0107055:	c7 44 24 0c cc b5 10 	movl   $0xc010b5cc,0xc(%esp)
c010705c:	c0 
c010705d:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0107064:	c0 
c0107065:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010706c:	00 
c010706d:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0107074:	e8 5e 9c ff ff       	call   c0100cd7 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107079:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010707d:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107081:	0f 8e 53 ff ff ff    	jle    c0106fda <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0107087:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c010708c:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0107092:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107095:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0107098:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010709f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01070a2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01070a5:	89 50 04             	mov    %edx,0x4(%eax)
c01070a8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01070ab:	8b 50 04             	mov    0x4(%eax),%edx
c01070ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01070b1:	89 10                	mov    %edx,(%eax)
c01070b3:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01070ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01070bd:	8b 40 04             	mov    0x4(%eax),%eax
c01070c0:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01070c3:	0f 94 c0             	sete   %al
c01070c6:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01070c9:	85 c0                	test   %eax,%eax
c01070cb:	75 24                	jne    c01070f1 <check_swap+0x380>
c01070cd:	c7 44 24 0c e7 b5 10 	movl   $0xc010b5e7,0xc(%esp)
c01070d4:	c0 
c01070d5:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c01070dc:	c0 
c01070dd:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01070e4:	00 
c01070e5:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c01070ec:	e8 e6 9b ff ff       	call   c0100cd7 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01070f1:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01070f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01070f9:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0107100:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107103:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010710a:	eb 1e                	jmp    c010712a <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c010710c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010710f:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0107116:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010711d:	00 
c010711e:	89 04 24             	mov    %eax,(%esp)
c0107121:	e8 c8 de ff ff       	call   c0104fee <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107126:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010712a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010712e:	7e dc                	jle    c010710c <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107130:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0107135:	83 f8 04             	cmp    $0x4,%eax
c0107138:	74 24                	je     c010715e <check_swap+0x3ed>
c010713a:	c7 44 24 0c 00 b6 10 	movl   $0xc010b600,0xc(%esp)
c0107141:	c0 
c0107142:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0107149:	c0 
c010714a:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107151:	00 
c0107152:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0107159:	e8 79 9b ff ff       	call   c0100cd7 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010715e:	c7 04 24 24 b6 10 c0 	movl   $0xc010b624,(%esp)
c0107165:	e8 e9 91 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010716a:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0107171:	00 00 00 
     
     check_content_set();
c0107174:	e8 28 fa ff ff       	call   c0106ba1 <check_content_set>
     assert( nr_free == 0);         
c0107179:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010717e:	85 c0                	test   %eax,%eax
c0107180:	74 24                	je     c01071a6 <check_swap+0x435>
c0107182:	c7 44 24 0c 4b b6 10 	movl   $0xc010b64b,0xc(%esp)
c0107189:	c0 
c010718a:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0107191:	c0 
c0107192:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0107199:	00 
c010719a:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c01071a1:	e8 31 9b ff ff       	call   c0100cd7 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01071a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01071ad:	eb 26                	jmp    c01071d5 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01071af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071b2:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c01071b9:	ff ff ff ff 
c01071bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071c0:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c01071c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071ca:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01071d1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01071d5:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01071d9:	7e d4                	jle    c01071af <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01071db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01071e2:	e9 eb 00 00 00       	jmp    c01072d2 <check_swap+0x561>
         check_ptep[i]=0;
c01071e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071ea:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c01071f1:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01071f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071f8:	83 c0 01             	add    $0x1,%eax
c01071fb:	c1 e0 0c             	shl    $0xc,%eax
c01071fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107205:	00 
c0107206:	89 44 24 04          	mov    %eax,0x4(%esp)
c010720a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010720d:	89 04 24             	mov    %eax,(%esp)
c0107210:	e8 d5 e4 ff ff       	call   c01056ea <get_pte>
c0107215:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107218:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c010721f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107222:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107229:	85 c0                	test   %eax,%eax
c010722b:	75 24                	jne    c0107251 <check_swap+0x4e0>
c010722d:	c7 44 24 0c 58 b6 10 	movl   $0xc010b658,0xc(%esp)
c0107234:	c0 
c0107235:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c010723c:	c0 
c010723d:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107244:	00 
c0107245:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c010724c:	e8 86 9a ff ff       	call   c0100cd7 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107251:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107254:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c010725b:	8b 00                	mov    (%eax),%eax
c010725d:	89 04 24             	mov    %eax,(%esp)
c0107260:	e8 9f f5 ff ff       	call   c0106804 <pte2page>
c0107265:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107268:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c010726f:	39 d0                	cmp    %edx,%eax
c0107271:	74 24                	je     c0107297 <check_swap+0x526>
c0107273:	c7 44 24 0c 70 b6 10 	movl   $0xc010b670,0xc(%esp)
c010727a:	c0 
c010727b:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0107282:	c0 
c0107283:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010728a:	00 
c010728b:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0107292:	e8 40 9a ff ff       	call   c0100cd7 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107297:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010729a:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c01072a1:	8b 00                	mov    (%eax),%eax
c01072a3:	83 e0 01             	and    $0x1,%eax
c01072a6:	85 c0                	test   %eax,%eax
c01072a8:	75 24                	jne    c01072ce <check_swap+0x55d>
c01072aa:	c7 44 24 0c 98 b6 10 	movl   $0xc010b698,0xc(%esp)
c01072b1:	c0 
c01072b2:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c01072b9:	c0 
c01072ba:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01072c1:	00 
c01072c2:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c01072c9:	e8 09 9a ff ff       	call   c0100cd7 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01072ce:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01072d2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01072d6:	0f 8e 0b ff ff ff    	jle    c01071e7 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01072dc:	c7 04 24 b4 b6 10 c0 	movl   $0xc010b6b4,(%esp)
c01072e3:	e8 6b 90 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01072e8:	e8 6c fa ff ff       	call   c0106d59 <check_content_access>
c01072ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01072f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01072f4:	74 24                	je     c010731a <check_swap+0x5a9>
c01072f6:	c7 44 24 0c da b6 10 	movl   $0xc010b6da,0xc(%esp)
c01072fd:	c0 
c01072fe:	c7 44 24 08 c2 b3 10 	movl   $0xc010b3c2,0x8(%esp)
c0107305:	c0 
c0107306:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010730d:	00 
c010730e:	c7 04 24 5c b3 10 c0 	movl   $0xc010b35c,(%esp)
c0107315:	e8 bd 99 ff ff       	call   c0100cd7 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010731a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107321:	eb 1e                	jmp    c0107341 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107323:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107326:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c010732d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107334:	00 
c0107335:	89 04 24             	mov    %eax,(%esp)
c0107338:	e8 b1 dc ff ff       	call   c0104fee <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010733d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107341:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107345:	7e dc                	jle    c0107323 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0107347:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010734a:	89 04 24             	mov    %eax,(%esp)
c010734d:	e8 86 08 00 00       	call   c0107bd8 <mm_destroy>
         
     nr_free = nr_free_store;
c0107352:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107355:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c010735a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010735d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107360:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0107365:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c010736b:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107372:	eb 1d                	jmp    c0107391 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0107374:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107377:	83 e8 0c             	sub    $0xc,%eax
c010737a:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c010737d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107381:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107384:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107387:	8b 40 08             	mov    0x8(%eax),%eax
c010738a:	29 c2                	sub    %eax,%edx
c010738c:	89 d0                	mov    %edx,%eax
c010738e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107391:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107394:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107397:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010739a:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010739d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01073a0:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c01073a7:	75 cb                	jne    c0107374 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c01073a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073ac:	89 44 24 08          	mov    %eax,0x8(%esp)
c01073b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073b7:	c7 04 24 e1 b6 10 c0 	movl   $0xc010b6e1,(%esp)
c01073be:	e8 90 8f ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01073c3:	c7 04 24 fb b6 10 c0 	movl   $0xc010b6fb,(%esp)
c01073ca:	e8 84 8f ff ff       	call   c0100353 <cprintf>
}
c01073cf:	83 c4 74             	add    $0x74,%esp
c01073d2:	5b                   	pop    %ebx
c01073d3:	5d                   	pop    %ebp
c01073d4:	c3                   	ret    

c01073d5 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01073d5:	55                   	push   %ebp
c01073d6:	89 e5                	mov    %esp,%ebp
c01073d8:	83 ec 10             	sub    $0x10,%esp
c01073db:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01073e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01073e8:	89 50 04             	mov    %edx,0x4(%eax)
c01073eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073ee:	8b 50 04             	mov    0x4(%eax),%edx
c01073f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073f4:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01073f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01073f9:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107400:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107405:	c9                   	leave  
c0107406:	c3                   	ret    

c0107407 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107407:	55                   	push   %ebp
c0107408:	89 e5                	mov    %esp,%ebp
c010740a:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010740d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107410:	8b 40 14             	mov    0x14(%eax),%eax
c0107413:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107416:	8b 45 10             	mov    0x10(%ebp),%eax
c0107419:	83 c0 14             	add    $0x14,%eax
c010741c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010741f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107423:	74 06                	je     c010742b <_fifo_map_swappable+0x24>
c0107425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107429:	75 24                	jne    c010744f <_fifo_map_swappable+0x48>
c010742b:	c7 44 24 0c 14 b7 10 	movl   $0xc010b714,0xc(%esp)
c0107432:	c0 
c0107433:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c010743a:	c0 
c010743b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0107442:	00 
c0107443:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c010744a:	e8 88 98 ff ff       	call   c0100cd7 <__panic>
c010744f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107452:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107458:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010745b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010745e:	8b 40 04             	mov    0x4(%eax),%eax
c0107461:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107464:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107467:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010746a:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010746d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107470:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107476:	89 10                	mov    %edx,(%eax)
c0107478:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010747b:	8b 10                	mov    (%eax),%edx
c010747d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107480:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107486:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107489:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010748c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010748f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107492:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
c0107494:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107499:	c9                   	leave  
c010749a:	c3                   	ret    

c010749b <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010749b:	55                   	push   %ebp
c010749c:	89 e5                	mov    %esp,%ebp
c010749e:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01074a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01074a4:	8b 40 14             	mov    0x14(%eax),%eax
c01074a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01074aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074ae:	75 24                	jne    c01074d4 <_fifo_swap_out_victim+0x39>
c01074b0:	c7 44 24 0c 5b b7 10 	movl   $0xc010b75b,0xc(%esp)
c01074b7:	c0 
c01074b8:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c01074bf:	c0 
c01074c0:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01074c7:	00 
c01074c8:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01074cf:	e8 03 98 ff ff       	call   c0100cd7 <__panic>
     assert(in_tick==0);
c01074d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01074d8:	74 24                	je     c01074fe <_fifo_swap_out_victim+0x63>
c01074da:	c7 44 24 0c 68 b7 10 	movl   $0xc010b768,0xc(%esp)
c01074e1:	c0 
c01074e2:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c01074e9:	c0 
c01074ea:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01074f1:	00 
c01074f2:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01074f9:	e8 d9 97 ff ff       	call   c0100cd7 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t* tar = head->prev;
c01074fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107501:	8b 00                	mov    (%eax),%eax
c0107503:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(tar != head);
c0107506:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107509:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010750c:	75 24                	jne    c0107532 <_fifo_swap_out_victim+0x97>
c010750e:	c7 44 24 0c 73 b7 10 	movl   $0xc010b773,0xc(%esp)
c0107515:	c0 
c0107516:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c010751d:	c0 
c010751e:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0107525:	00 
c0107526:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c010752d:	e8 a5 97 ff ff       	call   c0100cd7 <__panic>
     struct Page* p = le2page(tar, pra_page_link);
c0107532:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107535:	83 e8 14             	sub    $0x14,%eax
c0107538:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010753b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010753e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107541:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107544:	8b 40 04             	mov    0x4(%eax),%eax
c0107547:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010754a:	8b 12                	mov    (%edx),%edx
c010754c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010754f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107555:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107558:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010755b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010755e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107561:	89 10                	mov    %edx,(%eax)
     list_del(tar);
     assert(p != NULL);
c0107563:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107567:	75 24                	jne    c010758d <_fifo_swap_out_victim+0xf2>
c0107569:	c7 44 24 0c 7f b7 10 	movl   $0xc010b77f,0xc(%esp)
c0107570:	c0 
c0107571:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107578:	c0 
c0107579:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0107580:	00 
c0107581:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c0107588:	e8 4a 97 ff ff       	call   c0100cd7 <__panic>
     *ptr_page = p;
c010758d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107590:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107593:	89 10                	mov    %edx,(%eax)
     return 0;
c0107595:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010759a:	c9                   	leave  
c010759b:	c3                   	ret    

c010759c <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c010759c:	55                   	push   %ebp
c010759d:	89 e5                	mov    %esp,%ebp
c010759f:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01075a2:	c7 04 24 8c b7 10 c0 	movl   $0xc010b78c,(%esp)
c01075a9:	e8 a5 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01075ae:	b8 00 30 00 00       	mov    $0x3000,%eax
c01075b3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01075b6:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075bb:	83 f8 04             	cmp    $0x4,%eax
c01075be:	74 24                	je     c01075e4 <_fifo_check_swap+0x48>
c01075c0:	c7 44 24 0c b2 b7 10 	movl   $0xc010b7b2,0xc(%esp)
c01075c7:	c0 
c01075c8:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c01075cf:	c0 
c01075d0:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c01075d7:	00 
c01075d8:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01075df:	e8 f3 96 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01075e4:	c7 04 24 c4 b7 10 c0 	movl   $0xc010b7c4,(%esp)
c01075eb:	e8 63 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01075f0:	b8 00 10 00 00       	mov    $0x1000,%eax
c01075f5:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01075f8:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075fd:	83 f8 04             	cmp    $0x4,%eax
c0107600:	74 24                	je     c0107626 <_fifo_check_swap+0x8a>
c0107602:	c7 44 24 0c b2 b7 10 	movl   $0xc010b7b2,0xc(%esp)
c0107609:	c0 
c010760a:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107611:	c0 
c0107612:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107619:	00 
c010761a:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c0107621:	e8 b1 96 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107626:	c7 04 24 ec b7 10 c0 	movl   $0xc010b7ec,(%esp)
c010762d:	e8 21 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107632:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107637:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c010763a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010763f:	83 f8 04             	cmp    $0x4,%eax
c0107642:	74 24                	je     c0107668 <_fifo_check_swap+0xcc>
c0107644:	c7 44 24 0c b2 b7 10 	movl   $0xc010b7b2,0xc(%esp)
c010764b:	c0 
c010764c:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107653:	c0 
c0107654:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010765b:	00 
c010765c:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c0107663:	e8 6f 96 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107668:	c7 04 24 14 b8 10 c0 	movl   $0xc010b814,(%esp)
c010766f:	e8 df 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107674:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107679:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010767c:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107681:	83 f8 04             	cmp    $0x4,%eax
c0107684:	74 24                	je     c01076aa <_fifo_check_swap+0x10e>
c0107686:	c7 44 24 0c b2 b7 10 	movl   $0xc010b7b2,0xc(%esp)
c010768d:	c0 
c010768e:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107695:	c0 
c0107696:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c010769d:	00 
c010769e:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01076a5:	e8 2d 96 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01076aa:	c7 04 24 3c b8 10 c0 	movl   $0xc010b83c,(%esp)
c01076b1:	e8 9d 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01076b6:	b8 00 50 00 00       	mov    $0x5000,%eax
c01076bb:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01076be:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01076c3:	83 f8 05             	cmp    $0x5,%eax
c01076c6:	74 24                	je     c01076ec <_fifo_check_swap+0x150>
c01076c8:	c7 44 24 0c 62 b8 10 	movl   $0xc010b862,0xc(%esp)
c01076cf:	c0 
c01076d0:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c01076d7:	c0 
c01076d8:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c01076df:	00 
c01076e0:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01076e7:	e8 eb 95 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01076ec:	c7 04 24 14 b8 10 c0 	movl   $0xc010b814,(%esp)
c01076f3:	e8 5b 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01076f8:	b8 00 20 00 00       	mov    $0x2000,%eax
c01076fd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107700:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107705:	83 f8 05             	cmp    $0x5,%eax
c0107708:	74 24                	je     c010772e <_fifo_check_swap+0x192>
c010770a:	c7 44 24 0c 62 b8 10 	movl   $0xc010b862,0xc(%esp)
c0107711:	c0 
c0107712:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107719:	c0 
c010771a:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107721:	00 
c0107722:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c0107729:	e8 a9 95 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010772e:	c7 04 24 c4 b7 10 c0 	movl   $0xc010b7c4,(%esp)
c0107735:	e8 19 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010773a:	b8 00 10 00 00       	mov    $0x1000,%eax
c010773f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107742:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107747:	83 f8 06             	cmp    $0x6,%eax
c010774a:	74 24                	je     c0107770 <_fifo_check_swap+0x1d4>
c010774c:	c7 44 24 0c 71 b8 10 	movl   $0xc010b871,0xc(%esp)
c0107753:	c0 
c0107754:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c010775b:	c0 
c010775c:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107763:	00 
c0107764:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c010776b:	e8 67 95 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107770:	c7 04 24 14 b8 10 c0 	movl   $0xc010b814,(%esp)
c0107777:	e8 d7 8b ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010777c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107781:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107784:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107789:	83 f8 07             	cmp    $0x7,%eax
c010778c:	74 24                	je     c01077b2 <_fifo_check_swap+0x216>
c010778e:	c7 44 24 0c 80 b8 10 	movl   $0xc010b880,0xc(%esp)
c0107795:	c0 
c0107796:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c010779d:	c0 
c010779e:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01077a5:	00 
c01077a6:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01077ad:	e8 25 95 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01077b2:	c7 04 24 8c b7 10 c0 	movl   $0xc010b78c,(%esp)
c01077b9:	e8 95 8b ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01077be:	b8 00 30 00 00       	mov    $0x3000,%eax
c01077c3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01077c6:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01077cb:	83 f8 08             	cmp    $0x8,%eax
c01077ce:	74 24                	je     c01077f4 <_fifo_check_swap+0x258>
c01077d0:	c7 44 24 0c 8f b8 10 	movl   $0xc010b88f,0xc(%esp)
c01077d7:	c0 
c01077d8:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c01077df:	c0 
c01077e0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01077e7:	00 
c01077e8:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c01077ef:	e8 e3 94 ff ff       	call   c0100cd7 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01077f4:	c7 04 24 ec b7 10 c0 	movl   $0xc010b7ec,(%esp)
c01077fb:	e8 53 8b ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107800:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107805:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107808:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010780d:	83 f8 09             	cmp    $0x9,%eax
c0107810:	74 24                	je     c0107836 <_fifo_check_swap+0x29a>
c0107812:	c7 44 24 0c 9e b8 10 	movl   $0xc010b89e,0xc(%esp)
c0107819:	c0 
c010781a:	c7 44 24 08 32 b7 10 	movl   $0xc010b732,0x8(%esp)
c0107821:	c0 
c0107822:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107829:	00 
c010782a:	c7 04 24 47 b7 10 c0 	movl   $0xc010b747,(%esp)
c0107831:	e8 a1 94 ff ff       	call   c0100cd7 <__panic>
    return 0;
c0107836:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010783b:	c9                   	leave  
c010783c:	c3                   	ret    

c010783d <_fifo_init>:


static int
_fifo_init(void)
{
c010783d:	55                   	push   %ebp
c010783e:	89 e5                	mov    %esp,%ebp
    return 0;
c0107840:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107845:	5d                   	pop    %ebp
c0107846:	c3                   	ret    

c0107847 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107847:	55                   	push   %ebp
c0107848:	89 e5                	mov    %esp,%ebp
    return 0;
c010784a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010784f:	5d                   	pop    %ebp
c0107850:	c3                   	ret    

c0107851 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107851:	55                   	push   %ebp
c0107852:	89 e5                	mov    %esp,%ebp
c0107854:	b8 00 00 00 00       	mov    $0x0,%eax
c0107859:	5d                   	pop    %ebp
c010785a:	c3                   	ret    

c010785b <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010785b:	55                   	push   %ebp
c010785c:	89 e5                	mov    %esp,%ebp
c010785e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107861:	8b 45 08             	mov    0x8(%ebp),%eax
c0107864:	c1 e8 0c             	shr    $0xc,%eax
c0107867:	89 c2                	mov    %eax,%edx
c0107869:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010786e:	39 c2                	cmp    %eax,%edx
c0107870:	72 1c                	jb     c010788e <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107872:	c7 44 24 08 c0 b8 10 	movl   $0xc010b8c0,0x8(%esp)
c0107879:	c0 
c010787a:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107881:	00 
c0107882:	c7 04 24 df b8 10 c0 	movl   $0xc010b8df,(%esp)
c0107889:	e8 49 94 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c010788e:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0107893:	8b 55 08             	mov    0x8(%ebp),%edx
c0107896:	c1 ea 0c             	shr    $0xc,%edx
c0107899:	c1 e2 05             	shl    $0x5,%edx
c010789c:	01 d0                	add    %edx,%eax
}
c010789e:	c9                   	leave  
c010789f:	c3                   	ret    

c01078a0 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01078a0:	55                   	push   %ebp
c01078a1:	89 e5                	mov    %esp,%ebp
c01078a3:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01078a6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01078ad:	e8 74 d2 ff ff       	call   c0104b26 <kmalloc>
c01078b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01078b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01078b9:	74 58                	je     c0107913 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01078bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01078c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01078c7:	89 50 04             	mov    %edx,0x4(%eax)
c01078ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078cd:	8b 50 04             	mov    0x4(%eax),%edx
c01078d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078d3:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01078d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01078df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01078e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ec:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01078f3:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01078f8:	85 c0                	test   %eax,%eax
c01078fa:	74 0d                	je     c0107909 <mm_create+0x69>
c01078fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ff:	89 04 24             	mov    %eax,(%esp)
c0107902:	e8 cb ef ff ff       	call   c01068d2 <swap_init_mm>
c0107907:	eb 0a                	jmp    c0107913 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010790c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107913:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107916:	c9                   	leave  
c0107917:	c3                   	ret    

c0107918 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107918:	55                   	push   %ebp
c0107919:	89 e5                	mov    %esp,%ebp
c010791b:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010791e:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107925:	e8 fc d1 ff ff       	call   c0104b26 <kmalloc>
c010792a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010792d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107931:	74 1b                	je     c010794e <vma_create+0x36>
        vma->vm_start = vm_start;
c0107933:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107936:	8b 55 08             	mov    0x8(%ebp),%edx
c0107939:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010793c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010793f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107942:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107945:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107948:	8b 55 10             	mov    0x10(%ebp),%edx
c010794b:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010794e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107951:	c9                   	leave  
c0107952:	c3                   	ret    

c0107953 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107953:	55                   	push   %ebp
c0107954:	89 e5                	mov    %esp,%ebp
c0107956:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107960:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107964:	0f 84 95 00 00 00    	je     c01079ff <find_vma+0xac>
        vma = mm->mmap_cache;
c010796a:	8b 45 08             	mov    0x8(%ebp),%eax
c010796d:	8b 40 08             	mov    0x8(%eax),%eax
c0107970:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107973:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107977:	74 16                	je     c010798f <find_vma+0x3c>
c0107979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010797c:	8b 40 04             	mov    0x4(%eax),%eax
c010797f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107982:	77 0b                	ja     c010798f <find_vma+0x3c>
c0107984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107987:	8b 40 08             	mov    0x8(%eax),%eax
c010798a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010798d:	77 61                	ja     c01079f0 <find_vma+0x9d>
                bool found = 0;
c010798f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107996:	8b 45 08             	mov    0x8(%ebp),%eax
c0107999:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010799c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010799f:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01079a2:	eb 28                	jmp    c01079cc <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01079a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079a7:	83 e8 10             	sub    $0x10,%eax
c01079aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01079ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079b0:	8b 40 04             	mov    0x4(%eax),%eax
c01079b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079b6:	77 14                	ja     c01079cc <find_vma+0x79>
c01079b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079bb:	8b 40 08             	mov    0x8(%eax),%eax
c01079be:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079c1:	76 09                	jbe    c01079cc <find_vma+0x79>
                        found = 1;
c01079c3:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01079ca:	eb 17                	jmp    c01079e3 <find_vma+0x90>
c01079cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01079d5:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01079d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01079db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01079e1:	75 c1                	jne    c01079a4 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c01079e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01079e7:	75 07                	jne    c01079f0 <find_vma+0x9d>
                    vma = NULL;
c01079e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01079f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01079f4:	74 09                	je     c01079ff <find_vma+0xac>
            mm->mmap_cache = vma;
c01079f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01079f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01079fc:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01079ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107a02:	c9                   	leave  
c0107a03:	c3                   	ret    

c0107a04 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107a04:	55                   	push   %ebp
c0107a05:	89 e5                	mov    %esp,%ebp
c0107a07:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a0d:	8b 50 04             	mov    0x4(%eax),%edx
c0107a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a13:	8b 40 08             	mov    0x8(%eax),%eax
c0107a16:	39 c2                	cmp    %eax,%edx
c0107a18:	72 24                	jb     c0107a3e <check_vma_overlap+0x3a>
c0107a1a:	c7 44 24 0c ed b8 10 	movl   $0xc010b8ed,0xc(%esp)
c0107a21:	c0 
c0107a22:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107a29:	c0 
c0107a2a:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107a31:	00 
c0107a32:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107a39:	e8 99 92 ff ff       	call   c0100cd7 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a41:	8b 50 08             	mov    0x8(%eax),%edx
c0107a44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a47:	8b 40 04             	mov    0x4(%eax),%eax
c0107a4a:	39 c2                	cmp    %eax,%edx
c0107a4c:	76 24                	jbe    c0107a72 <check_vma_overlap+0x6e>
c0107a4e:	c7 44 24 0c 30 b9 10 	movl   $0xc010b930,0xc(%esp)
c0107a55:	c0 
c0107a56:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107a5d:	c0 
c0107a5e:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107a65:	00 
c0107a66:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107a6d:	e8 65 92 ff ff       	call   c0100cd7 <__panic>
    assert(next->vm_start < next->vm_end);
c0107a72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a75:	8b 50 04             	mov    0x4(%eax),%edx
c0107a78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a7b:	8b 40 08             	mov    0x8(%eax),%eax
c0107a7e:	39 c2                	cmp    %eax,%edx
c0107a80:	72 24                	jb     c0107aa6 <check_vma_overlap+0xa2>
c0107a82:	c7 44 24 0c 4f b9 10 	movl   $0xc010b94f,0xc(%esp)
c0107a89:	c0 
c0107a8a:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107a91:	c0 
c0107a92:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107a99:	00 
c0107a9a:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107aa1:	e8 31 92 ff ff       	call   c0100cd7 <__panic>
}
c0107aa6:	c9                   	leave  
c0107aa7:	c3                   	ret    

c0107aa8 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107aa8:	55                   	push   %ebp
c0107aa9:	89 e5                	mov    %esp,%ebp
c0107aab:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107aae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ab1:	8b 50 04             	mov    0x4(%eax),%edx
c0107ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ab7:	8b 40 08             	mov    0x8(%eax),%eax
c0107aba:	39 c2                	cmp    %eax,%edx
c0107abc:	72 24                	jb     c0107ae2 <insert_vma_struct+0x3a>
c0107abe:	c7 44 24 0c 6d b9 10 	movl   $0xc010b96d,0xc(%esp)
c0107ac5:	c0 
c0107ac6:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107acd:	c0 
c0107ace:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0107ad5:	00 
c0107ad6:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107add:	e8 f5 91 ff ff       	call   c0100cd7 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107af4:	eb 21                	jmp    c0107b17 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107af9:	83 e8 10             	sub    $0x10,%eax
c0107afc:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b02:	8b 50 04             	mov    0x4(%eax),%edx
c0107b05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b08:	8b 40 04             	mov    0x4(%eax),%eax
c0107b0b:	39 c2                	cmp    %eax,%edx
c0107b0d:	76 02                	jbe    c0107b11 <insert_vma_struct+0x69>
                break;
c0107b0f:	eb 1d                	jmp    c0107b2e <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b20:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b2c:	75 c8                	jne    c0107af6 <insert_vma_struct+0x4e>
c0107b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b31:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107b34:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b37:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107b3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b43:	74 15                	je     c0107b5a <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b48:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b52:	89 14 24             	mov    %edx,(%esp)
c0107b55:	e8 aa fe ff ff       	call   c0107a04 <check_vma_overlap>
    }
    if (le_next != list) {
c0107b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b60:	74 15                	je     c0107b77 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b65:	83 e8 10             	sub    $0x10,%eax
c0107b68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b6f:	89 04 24             	mov    %eax,(%esp)
c0107b72:	e8 8d fe ff ff       	call   c0107a04 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107b77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b7a:	8b 55 08             	mov    0x8(%ebp),%edx
c0107b7d:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b82:	8d 50 10             	lea    0x10(%eax),%edx
c0107b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b88:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107b8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107b8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b91:	8b 40 04             	mov    0x4(%eax),%eax
c0107b94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107b97:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107b9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107b9d:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107ba0:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107ba3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107ba6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107ba9:	89 10                	mov    %edx,(%eax)
c0107bab:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107bae:	8b 10                	mov    (%eax),%edx
c0107bb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107bb3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107bb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107bb9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107bbc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107bc2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107bc5:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bca:	8b 40 10             	mov    0x10(%eax),%eax
c0107bcd:	8d 50 01             	lea    0x1(%eax),%edx
c0107bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bd3:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107bd6:	c9                   	leave  
c0107bd7:	c3                   	ret    

c0107bd8 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107bd8:	55                   	push   %ebp
c0107bd9:	89 e5                	mov    %esp,%ebp
c0107bdb:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0107be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107be4:	eb 36                	jmp    c0107c1c <mm_destroy+0x44>
c0107be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bef:	8b 40 04             	mov    0x4(%eax),%eax
c0107bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107bf5:	8b 12                	mov    (%edx),%edx
c0107bf7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107c03:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c09:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107c0c:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c11:	83 e8 10             	sub    $0x10,%eax
c0107c14:	89 04 24             	mov    %eax,(%esp)
c0107c17:	e8 25 cf ff ff       	call   c0104b41 <kfree>
c0107c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107c22:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c25:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107c31:	75 b3                	jne    c0107be6 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c36:	89 04 24             	mov    %eax,(%esp)
c0107c39:	e8 03 cf ff ff       	call   c0104b41 <kfree>
    mm=NULL;
c0107c3e:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107c45:	c9                   	leave  
c0107c46:	c3                   	ret    

c0107c47 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107c47:	55                   	push   %ebp
c0107c48:	89 e5                	mov    %esp,%ebp
c0107c4a:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107c4d:	e8 02 00 00 00       	call   c0107c54 <check_vmm>
}
c0107c52:	c9                   	leave  
c0107c53:	c3                   	ret    

c0107c54 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107c54:	55                   	push   %ebp
c0107c55:	89 e5                	mov    %esp,%ebp
c0107c57:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107c5a:	e8 c1 d3 ff ff       	call   c0105020 <nr_free_pages>
c0107c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107c62:	e8 13 00 00 00       	call   c0107c7a <check_vma_struct>
    check_pgfault();
c0107c67:	e8 a7 04 00 00       	call   c0108113 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107c6c:	c7 04 24 89 b9 10 c0 	movl   $0xc010b989,(%esp)
c0107c73:	e8 db 86 ff ff       	call   c0100353 <cprintf>
}
c0107c78:	c9                   	leave  
c0107c79:	c3                   	ret    

c0107c7a <check_vma_struct>:

static void
check_vma_struct(void) {
c0107c7a:	55                   	push   %ebp
c0107c7b:	89 e5                	mov    %esp,%ebp
c0107c7d:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107c80:	e8 9b d3 ff ff       	call   c0105020 <nr_free_pages>
c0107c85:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107c88:	e8 13 fc ff ff       	call   c01078a0 <mm_create>
c0107c8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107c90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107c94:	75 24                	jne    c0107cba <check_vma_struct+0x40>
c0107c96:	c7 44 24 0c a1 b9 10 	movl   $0xc010b9a1,0xc(%esp)
c0107c9d:	c0 
c0107c9e:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107ca5:	c0 
c0107ca6:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107cad:	00 
c0107cae:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107cb5:	e8 1d 90 ff ff       	call   c0100cd7 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107cba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107cc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107cc4:	89 d0                	mov    %edx,%eax
c0107cc6:	c1 e0 02             	shl    $0x2,%eax
c0107cc9:	01 d0                	add    %edx,%eax
c0107ccb:	01 c0                	add    %eax,%eax
c0107ccd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107cd6:	eb 70                	jmp    c0107d48 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107cdb:	89 d0                	mov    %edx,%eax
c0107cdd:	c1 e0 02             	shl    $0x2,%eax
c0107ce0:	01 d0                	add    %edx,%eax
c0107ce2:	83 c0 02             	add    $0x2,%eax
c0107ce5:	89 c1                	mov    %eax,%ecx
c0107ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107cea:	89 d0                	mov    %edx,%eax
c0107cec:	c1 e0 02             	shl    $0x2,%eax
c0107cef:	01 d0                	add    %edx,%eax
c0107cf1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107cf8:	00 
c0107cf9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107cfd:	89 04 24             	mov    %eax,(%esp)
c0107d00:	e8 13 fc ff ff       	call   c0107918 <vma_create>
c0107d05:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107d08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107d0c:	75 24                	jne    c0107d32 <check_vma_struct+0xb8>
c0107d0e:	c7 44 24 0c ac b9 10 	movl   $0xc010b9ac,0xc(%esp)
c0107d15:	c0 
c0107d16:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107d1d:	c0 
c0107d1e:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107d25:	00 
c0107d26:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107d2d:	e8 a5 8f ff ff       	call   c0100cd7 <__panic>
        insert_vma_struct(mm, vma);
c0107d32:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d3c:	89 04 24             	mov    %eax,(%esp)
c0107d3f:	e8 64 fd ff ff       	call   c0107aa8 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107d44:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107d4c:	7f 8a                	jg     c0107cd8 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d51:	83 c0 01             	add    $0x1,%eax
c0107d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d57:	eb 70                	jmp    c0107dc9 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d5c:	89 d0                	mov    %edx,%eax
c0107d5e:	c1 e0 02             	shl    $0x2,%eax
c0107d61:	01 d0                	add    %edx,%eax
c0107d63:	83 c0 02             	add    $0x2,%eax
c0107d66:	89 c1                	mov    %eax,%ecx
c0107d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d6b:	89 d0                	mov    %edx,%eax
c0107d6d:	c1 e0 02             	shl    $0x2,%eax
c0107d70:	01 d0                	add    %edx,%eax
c0107d72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107d79:	00 
c0107d7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107d7e:	89 04 24             	mov    %eax,(%esp)
c0107d81:	e8 92 fb ff ff       	call   c0107918 <vma_create>
c0107d86:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107d89:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107d8d:	75 24                	jne    c0107db3 <check_vma_struct+0x139>
c0107d8f:	c7 44 24 0c ac b9 10 	movl   $0xc010b9ac,0xc(%esp)
c0107d96:	c0 
c0107d97:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107d9e:	c0 
c0107d9f:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107da6:	00 
c0107da7:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107dae:	e8 24 8f ff ff       	call   c0100cd7 <__panic>
        insert_vma_struct(mm, vma);
c0107db3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107db6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dbd:	89 04 24             	mov    %eax,(%esp)
c0107dc0:	e8 e3 fc ff ff       	call   c0107aa8 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107dc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dcc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107dcf:	7e 88                	jle    c0107d59 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dd4:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107dd7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107dda:	8b 40 04             	mov    0x4(%eax),%eax
c0107ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107de0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107de7:	e9 97 00 00 00       	jmp    c0107e83 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107def:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107df2:	75 24                	jne    c0107e18 <check_vma_struct+0x19e>
c0107df4:	c7 44 24 0c b8 b9 10 	movl   $0xc010b9b8,0xc(%esp)
c0107dfb:	c0 
c0107dfc:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107e03:	c0 
c0107e04:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107e0b:	00 
c0107e0c:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107e13:	e8 bf 8e ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e1b:	83 e8 10             	sub    $0x10,%eax
c0107e1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107e21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107e24:	8b 48 04             	mov    0x4(%eax),%ecx
c0107e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e2a:	89 d0                	mov    %edx,%eax
c0107e2c:	c1 e0 02             	shl    $0x2,%eax
c0107e2f:	01 d0                	add    %edx,%eax
c0107e31:	39 c1                	cmp    %eax,%ecx
c0107e33:	75 17                	jne    c0107e4c <check_vma_struct+0x1d2>
c0107e35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107e38:	8b 48 08             	mov    0x8(%eax),%ecx
c0107e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e3e:	89 d0                	mov    %edx,%eax
c0107e40:	c1 e0 02             	shl    $0x2,%eax
c0107e43:	01 d0                	add    %edx,%eax
c0107e45:	83 c0 02             	add    $0x2,%eax
c0107e48:	39 c1                	cmp    %eax,%ecx
c0107e4a:	74 24                	je     c0107e70 <check_vma_struct+0x1f6>
c0107e4c:	c7 44 24 0c d0 b9 10 	movl   $0xc010b9d0,0xc(%esp)
c0107e53:	c0 
c0107e54:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107e5b:	c0 
c0107e5c:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107e63:	00 
c0107e64:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107e6b:	e8 67 8e ff ff       	call   c0100cd7 <__panic>
c0107e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e73:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107e76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107e79:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107e7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107e89:	0f 8e 5d ff ff ff    	jle    c0107dec <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107e8f:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107e96:	e9 cd 01 00 00       	jmp    c0108068 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ea5:	89 04 24             	mov    %eax,(%esp)
c0107ea8:	e8 a6 fa ff ff       	call   c0107953 <find_vma>
c0107ead:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107eb0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107eb4:	75 24                	jne    c0107eda <check_vma_struct+0x260>
c0107eb6:	c7 44 24 0c 05 ba 10 	movl   $0xc010ba05,0xc(%esp)
c0107ebd:	c0 
c0107ebe:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107ec5:	c0 
c0107ec6:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107ecd:	00 
c0107ece:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107ed5:	e8 fd 8d ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107edd:	83 c0 01             	add    $0x1,%eax
c0107ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ee7:	89 04 24             	mov    %eax,(%esp)
c0107eea:	e8 64 fa ff ff       	call   c0107953 <find_vma>
c0107eef:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107ef2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107ef6:	75 24                	jne    c0107f1c <check_vma_struct+0x2a2>
c0107ef8:	c7 44 24 0c 12 ba 10 	movl   $0xc010ba12,0xc(%esp)
c0107eff:	c0 
c0107f00:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107f07:	c0 
c0107f08:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107f0f:	00 
c0107f10:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107f17:	e8 bb 8d ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f1f:	83 c0 02             	add    $0x2,%eax
c0107f22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f29:	89 04 24             	mov    %eax,(%esp)
c0107f2c:	e8 22 fa ff ff       	call   c0107953 <find_vma>
c0107f31:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107f34:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107f38:	74 24                	je     c0107f5e <check_vma_struct+0x2e4>
c0107f3a:	c7 44 24 0c 1f ba 10 	movl   $0xc010ba1f,0xc(%esp)
c0107f41:	c0 
c0107f42:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107f49:	c0 
c0107f4a:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107f51:	00 
c0107f52:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107f59:	e8 79 8d ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f61:	83 c0 03             	add    $0x3,%eax
c0107f64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f6b:	89 04 24             	mov    %eax,(%esp)
c0107f6e:	e8 e0 f9 ff ff       	call   c0107953 <find_vma>
c0107f73:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107f76:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107f7a:	74 24                	je     c0107fa0 <check_vma_struct+0x326>
c0107f7c:	c7 44 24 0c 2c ba 10 	movl   $0xc010ba2c,0xc(%esp)
c0107f83:	c0 
c0107f84:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107f8b:	c0 
c0107f8c:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107f93:	00 
c0107f94:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107f9b:	e8 37 8d ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fa3:	83 c0 04             	add    $0x4,%eax
c0107fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fad:	89 04 24             	mov    %eax,(%esp)
c0107fb0:	e8 9e f9 ff ff       	call   c0107953 <find_vma>
c0107fb5:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107fb8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107fbc:	74 24                	je     c0107fe2 <check_vma_struct+0x368>
c0107fbe:	c7 44 24 0c 39 ba 10 	movl   $0xc010ba39,0xc(%esp)
c0107fc5:	c0 
c0107fc6:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0107fcd:	c0 
c0107fce:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107fd5:	00 
c0107fd6:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0107fdd:	e8 f5 8c ff ff       	call   c0100cd7 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107fe2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107fe5:	8b 50 04             	mov    0x4(%eax),%edx
c0107fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107feb:	39 c2                	cmp    %eax,%edx
c0107fed:	75 10                	jne    c0107fff <check_vma_struct+0x385>
c0107fef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ff2:	8b 50 08             	mov    0x8(%eax),%edx
c0107ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ff8:	83 c0 02             	add    $0x2,%eax
c0107ffb:	39 c2                	cmp    %eax,%edx
c0107ffd:	74 24                	je     c0108023 <check_vma_struct+0x3a9>
c0107fff:	c7 44 24 0c 48 ba 10 	movl   $0xc010ba48,0xc(%esp)
c0108006:	c0 
c0108007:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c010800e:	c0 
c010800f:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0108016:	00 
c0108017:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c010801e:	e8 b4 8c ff ff       	call   c0100cd7 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108023:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108026:	8b 50 04             	mov    0x4(%eax),%edx
c0108029:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010802c:	39 c2                	cmp    %eax,%edx
c010802e:	75 10                	jne    c0108040 <check_vma_struct+0x3c6>
c0108030:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108033:	8b 50 08             	mov    0x8(%eax),%edx
c0108036:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108039:	83 c0 02             	add    $0x2,%eax
c010803c:	39 c2                	cmp    %eax,%edx
c010803e:	74 24                	je     c0108064 <check_vma_struct+0x3ea>
c0108040:	c7 44 24 0c 78 ba 10 	movl   $0xc010ba78,0xc(%esp)
c0108047:	c0 
c0108048:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c010804f:	c0 
c0108050:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0108057:	00 
c0108058:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c010805f:	e8 73 8c ff ff       	call   c0100cd7 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108064:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0108068:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010806b:	89 d0                	mov    %edx,%eax
c010806d:	c1 e0 02             	shl    $0x2,%eax
c0108070:	01 d0                	add    %edx,%eax
c0108072:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108075:	0f 8d 20 fe ff ff    	jge    c0107e9b <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010807b:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0108082:	eb 70                	jmp    c01080f4 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0108084:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108087:	89 44 24 04          	mov    %eax,0x4(%esp)
c010808b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010808e:	89 04 24             	mov    %eax,(%esp)
c0108091:	e8 bd f8 ff ff       	call   c0107953 <find_vma>
c0108096:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0108099:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010809d:	74 27                	je     c01080c6 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010809f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01080a2:	8b 50 08             	mov    0x8(%eax),%edx
c01080a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01080a8:	8b 40 04             	mov    0x4(%eax),%eax
c01080ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01080af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080ba:	c7 04 24 a8 ba 10 c0 	movl   $0xc010baa8,(%esp)
c01080c1:	e8 8d 82 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01080c6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01080ca:	74 24                	je     c01080f0 <check_vma_struct+0x476>
c01080cc:	c7 44 24 0c cd ba 10 	movl   $0xc010bacd,0xc(%esp)
c01080d3:	c0 
c01080d4:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c01080db:	c0 
c01080dc:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01080e3:	00 
c01080e4:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c01080eb:	e8 e7 8b ff ff       	call   c0100cd7 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01080f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01080f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01080f8:	79 8a                	jns    c0108084 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01080fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080fd:	89 04 24             	mov    %eax,(%esp)
c0108100:	e8 d3 fa ff ff       	call   c0107bd8 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108105:	c7 04 24 e4 ba 10 c0 	movl   $0xc010bae4,(%esp)
c010810c:	e8 42 82 ff ff       	call   c0100353 <cprintf>
}
c0108111:	c9                   	leave  
c0108112:	c3                   	ret    

c0108113 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108113:	55                   	push   %ebp
c0108114:	89 e5                	mov    %esp,%ebp
c0108116:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108119:	e8 02 cf ff ff       	call   c0105020 <nr_free_pages>
c010811e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108121:	e8 7a f7 ff ff       	call   c01078a0 <mm_create>
c0108126:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c010812b:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0108130:	85 c0                	test   %eax,%eax
c0108132:	75 24                	jne    c0108158 <check_pgfault+0x45>
c0108134:	c7 44 24 0c 03 bb 10 	movl   $0xc010bb03,0xc(%esp)
c010813b:	c0 
c010813c:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0108143:	c0 
c0108144:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c010814b:	00 
c010814c:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0108153:	e8 7f 8b ff ff       	call   c0100cd7 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108158:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010815d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108160:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0108166:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108169:	89 50 0c             	mov    %edx,0xc(%eax)
c010816c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010816f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108172:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108178:	8b 00                	mov    (%eax),%eax
c010817a:	85 c0                	test   %eax,%eax
c010817c:	74 24                	je     c01081a2 <check_pgfault+0x8f>
c010817e:	c7 44 24 0c 1b bb 10 	movl   $0xc010bb1b,0xc(%esp)
c0108185:	c0 
c0108186:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c010818d:	c0 
c010818e:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0108195:	00 
c0108196:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c010819d:	e8 35 8b ff ff       	call   c0100cd7 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01081a2:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01081a9:	00 
c01081aa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01081b1:	00 
c01081b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01081b9:	e8 5a f7 ff ff       	call   c0107918 <vma_create>
c01081be:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01081c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01081c5:	75 24                	jne    c01081eb <check_pgfault+0xd8>
c01081c7:	c7 44 24 0c ac b9 10 	movl   $0xc010b9ac,0xc(%esp)
c01081ce:	c0 
c01081cf:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c01081d6:	c0 
c01081d7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01081de:	00 
c01081df:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c01081e6:	e8 ec 8a ff ff       	call   c0100cd7 <__panic>

    insert_vma_struct(mm, vma);
c01081eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081f5:	89 04 24             	mov    %eax,(%esp)
c01081f8:	e8 ab f8 ff ff       	call   c0107aa8 <insert_vma_struct>

    uintptr_t addr = 0x100;
c01081fd:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108204:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108207:	89 44 24 04          	mov    %eax,0x4(%esp)
c010820b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010820e:	89 04 24             	mov    %eax,(%esp)
c0108211:	e8 3d f7 ff ff       	call   c0107953 <find_vma>
c0108216:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108219:	74 24                	je     c010823f <check_pgfault+0x12c>
c010821b:	c7 44 24 0c 29 bb 10 	movl   $0xc010bb29,0xc(%esp)
c0108222:	c0 
c0108223:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c010822a:	c0 
c010822b:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0108232:	00 
c0108233:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c010823a:	e8 98 8a ff ff       	call   c0100cd7 <__panic>

    int i, sum = 0;
c010823f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010824d:	eb 17                	jmp    c0108266 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c010824f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108252:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108255:	01 d0                	add    %edx,%eax
c0108257:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010825a:	88 10                	mov    %dl,(%eax)
        sum += i;
c010825c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010825f:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108262:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108266:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010826a:	7e e3                	jle    c010824f <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010826c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108273:	eb 15                	jmp    c010828a <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108275:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108278:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010827b:	01 d0                	add    %edx,%eax
c010827d:	0f b6 00             	movzbl (%eax),%eax
c0108280:	0f be c0             	movsbl %al,%eax
c0108283:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108286:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010828a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010828e:	7e e5                	jle    c0108275 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108294:	74 24                	je     c01082ba <check_pgfault+0x1a7>
c0108296:	c7 44 24 0c 43 bb 10 	movl   $0xc010bb43,0xc(%esp)
c010829d:	c0 
c010829e:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c01082a5:	c0 
c01082a6:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01082ad:	00 
c01082ae:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c01082b5:	e8 1d 8a ff ff       	call   c0100cd7 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01082ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01082c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01082c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01082c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082cf:	89 04 24             	mov    %eax,(%esp)
c01082d2:	e8 0a d6 ff ff       	call   c01058e1 <page_remove>
    free_page(pa2page(pgdir[0]));
c01082d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082da:	8b 00                	mov    (%eax),%eax
c01082dc:	89 04 24             	mov    %eax,(%esp)
c01082df:	e8 77 f5 ff ff       	call   c010785b <pa2page>
c01082e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01082eb:	00 
c01082ec:	89 04 24             	mov    %eax,(%esp)
c01082ef:	e8 fa cc ff ff       	call   c0104fee <free_pages>
    pgdir[0] = 0;
c01082f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01082fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108300:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108307:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010830a:	89 04 24             	mov    %eax,(%esp)
c010830d:	e8 c6 f8 ff ff       	call   c0107bd8 <mm_destroy>
    check_mm_struct = NULL;
c0108312:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c0108319:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c010831c:	e8 ff cc ff ff       	call   c0105020 <nr_free_pages>
c0108321:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108324:	74 24                	je     c010834a <check_pgfault+0x237>
c0108326:	c7 44 24 0c 4c bb 10 	movl   $0xc010bb4c,0xc(%esp)
c010832d:	c0 
c010832e:	c7 44 24 08 0b b9 10 	movl   $0xc010b90b,0x8(%esp)
c0108335:	c0 
c0108336:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c010833d:	00 
c010833e:	c7 04 24 20 b9 10 c0 	movl   $0xc010b920,(%esp)
c0108345:	e8 8d 89 ff ff       	call   c0100cd7 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010834a:	c7 04 24 73 bb 10 c0 	movl   $0xc010bb73,(%esp)
c0108351:	e8 fd 7f ff ff       	call   c0100353 <cprintf>
}
c0108356:	c9                   	leave  
c0108357:	c3                   	ret    

c0108358 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108358:	55                   	push   %ebp
c0108359:	89 e5                	mov    %esp,%ebp
c010835b:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c010835e:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108365:	8b 45 10             	mov    0x10(%ebp),%eax
c0108368:	89 44 24 04          	mov    %eax,0x4(%esp)
c010836c:	8b 45 08             	mov    0x8(%ebp),%eax
c010836f:	89 04 24             	mov    %eax,(%esp)
c0108372:	e8 dc f5 ff ff       	call   c0107953 <find_vma>
c0108377:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c010837a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010837f:	83 c0 01             	add    $0x1,%eax
c0108382:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108387:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010838b:	74 0b                	je     c0108398 <do_pgfault+0x40>
c010838d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108390:	8b 40 04             	mov    0x4(%eax),%eax
c0108393:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108396:	76 18                	jbe    c01083b0 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108398:	8b 45 10             	mov    0x10(%ebp),%eax
c010839b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010839f:	c7 04 24 90 bb 10 c0 	movl   $0xc010bb90,(%esp)
c01083a6:	e8 a8 7f ff ff       	call   c0100353 <cprintf>
        goto failed;
c01083ab:	e9 ca 01 00 00       	jmp    c010857a <do_pgfault+0x222>
    }
    //check the error_code
    switch (error_code & 3) {
c01083b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083b3:	83 e0 03             	and    $0x3,%eax
c01083b6:	85 c0                	test   %eax,%eax
c01083b8:	74 36                	je     c01083f0 <do_pgfault+0x98>
c01083ba:	83 f8 01             	cmp    $0x1,%eax
c01083bd:	74 20                	je     c01083df <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01083bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083c2:	8b 40 0c             	mov    0xc(%eax),%eax
c01083c5:	83 e0 02             	and    $0x2,%eax
c01083c8:	85 c0                	test   %eax,%eax
c01083ca:	75 11                	jne    c01083dd <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01083cc:	c7 04 24 c0 bb 10 c0 	movl   $0xc010bbc0,(%esp)
c01083d3:	e8 7b 7f ff ff       	call   c0100353 <cprintf>
            goto failed;
c01083d8:	e9 9d 01 00 00       	jmp    c010857a <do_pgfault+0x222>
        }
        break;
c01083dd:	eb 2f                	jmp    c010840e <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01083df:	c7 04 24 20 bc 10 c0 	movl   $0xc010bc20,(%esp)
c01083e6:	e8 68 7f ff ff       	call   c0100353 <cprintf>
        goto failed;
c01083eb:	e9 8a 01 00 00       	jmp    c010857a <do_pgfault+0x222>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01083f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083f3:	8b 40 0c             	mov    0xc(%eax),%eax
c01083f6:	83 e0 05             	and    $0x5,%eax
c01083f9:	85 c0                	test   %eax,%eax
c01083fb:	75 11                	jne    c010840e <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01083fd:	c7 04 24 58 bc 10 c0 	movl   $0xc010bc58,(%esp)
c0108404:	e8 4a 7f ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108409:	e9 6c 01 00 00       	jmp    c010857a <do_pgfault+0x222>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c010840e:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108415:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108418:	8b 40 0c             	mov    0xc(%eax),%eax
c010841b:	83 e0 02             	and    $0x2,%eax
c010841e:	85 c0                	test   %eax,%eax
c0108420:	74 04                	je     c0108426 <do_pgfault+0xce>
        perm |= PTE_W;
c0108422:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108426:	8b 45 10             	mov    0x10(%ebp),%eax
c0108429:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010842c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010842f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108434:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108437:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010843e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: YOUR CODE*/
    //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    if((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
c0108445:	8b 45 08             	mov    0x8(%ebp),%eax
c0108448:	8b 40 0c             	mov    0xc(%eax),%eax
c010844b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108452:	00 
c0108453:	8b 55 10             	mov    0x10(%ebp),%edx
c0108456:	89 54 24 04          	mov    %edx,0x4(%esp)
c010845a:	89 04 24             	mov    %eax,(%esp)
c010845d:	e8 88 d2 ff ff       	call   c01056ea <get_pte>
c0108462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108465:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108469:	75 11                	jne    c010847c <do_pgfault+0x124>
    {
    	cprintf("get_pte in do_pgfault failed\n");
c010846b:	c7 04 24 bb bc 10 c0 	movl   $0xc010bcbb,(%esp)
c0108472:	e8 dc 7e ff ff       	call   c0100353 <cprintf>
    	goto failed;
c0108477:	e9 fe 00 00 00       	jmp    c010857a <do_pgfault+0x222>
    }
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0)
c010847c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010847f:	8b 00                	mov    (%eax),%eax
c0108481:	85 c0                	test   %eax,%eax
c0108483:	75 35                	jne    c01084ba <do_pgfault+0x162>
    {
    	if(pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
c0108485:	8b 45 08             	mov    0x8(%ebp),%eax
c0108488:	8b 40 0c             	mov    0xc(%eax),%eax
c010848b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010848e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108492:	8b 55 10             	mov    0x10(%ebp),%edx
c0108495:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108499:	89 04 24             	mov    %eax,(%esp)
c010849c:	e8 9a d5 ff ff       	call   c0105a3b <pgdir_alloc_page>
c01084a1:	85 c0                	test   %eax,%eax
c01084a3:	0f 85 ca 00 00 00    	jne    c0108573 <do_pgfault+0x21b>
    	{
    		cprintf("pgdir_alloc_page in do_pgfault failed\n");
c01084a9:	c7 04 24 dc bc 10 c0 	movl   $0xc010bcdc,(%esp)
c01084b0:	e8 9e 7e ff ff       	call   c0100353 <cprintf>
    		goto failed;
c01084b5:	e9 c0 00 00 00       	jmp    c010857a <do_pgfault+0x222>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok)
c01084ba:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01084bf:	85 c0                	test   %eax,%eax
c01084c1:	0f 84 95 00 00 00    	je     c010855c <do_pgfault+0x204>
        {
            struct Page *page=NULL;
c01084c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
            if((ret = swap_in(mm, addr, &page)) != 0)
c01084ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01084d1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01084d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01084df:	89 04 24             	mov    %eax,(%esp)
c01084e2:	e8 e4 e5 ff ff       	call   c0106acb <swap_in>
c01084e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01084ee:	74 0e                	je     c01084fe <do_pgfault+0x1a6>
            {
            	cprintf("swap_in in do_pgfault failed\n");
c01084f0:	c7 04 24 03 bd 10 c0 	movl   $0xc010bd03,(%esp)
c01084f7:	e8 57 7e ff ff       	call   c0100353 <cprintf>
            	goto failed;
c01084fc:	eb 7c                	jmp    c010857a <do_pgfault+0x222>
            }
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            if((ret = page_insert(mm->pgdir, page, addr, perm)) != 0)
c01084fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108501:	8b 45 08             	mov    0x8(%ebp),%eax
c0108504:	8b 40 0c             	mov    0xc(%eax),%eax
c0108507:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010850a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010850e:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108511:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108515:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108519:	89 04 24             	mov    %eax,(%esp)
c010851c:	e8 04 d4 ff ff       	call   c0105925 <page_insert>
c0108521:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108528:	74 0f                	je     c0108539 <do_pgfault+0x1e1>
            {
            	cprintf("page_insert in do_pgfault failed\n");
c010852a:	c7 04 24 24 bd 10 c0 	movl   $0xc010bd24,(%esp)
c0108531:	e8 1d 7e ff ff       	call   c0100353 <cprintf>
            	goto failed;
c0108536:	90                   	nop
c0108537:	eb 41                	jmp    c010857a <do_pgfault+0x222>
            }
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c0108539:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010853c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108543:	00 
c0108544:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108548:	8b 45 10             	mov    0x10(%ebp),%eax
c010854b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010854f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108552:	89 04 24             	mov    %eax,(%esp)
c0108555:	e8 a8 e3 ff ff       	call   c0106902 <swap_map_swappable>
c010855a:	eb 17                	jmp    c0108573 <do_pgfault+0x21b>
        }
        else
        {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c010855c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010855f:	8b 00                	mov    (%eax),%eax
c0108561:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108565:	c7 04 24 48 bd 10 c0 	movl   $0xc010bd48,(%esp)
c010856c:	e8 e2 7d ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108571:	eb 07                	jmp    c010857a <do_pgfault+0x222>
        }
   }
   ret = 0;
c0108573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010857a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010857d:	c9                   	leave  
c010857e:	c3                   	ret    

c010857f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010857f:	55                   	push   %ebp
c0108580:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108582:	8b 55 08             	mov    0x8(%ebp),%edx
c0108585:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010858a:	29 c2                	sub    %eax,%edx
c010858c:	89 d0                	mov    %edx,%eax
c010858e:	c1 f8 05             	sar    $0x5,%eax
}
c0108591:	5d                   	pop    %ebp
c0108592:	c3                   	ret    

c0108593 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108593:	55                   	push   %ebp
c0108594:	89 e5                	mov    %esp,%ebp
c0108596:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108599:	8b 45 08             	mov    0x8(%ebp),%eax
c010859c:	89 04 24             	mov    %eax,(%esp)
c010859f:	e8 db ff ff ff       	call   c010857f <page2ppn>
c01085a4:	c1 e0 0c             	shl    $0xc,%eax
}
c01085a7:	c9                   	leave  
c01085a8:	c3                   	ret    

c01085a9 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01085a9:	55                   	push   %ebp
c01085aa:	89 e5                	mov    %esp,%ebp
c01085ac:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01085af:	8b 45 08             	mov    0x8(%ebp),%eax
c01085b2:	89 04 24             	mov    %eax,(%esp)
c01085b5:	e8 d9 ff ff ff       	call   c0108593 <page2pa>
c01085ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c0:	c1 e8 0c             	shr    $0xc,%eax
c01085c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085c6:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01085cb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01085ce:	72 23                	jb     c01085f3 <page2kva+0x4a>
c01085d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085d7:	c7 44 24 08 70 bd 10 	movl   $0xc010bd70,0x8(%esp)
c01085de:	c0 
c01085df:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01085e6:	00 
c01085e7:	c7 04 24 93 bd 10 c0 	movl   $0xc010bd93,(%esp)
c01085ee:	e8 e4 86 ff ff       	call   c0100cd7 <__panic>
c01085f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085f6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01085fb:	c9                   	leave  
c01085fc:	c3                   	ret    

c01085fd <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01085fd:	55                   	push   %ebp
c01085fe:	89 e5                	mov    %esp,%ebp
c0108600:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108603:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010860a:	e8 18 94 ff ff       	call   c0101a27 <ide_device_valid>
c010860f:	85 c0                	test   %eax,%eax
c0108611:	75 1c                	jne    c010862f <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108613:	c7 44 24 08 a1 bd 10 	movl   $0xc010bda1,0x8(%esp)
c010861a:	c0 
c010861b:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108622:	00 
c0108623:	c7 04 24 bb bd 10 c0 	movl   $0xc010bdbb,(%esp)
c010862a:	e8 a8 86 ff ff       	call   c0100cd7 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010862f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108636:	e8 2b 94 ff ff       	call   c0101a66 <ide_device_size>
c010863b:	c1 e8 03             	shr    $0x3,%eax
c010863e:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c0108643:	c9                   	leave  
c0108644:	c3                   	ret    

c0108645 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108645:	55                   	push   %ebp
c0108646:	89 e5                	mov    %esp,%ebp
c0108648:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010864b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010864e:	89 04 24             	mov    %eax,(%esp)
c0108651:	e8 53 ff ff ff       	call   c01085a9 <page2kva>
c0108656:	8b 55 08             	mov    0x8(%ebp),%edx
c0108659:	c1 ea 08             	shr    $0x8,%edx
c010865c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010865f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108663:	74 0b                	je     c0108670 <swapfs_read+0x2b>
c0108665:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c010866b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010866e:	72 23                	jb     c0108693 <swapfs_read+0x4e>
c0108670:	8b 45 08             	mov    0x8(%ebp),%eax
c0108673:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108677:	c7 44 24 08 cc bd 10 	movl   $0xc010bdcc,0x8(%esp)
c010867e:	c0 
c010867f:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108686:	00 
c0108687:	c7 04 24 bb bd 10 c0 	movl   $0xc010bdbb,(%esp)
c010868e:	e8 44 86 ff ff       	call   c0100cd7 <__panic>
c0108693:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108696:	c1 e2 03             	shl    $0x3,%edx
c0108699:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01086a0:	00 
c01086a1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01086a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086b0:	e8 f0 93 ff ff       	call   c0101aa5 <ide_read_secs>
}
c01086b5:	c9                   	leave  
c01086b6:	c3                   	ret    

c01086b7 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01086b7:	55                   	push   %ebp
c01086b8:	89 e5                	mov    %esp,%ebp
c01086ba:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01086bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086c0:	89 04 24             	mov    %eax,(%esp)
c01086c3:	e8 e1 fe ff ff       	call   c01085a9 <page2kva>
c01086c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01086cb:	c1 ea 08             	shr    $0x8,%edx
c01086ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01086d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01086d5:	74 0b                	je     c01086e2 <swapfs_write+0x2b>
c01086d7:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c01086dd:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01086e0:	72 23                	jb     c0108705 <swapfs_write+0x4e>
c01086e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086e9:	c7 44 24 08 cc bd 10 	movl   $0xc010bdcc,0x8(%esp)
c01086f0:	c0 
c01086f1:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01086f8:	00 
c01086f9:	c7 04 24 bb bd 10 c0 	movl   $0xc010bdbb,(%esp)
c0108700:	e8 d2 85 ff ff       	call   c0100cd7 <__panic>
c0108705:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108708:	c1 e2 03             	shl    $0x3,%edx
c010870b:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108712:	00 
c0108713:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108717:	89 54 24 04          	mov    %edx,0x4(%esp)
c010871b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108722:	e8 c0 95 ff ff       	call   c0101ce7 <ide_write_secs>
}
c0108727:	c9                   	leave  
c0108728:	c3                   	ret    

c0108729 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108729:	52                   	push   %edx
    call *%ebx              # call fn
c010872a:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c010872c:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c010872d:	e8 3b 08 00 00       	call   c0108f6d <do_exit>

c0108732 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108732:	55                   	push   %ebp
c0108733:	89 e5                	mov    %esp,%ebp
c0108735:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108738:	9c                   	pushf  
c0108739:	58                   	pop    %eax
c010873a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010873d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108740:	25 00 02 00 00       	and    $0x200,%eax
c0108745:	85 c0                	test   %eax,%eax
c0108747:	74 0c                	je     c0108755 <__intr_save+0x23>
        intr_disable();
c0108749:	e8 e1 97 ff ff       	call   c0101f2f <intr_disable>
        return 1;
c010874e:	b8 01 00 00 00       	mov    $0x1,%eax
c0108753:	eb 05                	jmp    c010875a <__intr_save+0x28>
    }
    return 0;
c0108755:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010875a:	c9                   	leave  
c010875b:	c3                   	ret    

c010875c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010875c:	55                   	push   %ebp
c010875d:	89 e5                	mov    %esp,%ebp
c010875f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108762:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108766:	74 05                	je     c010876d <__intr_restore+0x11>
        intr_enable();
c0108768:	e8 bc 97 ff ff       	call   c0101f29 <intr_enable>
    }
}
c010876d:	c9                   	leave  
c010876e:	c3                   	ret    

c010876f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010876f:	55                   	push   %ebp
c0108770:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108772:	8b 55 08             	mov    0x8(%ebp),%edx
c0108775:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010877a:	29 c2                	sub    %eax,%edx
c010877c:	89 d0                	mov    %edx,%eax
c010877e:	c1 f8 05             	sar    $0x5,%eax
}
c0108781:	5d                   	pop    %ebp
c0108782:	c3                   	ret    

c0108783 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108783:	55                   	push   %ebp
c0108784:	89 e5                	mov    %esp,%ebp
c0108786:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108789:	8b 45 08             	mov    0x8(%ebp),%eax
c010878c:	89 04 24             	mov    %eax,(%esp)
c010878f:	e8 db ff ff ff       	call   c010876f <page2ppn>
c0108794:	c1 e0 0c             	shl    $0xc,%eax
}
c0108797:	c9                   	leave  
c0108798:	c3                   	ret    

c0108799 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108799:	55                   	push   %ebp
c010879a:	89 e5                	mov    %esp,%ebp
c010879c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010879f:	8b 45 08             	mov    0x8(%ebp),%eax
c01087a2:	c1 e8 0c             	shr    $0xc,%eax
c01087a5:	89 c2                	mov    %eax,%edx
c01087a7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01087ac:	39 c2                	cmp    %eax,%edx
c01087ae:	72 1c                	jb     c01087cc <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01087b0:	c7 44 24 08 ec bd 10 	movl   $0xc010bdec,0x8(%esp)
c01087b7:	c0 
c01087b8:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01087bf:	00 
c01087c0:	c7 04 24 0b be 10 c0 	movl   $0xc010be0b,(%esp)
c01087c7:	e8 0b 85 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c01087cc:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01087d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01087d4:	c1 ea 0c             	shr    $0xc,%edx
c01087d7:	c1 e2 05             	shl    $0x5,%edx
c01087da:	01 d0                	add    %edx,%eax
}
c01087dc:	c9                   	leave  
c01087dd:	c3                   	ret    

c01087de <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01087de:	55                   	push   %ebp
c01087df:	89 e5                	mov    %esp,%ebp
c01087e1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01087e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e7:	89 04 24             	mov    %eax,(%esp)
c01087ea:	e8 94 ff ff ff       	call   c0108783 <page2pa>
c01087ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087f5:	c1 e8 0c             	shr    $0xc,%eax
c01087f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01087fb:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108800:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108803:	72 23                	jb     c0108828 <page2kva+0x4a>
c0108805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108808:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010880c:	c7 44 24 08 1c be 10 	movl   $0xc010be1c,0x8(%esp)
c0108813:	c0 
c0108814:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010881b:	00 
c010881c:	c7 04 24 0b be 10 c0 	movl   $0xc010be0b,(%esp)
c0108823:	e8 af 84 ff ff       	call   c0100cd7 <__panic>
c0108828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010882b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108830:	c9                   	leave  
c0108831:	c3                   	ret    

c0108832 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0108832:	55                   	push   %ebp
c0108833:	89 e5                	mov    %esp,%ebp
c0108835:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0108838:	8b 45 08             	mov    0x8(%ebp),%eax
c010883b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010883e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0108845:	77 23                	ja     c010886a <kva2page+0x38>
c0108847:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010884a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010884e:	c7 44 24 08 40 be 10 	movl   $0xc010be40,0x8(%esp)
c0108855:	c0 
c0108856:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c010885d:	00 
c010885e:	c7 04 24 0b be 10 c0 	movl   $0xc010be0b,(%esp)
c0108865:	e8 6d 84 ff ff       	call   c0100cd7 <__panic>
c010886a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010886d:	05 00 00 00 40       	add    $0x40000000,%eax
c0108872:	89 04 24             	mov    %eax,(%esp)
c0108875:	e8 1f ff ff ff       	call   c0108799 <pa2page>
}
c010887a:	c9                   	leave  
c010887b:	c3                   	ret    

c010887c <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c010887c:	55                   	push   %ebp
c010887d:	89 e5                	mov    %esp,%ebp
c010887f:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0108882:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c0108889:	e8 98 c2 ff ff       	call   c0104b26 <kmalloc>
c010888e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0108891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108895:	0f 84 a1 00 00 00    	je     c010893c <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
    	proc->state = PROC_UNINIT;
c010889b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010889e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	proc->pid = -1;
c01088a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088a7:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    	proc->runs = 0;
c01088ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    	proc->kstack = 0;
c01088b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    	proc->need_resched = 0;
c01088c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088c5:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    	proc->parent = NULL;
c01088cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088cf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    	proc->mm = NULL;
c01088d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088d9:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    	memset(&(proc->context), 0, sizeof(struct context));
c01088e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088e3:	83 c0 1c             	add    $0x1c,%eax
c01088e6:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c01088ed:	00 
c01088ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01088f5:	00 
c01088f6:	89 04 24             	mov    %eax,(%esp)
c01088f9:	e8 f1 14 00 00       	call   c0109def <memset>
    	proc->tf = NULL;
c01088fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108901:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
    	proc->cr3 = boot_cr3;
c0108908:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c010890e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108911:	89 50 40             	mov    %edx,0x40(%eax)
    	proc->flags = 0;
c0108914:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108917:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    	memset(proc->name, 0, PROC_NAME_LEN);
c010891e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108921:	83 c0 48             	add    $0x48,%eax
c0108924:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c010892b:	00 
c010892c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108933:	00 
c0108934:	89 04 24             	mov    %eax,(%esp)
c0108937:	e8 b3 14 00 00       	call   c0109def <memset>
    }
    return proc;
c010893c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010893f:	c9                   	leave  
c0108940:	c3                   	ret    

c0108941 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108941:	55                   	push   %ebp
c0108942:	89 e5                	mov    %esp,%ebp
c0108944:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c0108947:	8b 45 08             	mov    0x8(%ebp),%eax
c010894a:	83 c0 48             	add    $0x48,%eax
c010894d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108954:	00 
c0108955:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010895c:	00 
c010895d:	89 04 24             	mov    %eax,(%esp)
c0108960:	e8 8a 14 00 00       	call   c0109def <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c0108965:	8b 45 08             	mov    0x8(%ebp),%eax
c0108968:	8d 50 48             	lea    0x48(%eax),%edx
c010896b:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108972:	00 
c0108973:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108976:	89 44 24 04          	mov    %eax,0x4(%esp)
c010897a:	89 14 24             	mov    %edx,(%esp)
c010897d:	e8 4f 15 00 00       	call   c0109ed1 <memcpy>
}
c0108982:	c9                   	leave  
c0108983:	c3                   	ret    

c0108984 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108984:	55                   	push   %ebp
c0108985:	89 e5                	mov    %esp,%ebp
c0108987:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c010898a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108991:	00 
c0108992:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108999:	00 
c010899a:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01089a1:	e8 49 14 00 00       	call   c0109def <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01089a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a9:	83 c0 48             	add    $0x48,%eax
c01089ac:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01089b3:	00 
c01089b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089b8:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01089bf:	e8 0d 15 00 00       	call   c0109ed1 <memcpy>
}
c01089c4:	c9                   	leave  
c01089c5:	c3                   	ret    

c01089c6 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01089c6:	55                   	push   %ebp
c01089c7:	89 e5                	mov    %esp,%ebp
c01089c9:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01089cc:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01089d3:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01089d8:	83 c0 01             	add    $0x1,%eax
c01089db:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01089e0:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01089e5:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01089ea:	7e 0c                	jle    c01089f8 <get_pid+0x32>
        last_pid = 1;
c01089ec:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c01089f3:	00 00 00 
        goto inside;
c01089f6:	eb 13                	jmp    c0108a0b <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01089f8:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01089fe:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108a03:	39 c2                	cmp    %eax,%edx
c0108a05:	0f 8c ac 00 00 00    	jl     c0108ab7 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108a0b:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108a12:	20 00 00 
    repeat:
        le = list;
c0108a15:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108a1b:	eb 7f                	jmp    c0108a9c <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a20:	83 e8 58             	sub    $0x58,%eax
c0108a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0108a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a29:	8b 50 04             	mov    0x4(%eax),%edx
c0108a2c:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108a31:	39 c2                	cmp    %eax,%edx
c0108a33:	75 3e                	jne    c0108a73 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0108a35:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108a3a:	83 c0 01             	add    $0x1,%eax
c0108a3d:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108a42:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c0108a48:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108a4d:	39 c2                	cmp    %eax,%edx
c0108a4f:	7c 4b                	jl     c0108a9c <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108a51:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108a56:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108a5b:	7e 0a                	jle    c0108a67 <get_pid+0xa1>
                        last_pid = 1;
c0108a5d:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108a64:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0108a67:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108a6e:	20 00 00 
                    goto repeat;
c0108a71:	eb a2                	jmp    c0108a15 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a76:	8b 50 04             	mov    0x4(%eax),%edx
c0108a79:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108a7e:	39 c2                	cmp    %eax,%edx
c0108a80:	7e 1a                	jle    c0108a9c <get_pid+0xd6>
c0108a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a85:	8b 50 04             	mov    0x4(%eax),%edx
c0108a88:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108a8d:	39 c2                	cmp    %eax,%edx
c0108a8f:	7d 0b                	jge    c0108a9c <get_pid+0xd6>
                next_safe = proc->pid;
c0108a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a94:	8b 40 04             	mov    0x4(%eax),%eax
c0108a97:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c0108a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aa5:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108aa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108aae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108ab1:	0f 85 66 ff ff ff    	jne    c0108a1d <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108ab7:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c0108abc:	c9                   	leave  
c0108abd:	c3                   	ret    

c0108abe <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108abe:	55                   	push   %ebp
c0108abf:	89 e5                	mov    %esp,%ebp
c0108ac1:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108ac4:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108ac9:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108acc:	74 63                	je     c0108b31 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108ace:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108adc:	e8 51 fc ff ff       	call   c0108732 <__intr_save>
c0108ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ae7:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aef:	8b 40 0c             	mov    0xc(%eax),%eax
c0108af2:	05 00 20 00 00       	add    $0x2000,%eax
c0108af7:	89 04 24             	mov    %eax,(%esp)
c0108afa:	e8 36 c3 ff ff       	call   c0104e35 <load_esp0>
            lcr3(next->cr3);
c0108aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b02:	8b 40 40             	mov    0x40(%eax),%eax
c0108b05:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b0b:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b11:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b17:	83 c0 1c             	add    $0x1c,%eax
c0108b1a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b1e:	89 04 24             	mov    %eax,(%esp)
c0108b21:	e8 99 06 00 00       	call   c01091bf <switch_to>
        }
        local_intr_restore(intr_flag);
c0108b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b29:	89 04 24             	mov    %eax,(%esp)
c0108b2c:	e8 2b fc ff ff       	call   c010875c <__intr_restore>
    }
}
c0108b31:	c9                   	leave  
c0108b32:	c3                   	ret    

c0108b33 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108b33:	55                   	push   %ebp
c0108b34:	89 e5                	mov    %esp,%ebp
c0108b36:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0108b39:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108b3e:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b41:	89 04 24             	mov    %eax,(%esp)
c0108b44:	e8 48 9e ff ff       	call   c0102991 <forkrets>
}
c0108b49:	c9                   	leave  
c0108b4a:	c3                   	ret    

c0108b4b <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108b4b:	55                   	push   %ebp
c0108b4c:	89 e5                	mov    %esp,%ebp
c0108b4e:	53                   	push   %ebx
c0108b4f:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b55:	8d 58 60             	lea    0x60(%eax),%ebx
c0108b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b5b:	8b 40 04             	mov    0x4(%eax),%eax
c0108b5e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108b65:	00 
c0108b66:	89 04 24             	mov    %eax,(%esp)
c0108b69:	e8 d4 07 00 00       	call   c0109342 <hash32>
c0108b6e:	c1 e0 03             	shl    $0x3,%eax
c0108b71:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b79:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b85:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b8b:	8b 40 04             	mov    0x4(%eax),%eax
c0108b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108b91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108b94:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108b97:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108b9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108b9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108ba3:	89 10                	mov    %edx,(%eax)
c0108ba5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba8:	8b 10                	mov    (%eax),%edx
c0108baa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108bb6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108bbf:	89 10                	mov    %edx,(%eax)
}
c0108bc1:	83 c4 34             	add    $0x34,%esp
c0108bc4:	5b                   	pop    %ebx
c0108bc5:	5d                   	pop    %ebp
c0108bc6:	c3                   	ret    

c0108bc7 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108bc7:	55                   	push   %ebp
c0108bc8:	89 e5                	mov    %esp,%ebp
c0108bca:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108bd1:	7e 5f                	jle    c0108c32 <find_proc+0x6b>
c0108bd3:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108bda:	7f 56                	jg     c0108c32 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bdf:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108be6:	00 
c0108be7:	89 04 24             	mov    %eax,(%esp)
c0108bea:	e8 53 07 00 00       	call   c0109342 <hash32>
c0108bef:	c1 e0 03             	shl    $0x3,%eax
c0108bf2:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108c00:	eb 19                	jmp    c0108c1b <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c05:	83 e8 60             	sub    $0x60,%eax
c0108c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c0e:	8b 40 04             	mov    0x4(%eax),%eax
c0108c11:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108c14:	75 05                	jne    c0108c1b <find_proc+0x54>
                return proc;
c0108c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c19:	eb 1c                	jmp    c0108c37 <find_proc+0x70>
c0108c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c24:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108c30:	75 d0                	jne    c0108c02 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c37:	c9                   	leave  
c0108c38:	c3                   	ret    

c0108c39 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108c39:	55                   	push   %ebp
c0108c3a:	89 e5                	mov    %esp,%ebp
c0108c3c:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108c3f:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108c46:	00 
c0108c47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108c4e:	00 
c0108c4f:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108c52:	89 04 24             	mov    %eax,(%esp)
c0108c55:	e8 95 11 00 00       	call   c0109def <memset>
    tf.tf_cs = KERNEL_CS;
c0108c5a:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108c60:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108c66:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108c6a:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108c6e:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108c72:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c79:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108c82:	b8 29 87 10 c0       	mov    $0xc0108729,%eax
c0108c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108c8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c8d:	80 cc 01             	or     $0x1,%ah
c0108c90:	89 c2                	mov    %eax,%edx
c0108c92:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108c95:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108ca0:	00 
c0108ca1:	89 14 24             	mov    %edx,(%esp)
c0108ca4:	e8 79 01 00 00       	call   c0108e22 <do_fork>
}
c0108ca9:	c9                   	leave  
c0108caa:	c3                   	ret    

c0108cab <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108cab:	55                   	push   %ebp
c0108cac:	89 e5                	mov    %esp,%ebp
c0108cae:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108cb1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108cb8:	e8 c6 c2 ff ff       	call   c0104f83 <alloc_pages>
c0108cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108cc4:	74 1a                	je     c0108ce0 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cc9:	89 04 24             	mov    %eax,(%esp)
c0108ccc:	e8 0d fb ff ff       	call   c01087de <page2kva>
c0108cd1:	89 c2                	mov    %eax,%edx
c0108cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cd6:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108cd9:	b8 00 00 00 00       	mov    $0x0,%eax
c0108cde:	eb 05                	jmp    c0108ce5 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108ce0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108ce5:	c9                   	leave  
c0108ce6:	c3                   	ret    

c0108ce7 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108ce7:	55                   	push   %ebp
c0108ce8:	89 e5                	mov    %esp,%ebp
c0108cea:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cf0:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cf3:	89 04 24             	mov    %eax,(%esp)
c0108cf6:	e8 37 fb ff ff       	call   c0108832 <kva2page>
c0108cfb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108d02:	00 
c0108d03:	89 04 24             	mov    %eax,(%esp)
c0108d06:	e8 e3 c2 ff ff       	call   c0104fee <free_pages>
}
c0108d0b:	c9                   	leave  
c0108d0c:	c3                   	ret    

c0108d0d <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108d0d:	55                   	push   %ebp
c0108d0e:	89 e5                	mov    %esp,%ebp
c0108d10:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108d13:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108d18:	8b 40 18             	mov    0x18(%eax),%eax
c0108d1b:	85 c0                	test   %eax,%eax
c0108d1d:	74 24                	je     c0108d43 <copy_mm+0x36>
c0108d1f:	c7 44 24 0c 64 be 10 	movl   $0xc010be64,0xc(%esp)
c0108d26:	c0 
c0108d27:	c7 44 24 08 78 be 10 	movl   $0xc010be78,0x8(%esp)
c0108d2e:	c0 
c0108d2f:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108d36:	00 
c0108d37:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c0108d3e:	e8 94 7f ff ff       	call   c0100cd7 <__panic>
    /* do nothing in this project */
    return 0;
c0108d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108d48:	c9                   	leave  
c0108d49:	c3                   	ret    

c0108d4a <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108d4a:	55                   	push   %ebp
c0108d4b:	89 e5                	mov    %esp,%ebp
c0108d4d:	57                   	push   %edi
c0108d4e:	56                   	push   %esi
c0108d4f:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d53:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d56:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108d5b:	89 c2                	mov    %eax,%edx
c0108d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d60:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d66:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108d69:	8b 55 10             	mov    0x10(%ebp),%edx
c0108d6c:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108d71:	89 c1                	mov    %eax,%ecx
c0108d73:	83 e1 01             	and    $0x1,%ecx
c0108d76:	85 c9                	test   %ecx,%ecx
c0108d78:	74 0e                	je     c0108d88 <copy_thread+0x3e>
c0108d7a:	0f b6 0a             	movzbl (%edx),%ecx
c0108d7d:	88 08                	mov    %cl,(%eax)
c0108d7f:	83 c0 01             	add    $0x1,%eax
c0108d82:	83 c2 01             	add    $0x1,%edx
c0108d85:	83 eb 01             	sub    $0x1,%ebx
c0108d88:	89 c1                	mov    %eax,%ecx
c0108d8a:	83 e1 02             	and    $0x2,%ecx
c0108d8d:	85 c9                	test   %ecx,%ecx
c0108d8f:	74 0f                	je     c0108da0 <copy_thread+0x56>
c0108d91:	0f b7 0a             	movzwl (%edx),%ecx
c0108d94:	66 89 08             	mov    %cx,(%eax)
c0108d97:	83 c0 02             	add    $0x2,%eax
c0108d9a:	83 c2 02             	add    $0x2,%edx
c0108d9d:	83 eb 02             	sub    $0x2,%ebx
c0108da0:	89 d9                	mov    %ebx,%ecx
c0108da2:	c1 e9 02             	shr    $0x2,%ecx
c0108da5:	89 c7                	mov    %eax,%edi
c0108da7:	89 d6                	mov    %edx,%esi
c0108da9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108dab:	89 f2                	mov    %esi,%edx
c0108dad:	89 f8                	mov    %edi,%eax
c0108daf:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108db4:	89 de                	mov    %ebx,%esi
c0108db6:	83 e6 02             	and    $0x2,%esi
c0108db9:	85 f6                	test   %esi,%esi
c0108dbb:	74 0b                	je     c0108dc8 <copy_thread+0x7e>
c0108dbd:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108dc1:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108dc5:	83 c1 02             	add    $0x2,%ecx
c0108dc8:	83 e3 01             	and    $0x1,%ebx
c0108dcb:	85 db                	test   %ebx,%ebx
c0108dcd:	74 07                	je     c0108dd6 <copy_thread+0x8c>
c0108dcf:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108dd3:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dd9:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108ddc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de6:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108de9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108dec:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108def:	8b 45 08             	mov    0x8(%ebp),%eax
c0108df2:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108df5:	8b 55 08             	mov    0x8(%ebp),%edx
c0108df8:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108dfb:	8b 52 40             	mov    0x40(%edx),%edx
c0108dfe:	80 ce 02             	or     $0x2,%dh
c0108e01:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108e04:	ba 33 8b 10 c0       	mov    $0xc0108b33,%edx
c0108e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e0c:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e12:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e15:	89 c2                	mov    %eax,%edx
c0108e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e1a:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108e1d:	5b                   	pop    %ebx
c0108e1e:	5e                   	pop    %esi
c0108e1f:	5f                   	pop    %edi
c0108e20:	5d                   	pop    %ebp
c0108e21:	c3                   	ret    

c0108e22 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108e22:	55                   	push   %ebp
c0108e23:	89 e5                	mov    %esp,%ebp
c0108e25:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108e28:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108e2f:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108e34:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108e39:	7e 05                	jle    c0108e40 <do_fork+0x1e>
        goto fork_out;
c0108e3b:	e9 19 01 00 00       	jmp    c0108f59 <do_fork+0x137>
    }
    ret = -E_NO_MEM;
c0108e40:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    if((proc = alloc_proc()) == NULL)
c0108e47:	e8 30 fa ff ff       	call   c010887c <alloc_proc>
c0108e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108e4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108e53:	75 05                	jne    c0108e5a <do_fork+0x38>
    {
    	goto fork_out;
c0108e55:	e9 ff 00 00 00       	jmp    c0108f59 <do_fork+0x137>
    }
    proc->parent = current;
c0108e5a:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e63:	89 50 14             	mov    %edx,0x14(%eax)
    //    2. call setup_kstack to allocate a kernel stack for child process
    if(setup_kstack(proc) != 0)
c0108e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e69:	89 04 24             	mov    %eax,(%esp)
c0108e6c:	e8 3a fe ff ff       	call   c0108cab <setup_kstack>
c0108e71:	85 c0                	test   %eax,%eax
c0108e73:	74 11                	je     c0108e86 <do_fork+0x64>
    {
    	goto bad_fork_cleanup_kstack;
c0108e75:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e79:	89 04 24             	mov    %eax,(%esp)
c0108e7c:	e8 66 fe ff ff       	call   c0108ce7 <put_kstack>
c0108e81:	e9 d8 00 00 00       	jmp    c0108f5e <do_fork+0x13c>
    if(setup_kstack(proc) != 0)
    {
    	goto bad_fork_cleanup_kstack;
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
    if(copy_mm(clone_flags, proc) != 0)
c0108e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e90:	89 04 24             	mov    %eax,(%esp)
c0108e93:	e8 75 fe ff ff       	call   c0108d0d <copy_mm>
c0108e98:	85 c0                	test   %eax,%eax
c0108e9a:	74 05                	je     c0108ea1 <do_fork+0x7f>
    {
    	goto bad_fork_cleanup_proc;
c0108e9c:	e9 bd 00 00 00       	jmp    c0108f5e <do_fork+0x13c>
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
c0108ea1:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ea4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108eab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108eb2:	89 04 24             	mov    %eax,(%esp)
c0108eb5:	e8 90 fe ff ff       	call   c0108d4a <copy_thread>
    //    5. insert proc_struct into hash_list && proc_list
    bool intr_flag;
    local_intr_save(intr_flag);
c0108eba:	e8 73 f8 ff ff       	call   c0108732 <__intr_save>
c0108ebf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    proc->pid = get_pid();
c0108ec2:	e8 ff fa ff ff       	call   c01089c6 <get_pid>
c0108ec7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108eca:	89 42 04             	mov    %eax,0x4(%edx)
    hash_proc(proc);
c0108ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ed0:	89 04 24             	mov    %eax,(%esp)
c0108ed3:	e8 73 fc ff ff       	call   c0108b4b <hash_proc>
    list_add(&proc_list, &(proc->list_link));
c0108ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108edb:	83 c0 58             	add    $0x58,%eax
c0108ede:	c7 45 e8 10 7c 12 c0 	movl   $0xc0127c10,-0x18(%ebp)
c0108ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108eeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108ef1:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108ef4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ef7:	8b 40 04             	mov    0x4(%eax),%eax
c0108efa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108efd:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108f03:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108f06:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108f09:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108f0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108f0f:	89 10                	mov    %edx,(%eax)
c0108f11:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108f14:	8b 10                	mov    (%eax),%edx
c0108f16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108f19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108f1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108f1f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108f22:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108f25:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108f28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108f2b:	89 10                	mov    %edx,(%eax)
    nr_process++;
c0108f2d:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108f32:	83 c0 01             	add    $0x1,%eax
c0108f35:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
    local_intr_restore(intr_flag);
c0108f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f3d:	89 04 24             	mov    %eax,(%esp)
c0108f40:	e8 17 f8 ff ff       	call   c010875c <__intr_restore>
    //    6. call wakup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0108f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f48:	89 04 24             	mov    %eax,(%esp)
c0108f4b:	e8 e3 02 00 00       	call   c0109233 <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0108f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f53:	8b 40 04             	mov    0x4(%eax),%eax
c0108f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
fork_out:
    return ret;
c0108f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f5c:	eb 0d                	jmp    c0108f6b <do_fork+0x149>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f61:	89 04 24             	mov    %eax,(%esp)
c0108f64:	e8 d8 bb ff ff       	call   c0104b41 <kfree>
    goto fork_out;
c0108f69:	eb ee                	jmp    c0108f59 <do_fork+0x137>
}
c0108f6b:	c9                   	leave  
c0108f6c:	c3                   	ret    

c0108f6d <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108f6d:	55                   	push   %ebp
c0108f6e:	89 e5                	mov    %esp,%ebp
c0108f70:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108f73:	c7 44 24 08 a1 be 10 	movl   $0xc010bea1,0x8(%esp)
c0108f7a:	c0 
c0108f7b:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
c0108f82:	00 
c0108f83:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c0108f8a:	e8 48 7d ff ff       	call   c0100cd7 <__panic>

c0108f8f <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108f8f:	55                   	push   %ebp
c0108f90:	89 e5                	mov    %esp,%ebp
c0108f92:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108f95:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108f9a:	89 04 24             	mov    %eax,(%esp)
c0108f9d:	e8 e2 f9 ff ff       	call   c0108984 <get_proc_name>
c0108fa2:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108fa8:	8b 52 04             	mov    0x4(%edx),%edx
c0108fab:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108faf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108fb3:	c7 04 24 b4 be 10 c0 	movl   $0xc010beb4,(%esp)
c0108fba:	e8 94 73 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108fbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fc6:	c7 04 24 da be 10 c0 	movl   $0xc010beda,(%esp)
c0108fcd:	e8 81 73 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108fd2:	c7 04 24 e7 be 10 c0 	movl   $0xc010bee7,(%esp)
c0108fd9:	e8 75 73 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108fe3:	c9                   	leave  
c0108fe4:	c3                   	ret    

c0108fe5 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108fe5:	55                   	push   %ebp
c0108fe6:	89 e5                	mov    %esp,%ebp
c0108fe8:	83 ec 28             	sub    $0x28,%esp
c0108feb:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ff5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108ff8:	89 50 04             	mov    %edx,0x4(%eax)
c0108ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ffe:	8b 50 04             	mov    0x4(%eax),%edx
c0109001:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109004:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010900d:	eb 26                	jmp    c0109035 <proc_init+0x50>
        list_init(hash_list + i);
c010900f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109012:	c1 e0 03             	shl    $0x3,%eax
c0109015:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010901a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010901d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109020:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109023:	89 50 04             	mov    %edx,0x4(%eax)
c0109026:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109029:	8b 50 04             	mov    0x4(%eax),%edx
c010902c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010902f:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109031:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0109035:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010903c:	7e d1                	jle    c010900f <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010903e:	e8 39 f8 ff ff       	call   c010887c <alloc_proc>
c0109043:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0109048:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010904d:	85 c0                	test   %eax,%eax
c010904f:	75 1c                	jne    c010906d <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0109051:	c7 44 24 08 03 bf 10 	movl   $0xc010bf03,0x8(%esp)
c0109058:	c0 
c0109059:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c0109060:	00 
c0109061:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c0109068:	e8 6a 7c ff ff       	call   c0100cd7 <__panic>
    }

    idleproc->pid = 0;
c010906d:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0109079:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010907e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0109084:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109089:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c010908e:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0109091:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109096:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010909d:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c01090a2:	c7 44 24 04 1b bf 10 	movl   $0xc010bf1b,0x4(%esp)
c01090a9:	c0 
c01090aa:	89 04 24             	mov    %eax,(%esp)
c01090ad:	e8 8f f8 ff ff       	call   c0108941 <set_proc_name>
    nr_process ++;
c01090b2:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c01090b7:	83 c0 01             	add    $0x1,%eax
c01090ba:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c01090bf:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c01090c4:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c01090c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01090d0:	00 
c01090d1:	c7 44 24 04 20 bf 10 	movl   $0xc010bf20,0x4(%esp)
c01090d8:	c0 
c01090d9:	c7 04 24 8f 8f 10 c0 	movl   $0xc0108f8f,(%esp)
c01090e0:	e8 54 fb ff ff       	call   c0108c39 <kernel_thread>
c01090e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c01090e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01090ec:	7f 1c                	jg     c010910a <proc_init+0x125>
        panic("create init_main failed.\n");
c01090ee:	c7 44 24 08 2e bf 10 	movl   $0xc010bf2e,0x8(%esp)
c01090f5:	c0 
c01090f6:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c01090fd:	00 
c01090fe:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c0109105:	e8 cd 7b ff ff       	call   c0100cd7 <__panic>
    }

    initproc = find_proc(pid);
c010910a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010910d:	89 04 24             	mov    %eax,(%esp)
c0109110:	e8 b2 fa ff ff       	call   c0108bc7 <find_proc>
c0109115:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c010911a:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c010911f:	c7 44 24 04 48 bf 10 	movl   $0xc010bf48,0x4(%esp)
c0109126:	c0 
c0109127:	89 04 24             	mov    %eax,(%esp)
c010912a:	e8 12 f8 ff ff       	call   c0108941 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010912f:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109134:	85 c0                	test   %eax,%eax
c0109136:	74 0c                	je     c0109144 <proc_init+0x15f>
c0109138:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010913d:	8b 40 04             	mov    0x4(%eax),%eax
c0109140:	85 c0                	test   %eax,%eax
c0109142:	74 24                	je     c0109168 <proc_init+0x183>
c0109144:	c7 44 24 0c 50 bf 10 	movl   $0xc010bf50,0xc(%esp)
c010914b:	c0 
c010914c:	c7 44 24 08 78 be 10 	movl   $0xc010be78,0x8(%esp)
c0109153:	c0 
c0109154:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c010915b:	00 
c010915c:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c0109163:	e8 6f 7b ff ff       	call   c0100cd7 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0109168:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c010916d:	85 c0                	test   %eax,%eax
c010916f:	74 0d                	je     c010917e <proc_init+0x199>
c0109171:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0109176:	8b 40 04             	mov    0x4(%eax),%eax
c0109179:	83 f8 01             	cmp    $0x1,%eax
c010917c:	74 24                	je     c01091a2 <proc_init+0x1bd>
c010917e:	c7 44 24 0c 78 bf 10 	movl   $0xc010bf78,0xc(%esp)
c0109185:	c0 
c0109186:	c7 44 24 08 78 be 10 	movl   $0xc010be78,0x8(%esp)
c010918d:	c0 
c010918e:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c0109195:	00 
c0109196:	c7 04 24 8d be 10 c0 	movl   $0xc010be8d,(%esp)
c010919d:	e8 35 7b ff ff       	call   c0100cd7 <__panic>
}
c01091a2:	c9                   	leave  
c01091a3:	c3                   	ret    

c01091a4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c01091a4:	55                   	push   %ebp
c01091a5:	89 e5                	mov    %esp,%ebp
c01091a7:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c01091aa:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01091af:	8b 40 10             	mov    0x10(%eax),%eax
c01091b2:	85 c0                	test   %eax,%eax
c01091b4:	74 07                	je     c01091bd <cpu_idle+0x19>
            schedule();
c01091b6:	e8 c1 00 00 00       	call   c010927c <schedule>
        }
    }
c01091bb:	eb ed                	jmp    c01091aa <cpu_idle+0x6>
c01091bd:	eb eb                	jmp    c01091aa <cpu_idle+0x6>

c01091bf <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c01091bf:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c01091c3:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c01091c5:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c01091c8:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c01091cb:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c01091ce:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c01091d1:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c01091d4:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c01091d7:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c01091da:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c01091de:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c01091e1:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c01091e4:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c01091e7:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c01091ea:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c01091ed:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c01091f0:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c01091f3:	ff 30                	pushl  (%eax)

    ret
c01091f5:	c3                   	ret    

c01091f6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01091f6:	55                   	push   %ebp
c01091f7:	89 e5                	mov    %esp,%ebp
c01091f9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01091fc:	9c                   	pushf  
c01091fd:	58                   	pop    %eax
c01091fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0109201:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0109204:	25 00 02 00 00       	and    $0x200,%eax
c0109209:	85 c0                	test   %eax,%eax
c010920b:	74 0c                	je     c0109219 <__intr_save+0x23>
        intr_disable();
c010920d:	e8 1d 8d ff ff       	call   c0101f2f <intr_disable>
        return 1;
c0109212:	b8 01 00 00 00       	mov    $0x1,%eax
c0109217:	eb 05                	jmp    c010921e <__intr_save+0x28>
    }
    return 0;
c0109219:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010921e:	c9                   	leave  
c010921f:	c3                   	ret    

c0109220 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0109220:	55                   	push   %ebp
c0109221:	89 e5                	mov    %esp,%ebp
c0109223:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010922a:	74 05                	je     c0109231 <__intr_restore+0x11>
        intr_enable();
c010922c:	e8 f8 8c ff ff       	call   c0101f29 <intr_enable>
    }
}
c0109231:	c9                   	leave  
c0109232:	c3                   	ret    

c0109233 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0109233:	55                   	push   %ebp
c0109234:	89 e5                	mov    %esp,%ebp
c0109236:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0109239:	8b 45 08             	mov    0x8(%ebp),%eax
c010923c:	8b 00                	mov    (%eax),%eax
c010923e:	83 f8 03             	cmp    $0x3,%eax
c0109241:	74 0a                	je     c010924d <wakeup_proc+0x1a>
c0109243:	8b 45 08             	mov    0x8(%ebp),%eax
c0109246:	8b 00                	mov    (%eax),%eax
c0109248:	83 f8 02             	cmp    $0x2,%eax
c010924b:	75 24                	jne    c0109271 <wakeup_proc+0x3e>
c010924d:	c7 44 24 0c a0 bf 10 	movl   $0xc010bfa0,0xc(%esp)
c0109254:	c0 
c0109255:	c7 44 24 08 db bf 10 	movl   $0xc010bfdb,0x8(%esp)
c010925c:	c0 
c010925d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0109264:	00 
c0109265:	c7 04 24 f0 bf 10 c0 	movl   $0xc010bff0,(%esp)
c010926c:	e8 66 7a ff ff       	call   c0100cd7 <__panic>
    proc->state = PROC_RUNNABLE;
c0109271:	8b 45 08             	mov    0x8(%ebp),%eax
c0109274:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c010927a:	c9                   	leave  
c010927b:	c3                   	ret    

c010927c <schedule>:

void
schedule(void) {
c010927c:	55                   	push   %ebp
c010927d:	89 e5                	mov    %esp,%ebp
c010927f:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0109282:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0109289:	e8 68 ff ff ff       	call   c01091f6 <__intr_save>
c010928e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0109291:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109296:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010929d:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c01092a3:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c01092a8:	39 c2                	cmp    %eax,%edx
c01092aa:	74 0a                	je     c01092b6 <schedule+0x3a>
c01092ac:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01092b1:	83 c0 58             	add    $0x58,%eax
c01092b4:	eb 05                	jmp    c01092bb <schedule+0x3f>
c01092b6:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c01092bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c01092be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01092ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092cd:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c01092d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092d3:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c01092da:	74 15                	je     c01092f1 <schedule+0x75>
                next = le2proc(le, list_link);
c01092dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092df:	83 e8 58             	sub    $0x58,%eax
c01092e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c01092e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01092e8:	8b 00                	mov    (%eax),%eax
c01092ea:	83 f8 02             	cmp    $0x2,%eax
c01092ed:	75 02                	jne    c01092f1 <schedule+0x75>
                    break;
c01092ef:	eb 08                	jmp    c01092f9 <schedule+0x7d>
                }
            }
        } while (le != last);
c01092f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01092f7:	75 cb                	jne    c01092c4 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c01092f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01092fd:	74 0a                	je     c0109309 <schedule+0x8d>
c01092ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109302:	8b 00                	mov    (%eax),%eax
c0109304:	83 f8 02             	cmp    $0x2,%eax
c0109307:	74 08                	je     c0109311 <schedule+0x95>
            next = idleproc;
c0109309:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010930e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109311:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109314:	8b 40 08             	mov    0x8(%eax),%eax
c0109317:	8d 50 01             	lea    0x1(%eax),%edx
c010931a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010931d:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109320:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109325:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109328:	74 0b                	je     c0109335 <schedule+0xb9>
            proc_run(next);
c010932a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010932d:	89 04 24             	mov    %eax,(%esp)
c0109330:	e8 89 f7 ff ff       	call   c0108abe <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109335:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109338:	89 04 24             	mov    %eax,(%esp)
c010933b:	e8 e0 fe ff ff       	call   c0109220 <__intr_restore>
}
c0109340:	c9                   	leave  
c0109341:	c3                   	ret    

c0109342 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109342:	55                   	push   %ebp
c0109343:	89 e5                	mov    %esp,%ebp
c0109345:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109348:	8b 45 08             	mov    0x8(%ebp),%eax
c010934b:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109351:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109354:	b8 20 00 00 00       	mov    $0x20,%eax
c0109359:	2b 45 0c             	sub    0xc(%ebp),%eax
c010935c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010935f:	89 c1                	mov    %eax,%ecx
c0109361:	d3 ea                	shr    %cl,%edx
c0109363:	89 d0                	mov    %edx,%eax
}
c0109365:	c9                   	leave  
c0109366:	c3                   	ret    

c0109367 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0109367:	55                   	push   %ebp
c0109368:	89 e5                	mov    %esp,%ebp
c010936a:	83 ec 58             	sub    $0x58,%esp
c010936d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109370:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109373:	8b 45 14             	mov    0x14(%ebp),%eax
c0109376:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109379:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010937c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010937f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109382:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109385:	8b 45 18             	mov    0x18(%ebp),%eax
c0109388:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010938b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010938e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109391:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109394:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109397:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010939a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010939d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01093a1:	74 1c                	je     c01093bf <printnum+0x58>
c01093a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01093a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01093ab:	f7 75 e4             	divl   -0x1c(%ebp)
c01093ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01093b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01093b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01093b9:	f7 75 e4             	divl   -0x1c(%ebp)
c01093bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01093bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01093c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01093c5:	f7 75 e4             	divl   -0x1c(%ebp)
c01093c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01093cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01093ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01093d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01093d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01093d7:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01093da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01093dd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01093e0:	8b 45 18             	mov    0x18(%ebp),%eax
c01093e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01093e8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01093eb:	77 56                	ja     c0109443 <printnum+0xdc>
c01093ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01093f0:	72 05                	jb     c01093f7 <printnum+0x90>
c01093f2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01093f5:	77 4c                	ja     c0109443 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01093f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01093fa:	8d 50 ff             	lea    -0x1(%eax),%edx
c01093fd:	8b 45 20             	mov    0x20(%ebp),%eax
c0109400:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109404:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109408:	8b 45 18             	mov    0x18(%ebp),%eax
c010940b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010940f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109412:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109415:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109419:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010941d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109420:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109424:	8b 45 08             	mov    0x8(%ebp),%eax
c0109427:	89 04 24             	mov    %eax,(%esp)
c010942a:	e8 38 ff ff ff       	call   c0109367 <printnum>
c010942f:	eb 1c                	jmp    c010944d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109431:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109434:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109438:	8b 45 20             	mov    0x20(%ebp),%eax
c010943b:	89 04 24             	mov    %eax,(%esp)
c010943e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109441:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109443:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0109447:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010944b:	7f e4                	jg     c0109431 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010944d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109450:	05 88 c0 10 c0       	add    $0xc010c088,%eax
c0109455:	0f b6 00             	movzbl (%eax),%eax
c0109458:	0f be c0             	movsbl %al,%eax
c010945b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010945e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109462:	89 04 24             	mov    %eax,(%esp)
c0109465:	8b 45 08             	mov    0x8(%ebp),%eax
c0109468:	ff d0                	call   *%eax
}
c010946a:	c9                   	leave  
c010946b:	c3                   	ret    

c010946c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010946c:	55                   	push   %ebp
c010946d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010946f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109473:	7e 14                	jle    c0109489 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109475:	8b 45 08             	mov    0x8(%ebp),%eax
c0109478:	8b 00                	mov    (%eax),%eax
c010947a:	8d 48 08             	lea    0x8(%eax),%ecx
c010947d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109480:	89 0a                	mov    %ecx,(%edx)
c0109482:	8b 50 04             	mov    0x4(%eax),%edx
c0109485:	8b 00                	mov    (%eax),%eax
c0109487:	eb 30                	jmp    c01094b9 <getuint+0x4d>
    }
    else if (lflag) {
c0109489:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010948d:	74 16                	je     c01094a5 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010948f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109492:	8b 00                	mov    (%eax),%eax
c0109494:	8d 48 04             	lea    0x4(%eax),%ecx
c0109497:	8b 55 08             	mov    0x8(%ebp),%edx
c010949a:	89 0a                	mov    %ecx,(%edx)
c010949c:	8b 00                	mov    (%eax),%eax
c010949e:	ba 00 00 00 00       	mov    $0x0,%edx
c01094a3:	eb 14                	jmp    c01094b9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01094a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01094a8:	8b 00                	mov    (%eax),%eax
c01094aa:	8d 48 04             	lea    0x4(%eax),%ecx
c01094ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01094b0:	89 0a                	mov    %ecx,(%edx)
c01094b2:	8b 00                	mov    (%eax),%eax
c01094b4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01094b9:	5d                   	pop    %ebp
c01094ba:	c3                   	ret    

c01094bb <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01094bb:	55                   	push   %ebp
c01094bc:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01094be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01094c2:	7e 14                	jle    c01094d8 <getint+0x1d>
        return va_arg(*ap, long long);
c01094c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c7:	8b 00                	mov    (%eax),%eax
c01094c9:	8d 48 08             	lea    0x8(%eax),%ecx
c01094cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01094cf:	89 0a                	mov    %ecx,(%edx)
c01094d1:	8b 50 04             	mov    0x4(%eax),%edx
c01094d4:	8b 00                	mov    (%eax),%eax
c01094d6:	eb 28                	jmp    c0109500 <getint+0x45>
    }
    else if (lflag) {
c01094d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01094dc:	74 12                	je     c01094f0 <getint+0x35>
        return va_arg(*ap, long);
c01094de:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e1:	8b 00                	mov    (%eax),%eax
c01094e3:	8d 48 04             	lea    0x4(%eax),%ecx
c01094e6:	8b 55 08             	mov    0x8(%ebp),%edx
c01094e9:	89 0a                	mov    %ecx,(%edx)
c01094eb:	8b 00                	mov    (%eax),%eax
c01094ed:	99                   	cltd   
c01094ee:	eb 10                	jmp    c0109500 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01094f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01094f3:	8b 00                	mov    (%eax),%eax
c01094f5:	8d 48 04             	lea    0x4(%eax),%ecx
c01094f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01094fb:	89 0a                	mov    %ecx,(%edx)
c01094fd:	8b 00                	mov    (%eax),%eax
c01094ff:	99                   	cltd   
    }
}
c0109500:	5d                   	pop    %ebp
c0109501:	c3                   	ret    

c0109502 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109502:	55                   	push   %ebp
c0109503:	89 e5                	mov    %esp,%ebp
c0109505:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0109508:	8d 45 14             	lea    0x14(%ebp),%eax
c010950b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010950e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109511:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109515:	8b 45 10             	mov    0x10(%ebp),%eax
c0109518:	89 44 24 08          	mov    %eax,0x8(%esp)
c010951c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010951f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109523:	8b 45 08             	mov    0x8(%ebp),%eax
c0109526:	89 04 24             	mov    %eax,(%esp)
c0109529:	e8 02 00 00 00       	call   c0109530 <vprintfmt>
    va_end(ap);
}
c010952e:	c9                   	leave  
c010952f:	c3                   	ret    

c0109530 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109530:	55                   	push   %ebp
c0109531:	89 e5                	mov    %esp,%ebp
c0109533:	56                   	push   %esi
c0109534:	53                   	push   %ebx
c0109535:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109538:	eb 18                	jmp    c0109552 <vprintfmt+0x22>
            if (ch == '\0') {
c010953a:	85 db                	test   %ebx,%ebx
c010953c:	75 05                	jne    c0109543 <vprintfmt+0x13>
                return;
c010953e:	e9 d1 03 00 00       	jmp    c0109914 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109543:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109546:	89 44 24 04          	mov    %eax,0x4(%esp)
c010954a:	89 1c 24             	mov    %ebx,(%esp)
c010954d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109550:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109552:	8b 45 10             	mov    0x10(%ebp),%eax
c0109555:	8d 50 01             	lea    0x1(%eax),%edx
c0109558:	89 55 10             	mov    %edx,0x10(%ebp)
c010955b:	0f b6 00             	movzbl (%eax),%eax
c010955e:	0f b6 d8             	movzbl %al,%ebx
c0109561:	83 fb 25             	cmp    $0x25,%ebx
c0109564:	75 d4                	jne    c010953a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0109566:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010956a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109574:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109577:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010957e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109581:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109584:	8b 45 10             	mov    0x10(%ebp),%eax
c0109587:	8d 50 01             	lea    0x1(%eax),%edx
c010958a:	89 55 10             	mov    %edx,0x10(%ebp)
c010958d:	0f b6 00             	movzbl (%eax),%eax
c0109590:	0f b6 d8             	movzbl %al,%ebx
c0109593:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109596:	83 f8 55             	cmp    $0x55,%eax
c0109599:	0f 87 44 03 00 00    	ja     c01098e3 <vprintfmt+0x3b3>
c010959f:	8b 04 85 ac c0 10 c0 	mov    -0x3fef3f54(,%eax,4),%eax
c01095a6:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01095a8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01095ac:	eb d6                	jmp    c0109584 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01095ae:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01095b2:	eb d0                	jmp    c0109584 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01095b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01095bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01095be:	89 d0                	mov    %edx,%eax
c01095c0:	c1 e0 02             	shl    $0x2,%eax
c01095c3:	01 d0                	add    %edx,%eax
c01095c5:	01 c0                	add    %eax,%eax
c01095c7:	01 d8                	add    %ebx,%eax
c01095c9:	83 e8 30             	sub    $0x30,%eax
c01095cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01095cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01095d2:	0f b6 00             	movzbl (%eax),%eax
c01095d5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01095d8:	83 fb 2f             	cmp    $0x2f,%ebx
c01095db:	7e 0b                	jle    c01095e8 <vprintfmt+0xb8>
c01095dd:	83 fb 39             	cmp    $0x39,%ebx
c01095e0:	7f 06                	jg     c01095e8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01095e2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01095e6:	eb d3                	jmp    c01095bb <vprintfmt+0x8b>
            goto process_precision;
c01095e8:	eb 33                	jmp    c010961d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01095ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01095ed:	8d 50 04             	lea    0x4(%eax),%edx
c01095f0:	89 55 14             	mov    %edx,0x14(%ebp)
c01095f3:	8b 00                	mov    (%eax),%eax
c01095f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01095f8:	eb 23                	jmp    c010961d <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01095fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01095fe:	79 0c                	jns    c010960c <vprintfmt+0xdc>
                width = 0;
c0109600:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109607:	e9 78 ff ff ff       	jmp    c0109584 <vprintfmt+0x54>
c010960c:	e9 73 ff ff ff       	jmp    c0109584 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109611:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109618:	e9 67 ff ff ff       	jmp    c0109584 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010961d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109621:	79 12                	jns    c0109635 <vprintfmt+0x105>
                width = precision, precision = -1;
c0109623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109626:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109629:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109630:	e9 4f ff ff ff       	jmp    c0109584 <vprintfmt+0x54>
c0109635:	e9 4a ff ff ff       	jmp    c0109584 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010963a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010963e:	e9 41 ff ff ff       	jmp    c0109584 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109643:	8b 45 14             	mov    0x14(%ebp),%eax
c0109646:	8d 50 04             	lea    0x4(%eax),%edx
c0109649:	89 55 14             	mov    %edx,0x14(%ebp)
c010964c:	8b 00                	mov    (%eax),%eax
c010964e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109651:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109655:	89 04 24             	mov    %eax,(%esp)
c0109658:	8b 45 08             	mov    0x8(%ebp),%eax
c010965b:	ff d0                	call   *%eax
            break;
c010965d:	e9 ac 02 00 00       	jmp    c010990e <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109662:	8b 45 14             	mov    0x14(%ebp),%eax
c0109665:	8d 50 04             	lea    0x4(%eax),%edx
c0109668:	89 55 14             	mov    %edx,0x14(%ebp)
c010966b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010966d:	85 db                	test   %ebx,%ebx
c010966f:	79 02                	jns    c0109673 <vprintfmt+0x143>
                err = -err;
c0109671:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109673:	83 fb 06             	cmp    $0x6,%ebx
c0109676:	7f 0b                	jg     c0109683 <vprintfmt+0x153>
c0109678:	8b 34 9d 6c c0 10 c0 	mov    -0x3fef3f94(,%ebx,4),%esi
c010967f:	85 f6                	test   %esi,%esi
c0109681:	75 23                	jne    c01096a6 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109683:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109687:	c7 44 24 08 99 c0 10 	movl   $0xc010c099,0x8(%esp)
c010968e:	c0 
c010968f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109692:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109696:	8b 45 08             	mov    0x8(%ebp),%eax
c0109699:	89 04 24             	mov    %eax,(%esp)
c010969c:	e8 61 fe ff ff       	call   c0109502 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01096a1:	e9 68 02 00 00       	jmp    c010990e <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01096a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01096aa:	c7 44 24 08 a2 c0 10 	movl   $0xc010c0a2,0x8(%esp)
c01096b1:	c0 
c01096b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01096bc:	89 04 24             	mov    %eax,(%esp)
c01096bf:	e8 3e fe ff ff       	call   c0109502 <printfmt>
            }
            break;
c01096c4:	e9 45 02 00 00       	jmp    c010990e <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01096c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01096cc:	8d 50 04             	lea    0x4(%eax),%edx
c01096cf:	89 55 14             	mov    %edx,0x14(%ebp)
c01096d2:	8b 30                	mov    (%eax),%esi
c01096d4:	85 f6                	test   %esi,%esi
c01096d6:	75 05                	jne    c01096dd <vprintfmt+0x1ad>
                p = "(null)";
c01096d8:	be a5 c0 10 c0       	mov    $0xc010c0a5,%esi
            }
            if (width > 0 && padc != '-') {
c01096dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01096e1:	7e 3e                	jle    c0109721 <vprintfmt+0x1f1>
c01096e3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01096e7:	74 38                	je     c0109721 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01096e9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01096ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01096ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096f3:	89 34 24             	mov    %esi,(%esp)
c01096f6:	e8 ed 03 00 00       	call   c0109ae8 <strnlen>
c01096fb:	29 c3                	sub    %eax,%ebx
c01096fd:	89 d8                	mov    %ebx,%eax
c01096ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109702:	eb 17                	jmp    c010971b <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109704:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109708:	8b 55 0c             	mov    0xc(%ebp),%edx
c010970b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010970f:	89 04 24             	mov    %eax,(%esp)
c0109712:	8b 45 08             	mov    0x8(%ebp),%eax
c0109715:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109717:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010971b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010971f:	7f e3                	jg     c0109704 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109721:	eb 38                	jmp    c010975b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109723:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109727:	74 1f                	je     c0109748 <vprintfmt+0x218>
c0109729:	83 fb 1f             	cmp    $0x1f,%ebx
c010972c:	7e 05                	jle    c0109733 <vprintfmt+0x203>
c010972e:	83 fb 7e             	cmp    $0x7e,%ebx
c0109731:	7e 15                	jle    c0109748 <vprintfmt+0x218>
                    putch('?', putdat);
c0109733:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109736:	89 44 24 04          	mov    %eax,0x4(%esp)
c010973a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109741:	8b 45 08             	mov    0x8(%ebp),%eax
c0109744:	ff d0                	call   *%eax
c0109746:	eb 0f                	jmp    c0109757 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0109748:	8b 45 0c             	mov    0xc(%ebp),%eax
c010974b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010974f:	89 1c 24             	mov    %ebx,(%esp)
c0109752:	8b 45 08             	mov    0x8(%ebp),%eax
c0109755:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109757:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010975b:	89 f0                	mov    %esi,%eax
c010975d:	8d 70 01             	lea    0x1(%eax),%esi
c0109760:	0f b6 00             	movzbl (%eax),%eax
c0109763:	0f be d8             	movsbl %al,%ebx
c0109766:	85 db                	test   %ebx,%ebx
c0109768:	74 10                	je     c010977a <vprintfmt+0x24a>
c010976a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010976e:	78 b3                	js     c0109723 <vprintfmt+0x1f3>
c0109770:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109774:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109778:	79 a9                	jns    c0109723 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010977a:	eb 17                	jmp    c0109793 <vprintfmt+0x263>
                putch(' ', putdat);
c010977c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010977f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109783:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010978a:	8b 45 08             	mov    0x8(%ebp),%eax
c010978d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010978f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109793:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109797:	7f e3                	jg     c010977c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0109799:	e9 70 01 00 00       	jmp    c010990e <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010979e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01097a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097a5:	8d 45 14             	lea    0x14(%ebp),%eax
c01097a8:	89 04 24             	mov    %eax,(%esp)
c01097ab:	e8 0b fd ff ff       	call   c01094bb <getint>
c01097b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01097b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01097b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01097bc:	85 d2                	test   %edx,%edx
c01097be:	79 26                	jns    c01097e6 <vprintfmt+0x2b6>
                putch('-', putdat);
c01097c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097c7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01097ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01097d1:	ff d0                	call   *%eax
                num = -(long long)num;
c01097d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01097d9:	f7 d8                	neg    %eax
c01097db:	83 d2 00             	adc    $0x0,%edx
c01097de:	f7 da                	neg    %edx
c01097e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01097e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01097e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01097ed:	e9 a8 00 00 00       	jmp    c010989a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01097f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01097f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097f9:	8d 45 14             	lea    0x14(%ebp),%eax
c01097fc:	89 04 24             	mov    %eax,(%esp)
c01097ff:	e8 68 fc ff ff       	call   c010946c <getuint>
c0109804:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109807:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010980a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109811:	e9 84 00 00 00       	jmp    c010989a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109816:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010981d:	8d 45 14             	lea    0x14(%ebp),%eax
c0109820:	89 04 24             	mov    %eax,(%esp)
c0109823:	e8 44 fc ff ff       	call   c010946c <getuint>
c0109828:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010982b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010982e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109835:	eb 63                	jmp    c010989a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0109837:	8b 45 0c             	mov    0xc(%ebp),%eax
c010983a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010983e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109845:	8b 45 08             	mov    0x8(%ebp),%eax
c0109848:	ff d0                	call   *%eax
            putch('x', putdat);
c010984a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010984d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109851:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109858:	8b 45 08             	mov    0x8(%ebp),%eax
c010985b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010985d:	8b 45 14             	mov    0x14(%ebp),%eax
c0109860:	8d 50 04             	lea    0x4(%eax),%edx
c0109863:	89 55 14             	mov    %edx,0x14(%ebp)
c0109866:	8b 00                	mov    (%eax),%eax
c0109868:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010986b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109872:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109879:	eb 1f                	jmp    c010989a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010987b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010987e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109882:	8d 45 14             	lea    0x14(%ebp),%eax
c0109885:	89 04 24             	mov    %eax,(%esp)
c0109888:	e8 df fb ff ff       	call   c010946c <getuint>
c010988d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109890:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109893:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010989a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010989e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098a1:	89 54 24 18          	mov    %edx,0x18(%esp)
c01098a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01098a8:	89 54 24 14          	mov    %edx,0x14(%esp)
c01098ac:	89 44 24 10          	mov    %eax,0x10(%esp)
c01098b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01098ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01098be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01098c8:	89 04 24             	mov    %eax,(%esp)
c01098cb:	e8 97 fa ff ff       	call   c0109367 <printnum>
            break;
c01098d0:	eb 3c                	jmp    c010990e <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01098d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098d9:	89 1c 24             	mov    %ebx,(%esp)
c01098dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01098df:	ff d0                	call   *%eax
            break;
c01098e1:	eb 2b                	jmp    c010990e <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01098e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01098f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01098f4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01098f6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01098fa:	eb 04                	jmp    c0109900 <vprintfmt+0x3d0>
c01098fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109900:	8b 45 10             	mov    0x10(%ebp),%eax
c0109903:	83 e8 01             	sub    $0x1,%eax
c0109906:	0f b6 00             	movzbl (%eax),%eax
c0109909:	3c 25                	cmp    $0x25,%al
c010990b:	75 ef                	jne    c01098fc <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010990d:	90                   	nop
        }
    }
c010990e:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010990f:	e9 3e fc ff ff       	jmp    c0109552 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109914:	83 c4 40             	add    $0x40,%esp
c0109917:	5b                   	pop    %ebx
c0109918:	5e                   	pop    %esi
c0109919:	5d                   	pop    %ebp
c010991a:	c3                   	ret    

c010991b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010991b:	55                   	push   %ebp
c010991c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010991e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109921:	8b 40 08             	mov    0x8(%eax),%eax
c0109924:	8d 50 01             	lea    0x1(%eax),%edx
c0109927:	8b 45 0c             	mov    0xc(%ebp),%eax
c010992a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010992d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109930:	8b 10                	mov    (%eax),%edx
c0109932:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109935:	8b 40 04             	mov    0x4(%eax),%eax
c0109938:	39 c2                	cmp    %eax,%edx
c010993a:	73 12                	jae    c010994e <sprintputch+0x33>
        *b->buf ++ = ch;
c010993c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010993f:	8b 00                	mov    (%eax),%eax
c0109941:	8d 48 01             	lea    0x1(%eax),%ecx
c0109944:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109947:	89 0a                	mov    %ecx,(%edx)
c0109949:	8b 55 08             	mov    0x8(%ebp),%edx
c010994c:	88 10                	mov    %dl,(%eax)
    }
}
c010994e:	5d                   	pop    %ebp
c010994f:	c3                   	ret    

c0109950 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109950:	55                   	push   %ebp
c0109951:	89 e5                	mov    %esp,%ebp
c0109953:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109956:	8d 45 14             	lea    0x14(%ebp),%eax
c0109959:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010995c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010995f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109963:	8b 45 10             	mov    0x10(%ebp),%eax
c0109966:	89 44 24 08          	mov    %eax,0x8(%esp)
c010996a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010996d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109971:	8b 45 08             	mov    0x8(%ebp),%eax
c0109974:	89 04 24             	mov    %eax,(%esp)
c0109977:	e8 08 00 00 00       	call   c0109984 <vsnprintf>
c010997c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010997f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109982:	c9                   	leave  
c0109983:	c3                   	ret    

c0109984 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109984:	55                   	push   %ebp
c0109985:	89 e5                	mov    %esp,%ebp
c0109987:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010998a:	8b 45 08             	mov    0x8(%ebp),%eax
c010998d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109990:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109993:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109996:	8b 45 08             	mov    0x8(%ebp),%eax
c0109999:	01 d0                	add    %edx,%eax
c010999b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010999e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01099a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01099a9:	74 0a                	je     c01099b5 <vsnprintf+0x31>
c01099ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01099ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099b1:	39 c2                	cmp    %eax,%edx
c01099b3:	76 07                	jbe    c01099bc <vsnprintf+0x38>
        return -E_INVAL;
c01099b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01099ba:	eb 2a                	jmp    c01099e6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01099bc:	8b 45 14             	mov    0x14(%ebp),%eax
c01099bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01099c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01099c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01099ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01099cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099d1:	c7 04 24 1b 99 10 c0 	movl   $0xc010991b,(%esp)
c01099d8:	e8 53 fb ff ff       	call   c0109530 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01099dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01099e0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01099e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01099e6:	c9                   	leave  
c01099e7:	c3                   	ret    

c01099e8 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01099e8:	55                   	push   %ebp
c01099e9:	89 e5                	mov    %esp,%ebp
c01099eb:	57                   	push   %edi
c01099ec:	56                   	push   %esi
c01099ed:	53                   	push   %ebx
c01099ee:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01099f1:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01099f6:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01099fc:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109a02:	6b f0 05             	imul   $0x5,%eax,%esi
c0109a05:	01 f7                	add    %esi,%edi
c0109a07:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0109a0c:	f7 e6                	mul    %esi
c0109a0e:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109a11:	89 f2                	mov    %esi,%edx
c0109a13:	83 c0 0b             	add    $0xb,%eax
c0109a16:	83 d2 00             	adc    $0x0,%edx
c0109a19:	89 c7                	mov    %eax,%edi
c0109a1b:	83 e7 ff             	and    $0xffffffff,%edi
c0109a1e:	89 f9                	mov    %edi,%ecx
c0109a20:	0f b7 da             	movzwl %dx,%ebx
c0109a23:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c0109a29:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c0109a2f:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109a34:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c0109a3a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109a3e:	c1 ea 0c             	shr    $0xc,%edx
c0109a41:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109a44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109a47:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109a54:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109a57:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a64:	74 1c                	je     c0109a82 <rand+0x9a>
c0109a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109a69:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a6e:	f7 75 dc             	divl   -0x24(%ebp)
c0109a71:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109a77:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a7c:	f7 75 dc             	divl   -0x24(%ebp)
c0109a7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a82:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109a85:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a88:	f7 75 dc             	divl   -0x24(%ebp)
c0109a8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109a8e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109a94:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109a97:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109a9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109a9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109aa0:	83 c4 24             	add    $0x24,%esp
c0109aa3:	5b                   	pop    %ebx
c0109aa4:	5e                   	pop    %esi
c0109aa5:	5f                   	pop    %edi
c0109aa6:	5d                   	pop    %ebp
c0109aa7:	c3                   	ret    

c0109aa8 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109aa8:	55                   	push   %ebp
c0109aa9:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aae:	ba 00 00 00 00       	mov    $0x0,%edx
c0109ab3:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c0109ab8:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c0109abe:	5d                   	pop    %ebp
c0109abf:	c3                   	ret    

c0109ac0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109ac0:	55                   	push   %ebp
c0109ac1:	89 e5                	mov    %esp,%ebp
c0109ac3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109ac6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109acd:	eb 04                	jmp    c0109ad3 <strlen+0x13>
        cnt ++;
c0109acf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ad6:	8d 50 01             	lea    0x1(%eax),%edx
c0109ad9:	89 55 08             	mov    %edx,0x8(%ebp)
c0109adc:	0f b6 00             	movzbl (%eax),%eax
c0109adf:	84 c0                	test   %al,%al
c0109ae1:	75 ec                	jne    c0109acf <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109ae6:	c9                   	leave  
c0109ae7:	c3                   	ret    

c0109ae8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109ae8:	55                   	push   %ebp
c0109ae9:	89 e5                	mov    %esp,%ebp
c0109aeb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109aee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109af5:	eb 04                	jmp    c0109afb <strnlen+0x13>
        cnt ++;
c0109af7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0109afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109afe:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109b01:	73 10                	jae    c0109b13 <strnlen+0x2b>
c0109b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b06:	8d 50 01             	lea    0x1(%eax),%edx
c0109b09:	89 55 08             	mov    %edx,0x8(%ebp)
c0109b0c:	0f b6 00             	movzbl (%eax),%eax
c0109b0f:	84 c0                	test   %al,%al
c0109b11:	75 e4                	jne    c0109af7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109b16:	c9                   	leave  
c0109b17:	c3                   	ret    

c0109b18 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109b18:	55                   	push   %ebp
c0109b19:	89 e5                	mov    %esp,%ebp
c0109b1b:	57                   	push   %edi
c0109b1c:	56                   	push   %esi
c0109b1d:	83 ec 20             	sub    $0x20,%esp
c0109b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0109b2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b32:	89 d1                	mov    %edx,%ecx
c0109b34:	89 c2                	mov    %eax,%edx
c0109b36:	89 ce                	mov    %ecx,%esi
c0109b38:	89 d7                	mov    %edx,%edi
c0109b3a:	ac                   	lods   %ds:(%esi),%al
c0109b3b:	aa                   	stos   %al,%es:(%edi)
c0109b3c:	84 c0                	test   %al,%al
c0109b3e:	75 fa                	jne    c0109b3a <strcpy+0x22>
c0109b40:	89 fa                	mov    %edi,%edx
c0109b42:	89 f1                	mov    %esi,%ecx
c0109b44:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109b47:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109b50:	83 c4 20             	add    $0x20,%esp
c0109b53:	5e                   	pop    %esi
c0109b54:	5f                   	pop    %edi
c0109b55:	5d                   	pop    %ebp
c0109b56:	c3                   	ret    

c0109b57 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109b57:	55                   	push   %ebp
c0109b58:	89 e5                	mov    %esp,%ebp
c0109b5a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b60:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109b63:	eb 21                	jmp    c0109b86 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109b65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b68:	0f b6 10             	movzbl (%eax),%edx
c0109b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109b6e:	88 10                	mov    %dl,(%eax)
c0109b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109b73:	0f b6 00             	movzbl (%eax),%eax
c0109b76:	84 c0                	test   %al,%al
c0109b78:	74 04                	je     c0109b7e <strncpy+0x27>
            src ++;
c0109b7a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109b7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109b82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0109b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109b8a:	75 d9                	jne    c0109b65 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109b8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109b8f:	c9                   	leave  
c0109b90:	c3                   	ret    

c0109b91 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109b91:	55                   	push   %ebp
c0109b92:	89 e5                	mov    %esp,%ebp
c0109b94:	57                   	push   %edi
c0109b95:	56                   	push   %esi
c0109b96:	83 ec 20             	sub    $0x20,%esp
c0109b99:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0109ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bab:	89 d1                	mov    %edx,%ecx
c0109bad:	89 c2                	mov    %eax,%edx
c0109baf:	89 ce                	mov    %ecx,%esi
c0109bb1:	89 d7                	mov    %edx,%edi
c0109bb3:	ac                   	lods   %ds:(%esi),%al
c0109bb4:	ae                   	scas   %es:(%edi),%al
c0109bb5:	75 08                	jne    c0109bbf <strcmp+0x2e>
c0109bb7:	84 c0                	test   %al,%al
c0109bb9:	75 f8                	jne    c0109bb3 <strcmp+0x22>
c0109bbb:	31 c0                	xor    %eax,%eax
c0109bbd:	eb 04                	jmp    c0109bc3 <strcmp+0x32>
c0109bbf:	19 c0                	sbb    %eax,%eax
c0109bc1:	0c 01                	or     $0x1,%al
c0109bc3:	89 fa                	mov    %edi,%edx
c0109bc5:	89 f1                	mov    %esi,%ecx
c0109bc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109bca:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109bcd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109bd3:	83 c4 20             	add    $0x20,%esp
c0109bd6:	5e                   	pop    %esi
c0109bd7:	5f                   	pop    %edi
c0109bd8:	5d                   	pop    %ebp
c0109bd9:	c3                   	ret    

c0109bda <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109bda:	55                   	push   %ebp
c0109bdb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109bdd:	eb 0c                	jmp    c0109beb <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109bdf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109be3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109be7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109bef:	74 1a                	je     c0109c0b <strncmp+0x31>
c0109bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bf4:	0f b6 00             	movzbl (%eax),%eax
c0109bf7:	84 c0                	test   %al,%al
c0109bf9:	74 10                	je     c0109c0b <strncmp+0x31>
c0109bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bfe:	0f b6 10             	movzbl (%eax),%edx
c0109c01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c04:	0f b6 00             	movzbl (%eax),%eax
c0109c07:	38 c2                	cmp    %al,%dl
c0109c09:	74 d4                	je     c0109bdf <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109c0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109c0f:	74 18                	je     c0109c29 <strncmp+0x4f>
c0109c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c14:	0f b6 00             	movzbl (%eax),%eax
c0109c17:	0f b6 d0             	movzbl %al,%edx
c0109c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c1d:	0f b6 00             	movzbl (%eax),%eax
c0109c20:	0f b6 c0             	movzbl %al,%eax
c0109c23:	29 c2                	sub    %eax,%edx
c0109c25:	89 d0                	mov    %edx,%eax
c0109c27:	eb 05                	jmp    c0109c2e <strncmp+0x54>
c0109c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109c2e:	5d                   	pop    %ebp
c0109c2f:	c3                   	ret    

c0109c30 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109c30:	55                   	push   %ebp
c0109c31:	89 e5                	mov    %esp,%ebp
c0109c33:	83 ec 04             	sub    $0x4,%esp
c0109c36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c39:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109c3c:	eb 14                	jmp    c0109c52 <strchr+0x22>
        if (*s == c) {
c0109c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c41:	0f b6 00             	movzbl (%eax),%eax
c0109c44:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109c47:	75 05                	jne    c0109c4e <strchr+0x1e>
            return (char *)s;
c0109c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c4c:	eb 13                	jmp    c0109c61 <strchr+0x31>
        }
        s ++;
c0109c4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c55:	0f b6 00             	movzbl (%eax),%eax
c0109c58:	84 c0                	test   %al,%al
c0109c5a:	75 e2                	jne    c0109c3e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0109c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109c61:	c9                   	leave  
c0109c62:	c3                   	ret    

c0109c63 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109c63:	55                   	push   %ebp
c0109c64:	89 e5                	mov    %esp,%ebp
c0109c66:	83 ec 04             	sub    $0x4,%esp
c0109c69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109c6f:	eb 11                	jmp    c0109c82 <strfind+0x1f>
        if (*s == c) {
c0109c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c74:	0f b6 00             	movzbl (%eax),%eax
c0109c77:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109c7a:	75 02                	jne    c0109c7e <strfind+0x1b>
            break;
c0109c7c:	eb 0e                	jmp    c0109c8c <strfind+0x29>
        }
        s ++;
c0109c7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c85:	0f b6 00             	movzbl (%eax),%eax
c0109c88:	84 c0                	test   %al,%al
c0109c8a:	75 e5                	jne    c0109c71 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0109c8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109c8f:	c9                   	leave  
c0109c90:	c3                   	ret    

c0109c91 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109c91:	55                   	push   %ebp
c0109c92:	89 e5                	mov    %esp,%ebp
c0109c94:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109c97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109c9e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109ca5:	eb 04                	jmp    c0109cab <strtol+0x1a>
        s ++;
c0109ca7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cae:	0f b6 00             	movzbl (%eax),%eax
c0109cb1:	3c 20                	cmp    $0x20,%al
c0109cb3:	74 f2                	je     c0109ca7 <strtol+0x16>
c0109cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cb8:	0f b6 00             	movzbl (%eax),%eax
c0109cbb:	3c 09                	cmp    $0x9,%al
c0109cbd:	74 e8                	je     c0109ca7 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cc2:	0f b6 00             	movzbl (%eax),%eax
c0109cc5:	3c 2b                	cmp    $0x2b,%al
c0109cc7:	75 06                	jne    c0109ccf <strtol+0x3e>
        s ++;
c0109cc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109ccd:	eb 15                	jmp    c0109ce4 <strtol+0x53>
    }
    else if (*s == '-') {
c0109ccf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cd2:	0f b6 00             	movzbl (%eax),%eax
c0109cd5:	3c 2d                	cmp    $0x2d,%al
c0109cd7:	75 0b                	jne    c0109ce4 <strtol+0x53>
        s ++, neg = 1;
c0109cd9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109cdd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109ce4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109ce8:	74 06                	je     c0109cf0 <strtol+0x5f>
c0109cea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109cee:	75 24                	jne    c0109d14 <strtol+0x83>
c0109cf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cf3:	0f b6 00             	movzbl (%eax),%eax
c0109cf6:	3c 30                	cmp    $0x30,%al
c0109cf8:	75 1a                	jne    c0109d14 <strtol+0x83>
c0109cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cfd:	83 c0 01             	add    $0x1,%eax
c0109d00:	0f b6 00             	movzbl (%eax),%eax
c0109d03:	3c 78                	cmp    $0x78,%al
c0109d05:	75 0d                	jne    c0109d14 <strtol+0x83>
        s += 2, base = 16;
c0109d07:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109d0b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109d12:	eb 2a                	jmp    c0109d3e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109d14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109d18:	75 17                	jne    c0109d31 <strtol+0xa0>
c0109d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d1d:	0f b6 00             	movzbl (%eax),%eax
c0109d20:	3c 30                	cmp    $0x30,%al
c0109d22:	75 0d                	jne    c0109d31 <strtol+0xa0>
        s ++, base = 8;
c0109d24:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109d28:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109d2f:	eb 0d                	jmp    c0109d3e <strtol+0xad>
    }
    else if (base == 0) {
c0109d31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109d35:	75 07                	jne    c0109d3e <strtol+0xad>
        base = 10;
c0109d37:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d41:	0f b6 00             	movzbl (%eax),%eax
c0109d44:	3c 2f                	cmp    $0x2f,%al
c0109d46:	7e 1b                	jle    c0109d63 <strtol+0xd2>
c0109d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d4b:	0f b6 00             	movzbl (%eax),%eax
c0109d4e:	3c 39                	cmp    $0x39,%al
c0109d50:	7f 11                	jg     c0109d63 <strtol+0xd2>
            dig = *s - '0';
c0109d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d55:	0f b6 00             	movzbl (%eax),%eax
c0109d58:	0f be c0             	movsbl %al,%eax
c0109d5b:	83 e8 30             	sub    $0x30,%eax
c0109d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109d61:	eb 48                	jmp    c0109dab <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d66:	0f b6 00             	movzbl (%eax),%eax
c0109d69:	3c 60                	cmp    $0x60,%al
c0109d6b:	7e 1b                	jle    c0109d88 <strtol+0xf7>
c0109d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d70:	0f b6 00             	movzbl (%eax),%eax
c0109d73:	3c 7a                	cmp    $0x7a,%al
c0109d75:	7f 11                	jg     c0109d88 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d7a:	0f b6 00             	movzbl (%eax),%eax
c0109d7d:	0f be c0             	movsbl %al,%eax
c0109d80:	83 e8 57             	sub    $0x57,%eax
c0109d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109d86:	eb 23                	jmp    c0109dab <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d8b:	0f b6 00             	movzbl (%eax),%eax
c0109d8e:	3c 40                	cmp    $0x40,%al
c0109d90:	7e 3d                	jle    c0109dcf <strtol+0x13e>
c0109d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d95:	0f b6 00             	movzbl (%eax),%eax
c0109d98:	3c 5a                	cmp    $0x5a,%al
c0109d9a:	7f 33                	jg     c0109dcf <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d9f:	0f b6 00             	movzbl (%eax),%eax
c0109da2:	0f be c0             	movsbl %al,%eax
c0109da5:	83 e8 37             	sub    $0x37,%eax
c0109da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dae:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109db1:	7c 02                	jl     c0109db5 <strtol+0x124>
            break;
c0109db3:	eb 1a                	jmp    c0109dcf <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109db5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109dbc:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109dc0:	89 c2                	mov    %eax,%edx
c0109dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dc5:	01 d0                	add    %edx,%eax
c0109dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109dca:	e9 6f ff ff ff       	jmp    c0109d3e <strtol+0xad>

    if (endptr) {
c0109dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109dd3:	74 08                	je     c0109ddd <strtol+0x14c>
        *endptr = (char *) s;
c0109dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109dd8:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ddb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109de1:	74 07                	je     c0109dea <strtol+0x159>
c0109de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109de6:	f7 d8                	neg    %eax
c0109de8:	eb 03                	jmp    c0109ded <strtol+0x15c>
c0109dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109ded:	c9                   	leave  
c0109dee:	c3                   	ret    

c0109def <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109def:	55                   	push   %ebp
c0109df0:	89 e5                	mov    %esp,%ebp
c0109df2:	57                   	push   %edi
c0109df3:	83 ec 24             	sub    $0x24,%esp
c0109df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109df9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109dfc:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109e00:	8b 55 08             	mov    0x8(%ebp),%edx
c0109e03:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109e06:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109e09:	8b 45 10             	mov    0x10(%ebp),%eax
c0109e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109e0f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109e12:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109e16:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109e19:	89 d7                	mov    %edx,%edi
c0109e1b:	f3 aa                	rep stos %al,%es:(%edi)
c0109e1d:	89 fa                	mov    %edi,%edx
c0109e1f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109e22:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109e28:	83 c4 24             	add    $0x24,%esp
c0109e2b:	5f                   	pop    %edi
c0109e2c:	5d                   	pop    %ebp
c0109e2d:	c3                   	ret    

c0109e2e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109e2e:	55                   	push   %ebp
c0109e2f:	89 e5                	mov    %esp,%ebp
c0109e31:	57                   	push   %edi
c0109e32:	56                   	push   %esi
c0109e33:	53                   	push   %ebx
c0109e34:	83 ec 30             	sub    $0x30,%esp
c0109e37:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109e43:	8b 45 10             	mov    0x10(%ebp),%eax
c0109e46:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e4c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109e4f:	73 42                	jae    c0109e93 <memmove+0x65>
c0109e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e60:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109e66:	c1 e8 02             	shr    $0x2,%eax
c0109e69:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109e71:	89 d7                	mov    %edx,%edi
c0109e73:	89 c6                	mov    %eax,%esi
c0109e75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109e77:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109e7a:	83 e1 03             	and    $0x3,%ecx
c0109e7d:	74 02                	je     c0109e81 <memmove+0x53>
c0109e7f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109e81:	89 f0                	mov    %esi,%eax
c0109e83:	89 fa                	mov    %edi,%edx
c0109e85:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109e88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109e8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109e91:	eb 36                	jmp    c0109ec9 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e96:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e9c:	01 c2                	add    %eax,%edx
c0109e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ea1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ea7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ead:	89 c1                	mov    %eax,%ecx
c0109eaf:	89 d8                	mov    %ebx,%eax
c0109eb1:	89 d6                	mov    %edx,%esi
c0109eb3:	89 c7                	mov    %eax,%edi
c0109eb5:	fd                   	std    
c0109eb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109eb8:	fc                   	cld    
c0109eb9:	89 f8                	mov    %edi,%eax
c0109ebb:	89 f2                	mov    %esi,%edx
c0109ebd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109ec0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109ec3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109ec9:	83 c4 30             	add    $0x30,%esp
c0109ecc:	5b                   	pop    %ebx
c0109ecd:	5e                   	pop    %esi
c0109ece:	5f                   	pop    %edi
c0109ecf:	5d                   	pop    %ebp
c0109ed0:	c3                   	ret    

c0109ed1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109ed1:	55                   	push   %ebp
c0109ed2:	89 e5                	mov    %esp,%ebp
c0109ed4:	57                   	push   %edi
c0109ed5:	56                   	push   %esi
c0109ed6:	83 ec 20             	sub    $0x20,%esp
c0109ed9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109edf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ee5:	8b 45 10             	mov    0x10(%ebp),%eax
c0109ee8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109eee:	c1 e8 02             	shr    $0x2,%eax
c0109ef1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ef9:	89 d7                	mov    %edx,%edi
c0109efb:	89 c6                	mov    %eax,%esi
c0109efd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109eff:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109f02:	83 e1 03             	and    $0x3,%ecx
c0109f05:	74 02                	je     c0109f09 <memcpy+0x38>
c0109f07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109f09:	89 f0                	mov    %esi,%eax
c0109f0b:	89 fa                	mov    %edi,%edx
c0109f0d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109f10:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109f13:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109f19:	83 c4 20             	add    $0x20,%esp
c0109f1c:	5e                   	pop    %esi
c0109f1d:	5f                   	pop    %edi
c0109f1e:	5d                   	pop    %ebp
c0109f1f:	c3                   	ret    

c0109f20 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109f20:	55                   	push   %ebp
c0109f21:	89 e5                	mov    %esp,%ebp
c0109f23:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109f32:	eb 30                	jmp    c0109f64 <memcmp+0x44>
        if (*s1 != *s2) {
c0109f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109f37:	0f b6 10             	movzbl (%eax),%edx
c0109f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109f3d:	0f b6 00             	movzbl (%eax),%eax
c0109f40:	38 c2                	cmp    %al,%dl
c0109f42:	74 18                	je     c0109f5c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109f47:	0f b6 00             	movzbl (%eax),%eax
c0109f4a:	0f b6 d0             	movzbl %al,%edx
c0109f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109f50:	0f b6 00             	movzbl (%eax),%eax
c0109f53:	0f b6 c0             	movzbl %al,%eax
c0109f56:	29 c2                	sub    %eax,%edx
c0109f58:	89 d0                	mov    %edx,%eax
c0109f5a:	eb 1a                	jmp    c0109f76 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109f5c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109f60:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109f64:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f67:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109f6a:	89 55 10             	mov    %edx,0x10(%ebp)
c0109f6d:	85 c0                	test   %eax,%eax
c0109f6f:	75 c3                	jne    c0109f34 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109f76:	c9                   	leave  
c0109f77:	c3                   	ret    
