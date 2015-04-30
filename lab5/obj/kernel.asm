
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 12 00 	lgdtl  0x12a018
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
c010001e:	bc 00 a0 12 c0       	mov    $0xc012a000,%esp
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
c0100030:	ba b8 f0 19 c0       	mov    $0xc019f0b8,%edx
c0100035:	b8 2a bf 19 c0       	mov    $0xc019bf2a,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 2a bf 19 c0 	movl   $0xc019bf2a,(%esp)
c0100051:	e8 77 bd 00 00       	call   c010bdcd <memset>

    cons_init();                // init the console
c0100056:	e8 7a 16 00 00       	call   c01016d5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 60 bf 10 c0 	movl   $0xc010bf60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 7c bf 10 c0 	movl   $0xc010bf7c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 05 09 00 00       	call   c010097f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 01 58 00 00       	call   c0105885 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 2a 20 00 00       	call   c01020b3 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 a2 21 00 00       	call   c0102230 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 f7 86 00 00       	call   c010878a <vmm_init>
    proc_init();                // init process table
c0100093:	e8 f8 ac 00 00       	call   c010ad90 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 69 17 00 00       	call   c0101806 <ide_init>
    swap_init();                // init swap
c010009d:	e8 96 6e 00 00       	call   c0106f38 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 e4 0d 00 00       	call   c0100e8b <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 75 1f 00 00       	call   c0102021 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 9e ae 00 00       	call   c010af4f <cpu_idle>

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
c01000ce:	e8 ea 0c 00 00       	call   c0100dbd <mon_backtrace>
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
c010015f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 81 bf 10 c0 	movl   $0xc010bf81,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 8f bf 10 c0 	movl   $0xc010bf8f,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 9d bf 10 c0 	movl   $0xc010bf9d,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 ab bf 10 c0 	movl   $0xc010bfab,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 b9 bf 10 c0 	movl   $0xc010bfb9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 40 bf 19 c0       	mov    %eax,0xc019bf40
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
c010021c:	c7 04 24 c8 bf 10 c0 	movl   $0xc010bfc8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 e8 bf 10 c0 	movl   $0xc010bfe8,(%esp)
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
c010025d:	c7 04 24 07 c0 10 c0 	movl   $0xc010c007,(%esp)
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
c01002ab:	88 90 60 bf 19 c0    	mov    %dl,-0x3fe640a0(%eax)
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
c01002ea:	05 60 bf 19 c0       	add    $0xc019bf60,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 60 bf 19 c0       	mov    $0xc019bf60,%eax
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
c010030c:	e8 f0 13 00 00       	call   c0101701 <cons_putc>
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
c0100349:	e8 c0 b1 00 00       	call   c010b50e <vprintfmt>
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
c0100385:	e8 77 13 00 00       	call   c0101701 <cons_putc>
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
c01003e1:	e8 57 13 00 00       	call   c010173d <cons_getc>
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
c0100553:	c7 00 0c c0 10 c0    	movl   $0xc010c00c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 0c c0 10 c0 	movl   $0xc010c00c,0x8(%eax)
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

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058a:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100591:	76 21                	jbe    c01005b4 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100593:	c7 45 f4 20 e7 10 c0 	movl   $0xc010e720,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059a:	c7 45 f0 9c 2a 12 c0 	movl   $0xc0122a9c,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a1:	c7 45 ec 9d 2a 12 c0 	movl   $0xc0122a9d,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005a8:	c7 45 e8 92 77 12 c0 	movl   $0xc0127792,-0x18(%ebp)
c01005af:	e9 ea 00 00 00       	jmp    c010069e <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b4:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005bb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c0:	85 c0                	test   %eax,%eax
c01005c2:	74 11                	je     c01005d5 <debuginfo_eip+0x8b>
c01005c4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c9:	8b 40 18             	mov    0x18(%eax),%eax
c01005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d3:	75 0a                	jne    c01005df <debuginfo_eip+0x95>
            return -1;
c01005d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005da:	e9 9e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005e9:	00 
c01005ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f1:	00 
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 c1 8a 00 00       	call   c01090c2 <user_mem_check>
c0100601:	85 c0                	test   %eax,%eax
c0100603:	75 0a                	jne    c010060f <debuginfo_eip+0xc5>
            return -1;
c0100605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060a:	e9 6e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	8b 40 04             	mov    0x4(%eax),%eax
c010061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100623:	8b 40 08             	mov    0x8(%eax),%eax
c0100626:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c0100629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062c:	8b 40 0c             	mov    0xc(%eax),%eax
c010062f:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100638:	29 c2                	sub    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100644:	00 
c0100645:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100650:	89 04 24             	mov    %eax,(%esp)
c0100653:	e8 6a 8a 00 00       	call   c01090c2 <user_mem_check>
c0100658:	85 c0                	test   %eax,%eax
c010065a:	75 0a                	jne    c0100666 <debuginfo_eip+0x11c>
            return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 17 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c0100666:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066c:	29 c2                	sub    %eax,%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010067c:	00 
c010067d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100688:	89 04 24             	mov    %eax,(%esp)
c010068b:	e8 32 8a 00 00       	call   c01090c2 <user_mem_check>
c0100690:	85 c0                	test   %eax,%eax
c0100692:	75 0a                	jne    c010069e <debuginfo_eip+0x154>
            return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 df 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a4:	76 0d                	jbe    c01006b3 <debuginfo_eip+0x169>
c01006a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a9:	83 e8 01             	sub    $0x1,%eax
c01006ac:	0f b6 00             	movzbl (%eax),%eax
c01006af:	84 c0                	test   %al,%al
c01006b1:	74 0a                	je     c01006bd <debuginfo_eip+0x173>
        return -1;
c01006b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b8:	e9 c0 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ca:	29 c2                	sub    %eax,%edx
c01006cc:	89 d0                	mov    %edx,%eax
c01006ce:	c1 f8 02             	sar    $0x2,%eax
c01006d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006d7:	83 e8 01             	sub    $0x1,%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ef fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c0100705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100708:	85 c0                	test   %eax,%eax
c010070a:	75 0a                	jne    c0100716 <debuginfo_eip+0x1cc>
        return -1;
c010070c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100711:	e9 67 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100716:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010071c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010071f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100722:	8b 45 08             	mov    0x8(%ebp),%eax
c0100725:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100729:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100730:	00 
c0100731:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100734:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100738:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010073b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100742:	89 04 24             	mov    %eax,(%esp)
c0100745:	e8 aa fc ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c010074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100750:	39 c2                	cmp    %eax,%edx
c0100752:	7f 7c                	jg     c01007d0 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	89 d0                	mov    %edx,%eax
c010075b:	01 c0                	add    %eax,%eax
c010075d:	01 d0                	add    %edx,%eax
c010075f:	c1 e0 02             	shl    $0x2,%eax
c0100762:	89 c2                	mov    %eax,%edx
c0100764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	8b 10                	mov    (%eax),%edx
c010076b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100771:	29 c1                	sub    %eax,%ecx
c0100773:	89 c8                	mov    %ecx,%eax
c0100775:	39 c2                	cmp    %eax,%edx
c0100777:	73 22                	jae    c010079b <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077c:	89 c2                	mov    %eax,%edx
c010077e:	89 d0                	mov    %edx,%eax
c0100780:	01 c0                	add    %eax,%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	c1 e0 02             	shl    $0x2,%eax
c0100787:	89 c2                	mov    %eax,%edx
c0100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078c:	01 d0                	add    %edx,%eax
c010078e:	8b 10                	mov    (%eax),%edx
c0100790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100793:	01 c2                	add    %eax,%edx
c0100795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100798:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	8b 50 08             	mov    0x8(%eax),%edx
c01007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bc:	8b 40 10             	mov    0x10(%eax),%eax
c01007bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007ce:	eb 15                	jmp    c01007e5 <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e8:	8b 40 08             	mov    0x8(%eax),%eax
c01007eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f2:	00 
c01007f3:	89 04 24             	mov    %eax,(%esp)
c01007f6:	e8 46 b4 00 00       	call   c010bc41 <strfind>
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	29 c2                	sub    %eax,%edx
c0100805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100808:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100812:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100819:	00 
c010081a:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100821:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082b:	89 04 24             	mov    %eax,(%esp)
c010082e:	e8 c1 fb ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c0100833:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100836:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100839:	39 c2                	cmp    %eax,%edx
c010083b:	7f 24                	jg     c0100861 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c010083d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	89 d0                	mov    %edx,%eax
c0100844:	01 c0                	add    %eax,%eax
c0100846:	01 d0                	add    %edx,%eax
c0100848:	c1 e0 02             	shl    $0x2,%eax
c010084b:	89 c2                	mov    %eax,%edx
c010084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100850:	01 d0                	add    %edx,%eax
c0100852:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100856:	0f b7 d0             	movzwl %ax,%edx
c0100859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010085c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085f:	eb 13                	jmp    c0100874 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100866:	e9 12 01 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010086b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010086e:	83 e8 01             	sub    $0x1,%eax
c0100871:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100874:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087a:	39 c2                	cmp    %eax,%edx
c010087c:	7c 56                	jl     c01008d4 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c010087e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	89 d0                	mov    %edx,%eax
c0100885:	01 c0                	add    %eax,%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	c1 e0 02             	shl    $0x2,%eax
c010088c:	89 c2                	mov    %eax,%edx
c010088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100891:	01 d0                	add    %edx,%eax
c0100893:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100897:	3c 84                	cmp    $0x84,%al
c0100899:	74 39                	je     c01008d4 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010089b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b4:	3c 64                	cmp    $0x64,%al
c01008b6:	75 b3                	jne    c010086b <debuginfo_eip+0x321>
c01008b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008bb:	89 c2                	mov    %eax,%edx
c01008bd:	89 d0                	mov    %edx,%eax
c01008bf:	01 c0                	add    %eax,%eax
c01008c1:	01 d0                	add    %edx,%eax
c01008c3:	c1 e0 02             	shl    $0x2,%eax
c01008c6:	89 c2                	mov    %eax,%edx
c01008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cb:	01 d0                	add    %edx,%eax
c01008cd:	8b 40 08             	mov    0x8(%eax),%eax
c01008d0:	85 c0                	test   %eax,%eax
c01008d2:	74 97                	je     c010086b <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008da:	39 c2                	cmp    %eax,%edx
c01008dc:	7c 46                	jl     c0100924 <debuginfo_eip+0x3da>
c01008de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e1:	89 c2                	mov    %eax,%edx
c01008e3:	89 d0                	mov    %edx,%eax
c01008e5:	01 c0                	add    %eax,%eax
c01008e7:	01 d0                	add    %edx,%eax
c01008e9:	c1 e0 02             	shl    $0x2,%eax
c01008ec:	89 c2                	mov    %eax,%edx
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f1:	01 d0                	add    %edx,%eax
c01008f3:	8b 10                	mov    (%eax),%edx
c01008f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008fb:	29 c1                	sub    %eax,%ecx
c01008fd:	89 c8                	mov    %ecx,%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	73 21                	jae    c0100924 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100903:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091d:	01 c2                	add    %eax,%edx
c010091f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100922:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 4a                	jge    c0100978 <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 c0 01             	add    $0x1,%eax
c0100934:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100937:	eb 18                	jmp    c0100951 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100948:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010094b:	83 c0 01             	add    $0x1,%eax
c010094e:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100951:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100954:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100957:	39 c2                	cmp    %eax,%edx
c0100959:	7d 1d                	jge    c0100978 <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010095e:	89 c2                	mov    %eax,%edx
c0100960:	89 d0                	mov    %edx,%eax
c0100962:	01 c0                	add    %eax,%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	c1 e0 02             	shl    $0x2,%eax
c0100969:	89 c2                	mov    %eax,%edx
c010096b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096e:	01 d0                	add    %edx,%eax
c0100970:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100974:	3c a0                	cmp    $0xa0,%al
c0100976:	74 c1                	je     c0100939 <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097d:	c9                   	leave  
c010097e:	c3                   	ret    

c010097f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097f:	55                   	push   %ebp
c0100980:	89 e5                	mov    %esp,%ebp
c0100982:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100985:	c7 04 24 16 c0 10 c0 	movl   $0xc010c016,(%esp)
c010098c:	e8 c2 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100991:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100998:	c0 
c0100999:	c7 04 24 2f c0 10 c0 	movl   $0xc010c02f,(%esp)
c01009a0:	e8 ae f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a5:	c7 44 24 04 56 bf 10 	movl   $0xc010bf56,0x4(%esp)
c01009ac:	c0 
c01009ad:	c7 04 24 47 c0 10 c0 	movl   $0xc010c047,(%esp)
c01009b4:	e8 9a f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009b9:	c7 44 24 04 2a bf 19 	movl   $0xc019bf2a,0x4(%esp)
c01009c0:	c0 
c01009c1:	c7 04 24 5f c0 10 c0 	movl   $0xc010c05f,(%esp)
c01009c8:	e8 86 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cd:	c7 44 24 04 b8 f0 19 	movl   $0xc019f0b8,0x4(%esp)
c01009d4:	c0 
c01009d5:	c7 04 24 77 c0 10 c0 	movl   $0xc010c077,(%esp)
c01009dc:	e8 72 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e1:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c01009e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f1:	29 c2                	sub    %eax,%edx
c01009f3:	89 d0                	mov    %edx,%eax
c01009f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009fb:	85 c0                	test   %eax,%eax
c01009fd:	0f 48 c2             	cmovs  %edx,%eax
c0100a00:	c1 f8 0a             	sar    $0xa,%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 90 c0 10 c0 	movl   $0xc010c090,(%esp)
c0100a0e:	e8 40 f9 ff ff       	call   c0100353 <cprintf>
}
c0100a13:	c9                   	leave  
c0100a14:	c3                   	ret    

c0100a15 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a15:	55                   	push   %ebp
c0100a16:	89 e5                	mov    %esp,%ebp
c0100a18:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a28:	89 04 24             	mov    %eax,(%esp)
c0100a2b:	e8 1a fb ff ff       	call   c010054a <debuginfo_eip>
c0100a30:	85 c0                	test   %eax,%eax
c0100a32:	74 15                	je     c0100a49 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 ba c0 10 c0 	movl   $0xc010c0ba,(%esp)
c0100a42:	e8 0c f9 ff ff       	call   c0100353 <cprintf>
c0100a47:	eb 6d                	jmp    c0100ab6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a50:	eb 1c                	jmp    c0100a6e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a66:	01 ca                	add    %ecx,%edx
c0100a68:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a74:	7f dc                	jg     c0100a52 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a76:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7f:	01 d0                	add    %edx,%eax
c0100a81:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8a:	89 d1                	mov    %edx,%ecx
c0100a8c:	29 c1                	sub    %eax,%ecx
c0100a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a94:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 d6 c0 10 c0 	movl   $0xc010c0d6,(%esp)
c0100ab1:	e8 9d f8 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100ab6:	c9                   	leave  
c0100ab7:	c3                   	ret    

c0100ab8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ab8:	55                   	push   %ebp
c0100ab9:	89 e5                	mov    %esp,%ebp
c0100abb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100abe:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100acf:	89 e8                	mov    %ebp,%eax
c0100ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c0100ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c0100ada:	e8 d9 ff ff ff       	call   c0100ab8 <read_eip>
c0100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c0100ae2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ae9:	e9 88 00 00 00       	jmp    c0100b76 <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afc:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0100b03:	e8 4b f8 ff ff       	call   c0100353 <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	83 c0 02             	add    $0x2,%eax
c0100b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
c0100b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b18:	eb 25                	jmp    c0100b3f <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b27:	01 d0                	add    %edx,%eax
c0100b29:	8b 00                	mov    (%eax),%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 04 c1 10 c0 	movl   $0xc010c104,(%esp)
c0100b36:	e8 18 f8 ff ff       	call   c0100353 <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
c0100b3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b43:	7e d5                	jle    c0100b1a <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100b45:	c7 04 24 0c c1 10 c0 	movl   $0xc010c10c,(%esp)
c0100b4c:	e8 02 f8 ff ff       	call   c0100353 <cprintf>
		print_debuginfo(eip - 1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	83 e8 01             	sub    $0x1,%eax
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 b6 fe ff ff       	call   c0100a15 <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	83 c0 04             	add    $0x4,%eax
c0100b65:	8b 00                	mov    (%eax),%eax
c0100b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
c0100b72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b7a:	0f 8e 6e ff ff ff    	jle    c0100aee <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
c0100b80:	c9                   	leave  
c0100b81:	c3                   	ret    

c0100b82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b82:	55                   	push   %ebp
c0100b83:	89 e5                	mov    %esp,%ebp
c0100b85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b8f:	eb 0c                	jmp    c0100b9d <parse+0x1b>
            *buf ++ = '\0';
c0100b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b94:	8d 50 01             	lea    0x1(%eax),%edx
c0100b97:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba0:	0f b6 00             	movzbl (%eax),%eax
c0100ba3:	84 c0                	test   %al,%al
c0100ba5:	74 1d                	je     c0100bc4 <parse+0x42>
c0100ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100baa:	0f b6 00             	movzbl (%eax),%eax
c0100bad:	0f be c0             	movsbl %al,%eax
c0100bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb4:	c7 04 24 90 c1 10 c0 	movl   $0xc010c190,(%esp)
c0100bbb:	e8 4e b0 00 00       	call   c010bc0e <strchr>
c0100bc0:	85 c0                	test   %eax,%eax
c0100bc2:	75 cd                	jne    c0100b91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc7:	0f b6 00             	movzbl (%eax),%eax
c0100bca:	84 c0                	test   %al,%al
c0100bcc:	75 02                	jne    c0100bd0 <parse+0x4e>
            break;
c0100bce:	eb 67                	jmp    c0100c37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bd4:	75 14                	jne    c0100bea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bd6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bdd:	00 
c0100bde:	c7 04 24 95 c1 10 c0 	movl   $0xc010c195,(%esp)
c0100be5:	e8 69 f7 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bed:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bfd:	01 c2                	add    %eax,%edx
c0100bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c04:	eb 04                	jmp    c0100c0a <parse+0x88>
            buf ++;
c0100c06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0d:	0f b6 00             	movzbl (%eax),%eax
c0100c10:	84 c0                	test   %al,%al
c0100c12:	74 1d                	je     c0100c31 <parse+0xaf>
c0100c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c17:	0f b6 00             	movzbl (%eax),%eax
c0100c1a:	0f be c0             	movsbl %al,%eax
c0100c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c21:	c7 04 24 90 c1 10 c0 	movl   $0xc010c190,(%esp)
c0100c28:	e8 e1 af 00 00       	call   c010bc0e <strchr>
c0100c2d:	85 c0                	test   %eax,%eax
c0100c2f:	74 d5                	je     c0100c06 <parse+0x84>
            buf ++;
        }
    }
c0100c31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c32:	e9 66 ff ff ff       	jmp    c0100b9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c3a:	c9                   	leave  
c0100c3b:	c3                   	ret    

c0100c3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c3c:	55                   	push   %ebp
c0100c3d:	89 e5                	mov    %esp,%ebp
c0100c3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c42:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4c:	89 04 24             	mov    %eax,(%esp)
c0100c4f:	e8 2e ff ff ff       	call   c0100b82 <parse>
c0100c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c5b:	75 0a                	jne    c0100c67 <runcmd+0x2b>
        return 0;
c0100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c62:	e9 85 00 00 00       	jmp    c0100cec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6e:	eb 5c                	jmp    c0100ccc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c76:	89 d0                	mov    %edx,%eax
c0100c78:	01 c0                	add    %eax,%eax
c0100c7a:	01 d0                	add    %edx,%eax
c0100c7c:	c1 e0 02             	shl    $0x2,%eax
c0100c7f:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c84:	8b 00                	mov    (%eax),%eax
c0100c86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c8a:	89 04 24             	mov    %eax,(%esp)
c0100c8d:	e8 dd ae 00 00       	call   c010bb6f <strcmp>
c0100c92:	85 c0                	test   %eax,%eax
c0100c94:	75 32                	jne    c0100cc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c99:	89 d0                	mov    %edx,%eax
c0100c9b:	01 c0                	add    %eax,%eax
c0100c9d:	01 d0                	add    %edx,%eax
c0100c9f:	c1 e0 02             	shl    $0x2,%eax
c0100ca2:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100ca7:	8b 40 08             	mov    0x8(%eax),%eax
c0100caa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cad:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cb3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cba:	83 c2 04             	add    $0x4,%edx
c0100cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100cc1:	89 0c 24             	mov    %ecx,(%esp)
c0100cc4:	ff d0                	call   *%eax
c0100cc6:	eb 24                	jmp    c0100cec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ccf:	83 f8 02             	cmp    $0x2,%eax
c0100cd2:	76 9c                	jbe    c0100c70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cdb:	c7 04 24 b3 c1 10 c0 	movl   $0xc010c1b3,(%esp)
c0100ce2:	e8 6c f6 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cec:	c9                   	leave  
c0100ced:	c3                   	ret    

c0100cee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cee:	55                   	push   %ebp
c0100cef:	89 e5                	mov    %esp,%ebp
c0100cf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cf4:	c7 04 24 cc c1 10 c0 	movl   $0xc010c1cc,(%esp)
c0100cfb:	e8 53 f6 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d00:	c7 04 24 f4 c1 10 c0 	movl   $0xc010c1f4,(%esp)
c0100d07:	e8 47 f6 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100d0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d10:	74 0b                	je     c0100d1d <kmonitor+0x2f>
        print_trapframe(tf);
c0100d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d15:	89 04 24             	mov    %eax,(%esp)
c0100d18:	e8 64 18 00 00       	call   c0102581 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d1d:	c7 04 24 19 c2 10 c0 	movl   $0xc010c219,(%esp)
c0100d24:	e8 21 f5 ff ff       	call   c010024a <readline>
c0100d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d30:	74 18                	je     c0100d4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d3c:	89 04 24             	mov    %eax,(%esp)
c0100d3f:	e8 f8 fe ff ff       	call   c0100c3c <runcmd>
c0100d44:	85 c0                	test   %eax,%eax
c0100d46:	79 02                	jns    c0100d4a <kmonitor+0x5c>
                break;
c0100d48:	eb 02                	jmp    c0100d4c <kmonitor+0x5e>
            }
        }
    }
c0100d4a:	eb d1                	jmp    c0100d1d <kmonitor+0x2f>
}
c0100d4c:	c9                   	leave  
c0100d4d:	c3                   	ret    

c0100d4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d4e:	55                   	push   %ebp
c0100d4f:	89 e5                	mov    %esp,%ebp
c0100d51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d5b:	eb 3f                	jmp    c0100d9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d60:	89 d0                	mov    %edx,%eax
c0100d62:	01 c0                	add    %eax,%eax
c0100d64:	01 d0                	add    %edx,%eax
c0100d66:	c1 e0 02             	shl    $0x2,%eax
c0100d69:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d6e:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d74:	89 d0                	mov    %edx,%eax
c0100d76:	01 c0                	add    %eax,%eax
c0100d78:	01 d0                	add    %edx,%eax
c0100d7a:	c1 e0 02             	shl    $0x2,%eax
c0100d7d:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d82:	8b 00                	mov    (%eax),%eax
c0100d84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8c:	c7 04 24 1d c2 10 c0 	movl   $0xc010c21d,(%esp)
c0100d93:	e8 bb f5 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d9f:	83 f8 02             	cmp    $0x2,%eax
c0100da2:	76 b9                	jbe    c0100d5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100da9:	c9                   	leave  
c0100daa:	c3                   	ret    

c0100dab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dab:	55                   	push   %ebp
c0100dac:	89 e5                	mov    %esp,%ebp
c0100dae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db1:	e8 c9 fb ff ff       	call   c010097f <print_kerninfo>
    return 0;
c0100db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dbb:	c9                   	leave  
c0100dbc:	c3                   	ret    

c0100dbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dbd:	55                   	push   %ebp
c0100dbe:	89 e5                	mov    %esp,%ebp
c0100dc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc3:	e8 01 fd ff ff       	call   c0100ac9 <print_stackframe>
    return 0;
c0100dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dcd:	c9                   	leave  
c0100dce:	c3                   	ret    

c0100dcf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dcf:	55                   	push   %ebp
c0100dd0:	89 e5                	mov    %esp,%ebp
c0100dd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100dd5:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
c0100dda:	85 c0                	test   %eax,%eax
c0100ddc:	74 02                	je     c0100de0 <__panic+0x11>
        goto panic_dead;
c0100dde:	eb 48                	jmp    c0100e28 <__panic+0x59>
    }
    is_panic = 1;
c0100de0:	c7 05 60 c3 19 c0 01 	movl   $0x1,0xc019c360
c0100de7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100dea:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100df0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100df3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100dfe:	c7 04 24 26 c2 10 c0 	movl   $0xc010c226,(%esp)
c0100e05:	e8 49 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e11:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e14:	89 04 24             	mov    %eax,(%esp)
c0100e17:	e8 04 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e1c:	c7 04 24 42 c2 10 c0 	movl   $0xc010c242,(%esp)
c0100e23:	e8 2b f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e28:	e8 fa 11 00 00       	call   c0102027 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e34:	e8 b5 fe ff ff       	call   c0100cee <kmonitor>
    }
c0100e39:	eb f2                	jmp    c0100e2d <__panic+0x5e>

c0100e3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e3b:	55                   	push   %ebp
c0100e3c:	89 e5                	mov    %esp,%ebp
c0100e3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e41:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e4a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e55:	c7 04 24 44 c2 10 c0 	movl   $0xc010c244,(%esp)
c0100e5c:	e8 f2 f4 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e68:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e6b:	89 04 24             	mov    %eax,(%esp)
c0100e6e:	e8 ad f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e73:	c7 04 24 42 c2 10 c0 	movl   $0xc010c242,(%esp)
c0100e7a:	e8 d4 f4 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e84:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
}
c0100e89:	5d                   	pop    %ebp
c0100e8a:	c3                   	ret    

c0100e8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e8b:	55                   	push   %ebp
c0100e8c:	89 e5                	mov    %esp,%ebp
c0100e8e:	83 ec 28             	sub    $0x28,%esp
c0100e91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ea3:	ee                   	out    %al,(%dx)
c0100ea4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eaa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eb6:	ee                   	out    %al,(%dx)
c0100eb7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ebd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ec1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ec5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ec9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100eca:	c7 05 b4 ef 19 c0 00 	movl   $0x0,0xc019efb4
c0100ed1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ed4:	c7 04 24 62 c2 10 c0 	movl   $0xc010c262,(%esp)
c0100edb:	e8 73 f4 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ee7:	e8 99 11 00 00       	call   c0102085 <pic_enable>
}
c0100eec:	c9                   	leave  
c0100eed:	c3                   	ret    

c0100eee <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100eee:	55                   	push   %ebp
c0100eef:	89 e5                	mov    %esp,%ebp
c0100ef1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100ef4:	9c                   	pushf  
c0100ef5:	58                   	pop    %eax
c0100ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100efc:	25 00 02 00 00       	and    $0x200,%eax
c0100f01:	85 c0                	test   %eax,%eax
c0100f03:	74 0c                	je     c0100f11 <__intr_save+0x23>
        intr_disable();
c0100f05:	e8 1d 11 00 00       	call   c0102027 <intr_disable>
        return 1;
c0100f0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f0f:	eb 05                	jmp    c0100f16 <__intr_save+0x28>
    }
    return 0;
c0100f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f16:	c9                   	leave  
c0100f17:	c3                   	ret    

c0100f18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f18:	55                   	push   %ebp
c0100f19:	89 e5                	mov    %esp,%ebp
c0100f1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f22:	74 05                	je     c0100f29 <__intr_restore+0x11>
        intr_enable();
c0100f24:	e8 f8 10 00 00       	call   c0102021 <intr_enable>
    }
}
c0100f29:	c9                   	leave  
c0100f2a:	c3                   	ret    

c0100f2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f2b:	55                   	push   %ebp
c0100f2c:	89 e5                	mov    %esp,%ebp
c0100f2e:	83 ec 10             	sub    $0x10,%esp
c0100f31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f3b:	89 c2                	mov    %eax,%edx
c0100f3d:	ec                   	in     (%dx),%al
c0100f3e:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f4b:	89 c2                	mov    %eax,%edx
c0100f4d:	ec                   	in     (%dx),%al
c0100f4e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f5b:	89 c2                	mov    %eax,%edx
c0100f5d:	ec                   	in     (%dx),%al
c0100f5e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f6b:	89 c2                	mov    %eax,%edx
c0100f6d:	ec                   	in     (%dx),%al
c0100f6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f71:	c9                   	leave  
c0100f72:	c3                   	ret    

c0100f73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f73:	55                   	push   %ebp
c0100f74:	89 e5                	mov    %esp,%ebp
c0100f76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f83:	0f b7 00             	movzwl (%eax),%eax
c0100f86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f95:	0f b7 00             	movzwl (%eax),%eax
c0100f98:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100f9c:	74 12                	je     c0100fb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fa5:	66 c7 05 86 c3 19 c0 	movw   $0x3b4,0xc019c386
c0100fac:	b4 03 
c0100fae:	eb 13                	jmp    c0100fc3 <cga_init+0x50>
    } else {
        *cp = was;
c0100fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fba:	66 c7 05 86 c3 19 c0 	movw   $0x3d4,0xc019c386
c0100fc1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fc3:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100fca:	0f b7 c0             	movzwl %ax,%eax
c0100fcd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fd1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fd9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fde:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100fe5:	83 c0 01             	add    $0x1,%eax
c0100fe8:	0f b7 c0             	movzwl %ax,%eax
c0100feb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff3:	89 c2                	mov    %eax,%edx
c0100ff5:	ec                   	in     (%dx),%al
c0100ff6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ff9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ffd:	0f b6 c0             	movzbl %al,%eax
c0101000:	c1 e0 08             	shl    $0x8,%eax
c0101003:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101006:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010100d:	0f b7 c0             	movzwl %ax,%eax
c0101010:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101014:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101018:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010101c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101020:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101021:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101028:	83 c0 01             	add    $0x1,%eax
c010102b:	0f b7 c0             	movzwl %ax,%eax
c010102e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101032:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101036:	89 c2                	mov    %eax,%edx
c0101038:	ec                   	in     (%dx),%al
c0101039:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c010103c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101040:	0f b6 c0             	movzbl %al,%eax
c0101043:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0101046:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101049:	a3 80 c3 19 c0       	mov    %eax,0xc019c380
    crt_pos = pos;
c010104e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101051:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
}
c0101057:	c9                   	leave  
c0101058:	c3                   	ret    

c0101059 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101059:	55                   	push   %ebp
c010105a:	89 e5                	mov    %esp,%ebp
c010105c:	83 ec 48             	sub    $0x48,%esp
c010105f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0101065:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101069:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010106d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101071:	ee                   	out    %al,(%dx)
c0101072:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0101078:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c010107c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101080:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101084:	ee                   	out    %al,(%dx)
c0101085:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c010108b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c010108f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101093:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101097:	ee                   	out    %al,(%dx)
c0101098:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010109e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010a2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010a6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010aa:	ee                   	out    %al,(%dx)
c01010ab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010b1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010bd:	ee                   	out    %al,(%dx)
c01010be:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010c4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010c8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010cc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010d0:	ee                   	out    %al,(%dx)
c01010d1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010d7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010db:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010df:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010e3:	ee                   	out    %al,(%dx)
c01010e4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010ea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010ee:	89 c2                	mov    %eax,%edx
c01010f0:	ec                   	in     (%dx),%al
c01010f1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010f4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010f8:	3c ff                	cmp    $0xff,%al
c01010fa:	0f 95 c0             	setne  %al
c01010fd:	0f b6 c0             	movzbl %al,%eax
c0101100:	a3 88 c3 19 c0       	mov    %eax,0xc019c388
c0101105:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010110b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010110f:	89 c2                	mov    %eax,%edx
c0101111:	ec                   	in     (%dx),%al
c0101112:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101115:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010111b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010111f:	89 c2                	mov    %eax,%edx
c0101121:	ec                   	in     (%dx),%al
c0101122:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101125:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c010112a:	85 c0                	test   %eax,%eax
c010112c:	74 0c                	je     c010113a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010112e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101135:	e8 4b 0f 00 00       	call   c0102085 <pic_enable>
    }
}
c010113a:	c9                   	leave  
c010113b:	c3                   	ret    

c010113c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010113c:	55                   	push   %ebp
c010113d:	89 e5                	mov    %esp,%ebp
c010113f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101149:	eb 09                	jmp    c0101154 <lpt_putc_sub+0x18>
        delay();
c010114b:	e8 db fd ff ff       	call   c0100f2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101150:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101154:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010115a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010115e:	89 c2                	mov    %eax,%edx
c0101160:	ec                   	in     (%dx),%al
c0101161:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101164:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101168:	84 c0                	test   %al,%al
c010116a:	78 09                	js     c0101175 <lpt_putc_sub+0x39>
c010116c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101173:	7e d6                	jle    c010114b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101175:	8b 45 08             	mov    0x8(%ebp),%eax
c0101178:	0f b6 c0             	movzbl %al,%eax
c010117b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101181:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101184:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101188:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010118c:	ee                   	out    %al,(%dx)
c010118d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101193:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101197:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010119b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010119f:	ee                   	out    %al,(%dx)
c01011a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011b3:	c9                   	leave  
c01011b4:	c3                   	ret    

c01011b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011b5:	55                   	push   %ebp
c01011b6:	89 e5                	mov    %esp,%ebp
c01011b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011bf:	74 0d                	je     c01011ce <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c4:	89 04 24             	mov    %eax,(%esp)
c01011c7:	e8 70 ff ff ff       	call   c010113c <lpt_putc_sub>
c01011cc:	eb 24                	jmp    c01011f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011d5:	e8 62 ff ff ff       	call   c010113c <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011e1:	e8 56 ff ff ff       	call   c010113c <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011ed:	e8 4a ff ff ff       	call   c010113c <lpt_putc_sub>
    }
}
c01011f2:	c9                   	leave  
c01011f3:	c3                   	ret    

c01011f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011f4:	55                   	push   %ebp
c01011f5:	89 e5                	mov    %esp,%ebp
c01011f7:	53                   	push   %ebx
c01011f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01011fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01011fe:	b0 00                	mov    $0x0,%al
c0101200:	85 c0                	test   %eax,%eax
c0101202:	75 07                	jne    c010120b <cga_putc+0x17>
        c |= 0x0700;
c0101204:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010120b:	8b 45 08             	mov    0x8(%ebp),%eax
c010120e:	0f b6 c0             	movzbl %al,%eax
c0101211:	83 f8 0a             	cmp    $0xa,%eax
c0101214:	74 4c                	je     c0101262 <cga_putc+0x6e>
c0101216:	83 f8 0d             	cmp    $0xd,%eax
c0101219:	74 57                	je     c0101272 <cga_putc+0x7e>
c010121b:	83 f8 08             	cmp    $0x8,%eax
c010121e:	0f 85 88 00 00 00    	jne    c01012ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101224:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010122b:	66 85 c0             	test   %ax,%ax
c010122e:	74 30                	je     c0101260 <cga_putc+0x6c>
            crt_pos --;
c0101230:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101237:	83 e8 01             	sub    $0x1,%eax
c010123a:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101240:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c0101245:	0f b7 15 84 c3 19 c0 	movzwl 0xc019c384,%edx
c010124c:	0f b7 d2             	movzwl %dx,%edx
c010124f:	01 d2                	add    %edx,%edx
c0101251:	01 c2                	add    %eax,%edx
c0101253:	8b 45 08             	mov    0x8(%ebp),%eax
c0101256:	b0 00                	mov    $0x0,%al
c0101258:	83 c8 20             	or     $0x20,%eax
c010125b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010125e:	eb 72                	jmp    c01012d2 <cga_putc+0xde>
c0101260:	eb 70                	jmp    c01012d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101262:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101269:	83 c0 50             	add    $0x50,%eax
c010126c:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101272:	0f b7 1d 84 c3 19 c0 	movzwl 0xc019c384,%ebx
c0101279:	0f b7 0d 84 c3 19 c0 	movzwl 0xc019c384,%ecx
c0101280:	0f b7 c1             	movzwl %cx,%eax
c0101283:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101289:	c1 e8 10             	shr    $0x10,%eax
c010128c:	89 c2                	mov    %eax,%edx
c010128e:	66 c1 ea 06          	shr    $0x6,%dx
c0101292:	89 d0                	mov    %edx,%eax
c0101294:	c1 e0 02             	shl    $0x2,%eax
c0101297:	01 d0                	add    %edx,%eax
c0101299:	c1 e0 04             	shl    $0x4,%eax
c010129c:	29 c1                	sub    %eax,%ecx
c010129e:	89 ca                	mov    %ecx,%edx
c01012a0:	89 d8                	mov    %ebx,%eax
c01012a2:	29 d0                	sub    %edx,%eax
c01012a4:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
        break;
c01012aa:	eb 26                	jmp    c01012d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012ac:	8b 0d 80 c3 19 c0    	mov    0xc019c380,%ecx
c01012b2:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012b9:	8d 50 01             	lea    0x1(%eax),%edx
c01012bc:	66 89 15 84 c3 19 c0 	mov    %dx,0xc019c384
c01012c3:	0f b7 c0             	movzwl %ax,%eax
c01012c6:	01 c0                	add    %eax,%eax
c01012c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ce:	66 89 02             	mov    %ax,(%edx)
        break;
c01012d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012d2:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012d9:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012dd:	76 5b                	jbe    c010133a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012df:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012ea:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012f6:	00 
c01012f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012fb:	89 04 24             	mov    %eax,(%esp)
c01012fe:	e8 09 ab 00 00       	call   c010be0c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101303:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010130a:	eb 15                	jmp    c0101321 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010130c:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c0101311:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101314:	01 d2                	add    %edx,%edx
c0101316:	01 d0                	add    %edx,%eax
c0101318:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010131d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101321:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101328:	7e e2                	jle    c010130c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010132a:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101331:	83 e8 50             	sub    $0x50,%eax
c0101334:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010133a:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101341:	0f b7 c0             	movzwl %ax,%eax
c0101344:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101348:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010134c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101350:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101354:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101355:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010135c:	66 c1 e8 08          	shr    $0x8,%ax
c0101360:	0f b6 c0             	movzbl %al,%eax
c0101363:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c010136a:	83 c2 01             	add    $0x1,%edx
c010136d:	0f b7 d2             	movzwl %dx,%edx
c0101370:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101374:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101377:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010137b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010137f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101380:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101387:	0f b7 c0             	movzwl %ax,%eax
c010138a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010138e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101392:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101396:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010139a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010139b:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01013a2:	0f b6 c0             	movzbl %al,%eax
c01013a5:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c01013ac:	83 c2 01             	add    $0x1,%edx
c01013af:	0f b7 d2             	movzwl %dx,%edx
c01013b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013c1:	ee                   	out    %al,(%dx)
}
c01013c2:	83 c4 34             	add    $0x34,%esp
c01013c5:	5b                   	pop    %ebx
c01013c6:	5d                   	pop    %ebp
c01013c7:	c3                   	ret    

c01013c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013c8:	55                   	push   %ebp
c01013c9:	89 e5                	mov    %esp,%ebp
c01013cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013d5:	eb 09                	jmp    c01013e0 <serial_putc_sub+0x18>
        delay();
c01013d7:	e8 4f fb ff ff       	call   c0100f2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013ea:	89 c2                	mov    %eax,%edx
c01013ec:	ec                   	in     (%dx),%al
c01013ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013f4:	0f b6 c0             	movzbl %al,%eax
c01013f7:	83 e0 20             	and    $0x20,%eax
c01013fa:	85 c0                	test   %eax,%eax
c01013fc:	75 09                	jne    c0101407 <serial_putc_sub+0x3f>
c01013fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101405:	7e d0                	jle    c01013d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101407:	8b 45 08             	mov    0x8(%ebp),%eax
c010140a:	0f b6 c0             	movzbl %al,%eax
c010140d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101413:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101416:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010141a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010141e:	ee                   	out    %al,(%dx)
}
c010141f:	c9                   	leave  
c0101420:	c3                   	ret    

c0101421 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101421:	55                   	push   %ebp
c0101422:	89 e5                	mov    %esp,%ebp
c0101424:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101427:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010142b:	74 0d                	je     c010143a <serial_putc+0x19>
        serial_putc_sub(c);
c010142d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101430:	89 04 24             	mov    %eax,(%esp)
c0101433:	e8 90 ff ff ff       	call   c01013c8 <serial_putc_sub>
c0101438:	eb 24                	jmp    c010145e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010143a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101441:	e8 82 ff ff ff       	call   c01013c8 <serial_putc_sub>
        serial_putc_sub(' ');
c0101446:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010144d:	e8 76 ff ff ff       	call   c01013c8 <serial_putc_sub>
        serial_putc_sub('\b');
c0101452:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101459:	e8 6a ff ff ff       	call   c01013c8 <serial_putc_sub>
    }
}
c010145e:	c9                   	leave  
c010145f:	c3                   	ret    

c0101460 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101460:	55                   	push   %ebp
c0101461:	89 e5                	mov    %esp,%ebp
c0101463:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101466:	eb 33                	jmp    c010149b <cons_intr+0x3b>
        if (c != 0) {
c0101468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010146c:	74 2d                	je     c010149b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010146e:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101473:	8d 50 01             	lea    0x1(%eax),%edx
c0101476:	89 15 a4 c5 19 c0    	mov    %edx,0xc019c5a4
c010147c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010147f:	88 90 a0 c3 19 c0    	mov    %dl,-0x3fe63c60(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101485:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c010148a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010148f:	75 0a                	jne    c010149b <cons_intr+0x3b>
                cons.wpos = 0;
c0101491:	c7 05 a4 c5 19 c0 00 	movl   $0x0,0xc019c5a4
c0101498:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010149b:	8b 45 08             	mov    0x8(%ebp),%eax
c010149e:	ff d0                	call   *%eax
c01014a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014a7:	75 bf                	jne    c0101468 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014a9:	c9                   	leave  
c01014aa:	c3                   	ret    

c01014ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014ab:	55                   	push   %ebp
c01014ac:	89 e5                	mov    %esp,%ebp
c01014ae:	83 ec 10             	sub    $0x10,%esp
c01014b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014bb:	89 c2                	mov    %eax,%edx
c01014bd:	ec                   	in     (%dx),%al
c01014be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014c5:	0f b6 c0             	movzbl %al,%eax
c01014c8:	83 e0 01             	and    $0x1,%eax
c01014cb:	85 c0                	test   %eax,%eax
c01014cd:	75 07                	jne    c01014d6 <serial_proc_data+0x2b>
        return -1;
c01014cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014d4:	eb 2a                	jmp    c0101500 <serial_proc_data+0x55>
c01014d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014e0:	89 c2                	mov    %eax,%edx
c01014e2:	ec                   	in     (%dx),%al
c01014e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014ea:	0f b6 c0             	movzbl %al,%eax
c01014ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014f4:	75 07                	jne    c01014fd <serial_proc_data+0x52>
        c = '\b';
c01014f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101500:	c9                   	leave  
c0101501:	c3                   	ret    

c0101502 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101502:	55                   	push   %ebp
c0101503:	89 e5                	mov    %esp,%ebp
c0101505:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101508:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c010150d:	85 c0                	test   %eax,%eax
c010150f:	74 0c                	je     c010151d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101511:	c7 04 24 ab 14 10 c0 	movl   $0xc01014ab,(%esp)
c0101518:	e8 43 ff ff ff       	call   c0101460 <cons_intr>
    }
}
c010151d:	c9                   	leave  
c010151e:	c3                   	ret    

c010151f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010151f:	55                   	push   %ebp
c0101520:	89 e5                	mov    %esp,%ebp
c0101522:	83 ec 38             	sub    $0x38,%esp
c0101525:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010152b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010152f:	89 c2                	mov    %eax,%edx
c0101531:	ec                   	in     (%dx),%al
c0101532:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101535:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	83 e0 01             	and    $0x1,%eax
c010153f:	85 c0                	test   %eax,%eax
c0101541:	75 0a                	jne    c010154d <kbd_proc_data+0x2e>
        return -1;
c0101543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101548:	e9 59 01 00 00       	jmp    c01016a6 <kbd_proc_data+0x187>
c010154d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101553:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101557:	89 c2                	mov    %eax,%edx
c0101559:	ec                   	in     (%dx),%al
c010155a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010155d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101561:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101564:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101568:	75 17                	jne    c0101581 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010156a:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010156f:	83 c8 40             	or     $0x40,%eax
c0101572:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c0101577:	b8 00 00 00 00       	mov    $0x0,%eax
c010157c:	e9 25 01 00 00       	jmp    c01016a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101581:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101585:	84 c0                	test   %al,%al
c0101587:	79 47                	jns    c01015d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101589:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010158e:	83 e0 40             	and    $0x40,%eax
c0101591:	85 c0                	test   %eax,%eax
c0101593:	75 09                	jne    c010159e <kbd_proc_data+0x7f>
c0101595:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101599:	83 e0 7f             	and    $0x7f,%eax
c010159c:	eb 04                	jmp    c01015a2 <kbd_proc_data+0x83>
c010159e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a9:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015b0:	83 c8 40             	or     $0x40,%eax
c01015b3:	0f b6 c0             	movzbl %al,%eax
c01015b6:	f7 d0                	not    %eax
c01015b8:	89 c2                	mov    %eax,%edx
c01015ba:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015bf:	21 d0                	and    %edx,%eax
c01015c1:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c01015c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01015cb:	e9 d6 00 00 00       	jmp    c01016a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015d0:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015d5:	83 e0 40             	and    $0x40,%eax
c01015d8:	85 c0                	test   %eax,%eax
c01015da:	74 11                	je     c01015ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015e0:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01015e8:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    }

    shift |= shiftcode[data];
c01015ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f1:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015f8:	0f b6 d0             	movzbl %al,%edx
c01015fb:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101600:	09 d0                	or     %edx,%eax
c0101602:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    shift ^= togglecode[data];
c0101607:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010160b:	0f b6 80 60 a1 12 c0 	movzbl -0x3fed5ea0(%eax),%eax
c0101612:	0f b6 d0             	movzbl %al,%edx
c0101615:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010161a:	31 d0                	xor    %edx,%eax
c010161c:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101621:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101626:	83 e0 03             	and    $0x3,%eax
c0101629:	8b 14 85 60 a5 12 c0 	mov    -0x3fed5aa0(,%eax,4),%edx
c0101630:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101634:	01 d0                	add    %edx,%eax
c0101636:	0f b6 00             	movzbl (%eax),%eax
c0101639:	0f b6 c0             	movzbl %al,%eax
c010163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010163f:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101644:	83 e0 08             	and    $0x8,%eax
c0101647:	85 c0                	test   %eax,%eax
c0101649:	74 22                	je     c010166d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010164b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010164f:	7e 0c                	jle    c010165d <kbd_proc_data+0x13e>
c0101651:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101655:	7f 06                	jg     c010165d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101657:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010165b:	eb 10                	jmp    c010166d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010165d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101661:	7e 0a                	jle    c010166d <kbd_proc_data+0x14e>
c0101663:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101667:	7f 04                	jg     c010166d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101669:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010166d:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101672:	f7 d0                	not    %eax
c0101674:	83 e0 06             	and    $0x6,%eax
c0101677:	85 c0                	test   %eax,%eax
c0101679:	75 28                	jne    c01016a3 <kbd_proc_data+0x184>
c010167b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101682:	75 1f                	jne    c01016a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101684:	c7 04 24 7d c2 10 c0 	movl   $0xc010c27d,(%esp)
c010168b:	e8 c3 ec ff ff       	call   c0100353 <cprintf>
c0101690:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101696:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010169a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010169e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a6:	c9                   	leave  
c01016a7:	c3                   	ret    

c01016a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016a8:	55                   	push   %ebp
c01016a9:	89 e5                	mov    %esp,%ebp
c01016ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016ae:	c7 04 24 1f 15 10 c0 	movl   $0xc010151f,(%esp)
c01016b5:	e8 a6 fd ff ff       	call   c0101460 <cons_intr>
}
c01016ba:	c9                   	leave  
c01016bb:	c3                   	ret    

c01016bc <kbd_init>:

static void
kbd_init(void) {
c01016bc:	55                   	push   %ebp
c01016bd:	89 e5                	mov    %esp,%ebp
c01016bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c2:	e8 e1 ff ff ff       	call   c01016a8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01016c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016ce:	e8 b2 09 00 00       	call   c0102085 <pic_enable>
}
c01016d3:	c9                   	leave  
c01016d4:	c3                   	ret    

c01016d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016d5:	55                   	push   %ebp
c01016d6:	89 e5                	mov    %esp,%ebp
c01016d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016db:	e8 93 f8 ff ff       	call   c0100f73 <cga_init>
    serial_init();
c01016e0:	e8 74 f9 ff ff       	call   c0101059 <serial_init>
    kbd_init();
c01016e5:	e8 d2 ff ff ff       	call   c01016bc <kbd_init>
    if (!serial_exists) {
c01016ea:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c01016ef:	85 c0                	test   %eax,%eax
c01016f1:	75 0c                	jne    c01016ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016f3:	c7 04 24 89 c2 10 c0 	movl   $0xc010c289,(%esp)
c01016fa:	e8 54 ec ff ff       	call   c0100353 <cprintf>
    }
}
c01016ff:	c9                   	leave  
c0101700:	c3                   	ret    

c0101701 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101701:	55                   	push   %ebp
c0101702:	89 e5                	mov    %esp,%ebp
c0101704:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101707:	e8 e2 f7 ff ff       	call   c0100eee <__intr_save>
c010170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010170f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101712:	89 04 24             	mov    %eax,(%esp)
c0101715:	e8 9b fa ff ff       	call   c01011b5 <lpt_putc>
        cga_putc(c);
c010171a:	8b 45 08             	mov    0x8(%ebp),%eax
c010171d:	89 04 24             	mov    %eax,(%esp)
c0101720:	e8 cf fa ff ff       	call   c01011f4 <cga_putc>
        serial_putc(c);
c0101725:	8b 45 08             	mov    0x8(%ebp),%eax
c0101728:	89 04 24             	mov    %eax,(%esp)
c010172b:	e8 f1 fc ff ff       	call   c0101421 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101733:	89 04 24             	mov    %eax,(%esp)
c0101736:	e8 dd f7 ff ff       	call   c0100f18 <__intr_restore>
}
c010173b:	c9                   	leave  
c010173c:	c3                   	ret    

c010173d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010173d:	55                   	push   %ebp
c010173e:	89 e5                	mov    %esp,%ebp
c0101740:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010174a:	e8 9f f7 ff ff       	call   c0100eee <__intr_save>
c010174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101752:	e8 ab fd ff ff       	call   c0101502 <serial_intr>
        kbd_intr();
c0101757:	e8 4c ff ff ff       	call   c01016a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010175c:	8b 15 a0 c5 19 c0    	mov    0xc019c5a0,%edx
c0101762:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101767:	39 c2                	cmp    %eax,%edx
c0101769:	74 31                	je     c010179c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010176b:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101770:	8d 50 01             	lea    0x1(%eax),%edx
c0101773:	89 15 a0 c5 19 c0    	mov    %edx,0xc019c5a0
c0101779:	0f b6 80 a0 c3 19 c0 	movzbl -0x3fe63c60(%eax),%eax
c0101780:	0f b6 c0             	movzbl %al,%eax
c0101783:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101786:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c010178b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101790:	75 0a                	jne    c010179c <cons_getc+0x5f>
                cons.rpos = 0;
c0101792:	c7 05 a0 c5 19 c0 00 	movl   $0x0,0xc019c5a0
c0101799:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010179f:	89 04 24             	mov    %eax,(%esp)
c01017a2:	e8 71 f7 ff ff       	call   c0100f18 <__intr_restore>
    return c;
c01017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017aa:	c9                   	leave  
c01017ab:	c3                   	ret    

c01017ac <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017ac:	55                   	push   %ebp
c01017ad:	89 e5                	mov    %esp,%ebp
c01017af:	83 ec 14             	sub    $0x14,%esp
c01017b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01017b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017b9:	90                   	nop
c01017ba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017be:	83 c0 07             	add    $0x7,%eax
c01017c1:	0f b7 c0             	movzwl %ax,%eax
c01017c4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017c8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017cc:	89 c2                	mov    %eax,%edx
c01017ce:	ec                   	in     (%dx),%al
c01017cf:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017d2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017d6:	0f b6 c0             	movzbl %al,%eax
c01017d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017df:	25 80 00 00 00       	and    $0x80,%eax
c01017e4:	85 c0                	test   %eax,%eax
c01017e6:	75 d2                	jne    c01017ba <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017ec:	74 11                	je     c01017ff <ide_wait_ready+0x53>
c01017ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f1:	83 e0 21             	and    $0x21,%eax
c01017f4:	85 c0                	test   %eax,%eax
c01017f6:	74 07                	je     c01017ff <ide_wait_ready+0x53>
        return -1;
c01017f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01017fd:	eb 05                	jmp    c0101804 <ide_wait_ready+0x58>
    }
    return 0;
c01017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101804:	c9                   	leave  
c0101805:	c3                   	ret    

c0101806 <ide_init>:

void
ide_init(void) {
c0101806:	55                   	push   %ebp
c0101807:	89 e5                	mov    %esp,%ebp
c0101809:	57                   	push   %edi
c010180a:	53                   	push   %ebx
c010180b:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101811:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101817:	e9 d6 02 00 00       	jmp    c0101af2 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010181c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101820:	c1 e0 03             	shl    $0x3,%eax
c0101823:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010182a:	29 c2                	sub    %eax,%edx
c010182c:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101832:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101835:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101839:	66 d1 e8             	shr    %ax
c010183c:	0f b7 c0             	movzwl %ax,%eax
c010183f:	0f b7 04 85 a8 c2 10 	movzwl -0x3fef3d58(,%eax,4),%eax
c0101846:	c0 
c0101847:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c010184b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010184f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101856:	00 
c0101857:	89 04 24             	mov    %eax,(%esp)
c010185a:	e8 4d ff ff ff       	call   c01017ac <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010185f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101863:	83 e0 01             	and    $0x1,%eax
c0101866:	c1 e0 04             	shl    $0x4,%eax
c0101869:	83 c8 e0             	or     $0xffffffe0,%eax
c010186c:	0f b6 c0             	movzbl %al,%eax
c010186f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101873:	83 c2 06             	add    $0x6,%edx
c0101876:	0f b7 d2             	movzwl %dx,%edx
c0101879:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010187d:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101880:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101884:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101888:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101889:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010188d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101894:	00 
c0101895:	89 04 24             	mov    %eax,(%esp)
c0101898:	e8 0f ff ff ff       	call   c01017ac <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c010189d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018a1:	83 c0 07             	add    $0x7,%eax
c01018a4:	0f b7 c0             	movzwl %ax,%eax
c01018a7:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018ab:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018af:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018b3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018b7:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018b8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018c3:	00 
c01018c4:	89 04 24             	mov    %eax,(%esp)
c01018c7:	e8 e0 fe ff ff       	call   c01017ac <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018cc:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018d0:	83 c0 07             	add    $0x7,%eax
c01018d3:	0f b7 c0             	movzwl %ax,%eax
c01018d6:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018da:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018de:	89 c2                	mov    %eax,%edx
c01018e0:	ec                   	in     (%dx),%al
c01018e1:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018e4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018e8:	84 c0                	test   %al,%al
c01018ea:	0f 84 f7 01 00 00    	je     c0101ae7 <ide_init+0x2e1>
c01018f0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01018fb:	00 
c01018fc:	89 04 24             	mov    %eax,(%esp)
c01018ff:	e8 a8 fe ff ff       	call   c01017ac <ide_wait_ready>
c0101904:	85 c0                	test   %eax,%eax
c0101906:	0f 85 db 01 00 00    	jne    c0101ae7 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010190c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101910:	c1 e0 03             	shl    $0x3,%eax
c0101913:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191a:	29 c2                	sub    %eax,%edx
c010191c:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101922:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101925:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101929:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010192c:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101932:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101935:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010193c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010193f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101942:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101945:	89 cb                	mov    %ecx,%ebx
c0101947:	89 df                	mov    %ebx,%edi
c0101949:	89 c1                	mov    %eax,%ecx
c010194b:	fc                   	cld    
c010194c:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010194e:	89 c8                	mov    %ecx,%eax
c0101950:	89 fb                	mov    %edi,%ebx
c0101952:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101955:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101958:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010195e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101964:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010196a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010196d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101970:	25 00 00 00 04       	and    $0x4000000,%eax
c0101975:	85 c0                	test   %eax,%eax
c0101977:	74 0e                	je     c0101987 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010197c:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101982:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101985:	eb 09                	jmp    c0101990 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010198a:	8b 40 78             	mov    0x78(%eax),%eax
c010198d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101990:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101994:	c1 e0 03             	shl    $0x3,%eax
c0101997:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010199e:	29 c2                	sub    %eax,%edx
c01019a0:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019a9:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019ac:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b0:	c1 e0 03             	shl    $0x3,%eax
c01019b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ba:	29 c2                	sub    %eax,%edx
c01019bc:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019c5:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019cb:	83 c0 62             	add    $0x62,%eax
c01019ce:	0f b7 00             	movzwl (%eax),%eax
c01019d1:	0f b7 c0             	movzwl %ax,%eax
c01019d4:	25 00 02 00 00       	and    $0x200,%eax
c01019d9:	85 c0                	test   %eax,%eax
c01019db:	75 24                	jne    c0101a01 <ide_init+0x1fb>
c01019dd:	c7 44 24 0c b0 c2 10 	movl   $0xc010c2b0,0xc(%esp)
c01019e4:	c0 
c01019e5:	c7 44 24 08 f3 c2 10 	movl   $0xc010c2f3,0x8(%esp)
c01019ec:	c0 
c01019ed:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019f4:	00 
c01019f5:	c7 04 24 08 c3 10 c0 	movl   $0xc010c308,(%esp)
c01019fc:	e8 ce f3 ff ff       	call   c0100dcf <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a01:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a05:	c1 e0 03             	shl    $0x3,%eax
c0101a08:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a0f:	29 c2                	sub    %eax,%edx
c0101a11:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101a17:	83 c0 0c             	add    $0xc,%eax
c0101a1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a20:	83 c0 36             	add    $0x36,%eax
c0101a23:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a26:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a2d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a34:	eb 34                	jmp    c0101a6a <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a39:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a3c:	01 c2                	add    %eax,%edx
c0101a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a41:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a44:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a47:	01 c8                	add    %ecx,%eax
c0101a49:	0f b6 00             	movzbl (%eax),%eax
c0101a4c:	88 02                	mov    %al,(%edx)
c0101a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a51:	8d 50 01             	lea    0x1(%eax),%edx
c0101a54:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a57:	01 c2                	add    %eax,%edx
c0101a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a5c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a5f:	01 c8                	add    %ecx,%eax
c0101a61:	0f b6 00             	movzbl (%eax),%eax
c0101a64:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a66:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a6d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a70:	72 c4                	jb     c0101a36 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a75:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a78:	01 d0                	add    %edx,%eax
c0101a7a:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a83:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a86:	85 c0                	test   %eax,%eax
c0101a88:	74 0f                	je     c0101a99 <ide_init+0x293>
c0101a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a90:	01 d0                	add    %edx,%eax
c0101a92:	0f b6 00             	movzbl (%eax),%eax
c0101a95:	3c 20                	cmp    $0x20,%al
c0101a97:	74 d9                	je     c0101a72 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a99:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a9d:	c1 e0 03             	shl    $0x3,%eax
c0101aa0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aa7:	29 c2                	sub    %eax,%edx
c0101aa9:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101aaf:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101ab2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ab6:	c1 e0 03             	shl    $0x3,%eax
c0101ab9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac0:	29 c2                	sub    %eax,%edx
c0101ac2:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ac8:	8b 50 08             	mov    0x8(%eax),%edx
c0101acb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101acf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ad3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101adb:	c7 04 24 1a c3 10 c0 	movl   $0xc010c31a,(%esp)
c0101ae2:	e8 6c e8 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101ae7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aeb:	83 c0 01             	add    $0x1,%eax
c0101aee:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101af2:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101af7:	0f 86 1f fd ff ff    	jbe    c010181c <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101afd:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b04:	e8 7c 05 00 00       	call   c0102085 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b09:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b10:	e8 70 05 00 00       	call   c0102085 <pic_enable>
}
c0101b15:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b1b:	5b                   	pop    %ebx
c0101b1c:	5f                   	pop    %edi
c0101b1d:	5d                   	pop    %ebp
c0101b1e:	c3                   	ret    

c0101b1f <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b1f:	55                   	push   %ebp
c0101b20:	89 e5                	mov    %esp,%ebp
c0101b22:	83 ec 04             	sub    $0x4,%esp
c0101b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b28:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b2c:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b31:	77 24                	ja     c0101b57 <ide_device_valid+0x38>
c0101b33:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b37:	c1 e0 03             	shl    $0x3,%eax
c0101b3a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b41:	29 c2                	sub    %eax,%edx
c0101b43:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b49:	0f b6 00             	movzbl (%eax),%eax
c0101b4c:	84 c0                	test   %al,%al
c0101b4e:	74 07                	je     c0101b57 <ide_device_valid+0x38>
c0101b50:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b55:	eb 05                	jmp    c0101b5c <ide_device_valid+0x3d>
c0101b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b5c:	c9                   	leave  
c0101b5d:	c3                   	ret    

c0101b5e <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b5e:	55                   	push   %ebp
c0101b5f:	89 e5                	mov    %esp,%ebp
c0101b61:	83 ec 08             	sub    $0x8,%esp
c0101b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b67:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b6b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b6f:	89 04 24             	mov    %eax,(%esp)
c0101b72:	e8 a8 ff ff ff       	call   c0101b1f <ide_device_valid>
c0101b77:	85 c0                	test   %eax,%eax
c0101b79:	74 1b                	je     c0101b96 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b7b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b7f:	c1 e0 03             	shl    $0x3,%eax
c0101b82:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b89:	29 c2                	sub    %eax,%edx
c0101b8b:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b91:	8b 40 08             	mov    0x8(%eax),%eax
c0101b94:	eb 05                	jmp    c0101b9b <ide_device_size+0x3d>
    }
    return 0;
c0101b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b9b:	c9                   	leave  
c0101b9c:	c3                   	ret    

c0101b9d <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101b9d:	55                   	push   %ebp
c0101b9e:	89 e5                	mov    %esp,%ebp
c0101ba0:	57                   	push   %edi
c0101ba1:	53                   	push   %ebx
c0101ba2:	83 ec 50             	sub    $0x50,%esp
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bac:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bb3:	77 24                	ja     c0101bd9 <ide_read_secs+0x3c>
c0101bb5:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bba:	77 1d                	ja     c0101bd9 <ide_read_secs+0x3c>
c0101bbc:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc0:	c1 e0 03             	shl    $0x3,%eax
c0101bc3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bca:	29 c2                	sub    %eax,%edx
c0101bcc:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101bd2:	0f b6 00             	movzbl (%eax),%eax
c0101bd5:	84 c0                	test   %al,%al
c0101bd7:	75 24                	jne    c0101bfd <ide_read_secs+0x60>
c0101bd9:	c7 44 24 0c 38 c3 10 	movl   $0xc010c338,0xc(%esp)
c0101be0:	c0 
c0101be1:	c7 44 24 08 f3 c2 10 	movl   $0xc010c2f3,0x8(%esp)
c0101be8:	c0 
c0101be9:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bf0:	00 
c0101bf1:	c7 04 24 08 c3 10 c0 	movl   $0xc010c308,(%esp)
c0101bf8:	e8 d2 f1 ff ff       	call   c0100dcf <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101bfd:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c04:	77 0f                	ja     c0101c15 <ide_read_secs+0x78>
c0101c06:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c09:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c0c:	01 d0                	add    %edx,%eax
c0101c0e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c13:	76 24                	jbe    c0101c39 <ide_read_secs+0x9c>
c0101c15:	c7 44 24 0c 60 c3 10 	movl   $0xc010c360,0xc(%esp)
c0101c1c:	c0 
c0101c1d:	c7 44 24 08 f3 c2 10 	movl   $0xc010c2f3,0x8(%esp)
c0101c24:	c0 
c0101c25:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c2c:	00 
c0101c2d:	c7 04 24 08 c3 10 c0 	movl   $0xc010c308,(%esp)
c0101c34:	e8 96 f1 ff ff       	call   c0100dcf <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c39:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c3d:	66 d1 e8             	shr    %ax
c0101c40:	0f b7 c0             	movzwl %ax,%eax
c0101c43:	0f b7 04 85 a8 c2 10 	movzwl -0x3fef3d58(,%eax,4),%eax
c0101c4a:	c0 
c0101c4b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c4f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c53:	66 d1 e8             	shr    %ax
c0101c56:	0f b7 c0             	movzwl %ax,%eax
c0101c59:	0f b7 04 85 aa c2 10 	movzwl -0x3fef3d56(,%eax,4),%eax
c0101c60:	c0 
c0101c61:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c69:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c70:	00 
c0101c71:	89 04 24             	mov    %eax,(%esp)
c0101c74:	e8 33 fb ff ff       	call   c01017ac <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c79:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c7d:	83 c0 02             	add    $0x2,%eax
c0101c80:	0f b7 c0             	movzwl %ax,%eax
c0101c83:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c87:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c93:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c94:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c97:	0f b6 c0             	movzbl %al,%eax
c0101c9a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c9e:	83 c2 02             	add    $0x2,%edx
c0101ca1:	0f b7 d2             	movzwl %dx,%edx
c0101ca4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ca8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101caf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cb3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cb7:	0f b6 c0             	movzbl %al,%eax
c0101cba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cbe:	83 c2 03             	add    $0x3,%edx
c0101cc1:	0f b7 d2             	movzwl %dx,%edx
c0101cc4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cc8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101ccb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ccf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cd3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cd7:	c1 e8 08             	shr    $0x8,%eax
c0101cda:	0f b6 c0             	movzbl %al,%eax
c0101cdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ce1:	83 c2 04             	add    $0x4,%edx
c0101ce4:	0f b7 d2             	movzwl %dx,%edx
c0101ce7:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101ceb:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cee:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cf2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cf6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cfa:	c1 e8 10             	shr    $0x10,%eax
c0101cfd:	0f b6 c0             	movzbl %al,%eax
c0101d00:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d04:	83 c2 05             	add    $0x5,%edx
c0101d07:	0f b7 d2             	movzwl %dx,%edx
c0101d0a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d0e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d11:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d15:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d19:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d1a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d1e:	83 e0 01             	and    $0x1,%eax
c0101d21:	c1 e0 04             	shl    $0x4,%eax
c0101d24:	89 c2                	mov    %eax,%edx
c0101d26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d29:	c1 e8 18             	shr    $0x18,%eax
c0101d2c:	83 e0 0f             	and    $0xf,%eax
c0101d2f:	09 d0                	or     %edx,%eax
c0101d31:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d34:	0f b6 c0             	movzbl %al,%eax
c0101d37:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d3b:	83 c2 06             	add    $0x6,%edx
c0101d3e:	0f b7 d2             	movzwl %dx,%edx
c0101d41:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d45:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d48:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d4c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d50:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d51:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d55:	83 c0 07             	add    $0x7,%eax
c0101d58:	0f b7 c0             	movzwl %ax,%eax
c0101d5b:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d5f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d63:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d67:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d6b:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d73:	eb 5a                	jmp    c0101dcf <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d80:	00 
c0101d81:	89 04 24             	mov    %eax,(%esp)
c0101d84:	e8 23 fa ff ff       	call   c01017ac <ide_wait_ready>
c0101d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d90:	74 02                	je     c0101d94 <ide_read_secs+0x1f7>
            goto out;
c0101d92:	eb 41                	jmp    c0101dd5 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d94:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d98:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101d9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101da1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101da8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101dab:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101dae:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101db1:	89 cb                	mov    %ecx,%ebx
c0101db3:	89 df                	mov    %ebx,%edi
c0101db5:	89 c1                	mov    %eax,%ecx
c0101db7:	fc                   	cld    
c0101db8:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dba:	89 c8                	mov    %ecx,%eax
c0101dbc:	89 fb                	mov    %edi,%ebx
c0101dbe:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dc4:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dc8:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dcf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dd3:	75 a0                	jne    c0101d75 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dd8:	83 c4 50             	add    $0x50,%esp
c0101ddb:	5b                   	pop    %ebx
c0101ddc:	5f                   	pop    %edi
c0101ddd:	5d                   	pop    %ebp
c0101dde:	c3                   	ret    

c0101ddf <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ddf:	55                   	push   %ebp
c0101de0:	89 e5                	mov    %esp,%ebp
c0101de2:	56                   	push   %esi
c0101de3:	53                   	push   %ebx
c0101de4:	83 ec 50             	sub    $0x50,%esp
c0101de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dea:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101dee:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101df5:	77 24                	ja     c0101e1b <ide_write_secs+0x3c>
c0101df7:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101dfc:	77 1d                	ja     c0101e1b <ide_write_secs+0x3c>
c0101dfe:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e02:	c1 e0 03             	shl    $0x3,%eax
c0101e05:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e0c:	29 c2                	sub    %eax,%edx
c0101e0e:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101e14:	0f b6 00             	movzbl (%eax),%eax
c0101e17:	84 c0                	test   %al,%al
c0101e19:	75 24                	jne    c0101e3f <ide_write_secs+0x60>
c0101e1b:	c7 44 24 0c 38 c3 10 	movl   $0xc010c338,0xc(%esp)
c0101e22:	c0 
c0101e23:	c7 44 24 08 f3 c2 10 	movl   $0xc010c2f3,0x8(%esp)
c0101e2a:	c0 
c0101e2b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e32:	00 
c0101e33:	c7 04 24 08 c3 10 c0 	movl   $0xc010c308,(%esp)
c0101e3a:	e8 90 ef ff ff       	call   c0100dcf <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e3f:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e46:	77 0f                	ja     c0101e57 <ide_write_secs+0x78>
c0101e48:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e4e:	01 d0                	add    %edx,%eax
c0101e50:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e55:	76 24                	jbe    c0101e7b <ide_write_secs+0x9c>
c0101e57:	c7 44 24 0c 60 c3 10 	movl   $0xc010c360,0xc(%esp)
c0101e5e:	c0 
c0101e5f:	c7 44 24 08 f3 c2 10 	movl   $0xc010c2f3,0x8(%esp)
c0101e66:	c0 
c0101e67:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e6e:	00 
c0101e6f:	c7 04 24 08 c3 10 c0 	movl   $0xc010c308,(%esp)
c0101e76:	e8 54 ef ff ff       	call   c0100dcf <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e7b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e7f:	66 d1 e8             	shr    %ax
c0101e82:	0f b7 c0             	movzwl %ax,%eax
c0101e85:	0f b7 04 85 a8 c2 10 	movzwl -0x3fef3d58(,%eax,4),%eax
c0101e8c:	c0 
c0101e8d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e91:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e95:	66 d1 e8             	shr    %ax
c0101e98:	0f b7 c0             	movzwl %ax,%eax
c0101e9b:	0f b7 04 85 aa c2 10 	movzwl -0x3fef3d56(,%eax,4),%eax
c0101ea2:	c0 
c0101ea3:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ea7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101eb2:	00 
c0101eb3:	89 04 24             	mov    %eax,(%esp)
c0101eb6:	e8 f1 f8 ff ff       	call   c01017ac <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ebb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ebf:	83 c0 02             	add    $0x2,%eax
c0101ec2:	0f b7 c0             	movzwl %ax,%eax
c0101ec5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ec9:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ecd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ed1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ed5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ed6:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ed9:	0f b6 c0             	movzbl %al,%eax
c0101edc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee0:	83 c2 02             	add    $0x2,%edx
c0101ee3:	0f b7 d2             	movzwl %dx,%edx
c0101ee6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101eea:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101eed:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ef1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101ef5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ef9:	0f b6 c0             	movzbl %al,%eax
c0101efc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f00:	83 c2 03             	add    $0x3,%edx
c0101f03:	0f b7 d2             	movzwl %dx,%edx
c0101f06:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f0a:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f0d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f11:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f15:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f19:	c1 e8 08             	shr    $0x8,%eax
c0101f1c:	0f b6 c0             	movzbl %al,%eax
c0101f1f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f23:	83 c2 04             	add    $0x4,%edx
c0101f26:	0f b7 d2             	movzwl %dx,%edx
c0101f29:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f2d:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f30:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f34:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f38:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f3c:	c1 e8 10             	shr    $0x10,%eax
c0101f3f:	0f b6 c0             	movzbl %al,%eax
c0101f42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f46:	83 c2 05             	add    $0x5,%edx
c0101f49:	0f b7 d2             	movzwl %dx,%edx
c0101f4c:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f50:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f53:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f57:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f5b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f60:	83 e0 01             	and    $0x1,%eax
c0101f63:	c1 e0 04             	shl    $0x4,%eax
c0101f66:	89 c2                	mov    %eax,%edx
c0101f68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f6b:	c1 e8 18             	shr    $0x18,%eax
c0101f6e:	83 e0 0f             	and    $0xf,%eax
c0101f71:	09 d0                	or     %edx,%eax
c0101f73:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f76:	0f b6 c0             	movzbl %al,%eax
c0101f79:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f7d:	83 c2 06             	add    $0x6,%edx
c0101f80:	0f b7 d2             	movzwl %dx,%edx
c0101f83:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f87:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f8a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f8e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f92:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f93:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f97:	83 c0 07             	add    $0x7,%eax
c0101f9a:	0f b7 c0             	movzwl %ax,%eax
c0101f9d:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fa1:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fa5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101fa9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fad:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fb5:	eb 5a                	jmp    c0102011 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fb7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fbb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fc2:	00 
c0101fc3:	89 04 24             	mov    %eax,(%esp)
c0101fc6:	e8 e1 f7 ff ff       	call   c01017ac <ide_wait_ready>
c0101fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fd2:	74 02                	je     c0101fd6 <ide_write_secs+0x1f7>
            goto out;
c0101fd4:	eb 41                	jmp    c0102017 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fd6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fda:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fdd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fe0:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fe3:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101fea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101fed:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ff0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ff3:	89 cb                	mov    %ecx,%ebx
c0101ff5:	89 de                	mov    %ebx,%esi
c0101ff7:	89 c1                	mov    %eax,%ecx
c0101ff9:	fc                   	cld    
c0101ffa:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101ffc:	89 c8                	mov    %ecx,%eax
c0101ffe:	89 f3                	mov    %esi,%ebx
c0102000:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0102003:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0102006:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c010200a:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0102011:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0102015:	75 a0                	jne    c0101fb7 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0102017:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010201a:	83 c4 50             	add    $0x50,%esp
c010201d:	5b                   	pop    %ebx
c010201e:	5e                   	pop    %esi
c010201f:	5d                   	pop    %ebp
c0102020:	c3                   	ret    

c0102021 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102021:	55                   	push   %ebp
c0102022:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0102024:	fb                   	sti    
    sti();
}
c0102025:	5d                   	pop    %ebp
c0102026:	c3                   	ret    

c0102027 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0102027:	55                   	push   %ebp
c0102028:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c010202a:	fa                   	cli    
    cli();
}
c010202b:	5d                   	pop    %ebp
c010202c:	c3                   	ret    

c010202d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010202d:	55                   	push   %ebp
c010202e:	89 e5                	mov    %esp,%ebp
c0102030:	83 ec 14             	sub    $0x14,%esp
c0102033:	8b 45 08             	mov    0x8(%ebp),%eax
c0102036:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c010203a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010203e:	66 a3 70 a5 12 c0    	mov    %ax,0xc012a570
    if (did_init) {
c0102044:	a1 a0 c6 19 c0       	mov    0xc019c6a0,%eax
c0102049:	85 c0                	test   %eax,%eax
c010204b:	74 36                	je     c0102083 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c010204d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102051:	0f b6 c0             	movzbl %al,%eax
c0102054:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010205a:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010205d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102061:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102065:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0102066:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010206a:	66 c1 e8 08          	shr    $0x8,%ax
c010206e:	0f b6 c0             	movzbl %al,%eax
c0102071:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0102077:	88 45 f9             	mov    %al,-0x7(%ebp)
c010207a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010207e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102082:	ee                   	out    %al,(%dx)
    }
}
c0102083:	c9                   	leave  
c0102084:	c3                   	ret    

c0102085 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0102085:	55                   	push   %ebp
c0102086:	89 e5                	mov    %esp,%ebp
c0102088:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010208b:	8b 45 08             	mov    0x8(%ebp),%eax
c010208e:	ba 01 00 00 00       	mov    $0x1,%edx
c0102093:	89 c1                	mov    %eax,%ecx
c0102095:	d3 e2                	shl    %cl,%edx
c0102097:	89 d0                	mov    %edx,%eax
c0102099:	f7 d0                	not    %eax
c010209b:	89 c2                	mov    %eax,%edx
c010209d:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01020a4:	21 d0                	and    %edx,%eax
c01020a6:	0f b7 c0             	movzwl %ax,%eax
c01020a9:	89 04 24             	mov    %eax,(%esp)
c01020ac:	e8 7c ff ff ff       	call   c010202d <pic_setmask>
}
c01020b1:	c9                   	leave  
c01020b2:	c3                   	ret    

c01020b3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020b3:	55                   	push   %ebp
c01020b4:	89 e5                	mov    %esp,%ebp
c01020b6:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020b9:	c7 05 a0 c6 19 c0 01 	movl   $0x1,0xc019c6a0
c01020c0:	00 00 00 
c01020c3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020c9:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020cd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020d1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020d5:	ee                   	out    %al,(%dx)
c01020d6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020dc:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020e8:	ee                   	out    %al,(%dx)
c01020e9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020ef:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020f7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01020fb:	ee                   	out    %al,(%dx)
c01020fc:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102102:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102106:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010210a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010210e:	ee                   	out    %al,(%dx)
c010210f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102115:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102119:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010211d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102121:	ee                   	out    %al,(%dx)
c0102122:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102128:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010212c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102130:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102134:	ee                   	out    %al,(%dx)
c0102135:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010213b:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010213f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102143:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102147:	ee                   	out    %al,(%dx)
c0102148:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010214e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102152:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102156:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010215a:	ee                   	out    %al,(%dx)
c010215b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102161:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102165:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102169:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010216d:	ee                   	out    %al,(%dx)
c010216e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102174:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102178:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010217c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102180:	ee                   	out    %al,(%dx)
c0102181:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102187:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010218b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010218f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102193:	ee                   	out    %al,(%dx)
c0102194:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010219a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010219e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021a2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021a6:	ee                   	out    %al,(%dx)
c01021a7:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021ad:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021b1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021b5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021b9:	ee                   	out    %al,(%dx)
c01021ba:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021c0:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021c4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021c8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021cc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021cd:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021d4:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021d8:	74 12                	je     c01021ec <pic_init+0x139>
        pic_setmask(irq_mask);
c01021da:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021e1:	0f b7 c0             	movzwl %ax,%eax
c01021e4:	89 04 24             	mov    %eax,(%esp)
c01021e7:	e8 41 fe ff ff       	call   c010202d <pic_setmask>
    }
}
c01021ec:	c9                   	leave  
c01021ed:	c3                   	ret    

c01021ee <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01021ee:	55                   	push   %ebp
c01021ef:	89 e5                	mov    %esp,%ebp
c01021f1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021f4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01021fb:	00 
c01021fc:	c7 04 24 a0 c3 10 c0 	movl   $0xc010c3a0,(%esp)
c0102203:	e8 4b e1 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102208:	c7 04 24 aa c3 10 c0 	movl   $0xc010c3aa,(%esp)
c010220f:	e8 3f e1 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c0102214:	c7 44 24 08 b8 c3 10 	movl   $0xc010c3b8,0x8(%esp)
c010221b:	c0 
c010221c:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0102223:	00 
c0102224:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c010222b:	e8 9f eb ff ff       	call   c0100dcf <__panic>

c0102230 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102230:	55                   	push   %ebp
c0102231:	89 e5                	mov    %esp,%ebp
c0102233:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c0102236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010223d:	e9 5c 02 00 00       	jmp    c010249e <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
c0102242:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c0102249:	0f 85 c1 00 00 00    	jne    c0102310 <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
c010224f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102252:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c0102259:	89 c2                	mov    %eax,%edx
c010225b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010225e:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c0102265:	c0 
c0102266:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102269:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c0102270:	c0 08 00 
c0102273:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102276:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c010227d:	c0 
c010227e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102281:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102288:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010228b:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102292:	c0 
c0102293:	83 e2 1f             	and    $0x1f,%edx
c0102296:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c010229d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022a0:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022a7:	c0 
c01022a8:	83 ca 0f             	or     $0xf,%edx
c01022ab:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b5:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022bc:	c0 
c01022bd:	83 e2 ef             	and    $0xffffffef,%edx
c01022c0:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ca:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022d1:	c0 
c01022d2:	83 ca 60             	or     $0x60,%edx
c01022d5:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022df:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022e6:	c0 
c01022e7:	83 ca 80             	or     $0xffffff80,%edx
c01022ea:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f4:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01022fb:	c1 e8 10             	shr    $0x10,%eax
c01022fe:	89 c2                	mov    %eax,%edx
c0102300:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102303:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c010230a:	c0 
c010230b:	e9 8a 01 00 00       	jmp    c010249a <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
c0102310:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c0102314:	0f 8f c1 00 00 00    	jg     c01023db <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010231a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010231d:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c0102324:	89 c2                	mov    %eax,%edx
c0102326:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102329:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c0102330:	c0 
c0102331:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102334:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c010233b:	c0 08 00 
c010233e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102341:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102348:	c0 
c0102349:	83 e2 e0             	and    $0xffffffe0,%edx
c010234c:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102353:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102356:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c010235d:	c0 
c010235e:	83 e2 1f             	and    $0x1f,%edx
c0102361:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102368:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010236b:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102372:	c0 
c0102373:	83 ca 0f             	or     $0xf,%edx
c0102376:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c010237d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102380:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102387:	c0 
c0102388:	83 e2 ef             	and    $0xffffffef,%edx
c010238b:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c0102392:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102395:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c010239c:	c0 
c010239d:	83 e2 9f             	and    $0xffffff9f,%edx
c01023a0:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01023a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023aa:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01023b1:	c0 
c01023b2:	83 ca 80             	or     $0xffffff80,%edx
c01023b5:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01023bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023bf:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01023c6:	c1 e8 10             	shr    $0x10,%eax
c01023c9:	89 c2                	mov    %eax,%edx
c01023cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023ce:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c01023d5:	c0 
c01023d6:	e9 bf 00 00 00       	jmp    c010249a <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01023db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023de:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01023e5:	89 c2                	mov    %eax,%edx
c01023e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023ea:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c01023f1:	c0 
c01023f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023f5:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c01023fc:	c0 08 00 
c01023ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102402:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102409:	c0 
c010240a:	83 e2 e0             	and    $0xffffffe0,%edx
c010240d:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102414:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102417:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c010241e:	c0 
c010241f:	83 e2 1f             	and    $0x1f,%edx
c0102422:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102429:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010242c:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102433:	c0 
c0102434:	83 e2 f0             	and    $0xfffffff0,%edx
c0102437:	83 ca 0e             	or     $0xe,%edx
c010243a:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c0102441:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102444:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c010244b:	c0 
c010244c:	83 e2 ef             	and    $0xffffffef,%edx
c010244f:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c0102456:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102459:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102460:	c0 
c0102461:	83 e2 9f             	and    $0xffffff9f,%edx
c0102464:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c010246b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010246e:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102475:	c0 
c0102476:	83 ca 80             	or     $0xffffff80,%edx
c0102479:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c0102480:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102483:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c010248a:	c1 e8 10             	shr    $0x10,%eax
c010248d:	89 c2                	mov    %eax,%edx
c010248f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102492:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c0102499:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
c010249a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010249e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024a1:	3d ff 00 00 00       	cmp    $0xff,%eax
c01024a6:	0f 86 96 fd ff ff    	jbe    c0102242 <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01024ac:	a1 e4 a7 12 c0       	mov    0xc012a7e4,%eax
c01024b1:	66 a3 88 ca 19 c0    	mov    %ax,0xc019ca88
c01024b7:	66 c7 05 8a ca 19 c0 	movw   $0x8,0xc019ca8a
c01024be:	08 00 
c01024c0:	0f b6 05 8c ca 19 c0 	movzbl 0xc019ca8c,%eax
c01024c7:	83 e0 e0             	and    $0xffffffe0,%eax
c01024ca:	a2 8c ca 19 c0       	mov    %al,0xc019ca8c
c01024cf:	0f b6 05 8c ca 19 c0 	movzbl 0xc019ca8c,%eax
c01024d6:	83 e0 1f             	and    $0x1f,%eax
c01024d9:	a2 8c ca 19 c0       	mov    %al,0xc019ca8c
c01024de:	0f b6 05 8d ca 19 c0 	movzbl 0xc019ca8d,%eax
c01024e5:	83 e0 f0             	and    $0xfffffff0,%eax
c01024e8:	83 c8 0e             	or     $0xe,%eax
c01024eb:	a2 8d ca 19 c0       	mov    %al,0xc019ca8d
c01024f0:	0f b6 05 8d ca 19 c0 	movzbl 0xc019ca8d,%eax
c01024f7:	83 e0 ef             	and    $0xffffffef,%eax
c01024fa:	a2 8d ca 19 c0       	mov    %al,0xc019ca8d
c01024ff:	0f b6 05 8d ca 19 c0 	movzbl 0xc019ca8d,%eax
c0102506:	83 c8 60             	or     $0x60,%eax
c0102509:	a2 8d ca 19 c0       	mov    %al,0xc019ca8d
c010250e:	0f b6 05 8d ca 19 c0 	movzbl 0xc019ca8d,%eax
c0102515:	83 c8 80             	or     $0xffffff80,%eax
c0102518:	a2 8d ca 19 c0       	mov    %al,0xc019ca8d
c010251d:	a1 e4 a7 12 c0       	mov    0xc012a7e4,%eax
c0102522:	c1 e8 10             	shr    $0x10,%eax
c0102525:	66 a3 8e ca 19 c0    	mov    %ax,0xc019ca8e
c010252b:	c7 45 f8 80 a5 12 c0 	movl   $0xc012a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102532:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102535:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
     /* LAB5 YOUR CODE */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
}
c0102538:	c9                   	leave  
c0102539:	c3                   	ret    

c010253a <trapname>:

static const char *
trapname(int trapno) {
c010253a:	55                   	push   %ebp
c010253b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010253d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102540:	83 f8 13             	cmp    $0x13,%eax
c0102543:	77 0c                	ja     c0102551 <trapname+0x17>
        return excnames[trapno];
c0102545:	8b 45 08             	mov    0x8(%ebp),%eax
c0102548:	8b 04 85 60 c8 10 c0 	mov    -0x3fef37a0(,%eax,4),%eax
c010254f:	eb 18                	jmp    c0102569 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102551:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102555:	7e 0d                	jle    c0102564 <trapname+0x2a>
c0102557:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010255b:	7f 07                	jg     c0102564 <trapname+0x2a>
        return "Hardware Interrupt";
c010255d:	b8 df c3 10 c0       	mov    $0xc010c3df,%eax
c0102562:	eb 05                	jmp    c0102569 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102564:	b8 f2 c3 10 c0       	mov    $0xc010c3f2,%eax
}
c0102569:	5d                   	pop    %ebp
c010256a:	c3                   	ret    

c010256b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010256b:	55                   	push   %ebp
c010256c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010256e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102571:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102575:	66 83 f8 08          	cmp    $0x8,%ax
c0102579:	0f 94 c0             	sete   %al
c010257c:	0f b6 c0             	movzbl %al,%eax
}
c010257f:	5d                   	pop    %ebp
c0102580:	c3                   	ret    

c0102581 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102581:	55                   	push   %ebp
c0102582:	89 e5                	mov    %esp,%ebp
c0102584:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102587:	8b 45 08             	mov    0x8(%ebp),%eax
c010258a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010258e:	c7 04 24 33 c4 10 c0 	movl   $0xc010c433,(%esp)
c0102595:	e8 b9 dd ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c010259a:	8b 45 08             	mov    0x8(%ebp),%eax
c010259d:	89 04 24             	mov    %eax,(%esp)
c01025a0:	e8 a1 01 00 00       	call   c0102746 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01025a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01025ac:	0f b7 c0             	movzwl %ax,%eax
c01025af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025b3:	c7 04 24 44 c4 10 c0 	movl   $0xc010c444,(%esp)
c01025ba:	e8 94 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01025bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01025c6:	0f b7 c0             	movzwl %ax,%eax
c01025c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025cd:	c7 04 24 57 c4 10 c0 	movl   $0xc010c457,(%esp)
c01025d4:	e8 7a dd ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01025d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01025dc:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01025e0:	0f b7 c0             	movzwl %ax,%eax
c01025e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025e7:	c7 04 24 6a c4 10 c0 	movl   $0xc010c46a,(%esp)
c01025ee:	e8 60 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01025f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f6:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01025fa:	0f b7 c0             	movzwl %ax,%eax
c01025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102601:	c7 04 24 7d c4 10 c0 	movl   $0xc010c47d,(%esp)
c0102608:	e8 46 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010260d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102610:	8b 40 30             	mov    0x30(%eax),%eax
c0102613:	89 04 24             	mov    %eax,(%esp)
c0102616:	e8 1f ff ff ff       	call   c010253a <trapname>
c010261b:	8b 55 08             	mov    0x8(%ebp),%edx
c010261e:	8b 52 30             	mov    0x30(%edx),%edx
c0102621:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102625:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102629:	c7 04 24 90 c4 10 c0 	movl   $0xc010c490,(%esp)
c0102630:	e8 1e dd ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102635:	8b 45 08             	mov    0x8(%ebp),%eax
c0102638:	8b 40 34             	mov    0x34(%eax),%eax
c010263b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010263f:	c7 04 24 a2 c4 10 c0 	movl   $0xc010c4a2,(%esp)
c0102646:	e8 08 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010264b:	8b 45 08             	mov    0x8(%ebp),%eax
c010264e:	8b 40 38             	mov    0x38(%eax),%eax
c0102651:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102655:	c7 04 24 b1 c4 10 c0 	movl   $0xc010c4b1,(%esp)
c010265c:	e8 f2 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102661:	8b 45 08             	mov    0x8(%ebp),%eax
c0102664:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102668:	0f b7 c0             	movzwl %ax,%eax
c010266b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010266f:	c7 04 24 c0 c4 10 c0 	movl   $0xc010c4c0,(%esp)
c0102676:	e8 d8 dc ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010267b:	8b 45 08             	mov    0x8(%ebp),%eax
c010267e:	8b 40 40             	mov    0x40(%eax),%eax
c0102681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102685:	c7 04 24 d3 c4 10 c0 	movl   $0xc010c4d3,(%esp)
c010268c:	e8 c2 dc ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102698:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010269f:	eb 3e                	jmp    c01026df <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01026a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a4:	8b 50 40             	mov    0x40(%eax),%edx
c01026a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026aa:	21 d0                	and    %edx,%eax
c01026ac:	85 c0                	test   %eax,%eax
c01026ae:	74 28                	je     c01026d8 <print_trapframe+0x157>
c01026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026b3:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c01026ba:	85 c0                	test   %eax,%eax
c01026bc:	74 1a                	je     c01026d8 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026c1:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c01026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026cc:	c7 04 24 e2 c4 10 c0 	movl   $0xc010c4e2,(%esp)
c01026d3:	e8 7b dc ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01026d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01026dc:	d1 65 f0             	shll   -0x10(%ebp)
c01026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026e2:	83 f8 17             	cmp    $0x17,%eax
c01026e5:	76 ba                	jbe    c01026a1 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01026e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ea:	8b 40 40             	mov    0x40(%eax),%eax
c01026ed:	25 00 30 00 00       	and    $0x3000,%eax
c01026f2:	c1 e8 0c             	shr    $0xc,%eax
c01026f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026f9:	c7 04 24 e6 c4 10 c0 	movl   $0xc010c4e6,(%esp)
c0102700:	e8 4e dc ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102705:	8b 45 08             	mov    0x8(%ebp),%eax
c0102708:	89 04 24             	mov    %eax,(%esp)
c010270b:	e8 5b fe ff ff       	call   c010256b <trap_in_kernel>
c0102710:	85 c0                	test   %eax,%eax
c0102712:	75 30                	jne    c0102744 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102714:	8b 45 08             	mov    0x8(%ebp),%eax
c0102717:	8b 40 44             	mov    0x44(%eax),%eax
c010271a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010271e:	c7 04 24 ef c4 10 c0 	movl   $0xc010c4ef,(%esp)
c0102725:	e8 29 dc ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010272a:	8b 45 08             	mov    0x8(%ebp),%eax
c010272d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102731:	0f b7 c0             	movzwl %ax,%eax
c0102734:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102738:	c7 04 24 fe c4 10 c0 	movl   $0xc010c4fe,(%esp)
c010273f:	e8 0f dc ff ff       	call   c0100353 <cprintf>
    }
}
c0102744:	c9                   	leave  
c0102745:	c3                   	ret    

c0102746 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102746:	55                   	push   %ebp
c0102747:	89 e5                	mov    %esp,%ebp
c0102749:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010274c:	8b 45 08             	mov    0x8(%ebp),%eax
c010274f:	8b 00                	mov    (%eax),%eax
c0102751:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102755:	c7 04 24 11 c5 10 c0 	movl   $0xc010c511,(%esp)
c010275c:	e8 f2 db ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102761:	8b 45 08             	mov    0x8(%ebp),%eax
c0102764:	8b 40 04             	mov    0x4(%eax),%eax
c0102767:	89 44 24 04          	mov    %eax,0x4(%esp)
c010276b:	c7 04 24 20 c5 10 c0 	movl   $0xc010c520,(%esp)
c0102772:	e8 dc db ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102777:	8b 45 08             	mov    0x8(%ebp),%eax
c010277a:	8b 40 08             	mov    0x8(%eax),%eax
c010277d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102781:	c7 04 24 2f c5 10 c0 	movl   $0xc010c52f,(%esp)
c0102788:	e8 c6 db ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010278d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102790:	8b 40 0c             	mov    0xc(%eax),%eax
c0102793:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102797:	c7 04 24 3e c5 10 c0 	movl   $0xc010c53e,(%esp)
c010279e:	e8 b0 db ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01027a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a6:	8b 40 10             	mov    0x10(%eax),%eax
c01027a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027ad:	c7 04 24 4d c5 10 c0 	movl   $0xc010c54d,(%esp)
c01027b4:	e8 9a db ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01027b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01027bc:	8b 40 14             	mov    0x14(%eax),%eax
c01027bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027c3:	c7 04 24 5c c5 10 c0 	movl   $0xc010c55c,(%esp)
c01027ca:	e8 84 db ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01027cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d2:	8b 40 18             	mov    0x18(%eax),%eax
c01027d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027d9:	c7 04 24 6b c5 10 c0 	movl   $0xc010c56b,(%esp)
c01027e0:	e8 6e db ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01027e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01027eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027ef:	c7 04 24 7a c5 10 c0 	movl   $0xc010c57a,(%esp)
c01027f6:	e8 58 db ff ff       	call   c0100353 <cprintf>
}
c01027fb:	c9                   	leave  
c01027fc:	c3                   	ret    

c01027fd <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01027fd:	55                   	push   %ebp
c01027fe:	89 e5                	mov    %esp,%ebp
c0102800:	53                   	push   %ebx
c0102801:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102804:	8b 45 08             	mov    0x8(%ebp),%eax
c0102807:	8b 40 34             	mov    0x34(%eax),%eax
c010280a:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010280d:	85 c0                	test   %eax,%eax
c010280f:	74 07                	je     c0102818 <print_pgfault+0x1b>
c0102811:	b9 89 c5 10 c0       	mov    $0xc010c589,%ecx
c0102816:	eb 05                	jmp    c010281d <print_pgfault+0x20>
c0102818:	b9 9a c5 10 c0       	mov    $0xc010c59a,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010281d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102820:	8b 40 34             	mov    0x34(%eax),%eax
c0102823:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102826:	85 c0                	test   %eax,%eax
c0102828:	74 07                	je     c0102831 <print_pgfault+0x34>
c010282a:	ba 57 00 00 00       	mov    $0x57,%edx
c010282f:	eb 05                	jmp    c0102836 <print_pgfault+0x39>
c0102831:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102836:	8b 45 08             	mov    0x8(%ebp),%eax
c0102839:	8b 40 34             	mov    0x34(%eax),%eax
c010283c:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010283f:	85 c0                	test   %eax,%eax
c0102841:	74 07                	je     c010284a <print_pgfault+0x4d>
c0102843:	b8 55 00 00 00       	mov    $0x55,%eax
c0102848:	eb 05                	jmp    c010284f <print_pgfault+0x52>
c010284a:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010284f:	0f 20 d3             	mov    %cr2,%ebx
c0102852:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102855:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102858:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010285c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102860:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102864:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102868:	c7 04 24 a8 c5 10 c0 	movl   $0xc010c5a8,(%esp)
c010286f:	e8 df da ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102874:	83 c4 34             	add    $0x34,%esp
c0102877:	5b                   	pop    %ebx
c0102878:	5d                   	pop    %ebp
c0102879:	c3                   	ret    

c010287a <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010287a:	55                   	push   %ebp
c010287b:	89 e5                	mov    %esp,%ebp
c010287d:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c0102880:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0102885:	85 c0                	test   %eax,%eax
c0102887:	74 0b                	je     c0102894 <pgfault_handler+0x1a>
            print_pgfault(tf);
c0102889:	8b 45 08             	mov    0x8(%ebp),%eax
c010288c:	89 04 24             	mov    %eax,(%esp)
c010288f:	e8 69 ff ff ff       	call   c01027fd <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c0102894:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0102899:	85 c0                	test   %eax,%eax
c010289b:	74 3d                	je     c01028da <pgfault_handler+0x60>
        assert(current == idleproc);
c010289d:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c01028a3:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c01028a8:	39 c2                	cmp    %eax,%edx
c01028aa:	74 24                	je     c01028d0 <pgfault_handler+0x56>
c01028ac:	c7 44 24 0c cb c5 10 	movl   $0xc010c5cb,0xc(%esp)
c01028b3:	c0 
c01028b4:	c7 44 24 08 df c5 10 	movl   $0xc010c5df,0x8(%esp)
c01028bb:	c0 
c01028bc:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01028c3:	00 
c01028c4:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c01028cb:	e8 ff e4 ff ff       	call   c0100dcf <__panic>
        mm = check_mm_struct;
c01028d0:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01028d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028d8:	eb 46                	jmp    c0102920 <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c01028da:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01028df:	85 c0                	test   %eax,%eax
c01028e1:	75 32                	jne    c0102915 <pgfault_handler+0x9b>
            print_trapframe(tf);
c01028e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e6:	89 04 24             	mov    %eax,(%esp)
c01028e9:	e8 93 fc ff ff       	call   c0102581 <print_trapframe>
            print_pgfault(tf);
c01028ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f1:	89 04 24             	mov    %eax,(%esp)
c01028f4:	e8 04 ff ff ff       	call   c01027fd <print_pgfault>
            panic("unhandled page fault.\n");
c01028f9:	c7 44 24 08 f4 c5 10 	movl   $0xc010c5f4,0x8(%esp)
c0102900:	c0 
c0102901:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0102908:	00 
c0102909:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102910:	e8 ba e4 ff ff       	call   c0100dcf <__panic>
        }
        mm = current->mm;
c0102915:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010291a:	8b 40 18             	mov    0x18(%eax),%eax
c010291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102920:	0f 20 d0             	mov    %cr2,%eax
c0102923:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c0102926:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c0102929:	89 c2                	mov    %eax,%edx
c010292b:	8b 45 08             	mov    0x8(%ebp),%eax
c010292e:	8b 40 34             	mov    0x34(%eax),%eax
c0102931:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102935:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102939:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293c:	89 04 24             	mov    %eax,(%esp)
c010293f:	e8 57 65 00 00       	call   c0108e9b <do_pgfault>
}
c0102944:	c9                   	leave  
c0102945:	c3                   	ret    

c0102946 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102946:	55                   	push   %ebp
c0102947:	89 e5                	mov    %esp,%ebp
c0102949:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c010294c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c0102953:	8b 45 08             	mov    0x8(%ebp),%eax
c0102956:	8b 40 30             	mov    0x30(%eax),%eax
c0102959:	83 f8 2f             	cmp    $0x2f,%eax
c010295c:	77 38                	ja     c0102996 <trap_dispatch+0x50>
c010295e:	83 f8 2e             	cmp    $0x2e,%eax
c0102961:	0f 83 32 02 00 00    	jae    c0102b99 <trap_dispatch+0x253>
c0102967:	83 f8 20             	cmp    $0x20,%eax
c010296a:	0f 84 07 01 00 00    	je     c0102a77 <trap_dispatch+0x131>
c0102970:	83 f8 20             	cmp    $0x20,%eax
c0102973:	77 0a                	ja     c010297f <trap_dispatch+0x39>
c0102975:	83 f8 0e             	cmp    $0xe,%eax
c0102978:	74 3e                	je     c01029b8 <trap_dispatch+0x72>
c010297a:	e9 d2 01 00 00       	jmp    c0102b51 <trap_dispatch+0x20b>
c010297f:	83 f8 21             	cmp    $0x21,%eax
c0102982:	0f 84 87 01 00 00    	je     c0102b0f <trap_dispatch+0x1c9>
c0102988:	83 f8 24             	cmp    $0x24,%eax
c010298b:	0f 84 55 01 00 00    	je     c0102ae6 <trap_dispatch+0x1a0>
c0102991:	e9 bb 01 00 00       	jmp    c0102b51 <trap_dispatch+0x20b>
c0102996:	83 f8 78             	cmp    $0x78,%eax
c0102999:	0f 82 b2 01 00 00    	jb     c0102b51 <trap_dispatch+0x20b>
c010299f:	83 f8 79             	cmp    $0x79,%eax
c01029a2:	0f 86 8d 01 00 00    	jbe    c0102b35 <trap_dispatch+0x1ef>
c01029a8:	3d 80 00 00 00       	cmp    $0x80,%eax
c01029ad:	0f 84 ba 00 00 00    	je     c0102a6d <trap_dispatch+0x127>
c01029b3:	e9 99 01 00 00       	jmp    c0102b51 <trap_dispatch+0x20b>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01029b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029bb:	89 04 24             	mov    %eax,(%esp)
c01029be:	e8 b7 fe ff ff       	call   c010287a <pgfault_handler>
c01029c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01029c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01029ca:	0f 84 98 00 00 00    	je     c0102a68 <trap_dispatch+0x122>
            print_trapframe(tf);
c01029d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d3:	89 04 24             	mov    %eax,(%esp)
c01029d6:	e8 a6 fb ff ff       	call   c0102581 <print_trapframe>
            if (current == NULL) {
c01029db:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029e0:	85 c0                	test   %eax,%eax
c01029e2:	75 23                	jne    c0102a07 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c01029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01029eb:	c7 44 24 08 0c c6 10 	movl   $0xc010c60c,0x8(%esp)
c01029f2:	c0 
c01029f3:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01029fa:	00 
c01029fb:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102a02:	e8 c8 e3 ff ff       	call   c0100dcf <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c0102a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a0a:	89 04 24             	mov    %eax,(%esp)
c0102a0d:	e8 59 fb ff ff       	call   c010256b <trap_in_kernel>
c0102a12:	85 c0                	test   %eax,%eax
c0102a14:	74 23                	je     c0102a39 <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a19:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a1d:	c7 44 24 08 2c c6 10 	movl   $0xc010c62c,0x8(%esp)
c0102a24:	c0 
c0102a25:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102a2c:	00 
c0102a2d:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102a34:	e8 96 e3 ff ff       	call   c0100dcf <__panic>
                }
                cprintf("killed by kernel.\n");
c0102a39:	c7 04 24 5a c6 10 c0 	movl   $0xc010c65a,(%esp)
c0102a40:	e8 0e d9 ff ff       	call   c0100353 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c0102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a48:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a4c:	c7 44 24 08 70 c6 10 	movl   $0xc010c670,0x8(%esp)
c0102a53:	c0 
c0102a54:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0102a5b:	00 
c0102a5c:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102a63:	e8 67 e3 ff ff       	call   c0100dcf <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c0102a68:	e9 2d 01 00 00       	jmp    c0102b9a <trap_dispatch+0x254>
    case T_SYSCALL:
        syscall();
c0102a6d:	e8 e8 87 00 00       	call   c010b25a <syscall>
        break;
c0102a72:	e9 23 01 00 00       	jmp    c0102b9a <trap_dispatch+0x254>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0102a77:	a1 b4 ef 19 c0       	mov    0xc019efb4,%eax
c0102a7c:	83 c0 01             	add    $0x1,%eax
c0102a7f:	a3 b4 ef 19 c0       	mov    %eax,0xc019efb4
		if(ticks % TICK_NUM == 0)
c0102a84:	8b 0d b4 ef 19 c0    	mov    0xc019efb4,%ecx
c0102a8a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102a8f:	89 c8                	mov    %ecx,%eax
c0102a91:	f7 e2                	mul    %edx
c0102a93:	89 d0                	mov    %edx,%eax
c0102a95:	c1 e8 05             	shr    $0x5,%eax
c0102a98:	6b c0 64             	imul   $0x64,%eax,%eax
c0102a9b:	29 c1                	sub    %eax,%ecx
c0102a9d:	89 c8                	mov    %ecx,%eax
c0102a9f:	85 c0                	test   %eax,%eax
c0102aa1:	75 3e                	jne    c0102ae1 <trap_dispatch+0x19b>
		{
			assert(current != NULL);
c0102aa3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102aa8:	85 c0                	test   %eax,%eax
c0102aaa:	75 24                	jne    c0102ad0 <trap_dispatch+0x18a>
c0102aac:	c7 44 24 0c 99 c6 10 	movl   $0xc010c699,0xc(%esp)
c0102ab3:	c0 
c0102ab4:	c7 44 24 08 df c5 10 	movl   $0xc010c5df,0x8(%esp)
c0102abb:	c0 
c0102abc:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0102ac3:	00 
c0102ac4:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102acb:	e8 ff e2 ff ff       	call   c0100dcf <__panic>
			current->need_resched = 1;
c0102ad0:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102ad5:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
        /* LAB5 YOUR CODE */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
  
        break;
c0102adc:	e9 b9 00 00 00       	jmp    c0102b9a <trap_dispatch+0x254>
c0102ae1:	e9 b4 00 00 00       	jmp    c0102b9a <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102ae6:	e8 52 ec ff ff       	call   c010173d <cons_getc>
c0102aeb:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102aee:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102af2:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102af6:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102afa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102afe:	c7 04 24 a9 c6 10 c0 	movl   $0xc010c6a9,(%esp)
c0102b05:	e8 49 d8 ff ff       	call   c0100353 <cprintf>
        break;
c0102b0a:	e9 8b 00 00 00       	jmp    c0102b9a <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102b0f:	e8 29 ec ff ff       	call   c010173d <cons_getc>
c0102b14:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102b17:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102b1b:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102b1f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102b27:	c7 04 24 bb c6 10 c0 	movl   $0xc010c6bb,(%esp)
c0102b2e:	e8 20 d8 ff ff       	call   c0100353 <cprintf>
        break;
c0102b33:	eb 65                	jmp    c0102b9a <trap_dispatch+0x254>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102b35:	c7 44 24 08 ca c6 10 	movl   $0xc010c6ca,0x8(%esp)
c0102b3c:	c0 
c0102b3d:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0102b44:	00 
c0102b45:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102b4c:	e8 7e e2 ff ff       	call   c0100dcf <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c0102b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b54:	89 04 24             	mov    %eax,(%esp)
c0102b57:	e8 25 fa ff ff       	call   c0102581 <print_trapframe>
        if (current != NULL) {
c0102b5c:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102b61:	85 c0                	test   %eax,%eax
c0102b63:	74 18                	je     c0102b7d <trap_dispatch+0x237>
            cprintf("unhandled trap.\n");
c0102b65:	c7 04 24 da c6 10 c0 	movl   $0xc010c6da,(%esp)
c0102b6c:	e8 e2 d7 ff ff       	call   c0100353 <cprintf>
            do_exit(-E_KILLED);
c0102b71:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102b78:	e8 80 74 00 00       	call   c0109ffd <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102b7d:	c7 44 24 08 eb c6 10 	movl   $0xc010c6eb,0x8(%esp)
c0102b84:	c0 
c0102b85:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0102b8c:	00 
c0102b8d:	c7 04 24 ce c3 10 c0 	movl   $0xc010c3ce,(%esp)
c0102b94:	e8 36 e2 ff ff       	call   c0100dcf <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102b99:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c0102b9a:	c9                   	leave  
c0102b9b:	c3                   	ret    

c0102b9c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102b9c:	55                   	push   %ebp
c0102b9d:	89 e5                	mov    %esp,%ebp
c0102b9f:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c0102ba2:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102ba7:	85 c0                	test   %eax,%eax
c0102ba9:	75 0d                	jne    c0102bb8 <trap+0x1c>
        trap_dispatch(tf);
c0102bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bae:	89 04 24             	mov    %eax,(%esp)
c0102bb1:	e8 90 fd ff ff       	call   c0102946 <trap_dispatch>
c0102bb6:	eb 6c                	jmp    c0102c24 <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c0102bb8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102bbd:	8b 40 3c             	mov    0x3c(%eax),%eax
c0102bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c0102bc3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102bc8:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bcb:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c0102bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd1:	89 04 24             	mov    %eax,(%esp)
c0102bd4:	e8 92 f9 ff ff       	call   c010256b <trap_in_kernel>
c0102bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c0102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdf:	89 04 24             	mov    %eax,(%esp)
c0102be2:	e8 5f fd ff ff       	call   c0102946 <trap_dispatch>
    
        current->tf = otf;
c0102be7:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102bef:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c0102bf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102bf6:	75 2c                	jne    c0102c24 <trap+0x88>
            if (current->flags & PF_EXITING) {
c0102bf8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102bfd:	8b 40 44             	mov    0x44(%eax),%eax
c0102c00:	83 e0 01             	and    $0x1,%eax
c0102c03:	85 c0                	test   %eax,%eax
c0102c05:	74 0c                	je     c0102c13 <trap+0x77>
                do_exit(-E_KILLED);
c0102c07:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102c0e:	e8 ea 73 00 00       	call   c0109ffd <do_exit>
            }
            if (current->need_resched) {
c0102c13:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102c18:	8b 40 10             	mov    0x10(%eax),%eax
c0102c1b:	85 c0                	test   %eax,%eax
c0102c1d:	74 05                	je     c0102c24 <trap+0x88>
                schedule();
c0102c1f:	e8 3e 84 00 00       	call   c010b062 <schedule>
            }
        }
    }
}
c0102c24:	c9                   	leave  
c0102c25:	c3                   	ret    

c0102c26 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102c26:	1e                   	push   %ds
    pushl %es
c0102c27:	06                   	push   %es
    pushl %fs
c0102c28:	0f a0                	push   %fs
    pushl %gs
c0102c2a:	0f a8                	push   %gs
    pushal
c0102c2c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102c2d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102c32:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102c34:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102c36:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102c37:	e8 60 ff ff ff       	call   c0102b9c <trap>

    # pop the pushed stack pointer
    popl %esp
c0102c3c:	5c                   	pop    %esp

c0102c3d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102c3d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102c3e:	0f a9                	pop    %gs
    popl %fs
c0102c40:	0f a1                	pop    %fs
    popl %es
c0102c42:	07                   	pop    %es
    popl %ds
c0102c43:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102c44:	83 c4 08             	add    $0x8,%esp
    iret
c0102c47:	cf                   	iret   

c0102c48 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102c48:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102c4c:	e9 ec ff ff ff       	jmp    c0102c3d <__trapret>

c0102c51 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $0
c0102c53:	6a 00                	push   $0x0
  jmp __alltraps
c0102c55:	e9 cc ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c5a <vector1>:
.globl vector1
vector1:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $1
c0102c5c:	6a 01                	push   $0x1
  jmp __alltraps
c0102c5e:	e9 c3 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c63 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102c63:	6a 00                	push   $0x0
  pushl $2
c0102c65:	6a 02                	push   $0x2
  jmp __alltraps
c0102c67:	e9 ba ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c6c <vector3>:
.globl vector3
vector3:
  pushl $0
c0102c6c:	6a 00                	push   $0x0
  pushl $3
c0102c6e:	6a 03                	push   $0x3
  jmp __alltraps
c0102c70:	e9 b1 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c75 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $4
c0102c77:	6a 04                	push   $0x4
  jmp __alltraps
c0102c79:	e9 a8 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c7e <vector5>:
.globl vector5
vector5:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $5
c0102c80:	6a 05                	push   $0x5
  jmp __alltraps
c0102c82:	e9 9f ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c87 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102c87:	6a 00                	push   $0x0
  pushl $6
c0102c89:	6a 06                	push   $0x6
  jmp __alltraps
c0102c8b:	e9 96 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c90 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102c90:	6a 00                	push   $0x0
  pushl $7
c0102c92:	6a 07                	push   $0x7
  jmp __alltraps
c0102c94:	e9 8d ff ff ff       	jmp    c0102c26 <__alltraps>

c0102c99 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102c99:	6a 08                	push   $0x8
  jmp __alltraps
c0102c9b:	e9 86 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102ca0 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102ca0:	6a 09                	push   $0x9
  jmp __alltraps
c0102ca2:	e9 7f ff ff ff       	jmp    c0102c26 <__alltraps>

c0102ca7 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102ca7:	6a 0a                	push   $0xa
  jmp __alltraps
c0102ca9:	e9 78 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cae <vector11>:
.globl vector11
vector11:
  pushl $11
c0102cae:	6a 0b                	push   $0xb
  jmp __alltraps
c0102cb0:	e9 71 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cb5 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102cb5:	6a 0c                	push   $0xc
  jmp __alltraps
c0102cb7:	e9 6a ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cbc <vector13>:
.globl vector13
vector13:
  pushl $13
c0102cbc:	6a 0d                	push   $0xd
  jmp __alltraps
c0102cbe:	e9 63 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cc3 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102cc3:	6a 0e                	push   $0xe
  jmp __alltraps
c0102cc5:	e9 5c ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cca <vector15>:
.globl vector15
vector15:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $15
c0102ccc:	6a 0f                	push   $0xf
  jmp __alltraps
c0102cce:	e9 53 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cd3 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $16
c0102cd5:	6a 10                	push   $0x10
  jmp __alltraps
c0102cd7:	e9 4a ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cdc <vector17>:
.globl vector17
vector17:
  pushl $17
c0102cdc:	6a 11                	push   $0x11
  jmp __alltraps
c0102cde:	e9 43 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102ce3 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102ce3:	6a 00                	push   $0x0
  pushl $18
c0102ce5:	6a 12                	push   $0x12
  jmp __alltraps
c0102ce7:	e9 3a ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cec <vector19>:
.globl vector19
vector19:
  pushl $0
c0102cec:	6a 00                	push   $0x0
  pushl $19
c0102cee:	6a 13                	push   $0x13
  jmp __alltraps
c0102cf0:	e9 31 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cf5 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102cf5:	6a 00                	push   $0x0
  pushl $20
c0102cf7:	6a 14                	push   $0x14
  jmp __alltraps
c0102cf9:	e9 28 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102cfe <vector21>:
.globl vector21
vector21:
  pushl $0
c0102cfe:	6a 00                	push   $0x0
  pushl $21
c0102d00:	6a 15                	push   $0x15
  jmp __alltraps
c0102d02:	e9 1f ff ff ff       	jmp    c0102c26 <__alltraps>

c0102d07 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102d07:	6a 00                	push   $0x0
  pushl $22
c0102d09:	6a 16                	push   $0x16
  jmp __alltraps
c0102d0b:	e9 16 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102d10 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102d10:	6a 00                	push   $0x0
  pushl $23
c0102d12:	6a 17                	push   $0x17
  jmp __alltraps
c0102d14:	e9 0d ff ff ff       	jmp    c0102c26 <__alltraps>

c0102d19 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102d19:	6a 00                	push   $0x0
  pushl $24
c0102d1b:	6a 18                	push   $0x18
  jmp __alltraps
c0102d1d:	e9 04 ff ff ff       	jmp    c0102c26 <__alltraps>

c0102d22 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102d22:	6a 00                	push   $0x0
  pushl $25
c0102d24:	6a 19                	push   $0x19
  jmp __alltraps
c0102d26:	e9 fb fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d2b <vector26>:
.globl vector26
vector26:
  pushl $0
c0102d2b:	6a 00                	push   $0x0
  pushl $26
c0102d2d:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102d2f:	e9 f2 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d34 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102d34:	6a 00                	push   $0x0
  pushl $27
c0102d36:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102d38:	e9 e9 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d3d <vector28>:
.globl vector28
vector28:
  pushl $0
c0102d3d:	6a 00                	push   $0x0
  pushl $28
c0102d3f:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102d41:	e9 e0 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d46 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102d46:	6a 00                	push   $0x0
  pushl $29
c0102d48:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102d4a:	e9 d7 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d4f <vector30>:
.globl vector30
vector30:
  pushl $0
c0102d4f:	6a 00                	push   $0x0
  pushl $30
c0102d51:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102d53:	e9 ce fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d58 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102d58:	6a 00                	push   $0x0
  pushl $31
c0102d5a:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102d5c:	e9 c5 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d61 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102d61:	6a 00                	push   $0x0
  pushl $32
c0102d63:	6a 20                	push   $0x20
  jmp __alltraps
c0102d65:	e9 bc fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d6a <vector33>:
.globl vector33
vector33:
  pushl $0
c0102d6a:	6a 00                	push   $0x0
  pushl $33
c0102d6c:	6a 21                	push   $0x21
  jmp __alltraps
c0102d6e:	e9 b3 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d73 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102d73:	6a 00                	push   $0x0
  pushl $34
c0102d75:	6a 22                	push   $0x22
  jmp __alltraps
c0102d77:	e9 aa fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d7c <vector35>:
.globl vector35
vector35:
  pushl $0
c0102d7c:	6a 00                	push   $0x0
  pushl $35
c0102d7e:	6a 23                	push   $0x23
  jmp __alltraps
c0102d80:	e9 a1 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d85 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102d85:	6a 00                	push   $0x0
  pushl $36
c0102d87:	6a 24                	push   $0x24
  jmp __alltraps
c0102d89:	e9 98 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d8e <vector37>:
.globl vector37
vector37:
  pushl $0
c0102d8e:	6a 00                	push   $0x0
  pushl $37
c0102d90:	6a 25                	push   $0x25
  jmp __alltraps
c0102d92:	e9 8f fe ff ff       	jmp    c0102c26 <__alltraps>

c0102d97 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102d97:	6a 00                	push   $0x0
  pushl $38
c0102d99:	6a 26                	push   $0x26
  jmp __alltraps
c0102d9b:	e9 86 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102da0 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102da0:	6a 00                	push   $0x0
  pushl $39
c0102da2:	6a 27                	push   $0x27
  jmp __alltraps
c0102da4:	e9 7d fe ff ff       	jmp    c0102c26 <__alltraps>

c0102da9 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102da9:	6a 00                	push   $0x0
  pushl $40
c0102dab:	6a 28                	push   $0x28
  jmp __alltraps
c0102dad:	e9 74 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102db2 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102db2:	6a 00                	push   $0x0
  pushl $41
c0102db4:	6a 29                	push   $0x29
  jmp __alltraps
c0102db6:	e9 6b fe ff ff       	jmp    c0102c26 <__alltraps>

c0102dbb <vector42>:
.globl vector42
vector42:
  pushl $0
c0102dbb:	6a 00                	push   $0x0
  pushl $42
c0102dbd:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102dbf:	e9 62 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102dc4 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102dc4:	6a 00                	push   $0x0
  pushl $43
c0102dc6:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102dc8:	e9 59 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102dcd <vector44>:
.globl vector44
vector44:
  pushl $0
c0102dcd:	6a 00                	push   $0x0
  pushl $44
c0102dcf:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102dd1:	e9 50 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102dd6 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102dd6:	6a 00                	push   $0x0
  pushl $45
c0102dd8:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102dda:	e9 47 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102ddf <vector46>:
.globl vector46
vector46:
  pushl $0
c0102ddf:	6a 00                	push   $0x0
  pushl $46
c0102de1:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102de3:	e9 3e fe ff ff       	jmp    c0102c26 <__alltraps>

c0102de8 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102de8:	6a 00                	push   $0x0
  pushl $47
c0102dea:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102dec:	e9 35 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102df1 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102df1:	6a 00                	push   $0x0
  pushl $48
c0102df3:	6a 30                	push   $0x30
  jmp __alltraps
c0102df5:	e9 2c fe ff ff       	jmp    c0102c26 <__alltraps>

c0102dfa <vector49>:
.globl vector49
vector49:
  pushl $0
c0102dfa:	6a 00                	push   $0x0
  pushl $49
c0102dfc:	6a 31                	push   $0x31
  jmp __alltraps
c0102dfe:	e9 23 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102e03 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102e03:	6a 00                	push   $0x0
  pushl $50
c0102e05:	6a 32                	push   $0x32
  jmp __alltraps
c0102e07:	e9 1a fe ff ff       	jmp    c0102c26 <__alltraps>

c0102e0c <vector51>:
.globl vector51
vector51:
  pushl $0
c0102e0c:	6a 00                	push   $0x0
  pushl $51
c0102e0e:	6a 33                	push   $0x33
  jmp __alltraps
c0102e10:	e9 11 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102e15 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102e15:	6a 00                	push   $0x0
  pushl $52
c0102e17:	6a 34                	push   $0x34
  jmp __alltraps
c0102e19:	e9 08 fe ff ff       	jmp    c0102c26 <__alltraps>

c0102e1e <vector53>:
.globl vector53
vector53:
  pushl $0
c0102e1e:	6a 00                	push   $0x0
  pushl $53
c0102e20:	6a 35                	push   $0x35
  jmp __alltraps
c0102e22:	e9 ff fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e27 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102e27:	6a 00                	push   $0x0
  pushl $54
c0102e29:	6a 36                	push   $0x36
  jmp __alltraps
c0102e2b:	e9 f6 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e30 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102e30:	6a 00                	push   $0x0
  pushl $55
c0102e32:	6a 37                	push   $0x37
  jmp __alltraps
c0102e34:	e9 ed fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e39 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102e39:	6a 00                	push   $0x0
  pushl $56
c0102e3b:	6a 38                	push   $0x38
  jmp __alltraps
c0102e3d:	e9 e4 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e42 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102e42:	6a 00                	push   $0x0
  pushl $57
c0102e44:	6a 39                	push   $0x39
  jmp __alltraps
c0102e46:	e9 db fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e4b <vector58>:
.globl vector58
vector58:
  pushl $0
c0102e4b:	6a 00                	push   $0x0
  pushl $58
c0102e4d:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102e4f:	e9 d2 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e54 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102e54:	6a 00                	push   $0x0
  pushl $59
c0102e56:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102e58:	e9 c9 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e5d <vector60>:
.globl vector60
vector60:
  pushl $0
c0102e5d:	6a 00                	push   $0x0
  pushl $60
c0102e5f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102e61:	e9 c0 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e66 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102e66:	6a 00                	push   $0x0
  pushl $61
c0102e68:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102e6a:	e9 b7 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e6f <vector62>:
.globl vector62
vector62:
  pushl $0
c0102e6f:	6a 00                	push   $0x0
  pushl $62
c0102e71:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102e73:	e9 ae fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e78 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102e78:	6a 00                	push   $0x0
  pushl $63
c0102e7a:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102e7c:	e9 a5 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e81 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102e81:	6a 00                	push   $0x0
  pushl $64
c0102e83:	6a 40                	push   $0x40
  jmp __alltraps
c0102e85:	e9 9c fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e8a <vector65>:
.globl vector65
vector65:
  pushl $0
c0102e8a:	6a 00                	push   $0x0
  pushl $65
c0102e8c:	6a 41                	push   $0x41
  jmp __alltraps
c0102e8e:	e9 93 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e93 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102e93:	6a 00                	push   $0x0
  pushl $66
c0102e95:	6a 42                	push   $0x42
  jmp __alltraps
c0102e97:	e9 8a fd ff ff       	jmp    c0102c26 <__alltraps>

c0102e9c <vector67>:
.globl vector67
vector67:
  pushl $0
c0102e9c:	6a 00                	push   $0x0
  pushl $67
c0102e9e:	6a 43                	push   $0x43
  jmp __alltraps
c0102ea0:	e9 81 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ea5 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102ea5:	6a 00                	push   $0x0
  pushl $68
c0102ea7:	6a 44                	push   $0x44
  jmp __alltraps
c0102ea9:	e9 78 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102eae <vector69>:
.globl vector69
vector69:
  pushl $0
c0102eae:	6a 00                	push   $0x0
  pushl $69
c0102eb0:	6a 45                	push   $0x45
  jmp __alltraps
c0102eb2:	e9 6f fd ff ff       	jmp    c0102c26 <__alltraps>

c0102eb7 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102eb7:	6a 00                	push   $0x0
  pushl $70
c0102eb9:	6a 46                	push   $0x46
  jmp __alltraps
c0102ebb:	e9 66 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ec0 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102ec0:	6a 00                	push   $0x0
  pushl $71
c0102ec2:	6a 47                	push   $0x47
  jmp __alltraps
c0102ec4:	e9 5d fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ec9 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102ec9:	6a 00                	push   $0x0
  pushl $72
c0102ecb:	6a 48                	push   $0x48
  jmp __alltraps
c0102ecd:	e9 54 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ed2 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ed2:	6a 00                	push   $0x0
  pushl $73
c0102ed4:	6a 49                	push   $0x49
  jmp __alltraps
c0102ed6:	e9 4b fd ff ff       	jmp    c0102c26 <__alltraps>

c0102edb <vector74>:
.globl vector74
vector74:
  pushl $0
c0102edb:	6a 00                	push   $0x0
  pushl $74
c0102edd:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102edf:	e9 42 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ee4 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ee4:	6a 00                	push   $0x0
  pushl $75
c0102ee6:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ee8:	e9 39 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102eed <vector76>:
.globl vector76
vector76:
  pushl $0
c0102eed:	6a 00                	push   $0x0
  pushl $76
c0102eef:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102ef1:	e9 30 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102ef6 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102ef6:	6a 00                	push   $0x0
  pushl $77
c0102ef8:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102efa:	e9 27 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102eff <vector78>:
.globl vector78
vector78:
  pushl $0
c0102eff:	6a 00                	push   $0x0
  pushl $78
c0102f01:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102f03:	e9 1e fd ff ff       	jmp    c0102c26 <__alltraps>

c0102f08 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102f08:	6a 00                	push   $0x0
  pushl $79
c0102f0a:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102f0c:	e9 15 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102f11 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102f11:	6a 00                	push   $0x0
  pushl $80
c0102f13:	6a 50                	push   $0x50
  jmp __alltraps
c0102f15:	e9 0c fd ff ff       	jmp    c0102c26 <__alltraps>

c0102f1a <vector81>:
.globl vector81
vector81:
  pushl $0
c0102f1a:	6a 00                	push   $0x0
  pushl $81
c0102f1c:	6a 51                	push   $0x51
  jmp __alltraps
c0102f1e:	e9 03 fd ff ff       	jmp    c0102c26 <__alltraps>

c0102f23 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102f23:	6a 00                	push   $0x0
  pushl $82
c0102f25:	6a 52                	push   $0x52
  jmp __alltraps
c0102f27:	e9 fa fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f2c <vector83>:
.globl vector83
vector83:
  pushl $0
c0102f2c:	6a 00                	push   $0x0
  pushl $83
c0102f2e:	6a 53                	push   $0x53
  jmp __alltraps
c0102f30:	e9 f1 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f35 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102f35:	6a 00                	push   $0x0
  pushl $84
c0102f37:	6a 54                	push   $0x54
  jmp __alltraps
c0102f39:	e9 e8 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f3e <vector85>:
.globl vector85
vector85:
  pushl $0
c0102f3e:	6a 00                	push   $0x0
  pushl $85
c0102f40:	6a 55                	push   $0x55
  jmp __alltraps
c0102f42:	e9 df fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f47 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102f47:	6a 00                	push   $0x0
  pushl $86
c0102f49:	6a 56                	push   $0x56
  jmp __alltraps
c0102f4b:	e9 d6 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f50 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102f50:	6a 00                	push   $0x0
  pushl $87
c0102f52:	6a 57                	push   $0x57
  jmp __alltraps
c0102f54:	e9 cd fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f59 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102f59:	6a 00                	push   $0x0
  pushl $88
c0102f5b:	6a 58                	push   $0x58
  jmp __alltraps
c0102f5d:	e9 c4 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f62 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102f62:	6a 00                	push   $0x0
  pushl $89
c0102f64:	6a 59                	push   $0x59
  jmp __alltraps
c0102f66:	e9 bb fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f6b <vector90>:
.globl vector90
vector90:
  pushl $0
c0102f6b:	6a 00                	push   $0x0
  pushl $90
c0102f6d:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102f6f:	e9 b2 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f74 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102f74:	6a 00                	push   $0x0
  pushl $91
c0102f76:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102f78:	e9 a9 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f7d <vector92>:
.globl vector92
vector92:
  pushl $0
c0102f7d:	6a 00                	push   $0x0
  pushl $92
c0102f7f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102f81:	e9 a0 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f86 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102f86:	6a 00                	push   $0x0
  pushl $93
c0102f88:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102f8a:	e9 97 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f8f <vector94>:
.globl vector94
vector94:
  pushl $0
c0102f8f:	6a 00                	push   $0x0
  pushl $94
c0102f91:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102f93:	e9 8e fc ff ff       	jmp    c0102c26 <__alltraps>

c0102f98 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102f98:	6a 00                	push   $0x0
  pushl $95
c0102f9a:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102f9c:	e9 85 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fa1 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102fa1:	6a 00                	push   $0x0
  pushl $96
c0102fa3:	6a 60                	push   $0x60
  jmp __alltraps
c0102fa5:	e9 7c fc ff ff       	jmp    c0102c26 <__alltraps>

c0102faa <vector97>:
.globl vector97
vector97:
  pushl $0
c0102faa:	6a 00                	push   $0x0
  pushl $97
c0102fac:	6a 61                	push   $0x61
  jmp __alltraps
c0102fae:	e9 73 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fb3 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102fb3:	6a 00                	push   $0x0
  pushl $98
c0102fb5:	6a 62                	push   $0x62
  jmp __alltraps
c0102fb7:	e9 6a fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fbc <vector99>:
.globl vector99
vector99:
  pushl $0
c0102fbc:	6a 00                	push   $0x0
  pushl $99
c0102fbe:	6a 63                	push   $0x63
  jmp __alltraps
c0102fc0:	e9 61 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fc5 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102fc5:	6a 00                	push   $0x0
  pushl $100
c0102fc7:	6a 64                	push   $0x64
  jmp __alltraps
c0102fc9:	e9 58 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fce <vector101>:
.globl vector101
vector101:
  pushl $0
c0102fce:	6a 00                	push   $0x0
  pushl $101
c0102fd0:	6a 65                	push   $0x65
  jmp __alltraps
c0102fd2:	e9 4f fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fd7 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102fd7:	6a 00                	push   $0x0
  pushl $102
c0102fd9:	6a 66                	push   $0x66
  jmp __alltraps
c0102fdb:	e9 46 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fe0 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102fe0:	6a 00                	push   $0x0
  pushl $103
c0102fe2:	6a 67                	push   $0x67
  jmp __alltraps
c0102fe4:	e9 3d fc ff ff       	jmp    c0102c26 <__alltraps>

c0102fe9 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102fe9:	6a 00                	push   $0x0
  pushl $104
c0102feb:	6a 68                	push   $0x68
  jmp __alltraps
c0102fed:	e9 34 fc ff ff       	jmp    c0102c26 <__alltraps>

c0102ff2 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102ff2:	6a 00                	push   $0x0
  pushl $105
c0102ff4:	6a 69                	push   $0x69
  jmp __alltraps
c0102ff6:	e9 2b fc ff ff       	jmp    c0102c26 <__alltraps>

c0102ffb <vector106>:
.globl vector106
vector106:
  pushl $0
c0102ffb:	6a 00                	push   $0x0
  pushl $106
c0102ffd:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102fff:	e9 22 fc ff ff       	jmp    c0102c26 <__alltraps>

c0103004 <vector107>:
.globl vector107
vector107:
  pushl $0
c0103004:	6a 00                	push   $0x0
  pushl $107
c0103006:	6a 6b                	push   $0x6b
  jmp __alltraps
c0103008:	e9 19 fc ff ff       	jmp    c0102c26 <__alltraps>

c010300d <vector108>:
.globl vector108
vector108:
  pushl $0
c010300d:	6a 00                	push   $0x0
  pushl $108
c010300f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0103011:	e9 10 fc ff ff       	jmp    c0102c26 <__alltraps>

c0103016 <vector109>:
.globl vector109
vector109:
  pushl $0
c0103016:	6a 00                	push   $0x0
  pushl $109
c0103018:	6a 6d                	push   $0x6d
  jmp __alltraps
c010301a:	e9 07 fc ff ff       	jmp    c0102c26 <__alltraps>

c010301f <vector110>:
.globl vector110
vector110:
  pushl $0
c010301f:	6a 00                	push   $0x0
  pushl $110
c0103021:	6a 6e                	push   $0x6e
  jmp __alltraps
c0103023:	e9 fe fb ff ff       	jmp    c0102c26 <__alltraps>

c0103028 <vector111>:
.globl vector111
vector111:
  pushl $0
c0103028:	6a 00                	push   $0x0
  pushl $111
c010302a:	6a 6f                	push   $0x6f
  jmp __alltraps
c010302c:	e9 f5 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103031 <vector112>:
.globl vector112
vector112:
  pushl $0
c0103031:	6a 00                	push   $0x0
  pushl $112
c0103033:	6a 70                	push   $0x70
  jmp __alltraps
c0103035:	e9 ec fb ff ff       	jmp    c0102c26 <__alltraps>

c010303a <vector113>:
.globl vector113
vector113:
  pushl $0
c010303a:	6a 00                	push   $0x0
  pushl $113
c010303c:	6a 71                	push   $0x71
  jmp __alltraps
c010303e:	e9 e3 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103043 <vector114>:
.globl vector114
vector114:
  pushl $0
c0103043:	6a 00                	push   $0x0
  pushl $114
c0103045:	6a 72                	push   $0x72
  jmp __alltraps
c0103047:	e9 da fb ff ff       	jmp    c0102c26 <__alltraps>

c010304c <vector115>:
.globl vector115
vector115:
  pushl $0
c010304c:	6a 00                	push   $0x0
  pushl $115
c010304e:	6a 73                	push   $0x73
  jmp __alltraps
c0103050:	e9 d1 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103055 <vector116>:
.globl vector116
vector116:
  pushl $0
c0103055:	6a 00                	push   $0x0
  pushl $116
c0103057:	6a 74                	push   $0x74
  jmp __alltraps
c0103059:	e9 c8 fb ff ff       	jmp    c0102c26 <__alltraps>

c010305e <vector117>:
.globl vector117
vector117:
  pushl $0
c010305e:	6a 00                	push   $0x0
  pushl $117
c0103060:	6a 75                	push   $0x75
  jmp __alltraps
c0103062:	e9 bf fb ff ff       	jmp    c0102c26 <__alltraps>

c0103067 <vector118>:
.globl vector118
vector118:
  pushl $0
c0103067:	6a 00                	push   $0x0
  pushl $118
c0103069:	6a 76                	push   $0x76
  jmp __alltraps
c010306b:	e9 b6 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103070 <vector119>:
.globl vector119
vector119:
  pushl $0
c0103070:	6a 00                	push   $0x0
  pushl $119
c0103072:	6a 77                	push   $0x77
  jmp __alltraps
c0103074:	e9 ad fb ff ff       	jmp    c0102c26 <__alltraps>

c0103079 <vector120>:
.globl vector120
vector120:
  pushl $0
c0103079:	6a 00                	push   $0x0
  pushl $120
c010307b:	6a 78                	push   $0x78
  jmp __alltraps
c010307d:	e9 a4 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103082 <vector121>:
.globl vector121
vector121:
  pushl $0
c0103082:	6a 00                	push   $0x0
  pushl $121
c0103084:	6a 79                	push   $0x79
  jmp __alltraps
c0103086:	e9 9b fb ff ff       	jmp    c0102c26 <__alltraps>

c010308b <vector122>:
.globl vector122
vector122:
  pushl $0
c010308b:	6a 00                	push   $0x0
  pushl $122
c010308d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010308f:	e9 92 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103094 <vector123>:
.globl vector123
vector123:
  pushl $0
c0103094:	6a 00                	push   $0x0
  pushl $123
c0103096:	6a 7b                	push   $0x7b
  jmp __alltraps
c0103098:	e9 89 fb ff ff       	jmp    c0102c26 <__alltraps>

c010309d <vector124>:
.globl vector124
vector124:
  pushl $0
c010309d:	6a 00                	push   $0x0
  pushl $124
c010309f:	6a 7c                	push   $0x7c
  jmp __alltraps
c01030a1:	e9 80 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030a6 <vector125>:
.globl vector125
vector125:
  pushl $0
c01030a6:	6a 00                	push   $0x0
  pushl $125
c01030a8:	6a 7d                	push   $0x7d
  jmp __alltraps
c01030aa:	e9 77 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030af <vector126>:
.globl vector126
vector126:
  pushl $0
c01030af:	6a 00                	push   $0x0
  pushl $126
c01030b1:	6a 7e                	push   $0x7e
  jmp __alltraps
c01030b3:	e9 6e fb ff ff       	jmp    c0102c26 <__alltraps>

c01030b8 <vector127>:
.globl vector127
vector127:
  pushl $0
c01030b8:	6a 00                	push   $0x0
  pushl $127
c01030ba:	6a 7f                	push   $0x7f
  jmp __alltraps
c01030bc:	e9 65 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030c1 <vector128>:
.globl vector128
vector128:
  pushl $0
c01030c1:	6a 00                	push   $0x0
  pushl $128
c01030c3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01030c8:	e9 59 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030cd <vector129>:
.globl vector129
vector129:
  pushl $0
c01030cd:	6a 00                	push   $0x0
  pushl $129
c01030cf:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01030d4:	e9 4d fb ff ff       	jmp    c0102c26 <__alltraps>

c01030d9 <vector130>:
.globl vector130
vector130:
  pushl $0
c01030d9:	6a 00                	push   $0x0
  pushl $130
c01030db:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01030e0:	e9 41 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030e5 <vector131>:
.globl vector131
vector131:
  pushl $0
c01030e5:	6a 00                	push   $0x0
  pushl $131
c01030e7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01030ec:	e9 35 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030f1 <vector132>:
.globl vector132
vector132:
  pushl $0
c01030f1:	6a 00                	push   $0x0
  pushl $132
c01030f3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01030f8:	e9 29 fb ff ff       	jmp    c0102c26 <__alltraps>

c01030fd <vector133>:
.globl vector133
vector133:
  pushl $0
c01030fd:	6a 00                	push   $0x0
  pushl $133
c01030ff:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0103104:	e9 1d fb ff ff       	jmp    c0102c26 <__alltraps>

c0103109 <vector134>:
.globl vector134
vector134:
  pushl $0
c0103109:	6a 00                	push   $0x0
  pushl $134
c010310b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0103110:	e9 11 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103115 <vector135>:
.globl vector135
vector135:
  pushl $0
c0103115:	6a 00                	push   $0x0
  pushl $135
c0103117:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010311c:	e9 05 fb ff ff       	jmp    c0102c26 <__alltraps>

c0103121 <vector136>:
.globl vector136
vector136:
  pushl $0
c0103121:	6a 00                	push   $0x0
  pushl $136
c0103123:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0103128:	e9 f9 fa ff ff       	jmp    c0102c26 <__alltraps>

c010312d <vector137>:
.globl vector137
vector137:
  pushl $0
c010312d:	6a 00                	push   $0x0
  pushl $137
c010312f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0103134:	e9 ed fa ff ff       	jmp    c0102c26 <__alltraps>

c0103139 <vector138>:
.globl vector138
vector138:
  pushl $0
c0103139:	6a 00                	push   $0x0
  pushl $138
c010313b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0103140:	e9 e1 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103145 <vector139>:
.globl vector139
vector139:
  pushl $0
c0103145:	6a 00                	push   $0x0
  pushl $139
c0103147:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010314c:	e9 d5 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103151 <vector140>:
.globl vector140
vector140:
  pushl $0
c0103151:	6a 00                	push   $0x0
  pushl $140
c0103153:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0103158:	e9 c9 fa ff ff       	jmp    c0102c26 <__alltraps>

c010315d <vector141>:
.globl vector141
vector141:
  pushl $0
c010315d:	6a 00                	push   $0x0
  pushl $141
c010315f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0103164:	e9 bd fa ff ff       	jmp    c0102c26 <__alltraps>

c0103169 <vector142>:
.globl vector142
vector142:
  pushl $0
c0103169:	6a 00                	push   $0x0
  pushl $142
c010316b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0103170:	e9 b1 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103175 <vector143>:
.globl vector143
vector143:
  pushl $0
c0103175:	6a 00                	push   $0x0
  pushl $143
c0103177:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010317c:	e9 a5 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103181 <vector144>:
.globl vector144
vector144:
  pushl $0
c0103181:	6a 00                	push   $0x0
  pushl $144
c0103183:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0103188:	e9 99 fa ff ff       	jmp    c0102c26 <__alltraps>

c010318d <vector145>:
.globl vector145
vector145:
  pushl $0
c010318d:	6a 00                	push   $0x0
  pushl $145
c010318f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0103194:	e9 8d fa ff ff       	jmp    c0102c26 <__alltraps>

c0103199 <vector146>:
.globl vector146
vector146:
  pushl $0
c0103199:	6a 00                	push   $0x0
  pushl $146
c010319b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01031a0:	e9 81 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031a5 <vector147>:
.globl vector147
vector147:
  pushl $0
c01031a5:	6a 00                	push   $0x0
  pushl $147
c01031a7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01031ac:	e9 75 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031b1 <vector148>:
.globl vector148
vector148:
  pushl $0
c01031b1:	6a 00                	push   $0x0
  pushl $148
c01031b3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01031b8:	e9 69 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031bd <vector149>:
.globl vector149
vector149:
  pushl $0
c01031bd:	6a 00                	push   $0x0
  pushl $149
c01031bf:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01031c4:	e9 5d fa ff ff       	jmp    c0102c26 <__alltraps>

c01031c9 <vector150>:
.globl vector150
vector150:
  pushl $0
c01031c9:	6a 00                	push   $0x0
  pushl $150
c01031cb:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01031d0:	e9 51 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031d5 <vector151>:
.globl vector151
vector151:
  pushl $0
c01031d5:	6a 00                	push   $0x0
  pushl $151
c01031d7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01031dc:	e9 45 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031e1 <vector152>:
.globl vector152
vector152:
  pushl $0
c01031e1:	6a 00                	push   $0x0
  pushl $152
c01031e3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01031e8:	e9 39 fa ff ff       	jmp    c0102c26 <__alltraps>

c01031ed <vector153>:
.globl vector153
vector153:
  pushl $0
c01031ed:	6a 00                	push   $0x0
  pushl $153
c01031ef:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01031f4:	e9 2d fa ff ff       	jmp    c0102c26 <__alltraps>

c01031f9 <vector154>:
.globl vector154
vector154:
  pushl $0
c01031f9:	6a 00                	push   $0x0
  pushl $154
c01031fb:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0103200:	e9 21 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103205 <vector155>:
.globl vector155
vector155:
  pushl $0
c0103205:	6a 00                	push   $0x0
  pushl $155
c0103207:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010320c:	e9 15 fa ff ff       	jmp    c0102c26 <__alltraps>

c0103211 <vector156>:
.globl vector156
vector156:
  pushl $0
c0103211:	6a 00                	push   $0x0
  pushl $156
c0103213:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0103218:	e9 09 fa ff ff       	jmp    c0102c26 <__alltraps>

c010321d <vector157>:
.globl vector157
vector157:
  pushl $0
c010321d:	6a 00                	push   $0x0
  pushl $157
c010321f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0103224:	e9 fd f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103229 <vector158>:
.globl vector158
vector158:
  pushl $0
c0103229:	6a 00                	push   $0x0
  pushl $158
c010322b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0103230:	e9 f1 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103235 <vector159>:
.globl vector159
vector159:
  pushl $0
c0103235:	6a 00                	push   $0x0
  pushl $159
c0103237:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010323c:	e9 e5 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103241 <vector160>:
.globl vector160
vector160:
  pushl $0
c0103241:	6a 00                	push   $0x0
  pushl $160
c0103243:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0103248:	e9 d9 f9 ff ff       	jmp    c0102c26 <__alltraps>

c010324d <vector161>:
.globl vector161
vector161:
  pushl $0
c010324d:	6a 00                	push   $0x0
  pushl $161
c010324f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0103254:	e9 cd f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103259 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103259:	6a 00                	push   $0x0
  pushl $162
c010325b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0103260:	e9 c1 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103265 <vector163>:
.globl vector163
vector163:
  pushl $0
c0103265:	6a 00                	push   $0x0
  pushl $163
c0103267:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010326c:	e9 b5 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103271 <vector164>:
.globl vector164
vector164:
  pushl $0
c0103271:	6a 00                	push   $0x0
  pushl $164
c0103273:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0103278:	e9 a9 f9 ff ff       	jmp    c0102c26 <__alltraps>

c010327d <vector165>:
.globl vector165
vector165:
  pushl $0
c010327d:	6a 00                	push   $0x0
  pushl $165
c010327f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0103284:	e9 9d f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103289 <vector166>:
.globl vector166
vector166:
  pushl $0
c0103289:	6a 00                	push   $0x0
  pushl $166
c010328b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0103290:	e9 91 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103295 <vector167>:
.globl vector167
vector167:
  pushl $0
c0103295:	6a 00                	push   $0x0
  pushl $167
c0103297:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010329c:	e9 85 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032a1 <vector168>:
.globl vector168
vector168:
  pushl $0
c01032a1:	6a 00                	push   $0x0
  pushl $168
c01032a3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01032a8:	e9 79 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032ad <vector169>:
.globl vector169
vector169:
  pushl $0
c01032ad:	6a 00                	push   $0x0
  pushl $169
c01032af:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01032b4:	e9 6d f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032b9 <vector170>:
.globl vector170
vector170:
  pushl $0
c01032b9:	6a 00                	push   $0x0
  pushl $170
c01032bb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01032c0:	e9 61 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032c5 <vector171>:
.globl vector171
vector171:
  pushl $0
c01032c5:	6a 00                	push   $0x0
  pushl $171
c01032c7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01032cc:	e9 55 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032d1 <vector172>:
.globl vector172
vector172:
  pushl $0
c01032d1:	6a 00                	push   $0x0
  pushl $172
c01032d3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01032d8:	e9 49 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032dd <vector173>:
.globl vector173
vector173:
  pushl $0
c01032dd:	6a 00                	push   $0x0
  pushl $173
c01032df:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01032e4:	e9 3d f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032e9 <vector174>:
.globl vector174
vector174:
  pushl $0
c01032e9:	6a 00                	push   $0x0
  pushl $174
c01032eb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01032f0:	e9 31 f9 ff ff       	jmp    c0102c26 <__alltraps>

c01032f5 <vector175>:
.globl vector175
vector175:
  pushl $0
c01032f5:	6a 00                	push   $0x0
  pushl $175
c01032f7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01032fc:	e9 25 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103301 <vector176>:
.globl vector176
vector176:
  pushl $0
c0103301:	6a 00                	push   $0x0
  pushl $176
c0103303:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0103308:	e9 19 f9 ff ff       	jmp    c0102c26 <__alltraps>

c010330d <vector177>:
.globl vector177
vector177:
  pushl $0
c010330d:	6a 00                	push   $0x0
  pushl $177
c010330f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0103314:	e9 0d f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103319 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103319:	6a 00                	push   $0x0
  pushl $178
c010331b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0103320:	e9 01 f9 ff ff       	jmp    c0102c26 <__alltraps>

c0103325 <vector179>:
.globl vector179
vector179:
  pushl $0
c0103325:	6a 00                	push   $0x0
  pushl $179
c0103327:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010332c:	e9 f5 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103331 <vector180>:
.globl vector180
vector180:
  pushl $0
c0103331:	6a 00                	push   $0x0
  pushl $180
c0103333:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0103338:	e9 e9 f8 ff ff       	jmp    c0102c26 <__alltraps>

c010333d <vector181>:
.globl vector181
vector181:
  pushl $0
c010333d:	6a 00                	push   $0x0
  pushl $181
c010333f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0103344:	e9 dd f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103349 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103349:	6a 00                	push   $0x0
  pushl $182
c010334b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103350:	e9 d1 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103355 <vector183>:
.globl vector183
vector183:
  pushl $0
c0103355:	6a 00                	push   $0x0
  pushl $183
c0103357:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010335c:	e9 c5 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103361 <vector184>:
.globl vector184
vector184:
  pushl $0
c0103361:	6a 00                	push   $0x0
  pushl $184
c0103363:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0103368:	e9 b9 f8 ff ff       	jmp    c0102c26 <__alltraps>

c010336d <vector185>:
.globl vector185
vector185:
  pushl $0
c010336d:	6a 00                	push   $0x0
  pushl $185
c010336f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0103374:	e9 ad f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103379 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103379:	6a 00                	push   $0x0
  pushl $186
c010337b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0103380:	e9 a1 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103385 <vector187>:
.globl vector187
vector187:
  pushl $0
c0103385:	6a 00                	push   $0x0
  pushl $187
c0103387:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010338c:	e9 95 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103391 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103391:	6a 00                	push   $0x0
  pushl $188
c0103393:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0103398:	e9 89 f8 ff ff       	jmp    c0102c26 <__alltraps>

c010339d <vector189>:
.globl vector189
vector189:
  pushl $0
c010339d:	6a 00                	push   $0x0
  pushl $189
c010339f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01033a4:	e9 7d f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033a9 <vector190>:
.globl vector190
vector190:
  pushl $0
c01033a9:	6a 00                	push   $0x0
  pushl $190
c01033ab:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01033b0:	e9 71 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033b5 <vector191>:
.globl vector191
vector191:
  pushl $0
c01033b5:	6a 00                	push   $0x0
  pushl $191
c01033b7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01033bc:	e9 65 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033c1 <vector192>:
.globl vector192
vector192:
  pushl $0
c01033c1:	6a 00                	push   $0x0
  pushl $192
c01033c3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01033c8:	e9 59 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033cd <vector193>:
.globl vector193
vector193:
  pushl $0
c01033cd:	6a 00                	push   $0x0
  pushl $193
c01033cf:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01033d4:	e9 4d f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033d9 <vector194>:
.globl vector194
vector194:
  pushl $0
c01033d9:	6a 00                	push   $0x0
  pushl $194
c01033db:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01033e0:	e9 41 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033e5 <vector195>:
.globl vector195
vector195:
  pushl $0
c01033e5:	6a 00                	push   $0x0
  pushl $195
c01033e7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01033ec:	e9 35 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033f1 <vector196>:
.globl vector196
vector196:
  pushl $0
c01033f1:	6a 00                	push   $0x0
  pushl $196
c01033f3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01033f8:	e9 29 f8 ff ff       	jmp    c0102c26 <__alltraps>

c01033fd <vector197>:
.globl vector197
vector197:
  pushl $0
c01033fd:	6a 00                	push   $0x0
  pushl $197
c01033ff:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103404:	e9 1d f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103409 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103409:	6a 00                	push   $0x0
  pushl $198
c010340b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103410:	e9 11 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103415 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103415:	6a 00                	push   $0x0
  pushl $199
c0103417:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010341c:	e9 05 f8 ff ff       	jmp    c0102c26 <__alltraps>

c0103421 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103421:	6a 00                	push   $0x0
  pushl $200
c0103423:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103428:	e9 f9 f7 ff ff       	jmp    c0102c26 <__alltraps>

c010342d <vector201>:
.globl vector201
vector201:
  pushl $0
c010342d:	6a 00                	push   $0x0
  pushl $201
c010342f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103434:	e9 ed f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103439 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103439:	6a 00                	push   $0x0
  pushl $202
c010343b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103440:	e9 e1 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103445 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103445:	6a 00                	push   $0x0
  pushl $203
c0103447:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010344c:	e9 d5 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103451 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103451:	6a 00                	push   $0x0
  pushl $204
c0103453:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103458:	e9 c9 f7 ff ff       	jmp    c0102c26 <__alltraps>

c010345d <vector205>:
.globl vector205
vector205:
  pushl $0
c010345d:	6a 00                	push   $0x0
  pushl $205
c010345f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103464:	e9 bd f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103469 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103469:	6a 00                	push   $0x0
  pushl $206
c010346b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103470:	e9 b1 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103475 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103475:	6a 00                	push   $0x0
  pushl $207
c0103477:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010347c:	e9 a5 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103481 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103481:	6a 00                	push   $0x0
  pushl $208
c0103483:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103488:	e9 99 f7 ff ff       	jmp    c0102c26 <__alltraps>

c010348d <vector209>:
.globl vector209
vector209:
  pushl $0
c010348d:	6a 00                	push   $0x0
  pushl $209
c010348f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103494:	e9 8d f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103499 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103499:	6a 00                	push   $0x0
  pushl $210
c010349b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01034a0:	e9 81 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034a5 <vector211>:
.globl vector211
vector211:
  pushl $0
c01034a5:	6a 00                	push   $0x0
  pushl $211
c01034a7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01034ac:	e9 75 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034b1 <vector212>:
.globl vector212
vector212:
  pushl $0
c01034b1:	6a 00                	push   $0x0
  pushl $212
c01034b3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01034b8:	e9 69 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034bd <vector213>:
.globl vector213
vector213:
  pushl $0
c01034bd:	6a 00                	push   $0x0
  pushl $213
c01034bf:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01034c4:	e9 5d f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034c9 <vector214>:
.globl vector214
vector214:
  pushl $0
c01034c9:	6a 00                	push   $0x0
  pushl $214
c01034cb:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01034d0:	e9 51 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034d5 <vector215>:
.globl vector215
vector215:
  pushl $0
c01034d5:	6a 00                	push   $0x0
  pushl $215
c01034d7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01034dc:	e9 45 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034e1 <vector216>:
.globl vector216
vector216:
  pushl $0
c01034e1:	6a 00                	push   $0x0
  pushl $216
c01034e3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01034e8:	e9 39 f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034ed <vector217>:
.globl vector217
vector217:
  pushl $0
c01034ed:	6a 00                	push   $0x0
  pushl $217
c01034ef:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01034f4:	e9 2d f7 ff ff       	jmp    c0102c26 <__alltraps>

c01034f9 <vector218>:
.globl vector218
vector218:
  pushl $0
c01034f9:	6a 00                	push   $0x0
  pushl $218
c01034fb:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103500:	e9 21 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103505 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103505:	6a 00                	push   $0x0
  pushl $219
c0103507:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010350c:	e9 15 f7 ff ff       	jmp    c0102c26 <__alltraps>

c0103511 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103511:	6a 00                	push   $0x0
  pushl $220
c0103513:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103518:	e9 09 f7 ff ff       	jmp    c0102c26 <__alltraps>

c010351d <vector221>:
.globl vector221
vector221:
  pushl $0
c010351d:	6a 00                	push   $0x0
  pushl $221
c010351f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103524:	e9 fd f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103529 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103529:	6a 00                	push   $0x0
  pushl $222
c010352b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103530:	e9 f1 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103535 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103535:	6a 00                	push   $0x0
  pushl $223
c0103537:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010353c:	e9 e5 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103541 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103541:	6a 00                	push   $0x0
  pushl $224
c0103543:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103548:	e9 d9 f6 ff ff       	jmp    c0102c26 <__alltraps>

c010354d <vector225>:
.globl vector225
vector225:
  pushl $0
c010354d:	6a 00                	push   $0x0
  pushl $225
c010354f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103554:	e9 cd f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103559 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103559:	6a 00                	push   $0x0
  pushl $226
c010355b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103560:	e9 c1 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103565 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103565:	6a 00                	push   $0x0
  pushl $227
c0103567:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010356c:	e9 b5 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103571 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103571:	6a 00                	push   $0x0
  pushl $228
c0103573:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103578:	e9 a9 f6 ff ff       	jmp    c0102c26 <__alltraps>

c010357d <vector229>:
.globl vector229
vector229:
  pushl $0
c010357d:	6a 00                	push   $0x0
  pushl $229
c010357f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103584:	e9 9d f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103589 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103589:	6a 00                	push   $0x0
  pushl $230
c010358b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103590:	e9 91 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103595 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103595:	6a 00                	push   $0x0
  pushl $231
c0103597:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010359c:	e9 85 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035a1 <vector232>:
.globl vector232
vector232:
  pushl $0
c01035a1:	6a 00                	push   $0x0
  pushl $232
c01035a3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01035a8:	e9 79 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035ad <vector233>:
.globl vector233
vector233:
  pushl $0
c01035ad:	6a 00                	push   $0x0
  pushl $233
c01035af:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01035b4:	e9 6d f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035b9 <vector234>:
.globl vector234
vector234:
  pushl $0
c01035b9:	6a 00                	push   $0x0
  pushl $234
c01035bb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01035c0:	e9 61 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035c5 <vector235>:
.globl vector235
vector235:
  pushl $0
c01035c5:	6a 00                	push   $0x0
  pushl $235
c01035c7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01035cc:	e9 55 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035d1 <vector236>:
.globl vector236
vector236:
  pushl $0
c01035d1:	6a 00                	push   $0x0
  pushl $236
c01035d3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01035d8:	e9 49 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035dd <vector237>:
.globl vector237
vector237:
  pushl $0
c01035dd:	6a 00                	push   $0x0
  pushl $237
c01035df:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01035e4:	e9 3d f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035e9 <vector238>:
.globl vector238
vector238:
  pushl $0
c01035e9:	6a 00                	push   $0x0
  pushl $238
c01035eb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01035f0:	e9 31 f6 ff ff       	jmp    c0102c26 <__alltraps>

c01035f5 <vector239>:
.globl vector239
vector239:
  pushl $0
c01035f5:	6a 00                	push   $0x0
  pushl $239
c01035f7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01035fc:	e9 25 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103601 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103601:	6a 00                	push   $0x0
  pushl $240
c0103603:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103608:	e9 19 f6 ff ff       	jmp    c0102c26 <__alltraps>

c010360d <vector241>:
.globl vector241
vector241:
  pushl $0
c010360d:	6a 00                	push   $0x0
  pushl $241
c010360f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103614:	e9 0d f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103619 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103619:	6a 00                	push   $0x0
  pushl $242
c010361b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103620:	e9 01 f6 ff ff       	jmp    c0102c26 <__alltraps>

c0103625 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103625:	6a 00                	push   $0x0
  pushl $243
c0103627:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010362c:	e9 f5 f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103631 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103631:	6a 00                	push   $0x0
  pushl $244
c0103633:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103638:	e9 e9 f5 ff ff       	jmp    c0102c26 <__alltraps>

c010363d <vector245>:
.globl vector245
vector245:
  pushl $0
c010363d:	6a 00                	push   $0x0
  pushl $245
c010363f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103644:	e9 dd f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103649 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103649:	6a 00                	push   $0x0
  pushl $246
c010364b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103650:	e9 d1 f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103655 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103655:	6a 00                	push   $0x0
  pushl $247
c0103657:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010365c:	e9 c5 f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103661 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103661:	6a 00                	push   $0x0
  pushl $248
c0103663:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103668:	e9 b9 f5 ff ff       	jmp    c0102c26 <__alltraps>

c010366d <vector249>:
.globl vector249
vector249:
  pushl $0
c010366d:	6a 00                	push   $0x0
  pushl $249
c010366f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103674:	e9 ad f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103679 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103679:	6a 00                	push   $0x0
  pushl $250
c010367b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103680:	e9 a1 f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103685 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103685:	6a 00                	push   $0x0
  pushl $251
c0103687:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010368c:	e9 95 f5 ff ff       	jmp    c0102c26 <__alltraps>

c0103691 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103691:	6a 00                	push   $0x0
  pushl $252
c0103693:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103698:	e9 89 f5 ff ff       	jmp    c0102c26 <__alltraps>

c010369d <vector253>:
.globl vector253
vector253:
  pushl $0
c010369d:	6a 00                	push   $0x0
  pushl $253
c010369f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01036a4:	e9 7d f5 ff ff       	jmp    c0102c26 <__alltraps>

c01036a9 <vector254>:
.globl vector254
vector254:
  pushl $0
c01036a9:	6a 00                	push   $0x0
  pushl $254
c01036ab:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01036b0:	e9 71 f5 ff ff       	jmp    c0102c26 <__alltraps>

c01036b5 <vector255>:
.globl vector255
vector255:
  pushl $0
c01036b5:	6a 00                	push   $0x0
  pushl $255
c01036b7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01036bc:	e9 65 f5 ff ff       	jmp    c0102c26 <__alltraps>

c01036c1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01036c1:	55                   	push   %ebp
c01036c2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01036c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01036c7:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01036cc:	29 c2                	sub    %eax,%edx
c01036ce:	89 d0                	mov    %edx,%eax
c01036d0:	c1 f8 05             	sar    $0x5,%eax
}
c01036d3:	5d                   	pop    %ebp
c01036d4:	c3                   	ret    

c01036d5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01036d5:	55                   	push   %ebp
c01036d6:	89 e5                	mov    %esp,%ebp
c01036d8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01036db:	8b 45 08             	mov    0x8(%ebp),%eax
c01036de:	89 04 24             	mov    %eax,(%esp)
c01036e1:	e8 db ff ff ff       	call   c01036c1 <page2ppn>
c01036e6:	c1 e0 0c             	shl    $0xc,%eax
}
c01036e9:	c9                   	leave  
c01036ea:	c3                   	ret    

c01036eb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01036eb:	55                   	push   %ebp
c01036ec:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01036ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f1:	8b 00                	mov    (%eax),%eax
}
c01036f3:	5d                   	pop    %ebp
c01036f4:	c3                   	ret    

c01036f5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01036f5:	55                   	push   %ebp
c01036f6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01036f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036fe:	89 10                	mov    %edx,(%eax)
}
c0103700:	5d                   	pop    %ebp
c0103701:	c3                   	ret    

c0103702 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103702:	55                   	push   %ebp
c0103703:	89 e5                	mov    %esp,%ebp
c0103705:	83 ec 10             	sub    $0x10,%esp
c0103708:	c7 45 fc b8 ef 19 c0 	movl   $0xc019efb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010370f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103712:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103715:	89 50 04             	mov    %edx,0x4(%eax)
c0103718:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010371b:	8b 50 04             	mov    0x4(%eax),%edx
c010371e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103721:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103723:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c010372a:	00 00 00 
}
c010372d:	c9                   	leave  
c010372e:	c3                   	ret    

c010372f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010372f:	55                   	push   %ebp
c0103730:	89 e5                	mov    %esp,%ebp
c0103732:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
c0103735:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103739:	75 24                	jne    c010375f <default_init_memmap+0x30>
c010373b:	c7 44 24 0c b0 c8 10 	movl   $0xc010c8b0,0xc(%esp)
c0103742:	c0 
c0103743:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010374a:	c0 
c010374b:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103752:	00 
c0103753:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c010375a:	e8 70 d6 ff ff       	call   c0100dcf <__panic>
	struct Page *p = base;
c010375f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103762:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
c0103765:	e9 ef 00 00 00       	jmp    c0103859 <default_init_memmap+0x12a>
		assert(PageReserved(p));
c010376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376d:	83 c0 04             	add    $0x4,%eax
c0103770:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103777:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010377a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010377d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103780:	0f a3 10             	bt     %edx,(%eax)
c0103783:	19 c0                	sbb    %eax,%eax
c0103785:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103788:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010378c:	0f 95 c0             	setne  %al
c010378f:	0f b6 c0             	movzbl %al,%eax
c0103792:	85 c0                	test   %eax,%eax
c0103794:	75 24                	jne    c01037ba <default_init_memmap+0x8b>
c0103796:	c7 44 24 0c e1 c8 10 	movl   $0xc010c8e1,0xc(%esp)
c010379d:	c0 
c010379e:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01037a5:	c0 
c01037a6:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01037ad:	00 
c01037ae:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01037b5:	e8 15 d6 ff ff       	call   c0100dcf <__panic>
		p->flags = 0;
c01037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c01037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c7:	83 c0 04             	add    $0x4,%eax
c01037ca:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01037d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01037da:	0f ab 10             	bts    %edx,(%eax)
		if(p == base)
c01037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037e3:	75 0b                	jne    c01037f0 <default_init_memmap+0xc1>
		{
			p->property = n;
c01037e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01037eb:	89 50 08             	mov    %edx,0x8(%eax)
c01037ee:	eb 0a                	jmp    c01037fa <default_init_memmap+0xcb>
		}
		else
		{
			p->property = 0;
c01037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		}
		set_page_ref(p, 0);
c01037fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103801:	00 
c0103802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103805:	89 04 24             	mov    %eax,(%esp)
c0103808:	e8 e8 fe ff ff       	call   c01036f5 <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
c010380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103810:	83 c0 0c             	add    $0xc,%eax
c0103813:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
c010381a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010381d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103820:	8b 00                	mov    (%eax),%eax
c0103822:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103825:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103828:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010382b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010382e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103831:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103834:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103837:	89 10                	mov    %edx,(%eax)
c0103839:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010383c:	8b 10                	mov    (%eax),%edx
c010383e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103841:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103847:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010384a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010384d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103850:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103853:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
c0103855:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010385c:	c1 e0 05             	shl    $0x5,%eax
c010385f:	89 c2                	mov    %eax,%edx
c0103861:	8b 45 08             	mov    0x8(%ebp),%eax
c0103864:	01 d0                	add    %edx,%eax
c0103866:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103869:	0f 85 fb fe ff ff    	jne    c010376a <default_init_memmap+0x3b>
			p->property = 0;
		}
		set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
	}
	nr_free += n;
c010386f:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103875:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103878:	01 d0                	add    %edx,%eax
c010387a:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
}
c010387f:	c9                   	leave  
c0103880:	c3                   	ret    

c0103881 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103881:	55                   	push   %ebp
c0103882:	89 e5                	mov    %esp,%ebp
c0103884:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c0103887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010388b:	75 24                	jne    c01038b1 <default_alloc_pages+0x30>
c010388d:	c7 44 24 0c b0 c8 10 	movl   $0xc010c8b0,0xc(%esp)
c0103894:	c0 
c0103895:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010389c:	c0 
c010389d:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c01038a4:	00 
c01038a5:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01038ac:	e8 1e d5 ff ff       	call   c0100dcf <__panic>
	if (n > nr_free) {
c01038b1:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01038b6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01038b9:	73 0a                	jae    c01038c5 <default_alloc_pages+0x44>
		return NULL;
c01038bb:	b8 00 00 00 00       	mov    $0x0,%eax
c01038c0:	e9 45 01 00 00       	jmp    c0103a0a <default_alloc_pages+0x189>
	}
	struct Page *page = NULL;
c01038c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	list_entry_t *tmp = NULL;
c01038cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	list_entry_t *le = &free_list;
c01038d3:	c7 45 f4 b8 ef 19 c0 	movl   $0xc019efb8,-0xc(%ebp)
	while ((le = list_next(le)) != &free_list)
c01038da:	e9 0a 01 00 00       	jmp    c01039e9 <default_alloc_pages+0x168>
	{
		struct Page *p = le2page(le, page_link);
c01038df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038e2:	83 e8 0c             	sub    $0xc,%eax
c01038e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (p->property >= n)
c01038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038eb:	8b 40 08             	mov    0x8(%eax),%eax
c01038ee:	3b 45 08             	cmp    0x8(%ebp),%eax
c01038f1:	0f 82 f2 00 00 00    	jb     c01039e9 <default_alloc_pages+0x168>
		{
			int i;
			for(i = 0;i<n;i++)
c01038f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01038fe:	eb 7c                	jmp    c010397c <default_alloc_pages+0xfb>
c0103900:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103903:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103906:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103909:	8b 40 04             	mov    0x4(%eax),%eax
			{
				tmp = list_next(le);
c010390c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				struct Page *pagetmp = le2page(le, page_link);
c010390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103912:	83 e8 0c             	sub    $0xc,%eax
c0103915:	89 45 e0             	mov    %eax,-0x20(%ebp)
				SetPageReserved(pagetmp);
c0103918:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010391b:	83 c0 04             	add    $0x4,%eax
c010391e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0103925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103928:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010392b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010392e:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(pagetmp);
c0103931:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103934:	83 c0 04             	add    $0x4,%eax
c0103937:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010393e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103941:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103944:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103947:	0f b3 10             	btr    %edx,(%eax)
c010394a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010394d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103950:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103953:	8b 40 04             	mov    0x4(%eax),%eax
c0103956:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103959:	8b 12                	mov    (%edx),%edx
c010395b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010395e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103961:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103964:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103967:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010396a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010396d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103970:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = tmp;
c0103972:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103975:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		struct Page *p = le2page(le, page_link);
		if (p->property >= n)
		{
			int i;
			for(i = 0;i<n;i++)
c0103978:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c010397c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010397f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103982:	0f 82 78 ff ff ff    	jb     c0103900 <default_alloc_pages+0x7f>
				SetPageReserved(pagetmp);
				ClearPageProperty(pagetmp);
				list_del(le);
				le = tmp;
			}
			if(p->property > n)
c0103988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010398b:	8b 40 08             	mov    0x8(%eax),%eax
c010398e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103991:	76 12                	jbe    c01039a5 <default_alloc_pages+0x124>
			{
				(le2page(le, page_link)->property) = p->property - n;
c0103993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103996:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010399c:	8b 40 08             	mov    0x8(%eax),%eax
c010399f:	2b 45 08             	sub    0x8(%ebp),%eax
c01039a2:	89 42 08             	mov    %eax,0x8(%edx)
			}
			SetPageReserved(p);
c01039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039a8:	83 c0 04             	add    $0x4,%eax
c01039ab:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c01039b2:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01039b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01039b8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01039bb:	0f ab 10             	bts    %edx,(%eax)
			ClearPageProperty(p);
c01039be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039c1:	83 c0 04             	add    $0x4,%eax
c01039c4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01039cb:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01039ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01039d1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01039d4:	0f b3 10             	btr    %edx,(%eax)
			nr_free -= n;
c01039d7:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01039dc:	2b 45 08             	sub    0x8(%ebp),%eax
c01039df:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
			return p;
c01039e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039e7:	eb 21                	jmp    c0103a0a <default_alloc_pages+0x189>
c01039e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ec:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039ef:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01039f2:	8b 40 04             	mov    0x4(%eax),%eax
		return NULL;
	}
	struct Page *page = NULL;
	list_entry_t *tmp = NULL;
	list_entry_t *le = &free_list;
	while ((le = list_next(le)) != &free_list)
c01039f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01039f8:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c01039ff:	0f 85 da fe ff ff    	jne    c01038df <default_alloc_pages+0x5e>
			ClearPageProperty(p);
			nr_free -= n;
			return p;
		}
	}
	return NULL;
c0103a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a0a:	c9                   	leave  
c0103a0b:	c3                   	ret    

c0103a0c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103a0c:	55                   	push   %ebp
c0103a0d:	89 e5                	mov    %esp,%ebp
c0103a0f:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c0103a12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103a16:	75 24                	jne    c0103a3c <default_free_pages+0x30>
c0103a18:	c7 44 24 0c b0 c8 10 	movl   $0xc010c8b0,0xc(%esp)
c0103a1f:	c0 
c0103a20:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103a27:	c0 
c0103a28:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0103a2f:	00 
c0103a30:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103a37:	e8 93 d3 ff ff       	call   c0100dcf <__panic>
	assert(PageReserved(base));
c0103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3f:	83 c0 04             	add    $0x4,%eax
c0103a42:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0103a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103a52:	0f a3 10             	bt     %edx,(%eax)
c0103a55:	19 c0                	sbb    %eax,%eax
c0103a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0103a5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103a5e:	0f 95 c0             	setne  %al
c0103a61:	0f b6 c0             	movzbl %al,%eax
c0103a64:	85 c0                	test   %eax,%eax
c0103a66:	75 24                	jne    c0103a8c <default_free_pages+0x80>
c0103a68:	c7 44 24 0c f1 c8 10 	movl   $0xc010c8f1,0xc(%esp)
c0103a6f:	c0 
c0103a70:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103a77:	c0 
c0103a78:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0103a7f:	00 
c0103a80:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103a87:	e8 43 d3 ff ff       	call   c0100dcf <__panic>
	list_entry_t *le = &free_list;
c0103a8c:	c7 45 f4 b8 ef 19 c0 	movl   $0xc019efb8,-0xc(%ebp)
	struct Page* p = NULL;
c0103a93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((le = list_next(le)) != &free_list)
c0103a9a:	eb 13                	jmp    c0103aaf <default_free_pages+0xa3>
	{
		p = le2page(le, page_link);
c0103a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a9f:	83 e8 0c             	sub    $0xc,%eax
c0103aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(p > base)
c0103aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103aab:	76 02                	jbe    c0103aaf <default_free_pages+0xa3>
			break;
c0103aad:	eb 18                	jmp    c0103ac7 <default_free_pages+0xbb>
c0103aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103ab5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ab8:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
	assert(n > 0);
	assert(PageReserved(base));
	list_entry_t *le = &free_list;
	struct Page* p = NULL;
	while ((le = list_next(le)) != &free_list)
c0103abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103abe:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c0103ac5:	75 d5                	jne    c0103a9c <default_free_pages+0x90>
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c0103ac7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103ace:	eb 55                	jmp    c0103b25 <default_free_pages+0x119>
	{
		list_add_before(le, &((base + i)->page_link));
c0103ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ad3:	c1 e0 05             	shl    $0x5,%eax
c0103ad6:	89 c2                	mov    %eax,%edx
c0103ad8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adb:	01 d0                	add    %edx,%eax
c0103add:	8d 50 0c             	lea    0xc(%eax),%edx
c0103ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103ae6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103ae9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103aec:	8b 00                	mov    (%eax),%eax
c0103aee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103af1:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103af4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0103af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103afa:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103afd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103b00:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103b03:	89 10                	mov    %edx,(%eax)
c0103b05:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103b08:	8b 10                	mov    (%eax),%edx
c0103b0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103b0d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103b10:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103b13:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103b16:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103b19:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103b1c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103b1f:	89 10                	mov    %edx,(%eax)
		p = le2page(le, page_link);
		if(p > base)
			break;
	}
	int i;
	for(i = 0;i<n;i++)
c0103b21:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0103b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b28:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b2b:	72 a3                	jb     c0103ad0 <default_free_pages+0xc4>
	{
		list_add_before(le, &((base + i)->page_link));
	}
	base->flags = 0;
c0103b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	ClearPageProperty(base);
c0103b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3a:	83 c0 04             	add    $0x4,%eax
c0103b3d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103b44:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103b47:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103b4a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103b4d:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
c0103b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b53:	83 c0 04             	add    $0x4,%eax
c0103b56:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0103b5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103b63:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103b66:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
c0103b69:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103b70:	00 
c0103b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b74:	89 04 24             	mov    %eax,(%esp)
c0103b77:	e8 79 fb ff ff       	call   c01036f5 <set_page_ref>
	base->property = n;
c0103b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b82:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le, page_link);
c0103b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b88:	83 e8 0c             	sub    $0xc,%eax
c0103b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(base + n == p)
c0103b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b91:	c1 e0 05             	shl    $0x5,%eax
c0103b94:	89 c2                	mov    %eax,%edx
c0103b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b99:	01 d0                	add    %edx,%eax
c0103b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103b9e:	75 1b                	jne    c0103bbb <default_free_pages+0x1af>
	{
		base->property = n + p->property;
c0103ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ba3:	8b 50 08             	mov    0x8(%eax),%edx
c0103ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ba9:	01 c2                	add    %eax,%edx
c0103bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bae:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0103bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
c0103bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bbe:	83 c0 0c             	add    $0xc,%eax
c0103bc1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103bc4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103bc7:	8b 00                	mov    (%eax),%eax
c0103bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
c0103bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bcf:	83 e8 0c             	sub    $0xc,%eax
c0103bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//below need to change
	if(le != &free_list && base - 1 == p)
c0103bd5:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c0103bdc:	74 57                	je     c0103c35 <default_free_pages+0x229>
c0103bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be1:	83 e8 20             	sub    $0x20,%eax
c0103be4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103be7:	75 4c                	jne    c0103c35 <default_free_pages+0x229>
	{
	  while(le!=&free_list){
c0103be9:	eb 41                	jmp    c0103c2c <default_free_pages+0x220>
		if(p->property){
c0103beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bee:	8b 40 08             	mov    0x8(%eax),%eax
c0103bf1:	85 c0                	test   %eax,%eax
c0103bf3:	74 20                	je     c0103c15 <default_free_pages+0x209>
		  p->property += base->property;
c0103bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bf8:	8b 50 08             	mov    0x8(%eax),%edx
c0103bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bfe:	8b 40 08             	mov    0x8(%eax),%eax
c0103c01:	01 c2                	add    %eax,%edx
c0103c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c06:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
c0103c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
c0103c13:	eb 20                	jmp    c0103c35 <default_free_pages+0x229>
c0103c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c18:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103c1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103c1e:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
c0103c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
c0103c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c26:	83 e8 0c             	sub    $0xc,%eax
c0103c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	//below need to change
	if(le != &free_list && base - 1 == p)
	{
	  while(le!=&free_list){
c0103c2c:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c0103c33:	75 b6                	jne    c0103beb <default_free_pages+0x1df>
		}
		le = list_prev(le);
		p = le2page(le,page_link);
	  }
	}
	nr_free += n;
c0103c35:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c3e:	01 d0                	add    %edx,%eax
c0103c40:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
}
c0103c45:	c9                   	leave  
c0103c46:	c3                   	ret    

c0103c47 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103c47:	55                   	push   %ebp
c0103c48:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103c4a:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
}
c0103c4f:	5d                   	pop    %ebp
c0103c50:	c3                   	ret    

c0103c51 <basic_check>:

static void
basic_check(void) {
c0103c51:	55                   	push   %ebp
c0103c52:	89 e5                	mov    %esp,%ebp
c0103c54:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c67:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103c6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c71:	e8 dc 15 00 00       	call   c0105252 <alloc_pages>
c0103c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c7d:	75 24                	jne    c0103ca3 <basic_check+0x52>
c0103c7f:	c7 44 24 0c 04 c9 10 	movl   $0xc010c904,0xc(%esp)
c0103c86:	c0 
c0103c87:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103c8e:	c0 
c0103c8f:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103c96:	00 
c0103c97:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103c9e:	e8 2c d1 ff ff       	call   c0100dcf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103ca3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103caa:	e8 a3 15 00 00       	call   c0105252 <alloc_pages>
c0103caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103cb6:	75 24                	jne    c0103cdc <basic_check+0x8b>
c0103cb8:	c7 44 24 0c 20 c9 10 	movl   $0xc010c920,0xc(%esp)
c0103cbf:	c0 
c0103cc0:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103cc7:	c0 
c0103cc8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103ccf:	00 
c0103cd0:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103cd7:	e8 f3 d0 ff ff       	call   c0100dcf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103cdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ce3:	e8 6a 15 00 00       	call   c0105252 <alloc_pages>
c0103ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ceb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103cef:	75 24                	jne    c0103d15 <basic_check+0xc4>
c0103cf1:	c7 44 24 0c 3c c9 10 	movl   $0xc010c93c,0xc(%esp)
c0103cf8:	c0 
c0103cf9:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103d00:	c0 
c0103d01:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103d08:	00 
c0103d09:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103d10:	e8 ba d0 ff ff       	call   c0100dcf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103d1b:	74 10                	je     c0103d2d <basic_check+0xdc>
c0103d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d20:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d23:	74 08                	je     c0103d2d <basic_check+0xdc>
c0103d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d2b:	75 24                	jne    c0103d51 <basic_check+0x100>
c0103d2d:	c7 44 24 0c 58 c9 10 	movl   $0xc010c958,0xc(%esp)
c0103d34:	c0 
c0103d35:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103d3c:	c0 
c0103d3d:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103d44:	00 
c0103d45:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103d4c:	e8 7e d0 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d54:	89 04 24             	mov    %eax,(%esp)
c0103d57:	e8 8f f9 ff ff       	call   c01036eb <page_ref>
c0103d5c:	85 c0                	test   %eax,%eax
c0103d5e:	75 1e                	jne    c0103d7e <basic_check+0x12d>
c0103d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d63:	89 04 24             	mov    %eax,(%esp)
c0103d66:	e8 80 f9 ff ff       	call   c01036eb <page_ref>
c0103d6b:	85 c0                	test   %eax,%eax
c0103d6d:	75 0f                	jne    c0103d7e <basic_check+0x12d>
c0103d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d72:	89 04 24             	mov    %eax,(%esp)
c0103d75:	e8 71 f9 ff ff       	call   c01036eb <page_ref>
c0103d7a:	85 c0                	test   %eax,%eax
c0103d7c:	74 24                	je     c0103da2 <basic_check+0x151>
c0103d7e:	c7 44 24 0c 7c c9 10 	movl   $0xc010c97c,0xc(%esp)
c0103d85:	c0 
c0103d86:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103d8d:	c0 
c0103d8e:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103d95:	00 
c0103d96:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103d9d:	e8 2d d0 ff ff       	call   c0100dcf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103da5:	89 04 24             	mov    %eax,(%esp)
c0103da8:	e8 28 f9 ff ff       	call   c01036d5 <page2pa>
c0103dad:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103db3:	c1 e2 0c             	shl    $0xc,%edx
c0103db6:	39 d0                	cmp    %edx,%eax
c0103db8:	72 24                	jb     c0103dde <basic_check+0x18d>
c0103dba:	c7 44 24 0c b8 c9 10 	movl   $0xc010c9b8,0xc(%esp)
c0103dc1:	c0 
c0103dc2:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103dc9:	c0 
c0103dca:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103dd1:	00 
c0103dd2:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103dd9:	e8 f1 cf ff ff       	call   c0100dcf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103de1:	89 04 24             	mov    %eax,(%esp)
c0103de4:	e8 ec f8 ff ff       	call   c01036d5 <page2pa>
c0103de9:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103def:	c1 e2 0c             	shl    $0xc,%edx
c0103df2:	39 d0                	cmp    %edx,%eax
c0103df4:	72 24                	jb     c0103e1a <basic_check+0x1c9>
c0103df6:	c7 44 24 0c d5 c9 10 	movl   $0xc010c9d5,0xc(%esp)
c0103dfd:	c0 
c0103dfe:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103e05:	c0 
c0103e06:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103e0d:	00 
c0103e0e:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103e15:	e8 b5 cf ff ff       	call   c0100dcf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e1d:	89 04 24             	mov    %eax,(%esp)
c0103e20:	e8 b0 f8 ff ff       	call   c01036d5 <page2pa>
c0103e25:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103e2b:	c1 e2 0c             	shl    $0xc,%edx
c0103e2e:	39 d0                	cmp    %edx,%eax
c0103e30:	72 24                	jb     c0103e56 <basic_check+0x205>
c0103e32:	c7 44 24 0c f2 c9 10 	movl   $0xc010c9f2,0xc(%esp)
c0103e39:	c0 
c0103e3a:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103e41:	c0 
c0103e42:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103e49:	00 
c0103e4a:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103e51:	e8 79 cf ff ff       	call   c0100dcf <__panic>

    list_entry_t free_list_store = free_list;
c0103e56:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0103e5b:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0103e61:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e67:	c7 45 e0 b8 ef 19 c0 	movl   $0xc019efb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e71:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103e74:	89 50 04             	mov    %edx,0x4(%eax)
c0103e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e7a:	8b 50 04             	mov    0x4(%eax),%edx
c0103e7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e80:	89 10                	mov    %edx,(%eax)
c0103e82:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e8c:	8b 40 04             	mov    0x4(%eax),%eax
c0103e8f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103e92:	0f 94 c0             	sete   %al
c0103e95:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e98:	85 c0                	test   %eax,%eax
c0103e9a:	75 24                	jne    c0103ec0 <basic_check+0x26f>
c0103e9c:	c7 44 24 0c 0f ca 10 	movl   $0xc010ca0f,0xc(%esp)
c0103ea3:	c0 
c0103ea4:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103eab:	c0 
c0103eac:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103eb3:	00 
c0103eb4:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103ebb:	e8 0f cf ff ff       	call   c0100dcf <__panic>

    unsigned int nr_free_store = nr_free;
c0103ec0:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103ec5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103ec8:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103ecf:	00 00 00 

    assert(alloc_page() == NULL);
c0103ed2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ed9:	e8 74 13 00 00       	call   c0105252 <alloc_pages>
c0103ede:	85 c0                	test   %eax,%eax
c0103ee0:	74 24                	je     c0103f06 <basic_check+0x2b5>
c0103ee2:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c0103ee9:	c0 
c0103eea:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103ef1:	c0 
c0103ef2:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103ef9:	00 
c0103efa:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103f01:	e8 c9 ce ff ff       	call   c0100dcf <__panic>

    free_page(p0);
c0103f06:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f0d:	00 
c0103f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f11:	89 04 24             	mov    %eax,(%esp)
c0103f14:	e8 a4 13 00 00       	call   c01052bd <free_pages>
    free_page(p1);
c0103f19:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f20:	00 
c0103f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f24:	89 04 24             	mov    %eax,(%esp)
c0103f27:	e8 91 13 00 00       	call   c01052bd <free_pages>
    free_page(p2);
c0103f2c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f33:	00 
c0103f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f37:	89 04 24             	mov    %eax,(%esp)
c0103f3a:	e8 7e 13 00 00       	call   c01052bd <free_pages>
    assert(nr_free == 3);
c0103f3f:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103f44:	83 f8 03             	cmp    $0x3,%eax
c0103f47:	74 24                	je     c0103f6d <basic_check+0x31c>
c0103f49:	c7 44 24 0c 3b ca 10 	movl   $0xc010ca3b,0xc(%esp)
c0103f50:	c0 
c0103f51:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103f60:	00 
c0103f61:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103f68:	e8 62 ce ff ff       	call   c0100dcf <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103f6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f74:	e8 d9 12 00 00       	call   c0105252 <alloc_pages>
c0103f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103f80:	75 24                	jne    c0103fa6 <basic_check+0x355>
c0103f82:	c7 44 24 0c 04 c9 10 	movl   $0xc010c904,0xc(%esp)
c0103f89:	c0 
c0103f8a:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103f91:	c0 
c0103f92:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103f99:	00 
c0103f9a:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103fa1:	e8 29 ce ff ff       	call   c0100dcf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103fa6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fad:	e8 a0 12 00 00       	call   c0105252 <alloc_pages>
c0103fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103fb9:	75 24                	jne    c0103fdf <basic_check+0x38e>
c0103fbb:	c7 44 24 0c 20 c9 10 	movl   $0xc010c920,0xc(%esp)
c0103fc2:	c0 
c0103fc3:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0103fca:	c0 
c0103fcb:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103fd2:	00 
c0103fd3:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0103fda:	e8 f0 cd ff ff       	call   c0100dcf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103fdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fe6:	e8 67 12 00 00       	call   c0105252 <alloc_pages>
c0103feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ff2:	75 24                	jne    c0104018 <basic_check+0x3c7>
c0103ff4:	c7 44 24 0c 3c c9 10 	movl   $0xc010c93c,0xc(%esp)
c0103ffb:	c0 
c0103ffc:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104003:	c0 
c0104004:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c010400b:	00 
c010400c:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104013:	e8 b7 cd ff ff       	call   c0100dcf <__panic>

    assert(alloc_page() == NULL);
c0104018:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010401f:	e8 2e 12 00 00       	call   c0105252 <alloc_pages>
c0104024:	85 c0                	test   %eax,%eax
c0104026:	74 24                	je     c010404c <basic_check+0x3fb>
c0104028:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c010402f:	c0 
c0104030:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104037:	c0 
c0104038:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010403f:	00 
c0104040:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104047:	e8 83 cd ff ff       	call   c0100dcf <__panic>

    free_page(p0);
c010404c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104053:	00 
c0104054:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104057:	89 04 24             	mov    %eax,(%esp)
c010405a:	e8 5e 12 00 00       	call   c01052bd <free_pages>
c010405f:	c7 45 d8 b8 ef 19 c0 	movl   $0xc019efb8,-0x28(%ebp)
c0104066:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104069:	8b 40 04             	mov    0x4(%eax),%eax
c010406c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010406f:	0f 94 c0             	sete   %al
c0104072:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104075:	85 c0                	test   %eax,%eax
c0104077:	74 24                	je     c010409d <basic_check+0x44c>
c0104079:	c7 44 24 0c 48 ca 10 	movl   $0xc010ca48,0xc(%esp)
c0104080:	c0 
c0104081:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104088:	c0 
c0104089:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104090:	00 
c0104091:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104098:	e8 32 cd ff ff       	call   c0100dcf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010409d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040a4:	e8 a9 11 00 00       	call   c0105252 <alloc_pages>
c01040a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01040b2:	74 24                	je     c01040d8 <basic_check+0x487>
c01040b4:	c7 44 24 0c 60 ca 10 	movl   $0xc010ca60,0xc(%esp)
c01040bb:	c0 
c01040bc:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01040c3:	c0 
c01040c4:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01040cb:	00 
c01040cc:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01040d3:	e8 f7 cc ff ff       	call   c0100dcf <__panic>
    assert(alloc_page() == NULL);
c01040d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040df:	e8 6e 11 00 00       	call   c0105252 <alloc_pages>
c01040e4:	85 c0                	test   %eax,%eax
c01040e6:	74 24                	je     c010410c <basic_check+0x4bb>
c01040e8:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c01040ef:	c0 
c01040f0:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01040f7:	c0 
c01040f8:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01040ff:	00 
c0104100:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104107:	e8 c3 cc ff ff       	call   c0100dcf <__panic>

    assert(nr_free == 0);
c010410c:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0104111:	85 c0                	test   %eax,%eax
c0104113:	74 24                	je     c0104139 <basic_check+0x4e8>
c0104115:	c7 44 24 0c 79 ca 10 	movl   $0xc010ca79,0xc(%esp)
c010411c:	c0 
c010411d:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104124:	c0 
c0104125:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010412c:	00 
c010412d:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104134:	e8 96 cc ff ff       	call   c0100dcf <__panic>
    free_list = free_list_store;
c0104139:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010413c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010413f:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0104144:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    nr_free = nr_free_store;
c010414a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010414d:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_page(p);
c0104152:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104159:	00 
c010415a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010415d:	89 04 24             	mov    %eax,(%esp)
c0104160:	e8 58 11 00 00       	call   c01052bd <free_pages>
    free_page(p1);
c0104165:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010416c:	00 
c010416d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104170:	89 04 24             	mov    %eax,(%esp)
c0104173:	e8 45 11 00 00       	call   c01052bd <free_pages>
    free_page(p2);
c0104178:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010417f:	00 
c0104180:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104183:	89 04 24             	mov    %eax,(%esp)
c0104186:	e8 32 11 00 00       	call   c01052bd <free_pages>
}
c010418b:	c9                   	leave  
c010418c:	c3                   	ret    

c010418d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010418d:	55                   	push   %ebp
c010418e:	89 e5                	mov    %esp,%ebp
c0104190:	53                   	push   %ebx
c0104191:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010419e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01041a5:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01041ac:	eb 6b                	jmp    c0104219 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01041ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041b1:	83 e8 0c             	sub    $0xc,%eax
c01041b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01041b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041ba:	83 c0 04             	add    $0x4,%eax
c01041bd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01041c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01041ca:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041cd:	0f a3 10             	bt     %edx,(%eax)
c01041d0:	19 c0                	sbb    %eax,%eax
c01041d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01041d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01041d9:	0f 95 c0             	setne  %al
c01041dc:	0f b6 c0             	movzbl %al,%eax
c01041df:	85 c0                	test   %eax,%eax
c01041e1:	75 24                	jne    c0104207 <default_check+0x7a>
c01041e3:	c7 44 24 0c 86 ca 10 	movl   $0xc010ca86,0xc(%esp)
c01041ea:	c0 
c01041eb:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01041f2:	c0 
c01041f3:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01041fa:	00 
c01041fb:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104202:	e8 c8 cb ff ff       	call   c0100dcf <__panic>
        count ++, total += p->property;
c0104207:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010420b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010420e:	8b 50 08             	mov    0x8(%eax),%edx
c0104211:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104214:	01 d0                	add    %edx,%eax
c0104216:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104219:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010421c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010421f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104222:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104225:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104228:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c010422f:	0f 85 79 ff ff ff    	jne    c01041ae <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104235:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104238:	e8 b2 10 00 00       	call   c01052ef <nr_free_pages>
c010423d:	39 c3                	cmp    %eax,%ebx
c010423f:	74 24                	je     c0104265 <default_check+0xd8>
c0104241:	c7 44 24 0c 96 ca 10 	movl   $0xc010ca96,0xc(%esp)
c0104248:	c0 
c0104249:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104250:	c0 
c0104251:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104258:	00 
c0104259:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104260:	e8 6a cb ff ff       	call   c0100dcf <__panic>

    basic_check();
c0104265:	e8 e7 f9 ff ff       	call   c0103c51 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010426a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104271:	e8 dc 0f 00 00       	call   c0105252 <alloc_pages>
c0104276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0104279:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010427d:	75 24                	jne    c01042a3 <default_check+0x116>
c010427f:	c7 44 24 0c af ca 10 	movl   $0xc010caaf,0xc(%esp)
c0104286:	c0 
c0104287:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010428e:	c0 
c010428f:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0104296:	00 
c0104297:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c010429e:	e8 2c cb ff ff       	call   c0100dcf <__panic>
    assert(!PageProperty(p0));
c01042a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042a6:	83 c0 04             	add    $0x4,%eax
c01042a9:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01042b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042b6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01042b9:	0f a3 10             	bt     %edx,(%eax)
c01042bc:	19 c0                	sbb    %eax,%eax
c01042be:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01042c1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01042c5:	0f 95 c0             	setne  %al
c01042c8:	0f b6 c0             	movzbl %al,%eax
c01042cb:	85 c0                	test   %eax,%eax
c01042cd:	74 24                	je     c01042f3 <default_check+0x166>
c01042cf:	c7 44 24 0c ba ca 10 	movl   $0xc010caba,0xc(%esp)
c01042d6:	c0 
c01042d7:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01042de:	c0 
c01042df:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01042e6:	00 
c01042e7:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01042ee:	e8 dc ca ff ff       	call   c0100dcf <__panic>

    list_entry_t free_list_store = free_list;
c01042f3:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c01042f8:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c01042fe:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104301:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104304:	c7 45 b4 b8 ef 19 c0 	movl   $0xc019efb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010430b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010430e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104311:	89 50 04             	mov    %edx,0x4(%eax)
c0104314:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104317:	8b 50 04             	mov    0x4(%eax),%edx
c010431a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010431d:	89 10                	mov    %edx,(%eax)
c010431f:	c7 45 b0 b8 ef 19 c0 	movl   $0xc019efb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104326:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104329:	8b 40 04             	mov    0x4(%eax),%eax
c010432c:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010432f:	0f 94 c0             	sete   %al
c0104332:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104335:	85 c0                	test   %eax,%eax
c0104337:	75 24                	jne    c010435d <default_check+0x1d0>
c0104339:	c7 44 24 0c 0f ca 10 	movl   $0xc010ca0f,0xc(%esp)
c0104340:	c0 
c0104341:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104348:	c0 
c0104349:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104350:	00 
c0104351:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104358:	e8 72 ca ff ff       	call   c0100dcf <__panic>
    assert(alloc_page() == NULL);
c010435d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104364:	e8 e9 0e 00 00       	call   c0105252 <alloc_pages>
c0104369:	85 c0                	test   %eax,%eax
c010436b:	74 24                	je     c0104391 <default_check+0x204>
c010436d:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c0104374:	c0 
c0104375:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010437c:	c0 
c010437d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104384:	00 
c0104385:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c010438c:	e8 3e ca ff ff       	call   c0100dcf <__panic>

    unsigned int nr_free_store = nr_free;
c0104391:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0104396:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104399:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c01043a0:	00 00 00 

    free_pages(p0 + 2, 3);
c01043a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043a6:	83 c0 40             	add    $0x40,%eax
c01043a9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01043b0:	00 
c01043b1:	89 04 24             	mov    %eax,(%esp)
c01043b4:	e8 04 0f 00 00       	call   c01052bd <free_pages>
    assert(alloc_pages(4) == NULL);
c01043b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01043c0:	e8 8d 0e 00 00       	call   c0105252 <alloc_pages>
c01043c5:	85 c0                	test   %eax,%eax
c01043c7:	74 24                	je     c01043ed <default_check+0x260>
c01043c9:	c7 44 24 0c cc ca 10 	movl   $0xc010cacc,0xc(%esp)
c01043d0:	c0 
c01043d1:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01043d8:	c0 
c01043d9:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01043e0:	00 
c01043e1:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01043e8:	e8 e2 c9 ff ff       	call   c0100dcf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01043ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043f0:	83 c0 40             	add    $0x40,%eax
c01043f3:	83 c0 04             	add    $0x4,%eax
c01043f6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01043fd:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104400:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104403:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104406:	0f a3 10             	bt     %edx,(%eax)
c0104409:	19 c0                	sbb    %eax,%eax
c010440b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010440e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104412:	0f 95 c0             	setne  %al
c0104415:	0f b6 c0             	movzbl %al,%eax
c0104418:	85 c0                	test   %eax,%eax
c010441a:	74 0e                	je     c010442a <default_check+0x29d>
c010441c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441f:	83 c0 40             	add    $0x40,%eax
c0104422:	8b 40 08             	mov    0x8(%eax),%eax
c0104425:	83 f8 03             	cmp    $0x3,%eax
c0104428:	74 24                	je     c010444e <default_check+0x2c1>
c010442a:	c7 44 24 0c e4 ca 10 	movl   $0xc010cae4,0xc(%esp)
c0104431:	c0 
c0104432:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104439:	c0 
c010443a:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104441:	00 
c0104442:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104449:	e8 81 c9 ff ff       	call   c0100dcf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010444e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104455:	e8 f8 0d 00 00       	call   c0105252 <alloc_pages>
c010445a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010445d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104461:	75 24                	jne    c0104487 <default_check+0x2fa>
c0104463:	c7 44 24 0c 10 cb 10 	movl   $0xc010cb10,0xc(%esp)
c010446a:	c0 
c010446b:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104472:	c0 
c0104473:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010447a:	00 
c010447b:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104482:	e8 48 c9 ff ff       	call   c0100dcf <__panic>
    assert(alloc_page() == NULL);
c0104487:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010448e:	e8 bf 0d 00 00       	call   c0105252 <alloc_pages>
c0104493:	85 c0                	test   %eax,%eax
c0104495:	74 24                	je     c01044bb <default_check+0x32e>
c0104497:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c010449e:	c0 
c010449f:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01044a6:	c0 
c01044a7:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01044ae:	00 
c01044af:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01044b6:	e8 14 c9 ff ff       	call   c0100dcf <__panic>
    assert(p0 + 2 == p1);
c01044bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044be:	83 c0 40             	add    $0x40,%eax
c01044c1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01044c4:	74 24                	je     c01044ea <default_check+0x35d>
c01044c6:	c7 44 24 0c 2e cb 10 	movl   $0xc010cb2e,0xc(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01044d5:	c0 
c01044d6:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01044dd:	00 
c01044de:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01044e5:	e8 e5 c8 ff ff       	call   c0100dcf <__panic>

    p2 = p0 + 1;
c01044ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044ed:	83 c0 20             	add    $0x20,%eax
c01044f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01044f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044fa:	00 
c01044fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044fe:	89 04 24             	mov    %eax,(%esp)
c0104501:	e8 b7 0d 00 00       	call   c01052bd <free_pages>
    free_pages(p1, 3);
c0104506:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010450d:	00 
c010450e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104511:	89 04 24             	mov    %eax,(%esp)
c0104514:	e8 a4 0d 00 00       	call   c01052bd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010451c:	83 c0 04             	add    $0x4,%eax
c010451f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104526:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104529:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010452c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010452f:	0f a3 10             	bt     %edx,(%eax)
c0104532:	19 c0                	sbb    %eax,%eax
c0104534:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104537:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010453b:	0f 95 c0             	setne  %al
c010453e:	0f b6 c0             	movzbl %al,%eax
c0104541:	85 c0                	test   %eax,%eax
c0104543:	74 0b                	je     c0104550 <default_check+0x3c3>
c0104545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104548:	8b 40 08             	mov    0x8(%eax),%eax
c010454b:	83 f8 01             	cmp    $0x1,%eax
c010454e:	74 24                	je     c0104574 <default_check+0x3e7>
c0104550:	c7 44 24 0c 3c cb 10 	movl   $0xc010cb3c,0xc(%esp)
c0104557:	c0 
c0104558:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010455f:	c0 
c0104560:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104567:	00 
c0104568:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c010456f:	e8 5b c8 ff ff       	call   c0100dcf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104574:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104577:	83 c0 04             	add    $0x4,%eax
c010457a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104581:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104584:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104587:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010458a:	0f a3 10             	bt     %edx,(%eax)
c010458d:	19 c0                	sbb    %eax,%eax
c010458f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104592:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104596:	0f 95 c0             	setne  %al
c0104599:	0f b6 c0             	movzbl %al,%eax
c010459c:	85 c0                	test   %eax,%eax
c010459e:	74 0b                	je     c01045ab <default_check+0x41e>
c01045a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045a3:	8b 40 08             	mov    0x8(%eax),%eax
c01045a6:	83 f8 03             	cmp    $0x3,%eax
c01045a9:	74 24                	je     c01045cf <default_check+0x442>
c01045ab:	c7 44 24 0c 64 cb 10 	movl   $0xc010cb64,0xc(%esp)
c01045b2:	c0 
c01045b3:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01045ba:	c0 
c01045bb:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01045c2:	00 
c01045c3:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01045ca:	e8 00 c8 ff ff       	call   c0100dcf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01045cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045d6:	e8 77 0c 00 00       	call   c0105252 <alloc_pages>
c01045db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01045e1:	83 e8 20             	sub    $0x20,%eax
c01045e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01045e7:	74 24                	je     c010460d <default_check+0x480>
c01045e9:	c7 44 24 0c 8a cb 10 	movl   $0xc010cb8a,0xc(%esp)
c01045f0:	c0 
c01045f1:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01045f8:	c0 
c01045f9:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104600:	00 
c0104601:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104608:	e8 c2 c7 ff ff       	call   c0100dcf <__panic>
    free_page(p0);
c010460d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104614:	00 
c0104615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104618:	89 04 24             	mov    %eax,(%esp)
c010461b:	e8 9d 0c 00 00       	call   c01052bd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104620:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104627:	e8 26 0c 00 00       	call   c0105252 <alloc_pages>
c010462c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010462f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104632:	83 c0 20             	add    $0x20,%eax
c0104635:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104638:	74 24                	je     c010465e <default_check+0x4d1>
c010463a:	c7 44 24 0c a8 cb 10 	movl   $0xc010cba8,0xc(%esp)
c0104641:	c0 
c0104642:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104649:	c0 
c010464a:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0104651:	00 
c0104652:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104659:	e8 71 c7 ff ff       	call   c0100dcf <__panic>

    free_pages(p0, 2);
c010465e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104665:	00 
c0104666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104669:	89 04 24             	mov    %eax,(%esp)
c010466c:	e8 4c 0c 00 00       	call   c01052bd <free_pages>
    free_page(p2);
c0104671:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104678:	00 
c0104679:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010467c:	89 04 24             	mov    %eax,(%esp)
c010467f:	e8 39 0c 00 00       	call   c01052bd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104684:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010468b:	e8 c2 0b 00 00       	call   c0105252 <alloc_pages>
c0104690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104693:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104697:	75 24                	jne    c01046bd <default_check+0x530>
c0104699:	c7 44 24 0c c8 cb 10 	movl   $0xc010cbc8,0xc(%esp)
c01046a0:	c0 
c01046a1:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01046a8:	c0 
c01046a9:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01046b0:	00 
c01046b1:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01046b8:	e8 12 c7 ff ff       	call   c0100dcf <__panic>
    assert(alloc_page() == NULL);
c01046bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046c4:	e8 89 0b 00 00       	call   c0105252 <alloc_pages>
c01046c9:	85 c0                	test   %eax,%eax
c01046cb:	74 24                	je     c01046f1 <default_check+0x564>
c01046cd:	c7 44 24 0c 26 ca 10 	movl   $0xc010ca26,0xc(%esp)
c01046d4:	c0 
c01046d5:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01046dc:	c0 
c01046dd:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01046e4:	00 
c01046e5:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01046ec:	e8 de c6 ff ff       	call   c0100dcf <__panic>

    assert(nr_free == 0);
c01046f1:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01046f6:	85 c0                	test   %eax,%eax
c01046f8:	74 24                	je     c010471e <default_check+0x591>
c01046fa:	c7 44 24 0c 79 ca 10 	movl   $0xc010ca79,0xc(%esp)
c0104701:	c0 
c0104702:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c0104709:	c0 
c010470a:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0104711:	00 
c0104712:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c0104719:	e8 b1 c6 ff ff       	call   c0100dcf <__panic>
    nr_free = nr_free_store;
c010471e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104721:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_list = free_list_store;
c0104726:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104729:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010472c:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0104731:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    free_pages(p0, 5);
c0104737:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010473e:	00 
c010473f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104742:	89 04 24             	mov    %eax,(%esp)
c0104745:	e8 73 0b 00 00       	call   c01052bd <free_pages>

    le = &free_list;
c010474a:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104751:	eb 1d                	jmp    c0104770 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104753:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104756:	83 e8 0c             	sub    $0xc,%eax
c0104759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010475c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104760:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104766:	8b 40 08             	mov    0x8(%eax),%eax
c0104769:	29 c2                	sub    %eax,%edx
c010476b:	89 d0                	mov    %edx,%eax
c010476d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104770:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104773:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104776:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104779:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010477c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010477f:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c0104786:	75 cb                	jne    c0104753 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010478c:	74 24                	je     c01047b2 <default_check+0x625>
c010478e:	c7 44 24 0c e6 cb 10 	movl   $0xc010cbe6,0xc(%esp)
c0104795:	c0 
c0104796:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c010479d:	c0 
c010479e:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01047a5:	00 
c01047a6:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01047ad:	e8 1d c6 ff ff       	call   c0100dcf <__panic>
    assert(total == 0);
c01047b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047b6:	74 24                	je     c01047dc <default_check+0x64f>
c01047b8:	c7 44 24 0c f1 cb 10 	movl   $0xc010cbf1,0xc(%esp)
c01047bf:	c0 
c01047c0:	c7 44 24 08 b6 c8 10 	movl   $0xc010c8b6,0x8(%esp)
c01047c7:	c0 
c01047c8:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01047cf:	00 
c01047d0:	c7 04 24 cb c8 10 c0 	movl   $0xc010c8cb,(%esp)
c01047d7:	e8 f3 c5 ff ff       	call   c0100dcf <__panic>
}
c01047dc:	81 c4 94 00 00 00    	add    $0x94,%esp
c01047e2:	5b                   	pop    %ebx
c01047e3:	5d                   	pop    %ebp
c01047e4:	c3                   	ret    

c01047e5 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01047e5:	55                   	push   %ebp
c01047e6:	89 e5                	mov    %esp,%ebp
c01047e8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01047eb:	9c                   	pushf  
c01047ec:	58                   	pop    %eax
c01047ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01047f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01047f3:	25 00 02 00 00       	and    $0x200,%eax
c01047f8:	85 c0                	test   %eax,%eax
c01047fa:	74 0c                	je     c0104808 <__intr_save+0x23>
        intr_disable();
c01047fc:	e8 26 d8 ff ff       	call   c0102027 <intr_disable>
        return 1;
c0104801:	b8 01 00 00 00       	mov    $0x1,%eax
c0104806:	eb 05                	jmp    c010480d <__intr_save+0x28>
    }
    return 0;
c0104808:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010480d:	c9                   	leave  
c010480e:	c3                   	ret    

c010480f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010480f:	55                   	push   %ebp
c0104810:	89 e5                	mov    %esp,%ebp
c0104812:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104819:	74 05                	je     c0104820 <__intr_restore+0x11>
        intr_enable();
c010481b:	e8 01 d8 ff ff       	call   c0102021 <intr_enable>
    }
}
c0104820:	c9                   	leave  
c0104821:	c3                   	ret    

c0104822 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104822:	55                   	push   %ebp
c0104823:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104825:	8b 55 08             	mov    0x8(%ebp),%edx
c0104828:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010482d:	29 c2                	sub    %eax,%edx
c010482f:	89 d0                	mov    %edx,%eax
c0104831:	c1 f8 05             	sar    $0x5,%eax
}
c0104834:	5d                   	pop    %ebp
c0104835:	c3                   	ret    

c0104836 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104836:	55                   	push   %ebp
c0104837:	89 e5                	mov    %esp,%ebp
c0104839:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010483c:	8b 45 08             	mov    0x8(%ebp),%eax
c010483f:	89 04 24             	mov    %eax,(%esp)
c0104842:	e8 db ff ff ff       	call   c0104822 <page2ppn>
c0104847:	c1 e0 0c             	shl    $0xc,%eax
}
c010484a:	c9                   	leave  
c010484b:	c3                   	ret    

c010484c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010484c:	55                   	push   %ebp
c010484d:	89 e5                	mov    %esp,%ebp
c010484f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104852:	8b 45 08             	mov    0x8(%ebp),%eax
c0104855:	c1 e8 0c             	shr    $0xc,%eax
c0104858:	89 c2                	mov    %eax,%edx
c010485a:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010485f:	39 c2                	cmp    %eax,%edx
c0104861:	72 1c                	jb     c010487f <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104863:	c7 44 24 08 2c cc 10 	movl   $0xc010cc2c,0x8(%esp)
c010486a:	c0 
c010486b:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104872:	00 
c0104873:	c7 04 24 4b cc 10 c0 	movl   $0xc010cc4b,(%esp)
c010487a:	e8 50 c5 ff ff       	call   c0100dcf <__panic>
    }
    return &pages[PPN(pa)];
c010487f:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104884:	8b 55 08             	mov    0x8(%ebp),%edx
c0104887:	c1 ea 0c             	shr    $0xc,%edx
c010488a:	c1 e2 05             	shl    $0x5,%edx
c010488d:	01 d0                	add    %edx,%eax
}
c010488f:	c9                   	leave  
c0104890:	c3                   	ret    

c0104891 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104891:	55                   	push   %ebp
c0104892:	89 e5                	mov    %esp,%ebp
c0104894:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104897:	8b 45 08             	mov    0x8(%ebp),%eax
c010489a:	89 04 24             	mov    %eax,(%esp)
c010489d:	e8 94 ff ff ff       	call   c0104836 <page2pa>
c01048a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a8:	c1 e8 0c             	shr    $0xc,%eax
c01048ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ae:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01048b3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01048b6:	72 23                	jb     c01048db <page2kva+0x4a>
c01048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048bf:	c7 44 24 08 5c cc 10 	movl   $0xc010cc5c,0x8(%esp)
c01048c6:	c0 
c01048c7:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01048ce:	00 
c01048cf:	c7 04 24 4b cc 10 c0 	movl   $0xc010cc4b,(%esp)
c01048d6:	e8 f4 c4 ff ff       	call   c0100dcf <__panic>
c01048db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048de:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01048e3:	c9                   	leave  
c01048e4:	c3                   	ret    

c01048e5 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01048e5:	55                   	push   %ebp
c01048e6:	89 e5                	mov    %esp,%ebp
c01048e8:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01048eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048f1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01048f8:	77 23                	ja     c010491d <kva2page+0x38>
c01048fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104901:	c7 44 24 08 80 cc 10 	movl   $0xc010cc80,0x8(%esp)
c0104908:	c0 
c0104909:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0104910:	00 
c0104911:	c7 04 24 4b cc 10 c0 	movl   $0xc010cc4b,(%esp)
c0104918:	e8 b2 c4 ff ff       	call   c0100dcf <__panic>
c010491d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104920:	05 00 00 00 40       	add    $0x40000000,%eax
c0104925:	89 04 24             	mov    %eax,(%esp)
c0104928:	e8 1f ff ff ff       	call   c010484c <pa2page>
}
c010492d:	c9                   	leave  
c010492e:	c3                   	ret    

c010492f <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c010492f:	55                   	push   %ebp
c0104930:	89 e5                	mov    %esp,%ebp
c0104932:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c0104935:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104938:	ba 01 00 00 00       	mov    $0x1,%edx
c010493d:	89 c1                	mov    %eax,%ecx
c010493f:	d3 e2                	shl    %cl,%edx
c0104941:	89 d0                	mov    %edx,%eax
c0104943:	89 04 24             	mov    %eax,(%esp)
c0104946:	e8 07 09 00 00       	call   c0105252 <alloc_pages>
c010494b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c010494e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104952:	75 07                	jne    c010495b <__slob_get_free_pages+0x2c>
    return NULL;
c0104954:	b8 00 00 00 00       	mov    $0x0,%eax
c0104959:	eb 0b                	jmp    c0104966 <__slob_get_free_pages+0x37>
  return page2kva(page);
c010495b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010495e:	89 04 24             	mov    %eax,(%esp)
c0104961:	e8 2b ff ff ff       	call   c0104891 <page2kva>
}
c0104966:	c9                   	leave  
c0104967:	c3                   	ret    

c0104968 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104968:	55                   	push   %ebp
c0104969:	89 e5                	mov    %esp,%ebp
c010496b:	53                   	push   %ebx
c010496c:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c010496f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104972:	ba 01 00 00 00       	mov    $0x1,%edx
c0104977:	89 c1                	mov    %eax,%ecx
c0104979:	d3 e2                	shl    %cl,%edx
c010497b:	89 d0                	mov    %edx,%eax
c010497d:	89 c3                	mov    %eax,%ebx
c010497f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104982:	89 04 24             	mov    %eax,(%esp)
c0104985:	e8 5b ff ff ff       	call   c01048e5 <kva2page>
c010498a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010498e:	89 04 24             	mov    %eax,(%esp)
c0104991:	e8 27 09 00 00       	call   c01052bd <free_pages>
}
c0104996:	83 c4 14             	add    $0x14,%esp
c0104999:	5b                   	pop    %ebx
c010499a:	5d                   	pop    %ebp
c010499b:	c3                   	ret    

c010499c <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c010499c:	55                   	push   %ebp
c010499d:	89 e5                	mov    %esp,%ebp
c010499f:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01049a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a5:	83 c0 08             	add    $0x8,%eax
c01049a8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01049ad:	76 24                	jbe    c01049d3 <slob_alloc+0x37>
c01049af:	c7 44 24 0c a4 cc 10 	movl   $0xc010cca4,0xc(%esp)
c01049b6:	c0 
c01049b7:	c7 44 24 08 c3 cc 10 	movl   $0xc010ccc3,0x8(%esp)
c01049be:	c0 
c01049bf:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01049c6:	00 
c01049c7:	c7 04 24 d8 cc 10 c0 	movl   $0xc010ccd8,(%esp)
c01049ce:	e8 fc c3 ff ff       	call   c0100dcf <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01049d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c01049da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01049e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01049e4:	83 c0 07             	add    $0x7,%eax
c01049e7:	c1 e8 03             	shr    $0x3,%eax
c01049ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01049ed:	e8 f3 fd ff ff       	call   c01047e5 <__intr_save>
c01049f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01049f5:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01049fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01049fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a00:	8b 40 04             	mov    0x4(%eax),%eax
c0104a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104a06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104a0a:	74 25                	je     c0104a31 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104a0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a12:	01 d0                	add    %edx,%eax
c0104a14:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104a17:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a1a:	f7 d8                	neg    %eax
c0104a1c:	21 d0                	and    %edx,%eax
c0104a1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a27:	29 c2                	sub    %eax,%edx
c0104a29:	89 d0                	mov    %edx,%eax
c0104a2b:	c1 f8 03             	sar    $0x3,%eax
c0104a2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a34:	8b 00                	mov    (%eax),%eax
c0104a36:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104a39:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104a3c:	01 ca                	add    %ecx,%edx
c0104a3e:	39 d0                	cmp    %edx,%eax
c0104a40:	0f 8c aa 00 00 00    	jl     c0104af0 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104a46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104a4a:	74 38                	je     c0104a84 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a4f:	8b 00                	mov    (%eax),%eax
c0104a51:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104a54:	89 c2                	mov    %eax,%edx
c0104a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a59:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a5e:	8b 50 04             	mov    0x4(%eax),%edx
c0104a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a64:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104a6d:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a73:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104a76:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a87:	8b 00                	mov    (%eax),%eax
c0104a89:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104a8c:	75 0e                	jne    c0104a9c <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a91:	8b 50 04             	mov    0x4(%eax),%edx
c0104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a97:	89 50 04             	mov    %edx,0x4(%eax)
c0104a9a:	eb 3c                	jmp    c0104ad8 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a9f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa9:	01 c2                	add    %eax,%edx
c0104aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aae:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab4:	8b 40 04             	mov    0x4(%eax),%eax
c0104ab7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104aba:	8b 12                	mov    (%edx),%edx
c0104abc:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104abf:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac4:	8b 40 04             	mov    0x4(%eax),%eax
c0104ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104aca:	8b 52 04             	mov    0x4(%edx),%edx
c0104acd:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ad6:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104adb:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ae3:	89 04 24             	mov    %eax,(%esp)
c0104ae6:	e8 24 fd ff ff       	call   c010480f <__intr_restore>
			return cur;
c0104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aee:	eb 7f                	jmp    c0104b6f <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104af0:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104af5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104af8:	75 61                	jne    c0104b5b <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104afd:	89 04 24             	mov    %eax,(%esp)
c0104b00:	e8 0a fd ff ff       	call   c010480f <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104b05:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104b0c:	75 07                	jne    c0104b15 <slob_alloc+0x179>
				return 0;
c0104b0e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b13:	eb 5a                	jmp    c0104b6f <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104b15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b1c:	00 
c0104b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b20:	89 04 24             	mov    %eax,(%esp)
c0104b23:	e8 07 fe ff ff       	call   c010492f <__slob_get_free_pages>
c0104b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b2f:	75 07                	jne    c0104b38 <slob_alloc+0x19c>
				return 0;
c0104b31:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b36:	eb 37                	jmp    c0104b6f <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104b38:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b3f:	00 
c0104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b43:	89 04 24             	mov    %eax,(%esp)
c0104b46:	e8 26 00 00 00       	call   c0104b71 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104b4b:	e8 95 fc ff ff       	call   c01047e5 <__intr_save>
c0104b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104b53:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b64:	8b 40 04             	mov    0x4(%eax),%eax
c0104b67:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104b6a:	e9 97 fe ff ff       	jmp    c0104a06 <slob_alloc+0x6a>
}
c0104b6f:	c9                   	leave  
c0104b70:	c3                   	ret    

c0104b71 <slob_free>:

static void slob_free(void *block, int size)
{
c0104b71:	55                   	push   %ebp
c0104b72:	89 e5                	mov    %esp,%ebp
c0104b74:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b81:	75 05                	jne    c0104b88 <slob_free+0x17>
		return;
c0104b83:	e9 ff 00 00 00       	jmp    c0104c87 <slob_free+0x116>

	if (size)
c0104b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104b8c:	74 10                	je     c0104b9e <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b91:	83 c0 07             	add    $0x7,%eax
c0104b94:	c1 e8 03             	shr    $0x3,%eax
c0104b97:	89 c2                	mov    %eax,%edx
c0104b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b9c:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104b9e:	e8 42 fc ff ff       	call   c01047e5 <__intr_save>
c0104ba3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104ba6:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bae:	eb 27                	jmp    c0104bd7 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb3:	8b 40 04             	mov    0x4(%eax),%eax
c0104bb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bb9:	77 13                	ja     c0104bce <slob_free+0x5d>
c0104bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bbe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bc1:	77 27                	ja     c0104bea <slob_free+0x79>
c0104bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc6:	8b 40 04             	mov    0x4(%eax),%eax
c0104bc9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104bcc:	77 1c                	ja     c0104bea <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bd1:	8b 40 04             	mov    0x4(%eax),%eax
c0104bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bda:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bdd:	76 d1                	jbe    c0104bb0 <slob_free+0x3f>
c0104bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be2:	8b 40 04             	mov    0x4(%eax),%eax
c0104be5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104be8:	76 c6                	jbe    c0104bb0 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bed:	8b 00                	mov    (%eax),%eax
c0104bef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bf9:	01 c2                	add    %eax,%edx
c0104bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bfe:	8b 40 04             	mov    0x4(%eax),%eax
c0104c01:	39 c2                	cmp    %eax,%edx
c0104c03:	75 25                	jne    c0104c2a <slob_free+0xb9>
		b->units += cur->next->units;
c0104c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c08:	8b 10                	mov    (%eax),%edx
c0104c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c0d:	8b 40 04             	mov    0x4(%eax),%eax
c0104c10:	8b 00                	mov    (%eax),%eax
c0104c12:	01 c2                	add    %eax,%edx
c0104c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c17:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1c:	8b 40 04             	mov    0x4(%eax),%eax
c0104c1f:	8b 50 04             	mov    0x4(%eax),%edx
c0104c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c25:	89 50 04             	mov    %edx,0x4(%eax)
c0104c28:	eb 0c                	jmp    c0104c36 <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c2d:	8b 50 04             	mov    0x4(%eax),%edx
c0104c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c33:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c39:	8b 00                	mov    (%eax),%eax
c0104c3b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c45:	01 d0                	add    %edx,%eax
c0104c47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104c4a:	75 1f                	jne    c0104c6b <slob_free+0xfa>
		cur->units += b->units;
c0104c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c4f:	8b 10                	mov    (%eax),%edx
c0104c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c54:	8b 00                	mov    (%eax),%eax
c0104c56:	01 c2                	add    %eax,%edx
c0104c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c5b:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c60:	8b 50 04             	mov    0x4(%eax),%edx
c0104c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c66:	89 50 04             	mov    %edx,0x4(%eax)
c0104c69:	eb 09                	jmp    c0104c74 <slob_free+0x103>
	} else
		cur->next = b;
c0104c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c71:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c77:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c7f:	89 04 24             	mov    %eax,(%esp)
c0104c82:	e8 88 fb ff ff       	call   c010480f <__intr_restore>
}
c0104c87:	c9                   	leave  
c0104c88:	c3                   	ret    

c0104c89 <slob_init>:



void
slob_init(void) {
c0104c89:	55                   	push   %ebp
c0104c8a:	89 e5                	mov    %esp,%ebp
c0104c8c:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104c8f:	c7 04 24 ea cc 10 c0 	movl   $0xc010ccea,(%esp)
c0104c96:	e8 b8 b6 ff ff       	call   c0100353 <cprintf>
}
c0104c9b:	c9                   	leave  
c0104c9c:	c3                   	ret    

c0104c9d <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104c9d:	55                   	push   %ebp
c0104c9e:	89 e5                	mov    %esp,%ebp
c0104ca0:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104ca3:	e8 e1 ff ff ff       	call   c0104c89 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104ca8:	c7 04 24 fe cc 10 c0 	movl   $0xc010ccfe,(%esp)
c0104caf:	e8 9f b6 ff ff       	call   c0100353 <cprintf>
}
c0104cb4:	c9                   	leave  
c0104cb5:	c3                   	ret    

c0104cb6 <slob_allocated>:

size_t
slob_allocated(void) {
c0104cb6:	55                   	push   %ebp
c0104cb7:	89 e5                	mov    %esp,%ebp
  return 0;
c0104cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104cbe:	5d                   	pop    %ebp
c0104cbf:	c3                   	ret    

c0104cc0 <kallocated>:

size_t
kallocated(void) {
c0104cc0:	55                   	push   %ebp
c0104cc1:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104cc3:	e8 ee ff ff ff       	call   c0104cb6 <slob_allocated>
}
c0104cc8:	5d                   	pop    %ebp
c0104cc9:	c3                   	ret    

c0104cca <find_order>:

static int find_order(int size)
{
c0104cca:	55                   	push   %ebp
c0104ccb:	89 e5                	mov    %esp,%ebp
c0104ccd:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104cd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104cd7:	eb 07                	jmp    c0104ce0 <find_order+0x16>
		order++;
c0104cd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104cdd:	d1 7d 08             	sarl   0x8(%ebp)
c0104ce0:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104ce7:	7f f0                	jg     c0104cd9 <find_order+0xf>
		order++;
	return order;
c0104ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104cec:	c9                   	leave  
c0104ced:	c3                   	ret    

c0104cee <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104cee:	55                   	push   %ebp
c0104cef:	89 e5                	mov    %esp,%ebp
c0104cf1:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104cf4:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104cfb:	77 38                	ja     c0104d35 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d00:	8d 50 08             	lea    0x8(%eax),%edx
c0104d03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d0a:	00 
c0104d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d12:	89 14 24             	mov    %edx,(%esp)
c0104d15:	e8 82 fc ff ff       	call   c010499c <slob_alloc>
c0104d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d21:	74 08                	je     c0104d2b <__kmalloc+0x3d>
c0104d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d26:	83 c0 08             	add    $0x8,%eax
c0104d29:	eb 05                	jmp    c0104d30 <__kmalloc+0x42>
c0104d2b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d30:	e9 a6 00 00 00       	jmp    c0104ddb <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104d35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d3c:	00 
c0104d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d44:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104d4b:	e8 4c fc ff ff       	call   c010499c <slob_alloc>
c0104d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104d53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d57:	75 07                	jne    c0104d60 <__kmalloc+0x72>
		return 0;
c0104d59:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d5e:	eb 7b                	jmp    c0104ddb <__kmalloc+0xed>

	bb->order = find_order(size);
c0104d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d63:	89 04 24             	mov    %eax,(%esp)
c0104d66:	e8 5f ff ff ff       	call   c0104cca <find_order>
c0104d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d6e:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d73:	8b 00                	mov    (%eax),%eax
c0104d75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d7c:	89 04 24             	mov    %eax,(%esp)
c0104d7f:	e8 ab fb ff ff       	call   c010492f <__slob_get_free_pages>
c0104d84:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d87:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8d:	8b 40 04             	mov    0x4(%eax),%eax
c0104d90:	85 c0                	test   %eax,%eax
c0104d92:	74 2f                	je     c0104dc3 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104d94:	e8 4c fa ff ff       	call   c01047e5 <__intr_save>
c0104d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104d9c:	8b 15 c4 ce 19 c0    	mov    0xc019cec4,%edx
c0104da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da5:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dab:	a3 c4 ce 19 c0       	mov    %eax,0xc019cec4
		spin_unlock_irqrestore(&block_lock, flags);
c0104db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104db3:	89 04 24             	mov    %eax,(%esp)
c0104db6:	e8 54 fa ff ff       	call   c010480f <__intr_restore>
		return bb->pages;
c0104dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dbe:	8b 40 04             	mov    0x4(%eax),%eax
c0104dc1:	eb 18                	jmp    c0104ddb <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104dc3:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104dca:	00 
c0104dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dce:	89 04 24             	mov    %eax,(%esp)
c0104dd1:	e8 9b fd ff ff       	call   c0104b71 <slob_free>
	return 0;
c0104dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ddb:	c9                   	leave  
c0104ddc:	c3                   	ret    

c0104ddd <kmalloc>:

void *
kmalloc(size_t size)
{
c0104ddd:	55                   	push   %ebp
c0104dde:	89 e5                	mov    %esp,%ebp
c0104de0:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104de3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104dea:	00 
c0104deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dee:	89 04 24             	mov    %eax,(%esp)
c0104df1:	e8 f8 fe ff ff       	call   c0104cee <__kmalloc>
}
c0104df6:	c9                   	leave  
c0104df7:	c3                   	ret    

c0104df8 <kfree>:


void kfree(void *block)
{
c0104df8:	55                   	push   %ebp
c0104df9:	89 e5                	mov    %esp,%ebp
c0104dfb:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104dfe:	c7 45 f0 c4 ce 19 c0 	movl   $0xc019cec4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104e09:	75 05                	jne    c0104e10 <kfree+0x18>
		return;
c0104e0b:	e9 a2 00 00 00       	jmp    c0104eb2 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e13:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104e18:	85 c0                	test   %eax,%eax
c0104e1a:	75 7f                	jne    c0104e9b <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104e1c:	e8 c4 f9 ff ff       	call   c01047e5 <__intr_save>
c0104e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104e24:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e2c:	eb 5c                	jmp    c0104e8a <kfree+0x92>
			if (bb->pages == block) {
c0104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e31:	8b 40 04             	mov    0x4(%eax),%eax
c0104e34:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104e37:	75 3f                	jne    c0104e78 <kfree+0x80>
				*last = bb->next;
c0104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e3c:	8b 50 08             	mov    0x8(%eax),%edx
c0104e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e42:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e47:	89 04 24             	mov    %eax,(%esp)
c0104e4a:	e8 c0 f9 ff ff       	call   c010480f <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e52:	8b 10                	mov    (%eax),%edx
c0104e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e57:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e5b:	89 04 24             	mov    %eax,(%esp)
c0104e5e:	e8 05 fb ff ff       	call   c0104968 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104e63:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104e6a:	00 
c0104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e6e:	89 04 24             	mov    %eax,(%esp)
c0104e71:	e8 fb fc ff ff       	call   c0104b71 <slob_free>
				return;
c0104e76:	eb 3a                	jmp    c0104eb2 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e7b:	83 c0 08             	add    $0x8,%eax
c0104e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e84:	8b 40 08             	mov    0x8(%eax),%eax
c0104e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e8e:	75 9e                	jne    c0104e2e <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e93:	89 04 24             	mov    %eax,(%esp)
c0104e96:	e8 74 f9 ff ff       	call   c010480f <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e9e:	83 e8 08             	sub    $0x8,%eax
c0104ea1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ea8:	00 
c0104ea9:	89 04 24             	mov    %eax,(%esp)
c0104eac:	e8 c0 fc ff ff       	call   c0104b71 <slob_free>
	return;
c0104eb1:	90                   	nop
}
c0104eb2:	c9                   	leave  
c0104eb3:	c3                   	ret    

c0104eb4 <ksize>:


unsigned int ksize(const void *block)
{
c0104eb4:	55                   	push   %ebp
c0104eb5:	89 e5                	mov    %esp,%ebp
c0104eb7:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104eba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ebe:	75 07                	jne    c0104ec7 <ksize+0x13>
		return 0;
c0104ec0:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ec5:	eb 6b                	jmp    c0104f32 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104ec7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eca:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104ecf:	85 c0                	test   %eax,%eax
c0104ed1:	75 54                	jne    c0104f27 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104ed3:	e8 0d f9 ff ff       	call   c01047e5 <__intr_save>
c0104ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104edb:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ee3:	eb 31                	jmp    c0104f16 <ksize+0x62>
			if (bb->pages == block) {
c0104ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee8:	8b 40 04             	mov    0x4(%eax),%eax
c0104eeb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104eee:	75 1d                	jne    c0104f0d <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef3:	89 04 24             	mov    %eax,(%esp)
c0104ef6:	e8 14 f9 ff ff       	call   c010480f <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104efe:	8b 00                	mov    (%eax),%eax
c0104f00:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104f05:	89 c1                	mov    %eax,%ecx
c0104f07:	d3 e2                	shl    %cl,%edx
c0104f09:	89 d0                	mov    %edx,%eax
c0104f0b:	eb 25                	jmp    c0104f32 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f10:	8b 40 08             	mov    0x8(%eax),%eax
c0104f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f1a:	75 c9                	jne    c0104ee5 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1f:	89 04 24             	mov    %eax,(%esp)
c0104f22:	e8 e8 f8 ff ff       	call   c010480f <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f2a:	83 e8 08             	sub    $0x8,%eax
c0104f2d:	8b 00                	mov    (%eax),%eax
c0104f2f:	c1 e0 03             	shl    $0x3,%eax
}
c0104f32:	c9                   	leave  
c0104f33:	c3                   	ret    

c0104f34 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104f34:	55                   	push   %ebp
c0104f35:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104f37:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f3a:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104f3f:	29 c2                	sub    %eax,%edx
c0104f41:	89 d0                	mov    %edx,%eax
c0104f43:	c1 f8 05             	sar    $0x5,%eax
}
c0104f46:	5d                   	pop    %ebp
c0104f47:	c3                   	ret    

c0104f48 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104f48:	55                   	push   %ebp
c0104f49:	89 e5                	mov    %esp,%ebp
c0104f4b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f51:	89 04 24             	mov    %eax,(%esp)
c0104f54:	e8 db ff ff ff       	call   c0104f34 <page2ppn>
c0104f59:	c1 e0 0c             	shl    $0xc,%eax
}
c0104f5c:	c9                   	leave  
c0104f5d:	c3                   	ret    

c0104f5e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104f5e:	55                   	push   %ebp
c0104f5f:	89 e5                	mov    %esp,%ebp
c0104f61:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f67:	c1 e8 0c             	shr    $0xc,%eax
c0104f6a:	89 c2                	mov    %eax,%edx
c0104f6c:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104f71:	39 c2                	cmp    %eax,%edx
c0104f73:	72 1c                	jb     c0104f91 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104f75:	c7 44 24 08 1c cd 10 	movl   $0xc010cd1c,0x8(%esp)
c0104f7c:	c0 
c0104f7d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104f84:	00 
c0104f85:	c7 04 24 3b cd 10 c0 	movl   $0xc010cd3b,(%esp)
c0104f8c:	e8 3e be ff ff       	call   c0100dcf <__panic>
    }
    return &pages[PPN(pa)];
c0104f91:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104f96:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f99:	c1 ea 0c             	shr    $0xc,%edx
c0104f9c:	c1 e2 05             	shl    $0x5,%edx
c0104f9f:	01 d0                	add    %edx,%eax
}
c0104fa1:	c9                   	leave  
c0104fa2:	c3                   	ret    

c0104fa3 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104fa3:	55                   	push   %ebp
c0104fa4:	89 e5                	mov    %esp,%ebp
c0104fa6:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104fa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fac:	89 04 24             	mov    %eax,(%esp)
c0104faf:	e8 94 ff ff ff       	call   c0104f48 <page2pa>
c0104fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fba:	c1 e8 0c             	shr    $0xc,%eax
c0104fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fc0:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104fc5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104fc8:	72 23                	jb     c0104fed <page2kva+0x4a>
c0104fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fcd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fd1:	c7 44 24 08 4c cd 10 	movl   $0xc010cd4c,0x8(%esp)
c0104fd8:	c0 
c0104fd9:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104fe0:	00 
c0104fe1:	c7 04 24 3b cd 10 c0 	movl   $0xc010cd3b,(%esp)
c0104fe8:	e8 e2 bd ff ff       	call   c0100dcf <__panic>
c0104fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104ff5:	c9                   	leave  
c0104ff6:	c3                   	ret    

c0104ff7 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104ff7:	55                   	push   %ebp
c0104ff8:	89 e5                	mov    %esp,%ebp
c0104ffa:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104ffd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105000:	83 e0 01             	and    $0x1,%eax
c0105003:	85 c0                	test   %eax,%eax
c0105005:	75 1c                	jne    c0105023 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0105007:	c7 44 24 08 70 cd 10 	movl   $0xc010cd70,0x8(%esp)
c010500e:	c0 
c010500f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0105016:	00 
c0105017:	c7 04 24 3b cd 10 c0 	movl   $0xc010cd3b,(%esp)
c010501e:	e8 ac bd ff ff       	call   c0100dcf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105023:	8b 45 08             	mov    0x8(%ebp),%eax
c0105026:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010502b:	89 04 24             	mov    %eax,(%esp)
c010502e:	e8 2b ff ff ff       	call   c0104f5e <pa2page>
}
c0105033:	c9                   	leave  
c0105034:	c3                   	ret    

c0105035 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0105035:	55                   	push   %ebp
c0105036:	89 e5                	mov    %esp,%ebp
c0105038:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010503b:	8b 45 08             	mov    0x8(%ebp),%eax
c010503e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105043:	89 04 24             	mov    %eax,(%esp)
c0105046:	e8 13 ff ff ff       	call   c0104f5e <pa2page>
}
c010504b:	c9                   	leave  
c010504c:	c3                   	ret    

c010504d <page_ref>:

static inline int
page_ref(struct Page *page) {
c010504d:	55                   	push   %ebp
c010504e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105050:	8b 45 08             	mov    0x8(%ebp),%eax
c0105053:	8b 00                	mov    (%eax),%eax
}
c0105055:	5d                   	pop    %ebp
c0105056:	c3                   	ret    

c0105057 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105057:	55                   	push   %ebp
c0105058:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010505a:	8b 45 08             	mov    0x8(%ebp),%eax
c010505d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105060:	89 10                	mov    %edx,(%eax)
}
c0105062:	5d                   	pop    %ebp
c0105063:	c3                   	ret    

c0105064 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0105064:	55                   	push   %ebp
c0105065:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0105067:	8b 45 08             	mov    0x8(%ebp),%eax
c010506a:	8b 00                	mov    (%eax),%eax
c010506c:	8d 50 01             	lea    0x1(%eax),%edx
c010506f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105072:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0105074:	8b 45 08             	mov    0x8(%ebp),%eax
c0105077:	8b 00                	mov    (%eax),%eax
}
c0105079:	5d                   	pop    %ebp
c010507a:	c3                   	ret    

c010507b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010507b:	55                   	push   %ebp
c010507c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010507e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105081:	8b 00                	mov    (%eax),%eax
c0105083:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105086:	8b 45 08             	mov    0x8(%ebp),%eax
c0105089:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010508b:	8b 45 08             	mov    0x8(%ebp),%eax
c010508e:	8b 00                	mov    (%eax),%eax
}
c0105090:	5d                   	pop    %ebp
c0105091:	c3                   	ret    

c0105092 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0105092:	55                   	push   %ebp
c0105093:	89 e5                	mov    %esp,%ebp
c0105095:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0105098:	9c                   	pushf  
c0105099:	58                   	pop    %eax
c010509a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010509d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01050a0:	25 00 02 00 00       	and    $0x200,%eax
c01050a5:	85 c0                	test   %eax,%eax
c01050a7:	74 0c                	je     c01050b5 <__intr_save+0x23>
        intr_disable();
c01050a9:	e8 79 cf ff ff       	call   c0102027 <intr_disable>
        return 1;
c01050ae:	b8 01 00 00 00       	mov    $0x1,%eax
c01050b3:	eb 05                	jmp    c01050ba <__intr_save+0x28>
    }
    return 0;
c01050b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050ba:	c9                   	leave  
c01050bb:	c3                   	ret    

c01050bc <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01050bc:	55                   	push   %ebp
c01050bd:	89 e5                	mov    %esp,%ebp
c01050bf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01050c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01050c6:	74 05                	je     c01050cd <__intr_restore+0x11>
        intr_enable();
c01050c8:	e8 54 cf ff ff       	call   c0102021 <intr_enable>
    }
}
c01050cd:	c9                   	leave  
c01050ce:	c3                   	ret    

c01050cf <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01050cf:	55                   	push   %ebp
c01050d0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01050d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01050d5:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01050d8:	b8 23 00 00 00       	mov    $0x23,%eax
c01050dd:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01050df:	b8 23 00 00 00       	mov    $0x23,%eax
c01050e4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01050e6:	b8 10 00 00 00       	mov    $0x10,%eax
c01050eb:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01050ed:	b8 10 00 00 00       	mov    $0x10,%eax
c01050f2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01050f4:	b8 10 00 00 00       	mov    $0x10,%eax
c01050f9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01050fb:	ea 02 51 10 c0 08 00 	ljmp   $0x8,$0xc0105102
}
c0105102:	5d                   	pop    %ebp
c0105103:	c3                   	ret    

c0105104 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0105104:	55                   	push   %ebp
c0105105:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0105107:	8b 45 08             	mov    0x8(%ebp),%eax
c010510a:	a3 04 cf 19 c0       	mov    %eax,0xc019cf04
}
c010510f:	5d                   	pop    %ebp
c0105110:	c3                   	ret    

c0105111 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0105111:	55                   	push   %ebp
c0105112:	89 e5                	mov    %esp,%ebp
c0105114:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0105117:	b8 00 a0 12 c0       	mov    $0xc012a000,%eax
c010511c:	89 04 24             	mov    %eax,(%esp)
c010511f:	e8 e0 ff ff ff       	call   c0105104 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0105124:	66 c7 05 08 cf 19 c0 	movw   $0x10,0xc019cf08
c010512b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010512d:	66 c7 05 48 aa 12 c0 	movw   $0x68,0xc012aa48
c0105134:	68 00 
c0105136:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c010513b:	66 a3 4a aa 12 c0    	mov    %ax,0xc012aa4a
c0105141:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0105146:	c1 e8 10             	shr    $0x10,%eax
c0105149:	a2 4c aa 12 c0       	mov    %al,0xc012aa4c
c010514e:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105155:	83 e0 f0             	and    $0xfffffff0,%eax
c0105158:	83 c8 09             	or     $0x9,%eax
c010515b:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0105160:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105167:	83 e0 ef             	and    $0xffffffef,%eax
c010516a:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010516f:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105176:	83 e0 9f             	and    $0xffffff9f,%eax
c0105179:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010517e:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105185:	83 c8 80             	or     $0xffffff80,%eax
c0105188:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010518d:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0105194:	83 e0 f0             	and    $0xfffffff0,%eax
c0105197:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c010519c:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01051a3:	83 e0 ef             	and    $0xffffffef,%eax
c01051a6:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01051ab:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01051b2:	83 e0 df             	and    $0xffffffdf,%eax
c01051b5:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01051ba:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01051c1:	83 c8 40             	or     $0x40,%eax
c01051c4:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01051c9:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01051d0:	83 e0 7f             	and    $0x7f,%eax
c01051d3:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01051d8:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c01051dd:	c1 e8 18             	shr    $0x18,%eax
c01051e0:	a2 4f aa 12 c0       	mov    %al,0xc012aa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c01051e5:	c7 04 24 50 aa 12 c0 	movl   $0xc012aa50,(%esp)
c01051ec:	e8 de fe ff ff       	call   c01050cf <lgdt>
c01051f1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01051f7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01051fb:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01051fe:	c9                   	leave  
c01051ff:	c3                   	ret    

c0105200 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0105200:	55                   	push   %ebp
c0105201:	89 e5                	mov    %esp,%ebp
c0105203:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0105206:	c7 05 c4 ef 19 c0 10 	movl   $0xc010cc10,0xc019efc4
c010520d:	cc 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0105210:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105215:	8b 00                	mov    (%eax),%eax
c0105217:	89 44 24 04          	mov    %eax,0x4(%esp)
c010521b:	c7 04 24 9c cd 10 c0 	movl   $0xc010cd9c,(%esp)
c0105222:	e8 2c b1 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0105227:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010522c:	8b 40 04             	mov    0x4(%eax),%eax
c010522f:	ff d0                	call   *%eax
}
c0105231:	c9                   	leave  
c0105232:	c3                   	ret    

c0105233 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105233:	55                   	push   %ebp
c0105234:	89 e5                	mov    %esp,%ebp
c0105236:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0105239:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010523e:	8b 40 08             	mov    0x8(%eax),%eax
c0105241:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105244:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105248:	8b 55 08             	mov    0x8(%ebp),%edx
c010524b:	89 14 24             	mov    %edx,(%esp)
c010524e:	ff d0                	call   *%eax
}
c0105250:	c9                   	leave  
c0105251:	c3                   	ret    

c0105252 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0105252:	55                   	push   %ebp
c0105253:	89 e5                	mov    %esp,%ebp
c0105255:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0105258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010525f:	e8 2e fe ff ff       	call   c0105092 <__intr_save>
c0105264:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0105267:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010526c:	8b 40 0c             	mov    0xc(%eax),%eax
c010526f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105272:	89 14 24             	mov    %edx,(%esp)
c0105275:	ff d0                	call   *%eax
c0105277:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c010527a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010527d:	89 04 24             	mov    %eax,(%esp)
c0105280:	e8 37 fe ff ff       	call   c01050bc <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0105285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105289:	75 2d                	jne    c01052b8 <alloc_pages+0x66>
c010528b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010528f:	77 27                	ja     c01052b8 <alloc_pages+0x66>
c0105291:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0105296:	85 c0                	test   %eax,%eax
c0105298:	74 1e                	je     c01052b8 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010529a:	8b 55 08             	mov    0x8(%ebp),%edx
c010529d:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01052a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052a9:	00 
c01052aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052ae:	89 04 24             	mov    %eax,(%esp)
c01052b1:	e8 8e 1d 00 00       	call   c0107044 <swap_out>
    }
c01052b6:	eb a7                	jmp    c010525f <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01052b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01052bb:	c9                   	leave  
c01052bc:	c3                   	ret    

c01052bd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01052bd:	55                   	push   %ebp
c01052be:	89 e5                	mov    %esp,%ebp
c01052c0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01052c3:	e8 ca fd ff ff       	call   c0105092 <__intr_save>
c01052c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01052cb:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01052d0:	8b 40 10             	mov    0x10(%eax),%eax
c01052d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01052d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052da:	8b 55 08             	mov    0x8(%ebp),%edx
c01052dd:	89 14 24             	mov    %edx,(%esp)
c01052e0:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01052e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052e5:	89 04 24             	mov    %eax,(%esp)
c01052e8:	e8 cf fd ff ff       	call   c01050bc <__intr_restore>
}
c01052ed:	c9                   	leave  
c01052ee:	c3                   	ret    

c01052ef <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01052ef:	55                   	push   %ebp
c01052f0:	89 e5                	mov    %esp,%ebp
c01052f2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01052f5:	e8 98 fd ff ff       	call   c0105092 <__intr_save>
c01052fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01052fd:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105302:	8b 40 14             	mov    0x14(%eax),%eax
c0105305:	ff d0                	call   *%eax
c0105307:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010530a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010530d:	89 04 24             	mov    %eax,(%esp)
c0105310:	e8 a7 fd ff ff       	call   c01050bc <__intr_restore>
    return ret;
c0105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0105318:	c9                   	leave  
c0105319:	c3                   	ret    

c010531a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010531a:	55                   	push   %ebp
c010531b:	89 e5                	mov    %esp,%ebp
c010531d:	57                   	push   %edi
c010531e:	56                   	push   %esi
c010531f:	53                   	push   %ebx
c0105320:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0105326:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010532d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105334:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010533b:	c7 04 24 b3 cd 10 c0 	movl   $0xc010cdb3,(%esp)
c0105342:	e8 0c b0 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105347:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010534e:	e9 15 01 00 00       	jmp    c0105468 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105353:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105356:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105359:	89 d0                	mov    %edx,%eax
c010535b:	c1 e0 02             	shl    $0x2,%eax
c010535e:	01 d0                	add    %edx,%eax
c0105360:	c1 e0 02             	shl    $0x2,%eax
c0105363:	01 c8                	add    %ecx,%eax
c0105365:	8b 50 08             	mov    0x8(%eax),%edx
c0105368:	8b 40 04             	mov    0x4(%eax),%eax
c010536b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010536e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105371:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105374:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105377:	89 d0                	mov    %edx,%eax
c0105379:	c1 e0 02             	shl    $0x2,%eax
c010537c:	01 d0                	add    %edx,%eax
c010537e:	c1 e0 02             	shl    $0x2,%eax
c0105381:	01 c8                	add    %ecx,%eax
c0105383:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105386:	8b 58 10             	mov    0x10(%eax),%ebx
c0105389:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010538c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010538f:	01 c8                	add    %ecx,%eax
c0105391:	11 da                	adc    %ebx,%edx
c0105393:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105396:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105399:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010539c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010539f:	89 d0                	mov    %edx,%eax
c01053a1:	c1 e0 02             	shl    $0x2,%eax
c01053a4:	01 d0                	add    %edx,%eax
c01053a6:	c1 e0 02             	shl    $0x2,%eax
c01053a9:	01 c8                	add    %ecx,%eax
c01053ab:	83 c0 14             	add    $0x14,%eax
c01053ae:	8b 00                	mov    (%eax),%eax
c01053b0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01053b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01053b9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01053bc:	83 c0 ff             	add    $0xffffffff,%eax
c01053bf:	83 d2 ff             	adc    $0xffffffff,%edx
c01053c2:	89 c6                	mov    %eax,%esi
c01053c4:	89 d7                	mov    %edx,%edi
c01053c6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01053c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053cc:	89 d0                	mov    %edx,%eax
c01053ce:	c1 e0 02             	shl    $0x2,%eax
c01053d1:	01 d0                	add    %edx,%eax
c01053d3:	c1 e0 02             	shl    $0x2,%eax
c01053d6:	01 c8                	add    %ecx,%eax
c01053d8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01053db:	8b 58 10             	mov    0x10(%eax),%ebx
c01053de:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01053e4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01053e8:	89 74 24 14          	mov    %esi,0x14(%esp)
c01053ec:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01053f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01053f3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01053f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053fa:	89 54 24 10          	mov    %edx,0x10(%esp)
c01053fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105402:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105406:	c7 04 24 c0 cd 10 c0 	movl   $0xc010cdc0,(%esp)
c010540d:	e8 41 af ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0105412:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105415:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105418:	89 d0                	mov    %edx,%eax
c010541a:	c1 e0 02             	shl    $0x2,%eax
c010541d:	01 d0                	add    %edx,%eax
c010541f:	c1 e0 02             	shl    $0x2,%eax
c0105422:	01 c8                	add    %ecx,%eax
c0105424:	83 c0 14             	add    $0x14,%eax
c0105427:	8b 00                	mov    (%eax),%eax
c0105429:	83 f8 01             	cmp    $0x1,%eax
c010542c:	75 36                	jne    c0105464 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010542e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105434:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105437:	77 2b                	ja     c0105464 <page_init+0x14a>
c0105439:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010543c:	72 05                	jb     c0105443 <page_init+0x129>
c010543e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105441:	73 21                	jae    c0105464 <page_init+0x14a>
c0105443:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105447:	77 1b                	ja     c0105464 <page_init+0x14a>
c0105449:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010544d:	72 09                	jb     c0105458 <page_init+0x13e>
c010544f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105456:	77 0c                	ja     c0105464 <page_init+0x14a>
                maxpa = end;
c0105458:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010545b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010545e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105461:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105464:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105468:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010546b:	8b 00                	mov    (%eax),%eax
c010546d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105470:	0f 8f dd fe ff ff    	jg     c0105353 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105476:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010547a:	72 1d                	jb     c0105499 <page_init+0x17f>
c010547c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105480:	77 09                	ja     c010548b <page_init+0x171>
c0105482:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105489:	76 0e                	jbe    c0105499 <page_init+0x17f>
        maxpa = KMEMSIZE;
c010548b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105492:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105499:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010549c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010549f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01054a3:	c1 ea 0c             	shr    $0xc,%edx
c01054a6:	a3 e0 ce 19 c0       	mov    %eax,0xc019cee0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01054ab:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01054b2:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c01054b7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054ba:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01054bd:	01 d0                	add    %edx,%eax
c01054bf:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01054c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01054c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ca:	f7 75 ac             	divl   -0x54(%ebp)
c01054cd:	89 d0                	mov    %edx,%eax
c01054cf:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01054d2:	29 c2                	sub    %eax,%edx
c01054d4:	89 d0                	mov    %edx,%eax
c01054d6:	a3 cc ef 19 c0       	mov    %eax,0xc019efcc

    for (i = 0; i < npage; i ++) {
c01054db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01054e2:	eb 27                	jmp    c010550b <page_init+0x1f1>
        SetPageReserved(pages + i);
c01054e4:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01054e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054ec:	c1 e2 05             	shl    $0x5,%edx
c01054ef:	01 d0                	add    %edx,%eax
c01054f1:	83 c0 04             	add    $0x4,%eax
c01054f4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01054fb:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01054fe:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105501:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105504:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105507:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010550b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010550e:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105513:	39 c2                	cmp    %eax,%edx
c0105515:	72 cd                	jb     c01054e4 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105517:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010551c:	c1 e0 05             	shl    $0x5,%eax
c010551f:	89 c2                	mov    %eax,%edx
c0105521:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0105526:	01 d0                	add    %edx,%eax
c0105528:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010552b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105532:	77 23                	ja     c0105557 <page_init+0x23d>
c0105534:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105537:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010553b:	c7 44 24 08 f0 cd 10 	movl   $0xc010cdf0,0x8(%esp)
c0105542:	c0 
c0105543:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010554a:	00 
c010554b:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105552:	e8 78 b8 ff ff       	call   c0100dcf <__panic>
c0105557:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010555a:	05 00 00 00 40       	add    $0x40000000,%eax
c010555f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105562:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105569:	e9 74 01 00 00       	jmp    c01056e2 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010556e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105571:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105574:	89 d0                	mov    %edx,%eax
c0105576:	c1 e0 02             	shl    $0x2,%eax
c0105579:	01 d0                	add    %edx,%eax
c010557b:	c1 e0 02             	shl    $0x2,%eax
c010557e:	01 c8                	add    %ecx,%eax
c0105580:	8b 50 08             	mov    0x8(%eax),%edx
c0105583:	8b 40 04             	mov    0x4(%eax),%eax
c0105586:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105589:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010558c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010558f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105592:	89 d0                	mov    %edx,%eax
c0105594:	c1 e0 02             	shl    $0x2,%eax
c0105597:	01 d0                	add    %edx,%eax
c0105599:	c1 e0 02             	shl    $0x2,%eax
c010559c:	01 c8                	add    %ecx,%eax
c010559e:	8b 48 0c             	mov    0xc(%eax),%ecx
c01055a1:	8b 58 10             	mov    0x10(%eax),%ebx
c01055a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055aa:	01 c8                	add    %ecx,%eax
c01055ac:	11 da                	adc    %ebx,%edx
c01055ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01055b1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01055b4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01055b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01055ba:	89 d0                	mov    %edx,%eax
c01055bc:	c1 e0 02             	shl    $0x2,%eax
c01055bf:	01 d0                	add    %edx,%eax
c01055c1:	c1 e0 02             	shl    $0x2,%eax
c01055c4:	01 c8                	add    %ecx,%eax
c01055c6:	83 c0 14             	add    $0x14,%eax
c01055c9:	8b 00                	mov    (%eax),%eax
c01055cb:	83 f8 01             	cmp    $0x1,%eax
c01055ce:	0f 85 0a 01 00 00    	jne    c01056de <page_init+0x3c4>
            if (begin < freemem) {
c01055d4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01055d7:	ba 00 00 00 00       	mov    $0x0,%edx
c01055dc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055df:	72 17                	jb     c01055f8 <page_init+0x2de>
c01055e1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055e4:	77 05                	ja     c01055eb <page_init+0x2d1>
c01055e6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01055e9:	76 0d                	jbe    c01055f8 <page_init+0x2de>
                begin = freemem;
c01055eb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01055ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055f1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01055f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01055fc:	72 1d                	jb     c010561b <page_init+0x301>
c01055fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105602:	77 09                	ja     c010560d <page_init+0x2f3>
c0105604:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010560b:	76 0e                	jbe    c010561b <page_init+0x301>
                end = KMEMSIZE;
c010560d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105614:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010561b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010561e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105621:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105624:	0f 87 b4 00 00 00    	ja     c01056de <page_init+0x3c4>
c010562a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010562d:	72 09                	jb     c0105638 <page_init+0x31e>
c010562f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105632:	0f 83 a6 00 00 00    	jae    c01056de <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105638:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010563f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105642:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105645:	01 d0                	add    %edx,%eax
c0105647:	83 e8 01             	sub    $0x1,%eax
c010564a:	89 45 98             	mov    %eax,-0x68(%ebp)
c010564d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105650:	ba 00 00 00 00       	mov    $0x0,%edx
c0105655:	f7 75 9c             	divl   -0x64(%ebp)
c0105658:	89 d0                	mov    %edx,%eax
c010565a:	8b 55 98             	mov    -0x68(%ebp),%edx
c010565d:	29 c2                	sub    %eax,%edx
c010565f:	89 d0                	mov    %edx,%eax
c0105661:	ba 00 00 00 00       	mov    $0x0,%edx
c0105666:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105669:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010566c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010566f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105672:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105675:	ba 00 00 00 00       	mov    $0x0,%edx
c010567a:	89 c7                	mov    %eax,%edi
c010567c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105682:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105685:	89 d0                	mov    %edx,%eax
c0105687:	83 e0 00             	and    $0x0,%eax
c010568a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010568d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105690:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105693:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105696:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105699:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010569c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010569f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01056a2:	77 3a                	ja     c01056de <page_init+0x3c4>
c01056a4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01056a7:	72 05                	jb     c01056ae <page_init+0x394>
c01056a9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01056ac:	73 30                	jae    c01056de <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01056ae:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01056b1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01056b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01056b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01056ba:	29 c8                	sub    %ecx,%eax
c01056bc:	19 da                	sbb    %ebx,%edx
c01056be:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01056c2:	c1 ea 0c             	shr    $0xc,%edx
c01056c5:	89 c3                	mov    %eax,%ebx
c01056c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01056ca:	89 04 24             	mov    %eax,(%esp)
c01056cd:	e8 8c f8 ff ff       	call   c0104f5e <pa2page>
c01056d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01056d6:	89 04 24             	mov    %eax,(%esp)
c01056d9:	e8 55 fb ff ff       	call   c0105233 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01056de:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01056e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01056e5:	8b 00                	mov    (%eax),%eax
c01056e7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01056ea:	0f 8f 7e fe ff ff    	jg     c010556e <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01056f0:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01056f6:	5b                   	pop    %ebx
c01056f7:	5e                   	pop    %esi
c01056f8:	5f                   	pop    %edi
c01056f9:	5d                   	pop    %ebp
c01056fa:	c3                   	ret    

c01056fb <enable_paging>:

static void
enable_paging(void) {
c01056fb:	55                   	push   %ebp
c01056fc:	89 e5                	mov    %esp,%ebp
c01056fe:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105701:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c0105706:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105709:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010570c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010570f:	0f 20 c0             	mov    %cr0,%eax
c0105712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105715:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105718:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010571b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105722:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105726:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105729:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010572c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010572f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105732:	c9                   	leave  
c0105733:	c3                   	ret    

c0105734 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105734:	55                   	push   %ebp
c0105735:	89 e5                	mov    %esp,%ebp
c0105737:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010573a:	8b 45 14             	mov    0x14(%ebp),%eax
c010573d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105740:	31 d0                	xor    %edx,%eax
c0105742:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105747:	85 c0                	test   %eax,%eax
c0105749:	74 24                	je     c010576f <boot_map_segment+0x3b>
c010574b:	c7 44 24 0c 22 ce 10 	movl   $0xc010ce22,0xc(%esp)
c0105752:	c0 
c0105753:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010575a:	c0 
c010575b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105762:	00 
c0105763:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010576a:	e8 60 b6 ff ff       	call   c0100dcf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010576f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105776:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105779:	25 ff 0f 00 00       	and    $0xfff,%eax
c010577e:	89 c2                	mov    %eax,%edx
c0105780:	8b 45 10             	mov    0x10(%ebp),%eax
c0105783:	01 c2                	add    %eax,%edx
c0105785:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105788:	01 d0                	add    %edx,%eax
c010578a:	83 e8 01             	sub    $0x1,%eax
c010578d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105793:	ba 00 00 00 00       	mov    $0x0,%edx
c0105798:	f7 75 f0             	divl   -0x10(%ebp)
c010579b:	89 d0                	mov    %edx,%eax
c010579d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01057a0:	29 c2                	sub    %eax,%edx
c01057a2:	89 d0                	mov    %edx,%eax
c01057a4:	c1 e8 0c             	shr    $0xc,%eax
c01057a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01057aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01057b8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01057bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01057be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01057c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01057c9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01057cc:	eb 6b                	jmp    c0105839 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01057ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01057d5:	00 
c01057d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	89 04 24             	mov    %eax,(%esp)
c01057e3:	e8 d1 01 00 00       	call   c01059b9 <get_pte>
c01057e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01057eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01057ef:	75 24                	jne    c0105815 <boot_map_segment+0xe1>
c01057f1:	c7 44 24 0c 4e ce 10 	movl   $0xc010ce4e,0xc(%esp)
c01057f8:	c0 
c01057f9:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105800:	c0 
c0105801:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105808:	00 
c0105809:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105810:	e8 ba b5 ff ff       	call   c0100dcf <__panic>
        *ptep = pa | PTE_P | perm;
c0105815:	8b 45 18             	mov    0x18(%ebp),%eax
c0105818:	8b 55 14             	mov    0x14(%ebp),%edx
c010581b:	09 d0                	or     %edx,%eax
c010581d:	83 c8 01             	or     $0x1,%eax
c0105820:	89 c2                	mov    %eax,%edx
c0105822:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105825:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105827:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010582b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105832:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010583d:	75 8f                	jne    c01057ce <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010583f:	c9                   	leave  
c0105840:	c3                   	ret    

c0105841 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105841:	55                   	push   %ebp
c0105842:	89 e5                	mov    %esp,%ebp
c0105844:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010584e:	e8 ff f9 ff ff       	call   c0105252 <alloc_pages>
c0105853:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010585a:	75 1c                	jne    c0105878 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010585c:	c7 44 24 08 5b ce 10 	movl   $0xc010ce5b,0x8(%esp)
c0105863:	c0 
c0105864:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010586b:	00 
c010586c:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105873:	e8 57 b5 ff ff       	call   c0100dcf <__panic>
    }
    return page2kva(p);
c0105878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587b:	89 04 24             	mov    %eax,(%esp)
c010587e:	e8 20 f7 ff ff       	call   c0104fa3 <page2kva>
}
c0105883:	c9                   	leave  
c0105884:	c3                   	ret    

c0105885 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105885:	55                   	push   %ebp
c0105886:	89 e5                	mov    %esp,%ebp
c0105888:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010588b:	e8 70 f9 ff ff       	call   c0105200 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105890:	e8 85 fa ff ff       	call   c010531a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105895:	e8 62 09 00 00       	call   c01061fc <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010589a:	e8 a2 ff ff ff       	call   c0105841 <boot_alloc_page>
c010589f:	a3 e4 ce 19 c0       	mov    %eax,0xc019cee4
    memset(boot_pgdir, 0, PGSIZE);
c01058a4:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01058a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01058b0:	00 
c01058b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01058b8:	00 
c01058b9:	89 04 24             	mov    %eax,(%esp)
c01058bc:	e8 0c 65 00 00       	call   c010bdcd <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01058c1:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01058c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058c9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01058d0:	77 23                	ja     c01058f5 <pmm_init+0x70>
c01058d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058d9:	c7 44 24 08 f0 cd 10 	movl   $0xc010cdf0,0x8(%esp)
c01058e0:	c0 
c01058e1:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01058e8:	00 
c01058e9:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01058f0:	e8 da b4 ff ff       	call   c0100dcf <__panic>
c01058f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058f8:	05 00 00 00 40       	add    $0x40000000,%eax
c01058fd:	a3 c8 ef 19 c0       	mov    %eax,0xc019efc8

    check_pgdir();
c0105902:	e8 13 09 00 00       	call   c010621a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105907:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010590c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105912:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010591a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105921:	77 23                	ja     c0105946 <pmm_init+0xc1>
c0105923:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105926:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010592a:	c7 44 24 08 f0 cd 10 	movl   $0xc010cdf0,0x8(%esp)
c0105931:	c0 
c0105932:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105939:	00 
c010593a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105941:	e8 89 b4 ff ff       	call   c0100dcf <__panic>
c0105946:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105949:	05 00 00 00 40       	add    $0x40000000,%eax
c010594e:	83 c8 03             	or     $0x3,%eax
c0105951:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105953:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105958:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010595f:	00 
c0105960:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105967:	00 
c0105968:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010596f:	38 
c0105970:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105977:	c0 
c0105978:	89 04 24             	mov    %eax,(%esp)
c010597b:	e8 b4 fd ff ff       	call   c0105734 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105980:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105985:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c010598b:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0105991:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105993:	e8 63 fd ff ff       	call   c01056fb <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105998:	e8 74 f7 ff ff       	call   c0105111 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010599d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01059a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01059a8:	e8 08 0f 00 00       	call   c01068b5 <check_boot_pgdir>

    print_pgdir();
c01059ad:	e8 95 13 00 00       	call   c0106d47 <print_pgdir>
    
    kmalloc_init();
c01059b2:	e8 e6 f2 ff ff       	call   c0104c9d <kmalloc_init>

}
c01059b7:	c9                   	leave  
c01059b8:	c3                   	ret    

c01059b9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01059b9:	55                   	push   %ebp
c01059ba:	89 e5                	mov    %esp,%ebp
c01059bc:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t* entry = &pgdir[PDX(la)];
c01059bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c2:	c1 e8 16             	shr    $0x16,%eax
c01059c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01059cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cf:	01 d0                	add    %edx,%eax
c01059d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*entry & PTE_P))
c01059d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059d7:	8b 00                	mov    (%eax),%eax
c01059d9:	83 e0 01             	and    $0x1,%eax
c01059dc:	85 c0                	test   %eax,%eax
c01059de:	0f 85 af 00 00 00    	jne    c0105a93 <get_pte+0xda>
    {
    	struct Page* p;
    	if((!create) || ((p = alloc_page()) == NULL))
c01059e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059e8:	74 15                	je     c01059ff <get_pte+0x46>
c01059ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059f1:	e8 5c f8 ff ff       	call   c0105252 <alloc_pages>
c01059f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059fd:	75 0a                	jne    c0105a09 <get_pte+0x50>
    	{
			return NULL;
c01059ff:	b8 00 00 00 00       	mov    $0x0,%eax
c0105a04:	e9 e6 00 00 00       	jmp    c0105aef <get_pte+0x136>
    	}
		set_page_ref(p, 1);
c0105a09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a10:	00 
c0105a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a14:	89 04 24             	mov    %eax,(%esp)
c0105a17:	e8 3b f6 ff ff       	call   c0105057 <set_page_ref>
		uintptr_t pg_addr = page2pa(p);
c0105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1f:	89 04 24             	mov    %eax,(%esp)
c0105a22:	e8 21 f5 ff ff       	call   c0104f48 <page2pa>
c0105a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pg_addr), 0, PGSIZE);
c0105a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a33:	c1 e8 0c             	shr    $0xc,%eax
c0105a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a39:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105a3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105a41:	72 23                	jb     c0105a66 <get_pte+0xad>
c0105a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a46:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a4a:	c7 44 24 08 4c cd 10 	movl   $0xc010cd4c,0x8(%esp)
c0105a51:	c0 
c0105a52:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c0105a59:	00 
c0105a5a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105a61:	e8 69 b3 ff ff       	call   c0100dcf <__panic>
c0105a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a69:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105a6e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105a75:	00 
c0105a76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a7d:	00 
c0105a7e:	89 04 24             	mov    %eax,(%esp)
c0105a81:	e8 47 63 00 00       	call   c010bdcd <memset>
		*entry = pg_addr | PTE_U | PTE_W | PTE_P;
c0105a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a89:	83 c8 07             	or     $0x7,%eax
c0105a8c:	89 c2                	mov    %eax,%edx
c0105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a91:	89 10                	mov    %edx,(%eax)
   	}
    return &((pte_t*)KADDR(PDE_ADDR(*entry)))[PTX(la)];
c0105a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a96:	8b 00                	mov    (%eax),%eax
c0105a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aa3:	c1 e8 0c             	shr    $0xc,%eax
c0105aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105aa9:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105aae:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105ab1:	72 23                	jb     c0105ad6 <get_pte+0x11d>
c0105ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ab6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aba:	c7 44 24 08 4c cd 10 	movl   $0xc010cd4c,0x8(%esp)
c0105ac1:	c0 
c0105ac2:	c7 44 24 04 9c 01 00 	movl   $0x19c,0x4(%esp)
c0105ac9:	00 
c0105aca:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105ad1:	e8 f9 b2 ff ff       	call   c0100dcf <__panic>
c0105ad6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ad9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105ade:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ae1:	c1 ea 0c             	shr    $0xc,%edx
c0105ae4:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105aea:	c1 e2 02             	shl    $0x2,%edx
c0105aed:	01 d0                	add    %edx,%eax
}
c0105aef:	c9                   	leave  
c0105af0:	c3                   	ret    

c0105af1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105af1:	55                   	push   %ebp
c0105af2:	89 e5                	mov    %esp,%ebp
c0105af4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105afe:	00 
c0105aff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b09:	89 04 24             	mov    %eax,(%esp)
c0105b0c:	e8 a8 fe ff ff       	call   c01059b9 <get_pte>
c0105b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b18:	74 08                	je     c0105b22 <get_page+0x31>
        *ptep_store = ptep;
c0105b1a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b20:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105b26:	74 1b                	je     c0105b43 <get_page+0x52>
c0105b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b2b:	8b 00                	mov    (%eax),%eax
c0105b2d:	83 e0 01             	and    $0x1,%eax
c0105b30:	85 c0                	test   %eax,%eax
c0105b32:	74 0f                	je     c0105b43 <get_page+0x52>
        return pa2page(*ptep);
c0105b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b37:	8b 00                	mov    (%eax),%eax
c0105b39:	89 04 24             	mov    %eax,(%esp)
c0105b3c:	e8 1d f4 ff ff       	call   c0104f5e <pa2page>
c0105b41:	eb 05                	jmp    c0105b48 <get_page+0x57>
    }
    return NULL;
c0105b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b48:	c9                   	leave  
c0105b49:	c3                   	ret    

c0105b4a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105b4a:	55                   	push   %ebp
c0105b4b:	89 e5                	mov    %esp,%ebp
c0105b4d:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
c0105b50:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b53:	8b 00                	mov    (%eax),%eax
c0105b55:	83 e0 01             	and    $0x1,%eax
c0105b58:	85 c0                	test   %eax,%eax
c0105b5a:	74 52                	je     c0105bae <page_remove_pte+0x64>
	{
		struct Page* page = pte2page(*ptep);
c0105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b5f:	8b 00                	mov    (%eax),%eax
c0105b61:	89 04 24             	mov    %eax,(%esp)
c0105b64:	e8 8e f4 ff ff       	call   c0104ff7 <pte2page>
c0105b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int re = page_ref_dec(page);
c0105b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b6f:	89 04 24             	mov    %eax,(%esp)
c0105b72:	e8 04 f5 ff ff       	call   c010507b <page_ref_dec>
c0105b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(re == 0)
c0105b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b7e:	75 13                	jne    c0105b93 <page_remove_pte+0x49>
		{
			free_page(page);
c0105b80:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b87:	00 
c0105b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b8b:	89 04 24             	mov    %eax,(%esp)
c0105b8e:	e8 2a f7 ff ff       	call   c01052bd <free_pages>
		}
		*ptep = 0;
c0105b93:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c0105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba6:	89 04 24             	mov    %eax,(%esp)
c0105ba9:	e8 1d 05 00 00       	call   c01060cb <tlb_invalidate>
	}
}
c0105bae:	c9                   	leave  
c0105baf:	c3                   	ret    

c0105bb0 <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105bb0:	55                   	push   %ebp
c0105bb1:	89 e5                	mov    %esp,%ebp
c0105bb3:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105bbe:	85 c0                	test   %eax,%eax
c0105bc0:	75 0c                	jne    c0105bce <unmap_range+0x1e>
c0105bc2:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bc5:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105bca:	85 c0                	test   %eax,%eax
c0105bcc:	74 24                	je     c0105bf2 <unmap_range+0x42>
c0105bce:	c7 44 24 0c 74 ce 10 	movl   $0xc010ce74,0xc(%esp)
c0105bd5:	c0 
c0105bd6:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105bdd:	c0 
c0105bde:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0105be5:	00 
c0105be6:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105bed:	e8 dd b1 ff ff       	call   c0100dcf <__panic>
    assert(USER_ACCESS(start, end));
c0105bf2:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105bf9:	76 11                	jbe    c0105c0c <unmap_range+0x5c>
c0105bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfe:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c01:	73 09                	jae    c0105c0c <unmap_range+0x5c>
c0105c03:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105c0a:	76 24                	jbe    c0105c30 <unmap_range+0x80>
c0105c0c:	c7 44 24 0c 9d ce 10 	movl   $0xc010ce9d,0xc(%esp)
c0105c13:	c0 
c0105c14:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105c1b:	c0 
c0105c1c:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0105c23:	00 
c0105c24:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105c2b:	e8 9f b1 ff ff       	call   c0100dcf <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105c30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c37:	00 
c0105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c42:	89 04 24             	mov    %eax,(%esp)
c0105c45:	e8 6f fd ff ff       	call   c01059b9 <get_pte>
c0105c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c51:	75 18                	jne    c0105c6b <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c56:	05 00 00 40 00       	add    $0x400000,%eax
c0105c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c61:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105c66:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105c69:	eb 29                	jmp    c0105c94 <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c6e:	8b 00                	mov    (%eax),%eax
c0105c70:	85 c0                	test   %eax,%eax
c0105c72:	74 19                	je     c0105c8d <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c0105c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c77:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c85:	89 04 24             	mov    %eax,(%esp)
c0105c88:	e8 bd fe ff ff       	call   c0105b4a <page_remove_pte>
        }
        start += PGSIZE;
c0105c8d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105c94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c98:	74 08                	je     c0105ca2 <unmap_range+0xf2>
c0105c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c9d:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105ca0:	72 8e                	jb     c0105c30 <unmap_range+0x80>
}
c0105ca2:	c9                   	leave  
c0105ca3:	c3                   	ret    

c0105ca4 <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105ca4:	55                   	push   %ebp
c0105ca5:	89 e5                	mov    %esp,%ebp
c0105ca7:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105caa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cad:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105cb2:	85 c0                	test   %eax,%eax
c0105cb4:	75 0c                	jne    c0105cc2 <exit_range+0x1e>
c0105cb6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cb9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105cbe:	85 c0                	test   %eax,%eax
c0105cc0:	74 24                	je     c0105ce6 <exit_range+0x42>
c0105cc2:	c7 44 24 0c 74 ce 10 	movl   $0xc010ce74,0xc(%esp)
c0105cc9:	c0 
c0105cca:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105cd1:	c0 
c0105cd2:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0105cd9:	00 
c0105cda:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105ce1:	e8 e9 b0 ff ff       	call   c0100dcf <__panic>
    assert(USER_ACCESS(start, end));
c0105ce6:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105ced:	76 11                	jbe    c0105d00 <exit_range+0x5c>
c0105cef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cf5:	73 09                	jae    c0105d00 <exit_range+0x5c>
c0105cf7:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105cfe:	76 24                	jbe    c0105d24 <exit_range+0x80>
c0105d00:	c7 44 24 0c 9d ce 10 	movl   $0xc010ce9d,0xc(%esp)
c0105d07:	c0 
c0105d08:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105d0f:	c0 
c0105d10:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0105d17:	00 
c0105d18:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105d1f:	e8 ab b0 ff ff       	call   c0100dcf <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105d24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d2d:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105d32:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105d35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d38:	c1 e8 16             	shr    $0x16,%eax
c0105d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4b:	01 d0                	add    %edx,%eax
c0105d4d:	8b 00                	mov    (%eax),%eax
c0105d4f:	83 e0 01             	and    $0x1,%eax
c0105d52:	85 c0                	test   %eax,%eax
c0105d54:	74 3e                	je     c0105d94 <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d63:	01 d0                	add    %edx,%eax
c0105d65:	8b 00                	mov    (%eax),%eax
c0105d67:	89 04 24             	mov    %eax,(%esp)
c0105d6a:	e8 c6 f2 ff ff       	call   c0105035 <pde2page>
c0105d6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d76:	00 
c0105d77:	89 04 24             	mov    %eax,(%esp)
c0105d7a:	e8 3e f5 ff ff       	call   c01052bd <free_pages>
            pgdir[pde_idx] = 0;
c0105d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8c:	01 d0                	add    %edx,%eax
c0105d8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c0105d94:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105d9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d9f:	74 08                	je     c0105da9 <exit_range+0x105>
c0105da1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da4:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105da7:	72 8c                	jb     c0105d35 <exit_range+0x91>
}
c0105da9:	c9                   	leave  
c0105daa:	c3                   	ret    

c0105dab <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105dab:	55                   	push   %ebp
c0105dac:	89 e5                	mov    %esp,%ebp
c0105dae:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105db1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105db4:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105db9:	85 c0                	test   %eax,%eax
c0105dbb:	75 0c                	jne    c0105dc9 <copy_range+0x1e>
c0105dbd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dc0:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105dc5:	85 c0                	test   %eax,%eax
c0105dc7:	74 24                	je     c0105ded <copy_range+0x42>
c0105dc9:	c7 44 24 0c 74 ce 10 	movl   $0xc010ce74,0xc(%esp)
c0105dd0:	c0 
c0105dd1:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105dd8:	c0 
c0105dd9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0105de0:	00 
c0105de1:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105de8:	e8 e2 af ff ff       	call   c0100dcf <__panic>
    assert(USER_ACCESS(start, end));
c0105ded:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105df4:	76 11                	jbe    c0105e07 <copy_range+0x5c>
c0105df6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df9:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105dfc:	73 09                	jae    c0105e07 <copy_range+0x5c>
c0105dfe:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105e05:	76 24                	jbe    c0105e2b <copy_range+0x80>
c0105e07:	c7 44 24 0c 9d ce 10 	movl   $0xc010ce9d,0xc(%esp)
c0105e0e:	c0 
c0105e0f:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105e16:	c0 
c0105e17:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0105e1e:	00 
c0105e1f:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105e26:	e8 a4 af ff ff       	call   c0100dcf <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105e2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e32:	00 
c0105e33:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3d:	89 04 24             	mov    %eax,(%esp)
c0105e40:	e8 74 fb ff ff       	call   c01059b9 <get_pte>
c0105e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e4c:	75 1b                	jne    c0105e69 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105e4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e51:	05 00 00 40 00       	add    $0x400000,%eax
c0105e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5c:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105e61:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105e64:	e9 4c 01 00 00       	jmp    c0105fb5 <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e6c:	8b 00                	mov    (%eax),%eax
c0105e6e:	83 e0 01             	and    $0x1,%eax
c0105e71:	85 c0                	test   %eax,%eax
c0105e73:	0f 84 35 01 00 00    	je     c0105fae <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105e79:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105e80:	00 
c0105e81:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8b:	89 04 24             	mov    %eax,(%esp)
c0105e8e:	e8 26 fb ff ff       	call   c01059b9 <get_pte>
c0105e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105e9a:	75 0a                	jne    c0105ea6 <copy_range+0xfb>
                return -E_NO_MEM;
c0105e9c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105ea1:	e9 26 01 00 00       	jmp    c0105fcc <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ea9:	8b 00                	mov    (%eax),%eax
c0105eab:	83 e0 07             	and    $0x7,%eax
c0105eae:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105eb4:	8b 00                	mov    (%eax),%eax
c0105eb6:	89 04 24             	mov    %eax,(%esp)
c0105eb9:	e8 39 f1 ff ff       	call   c0104ff7 <pte2page>
c0105ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105ec1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ec8:	e8 85 f3 ff ff       	call   c0105252 <alloc_pages>
c0105ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105ed0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ed4:	75 24                	jne    c0105efa <copy_range+0x14f>
c0105ed6:	c7 44 24 0c b5 ce 10 	movl   $0xc010ceb5,0xc(%esp)
c0105edd:	c0 
c0105ede:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105ee5:	c0 
c0105ee6:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0105eed:	00 
c0105eee:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105ef5:	e8 d5 ae ff ff       	call   c0100dcf <__panic>
        assert(npage!=NULL);
c0105efa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105efe:	75 24                	jne    c0105f24 <copy_range+0x179>
c0105f00:	c7 44 24 0c c0 ce 10 	movl   $0xc010cec0,0xc(%esp)
c0105f07:	c0 
c0105f08:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105f0f:	c0 
c0105f10:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105f17:	00 
c0105f18:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105f1f:	e8 ab ae ff ff       	call   c0100dcf <__panic>
        int ret=0;
c0105f24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        void* src_kvaddr = page2kva(page);
c0105f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f2e:	89 04 24             	mov    %eax,(%esp)
c0105f31:	e8 6d f0 ff ff       	call   c0104fa3 <page2kva>
c0105f36:	89 45 d8             	mov    %eax,-0x28(%ebp)
        void* dst_kvaddr = page2kva(npage);
c0105f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f3c:	89 04 24             	mov    %eax,(%esp)
c0105f3f:	e8 5f f0 ff ff       	call   c0104fa3 <page2kva>
c0105f44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105f47:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105f4e:	00 
c0105f4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105f52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105f59:	89 04 24             	mov    %eax,(%esp)
c0105f5c:	e8 4e 5f 00 00       	call   c010beaf <memcpy>
        ret = page_insert(to, npage, start, perm);
c0105f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f64:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f68:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f6b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f79:	89 04 24             	mov    %eax,(%esp)
c0105f7c:	e8 91 00 00 00       	call   c0106012 <page_insert>
c0105f81:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(ret == 0);
c0105f84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105f88:	74 24                	je     c0105fae <copy_range+0x203>
c0105f8a:	c7 44 24 0c cc ce 10 	movl   $0xc010cecc,0xc(%esp)
c0105f91:	c0 
c0105f92:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0105f99:	c0 
c0105f9a:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105fa1:	00 
c0105fa2:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0105fa9:	e8 21 ae ff ff       	call   c0100dcf <__panic>
        }
        start += PGSIZE;
c0105fae:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fb9:	74 0c                	je     c0105fc7 <copy_range+0x21c>
c0105fbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fbe:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105fc1:	0f 82 64 fe ff ff    	jb     c0105e2b <copy_range+0x80>
    return 0;
c0105fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fcc:	c9                   	leave  
c0105fcd:	c3                   	ret    

c0105fce <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105fce:	55                   	push   %ebp
c0105fcf:	89 e5                	mov    %esp,%ebp
c0105fd1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105fd4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fdb:	00 
c0105fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fe3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe6:	89 04 24             	mov    %eax,(%esp)
c0105fe9:	e8 cb f9 ff ff       	call   c01059b9 <get_pte>
c0105fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105ff5:	74 19                	je     c0106010 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ffa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106001:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106005:	8b 45 08             	mov    0x8(%ebp),%eax
c0106008:	89 04 24             	mov    %eax,(%esp)
c010600b:	e8 3a fb ff ff       	call   c0105b4a <page_remove_pte>
    }
}
c0106010:	c9                   	leave  
c0106011:	c3                   	ret    

c0106012 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0106012:	55                   	push   %ebp
c0106013:	89 e5                	mov    %esp,%ebp
c0106015:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0106018:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010601f:	00 
c0106020:	8b 45 10             	mov    0x10(%ebp),%eax
c0106023:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106027:	8b 45 08             	mov    0x8(%ebp),%eax
c010602a:	89 04 24             	mov    %eax,(%esp)
c010602d:	e8 87 f9 ff ff       	call   c01059b9 <get_pte>
c0106032:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0106035:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106039:	75 0a                	jne    c0106045 <page_insert+0x33>
        return -E_NO_MEM;
c010603b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0106040:	e9 84 00 00 00       	jmp    c01060c9 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0106045:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106048:	89 04 24             	mov    %eax,(%esp)
c010604b:	e8 14 f0 ff ff       	call   c0105064 <page_ref_inc>
    if (*ptep & PTE_P) {
c0106050:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106053:	8b 00                	mov    (%eax),%eax
c0106055:	83 e0 01             	and    $0x1,%eax
c0106058:	85 c0                	test   %eax,%eax
c010605a:	74 3e                	je     c010609a <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010605c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010605f:	8b 00                	mov    (%eax),%eax
c0106061:	89 04 24             	mov    %eax,(%esp)
c0106064:	e8 8e ef ff ff       	call   c0104ff7 <pte2page>
c0106069:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010606c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010606f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106072:	75 0d                	jne    c0106081 <page_insert+0x6f>
            page_ref_dec(page);
c0106074:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106077:	89 04 24             	mov    %eax,(%esp)
c010607a:	e8 fc ef ff ff       	call   c010507b <page_ref_dec>
c010607f:	eb 19                	jmp    c010609a <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0106081:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106084:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106088:	8b 45 10             	mov    0x10(%ebp),%eax
c010608b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010608f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106092:	89 04 24             	mov    %eax,(%esp)
c0106095:	e8 b0 fa ff ff       	call   c0105b4a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010609a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010609d:	89 04 24             	mov    %eax,(%esp)
c01060a0:	e8 a3 ee ff ff       	call   c0104f48 <page2pa>
c01060a5:	0b 45 14             	or     0x14(%ebp),%eax
c01060a8:	83 c8 01             	or     $0x1,%eax
c01060ab:	89 c2                	mov    %eax,%edx
c01060ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060b0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01060b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01060b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01060bc:	89 04 24             	mov    %eax,(%esp)
c01060bf:	e8 07 00 00 00       	call   c01060cb <tlb_invalidate>
    return 0;
c01060c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060c9:	c9                   	leave  
c01060ca:	c3                   	ret    

c01060cb <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01060cb:	55                   	push   %ebp
c01060cc:	89 e5                	mov    %esp,%ebp
c01060ce:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01060d1:	0f 20 d8             	mov    %cr3,%eax
c01060d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01060d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01060da:	89 c2                	mov    %eax,%edx
c01060dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060e2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01060e9:	77 23                	ja     c010610e <tlb_invalidate+0x43>
c01060eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060f2:	c7 44 24 08 f0 cd 10 	movl   $0xc010cdf0,0x8(%esp)
c01060f9:	c0 
c01060fa:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0106101:	00 
c0106102:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106109:	e8 c1 ac ff ff       	call   c0100dcf <__panic>
c010610e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106111:	05 00 00 00 40       	add    $0x40000000,%eax
c0106116:	39 c2                	cmp    %eax,%edx
c0106118:	75 0c                	jne    c0106126 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010611a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010611d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0106120:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106123:	0f 01 38             	invlpg (%eax)
    }
}
c0106126:	c9                   	leave  
c0106127:	c3                   	ret    

c0106128 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0106128:	55                   	push   %ebp
c0106129:	89 e5                	mov    %esp,%ebp
c010612b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010612e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106135:	e8 18 f1 ff ff       	call   c0105252 <alloc_pages>
c010613a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010613d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106141:	0f 84 b0 00 00 00    	je     c01061f7 <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0106147:	8b 45 10             	mov    0x10(%ebp),%eax
c010614a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010614e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106151:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106155:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106158:	89 44 24 04          	mov    %eax,0x4(%esp)
c010615c:	8b 45 08             	mov    0x8(%ebp),%eax
c010615f:	89 04 24             	mov    %eax,(%esp)
c0106162:	e8 ab fe ff ff       	call   c0106012 <page_insert>
c0106167:	85 c0                	test   %eax,%eax
c0106169:	74 1a                	je     c0106185 <pgdir_alloc_page+0x5d>
            free_page(page);
c010616b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106172:	00 
c0106173:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106176:	89 04 24             	mov    %eax,(%esp)
c0106179:	e8 3f f1 ff ff       	call   c01052bd <free_pages>
            return NULL;
c010617e:	b8 00 00 00 00       	mov    $0x0,%eax
c0106183:	eb 75                	jmp    c01061fa <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0106185:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c010618a:	85 c0                	test   %eax,%eax
c010618c:	74 69                	je     c01061f7 <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c010618e:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0106193:	85 c0                	test   %eax,%eax
c0106195:	74 60                	je     c01061f7 <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0106197:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010619c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01061a3:	00 
c01061a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061a7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061ab:	8b 55 0c             	mov    0xc(%ebp),%edx
c01061ae:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061b2:	89 04 24             	mov    %eax,(%esp)
c01061b5:	e8 3e 0e 00 00       	call   c0106ff8 <swap_map_swappable>
                page->pra_vaddr=la;
c01061ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01061c0:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c01061c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061c6:	89 04 24             	mov    %eax,(%esp)
c01061c9:	e8 7f ee ff ff       	call   c010504d <page_ref>
c01061ce:	83 f8 01             	cmp    $0x1,%eax
c01061d1:	74 24                	je     c01061f7 <pgdir_alloc_page+0xcf>
c01061d3:	c7 44 24 0c d5 ce 10 	movl   $0xc010ced5,0xc(%esp)
c01061da:	c0 
c01061db:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01061e2:	c0 
c01061e3:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
c01061ea:	00 
c01061eb:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01061f2:	e8 d8 ab ff ff       	call   c0100dcf <__panic>
            }
        }

    }

    return page;
c01061f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01061fa:	c9                   	leave  
c01061fb:	c3                   	ret    

c01061fc <check_alloc_page>:

static void
check_alloc_page(void) {
c01061fc:	55                   	push   %ebp
c01061fd:	89 e5                	mov    %esp,%ebp
c01061ff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0106202:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0106207:	8b 40 18             	mov    0x18(%eax),%eax
c010620a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010620c:	c7 04 24 ec ce 10 c0 	movl   $0xc010ceec,(%esp)
c0106213:	e8 3b a1 ff ff       	call   c0100353 <cprintf>
}
c0106218:	c9                   	leave  
c0106219:	c3                   	ret    

c010621a <check_pgdir>:

static void
check_pgdir(void) {
c010621a:	55                   	push   %ebp
c010621b:	89 e5                	mov    %esp,%ebp
c010621d:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0106220:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106225:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010622a:	76 24                	jbe    c0106250 <check_pgdir+0x36>
c010622c:	c7 44 24 0c 0b cf 10 	movl   $0xc010cf0b,0xc(%esp)
c0106233:	c0 
c0106234:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010623b:	c0 
c010623c:	c7 44 24 04 87 02 00 	movl   $0x287,0x4(%esp)
c0106243:	00 
c0106244:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010624b:	e8 7f ab ff ff       	call   c0100dcf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0106250:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106255:	85 c0                	test   %eax,%eax
c0106257:	74 0e                	je     c0106267 <check_pgdir+0x4d>
c0106259:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010625e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106263:	85 c0                	test   %eax,%eax
c0106265:	74 24                	je     c010628b <check_pgdir+0x71>
c0106267:	c7 44 24 0c 28 cf 10 	movl   $0xc010cf28,0xc(%esp)
c010626e:	c0 
c010626f:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106276:	c0 
c0106277:	c7 44 24 04 88 02 00 	movl   $0x288,0x4(%esp)
c010627e:	00 
c010627f:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106286:	e8 44 ab ff ff       	call   c0100dcf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010628b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106290:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106297:	00 
c0106298:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010629f:	00 
c01062a0:	89 04 24             	mov    %eax,(%esp)
c01062a3:	e8 49 f8 ff ff       	call   c0105af1 <get_page>
c01062a8:	85 c0                	test   %eax,%eax
c01062aa:	74 24                	je     c01062d0 <check_pgdir+0xb6>
c01062ac:	c7 44 24 0c 60 cf 10 	movl   $0xc010cf60,0xc(%esp)
c01062b3:	c0 
c01062b4:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01062bb:	c0 
c01062bc:	c7 44 24 04 89 02 00 	movl   $0x289,0x4(%esp)
c01062c3:	00 
c01062c4:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01062cb:	e8 ff aa ff ff       	call   c0100dcf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01062d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062d7:	e8 76 ef ff ff       	call   c0105252 <alloc_pages>
c01062dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01062df:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01062e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01062eb:	00 
c01062ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062f3:	00 
c01062f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062fb:	89 04 24             	mov    %eax,(%esp)
c01062fe:	e8 0f fd ff ff       	call   c0106012 <page_insert>
c0106303:	85 c0                	test   %eax,%eax
c0106305:	74 24                	je     c010632b <check_pgdir+0x111>
c0106307:	c7 44 24 0c 88 cf 10 	movl   $0xc010cf88,0xc(%esp)
c010630e:	c0 
c010630f:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106316:	c0 
c0106317:	c7 44 24 04 8d 02 00 	movl   $0x28d,0x4(%esp)
c010631e:	00 
c010631f:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106326:	e8 a4 aa ff ff       	call   c0100dcf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010632b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106330:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106337:	00 
c0106338:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010633f:	00 
c0106340:	89 04 24             	mov    %eax,(%esp)
c0106343:	e8 71 f6 ff ff       	call   c01059b9 <get_pte>
c0106348:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010634b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010634f:	75 24                	jne    c0106375 <check_pgdir+0x15b>
c0106351:	c7 44 24 0c b4 cf 10 	movl   $0xc010cfb4,0xc(%esp)
c0106358:	c0 
c0106359:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106360:	c0 
c0106361:	c7 44 24 04 90 02 00 	movl   $0x290,0x4(%esp)
c0106368:	00 
c0106369:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106370:	e8 5a aa ff ff       	call   c0100dcf <__panic>
    assert(pa2page(*ptep) == p1);
c0106375:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106378:	8b 00                	mov    (%eax),%eax
c010637a:	89 04 24             	mov    %eax,(%esp)
c010637d:	e8 dc eb ff ff       	call   c0104f5e <pa2page>
c0106382:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106385:	74 24                	je     c01063ab <check_pgdir+0x191>
c0106387:	c7 44 24 0c e1 cf 10 	movl   $0xc010cfe1,0xc(%esp)
c010638e:	c0 
c010638f:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106396:	c0 
c0106397:	c7 44 24 04 91 02 00 	movl   $0x291,0x4(%esp)
c010639e:	00 
c010639f:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01063a6:	e8 24 aa ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p1) == 1);
c01063ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063ae:	89 04 24             	mov    %eax,(%esp)
c01063b1:	e8 97 ec ff ff       	call   c010504d <page_ref>
c01063b6:	83 f8 01             	cmp    $0x1,%eax
c01063b9:	74 24                	je     c01063df <check_pgdir+0x1c5>
c01063bb:	c7 44 24 0c f6 cf 10 	movl   $0xc010cff6,0xc(%esp)
c01063c2:	c0 
c01063c3:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01063ca:	c0 
c01063cb:	c7 44 24 04 92 02 00 	movl   $0x292,0x4(%esp)
c01063d2:	00 
c01063d3:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01063da:	e8 f0 a9 ff ff       	call   c0100dcf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01063df:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01063e4:	8b 00                	mov    (%eax),%eax
c01063e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01063eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01063ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063f1:	c1 e8 0c             	shr    $0xc,%eax
c01063f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01063f7:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01063fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01063ff:	72 23                	jb     c0106424 <check_pgdir+0x20a>
c0106401:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106404:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106408:	c7 44 24 08 4c cd 10 	movl   $0xc010cd4c,0x8(%esp)
c010640f:	c0 
c0106410:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c0106417:	00 
c0106418:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010641f:	e8 ab a9 ff ff       	call   c0100dcf <__panic>
c0106424:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106427:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010642c:	83 c0 04             	add    $0x4,%eax
c010642f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0106432:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106437:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010643e:	00 
c010643f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106446:	00 
c0106447:	89 04 24             	mov    %eax,(%esp)
c010644a:	e8 6a f5 ff ff       	call   c01059b9 <get_pte>
c010644f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106452:	74 24                	je     c0106478 <check_pgdir+0x25e>
c0106454:	c7 44 24 0c 08 d0 10 	movl   $0xc010d008,0xc(%esp)
c010645b:	c0 
c010645c:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106463:	c0 
c0106464:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c010646b:	00 
c010646c:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106473:	e8 57 a9 ff ff       	call   c0100dcf <__panic>

    p2 = alloc_page();
c0106478:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010647f:	e8 ce ed ff ff       	call   c0105252 <alloc_pages>
c0106484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106487:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010648c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0106493:	00 
c0106494:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010649b:	00 
c010649c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010649f:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064a3:	89 04 24             	mov    %eax,(%esp)
c01064a6:	e8 67 fb ff ff       	call   c0106012 <page_insert>
c01064ab:	85 c0                	test   %eax,%eax
c01064ad:	74 24                	je     c01064d3 <check_pgdir+0x2b9>
c01064af:	c7 44 24 0c 30 d0 10 	movl   $0xc010d030,0xc(%esp)
c01064b6:	c0 
c01064b7:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01064be:	c0 
c01064bf:	c7 44 24 04 98 02 00 	movl   $0x298,0x4(%esp)
c01064c6:	00 
c01064c7:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01064ce:	e8 fc a8 ff ff       	call   c0100dcf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01064d3:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01064d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01064df:	00 
c01064e0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01064e7:	00 
c01064e8:	89 04 24             	mov    %eax,(%esp)
c01064eb:	e8 c9 f4 ff ff       	call   c01059b9 <get_pte>
c01064f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01064f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01064f7:	75 24                	jne    c010651d <check_pgdir+0x303>
c01064f9:	c7 44 24 0c 68 d0 10 	movl   $0xc010d068,0xc(%esp)
c0106500:	c0 
c0106501:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106508:	c0 
c0106509:	c7 44 24 04 99 02 00 	movl   $0x299,0x4(%esp)
c0106510:	00 
c0106511:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106518:	e8 b2 a8 ff ff       	call   c0100dcf <__panic>
    assert(*ptep & PTE_U);
c010651d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106520:	8b 00                	mov    (%eax),%eax
c0106522:	83 e0 04             	and    $0x4,%eax
c0106525:	85 c0                	test   %eax,%eax
c0106527:	75 24                	jne    c010654d <check_pgdir+0x333>
c0106529:	c7 44 24 0c 98 d0 10 	movl   $0xc010d098,0xc(%esp)
c0106530:	c0 
c0106531:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106538:	c0 
c0106539:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c0106540:	00 
c0106541:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106548:	e8 82 a8 ff ff       	call   c0100dcf <__panic>
    assert(*ptep & PTE_W);
c010654d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106550:	8b 00                	mov    (%eax),%eax
c0106552:	83 e0 02             	and    $0x2,%eax
c0106555:	85 c0                	test   %eax,%eax
c0106557:	75 24                	jne    c010657d <check_pgdir+0x363>
c0106559:	c7 44 24 0c a6 d0 10 	movl   $0xc010d0a6,0xc(%esp)
c0106560:	c0 
c0106561:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106568:	c0 
c0106569:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c0106570:	00 
c0106571:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106578:	e8 52 a8 ff ff       	call   c0100dcf <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010657d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106582:	8b 00                	mov    (%eax),%eax
c0106584:	83 e0 04             	and    $0x4,%eax
c0106587:	85 c0                	test   %eax,%eax
c0106589:	75 24                	jne    c01065af <check_pgdir+0x395>
c010658b:	c7 44 24 0c b4 d0 10 	movl   $0xc010d0b4,0xc(%esp)
c0106592:	c0 
c0106593:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010659a:	c0 
c010659b:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c01065a2:	00 
c01065a3:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01065aa:	e8 20 a8 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p2) == 1);
c01065af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065b2:	89 04 24             	mov    %eax,(%esp)
c01065b5:	e8 93 ea ff ff       	call   c010504d <page_ref>
c01065ba:	83 f8 01             	cmp    $0x1,%eax
c01065bd:	74 24                	je     c01065e3 <check_pgdir+0x3c9>
c01065bf:	c7 44 24 0c ca d0 10 	movl   $0xc010d0ca,0xc(%esp)
c01065c6:	c0 
c01065c7:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01065ce:	c0 
c01065cf:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c01065d6:	00 
c01065d7:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01065de:	e8 ec a7 ff ff       	call   c0100dcf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01065e3:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01065e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01065ef:	00 
c01065f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01065f7:	00 
c01065f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01065fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065ff:	89 04 24             	mov    %eax,(%esp)
c0106602:	e8 0b fa ff ff       	call   c0106012 <page_insert>
c0106607:	85 c0                	test   %eax,%eax
c0106609:	74 24                	je     c010662f <check_pgdir+0x415>
c010660b:	c7 44 24 0c dc d0 10 	movl   $0xc010d0dc,0xc(%esp)
c0106612:	c0 
c0106613:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010661a:	c0 
c010661b:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c0106622:	00 
c0106623:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010662a:	e8 a0 a7 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p1) == 2);
c010662f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106632:	89 04 24             	mov    %eax,(%esp)
c0106635:	e8 13 ea ff ff       	call   c010504d <page_ref>
c010663a:	83 f8 02             	cmp    $0x2,%eax
c010663d:	74 24                	je     c0106663 <check_pgdir+0x449>
c010663f:	c7 44 24 0c 08 d1 10 	movl   $0xc010d108,0xc(%esp)
c0106646:	c0 
c0106647:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010664e:	c0 
c010664f:	c7 44 24 04 a0 02 00 	movl   $0x2a0,0x4(%esp)
c0106656:	00 
c0106657:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010665e:	e8 6c a7 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p2) == 0);
c0106663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106666:	89 04 24             	mov    %eax,(%esp)
c0106669:	e8 df e9 ff ff       	call   c010504d <page_ref>
c010666e:	85 c0                	test   %eax,%eax
c0106670:	74 24                	je     c0106696 <check_pgdir+0x47c>
c0106672:	c7 44 24 0c 1a d1 10 	movl   $0xc010d11a,0xc(%esp)
c0106679:	c0 
c010667a:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106681:	c0 
c0106682:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c0106689:	00 
c010668a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106691:	e8 39 a7 ff ff       	call   c0100dcf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106696:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010669b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01066a2:	00 
c01066a3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01066aa:	00 
c01066ab:	89 04 24             	mov    %eax,(%esp)
c01066ae:	e8 06 f3 ff ff       	call   c01059b9 <get_pte>
c01066b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01066ba:	75 24                	jne    c01066e0 <check_pgdir+0x4c6>
c01066bc:	c7 44 24 0c 68 d0 10 	movl   $0xc010d068,0xc(%esp)
c01066c3:	c0 
c01066c4:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01066cb:	c0 
c01066cc:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c01066d3:	00 
c01066d4:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01066db:	e8 ef a6 ff ff       	call   c0100dcf <__panic>
    assert(pa2page(*ptep) == p1);
c01066e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066e3:	8b 00                	mov    (%eax),%eax
c01066e5:	89 04 24             	mov    %eax,(%esp)
c01066e8:	e8 71 e8 ff ff       	call   c0104f5e <pa2page>
c01066ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01066f0:	74 24                	je     c0106716 <check_pgdir+0x4fc>
c01066f2:	c7 44 24 0c e1 cf 10 	movl   $0xc010cfe1,0xc(%esp)
c01066f9:	c0 
c01066fa:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106701:	c0 
c0106702:	c7 44 24 04 a3 02 00 	movl   $0x2a3,0x4(%esp)
c0106709:	00 
c010670a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106711:	e8 b9 a6 ff ff       	call   c0100dcf <__panic>
    assert((*ptep & PTE_U) == 0);
c0106716:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106719:	8b 00                	mov    (%eax),%eax
c010671b:	83 e0 04             	and    $0x4,%eax
c010671e:	85 c0                	test   %eax,%eax
c0106720:	74 24                	je     c0106746 <check_pgdir+0x52c>
c0106722:	c7 44 24 0c 2c d1 10 	movl   $0xc010d12c,0xc(%esp)
c0106729:	c0 
c010672a:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106731:	c0 
c0106732:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c0106739:	00 
c010673a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106741:	e8 89 a6 ff ff       	call   c0100dcf <__panic>

    page_remove(boot_pgdir, 0x0);
c0106746:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010674b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106752:	00 
c0106753:	89 04 24             	mov    %eax,(%esp)
c0106756:	e8 73 f8 ff ff       	call   c0105fce <page_remove>
    assert(page_ref(p1) == 1);
c010675b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010675e:	89 04 24             	mov    %eax,(%esp)
c0106761:	e8 e7 e8 ff ff       	call   c010504d <page_ref>
c0106766:	83 f8 01             	cmp    $0x1,%eax
c0106769:	74 24                	je     c010678f <check_pgdir+0x575>
c010676b:	c7 44 24 0c f6 cf 10 	movl   $0xc010cff6,0xc(%esp)
c0106772:	c0 
c0106773:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010677a:	c0 
c010677b:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c0106782:	00 
c0106783:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010678a:	e8 40 a6 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p2) == 0);
c010678f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106792:	89 04 24             	mov    %eax,(%esp)
c0106795:	e8 b3 e8 ff ff       	call   c010504d <page_ref>
c010679a:	85 c0                	test   %eax,%eax
c010679c:	74 24                	je     c01067c2 <check_pgdir+0x5a8>
c010679e:	c7 44 24 0c 1a d1 10 	movl   $0xc010d11a,0xc(%esp)
c01067a5:	c0 
c01067a6:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01067ad:	c0 
c01067ae:	c7 44 24 04 a8 02 00 	movl   $0x2a8,0x4(%esp)
c01067b5:	00 
c01067b6:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01067bd:	e8 0d a6 ff ff       	call   c0100dcf <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01067c2:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01067c7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01067ce:	00 
c01067cf:	89 04 24             	mov    %eax,(%esp)
c01067d2:	e8 f7 f7 ff ff       	call   c0105fce <page_remove>
    assert(page_ref(p1) == 0);
c01067d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067da:	89 04 24             	mov    %eax,(%esp)
c01067dd:	e8 6b e8 ff ff       	call   c010504d <page_ref>
c01067e2:	85 c0                	test   %eax,%eax
c01067e4:	74 24                	je     c010680a <check_pgdir+0x5f0>
c01067e6:	c7 44 24 0c 41 d1 10 	movl   $0xc010d141,0xc(%esp)
c01067ed:	c0 
c01067ee:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c01067f5:	c0 
c01067f6:	c7 44 24 04 ab 02 00 	movl   $0x2ab,0x4(%esp)
c01067fd:	00 
c01067fe:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106805:	e8 c5 a5 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p2) == 0);
c010680a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010680d:	89 04 24             	mov    %eax,(%esp)
c0106810:	e8 38 e8 ff ff       	call   c010504d <page_ref>
c0106815:	85 c0                	test   %eax,%eax
c0106817:	74 24                	je     c010683d <check_pgdir+0x623>
c0106819:	c7 44 24 0c 1a d1 10 	movl   $0xc010d11a,0xc(%esp)
c0106820:	c0 
c0106821:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106828:	c0 
c0106829:	c7 44 24 04 ac 02 00 	movl   $0x2ac,0x4(%esp)
c0106830:	00 
c0106831:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106838:	e8 92 a5 ff ff       	call   c0100dcf <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c010683d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106842:	8b 00                	mov    (%eax),%eax
c0106844:	89 04 24             	mov    %eax,(%esp)
c0106847:	e8 12 e7 ff ff       	call   c0104f5e <pa2page>
c010684c:	89 04 24             	mov    %eax,(%esp)
c010684f:	e8 f9 e7 ff ff       	call   c010504d <page_ref>
c0106854:	83 f8 01             	cmp    $0x1,%eax
c0106857:	74 24                	je     c010687d <check_pgdir+0x663>
c0106859:	c7 44 24 0c 54 d1 10 	movl   $0xc010d154,0xc(%esp)
c0106860:	c0 
c0106861:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106868:	c0 
c0106869:	c7 44 24 04 ae 02 00 	movl   $0x2ae,0x4(%esp)
c0106870:	00 
c0106871:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106878:	e8 52 a5 ff ff       	call   c0100dcf <__panic>
    free_page(pa2page(boot_pgdir[0]));
c010687d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106882:	8b 00                	mov    (%eax),%eax
c0106884:	89 04 24             	mov    %eax,(%esp)
c0106887:	e8 d2 e6 ff ff       	call   c0104f5e <pa2page>
c010688c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106893:	00 
c0106894:	89 04 24             	mov    %eax,(%esp)
c0106897:	e8 21 ea ff ff       	call   c01052bd <free_pages>
    boot_pgdir[0] = 0;
c010689c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01068a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01068a7:	c7 04 24 7a d1 10 c0 	movl   $0xc010d17a,(%esp)
c01068ae:	e8 a0 9a ff ff       	call   c0100353 <cprintf>
}
c01068b3:	c9                   	leave  
c01068b4:	c3                   	ret    

c01068b5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01068b5:	55                   	push   %ebp
c01068b6:	89 e5                	mov    %esp,%ebp
c01068b8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01068bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01068c2:	e9 ca 00 00 00       	jmp    c0106991 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01068c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01068cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068d0:	c1 e8 0c             	shr    $0xc,%eax
c01068d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068d6:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01068db:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01068de:	72 23                	jb     c0106903 <check_boot_pgdir+0x4e>
c01068e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01068e7:	c7 44 24 08 4c cd 10 	movl   $0xc010cd4c,0x8(%esp)
c01068ee:	c0 
c01068ef:	c7 44 24 04 ba 02 00 	movl   $0x2ba,0x4(%esp)
c01068f6:	00 
c01068f7:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01068fe:	e8 cc a4 ff ff       	call   c0100dcf <__panic>
c0106903:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106906:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010690b:	89 c2                	mov    %eax,%edx
c010690d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106912:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106919:	00 
c010691a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010691e:	89 04 24             	mov    %eax,(%esp)
c0106921:	e8 93 f0 ff ff       	call   c01059b9 <get_pte>
c0106926:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106929:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010692d:	75 24                	jne    c0106953 <check_boot_pgdir+0x9e>
c010692f:	c7 44 24 0c 94 d1 10 	movl   $0xc010d194,0xc(%esp)
c0106936:	c0 
c0106937:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c010693e:	c0 
c010693f:	c7 44 24 04 ba 02 00 	movl   $0x2ba,0x4(%esp)
c0106946:	00 
c0106947:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c010694e:	e8 7c a4 ff ff       	call   c0100dcf <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106953:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106956:	8b 00                	mov    (%eax),%eax
c0106958:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010695d:	89 c2                	mov    %eax,%edx
c010695f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106962:	39 c2                	cmp    %eax,%edx
c0106964:	74 24                	je     c010698a <check_boot_pgdir+0xd5>
c0106966:	c7 44 24 0c d1 d1 10 	movl   $0xc010d1d1,0xc(%esp)
c010696d:	c0 
c010696e:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106975:	c0 
c0106976:	c7 44 24 04 bb 02 00 	movl   $0x2bb,0x4(%esp)
c010697d:	00 
c010697e:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106985:	e8 45 a4 ff ff       	call   c0100dcf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010698a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106991:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106994:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106999:	39 c2                	cmp    %eax,%edx
c010699b:	0f 82 26 ff ff ff    	jb     c01068c7 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01069a1:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01069a6:	05 ac 0f 00 00       	add    $0xfac,%eax
c01069ab:	8b 00                	mov    (%eax),%eax
c01069ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069b2:	89 c2                	mov    %eax,%edx
c01069b4:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01069b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01069bc:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01069c3:	77 23                	ja     c01069e8 <check_boot_pgdir+0x133>
c01069c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069cc:	c7 44 24 08 f0 cd 10 	movl   $0xc010cdf0,0x8(%esp)
c01069d3:	c0 
c01069d4:	c7 44 24 04 be 02 00 	movl   $0x2be,0x4(%esp)
c01069db:	00 
c01069dc:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c01069e3:	e8 e7 a3 ff ff       	call   c0100dcf <__panic>
c01069e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069eb:	05 00 00 00 40       	add    $0x40000000,%eax
c01069f0:	39 c2                	cmp    %eax,%edx
c01069f2:	74 24                	je     c0106a18 <check_boot_pgdir+0x163>
c01069f4:	c7 44 24 0c e8 d1 10 	movl   $0xc010d1e8,0xc(%esp)
c01069fb:	c0 
c01069fc:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106a03:	c0 
c0106a04:	c7 44 24 04 be 02 00 	movl   $0x2be,0x4(%esp)
c0106a0b:	00 
c0106a0c:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106a13:	e8 b7 a3 ff ff       	call   c0100dcf <__panic>

    assert(boot_pgdir[0] == 0);
c0106a18:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106a1d:	8b 00                	mov    (%eax),%eax
c0106a1f:	85 c0                	test   %eax,%eax
c0106a21:	74 24                	je     c0106a47 <check_boot_pgdir+0x192>
c0106a23:	c7 44 24 0c 1c d2 10 	movl   $0xc010d21c,0xc(%esp)
c0106a2a:	c0 
c0106a2b:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106a32:	c0 
c0106a33:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c0106a3a:	00 
c0106a3b:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106a42:	e8 88 a3 ff ff       	call   c0100dcf <__panic>

    struct Page *p;
    p = alloc_page();
c0106a47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a4e:	e8 ff e7 ff ff       	call   c0105252 <alloc_pages>
c0106a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106a56:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106a5b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106a62:	00 
c0106a63:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106a6a:	00 
c0106a6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106a6e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a72:	89 04 24             	mov    %eax,(%esp)
c0106a75:	e8 98 f5 ff ff       	call   c0106012 <page_insert>
c0106a7a:	85 c0                	test   %eax,%eax
c0106a7c:	74 24                	je     c0106aa2 <check_boot_pgdir+0x1ed>
c0106a7e:	c7 44 24 0c 30 d2 10 	movl   $0xc010d230,0xc(%esp)
c0106a85:	c0 
c0106a86:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106a8d:	c0 
c0106a8e:	c7 44 24 04 c4 02 00 	movl   $0x2c4,0x4(%esp)
c0106a95:	00 
c0106a96:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106a9d:	e8 2d a3 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p) == 1);
c0106aa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106aa5:	89 04 24             	mov    %eax,(%esp)
c0106aa8:	e8 a0 e5 ff ff       	call   c010504d <page_ref>
c0106aad:	83 f8 01             	cmp    $0x1,%eax
c0106ab0:	74 24                	je     c0106ad6 <check_boot_pgdir+0x221>
c0106ab2:	c7 44 24 0c 5e d2 10 	movl   $0xc010d25e,0xc(%esp)
c0106ab9:	c0 
c0106aba:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106ac1:	c0 
c0106ac2:	c7 44 24 04 c5 02 00 	movl   $0x2c5,0x4(%esp)
c0106ac9:	00 
c0106aca:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106ad1:	e8 f9 a2 ff ff       	call   c0100dcf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106ad6:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106adb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106ae2:	00 
c0106ae3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0106aea:	00 
c0106aeb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106aee:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106af2:	89 04 24             	mov    %eax,(%esp)
c0106af5:	e8 18 f5 ff ff       	call   c0106012 <page_insert>
c0106afa:	85 c0                	test   %eax,%eax
c0106afc:	74 24                	je     c0106b22 <check_boot_pgdir+0x26d>
c0106afe:	c7 44 24 0c 70 d2 10 	movl   $0xc010d270,0xc(%esp)
c0106b05:	c0 
c0106b06:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106b0d:	c0 
c0106b0e:	c7 44 24 04 c6 02 00 	movl   $0x2c6,0x4(%esp)
c0106b15:	00 
c0106b16:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106b1d:	e8 ad a2 ff ff       	call   c0100dcf <__panic>
    assert(page_ref(p) == 2);
c0106b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b25:	89 04 24             	mov    %eax,(%esp)
c0106b28:	e8 20 e5 ff ff       	call   c010504d <page_ref>
c0106b2d:	83 f8 02             	cmp    $0x2,%eax
c0106b30:	74 24                	je     c0106b56 <check_boot_pgdir+0x2a1>
c0106b32:	c7 44 24 0c a7 d2 10 	movl   $0xc010d2a7,0xc(%esp)
c0106b39:	c0 
c0106b3a:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106b41:	c0 
c0106b42:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c0106b49:	00 
c0106b4a:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106b51:	e8 79 a2 ff ff       	call   c0100dcf <__panic>

    const char *str = "ucore: Hello world!!";
c0106b56:	c7 45 dc b8 d2 10 c0 	movl   $0xc010d2b8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106b5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b64:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106b6b:	e8 86 4f 00 00       	call   c010baf6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106b70:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106b77:	00 
c0106b78:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106b7f:	e8 eb 4f 00 00       	call   c010bb6f <strcmp>
c0106b84:	85 c0                	test   %eax,%eax
c0106b86:	74 24                	je     c0106bac <check_boot_pgdir+0x2f7>
c0106b88:	c7 44 24 0c d0 d2 10 	movl   $0xc010d2d0,0xc(%esp)
c0106b8f:	c0 
c0106b90:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106b97:	c0 
c0106b98:	c7 44 24 04 cb 02 00 	movl   $0x2cb,0x4(%esp)
c0106b9f:	00 
c0106ba0:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106ba7:	e8 23 a2 ff ff       	call   c0100dcf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106baf:	89 04 24             	mov    %eax,(%esp)
c0106bb2:	e8 ec e3 ff ff       	call   c0104fa3 <page2kva>
c0106bb7:	05 00 01 00 00       	add    $0x100,%eax
c0106bbc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106bbf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106bc6:	e8 d3 4e 00 00       	call   c010ba9e <strlen>
c0106bcb:	85 c0                	test   %eax,%eax
c0106bcd:	74 24                	je     c0106bf3 <check_boot_pgdir+0x33e>
c0106bcf:	c7 44 24 0c 08 d3 10 	movl   $0xc010d308,0xc(%esp)
c0106bd6:	c0 
c0106bd7:	c7 44 24 08 39 ce 10 	movl   $0xc010ce39,0x8(%esp)
c0106bde:	c0 
c0106bdf:	c7 44 24 04 ce 02 00 	movl   $0x2ce,0x4(%esp)
c0106be6:	00 
c0106be7:	c7 04 24 14 ce 10 c0 	movl   $0xc010ce14,(%esp)
c0106bee:	e8 dc a1 ff ff       	call   c0100dcf <__panic>

    free_page(p);
c0106bf3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106bfa:	00 
c0106bfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106bfe:	89 04 24             	mov    %eax,(%esp)
c0106c01:	e8 b7 e6 ff ff       	call   c01052bd <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106c06:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106c0b:	8b 00                	mov    (%eax),%eax
c0106c0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106c12:	89 04 24             	mov    %eax,(%esp)
c0106c15:	e8 44 e3 ff ff       	call   c0104f5e <pa2page>
c0106c1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106c21:	00 
c0106c22:	89 04 24             	mov    %eax,(%esp)
c0106c25:	e8 93 e6 ff ff       	call   c01052bd <free_pages>
    boot_pgdir[0] = 0;
c0106c2a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106c35:	c7 04 24 2c d3 10 c0 	movl   $0xc010d32c,(%esp)
c0106c3c:	e8 12 97 ff ff       	call   c0100353 <cprintf>
}
c0106c41:	c9                   	leave  
c0106c42:	c3                   	ret    

c0106c43 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106c43:	55                   	push   %ebp
c0106c44:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c49:	83 e0 04             	and    $0x4,%eax
c0106c4c:	85 c0                	test   %eax,%eax
c0106c4e:	74 07                	je     c0106c57 <perm2str+0x14>
c0106c50:	b8 75 00 00 00       	mov    $0x75,%eax
c0106c55:	eb 05                	jmp    c0106c5c <perm2str+0x19>
c0106c57:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106c5c:	a2 68 cf 19 c0       	mov    %al,0xc019cf68
    str[1] = 'r';
c0106c61:	c6 05 69 cf 19 c0 72 	movb   $0x72,0xc019cf69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c6b:	83 e0 02             	and    $0x2,%eax
c0106c6e:	85 c0                	test   %eax,%eax
c0106c70:	74 07                	je     c0106c79 <perm2str+0x36>
c0106c72:	b8 77 00 00 00       	mov    $0x77,%eax
c0106c77:	eb 05                	jmp    c0106c7e <perm2str+0x3b>
c0106c79:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106c7e:	a2 6a cf 19 c0       	mov    %al,0xc019cf6a
    str[3] = '\0';
c0106c83:	c6 05 6b cf 19 c0 00 	movb   $0x0,0xc019cf6b
    return str;
c0106c8a:	b8 68 cf 19 c0       	mov    $0xc019cf68,%eax
}
c0106c8f:	5d                   	pop    %ebp
c0106c90:	c3                   	ret    

c0106c91 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106c91:	55                   	push   %ebp
c0106c92:	89 e5                	mov    %esp,%ebp
c0106c94:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106c97:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106c9d:	72 0a                	jb     c0106ca9 <get_pgtable_items+0x18>
        return 0;
c0106c9f:	b8 00 00 00 00       	mov    $0x0,%eax
c0106ca4:	e9 9c 00 00 00       	jmp    c0106d45 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106ca9:	eb 04                	jmp    c0106caf <get_pgtable_items+0x1e>
        start ++;
c0106cab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106caf:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106cb5:	73 18                	jae    c0106ccf <get_pgtable_items+0x3e>
c0106cb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106cc1:	8b 45 14             	mov    0x14(%ebp),%eax
c0106cc4:	01 d0                	add    %edx,%eax
c0106cc6:	8b 00                	mov    (%eax),%eax
c0106cc8:	83 e0 01             	and    $0x1,%eax
c0106ccb:	85 c0                	test   %eax,%eax
c0106ccd:	74 dc                	je     c0106cab <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106ccf:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cd2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106cd5:	73 69                	jae    c0106d40 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106cd7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106cdb:	74 08                	je     c0106ce5 <get_pgtable_items+0x54>
            *left_store = start;
c0106cdd:	8b 45 18             	mov    0x18(%ebp),%eax
c0106ce0:	8b 55 10             	mov    0x10(%ebp),%edx
c0106ce3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106ce5:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ce8:	8d 50 01             	lea    0x1(%eax),%edx
c0106ceb:	89 55 10             	mov    %edx,0x10(%ebp)
c0106cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106cf5:	8b 45 14             	mov    0x14(%ebp),%eax
c0106cf8:	01 d0                	add    %edx,%eax
c0106cfa:	8b 00                	mov    (%eax),%eax
c0106cfc:	83 e0 07             	and    $0x7,%eax
c0106cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106d02:	eb 04                	jmp    c0106d08 <get_pgtable_items+0x77>
            start ++;
c0106d04:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106d0e:	73 1d                	jae    c0106d2d <get_pgtable_items+0x9c>
c0106d10:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106d1a:	8b 45 14             	mov    0x14(%ebp),%eax
c0106d1d:	01 d0                	add    %edx,%eax
c0106d1f:	8b 00                	mov    (%eax),%eax
c0106d21:	83 e0 07             	and    $0x7,%eax
c0106d24:	89 c2                	mov    %eax,%edx
c0106d26:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d29:	39 c2                	cmp    %eax,%edx
c0106d2b:	74 d7                	je     c0106d04 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106d2d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106d31:	74 08                	je     c0106d3b <get_pgtable_items+0xaa>
            *right_store = start;
c0106d33:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106d36:	8b 55 10             	mov    0x10(%ebp),%edx
c0106d39:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d3e:	eb 05                	jmp    c0106d45 <get_pgtable_items+0xb4>
    }
    return 0;
c0106d40:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d45:	c9                   	leave  
c0106d46:	c3                   	ret    

c0106d47 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106d47:	55                   	push   %ebp
c0106d48:	89 e5                	mov    %esp,%ebp
c0106d4a:	57                   	push   %edi
c0106d4b:	56                   	push   %esi
c0106d4c:	53                   	push   %ebx
c0106d4d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106d50:	c7 04 24 4c d3 10 c0 	movl   $0xc010d34c,(%esp)
c0106d57:	e8 f7 95 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106d5c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106d63:	e9 fa 00 00 00       	jmp    c0106e62 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d6b:	89 04 24             	mov    %eax,(%esp)
c0106d6e:	e8 d0 fe ff ff       	call   c0106c43 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106d73:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106d76:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d79:	29 d1                	sub    %edx,%ecx
c0106d7b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106d7d:	89 d6                	mov    %edx,%esi
c0106d7f:	c1 e6 16             	shl    $0x16,%esi
c0106d82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d85:	89 d3                	mov    %edx,%ebx
c0106d87:	c1 e3 16             	shl    $0x16,%ebx
c0106d8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d8d:	89 d1                	mov    %edx,%ecx
c0106d8f:	c1 e1 16             	shl    $0x16,%ecx
c0106d92:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106d95:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d98:	29 d7                	sub    %edx,%edi
c0106d9a:	89 fa                	mov    %edi,%edx
c0106d9c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106da0:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106da4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106dac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106db0:	c7 04 24 7d d3 10 c0 	movl   $0xc010d37d,(%esp)
c0106db7:	e8 97 95 ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dbf:	c1 e0 0a             	shl    $0xa,%eax
c0106dc2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106dc5:	eb 54                	jmp    c0106e1b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106dca:	89 04 24             	mov    %eax,(%esp)
c0106dcd:	e8 71 fe ff ff       	call   c0106c43 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106dd2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106dd5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106dd8:	29 d1                	sub    %edx,%ecx
c0106dda:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106ddc:	89 d6                	mov    %edx,%esi
c0106dde:	c1 e6 0c             	shl    $0xc,%esi
c0106de1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106de4:	89 d3                	mov    %edx,%ebx
c0106de6:	c1 e3 0c             	shl    $0xc,%ebx
c0106de9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106dec:	c1 e2 0c             	shl    $0xc,%edx
c0106def:	89 d1                	mov    %edx,%ecx
c0106df1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106df4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106df7:	29 d7                	sub    %edx,%edi
c0106df9:	89 fa                	mov    %edi,%edx
c0106dfb:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106dff:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106e03:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106e07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106e0b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e0f:	c7 04 24 9c d3 10 c0 	movl   $0xc010d39c,(%esp)
c0106e16:	e8 38 95 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106e1b:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106e20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106e23:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106e26:	89 ce                	mov    %ecx,%esi
c0106e28:	c1 e6 0a             	shl    $0xa,%esi
c0106e2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106e2e:	89 cb                	mov    %ecx,%ebx
c0106e30:	c1 e3 0a             	shl    $0xa,%ebx
c0106e33:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106e36:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106e3a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106e3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106e41:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106e45:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e49:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106e4d:	89 1c 24             	mov    %ebx,(%esp)
c0106e50:	e8 3c fe ff ff       	call   c0106c91 <get_pgtable_items>
c0106e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106e58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106e5c:	0f 85 65 ff ff ff    	jne    c0106dc7 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106e62:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e6a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106e6d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106e71:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106e74:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106e78:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106e7c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e80:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106e87:	00 
c0106e88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106e8f:	e8 fd fd ff ff       	call   c0106c91 <get_pgtable_items>
c0106e94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106e97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106e9b:	0f 85 c7 fe ff ff    	jne    c0106d68 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106ea1:	c7 04 24 c0 d3 10 c0 	movl   $0xc010d3c0,(%esp)
c0106ea8:	e8 a6 94 ff ff       	call   c0100353 <cprintf>
}
c0106ead:	83 c4 4c             	add    $0x4c,%esp
c0106eb0:	5b                   	pop    %ebx
c0106eb1:	5e                   	pop    %esi
c0106eb2:	5f                   	pop    %edi
c0106eb3:	5d                   	pop    %ebp
c0106eb4:	c3                   	ret    

c0106eb5 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106eb5:	55                   	push   %ebp
c0106eb6:	89 e5                	mov    %esp,%ebp
c0106eb8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ebe:	c1 e8 0c             	shr    $0xc,%eax
c0106ec1:	89 c2                	mov    %eax,%edx
c0106ec3:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106ec8:	39 c2                	cmp    %eax,%edx
c0106eca:	72 1c                	jb     c0106ee8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106ecc:	c7 44 24 08 f4 d3 10 	movl   $0xc010d3f4,0x8(%esp)
c0106ed3:	c0 
c0106ed4:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106edb:	00 
c0106edc:	c7 04 24 13 d4 10 c0 	movl   $0xc010d413,(%esp)
c0106ee3:	e8 e7 9e ff ff       	call   c0100dcf <__panic>
    }
    return &pages[PPN(pa)];
c0106ee8:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0106eed:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ef0:	c1 ea 0c             	shr    $0xc,%edx
c0106ef3:	c1 e2 05             	shl    $0x5,%edx
c0106ef6:	01 d0                	add    %edx,%eax
}
c0106ef8:	c9                   	leave  
c0106ef9:	c3                   	ret    

c0106efa <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106efa:	55                   	push   %ebp
c0106efb:	89 e5                	mov    %esp,%ebp
c0106efd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f03:	83 e0 01             	and    $0x1,%eax
c0106f06:	85 c0                	test   %eax,%eax
c0106f08:	75 1c                	jne    c0106f26 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106f0a:	c7 44 24 08 24 d4 10 	movl   $0xc010d424,0x8(%esp)
c0106f11:	c0 
c0106f12:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106f19:	00 
c0106f1a:	c7 04 24 13 d4 10 c0 	movl   $0xc010d413,(%esp)
c0106f21:	e8 a9 9e ff ff       	call   c0100dcf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106f2e:	89 04 24             	mov    %eax,(%esp)
c0106f31:	e8 7f ff ff ff       	call   c0106eb5 <pa2page>
}
c0106f36:	c9                   	leave  
c0106f37:	c3                   	ret    

c0106f38 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106f38:	55                   	push   %ebp
c0106f39:	89 e5                	mov    %esp,%ebp
c0106f3b:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106f3e:	e8 20 23 00 00       	call   c0109263 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106f43:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106f48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106f4d:	76 0c                	jbe    c0106f5b <swap_init+0x23>
c0106f4f:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106f54:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106f59:	76 25                	jbe    c0106f80 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106f5b:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106f60:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f64:	c7 44 24 08 45 d4 10 	movl   $0xc010d445,0x8(%esp)
c0106f6b:	c0 
c0106f6c:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106f73:	00 
c0106f74:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0106f7b:	e8 4f 9e ff ff       	call   c0100dcf <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106f80:	c7 05 74 cf 19 c0 60 	movl   $0xc012aa60,0xc019cf74
c0106f87:	aa 12 c0 
     int r = sm->init();
c0106f8a:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106f8f:	8b 40 04             	mov    0x4(%eax),%eax
c0106f92:	ff d0                	call   *%eax
c0106f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106f9b:	75 26                	jne    c0106fc3 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106f9d:	c7 05 6c cf 19 c0 01 	movl   $0x1,0xc019cf6c
c0106fa4:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106fa7:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106fac:	8b 00                	mov    (%eax),%eax
c0106fae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106fb2:	c7 04 24 6f d4 10 c0 	movl   $0xc010d46f,(%esp)
c0106fb9:	e8 95 93 ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106fbe:	e8 a4 04 00 00       	call   c0107467 <check_swap>
     }

     return r;
c0106fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106fc6:	c9                   	leave  
c0106fc7:	c3                   	ret    

c0106fc8 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106fc8:	55                   	push   %ebp
c0106fc9:	89 e5                	mov    %esp,%ebp
c0106fcb:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106fce:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106fd3:	8b 40 08             	mov    0x8(%eax),%eax
c0106fd6:	8b 55 08             	mov    0x8(%ebp),%edx
c0106fd9:	89 14 24             	mov    %edx,(%esp)
c0106fdc:	ff d0                	call   *%eax
}
c0106fde:	c9                   	leave  
c0106fdf:	c3                   	ret    

c0106fe0 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106fe0:	55                   	push   %ebp
c0106fe1:	89 e5                	mov    %esp,%ebp
c0106fe3:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106fe6:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106feb:	8b 40 0c             	mov    0xc(%eax),%eax
c0106fee:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ff1:	89 14 24             	mov    %edx,(%esp)
c0106ff4:	ff d0                	call   *%eax
}
c0106ff6:	c9                   	leave  
c0106ff7:	c3                   	ret    

c0106ff8 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106ff8:	55                   	push   %ebp
c0106ff9:	89 e5                	mov    %esp,%ebp
c0106ffb:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106ffe:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0107003:	8b 40 10             	mov    0x10(%eax),%eax
c0107006:	8b 55 14             	mov    0x14(%ebp),%edx
c0107009:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010700d:	8b 55 10             	mov    0x10(%ebp),%edx
c0107010:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107014:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107017:	89 54 24 04          	mov    %edx,0x4(%esp)
c010701b:	8b 55 08             	mov    0x8(%ebp),%edx
c010701e:	89 14 24             	mov    %edx,(%esp)
c0107021:	ff d0                	call   *%eax
}
c0107023:	c9                   	leave  
c0107024:	c3                   	ret    

c0107025 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107025:	55                   	push   %ebp
c0107026:	89 e5                	mov    %esp,%ebp
c0107028:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010702b:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0107030:	8b 40 14             	mov    0x14(%eax),%eax
c0107033:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107036:	89 54 24 04          	mov    %edx,0x4(%esp)
c010703a:	8b 55 08             	mov    0x8(%ebp),%edx
c010703d:	89 14 24             	mov    %edx,(%esp)
c0107040:	ff d0                	call   *%eax
}
c0107042:	c9                   	leave  
c0107043:	c3                   	ret    

c0107044 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0107044:	55                   	push   %ebp
c0107045:	89 e5                	mov    %esp,%ebp
c0107047:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010704a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107051:	e9 5a 01 00 00       	jmp    c01071b0 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0107056:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c010705b:	8b 40 18             	mov    0x18(%eax),%eax
c010705e:	8b 55 10             	mov    0x10(%ebp),%edx
c0107061:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107065:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0107068:	89 54 24 04          	mov    %edx,0x4(%esp)
c010706c:	8b 55 08             	mov    0x8(%ebp),%edx
c010706f:	89 14 24             	mov    %edx,(%esp)
c0107072:	ff d0                	call   *%eax
c0107074:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0107077:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010707b:	74 18                	je     c0107095 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010707d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107080:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107084:	c7 04 24 84 d4 10 c0 	movl   $0xc010d484,(%esp)
c010708b:	e8 c3 92 ff ff       	call   c0100353 <cprintf>
c0107090:	e9 27 01 00 00       	jmp    c01071bc <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0107095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107098:	8b 40 1c             	mov    0x1c(%eax),%eax
c010709b:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010709e:	8b 45 08             	mov    0x8(%ebp),%eax
c01070a1:	8b 40 0c             	mov    0xc(%eax),%eax
c01070a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01070ab:	00 
c01070ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01070af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01070b3:	89 04 24             	mov    %eax,(%esp)
c01070b6:	e8 fe e8 ff ff       	call   c01059b9 <get_pte>
c01070bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01070be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01070c1:	8b 00                	mov    (%eax),%eax
c01070c3:	83 e0 01             	and    $0x1,%eax
c01070c6:	85 c0                	test   %eax,%eax
c01070c8:	75 24                	jne    c01070ee <swap_out+0xaa>
c01070ca:	c7 44 24 0c b1 d4 10 	movl   $0xc010d4b1,0xc(%esp)
c01070d1:	c0 
c01070d2:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01070d9:	c0 
c01070da:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01070e1:	00 
c01070e2:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01070e9:	e8 e1 9c ff ff       	call   c0100dcf <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01070ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01070f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01070f4:	8b 52 1c             	mov    0x1c(%edx),%edx
c01070f7:	c1 ea 0c             	shr    $0xc,%edx
c01070fa:	83 c2 01             	add    $0x1,%edx
c01070fd:	c1 e2 08             	shl    $0x8,%edx
c0107100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107104:	89 14 24             	mov    %edx,(%esp)
c0107107:	e8 11 22 00 00       	call   c010931d <swapfs_write>
c010710c:	85 c0                	test   %eax,%eax
c010710e:	74 34                	je     c0107144 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0107110:	c7 04 24 db d4 10 c0 	movl   $0xc010d4db,(%esp)
c0107117:	e8 37 92 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010711c:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0107121:	8b 40 10             	mov    0x10(%eax),%eax
c0107124:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010712e:	00 
c010712f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107133:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107136:	89 54 24 04          	mov    %edx,0x4(%esp)
c010713a:	8b 55 08             	mov    0x8(%ebp),%edx
c010713d:	89 14 24             	mov    %edx,(%esp)
c0107140:	ff d0                	call   *%eax
c0107142:	eb 68                	jmp    c01071ac <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0107144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107147:	8b 40 1c             	mov    0x1c(%eax),%eax
c010714a:	c1 e8 0c             	shr    $0xc,%eax
c010714d:	83 c0 01             	add    $0x1,%eax
c0107150:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107154:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107157:	89 44 24 08          	mov    %eax,0x8(%esp)
c010715b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010715e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107162:	c7 04 24 f4 d4 10 c0 	movl   $0xc010d4f4,(%esp)
c0107169:	e8 e5 91 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010716e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107171:	8b 40 1c             	mov    0x1c(%eax),%eax
c0107174:	c1 e8 0c             	shr    $0xc,%eax
c0107177:	83 c0 01             	add    $0x1,%eax
c010717a:	c1 e0 08             	shl    $0x8,%eax
c010717d:	89 c2                	mov    %eax,%edx
c010717f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107182:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0107184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107187:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010718e:	00 
c010718f:	89 04 24             	mov    %eax,(%esp)
c0107192:	e8 26 e1 ff ff       	call   c01052bd <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0107197:	8b 45 08             	mov    0x8(%ebp),%eax
c010719a:	8b 40 0c             	mov    0xc(%eax),%eax
c010719d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01071a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01071a4:	89 04 24             	mov    %eax,(%esp)
c01071a7:	e8 1f ef ff ff       	call   c01060cb <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01071ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01071b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01071b6:	0f 85 9a fe ff ff    	jne    c0107056 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01071bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01071bf:	c9                   	leave  
c01071c0:	c3                   	ret    

c01071c1 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01071c1:	55                   	push   %ebp
c01071c2:	89 e5                	mov    %esp,%ebp
c01071c4:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01071c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01071ce:	e8 7f e0 ff ff       	call   c0105252 <alloc_pages>
c01071d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01071d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071da:	75 24                	jne    c0107200 <swap_in+0x3f>
c01071dc:	c7 44 24 0c 34 d5 10 	movl   $0xc010d534,0xc(%esp)
c01071e3:	c0 
c01071e4:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01071eb:	c0 
c01071ec:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01071f3:	00 
c01071f4:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01071fb:	e8 cf 9b ff ff       	call   c0100dcf <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0107200:	8b 45 08             	mov    0x8(%ebp),%eax
c0107203:	8b 40 0c             	mov    0xc(%eax),%eax
c0107206:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010720d:	00 
c010720e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107211:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107215:	89 04 24             	mov    %eax,(%esp)
c0107218:	e8 9c e7 ff ff       	call   c01059b9 <get_pte>
c010721d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0107220:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107223:	8b 00                	mov    (%eax),%eax
c0107225:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107228:	89 54 24 04          	mov    %edx,0x4(%esp)
c010722c:	89 04 24             	mov    %eax,(%esp)
c010722f:	e8 77 20 00 00       	call   c01092ab <swapfs_read>
c0107234:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107237:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010723b:	74 2a                	je     c0107267 <swap_in+0xa6>
     {
        assert(r!=0);
c010723d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107241:	75 24                	jne    c0107267 <swap_in+0xa6>
c0107243:	c7 44 24 0c 41 d5 10 	movl   $0xc010d541,0xc(%esp)
c010724a:	c0 
c010724b:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107252:	c0 
c0107253:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c010725a:	00 
c010725b:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107262:	e8 68 9b ff ff       	call   c0100dcf <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0107267:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010726a:	8b 00                	mov    (%eax),%eax
c010726c:	c1 e8 08             	shr    $0x8,%eax
c010726f:	89 c2                	mov    %eax,%edx
c0107271:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107274:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107278:	89 54 24 04          	mov    %edx,0x4(%esp)
c010727c:	c7 04 24 48 d5 10 c0 	movl   $0xc010d548,(%esp)
c0107283:	e8 cb 90 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0107288:	8b 45 10             	mov    0x10(%ebp),%eax
c010728b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010728e:	89 10                	mov    %edx,(%eax)
     return 0;
c0107290:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107295:	c9                   	leave  
c0107296:	c3                   	ret    

c0107297 <check_content_set>:



static inline void
check_content_set(void)
{
c0107297:	55                   	push   %ebp
c0107298:	89 e5                	mov    %esp,%ebp
c010729a:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010729d:	b8 00 10 00 00       	mov    $0x1000,%eax
c01072a2:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01072a5:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01072aa:	83 f8 01             	cmp    $0x1,%eax
c01072ad:	74 24                	je     c01072d3 <check_content_set+0x3c>
c01072af:	c7 44 24 0c 86 d5 10 	movl   $0xc010d586,0xc(%esp)
c01072b6:	c0 
c01072b7:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01072be:	c0 
c01072bf:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01072c6:	00 
c01072c7:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01072ce:	e8 fc 9a ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01072d3:	b8 10 10 00 00       	mov    $0x1010,%eax
c01072d8:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01072db:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01072e0:	83 f8 01             	cmp    $0x1,%eax
c01072e3:	74 24                	je     c0107309 <check_content_set+0x72>
c01072e5:	c7 44 24 0c 86 d5 10 	movl   $0xc010d586,0xc(%esp)
c01072ec:	c0 
c01072ed:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01072f4:	c0 
c01072f5:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01072fc:	00 
c01072fd:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107304:	e8 c6 9a ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0107309:	b8 00 20 00 00       	mov    $0x2000,%eax
c010730e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0107311:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107316:	83 f8 02             	cmp    $0x2,%eax
c0107319:	74 24                	je     c010733f <check_content_set+0xa8>
c010731b:	c7 44 24 0c 95 d5 10 	movl   $0xc010d595,0xc(%esp)
c0107322:	c0 
c0107323:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c010732a:	c0 
c010732b:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0107332:	00 
c0107333:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c010733a:	e8 90 9a ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010733f:	b8 10 20 00 00       	mov    $0x2010,%eax
c0107344:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0107347:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010734c:	83 f8 02             	cmp    $0x2,%eax
c010734f:	74 24                	je     c0107375 <check_content_set+0xde>
c0107351:	c7 44 24 0c 95 d5 10 	movl   $0xc010d595,0xc(%esp)
c0107358:	c0 
c0107359:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107360:	c0 
c0107361:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0107368:	00 
c0107369:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107370:	e8 5a 9a ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0107375:	b8 00 30 00 00       	mov    $0x3000,%eax
c010737a:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010737d:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107382:	83 f8 03             	cmp    $0x3,%eax
c0107385:	74 24                	je     c01073ab <check_content_set+0x114>
c0107387:	c7 44 24 0c a4 d5 10 	movl   $0xc010d5a4,0xc(%esp)
c010738e:	c0 
c010738f:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107396:	c0 
c0107397:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c010739e:	00 
c010739f:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01073a6:	e8 24 9a ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01073ab:	b8 10 30 00 00       	mov    $0x3010,%eax
c01073b0:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01073b3:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01073b8:	83 f8 03             	cmp    $0x3,%eax
c01073bb:	74 24                	je     c01073e1 <check_content_set+0x14a>
c01073bd:	c7 44 24 0c a4 d5 10 	movl   $0xc010d5a4,0xc(%esp)
c01073c4:	c0 
c01073c5:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01073cc:	c0 
c01073cd:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01073d4:	00 
c01073d5:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01073dc:	e8 ee 99 ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01073e1:	b8 00 40 00 00       	mov    $0x4000,%eax
c01073e6:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01073e9:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01073ee:	83 f8 04             	cmp    $0x4,%eax
c01073f1:	74 24                	je     c0107417 <check_content_set+0x180>
c01073f3:	c7 44 24 0c b3 d5 10 	movl   $0xc010d5b3,0xc(%esp)
c01073fa:	c0 
c01073fb:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107402:	c0 
c0107403:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c010740a:	00 
c010740b:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107412:	e8 b8 99 ff ff       	call   c0100dcf <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0107417:	b8 10 40 00 00       	mov    $0x4010,%eax
c010741c:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010741f:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107424:	83 f8 04             	cmp    $0x4,%eax
c0107427:	74 24                	je     c010744d <check_content_set+0x1b6>
c0107429:	c7 44 24 0c b3 d5 10 	movl   $0xc010d5b3,0xc(%esp)
c0107430:	c0 
c0107431:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107438:	c0 
c0107439:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0107440:	00 
c0107441:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107448:	e8 82 99 ff ff       	call   c0100dcf <__panic>
}
c010744d:	c9                   	leave  
c010744e:	c3                   	ret    

c010744f <check_content_access>:

static inline int
check_content_access(void)
{
c010744f:	55                   	push   %ebp
c0107450:	89 e5                	mov    %esp,%ebp
c0107452:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0107455:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c010745a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010745d:	ff d0                	call   *%eax
c010745f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0107462:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107465:	c9                   	leave  
c0107466:	c3                   	ret    

c0107467 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0107467:	55                   	push   %ebp
c0107468:	89 e5                	mov    %esp,%ebp
c010746a:	53                   	push   %ebx
c010746b:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010746e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010747c:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107483:	eb 6b                	jmp    c01074f0 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0107485:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107488:	83 e8 0c             	sub    $0xc,%eax
c010748b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010748e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107491:	83 c0 04             	add    $0x4,%eax
c0107494:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010749b:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010749e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01074a1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01074a4:	0f a3 10             	bt     %edx,(%eax)
c01074a7:	19 c0                	sbb    %eax,%eax
c01074a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01074ac:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01074b0:	0f 95 c0             	setne  %al
c01074b3:	0f b6 c0             	movzbl %al,%eax
c01074b6:	85 c0                	test   %eax,%eax
c01074b8:	75 24                	jne    c01074de <check_swap+0x77>
c01074ba:	c7 44 24 0c c2 d5 10 	movl   $0xc010d5c2,0xc(%esp)
c01074c1:	c0 
c01074c2:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01074c9:	c0 
c01074ca:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01074d1:	00 
c01074d2:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01074d9:	e8 f1 98 ff ff       	call   c0100dcf <__panic>
        count ++, total += p->property;
c01074de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01074e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074e5:	8b 50 08             	mov    0x8(%eax),%edx
c01074e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074eb:	01 d0                	add    %edx,%eax
c01074ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01074f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074f3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01074f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01074f9:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01074fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074ff:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c0107506:	0f 85 79 ff ff ff    	jne    c0107485 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010750c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010750f:	e8 db dd ff ff       	call   c01052ef <nr_free_pages>
c0107514:	39 c3                	cmp    %eax,%ebx
c0107516:	74 24                	je     c010753c <check_swap+0xd5>
c0107518:	c7 44 24 0c d2 d5 10 	movl   $0xc010d5d2,0xc(%esp)
c010751f:	c0 
c0107520:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107527:	c0 
c0107528:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010752f:	00 
c0107530:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107537:	e8 93 98 ff ff       	call   c0100dcf <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010753c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010753f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107546:	89 44 24 04          	mov    %eax,0x4(%esp)
c010754a:	c7 04 24 ec d5 10 c0 	movl   $0xc010d5ec,(%esp)
c0107551:	e8 fd 8d ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0107556:	e8 9c 0a 00 00       	call   c0107ff7 <mm_create>
c010755b:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010755e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107562:	75 24                	jne    c0107588 <check_swap+0x121>
c0107564:	c7 44 24 0c 12 d6 10 	movl   $0xc010d612,0xc(%esp)
c010756b:	c0 
c010756c:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107573:	c0 
c0107574:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010757b:	00 
c010757c:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107583:	e8 47 98 ff ff       	call   c0100dcf <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0107588:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010758d:	85 c0                	test   %eax,%eax
c010758f:	74 24                	je     c01075b5 <check_swap+0x14e>
c0107591:	c7 44 24 0c 1d d6 10 	movl   $0xc010d61d,0xc(%esp)
c0107598:	c0 
c0107599:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01075a0:	c0 
c01075a1:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01075a8:	00 
c01075a9:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01075b0:	e8 1a 98 ff ff       	call   c0100dcf <__panic>

     check_mm_struct = mm;
c01075b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01075b8:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01075bd:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c01075c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01075c6:	89 50 0c             	mov    %edx,0xc(%eax)
c01075c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01075cc:	8b 40 0c             	mov    0xc(%eax),%eax
c01075cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01075d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075d5:	8b 00                	mov    (%eax),%eax
c01075d7:	85 c0                	test   %eax,%eax
c01075d9:	74 24                	je     c01075ff <check_swap+0x198>
c01075db:	c7 44 24 0c 35 d6 10 	movl   $0xc010d635,0xc(%esp)
c01075e2:	c0 
c01075e3:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01075ea:	c0 
c01075eb:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01075f2:	00 
c01075f3:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01075fa:	e8 d0 97 ff ff       	call   c0100dcf <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01075ff:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0107606:	00 
c0107607:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010760e:	00 
c010760f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0107616:	e8 75 0a 00 00       	call   c0108090 <vma_create>
c010761b:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010761e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107622:	75 24                	jne    c0107648 <check_swap+0x1e1>
c0107624:	c7 44 24 0c 43 d6 10 	movl   $0xc010d643,0xc(%esp)
c010762b:	c0 
c010762c:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107633:	c0 
c0107634:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c010763b:	00 
c010763c:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107643:	e8 87 97 ff ff       	call   c0100dcf <__panic>

     insert_vma_struct(mm, vma);
c0107648:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010764b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010764f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107652:	89 04 24             	mov    %eax,(%esp)
c0107655:	e8 c6 0b 00 00       	call   c0108220 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010765a:	c7 04 24 50 d6 10 c0 	movl   $0xc010d650,(%esp)
c0107661:	e8 ed 8c ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0107666:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010766d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107670:	8b 40 0c             	mov    0xc(%eax),%eax
c0107673:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010767a:	00 
c010767b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107682:	00 
c0107683:	89 04 24             	mov    %eax,(%esp)
c0107686:	e8 2e e3 ff ff       	call   c01059b9 <get_pte>
c010768b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c010768e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0107692:	75 24                	jne    c01076b8 <check_swap+0x251>
c0107694:	c7 44 24 0c 84 d6 10 	movl   $0xc010d684,0xc(%esp)
c010769b:	c0 
c010769c:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01076a3:	c0 
c01076a4:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01076ab:	00 
c01076ac:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01076b3:	e8 17 97 ff ff       	call   c0100dcf <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01076b8:	c7 04 24 98 d6 10 c0 	movl   $0xc010d698,(%esp)
c01076bf:	e8 8f 8c ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01076c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01076cb:	e9 a3 00 00 00       	jmp    c0107773 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01076d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01076d7:	e8 76 db ff ff       	call   c0105252 <alloc_pages>
c01076dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01076df:	89 04 95 e0 ef 19 c0 	mov    %eax,-0x3fe61020(,%edx,4)
          assert(check_rp[i] != NULL );
c01076e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076e9:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01076f0:	85 c0                	test   %eax,%eax
c01076f2:	75 24                	jne    c0107718 <check_swap+0x2b1>
c01076f4:	c7 44 24 0c bc d6 10 	movl   $0xc010d6bc,0xc(%esp)
c01076fb:	c0 
c01076fc:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107703:	c0 
c0107704:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010770b:	00 
c010770c:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107713:	e8 b7 96 ff ff       	call   c0100dcf <__panic>
          assert(!PageProperty(check_rp[i]));
c0107718:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010771b:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c0107722:	83 c0 04             	add    $0x4,%eax
c0107725:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010772c:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010772f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107732:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107735:	0f a3 10             	bt     %edx,(%eax)
c0107738:	19 c0                	sbb    %eax,%eax
c010773a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010773d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0107741:	0f 95 c0             	setne  %al
c0107744:	0f b6 c0             	movzbl %al,%eax
c0107747:	85 c0                	test   %eax,%eax
c0107749:	74 24                	je     c010776f <check_swap+0x308>
c010774b:	c7 44 24 0c d0 d6 10 	movl   $0xc010d6d0,0xc(%esp)
c0107752:	c0 
c0107753:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c010775a:	c0 
c010775b:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0107762:	00 
c0107763:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c010776a:	e8 60 96 ff ff       	call   c0100dcf <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010776f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107773:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107777:	0f 8e 53 ff ff ff    	jle    c01076d0 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c010777d:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0107782:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0107788:	89 45 98             	mov    %eax,-0x68(%ebp)
c010778b:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010778e:	c7 45 a8 b8 ef 19 c0 	movl   $0xc019efb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107795:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107798:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010779b:	89 50 04             	mov    %edx,0x4(%eax)
c010779e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01077a1:	8b 50 04             	mov    0x4(%eax),%edx
c01077a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01077a7:	89 10                	mov    %edx,(%eax)
c01077a9:	c7 45 a4 b8 ef 19 c0 	movl   $0xc019efb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01077b0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01077b3:	8b 40 04             	mov    0x4(%eax),%eax
c01077b6:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01077b9:	0f 94 c0             	sete   %al
c01077bc:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01077bf:	85 c0                	test   %eax,%eax
c01077c1:	75 24                	jne    c01077e7 <check_swap+0x380>
c01077c3:	c7 44 24 0c eb d6 10 	movl   $0xc010d6eb,0xc(%esp)
c01077ca:	c0 
c01077cb:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01077d2:	c0 
c01077d3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01077da:	00 
c01077db:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01077e2:	e8 e8 95 ff ff       	call   c0100dcf <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01077e7:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01077ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01077ef:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c01077f6:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01077f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107800:	eb 1e                	jmp    c0107820 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0107802:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107805:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c010780c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107813:	00 
c0107814:	89 04 24             	mov    %eax,(%esp)
c0107817:	e8 a1 da ff ff       	call   c01052bd <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010781c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107820:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107824:	7e dc                	jle    c0107802 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107826:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010782b:	83 f8 04             	cmp    $0x4,%eax
c010782e:	74 24                	je     c0107854 <check_swap+0x3ed>
c0107830:	c7 44 24 0c 04 d7 10 	movl   $0xc010d704,0xc(%esp)
c0107837:	c0 
c0107838:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c010783f:	c0 
c0107840:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0107847:	00 
c0107848:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c010784f:	e8 7b 95 ff ff       	call   c0100dcf <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0107854:	c7 04 24 28 d7 10 c0 	movl   $0xc010d728,(%esp)
c010785b:	e8 f3 8a ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0107860:	c7 05 78 cf 19 c0 00 	movl   $0x0,0xc019cf78
c0107867:	00 00 00 
     
     check_content_set();
c010786a:	e8 28 fa ff ff       	call   c0107297 <check_content_set>
     assert( nr_free == 0);         
c010786f:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0107874:	85 c0                	test   %eax,%eax
c0107876:	74 24                	je     c010789c <check_swap+0x435>
c0107878:	c7 44 24 0c 4f d7 10 	movl   $0xc010d74f,0xc(%esp)
c010787f:	c0 
c0107880:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107887:	c0 
c0107888:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c010788f:	00 
c0107890:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107897:	e8 33 95 ff ff       	call   c0100dcf <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010789c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01078a3:	eb 26                	jmp    c01078cb <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01078a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078a8:	c7 04 85 00 f0 19 c0 	movl   $0xffffffff,-0x3fe61000(,%eax,4)
c01078af:	ff ff ff ff 
c01078b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078b6:	8b 14 85 00 f0 19 c0 	mov    -0x3fe61000(,%eax,4),%edx
c01078bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078c0:	89 14 85 40 f0 19 c0 	mov    %edx,-0x3fe60fc0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01078c7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01078cb:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01078cf:	7e d4                	jle    c01078a5 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01078d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01078d8:	e9 eb 00 00 00       	jmp    c01079c8 <check_swap+0x561>
         check_ptep[i]=0;
c01078dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078e0:	c7 04 85 94 f0 19 c0 	movl   $0x0,-0x3fe60f6c(,%eax,4)
c01078e7:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01078eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078ee:	83 c0 01             	add    $0x1,%eax
c01078f1:	c1 e0 0c             	shl    $0xc,%eax
c01078f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01078fb:	00 
c01078fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107900:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107903:	89 04 24             	mov    %eax,(%esp)
c0107906:	e8 ae e0 ff ff       	call   c01059b9 <get_pte>
c010790b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010790e:	89 04 95 94 f0 19 c0 	mov    %eax,-0x3fe60f6c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0107915:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107918:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c010791f:	85 c0                	test   %eax,%eax
c0107921:	75 24                	jne    c0107947 <check_swap+0x4e0>
c0107923:	c7 44 24 0c 5c d7 10 	movl   $0xc010d75c,0xc(%esp)
c010792a:	c0 
c010792b:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107932:	c0 
c0107933:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010793a:	00 
c010793b:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107942:	e8 88 94 ff ff       	call   c0100dcf <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107947:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010794a:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107951:	8b 00                	mov    (%eax),%eax
c0107953:	89 04 24             	mov    %eax,(%esp)
c0107956:	e8 9f f5 ff ff       	call   c0106efa <pte2page>
c010795b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010795e:	8b 14 95 e0 ef 19 c0 	mov    -0x3fe61020(,%edx,4),%edx
c0107965:	39 d0                	cmp    %edx,%eax
c0107967:	74 24                	je     c010798d <check_swap+0x526>
c0107969:	c7 44 24 0c 74 d7 10 	movl   $0xc010d774,0xc(%esp)
c0107970:	c0 
c0107971:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c0107978:	c0 
c0107979:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107980:	00 
c0107981:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107988:	e8 42 94 ff ff       	call   c0100dcf <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010798d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107990:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107997:	8b 00                	mov    (%eax),%eax
c0107999:	83 e0 01             	and    $0x1,%eax
c010799c:	85 c0                	test   %eax,%eax
c010799e:	75 24                	jne    c01079c4 <check_swap+0x55d>
c01079a0:	c7 44 24 0c 9c d7 10 	movl   $0xc010d79c,0xc(%esp)
c01079a7:	c0 
c01079a8:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01079af:	c0 
c01079b0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01079b7:	00 
c01079b8:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c01079bf:	e8 0b 94 ff ff       	call   c0100dcf <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01079c4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01079c8:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01079cc:	0f 8e 0b ff ff ff    	jle    c01078dd <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01079d2:	c7 04 24 b8 d7 10 c0 	movl   $0xc010d7b8,(%esp)
c01079d9:	e8 75 89 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01079de:	e8 6c fa ff ff       	call   c010744f <check_content_access>
c01079e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01079e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01079ea:	74 24                	je     c0107a10 <check_swap+0x5a9>
c01079ec:	c7 44 24 0c de d7 10 	movl   $0xc010d7de,0xc(%esp)
c01079f3:	c0 
c01079f4:	c7 44 24 08 c6 d4 10 	movl   $0xc010d4c6,0x8(%esp)
c01079fb:	c0 
c01079fc:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0107a03:	00 
c0107a04:	c7 04 24 60 d4 10 c0 	movl   $0xc010d460,(%esp)
c0107a0b:	e8 bf 93 ff ff       	call   c0100dcf <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107a10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107a17:	eb 1e                	jmp    c0107a37 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a1c:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c0107a23:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107a2a:	00 
c0107a2b:	89 04 24             	mov    %eax,(%esp)
c0107a2e:	e8 8a d8 ff ff       	call   c01052bd <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107a37:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107a3b:	7e dc                	jle    c0107a19 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pa2page(pgdir[0]));
c0107a3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a40:	8b 00                	mov    (%eax),%eax
c0107a42:	89 04 24             	mov    %eax,(%esp)
c0107a45:	e8 6b f4 ff ff       	call   c0106eb5 <pa2page>
c0107a4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107a51:	00 
c0107a52:	89 04 24             	mov    %eax,(%esp)
c0107a55:	e8 63 d8 ff ff       	call   c01052bd <free_pages>
     pgdir[0] = 0;
c0107a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c0107a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c0107a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a70:	89 04 24             	mov    %eax,(%esp)
c0107a73:	e8 d8 08 00 00       	call   c0108350 <mm_destroy>
     check_mm_struct = NULL;
c0107a78:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0107a7f:	00 00 00 
     
     nr_free = nr_free_store;
c0107a82:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a85:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
     free_list = free_list_store;
c0107a8a:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107a8d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107a90:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0107a95:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc

     
     le = &free_list;
c0107a9b:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107aa2:	eb 1d                	jmp    c0107ac1 <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c0107aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107aa7:	83 e8 0c             	sub    $0xc,%eax
c0107aaa:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107aad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107ab1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107ab4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107ab7:	8b 40 08             	mov    0x8(%eax),%eax
c0107aba:	29 c2                	sub    %eax,%edx
c0107abc:	89 d0                	mov    %edx,%eax
c0107abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ac4:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107ac7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107aca:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107acd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ad0:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c0107ad7:	75 cb                	jne    c0107aa4 <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107adc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ae7:	c7 04 24 e5 d7 10 c0 	movl   $0xc010d7e5,(%esp)
c0107aee:	e8 60 88 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0107af3:	c7 04 24 ff d7 10 c0 	movl   $0xc010d7ff,(%esp)
c0107afa:	e8 54 88 ff ff       	call   c0100353 <cprintf>
}
c0107aff:	83 c4 74             	add    $0x74,%esp
c0107b02:	5b                   	pop    %ebx
c0107b03:	5d                   	pop    %ebp
c0107b04:	c3                   	ret    

c0107b05 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0107b05:	55                   	push   %ebp
c0107b06:	89 e5                	mov    %esp,%ebp
c0107b08:	83 ec 10             	sub    $0x10,%esp
c0107b0b:	c7 45 fc a4 f0 19 c0 	movl   $0xc019f0a4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107b18:	89 50 04             	mov    %edx,0x4(%eax)
c0107b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107b1e:	8b 50 04             	mov    0x4(%eax),%edx
c0107b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107b24:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0107b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b29:	c7 40 14 a4 f0 19 c0 	movl   $0xc019f0a4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b35:	c9                   	leave  
c0107b36:	c3                   	ret    

c0107b37 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107b37:	55                   	push   %ebp
c0107b38:	89 e5                	mov    %esp,%ebp
c0107b3a:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b40:	8b 40 14             	mov    0x14(%eax),%eax
c0107b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107b46:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b49:	83 c0 14             	add    $0x14,%eax
c0107b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107b4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b53:	74 06                	je     c0107b5b <_fifo_map_swappable+0x24>
c0107b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107b59:	75 24                	jne    c0107b7f <_fifo_map_swappable+0x48>
c0107b5b:	c7 44 24 0c 18 d8 10 	movl   $0xc010d818,0xc(%esp)
c0107b62:	c0 
c0107b63:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107b6a:	c0 
c0107b6b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0107b72:	00 
c0107b73:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107b7a:	e8 50 92 ff ff       	call   c0100dcf <__panic>
c0107b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b8e:	8b 40 04             	mov    0x4(%eax),%eax
c0107b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107b94:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107b97:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107b9a:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0107b9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ba3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107ba6:	89 10                	mov    %edx,(%eax)
c0107ba8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bab:	8b 10                	mov    (%eax),%edx
c0107bad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107bb0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107bb9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107bc2:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
c0107bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107bc9:	c9                   	leave  
c0107bca:	c3                   	ret    

c0107bcb <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107bcb:	55                   	push   %ebp
c0107bcc:	89 e5                	mov    %esp,%ebp
c0107bce:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bd4:	8b 40 14             	mov    0x14(%eax),%eax
c0107bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107bda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107bde:	75 24                	jne    c0107c04 <_fifo_swap_out_victim+0x39>
c0107be0:	c7 44 24 0c 5f d8 10 	movl   $0xc010d85f,0xc(%esp)
c0107be7:	c0 
c0107be8:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107bef:	c0 
c0107bf0:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0107bf7:	00 
c0107bf8:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107bff:	e8 cb 91 ff ff       	call   c0100dcf <__panic>
     assert(in_tick==0);
c0107c04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107c08:	74 24                	je     c0107c2e <_fifo_swap_out_victim+0x63>
c0107c0a:	c7 44 24 0c 6c d8 10 	movl   $0xc010d86c,0xc(%esp)
c0107c11:	c0 
c0107c12:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107c19:	c0 
c0107c1a:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107c21:	00 
c0107c22:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107c29:	e8 a1 91 ff ff       	call   c0100dcf <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t* tar = head->prev;
c0107c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c31:	8b 00                	mov    (%eax),%eax
c0107c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(tar != head);
c0107c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c39:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107c3c:	75 24                	jne    c0107c62 <_fifo_swap_out_victim+0x97>
c0107c3e:	c7 44 24 0c 77 d8 10 	movl   $0xc010d877,0xc(%esp)
c0107c45:	c0 
c0107c46:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107c4d:	c0 
c0107c4e:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0107c55:	00 
c0107c56:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107c5d:	e8 6d 91 ff ff       	call   c0100dcf <__panic>
     struct Page* p = le2page(tar, pra_page_link);
c0107c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c65:	83 e8 14             	sub    $0x14,%eax
c0107c68:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c74:	8b 40 04             	mov    0x4(%eax),%eax
c0107c77:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107c7a:	8b 12                	mov    (%edx),%edx
c0107c7c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c85:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107c88:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107c91:	89 10                	mov    %edx,(%eax)
     list_del(tar);
     assert(p != NULL);
c0107c93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107c97:	75 24                	jne    c0107cbd <_fifo_swap_out_victim+0xf2>
c0107c99:	c7 44 24 0c 83 d8 10 	movl   $0xc010d883,0xc(%esp)
c0107ca0:	c0 
c0107ca1:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107ca8:	c0 
c0107ca9:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0107cb0:	00 
c0107cb1:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107cb8:	e8 12 91 ff ff       	call   c0100dcf <__panic>
     *ptr_page = p;
c0107cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107cc3:	89 10                	mov    %edx,(%eax)
     return 0;
c0107cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107cca:	c9                   	leave  
c0107ccb:	c3                   	ret    

c0107ccc <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107ccc:	55                   	push   %ebp
c0107ccd:	89 e5                	mov    %esp,%ebp
c0107ccf:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107cd2:	c7 04 24 90 d8 10 c0 	movl   $0xc010d890,(%esp)
c0107cd9:	e8 75 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107cde:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107ce3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107ce6:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107ceb:	83 f8 04             	cmp    $0x4,%eax
c0107cee:	74 24                	je     c0107d14 <_fifo_check_swap+0x48>
c0107cf0:	c7 44 24 0c b6 d8 10 	movl   $0xc010d8b6,0xc(%esp)
c0107cf7:	c0 
c0107cf8:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107cff:	c0 
c0107d00:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0107d07:	00 
c0107d08:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107d0f:	e8 bb 90 ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107d14:	c7 04 24 c8 d8 10 c0 	movl   $0xc010d8c8,(%esp)
c0107d1b:	e8 33 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107d20:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107d25:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107d28:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107d2d:	83 f8 04             	cmp    $0x4,%eax
c0107d30:	74 24                	je     c0107d56 <_fifo_check_swap+0x8a>
c0107d32:	c7 44 24 0c b6 d8 10 	movl   $0xc010d8b6,0xc(%esp)
c0107d39:	c0 
c0107d3a:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107d41:	c0 
c0107d42:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107d49:	00 
c0107d4a:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107d51:	e8 79 90 ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107d56:	c7 04 24 f0 d8 10 c0 	movl   $0xc010d8f0,(%esp)
c0107d5d:	e8 f1 85 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107d62:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107d67:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107d6a:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107d6f:	83 f8 04             	cmp    $0x4,%eax
c0107d72:	74 24                	je     c0107d98 <_fifo_check_swap+0xcc>
c0107d74:	c7 44 24 0c b6 d8 10 	movl   $0xc010d8b6,0xc(%esp)
c0107d7b:	c0 
c0107d7c:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107d83:	c0 
c0107d84:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0107d8b:	00 
c0107d8c:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107d93:	e8 37 90 ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107d98:	c7 04 24 18 d9 10 c0 	movl   $0xc010d918,(%esp)
c0107d9f:	e8 af 85 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107da4:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107da9:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107dac:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107db1:	83 f8 04             	cmp    $0x4,%eax
c0107db4:	74 24                	je     c0107dda <_fifo_check_swap+0x10e>
c0107db6:	c7 44 24 0c b6 d8 10 	movl   $0xc010d8b6,0xc(%esp)
c0107dbd:	c0 
c0107dbe:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107dc5:	c0 
c0107dc6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0107dcd:	00 
c0107dce:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107dd5:	e8 f5 8f ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107dda:	c7 04 24 40 d9 10 c0 	movl   $0xc010d940,(%esp)
c0107de1:	e8 6d 85 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107de6:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107deb:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107dee:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107df3:	83 f8 05             	cmp    $0x5,%eax
c0107df6:	74 24                	je     c0107e1c <_fifo_check_swap+0x150>
c0107df8:	c7 44 24 0c 66 d9 10 	movl   $0xc010d966,0xc(%esp)
c0107dff:	c0 
c0107e00:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107e07:	c0 
c0107e08:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107e0f:	00 
c0107e10:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107e17:	e8 b3 8f ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107e1c:	c7 04 24 18 d9 10 c0 	movl   $0xc010d918,(%esp)
c0107e23:	e8 2b 85 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107e28:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107e2d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107e30:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107e35:	83 f8 05             	cmp    $0x5,%eax
c0107e38:	74 24                	je     c0107e5e <_fifo_check_swap+0x192>
c0107e3a:	c7 44 24 0c 66 d9 10 	movl   $0xc010d966,0xc(%esp)
c0107e41:	c0 
c0107e42:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107e49:	c0 
c0107e4a:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107e51:	00 
c0107e52:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107e59:	e8 71 8f ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107e5e:	c7 04 24 c8 d8 10 c0 	movl   $0xc010d8c8,(%esp)
c0107e65:	e8 e9 84 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107e6a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107e6f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107e72:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107e77:	83 f8 06             	cmp    $0x6,%eax
c0107e7a:	74 24                	je     c0107ea0 <_fifo_check_swap+0x1d4>
c0107e7c:	c7 44 24 0c 75 d9 10 	movl   $0xc010d975,0xc(%esp)
c0107e83:	c0 
c0107e84:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107e8b:	c0 
c0107e8c:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107e93:	00 
c0107e94:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107e9b:	e8 2f 8f ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107ea0:	c7 04 24 18 d9 10 c0 	movl   $0xc010d918,(%esp)
c0107ea7:	e8 a7 84 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107eac:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107eb1:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107eb4:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107eb9:	83 f8 07             	cmp    $0x7,%eax
c0107ebc:	74 24                	je     c0107ee2 <_fifo_check_swap+0x216>
c0107ebe:	c7 44 24 0c 84 d9 10 	movl   $0xc010d984,0xc(%esp)
c0107ec5:	c0 
c0107ec6:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107ecd:	c0 
c0107ece:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107ed5:	00 
c0107ed6:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107edd:	e8 ed 8e ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107ee2:	c7 04 24 90 d8 10 c0 	movl   $0xc010d890,(%esp)
c0107ee9:	e8 65 84 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107eee:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107ef3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107ef6:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107efb:	83 f8 08             	cmp    $0x8,%eax
c0107efe:	74 24                	je     c0107f24 <_fifo_check_swap+0x258>
c0107f00:	c7 44 24 0c 93 d9 10 	movl   $0xc010d993,0xc(%esp)
c0107f07:	c0 
c0107f08:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107f0f:	c0 
c0107f10:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107f17:	00 
c0107f18:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107f1f:	e8 ab 8e ff ff       	call   c0100dcf <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107f24:	c7 04 24 f0 d8 10 c0 	movl   $0xc010d8f0,(%esp)
c0107f2b:	e8 23 84 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107f30:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107f35:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107f38:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107f3d:	83 f8 09             	cmp    $0x9,%eax
c0107f40:	74 24                	je     c0107f66 <_fifo_check_swap+0x29a>
c0107f42:	c7 44 24 0c a2 d9 10 	movl   $0xc010d9a2,0xc(%esp)
c0107f49:	c0 
c0107f4a:	c7 44 24 08 36 d8 10 	movl   $0xc010d836,0x8(%esp)
c0107f51:	c0 
c0107f52:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107f59:	00 
c0107f5a:	c7 04 24 4b d8 10 c0 	movl   $0xc010d84b,(%esp)
c0107f61:	e8 69 8e ff ff       	call   c0100dcf <__panic>
    return 0;
c0107f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f6b:	c9                   	leave  
c0107f6c:	c3                   	ret    

c0107f6d <_fifo_init>:


static int
_fifo_init(void)
{
c0107f6d:	55                   	push   %ebp
c0107f6e:	89 e5                	mov    %esp,%ebp
    return 0;
c0107f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f75:	5d                   	pop    %ebp
c0107f76:	c3                   	ret    

c0107f77 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107f77:	55                   	push   %ebp
c0107f78:	89 e5                	mov    %esp,%ebp
    return 0;
c0107f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f7f:	5d                   	pop    %ebp
c0107f80:	c3                   	ret    

c0107f81 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107f81:	55                   	push   %ebp
c0107f82:	89 e5                	mov    %esp,%ebp
c0107f84:	b8 00 00 00 00       	mov    $0x0,%eax
c0107f89:	5d                   	pop    %ebp
c0107f8a:	c3                   	ret    

c0107f8b <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107f8b:	55                   	push   %ebp
c0107f8c:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107f97:	5d                   	pop    %ebp
c0107f98:	c3                   	ret    

c0107f99 <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107f99:	55                   	push   %ebp
c0107f9a:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107f9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f9f:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107fa2:	5d                   	pop    %ebp
c0107fa3:	c3                   	ret    

c0107fa4 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107fa4:	55                   	push   %ebp
c0107fa5:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107fa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107faa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107fad:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107fb0:	5d                   	pop    %ebp
c0107fb1:	c3                   	ret    

c0107fb2 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107fb2:	55                   	push   %ebp
c0107fb3:	89 e5                	mov    %esp,%ebp
c0107fb5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fbb:	c1 e8 0c             	shr    $0xc,%eax
c0107fbe:	89 c2                	mov    %eax,%edx
c0107fc0:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0107fc5:	39 c2                	cmp    %eax,%edx
c0107fc7:	72 1c                	jb     c0107fe5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107fc9:	c7 44 24 08 c4 d9 10 	movl   $0xc010d9c4,0x8(%esp)
c0107fd0:	c0 
c0107fd1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107fd8:	00 
c0107fd9:	c7 04 24 e3 d9 10 c0 	movl   $0xc010d9e3,(%esp)
c0107fe0:	e8 ea 8d ff ff       	call   c0100dcf <__panic>
    }
    return &pages[PPN(pa)];
c0107fe5:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0107fea:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fed:	c1 ea 0c             	shr    $0xc,%edx
c0107ff0:	c1 e2 05             	shl    $0x5,%edx
c0107ff3:	01 d0                	add    %edx,%eax
}
c0107ff5:	c9                   	leave  
c0107ff6:	c3                   	ret    

c0107ff7 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107ff7:	55                   	push   %ebp
c0107ff8:	89 e5                	mov    %esp,%ebp
c0107ffa:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107ffd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108004:	e8 d4 cd ff ff       	call   c0104ddd <kmalloc>
c0108009:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010800c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108010:	74 79                	je     c010808b <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108015:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108018:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010801b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010801e:	89 50 04             	mov    %edx,0x4(%eax)
c0108021:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108024:	8b 50 04             	mov    0x4(%eax),%edx
c0108027:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010802a:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010802c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010802f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0108036:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108039:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0108040:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108043:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010804a:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c010804f:	85 c0                	test   %eax,%eax
c0108051:	74 0d                	je     c0108060 <mm_create+0x69>
c0108053:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108056:	89 04 24             	mov    %eax,(%esp)
c0108059:	e8 6a ef ff ff       	call   c0106fc8 <swap_init_mm>
c010805e:	eb 0a                	jmp    c010806a <mm_create+0x73>
        else mm->sm_priv = NULL;
c0108060:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108063:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c010806a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108071:	00 
c0108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108075:	89 04 24             	mov    %eax,(%esp)
c0108078:	e8 27 ff ff ff       	call   c0107fa4 <set_mm_count>
        lock_init(&(mm->mm_lock));
c010807d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108080:	83 c0 1c             	add    $0x1c,%eax
c0108083:	89 04 24             	mov    %eax,(%esp)
c0108086:	e8 00 ff ff ff       	call   c0107f8b <lock_init>
    }    
    return mm;
c010808b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010808e:	c9                   	leave  
c010808f:	c3                   	ret    

c0108090 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0108090:	55                   	push   %ebp
c0108091:	89 e5                	mov    %esp,%ebp
c0108093:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0108096:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010809d:	e8 3b cd ff ff       	call   c0104ddd <kmalloc>
c01080a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01080a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01080a9:	74 1b                	je     c01080c6 <vma_create+0x36>
        vma->vm_start = vm_start;
c01080ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01080b1:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080b7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01080ba:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080c0:	8b 55 10             	mov    0x10(%ebp),%edx
c01080c3:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01080c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01080c9:	c9                   	leave  
c01080ca:	c3                   	ret    

c01080cb <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01080cb:	55                   	push   %ebp
c01080cc:	89 e5                	mov    %esp,%ebp
c01080ce:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01080d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01080d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01080dc:	0f 84 95 00 00 00    	je     c0108177 <find_vma+0xac>
        vma = mm->mmap_cache;
c01080e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01080e5:	8b 40 08             	mov    0x8(%eax),%eax
c01080e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01080eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01080ef:	74 16                	je     c0108107 <find_vma+0x3c>
c01080f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01080f4:	8b 40 04             	mov    0x4(%eax),%eax
c01080f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01080fa:	77 0b                	ja     c0108107 <find_vma+0x3c>
c01080fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01080ff:	8b 40 08             	mov    0x8(%eax),%eax
c0108102:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108105:	77 61                	ja     c0108168 <find_vma+0x9d>
                bool found = 0;
c0108107:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010810e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108111:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108114:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108117:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c010811a:	eb 28                	jmp    c0108144 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010811c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010811f:	83 e8 10             	sub    $0x10,%eax
c0108122:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0108125:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108128:	8b 40 04             	mov    0x4(%eax),%eax
c010812b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010812e:	77 14                	ja     c0108144 <find_vma+0x79>
c0108130:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108133:	8b 40 08             	mov    0x8(%eax),%eax
c0108136:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108139:	76 09                	jbe    c0108144 <find_vma+0x79>
                        found = 1;
c010813b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0108142:	eb 17                	jmp    c010815b <find_vma+0x90>
c0108144:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108147:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010814a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010814d:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0108150:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108156:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108159:	75 c1                	jne    c010811c <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010815b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010815f:	75 07                	jne    c0108168 <find_vma+0x9d>
                    vma = NULL;
c0108161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0108168:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010816c:	74 09                	je     c0108177 <find_vma+0xac>
            mm->mmap_cache = vma;
c010816e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108171:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0108174:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0108177:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010817a:	c9                   	leave  
c010817b:	c3                   	ret    

c010817c <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010817c:	55                   	push   %ebp
c010817d:	89 e5                	mov    %esp,%ebp
c010817f:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0108182:	8b 45 08             	mov    0x8(%ebp),%eax
c0108185:	8b 50 04             	mov    0x4(%eax),%edx
c0108188:	8b 45 08             	mov    0x8(%ebp),%eax
c010818b:	8b 40 08             	mov    0x8(%eax),%eax
c010818e:	39 c2                	cmp    %eax,%edx
c0108190:	72 24                	jb     c01081b6 <check_vma_overlap+0x3a>
c0108192:	c7 44 24 0c f1 d9 10 	movl   $0xc010d9f1,0xc(%esp)
c0108199:	c0 
c010819a:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c01081a1:	c0 
c01081a2:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01081a9:	00 
c01081aa:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c01081b1:	e8 19 8c ff ff       	call   c0100dcf <__panic>
    assert(prev->vm_end <= next->vm_start);
c01081b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b9:	8b 50 08             	mov    0x8(%eax),%edx
c01081bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081bf:	8b 40 04             	mov    0x4(%eax),%eax
c01081c2:	39 c2                	cmp    %eax,%edx
c01081c4:	76 24                	jbe    c01081ea <check_vma_overlap+0x6e>
c01081c6:	c7 44 24 0c 34 da 10 	movl   $0xc010da34,0xc(%esp)
c01081cd:	c0 
c01081ce:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c01081d5:	c0 
c01081d6:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01081dd:	00 
c01081de:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c01081e5:	e8 e5 8b ff ff       	call   c0100dcf <__panic>
    assert(next->vm_start < next->vm_end);
c01081ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081ed:	8b 50 04             	mov    0x4(%eax),%edx
c01081f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081f3:	8b 40 08             	mov    0x8(%eax),%eax
c01081f6:	39 c2                	cmp    %eax,%edx
c01081f8:	72 24                	jb     c010821e <check_vma_overlap+0xa2>
c01081fa:	c7 44 24 0c 53 da 10 	movl   $0xc010da53,0xc(%esp)
c0108201:	c0 
c0108202:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108209:	c0 
c010820a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0108211:	00 
c0108212:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108219:	e8 b1 8b ff ff       	call   c0100dcf <__panic>
}
c010821e:	c9                   	leave  
c010821f:	c3                   	ret    

c0108220 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0108220:	55                   	push   %ebp
c0108221:	89 e5                	mov    %esp,%ebp
c0108223:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0108226:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108229:	8b 50 04             	mov    0x4(%eax),%edx
c010822c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010822f:	8b 40 08             	mov    0x8(%eax),%eax
c0108232:	39 c2                	cmp    %eax,%edx
c0108234:	72 24                	jb     c010825a <insert_vma_struct+0x3a>
c0108236:	c7 44 24 0c 71 da 10 	movl   $0xc010da71,0xc(%esp)
c010823d:	c0 
c010823e:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108245:	c0 
c0108246:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c010824d:	00 
c010824e:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108255:	e8 75 8b ff ff       	call   c0100dcf <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010825a:	8b 45 08             	mov    0x8(%ebp),%eax
c010825d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0108260:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108263:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0108266:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010826c:	eb 21                	jmp    c010828f <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010826e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108271:	83 e8 10             	sub    $0x10,%eax
c0108274:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0108277:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010827a:	8b 50 04             	mov    0x4(%eax),%edx
c010827d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108280:	8b 40 04             	mov    0x4(%eax),%eax
c0108283:	39 c2                	cmp    %eax,%edx
c0108285:	76 02                	jbe    c0108289 <insert_vma_struct+0x69>
                break;
c0108287:	eb 1d                	jmp    c01082a6 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0108289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010828c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010828f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108292:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108295:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108298:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010829b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010829e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082a4:	75 c8                	jne    c010826e <insert_vma_struct+0x4e>
c01082a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01082ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082af:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01082b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01082b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082bb:	74 15                	je     c01082d2 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01082bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082c0:	8d 50 f0             	lea    -0x10(%eax),%edx
c01082c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082ca:	89 14 24             	mov    %edx,(%esp)
c01082cd:	e8 aa fe ff ff       	call   c010817c <check_vma_overlap>
    }
    if (le_next != list) {
c01082d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082d8:	74 15                	je     c01082ef <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01082da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082dd:	83 e8 10             	sub    $0x10,%eax
c01082e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082e7:	89 04 24             	mov    %eax,(%esp)
c01082ea:	e8 8d fe ff ff       	call   c010817c <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01082ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082f2:	8b 55 08             	mov    0x8(%ebp),%edx
c01082f5:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01082f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082fa:	8d 50 10             	lea    0x10(%eax),%edx
c01082fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108300:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108303:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108306:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108309:	8b 40 04             	mov    0x4(%eax),%eax
c010830c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010830f:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0108312:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108315:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0108318:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010831b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010831e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108321:	89 10                	mov    %edx,(%eax)
c0108323:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108326:	8b 10                	mov    (%eax),%edx
c0108328:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010832b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010832e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108331:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108334:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108337:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010833a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010833d:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010833f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108342:	8b 40 10             	mov    0x10(%eax),%eax
c0108345:	8d 50 01             	lea    0x1(%eax),%edx
c0108348:	8b 45 08             	mov    0x8(%ebp),%eax
c010834b:	89 50 10             	mov    %edx,0x10(%eax)
}
c010834e:	c9                   	leave  
c010834f:	c3                   	ret    

c0108350 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0108350:	55                   	push   %ebp
c0108351:	89 e5                	mov    %esp,%ebp
c0108353:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c0108356:	8b 45 08             	mov    0x8(%ebp),%eax
c0108359:	89 04 24             	mov    %eax,(%esp)
c010835c:	e8 38 fc ff ff       	call   c0107f99 <mm_count>
c0108361:	85 c0                	test   %eax,%eax
c0108363:	74 24                	je     c0108389 <mm_destroy+0x39>
c0108365:	c7 44 24 0c 8d da 10 	movl   $0xc010da8d,0xc(%esp)
c010836c:	c0 
c010836d:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108374:	c0 
c0108375:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010837c:	00 
c010837d:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108384:	e8 46 8a ff ff       	call   c0100dcf <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c0108389:	8b 45 08             	mov    0x8(%ebp),%eax
c010838c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010838f:	eb 36                	jmp    c01083c7 <mm_destroy+0x77>
c0108391:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108394:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0108397:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010839a:	8b 40 04             	mov    0x4(%eax),%eax
c010839d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01083a0:	8b 12                	mov    (%edx),%edx
c01083a2:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01083a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01083a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01083ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01083ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01083b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01083b7:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c01083b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083bc:	83 e8 10             	sub    $0x10,%eax
c01083bf:	89 04 24             	mov    %eax,(%esp)
c01083c2:	e8 31 ca ff ff       	call   c0104df8 <kfree>
c01083c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01083cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083d0:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01083d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01083dc:	75 b3                	jne    c0108391 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01083de:	8b 45 08             	mov    0x8(%ebp),%eax
c01083e1:	89 04 24             	mov    %eax,(%esp)
c01083e4:	e8 0f ca ff ff       	call   c0104df8 <kfree>
    mm=NULL;
c01083e9:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01083f0:	c9                   	leave  
c01083f1:	c3                   	ret    

c01083f2 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c01083f2:	55                   	push   %ebp
c01083f3:	89 e5                	mov    %esp,%ebp
c01083f5:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c01083f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108401:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108406:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108409:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0108410:	8b 45 10             	mov    0x10(%ebp),%eax
c0108413:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108416:	01 c2                	add    %eax,%edx
c0108418:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010841b:	01 d0                	add    %edx,%eax
c010841d:	83 e8 01             	sub    $0x1,%eax
c0108420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108426:	ba 00 00 00 00       	mov    $0x0,%edx
c010842b:	f7 75 e8             	divl   -0x18(%ebp)
c010842e:	89 d0                	mov    %edx,%eax
c0108430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108433:	29 c2                	sub    %eax,%edx
c0108435:	89 d0                	mov    %edx,%eax
c0108437:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c010843a:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c0108441:	76 11                	jbe    c0108454 <mm_map+0x62>
c0108443:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108446:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108449:	73 09                	jae    c0108454 <mm_map+0x62>
c010844b:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c0108452:	76 0a                	jbe    c010845e <mm_map+0x6c>
        return -E_INVAL;
c0108454:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108459:	e9 ae 00 00 00       	jmp    c010850c <mm_map+0x11a>
    }

    assert(mm != NULL);
c010845e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108462:	75 24                	jne    c0108488 <mm_map+0x96>
c0108464:	c7 44 24 0c 9f da 10 	movl   $0xc010da9f,0xc(%esp)
c010846b:	c0 
c010846c:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108473:	c0 
c0108474:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c010847b:	00 
c010847c:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108483:	e8 47 89 ff ff       	call   c0100dcf <__panic>

    int ret = -E_INVAL;
c0108488:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c010848f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108496:	8b 45 08             	mov    0x8(%ebp),%eax
c0108499:	89 04 24             	mov    %eax,(%esp)
c010849c:	e8 2a fc ff ff       	call   c01080cb <find_vma>
c01084a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01084a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01084a8:	74 0d                	je     c01084b7 <mm_map+0xc5>
c01084aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084ad:	8b 40 04             	mov    0x4(%eax),%eax
c01084b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01084b3:	73 02                	jae    c01084b7 <mm_map+0xc5>
        goto out;
c01084b5:	eb 52                	jmp    c0108509 <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c01084b7:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c01084be:	8b 45 14             	mov    0x14(%ebp),%eax
c01084c1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084cf:	89 04 24             	mov    %eax,(%esp)
c01084d2:	e8 b9 fb ff ff       	call   c0108090 <vma_create>
c01084d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01084da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01084de:	75 02                	jne    c01084e2 <mm_map+0xf0>
        goto out;
c01084e0:	eb 27                	jmp    c0108509 <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c01084e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01084ec:	89 04 24             	mov    %eax,(%esp)
c01084ef:	e8 2c fd ff ff       	call   c0108220 <insert_vma_struct>
    if (vma_store != NULL) {
c01084f4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01084f8:	74 08                	je     c0108502 <mm_map+0x110>
        *vma_store = vma;
c01084fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01084fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108500:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c0108502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c0108509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010850c:	c9                   	leave  
c010850d:	c3                   	ret    

c010850e <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c010850e:	55                   	push   %ebp
c010850f:	89 e5                	mov    %esp,%ebp
c0108511:	56                   	push   %esi
c0108512:	53                   	push   %ebx
c0108513:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c0108516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010851a:	74 06                	je     c0108522 <dup_mmap+0x14>
c010851c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108520:	75 24                	jne    c0108546 <dup_mmap+0x38>
c0108522:	c7 44 24 0c aa da 10 	movl   $0xc010daaa,0xc(%esp)
c0108529:	c0 
c010852a:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108531:	c0 
c0108532:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0108539:	00 
c010853a:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108541:	e8 89 88 ff ff       	call   c0100dcf <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c0108546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108549:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010854c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010854f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c0108552:	e9 92 00 00 00       	jmp    c01085e9 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c0108557:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010855a:	83 e8 10             	sub    $0x10,%eax
c010855d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c0108560:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108563:	8b 48 0c             	mov    0xc(%eax),%ecx
c0108566:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108569:	8b 50 08             	mov    0x8(%eax),%edx
c010856c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010856f:	8b 40 04             	mov    0x4(%eax),%eax
c0108572:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108576:	89 54 24 04          	mov    %edx,0x4(%esp)
c010857a:	89 04 24             	mov    %eax,(%esp)
c010857d:	e8 0e fb ff ff       	call   c0108090 <vma_create>
c0108582:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c0108585:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108589:	75 07                	jne    c0108592 <dup_mmap+0x84>
            return -E_NO_MEM;
c010858b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108590:	eb 76                	jmp    c0108608 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c0108592:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108595:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108599:	8b 45 08             	mov    0x8(%ebp),%eax
c010859c:	89 04 24             	mov    %eax,(%esp)
c010859f:	e8 7c fc ff ff       	call   c0108220 <insert_vma_struct>

        bool share = 0;
c01085a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c01085ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085ae:	8b 58 08             	mov    0x8(%eax),%ebx
c01085b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085b4:	8b 48 04             	mov    0x4(%eax),%ecx
c01085b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085ba:	8b 50 0c             	mov    0xc(%eax),%edx
c01085bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01085c0:	8b 40 0c             	mov    0xc(%eax),%eax
c01085c3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01085c6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01085ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01085ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01085d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085d6:	89 04 24             	mov    %eax,(%esp)
c01085d9:	e8 cd d7 ff ff       	call   c0105dab <copy_range>
c01085de:	85 c0                	test   %eax,%eax
c01085e0:	74 07                	je     c01085e9 <dup_mmap+0xdb>
            return -E_NO_MEM;
c01085e2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01085e7:	eb 1f                	jmp    c0108608 <dup_mmap+0xfa>
c01085e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01085ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085f2:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c01085f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01085fd:	0f 85 54 ff ff ff    	jne    c0108557 <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c0108603:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108608:	83 c4 40             	add    $0x40,%esp
c010860b:	5b                   	pop    %ebx
c010860c:	5e                   	pop    %esi
c010860d:	5d                   	pop    %ebp
c010860e:	c3                   	ret    

c010860f <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c010860f:	55                   	push   %ebp
c0108610:	89 e5                	mov    %esp,%ebp
c0108612:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c0108615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108619:	74 0f                	je     c010862a <exit_mmap+0x1b>
c010861b:	8b 45 08             	mov    0x8(%ebp),%eax
c010861e:	89 04 24             	mov    %eax,(%esp)
c0108621:	e8 73 f9 ff ff       	call   c0107f99 <mm_count>
c0108626:	85 c0                	test   %eax,%eax
c0108628:	74 24                	je     c010864e <exit_mmap+0x3f>
c010862a:	c7 44 24 0c c8 da 10 	movl   $0xc010dac8,0xc(%esp)
c0108631:	c0 
c0108632:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108639:	c0 
c010863a:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0108641:	00 
c0108642:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108649:	e8 81 87 ff ff       	call   c0100dcf <__panic>
    pde_t *pgdir = mm->pgdir;
c010864e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108651:	8b 40 0c             	mov    0xc(%eax),%eax
c0108654:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c0108657:	8b 45 08             	mov    0x8(%ebp),%eax
c010865a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010865d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108660:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c0108663:	eb 28                	jmp    c010868d <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108668:	83 e8 10             	sub    $0x10,%eax
c010866b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c010866e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108671:	8b 50 08             	mov    0x8(%eax),%edx
c0108674:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108677:	8b 40 04             	mov    0x4(%eax),%eax
c010867a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010867e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108682:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108685:	89 04 24             	mov    %eax,(%esp)
c0108688:	e8 23 d5 ff ff       	call   c0105bb0 <unmap_range>
c010868d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108690:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108693:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108696:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c0108699:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010869c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010869f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01086a2:	75 c1                	jne    c0108665 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01086a4:	eb 28                	jmp    c01086ce <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c01086a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086a9:	83 e8 10             	sub    $0x10,%eax
c01086ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c01086af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01086b2:	8b 50 08             	mov    0x8(%eax),%edx
c01086b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01086b8:	8b 40 04             	mov    0x4(%eax),%eax
c01086bb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01086bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086c6:	89 04 24             	mov    %eax,(%esp)
c01086c9:	e8 d6 d5 ff ff       	call   c0105ca4 <exit_range>
c01086ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01086d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01086d7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01086da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01086e3:	75 c1                	jne    c01086a6 <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c01086e5:	c9                   	leave  
c01086e6:	c3                   	ret    

c01086e7 <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c01086e7:	55                   	push   %ebp
c01086e8:	89 e5                	mov    %esp,%ebp
c01086ea:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c01086ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01086f0:	8b 55 18             	mov    0x18(%ebp),%edx
c01086f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01086f7:	8b 55 14             	mov    0x14(%ebp),%edx
c01086fa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01086fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108702:	8b 45 08             	mov    0x8(%ebp),%eax
c0108705:	89 04 24             	mov    %eax,(%esp)
c0108708:	e8 b5 09 00 00       	call   c01090c2 <user_mem_check>
c010870d:	85 c0                	test   %eax,%eax
c010870f:	75 07                	jne    c0108718 <copy_from_user+0x31>
        return 0;
c0108711:	b8 00 00 00 00       	mov    $0x0,%eax
c0108716:	eb 1e                	jmp    c0108736 <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c0108718:	8b 45 14             	mov    0x14(%ebp),%eax
c010871b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010871f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108722:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108726:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108729:	89 04 24             	mov    %eax,(%esp)
c010872c:	e8 7e 37 00 00       	call   c010beaf <memcpy>
    return 1;
c0108731:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108736:	c9                   	leave  
c0108737:	c3                   	ret    

c0108738 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c0108738:	55                   	push   %ebp
c0108739:	89 e5                	mov    %esp,%ebp
c010873b:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c010873e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108741:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108748:	00 
c0108749:	8b 55 14             	mov    0x14(%ebp),%edx
c010874c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108750:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108754:	8b 45 08             	mov    0x8(%ebp),%eax
c0108757:	89 04 24             	mov    %eax,(%esp)
c010875a:	e8 63 09 00 00       	call   c01090c2 <user_mem_check>
c010875f:	85 c0                	test   %eax,%eax
c0108761:	75 07                	jne    c010876a <copy_to_user+0x32>
        return 0;
c0108763:	b8 00 00 00 00       	mov    $0x0,%eax
c0108768:	eb 1e                	jmp    c0108788 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c010876a:	8b 45 14             	mov    0x14(%ebp),%eax
c010876d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108771:	8b 45 10             	mov    0x10(%ebp),%eax
c0108774:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108778:	8b 45 0c             	mov    0xc(%ebp),%eax
c010877b:	89 04 24             	mov    %eax,(%esp)
c010877e:	e8 2c 37 00 00       	call   c010beaf <memcpy>
    return 1;
c0108783:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108788:	c9                   	leave  
c0108789:	c3                   	ret    

c010878a <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010878a:	55                   	push   %ebp
c010878b:	89 e5                	mov    %esp,%ebp
c010878d:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0108790:	e8 02 00 00 00       	call   c0108797 <check_vmm>
}
c0108795:	c9                   	leave  
c0108796:	c3                   	ret    

c0108797 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0108797:	55                   	push   %ebp
c0108798:	89 e5                	mov    %esp,%ebp
c010879a:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010879d:	e8 4d cb ff ff       	call   c01052ef <nr_free_pages>
c01087a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01087a5:	e8 13 00 00 00       	call   c01087bd <check_vma_struct>
    check_pgfault();
c01087aa:	e8 a7 04 00 00       	call   c0108c56 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c01087af:	c7 04 24 e8 da 10 c0 	movl   $0xc010dae8,(%esp)
c01087b6:	e8 98 7b ff ff       	call   c0100353 <cprintf>
}
c01087bb:	c9                   	leave  
c01087bc:	c3                   	ret    

c01087bd <check_vma_struct>:

static void
check_vma_struct(void) {
c01087bd:	55                   	push   %ebp
c01087be:	89 e5                	mov    %esp,%ebp
c01087c0:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01087c3:	e8 27 cb ff ff       	call   c01052ef <nr_free_pages>
c01087c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01087cb:	e8 27 f8 ff ff       	call   c0107ff7 <mm_create>
c01087d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01087d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087d7:	75 24                	jne    c01087fd <check_vma_struct+0x40>
c01087d9:	c7 44 24 0c 9f da 10 	movl   $0xc010da9f,0xc(%esp)
c01087e0:	c0 
c01087e1:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c01087e8:	c0 
c01087e9:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01087f0:	00 
c01087f1:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c01087f8:	e8 d2 85 ff ff       	call   c0100dcf <__panic>

    int step1 = 10, step2 = step1 * 10;
c01087fd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0108804:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108807:	89 d0                	mov    %edx,%eax
c0108809:	c1 e0 02             	shl    $0x2,%eax
c010880c:	01 d0                	add    %edx,%eax
c010880e:	01 c0                	add    %eax,%eax
c0108810:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0108813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108816:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108819:	eb 70                	jmp    c010888b <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010881b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010881e:	89 d0                	mov    %edx,%eax
c0108820:	c1 e0 02             	shl    $0x2,%eax
c0108823:	01 d0                	add    %edx,%eax
c0108825:	83 c0 02             	add    $0x2,%eax
c0108828:	89 c1                	mov    %eax,%ecx
c010882a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010882d:	89 d0                	mov    %edx,%eax
c010882f:	c1 e0 02             	shl    $0x2,%eax
c0108832:	01 d0                	add    %edx,%eax
c0108834:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010883b:	00 
c010883c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0108840:	89 04 24             	mov    %eax,(%esp)
c0108843:	e8 48 f8 ff ff       	call   c0108090 <vma_create>
c0108848:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c010884b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010884f:	75 24                	jne    c0108875 <check_vma_struct+0xb8>
c0108851:	c7 44 24 0c 00 db 10 	movl   $0xc010db00,0xc(%esp)
c0108858:	c0 
c0108859:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108860:	c0 
c0108861:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108868:	00 
c0108869:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108870:	e8 5a 85 ff ff       	call   c0100dcf <__panic>
        insert_vma_struct(mm, vma);
c0108875:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108878:	89 44 24 04          	mov    %eax,0x4(%esp)
c010887c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010887f:	89 04 24             	mov    %eax,(%esp)
c0108882:	e8 99 f9 ff ff       	call   c0108220 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0108887:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010888b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010888f:	7f 8a                	jg     c010881b <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108894:	83 c0 01             	add    $0x1,%eax
c0108897:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010889a:	eb 70                	jmp    c010890c <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010889c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010889f:	89 d0                	mov    %edx,%eax
c01088a1:	c1 e0 02             	shl    $0x2,%eax
c01088a4:	01 d0                	add    %edx,%eax
c01088a6:	83 c0 02             	add    $0x2,%eax
c01088a9:	89 c1                	mov    %eax,%ecx
c01088ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01088ae:	89 d0                	mov    %edx,%eax
c01088b0:	c1 e0 02             	shl    $0x2,%eax
c01088b3:	01 d0                	add    %edx,%eax
c01088b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01088bc:	00 
c01088bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01088c1:	89 04 24             	mov    %eax,(%esp)
c01088c4:	e8 c7 f7 ff ff       	call   c0108090 <vma_create>
c01088c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01088cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01088d0:	75 24                	jne    c01088f6 <check_vma_struct+0x139>
c01088d2:	c7 44 24 0c 00 db 10 	movl   $0xc010db00,0xc(%esp)
c01088d9:	c0 
c01088da:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c01088e1:	c0 
c01088e2:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01088e9:	00 
c01088ea:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c01088f1:	e8 d9 84 ff ff       	call   c0100dcf <__panic>
        insert_vma_struct(mm, vma);
c01088f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01088f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108900:	89 04 24             	mov    %eax,(%esp)
c0108903:	e8 18 f9 ff ff       	call   c0108220 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108908:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010890c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010890f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108912:	7e 88                	jle    c010889c <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0108914:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108917:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010891a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010891d:	8b 40 04             	mov    0x4(%eax),%eax
c0108920:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0108923:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c010892a:	e9 97 00 00 00       	jmp    c01089c6 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010892f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108932:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108935:	75 24                	jne    c010895b <check_vma_struct+0x19e>
c0108937:	c7 44 24 0c 0c db 10 	movl   $0xc010db0c,0xc(%esp)
c010893e:	c0 
c010893f:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108946:	c0 
c0108947:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c010894e:	00 
c010894f:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108956:	e8 74 84 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c010895b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010895e:	83 e8 10             	sub    $0x10,%eax
c0108961:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108967:	8b 48 04             	mov    0x4(%eax),%ecx
c010896a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010896d:	89 d0                	mov    %edx,%eax
c010896f:	c1 e0 02             	shl    $0x2,%eax
c0108972:	01 d0                	add    %edx,%eax
c0108974:	39 c1                	cmp    %eax,%ecx
c0108976:	75 17                	jne    c010898f <check_vma_struct+0x1d2>
c0108978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010897b:	8b 48 08             	mov    0x8(%eax),%ecx
c010897e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108981:	89 d0                	mov    %edx,%eax
c0108983:	c1 e0 02             	shl    $0x2,%eax
c0108986:	01 d0                	add    %edx,%eax
c0108988:	83 c0 02             	add    $0x2,%eax
c010898b:	39 c1                	cmp    %eax,%ecx
c010898d:	74 24                	je     c01089b3 <check_vma_struct+0x1f6>
c010898f:	c7 44 24 0c 24 db 10 	movl   $0xc010db24,0xc(%esp)
c0108996:	c0 
c0108997:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c010899e:	c0 
c010899f:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01089a6:	00 
c01089a7:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c01089ae:	e8 1c 84 ff ff       	call   c0100dcf <__panic>
c01089b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01089b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01089bc:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01089bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01089c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01089c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089c9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01089cc:	0f 8e 5d ff ff ff    	jle    c010892f <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01089d2:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01089d9:	e9 cd 01 00 00       	jmp    c0108bab <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01089de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089e8:	89 04 24             	mov    %eax,(%esp)
c01089eb:	e8 db f6 ff ff       	call   c01080cb <find_vma>
c01089f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c01089f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01089f7:	75 24                	jne    c0108a1d <check_vma_struct+0x260>
c01089f9:	c7 44 24 0c 59 db 10 	movl   $0xc010db59,0xc(%esp)
c0108a00:	c0 
c0108a01:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108a08:	c0 
c0108a09:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0108a10:	00 
c0108a11:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108a18:	e8 b2 83 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0108a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a20:	83 c0 01             	add    $0x1,%eax
c0108a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a2a:	89 04 24             	mov    %eax,(%esp)
c0108a2d:	e8 99 f6 ff ff       	call   c01080cb <find_vma>
c0108a32:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0108a35:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0108a39:	75 24                	jne    c0108a5f <check_vma_struct+0x2a2>
c0108a3b:	c7 44 24 0c 66 db 10 	movl   $0xc010db66,0xc(%esp)
c0108a42:	c0 
c0108a43:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108a4a:	c0 
c0108a4b:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0108a52:	00 
c0108a53:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108a5a:	e8 70 83 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0108a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a62:	83 c0 02             	add    $0x2,%eax
c0108a65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a6c:	89 04 24             	mov    %eax,(%esp)
c0108a6f:	e8 57 f6 ff ff       	call   c01080cb <find_vma>
c0108a74:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0108a77:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0108a7b:	74 24                	je     c0108aa1 <check_vma_struct+0x2e4>
c0108a7d:	c7 44 24 0c 73 db 10 	movl   $0xc010db73,0xc(%esp)
c0108a84:	c0 
c0108a85:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108a8c:	c0 
c0108a8d:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108a94:	00 
c0108a95:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108a9c:	e8 2e 83 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0108aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aa4:	83 c0 03             	add    $0x3,%eax
c0108aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108aae:	89 04 24             	mov    %eax,(%esp)
c0108ab1:	e8 15 f6 ff ff       	call   c01080cb <find_vma>
c0108ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0108ab9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0108abd:	74 24                	je     c0108ae3 <check_vma_struct+0x326>
c0108abf:	c7 44 24 0c 80 db 10 	movl   $0xc010db80,0xc(%esp)
c0108ac6:	c0 
c0108ac7:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108ace:	c0 
c0108acf:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0108ad6:	00 
c0108ad7:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108ade:	e8 ec 82 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0108ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ae6:	83 c0 04             	add    $0x4,%eax
c0108ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108af0:	89 04 24             	mov    %eax,(%esp)
c0108af3:	e8 d3 f5 ff ff       	call   c01080cb <find_vma>
c0108af8:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0108afb:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0108aff:	74 24                	je     c0108b25 <check_vma_struct+0x368>
c0108b01:	c7 44 24 0c 8d db 10 	movl   $0xc010db8d,0xc(%esp)
c0108b08:	c0 
c0108b09:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108b10:	c0 
c0108b11:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0108b18:	00 
c0108b19:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108b20:	e8 aa 82 ff ff       	call   c0100dcf <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0108b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108b28:	8b 50 04             	mov    0x4(%eax),%edx
c0108b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b2e:	39 c2                	cmp    %eax,%edx
c0108b30:	75 10                	jne    c0108b42 <check_vma_struct+0x385>
c0108b32:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108b35:	8b 50 08             	mov    0x8(%eax),%edx
c0108b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b3b:	83 c0 02             	add    $0x2,%eax
c0108b3e:	39 c2                	cmp    %eax,%edx
c0108b40:	74 24                	je     c0108b66 <check_vma_struct+0x3a9>
c0108b42:	c7 44 24 0c 9c db 10 	movl   $0xc010db9c,0xc(%esp)
c0108b49:	c0 
c0108b4a:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108b51:	c0 
c0108b52:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0108b59:	00 
c0108b5a:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108b61:	e8 69 82 ff ff       	call   c0100dcf <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108b66:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108b69:	8b 50 04             	mov    0x4(%eax),%edx
c0108b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b6f:	39 c2                	cmp    %eax,%edx
c0108b71:	75 10                	jne    c0108b83 <check_vma_struct+0x3c6>
c0108b73:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108b76:	8b 50 08             	mov    0x8(%eax),%edx
c0108b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b7c:	83 c0 02             	add    $0x2,%eax
c0108b7f:	39 c2                	cmp    %eax,%edx
c0108b81:	74 24                	je     c0108ba7 <check_vma_struct+0x3ea>
c0108b83:	c7 44 24 0c cc db 10 	movl   $0xc010dbcc,0xc(%esp)
c0108b8a:	c0 
c0108b8b:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108b92:	c0 
c0108b93:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0108b9a:	00 
c0108b9b:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108ba2:	e8 28 82 ff ff       	call   c0100dcf <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108ba7:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0108bab:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108bae:	89 d0                	mov    %edx,%eax
c0108bb0:	c1 e0 02             	shl    $0x2,%eax
c0108bb3:	01 d0                	add    %edx,%eax
c0108bb5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108bb8:	0f 8d 20 fe ff ff    	jge    c01089de <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108bbe:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0108bc5:	eb 70                	jmp    c0108c37 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0108bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bd1:	89 04 24             	mov    %eax,(%esp)
c0108bd4:	e8 f2 f4 ff ff       	call   c01080cb <find_vma>
c0108bd9:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0108bdc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108be0:	74 27                	je     c0108c09 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0108be2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108be5:	8b 50 08             	mov    0x8(%eax),%edx
c0108be8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108beb:	8b 40 04             	mov    0x4(%eax),%eax
c0108bee:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108bf2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bfd:	c7 04 24 fc db 10 c0 	movl   $0xc010dbfc,(%esp)
c0108c04:	e8 4a 77 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0108c09:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108c0d:	74 24                	je     c0108c33 <check_vma_struct+0x476>
c0108c0f:	c7 44 24 0c 21 dc 10 	movl   $0xc010dc21,0xc(%esp)
c0108c16:	c0 
c0108c17:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108c1e:	c0 
c0108c1f:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0108c26:	00 
c0108c27:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108c2e:	e8 9c 81 ff ff       	call   c0100dcf <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108c33:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108c3b:	79 8a                	jns    c0108bc7 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c40:	89 04 24             	mov    %eax,(%esp)
c0108c43:	e8 08 f7 ff ff       	call   c0108350 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108c48:	c7 04 24 38 dc 10 c0 	movl   $0xc010dc38,(%esp)
c0108c4f:	e8 ff 76 ff ff       	call   c0100353 <cprintf>
}
c0108c54:	c9                   	leave  
c0108c55:	c3                   	ret    

c0108c56 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108c56:	55                   	push   %ebp
c0108c57:	89 e5                	mov    %esp,%ebp
c0108c59:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108c5c:	e8 8e c6 ff ff       	call   c01052ef <nr_free_pages>
c0108c61:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108c64:	e8 8e f3 ff ff       	call   c0107ff7 <mm_create>
c0108c69:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac
    assert(check_mm_struct != NULL);
c0108c6e:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108c73:	85 c0                	test   %eax,%eax
c0108c75:	75 24                	jne    c0108c9b <check_pgfault+0x45>
c0108c77:	c7 44 24 0c 57 dc 10 	movl   $0xc010dc57,0xc(%esp)
c0108c7e:	c0 
c0108c7f:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108c86:	c0 
c0108c87:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108c8e:	00 
c0108c8f:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108c96:	e8 34 81 ff ff       	call   c0100dcf <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108c9b:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108ca0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108ca3:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0108ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cac:	89 50 0c             	mov    %edx,0xc(%eax)
c0108caf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cb2:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108cbb:	8b 00                	mov    (%eax),%eax
c0108cbd:	85 c0                	test   %eax,%eax
c0108cbf:	74 24                	je     c0108ce5 <check_pgfault+0x8f>
c0108cc1:	c7 44 24 0c 6f dc 10 	movl   $0xc010dc6f,0xc(%esp)
c0108cc8:	c0 
c0108cc9:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108cd0:	c0 
c0108cd1:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108cd8:	00 
c0108cd9:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108ce0:	e8 ea 80 ff ff       	call   c0100dcf <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108ce5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0108cec:	00 
c0108ced:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108cf4:	00 
c0108cf5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108cfc:	e8 8f f3 ff ff       	call   c0108090 <vma_create>
c0108d01:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108d04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108d08:	75 24                	jne    c0108d2e <check_pgfault+0xd8>
c0108d0a:	c7 44 24 0c 00 db 10 	movl   $0xc010db00,0xc(%esp)
c0108d11:	c0 
c0108d12:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108d19:	c0 
c0108d1a:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108d21:	00 
c0108d22:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108d29:	e8 a1 80 ff ff       	call   c0100dcf <__panic>

    insert_vma_struct(mm, vma);
c0108d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d38:	89 04 24             	mov    %eax,(%esp)
c0108d3b:	e8 e0 f4 ff ff       	call   c0108220 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108d40:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108d47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d51:	89 04 24             	mov    %eax,(%esp)
c0108d54:	e8 72 f3 ff ff       	call   c01080cb <find_vma>
c0108d59:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108d5c:	74 24                	je     c0108d82 <check_pgfault+0x12c>
c0108d5e:	c7 44 24 0c 7d dc 10 	movl   $0xc010dc7d,0xc(%esp)
c0108d65:	c0 
c0108d66:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108d6d:	c0 
c0108d6e:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108d75:	00 
c0108d76:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108d7d:	e8 4d 80 ff ff       	call   c0100dcf <__panic>

    int i, sum = 0;
c0108d82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d90:	eb 17                	jmp    c0108da9 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d98:	01 d0                	add    %edx,%eax
c0108d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108d9d:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108da2:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108da5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108da9:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108dad:	7e e3                	jle    c0108d92 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108db6:	eb 15                	jmp    c0108dcd <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108dbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108dbe:	01 d0                	add    %edx,%eax
c0108dc0:	0f b6 00             	movzbl (%eax),%eax
c0108dc3:	0f be c0             	movsbl %al,%eax
c0108dc6:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108dc9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108dcd:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108dd1:	7e e5                	jle    c0108db8 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108dd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108dd7:	74 24                	je     c0108dfd <check_pgfault+0x1a7>
c0108dd9:	c7 44 24 0c 97 dc 10 	movl   $0xc010dc97,0xc(%esp)
c0108de0:	c0 
c0108de1:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108de8:	c0 
c0108de9:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0108df0:	00 
c0108df1:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108df8:	e8 d2 7f ff ff       	call   c0100dcf <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108dfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108e00:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108e03:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108e06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e12:	89 04 24             	mov    %eax,(%esp)
c0108e15:	e8 b4 d1 ff ff       	call   c0105fce <page_remove>
    free_page(pa2page(pgdir[0]));
c0108e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e1d:	8b 00                	mov    (%eax),%eax
c0108e1f:	89 04 24             	mov    %eax,(%esp)
c0108e22:	e8 8b f1 ff ff       	call   c0107fb2 <pa2page>
c0108e27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108e2e:	00 
c0108e2f:	89 04 24             	mov    %eax,(%esp)
c0108e32:	e8 86 c4 ff ff       	call   c01052bd <free_pages>
    pgdir[0] = 0;
c0108e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e4d:	89 04 24             	mov    %eax,(%esp)
c0108e50:	e8 fb f4 ff ff       	call   c0108350 <mm_destroy>
    check_mm_struct = NULL;
c0108e55:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0108e5c:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108e5f:	e8 8b c4 ff ff       	call   c01052ef <nr_free_pages>
c0108e64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108e67:	74 24                	je     c0108e8d <check_pgfault+0x237>
c0108e69:	c7 44 24 0c a0 dc 10 	movl   $0xc010dca0,0xc(%esp)
c0108e70:	c0 
c0108e71:	c7 44 24 08 0f da 10 	movl   $0xc010da0f,0x8(%esp)
c0108e78:	c0 
c0108e79:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108e80:	00 
c0108e81:	c7 04 24 24 da 10 c0 	movl   $0xc010da24,(%esp)
c0108e88:	e8 42 7f ff ff       	call   c0100dcf <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108e8d:	c7 04 24 c7 dc 10 c0 	movl   $0xc010dcc7,(%esp)
c0108e94:	e8 ba 74 ff ff       	call   c0100353 <cprintf>
}
c0108e99:	c9                   	leave  
c0108e9a:	c3                   	ret    

c0108e9b <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108e9b:	55                   	push   %ebp
c0108e9c:	89 e5                	mov    %esp,%ebp
c0108e9e:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108ea1:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108ea8:	8b 45 10             	mov    0x10(%ebp),%eax
c0108eab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eb2:	89 04 24             	mov    %eax,(%esp)
c0108eb5:	e8 11 f2 ff ff       	call   c01080cb <find_vma>
c0108eba:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108ebd:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0108ec2:	83 c0 01             	add    $0x1,%eax
c0108ec5:	a3 78 cf 19 c0       	mov    %eax,0xc019cf78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108eca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108ece:	74 0b                	je     c0108edb <do_pgfault+0x40>
c0108ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ed3:	8b 40 04             	mov    0x4(%eax),%eax
c0108ed6:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108ed9:	76 18                	jbe    c0108ef3 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108edb:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ede:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ee2:	c7 04 24 e4 dc 10 c0 	movl   $0xc010dce4,(%esp)
c0108ee9:	e8 65 74 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108eee:	e9 ca 01 00 00       	jmp    c01090bd <do_pgfault+0x222>
    }
    //check the error_code
    switch (error_code & 3) {
c0108ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ef6:	83 e0 03             	and    $0x3,%eax
c0108ef9:	85 c0                	test   %eax,%eax
c0108efb:	74 36                	je     c0108f33 <do_pgfault+0x98>
c0108efd:	83 f8 01             	cmp    $0x1,%eax
c0108f00:	74 20                	je     c0108f22 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f05:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f08:	83 e0 02             	and    $0x2,%eax
c0108f0b:	85 c0                	test   %eax,%eax
c0108f0d:	75 11                	jne    c0108f20 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108f0f:	c7 04 24 14 dd 10 c0 	movl   $0xc010dd14,(%esp)
c0108f16:	e8 38 74 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108f1b:	e9 9d 01 00 00       	jmp    c01090bd <do_pgfault+0x222>
        }
        break;
c0108f20:	eb 2f                	jmp    c0108f51 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108f22:	c7 04 24 74 dd 10 c0 	movl   $0xc010dd74,(%esp)
c0108f29:	e8 25 74 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108f2e:	e9 8a 01 00 00       	jmp    c01090bd <do_pgfault+0x222>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f36:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f39:	83 e0 05             	and    $0x5,%eax
c0108f3c:	85 c0                	test   %eax,%eax
c0108f3e:	75 11                	jne    c0108f51 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108f40:	c7 04 24 ac dd 10 c0 	movl   $0xc010ddac,(%esp)
c0108f47:	e8 07 74 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108f4c:	e9 6c 01 00 00       	jmp    c01090bd <do_pgfault+0x222>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108f51:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f5b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f5e:	83 e0 02             	and    $0x2,%eax
c0108f61:	85 c0                	test   %eax,%eax
c0108f63:	74 04                	je     c0108f69 <do_pgfault+0xce>
        perm |= PTE_W;
c0108f65:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108f69:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108f77:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108f7a:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108f81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (*ptep == 0) {
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
#endif
    /*LAB3 EXERCISE 1: YOUR CODE*/
    //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    if((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
c0108f88:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f8b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f8e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108f95:	00 
c0108f96:	8b 55 10             	mov    0x10(%ebp),%edx
c0108f99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f9d:	89 04 24             	mov    %eax,(%esp)
c0108fa0:	e8 14 ca ff ff       	call   c01059b9 <get_pte>
c0108fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108fa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108fac:	75 11                	jne    c0108fbf <do_pgfault+0x124>
    {
    	cprintf("get_pte in do_pgfault failed\n");
c0108fae:	c7 04 24 0f de 10 c0 	movl   $0xc010de0f,(%esp)
c0108fb5:	e8 99 73 ff ff       	call   c0100353 <cprintf>
    	goto failed;
c0108fba:	e9 fe 00 00 00       	jmp    c01090bd <do_pgfault+0x222>
    }
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0)
c0108fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fc2:	8b 00                	mov    (%eax),%eax
c0108fc4:	85 c0                	test   %eax,%eax
c0108fc6:	75 35                	jne    c0108ffd <do_pgfault+0x162>
    {
    	if(pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
c0108fc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fcb:	8b 40 0c             	mov    0xc(%eax),%eax
c0108fce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108fd1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108fd5:	8b 55 10             	mov    0x10(%ebp),%edx
c0108fd8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108fdc:	89 04 24             	mov    %eax,(%esp)
c0108fdf:	e8 44 d1 ff ff       	call   c0106128 <pgdir_alloc_page>
c0108fe4:	85 c0                	test   %eax,%eax
c0108fe6:	0f 85 ca 00 00 00    	jne    c01090b6 <do_pgfault+0x21b>
    	{
    		cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0108fec:	c7 04 24 30 de 10 c0 	movl   $0xc010de30,(%esp)
c0108ff3:	e8 5b 73 ff ff       	call   c0100353 <cprintf>
    		goto failed;
c0108ff8:	e9 c0 00 00 00       	jmp    c01090bd <do_pgfault+0x222>
		     If the vma includes this addr is writable, then we can set the page writable by rewrite the *ptep.
		     This method could be used to implement the Copy on Write (COW) thchnology(a fast fork process method).
		  2) *ptep & PTE_P == 0 & but *ptep!=0, it means this pte is a  swap entry.
		     We should add the LAB3's results here.
     */
        if(swap_init_ok) {
c0108ffd:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0109002:	85 c0                	test   %eax,%eax
c0109004:	0f 84 95 00 00 00    	je     c010909f <do_pgfault+0x204>
            struct Page *page=NULL;
c010900a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
            if((ret = swap_in(mm, addr, &page)) != 0)
c0109011:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0109014:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109018:	8b 45 10             	mov    0x10(%ebp),%eax
c010901b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010901f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109022:	89 04 24             	mov    %eax,(%esp)
c0109025:	e8 97 e1 ff ff       	call   c01071c1 <swap_in>
c010902a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010902d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109031:	74 0e                	je     c0109041 <do_pgfault+0x1a6>
            {
            	cprintf("swap_in in do_pgfault failed\n");
c0109033:	c7 04 24 57 de 10 c0 	movl   $0xc010de57,(%esp)
c010903a:	e8 14 73 ff ff       	call   c0100353 <cprintf>
            	goto failed;
c010903f:	eb 7c                	jmp    c01090bd <do_pgfault+0x222>
            }
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            if((ret = page_insert(mm->pgdir, page, addr, perm)) != 0)
c0109041:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109044:	8b 45 08             	mov    0x8(%ebp),%eax
c0109047:	8b 40 0c             	mov    0xc(%eax),%eax
c010904a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010904d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0109051:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0109054:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0109058:	89 54 24 04          	mov    %edx,0x4(%esp)
c010905c:	89 04 24             	mov    %eax,(%esp)
c010905f:	e8 ae cf ff ff       	call   c0106012 <page_insert>
c0109064:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010906b:	74 0f                	je     c010907c <do_pgfault+0x1e1>
            {
            	cprintf("page_insert in do_pgfault failed\n");
c010906d:	c7 04 24 78 de 10 c0 	movl   $0xc010de78,(%esp)
c0109074:	e8 da 72 ff ff       	call   c0100353 <cprintf>
            	goto failed;
c0109079:	90                   	nop
c010907a:	eb 41                	jmp    c01090bd <do_pgfault+0x222>
            }
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c010907c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010907f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0109086:	00 
c0109087:	89 44 24 08          	mov    %eax,0x8(%esp)
c010908b:	8b 45 10             	mov    0x10(%ebp),%eax
c010908e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109092:	8b 45 08             	mov    0x8(%ebp),%eax
c0109095:	89 04 24             	mov    %eax,(%esp)
c0109098:	e8 5b df ff ff       	call   c0106ff8 <swap_map_swappable>
c010909d:	eb 17                	jmp    c01090b6 <do_pgfault+0x21b>
        }
        else
        {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c010909f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01090a2:	8b 00                	mov    (%eax),%eax
c01090a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090a8:	c7 04 24 9c de 10 c0 	movl   $0xc010de9c,(%esp)
c01090af:	e8 9f 72 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01090b4:	eb 07                	jmp    c01090bd <do_pgfault+0x222>
        }
   }
   ret = 0;
c01090b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01090bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01090c0:	c9                   	leave  
c01090c1:	c3                   	ret    

c01090c2 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c01090c2:	55                   	push   %ebp
c01090c3:	89 e5                	mov    %esp,%ebp
c01090c5:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01090c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01090cc:	0f 84 e0 00 00 00    	je     c01091b2 <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c01090d2:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01090d9:	76 1c                	jbe    c01090f7 <user_mem_check+0x35>
c01090db:	8b 45 10             	mov    0x10(%ebp),%eax
c01090de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01090e1:	01 d0                	add    %edx,%eax
c01090e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01090e6:	76 0f                	jbe    c01090f7 <user_mem_check+0x35>
c01090e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01090eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01090ee:	01 d0                	add    %edx,%eax
c01090f0:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c01090f5:	76 0a                	jbe    c0109101 <user_mem_check+0x3f>
            return 0;
c01090f7:	b8 00 00 00 00       	mov    $0x0,%eax
c01090fc:	e9 e2 00 00 00       	jmp    c01091e3 <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0109101:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109104:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109107:	8b 45 10             	mov    0x10(%ebp),%eax
c010910a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010910d:	01 d0                	add    %edx,%eax
c010910f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0109112:	e9 88 00 00 00       	jmp    c010919f <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0109117:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010911a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010911e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109121:	89 04 24             	mov    %eax,(%esp)
c0109124:	e8 a2 ef ff ff       	call   c01080cb <find_vma>
c0109129:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010912c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109130:	74 0b                	je     c010913d <user_mem_check+0x7b>
c0109132:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109135:	8b 40 04             	mov    0x4(%eax),%eax
c0109138:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010913b:	76 0a                	jbe    c0109147 <user_mem_check+0x85>
                return 0;
c010913d:	b8 00 00 00 00       	mov    $0x0,%eax
c0109142:	e9 9c 00 00 00       	jmp    c01091e3 <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0109147:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010914a:	8b 50 0c             	mov    0xc(%eax),%edx
c010914d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0109151:	74 07                	je     c010915a <user_mem_check+0x98>
c0109153:	b8 02 00 00 00       	mov    $0x2,%eax
c0109158:	eb 05                	jmp    c010915f <user_mem_check+0x9d>
c010915a:	b8 01 00 00 00       	mov    $0x1,%eax
c010915f:	21 d0                	and    %edx,%eax
c0109161:	85 c0                	test   %eax,%eax
c0109163:	75 07                	jne    c010916c <user_mem_check+0xaa>
                return 0;
c0109165:	b8 00 00 00 00       	mov    $0x0,%eax
c010916a:	eb 77                	jmp    c01091e3 <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c010916c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0109170:	74 24                	je     c0109196 <user_mem_check+0xd4>
c0109172:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109175:	8b 40 0c             	mov    0xc(%eax),%eax
c0109178:	83 e0 08             	and    $0x8,%eax
c010917b:	85 c0                	test   %eax,%eax
c010917d:	74 17                	je     c0109196 <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c010917f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109182:	8b 40 04             	mov    0x4(%eax),%eax
c0109185:	05 00 10 00 00       	add    $0x1000,%eax
c010918a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010918d:	76 07                	jbe    c0109196 <user_mem_check+0xd4>
                    return 0;
c010918f:	b8 00 00 00 00       	mov    $0x0,%eax
c0109194:	eb 4d                	jmp    c01091e3 <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0109196:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109199:	8b 40 08             	mov    0x8(%eax),%eax
c010919c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c010919f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01091a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01091a5:	0f 82 6c ff ff ff    	jb     c0109117 <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c01091ab:	b8 01 00 00 00       	mov    $0x1,%eax
c01091b0:	eb 31                	jmp    c01091e3 <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c01091b2:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c01091b9:	76 23                	jbe    c01091de <user_mem_check+0x11c>
c01091bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01091be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091c1:	01 d0                	add    %edx,%eax
c01091c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01091c6:	76 16                	jbe    c01091de <user_mem_check+0x11c>
c01091c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01091cb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091ce:	01 d0                	add    %edx,%eax
c01091d0:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c01091d5:	77 07                	ja     c01091de <user_mem_check+0x11c>
c01091d7:	b8 01 00 00 00       	mov    $0x1,%eax
c01091dc:	eb 05                	jmp    c01091e3 <user_mem_check+0x121>
c01091de:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01091e3:	c9                   	leave  
c01091e4:	c3                   	ret    

c01091e5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01091e5:	55                   	push   %ebp
c01091e6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01091e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01091eb:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01091f0:	29 c2                	sub    %eax,%edx
c01091f2:	89 d0                	mov    %edx,%eax
c01091f4:	c1 f8 05             	sar    $0x5,%eax
}
c01091f7:	5d                   	pop    %ebp
c01091f8:	c3                   	ret    

c01091f9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01091f9:	55                   	push   %ebp
c01091fa:	89 e5                	mov    %esp,%ebp
c01091fc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01091ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109202:	89 04 24             	mov    %eax,(%esp)
c0109205:	e8 db ff ff ff       	call   c01091e5 <page2ppn>
c010920a:	c1 e0 0c             	shl    $0xc,%eax
}
c010920d:	c9                   	leave  
c010920e:	c3                   	ret    

c010920f <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010920f:	55                   	push   %ebp
c0109210:	89 e5                	mov    %esp,%ebp
c0109212:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109215:	8b 45 08             	mov    0x8(%ebp),%eax
c0109218:	89 04 24             	mov    %eax,(%esp)
c010921b:	e8 d9 ff ff ff       	call   c01091f9 <page2pa>
c0109220:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109223:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109226:	c1 e8 0c             	shr    $0xc,%eax
c0109229:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010922c:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0109231:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109234:	72 23                	jb     c0109259 <page2kva+0x4a>
c0109236:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109239:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010923d:	c7 44 24 08 c4 de 10 	movl   $0xc010dec4,0x8(%esp)
c0109244:	c0 
c0109245:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010924c:	00 
c010924d:	c7 04 24 e7 de 10 c0 	movl   $0xc010dee7,(%esp)
c0109254:	e8 76 7b ff ff       	call   c0100dcf <__panic>
c0109259:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010925c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0109261:	c9                   	leave  
c0109262:	c3                   	ret    

c0109263 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0109263:	55                   	push   %ebp
c0109264:	89 e5                	mov    %esp,%ebp
c0109266:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0109269:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109270:	e8 aa 88 ff ff       	call   c0101b1f <ide_device_valid>
c0109275:	85 c0                	test   %eax,%eax
c0109277:	75 1c                	jne    c0109295 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0109279:	c7 44 24 08 f5 de 10 	movl   $0xc010def5,0x8(%esp)
c0109280:	c0 
c0109281:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0109288:	00 
c0109289:	c7 04 24 0f df 10 c0 	movl   $0xc010df0f,(%esp)
c0109290:	e8 3a 7b ff ff       	call   c0100dcf <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0109295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010929c:	e8 bd 88 ff ff       	call   c0101b5e <ide_device_size>
c01092a1:	c1 e8 03             	shr    $0x3,%eax
c01092a4:	a3 7c f0 19 c0       	mov    %eax,0xc019f07c
}
c01092a9:	c9                   	leave  
c01092aa:	c3                   	ret    

c01092ab <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01092ab:	55                   	push   %ebp
c01092ac:	89 e5                	mov    %esp,%ebp
c01092ae:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01092b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092b4:	89 04 24             	mov    %eax,(%esp)
c01092b7:	e8 53 ff ff ff       	call   c010920f <page2kva>
c01092bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01092bf:	c1 ea 08             	shr    $0x8,%edx
c01092c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01092c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01092c9:	74 0b                	je     c01092d6 <swapfs_read+0x2b>
c01092cb:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c01092d1:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01092d4:	72 23                	jb     c01092f9 <swapfs_read+0x4e>
c01092d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01092d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092dd:	c7 44 24 08 20 df 10 	movl   $0xc010df20,0x8(%esp)
c01092e4:	c0 
c01092e5:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01092ec:	00 
c01092ed:	c7 04 24 0f df 10 c0 	movl   $0xc010df0f,(%esp)
c01092f4:	e8 d6 7a ff ff       	call   c0100dcf <__panic>
c01092f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01092fc:	c1 e2 03             	shl    $0x3,%edx
c01092ff:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0109306:	00 
c0109307:	89 44 24 08          	mov    %eax,0x8(%esp)
c010930b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010930f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109316:	e8 82 88 ff ff       	call   c0101b9d <ide_read_secs>
}
c010931b:	c9                   	leave  
c010931c:	c3                   	ret    

c010931d <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010931d:	55                   	push   %ebp
c010931e:	89 e5                	mov    %esp,%ebp
c0109320:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0109323:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109326:	89 04 24             	mov    %eax,(%esp)
c0109329:	e8 e1 fe ff ff       	call   c010920f <page2kva>
c010932e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109331:	c1 ea 08             	shr    $0x8,%edx
c0109334:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010933b:	74 0b                	je     c0109348 <swapfs_write+0x2b>
c010933d:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c0109343:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0109346:	72 23                	jb     c010936b <swapfs_write+0x4e>
c0109348:	8b 45 08             	mov    0x8(%ebp),%eax
c010934b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010934f:	c7 44 24 08 20 df 10 	movl   $0xc010df20,0x8(%esp)
c0109356:	c0 
c0109357:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010935e:	00 
c010935f:	c7 04 24 0f df 10 c0 	movl   $0xc010df0f,(%esp)
c0109366:	e8 64 7a ff ff       	call   c0100dcf <__panic>
c010936b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010936e:	c1 e2 03             	shl    $0x3,%edx
c0109371:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0109378:	00 
c0109379:	89 44 24 08          	mov    %eax,0x8(%esp)
c010937d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109388:	e8 52 8a ff ff       	call   c0101ddf <ide_write_secs>
}
c010938d:	c9                   	leave  
c010938e:	c3                   	ret    

c010938f <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010938f:	52                   	push   %edx
    call *%ebx              # call fn
c0109390:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0109392:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0109393:	e8 65 0c 00 00       	call   c0109ffd <do_exit>

c0109398 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c0109398:	55                   	push   %ebp
c0109399:	89 e5                	mov    %esp,%ebp
c010939b:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c010939e:	8b 55 0c             	mov    0xc(%ebp),%edx
c01093a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a4:	0f ab 02             	bts    %eax,(%edx)
c01093a7:	19 c0                	sbb    %eax,%eax
c01093a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c01093ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01093b0:	0f 95 c0             	setne  %al
c01093b3:	0f b6 c0             	movzbl %al,%eax
}
c01093b6:	c9                   	leave  
c01093b7:	c3                   	ret    

c01093b8 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c01093b8:	55                   	push   %ebp
c01093b9:	89 e5                	mov    %esp,%ebp
c01093bb:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c01093be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01093c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c4:	0f b3 02             	btr    %eax,(%edx)
c01093c7:	19 c0                	sbb    %eax,%eax
c01093c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c01093cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01093d0:	0f 95 c0             	setne  %al
c01093d3:	0f b6 c0             	movzbl %al,%eax
}
c01093d6:	c9                   	leave  
c01093d7:	c3                   	ret    

c01093d8 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01093d8:	55                   	push   %ebp
c01093d9:	89 e5                	mov    %esp,%ebp
c01093db:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01093de:	9c                   	pushf  
c01093df:	58                   	pop    %eax
c01093e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01093e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01093e6:	25 00 02 00 00       	and    $0x200,%eax
c01093eb:	85 c0                	test   %eax,%eax
c01093ed:	74 0c                	je     c01093fb <__intr_save+0x23>
        intr_disable();
c01093ef:	e8 33 8c ff ff       	call   c0102027 <intr_disable>
        return 1;
c01093f4:	b8 01 00 00 00       	mov    $0x1,%eax
c01093f9:	eb 05                	jmp    c0109400 <__intr_save+0x28>
    }
    return 0;
c01093fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109400:	c9                   	leave  
c0109401:	c3                   	ret    

c0109402 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0109402:	55                   	push   %ebp
c0109403:	89 e5                	mov    %esp,%ebp
c0109405:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010940c:	74 05                	je     c0109413 <__intr_restore+0x11>
        intr_enable();
c010940e:	e8 0e 8c ff ff       	call   c0102021 <intr_enable>
    }
}
c0109413:	c9                   	leave  
c0109414:	c3                   	ret    

c0109415 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0109415:	55                   	push   %ebp
c0109416:	89 e5                	mov    %esp,%ebp
c0109418:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c010941b:	8b 45 08             	mov    0x8(%ebp),%eax
c010941e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109429:	e8 6a ff ff ff       	call   c0109398 <test_and_set_bit>
c010942e:	85 c0                	test   %eax,%eax
c0109430:	0f 94 c0             	sete   %al
c0109433:	0f b6 c0             	movzbl %al,%eax
}
c0109436:	c9                   	leave  
c0109437:	c3                   	ret    

c0109438 <lock>:

static inline void
lock(lock_t *lock) {
c0109438:	55                   	push   %ebp
c0109439:	89 e5                	mov    %esp,%ebp
c010943b:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c010943e:	eb 05                	jmp    c0109445 <lock+0xd>
        schedule();
c0109440:	e8 1d 1c 00 00       	call   c010b062 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0109445:	8b 45 08             	mov    0x8(%ebp),%eax
c0109448:	89 04 24             	mov    %eax,(%esp)
c010944b:	e8 c5 ff ff ff       	call   c0109415 <try_lock>
c0109450:	85 c0                	test   %eax,%eax
c0109452:	74 ec                	je     c0109440 <lock+0x8>
        schedule();
    }
}
c0109454:	c9                   	leave  
c0109455:	c3                   	ret    

c0109456 <unlock>:

static inline void
unlock(lock_t *lock) {
c0109456:	55                   	push   %ebp
c0109457:	89 e5                	mov    %esp,%ebp
c0109459:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c010945c:	8b 45 08             	mov    0x8(%ebp),%eax
c010945f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010946a:	e8 49 ff ff ff       	call   c01093b8 <test_and_clear_bit>
c010946f:	85 c0                	test   %eax,%eax
c0109471:	75 1c                	jne    c010948f <unlock+0x39>
        panic("Unlock failed.\n");
c0109473:	c7 44 24 08 40 df 10 	movl   $0xc010df40,0x8(%esp)
c010947a:	c0 
c010947b:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0109482:	00 
c0109483:	c7 04 24 50 df 10 c0 	movl   $0xc010df50,(%esp)
c010948a:	e8 40 79 ff ff       	call   c0100dcf <__panic>
    }
}
c010948f:	c9                   	leave  
c0109490:	c3                   	ret    

c0109491 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0109491:	55                   	push   %ebp
c0109492:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0109494:	8b 55 08             	mov    0x8(%ebp),%edx
c0109497:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010949c:	29 c2                	sub    %eax,%edx
c010949e:	89 d0                	mov    %edx,%eax
c01094a0:	c1 f8 05             	sar    $0x5,%eax
}
c01094a3:	5d                   	pop    %ebp
c01094a4:	c3                   	ret    

c01094a5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01094a5:	55                   	push   %ebp
c01094a6:	89 e5                	mov    %esp,%ebp
c01094a8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01094ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01094ae:	89 04 24             	mov    %eax,(%esp)
c01094b1:	e8 db ff ff ff       	call   c0109491 <page2ppn>
c01094b6:	c1 e0 0c             	shl    $0xc,%eax
}
c01094b9:	c9                   	leave  
c01094ba:	c3                   	ret    

c01094bb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01094bb:	55                   	push   %ebp
c01094bc:	89 e5                	mov    %esp,%ebp
c01094be:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01094c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c4:	c1 e8 0c             	shr    $0xc,%eax
c01094c7:	89 c2                	mov    %eax,%edx
c01094c9:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01094ce:	39 c2                	cmp    %eax,%edx
c01094d0:	72 1c                	jb     c01094ee <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01094d2:	c7 44 24 08 64 df 10 	movl   $0xc010df64,0x8(%esp)
c01094d9:	c0 
c01094da:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01094e1:	00 
c01094e2:	c7 04 24 83 df 10 c0 	movl   $0xc010df83,(%esp)
c01094e9:	e8 e1 78 ff ff       	call   c0100dcf <__panic>
    }
    return &pages[PPN(pa)];
c01094ee:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01094f3:	8b 55 08             	mov    0x8(%ebp),%edx
c01094f6:	c1 ea 0c             	shr    $0xc,%edx
c01094f9:	c1 e2 05             	shl    $0x5,%edx
c01094fc:	01 d0                	add    %edx,%eax
}
c01094fe:	c9                   	leave  
c01094ff:	c3                   	ret    

c0109500 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0109500:	55                   	push   %ebp
c0109501:	89 e5                	mov    %esp,%ebp
c0109503:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109506:	8b 45 08             	mov    0x8(%ebp),%eax
c0109509:	89 04 24             	mov    %eax,(%esp)
c010950c:	e8 94 ff ff ff       	call   c01094a5 <page2pa>
c0109511:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109514:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109517:	c1 e8 0c             	shr    $0xc,%eax
c010951a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010951d:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0109522:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109525:	72 23                	jb     c010954a <page2kva+0x4a>
c0109527:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010952a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010952e:	c7 44 24 08 94 df 10 	movl   $0xc010df94,0x8(%esp)
c0109535:	c0 
c0109536:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010953d:	00 
c010953e:	c7 04 24 83 df 10 c0 	movl   $0xc010df83,(%esp)
c0109545:	e8 85 78 ff ff       	call   c0100dcf <__panic>
c010954a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010954d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0109552:	c9                   	leave  
c0109553:	c3                   	ret    

c0109554 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0109554:	55                   	push   %ebp
c0109555:	89 e5                	mov    %esp,%ebp
c0109557:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010955a:	8b 45 08             	mov    0x8(%ebp),%eax
c010955d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109560:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0109567:	77 23                	ja     c010958c <kva2page+0x38>
c0109569:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010956c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109570:	c7 44 24 08 b8 df 10 	movl   $0xc010dfb8,0x8(%esp)
c0109577:	c0 
c0109578:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010957f:	00 
c0109580:	c7 04 24 83 df 10 c0 	movl   $0xc010df83,(%esp)
c0109587:	e8 43 78 ff ff       	call   c0100dcf <__panic>
c010958c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010958f:	05 00 00 00 40       	add    $0x40000000,%eax
c0109594:	89 04 24             	mov    %eax,(%esp)
c0109597:	e8 1f ff ff ff       	call   c01094bb <pa2page>
}
c010959c:	c9                   	leave  
c010959d:	c3                   	ret    

c010959e <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c010959e:	55                   	push   %ebp
c010959f:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c01095a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a4:	8b 40 18             	mov    0x18(%eax),%eax
c01095a7:	8d 50 01             	lea    0x1(%eax),%edx
c01095aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01095ad:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01095b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b3:	8b 40 18             	mov    0x18(%eax),%eax
}
c01095b6:	5d                   	pop    %ebp
c01095b7:	c3                   	ret    

c01095b8 <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c01095b8:	55                   	push   %ebp
c01095b9:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c01095bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01095be:	8b 40 18             	mov    0x18(%eax),%eax
c01095c1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01095c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c7:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01095ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01095cd:	8b 40 18             	mov    0x18(%eax),%eax
}
c01095d0:	5d                   	pop    %ebp
c01095d1:	c3                   	ret    

c01095d2 <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c01095d2:	55                   	push   %ebp
c01095d3:	89 e5                	mov    %esp,%ebp
c01095d5:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01095d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01095dc:	74 0e                	je     c01095ec <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c01095de:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e1:	83 c0 1c             	add    $0x1c,%eax
c01095e4:	89 04 24             	mov    %eax,(%esp)
c01095e7:	e8 4c fe ff ff       	call   c0109438 <lock>
    }
}
c01095ec:	c9                   	leave  
c01095ed:	c3                   	ret    

c01095ee <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c01095ee:	55                   	push   %ebp
c01095ef:	89 e5                	mov    %esp,%ebp
c01095f1:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01095f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01095f8:	74 0e                	je     c0109608 <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c01095fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01095fd:	83 c0 1c             	add    $0x1c,%eax
c0109600:	89 04 24             	mov    %eax,(%esp)
c0109603:	e8 4e fe ff ff       	call   c0109456 <unlock>
    }
}
c0109608:	c9                   	leave  
c0109609:	c3                   	ret    

c010960a <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c010960a:	55                   	push   %ebp
c010960b:	89 e5                	mov    %esp,%ebp
c010960d:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0109610:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c0109617:	e8 c1 b7 ff ff       	call   c0104ddd <kmalloc>
c010961c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c010961f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109623:	0f 84 c9 00 00 00    	je     c01096f2 <alloc_proc+0xe8>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
    proc->state = PROC_UNINIT;
c0109629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010962c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    proc->pid = -1;
c0109632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109635:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    proc->runs = 0;
c010963c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010963f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    proc->kstack = 0;
c0109646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109649:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    proc->need_resched = 0;
c0109650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109653:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    proc->parent = NULL;
c010965a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010965d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    proc->mm = NULL;
c0109664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109667:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    memset(&(proc->context), 0, sizeof(struct context));
c010966e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109671:	83 c0 1c             	add    $0x1c,%eax
c0109674:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c010967b:	00 
c010967c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109683:	00 
c0109684:	89 04 24             	mov    %eax,(%esp)
c0109687:	e8 41 27 00 00       	call   c010bdcd <memset>
    proc->tf = NULL;
c010968c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010968f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
    proc->cr3 = boot_cr3;
c0109696:	8b 15 c8 ef 19 c0    	mov    0xc019efc8,%edx
c010969c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010969f:	89 50 40             	mov    %edx,0x40(%eax)
    proc->flags = 0;
c01096a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096a5:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    memset(proc->name, 0, PROC_NAME_LEN);		
c01096ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096af:	83 c0 48             	add    $0x48,%eax
c01096b2:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01096b9:	00 
c01096ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01096c1:	00 
c01096c2:	89 04 24             	mov    %eax,(%esp)
c01096c5:	e8 03 27 00 00       	call   c010bdcd <memset>
    /*
     * below fields(add in LAB5) in proc_struct need to be initialized	
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
	 */
    proc->wait_state = 0;
c01096ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096cd:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
    proc->cptr = NULL;
c01096d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096d7:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
    proc->yptr = NULL;
c01096de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096e1:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    proc->optr = NULL;
c01096e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096eb:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
    }
    return proc;
c01096f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096f5:	c9                   	leave  
c01096f6:	c3                   	ret    

c01096f7 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01096f7:	55                   	push   %ebp
c01096f8:	89 e5                	mov    %esp,%ebp
c01096fa:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01096fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0109700:	83 c0 48             	add    $0x48,%eax
c0109703:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010970a:	00 
c010970b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109712:	00 
c0109713:	89 04 24             	mov    %eax,(%esp)
c0109716:	e8 b2 26 00 00       	call   c010bdcd <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010971b:	8b 45 08             	mov    0x8(%ebp),%eax
c010971e:	8d 50 48             	lea    0x48(%eax),%edx
c0109721:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109728:	00 
c0109729:	8b 45 0c             	mov    0xc(%ebp),%eax
c010972c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109730:	89 14 24             	mov    %edx,(%esp)
c0109733:	e8 77 27 00 00       	call   c010beaf <memcpy>
}
c0109738:	c9                   	leave  
c0109739:	c3                   	ret    

c010973a <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c010973a:	55                   	push   %ebp
c010973b:	89 e5                	mov    %esp,%ebp
c010973d:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0109740:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109747:	00 
c0109748:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010974f:	00 
c0109750:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109757:	e8 71 26 00 00       	call   c010bdcd <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010975c:	8b 45 08             	mov    0x8(%ebp),%eax
c010975f:	83 c0 48             	add    $0x48,%eax
c0109762:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109769:	00 
c010976a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010976e:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109775:	e8 35 27 00 00       	call   c010beaf <memcpy>
}
c010977a:	c9                   	leave  
c010977b:	c3                   	ret    

c010977c <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c010977c:	55                   	push   %ebp
c010977d:	89 e5                	mov    %esp,%ebp
c010977f:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c0109782:	8b 45 08             	mov    0x8(%ebp),%eax
c0109785:	83 c0 58             	add    $0x58,%eax
c0109788:	c7 45 fc b0 f0 19 c0 	movl   $0xc019f0b0,-0x4(%ebp)
c010978f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0109792:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109795:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109798:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010979b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010979e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01097a1:	8b 40 04             	mov    0x4(%eax),%eax
c01097a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01097a7:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01097aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01097ad:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01097b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01097b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01097b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01097b9:	89 10                	mov    %edx,(%eax)
c01097bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01097be:	8b 10                	mov    (%eax),%edx
c01097c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097c3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01097c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01097cc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01097cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01097d5:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c01097d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01097da:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c01097e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01097e4:	8b 40 14             	mov    0x14(%eax),%eax
c01097e7:	8b 50 70             	mov    0x70(%eax),%edx
c01097ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ed:	89 50 78             	mov    %edx,0x78(%eax)
c01097f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01097f3:	8b 40 78             	mov    0x78(%eax),%eax
c01097f6:	85 c0                	test   %eax,%eax
c01097f8:	74 0c                	je     c0109806 <set_links+0x8a>
        proc->optr->yptr = proc;
c01097fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01097fd:	8b 40 78             	mov    0x78(%eax),%eax
c0109800:	8b 55 08             	mov    0x8(%ebp),%edx
c0109803:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c0109806:	8b 45 08             	mov    0x8(%ebp),%eax
c0109809:	8b 40 14             	mov    0x14(%eax),%eax
c010980c:	8b 55 08             	mov    0x8(%ebp),%edx
c010980f:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c0109812:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109817:	83 c0 01             	add    $0x1,%eax
c010981a:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c010981f:	c9                   	leave  
c0109820:	c3                   	ret    

c0109821 <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c0109821:	55                   	push   %ebp
c0109822:	89 e5                	mov    %esp,%ebp
c0109824:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c0109827:	8b 45 08             	mov    0x8(%ebp),%eax
c010982a:	83 c0 58             	add    $0x58,%eax
c010982d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109830:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109833:	8b 40 04             	mov    0x4(%eax),%eax
c0109836:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109839:	8b 12                	mov    (%edx),%edx
c010983b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010983e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109841:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109844:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109847:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010984a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010984d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109850:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c0109852:	8b 45 08             	mov    0x8(%ebp),%eax
c0109855:	8b 40 78             	mov    0x78(%eax),%eax
c0109858:	85 c0                	test   %eax,%eax
c010985a:	74 0f                	je     c010986b <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c010985c:	8b 45 08             	mov    0x8(%ebp),%eax
c010985f:	8b 40 78             	mov    0x78(%eax),%eax
c0109862:	8b 55 08             	mov    0x8(%ebp),%edx
c0109865:	8b 52 74             	mov    0x74(%edx),%edx
c0109868:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c010986b:	8b 45 08             	mov    0x8(%ebp),%eax
c010986e:	8b 40 74             	mov    0x74(%eax),%eax
c0109871:	85 c0                	test   %eax,%eax
c0109873:	74 11                	je     c0109886 <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c0109875:	8b 45 08             	mov    0x8(%ebp),%eax
c0109878:	8b 40 74             	mov    0x74(%eax),%eax
c010987b:	8b 55 08             	mov    0x8(%ebp),%edx
c010987e:	8b 52 78             	mov    0x78(%edx),%edx
c0109881:	89 50 78             	mov    %edx,0x78(%eax)
c0109884:	eb 0f                	jmp    c0109895 <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c0109886:	8b 45 08             	mov    0x8(%ebp),%eax
c0109889:	8b 40 14             	mov    0x14(%eax),%eax
c010988c:	8b 55 08             	mov    0x8(%ebp),%edx
c010988f:	8b 52 78             	mov    0x78(%edx),%edx
c0109892:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c0109895:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010989a:	83 e8 01             	sub    $0x1,%eax
c010989d:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c01098a2:	c9                   	leave  
c01098a3:	c3                   	ret    

c01098a4 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01098a4:	55                   	push   %ebp
c01098a5:	89 e5                	mov    %esp,%ebp
c01098a7:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01098aa:	c7 45 f8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01098b1:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01098b6:	83 c0 01             	add    $0x1,%eax
c01098b9:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c01098be:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01098c3:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01098c8:	7e 0c                	jle    c01098d6 <get_pid+0x32>
        last_pid = 1;
c01098ca:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c01098d1:	00 00 00 
        goto inside;
c01098d4:	eb 13                	jmp    c01098e9 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01098d6:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c01098dc:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01098e1:	39 c2                	cmp    %eax,%edx
c01098e3:	0f 8c ac 00 00 00    	jl     c0109995 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01098e9:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c01098f0:	20 00 00 
    repeat:
        le = list;
c01098f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01098f9:	eb 7f                	jmp    c010997a <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01098fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098fe:	83 e8 58             	sub    $0x58,%eax
c0109901:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0109904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109907:	8b 50 04             	mov    0x4(%eax),%edx
c010990a:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010990f:	39 c2                	cmp    %eax,%edx
c0109911:	75 3e                	jne    c0109951 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0109913:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109918:	83 c0 01             	add    $0x1,%eax
c010991b:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c0109920:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c0109926:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010992b:	39 c2                	cmp    %eax,%edx
c010992d:	7c 4b                	jl     c010997a <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c010992f:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109934:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109939:	7e 0a                	jle    c0109945 <get_pid+0xa1>
                        last_pid = 1;
c010993b:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c0109942:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0109945:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c010994c:	20 00 00 
                    goto repeat;
c010994f:	eb a2                	jmp    c01098f3 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0109951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109954:	8b 50 04             	mov    0x4(%eax),%edx
c0109957:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010995c:	39 c2                	cmp    %eax,%edx
c010995e:	7e 1a                	jle    c010997a <get_pid+0xd6>
c0109960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109963:	8b 50 04             	mov    0x4(%eax),%edx
c0109966:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010996b:	39 c2                	cmp    %eax,%edx
c010996d:	7d 0b                	jge    c010997a <get_pid+0xd6>
                next_safe = proc->pid;
c010996f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109972:	8b 40 04             	mov    0x4(%eax),%eax
c0109975:	a3 84 aa 12 c0       	mov    %eax,0xc012aa84
c010997a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010997d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109980:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109983:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0109986:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010998c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010998f:	0f 85 66 ff ff ff    	jne    c01098fb <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0109995:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
}
c010999a:	c9                   	leave  
c010999b:	c3                   	ret    

c010999c <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c010999c:	55                   	push   %ebp
c010999d:	89 e5                	mov    %esp,%ebp
c010999f:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01099a2:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01099a7:	39 45 08             	cmp    %eax,0x8(%ebp)
c01099aa:	74 63                	je     c0109a0f <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01099ac:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01099b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01099b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01099ba:	e8 19 fa ff ff       	call   c01093d8 <__intr_save>
c01099bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01099c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c5:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88
            load_esp0(next->kstack + KSTACKSIZE);
c01099ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099cd:	8b 40 0c             	mov    0xc(%eax),%eax
c01099d0:	05 00 20 00 00       	add    $0x2000,%eax
c01099d5:	89 04 24             	mov    %eax,(%esp)
c01099d8:	e8 27 b7 ff ff       	call   c0105104 <load_esp0>
            lcr3(next->cr3);
c01099dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099e0:	8b 40 40             	mov    0x40(%eax),%eax
c01099e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01099e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01099e9:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01099ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099ef:	8d 50 1c             	lea    0x1c(%eax),%edx
c01099f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099f5:	83 c0 1c             	add    $0x1c,%eax
c01099f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01099fc:	89 04 24             	mov    %eax,(%esp)
c01099ff:	e8 66 15 00 00       	call   c010af6a <switch_to>
        }
        local_intr_restore(intr_flag);
c0109a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a07:	89 04 24             	mov    %eax,(%esp)
c0109a0a:	e8 f3 f9 ff ff       	call   c0109402 <__intr_restore>
    }
}
c0109a0f:	c9                   	leave  
c0109a10:	c3                   	ret    

c0109a11 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0109a11:	55                   	push   %ebp
c0109a12:	89 e5                	mov    %esp,%ebp
c0109a14:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0109a17:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109a1c:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109a1f:	89 04 24             	mov    %eax,(%esp)
c0109a22:	e8 21 92 ff ff       	call   c0102c48 <forkrets>
}
c0109a27:	c9                   	leave  
c0109a28:	c3                   	ret    

c0109a29 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0109a29:	55                   	push   %ebp
c0109a2a:	89 e5                	mov    %esp,%ebp
c0109a2c:	53                   	push   %ebx
c0109a2d:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0109a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a33:	8d 58 60             	lea    0x60(%eax),%ebx
c0109a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a39:	8b 40 04             	mov    0x4(%eax),%eax
c0109a3c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109a43:	00 
c0109a44:	89 04 24             	mov    %eax,(%esp)
c0109a47:	e8 d4 18 00 00       	call   c010b320 <hash32>
c0109a4c:	c1 e0 03             	shl    $0x3,%eax
c0109a4f:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a57:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0109a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a63:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a69:	8b 40 04             	mov    0x4(%eax),%eax
c0109a6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109a6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109a72:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a75:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109a78:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109a7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109a81:	89 10                	mov    %edx,(%eax)
c0109a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109a86:	8b 10                	mov    (%eax),%edx
c0109a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a8b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0109a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a91:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109a94:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109a9d:	89 10                	mov    %edx,(%eax)
}
c0109a9f:	83 c4 34             	add    $0x34,%esp
c0109aa2:	5b                   	pop    %ebx
c0109aa3:	5d                   	pop    %ebp
c0109aa4:	c3                   	ret    

c0109aa5 <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c0109aa5:	55                   	push   %ebp
c0109aa6:	89 e5                	mov    %esp,%ebp
c0109aa8:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c0109aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aae:	83 c0 60             	add    $0x60,%eax
c0109ab1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109ab7:	8b 40 04             	mov    0x4(%eax),%eax
c0109aba:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109abd:	8b 12                	mov    (%edx),%edx
c0109abf:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109acb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ad1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109ad4:	89 10                	mov    %edx,(%eax)
}
c0109ad6:	c9                   	leave  
c0109ad7:	c3                   	ret    

c0109ad8 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0109ad8:	55                   	push   %ebp
c0109ad9:	89 e5                	mov    %esp,%ebp
c0109adb:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0109ade:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109ae2:	7e 5f                	jle    c0109b43 <find_proc+0x6b>
c0109ae4:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0109aeb:	7f 56                	jg     c0109b43 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0109aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0109af0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109af7:	00 
c0109af8:	89 04 24             	mov    %eax,(%esp)
c0109afb:	e8 20 18 00 00       	call   c010b320 <hash32>
c0109b00:	c1 e0 03             	shl    $0x3,%eax
c0109b03:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0109b11:	eb 19                	jmp    c0109b2c <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0109b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b16:	83 e8 60             	sub    $0x60,%eax
c0109b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0109b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b1f:	8b 40 04             	mov    0x4(%eax),%eax
c0109b22:	3b 45 08             	cmp    0x8(%ebp),%eax
c0109b25:	75 05                	jne    c0109b2c <find_proc+0x54>
                return proc;
c0109b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b2a:	eb 1c                	jmp    c0109b48 <find_proc+0x70>
c0109b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b35:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0109b41:	75 d0                	jne    c0109b13 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0109b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109b48:	c9                   	leave  
c0109b49:	c3                   	ret    

c0109b4a <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0109b4a:	55                   	push   %ebp
c0109b4b:	89 e5                	mov    %esp,%ebp
c0109b4d:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0109b50:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109b57:	00 
c0109b58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109b5f:	00 
c0109b60:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109b63:	89 04 24             	mov    %eax,(%esp)
c0109b66:	e8 62 22 00 00       	call   c010bdcd <memset>
    tf.tf_cs = KERNEL_CS;
c0109b6b:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0109b71:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0109b77:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0109b7b:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0109b7f:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0109b83:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0109b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0109b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b90:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0109b93:	b8 8f 93 10 c0       	mov    $0xc010938f,%eax
c0109b98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0109b9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b9e:	80 cc 01             	or     $0x1,%ah
c0109ba1:	89 c2                	mov    %eax,%edx
c0109ba3:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109baa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109bb1:	00 
c0109bb2:	89 14 24             	mov    %edx,(%esp)
c0109bb5:	e8 25 03 00 00       	call   c0109edf <do_fork>
}
c0109bba:	c9                   	leave  
c0109bbb:	c3                   	ret    

c0109bbc <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0109bbc:	55                   	push   %ebp
c0109bbd:	89 e5                	mov    %esp,%ebp
c0109bbf:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0109bc2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109bc9:	e8 84 b6 ff ff       	call   c0105252 <alloc_pages>
c0109bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0109bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109bd5:	74 1a                	je     c0109bf1 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0109bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bda:	89 04 24             	mov    %eax,(%esp)
c0109bdd:	e8 1e f9 ff ff       	call   c0109500 <page2kva>
c0109be2:	89 c2                	mov    %eax,%edx
c0109be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109be7:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0109bea:	b8 00 00 00 00       	mov    $0x0,%eax
c0109bef:	eb 05                	jmp    c0109bf6 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0109bf1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0109bf6:	c9                   	leave  
c0109bf7:	c3                   	ret    

c0109bf8 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0109bf8:	55                   	push   %ebp
c0109bf9:	89 e5                	mov    %esp,%ebp
c0109bfb:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0109bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c01:	8b 40 0c             	mov    0xc(%eax),%eax
c0109c04:	89 04 24             	mov    %eax,(%esp)
c0109c07:	e8 48 f9 ff ff       	call   c0109554 <kva2page>
c0109c0c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0109c13:	00 
c0109c14:	89 04 24             	mov    %eax,(%esp)
c0109c17:	e8 a1 b6 ff ff       	call   c01052bd <free_pages>
}
c0109c1c:	c9                   	leave  
c0109c1d:	c3                   	ret    

c0109c1e <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c0109c1e:	55                   	push   %ebp
c0109c1f:	89 e5                	mov    %esp,%ebp
c0109c21:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c0109c24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109c2b:	e8 22 b6 ff ff       	call   c0105252 <alloc_pages>
c0109c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109c37:	75 0a                	jne    c0109c43 <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109c39:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0109c3e:	e9 80 00 00 00       	jmp    c0109cc3 <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c0109c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109c46:	89 04 24             	mov    %eax,(%esp)
c0109c49:	e8 b2 f8 ff ff       	call   c0109500 <page2kva>
c0109c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c0109c51:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0109c56:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0109c5d:	00 
c0109c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c65:	89 04 24             	mov    %eax,(%esp)
c0109c68:	e8 42 22 00 00       	call   c010beaf <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c0109c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c70:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0109c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109c7c:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109c83:	77 23                	ja     c0109ca8 <setup_pgdir+0x8a>
c0109c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c88:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109c8c:	c7 44 24 08 b8 df 10 	movl   $0xc010dfb8,0x8(%esp)
c0109c93:	c0 
c0109c94:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0109c9b:	00 
c0109c9c:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c0109ca3:	e8 27 71 ff ff       	call   c0100dcf <__panic>
c0109ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cab:	05 00 00 00 40       	add    $0x40000000,%eax
c0109cb0:	83 c8 03             	or     $0x3,%eax
c0109cb3:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109cbb:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c0109cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109cc3:	c9                   	leave  
c0109cc4:	c3                   	ret    

c0109cc5 <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109cc5:	55                   	push   %ebp
c0109cc6:	89 e5                	mov    %esp,%ebp
c0109cc8:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cce:	8b 40 0c             	mov    0xc(%eax),%eax
c0109cd1:	89 04 24             	mov    %eax,(%esp)
c0109cd4:	e8 7b f8 ff ff       	call   c0109554 <kva2page>
c0109cd9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109ce0:	00 
c0109ce1:	89 04 24             	mov    %eax,(%esp)
c0109ce4:	e8 d4 b5 ff ff       	call   c01052bd <free_pages>
}
c0109ce9:	c9                   	leave  
c0109cea:	c3                   	ret    

c0109ceb <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109ceb:	55                   	push   %ebp
c0109cec:	89 e5                	mov    %esp,%ebp
c0109cee:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c0109cf1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109cf6:	8b 40 18             	mov    0x18(%eax),%eax
c0109cf9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109cfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109d00:	75 0a                	jne    c0109d0c <copy_mm+0x21>
        return 0;
c0109d02:	b8 00 00 00 00       	mov    $0x0,%eax
c0109d07:	e9 f9 00 00 00       	jmp    c0109e05 <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c0109d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d0f:	25 00 01 00 00       	and    $0x100,%eax
c0109d14:	85 c0                	test   %eax,%eax
c0109d16:	74 08                	je     c0109d20 <copy_mm+0x35>
        mm = oldmm;
c0109d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109d1e:	eb 78                	jmp    c0109d98 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c0109d20:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109d27:	e8 cb e2 ff ff       	call   c0107ff7 <mm_create>
c0109d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109d33:	75 05                	jne    c0109d3a <copy_mm+0x4f>
        goto bad_mm;
c0109d35:	e9 c8 00 00 00       	jmp    c0109e02 <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c0109d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d3d:	89 04 24             	mov    %eax,(%esp)
c0109d40:	e8 d9 fe ff ff       	call   c0109c1e <setup_pgdir>
c0109d45:	85 c0                	test   %eax,%eax
c0109d47:	74 05                	je     c0109d4e <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109d49:	e9 a9 00 00 00       	jmp    c0109df7 <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c0109d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d51:	89 04 24             	mov    %eax,(%esp)
c0109d54:	e8 79 f8 ff ff       	call   c01095d2 <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d63:	89 04 24             	mov    %eax,(%esp)
c0109d66:	e8 a3 e7 ff ff       	call   c010850e <dup_mmap>
c0109d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c0109d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d71:	89 04 24             	mov    %eax,(%esp)
c0109d74:	e8 75 f8 ff ff       	call   c01095ee <unlock_mm>

    if (ret != 0) {
c0109d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109d7d:	74 19                	je     c0109d98 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c0109d7f:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d83:	89 04 24             	mov    %eax,(%esp)
c0109d86:	e8 84 e8 ff ff       	call   c010860f <exit_mmap>
    put_pgdir(mm);
c0109d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d8e:	89 04 24             	mov    %eax,(%esp)
c0109d91:	e8 2f ff ff ff       	call   c0109cc5 <put_pgdir>
c0109d96:	eb 5f                	jmp    c0109df7 <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d9b:	89 04 24             	mov    %eax,(%esp)
c0109d9e:	e8 fb f7 ff ff       	call   c010959e <mm_count_inc>
    proc->mm = mm;
c0109da3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109da9:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c0109dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109daf:	8b 40 0c             	mov    0xc(%eax),%eax
c0109db2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109db5:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c0109dbc:	77 23                	ja     c0109de1 <copy_mm+0xf6>
c0109dbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109dc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109dc5:	c7 44 24 08 b8 df 10 	movl   $0xc010dfb8,0x8(%esp)
c0109dcc:	c0 
c0109dcd:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
c0109dd4:	00 
c0109dd5:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c0109ddc:	e8 ee 6f ff ff       	call   c0100dcf <__panic>
c0109de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109de4:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109dea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ded:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109df0:	b8 00 00 00 00       	mov    $0x0,%eax
c0109df5:	eb 0e                	jmp    c0109e05 <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dfa:	89 04 24             	mov    %eax,(%esp)
c0109dfd:	e8 4e e5 ff ff       	call   c0108350 <mm_destroy>
bad_mm:
    return ret;
c0109e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0109e05:	c9                   	leave  
c0109e06:	c3                   	ret    

c0109e07 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109e07:	55                   	push   %ebp
c0109e08:	89 e5                	mov    %esp,%ebp
c0109e0a:	57                   	push   %edi
c0109e0b:	56                   	push   %esi
c0109e0c:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e10:	8b 40 0c             	mov    0xc(%eax),%eax
c0109e13:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109e18:	89 c2                	mov    %eax,%edx
c0109e1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e1d:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109e20:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e23:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109e26:	8b 55 10             	mov    0x10(%ebp),%edx
c0109e29:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109e2e:	89 c1                	mov    %eax,%ecx
c0109e30:	83 e1 01             	and    $0x1,%ecx
c0109e33:	85 c9                	test   %ecx,%ecx
c0109e35:	74 0e                	je     c0109e45 <copy_thread+0x3e>
c0109e37:	0f b6 0a             	movzbl (%edx),%ecx
c0109e3a:	88 08                	mov    %cl,(%eax)
c0109e3c:	83 c0 01             	add    $0x1,%eax
c0109e3f:	83 c2 01             	add    $0x1,%edx
c0109e42:	83 eb 01             	sub    $0x1,%ebx
c0109e45:	89 c1                	mov    %eax,%ecx
c0109e47:	83 e1 02             	and    $0x2,%ecx
c0109e4a:	85 c9                	test   %ecx,%ecx
c0109e4c:	74 0f                	je     c0109e5d <copy_thread+0x56>
c0109e4e:	0f b7 0a             	movzwl (%edx),%ecx
c0109e51:	66 89 08             	mov    %cx,(%eax)
c0109e54:	83 c0 02             	add    $0x2,%eax
c0109e57:	83 c2 02             	add    $0x2,%edx
c0109e5a:	83 eb 02             	sub    $0x2,%ebx
c0109e5d:	89 d9                	mov    %ebx,%ecx
c0109e5f:	c1 e9 02             	shr    $0x2,%ecx
c0109e62:	89 c7                	mov    %eax,%edi
c0109e64:	89 d6                	mov    %edx,%esi
c0109e66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109e68:	89 f2                	mov    %esi,%edx
c0109e6a:	89 f8                	mov    %edi,%eax
c0109e6c:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109e71:	89 de                	mov    %ebx,%esi
c0109e73:	83 e6 02             	and    $0x2,%esi
c0109e76:	85 f6                	test   %esi,%esi
c0109e78:	74 0b                	je     c0109e85 <copy_thread+0x7e>
c0109e7a:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0109e7e:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109e82:	83 c1 02             	add    $0x2,%ecx
c0109e85:	83 e3 01             	and    $0x1,%ebx
c0109e88:	85 db                	test   %ebx,%ebx
c0109e8a:	74 07                	je     c0109e93 <copy_thread+0x8c>
c0109e8c:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109e90:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e96:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109e99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ea3:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109ea9:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0109eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0109eaf:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109eb2:	8b 55 08             	mov    0x8(%ebp),%edx
c0109eb5:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109eb8:	8b 52 40             	mov    0x40(%edx),%edx
c0109ebb:	80 ce 02             	or     $0x2,%dh
c0109ebe:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109ec1:	ba 11 9a 10 c0       	mov    $0xc0109a11,%edx
c0109ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ec9:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109ecc:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ecf:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ed2:	89 c2                	mov    %eax,%edx
c0109ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ed7:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109eda:	5b                   	pop    %ebx
c0109edb:	5e                   	pop    %esi
c0109edc:	5f                   	pop    %edi
c0109edd:	5d                   	pop    %ebp
c0109ede:	c3                   	ret    

c0109edf <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109edf:	55                   	push   %ebp
c0109ee0:	89 e5                	mov    %esp,%ebp
c0109ee2:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109ee5:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109eec:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109ef1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109ef6:	7e 05                	jle    c0109efd <do_fork+0x1e>
        goto fork_out;
c0109ef8:	e9 ec 00 00 00       	jmp    c0109fe9 <do_fork+0x10a>
    }
    ret = -E_NO_MEM;
c0109efd:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    if((proc = alloc_proc()) == NULL)
c0109f04:	e8 01 f7 ff ff       	call   c010960a <alloc_proc>
c0109f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109f0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109f10:	75 05                	jne    c0109f17 <do_fork+0x38>
    {
    	goto fork_out;
c0109f12:	e9 d2 00 00 00       	jmp    c0109fe9 <do_fork+0x10a>
    }
    proc->parent = current;
c0109f17:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f20:	89 50 14             	mov    %edx,0x14(%eax)
    assert(current->wait_state == 0);
c0109f23:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f28:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109f2b:	85 c0                	test   %eax,%eax
c0109f2d:	74 24                	je     c0109f53 <do_fork+0x74>
c0109f2f:	c7 44 24 0c f0 df 10 	movl   $0xc010dff0,0xc(%esp)
c0109f36:	c0 
c0109f37:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c0109f3e:	c0 
c0109f3f:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
c0109f46:	00 
c0109f47:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c0109f4e:	e8 7c 6e ff ff       	call   c0100dcf <__panic>
    //    2. call setup_kstack to allocate a kernel stack for child process
    if(setup_kstack(proc) != 0)
c0109f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f56:	89 04 24             	mov    %eax,(%esp)
c0109f59:	e8 5e fc ff ff       	call   c0109bbc <setup_kstack>
c0109f5e:	85 c0                	test   %eax,%eax
c0109f60:	74 0e                	je     c0109f70 <do_fork+0x91>
    {
    	goto bad_fork_cleanup_kstack;
c0109f62:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f66:	89 04 24             	mov    %eax,(%esp)
c0109f69:	e8 8a fc ff ff       	call   c0109bf8 <put_kstack>
c0109f6e:	eb 7e                	jmp    c0109fee <do_fork+0x10f>
    if(setup_kstack(proc) != 0)
    {
    	goto bad_fork_cleanup_kstack;
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
    if(copy_mm(clone_flags, proc) != 0)
c0109f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f77:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f7a:	89 04 24             	mov    %eax,(%esp)
c0109f7d:	e8 69 fd ff ff       	call   c0109ceb <copy_mm>
c0109f82:	85 c0                	test   %eax,%eax
c0109f84:	74 02                	je     c0109f88 <do_fork+0xa9>
    {
    	goto bad_fork_cleanup_proc;
c0109f86:	eb 66                	jmp    c0109fee <do_fork+0x10f>
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
c0109f88:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f99:	89 04 24             	mov    %eax,(%esp)
c0109f9c:	e8 66 fe ff ff       	call   c0109e07 <copy_thread>
    //    5. insert proc_struct into hash_list && proc_list
    bool intr_flag;
    local_intr_save(intr_flag);
c0109fa1:	e8 32 f4 ff ff       	call   c01093d8 <__intr_save>
c0109fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
		proc->pid = get_pid();
c0109fa9:	e8 f6 f8 ff ff       	call   c01098a4 <get_pid>
c0109fae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109fb1:	89 42 04             	mov    %eax,0x4(%edx)
		hash_proc(proc);
c0109fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fb7:	89 04 24             	mov    %eax,(%esp)
c0109fba:	e8 6a fa ff ff       	call   c0109a29 <hash_proc>
		set_links(proc);
c0109fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fc2:	89 04 24             	mov    %eax,(%esp)
c0109fc5:	e8 b2 f7 ff ff       	call   c010977c <set_links>
    }
    local_intr_restore(intr_flag);
c0109fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fcd:	89 04 24             	mov    %eax,(%esp)
c0109fd0:	e8 2d f4 ff ff       	call   c0109402 <__intr_restore>
    //    6. call wakup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0109fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fd8:	89 04 24             	mov    %eax,(%esp)
c0109fdb:	e8 fe 0f 00 00       	call   c010afde <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0109fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fe3:	8b 40 04             	mov    0x4(%eax),%eax
c0109fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
fork_out:
    return ret;
c0109fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109fec:	eb 0d                	jmp    c0109ffb <do_fork+0x11c>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0109fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ff1:	89 04 24             	mov    %eax,(%esp)
c0109ff4:	e8 ff ad ff ff       	call   c0104df8 <kfree>
    goto fork_out;
c0109ff9:	eb ee                	jmp    c0109fe9 <do_fork+0x10a>
}
c0109ffb:	c9                   	leave  
c0109ffc:	c3                   	ret    

c0109ffd <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109ffd:	55                   	push   %ebp
c0109ffe:	89 e5                	mov    %esp,%ebp
c010a000:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c010a003:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010a009:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010a00e:	39 c2                	cmp    %eax,%edx
c010a010:	75 1c                	jne    c010a02e <do_exit+0x31>
        panic("idleproc exit.\n");
c010a012:	c7 44 24 08 1e e0 10 	movl   $0xc010e01e,0x8(%esp)
c010a019:	c0 
c010a01a:	c7 44 24 04 c8 01 00 	movl   $0x1c8,0x4(%esp)
c010a021:	00 
c010a022:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a029:	e8 a1 6d ff ff       	call   c0100dcf <__panic>
    }
    if (current == initproc) {
c010a02e:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010a034:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a039:	39 c2                	cmp    %eax,%edx
c010a03b:	75 1c                	jne    c010a059 <do_exit+0x5c>
        panic("initproc exit.\n");
c010a03d:	c7 44 24 08 2e e0 10 	movl   $0xc010e02e,0x8(%esp)
c010a044:	c0 
c010a045:	c7 44 24 04 cb 01 00 	movl   $0x1cb,0x4(%esp)
c010a04c:	00 
c010a04d:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a054:	e8 76 6d ff ff       	call   c0100dcf <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c010a059:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a05e:	8b 40 18             	mov    0x18(%eax),%eax
c010a061:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c010a064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a068:	74 4a                	je     c010a0b4 <do_exit+0xb7>
        lcr3(boot_cr3);
c010a06a:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010a06f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010a072:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a075:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a078:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a07b:	89 04 24             	mov    %eax,(%esp)
c010a07e:	e8 35 f5 ff ff       	call   c01095b8 <mm_count_dec>
c010a083:	85 c0                	test   %eax,%eax
c010a085:	75 21                	jne    c010a0a8 <do_exit+0xab>
            exit_mmap(mm);
c010a087:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a08a:	89 04 24             	mov    %eax,(%esp)
c010a08d:	e8 7d e5 ff ff       	call   c010860f <exit_mmap>
            put_pgdir(mm);
c010a092:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a095:	89 04 24             	mov    %eax,(%esp)
c010a098:	e8 28 fc ff ff       	call   c0109cc5 <put_pgdir>
            mm_destroy(mm);
c010a09d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a0a0:	89 04 24             	mov    %eax,(%esp)
c010a0a3:	e8 a8 e2 ff ff       	call   c0108350 <mm_destroy>
        }
        current->mm = NULL;
c010a0a8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a0ad:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c010a0b4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a0b9:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c010a0bf:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a0c4:	8b 55 08             	mov    0x8(%ebp),%edx
c010a0c7:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c010a0ca:	e8 09 f3 ff ff       	call   c01093d8 <__intr_save>
c010a0cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c010a0d2:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a0d7:	8b 40 14             	mov    0x14(%eax),%eax
c010a0da:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c010a0dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0e0:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a0e3:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c010a0e8:	75 10                	jne    c010a0fa <do_exit+0xfd>
            wakeup_proc(proc);
c010a0ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0ed:	89 04 24             	mov    %eax,(%esp)
c010a0f0:	e8 e9 0e 00 00       	call   c010afde <wakeup_proc>
        }
        while (current->cptr != NULL) {
c010a0f5:	e9 8b 00 00 00       	jmp    c010a185 <do_exit+0x188>
c010a0fa:	e9 86 00 00 00       	jmp    c010a185 <do_exit+0x188>
            proc = current->cptr;
c010a0ff:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a104:	8b 40 70             	mov    0x70(%eax),%eax
c010a107:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c010a10a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a10f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a112:	8b 52 78             	mov    0x78(%edx),%edx
c010a115:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c010a118:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a11b:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c010a122:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a127:	8b 50 70             	mov    0x70(%eax),%edx
c010a12a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a12d:	89 50 78             	mov    %edx,0x78(%eax)
c010a130:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a133:	8b 40 78             	mov    0x78(%eax),%eax
c010a136:	85 c0                	test   %eax,%eax
c010a138:	74 0e                	je     c010a148 <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c010a13a:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a13f:	8b 40 70             	mov    0x70(%eax),%eax
c010a142:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a145:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c010a148:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010a14e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a151:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c010a154:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a159:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a15c:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c010a15f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a162:	8b 00                	mov    (%eax),%eax
c010a164:	83 f8 03             	cmp    $0x3,%eax
c010a167:	75 1c                	jne    c010a185 <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c010a169:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a16e:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a171:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c010a176:	75 0d                	jne    c010a185 <do_exit+0x188>
                    wakeup_proc(initproc);
c010a178:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a17d:	89 04 24             	mov    %eax,(%esp)
c010a180:	e8 59 0e 00 00       	call   c010afde <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c010a185:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a18a:	8b 40 70             	mov    0x70(%eax),%eax
c010a18d:	85 c0                	test   %eax,%eax
c010a18f:	0f 85 6a ff ff ff    	jne    c010a0ff <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c010a195:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a198:	89 04 24             	mov    %eax,(%esp)
c010a19b:	e8 62 f2 ff ff       	call   c0109402 <__intr_restore>
    
    schedule();
c010a1a0:	e8 bd 0e 00 00       	call   c010b062 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c010a1a5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a1aa:	8b 40 04             	mov    0x4(%eax),%eax
c010a1ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a1b1:	c7 44 24 08 40 e0 10 	movl   $0xc010e040,0x8(%esp)
c010a1b8:	c0 
c010a1b9:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010a1c0:	00 
c010a1c1:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a1c8:	e8 02 6c ff ff       	call   c0100dcf <__panic>

c010a1cd <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c010a1cd:	55                   	push   %ebp
c010a1ce:	89 e5                	mov    %esp,%ebp
c010a1d0:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c010a1d3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a1d8:	8b 40 18             	mov    0x18(%eax),%eax
c010a1db:	85 c0                	test   %eax,%eax
c010a1dd:	74 1c                	je     c010a1fb <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c010a1df:	c7 44 24 08 60 e0 10 	movl   $0xc010e060,0x8(%esp)
c010a1e6:	c0 
c010a1e7:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c010a1ee:	00 
c010a1ef:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a1f6:	e8 d4 6b ff ff       	call   c0100dcf <__panic>
    }

    int ret = -E_NO_MEM;
c010a1fb:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c010a202:	e8 f0 dd ff ff       	call   c0107ff7 <mm_create>
c010a207:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010a20a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010a20e:	75 06                	jne    c010a216 <load_icode+0x49>
        goto bad_mm;
c010a210:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c010a211:	e9 ef 05 00 00       	jmp    c010a805 <load_icode+0x638>
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c010a216:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a219:	89 04 24             	mov    %eax,(%esp)
c010a21c:	e8 fd f9 ff ff       	call   c0109c1e <setup_pgdir>
c010a221:	85 c0                	test   %eax,%eax
c010a223:	74 05                	je     c010a22a <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c010a225:	e9 f6 05 00 00       	jmp    c010a820 <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c010a22a:	8b 45 08             	mov    0x8(%ebp),%eax
c010a22d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c010a230:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a233:	8b 50 1c             	mov    0x1c(%eax),%edx
c010a236:	8b 45 08             	mov    0x8(%ebp),%eax
c010a239:	01 d0                	add    %edx,%eax
c010a23b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c010a23e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a241:	8b 00                	mov    (%eax),%eax
c010a243:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c010a248:	74 0c                	je     c010a256 <load_icode+0x89>
        ret = -E_INVAL_ELF;
c010a24a:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c010a251:	e9 bf 05 00 00       	jmp    c010a815 <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c010a256:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a259:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010a25d:	0f b7 c0             	movzwl %ax,%eax
c010a260:	c1 e0 05             	shl    $0x5,%eax
c010a263:	89 c2                	mov    %eax,%edx
c010a265:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a268:	01 d0                	add    %edx,%eax
c010a26a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c010a26d:	e9 13 03 00 00       	jmp    c010a585 <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c010a272:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a275:	8b 00                	mov    (%eax),%eax
c010a277:	83 f8 01             	cmp    $0x1,%eax
c010a27a:	74 05                	je     c010a281 <load_icode+0xb4>
            continue ;
c010a27c:	e9 00 03 00 00       	jmp    c010a581 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c010a281:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a284:	8b 50 10             	mov    0x10(%eax),%edx
c010a287:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a28a:	8b 40 14             	mov    0x14(%eax),%eax
c010a28d:	39 c2                	cmp    %eax,%edx
c010a28f:	76 0c                	jbe    c010a29d <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c010a291:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c010a298:	e9 6d 05 00 00       	jmp    c010a80a <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c010a29d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2a0:	8b 40 10             	mov    0x10(%eax),%eax
c010a2a3:	85 c0                	test   %eax,%eax
c010a2a5:	75 05                	jne    c010a2ac <load_icode+0xdf>
            continue ;
c010a2a7:	e9 d5 02 00 00       	jmp    c010a581 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c010a2ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010a2b3:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c010a2ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2bd:	8b 40 18             	mov    0x18(%eax),%eax
c010a2c0:	83 e0 01             	and    $0x1,%eax
c010a2c3:	85 c0                	test   %eax,%eax
c010a2c5:	74 04                	je     c010a2cb <load_icode+0xfe>
c010a2c7:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c010a2cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2ce:	8b 40 18             	mov    0x18(%eax),%eax
c010a2d1:	83 e0 02             	and    $0x2,%eax
c010a2d4:	85 c0                	test   %eax,%eax
c010a2d6:	74 04                	je     c010a2dc <load_icode+0x10f>
c010a2d8:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c010a2dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2df:	8b 40 18             	mov    0x18(%eax),%eax
c010a2e2:	83 e0 04             	and    $0x4,%eax
c010a2e5:	85 c0                	test   %eax,%eax
c010a2e7:	74 04                	je     c010a2ed <load_icode+0x120>
c010a2e9:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c010a2ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a2f0:	83 e0 02             	and    $0x2,%eax
c010a2f3:	85 c0                	test   %eax,%eax
c010a2f5:	74 04                	je     c010a2fb <load_icode+0x12e>
c010a2f7:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c010a2fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2fe:	8b 50 14             	mov    0x14(%eax),%edx
c010a301:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a304:	8b 40 08             	mov    0x8(%eax),%eax
c010a307:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a30e:	00 
c010a30f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a312:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a316:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a31a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a31e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a321:	89 04 24             	mov    %eax,(%esp)
c010a324:	e8 c9 e0 ff ff       	call   c01083f2 <mm_map>
c010a329:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a32c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a330:	74 05                	je     c010a337 <load_icode+0x16a>
            goto bad_cleanup_mmap;
c010a332:	e9 d3 04 00 00       	jmp    c010a80a <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c010a337:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a33a:	8b 50 04             	mov    0x4(%eax),%edx
c010a33d:	8b 45 08             	mov    0x8(%ebp),%eax
c010a340:	01 d0                	add    %edx,%eax
c010a342:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c010a345:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a348:	8b 40 08             	mov    0x8(%eax),%eax
c010a34b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a34e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a351:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010a354:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010a357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010a35c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c010a35f:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c010a366:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a369:	8b 50 08             	mov    0x8(%eax),%edx
c010a36c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a36f:	8b 40 10             	mov    0x10(%eax),%eax
c010a372:	01 d0                	add    %edx,%eax
c010a374:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a377:	e9 90 00 00 00       	jmp    c010a40c <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a37c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a37f:	8b 40 0c             	mov    0xc(%eax),%eax
c010a382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a385:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a389:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a38c:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a390:	89 04 24             	mov    %eax,(%esp)
c010a393:	e8 90 bd ff ff       	call   c0106128 <pgdir_alloc_page>
c010a398:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a39b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a39f:	75 05                	jne    c010a3a6 <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c010a3a1:	e9 64 04 00 00       	jmp    c010a80a <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a3a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a3a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a3ac:	29 c2                	sub    %eax,%edx
c010a3ae:	89 d0                	mov    %edx,%eax
c010a3b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a3b3:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a3b8:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a3bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a3be:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a3c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a3c8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a3cb:	73 0d                	jae    c010a3da <load_icode+0x20d>
                size -= la - end;
c010a3cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a3d0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a3d3:	29 c2                	sub    %eax,%edx
c010a3d5:	89 d0                	mov    %edx,%eax
c010a3d7:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c010a3da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a3dd:	89 04 24             	mov    %eax,(%esp)
c010a3e0:	e8 1b f1 ff ff       	call   c0109500 <page2kva>
c010a3e5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a3e8:	01 c2                	add    %eax,%edx
c010a3ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a3ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a3f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010a3f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a3f8:	89 14 24             	mov    %edx,(%esp)
c010a3fb:	e8 af 1a 00 00       	call   c010beaf <memcpy>
            start += size, from += size;
c010a400:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a403:	01 45 d8             	add    %eax,-0x28(%ebp)
c010a406:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a409:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a40c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a40f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a412:	0f 82 64 ff ff ff    	jb     c010a37c <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c010a418:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a41b:	8b 50 08             	mov    0x8(%eax),%edx
c010a41e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a421:	8b 40 14             	mov    0x14(%eax),%eax
c010a424:	01 d0                	add    %edx,%eax
c010a426:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c010a429:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a42c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a42f:	0f 83 b0 00 00 00    	jae    c010a4e5 <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c010a435:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a438:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a43b:	75 05                	jne    c010a442 <load_icode+0x275>
                continue ;
c010a43d:	e9 3f 01 00 00       	jmp    c010a581 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c010a442:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a445:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a448:	29 c2                	sub    %eax,%edx
c010a44a:	89 d0                	mov    %edx,%eax
c010a44c:	05 00 10 00 00       	add    $0x1000,%eax
c010a451:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a454:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a459:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a45c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c010a45f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a462:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a465:	73 0d                	jae    c010a474 <load_icode+0x2a7>
                size -= la - end;
c010a467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a46a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a46d:	29 c2                	sub    %eax,%edx
c010a46f:	89 d0                	mov    %edx,%eax
c010a471:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a474:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a477:	89 04 24             	mov    %eax,(%esp)
c010a47a:	e8 81 f0 ff ff       	call   c0109500 <page2kva>
c010a47f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a482:	01 c2                	add    %eax,%edx
c010a484:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a487:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a48b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a492:	00 
c010a493:	89 14 24             	mov    %edx,(%esp)
c010a496:	e8 32 19 00 00       	call   c010bdcd <memset>
            start += size;
c010a49b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a49e:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c010a4a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a4a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4a7:	73 08                	jae    c010a4b1 <load_icode+0x2e4>
c010a4a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a4ac:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a4af:	74 34                	je     c010a4e5 <load_icode+0x318>
c010a4b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a4b4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4b7:	72 08                	jb     c010a4c1 <load_icode+0x2f4>
c010a4b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a4bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4bf:	74 24                	je     c010a4e5 <load_icode+0x318>
c010a4c1:	c7 44 24 0c 88 e0 10 	movl   $0xc010e088,0xc(%esp)
c010a4c8:	c0 
c010a4c9:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010a4d0:	c0 
c010a4d1:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c010a4d8:	00 
c010a4d9:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a4e0:	e8 ea 68 ff ff       	call   c0100dcf <__panic>
        }
        while (start < end) {
c010a4e5:	e9 8b 00 00 00       	jmp    c010a575 <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a4ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4ed:	8b 40 0c             	mov    0xc(%eax),%eax
c010a4f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a4f3:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a4f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a4fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a4fe:	89 04 24             	mov    %eax,(%esp)
c010a501:	e8 22 bc ff ff       	call   c0106128 <pgdir_alloc_page>
c010a506:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a50d:	75 05                	jne    c010a514 <load_icode+0x347>
                goto bad_cleanup_mmap;
c010a50f:	e9 f6 02 00 00       	jmp    c010a80a <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a517:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a51a:	29 c2                	sub    %eax,%edx
c010a51c:	89 d0                	mov    %edx,%eax
c010a51e:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a521:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a526:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a529:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a52c:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a533:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a536:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a539:	73 0d                	jae    c010a548 <load_icode+0x37b>
                size -= la - end;
c010a53b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a53e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a541:	29 c2                	sub    %eax,%edx
c010a543:	89 d0                	mov    %edx,%eax
c010a545:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a548:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a54b:	89 04 24             	mov    %eax,(%esp)
c010a54e:	e8 ad ef ff ff       	call   c0109500 <page2kva>
c010a553:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a556:	01 c2                	add    %eax,%edx
c010a558:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a55b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a55f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a566:	00 
c010a567:	89 14 24             	mov    %edx,(%esp)
c010a56a:	e8 5e 18 00 00       	call   c010bdcd <memset>
            start += size;
c010a56f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a572:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a575:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a578:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a57b:	0f 82 69 ff ff ff    	jb     c010a4ea <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a581:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a585:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a588:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a58b:	0f 82 e1 fc ff ff    	jb     c010a272 <load_icode+0xa5>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a591:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a598:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a59f:	00 
c010a5a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a5a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a5a7:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a5ae:	00 
c010a5af:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a5b6:	af 
c010a5b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5ba:	89 04 24             	mov    %eax,(%esp)
c010a5bd:	e8 30 de ff ff       	call   c01083f2 <mm_map>
c010a5c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a5c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a5c9:	74 05                	je     c010a5d0 <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a5cb:	e9 3a 02 00 00       	jmp    c010a80a <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a5d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5d3:	8b 40 0c             	mov    0xc(%eax),%eax
c010a5d6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a5dd:	00 
c010a5de:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a5e5:	af 
c010a5e6:	89 04 24             	mov    %eax,(%esp)
c010a5e9:	e8 3a bb ff ff       	call   c0106128 <pgdir_alloc_page>
c010a5ee:	85 c0                	test   %eax,%eax
c010a5f0:	75 24                	jne    c010a616 <load_icode+0x449>
c010a5f2:	c7 44 24 0c c4 e0 10 	movl   $0xc010e0c4,0xc(%esp)
c010a5f9:	c0 
c010a5fa:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010a601:	c0 
c010a602:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c010a609:	00 
c010a60a:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a611:	e8 b9 67 ff ff       	call   c0100dcf <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a616:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a619:	8b 40 0c             	mov    0xc(%eax),%eax
c010a61c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a623:	00 
c010a624:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a62b:	af 
c010a62c:	89 04 24             	mov    %eax,(%esp)
c010a62f:	e8 f4 ba ff ff       	call   c0106128 <pgdir_alloc_page>
c010a634:	85 c0                	test   %eax,%eax
c010a636:	75 24                	jne    c010a65c <load_icode+0x48f>
c010a638:	c7 44 24 0c 08 e1 10 	movl   $0xc010e108,0xc(%esp)
c010a63f:	c0 
c010a640:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010a647:	c0 
c010a648:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c010a64f:	00 
c010a650:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a657:	e8 73 67 ff ff       	call   c0100dcf <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a65c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a65f:	8b 40 0c             	mov    0xc(%eax),%eax
c010a662:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a669:	00 
c010a66a:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a671:	af 
c010a672:	89 04 24             	mov    %eax,(%esp)
c010a675:	e8 ae ba ff ff       	call   c0106128 <pgdir_alloc_page>
c010a67a:	85 c0                	test   %eax,%eax
c010a67c:	75 24                	jne    c010a6a2 <load_icode+0x4d5>
c010a67e:	c7 44 24 0c 4c e1 10 	movl   $0xc010e14c,0xc(%esp)
c010a685:	c0 
c010a686:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010a68d:	c0 
c010a68e:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c010a695:	00 
c010a696:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a69d:	e8 2d 67 ff ff       	call   c0100dcf <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a6a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a6a5:	8b 40 0c             	mov    0xc(%eax),%eax
c010a6a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a6af:	00 
c010a6b0:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a6b7:	af 
c010a6b8:	89 04 24             	mov    %eax,(%esp)
c010a6bb:	e8 68 ba ff ff       	call   c0106128 <pgdir_alloc_page>
c010a6c0:	85 c0                	test   %eax,%eax
c010a6c2:	75 24                	jne    c010a6e8 <load_icode+0x51b>
c010a6c4:	c7 44 24 0c 90 e1 10 	movl   $0xc010e190,0xc(%esp)
c010a6cb:	c0 
c010a6cc:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010a6d3:	c0 
c010a6d4:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c010a6db:	00 
c010a6dc:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a6e3:	e8 e7 66 ff ff       	call   c0100dcf <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a6e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a6eb:	89 04 24             	mov    %eax,(%esp)
c010a6ee:	e8 ab ee ff ff       	call   c010959e <mm_count_inc>
    current->mm = mm;
c010a6f3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a6f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a6fb:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a6fe:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a703:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a706:	8b 52 0c             	mov    0xc(%edx),%edx
c010a709:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a70c:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a713:	77 23                	ja     c010a738 <load_icode+0x56b>
c010a715:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a718:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a71c:	c7 44 24 08 b8 df 10 	movl   $0xc010dfb8,0x8(%esp)
c010a723:	c0 
c010a724:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c010a72b:	00 
c010a72c:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a733:	e8 97 66 ff ff       	call   c0100dcf <__panic>
c010a738:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a73b:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a741:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a744:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a747:	8b 40 0c             	mov    0xc(%eax),%eax
c010a74a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a74d:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a754:	77 23                	ja     c010a779 <load_icode+0x5ac>
c010a756:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a759:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a75d:	c7 44 24 08 b8 df 10 	movl   $0xc010dfb8,0x8(%esp)
c010a764:	c0 
c010a765:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
c010a76c:	00 
c010a76d:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a774:	e8 56 66 ff ff       	call   c0100dcf <__panic>
c010a779:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a77c:	05 00 00 00 40       	add    $0x40000000,%eax
c010a781:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a784:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a787:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a78a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a78f:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a792:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a795:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a79c:	00 
c010a79d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a7a4:	00 
c010a7a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7a8:	89 04 24             	mov    %eax,(%esp)
c010a7ab:	e8 1d 16 00 00       	call   c010bdcd <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a7b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7b3:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a7b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7bc:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a7c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7c5:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a7c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7cc:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a7d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7d3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a7d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7da:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a7de:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7e1:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a7e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a7eb:	8b 50 18             	mov    0x18(%eax),%edx
c010a7ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7f1:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a7f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7f7:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    ret = 0;
c010a7fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a808:	eb 23                	jmp    c010a82d <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a80a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a80d:	89 04 24             	mov    %eax,(%esp)
c010a810:	e8 fa dd ff ff       	call   c010860f <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a815:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a818:	89 04 24             	mov    %eax,(%esp)
c010a81b:	e8 a5 f4 ff ff       	call   c0109cc5 <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a820:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a823:	89 04 24             	mov    %eax,(%esp)
c010a826:	e8 25 db ff ff       	call   c0108350 <mm_destroy>
bad_mm:
    goto out;
c010a82b:	eb d8                	jmp    c010a805 <load_icode+0x638>
}
c010a82d:	c9                   	leave  
c010a82e:	c3                   	ret    

c010a82f <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a82f:	55                   	push   %ebp
c010a830:	89 e5                	mov    %esp,%ebp
c010a832:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a835:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a83a:	8b 40 18             	mov    0x18(%eax),%eax
c010a83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a840:	8b 45 08             	mov    0x8(%ebp),%eax
c010a843:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a84a:	00 
c010a84b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a84e:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a852:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a859:	89 04 24             	mov    %eax,(%esp)
c010a85c:	e8 61 e8 ff ff       	call   c01090c2 <user_mem_check>
c010a861:	85 c0                	test   %eax,%eax
c010a863:	75 0a                	jne    c010a86f <do_execve+0x40>
        return -E_INVAL;
c010a865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a86a:	e9 f4 00 00 00       	jmp    c010a963 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a86f:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a873:	76 07                	jbe    c010a87c <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a875:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a87c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a883:	00 
c010a884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a88b:	00 
c010a88c:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a88f:	89 04 24             	mov    %eax,(%esp)
c010a892:	e8 36 15 00 00       	call   c010bdcd <memset>
    memcpy(local_name, name, len);
c010a897:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a89a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a89e:	8b 45 08             	mov    0x8(%ebp),%eax
c010a8a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a8a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a8a8:	89 04 24             	mov    %eax,(%esp)
c010a8ab:	e8 ff 15 00 00       	call   c010beaf <memcpy>

    if (mm != NULL) {
c010a8b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a8b4:	74 4a                	je     c010a900 <do_execve+0xd1>
        lcr3(boot_cr3);
c010a8b6:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010a8bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a8be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a8c1:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8c7:	89 04 24             	mov    %eax,(%esp)
c010a8ca:	e8 e9 ec ff ff       	call   c01095b8 <mm_count_dec>
c010a8cf:	85 c0                	test   %eax,%eax
c010a8d1:	75 21                	jne    c010a8f4 <do_execve+0xc5>
            exit_mmap(mm);
c010a8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8d6:	89 04 24             	mov    %eax,(%esp)
c010a8d9:	e8 31 dd ff ff       	call   c010860f <exit_mmap>
            put_pgdir(mm);
c010a8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8e1:	89 04 24             	mov    %eax,(%esp)
c010a8e4:	e8 dc f3 ff ff       	call   c0109cc5 <put_pgdir>
            mm_destroy(mm);
c010a8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8ec:	89 04 24             	mov    %eax,(%esp)
c010a8ef:	e8 5c da ff ff       	call   c0108350 <mm_destroy>
        }
        current->mm = NULL;
c010a8f4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a8f9:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a900:	8b 45 14             	mov    0x14(%ebp),%eax
c010a903:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a907:	8b 45 10             	mov    0x10(%ebp),%eax
c010a90a:	89 04 24             	mov    %eax,(%esp)
c010a90d:	e8 bb f8 ff ff       	call   c010a1cd <load_icode>
c010a912:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a915:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a919:	74 2f                	je     c010a94a <do_execve+0x11b>
        goto execve_exit;
c010a91b:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a91f:	89 04 24             	mov    %eax,(%esp)
c010a922:	e8 d6 f6 ff ff       	call   c0109ffd <do_exit>
    panic("already exit: %e.\n", ret);
c010a927:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a92a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a92e:	c7 44 24 08 d3 e1 10 	movl   $0xc010e1d3,0x8(%esp)
c010a935:	c0 
c010a936:	c7 44 24 04 b1 02 00 	movl   $0x2b1,0x4(%esp)
c010a93d:	00 
c010a93e:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010a945:	e8 85 64 ff ff       	call   c0100dcf <__panic>
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a94a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a94f:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a952:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a956:	89 04 24             	mov    %eax,(%esp)
c010a959:	e8 99 ed ff ff       	call   c01096f7 <set_proc_name>
    return 0;
c010a95e:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a963:	c9                   	leave  
c010a964:	c3                   	ret    

c010a965 <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a965:	55                   	push   %ebp
c010a966:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a968:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a96d:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a974:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a979:	5d                   	pop    %ebp
c010a97a:	c3                   	ret    

c010a97b <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a97b:	55                   	push   %ebp
c010a97c:	89 e5                	mov    %esp,%ebp
c010a97e:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a981:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a986:	8b 40 18             	mov    0x18(%eax),%eax
c010a989:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a98c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a990:	74 30                	je     c010a9c2 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a992:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a995:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a99c:	00 
c010a99d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a9a4:	00 
c010a9a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a9a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a9ac:	89 04 24             	mov    %eax,(%esp)
c010a9af:	e8 0e e7 ff ff       	call   c01090c2 <user_mem_check>
c010a9b4:	85 c0                	test   %eax,%eax
c010a9b6:	75 0a                	jne    c010a9c2 <do_wait+0x47>
            return -E_INVAL;
c010a9b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a9bd:	e9 4b 01 00 00       	jmp    c010ab0d <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a9c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a9c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a9cd:	74 39                	je     c010aa08 <do_wait+0x8d>
        proc = find_proc(pid);
c010a9cf:	8b 45 08             	mov    0x8(%ebp),%eax
c010a9d2:	89 04 24             	mov    %eax,(%esp)
c010a9d5:	e8 fe f0 ff ff       	call   c0109ad8 <find_proc>
c010a9da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a9dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a9e1:	74 54                	je     c010aa37 <do_wait+0xbc>
c010a9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a9e6:	8b 50 14             	mov    0x14(%eax),%edx
c010a9e9:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a9ee:	39 c2                	cmp    %eax,%edx
c010a9f0:	75 45                	jne    c010aa37 <do_wait+0xbc>
            haskid = 1;
c010a9f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a9fc:	8b 00                	mov    (%eax),%eax
c010a9fe:	83 f8 03             	cmp    $0x3,%eax
c010aa01:	75 34                	jne    c010aa37 <do_wait+0xbc>
                goto found;
c010aa03:	e9 80 00 00 00       	jmp    c010aa88 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010aa08:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aa0d:	8b 40 70             	mov    0x70(%eax),%eax
c010aa10:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010aa13:	eb 1c                	jmp    c010aa31 <do_wait+0xb6>
            haskid = 1;
c010aa15:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010aa1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa1f:	8b 00                	mov    (%eax),%eax
c010aa21:	83 f8 03             	cmp    $0x3,%eax
c010aa24:	75 02                	jne    c010aa28 <do_wait+0xad>
                goto found;
c010aa26:	eb 60                	jmp    c010aa88 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010aa28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa2b:	8b 40 78             	mov    0x78(%eax),%eax
c010aa2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aa31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010aa35:	75 de                	jne    c010aa15 <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010aa37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aa3b:	74 41                	je     c010aa7e <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010aa3d:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aa42:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010aa48:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aa4d:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010aa54:	e8 09 06 00 00       	call   c010b062 <schedule>
        if (current->flags & PF_EXITING) {
c010aa59:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aa5e:	8b 40 44             	mov    0x44(%eax),%eax
c010aa61:	83 e0 01             	and    $0x1,%eax
c010aa64:	85 c0                	test   %eax,%eax
c010aa66:	74 11                	je     c010aa79 <do_wait+0xfe>
            do_exit(-E_KILLED);
c010aa68:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010aa6f:	e8 89 f5 ff ff       	call   c0109ffd <do_exit>
        }
        goto repeat;
c010aa74:	e9 49 ff ff ff       	jmp    c010a9c2 <do_wait+0x47>
c010aa79:	e9 44 ff ff ff       	jmp    c010a9c2 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010aa7e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010aa83:	e9 85 00 00 00       	jmp    c010ab0d <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010aa88:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aa8d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010aa90:	74 0a                	je     c010aa9c <do_wait+0x121>
c010aa92:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aa97:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010aa9a:	75 1c                	jne    c010aab8 <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010aa9c:	c7 44 24 08 e6 e1 10 	movl   $0xc010e1e6,0x8(%esp)
c010aaa3:	c0 
c010aaa4:	c7 44 24 04 ea 02 00 	movl   $0x2ea,0x4(%esp)
c010aaab:	00 
c010aaac:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010aab3:	e8 17 63 ff ff       	call   c0100dcf <__panic>
    }
    if (code_store != NULL) {
c010aab8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010aabc:	74 0b                	je     c010aac9 <do_wait+0x14e>
        *code_store = proc->exit_code;
c010aabe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aac1:	8b 50 68             	mov    0x68(%eax),%edx
c010aac4:	8b 45 0c             	mov    0xc(%ebp),%eax
c010aac7:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010aac9:	e8 0a e9 ff ff       	call   c01093d8 <__intr_save>
c010aace:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010aad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aad4:	89 04 24             	mov    %eax,(%esp)
c010aad7:	e8 c9 ef ff ff       	call   c0109aa5 <unhash_proc>
        remove_links(proc);
c010aadc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aadf:	89 04 24             	mov    %eax,(%esp)
c010aae2:	e8 3a ed ff ff       	call   c0109821 <remove_links>
    }
    local_intr_restore(intr_flag);
c010aae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010aaea:	89 04 24             	mov    %eax,(%esp)
c010aaed:	e8 10 e9 ff ff       	call   c0109402 <__intr_restore>
    put_kstack(proc);
c010aaf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aaf5:	89 04 24             	mov    %eax,(%esp)
c010aaf8:	e8 fb f0 ff ff       	call   c0109bf8 <put_kstack>
    kfree(proc);
c010aafd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab00:	89 04 24             	mov    %eax,(%esp)
c010ab03:	e8 f0 a2 ff ff       	call   c0104df8 <kfree>
    return 0;
c010ab08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ab0d:	c9                   	leave  
c010ab0e:	c3                   	ret    

c010ab0f <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010ab0f:	55                   	push   %ebp
c010ab10:	89 e5                	mov    %esp,%ebp
c010ab12:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010ab15:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab18:	89 04 24             	mov    %eax,(%esp)
c010ab1b:	e8 b8 ef ff ff       	call   c0109ad8 <find_proc>
c010ab20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ab23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010ab27:	74 41                	je     c010ab6a <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010ab29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab2c:	8b 40 44             	mov    0x44(%eax),%eax
c010ab2f:	83 e0 01             	and    $0x1,%eax
c010ab32:	85 c0                	test   %eax,%eax
c010ab34:	75 2d                	jne    c010ab63 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010ab36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab39:	8b 40 44             	mov    0x44(%eax),%eax
c010ab3c:	83 c8 01             	or     $0x1,%eax
c010ab3f:	89 c2                	mov    %eax,%edx
c010ab41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab44:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010ab47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab4a:	8b 40 6c             	mov    0x6c(%eax),%eax
c010ab4d:	85 c0                	test   %eax,%eax
c010ab4f:	79 0b                	jns    c010ab5c <do_kill+0x4d>
                wakeup_proc(proc);
c010ab51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab54:	89 04 24             	mov    %eax,(%esp)
c010ab57:	e8 82 04 00 00       	call   c010afde <wakeup_proc>
            }
            return 0;
c010ab5c:	b8 00 00 00 00       	mov    $0x0,%eax
c010ab61:	eb 0c                	jmp    c010ab6f <do_kill+0x60>
        }
        return -E_KILLED;
c010ab63:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010ab68:	eb 05                	jmp    c010ab6f <do_kill+0x60>
    }
    return -E_INVAL;
c010ab6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010ab6f:	c9                   	leave  
c010ab70:	c3                   	ret    

c010ab71 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010ab71:	55                   	push   %ebp
c010ab72:	89 e5                	mov    %esp,%ebp
c010ab74:	57                   	push   %edi
c010ab75:	56                   	push   %esi
c010ab76:	53                   	push   %ebx
c010ab77:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010ab7a:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab7d:	89 04 24             	mov    %eax,(%esp)
c010ab80:	e8 19 0f 00 00       	call   c010ba9e <strlen>
c010ab85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010ab88:	b8 04 00 00 00       	mov    $0x4,%eax
c010ab8d:	8b 55 08             	mov    0x8(%ebp),%edx
c010ab90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010ab93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010ab96:	8b 75 10             	mov    0x10(%ebp),%esi
c010ab99:	89 f7                	mov    %esi,%edi
c010ab9b:	cd 80                	int    $0x80
c010ab9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010aba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010aba3:	83 c4 2c             	add    $0x2c,%esp
c010aba6:	5b                   	pop    %ebx
c010aba7:	5e                   	pop    %esi
c010aba8:	5f                   	pop    %edi
c010aba9:	5d                   	pop    %ebp
c010abaa:	c3                   	ret    

c010abab <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010abab:	55                   	push   %ebp
c010abac:	89 e5                	mov    %esp,%ebp
c010abae:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010abb1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010abb6:	8b 40 04             	mov    0x4(%eax),%eax
c010abb9:	c7 44 24 08 02 e2 10 	movl   $0xc010e202,0x8(%esp)
c010abc0:	c0 
c010abc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c010abc5:	c7 04 24 0c e2 10 c0 	movl   $0xc010e20c,(%esp)
c010abcc:	e8 82 57 ff ff       	call   c0100353 <cprintf>
c010abd1:	b8 e2 78 00 00       	mov    $0x78e2,%eax
c010abd6:	89 44 24 08          	mov    %eax,0x8(%esp)
c010abda:	c7 44 24 04 79 f8 15 	movl   $0xc015f879,0x4(%esp)
c010abe1:	c0 
c010abe2:	c7 04 24 02 e2 10 c0 	movl   $0xc010e202,(%esp)
c010abe9:	e8 83 ff ff ff       	call   c010ab71 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010abee:	c7 44 24 08 33 e2 10 	movl   $0xc010e233,0x8(%esp)
c010abf5:	c0 
c010abf6:	c7 44 24 04 33 03 00 	movl   $0x333,0x4(%esp)
c010abfd:	00 
c010abfe:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010ac05:	e8 c5 61 ff ff       	call   c0100dcf <__panic>

c010ac0a <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010ac0a:	55                   	push   %ebp
c010ac0b:	89 e5                	mov    %esp,%ebp
c010ac0d:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010ac10:	e8 da a6 ff ff       	call   c01052ef <nr_free_pages>
c010ac15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010ac18:	e8 a3 a0 ff ff       	call   c0104cc0 <kallocated>
c010ac1d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010ac20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010ac27:	00 
c010ac28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac2f:	00 
c010ac30:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c010ac37:	e8 0e ef ff ff       	call   c0109b4a <kernel_thread>
c010ac3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010ac3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010ac43:	7f 1c                	jg     c010ac61 <init_main+0x57>
        panic("create user_main failed.\n");
c010ac45:	c7 44 24 08 4d e2 10 	movl   $0xc010e24d,0x8(%esp)
c010ac4c:	c0 
c010ac4d:	c7 44 24 04 3e 03 00 	movl   $0x33e,0x4(%esp)
c010ac54:	00 
c010ac55:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010ac5c:	e8 6e 61 ff ff       	call   c0100dcf <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010ac61:	eb 05                	jmp    c010ac68 <init_main+0x5e>
        schedule();
c010ac63:	e8 fa 03 00 00       	call   c010b062 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010ac68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac6f:	00 
c010ac70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010ac77:	e8 ff fc ff ff       	call   c010a97b <do_wait>
c010ac7c:	85 c0                	test   %eax,%eax
c010ac7e:	74 e3                	je     c010ac63 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010ac80:	c7 04 24 68 e2 10 c0 	movl   $0xc010e268,(%esp)
c010ac87:	e8 c7 56 ff ff       	call   c0100353 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010ac8c:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ac91:	8b 40 70             	mov    0x70(%eax),%eax
c010ac94:	85 c0                	test   %eax,%eax
c010ac96:	75 18                	jne    c010acb0 <init_main+0xa6>
c010ac98:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ac9d:	8b 40 74             	mov    0x74(%eax),%eax
c010aca0:	85 c0                	test   %eax,%eax
c010aca2:	75 0c                	jne    c010acb0 <init_main+0xa6>
c010aca4:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aca9:	8b 40 78             	mov    0x78(%eax),%eax
c010acac:	85 c0                	test   %eax,%eax
c010acae:	74 24                	je     c010acd4 <init_main+0xca>
c010acb0:	c7 44 24 0c 8c e2 10 	movl   $0xc010e28c,0xc(%esp)
c010acb7:	c0 
c010acb8:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010acbf:	c0 
c010acc0:	c7 44 24 04 46 03 00 	movl   $0x346,0x4(%esp)
c010acc7:	00 
c010acc8:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010accf:	e8 fb 60 ff ff       	call   c0100dcf <__panic>
    assert(nr_process == 2);
c010acd4:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010acd9:	83 f8 02             	cmp    $0x2,%eax
c010acdc:	74 24                	je     c010ad02 <init_main+0xf8>
c010acde:	c7 44 24 0c d7 e2 10 	movl   $0xc010e2d7,0xc(%esp)
c010ace5:	c0 
c010ace6:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010aced:	c0 
c010acee:	c7 44 24 04 47 03 00 	movl   $0x347,0x4(%esp)
c010acf5:	00 
c010acf6:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010acfd:	e8 cd 60 ff ff       	call   c0100dcf <__panic>
c010ad02:	c7 45 e8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x18(%ebp)
c010ad09:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ad0c:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010ad0f:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010ad15:	83 c2 58             	add    $0x58,%edx
c010ad18:	39 d0                	cmp    %edx,%eax
c010ad1a:	74 24                	je     c010ad40 <init_main+0x136>
c010ad1c:	c7 44 24 0c e8 e2 10 	movl   $0xc010e2e8,0xc(%esp)
c010ad23:	c0 
c010ad24:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010ad2b:	c0 
c010ad2c:	c7 44 24 04 48 03 00 	movl   $0x348,0x4(%esp)
c010ad33:	00 
c010ad34:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010ad3b:	e8 8f 60 ff ff       	call   c0100dcf <__panic>
c010ad40:	c7 45 e4 b0 f0 19 c0 	movl   $0xc019f0b0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010ad47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ad4a:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010ad4c:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010ad52:	83 c2 58             	add    $0x58,%edx
c010ad55:	39 d0                	cmp    %edx,%eax
c010ad57:	74 24                	je     c010ad7d <init_main+0x173>
c010ad59:	c7 44 24 0c 18 e3 10 	movl   $0xc010e318,0xc(%esp)
c010ad60:	c0 
c010ad61:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010ad68:	c0 
c010ad69:	c7 44 24 04 49 03 00 	movl   $0x349,0x4(%esp)
c010ad70:	00 
c010ad71:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010ad78:	e8 52 60 ff ff       	call   c0100dcf <__panic>

    cprintf("init check memory pass.\n");
c010ad7d:	c7 04 24 48 e3 10 c0 	movl   $0xc010e348,(%esp)
c010ad84:	e8 ca 55 ff ff       	call   c0100353 <cprintf>
    return 0;
c010ad89:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ad8e:	c9                   	leave  
c010ad8f:	c3                   	ret    

c010ad90 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010ad90:	55                   	push   %ebp
c010ad91:	89 e5                	mov    %esp,%ebp
c010ad93:	83 ec 28             	sub    $0x28,%esp
c010ad96:	c7 45 ec b0 f0 19 c0 	movl   $0xc019f0b0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010ad9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ada0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010ada3:	89 50 04             	mov    %edx,0x4(%eax)
c010ada6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ada9:	8b 50 04             	mov    0x4(%eax),%edx
c010adac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010adaf:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010adb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010adb8:	eb 26                	jmp    c010ade0 <proc_init+0x50>
        list_init(hash_list + i);
c010adba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010adbd:	c1 e0 03             	shl    $0x3,%eax
c010adc0:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c010adc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010adc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010adcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010adce:	89 50 04             	mov    %edx,0x4(%eax)
c010add1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010add4:	8b 50 04             	mov    0x4(%eax),%edx
c010add7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010adda:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010addc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010ade0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010ade7:	7e d1                	jle    c010adba <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010ade9:	e8 1c e8 ff ff       	call   c010960a <alloc_proc>
c010adee:	a3 80 cf 19 c0       	mov    %eax,0xc019cf80
c010adf3:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010adf8:	85 c0                	test   %eax,%eax
c010adfa:	75 1c                	jne    c010ae18 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010adfc:	c7 44 24 08 61 e3 10 	movl   $0xc010e361,0x8(%esp)
c010ae03:	c0 
c010ae04:	c7 44 24 04 5b 03 00 	movl   $0x35b,0x4(%esp)
c010ae0b:	00 
c010ae0c:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010ae13:	e8 b7 5f ff ff       	call   c0100dcf <__panic>
    }

    idleproc->pid = 0;
c010ae18:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010ae24:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae29:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010ae2f:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae34:	ba 00 80 12 c0       	mov    $0xc0128000,%edx
c010ae39:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010ae3c:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae41:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010ae48:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae4d:	c7 44 24 04 79 e3 10 	movl   $0xc010e379,0x4(%esp)
c010ae54:	c0 
c010ae55:	89 04 24             	mov    %eax,(%esp)
c010ae58:	e8 9a e8 ff ff       	call   c01096f7 <set_proc_name>
    nr_process ++;
c010ae5d:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010ae62:	83 c0 01             	add    $0x1,%eax
c010ae65:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0

    current = idleproc;
c010ae6a:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae6f:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88

    int pid = kernel_thread(init_main, NULL, 0);
c010ae74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010ae7b:	00 
c010ae7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ae83:	00 
c010ae84:	c7 04 24 0a ac 10 c0 	movl   $0xc010ac0a,(%esp)
c010ae8b:	e8 ba ec ff ff       	call   c0109b4a <kernel_thread>
c010ae90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010ae93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ae97:	7f 1c                	jg     c010aeb5 <proc_init+0x125>
        panic("create init_main failed.\n");
c010ae99:	c7 44 24 08 7e e3 10 	movl   $0xc010e37e,0x8(%esp)
c010aea0:	c0 
c010aea1:	c7 44 24 04 69 03 00 	movl   $0x369,0x4(%esp)
c010aea8:	00 
c010aea9:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010aeb0:	e8 1a 5f ff ff       	call   c0100dcf <__panic>
    }

    initproc = find_proc(pid);
c010aeb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aeb8:	89 04 24             	mov    %eax,(%esp)
c010aebb:	e8 18 ec ff ff       	call   c0109ad8 <find_proc>
c010aec0:	a3 84 cf 19 c0       	mov    %eax,0xc019cf84
    set_proc_name(initproc, "init");
c010aec5:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aeca:	c7 44 24 04 98 e3 10 	movl   $0xc010e398,0x4(%esp)
c010aed1:	c0 
c010aed2:	89 04 24             	mov    %eax,(%esp)
c010aed5:	e8 1d e8 ff ff       	call   c01096f7 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010aeda:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aedf:	85 c0                	test   %eax,%eax
c010aee1:	74 0c                	je     c010aeef <proc_init+0x15f>
c010aee3:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aee8:	8b 40 04             	mov    0x4(%eax),%eax
c010aeeb:	85 c0                	test   %eax,%eax
c010aeed:	74 24                	je     c010af13 <proc_init+0x183>
c010aeef:	c7 44 24 0c a0 e3 10 	movl   $0xc010e3a0,0xc(%esp)
c010aef6:	c0 
c010aef7:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010aefe:	c0 
c010aeff:	c7 44 24 04 6f 03 00 	movl   $0x36f,0x4(%esp)
c010af06:	00 
c010af07:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010af0e:	e8 bc 5e ff ff       	call   c0100dcf <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010af13:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010af18:	85 c0                	test   %eax,%eax
c010af1a:	74 0d                	je     c010af29 <proc_init+0x199>
c010af1c:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010af21:	8b 40 04             	mov    0x4(%eax),%eax
c010af24:	83 f8 01             	cmp    $0x1,%eax
c010af27:	74 24                	je     c010af4d <proc_init+0x1bd>
c010af29:	c7 44 24 0c c8 e3 10 	movl   $0xc010e3c8,0xc(%esp)
c010af30:	c0 
c010af31:	c7 44 24 08 09 e0 10 	movl   $0xc010e009,0x8(%esp)
c010af38:	c0 
c010af39:	c7 44 24 04 70 03 00 	movl   $0x370,0x4(%esp)
c010af40:	00 
c010af41:	c7 04 24 dc df 10 c0 	movl   $0xc010dfdc,(%esp)
c010af48:	e8 82 5e ff ff       	call   c0100dcf <__panic>
}
c010af4d:	c9                   	leave  
c010af4e:	c3                   	ret    

c010af4f <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010af4f:	55                   	push   %ebp
c010af50:	89 e5                	mov    %esp,%ebp
c010af52:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010af55:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010af5a:	8b 40 10             	mov    0x10(%eax),%eax
c010af5d:	85 c0                	test   %eax,%eax
c010af5f:	74 07                	je     c010af68 <cpu_idle+0x19>
            schedule();
c010af61:	e8 fc 00 00 00       	call   c010b062 <schedule>
        }
    }
c010af66:	eb ed                	jmp    c010af55 <cpu_idle+0x6>
c010af68:	eb eb                	jmp    c010af55 <cpu_idle+0x6>

c010af6a <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010af6a:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010af6e:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010af70:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010af73:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010af76:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010af79:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010af7c:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010af7f:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010af82:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010af85:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010af89:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010af8c:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010af8f:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010af92:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010af95:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010af98:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010af9b:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010af9e:	ff 30                	pushl  (%eax)

    ret
c010afa0:	c3                   	ret    

c010afa1 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010afa1:	55                   	push   %ebp
c010afa2:	89 e5                	mov    %esp,%ebp
c010afa4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010afa7:	9c                   	pushf  
c010afa8:	58                   	pop    %eax
c010afa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010afac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010afaf:	25 00 02 00 00       	and    $0x200,%eax
c010afb4:	85 c0                	test   %eax,%eax
c010afb6:	74 0c                	je     c010afc4 <__intr_save+0x23>
        intr_disable();
c010afb8:	e8 6a 70 ff ff       	call   c0102027 <intr_disable>
        return 1;
c010afbd:	b8 01 00 00 00       	mov    $0x1,%eax
c010afc2:	eb 05                	jmp    c010afc9 <__intr_save+0x28>
    }
    return 0;
c010afc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010afc9:	c9                   	leave  
c010afca:	c3                   	ret    

c010afcb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010afcb:	55                   	push   %ebp
c010afcc:	89 e5                	mov    %esp,%ebp
c010afce:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010afd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010afd5:	74 05                	je     c010afdc <__intr_restore+0x11>
        intr_enable();
c010afd7:	e8 45 70 ff ff       	call   c0102021 <intr_enable>
    }
}
c010afdc:	c9                   	leave  
c010afdd:	c3                   	ret    

c010afde <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010afde:	55                   	push   %ebp
c010afdf:	89 e5                	mov    %esp,%ebp
c010afe1:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010afe4:	8b 45 08             	mov    0x8(%ebp),%eax
c010afe7:	8b 00                	mov    (%eax),%eax
c010afe9:	83 f8 03             	cmp    $0x3,%eax
c010afec:	75 24                	jne    c010b012 <wakeup_proc+0x34>
c010afee:	c7 44 24 0c ef e3 10 	movl   $0xc010e3ef,0xc(%esp)
c010aff5:	c0 
c010aff6:	c7 44 24 08 0a e4 10 	movl   $0xc010e40a,0x8(%esp)
c010affd:	c0 
c010affe:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010b005:	00 
c010b006:	c7 04 24 1f e4 10 c0 	movl   $0xc010e41f,(%esp)
c010b00d:	e8 bd 5d ff ff       	call   c0100dcf <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010b012:	e8 8a ff ff ff       	call   c010afa1 <__intr_save>
c010b017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010b01a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b01d:	8b 00                	mov    (%eax),%eax
c010b01f:	83 f8 02             	cmp    $0x2,%eax
c010b022:	74 15                	je     c010b039 <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010b024:	8b 45 08             	mov    0x8(%ebp),%eax
c010b027:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010b02d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b030:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010b037:	eb 1c                	jmp    c010b055 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010b039:	c7 44 24 08 35 e4 10 	movl   $0xc010e435,0x8(%esp)
c010b040:	c0 
c010b041:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010b048:	00 
c010b049:	c7 04 24 1f e4 10 c0 	movl   $0xc010e41f,(%esp)
c010b050:	e8 e6 5d ff ff       	call   c0100e3b <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010b055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b058:	89 04 24             	mov    %eax,(%esp)
c010b05b:	e8 6b ff ff ff       	call   c010afcb <__intr_restore>
}
c010b060:	c9                   	leave  
c010b061:	c3                   	ret    

c010b062 <schedule>:

void
schedule(void) {
c010b062:	55                   	push   %ebp
c010b063:	89 e5                	mov    %esp,%ebp
c010b065:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010b068:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010b06f:	e8 2d ff ff ff       	call   c010afa1 <__intr_save>
c010b074:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010b077:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b07c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010b083:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010b089:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010b08e:	39 c2                	cmp    %eax,%edx
c010b090:	74 0a                	je     c010b09c <schedule+0x3a>
c010b092:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b097:	83 c0 58             	add    $0x58,%eax
c010b09a:	eb 05                	jmp    c010b0a1 <schedule+0x3f>
c010b09c:	b8 b0 f0 19 c0       	mov    $0xc019f0b0,%eax
c010b0a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010b0a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b0a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b0aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010b0b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b0b3:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010b0b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b0b9:	81 7d f4 b0 f0 19 c0 	cmpl   $0xc019f0b0,-0xc(%ebp)
c010b0c0:	74 15                	je     c010b0d7 <schedule+0x75>
                next = le2proc(le, list_link);
c010b0c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0c5:	83 e8 58             	sub    $0x58,%eax
c010b0c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010b0cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0ce:	8b 00                	mov    (%eax),%eax
c010b0d0:	83 f8 02             	cmp    $0x2,%eax
c010b0d3:	75 02                	jne    c010b0d7 <schedule+0x75>
                    break;
c010b0d5:	eb 08                	jmp    c010b0df <schedule+0x7d>
                }
            }
        } while (le != last);
c010b0d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0da:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010b0dd:	75 cb                	jne    c010b0aa <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010b0df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b0e3:	74 0a                	je     c010b0ef <schedule+0x8d>
c010b0e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0e8:	8b 00                	mov    (%eax),%eax
c010b0ea:	83 f8 02             	cmp    $0x2,%eax
c010b0ed:	74 08                	je     c010b0f7 <schedule+0x95>
            next = idleproc;
c010b0ef:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010b0f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010b0f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0fa:	8b 40 08             	mov    0x8(%eax),%eax
c010b0fd:	8d 50 01             	lea    0x1(%eax),%edx
c010b100:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b103:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010b106:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b10b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010b10e:	74 0b                	je     c010b11b <schedule+0xb9>
            proc_run(next);
c010b110:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b113:	89 04 24             	mov    %eax,(%esp)
c010b116:	e8 81 e8 ff ff       	call   c010999c <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010b11b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b11e:	89 04 24             	mov    %eax,(%esp)
c010b121:	e8 a5 fe ff ff       	call   c010afcb <__intr_restore>
}
c010b126:	c9                   	leave  
c010b127:	c3                   	ret    

c010b128 <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010b128:	55                   	push   %ebp
c010b129:	89 e5                	mov    %esp,%ebp
c010b12b:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010b12e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b131:	8b 00                	mov    (%eax),%eax
c010b133:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010b136:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b139:	89 04 24             	mov    %eax,(%esp)
c010b13c:	e8 bc ee ff ff       	call   c0109ffd <do_exit>
}
c010b141:	c9                   	leave  
c010b142:	c3                   	ret    

c010b143 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010b143:	55                   	push   %ebp
c010b144:	89 e5                	mov    %esp,%ebp
c010b146:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010b149:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b14e:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b151:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010b154:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b157:	8b 40 44             	mov    0x44(%eax),%eax
c010b15a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010b15d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b160:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b164:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b167:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b16b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010b172:	e8 68 ed ff ff       	call   c0109edf <do_fork>
}
c010b177:	c9                   	leave  
c010b178:	c3                   	ret    

c010b179 <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010b179:	55                   	push   %ebp
c010b17a:	89 e5                	mov    %esp,%ebp
c010b17c:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b17f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b182:	8b 00                	mov    (%eax),%eax
c010b184:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010b187:	8b 45 08             	mov    0x8(%ebp),%eax
c010b18a:	83 c0 04             	add    $0x4,%eax
c010b18d:	8b 00                	mov    (%eax),%eax
c010b18f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010b192:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b195:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b199:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b19c:	89 04 24             	mov    %eax,(%esp)
c010b19f:	e8 d7 f7 ff ff       	call   c010a97b <do_wait>
}
c010b1a4:	c9                   	leave  
c010b1a5:	c3                   	ret    

c010b1a6 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010b1a6:	55                   	push   %ebp
c010b1a7:	89 e5                	mov    %esp,%ebp
c010b1a9:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010b1ac:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1af:	8b 00                	mov    (%eax),%eax
c010b1b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010b1b4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1b7:	8b 40 04             	mov    0x4(%eax),%eax
c010b1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010b1bd:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1c0:	83 c0 08             	add    $0x8,%eax
c010b1c3:	8b 00                	mov    (%eax),%eax
c010b1c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010b1c8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1cb:	8b 40 0c             	mov    0xc(%eax),%eax
c010b1ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010b1d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b1d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b1d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b1db:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b1df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b1e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1e9:	89 04 24             	mov    %eax,(%esp)
c010b1ec:	e8 3e f6 ff ff       	call   c010a82f <do_execve>
}
c010b1f1:	c9                   	leave  
c010b1f2:	c3                   	ret    

c010b1f3 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010b1f3:	55                   	push   %ebp
c010b1f4:	89 e5                	mov    %esp,%ebp
c010b1f6:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010b1f9:	e8 67 f7 ff ff       	call   c010a965 <do_yield>
}
c010b1fe:	c9                   	leave  
c010b1ff:	c3                   	ret    

c010b200 <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010b200:	55                   	push   %ebp
c010b201:	89 e5                	mov    %esp,%ebp
c010b203:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b206:	8b 45 08             	mov    0x8(%ebp),%eax
c010b209:	8b 00                	mov    (%eax),%eax
c010b20b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010b20e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b211:	89 04 24             	mov    %eax,(%esp)
c010b214:	e8 f6 f8 ff ff       	call   c010ab0f <do_kill>
}
c010b219:	c9                   	leave  
c010b21a:	c3                   	ret    

c010b21b <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010b21b:	55                   	push   %ebp
c010b21c:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010b21e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b223:	8b 40 04             	mov    0x4(%eax),%eax
}
c010b226:	5d                   	pop    %ebp
c010b227:	c3                   	ret    

c010b228 <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010b228:	55                   	push   %ebp
c010b229:	89 e5                	mov    %esp,%ebp
c010b22b:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010b22e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b231:	8b 00                	mov    (%eax),%eax
c010b233:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010b236:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b239:	89 04 24             	mov    %eax,(%esp)
c010b23c:	e8 38 51 ff ff       	call   c0100379 <cputchar>
    return 0;
c010b241:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b246:	c9                   	leave  
c010b247:	c3                   	ret    

c010b248 <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010b248:	55                   	push   %ebp
c010b249:	89 e5                	mov    %esp,%ebp
c010b24b:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010b24e:	e8 f4 ba ff ff       	call   c0106d47 <print_pgdir>
    return 0;
c010b253:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b258:	c9                   	leave  
c010b259:	c3                   	ret    

c010b25a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010b25a:	55                   	push   %ebp
c010b25b:	89 e5                	mov    %esp,%ebp
c010b25d:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010b260:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b265:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b268:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010b26b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b26e:	8b 40 1c             	mov    0x1c(%eax),%eax
c010b271:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010b274:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b278:	78 5e                	js     c010b2d8 <syscall+0x7e>
c010b27a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b27d:	83 f8 1f             	cmp    $0x1f,%eax
c010b280:	77 56                	ja     c010b2d8 <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010b282:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b285:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b28c:	85 c0                	test   %eax,%eax
c010b28e:	74 48                	je     c010b2d8 <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010b290:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b293:	8b 40 14             	mov    0x14(%eax),%eax
c010b296:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010b299:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b29c:	8b 40 18             	mov    0x18(%eax),%eax
c010b29f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2a5:	8b 40 10             	mov    0x10(%eax),%eax
c010b2a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b2ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2ae:	8b 00                	mov    (%eax),%eax
c010b2b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b2b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2b6:	8b 40 04             	mov    0x4(%eax),%eax
c010b2b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b2bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2bf:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b2c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010b2c9:	89 14 24             	mov    %edx,(%esp)
c010b2cc:	ff d0                	call   *%eax
c010b2ce:	89 c2                	mov    %eax,%edx
c010b2d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2d3:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010b2d6:	eb 46                	jmp    c010b31e <syscall+0xc4>
        }
    }
    print_trapframe(tf);
c010b2d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2db:	89 04 24             	mov    %eax,(%esp)
c010b2de:	e8 9e 72 ff ff       	call   c0102581 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b2e3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b2e8:	8d 50 48             	lea    0x48(%eax),%edx
c010b2eb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b2f0:	8b 40 04             	mov    0x4(%eax),%eax
c010b2f3:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b2f7:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b2fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b302:	c7 44 24 08 50 e4 10 	movl   $0xc010e450,0x8(%esp)
c010b309:	c0 
c010b30a:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010b311:	00 
c010b312:	c7 04 24 7c e4 10 c0 	movl   $0xc010e47c,(%esp)
c010b319:	e8 b1 5a ff ff       	call   c0100dcf <__panic>
            num, current->pid, current->name);
}
c010b31e:	c9                   	leave  
c010b31f:	c3                   	ret    

c010b320 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b320:	55                   	push   %ebp
c010b321:	89 e5                	mov    %esp,%ebp
c010b323:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b326:	8b 45 08             	mov    0x8(%ebp),%eax
c010b329:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010b332:	b8 20 00 00 00       	mov    $0x20,%eax
c010b337:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b33a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010b33d:	89 c1                	mov    %eax,%ecx
c010b33f:	d3 ea                	shr    %cl,%edx
c010b341:	89 d0                	mov    %edx,%eax
}
c010b343:	c9                   	leave  
c010b344:	c3                   	ret    

c010b345 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b345:	55                   	push   %ebp
c010b346:	89 e5                	mov    %esp,%ebp
c010b348:	83 ec 58             	sub    $0x58,%esp
c010b34b:	8b 45 10             	mov    0x10(%ebp),%eax
c010b34e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b351:	8b 45 14             	mov    0x14(%ebp),%eax
c010b354:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b357:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b35a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b35d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b360:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b363:	8b 45 18             	mov    0x18(%ebp),%eax
c010b366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b369:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b36c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b36f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b372:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010b375:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b378:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b37b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b37f:	74 1c                	je     c010b39d <printnum+0x58>
c010b381:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b384:	ba 00 00 00 00       	mov    $0x0,%edx
c010b389:	f7 75 e4             	divl   -0x1c(%ebp)
c010b38c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b38f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b392:	ba 00 00 00 00       	mov    $0x0,%edx
c010b397:	f7 75 e4             	divl   -0x1c(%ebp)
c010b39a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b39d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b3a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b3a3:	f7 75 e4             	divl   -0x1c(%ebp)
c010b3a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b3a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010b3ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b3af:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b3b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b3b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b3b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b3bb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b3be:	8b 45 18             	mov    0x18(%ebp),%eax
c010b3c1:	ba 00 00 00 00       	mov    $0x0,%edx
c010b3c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b3c9:	77 56                	ja     c010b421 <printnum+0xdc>
c010b3cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b3ce:	72 05                	jb     c010b3d5 <printnum+0x90>
c010b3d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b3d3:	77 4c                	ja     c010b421 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b3d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b3d8:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b3db:	8b 45 20             	mov    0x20(%ebp),%eax
c010b3de:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b3e2:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b3e6:	8b 45 18             	mov    0x18(%ebp),%eax
c010b3e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b3ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b3f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b3f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b3f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b3fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b402:	8b 45 08             	mov    0x8(%ebp),%eax
c010b405:	89 04 24             	mov    %eax,(%esp)
c010b408:	e8 38 ff ff ff       	call   c010b345 <printnum>
c010b40d:	eb 1c                	jmp    c010b42b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b40f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b412:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b416:	8b 45 20             	mov    0x20(%ebp),%eax
c010b419:	89 04 24             	mov    %eax,(%esp)
c010b41c:	8b 45 08             	mov    0x8(%ebp),%eax
c010b41f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b421:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b425:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b429:	7f e4                	jg     c010b40f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b42b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b42e:	05 a4 e5 10 c0       	add    $0xc010e5a4,%eax
c010b433:	0f b6 00             	movzbl (%eax),%eax
c010b436:	0f be c0             	movsbl %al,%eax
c010b439:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b43c:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b440:	89 04 24             	mov    %eax,(%esp)
c010b443:	8b 45 08             	mov    0x8(%ebp),%eax
c010b446:	ff d0                	call   *%eax
}
c010b448:	c9                   	leave  
c010b449:	c3                   	ret    

c010b44a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b44a:	55                   	push   %ebp
c010b44b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b44d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b451:	7e 14                	jle    c010b467 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b453:	8b 45 08             	mov    0x8(%ebp),%eax
c010b456:	8b 00                	mov    (%eax),%eax
c010b458:	8d 48 08             	lea    0x8(%eax),%ecx
c010b45b:	8b 55 08             	mov    0x8(%ebp),%edx
c010b45e:	89 0a                	mov    %ecx,(%edx)
c010b460:	8b 50 04             	mov    0x4(%eax),%edx
c010b463:	8b 00                	mov    (%eax),%eax
c010b465:	eb 30                	jmp    c010b497 <getuint+0x4d>
    }
    else if (lflag) {
c010b467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b46b:	74 16                	je     c010b483 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b46d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b470:	8b 00                	mov    (%eax),%eax
c010b472:	8d 48 04             	lea    0x4(%eax),%ecx
c010b475:	8b 55 08             	mov    0x8(%ebp),%edx
c010b478:	89 0a                	mov    %ecx,(%edx)
c010b47a:	8b 00                	mov    (%eax),%eax
c010b47c:	ba 00 00 00 00       	mov    $0x0,%edx
c010b481:	eb 14                	jmp    c010b497 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b483:	8b 45 08             	mov    0x8(%ebp),%eax
c010b486:	8b 00                	mov    (%eax),%eax
c010b488:	8d 48 04             	lea    0x4(%eax),%ecx
c010b48b:	8b 55 08             	mov    0x8(%ebp),%edx
c010b48e:	89 0a                	mov    %ecx,(%edx)
c010b490:	8b 00                	mov    (%eax),%eax
c010b492:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b497:	5d                   	pop    %ebp
c010b498:	c3                   	ret    

c010b499 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b499:	55                   	push   %ebp
c010b49a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b49c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b4a0:	7e 14                	jle    c010b4b6 <getint+0x1d>
        return va_arg(*ap, long long);
c010b4a2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4a5:	8b 00                	mov    (%eax),%eax
c010b4a7:	8d 48 08             	lea    0x8(%eax),%ecx
c010b4aa:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4ad:	89 0a                	mov    %ecx,(%edx)
c010b4af:	8b 50 04             	mov    0x4(%eax),%edx
c010b4b2:	8b 00                	mov    (%eax),%eax
c010b4b4:	eb 28                	jmp    c010b4de <getint+0x45>
    }
    else if (lflag) {
c010b4b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b4ba:	74 12                	je     c010b4ce <getint+0x35>
        return va_arg(*ap, long);
c010b4bc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4bf:	8b 00                	mov    (%eax),%eax
c010b4c1:	8d 48 04             	lea    0x4(%eax),%ecx
c010b4c4:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4c7:	89 0a                	mov    %ecx,(%edx)
c010b4c9:	8b 00                	mov    (%eax),%eax
c010b4cb:	99                   	cltd   
c010b4cc:	eb 10                	jmp    c010b4de <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b4ce:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4d1:	8b 00                	mov    (%eax),%eax
c010b4d3:	8d 48 04             	lea    0x4(%eax),%ecx
c010b4d6:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4d9:	89 0a                	mov    %ecx,(%edx)
c010b4db:	8b 00                	mov    (%eax),%eax
c010b4dd:	99                   	cltd   
    }
}
c010b4de:	5d                   	pop    %ebp
c010b4df:	c3                   	ret    

c010b4e0 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b4e0:	55                   	push   %ebp
c010b4e1:	89 e5                	mov    %esp,%ebp
c010b4e3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b4e6:	8d 45 14             	lea    0x14(%ebp),%eax
c010b4e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b4ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b4f3:	8b 45 10             	mov    0x10(%ebp),%eax
c010b4f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b501:	8b 45 08             	mov    0x8(%ebp),%eax
c010b504:	89 04 24             	mov    %eax,(%esp)
c010b507:	e8 02 00 00 00       	call   c010b50e <vprintfmt>
    va_end(ap);
}
c010b50c:	c9                   	leave  
c010b50d:	c3                   	ret    

c010b50e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b50e:	55                   	push   %ebp
c010b50f:	89 e5                	mov    %esp,%ebp
c010b511:	56                   	push   %esi
c010b512:	53                   	push   %ebx
c010b513:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b516:	eb 18                	jmp    c010b530 <vprintfmt+0x22>
            if (ch == '\0') {
c010b518:	85 db                	test   %ebx,%ebx
c010b51a:	75 05                	jne    c010b521 <vprintfmt+0x13>
                return;
c010b51c:	e9 d1 03 00 00       	jmp    c010b8f2 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b521:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b524:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b528:	89 1c 24             	mov    %ebx,(%esp)
c010b52b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b52e:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b530:	8b 45 10             	mov    0x10(%ebp),%eax
c010b533:	8d 50 01             	lea    0x1(%eax),%edx
c010b536:	89 55 10             	mov    %edx,0x10(%ebp)
c010b539:	0f b6 00             	movzbl (%eax),%eax
c010b53c:	0f b6 d8             	movzbl %al,%ebx
c010b53f:	83 fb 25             	cmp    $0x25,%ebx
c010b542:	75 d4                	jne    c010b518 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b544:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b548:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b54f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b552:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b555:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b55c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b55f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b562:	8b 45 10             	mov    0x10(%ebp),%eax
c010b565:	8d 50 01             	lea    0x1(%eax),%edx
c010b568:	89 55 10             	mov    %edx,0x10(%ebp)
c010b56b:	0f b6 00             	movzbl (%eax),%eax
c010b56e:	0f b6 d8             	movzbl %al,%ebx
c010b571:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b574:	83 f8 55             	cmp    $0x55,%eax
c010b577:	0f 87 44 03 00 00    	ja     c010b8c1 <vprintfmt+0x3b3>
c010b57d:	8b 04 85 c8 e5 10 c0 	mov    -0x3fef1a38(,%eax,4),%eax
c010b584:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b586:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b58a:	eb d6                	jmp    c010b562 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b58c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b590:	eb d0                	jmp    c010b562 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b592:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b59c:	89 d0                	mov    %edx,%eax
c010b59e:	c1 e0 02             	shl    $0x2,%eax
c010b5a1:	01 d0                	add    %edx,%eax
c010b5a3:	01 c0                	add    %eax,%eax
c010b5a5:	01 d8                	add    %ebx,%eax
c010b5a7:	83 e8 30             	sub    $0x30,%eax
c010b5aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b5ad:	8b 45 10             	mov    0x10(%ebp),%eax
c010b5b0:	0f b6 00             	movzbl (%eax),%eax
c010b5b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b5b6:	83 fb 2f             	cmp    $0x2f,%ebx
c010b5b9:	7e 0b                	jle    c010b5c6 <vprintfmt+0xb8>
c010b5bb:	83 fb 39             	cmp    $0x39,%ebx
c010b5be:	7f 06                	jg     c010b5c6 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b5c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b5c4:	eb d3                	jmp    c010b599 <vprintfmt+0x8b>
            goto process_precision;
c010b5c6:	eb 33                	jmp    c010b5fb <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b5c8:	8b 45 14             	mov    0x14(%ebp),%eax
c010b5cb:	8d 50 04             	lea    0x4(%eax),%edx
c010b5ce:	89 55 14             	mov    %edx,0x14(%ebp)
c010b5d1:	8b 00                	mov    (%eax),%eax
c010b5d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b5d6:	eb 23                	jmp    c010b5fb <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b5d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b5dc:	79 0c                	jns    c010b5ea <vprintfmt+0xdc>
                width = 0;
c010b5de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b5e5:	e9 78 ff ff ff       	jmp    c010b562 <vprintfmt+0x54>
c010b5ea:	e9 73 ff ff ff       	jmp    c010b562 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b5ef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b5f6:	e9 67 ff ff ff       	jmp    c010b562 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b5fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b5ff:	79 12                	jns    c010b613 <vprintfmt+0x105>
                width = precision, precision = -1;
c010b601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b604:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b607:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b60e:	e9 4f ff ff ff       	jmp    c010b562 <vprintfmt+0x54>
c010b613:	e9 4a ff ff ff       	jmp    c010b562 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b618:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b61c:	e9 41 ff ff ff       	jmp    c010b562 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b621:	8b 45 14             	mov    0x14(%ebp),%eax
c010b624:	8d 50 04             	lea    0x4(%eax),%edx
c010b627:	89 55 14             	mov    %edx,0x14(%ebp)
c010b62a:	8b 00                	mov    (%eax),%eax
c010b62c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b62f:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b633:	89 04 24             	mov    %eax,(%esp)
c010b636:	8b 45 08             	mov    0x8(%ebp),%eax
c010b639:	ff d0                	call   *%eax
            break;
c010b63b:	e9 ac 02 00 00       	jmp    c010b8ec <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b640:	8b 45 14             	mov    0x14(%ebp),%eax
c010b643:	8d 50 04             	lea    0x4(%eax),%edx
c010b646:	89 55 14             	mov    %edx,0x14(%ebp)
c010b649:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b64b:	85 db                	test   %ebx,%ebx
c010b64d:	79 02                	jns    c010b651 <vprintfmt+0x143>
                err = -err;
c010b64f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b651:	83 fb 18             	cmp    $0x18,%ebx
c010b654:	7f 0b                	jg     c010b661 <vprintfmt+0x153>
c010b656:	8b 34 9d 40 e5 10 c0 	mov    -0x3fef1ac0(,%ebx,4),%esi
c010b65d:	85 f6                	test   %esi,%esi
c010b65f:	75 23                	jne    c010b684 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b661:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b665:	c7 44 24 08 b5 e5 10 	movl   $0xc010e5b5,0x8(%esp)
c010b66c:	c0 
c010b66d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b670:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b674:	8b 45 08             	mov    0x8(%ebp),%eax
c010b677:	89 04 24             	mov    %eax,(%esp)
c010b67a:	e8 61 fe ff ff       	call   c010b4e0 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b67f:	e9 68 02 00 00       	jmp    c010b8ec <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b684:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b688:	c7 44 24 08 be e5 10 	movl   $0xc010e5be,0x8(%esp)
c010b68f:	c0 
c010b690:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b693:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b697:	8b 45 08             	mov    0x8(%ebp),%eax
c010b69a:	89 04 24             	mov    %eax,(%esp)
c010b69d:	e8 3e fe ff ff       	call   c010b4e0 <printfmt>
            }
            break;
c010b6a2:	e9 45 02 00 00       	jmp    c010b8ec <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b6a7:	8b 45 14             	mov    0x14(%ebp),%eax
c010b6aa:	8d 50 04             	lea    0x4(%eax),%edx
c010b6ad:	89 55 14             	mov    %edx,0x14(%ebp)
c010b6b0:	8b 30                	mov    (%eax),%esi
c010b6b2:	85 f6                	test   %esi,%esi
c010b6b4:	75 05                	jne    c010b6bb <vprintfmt+0x1ad>
                p = "(null)";
c010b6b6:	be c1 e5 10 c0       	mov    $0xc010e5c1,%esi
            }
            if (width > 0 && padc != '-') {
c010b6bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b6bf:	7e 3e                	jle    c010b6ff <vprintfmt+0x1f1>
c010b6c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b6c5:	74 38                	je     c010b6ff <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b6c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b6ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b6cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6d1:	89 34 24             	mov    %esi,(%esp)
c010b6d4:	e8 ed 03 00 00       	call   c010bac6 <strnlen>
c010b6d9:	29 c3                	sub    %eax,%ebx
c010b6db:	89 d8                	mov    %ebx,%eax
c010b6dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b6e0:	eb 17                	jmp    c010b6f9 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b6e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b6e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b6e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b6ed:	89 04 24             	mov    %eax,(%esp)
c010b6f0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6f3:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b6f5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b6f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b6fd:	7f e3                	jg     c010b6e2 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b6ff:	eb 38                	jmp    c010b739 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b701:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b705:	74 1f                	je     c010b726 <vprintfmt+0x218>
c010b707:	83 fb 1f             	cmp    $0x1f,%ebx
c010b70a:	7e 05                	jle    c010b711 <vprintfmt+0x203>
c010b70c:	83 fb 7e             	cmp    $0x7e,%ebx
c010b70f:	7e 15                	jle    c010b726 <vprintfmt+0x218>
                    putch('?', putdat);
c010b711:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b714:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b718:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b71f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b722:	ff d0                	call   *%eax
c010b724:	eb 0f                	jmp    c010b735 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b726:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b72d:	89 1c 24             	mov    %ebx,(%esp)
c010b730:	8b 45 08             	mov    0x8(%ebp),%eax
c010b733:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b735:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b739:	89 f0                	mov    %esi,%eax
c010b73b:	8d 70 01             	lea    0x1(%eax),%esi
c010b73e:	0f b6 00             	movzbl (%eax),%eax
c010b741:	0f be d8             	movsbl %al,%ebx
c010b744:	85 db                	test   %ebx,%ebx
c010b746:	74 10                	je     c010b758 <vprintfmt+0x24a>
c010b748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b74c:	78 b3                	js     c010b701 <vprintfmt+0x1f3>
c010b74e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b752:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b756:	79 a9                	jns    c010b701 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b758:	eb 17                	jmp    c010b771 <vprintfmt+0x263>
                putch(' ', putdat);
c010b75a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b75d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b761:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b768:	8b 45 08             	mov    0x8(%ebp),%eax
c010b76b:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b76d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b771:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b775:	7f e3                	jg     c010b75a <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b777:	e9 70 01 00 00       	jmp    c010b8ec <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b77c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b77f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b783:	8d 45 14             	lea    0x14(%ebp),%eax
c010b786:	89 04 24             	mov    %eax,(%esp)
c010b789:	e8 0b fd ff ff       	call   c010b499 <getint>
c010b78e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b791:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b794:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b797:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b79a:	85 d2                	test   %edx,%edx
c010b79c:	79 26                	jns    c010b7c4 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b79e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b7a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7a5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b7ac:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7af:	ff d0                	call   *%eax
                num = -(long long)num;
c010b7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b7b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b7b7:	f7 d8                	neg    %eax
c010b7b9:	83 d2 00             	adc    $0x0,%edx
c010b7bc:	f7 da                	neg    %edx
c010b7be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b7c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b7c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b7cb:	e9 a8 00 00 00       	jmp    c010b878 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b7d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b7d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7d7:	8d 45 14             	lea    0x14(%ebp),%eax
c010b7da:	89 04 24             	mov    %eax,(%esp)
c010b7dd:	e8 68 fc ff ff       	call   c010b44a <getuint>
c010b7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b7e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b7e8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b7ef:	e9 84 00 00 00       	jmp    c010b878 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b7f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b7f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7fb:	8d 45 14             	lea    0x14(%ebp),%eax
c010b7fe:	89 04 24             	mov    %eax,(%esp)
c010b801:	e8 44 fc ff ff       	call   c010b44a <getuint>
c010b806:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b809:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b80c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b813:	eb 63                	jmp    c010b878 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b815:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b818:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b81c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b823:	8b 45 08             	mov    0x8(%ebp),%eax
c010b826:	ff d0                	call   *%eax
            putch('x', putdat);
c010b828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b82b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b82f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b836:	8b 45 08             	mov    0x8(%ebp),%eax
c010b839:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b83b:	8b 45 14             	mov    0x14(%ebp),%eax
c010b83e:	8d 50 04             	lea    0x4(%eax),%edx
c010b841:	89 55 14             	mov    %edx,0x14(%ebp)
c010b844:	8b 00                	mov    (%eax),%eax
c010b846:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b850:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b857:	eb 1f                	jmp    c010b878 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b859:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b85c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b860:	8d 45 14             	lea    0x14(%ebp),%eax
c010b863:	89 04 24             	mov    %eax,(%esp)
c010b866:	e8 df fb ff ff       	call   c010b44a <getuint>
c010b86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b86e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b871:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b878:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b87c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b87f:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b883:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b886:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b88a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b891:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b894:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b898:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b89c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b89f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8a3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8a6:	89 04 24             	mov    %eax,(%esp)
c010b8a9:	e8 97 fa ff ff       	call   c010b345 <printnum>
            break;
c010b8ae:	eb 3c                	jmp    c010b8ec <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b8b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8b7:	89 1c 24             	mov    %ebx,(%esp)
c010b8ba:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8bd:	ff d0                	call   *%eax
            break;
c010b8bf:	eb 2b                	jmp    c010b8ec <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b8c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8c8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b8cf:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8d2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b8d4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b8d8:	eb 04                	jmp    c010b8de <vprintfmt+0x3d0>
c010b8da:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b8de:	8b 45 10             	mov    0x10(%ebp),%eax
c010b8e1:	83 e8 01             	sub    $0x1,%eax
c010b8e4:	0f b6 00             	movzbl (%eax),%eax
c010b8e7:	3c 25                	cmp    $0x25,%al
c010b8e9:	75 ef                	jne    c010b8da <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b8eb:	90                   	nop
        }
    }
c010b8ec:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b8ed:	e9 3e fc ff ff       	jmp    c010b530 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b8f2:	83 c4 40             	add    $0x40,%esp
c010b8f5:	5b                   	pop    %ebx
c010b8f6:	5e                   	pop    %esi
c010b8f7:	5d                   	pop    %ebp
c010b8f8:	c3                   	ret    

c010b8f9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b8f9:	55                   	push   %ebp
c010b8fa:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b8fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8ff:	8b 40 08             	mov    0x8(%eax),%eax
c010b902:	8d 50 01             	lea    0x1(%eax),%edx
c010b905:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b908:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b90b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b90e:	8b 10                	mov    (%eax),%edx
c010b910:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b913:	8b 40 04             	mov    0x4(%eax),%eax
c010b916:	39 c2                	cmp    %eax,%edx
c010b918:	73 12                	jae    c010b92c <sprintputch+0x33>
        *b->buf ++ = ch;
c010b91a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b91d:	8b 00                	mov    (%eax),%eax
c010b91f:	8d 48 01             	lea    0x1(%eax),%ecx
c010b922:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b925:	89 0a                	mov    %ecx,(%edx)
c010b927:	8b 55 08             	mov    0x8(%ebp),%edx
c010b92a:	88 10                	mov    %dl,(%eax)
    }
}
c010b92c:	5d                   	pop    %ebp
c010b92d:	c3                   	ret    

c010b92e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b92e:	55                   	push   %ebp
c010b92f:	89 e5                	mov    %esp,%ebp
c010b931:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b934:	8d 45 14             	lea    0x14(%ebp),%eax
c010b937:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b93d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b941:	8b 45 10             	mov    0x10(%ebp),%eax
c010b944:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b948:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b94b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b94f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b952:	89 04 24             	mov    %eax,(%esp)
c010b955:	e8 08 00 00 00       	call   c010b962 <vsnprintf>
c010b95a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b960:	c9                   	leave  
c010b961:	c3                   	ret    

c010b962 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b962:	55                   	push   %ebp
c010b963:	89 e5                	mov    %esp,%ebp
c010b965:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b968:	8b 45 08             	mov    0x8(%ebp),%eax
c010b96b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b96e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b971:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b974:	8b 45 08             	mov    0x8(%ebp),%eax
c010b977:	01 d0                	add    %edx,%eax
c010b979:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b97c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b983:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b987:	74 0a                	je     c010b993 <vsnprintf+0x31>
c010b989:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b98c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b98f:	39 c2                	cmp    %eax,%edx
c010b991:	76 07                	jbe    c010b99a <vsnprintf+0x38>
        return -E_INVAL;
c010b993:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b998:	eb 2a                	jmp    c010b9c4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b99a:	8b 45 14             	mov    0x14(%ebp),%eax
c010b99d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b9a1:	8b 45 10             	mov    0x10(%ebp),%eax
c010b9a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b9a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b9ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b9af:	c7 04 24 f9 b8 10 c0 	movl   $0xc010b8f9,(%esp)
c010b9b6:	e8 53 fb ff ff       	call   c010b50e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b9bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b9be:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b9c4:	c9                   	leave  
c010b9c5:	c3                   	ret    

c010b9c6 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b9c6:	55                   	push   %ebp
c010b9c7:	89 e5                	mov    %esp,%ebp
c010b9c9:	57                   	push   %edi
c010b9ca:	56                   	push   %esi
c010b9cb:	53                   	push   %ebx
c010b9cc:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b9cf:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b9d4:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b9da:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b9e0:	6b f0 05             	imul   $0x5,%eax,%esi
c010b9e3:	01 f7                	add    %esi,%edi
c010b9e5:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b9ea:	f7 e6                	mul    %esi
c010b9ec:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b9ef:	89 f2                	mov    %esi,%edx
c010b9f1:	83 c0 0b             	add    $0xb,%eax
c010b9f4:	83 d2 00             	adc    $0x0,%edx
c010b9f7:	89 c7                	mov    %eax,%edi
c010b9f9:	83 e7 ff             	and    $0xffffffff,%edi
c010b9fc:	89 f9                	mov    %edi,%ecx
c010b9fe:	0f b7 da             	movzwl %dx,%ebx
c010ba01:	89 0d 20 ab 12 c0    	mov    %ecx,0xc012ab20
c010ba07:	89 1d 24 ab 12 c0    	mov    %ebx,0xc012ab24
    unsigned long long result = (next >> 12);
c010ba0d:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010ba12:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010ba18:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010ba1c:	c1 ea 0c             	shr    $0xc,%edx
c010ba1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010ba22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010ba25:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010ba2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010ba2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010ba32:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010ba35:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010ba38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ba3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010ba3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010ba42:	74 1c                	je     c010ba60 <rand+0x9a>
c010ba44:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ba47:	ba 00 00 00 00       	mov    $0x0,%edx
c010ba4c:	f7 75 dc             	divl   -0x24(%ebp)
c010ba4f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010ba52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ba55:	ba 00 00 00 00       	mov    $0x0,%edx
c010ba5a:	f7 75 dc             	divl   -0x24(%ebp)
c010ba5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010ba60:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010ba63:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010ba66:	f7 75 dc             	divl   -0x24(%ebp)
c010ba69:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010ba6c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010ba6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010ba72:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010ba75:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010ba78:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010ba7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010ba7e:	83 c4 24             	add    $0x24,%esp
c010ba81:	5b                   	pop    %ebx
c010ba82:	5e                   	pop    %esi
c010ba83:	5f                   	pop    %edi
c010ba84:	5d                   	pop    %ebp
c010ba85:	c3                   	ret    

c010ba86 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010ba86:	55                   	push   %ebp
c010ba87:	89 e5                	mov    %esp,%ebp
    next = seed;
c010ba89:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba8c:	ba 00 00 00 00       	mov    $0x0,%edx
c010ba91:	a3 20 ab 12 c0       	mov    %eax,0xc012ab20
c010ba96:	89 15 24 ab 12 c0    	mov    %edx,0xc012ab24
}
c010ba9c:	5d                   	pop    %ebp
c010ba9d:	c3                   	ret    

c010ba9e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010ba9e:	55                   	push   %ebp
c010ba9f:	89 e5                	mov    %esp,%ebp
c010baa1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010baa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010baab:	eb 04                	jmp    c010bab1 <strlen+0x13>
        cnt ++;
c010baad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010bab1:	8b 45 08             	mov    0x8(%ebp),%eax
c010bab4:	8d 50 01             	lea    0x1(%eax),%edx
c010bab7:	89 55 08             	mov    %edx,0x8(%ebp)
c010baba:	0f b6 00             	movzbl (%eax),%eax
c010babd:	84 c0                	test   %al,%al
c010babf:	75 ec                	jne    c010baad <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010bac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010bac4:	c9                   	leave  
c010bac5:	c3                   	ret    

c010bac6 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010bac6:	55                   	push   %ebp
c010bac7:	89 e5                	mov    %esp,%ebp
c010bac9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010bacc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010bad3:	eb 04                	jmp    c010bad9 <strnlen+0x13>
        cnt ++;
c010bad5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010bad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010badc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010badf:	73 10                	jae    c010baf1 <strnlen+0x2b>
c010bae1:	8b 45 08             	mov    0x8(%ebp),%eax
c010bae4:	8d 50 01             	lea    0x1(%eax),%edx
c010bae7:	89 55 08             	mov    %edx,0x8(%ebp)
c010baea:	0f b6 00             	movzbl (%eax),%eax
c010baed:	84 c0                	test   %al,%al
c010baef:	75 e4                	jne    c010bad5 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010baf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010baf4:	c9                   	leave  
c010baf5:	c3                   	ret    

c010baf6 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010baf6:	55                   	push   %ebp
c010baf7:	89 e5                	mov    %esp,%ebp
c010baf9:	57                   	push   %edi
c010bafa:	56                   	push   %esi
c010bafb:	83 ec 20             	sub    $0x20,%esp
c010bafe:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb04:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb07:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010bb0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010bb0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bb10:	89 d1                	mov    %edx,%ecx
c010bb12:	89 c2                	mov    %eax,%edx
c010bb14:	89 ce                	mov    %ecx,%esi
c010bb16:	89 d7                	mov    %edx,%edi
c010bb18:	ac                   	lods   %ds:(%esi),%al
c010bb19:	aa                   	stos   %al,%es:(%edi)
c010bb1a:	84 c0                	test   %al,%al
c010bb1c:	75 fa                	jne    c010bb18 <strcpy+0x22>
c010bb1e:	89 fa                	mov    %edi,%edx
c010bb20:	89 f1                	mov    %esi,%ecx
c010bb22:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010bb25:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010bb28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010bb2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010bb2e:	83 c4 20             	add    $0x20,%esp
c010bb31:	5e                   	pop    %esi
c010bb32:	5f                   	pop    %edi
c010bb33:	5d                   	pop    %ebp
c010bb34:	c3                   	ret    

c010bb35 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010bb35:	55                   	push   %ebp
c010bb36:	89 e5                	mov    %esp,%ebp
c010bb38:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010bb3b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010bb41:	eb 21                	jmp    c010bb64 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010bb43:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb46:	0f b6 10             	movzbl (%eax),%edx
c010bb49:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bb4c:	88 10                	mov    %dl,(%eax)
c010bb4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bb51:	0f b6 00             	movzbl (%eax),%eax
c010bb54:	84 c0                	test   %al,%al
c010bb56:	74 04                	je     c010bb5c <strncpy+0x27>
            src ++;
c010bb58:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010bb5c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bb60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010bb64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bb68:	75 d9                	jne    c010bb43 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010bb6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bb6d:	c9                   	leave  
c010bb6e:	c3                   	ret    

c010bb6f <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010bb6f:	55                   	push   %ebp
c010bb70:	89 e5                	mov    %esp,%ebp
c010bb72:	57                   	push   %edi
c010bb73:	56                   	push   %esi
c010bb74:	83 ec 20             	sub    $0x20,%esp
c010bb77:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb80:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010bb83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bb86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bb89:	89 d1                	mov    %edx,%ecx
c010bb8b:	89 c2                	mov    %eax,%edx
c010bb8d:	89 ce                	mov    %ecx,%esi
c010bb8f:	89 d7                	mov    %edx,%edi
c010bb91:	ac                   	lods   %ds:(%esi),%al
c010bb92:	ae                   	scas   %es:(%edi),%al
c010bb93:	75 08                	jne    c010bb9d <strcmp+0x2e>
c010bb95:	84 c0                	test   %al,%al
c010bb97:	75 f8                	jne    c010bb91 <strcmp+0x22>
c010bb99:	31 c0                	xor    %eax,%eax
c010bb9b:	eb 04                	jmp    c010bba1 <strcmp+0x32>
c010bb9d:	19 c0                	sbb    %eax,%eax
c010bb9f:	0c 01                	or     $0x1,%al
c010bba1:	89 fa                	mov    %edi,%edx
c010bba3:	89 f1                	mov    %esi,%ecx
c010bba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bba8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010bbab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010bbae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010bbb1:	83 c4 20             	add    $0x20,%esp
c010bbb4:	5e                   	pop    %esi
c010bbb5:	5f                   	pop    %edi
c010bbb6:	5d                   	pop    %ebp
c010bbb7:	c3                   	ret    

c010bbb8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010bbb8:	55                   	push   %ebp
c010bbb9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bbbb:	eb 0c                	jmp    c010bbc9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010bbbd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010bbc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bbc5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bbc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bbcd:	74 1a                	je     c010bbe9 <strncmp+0x31>
c010bbcf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbd2:	0f b6 00             	movzbl (%eax),%eax
c010bbd5:	84 c0                	test   %al,%al
c010bbd7:	74 10                	je     c010bbe9 <strncmp+0x31>
c010bbd9:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbdc:	0f b6 10             	movzbl (%eax),%edx
c010bbdf:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbe2:	0f b6 00             	movzbl (%eax),%eax
c010bbe5:	38 c2                	cmp    %al,%dl
c010bbe7:	74 d4                	je     c010bbbd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bbe9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bbed:	74 18                	je     c010bc07 <strncmp+0x4f>
c010bbef:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbf2:	0f b6 00             	movzbl (%eax),%eax
c010bbf5:	0f b6 d0             	movzbl %al,%edx
c010bbf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbfb:	0f b6 00             	movzbl (%eax),%eax
c010bbfe:	0f b6 c0             	movzbl %al,%eax
c010bc01:	29 c2                	sub    %eax,%edx
c010bc03:	89 d0                	mov    %edx,%eax
c010bc05:	eb 05                	jmp    c010bc0c <strncmp+0x54>
c010bc07:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bc0c:	5d                   	pop    %ebp
c010bc0d:	c3                   	ret    

c010bc0e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010bc0e:	55                   	push   %ebp
c010bc0f:	89 e5                	mov    %esp,%ebp
c010bc11:	83 ec 04             	sub    $0x4,%esp
c010bc14:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc17:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bc1a:	eb 14                	jmp    c010bc30 <strchr+0x22>
        if (*s == c) {
c010bc1c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc1f:	0f b6 00             	movzbl (%eax),%eax
c010bc22:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bc25:	75 05                	jne    c010bc2c <strchr+0x1e>
            return (char *)s;
c010bc27:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc2a:	eb 13                	jmp    c010bc3f <strchr+0x31>
        }
        s ++;
c010bc2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010bc30:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc33:	0f b6 00             	movzbl (%eax),%eax
c010bc36:	84 c0                	test   %al,%al
c010bc38:	75 e2                	jne    c010bc1c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010bc3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bc3f:	c9                   	leave  
c010bc40:	c3                   	ret    

c010bc41 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010bc41:	55                   	push   %ebp
c010bc42:	89 e5                	mov    %esp,%ebp
c010bc44:	83 ec 04             	sub    $0x4,%esp
c010bc47:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc4a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bc4d:	eb 11                	jmp    c010bc60 <strfind+0x1f>
        if (*s == c) {
c010bc4f:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc52:	0f b6 00             	movzbl (%eax),%eax
c010bc55:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bc58:	75 02                	jne    c010bc5c <strfind+0x1b>
            break;
c010bc5a:	eb 0e                	jmp    c010bc6a <strfind+0x29>
        }
        s ++;
c010bc5c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010bc60:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc63:	0f b6 00             	movzbl (%eax),%eax
c010bc66:	84 c0                	test   %al,%al
c010bc68:	75 e5                	jne    c010bc4f <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010bc6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bc6d:	c9                   	leave  
c010bc6e:	c3                   	ret    

c010bc6f <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010bc6f:	55                   	push   %ebp
c010bc70:	89 e5                	mov    %esp,%ebp
c010bc72:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010bc75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010bc7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bc83:	eb 04                	jmp    c010bc89 <strtol+0x1a>
        s ++;
c010bc85:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bc89:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc8c:	0f b6 00             	movzbl (%eax),%eax
c010bc8f:	3c 20                	cmp    $0x20,%al
c010bc91:	74 f2                	je     c010bc85 <strtol+0x16>
c010bc93:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc96:	0f b6 00             	movzbl (%eax),%eax
c010bc99:	3c 09                	cmp    $0x9,%al
c010bc9b:	74 e8                	je     c010bc85 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010bc9d:	8b 45 08             	mov    0x8(%ebp),%eax
c010bca0:	0f b6 00             	movzbl (%eax),%eax
c010bca3:	3c 2b                	cmp    $0x2b,%al
c010bca5:	75 06                	jne    c010bcad <strtol+0x3e>
        s ++;
c010bca7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bcab:	eb 15                	jmp    c010bcc2 <strtol+0x53>
    }
    else if (*s == '-') {
c010bcad:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcb0:	0f b6 00             	movzbl (%eax),%eax
c010bcb3:	3c 2d                	cmp    $0x2d,%al
c010bcb5:	75 0b                	jne    c010bcc2 <strtol+0x53>
        s ++, neg = 1;
c010bcb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bcbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010bcc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bcc6:	74 06                	je     c010bcce <strtol+0x5f>
c010bcc8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010bccc:	75 24                	jne    c010bcf2 <strtol+0x83>
c010bcce:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcd1:	0f b6 00             	movzbl (%eax),%eax
c010bcd4:	3c 30                	cmp    $0x30,%al
c010bcd6:	75 1a                	jne    c010bcf2 <strtol+0x83>
c010bcd8:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcdb:	83 c0 01             	add    $0x1,%eax
c010bcde:	0f b6 00             	movzbl (%eax),%eax
c010bce1:	3c 78                	cmp    $0x78,%al
c010bce3:	75 0d                	jne    c010bcf2 <strtol+0x83>
        s += 2, base = 16;
c010bce5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010bce9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010bcf0:	eb 2a                	jmp    c010bd1c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010bcf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bcf6:	75 17                	jne    c010bd0f <strtol+0xa0>
c010bcf8:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcfb:	0f b6 00             	movzbl (%eax),%eax
c010bcfe:	3c 30                	cmp    $0x30,%al
c010bd00:	75 0d                	jne    c010bd0f <strtol+0xa0>
        s ++, base = 8;
c010bd02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bd06:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010bd0d:	eb 0d                	jmp    c010bd1c <strtol+0xad>
    }
    else if (base == 0) {
c010bd0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bd13:	75 07                	jne    c010bd1c <strtol+0xad>
        base = 10;
c010bd15:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010bd1c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd1f:	0f b6 00             	movzbl (%eax),%eax
c010bd22:	3c 2f                	cmp    $0x2f,%al
c010bd24:	7e 1b                	jle    c010bd41 <strtol+0xd2>
c010bd26:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd29:	0f b6 00             	movzbl (%eax),%eax
c010bd2c:	3c 39                	cmp    $0x39,%al
c010bd2e:	7f 11                	jg     c010bd41 <strtol+0xd2>
            dig = *s - '0';
c010bd30:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd33:	0f b6 00             	movzbl (%eax),%eax
c010bd36:	0f be c0             	movsbl %al,%eax
c010bd39:	83 e8 30             	sub    $0x30,%eax
c010bd3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bd3f:	eb 48                	jmp    c010bd89 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010bd41:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd44:	0f b6 00             	movzbl (%eax),%eax
c010bd47:	3c 60                	cmp    $0x60,%al
c010bd49:	7e 1b                	jle    c010bd66 <strtol+0xf7>
c010bd4b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd4e:	0f b6 00             	movzbl (%eax),%eax
c010bd51:	3c 7a                	cmp    $0x7a,%al
c010bd53:	7f 11                	jg     c010bd66 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010bd55:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd58:	0f b6 00             	movzbl (%eax),%eax
c010bd5b:	0f be c0             	movsbl %al,%eax
c010bd5e:	83 e8 57             	sub    $0x57,%eax
c010bd61:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bd64:	eb 23                	jmp    c010bd89 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010bd66:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd69:	0f b6 00             	movzbl (%eax),%eax
c010bd6c:	3c 40                	cmp    $0x40,%al
c010bd6e:	7e 3d                	jle    c010bdad <strtol+0x13e>
c010bd70:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd73:	0f b6 00             	movzbl (%eax),%eax
c010bd76:	3c 5a                	cmp    $0x5a,%al
c010bd78:	7f 33                	jg     c010bdad <strtol+0x13e>
            dig = *s - 'A' + 10;
c010bd7a:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd7d:	0f b6 00             	movzbl (%eax),%eax
c010bd80:	0f be c0             	movsbl %al,%eax
c010bd83:	83 e8 37             	sub    $0x37,%eax
c010bd86:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010bd89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bd8c:	3b 45 10             	cmp    0x10(%ebp),%eax
c010bd8f:	7c 02                	jl     c010bd93 <strtol+0x124>
            break;
c010bd91:	eb 1a                	jmp    c010bdad <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010bd93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bd97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bd9a:	0f af 45 10          	imul   0x10(%ebp),%eax
c010bd9e:	89 c2                	mov    %eax,%edx
c010bda0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bda3:	01 d0                	add    %edx,%eax
c010bda5:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010bda8:	e9 6f ff ff ff       	jmp    c010bd1c <strtol+0xad>

    if (endptr) {
c010bdad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010bdb1:	74 08                	je     c010bdbb <strtol+0x14c>
        *endptr = (char *) s;
c010bdb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bdb6:	8b 55 08             	mov    0x8(%ebp),%edx
c010bdb9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010bdbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010bdbf:	74 07                	je     c010bdc8 <strtol+0x159>
c010bdc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bdc4:	f7 d8                	neg    %eax
c010bdc6:	eb 03                	jmp    c010bdcb <strtol+0x15c>
c010bdc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010bdcb:	c9                   	leave  
c010bdcc:	c3                   	ret    

c010bdcd <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010bdcd:	55                   	push   %ebp
c010bdce:	89 e5                	mov    %esp,%ebp
c010bdd0:	57                   	push   %edi
c010bdd1:	83 ec 24             	sub    $0x24,%esp
c010bdd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bdd7:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010bdda:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010bdde:	8b 55 08             	mov    0x8(%ebp),%edx
c010bde1:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010bde4:	88 45 f7             	mov    %al,-0x9(%ebp)
c010bde7:	8b 45 10             	mov    0x10(%ebp),%eax
c010bdea:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bded:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010bdf0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010bdf4:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010bdf7:	89 d7                	mov    %edx,%edi
c010bdf9:	f3 aa                	rep stos %al,%es:(%edi)
c010bdfb:	89 fa                	mov    %edi,%edx
c010bdfd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010be00:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010be03:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010be06:	83 c4 24             	add    $0x24,%esp
c010be09:	5f                   	pop    %edi
c010be0a:	5d                   	pop    %ebp
c010be0b:	c3                   	ret    

c010be0c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010be0c:	55                   	push   %ebp
c010be0d:	89 e5                	mov    %esp,%ebp
c010be0f:	57                   	push   %edi
c010be10:	56                   	push   %esi
c010be11:	53                   	push   %ebx
c010be12:	83 ec 30             	sub    $0x30,%esp
c010be15:	8b 45 08             	mov    0x8(%ebp),%eax
c010be18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010be1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010be1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010be21:	8b 45 10             	mov    0x10(%ebp),%eax
c010be24:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010be27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010be2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010be2d:	73 42                	jae    c010be71 <memmove+0x65>
c010be2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010be32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010be35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010be38:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010be3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010be3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010be41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010be44:	c1 e8 02             	shr    $0x2,%eax
c010be47:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010be49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010be4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010be4f:	89 d7                	mov    %edx,%edi
c010be51:	89 c6                	mov    %eax,%esi
c010be53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010be55:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010be58:	83 e1 03             	and    $0x3,%ecx
c010be5b:	74 02                	je     c010be5f <memmove+0x53>
c010be5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010be5f:	89 f0                	mov    %esi,%eax
c010be61:	89 fa                	mov    %edi,%edx
c010be63:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010be66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010be69:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010be6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010be6f:	eb 36                	jmp    c010bea7 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010be71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010be74:	8d 50 ff             	lea    -0x1(%eax),%edx
c010be77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010be7a:	01 c2                	add    %eax,%edx
c010be7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010be7f:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010be82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010be85:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010be88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010be8b:	89 c1                	mov    %eax,%ecx
c010be8d:	89 d8                	mov    %ebx,%eax
c010be8f:	89 d6                	mov    %edx,%esi
c010be91:	89 c7                	mov    %eax,%edi
c010be93:	fd                   	std    
c010be94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010be96:	fc                   	cld    
c010be97:	89 f8                	mov    %edi,%eax
c010be99:	89 f2                	mov    %esi,%edx
c010be9b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010be9e:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010bea1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bea7:	83 c4 30             	add    $0x30,%esp
c010beaa:	5b                   	pop    %ebx
c010beab:	5e                   	pop    %esi
c010beac:	5f                   	pop    %edi
c010bead:	5d                   	pop    %ebp
c010beae:	c3                   	ret    

c010beaf <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010beaf:	55                   	push   %ebp
c010beb0:	89 e5                	mov    %esp,%ebp
c010beb2:	57                   	push   %edi
c010beb3:	56                   	push   %esi
c010beb4:	83 ec 20             	sub    $0x20,%esp
c010beb7:	8b 45 08             	mov    0x8(%ebp),%eax
c010beba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bebd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bec0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bec3:	8b 45 10             	mov    0x10(%ebp),%eax
c010bec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010becc:	c1 e8 02             	shr    $0x2,%eax
c010becf:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bed7:	89 d7                	mov    %edx,%edi
c010bed9:	89 c6                	mov    %eax,%esi
c010bedb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bedd:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010bee0:	83 e1 03             	and    $0x3,%ecx
c010bee3:	74 02                	je     c010bee7 <memcpy+0x38>
c010bee5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bee7:	89 f0                	mov    %esi,%eax
c010bee9:	89 fa                	mov    %edi,%edx
c010beeb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010beee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010bef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010bef7:	83 c4 20             	add    $0x20,%esp
c010befa:	5e                   	pop    %esi
c010befb:	5f                   	pop    %edi
c010befc:	5d                   	pop    %ebp
c010befd:	c3                   	ret    

c010befe <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010befe:	55                   	push   %ebp
c010beff:	89 e5                	mov    %esp,%ebp
c010bf01:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010bf04:	8b 45 08             	mov    0x8(%ebp),%eax
c010bf07:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010bf0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bf0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010bf10:	eb 30                	jmp    c010bf42 <memcmp+0x44>
        if (*s1 != *s2) {
c010bf12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bf15:	0f b6 10             	movzbl (%eax),%edx
c010bf18:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bf1b:	0f b6 00             	movzbl (%eax),%eax
c010bf1e:	38 c2                	cmp    %al,%dl
c010bf20:	74 18                	je     c010bf3a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bf22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bf25:	0f b6 00             	movzbl (%eax),%eax
c010bf28:	0f b6 d0             	movzbl %al,%edx
c010bf2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bf2e:	0f b6 00             	movzbl (%eax),%eax
c010bf31:	0f b6 c0             	movzbl %al,%eax
c010bf34:	29 c2                	sub    %eax,%edx
c010bf36:	89 d0                	mov    %edx,%eax
c010bf38:	eb 1a                	jmp    c010bf54 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010bf3a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bf3e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010bf42:	8b 45 10             	mov    0x10(%ebp),%eax
c010bf45:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bf48:	89 55 10             	mov    %edx,0x10(%ebp)
c010bf4b:	85 c0                	test   %eax,%eax
c010bf4d:	75 c3                	jne    c010bf12 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010bf4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bf54:	c9                   	leave  
c010bf55:	c3                   	ret    
