
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 75 34 00 00       	call   1034a1 <memset>

    cons_init();                // init the console
  10002c:	e8 2e 15 00 00       	call   10155f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 40 36 10 00 	movl   $0x103640,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 8d 2a 00 00       	call   102ae7 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 43 16 00 00       	call   1016a2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 bb 17 00 00       	call   10181f <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 e9 0c 00 00       	call   100d52 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a2 15 00 00       	call   101610 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 f2 0b 00 00       	call   100c84 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 6f 36 10 00 	movl   $0x10366f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 7d 36 10 00 	movl   $0x10367d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 8b 36 10 00 	movl   $0x10368b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 99 36 10 00 	movl   $0x103699,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 a8 36 10 00 	movl   $0x1036a8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 bb 12 00 00       	call   10158b <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 ad 29 00 00       	call   102cba <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 42 12 00 00       	call   10158b <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 0f 12 00 00       	call   1015b4 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 ec 36 10 00    	movl   $0x1036ec,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 ec 36 10 00 	movl   $0x1036ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 6c 3f 10 00 	movl   $0x103f6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 c4 b6 10 00 	movl   $0x10b6c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec c5 b6 10 00 	movl   $0x10b6c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 b0 d6 10 00 	movl   $0x10d6b0,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 53 2c 00 00       	call   103315 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 f6 36 10 00 	movl   $0x1036f6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 0f 37 10 00 	movl   $0x10370f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 2a 36 10 	movl   $0x10362a,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 3f 37 10 00 	movl   $0x10373f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 57 37 10 00 	movl   $0x103757,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 70 37 10 00 	movl   $0x103770,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 88 00 00 00       	jmp    100a3d <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 c8 37 10 00 	movl   $0x1037c8,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>
		uint32_t* args = (uint32_t)ebp + 2;
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	83 c0 02             	add    $0x2,%eax
  1009d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j<4;j++)
  1009d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009df:	eb 25                	jmp    100a06 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
  1009e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	8b 00                	mov    (%eax),%eax
  1009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f6:	c7 04 24 e4 37 10 00 	movl   $0x1037e4,(%esp)
  1009fd:	e8 10 f9 ff ff       	call   100312 <cprintf>
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* args = (uint32_t)ebp + 2;
		for(j = 0;j<4;j++)
  100a02:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a06:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0a:	7e d5                	jle    1009e1 <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
  100a0c:	c7 04 24 ec 37 10 00 	movl   $0x1037ec,(%esp)
  100a13:	e8 fa f8 ff ff       	call   100312 <cprintf>
		print_debuginfo(eip - 1);
  100a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1b:	83 e8 01             	sub    $0x1,%eax
  100a1e:	89 04 24             	mov    %eax,(%esp)
  100a21:	e8 b6 fe ff ff       	call   1008dc <print_debuginfo>
		eip = *((uint32_t*)(ebp + 4));
  100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a29:	83 c0 04             	add    $0x4,%eax
  100a2c:	8b 00                	mov    (%eax),%eax
  100a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j;
	for(i = 0;i<STACKFRAME_DEPTH;i++)
  100a39:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a41:	0f 8e 6e ff ff ff    	jle    1009b5 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)(ebp + 4));
		ebp = *((uint32_t*)ebp);
	}
}
  100a47:	c9                   	leave  
  100a48:	c3                   	ret    

00100a49 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a49:	55                   	push   %ebp
  100a4a:	89 e5                	mov    %esp,%ebp
  100a4c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a56:	eb 0c                	jmp    100a64 <parse+0x1b>
            *buf ++ = '\0';
  100a58:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5b:	8d 50 01             	lea    0x1(%eax),%edx
  100a5e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a61:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a64:	8b 45 08             	mov    0x8(%ebp),%eax
  100a67:	0f b6 00             	movzbl (%eax),%eax
  100a6a:	84 c0                	test   %al,%al
  100a6c:	74 1d                	je     100a8b <parse+0x42>
  100a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a71:	0f b6 00             	movzbl (%eax),%eax
  100a74:	0f be c0             	movsbl %al,%eax
  100a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a7b:	c7 04 24 70 38 10 00 	movl   $0x103870,(%esp)
  100a82:	e8 5b 28 00 00       	call   1032e2 <strchr>
  100a87:	85 c0                	test   %eax,%eax
  100a89:	75 cd                	jne    100a58 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	0f b6 00             	movzbl (%eax),%eax
  100a91:	84 c0                	test   %al,%al
  100a93:	75 02                	jne    100a97 <parse+0x4e>
            break;
  100a95:	eb 67                	jmp    100afe <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a97:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a9b:	75 14                	jne    100ab1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a9d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aa4:	00 
  100aa5:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  100aac:	e8 61 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab4:	8d 50 01             	lea    0x1(%eax),%edx
  100ab7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ac4:	01 c2                	add    %eax,%edx
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100acb:	eb 04                	jmp    100ad1 <parse+0x88>
            buf ++;
  100acd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad4:	0f b6 00             	movzbl (%eax),%eax
  100ad7:	84 c0                	test   %al,%al
  100ad9:	74 1d                	je     100af8 <parse+0xaf>
  100adb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ade:	0f b6 00             	movzbl (%eax),%eax
  100ae1:	0f be c0             	movsbl %al,%eax
  100ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae8:	c7 04 24 70 38 10 00 	movl   $0x103870,(%esp)
  100aef:	e8 ee 27 00 00       	call   1032e2 <strchr>
  100af4:	85 c0                	test   %eax,%eax
  100af6:	74 d5                	je     100acd <parse+0x84>
            buf ++;
        }
    }
  100af8:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af9:	e9 66 ff ff ff       	jmp    100a64 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b01:	c9                   	leave  
  100b02:	c3                   	ret    

00100b03 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b03:	55                   	push   %ebp
  100b04:	89 e5                	mov    %esp,%ebp
  100b06:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b09:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	89 04 24             	mov    %eax,(%esp)
  100b16:	e8 2e ff ff ff       	call   100a49 <parse>
  100b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b22:	75 0a                	jne    100b2e <runcmd+0x2b>
        return 0;
  100b24:	b8 00 00 00 00       	mov    $0x0,%eax
  100b29:	e9 85 00 00 00       	jmp    100bb3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b35:	eb 5c                	jmp    100b93 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b37:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b3d:	89 d0                	mov    %edx,%eax
  100b3f:	01 c0                	add    %eax,%eax
  100b41:	01 d0                	add    %edx,%eax
  100b43:	c1 e0 02             	shl    $0x2,%eax
  100b46:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b4b:	8b 00                	mov    (%eax),%eax
  100b4d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b51:	89 04 24             	mov    %eax,(%esp)
  100b54:	e8 ea 26 00 00       	call   103243 <strcmp>
  100b59:	85 c0                	test   %eax,%eax
  100b5b:	75 32                	jne    100b8f <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b60:	89 d0                	mov    %edx,%eax
  100b62:	01 c0                	add    %eax,%eax
  100b64:	01 d0                	add    %edx,%eax
  100b66:	c1 e0 02             	shl    $0x2,%eax
  100b69:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b6e:	8b 40 08             	mov    0x8(%eax),%eax
  100b71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b74:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b7e:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b81:	83 c2 04             	add    $0x4,%edx
  100b84:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b88:	89 0c 24             	mov    %ecx,(%esp)
  100b8b:	ff d0                	call   *%eax
  100b8d:	eb 24                	jmp    100bb3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b96:	83 f8 02             	cmp    $0x2,%eax
  100b99:	76 9c                	jbe    100b37 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba2:	c7 04 24 93 38 10 00 	movl   $0x103893,(%esp)
  100ba9:	e8 64 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb3:	c9                   	leave  
  100bb4:	c3                   	ret    

00100bb5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bb5:	55                   	push   %ebp
  100bb6:	89 e5                	mov    %esp,%ebp
  100bb8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bbb:	c7 04 24 ac 38 10 00 	movl   $0x1038ac,(%esp)
  100bc2:	e8 4b f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bc7:	c7 04 24 d4 38 10 00 	movl   $0x1038d4,(%esp)
  100bce:	e8 3f f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bd7:	74 0b                	je     100be4 <kmonitor+0x2f>
        print_trapframe(tf);
  100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdc:	89 04 24             	mov    %eax,(%esp)
  100bdf:	e8 8c 0f 00 00       	call   101b70 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100be4:	c7 04 24 f9 38 10 00 	movl   $0x1038f9,(%esp)
  100beb:	e8 19 f6 ff ff       	call   100209 <readline>
  100bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bf7:	74 18                	je     100c11 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c03:	89 04 24             	mov    %eax,(%esp)
  100c06:	e8 f8 fe ff ff       	call   100b03 <runcmd>
  100c0b:	85 c0                	test   %eax,%eax
  100c0d:	79 02                	jns    100c11 <kmonitor+0x5c>
                break;
  100c0f:	eb 02                	jmp    100c13 <kmonitor+0x5e>
            }
        }
    }
  100c11:	eb d1                	jmp    100be4 <kmonitor+0x2f>
}
  100c13:	c9                   	leave  
  100c14:	c3                   	ret    

00100c15 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c15:	55                   	push   %ebp
  100c16:	89 e5                	mov    %esp,%ebp
  100c18:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c22:	eb 3f                	jmp    100c63 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c27:	89 d0                	mov    %edx,%eax
  100c29:	01 c0                	add    %eax,%eax
  100c2b:	01 d0                	add    %edx,%eax
  100c2d:	c1 e0 02             	shl    $0x2,%eax
  100c30:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c35:	8b 48 04             	mov    0x4(%eax),%ecx
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c49:	8b 00                	mov    (%eax),%eax
  100c4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c53:	c7 04 24 fd 38 10 00 	movl   $0x1038fd,(%esp)
  100c5a:	e8 b3 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c66:	83 f8 02             	cmp    $0x2,%eax
  100c69:	76 b9                	jbe    100c24 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c70:	c9                   	leave  
  100c71:	c3                   	ret    

00100c72 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c72:	55                   	push   %ebp
  100c73:	89 e5                	mov    %esp,%ebp
  100c75:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c78:	e8 c9 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c82:	c9                   	leave  
  100c83:	c3                   	ret    

00100c84 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c84:	55                   	push   %ebp
  100c85:	89 e5                	mov    %esp,%ebp
  100c87:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c8a:	e8 01 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c94:	c9                   	leave  
  100c95:	c3                   	ret    

00100c96 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c96:	55                   	push   %ebp
  100c97:	89 e5                	mov    %esp,%ebp
  100c99:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c9c:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca1:	85 c0                	test   %eax,%eax
  100ca3:	74 02                	je     100ca7 <__panic+0x11>
        goto panic_dead;
  100ca5:	eb 48                	jmp    100cef <__panic+0x59>
    }
    is_panic = 1;
  100ca7:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cae:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb1:	8d 45 14             	lea    0x14(%ebp),%eax
  100cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc5:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  100ccc:	e8 41 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  100cdb:	89 04 24             	mov    %eax,(%esp)
  100cde:	e8 fc f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce3:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  100cea:	e8 23 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cef:	e8 22 09 00 00       	call   101616 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cfb:	e8 b5 fe ff ff       	call   100bb5 <kmonitor>
    }
  100d00:	eb f2                	jmp    100cf4 <__panic+0x5e>

00100d02 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d02:	55                   	push   %ebp
  100d03:	89 e5                	mov    %esp,%ebp
  100d05:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d08:	8d 45 14             	lea    0x14(%ebp),%eax
  100d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d11:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d15:	8b 45 08             	mov    0x8(%ebp),%eax
  100d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1c:	c7 04 24 24 39 10 00 	movl   $0x103924,(%esp)
  100d23:	e8 ea f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d32:	89 04 24             	mov    %eax,(%esp)
  100d35:	e8 a5 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d3a:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  100d41:	e8 cc f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d46:	c9                   	leave  
  100d47:	c3                   	ret    

00100d48 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d48:	55                   	push   %ebp
  100d49:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d4b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d50:	5d                   	pop    %ebp
  100d51:	c3                   	ret    

00100d52 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d52:	55                   	push   %ebp
  100d53:	89 e5                	mov    %esp,%ebp
  100d55:	83 ec 28             	sub    $0x28,%esp
  100d58:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d62:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d66:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d6a:	ee                   	out    %al,(%dx)
  100d6b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d71:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d75:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d79:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7d:	ee                   	out    %al,(%dx)
  100d7e:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d84:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d88:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d8c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d90:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d91:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d98:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9b:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100da2:	e8 6b f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100da7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dae:	e8 c1 08 00 00       	call   101674 <pic_enable>
}
  100db3:	c9                   	leave  
  100db4:	c3                   	ret    

00100db5 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db5:	55                   	push   %ebp
  100db6:	89 e5                	mov    %esp,%ebp
  100db8:	83 ec 10             	sub    $0x10,%esp
  100dbb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dc5:	89 c2                	mov    %eax,%edx
  100dc7:	ec                   	in     (%dx),%al
  100dc8:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dcb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd5:	89 c2                	mov    %eax,%edx
  100dd7:	ec                   	in     (%dx),%al
  100dd8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ddb:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100de5:	89 c2                	mov    %eax,%edx
  100de7:	ec                   	in     (%dx),%al
  100de8:	88 45 f5             	mov    %al,-0xb(%ebp)
  100deb:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100df1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100df5:	89 c2                	mov    %eax,%edx
  100df7:	ec                   	in     (%dx),%al
  100df8:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dfb:	c9                   	leave  
  100dfc:	c3                   	ret    

00100dfd <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e03:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0d:	0f b7 00             	movzwl (%eax),%eax
  100e10:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e17:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1f:	0f b7 00             	movzwl (%eax),%eax
  100e22:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e26:	74 12                	je     100e3a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e28:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e2f:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e36:	b4 03 
  100e38:	eb 13                	jmp    100e4d <cga_init+0x50>
    } else {
        *cp = was;
  100e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e41:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e44:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e4b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e4d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e54:	0f b7 c0             	movzwl %ax,%eax
  100e57:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e5b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e5f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e67:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e68:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6f:	83 c0 01             	add    $0x1,%eax
  100e72:	0f b7 c0             	movzwl %ax,%eax
  100e75:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e79:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e7d:	89 c2                	mov    %eax,%edx
  100e7f:	ec                   	in     (%dx),%al
  100e80:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e83:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e87:	0f b6 c0             	movzbl %al,%eax
  100e8a:	c1 e0 08             	shl    $0x8,%eax
  100e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e90:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e97:	0f b7 c0             	movzwl %ax,%eax
  100e9a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e9e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ea6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eaa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb2:	83 c0 01             	add    $0x1,%eax
  100eb5:	0f b7 c0             	movzwl %ax,%eax
  100eb8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ebc:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ec0:	89 c2                	mov    %eax,%edx
  100ec2:	ec                   	in     (%dx),%al
  100ec3:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ec6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eca:	0f b6 c0             	movzbl %al,%eax
  100ecd:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100edb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee1:	c9                   	leave  
  100ee2:	c3                   	ret    

00100ee3 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee3:	55                   	push   %ebp
  100ee4:	89 e5                	mov    %esp,%ebp
  100ee6:	83 ec 48             	sub    $0x48,%esp
  100ee9:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eef:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ef7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100efb:	ee                   	out    %al,(%dx)
  100efc:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f02:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f06:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f0e:	ee                   	out    %al,(%dx)
  100f0f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f15:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f19:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f21:	ee                   	out    %al,(%dx)
  100f22:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f28:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f2c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f30:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
  100f35:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f3b:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f3f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f43:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f47:	ee                   	out    %al,(%dx)
  100f48:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f4e:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f52:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f56:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f5a:	ee                   	out    %al,(%dx)
  100f5b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f61:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f65:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f69:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f74:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f78:	89 c2                	mov    %eax,%edx
  100f7a:	ec                   	in     (%dx),%al
  100f7b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f7e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f82:	3c ff                	cmp    $0xff,%al
  100f84:	0f 95 c0             	setne  %al
  100f87:	0f b6 c0             	movzbl %al,%eax
  100f8a:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f8f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f95:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f9f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fa5:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100faf:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb4:	85 c0                	test   %eax,%eax
  100fb6:	74 0c                	je     100fc4 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fb8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fbf:	e8 b0 06 00 00       	call   101674 <pic_enable>
    }
}
  100fc4:	c9                   	leave  
  100fc5:	c3                   	ret    

00100fc6 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc6:	55                   	push   %ebp
  100fc7:	89 e5                	mov    %esp,%ebp
  100fc9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd3:	eb 09                	jmp    100fde <lpt_putc_sub+0x18>
        delay();
  100fd5:	e8 db fd ff ff       	call   100db5 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fde:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fe8:	89 c2                	mov    %eax,%edx
  100fea:	ec                   	in     (%dx),%al
  100feb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff2:	84 c0                	test   %al,%al
  100ff4:	78 09                	js     100fff <lpt_putc_sub+0x39>
  100ff6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ffd:	7e d6                	jle    100fd5 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fff:	8b 45 08             	mov    0x8(%ebp),%eax
  101002:	0f b6 c0             	movzbl %al,%eax
  101005:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10100b:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10100e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101012:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
  101017:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10101d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101021:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101025:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101029:	ee                   	out    %al,(%dx)
  10102a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101030:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101034:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101038:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10103c:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10103d:	c9                   	leave  
  10103e:	c3                   	ret    

0010103f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103f:	55                   	push   %ebp
  101040:	89 e5                	mov    %esp,%ebp
  101042:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101045:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101049:	74 0d                	je     101058 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10104b:	8b 45 08             	mov    0x8(%ebp),%eax
  10104e:	89 04 24             	mov    %eax,(%esp)
  101051:	e8 70 ff ff ff       	call   100fc6 <lpt_putc_sub>
  101056:	eb 24                	jmp    10107c <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101058:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10105f:	e8 62 ff ff ff       	call   100fc6 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101064:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10106b:	e8 56 ff ff ff       	call   100fc6 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101070:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101077:	e8 4a ff ff ff       	call   100fc6 <lpt_putc_sub>
    }
}
  10107c:	c9                   	leave  
  10107d:	c3                   	ret    

0010107e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107e:	55                   	push   %ebp
  10107f:	89 e5                	mov    %esp,%ebp
  101081:	53                   	push   %ebx
  101082:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101085:	8b 45 08             	mov    0x8(%ebp),%eax
  101088:	b0 00                	mov    $0x0,%al
  10108a:	85 c0                	test   %eax,%eax
  10108c:	75 07                	jne    101095 <cga_putc+0x17>
        c |= 0x0700;
  10108e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	0f b6 c0             	movzbl %al,%eax
  10109b:	83 f8 0a             	cmp    $0xa,%eax
  10109e:	74 4c                	je     1010ec <cga_putc+0x6e>
  1010a0:	83 f8 0d             	cmp    $0xd,%eax
  1010a3:	74 57                	je     1010fc <cga_putc+0x7e>
  1010a5:	83 f8 08             	cmp    $0x8,%eax
  1010a8:	0f 85 88 00 00 00    	jne    101136 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010ae:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b5:	66 85 c0             	test   %ax,%ax
  1010b8:	74 30                	je     1010ea <cga_putc+0x6c>
            crt_pos --;
  1010ba:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c1:	83 e8 01             	sub    $0x1,%eax
  1010c4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ca:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010cf:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d6:	0f b7 d2             	movzwl %dx,%edx
  1010d9:	01 d2                	add    %edx,%edx
  1010db:	01 c2                	add    %eax,%edx
  1010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e0:	b0 00                	mov    $0x0,%al
  1010e2:	83 c8 20             	or     $0x20,%eax
  1010e5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e8:	eb 72                	jmp    10115c <cga_putc+0xde>
  1010ea:	eb 70                	jmp    10115c <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010ec:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f3:	83 c0 50             	add    $0x50,%eax
  1010f6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010fc:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101103:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10110a:	0f b7 c1             	movzwl %cx,%eax
  10110d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101113:	c1 e8 10             	shr    $0x10,%eax
  101116:	89 c2                	mov    %eax,%edx
  101118:	66 c1 ea 06          	shr    $0x6,%dx
  10111c:	89 d0                	mov    %edx,%eax
  10111e:	c1 e0 02             	shl    $0x2,%eax
  101121:	01 d0                	add    %edx,%eax
  101123:	c1 e0 04             	shl    $0x4,%eax
  101126:	29 c1                	sub    %eax,%ecx
  101128:	89 ca                	mov    %ecx,%edx
  10112a:	89 d8                	mov    %ebx,%eax
  10112c:	29 d0                	sub    %edx,%eax
  10112e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101134:	eb 26                	jmp    10115c <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101136:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10113c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101143:	8d 50 01             	lea    0x1(%eax),%edx
  101146:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10114d:	0f b7 c0             	movzwl %ax,%eax
  101150:	01 c0                	add    %eax,%eax
  101152:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101155:	8b 45 08             	mov    0x8(%ebp),%eax
  101158:	66 89 02             	mov    %ax,(%edx)
        break;
  10115b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10115c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101163:	66 3d cf 07          	cmp    $0x7cf,%ax
  101167:	76 5b                	jbe    1011c4 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101169:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101174:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101179:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101180:	00 
  101181:	89 54 24 04          	mov    %edx,0x4(%esp)
  101185:	89 04 24             	mov    %eax,(%esp)
  101188:	e8 53 23 00 00       	call   1034e0 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101194:	eb 15                	jmp    1011ab <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101196:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10119e:	01 d2                	add    %edx,%edx
  1011a0:	01 d0                	add    %edx,%eax
  1011a2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011ab:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b2:	7e e2                	jle    101196 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011bb:	83 e8 50             	sub    $0x50,%eax
  1011be:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011cb:	0f b7 c0             	movzwl %ax,%eax
  1011ce:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011d6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011da:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011de:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011df:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e6:	66 c1 e8 08          	shr    $0x8,%ax
  1011ea:	0f b6 c0             	movzbl %al,%eax
  1011ed:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f4:	83 c2 01             	add    $0x1,%edx
  1011f7:	0f b7 d2             	movzwl %dx,%edx
  1011fa:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011fe:	88 45 ed             	mov    %al,-0x13(%ebp)
  101201:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101205:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101209:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101211:	0f b7 c0             	movzwl %ax,%eax
  101214:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101218:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10121c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101220:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101224:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101225:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10122c:	0f b6 c0             	movzbl %al,%eax
  10122f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101236:	83 c2 01             	add    $0x1,%edx
  101239:	0f b7 d2             	movzwl %dx,%edx
  10123c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101240:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101243:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101247:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
}
  10124c:	83 c4 34             	add    $0x34,%esp
  10124f:	5b                   	pop    %ebx
  101250:	5d                   	pop    %ebp
  101251:	c3                   	ret    

00101252 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101252:	55                   	push   %ebp
  101253:	89 e5                	mov    %esp,%ebp
  101255:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10125f:	eb 09                	jmp    10126a <serial_putc_sub+0x18>
        delay();
  101261:	e8 4f fb ff ff       	call   100db5 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101270:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101274:	89 c2                	mov    %eax,%edx
  101276:	ec                   	in     (%dx),%al
  101277:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10127e:	0f b6 c0             	movzbl %al,%eax
  101281:	83 e0 20             	and    $0x20,%eax
  101284:	85 c0                	test   %eax,%eax
  101286:	75 09                	jne    101291 <serial_putc_sub+0x3f>
  101288:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10128f:	7e d0                	jle    101261 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101291:	8b 45 08             	mov    0x8(%ebp),%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10129d:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012a8:	ee                   	out    %al,(%dx)
}
  1012a9:	c9                   	leave  
  1012aa:	c3                   	ret    

001012ab <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012ab:	55                   	push   %ebp
  1012ac:	89 e5                	mov    %esp,%ebp
  1012ae:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b5:	74 0d                	je     1012c4 <serial_putc+0x19>
        serial_putc_sub(c);
  1012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ba:	89 04 24             	mov    %eax,(%esp)
  1012bd:	e8 90 ff ff ff       	call   101252 <serial_putc_sub>
  1012c2:	eb 24                	jmp    1012e8 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012cb:	e8 82 ff ff ff       	call   101252 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012d7:	e8 76 ff ff ff       	call   101252 <serial_putc_sub>
        serial_putc_sub('\b');
  1012dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e3:	e8 6a ff ff ff       	call   101252 <serial_putc_sub>
    }
}
  1012e8:	c9                   	leave  
  1012e9:	c3                   	ret    

001012ea <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
  1012ed:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f0:	eb 33                	jmp    101325 <cons_intr+0x3b>
        if (c != 0) {
  1012f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f6:	74 2d                	je     101325 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fd:	8d 50 01             	lea    0x1(%eax),%edx
  101300:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101309:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101314:	3d 00 02 00 00       	cmp    $0x200,%eax
  101319:	75 0a                	jne    101325 <cons_intr+0x3b>
                cons.wpos = 0;
  10131b:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101322:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101325:	8b 45 08             	mov    0x8(%ebp),%eax
  101328:	ff d0                	call   *%eax
  10132a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10132d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101331:	75 bf                	jne    1012f2 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101333:	c9                   	leave  
  101334:	c3                   	ret    

00101335 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101335:	55                   	push   %ebp
  101336:	89 e5                	mov    %esp,%ebp
  101338:	83 ec 10             	sub    $0x10,%esp
  10133b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101341:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101345:	89 c2                	mov    %eax,%edx
  101347:	ec                   	in     (%dx),%al
  101348:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10134b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134f:	0f b6 c0             	movzbl %al,%eax
  101352:	83 e0 01             	and    $0x1,%eax
  101355:	85 c0                	test   %eax,%eax
  101357:	75 07                	jne    101360 <serial_proc_data+0x2b>
        return -1;
  101359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135e:	eb 2a                	jmp    10138a <serial_proc_data+0x55>
  101360:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101366:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10136a:	89 c2                	mov    %eax,%edx
  10136c:	ec                   	in     (%dx),%al
  10136d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101370:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101374:	0f b6 c0             	movzbl %al,%eax
  101377:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10137a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137e:	75 07                	jne    101387 <serial_proc_data+0x52>
        c = '\b';
  101380:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10138a:	c9                   	leave  
  10138b:	c3                   	ret    

0010138c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10138c:	55                   	push   %ebp
  10138d:	89 e5                	mov    %esp,%ebp
  10138f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101392:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101397:	85 c0                	test   %eax,%eax
  101399:	74 0c                	je     1013a7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10139b:	c7 04 24 35 13 10 00 	movl   $0x101335,(%esp)
  1013a2:	e8 43 ff ff ff       	call   1012ea <cons_intr>
    }
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 38             	sub    $0x38,%esp
  1013af:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013b9:	89 c2                	mov    %eax,%edx
  1013bb:	ec                   	in     (%dx),%al
  1013bc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c3:	0f b6 c0             	movzbl %al,%eax
  1013c6:	83 e0 01             	and    $0x1,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	75 0a                	jne    1013d7 <kbd_proc_data+0x2e>
        return -1;
  1013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d2:	e9 59 01 00 00       	jmp    101530 <kbd_proc_data+0x187>
  1013d7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e1:	89 c2                	mov    %eax,%edx
  1013e3:	ec                   	in     (%dx),%al
  1013e4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013e7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013eb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013ee:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f2:	75 17                	jne    10140b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f9:	83 c8 40             	or     $0x40,%eax
  1013fc:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101401:	b8 00 00 00 00       	mov    $0x0,%eax
  101406:	e9 25 01 00 00       	jmp    101530 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10140b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140f:	84 c0                	test   %al,%al
  101411:	79 47                	jns    10145a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101413:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101418:	83 e0 40             	and    $0x40,%eax
  10141b:	85 c0                	test   %eax,%eax
  10141d:	75 09                	jne    101428 <kbd_proc_data+0x7f>
  10141f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101423:	83 e0 7f             	and    $0x7f,%eax
  101426:	eb 04                	jmp    10142c <kbd_proc_data+0x83>
  101428:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10142f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101433:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143a:	83 c8 40             	or     $0x40,%eax
  10143d:	0f b6 c0             	movzbl %al,%eax
  101440:	f7 d0                	not    %eax
  101442:	89 c2                	mov    %eax,%edx
  101444:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101449:	21 d0                	and    %edx,%eax
  10144b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101450:	b8 00 00 00 00       	mov    $0x0,%eax
  101455:	e9 d6 00 00 00       	jmp    101530 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10145a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145f:	83 e0 40             	and    $0x40,%eax
  101462:	85 c0                	test   %eax,%eax
  101464:	74 11                	je     101477 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101466:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146f:	83 e0 bf             	and    $0xffffffbf,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101482:	0f b6 d0             	movzbl %al,%edx
  101485:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148a:	09 d0                	or     %edx,%eax
  10148c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101495:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10149c:	0f b6 d0             	movzbl %al,%edx
  10149f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a4:	31 d0                	xor    %edx,%eax
  1014a6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ab:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b0:	83 e0 03             	and    $0x3,%eax
  1014b3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ba:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014be:	01 d0                	add    %edx,%eax
  1014c0:	0f b6 00             	movzbl (%eax),%eax
  1014c3:	0f b6 c0             	movzbl %al,%eax
  1014c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014c9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ce:	83 e0 08             	and    $0x8,%eax
  1014d1:	85 c0                	test   %eax,%eax
  1014d3:	74 22                	je     1014f7 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014d9:	7e 0c                	jle    1014e7 <kbd_proc_data+0x13e>
  1014db:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014df:	7f 06                	jg     1014e7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e5:	eb 10                	jmp    1014f7 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014e7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014eb:	7e 0a                	jle    1014f7 <kbd_proc_data+0x14e>
  1014ed:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f1:	7f 04                	jg     1014f7 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014f7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014fc:	f7 d0                	not    %eax
  1014fe:	83 e0 06             	and    $0x6,%eax
  101501:	85 c0                	test   %eax,%eax
  101503:	75 28                	jne    10152d <kbd_proc_data+0x184>
  101505:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10150c:	75 1f                	jne    10152d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10150e:	c7 04 24 5d 39 10 00 	movl   $0x10395d,(%esp)
  101515:	e8 f8 ed ff ff       	call   100312 <cprintf>
  10151a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101520:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101524:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101528:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10152c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101530:	c9                   	leave  
  101531:	c3                   	ret    

00101532 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101532:	55                   	push   %ebp
  101533:	89 e5                	mov    %esp,%ebp
  101535:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101538:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  10153f:	e8 a6 fd ff ff       	call   1012ea <cons_intr>
}
  101544:	c9                   	leave  
  101545:	c3                   	ret    

00101546 <kbd_init>:

static void
kbd_init(void) {
  101546:	55                   	push   %ebp
  101547:	89 e5                	mov    %esp,%ebp
  101549:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10154c:	e8 e1 ff ff ff       	call   101532 <kbd_intr>
    pic_enable(IRQ_KBD);
  101551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101558:	e8 17 01 00 00       	call   101674 <pic_enable>
}
  10155d:	c9                   	leave  
  10155e:	c3                   	ret    

0010155f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155f:	55                   	push   %ebp
  101560:	89 e5                	mov    %esp,%ebp
  101562:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101565:	e8 93 f8 ff ff       	call   100dfd <cga_init>
    serial_init();
  10156a:	e8 74 f9 ff ff       	call   100ee3 <serial_init>
    kbd_init();
  10156f:	e8 d2 ff ff ff       	call   101546 <kbd_init>
    if (!serial_exists) {
  101574:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101579:	85 c0                	test   %eax,%eax
  10157b:	75 0c                	jne    101589 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10157d:	c7 04 24 69 39 10 00 	movl   $0x103969,(%esp)
  101584:	e8 89 ed ff ff       	call   100312 <cprintf>
    }
}
  101589:	c9                   	leave  
  10158a:	c3                   	ret    

0010158b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158b:	55                   	push   %ebp
  10158c:	89 e5                	mov    %esp,%ebp
  10158e:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101591:	8b 45 08             	mov    0x8(%ebp),%eax
  101594:	89 04 24             	mov    %eax,(%esp)
  101597:	e8 a3 fa ff ff       	call   10103f <lpt_putc>
    cga_putc(c);
  10159c:	8b 45 08             	mov    0x8(%ebp),%eax
  10159f:	89 04 24             	mov    %eax,(%esp)
  1015a2:	e8 d7 fa ff ff       	call   10107e <cga_putc>
    serial_putc(c);
  1015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015aa:	89 04 24             	mov    %eax,(%esp)
  1015ad:	e8 f9 fc ff ff       	call   1012ab <serial_putc>
}
  1015b2:	c9                   	leave  
  1015b3:	c3                   	ret    

001015b4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015b4:	55                   	push   %ebp
  1015b5:	89 e5                	mov    %esp,%ebp
  1015b7:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ba:	e8 cd fd ff ff       	call   10138c <serial_intr>
    kbd_intr();
  1015bf:	e8 6e ff ff ff       	call   101532 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015c4:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ca:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015cf:	39 c2                	cmp    %eax,%edx
  1015d1:	74 36                	je     101609 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d3:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d8:	8d 50 01             	lea    0x1(%eax),%edx
  1015db:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e1:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e8:	0f b6 c0             	movzbl %al,%eax
  1015eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015ee:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f8:	75 0a                	jne    101604 <cons_getc+0x50>
            cons.rpos = 0;
  1015fa:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101601:	00 00 00 
        }
        return c;
  101604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101607:	eb 05                	jmp    10160e <cons_getc+0x5a>
    }
    return 0;
  101609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10160e:	c9                   	leave  
  10160f:	c3                   	ret    

00101610 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101613:	fb                   	sti    
    sti();
}
  101614:	5d                   	pop    %ebp
  101615:	c3                   	ret    

00101616 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101619:	fa                   	cli    
    cli();
}
  10161a:	5d                   	pop    %ebp
  10161b:	c3                   	ret    

0010161c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10161c:	55                   	push   %ebp
  10161d:	89 e5                	mov    %esp,%ebp
  10161f:	83 ec 14             	sub    $0x14,%esp
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101629:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162d:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101633:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101638:	85 c0                	test   %eax,%eax
  10163a:	74 36                	je     101672 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10163c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101640:	0f b6 c0             	movzbl %al,%eax
  101643:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101649:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10164c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101650:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101654:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101655:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101659:	66 c1 e8 08          	shr    $0x8,%ax
  10165d:	0f b6 c0             	movzbl %al,%eax
  101660:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101666:	88 45 f9             	mov    %al,-0x7(%ebp)
  101669:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10166d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101671:	ee                   	out    %al,(%dx)
    }
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
  101677:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10167a:	8b 45 08             	mov    0x8(%ebp),%eax
  10167d:	ba 01 00 00 00       	mov    $0x1,%edx
  101682:	89 c1                	mov    %eax,%ecx
  101684:	d3 e2                	shl    %cl,%edx
  101686:	89 d0                	mov    %edx,%eax
  101688:	f7 d0                	not    %eax
  10168a:	89 c2                	mov    %eax,%edx
  10168c:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101693:	21 d0                	and    %edx,%eax
  101695:	0f b7 c0             	movzwl %ax,%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 7c ff ff ff       	call   10161c <pic_setmask>
}
  1016a0:	c9                   	leave  
  1016a1:	c3                   	ret    

001016a2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
  1016a5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016a8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016af:	00 00 00 
  1016b2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b8:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016bc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c4:	ee                   	out    %al,(%dx)
  1016c5:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016cb:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d7:	ee                   	out    %al,(%dx)
  1016d8:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016de:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016e6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
  1016eb:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016f1:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016f5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016f9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016fd:	ee                   	out    %al,(%dx)
  1016fe:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101704:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101708:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10170c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101710:	ee                   	out    %al,(%dx)
  101711:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101717:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10171b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10171f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101723:	ee                   	out    %al,(%dx)
  101724:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10172a:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10172e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101732:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101736:	ee                   	out    %al,(%dx)
  101737:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10173d:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101741:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101745:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101749:	ee                   	out    %al,(%dx)
  10174a:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101750:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101754:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101758:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10175c:	ee                   	out    %al,(%dx)
  10175d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101763:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101767:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10176b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
  101770:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101776:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10177a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10177e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101789:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10178d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101791:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10179c:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017a0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017a4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017af:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017b3:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017b7:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017bc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c3:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c7:	74 12                	je     1017db <pic_init+0x139>
        pic_setmask(irq_mask);
  1017c9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d0:	0f b7 c0             	movzwl %ax,%eax
  1017d3:	89 04 24             	mov    %eax,(%esp)
  1017d6:	e8 41 fe ff ff       	call   10161c <pic_setmask>
    }
}
  1017db:	c9                   	leave  
  1017dc:	c3                   	ret    

001017dd <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
  1017e0:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e3:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017ea:	00 
  1017eb:	c7 04 24 a0 39 10 00 	movl   $0x1039a0,(%esp)
  1017f2:	e8 1b eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1017f7:	c7 04 24 aa 39 10 00 	movl   $0x1039aa,(%esp)
  1017fe:	e8 0f eb ff ff       	call   100312 <cprintf>
    panic("EOT: kernel seems ok.");
  101803:	c7 44 24 08 b8 39 10 	movl   $0x1039b8,0x8(%esp)
  10180a:	00 
  10180b:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101812:	00 
  101813:	c7 04 24 ce 39 10 00 	movl   $0x1039ce,(%esp)
  10181a:	e8 77 f4 ff ff       	call   100c96 <__panic>

0010181f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10181f:	55                   	push   %ebp
  101820:	89 e5                	mov    %esp,%ebp
  101822:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
  101825:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10182c:	e9 5c 02 00 00       	jmp    101a8d <idt_init+0x26e>
	{
		if(i == T_SYSCALL) //0x80
  101831:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  101838:	0f 85 c1 00 00 00    	jne    1018ff <idt_init+0xe0>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
  10183e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101841:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101848:	89 c2                	mov    %eax,%edx
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101854:	00 
  101855:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101858:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185f:	00 08 00 
  101862:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101865:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186c:	00 
  10186d:	83 e2 e0             	and    $0xffffffe0,%edx
  101870:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101881:	00 
  101882:	83 e2 1f             	and    $0x1f,%edx
  101885:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101896:	00 
  101897:	83 ca 0f             	or     $0xf,%edx
  10189a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ab:	00 
  1018ac:	83 e2 ef             	and    $0xffffffef,%edx
  1018af:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c0:	00 
  1018c1:	83 ca 60             	or     $0x60,%edx
  1018c4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d5:	00 
  1018d6:	83 ca 80             	or     $0xffffff80,%edx
  1018d9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ea:	c1 e8 10             	shr    $0x10,%eax
  1018ed:	89 c2                	mov    %eax,%edx
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f9:	00 
  1018fa:	e9 8a 01 00 00       	jmp    101a89 <idt_init+0x26a>
		}
		else if(i < 32) //0~31,trap gate
  1018ff:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101903:	0f 8f c1 00 00 00    	jg     1019ca <idt_init+0x1ab>
		{
			SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101909:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101913:	89 c2                	mov    %eax,%edx
  101915:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101918:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10191f:	00 
  101920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101923:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10192a:	00 08 00 
  10192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101930:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101937:	00 
  101938:	83 e2 e0             	and    $0xffffffe0,%edx
  10193b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10194c:	00 
  10194d:	83 e2 1f             	and    $0x1f,%edx
  101950:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101961:	00 
  101962:	83 ca 0f             	or     $0xf,%edx
  101965:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101976:	00 
  101977:	83 e2 ef             	and    $0xffffffef,%edx
  10197a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10198b:	00 
  10198c:	83 e2 9f             	and    $0xffffff9f,%edx
  10198f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019a0:	00 
  1019a1:	83 ca 80             	or     $0xffffff80,%edx
  1019a4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019b5:	c1 e8 10             	shr    $0x10,%eax
  1019b8:	89 c2                	mov    %eax,%edx
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019c4:	00 
  1019c5:	e9 bf 00 00 00       	jmp    101a89 <idt_init+0x26a>
		}
		else //others, interrupt gate
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1019ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cd:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019d4:	89 c2                	mov    %eax,%edx
  1019d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d9:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  1019e0:	00 
  1019e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e4:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  1019eb:	00 08 00 
  1019ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f1:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1019f8:	00 
  1019f9:	83 e2 e0             	and    $0xffffffe0,%edx
  1019fc:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a06:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101a0d:	00 
  101a0e:	83 e2 1f             	and    $0x1f,%edx
  101a11:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a22:	00 
  101a23:	83 e2 f0             	and    $0xfffffff0,%edx
  101a26:	83 ca 0e             	or     $0xe,%edx
  101a29:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a33:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a3a:	00 
  101a3b:	83 e2 ef             	and    $0xffffffef,%edx
  101a3e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a48:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a4f:	00 
  101a50:	83 e2 9f             	and    $0xffffff9f,%edx
  101a53:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a64:	00 
  101a65:	83 ca 80             	or     $0xffffff80,%edx
  101a68:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a72:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101a79:	c1 e8 10             	shr    $0x10,%eax
  101a7c:	89 c2                	mov    %eax,%edx
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101a88:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0;i<sizeof(idt) / sizeof(struct gatedesc);i++)
  101a89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a90:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a95:	0f 86 96 fd ff ff    	jbe    101831 <idt_init+0x12>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		}
	}
	//user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a9b:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101aa0:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101aa6:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101aad:	08 00 
  101aaf:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101ab6:	83 e0 e0             	and    $0xffffffe0,%eax
  101ab9:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101abe:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101ac5:	83 e0 1f             	and    $0x1f,%eax
  101ac8:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101acd:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ad4:	83 e0 f0             	and    $0xfffffff0,%eax
  101ad7:	83 c8 0e             	or     $0xe,%eax
  101ada:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101adf:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ae6:	83 e0 ef             	and    $0xffffffef,%eax
  101ae9:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101aee:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101af5:	83 c8 60             	or     $0x60,%eax
  101af8:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101afd:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101b04:	83 c8 80             	or     $0xffffff80,%eax
  101b07:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101b0c:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101b11:	c1 e8 10             	shr    $0x10,%eax
  101b14:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101b1a:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b24:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101b27:	c9                   	leave  
  101b28:	c3                   	ret    

00101b29 <trapname>:

static const char *
trapname(int trapno) {
  101b29:	55                   	push   %ebp
  101b2a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2f:	83 f8 13             	cmp    $0x13,%eax
  101b32:	77 0c                	ja     101b40 <trapname+0x17>
        return excnames[trapno];
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	8b 04 85 20 3d 10 00 	mov    0x103d20(,%eax,4),%eax
  101b3e:	eb 18                	jmp    101b58 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b40:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b44:	7e 0d                	jle    101b53 <trapname+0x2a>
  101b46:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b4a:	7f 07                	jg     101b53 <trapname+0x2a>
        return "Hardware Interrupt";
  101b4c:	b8 df 39 10 00       	mov    $0x1039df,%eax
  101b51:	eb 05                	jmp    101b58 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b53:	b8 f2 39 10 00       	mov    $0x1039f2,%eax
}
  101b58:	5d                   	pop    %ebp
  101b59:	c3                   	ret    

00101b5a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b5a:	55                   	push   %ebp
  101b5b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b60:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b64:	66 83 f8 08          	cmp    $0x8,%ax
  101b68:	0f 94 c0             	sete   %al
  101b6b:	0f b6 c0             	movzbl %al,%eax
}
  101b6e:	5d                   	pop    %ebp
  101b6f:	c3                   	ret    

00101b70 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b70:	55                   	push   %ebp
  101b71:	89 e5                	mov    %esp,%ebp
  101b73:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7d:	c7 04 24 33 3a 10 00 	movl   $0x103a33,(%esp)
  101b84:	e8 89 e7 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101b89:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8c:	89 04 24             	mov    %eax,(%esp)
  101b8f:	e8 a1 01 00 00       	call   101d35 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b9b:	0f b7 c0             	movzwl %ax,%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 44 3a 10 00 	movl   $0x103a44,(%esp)
  101ba9:	e8 64 e7 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bb5:	0f b7 c0             	movzwl %ax,%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 57 3a 10 00 	movl   $0x103a57,(%esp)
  101bc3:	e8 4a e7 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bcf:	0f b7 c0             	movzwl %ax,%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 6a 3a 10 00 	movl   $0x103a6a,(%esp)
  101bdd:	e8 30 e7 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101be9:	0f b7 c0             	movzwl %ax,%eax
  101bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf0:	c7 04 24 7d 3a 10 00 	movl   $0x103a7d,(%esp)
  101bf7:	e8 16 e7 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bff:	8b 40 30             	mov    0x30(%eax),%eax
  101c02:	89 04 24             	mov    %eax,(%esp)
  101c05:	e8 1f ff ff ff       	call   101b29 <trapname>
  101c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  101c0d:	8b 52 30             	mov    0x30(%edx),%edx
  101c10:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c14:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c18:	c7 04 24 90 3a 10 00 	movl   $0x103a90,(%esp)
  101c1f:	e8 ee e6 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c24:	8b 45 08             	mov    0x8(%ebp),%eax
  101c27:	8b 40 34             	mov    0x34(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101c35:	e8 d8 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 38             	mov    0x38(%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 b1 3a 10 00 	movl   $0x103ab1,(%esp)
  101c4b:	e8 c2 e6 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c57:	0f b7 c0             	movzwl %ax,%eax
  101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5e:	c7 04 24 c0 3a 10 00 	movl   $0x103ac0,(%esp)
  101c65:	e8 a8 e6 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6d:	8b 40 40             	mov    0x40(%eax),%eax
  101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c74:	c7 04 24 d3 3a 10 00 	movl   $0x103ad3,(%esp)
  101c7b:	e8 92 e6 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c87:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c8e:	eb 3e                	jmp    101cce <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c90:	8b 45 08             	mov    0x8(%ebp),%eax
  101c93:	8b 50 40             	mov    0x40(%eax),%edx
  101c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c99:	21 d0                	and    %edx,%eax
  101c9b:	85 c0                	test   %eax,%eax
  101c9d:	74 28                	je     101cc7 <print_trapframe+0x157>
  101c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ca2:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ca9:	85 c0                	test   %eax,%eax
  101cab:	74 1a                	je     101cc7 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cb0:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbb:	c7 04 24 e2 3a 10 00 	movl   $0x103ae2,(%esp)
  101cc2:	e8 4b e6 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ccb:	d1 65 f0             	shll   -0x10(%ebp)
  101cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cd1:	83 f8 17             	cmp    $0x17,%eax
  101cd4:	76 ba                	jbe    101c90 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd9:	8b 40 40             	mov    0x40(%eax),%eax
  101cdc:	25 00 30 00 00       	and    $0x3000,%eax
  101ce1:	c1 e8 0c             	shr    $0xc,%eax
  101ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce8:	c7 04 24 e6 3a 10 00 	movl   $0x103ae6,(%esp)
  101cef:	e8 1e e6 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf7:	89 04 24             	mov    %eax,(%esp)
  101cfa:	e8 5b fe ff ff       	call   101b5a <trap_in_kernel>
  101cff:	85 c0                	test   %eax,%eax
  101d01:	75 30                	jne    101d33 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d03:	8b 45 08             	mov    0x8(%ebp),%eax
  101d06:	8b 40 44             	mov    0x44(%eax),%eax
  101d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0d:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101d14:	e8 f9 e5 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d19:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d20:	0f b7 c0             	movzwl %ax,%eax
  101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d27:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101d2e:	e8 df e5 ff ff       	call   100312 <cprintf>
    }
}
  101d33:	c9                   	leave  
  101d34:	c3                   	ret    

00101d35 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d35:	55                   	push   %ebp
  101d36:	89 e5                	mov    %esp,%ebp
  101d38:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 00                	mov    (%eax),%eax
  101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d44:	c7 04 24 11 3b 10 00 	movl   $0x103b11,(%esp)
  101d4b:	e8 c2 e5 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	8b 40 04             	mov    0x4(%eax),%eax
  101d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5a:	c7 04 24 20 3b 10 00 	movl   $0x103b20,(%esp)
  101d61:	e8 ac e5 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d66:	8b 45 08             	mov    0x8(%ebp),%eax
  101d69:	8b 40 08             	mov    0x8(%eax),%eax
  101d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d70:	c7 04 24 2f 3b 10 00 	movl   $0x103b2f,(%esp)
  101d77:	e8 96 e5 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  101d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d86:	c7 04 24 3e 3b 10 00 	movl   $0x103b3e,(%esp)
  101d8d:	e8 80 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d92:	8b 45 08             	mov    0x8(%ebp),%eax
  101d95:	8b 40 10             	mov    0x10(%eax),%eax
  101d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9c:	c7 04 24 4d 3b 10 00 	movl   $0x103b4d,(%esp)
  101da3:	e8 6a e5 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101da8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dab:	8b 40 14             	mov    0x14(%eax),%eax
  101dae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db2:	c7 04 24 5c 3b 10 00 	movl   $0x103b5c,(%esp)
  101db9:	e8 54 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc1:	8b 40 18             	mov    0x18(%eax),%eax
  101dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc8:	c7 04 24 6b 3b 10 00 	movl   $0x103b6b,(%esp)
  101dcf:	e8 3e e5 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dde:	c7 04 24 7a 3b 10 00 	movl   $0x103b7a,(%esp)
  101de5:	e8 28 e5 ff ff       	call   100312 <cprintf>
}
  101dea:	c9                   	leave  
  101deb:	c3                   	ret    

00101dec <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101dec:	55                   	push   %ebp
  101ded:	89 e5                	mov    %esp,%ebp
  101def:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101df2:	8b 45 08             	mov    0x8(%ebp),%eax
  101df5:	8b 40 30             	mov    0x30(%eax),%eax
  101df8:	83 f8 2f             	cmp    $0x2f,%eax
  101dfb:	77 21                	ja     101e1e <trap_dispatch+0x32>
  101dfd:	83 f8 2e             	cmp    $0x2e,%eax
  101e00:	0f 83 04 01 00 00    	jae    101f0a <trap_dispatch+0x11e>
  101e06:	83 f8 21             	cmp    $0x21,%eax
  101e09:	0f 84 81 00 00 00    	je     101e90 <trap_dispatch+0xa4>
  101e0f:	83 f8 24             	cmp    $0x24,%eax
  101e12:	74 56                	je     101e6a <trap_dispatch+0x7e>
  101e14:	83 f8 20             	cmp    $0x20,%eax
  101e17:	74 16                	je     101e2f <trap_dispatch+0x43>
  101e19:	e9 b4 00 00 00       	jmp    101ed2 <trap_dispatch+0xe6>
  101e1e:	83 e8 78             	sub    $0x78,%eax
  101e21:	83 f8 01             	cmp    $0x1,%eax
  101e24:	0f 87 a8 00 00 00    	ja     101ed2 <trap_dispatch+0xe6>
  101e2a:	e9 87 00 00 00       	jmp    101eb6 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks++;
  101e2f:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101e34:	83 c0 01             	add    $0x1,%eax
  101e37:	a3 08 f9 10 00       	mov    %eax,0x10f908
    	if(ticks % TICK_NUM == 0)
  101e3c:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101e42:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e47:	89 c8                	mov    %ecx,%eax
  101e49:	f7 e2                	mul    %edx
  101e4b:	89 d0                	mov    %edx,%eax
  101e4d:	c1 e8 05             	shr    $0x5,%eax
  101e50:	6b c0 64             	imul   $0x64,%eax,%eax
  101e53:	29 c1                	sub    %eax,%ecx
  101e55:	89 c8                	mov    %ecx,%eax
  101e57:	85 c0                	test   %eax,%eax
  101e59:	75 0a                	jne    101e65 <trap_dispatch+0x79>
    	{
    		print_ticks();
  101e5b:	e8 7d f9 ff ff       	call   1017dd <print_ticks>
    	}
        break;
  101e60:	e9 a6 00 00 00       	jmp    101f0b <trap_dispatch+0x11f>
  101e65:	e9 a1 00 00 00       	jmp    101f0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e6a:	e8 45 f7 ff ff       	call   1015b4 <cons_getc>
  101e6f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e72:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e82:	c7 04 24 89 3b 10 00 	movl   $0x103b89,(%esp)
  101e89:	e8 84 e4 ff ff       	call   100312 <cprintf>
        break;
  101e8e:	eb 7b                	jmp    101f0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e90:	e8 1f f7 ff ff       	call   1015b4 <cons_getc>
  101e95:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e98:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e9c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ea0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ea8:	c7 04 24 9b 3b 10 00 	movl   $0x103b9b,(%esp)
  101eaf:	e8 5e e4 ff ff       	call   100312 <cprintf>
        break;
  101eb4:	eb 55                	jmp    101f0b <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101eb6:	c7 44 24 08 aa 3b 10 	movl   $0x103baa,0x8(%esp)
  101ebd:	00 
  101ebe:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  101ec5:	00 
  101ec6:	c7 04 24 ce 39 10 00 	movl   $0x1039ce,(%esp)
  101ecd:	e8 c4 ed ff ff       	call   100c96 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed9:	0f b7 c0             	movzwl %ax,%eax
  101edc:	83 e0 03             	and    $0x3,%eax
  101edf:	85 c0                	test   %eax,%eax
  101ee1:	75 28                	jne    101f0b <trap_dispatch+0x11f>
            print_trapframe(tf);
  101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee6:	89 04 24             	mov    %eax,(%esp)
  101ee9:	e8 82 fc ff ff       	call   101b70 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eee:	c7 44 24 08 ba 3b 10 	movl   $0x103bba,0x8(%esp)
  101ef5:	00 
  101ef6:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  101efd:	00 
  101efe:	c7 04 24 ce 39 10 00 	movl   $0x1039ce,(%esp)
  101f05:	e8 8c ed ff ff       	call   100c96 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f0a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f0b:	c9                   	leave  
  101f0c:	c3                   	ret    

00101f0d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f0d:	55                   	push   %ebp
  101f0e:	89 e5                	mov    %esp,%ebp
  101f10:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f13:	8b 45 08             	mov    0x8(%ebp),%eax
  101f16:	89 04 24             	mov    %eax,(%esp)
  101f19:	e8 ce fe ff ff       	call   101dec <trap_dispatch>
}
  101f1e:	c9                   	leave  
  101f1f:	c3                   	ret    

00101f20 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f20:	1e                   	push   %ds
    pushl %es
  101f21:	06                   	push   %es
    pushl %fs
  101f22:	0f a0                	push   %fs
    pushl %gs
  101f24:	0f a8                	push   %gs
    pushal
  101f26:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f27:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f2c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f2e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f30:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f31:	e8 d7 ff ff ff       	call   101f0d <trap>

    # pop the pushed stack pointer
    popl %esp
  101f36:	5c                   	pop    %esp

00101f37 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f37:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f38:	0f a9                	pop    %gs
    popl %fs
  101f3a:	0f a1                	pop    %fs
    popl %es
  101f3c:	07                   	pop    %es
    popl %ds
  101f3d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f3e:	83 c4 08             	add    $0x8,%esp
    iret
  101f41:	cf                   	iret   

00101f42 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $0
  101f44:	6a 00                	push   $0x0
  jmp __alltraps
  101f46:	e9 d5 ff ff ff       	jmp    101f20 <__alltraps>

00101f4b <vector1>:
.globl vector1
vector1:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $1
  101f4d:	6a 01                	push   $0x1
  jmp __alltraps
  101f4f:	e9 cc ff ff ff       	jmp    101f20 <__alltraps>

00101f54 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $2
  101f56:	6a 02                	push   $0x2
  jmp __alltraps
  101f58:	e9 c3 ff ff ff       	jmp    101f20 <__alltraps>

00101f5d <vector3>:
.globl vector3
vector3:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $3
  101f5f:	6a 03                	push   $0x3
  jmp __alltraps
  101f61:	e9 ba ff ff ff       	jmp    101f20 <__alltraps>

00101f66 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $4
  101f68:	6a 04                	push   $0x4
  jmp __alltraps
  101f6a:	e9 b1 ff ff ff       	jmp    101f20 <__alltraps>

00101f6f <vector5>:
.globl vector5
vector5:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $5
  101f71:	6a 05                	push   $0x5
  jmp __alltraps
  101f73:	e9 a8 ff ff ff       	jmp    101f20 <__alltraps>

00101f78 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $6
  101f7a:	6a 06                	push   $0x6
  jmp __alltraps
  101f7c:	e9 9f ff ff ff       	jmp    101f20 <__alltraps>

00101f81 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $7
  101f83:	6a 07                	push   $0x7
  jmp __alltraps
  101f85:	e9 96 ff ff ff       	jmp    101f20 <__alltraps>

00101f8a <vector8>:
.globl vector8
vector8:
  pushl $8
  101f8a:	6a 08                	push   $0x8
  jmp __alltraps
  101f8c:	e9 8f ff ff ff       	jmp    101f20 <__alltraps>

00101f91 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f91:	6a 09                	push   $0x9
  jmp __alltraps
  101f93:	e9 88 ff ff ff       	jmp    101f20 <__alltraps>

00101f98 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f98:	6a 0a                	push   $0xa
  jmp __alltraps
  101f9a:	e9 81 ff ff ff       	jmp    101f20 <__alltraps>

00101f9f <vector11>:
.globl vector11
vector11:
  pushl $11
  101f9f:	6a 0b                	push   $0xb
  jmp __alltraps
  101fa1:	e9 7a ff ff ff       	jmp    101f20 <__alltraps>

00101fa6 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fa6:	6a 0c                	push   $0xc
  jmp __alltraps
  101fa8:	e9 73 ff ff ff       	jmp    101f20 <__alltraps>

00101fad <vector13>:
.globl vector13
vector13:
  pushl $13
  101fad:	6a 0d                	push   $0xd
  jmp __alltraps
  101faf:	e9 6c ff ff ff       	jmp    101f20 <__alltraps>

00101fb4 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fb4:	6a 0e                	push   $0xe
  jmp __alltraps
  101fb6:	e9 65 ff ff ff       	jmp    101f20 <__alltraps>

00101fbb <vector15>:
.globl vector15
vector15:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $15
  101fbd:	6a 0f                	push   $0xf
  jmp __alltraps
  101fbf:	e9 5c ff ff ff       	jmp    101f20 <__alltraps>

00101fc4 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $16
  101fc6:	6a 10                	push   $0x10
  jmp __alltraps
  101fc8:	e9 53 ff ff ff       	jmp    101f20 <__alltraps>

00101fcd <vector17>:
.globl vector17
vector17:
  pushl $17
  101fcd:	6a 11                	push   $0x11
  jmp __alltraps
  101fcf:	e9 4c ff ff ff       	jmp    101f20 <__alltraps>

00101fd4 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $18
  101fd6:	6a 12                	push   $0x12
  jmp __alltraps
  101fd8:	e9 43 ff ff ff       	jmp    101f20 <__alltraps>

00101fdd <vector19>:
.globl vector19
vector19:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $19
  101fdf:	6a 13                	push   $0x13
  jmp __alltraps
  101fe1:	e9 3a ff ff ff       	jmp    101f20 <__alltraps>

00101fe6 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $20
  101fe8:	6a 14                	push   $0x14
  jmp __alltraps
  101fea:	e9 31 ff ff ff       	jmp    101f20 <__alltraps>

00101fef <vector21>:
.globl vector21
vector21:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $21
  101ff1:	6a 15                	push   $0x15
  jmp __alltraps
  101ff3:	e9 28 ff ff ff       	jmp    101f20 <__alltraps>

00101ff8 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $22
  101ffa:	6a 16                	push   $0x16
  jmp __alltraps
  101ffc:	e9 1f ff ff ff       	jmp    101f20 <__alltraps>

00102001 <vector23>:
.globl vector23
vector23:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $23
  102003:	6a 17                	push   $0x17
  jmp __alltraps
  102005:	e9 16 ff ff ff       	jmp    101f20 <__alltraps>

0010200a <vector24>:
.globl vector24
vector24:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $24
  10200c:	6a 18                	push   $0x18
  jmp __alltraps
  10200e:	e9 0d ff ff ff       	jmp    101f20 <__alltraps>

00102013 <vector25>:
.globl vector25
vector25:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $25
  102015:	6a 19                	push   $0x19
  jmp __alltraps
  102017:	e9 04 ff ff ff       	jmp    101f20 <__alltraps>

0010201c <vector26>:
.globl vector26
vector26:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $26
  10201e:	6a 1a                	push   $0x1a
  jmp __alltraps
  102020:	e9 fb fe ff ff       	jmp    101f20 <__alltraps>

00102025 <vector27>:
.globl vector27
vector27:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $27
  102027:	6a 1b                	push   $0x1b
  jmp __alltraps
  102029:	e9 f2 fe ff ff       	jmp    101f20 <__alltraps>

0010202e <vector28>:
.globl vector28
vector28:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $28
  102030:	6a 1c                	push   $0x1c
  jmp __alltraps
  102032:	e9 e9 fe ff ff       	jmp    101f20 <__alltraps>

00102037 <vector29>:
.globl vector29
vector29:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $29
  102039:	6a 1d                	push   $0x1d
  jmp __alltraps
  10203b:	e9 e0 fe ff ff       	jmp    101f20 <__alltraps>

00102040 <vector30>:
.globl vector30
vector30:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $30
  102042:	6a 1e                	push   $0x1e
  jmp __alltraps
  102044:	e9 d7 fe ff ff       	jmp    101f20 <__alltraps>

00102049 <vector31>:
.globl vector31
vector31:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $31
  10204b:	6a 1f                	push   $0x1f
  jmp __alltraps
  10204d:	e9 ce fe ff ff       	jmp    101f20 <__alltraps>

00102052 <vector32>:
.globl vector32
vector32:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $32
  102054:	6a 20                	push   $0x20
  jmp __alltraps
  102056:	e9 c5 fe ff ff       	jmp    101f20 <__alltraps>

0010205b <vector33>:
.globl vector33
vector33:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $33
  10205d:	6a 21                	push   $0x21
  jmp __alltraps
  10205f:	e9 bc fe ff ff       	jmp    101f20 <__alltraps>

00102064 <vector34>:
.globl vector34
vector34:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $34
  102066:	6a 22                	push   $0x22
  jmp __alltraps
  102068:	e9 b3 fe ff ff       	jmp    101f20 <__alltraps>

0010206d <vector35>:
.globl vector35
vector35:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $35
  10206f:	6a 23                	push   $0x23
  jmp __alltraps
  102071:	e9 aa fe ff ff       	jmp    101f20 <__alltraps>

00102076 <vector36>:
.globl vector36
vector36:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $36
  102078:	6a 24                	push   $0x24
  jmp __alltraps
  10207a:	e9 a1 fe ff ff       	jmp    101f20 <__alltraps>

0010207f <vector37>:
.globl vector37
vector37:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $37
  102081:	6a 25                	push   $0x25
  jmp __alltraps
  102083:	e9 98 fe ff ff       	jmp    101f20 <__alltraps>

00102088 <vector38>:
.globl vector38
vector38:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $38
  10208a:	6a 26                	push   $0x26
  jmp __alltraps
  10208c:	e9 8f fe ff ff       	jmp    101f20 <__alltraps>

00102091 <vector39>:
.globl vector39
vector39:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $39
  102093:	6a 27                	push   $0x27
  jmp __alltraps
  102095:	e9 86 fe ff ff       	jmp    101f20 <__alltraps>

0010209a <vector40>:
.globl vector40
vector40:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $40
  10209c:	6a 28                	push   $0x28
  jmp __alltraps
  10209e:	e9 7d fe ff ff       	jmp    101f20 <__alltraps>

001020a3 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $41
  1020a5:	6a 29                	push   $0x29
  jmp __alltraps
  1020a7:	e9 74 fe ff ff       	jmp    101f20 <__alltraps>

001020ac <vector42>:
.globl vector42
vector42:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $42
  1020ae:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020b0:	e9 6b fe ff ff       	jmp    101f20 <__alltraps>

001020b5 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $43
  1020b7:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020b9:	e9 62 fe ff ff       	jmp    101f20 <__alltraps>

001020be <vector44>:
.globl vector44
vector44:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $44
  1020c0:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020c2:	e9 59 fe ff ff       	jmp    101f20 <__alltraps>

001020c7 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $45
  1020c9:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020cb:	e9 50 fe ff ff       	jmp    101f20 <__alltraps>

001020d0 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $46
  1020d2:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020d4:	e9 47 fe ff ff       	jmp    101f20 <__alltraps>

001020d9 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $47
  1020db:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020dd:	e9 3e fe ff ff       	jmp    101f20 <__alltraps>

001020e2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $48
  1020e4:	6a 30                	push   $0x30
  jmp __alltraps
  1020e6:	e9 35 fe ff ff       	jmp    101f20 <__alltraps>

001020eb <vector49>:
.globl vector49
vector49:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $49
  1020ed:	6a 31                	push   $0x31
  jmp __alltraps
  1020ef:	e9 2c fe ff ff       	jmp    101f20 <__alltraps>

001020f4 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $50
  1020f6:	6a 32                	push   $0x32
  jmp __alltraps
  1020f8:	e9 23 fe ff ff       	jmp    101f20 <__alltraps>

001020fd <vector51>:
.globl vector51
vector51:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $51
  1020ff:	6a 33                	push   $0x33
  jmp __alltraps
  102101:	e9 1a fe ff ff       	jmp    101f20 <__alltraps>

00102106 <vector52>:
.globl vector52
vector52:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $52
  102108:	6a 34                	push   $0x34
  jmp __alltraps
  10210a:	e9 11 fe ff ff       	jmp    101f20 <__alltraps>

0010210f <vector53>:
.globl vector53
vector53:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $53
  102111:	6a 35                	push   $0x35
  jmp __alltraps
  102113:	e9 08 fe ff ff       	jmp    101f20 <__alltraps>

00102118 <vector54>:
.globl vector54
vector54:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $54
  10211a:	6a 36                	push   $0x36
  jmp __alltraps
  10211c:	e9 ff fd ff ff       	jmp    101f20 <__alltraps>

00102121 <vector55>:
.globl vector55
vector55:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $55
  102123:	6a 37                	push   $0x37
  jmp __alltraps
  102125:	e9 f6 fd ff ff       	jmp    101f20 <__alltraps>

0010212a <vector56>:
.globl vector56
vector56:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $56
  10212c:	6a 38                	push   $0x38
  jmp __alltraps
  10212e:	e9 ed fd ff ff       	jmp    101f20 <__alltraps>

00102133 <vector57>:
.globl vector57
vector57:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $57
  102135:	6a 39                	push   $0x39
  jmp __alltraps
  102137:	e9 e4 fd ff ff       	jmp    101f20 <__alltraps>

0010213c <vector58>:
.globl vector58
vector58:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $58
  10213e:	6a 3a                	push   $0x3a
  jmp __alltraps
  102140:	e9 db fd ff ff       	jmp    101f20 <__alltraps>

00102145 <vector59>:
.globl vector59
vector59:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $59
  102147:	6a 3b                	push   $0x3b
  jmp __alltraps
  102149:	e9 d2 fd ff ff       	jmp    101f20 <__alltraps>

0010214e <vector60>:
.globl vector60
vector60:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $60
  102150:	6a 3c                	push   $0x3c
  jmp __alltraps
  102152:	e9 c9 fd ff ff       	jmp    101f20 <__alltraps>

00102157 <vector61>:
.globl vector61
vector61:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $61
  102159:	6a 3d                	push   $0x3d
  jmp __alltraps
  10215b:	e9 c0 fd ff ff       	jmp    101f20 <__alltraps>

00102160 <vector62>:
.globl vector62
vector62:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $62
  102162:	6a 3e                	push   $0x3e
  jmp __alltraps
  102164:	e9 b7 fd ff ff       	jmp    101f20 <__alltraps>

00102169 <vector63>:
.globl vector63
vector63:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $63
  10216b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10216d:	e9 ae fd ff ff       	jmp    101f20 <__alltraps>

00102172 <vector64>:
.globl vector64
vector64:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $64
  102174:	6a 40                	push   $0x40
  jmp __alltraps
  102176:	e9 a5 fd ff ff       	jmp    101f20 <__alltraps>

0010217b <vector65>:
.globl vector65
vector65:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $65
  10217d:	6a 41                	push   $0x41
  jmp __alltraps
  10217f:	e9 9c fd ff ff       	jmp    101f20 <__alltraps>

00102184 <vector66>:
.globl vector66
vector66:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $66
  102186:	6a 42                	push   $0x42
  jmp __alltraps
  102188:	e9 93 fd ff ff       	jmp    101f20 <__alltraps>

0010218d <vector67>:
.globl vector67
vector67:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $67
  10218f:	6a 43                	push   $0x43
  jmp __alltraps
  102191:	e9 8a fd ff ff       	jmp    101f20 <__alltraps>

00102196 <vector68>:
.globl vector68
vector68:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $68
  102198:	6a 44                	push   $0x44
  jmp __alltraps
  10219a:	e9 81 fd ff ff       	jmp    101f20 <__alltraps>

0010219f <vector69>:
.globl vector69
vector69:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $69
  1021a1:	6a 45                	push   $0x45
  jmp __alltraps
  1021a3:	e9 78 fd ff ff       	jmp    101f20 <__alltraps>

001021a8 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $70
  1021aa:	6a 46                	push   $0x46
  jmp __alltraps
  1021ac:	e9 6f fd ff ff       	jmp    101f20 <__alltraps>

001021b1 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $71
  1021b3:	6a 47                	push   $0x47
  jmp __alltraps
  1021b5:	e9 66 fd ff ff       	jmp    101f20 <__alltraps>

001021ba <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $72
  1021bc:	6a 48                	push   $0x48
  jmp __alltraps
  1021be:	e9 5d fd ff ff       	jmp    101f20 <__alltraps>

001021c3 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $73
  1021c5:	6a 49                	push   $0x49
  jmp __alltraps
  1021c7:	e9 54 fd ff ff       	jmp    101f20 <__alltraps>

001021cc <vector74>:
.globl vector74
vector74:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $74
  1021ce:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021d0:	e9 4b fd ff ff       	jmp    101f20 <__alltraps>

001021d5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $75
  1021d7:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021d9:	e9 42 fd ff ff       	jmp    101f20 <__alltraps>

001021de <vector76>:
.globl vector76
vector76:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $76
  1021e0:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021e2:	e9 39 fd ff ff       	jmp    101f20 <__alltraps>

001021e7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $77
  1021e9:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021eb:	e9 30 fd ff ff       	jmp    101f20 <__alltraps>

001021f0 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $78
  1021f2:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021f4:	e9 27 fd ff ff       	jmp    101f20 <__alltraps>

001021f9 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $79
  1021fb:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021fd:	e9 1e fd ff ff       	jmp    101f20 <__alltraps>

00102202 <vector80>:
.globl vector80
vector80:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $80
  102204:	6a 50                	push   $0x50
  jmp __alltraps
  102206:	e9 15 fd ff ff       	jmp    101f20 <__alltraps>

0010220b <vector81>:
.globl vector81
vector81:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $81
  10220d:	6a 51                	push   $0x51
  jmp __alltraps
  10220f:	e9 0c fd ff ff       	jmp    101f20 <__alltraps>

00102214 <vector82>:
.globl vector82
vector82:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $82
  102216:	6a 52                	push   $0x52
  jmp __alltraps
  102218:	e9 03 fd ff ff       	jmp    101f20 <__alltraps>

0010221d <vector83>:
.globl vector83
vector83:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $83
  10221f:	6a 53                	push   $0x53
  jmp __alltraps
  102221:	e9 fa fc ff ff       	jmp    101f20 <__alltraps>

00102226 <vector84>:
.globl vector84
vector84:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $84
  102228:	6a 54                	push   $0x54
  jmp __alltraps
  10222a:	e9 f1 fc ff ff       	jmp    101f20 <__alltraps>

0010222f <vector85>:
.globl vector85
vector85:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $85
  102231:	6a 55                	push   $0x55
  jmp __alltraps
  102233:	e9 e8 fc ff ff       	jmp    101f20 <__alltraps>

00102238 <vector86>:
.globl vector86
vector86:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $86
  10223a:	6a 56                	push   $0x56
  jmp __alltraps
  10223c:	e9 df fc ff ff       	jmp    101f20 <__alltraps>

00102241 <vector87>:
.globl vector87
vector87:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $87
  102243:	6a 57                	push   $0x57
  jmp __alltraps
  102245:	e9 d6 fc ff ff       	jmp    101f20 <__alltraps>

0010224a <vector88>:
.globl vector88
vector88:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $88
  10224c:	6a 58                	push   $0x58
  jmp __alltraps
  10224e:	e9 cd fc ff ff       	jmp    101f20 <__alltraps>

00102253 <vector89>:
.globl vector89
vector89:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $89
  102255:	6a 59                	push   $0x59
  jmp __alltraps
  102257:	e9 c4 fc ff ff       	jmp    101f20 <__alltraps>

0010225c <vector90>:
.globl vector90
vector90:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $90
  10225e:	6a 5a                	push   $0x5a
  jmp __alltraps
  102260:	e9 bb fc ff ff       	jmp    101f20 <__alltraps>

00102265 <vector91>:
.globl vector91
vector91:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $91
  102267:	6a 5b                	push   $0x5b
  jmp __alltraps
  102269:	e9 b2 fc ff ff       	jmp    101f20 <__alltraps>

0010226e <vector92>:
.globl vector92
vector92:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $92
  102270:	6a 5c                	push   $0x5c
  jmp __alltraps
  102272:	e9 a9 fc ff ff       	jmp    101f20 <__alltraps>

00102277 <vector93>:
.globl vector93
vector93:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $93
  102279:	6a 5d                	push   $0x5d
  jmp __alltraps
  10227b:	e9 a0 fc ff ff       	jmp    101f20 <__alltraps>

00102280 <vector94>:
.globl vector94
vector94:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $94
  102282:	6a 5e                	push   $0x5e
  jmp __alltraps
  102284:	e9 97 fc ff ff       	jmp    101f20 <__alltraps>

00102289 <vector95>:
.globl vector95
vector95:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $95
  10228b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10228d:	e9 8e fc ff ff       	jmp    101f20 <__alltraps>

00102292 <vector96>:
.globl vector96
vector96:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $96
  102294:	6a 60                	push   $0x60
  jmp __alltraps
  102296:	e9 85 fc ff ff       	jmp    101f20 <__alltraps>

0010229b <vector97>:
.globl vector97
vector97:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $97
  10229d:	6a 61                	push   $0x61
  jmp __alltraps
  10229f:	e9 7c fc ff ff       	jmp    101f20 <__alltraps>

001022a4 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $98
  1022a6:	6a 62                	push   $0x62
  jmp __alltraps
  1022a8:	e9 73 fc ff ff       	jmp    101f20 <__alltraps>

001022ad <vector99>:
.globl vector99
vector99:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $99
  1022af:	6a 63                	push   $0x63
  jmp __alltraps
  1022b1:	e9 6a fc ff ff       	jmp    101f20 <__alltraps>

001022b6 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $100
  1022b8:	6a 64                	push   $0x64
  jmp __alltraps
  1022ba:	e9 61 fc ff ff       	jmp    101f20 <__alltraps>

001022bf <vector101>:
.globl vector101
vector101:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $101
  1022c1:	6a 65                	push   $0x65
  jmp __alltraps
  1022c3:	e9 58 fc ff ff       	jmp    101f20 <__alltraps>

001022c8 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $102
  1022ca:	6a 66                	push   $0x66
  jmp __alltraps
  1022cc:	e9 4f fc ff ff       	jmp    101f20 <__alltraps>

001022d1 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $103
  1022d3:	6a 67                	push   $0x67
  jmp __alltraps
  1022d5:	e9 46 fc ff ff       	jmp    101f20 <__alltraps>

001022da <vector104>:
.globl vector104
vector104:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $104
  1022dc:	6a 68                	push   $0x68
  jmp __alltraps
  1022de:	e9 3d fc ff ff       	jmp    101f20 <__alltraps>

001022e3 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $105
  1022e5:	6a 69                	push   $0x69
  jmp __alltraps
  1022e7:	e9 34 fc ff ff       	jmp    101f20 <__alltraps>

001022ec <vector106>:
.globl vector106
vector106:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $106
  1022ee:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022f0:	e9 2b fc ff ff       	jmp    101f20 <__alltraps>

001022f5 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $107
  1022f7:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022f9:	e9 22 fc ff ff       	jmp    101f20 <__alltraps>

001022fe <vector108>:
.globl vector108
vector108:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $108
  102300:	6a 6c                	push   $0x6c
  jmp __alltraps
  102302:	e9 19 fc ff ff       	jmp    101f20 <__alltraps>

00102307 <vector109>:
.globl vector109
vector109:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $109
  102309:	6a 6d                	push   $0x6d
  jmp __alltraps
  10230b:	e9 10 fc ff ff       	jmp    101f20 <__alltraps>

00102310 <vector110>:
.globl vector110
vector110:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $110
  102312:	6a 6e                	push   $0x6e
  jmp __alltraps
  102314:	e9 07 fc ff ff       	jmp    101f20 <__alltraps>

00102319 <vector111>:
.globl vector111
vector111:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $111
  10231b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10231d:	e9 fe fb ff ff       	jmp    101f20 <__alltraps>

00102322 <vector112>:
.globl vector112
vector112:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $112
  102324:	6a 70                	push   $0x70
  jmp __alltraps
  102326:	e9 f5 fb ff ff       	jmp    101f20 <__alltraps>

0010232b <vector113>:
.globl vector113
vector113:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $113
  10232d:	6a 71                	push   $0x71
  jmp __alltraps
  10232f:	e9 ec fb ff ff       	jmp    101f20 <__alltraps>

00102334 <vector114>:
.globl vector114
vector114:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $114
  102336:	6a 72                	push   $0x72
  jmp __alltraps
  102338:	e9 e3 fb ff ff       	jmp    101f20 <__alltraps>

0010233d <vector115>:
.globl vector115
vector115:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $115
  10233f:	6a 73                	push   $0x73
  jmp __alltraps
  102341:	e9 da fb ff ff       	jmp    101f20 <__alltraps>

00102346 <vector116>:
.globl vector116
vector116:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $116
  102348:	6a 74                	push   $0x74
  jmp __alltraps
  10234a:	e9 d1 fb ff ff       	jmp    101f20 <__alltraps>

0010234f <vector117>:
.globl vector117
vector117:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $117
  102351:	6a 75                	push   $0x75
  jmp __alltraps
  102353:	e9 c8 fb ff ff       	jmp    101f20 <__alltraps>

00102358 <vector118>:
.globl vector118
vector118:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $118
  10235a:	6a 76                	push   $0x76
  jmp __alltraps
  10235c:	e9 bf fb ff ff       	jmp    101f20 <__alltraps>

00102361 <vector119>:
.globl vector119
vector119:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $119
  102363:	6a 77                	push   $0x77
  jmp __alltraps
  102365:	e9 b6 fb ff ff       	jmp    101f20 <__alltraps>

0010236a <vector120>:
.globl vector120
vector120:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $120
  10236c:	6a 78                	push   $0x78
  jmp __alltraps
  10236e:	e9 ad fb ff ff       	jmp    101f20 <__alltraps>

00102373 <vector121>:
.globl vector121
vector121:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $121
  102375:	6a 79                	push   $0x79
  jmp __alltraps
  102377:	e9 a4 fb ff ff       	jmp    101f20 <__alltraps>

0010237c <vector122>:
.globl vector122
vector122:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $122
  10237e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102380:	e9 9b fb ff ff       	jmp    101f20 <__alltraps>

00102385 <vector123>:
.globl vector123
vector123:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $123
  102387:	6a 7b                	push   $0x7b
  jmp __alltraps
  102389:	e9 92 fb ff ff       	jmp    101f20 <__alltraps>

0010238e <vector124>:
.globl vector124
vector124:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $124
  102390:	6a 7c                	push   $0x7c
  jmp __alltraps
  102392:	e9 89 fb ff ff       	jmp    101f20 <__alltraps>

00102397 <vector125>:
.globl vector125
vector125:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $125
  102399:	6a 7d                	push   $0x7d
  jmp __alltraps
  10239b:	e9 80 fb ff ff       	jmp    101f20 <__alltraps>

001023a0 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $126
  1023a2:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023a4:	e9 77 fb ff ff       	jmp    101f20 <__alltraps>

001023a9 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $127
  1023ab:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023ad:	e9 6e fb ff ff       	jmp    101f20 <__alltraps>

001023b2 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $128
  1023b4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023b9:	e9 62 fb ff ff       	jmp    101f20 <__alltraps>

001023be <vector129>:
.globl vector129
vector129:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $129
  1023c0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023c5:	e9 56 fb ff ff       	jmp    101f20 <__alltraps>

001023ca <vector130>:
.globl vector130
vector130:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $130
  1023cc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023d1:	e9 4a fb ff ff       	jmp    101f20 <__alltraps>

001023d6 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $131
  1023d8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023dd:	e9 3e fb ff ff       	jmp    101f20 <__alltraps>

001023e2 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $132
  1023e4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023e9:	e9 32 fb ff ff       	jmp    101f20 <__alltraps>

001023ee <vector133>:
.globl vector133
vector133:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $133
  1023f0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023f5:	e9 26 fb ff ff       	jmp    101f20 <__alltraps>

001023fa <vector134>:
.globl vector134
vector134:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $134
  1023fc:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102401:	e9 1a fb ff ff       	jmp    101f20 <__alltraps>

00102406 <vector135>:
.globl vector135
vector135:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $135
  102408:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10240d:	e9 0e fb ff ff       	jmp    101f20 <__alltraps>

00102412 <vector136>:
.globl vector136
vector136:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $136
  102414:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102419:	e9 02 fb ff ff       	jmp    101f20 <__alltraps>

0010241e <vector137>:
.globl vector137
vector137:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $137
  102420:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102425:	e9 f6 fa ff ff       	jmp    101f20 <__alltraps>

0010242a <vector138>:
.globl vector138
vector138:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $138
  10242c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102431:	e9 ea fa ff ff       	jmp    101f20 <__alltraps>

00102436 <vector139>:
.globl vector139
vector139:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $139
  102438:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10243d:	e9 de fa ff ff       	jmp    101f20 <__alltraps>

00102442 <vector140>:
.globl vector140
vector140:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $140
  102444:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102449:	e9 d2 fa ff ff       	jmp    101f20 <__alltraps>

0010244e <vector141>:
.globl vector141
vector141:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $141
  102450:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102455:	e9 c6 fa ff ff       	jmp    101f20 <__alltraps>

0010245a <vector142>:
.globl vector142
vector142:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $142
  10245c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102461:	e9 ba fa ff ff       	jmp    101f20 <__alltraps>

00102466 <vector143>:
.globl vector143
vector143:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $143
  102468:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10246d:	e9 ae fa ff ff       	jmp    101f20 <__alltraps>

00102472 <vector144>:
.globl vector144
vector144:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $144
  102474:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102479:	e9 a2 fa ff ff       	jmp    101f20 <__alltraps>

0010247e <vector145>:
.globl vector145
vector145:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $145
  102480:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102485:	e9 96 fa ff ff       	jmp    101f20 <__alltraps>

0010248a <vector146>:
.globl vector146
vector146:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $146
  10248c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102491:	e9 8a fa ff ff       	jmp    101f20 <__alltraps>

00102496 <vector147>:
.globl vector147
vector147:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $147
  102498:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10249d:	e9 7e fa ff ff       	jmp    101f20 <__alltraps>

001024a2 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $148
  1024a4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024a9:	e9 72 fa ff ff       	jmp    101f20 <__alltraps>

001024ae <vector149>:
.globl vector149
vector149:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $149
  1024b0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024b5:	e9 66 fa ff ff       	jmp    101f20 <__alltraps>

001024ba <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $150
  1024bc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024c1:	e9 5a fa ff ff       	jmp    101f20 <__alltraps>

001024c6 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $151
  1024c8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024cd:	e9 4e fa ff ff       	jmp    101f20 <__alltraps>

001024d2 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $152
  1024d4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024d9:	e9 42 fa ff ff       	jmp    101f20 <__alltraps>

001024de <vector153>:
.globl vector153
vector153:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $153
  1024e0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024e5:	e9 36 fa ff ff       	jmp    101f20 <__alltraps>

001024ea <vector154>:
.globl vector154
vector154:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $154
  1024ec:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024f1:	e9 2a fa ff ff       	jmp    101f20 <__alltraps>

001024f6 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $155
  1024f8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024fd:	e9 1e fa ff ff       	jmp    101f20 <__alltraps>

00102502 <vector156>:
.globl vector156
vector156:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $156
  102504:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102509:	e9 12 fa ff ff       	jmp    101f20 <__alltraps>

0010250e <vector157>:
.globl vector157
vector157:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $157
  102510:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102515:	e9 06 fa ff ff       	jmp    101f20 <__alltraps>

0010251a <vector158>:
.globl vector158
vector158:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $158
  10251c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102521:	e9 fa f9 ff ff       	jmp    101f20 <__alltraps>

00102526 <vector159>:
.globl vector159
vector159:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $159
  102528:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10252d:	e9 ee f9 ff ff       	jmp    101f20 <__alltraps>

00102532 <vector160>:
.globl vector160
vector160:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $160
  102534:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102539:	e9 e2 f9 ff ff       	jmp    101f20 <__alltraps>

0010253e <vector161>:
.globl vector161
vector161:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $161
  102540:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102545:	e9 d6 f9 ff ff       	jmp    101f20 <__alltraps>

0010254a <vector162>:
.globl vector162
vector162:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $162
  10254c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102551:	e9 ca f9 ff ff       	jmp    101f20 <__alltraps>

00102556 <vector163>:
.globl vector163
vector163:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $163
  102558:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10255d:	e9 be f9 ff ff       	jmp    101f20 <__alltraps>

00102562 <vector164>:
.globl vector164
vector164:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $164
  102564:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102569:	e9 b2 f9 ff ff       	jmp    101f20 <__alltraps>

0010256e <vector165>:
.globl vector165
vector165:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $165
  102570:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102575:	e9 a6 f9 ff ff       	jmp    101f20 <__alltraps>

0010257a <vector166>:
.globl vector166
vector166:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $166
  10257c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102581:	e9 9a f9 ff ff       	jmp    101f20 <__alltraps>

00102586 <vector167>:
.globl vector167
vector167:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $167
  102588:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10258d:	e9 8e f9 ff ff       	jmp    101f20 <__alltraps>

00102592 <vector168>:
.globl vector168
vector168:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $168
  102594:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102599:	e9 82 f9 ff ff       	jmp    101f20 <__alltraps>

0010259e <vector169>:
.globl vector169
vector169:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $169
  1025a0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025a5:	e9 76 f9 ff ff       	jmp    101f20 <__alltraps>

001025aa <vector170>:
.globl vector170
vector170:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $170
  1025ac:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025b1:	e9 6a f9 ff ff       	jmp    101f20 <__alltraps>

001025b6 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $171
  1025b8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025bd:	e9 5e f9 ff ff       	jmp    101f20 <__alltraps>

001025c2 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $172
  1025c4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025c9:	e9 52 f9 ff ff       	jmp    101f20 <__alltraps>

001025ce <vector173>:
.globl vector173
vector173:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $173
  1025d0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025d5:	e9 46 f9 ff ff       	jmp    101f20 <__alltraps>

001025da <vector174>:
.globl vector174
vector174:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $174
  1025dc:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025e1:	e9 3a f9 ff ff       	jmp    101f20 <__alltraps>

001025e6 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $175
  1025e8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025ed:	e9 2e f9 ff ff       	jmp    101f20 <__alltraps>

001025f2 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $176
  1025f4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025f9:	e9 22 f9 ff ff       	jmp    101f20 <__alltraps>

001025fe <vector177>:
.globl vector177
vector177:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $177
  102600:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102605:	e9 16 f9 ff ff       	jmp    101f20 <__alltraps>

0010260a <vector178>:
.globl vector178
vector178:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $178
  10260c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102611:	e9 0a f9 ff ff       	jmp    101f20 <__alltraps>

00102616 <vector179>:
.globl vector179
vector179:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $179
  102618:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10261d:	e9 fe f8 ff ff       	jmp    101f20 <__alltraps>

00102622 <vector180>:
.globl vector180
vector180:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $180
  102624:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102629:	e9 f2 f8 ff ff       	jmp    101f20 <__alltraps>

0010262e <vector181>:
.globl vector181
vector181:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $181
  102630:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102635:	e9 e6 f8 ff ff       	jmp    101f20 <__alltraps>

0010263a <vector182>:
.globl vector182
vector182:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $182
  10263c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102641:	e9 da f8 ff ff       	jmp    101f20 <__alltraps>

00102646 <vector183>:
.globl vector183
vector183:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $183
  102648:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10264d:	e9 ce f8 ff ff       	jmp    101f20 <__alltraps>

00102652 <vector184>:
.globl vector184
vector184:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $184
  102654:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102659:	e9 c2 f8 ff ff       	jmp    101f20 <__alltraps>

0010265e <vector185>:
.globl vector185
vector185:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $185
  102660:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102665:	e9 b6 f8 ff ff       	jmp    101f20 <__alltraps>

0010266a <vector186>:
.globl vector186
vector186:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $186
  10266c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102671:	e9 aa f8 ff ff       	jmp    101f20 <__alltraps>

00102676 <vector187>:
.globl vector187
vector187:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $187
  102678:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10267d:	e9 9e f8 ff ff       	jmp    101f20 <__alltraps>

00102682 <vector188>:
.globl vector188
vector188:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $188
  102684:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102689:	e9 92 f8 ff ff       	jmp    101f20 <__alltraps>

0010268e <vector189>:
.globl vector189
vector189:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $189
  102690:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102695:	e9 86 f8 ff ff       	jmp    101f20 <__alltraps>

0010269a <vector190>:
.globl vector190
vector190:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $190
  10269c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026a1:	e9 7a f8 ff ff       	jmp    101f20 <__alltraps>

001026a6 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $191
  1026a8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026ad:	e9 6e f8 ff ff       	jmp    101f20 <__alltraps>

001026b2 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $192
  1026b4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026b9:	e9 62 f8 ff ff       	jmp    101f20 <__alltraps>

001026be <vector193>:
.globl vector193
vector193:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $193
  1026c0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026c5:	e9 56 f8 ff ff       	jmp    101f20 <__alltraps>

001026ca <vector194>:
.globl vector194
vector194:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $194
  1026cc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026d1:	e9 4a f8 ff ff       	jmp    101f20 <__alltraps>

001026d6 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $195
  1026d8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026dd:	e9 3e f8 ff ff       	jmp    101f20 <__alltraps>

001026e2 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $196
  1026e4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026e9:	e9 32 f8 ff ff       	jmp    101f20 <__alltraps>

001026ee <vector197>:
.globl vector197
vector197:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $197
  1026f0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026f5:	e9 26 f8 ff ff       	jmp    101f20 <__alltraps>

001026fa <vector198>:
.globl vector198
vector198:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $198
  1026fc:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102701:	e9 1a f8 ff ff       	jmp    101f20 <__alltraps>

00102706 <vector199>:
.globl vector199
vector199:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $199
  102708:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10270d:	e9 0e f8 ff ff       	jmp    101f20 <__alltraps>

00102712 <vector200>:
.globl vector200
vector200:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $200
  102714:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102719:	e9 02 f8 ff ff       	jmp    101f20 <__alltraps>

0010271e <vector201>:
.globl vector201
vector201:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $201
  102720:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102725:	e9 f6 f7 ff ff       	jmp    101f20 <__alltraps>

0010272a <vector202>:
.globl vector202
vector202:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $202
  10272c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102731:	e9 ea f7 ff ff       	jmp    101f20 <__alltraps>

00102736 <vector203>:
.globl vector203
vector203:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $203
  102738:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10273d:	e9 de f7 ff ff       	jmp    101f20 <__alltraps>

00102742 <vector204>:
.globl vector204
vector204:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $204
  102744:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102749:	e9 d2 f7 ff ff       	jmp    101f20 <__alltraps>

0010274e <vector205>:
.globl vector205
vector205:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $205
  102750:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102755:	e9 c6 f7 ff ff       	jmp    101f20 <__alltraps>

0010275a <vector206>:
.globl vector206
vector206:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $206
  10275c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102761:	e9 ba f7 ff ff       	jmp    101f20 <__alltraps>

00102766 <vector207>:
.globl vector207
vector207:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $207
  102768:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10276d:	e9 ae f7 ff ff       	jmp    101f20 <__alltraps>

00102772 <vector208>:
.globl vector208
vector208:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $208
  102774:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102779:	e9 a2 f7 ff ff       	jmp    101f20 <__alltraps>

0010277e <vector209>:
.globl vector209
vector209:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $209
  102780:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102785:	e9 96 f7 ff ff       	jmp    101f20 <__alltraps>

0010278a <vector210>:
.globl vector210
vector210:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $210
  10278c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102791:	e9 8a f7 ff ff       	jmp    101f20 <__alltraps>

00102796 <vector211>:
.globl vector211
vector211:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $211
  102798:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10279d:	e9 7e f7 ff ff       	jmp    101f20 <__alltraps>

001027a2 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $212
  1027a4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027a9:	e9 72 f7 ff ff       	jmp    101f20 <__alltraps>

001027ae <vector213>:
.globl vector213
vector213:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $213
  1027b0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027b5:	e9 66 f7 ff ff       	jmp    101f20 <__alltraps>

001027ba <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $214
  1027bc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027c1:	e9 5a f7 ff ff       	jmp    101f20 <__alltraps>

001027c6 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $215
  1027c8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027cd:	e9 4e f7 ff ff       	jmp    101f20 <__alltraps>

001027d2 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $216
  1027d4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027d9:	e9 42 f7 ff ff       	jmp    101f20 <__alltraps>

001027de <vector217>:
.globl vector217
vector217:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $217
  1027e0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027e5:	e9 36 f7 ff ff       	jmp    101f20 <__alltraps>

001027ea <vector218>:
.globl vector218
vector218:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $218
  1027ec:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027f1:	e9 2a f7 ff ff       	jmp    101f20 <__alltraps>

001027f6 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $219
  1027f8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027fd:	e9 1e f7 ff ff       	jmp    101f20 <__alltraps>

00102802 <vector220>:
.globl vector220
vector220:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $220
  102804:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102809:	e9 12 f7 ff ff       	jmp    101f20 <__alltraps>

0010280e <vector221>:
.globl vector221
vector221:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $221
  102810:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102815:	e9 06 f7 ff ff       	jmp    101f20 <__alltraps>

0010281a <vector222>:
.globl vector222
vector222:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $222
  10281c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102821:	e9 fa f6 ff ff       	jmp    101f20 <__alltraps>

00102826 <vector223>:
.globl vector223
vector223:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $223
  102828:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10282d:	e9 ee f6 ff ff       	jmp    101f20 <__alltraps>

00102832 <vector224>:
.globl vector224
vector224:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $224
  102834:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102839:	e9 e2 f6 ff ff       	jmp    101f20 <__alltraps>

0010283e <vector225>:
.globl vector225
vector225:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $225
  102840:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102845:	e9 d6 f6 ff ff       	jmp    101f20 <__alltraps>

0010284a <vector226>:
.globl vector226
vector226:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $226
  10284c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102851:	e9 ca f6 ff ff       	jmp    101f20 <__alltraps>

00102856 <vector227>:
.globl vector227
vector227:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $227
  102858:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10285d:	e9 be f6 ff ff       	jmp    101f20 <__alltraps>

00102862 <vector228>:
.globl vector228
vector228:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $228
  102864:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102869:	e9 b2 f6 ff ff       	jmp    101f20 <__alltraps>

0010286e <vector229>:
.globl vector229
vector229:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $229
  102870:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102875:	e9 a6 f6 ff ff       	jmp    101f20 <__alltraps>

0010287a <vector230>:
.globl vector230
vector230:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $230
  10287c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102881:	e9 9a f6 ff ff       	jmp    101f20 <__alltraps>

00102886 <vector231>:
.globl vector231
vector231:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $231
  102888:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10288d:	e9 8e f6 ff ff       	jmp    101f20 <__alltraps>

00102892 <vector232>:
.globl vector232
vector232:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $232
  102894:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102899:	e9 82 f6 ff ff       	jmp    101f20 <__alltraps>

0010289e <vector233>:
.globl vector233
vector233:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $233
  1028a0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028a5:	e9 76 f6 ff ff       	jmp    101f20 <__alltraps>

001028aa <vector234>:
.globl vector234
vector234:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $234
  1028ac:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028b1:	e9 6a f6 ff ff       	jmp    101f20 <__alltraps>

001028b6 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $235
  1028b8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028bd:	e9 5e f6 ff ff       	jmp    101f20 <__alltraps>

001028c2 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $236
  1028c4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028c9:	e9 52 f6 ff ff       	jmp    101f20 <__alltraps>

001028ce <vector237>:
.globl vector237
vector237:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $237
  1028d0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028d5:	e9 46 f6 ff ff       	jmp    101f20 <__alltraps>

001028da <vector238>:
.globl vector238
vector238:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $238
  1028dc:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028e1:	e9 3a f6 ff ff       	jmp    101f20 <__alltraps>

001028e6 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $239
  1028e8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028ed:	e9 2e f6 ff ff       	jmp    101f20 <__alltraps>

001028f2 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $240
  1028f4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028f9:	e9 22 f6 ff ff       	jmp    101f20 <__alltraps>

001028fe <vector241>:
.globl vector241
vector241:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $241
  102900:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102905:	e9 16 f6 ff ff       	jmp    101f20 <__alltraps>

0010290a <vector242>:
.globl vector242
vector242:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $242
  10290c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102911:	e9 0a f6 ff ff       	jmp    101f20 <__alltraps>

00102916 <vector243>:
.globl vector243
vector243:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $243
  102918:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10291d:	e9 fe f5 ff ff       	jmp    101f20 <__alltraps>

00102922 <vector244>:
.globl vector244
vector244:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $244
  102924:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102929:	e9 f2 f5 ff ff       	jmp    101f20 <__alltraps>

0010292e <vector245>:
.globl vector245
vector245:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $245
  102930:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102935:	e9 e6 f5 ff ff       	jmp    101f20 <__alltraps>

0010293a <vector246>:
.globl vector246
vector246:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $246
  10293c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102941:	e9 da f5 ff ff       	jmp    101f20 <__alltraps>

00102946 <vector247>:
.globl vector247
vector247:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $247
  102948:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10294d:	e9 ce f5 ff ff       	jmp    101f20 <__alltraps>

00102952 <vector248>:
.globl vector248
vector248:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $248
  102954:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102959:	e9 c2 f5 ff ff       	jmp    101f20 <__alltraps>

0010295e <vector249>:
.globl vector249
vector249:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $249
  102960:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102965:	e9 b6 f5 ff ff       	jmp    101f20 <__alltraps>

0010296a <vector250>:
.globl vector250
vector250:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $250
  10296c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102971:	e9 aa f5 ff ff       	jmp    101f20 <__alltraps>

00102976 <vector251>:
.globl vector251
vector251:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $251
  102978:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10297d:	e9 9e f5 ff ff       	jmp    101f20 <__alltraps>

00102982 <vector252>:
.globl vector252
vector252:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $252
  102984:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102989:	e9 92 f5 ff ff       	jmp    101f20 <__alltraps>

0010298e <vector253>:
.globl vector253
vector253:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $253
  102990:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102995:	e9 86 f5 ff ff       	jmp    101f20 <__alltraps>

0010299a <vector254>:
.globl vector254
vector254:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $254
  10299c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029a1:	e9 7a f5 ff ff       	jmp    101f20 <__alltraps>

001029a6 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $255
  1029a8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029ad:	e9 6e f5 ff ff       	jmp    101f20 <__alltraps>

001029b2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029b2:	55                   	push   %ebp
  1029b3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029bb:	b8 23 00 00 00       	mov    $0x23,%eax
  1029c0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029c2:	b8 23 00 00 00       	mov    $0x23,%eax
  1029c7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029c9:	b8 10 00 00 00       	mov    $0x10,%eax
  1029ce:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029d0:	b8 10 00 00 00       	mov    $0x10,%eax
  1029d5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029d7:	b8 10 00 00 00       	mov    $0x10,%eax
  1029dc:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029de:	ea e5 29 10 00 08 00 	ljmp   $0x8,$0x1029e5
}
  1029e5:	5d                   	pop    %ebp
  1029e6:	c3                   	ret    

001029e7 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029e7:	55                   	push   %ebp
  1029e8:	89 e5                	mov    %esp,%ebp
  1029ea:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029ed:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1029f2:	05 00 04 00 00       	add    $0x400,%eax
  1029f7:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029fc:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102a03:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a05:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102a0c:	68 00 
  102a0e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a13:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102a19:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a1e:	c1 e8 10             	shr    $0x10,%eax
  102a21:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a26:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a2d:	83 e0 f0             	and    $0xfffffff0,%eax
  102a30:	83 c8 09             	or     $0x9,%eax
  102a33:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a38:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a3f:	83 c8 10             	or     $0x10,%eax
  102a42:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a47:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a4e:	83 e0 9f             	and    $0xffffff9f,%eax
  102a51:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a56:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a5d:	83 c8 80             	or     $0xffffff80,%eax
  102a60:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a65:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a6c:	83 e0 f0             	and    $0xfffffff0,%eax
  102a6f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a74:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a7b:	83 e0 ef             	and    $0xffffffef,%eax
  102a7e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a83:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a8a:	83 e0 df             	and    $0xffffffdf,%eax
  102a8d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a92:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a99:	83 c8 40             	or     $0x40,%eax
  102a9c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aa1:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aa8:	83 e0 7f             	and    $0x7f,%eax
  102aab:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ab0:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ab5:	c1 e8 18             	shr    $0x18,%eax
  102ab8:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102abd:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102ac4:	83 e0 ef             	and    $0xffffffef,%eax
  102ac7:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102acc:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102ad3:	e8 da fe ff ff       	call   1029b2 <lgdt>
  102ad8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102ade:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102ae2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102ae5:	c9                   	leave  
  102ae6:	c3                   	ret    

00102ae7 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ae7:	55                   	push   %ebp
  102ae8:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102aea:	e8 f8 fe ff ff       	call   1029e7 <gdt_init>
}
  102aef:	5d                   	pop    %ebp
  102af0:	c3                   	ret    

00102af1 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102af1:	55                   	push   %ebp
  102af2:	89 e5                	mov    %esp,%ebp
  102af4:	83 ec 58             	sub    $0x58,%esp
  102af7:	8b 45 10             	mov    0x10(%ebp),%eax
  102afa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102afd:	8b 45 14             	mov    0x14(%ebp),%eax
  102b00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b09:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b0c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b0f:	8b 45 18             	mov    0x18(%ebp),%eax
  102b12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b1e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b2b:	74 1c                	je     102b49 <printnum+0x58>
  102b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b30:	ba 00 00 00 00       	mov    $0x0,%edx
  102b35:	f7 75 e4             	divl   -0x1c(%ebp)
  102b38:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  102b43:	f7 75 e4             	divl   -0x1c(%ebp)
  102b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b4f:	f7 75 e4             	divl   -0x1c(%ebp)
  102b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b55:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b61:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b67:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b6a:	8b 45 18             	mov    0x18(%ebp),%eax
  102b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  102b72:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b75:	77 56                	ja     102bcd <printnum+0xdc>
  102b77:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b7a:	72 05                	jb     102b81 <printnum+0x90>
  102b7c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b7f:	77 4c                	ja     102bcd <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b84:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b87:	8b 45 20             	mov    0x20(%ebp),%eax
  102b8a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b8e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b92:	8b 45 18             	mov    0x18(%ebp),%eax
  102b95:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ba3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bae:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb1:	89 04 24             	mov    %eax,(%esp)
  102bb4:	e8 38 ff ff ff       	call   102af1 <printnum>
  102bb9:	eb 1c                	jmp    102bd7 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bc2:	8b 45 20             	mov    0x20(%ebp),%eax
  102bc5:	89 04 24             	mov    %eax,(%esp)
  102bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcb:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102bcd:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102bd1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102bd5:	7f e4                	jg     102bbb <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102bd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bda:	05 f0 3d 10 00       	add    $0x103df0,%eax
  102bdf:	0f b6 00             	movzbl (%eax),%eax
  102be2:	0f be c0             	movsbl %al,%eax
  102be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  102be8:	89 54 24 04          	mov    %edx,0x4(%esp)
  102bec:	89 04 24             	mov    %eax,(%esp)
  102bef:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf2:	ff d0                	call   *%eax
}
  102bf4:	c9                   	leave  
  102bf5:	c3                   	ret    

00102bf6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102bf6:	55                   	push   %ebp
  102bf7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bf9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bfd:	7e 14                	jle    102c13 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102bff:	8b 45 08             	mov    0x8(%ebp),%eax
  102c02:	8b 00                	mov    (%eax),%eax
  102c04:	8d 48 08             	lea    0x8(%eax),%ecx
  102c07:	8b 55 08             	mov    0x8(%ebp),%edx
  102c0a:	89 0a                	mov    %ecx,(%edx)
  102c0c:	8b 50 04             	mov    0x4(%eax),%edx
  102c0f:	8b 00                	mov    (%eax),%eax
  102c11:	eb 30                	jmp    102c43 <getuint+0x4d>
    }
    else if (lflag) {
  102c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c17:	74 16                	je     102c2f <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c19:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1c:	8b 00                	mov    (%eax),%eax
  102c1e:	8d 48 04             	lea    0x4(%eax),%ecx
  102c21:	8b 55 08             	mov    0x8(%ebp),%edx
  102c24:	89 0a                	mov    %ecx,(%edx)
  102c26:	8b 00                	mov    (%eax),%eax
  102c28:	ba 00 00 00 00       	mov    $0x0,%edx
  102c2d:	eb 14                	jmp    102c43 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c32:	8b 00                	mov    (%eax),%eax
  102c34:	8d 48 04             	lea    0x4(%eax),%ecx
  102c37:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3a:	89 0a                	mov    %ecx,(%edx)
  102c3c:	8b 00                	mov    (%eax),%eax
  102c3e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c43:	5d                   	pop    %ebp
  102c44:	c3                   	ret    

00102c45 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c45:	55                   	push   %ebp
  102c46:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c48:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c4c:	7e 14                	jle    102c62 <getint+0x1d>
        return va_arg(*ap, long long);
  102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c51:	8b 00                	mov    (%eax),%eax
  102c53:	8d 48 08             	lea    0x8(%eax),%ecx
  102c56:	8b 55 08             	mov    0x8(%ebp),%edx
  102c59:	89 0a                	mov    %ecx,(%edx)
  102c5b:	8b 50 04             	mov    0x4(%eax),%edx
  102c5e:	8b 00                	mov    (%eax),%eax
  102c60:	eb 28                	jmp    102c8a <getint+0x45>
    }
    else if (lflag) {
  102c62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c66:	74 12                	je     102c7a <getint+0x35>
        return va_arg(*ap, long);
  102c68:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6b:	8b 00                	mov    (%eax),%eax
  102c6d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c70:	8b 55 08             	mov    0x8(%ebp),%edx
  102c73:	89 0a                	mov    %ecx,(%edx)
  102c75:	8b 00                	mov    (%eax),%eax
  102c77:	99                   	cltd   
  102c78:	eb 10                	jmp    102c8a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7d:	8b 00                	mov    (%eax),%eax
  102c7f:	8d 48 04             	lea    0x4(%eax),%ecx
  102c82:	8b 55 08             	mov    0x8(%ebp),%edx
  102c85:	89 0a                	mov    %ecx,(%edx)
  102c87:	8b 00                	mov    (%eax),%eax
  102c89:	99                   	cltd   
    }
}
  102c8a:	5d                   	pop    %ebp
  102c8b:	c3                   	ret    

00102c8c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c8c:	55                   	push   %ebp
  102c8d:	89 e5                	mov    %esp,%ebp
  102c8f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c92:	8d 45 14             	lea    0x14(%ebp),%eax
  102c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  102ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cad:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb0:	89 04 24             	mov    %eax,(%esp)
  102cb3:	e8 02 00 00 00       	call   102cba <vprintfmt>
    va_end(ap);
}
  102cb8:	c9                   	leave  
  102cb9:	c3                   	ret    

00102cba <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102cba:	55                   	push   %ebp
  102cbb:	89 e5                	mov    %esp,%ebp
  102cbd:	56                   	push   %esi
  102cbe:	53                   	push   %ebx
  102cbf:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cc2:	eb 18                	jmp    102cdc <vprintfmt+0x22>
            if (ch == '\0') {
  102cc4:	85 db                	test   %ebx,%ebx
  102cc6:	75 05                	jne    102ccd <vprintfmt+0x13>
                return;
  102cc8:	e9 d1 03 00 00       	jmp    10309e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd4:	89 1c 24             	mov    %ebx,(%esp)
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cda:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  102cdf:	8d 50 01             	lea    0x1(%eax),%edx
  102ce2:	89 55 10             	mov    %edx,0x10(%ebp)
  102ce5:	0f b6 00             	movzbl (%eax),%eax
  102ce8:	0f b6 d8             	movzbl %al,%ebx
  102ceb:	83 fb 25             	cmp    $0x25,%ebx
  102cee:	75 d4                	jne    102cc4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102cf0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102cf4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d0b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  102d11:	8d 50 01             	lea    0x1(%eax),%edx
  102d14:	89 55 10             	mov    %edx,0x10(%ebp)
  102d17:	0f b6 00             	movzbl (%eax),%eax
  102d1a:	0f b6 d8             	movzbl %al,%ebx
  102d1d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d20:	83 f8 55             	cmp    $0x55,%eax
  102d23:	0f 87 44 03 00 00    	ja     10306d <vprintfmt+0x3b3>
  102d29:	8b 04 85 14 3e 10 00 	mov    0x103e14(,%eax,4),%eax
  102d30:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d32:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d36:	eb d6                	jmp    102d0e <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d38:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d3c:	eb d0                	jmp    102d0e <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d48:	89 d0                	mov    %edx,%eax
  102d4a:	c1 e0 02             	shl    $0x2,%eax
  102d4d:	01 d0                	add    %edx,%eax
  102d4f:	01 c0                	add    %eax,%eax
  102d51:	01 d8                	add    %ebx,%eax
  102d53:	83 e8 30             	sub    $0x30,%eax
  102d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d59:	8b 45 10             	mov    0x10(%ebp),%eax
  102d5c:	0f b6 00             	movzbl (%eax),%eax
  102d5f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d62:	83 fb 2f             	cmp    $0x2f,%ebx
  102d65:	7e 0b                	jle    102d72 <vprintfmt+0xb8>
  102d67:	83 fb 39             	cmp    $0x39,%ebx
  102d6a:	7f 06                	jg     102d72 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d6c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d70:	eb d3                	jmp    102d45 <vprintfmt+0x8b>
            goto process_precision;
  102d72:	eb 33                	jmp    102da7 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d74:	8b 45 14             	mov    0x14(%ebp),%eax
  102d77:	8d 50 04             	lea    0x4(%eax),%edx
  102d7a:	89 55 14             	mov    %edx,0x14(%ebp)
  102d7d:	8b 00                	mov    (%eax),%eax
  102d7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d82:	eb 23                	jmp    102da7 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d88:	79 0c                	jns    102d96 <vprintfmt+0xdc>
                width = 0;
  102d8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d91:	e9 78 ff ff ff       	jmp    102d0e <vprintfmt+0x54>
  102d96:	e9 73 ff ff ff       	jmp    102d0e <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d9b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102da2:	e9 67 ff ff ff       	jmp    102d0e <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102da7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dab:	79 12                	jns    102dbf <vprintfmt+0x105>
                width = precision, precision = -1;
  102dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102db0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102db3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102dba:	e9 4f ff ff ff       	jmp    102d0e <vprintfmt+0x54>
  102dbf:	e9 4a ff ff ff       	jmp    102d0e <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102dc4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102dc8:	e9 41 ff ff ff       	jmp    102d0e <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  102dd0:	8d 50 04             	lea    0x4(%eax),%edx
  102dd3:	89 55 14             	mov    %edx,0x14(%ebp)
  102dd6:	8b 00                	mov    (%eax),%eax
  102dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ddb:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ddf:	89 04 24             	mov    %eax,(%esp)
  102de2:	8b 45 08             	mov    0x8(%ebp),%eax
  102de5:	ff d0                	call   *%eax
            break;
  102de7:	e9 ac 02 00 00       	jmp    103098 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102dec:	8b 45 14             	mov    0x14(%ebp),%eax
  102def:	8d 50 04             	lea    0x4(%eax),%edx
  102df2:	89 55 14             	mov    %edx,0x14(%ebp)
  102df5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102df7:	85 db                	test   %ebx,%ebx
  102df9:	79 02                	jns    102dfd <vprintfmt+0x143>
                err = -err;
  102dfb:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102dfd:	83 fb 06             	cmp    $0x6,%ebx
  102e00:	7f 0b                	jg     102e0d <vprintfmt+0x153>
  102e02:	8b 34 9d d4 3d 10 00 	mov    0x103dd4(,%ebx,4),%esi
  102e09:	85 f6                	test   %esi,%esi
  102e0b:	75 23                	jne    102e30 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102e0d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e11:	c7 44 24 08 01 3e 10 	movl   $0x103e01,0x8(%esp)
  102e18:	00 
  102e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e20:	8b 45 08             	mov    0x8(%ebp),%eax
  102e23:	89 04 24             	mov    %eax,(%esp)
  102e26:	e8 61 fe ff ff       	call   102c8c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e2b:	e9 68 02 00 00       	jmp    103098 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102e30:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e34:	c7 44 24 08 0a 3e 10 	movl   $0x103e0a,0x8(%esp)
  102e3b:	00 
  102e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e43:	8b 45 08             	mov    0x8(%ebp),%eax
  102e46:	89 04 24             	mov    %eax,(%esp)
  102e49:	e8 3e fe ff ff       	call   102c8c <printfmt>
            }
            break;
  102e4e:	e9 45 02 00 00       	jmp    103098 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e53:	8b 45 14             	mov    0x14(%ebp),%eax
  102e56:	8d 50 04             	lea    0x4(%eax),%edx
  102e59:	89 55 14             	mov    %edx,0x14(%ebp)
  102e5c:	8b 30                	mov    (%eax),%esi
  102e5e:	85 f6                	test   %esi,%esi
  102e60:	75 05                	jne    102e67 <vprintfmt+0x1ad>
                p = "(null)";
  102e62:	be 0d 3e 10 00       	mov    $0x103e0d,%esi
            }
            if (width > 0 && padc != '-') {
  102e67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e6b:	7e 3e                	jle    102eab <vprintfmt+0x1f1>
  102e6d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e71:	74 38                	je     102eab <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e73:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7d:	89 34 24             	mov    %esi,(%esp)
  102e80:	e8 15 03 00 00       	call   10319a <strnlen>
  102e85:	29 c3                	sub    %eax,%ebx
  102e87:	89 d8                	mov    %ebx,%eax
  102e89:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e8c:	eb 17                	jmp    102ea5 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e8e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e95:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e99:	89 04 24             	mov    %eax,(%esp)
  102e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ea1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ea5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ea9:	7f e3                	jg     102e8e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102eab:	eb 38                	jmp    102ee5 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ead:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102eb1:	74 1f                	je     102ed2 <vprintfmt+0x218>
  102eb3:	83 fb 1f             	cmp    $0x1f,%ebx
  102eb6:	7e 05                	jle    102ebd <vprintfmt+0x203>
  102eb8:	83 fb 7e             	cmp    $0x7e,%ebx
  102ebb:	7e 15                	jle    102ed2 <vprintfmt+0x218>
                    putch('?', putdat);
  102ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ec4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ece:	ff d0                	call   *%eax
  102ed0:	eb 0f                	jmp    102ee1 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed9:	89 1c 24             	mov    %ebx,(%esp)
  102edc:	8b 45 08             	mov    0x8(%ebp),%eax
  102edf:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ee1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ee5:	89 f0                	mov    %esi,%eax
  102ee7:	8d 70 01             	lea    0x1(%eax),%esi
  102eea:	0f b6 00             	movzbl (%eax),%eax
  102eed:	0f be d8             	movsbl %al,%ebx
  102ef0:	85 db                	test   %ebx,%ebx
  102ef2:	74 10                	je     102f04 <vprintfmt+0x24a>
  102ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ef8:	78 b3                	js     102ead <vprintfmt+0x1f3>
  102efa:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102efe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f02:	79 a9                	jns    102ead <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f04:	eb 17                	jmp    102f1d <vprintfmt+0x263>
                putch(' ', putdat);
  102f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f09:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f0d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f14:	8b 45 08             	mov    0x8(%ebp),%eax
  102f17:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f19:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f21:	7f e3                	jg     102f06 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102f23:	e9 70 01 00 00       	jmp    103098 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f2f:	8d 45 14             	lea    0x14(%ebp),%eax
  102f32:	89 04 24             	mov    %eax,(%esp)
  102f35:	e8 0b fd ff ff       	call   102c45 <getint>
  102f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f46:	85 d2                	test   %edx,%edx
  102f48:	79 26                	jns    102f70 <vprintfmt+0x2b6>
                putch('-', putdat);
  102f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f51:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f58:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5b:	ff d0                	call   *%eax
                num = -(long long)num;
  102f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f63:	f7 d8                	neg    %eax
  102f65:	83 d2 00             	adc    $0x0,%edx
  102f68:	f7 da                	neg    %edx
  102f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f77:	e9 a8 00 00 00       	jmp    103024 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f83:	8d 45 14             	lea    0x14(%ebp),%eax
  102f86:	89 04 24             	mov    %eax,(%esp)
  102f89:	e8 68 fc ff ff       	call   102bf6 <getuint>
  102f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f91:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f9b:	e9 84 00 00 00       	jmp    103024 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa7:	8d 45 14             	lea    0x14(%ebp),%eax
  102faa:	89 04 24             	mov    %eax,(%esp)
  102fad:	e8 44 fc ff ff       	call   102bf6 <getuint>
  102fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102fb8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102fbf:	eb 63                	jmp    103024 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fc8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd2:	ff d0                	call   *%eax
            putch('x', putdat);
  102fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fdb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe5:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  102fea:	8d 50 04             	lea    0x4(%eax),%edx
  102fed:	89 55 14             	mov    %edx,0x14(%ebp)
  102ff0:	8b 00                	mov    (%eax),%eax
  102ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102ffc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103003:	eb 1f                	jmp    103024 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103005:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103008:	89 44 24 04          	mov    %eax,0x4(%esp)
  10300c:	8d 45 14             	lea    0x14(%ebp),%eax
  10300f:	89 04 24             	mov    %eax,(%esp)
  103012:	e8 df fb ff ff       	call   102bf6 <getuint>
  103017:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10301a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10301d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103024:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10302b:	89 54 24 18          	mov    %edx,0x18(%esp)
  10302f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103032:	89 54 24 14          	mov    %edx,0x14(%esp)
  103036:	89 44 24 10          	mov    %eax,0x10(%esp)
  10303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103040:	89 44 24 08          	mov    %eax,0x8(%esp)
  103044:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103048:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10304f:	8b 45 08             	mov    0x8(%ebp),%eax
  103052:	89 04 24             	mov    %eax,(%esp)
  103055:	e8 97 fa ff ff       	call   102af1 <printnum>
            break;
  10305a:	eb 3c                	jmp    103098 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103063:	89 1c 24             	mov    %ebx,(%esp)
  103066:	8b 45 08             	mov    0x8(%ebp),%eax
  103069:	ff d0                	call   *%eax
            break;
  10306b:	eb 2b                	jmp    103098 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103070:	89 44 24 04          	mov    %eax,0x4(%esp)
  103074:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10307b:	8b 45 08             	mov    0x8(%ebp),%eax
  10307e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103080:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103084:	eb 04                	jmp    10308a <vprintfmt+0x3d0>
  103086:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10308a:	8b 45 10             	mov    0x10(%ebp),%eax
  10308d:	83 e8 01             	sub    $0x1,%eax
  103090:	0f b6 00             	movzbl (%eax),%eax
  103093:	3c 25                	cmp    $0x25,%al
  103095:	75 ef                	jne    103086 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103097:	90                   	nop
        }
    }
  103098:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103099:	e9 3e fc ff ff       	jmp    102cdc <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10309e:	83 c4 40             	add    $0x40,%esp
  1030a1:	5b                   	pop    %ebx
  1030a2:	5e                   	pop    %esi
  1030a3:	5d                   	pop    %ebp
  1030a4:	c3                   	ret    

001030a5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030a5:	55                   	push   %ebp
  1030a6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ab:	8b 40 08             	mov    0x8(%eax),%eax
  1030ae:	8d 50 01             	lea    0x1(%eax),%edx
  1030b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1030b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ba:	8b 10                	mov    (%eax),%edx
  1030bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bf:	8b 40 04             	mov    0x4(%eax),%eax
  1030c2:	39 c2                	cmp    %eax,%edx
  1030c4:	73 12                	jae    1030d8 <sprintputch+0x33>
        *b->buf ++ = ch;
  1030c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c9:	8b 00                	mov    (%eax),%eax
  1030cb:	8d 48 01             	lea    0x1(%eax),%ecx
  1030ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030d1:	89 0a                	mov    %ecx,(%edx)
  1030d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030d6:	88 10                	mov    %dl,(%eax)
    }
}
  1030d8:	5d                   	pop    %ebp
  1030d9:	c3                   	ret    

001030da <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030da:	55                   	push   %ebp
  1030db:	89 e5                	mov    %esp,%ebp
  1030dd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1030e0:	8d 45 14             	lea    0x14(%ebp),%eax
  1030e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1030f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fe:	89 04 24             	mov    %eax,(%esp)
  103101:	e8 08 00 00 00       	call   10310e <vsnprintf>
  103106:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103109:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10310c:	c9                   	leave  
  10310d:	c3                   	ret    

0010310e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10310e:	55                   	push   %ebp
  10310f:	89 e5                	mov    %esp,%ebp
  103111:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103114:	8b 45 08             	mov    0x8(%ebp),%eax
  103117:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10311a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10311d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103120:	8b 45 08             	mov    0x8(%ebp),%eax
  103123:	01 d0                	add    %edx,%eax
  103125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10312f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103133:	74 0a                	je     10313f <vsnprintf+0x31>
  103135:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313b:	39 c2                	cmp    %eax,%edx
  10313d:	76 07                	jbe    103146 <vsnprintf+0x38>
        return -E_INVAL;
  10313f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103144:	eb 2a                	jmp    103170 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103146:	8b 45 14             	mov    0x14(%ebp),%eax
  103149:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10314d:	8b 45 10             	mov    0x10(%ebp),%eax
  103150:	89 44 24 08          	mov    %eax,0x8(%esp)
  103154:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103157:	89 44 24 04          	mov    %eax,0x4(%esp)
  10315b:	c7 04 24 a5 30 10 00 	movl   $0x1030a5,(%esp)
  103162:	e8 53 fb ff ff       	call   102cba <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10316a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103170:	c9                   	leave  
  103171:	c3                   	ret    

00103172 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103172:	55                   	push   %ebp
  103173:	89 e5                	mov    %esp,%ebp
  103175:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10317f:	eb 04                	jmp    103185 <strlen+0x13>
        cnt ++;
  103181:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103185:	8b 45 08             	mov    0x8(%ebp),%eax
  103188:	8d 50 01             	lea    0x1(%eax),%edx
  10318b:	89 55 08             	mov    %edx,0x8(%ebp)
  10318e:	0f b6 00             	movzbl (%eax),%eax
  103191:	84 c0                	test   %al,%al
  103193:	75 ec                	jne    103181 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103198:	c9                   	leave  
  103199:	c3                   	ret    

0010319a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10319a:	55                   	push   %ebp
  10319b:	89 e5                	mov    %esp,%ebp
  10319d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031a7:	eb 04                	jmp    1031ad <strnlen+0x13>
        cnt ++;
  1031a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1031ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031b3:	73 10                	jae    1031c5 <strnlen+0x2b>
  1031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b8:	8d 50 01             	lea    0x1(%eax),%edx
  1031bb:	89 55 08             	mov    %edx,0x8(%ebp)
  1031be:	0f b6 00             	movzbl (%eax),%eax
  1031c1:	84 c0                	test   %al,%al
  1031c3:	75 e4                	jne    1031a9 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1031c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031c8:	c9                   	leave  
  1031c9:	c3                   	ret    

001031ca <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1031ca:	55                   	push   %ebp
  1031cb:	89 e5                	mov    %esp,%ebp
  1031cd:	57                   	push   %edi
  1031ce:	56                   	push   %esi
  1031cf:	83 ec 20             	sub    $0x20,%esp
  1031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031db:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1031de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031e4:	89 d1                	mov    %edx,%ecx
  1031e6:	89 c2                	mov    %eax,%edx
  1031e8:	89 ce                	mov    %ecx,%esi
  1031ea:	89 d7                	mov    %edx,%edi
  1031ec:	ac                   	lods   %ds:(%esi),%al
  1031ed:	aa                   	stos   %al,%es:(%edi)
  1031ee:	84 c0                	test   %al,%al
  1031f0:	75 fa                	jne    1031ec <strcpy+0x22>
  1031f2:	89 fa                	mov    %edi,%edx
  1031f4:	89 f1                	mov    %esi,%ecx
  1031f6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031f9:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1031fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103202:	83 c4 20             	add    $0x20,%esp
  103205:	5e                   	pop    %esi
  103206:	5f                   	pop    %edi
  103207:	5d                   	pop    %ebp
  103208:	c3                   	ret    

00103209 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103209:	55                   	push   %ebp
  10320a:	89 e5                	mov    %esp,%ebp
  10320c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10320f:	8b 45 08             	mov    0x8(%ebp),%eax
  103212:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103215:	eb 21                	jmp    103238 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103217:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321a:	0f b6 10             	movzbl (%eax),%edx
  10321d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103220:	88 10                	mov    %dl,(%eax)
  103222:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103225:	0f b6 00             	movzbl (%eax),%eax
  103228:	84 c0                	test   %al,%al
  10322a:	74 04                	je     103230 <strncpy+0x27>
            src ++;
  10322c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103230:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103234:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323c:	75 d9                	jne    103217 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  10323e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103241:	c9                   	leave  
  103242:	c3                   	ret    

00103243 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103243:	55                   	push   %ebp
  103244:	89 e5                	mov    %esp,%ebp
  103246:	57                   	push   %edi
  103247:	56                   	push   %esi
  103248:	83 ec 20             	sub    $0x20,%esp
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
  10324e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103251:	8b 45 0c             	mov    0xc(%ebp),%eax
  103254:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103257:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10325d:	89 d1                	mov    %edx,%ecx
  10325f:	89 c2                	mov    %eax,%edx
  103261:	89 ce                	mov    %ecx,%esi
  103263:	89 d7                	mov    %edx,%edi
  103265:	ac                   	lods   %ds:(%esi),%al
  103266:	ae                   	scas   %es:(%edi),%al
  103267:	75 08                	jne    103271 <strcmp+0x2e>
  103269:	84 c0                	test   %al,%al
  10326b:	75 f8                	jne    103265 <strcmp+0x22>
  10326d:	31 c0                	xor    %eax,%eax
  10326f:	eb 04                	jmp    103275 <strcmp+0x32>
  103271:	19 c0                	sbb    %eax,%eax
  103273:	0c 01                	or     $0x1,%al
  103275:	89 fa                	mov    %edi,%edx
  103277:	89 f1                	mov    %esi,%ecx
  103279:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10327c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10327f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103282:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103285:	83 c4 20             	add    $0x20,%esp
  103288:	5e                   	pop    %esi
  103289:	5f                   	pop    %edi
  10328a:	5d                   	pop    %ebp
  10328b:	c3                   	ret    

0010328c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10328c:	55                   	push   %ebp
  10328d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10328f:	eb 0c                	jmp    10329d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103291:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103295:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103299:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10329d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032a1:	74 1a                	je     1032bd <strncmp+0x31>
  1032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a6:	0f b6 00             	movzbl (%eax),%eax
  1032a9:	84 c0                	test   %al,%al
  1032ab:	74 10                	je     1032bd <strncmp+0x31>
  1032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b0:	0f b6 10             	movzbl (%eax),%edx
  1032b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b6:	0f b6 00             	movzbl (%eax),%eax
  1032b9:	38 c2                	cmp    %al,%dl
  1032bb:	74 d4                	je     103291 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032c1:	74 18                	je     1032db <strncmp+0x4f>
  1032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c6:	0f b6 00             	movzbl (%eax),%eax
  1032c9:	0f b6 d0             	movzbl %al,%edx
  1032cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032cf:	0f b6 00             	movzbl (%eax),%eax
  1032d2:	0f b6 c0             	movzbl %al,%eax
  1032d5:	29 c2                	sub    %eax,%edx
  1032d7:	89 d0                	mov    %edx,%eax
  1032d9:	eb 05                	jmp    1032e0 <strncmp+0x54>
  1032db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032e0:	5d                   	pop    %ebp
  1032e1:	c3                   	ret    

001032e2 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1032e2:	55                   	push   %ebp
  1032e3:	89 e5                	mov    %esp,%ebp
  1032e5:	83 ec 04             	sub    $0x4,%esp
  1032e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032eb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032ee:	eb 14                	jmp    103304 <strchr+0x22>
        if (*s == c) {
  1032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f3:	0f b6 00             	movzbl (%eax),%eax
  1032f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032f9:	75 05                	jne    103300 <strchr+0x1e>
            return (char *)s;
  1032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fe:	eb 13                	jmp    103313 <strchr+0x31>
        }
        s ++;
  103300:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103304:	8b 45 08             	mov    0x8(%ebp),%eax
  103307:	0f b6 00             	movzbl (%eax),%eax
  10330a:	84 c0                	test   %al,%al
  10330c:	75 e2                	jne    1032f0 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10330e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103313:	c9                   	leave  
  103314:	c3                   	ret    

00103315 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103315:	55                   	push   %ebp
  103316:	89 e5                	mov    %esp,%ebp
  103318:	83 ec 04             	sub    $0x4,%esp
  10331b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10331e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103321:	eb 11                	jmp    103334 <strfind+0x1f>
        if (*s == c) {
  103323:	8b 45 08             	mov    0x8(%ebp),%eax
  103326:	0f b6 00             	movzbl (%eax),%eax
  103329:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10332c:	75 02                	jne    103330 <strfind+0x1b>
            break;
  10332e:	eb 0e                	jmp    10333e <strfind+0x29>
        }
        s ++;
  103330:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103334:	8b 45 08             	mov    0x8(%ebp),%eax
  103337:	0f b6 00             	movzbl (%eax),%eax
  10333a:	84 c0                	test   %al,%al
  10333c:	75 e5                	jne    103323 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  10333e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103341:	c9                   	leave  
  103342:	c3                   	ret    

00103343 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103343:	55                   	push   %ebp
  103344:	89 e5                	mov    %esp,%ebp
  103346:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103350:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103357:	eb 04                	jmp    10335d <strtol+0x1a>
        s ++;
  103359:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10335d:	8b 45 08             	mov    0x8(%ebp),%eax
  103360:	0f b6 00             	movzbl (%eax),%eax
  103363:	3c 20                	cmp    $0x20,%al
  103365:	74 f2                	je     103359 <strtol+0x16>
  103367:	8b 45 08             	mov    0x8(%ebp),%eax
  10336a:	0f b6 00             	movzbl (%eax),%eax
  10336d:	3c 09                	cmp    $0x9,%al
  10336f:	74 e8                	je     103359 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103371:	8b 45 08             	mov    0x8(%ebp),%eax
  103374:	0f b6 00             	movzbl (%eax),%eax
  103377:	3c 2b                	cmp    $0x2b,%al
  103379:	75 06                	jne    103381 <strtol+0x3e>
        s ++;
  10337b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10337f:	eb 15                	jmp    103396 <strtol+0x53>
    }
    else if (*s == '-') {
  103381:	8b 45 08             	mov    0x8(%ebp),%eax
  103384:	0f b6 00             	movzbl (%eax),%eax
  103387:	3c 2d                	cmp    $0x2d,%al
  103389:	75 0b                	jne    103396 <strtol+0x53>
        s ++, neg = 1;
  10338b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10338f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103396:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10339a:	74 06                	je     1033a2 <strtol+0x5f>
  10339c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033a0:	75 24                	jne    1033c6 <strtol+0x83>
  1033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a5:	0f b6 00             	movzbl (%eax),%eax
  1033a8:	3c 30                	cmp    $0x30,%al
  1033aa:	75 1a                	jne    1033c6 <strtol+0x83>
  1033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1033af:	83 c0 01             	add    $0x1,%eax
  1033b2:	0f b6 00             	movzbl (%eax),%eax
  1033b5:	3c 78                	cmp    $0x78,%al
  1033b7:	75 0d                	jne    1033c6 <strtol+0x83>
        s += 2, base = 16;
  1033b9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1033bd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1033c4:	eb 2a                	jmp    1033f0 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1033c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033ca:	75 17                	jne    1033e3 <strtol+0xa0>
  1033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cf:	0f b6 00             	movzbl (%eax),%eax
  1033d2:	3c 30                	cmp    $0x30,%al
  1033d4:	75 0d                	jne    1033e3 <strtol+0xa0>
        s ++, base = 8;
  1033d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033da:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1033e1:	eb 0d                	jmp    1033f0 <strtol+0xad>
    }
    else if (base == 0) {
  1033e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033e7:	75 07                	jne    1033f0 <strtol+0xad>
        base = 10;
  1033e9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f3:	0f b6 00             	movzbl (%eax),%eax
  1033f6:	3c 2f                	cmp    $0x2f,%al
  1033f8:	7e 1b                	jle    103415 <strtol+0xd2>
  1033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fd:	0f b6 00             	movzbl (%eax),%eax
  103400:	3c 39                	cmp    $0x39,%al
  103402:	7f 11                	jg     103415 <strtol+0xd2>
            dig = *s - '0';
  103404:	8b 45 08             	mov    0x8(%ebp),%eax
  103407:	0f b6 00             	movzbl (%eax),%eax
  10340a:	0f be c0             	movsbl %al,%eax
  10340d:	83 e8 30             	sub    $0x30,%eax
  103410:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103413:	eb 48                	jmp    10345d <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103415:	8b 45 08             	mov    0x8(%ebp),%eax
  103418:	0f b6 00             	movzbl (%eax),%eax
  10341b:	3c 60                	cmp    $0x60,%al
  10341d:	7e 1b                	jle    10343a <strtol+0xf7>
  10341f:	8b 45 08             	mov    0x8(%ebp),%eax
  103422:	0f b6 00             	movzbl (%eax),%eax
  103425:	3c 7a                	cmp    $0x7a,%al
  103427:	7f 11                	jg     10343a <strtol+0xf7>
            dig = *s - 'a' + 10;
  103429:	8b 45 08             	mov    0x8(%ebp),%eax
  10342c:	0f b6 00             	movzbl (%eax),%eax
  10342f:	0f be c0             	movsbl %al,%eax
  103432:	83 e8 57             	sub    $0x57,%eax
  103435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103438:	eb 23                	jmp    10345d <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10343a:	8b 45 08             	mov    0x8(%ebp),%eax
  10343d:	0f b6 00             	movzbl (%eax),%eax
  103440:	3c 40                	cmp    $0x40,%al
  103442:	7e 3d                	jle    103481 <strtol+0x13e>
  103444:	8b 45 08             	mov    0x8(%ebp),%eax
  103447:	0f b6 00             	movzbl (%eax),%eax
  10344a:	3c 5a                	cmp    $0x5a,%al
  10344c:	7f 33                	jg     103481 <strtol+0x13e>
            dig = *s - 'A' + 10;
  10344e:	8b 45 08             	mov    0x8(%ebp),%eax
  103451:	0f b6 00             	movzbl (%eax),%eax
  103454:	0f be c0             	movsbl %al,%eax
  103457:	83 e8 37             	sub    $0x37,%eax
  10345a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103460:	3b 45 10             	cmp    0x10(%ebp),%eax
  103463:	7c 02                	jl     103467 <strtol+0x124>
            break;
  103465:	eb 1a                	jmp    103481 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103467:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10346b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10346e:	0f af 45 10          	imul   0x10(%ebp),%eax
  103472:	89 c2                	mov    %eax,%edx
  103474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103477:	01 d0                	add    %edx,%eax
  103479:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10347c:	e9 6f ff ff ff       	jmp    1033f0 <strtol+0xad>

    if (endptr) {
  103481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103485:	74 08                	je     10348f <strtol+0x14c>
        *endptr = (char *) s;
  103487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348a:	8b 55 08             	mov    0x8(%ebp),%edx
  10348d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10348f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103493:	74 07                	je     10349c <strtol+0x159>
  103495:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103498:	f7 d8                	neg    %eax
  10349a:	eb 03                	jmp    10349f <strtol+0x15c>
  10349c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10349f:	c9                   	leave  
  1034a0:	c3                   	ret    

001034a1 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034a1:	55                   	push   %ebp
  1034a2:	89 e5                	mov    %esp,%ebp
  1034a4:	57                   	push   %edi
  1034a5:	83 ec 24             	sub    $0x24,%esp
  1034a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ab:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1034ae:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1034b2:	8b 55 08             	mov    0x8(%ebp),%edx
  1034b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1034b8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1034bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1034be:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1034c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034c4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1034c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1034cb:	89 d7                	mov    %edx,%edi
  1034cd:	f3 aa                	rep stos %al,%es:(%edi)
  1034cf:	89 fa                	mov    %edi,%edx
  1034d1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1034d4:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034da:	83 c4 24             	add    $0x24,%esp
  1034dd:	5f                   	pop    %edi
  1034de:	5d                   	pop    %ebp
  1034df:	c3                   	ret    

001034e0 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1034e0:	55                   	push   %ebp
  1034e1:	89 e5                	mov    %esp,%ebp
  1034e3:	57                   	push   %edi
  1034e4:	56                   	push   %esi
  1034e5:	53                   	push   %ebx
  1034e6:	83 ec 30             	sub    $0x30,%esp
  1034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1034f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103501:	73 42                	jae    103545 <memmove+0x65>
  103503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10350c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10350f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103512:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103518:	c1 e8 02             	shr    $0x2,%eax
  10351b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10351d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103523:	89 d7                	mov    %edx,%edi
  103525:	89 c6                	mov    %eax,%esi
  103527:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103529:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10352c:	83 e1 03             	and    $0x3,%ecx
  10352f:	74 02                	je     103533 <memmove+0x53>
  103531:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103533:	89 f0                	mov    %esi,%eax
  103535:	89 fa                	mov    %edi,%edx
  103537:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10353a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10353d:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103543:	eb 36                	jmp    10357b <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103548:	8d 50 ff             	lea    -0x1(%eax),%edx
  10354b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10354e:	01 c2                	add    %eax,%edx
  103550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103553:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103559:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10355c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10355f:	89 c1                	mov    %eax,%ecx
  103561:	89 d8                	mov    %ebx,%eax
  103563:	89 d6                	mov    %edx,%esi
  103565:	89 c7                	mov    %eax,%edi
  103567:	fd                   	std    
  103568:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10356a:	fc                   	cld    
  10356b:	89 f8                	mov    %edi,%eax
  10356d:	89 f2                	mov    %esi,%edx
  10356f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103572:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103575:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103578:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10357b:	83 c4 30             	add    $0x30,%esp
  10357e:	5b                   	pop    %ebx
  10357f:	5e                   	pop    %esi
  103580:	5f                   	pop    %edi
  103581:	5d                   	pop    %ebp
  103582:	c3                   	ret    

00103583 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103583:	55                   	push   %ebp
  103584:	89 e5                	mov    %esp,%ebp
  103586:	57                   	push   %edi
  103587:	56                   	push   %esi
  103588:	83 ec 20             	sub    $0x20,%esp
  10358b:	8b 45 08             	mov    0x8(%ebp),%eax
  10358e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103591:	8b 45 0c             	mov    0xc(%ebp),%eax
  103594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103597:	8b 45 10             	mov    0x10(%ebp),%eax
  10359a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10359d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a0:	c1 e8 02             	shr    $0x2,%eax
  1035a3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1035a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ab:	89 d7                	mov    %edx,%edi
  1035ad:	89 c6                	mov    %eax,%esi
  1035af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035b1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1035b4:	83 e1 03             	and    $0x3,%ecx
  1035b7:	74 02                	je     1035bb <memcpy+0x38>
  1035b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035bb:	89 f0                	mov    %esi,%eax
  1035bd:	89 fa                	mov    %edi,%edx
  1035bf:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1035c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1035c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1035cb:	83 c4 20             	add    $0x20,%esp
  1035ce:	5e                   	pop    %esi
  1035cf:	5f                   	pop    %edi
  1035d0:	5d                   	pop    %ebp
  1035d1:	c3                   	ret    

001035d2 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1035d2:	55                   	push   %ebp
  1035d3:	89 e5                	mov    %esp,%ebp
  1035d5:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1035db:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1035de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1035e4:	eb 30                	jmp    103616 <memcmp+0x44>
        if (*s1 != *s2) {
  1035e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035e9:	0f b6 10             	movzbl (%eax),%edx
  1035ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035ef:	0f b6 00             	movzbl (%eax),%eax
  1035f2:	38 c2                	cmp    %al,%dl
  1035f4:	74 18                	je     10360e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1035f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035f9:	0f b6 00             	movzbl (%eax),%eax
  1035fc:	0f b6 d0             	movzbl %al,%edx
  1035ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103602:	0f b6 00             	movzbl (%eax),%eax
  103605:	0f b6 c0             	movzbl %al,%eax
  103608:	29 c2                	sub    %eax,%edx
  10360a:	89 d0                	mov    %edx,%eax
  10360c:	eb 1a                	jmp    103628 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10360e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103612:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103616:	8b 45 10             	mov    0x10(%ebp),%eax
  103619:	8d 50 ff             	lea    -0x1(%eax),%edx
  10361c:	89 55 10             	mov    %edx,0x10(%ebp)
  10361f:	85 c0                	test   %eax,%eax
  103621:	75 c3                	jne    1035e6 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103628:	c9                   	leave  
  103629:	c3                   	ret    
