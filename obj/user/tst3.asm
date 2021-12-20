
obj/user/tst3:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 7a 05 00 00       	call   8005b0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 7c             	sub    $0x7c,%esp
	

	rsttst();
  800041:	e8 31 1d 00 00       	call   801d77 <rsttst>
	
	

	int Mega = 1024*1024;
  800046:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80004d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  800054:	e8 e1 19 00 00       	call   801a3a <sys_calculate_free_frames>
  800059:	89 45 dc             	mov    %eax,-0x24(%ebp)

	void* ptr_allocations[20] = {0};
  80005c:	8d 55 84             	lea    -0x7c(%ebp),%edx
  80005f:	b9 14 00 00 00       	mov    $0x14,%ecx
  800064:	b8 00 00 00 00       	mov    $0x0,%eax
  800069:	89 d7                	mov    %edx,%edi
  80006b:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  80006d:	e8 c8 19 00 00       	call   801a3a <sys_calculate_free_frames>
  800072:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800078:	01 c0                	add    %eax,%eax
  80007a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80007d:	83 ec 0c             	sub    $0xc,%esp
  800080:	50                   	push   %eax
  800081:	e8 cd 14 00 00       	call   801553 <malloc>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 84             	mov    %eax,-0x7c(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  80008c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	6a 62                	push   $0x62
  800096:	68 00 10 00 80       	push   $0x80001000
  80009b:	68 00 00 00 80       	push   $0x80000000
  8000a0:	50                   	push   %eax
  8000a1:	e8 eb 1c 00 00       	call   801d91 <tst>
  8000a6:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000a9:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8000ac:	e8 89 19 00 00       	call   801a3a <sys_calculate_free_frames>
  8000b1:	29 c3                	sub    %eax,%ebx
  8000b3:	89 d8                	mov    %ebx,%eax
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	6a 00                	push   $0x0
  8000ba:	6a 65                	push   $0x65
  8000bc:	6a 00                	push   $0x0
  8000be:	68 01 02 00 00       	push   $0x201
  8000c3:	50                   	push   %eax
  8000c4:	e8 c8 1c 00 00       	call   801d91 <tst>
  8000c9:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 69 19 00 00       	call   801a3a <sys_calculate_free_frames>
  8000d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 6e 14 00 00       	call   801553 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  8000eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ee:	01 c0                	add    %eax,%eax
  8000f0:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8000f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f9:	01 c0                	add    %eax,%eax
  8000fb:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800101:	8b 45 88             	mov    -0x78(%ebp),%eax
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	6a 00                	push   $0x0
  800109:	6a 62                	push   $0x62
  80010b:	51                   	push   %ecx
  80010c:	52                   	push   %edx
  80010d:	50                   	push   %eax
  80010e:	e8 7e 1c 00 00       	call   801d91 <tst>
  800113:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800116:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800119:	e8 1c 19 00 00       	call   801a3a <sys_calculate_free_frames>
  80011e:	29 c3                	sub    %eax,%ebx
  800120:	89 d8                	mov    %ebx,%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	6a 00                	push   $0x0
  800127:	6a 65                	push   $0x65
  800129:	6a 00                	push   $0x0
  80012b:	68 00 02 00 00       	push   $0x200
  800130:	50                   	push   %eax
  800131:	e8 5b 1c 00 00       	call   801d91 <tst>
  800136:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800139:	e8 fc 18 00 00       	call   801a3a <sys_calculate_free_frames>
  80013e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800141:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800144:	01 c0                	add    %eax,%eax
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	50                   	push   %eax
  80014a:	e8 04 14 00 00       	call   801553 <malloc>
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800158:	c1 e0 02             	shl    $0x2,%eax
  80015b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800164:	c1 e0 02             	shl    $0x2,%eax
  800167:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80016d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	6a 00                	push   $0x0
  800175:	6a 62                	push   $0x62
  800177:	51                   	push   %ecx
  800178:	52                   	push   %edx
  800179:	50                   	push   %eax
  80017a:	e8 12 1c 00 00       	call   801d91 <tst>
  80017f:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  800182:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800185:	e8 b0 18 00 00       	call   801a3a <sys_calculate_free_frames>
  80018a:	29 c3                	sub    %eax,%ebx
  80018c:	89 d8                	mov    %ebx,%eax
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	6a 65                	push   $0x65
  800195:	6a 00                	push   $0x0
  800197:	6a 02                	push   $0x2
  800199:	50                   	push   %eax
  80019a:	e8 f2 1b 00 00       	call   801d91 <tst>
  80019f:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8001a2:	e8 93 18 00 00       	call   801a3a <sys_calculate_free_frames>
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	50                   	push   %eax
  8001b3:	e8 9b 13 00 00       	call   801553 <malloc>
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega + 4*kilo,USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE, 'b', 0);
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	c1 e0 02             	shl    $0x2,%eax
  8001c4:	89 c2                	mov    %eax,%edx
  8001c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c9:	c1 e0 02             	shl    $0x2,%eax
  8001cc:	01 d0                	add    %edx,%eax
  8001ce:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d7:	c1 e0 02             	shl    $0x2,%eax
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c1 e0 02             	shl    $0x2,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001ea:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	6a 00                	push   $0x0
  8001f2:	6a 62                	push   $0x62
  8001f4:	51                   	push   %ecx
  8001f5:	52                   	push   %edx
  8001f6:	50                   	push   %eax
  8001f7:	e8 95 1b 00 00       	call   801d91 <tst>
  8001fc:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  8001ff:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800202:	e8 33 18 00 00       	call   801a3a <sys_calculate_free_frames>
  800207:	29 c3                	sub    %eax,%ebx
  800209:	89 d8                	mov    %ebx,%eax
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	6a 00                	push   $0x0
  800210:	6a 65                	push   $0x65
  800212:	6a 00                	push   $0x0
  800214:	6a 01                	push   $0x1
  800216:	50                   	push   %eax
  800217:	e8 75 1b 00 00       	call   801d91 <tst>
  80021c:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80021f:	e8 16 18 00 00       	call   801a3a <sys_calculate_free_frames>
  800224:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800227:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80022a:	89 d0                	mov    %edx,%eax
  80022c:	01 c0                	add    %eax,%eax
  80022e:	01 d0                	add    %edx,%eax
  800230:	01 c0                	add    %eax,%eax
  800232:	01 d0                	add    %edx,%eax
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	50                   	push   %eax
  800238:	e8 16 13 00 00       	call   801553 <malloc>
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega + 8*kilo,USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE, 'b', 0);
  800243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800246:	c1 e0 02             	shl    $0x2,%eax
  800249:	89 c2                	mov    %eax,%edx
  80024b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024e:	c1 e0 03             	shl    $0x3,%eax
  800251:	01 d0                	add    %edx,%eax
  800253:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025c:	c1 e0 02             	shl    $0x2,%eax
  80025f:	89 c2                	mov    %eax,%edx
  800261:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800264:	c1 e0 03             	shl    $0x3,%eax
  800267:	01 d0                	add    %edx,%eax
  800269:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80026f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	6a 62                	push   $0x62
  800279:	51                   	push   %ecx
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	e8 10 1b 00 00       	call   801d91 <tst>
  800281:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2 ,0, 'e', 0);
  800284:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800287:	e8 ae 17 00 00       	call   801a3a <sys_calculate_free_frames>
  80028c:	29 c3                	sub    %eax,%ebx
  80028e:	89 d8                	mov    %ebx,%eax
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 00                	push   $0x0
  800295:	6a 65                	push   $0x65
  800297:	6a 00                	push   $0x0
  800299:	6a 02                	push   $0x2
  80029b:	50                   	push   %eax
  80029c:	e8 f0 1a 00 00       	call   801d91 <tst>
  8002a1:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8002a4:	e8 91 17 00 00       	call   801a3a <sys_calculate_free_frames>
  8002a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8002ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 92 12 00 00       	call   801553 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega + 16*kilo,USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  8002c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ca:	c1 e0 02             	shl    $0x2,%eax
  8002cd:	89 c2                	mov    %eax,%edx
  8002cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d2:	c1 e0 04             	shl    $0x4,%eax
  8002d5:	01 d0                	add    %edx,%eax
  8002d7:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e0:	c1 e0 02             	shl    $0x2,%eax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e8:	c1 e0 04             	shl    $0x4,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002f3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	6a 00                	push   $0x0
  8002fb:	6a 62                	push   $0x62
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	e8 8c 1a 00 00       	call   801d91 <tst>
  800305:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  800308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030b:	89 c2                	mov    %eax,%edx
  80030d:	01 d2                	add    %edx,%edx
  80030f:	01 d0                	add    %edx,%eax
  800311:	85 c0                	test   %eax,%eax
  800313:	79 05                	jns    80031a <_main+0x2e2>
  800315:	05 ff 0f 00 00       	add    $0xfff,%eax
  80031a:	c1 f8 0c             	sar    $0xc,%eax
  80031d:	89 c3                	mov    %eax,%ebx
  80031f:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800322:	e8 13 17 00 00       	call   801a3a <sys_calculate_free_frames>
  800327:	29 c6                	sub    %eax,%esi
  800329:	89 f0                	mov    %esi,%eax
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	6a 00                	push   $0x0
  800330:	6a 65                	push   $0x65
  800332:	6a 00                	push   $0x0
  800334:	53                   	push   %ebx
  800335:	50                   	push   %eax
  800336:	e8 56 1a 00 00       	call   801d91 <tst>
  80033b:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80033e:	e8 f7 16 00 00       	call   801a3a <sys_calculate_free_frames>
  800343:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800349:	01 c0                	add    %eax,%eax
  80034b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 fc 11 00 00       	call   801553 <malloc>
  800357:	83 c4 10             	add    $0x10,%esp
  80035a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega + 16*kilo,USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  80035d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	89 c2                	mov    %eax,%edx
  80036c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036f:	c1 e0 04             	shl    $0x4,%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80037a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80037d:	89 d0                	mov    %edx,%eax
  80037f:	01 c0                	add    %eax,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	89 c2                	mov    %eax,%edx
  800389:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038c:	c1 e0 04             	shl    $0x4,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800397:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	6a 00                	push   $0x0
  80039f:	6a 62                	push   $0x62
  8003a1:	51                   	push   %ecx
  8003a2:	52                   	push   %edx
  8003a3:	50                   	push   %eax
  8003a4:	e8 e8 19 00 00       	call   801d91 <tst>
  8003a9:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8003ac:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8003af:	e8 86 16 00 00       	call   801a3a <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 ec 0c             	sub    $0xc,%esp
  8003bb:	6a 00                	push   $0x0
  8003bd:	6a 65                	push   $0x65
  8003bf:	6a 00                	push   $0x0
  8003c1:	68 01 02 00 00       	push   $0x201
  8003c6:	50                   	push   %eax
  8003c7:	e8 c5 19 00 00       	call   801d91 <tst>
  8003cc:	83 c4 20             	add    $0x20,%esp
	}

	{
		int freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 66 16 00 00       	call   801a3a <sys_calculate_free_frames>
  8003d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  8003d7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	50                   	push   %eax
  8003de:	e8 80 13 00 00       	call   801763 <free>
  8003e3:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 ,0, 'e', 0);
  8003e6:	e8 4f 16 00 00       	call   801a3a <sys_calculate_free_frames>
  8003eb:	89 c2                	mov    %eax,%edx
  8003ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f0:	29 c2                	sub    %eax,%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	6a 00                	push   $0x0
  8003f9:	6a 65                	push   $0x65
  8003fb:	6a 00                	push   $0x0
  8003fd:	68 00 02 00 00       	push   $0x200
  800402:	50                   	push   %eax
  800403:	e8 89 19 00 00       	call   801d91 <tst>
  800408:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80040b:	e8 2a 16 00 00       	call   801a3a <sys_calculate_free_frames>
  800410:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800413:	8b 45 88             	mov    -0x78(%ebp),%eax
  800416:	83 ec 0c             	sub    $0xc,%esp
  800419:	50                   	push   %eax
  80041a:	e8 44 13 00 00       	call   801763 <free>
  80041f:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512+1 ,0, 'e', 0);
  800422:	e8 13 16 00 00       	call   801a3a <sys_calculate_free_frames>
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042c:	29 c2                	sub    %eax,%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	6a 00                	push   $0x0
  800435:	6a 65                	push   $0x65
  800437:	6a 00                	push   $0x0
  800439:	68 01 02 00 00       	push   $0x201
  80043e:	50                   	push   %eax
  80043f:	e8 4d 19 00 00       	call   801d91 <tst>
  800444:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800447:	e8 ee 15 00 00       	call   801a3a <sys_calculate_free_frames>
  80044c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80044f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800452:	83 ec 0c             	sub    $0xc,%esp
  800455:	50                   	push   %eax
  800456:	e8 08 13 00 00       	call   801763 <free>
  80045b:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  80045e:	e8 d7 15 00 00       	call   801a3a <sys_calculate_free_frames>
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	29 c2                	sub    %eax,%edx
  80046a:	89 d0                	mov    %edx,%eax
  80046c:	83 ec 0c             	sub    $0xc,%esp
  80046f:	6a 00                	push   $0x0
  800471:	6a 65                	push   $0x65
  800473:	6a 00                	push   $0x0
  800475:	6a 01                	push   $0x1
  800477:	50                   	push   %eax
  800478:	e8 14 19 00 00       	call   801d91 <tst>
  80047d:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800480:	e8 b5 15 00 00       	call   801a3a <sys_calculate_free_frames>
  800485:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800488:	8b 45 90             	mov    -0x70(%ebp),%eax
  80048b:	83 ec 0c             	sub    $0xc,%esp
  80048e:	50                   	push   %eax
  80048f:	e8 cf 12 00 00       	call   801763 <free>
  800494:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  800497:	e8 9e 15 00 00       	call   801a3a <sys_calculate_free_frames>
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	89 d0                	mov    %edx,%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	6a 00                	push   $0x0
  8004aa:	6a 65                	push   $0x65
  8004ac:	6a 00                	push   $0x0
  8004ae:	6a 01                	push   $0x1
  8004b0:	50                   	push   %eax
  8004b1:	e8 db 18 00 00       	call   801d91 <tst>
  8004b6:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8004b9:	e8 7c 15 00 00       	call   801a3a <sys_calculate_free_frames>
  8004be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  8004c1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	50                   	push   %eax
  8004c8:	e8 96 12 00 00       	call   801763 <free>
  8004cd:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 2 ,0, 'e', 0);
  8004d0:	e8 65 15 00 00       	call   801a3a <sys_calculate_free_frames>
  8004d5:	89 c2                	mov    %eax,%edx
  8004d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004da:	29 c2                	sub    %eax,%edx
  8004dc:	89 d0                	mov    %edx,%eax
  8004de:	83 ec 0c             	sub    $0xc,%esp
  8004e1:	6a 00                	push   $0x0
  8004e3:	6a 65                	push   $0x65
  8004e5:	6a 00                	push   $0x0
  8004e7:	6a 02                	push   $0x2
  8004e9:	50                   	push   %eax
  8004ea:	e8 a2 18 00 00       	call   801d91 <tst>
  8004ef:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8004f2:	e8 43 15 00 00       	call   801a3a <sys_calculate_free_frames>
  8004f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8004fa:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004fd:	83 ec 0c             	sub    $0xc,%esp
  800500:	50                   	push   %eax
  800501:	e8 5d 12 00 00       	call   801763 <free>
  800506:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 3*Mega/4096,0, 'e', 0);
  800509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	01 d2                	add    %edx,%edx
  800510:	01 d0                	add    %edx,%eax
  800512:	85 c0                	test   %eax,%eax
  800514:	79 05                	jns    80051b <_main+0x4e3>
  800516:	05 ff 0f 00 00       	add    $0xfff,%eax
  80051b:	c1 f8 0c             	sar    $0xc,%eax
  80051e:	89 c3                	mov    %eax,%ebx
  800520:	e8 15 15 00 00       	call   801a3a <sys_calculate_free_frames>
  800525:	89 c2                	mov    %eax,%edx
  800527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052a:	29 c2                	sub    %eax,%edx
  80052c:	89 d0                	mov    %edx,%eax
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	6a 00                	push   $0x0
  800533:	6a 65                	push   $0x65
  800535:	6a 00                	push   $0x0
  800537:	53                   	push   %ebx
  800538:	50                   	push   %eax
  800539:	e8 53 18 00 00       	call   801d91 <tst>
  80053e:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800541:	e8 f4 14 00 00       	call   801a3a <sys_calculate_free_frames>
  800546:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800549:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 0e 12 00 00       	call   801763 <free>
  800555:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512+2 ,0, 'e', 0);
  800558:	e8 dd 14 00 00       	call   801a3a <sys_calculate_free_frames>
  80055d:	89 c2                	mov    %eax,%edx
  80055f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800562:	29 c2                	sub    %eax,%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	6a 00                	push   $0x0
  80056b:	6a 65                	push   $0x65
  80056d:	6a 00                	push   $0x0
  80056f:	68 02 02 00 00       	push   $0x202
  800574:	50                   	push   %eax
  800575:	e8 17 18 00 00       	call   801d91 <tst>
  80057a:	83 c4 20             	add    $0x20,%esp

		tst(start_freeFrames, sys_calculate_free_frames() ,0, 'e', 0);
  80057d:	e8 b8 14 00 00       	call   801a3a <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	6a 00                	push   $0x0
  80058c:	6a 65                	push   $0x65
  80058e:	6a 00                	push   $0x0
  800590:	52                   	push   %edx
  800591:	50                   	push   %eax
  800592:	e8 fa 17 00 00       	call   801d91 <tst>
  800597:	83 c4 20             	add    $0x20,%esp

	}

	chktst(22);
  80059a:	83 ec 0c             	sub    $0xc,%esp
  80059d:	6a 16                	push   $0x16
  80059f:	e8 18 18 00 00       	call   801dbc <chktst>
  8005a4:	83 c4 10             	add    $0x10,%esp

	return;
  8005a7:	90                   	nop
}
  8005a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ab:	5b                   	pop    %ebx
  8005ac:	5e                   	pop    %esi
  8005ad:	5f                   	pop    %edi
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005b6:	e8 b4 13 00 00       	call   80196f <sys_getenvindex>
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005c1:	89 d0                	mov    %edx,%eax
  8005c3:	c1 e0 03             	shl    $0x3,%eax
  8005c6:	01 d0                	add    %edx,%eax
  8005c8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005cf:	01 c8                	add    %ecx,%eax
  8005d1:	01 c0                	add    %eax,%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	01 c0                	add    %eax,%eax
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	89 c2                	mov    %eax,%edx
  8005db:	c1 e2 05             	shl    $0x5,%edx
  8005de:	29 c2                	sub    %eax,%edx
  8005e0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8005e7:	89 c2                	mov    %eax,%edx
  8005e9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005ef:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f9:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005ff:	84 c0                	test   %al,%al
  800601:	74 0f                	je     800612 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800603:	a1 20 30 80 00       	mov    0x803020,%eax
  800608:	05 40 3c 01 00       	add    $0x13c40,%eax
  80060d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800616:	7e 0a                	jle    800622 <libmain+0x72>
		binaryname = argv[0];
  800618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 08             	pushl  0x8(%ebp)
  80062b:	e8 08 fa ff ff       	call   800038 <_main>
  800630:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800633:	e8 d2 14 00 00       	call   801b0a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800638:	83 ec 0c             	sub    $0xc,%esp
  80063b:	68 78 23 80 00       	push   $0x802378
  800640:	e8 84 01 00 00       	call   8007c9 <cprintf>
  800645:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800648:	a1 20 30 80 00       	mov    0x803020,%eax
  80064d:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800653:	a1 20 30 80 00       	mov    0x803020,%eax
  800658:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	52                   	push   %edx
  800662:	50                   	push   %eax
  800663:	68 a0 23 80 00       	push   $0x8023a0
  800668:	e8 5c 01 00 00       	call   8007c9 <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800670:	a1 20 30 80 00       	mov    0x803020,%eax
  800675:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80067b:	a1 20 30 80 00       	mov    0x803020,%eax
  800680:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 c8 23 80 00       	push   $0x8023c8
  800690:	e8 34 01 00 00       	call   8007c9 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800698:	a1 20 30 80 00       	mov    0x803020,%eax
  80069d:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	50                   	push   %eax
  8006a7:	68 09 24 80 00       	push   $0x802409
  8006ac:	e8 18 01 00 00       	call   8007c9 <cprintf>
  8006b1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	68 78 23 80 00       	push   $0x802378
  8006bc:	e8 08 01 00 00       	call   8007c9 <cprintf>
  8006c1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006c4:	e8 5b 14 00 00       	call   801b24 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006c9:	e8 19 00 00 00       	call   8006e7 <exit>
}
  8006ce:	90                   	nop
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	6a 00                	push   $0x0
  8006dc:	e8 5a 12 00 00       	call   80193b <sys_env_destroy>
  8006e1:	83 c4 10             	add    $0x10,%esp
}
  8006e4:	90                   	nop
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <exit>:

void
exit(void)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006ed:	e8 af 12 00 00       	call   8019a1 <sys_env_exit>
}
  8006f2:	90                   	nop
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 48 01             	lea    0x1(%eax),%ecx
  800703:	8b 55 0c             	mov    0xc(%ebp),%edx
  800706:	89 0a                	mov    %ecx,(%edx)
  800708:	8b 55 08             	mov    0x8(%ebp),%edx
  80070b:	88 d1                	mov    %dl,%cl
  80070d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800710:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071e:	75 2c                	jne    80074c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800720:	a0 24 30 80 00       	mov    0x803024,%al
  800725:	0f b6 c0             	movzbl %al,%eax
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	8b 12                	mov    (%edx),%edx
  80072d:	89 d1                	mov    %edx,%ecx
  80072f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800732:	83 c2 08             	add    $0x8,%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	51                   	push   %ecx
  80073a:	52                   	push   %edx
  80073b:	e8 b9 11 00 00       	call   8018f9 <sys_cputs>
  800740:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800743:	8b 45 0c             	mov    0xc(%ebp),%eax
  800746:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	8b 40 04             	mov    0x4(%eax),%eax
  800752:	8d 50 01             	lea    0x1(%eax),%edx
  800755:	8b 45 0c             	mov    0xc(%ebp),%eax
  800758:	89 50 04             	mov    %edx,0x4(%eax)
}
  80075b:	90                   	nop
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    

0080075e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800767:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80076e:	00 00 00 
	b.cnt = 0;
  800771:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800778:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	ff 75 08             	pushl  0x8(%ebp)
  800781:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800787:	50                   	push   %eax
  800788:	68 f5 06 80 00       	push   $0x8006f5
  80078d:	e8 11 02 00 00       	call   8009a3 <vprintfmt>
  800792:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800795:	a0 24 30 80 00       	mov    0x803024,%al
  80079a:	0f b6 c0             	movzbl %al,%eax
  80079d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007a3:	83 ec 04             	sub    $0x4,%esp
  8007a6:	50                   	push   %eax
  8007a7:	52                   	push   %edx
  8007a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ae:	83 c0 08             	add    $0x8,%eax
  8007b1:	50                   	push   %eax
  8007b2:	e8 42 11 00 00       	call   8018f9 <sys_cputs>
  8007b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ba:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007cf:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e5:	50                   	push   %eax
  8007e6:	e8 73 ff ff ff       	call   80075e <vcprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    

008007f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007fc:	e8 09 13 00 00       	call   801b0a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800801:	8d 45 0c             	lea    0xc(%ebp),%eax
  800804:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 f4             	pushl  -0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	e8 48 ff ff ff       	call   80075e <vcprintf>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80081c:	e8 03 13 00 00       	call   801b24 <sys_enable_interrupt>
	return cnt;
  800821:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    

00800826 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	53                   	push   %ebx
  80082a:	83 ec 14             	sub    $0x14,%esp
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800839:	8b 45 18             	mov    0x18(%ebp),%eax
  80083c:	ba 00 00 00 00       	mov    $0x0,%edx
  800841:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800844:	77 55                	ja     80089b <printnum+0x75>
  800846:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800849:	72 05                	jb     800850 <printnum+0x2a>
  80084b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80084e:	77 4b                	ja     80089b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800850:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800853:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800856:	8b 45 18             	mov    0x18(%ebp),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	ff 75 f4             	pushl  -0xc(%ebp)
  800863:	ff 75 f0             	pushl  -0x10(%ebp)
  800866:	e8 91 18 00 00       	call   8020fc <__udivdi3>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	83 ec 04             	sub    $0x4,%esp
  800871:	ff 75 20             	pushl  0x20(%ebp)
  800874:	53                   	push   %ebx
  800875:	ff 75 18             	pushl  0x18(%ebp)
  800878:	52                   	push   %edx
  800879:	50                   	push   %eax
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	ff 75 08             	pushl  0x8(%ebp)
  800880:	e8 a1 ff ff ff       	call   800826 <printnum>
  800885:	83 c4 20             	add    $0x20,%esp
  800888:	eb 1a                	jmp    8008a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 20             	pushl  0x20(%ebp)
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089b:	ff 4d 1c             	decl   0x1c(%ebp)
  80089e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008a2:	7f e6                	jg     80088a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b2:	53                   	push   %ebx
  8008b3:	51                   	push   %ecx
  8008b4:	52                   	push   %edx
  8008b5:	50                   	push   %eax
  8008b6:	e8 51 19 00 00       	call   80220c <__umoddi3>
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	05 34 26 80 00       	add    $0x802634,%eax
  8008c3:	8a 00                	mov    (%eax),%al
  8008c5:	0f be c0             	movsbl %al,%eax
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
}
  8008d7:	90                   	nop
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e4:	7e 1c                	jle    800902 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	8d 50 08             	lea    0x8(%eax),%edx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	89 10                	mov    %edx,(%eax)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	83 e8 08             	sub    $0x8,%eax
  8008fb:	8b 50 04             	mov    0x4(%eax),%edx
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	eb 40                	jmp    800942 <getuint+0x65>
	else if (lflag)
  800902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800906:	74 1e                	je     800926 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	8d 50 04             	lea    0x4(%eax),%edx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 10                	mov    %edx,(%eax)
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	83 e8 04             	sub    $0x4,%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	eb 1c                	jmp    800942 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 50 04             	lea    0x4(%eax),%edx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 10                	mov    %edx,(%eax)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800947:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80094b:	7e 1c                	jle    800969 <getint+0x25>
		return va_arg(*ap, long long);
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	8d 50 08             	lea    0x8(%eax),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 10                	mov    %edx,(%eax)
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	83 e8 08             	sub    $0x8,%eax
  800962:	8b 50 04             	mov    0x4(%eax),%edx
  800965:	8b 00                	mov    (%eax),%eax
  800967:	eb 38                	jmp    8009a1 <getint+0x5d>
	else if (lflag)
  800969:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096d:	74 1a                	je     800989 <getint+0x45>
		return va_arg(*ap, long);
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 10                	mov    %edx,(%eax)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	83 e8 04             	sub    $0x4,%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	99                   	cltd   
  800987:	eb 18                	jmp    8009a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	8d 50 04             	lea    0x4(%eax),%edx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 10                	mov    %edx,(%eax)
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	83 e8 04             	sub    $0x4,%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	99                   	cltd   
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	eb 17                	jmp    8009c4 <vprintfmt+0x21>
			if (ch == '\0')
  8009ad:	85 db                	test   %ebx,%ebx
  8009af:	0f 84 af 03 00 00    	je     800d64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	53                   	push   %ebx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8009cd:	8a 00                	mov    (%eax),%al
  8009cf:	0f b6 d8             	movzbl %al,%ebx
  8009d2:	83 fb 25             	cmp    $0x25,%ebx
  8009d5:	75 d6                	jne    8009ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	8d 50 01             	lea    0x1(%eax),%edx
  8009fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	0f b6 d8             	movzbl %al,%ebx
  800a05:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a08:	83 f8 55             	cmp    $0x55,%eax
  800a0b:	0f 87 2b 03 00 00    	ja     800d3c <vprintfmt+0x399>
  800a11:	8b 04 85 58 26 80 00 	mov    0x802658(,%eax,4),%eax
  800a18:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a1a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a1e:	eb d7                	jmp    8009f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a20:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a24:	eb d1                	jmp    8009f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a30:	89 d0                	mov    %edx,%eax
  800a32:	c1 e0 02             	shl    $0x2,%eax
  800a35:	01 d0                	add    %edx,%eax
  800a37:	01 c0                	add    %eax,%eax
  800a39:	01 d8                	add    %ebx,%eax
  800a3b:	83 e8 30             	sub    $0x30,%eax
  800a3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a41:	8b 45 10             	mov    0x10(%ebp),%eax
  800a44:	8a 00                	mov    (%eax),%al
  800a46:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a49:	83 fb 2f             	cmp    $0x2f,%ebx
  800a4c:	7e 3e                	jle    800a8c <vprintfmt+0xe9>
  800a4e:	83 fb 39             	cmp    $0x39,%ebx
  800a51:	7f 39                	jg     800a8c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a53:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a56:	eb d5                	jmp    800a2d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 c0 04             	add    $0x4,%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 e8 04             	sub    $0x4,%eax
  800a67:	8b 00                	mov    (%eax),%eax
  800a69:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a6c:	eb 1f                	jmp    800a8d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a72:	79 83                	jns    8009f7 <vprintfmt+0x54>
				width = 0;
  800a74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a7b:	e9 77 ff ff ff       	jmp    8009f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a80:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a87:	e9 6b ff ff ff       	jmp    8009f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a8c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a91:	0f 89 60 ff ff ff    	jns    8009f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aa4:	e9 4e ff ff ff       	jmp    8009f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aac:	e9 46 ff ff ff       	jmp    8009f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	83 c0 04             	add    $0x4,%eax
  800ab7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 e8 04             	sub    $0x4,%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	50                   	push   %eax
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			break;
  800ad1:	e9 89 02 00 00       	jmp    800d5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 e8 04             	sub    $0x4,%eax
  800ae5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ae7:	85 db                	test   %ebx,%ebx
  800ae9:	79 02                	jns    800aed <vprintfmt+0x14a>
				err = -err;
  800aeb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aed:	83 fb 64             	cmp    $0x64,%ebx
  800af0:	7f 0b                	jg     800afd <vprintfmt+0x15a>
  800af2:	8b 34 9d a0 24 80 00 	mov    0x8024a0(,%ebx,4),%esi
  800af9:	85 f6                	test   %esi,%esi
  800afb:	75 19                	jne    800b16 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800afd:	53                   	push   %ebx
  800afe:	68 45 26 80 00       	push   $0x802645
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 5e 02 00 00       	call   800d6c <printfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b11:	e9 49 02 00 00       	jmp    800d5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b16:	56                   	push   %esi
  800b17:	68 4e 26 80 00       	push   $0x80264e
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	ff 75 08             	pushl  0x8(%ebp)
  800b22:	e8 45 02 00 00       	call   800d6c <printfmt>
  800b27:	83 c4 10             	add    $0x10,%esp
			break;
  800b2a:	e9 30 02 00 00       	jmp    800d5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	83 c0 04             	add    $0x4,%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 30                	mov    (%eax),%esi
  800b40:	85 f6                	test   %esi,%esi
  800b42:	75 05                	jne    800b49 <vprintfmt+0x1a6>
				p = "(null)";
  800b44:	be 51 26 80 00       	mov    $0x802651,%esi
			if (width > 0 && padc != '-')
  800b49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4d:	7e 6d                	jle    800bbc <vprintfmt+0x219>
  800b4f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b53:	74 67                	je     800bbc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	50                   	push   %eax
  800b5c:	56                   	push   %esi
  800b5d:	e8 0c 03 00 00       	call   800e6e <strnlen>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b68:	eb 16                	jmp    800b80 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b6a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	50                   	push   %eax
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e4                	jg     800b6a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b86:	eb 34                	jmp    800bbc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b8c:	74 1c                	je     800baa <vprintfmt+0x207>
  800b8e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b91:	7e 05                	jle    800b98 <vprintfmt+0x1f5>
  800b93:	83 fb 7e             	cmp    $0x7e,%ebx
  800b96:	7e 12                	jle    800baa <vprintfmt+0x207>
					putch('?', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 3f                	push   $0x3f
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	eb 0f                	jmp    800bb9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	53                   	push   %ebx
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbc:	89 f0                	mov    %esi,%eax
  800bbe:	8d 70 01             	lea    0x1(%eax),%esi
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	0f be d8             	movsbl %al,%ebx
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	74 24                	je     800bee <vprintfmt+0x24b>
  800bca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bce:	78 b8                	js     800b88 <vprintfmt+0x1e5>
  800bd0:	ff 4d e0             	decl   -0x20(%ebp)
  800bd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd7:	79 af                	jns    800b88 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd9:	eb 13                	jmp    800bee <vprintfmt+0x24b>
				putch(' ', putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	6a 20                	push   $0x20
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	ff d0                	call   *%eax
  800be8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800beb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf2:	7f e7                	jg     800bdb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bf4:	e9 66 01 00 00       	jmp    800d5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bff:	8d 45 14             	lea    0x14(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 3c fd ff ff       	call   800944 <getint>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c17:	85 d2                	test   %edx,%edx
  800c19:	79 23                	jns    800c3e <vprintfmt+0x29b>
				putch('-', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 2d                	push   $0x2d
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c31:	f7 d8                	neg    %eax
  800c33:	83 d2 00             	adc    $0x0,%edx
  800c36:	f7 da                	neg    %edx
  800c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c45:	e9 bc 00 00 00       	jmp    800d06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c50:	8d 45 14             	lea    0x14(%ebp),%eax
  800c53:	50                   	push   %eax
  800c54:	e8 84 fc ff ff       	call   8008dd <getuint>
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c69:	e9 98 00 00 00       	jmp    800d06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 58                	push   $0x58
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 58                	push   $0x58
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	6a 58                	push   $0x58
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
			break;
  800c9e:	e9 bc 00 00 00       	jmp    800d5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 30                	push   $0x30
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 78                	push   $0x78
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ce5:	eb 1f                	jmp    800d06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ce7:	83 ec 08             	sub    $0x8,%esp
  800cea:	ff 75 e8             	pushl  -0x18(%ebp)
  800ced:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf0:	50                   	push   %eax
  800cf1:	e8 e7 fb ff ff       	call   8008dd <getuint>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0d:	83 ec 04             	sub    $0x4,%esp
  800d10:	52                   	push   %edx
  800d11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d14:	50                   	push   %eax
  800d15:	ff 75 f4             	pushl  -0xc(%ebp)
  800d18:	ff 75 f0             	pushl  -0x10(%ebp)
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	e8 00 fb ff ff       	call   800826 <printnum>
  800d26:	83 c4 20             	add    $0x20,%esp
			break;
  800d29:	eb 34                	jmp    800d5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	53                   	push   %ebx
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	ff d0                	call   *%eax
  800d37:	83 c4 10             	add    $0x10,%esp
			break;
  800d3a:	eb 23                	jmp    800d5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	6a 25                	push   $0x25
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4c:	ff 4d 10             	decl   0x10(%ebp)
  800d4f:	eb 03                	jmp    800d54 <vprintfmt+0x3b1>
  800d51:	ff 4d 10             	decl   0x10(%ebp)
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	48                   	dec    %eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 25                	cmp    $0x25,%al
  800d5c:	75 f3                	jne    800d51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d5e:	90                   	nop
		}
	}
  800d5f:	e9 47 fc ff ff       	jmp    8009ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d72:	8d 45 10             	lea    0x10(%ebp),%eax
  800d75:	83 c0 04             	add    $0x4,%eax
  800d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d81:	50                   	push   %eax
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	ff 75 08             	pushl  0x8(%ebp)
  800d88:	e8 16 fc ff ff       	call   8009a3 <vprintfmt>
  800d8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d90:	90                   	nop
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8b 40 08             	mov    0x8(%eax),%eax
  800d9c:	8d 50 01             	lea    0x1(%eax),%edx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8b 10                	mov    (%eax),%edx
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8b 40 04             	mov    0x4(%eax),%eax
  800db0:	39 c2                	cmp    %eax,%edx
  800db2:	73 12                	jae    800dc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8b 00                	mov    (%eax),%eax
  800db9:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbf:	89 0a                	mov    %ecx,(%edx)
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	88 10                	mov    %dl,(%eax)
}
  800dc6:	90                   	nop
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	01 d0                	add    %edx,%eax
  800de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dee:	74 06                	je     800df6 <vsnprintf+0x2d>
  800df0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df4:	7f 07                	jg     800dfd <vsnprintf+0x34>
		return -E_INVAL;
  800df6:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfb:	eb 20                	jmp    800e1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dfd:	ff 75 14             	pushl  0x14(%ebp)
  800e00:	ff 75 10             	pushl  0x10(%ebp)
  800e03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e06:	50                   	push   %eax
  800e07:	68 93 0d 80 00       	push   $0x800d93
  800e0c:	e8 92 fb ff ff       	call   8009a3 <vprintfmt>
  800e11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e25:	8d 45 10             	lea    0x10(%ebp),%eax
  800e28:	83 c0 04             	add    $0x4,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	ff 75 f4             	pushl  -0xc(%ebp)
  800e34:	50                   	push   %eax
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	ff 75 08             	pushl  0x8(%ebp)
  800e3b:	e8 89 ff ff ff       	call   800dc9 <vsnprintf>
  800e40:	83 c4 10             	add    $0x10,%esp
  800e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 06                	jmp    800e60 <strlen+0x15>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 f1                	jne    800e5a <strlen+0xf>
		n++;
	return n;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7b:	eb 09                	jmp    800e86 <strnlen+0x18>
		n++;
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e80:	ff 45 08             	incl   0x8(%ebp)
  800e83:	ff 4d 0c             	decl   0xc(%ebp)
  800e86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8a:	74 09                	je     800e95 <strnlen+0x27>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	75 e8                	jne    800e7d <strnlen+0xf>
		n++;
	return n;
  800e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea6:	90                   	nop
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8d 50 01             	lea    0x1(%eax),%edx
  800ead:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb9:	8a 12                	mov    (%edx),%dl
  800ebb:	88 10                	mov    %dl,(%eax)
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	84 c0                	test   %al,%al
  800ec1:	75 e4                	jne    800ea7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800edb:	eb 1f                	jmp    800efc <strncpy+0x34>
		*dst++ = *src;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee9:	8a 12                	mov    (%edx),%dl
  800eeb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	74 03                	je     800ef9 <strncpy+0x31>
			src++;
  800ef6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef9:	ff 45 fc             	incl   -0x4(%ebp)
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f02:	72 d9                	jb     800edd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f19:	74 30                	je     800f4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1b:	eb 16                	jmp    800f33 <strlcpy+0x2a>
			*dst++ = *src++;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8d 50 01             	lea    0x1(%eax),%edx
  800f23:	89 55 08             	mov    %edx,0x8(%ebp)
  800f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2f:	8a 12                	mov    (%edx),%dl
  800f31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f33:	ff 4d 10             	decl   0x10(%ebp)
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 09                	je     800f45 <strlcpy+0x3c>
  800f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	84 c0                	test   %al,%al
  800f43:	75 d8                	jne    800f1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	29 c2                	sub    %eax,%edx
  800f53:	89 d0                	mov    %edx,%eax
}
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5a:	eb 06                	jmp    800f62 <strcmp+0xb>
		p++, q++;
  800f5c:	ff 45 08             	incl   0x8(%ebp)
  800f5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	74 0e                	je     800f79 <strcmp+0x22>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 10                	mov    (%eax),%dl
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	38 c2                	cmp    %al,%dl
  800f77:	74 e3                	je     800f5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	0f b6 d0             	movzbl %al,%edx
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	0f b6 c0             	movzbl %al,%eax
  800f89:	29 c2                	sub    %eax,%edx
  800f8b:	89 d0                	mov    %edx,%eax
}
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f92:	eb 09                	jmp    800f9d <strncmp+0xe>
		n--, p++, q++;
  800f94:	ff 4d 10             	decl   0x10(%ebp)
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	74 17                	je     800fba <strncmp+0x2b>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	74 0e                	je     800fba <strncmp+0x2b>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 10                	mov    (%eax),%dl
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	38 c2                	cmp    %al,%dl
  800fb8:	74 da                	je     800f94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbe:	75 07                	jne    800fc7 <strncmp+0x38>
		return 0;
  800fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc5:	eb 14                	jmp    800fdb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f b6 d0             	movzbl %al,%edx
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	0f b6 c0             	movzbl %al,%eax
  800fd7:	29 c2                	sub    %eax,%edx
  800fd9:	89 d0                	mov    %edx,%eax
}
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe9:	eb 12                	jmp    800ffd <strchr+0x20>
		if (*s == c)
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff3:	75 05                	jne    800ffa <strchr+0x1d>
			return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	eb 11                	jmp    80100b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	84 c0                	test   %al,%al
  801004:	75 e5                	jne    800feb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801019:	eb 0d                	jmp    801028 <strfind+0x1b>
		if (*s == c)
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801023:	74 0e                	je     801033 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801025:	ff 45 08             	incl   0x8(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	84 c0                	test   %al,%al
  80102f:	75 ea                	jne    80101b <strfind+0xe>
  801031:	eb 01                	jmp    801034 <strfind+0x27>
		if (*s == c)
			break;
  801033:	90                   	nop
	return (char *) s;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80104b:	eb 0e                	jmp    80105b <memset+0x22>
		*p++ = c;
  80104d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801050:	8d 50 01             	lea    0x1(%eax),%edx
  801053:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801056:	8b 55 0c             	mov    0xc(%ebp),%edx
  801059:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80105b:	ff 4d f8             	decl   -0x8(%ebp)
  80105e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801062:	79 e9                	jns    80104d <memset+0x14>
		*p++ = c;

	return v;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80107b:	eb 16                	jmp    801093 <memcpy+0x2a>
		*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010bd:	73 50                	jae    80110f <memmove+0x6a>
  8010bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c5:	01 d0                	add    %edx,%eax
  8010c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ca:	76 43                	jbe    80110f <memmove+0x6a>
		s += n;
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d8:	eb 10                	jmp    8010ea <memmove+0x45>
			*--d = *--s;
  8010da:	ff 4d f8             	decl   -0x8(%ebp)
  8010dd:	ff 4d fc             	decl   -0x4(%ebp)
  8010e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e3:	8a 10                	mov    (%eax),%dl
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	75 e3                	jne    8010da <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010f7:	eb 23                	jmp    80111c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	8d 50 01             	lea    0x1(%eax),%edx
  8010ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8d 4a 01             	lea    0x1(%edx),%ecx
  801108:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110b:	8a 12                	mov    (%edx),%dl
  80110d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	8d 50 ff             	lea    -0x1(%eax),%edx
  801115:	89 55 10             	mov    %edx,0x10(%ebp)
  801118:	85 c0                	test   %eax,%eax
  80111a:	75 dd                	jne    8010f9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801133:	eb 2a                	jmp    80115f <memcmp+0x3e>
		if (*s1 != *s2)
  801135:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801138:	8a 10                	mov    (%eax),%dl
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	38 c2                	cmp    %al,%dl
  801141:	74 16                	je     801159 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	0f b6 d0             	movzbl %al,%edx
  80114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f b6 c0             	movzbl %al,%eax
  801153:	29 c2                	sub    %eax,%edx
  801155:	89 d0                	mov    %edx,%eax
  801157:	eb 18                	jmp    801171 <memcmp+0x50>
		s1++, s2++;
  801159:	ff 45 fc             	incl   -0x4(%ebp)
  80115c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	8d 50 ff             	lea    -0x1(%eax),%edx
  801165:	89 55 10             	mov    %edx,0x10(%ebp)
  801168:	85 c0                	test   %eax,%eax
  80116a:	75 c9                	jne    801135 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801179:	8b 55 08             	mov    0x8(%ebp),%edx
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801184:	eb 15                	jmp    80119b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	0f b6 d0             	movzbl %al,%edx
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	0f b6 c0             	movzbl %al,%eax
  801194:	39 c2                	cmp    %eax,%edx
  801196:	74 0d                	je     8011a5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a1:	72 e3                	jb     801186 <memfind+0x13>
  8011a3:	eb 01                	jmp    8011a6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a5:	90                   	nop
	return (void *) s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011bf:	eb 03                	jmp    8011c4 <strtol+0x19>
		s++;
  8011c1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 20                	cmp    $0x20,%al
  8011cb:	74 f4                	je     8011c1 <strtol+0x16>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 09                	cmp    $0x9,%al
  8011d4:	74 eb                	je     8011c1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	3c 2b                	cmp    $0x2b,%al
  8011dd:	75 05                	jne    8011e4 <strtol+0x39>
		s++;
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	eb 13                	jmp    8011f7 <strtol+0x4c>
	else if (*s == '-')
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	3c 2d                	cmp    $0x2d,%al
  8011eb:	75 0a                	jne    8011f7 <strtol+0x4c>
		s++, neg = 1;
  8011ed:	ff 45 08             	incl   0x8(%ebp)
  8011f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fb:	74 06                	je     801203 <strtol+0x58>
  8011fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801201:	75 20                	jne    801223 <strtol+0x78>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 30                	cmp    $0x30,%al
  80120a:	75 17                	jne    801223 <strtol+0x78>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	40                   	inc    %eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 78                	cmp    $0x78,%al
  801214:	75 0d                	jne    801223 <strtol+0x78>
		s += 2, base = 16;
  801216:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801221:	eb 28                	jmp    80124b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	75 15                	jne    80123e <strtol+0x93>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	3c 30                	cmp    $0x30,%al
  801230:	75 0c                	jne    80123e <strtol+0x93>
		s++, base = 8;
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80123c:	eb 0d                	jmp    80124b <strtol+0xa0>
	else if (base == 0)
  80123e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801242:	75 07                	jne    80124b <strtol+0xa0>
		base = 10;
  801244:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	3c 2f                	cmp    $0x2f,%al
  801252:	7e 19                	jle    80126d <strtol+0xc2>
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	3c 39                	cmp    $0x39,%al
  80125b:	7f 10                	jg     80126d <strtol+0xc2>
			dig = *s - '0';
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	83 e8 30             	sub    $0x30,%eax
  801268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126b:	eb 42                	jmp    8012af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	3c 60                	cmp    $0x60,%al
  801274:	7e 19                	jle    80128f <strtol+0xe4>
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 7a                	cmp    $0x7a,%al
  80127d:	7f 10                	jg     80128f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	0f be c0             	movsbl %al,%eax
  801287:	83 e8 57             	sub    $0x57,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80128d:	eb 20                	jmp    8012af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	3c 40                	cmp    $0x40,%al
  801296:	7e 39                	jle    8012d1 <strtol+0x126>
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 5a                	cmp    $0x5a,%al
  80129f:	7f 30                	jg     8012d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	0f be c0             	movsbl %al,%eax
  8012a9:	83 e8 37             	sub    $0x37,%eax
  8012ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b5:	7d 19                	jge    8012d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012b7:	ff 45 08             	incl   0x8(%ebp)
  8012ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c1:	89 c2                	mov    %eax,%edx
  8012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c6:	01 d0                	add    %edx,%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012cb:	e9 7b ff ff ff       	jmp    80124b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d5:	74 08                	je     8012df <strtol+0x134>
		*endptr = (char *) s;
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e3:	74 07                	je     8012ec <strtol+0x141>
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	f7 d8                	neg    %eax
  8012ea:	eb 03                	jmp    8012ef <strtol+0x144>
  8012ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801309:	79 13                	jns    80131e <ltostr+0x2d>
	{
		neg = 1;
  80130b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801318:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80131b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801326:	99                   	cltd   
  801327:	f7 f9                	idiv   %ecx
  801329:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80132c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801335:	89 c2                	mov    %eax,%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80133f:	83 c2 30             	add    $0x30,%edx
  801342:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801347:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134c:	f7 e9                	imul   %ecx
  80134e:	c1 fa 02             	sar    $0x2,%edx
  801351:	89 c8                	mov    %ecx,%eax
  801353:	c1 f8 1f             	sar    $0x1f,%eax
  801356:	29 c2                	sub    %eax,%edx
  801358:	89 d0                	mov    %edx,%eax
  80135a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80135d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801360:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801365:	f7 e9                	imul   %ecx
  801367:	c1 fa 02             	sar    $0x2,%edx
  80136a:	89 c8                	mov    %ecx,%eax
  80136c:	c1 f8 1f             	sar    $0x1f,%eax
  80136f:	29 c2                	sub    %eax,%edx
  801371:	89 d0                	mov    %edx,%eax
  801373:	c1 e0 02             	shl    $0x2,%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	01 c0                	add    %eax,%eax
  80137a:	29 c1                	sub    %eax,%ecx
  80137c:	89 ca                	mov    %ecx,%edx
  80137e:	85 d2                	test   %edx,%edx
  801380:	75 9c                	jne    80131e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801389:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138c:	48                   	dec    %eax
  80138d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801390:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801394:	74 3d                	je     8013d3 <ltostr+0xe2>
		start = 1 ;
  801396:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80139d:	eb 34                	jmp    8013d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 c2                	add    %eax,%edx
  8013b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ba:	01 c8                	add    %ecx,%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 c2                	add    %eax,%edx
  8013c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8013cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d9:	7c c4                	jl     80139f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	e8 54 fa ff ff       	call   800e4b <strlen>
  8013f7:	83 c4 04             	add    $0x4,%esp
  8013fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	e8 46 fa ff ff       	call   800e4b <strlen>
  801405:	83 c4 04             	add    $0x4,%esp
  801408:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80140b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801419:	eb 17                	jmp    801432 <strcconcat+0x49>
		final[s] = str1[s] ;
  80141b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	01 c2                	add    %eax,%edx
  801423:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	01 c8                	add    %ecx,%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80142f:	ff 45 fc             	incl   -0x4(%ebp)
  801432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801435:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801438:	7c e1                	jl     80141b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80143a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801441:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801448:	eb 1f                	jmp    801469 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80144a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801453:	89 c2                	mov    %eax,%edx
  801455:	8b 45 10             	mov    0x10(%ebp),%eax
  801458:	01 c2                	add    %eax,%edx
  80145a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c8                	add    %ecx,%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801466:	ff 45 f8             	incl   -0x8(%ebp)
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80146f:	7c d9                	jl     80144a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c6 00 00             	movb   $0x0,(%eax)
}
  80147c:	90                   	nop
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801482:	8b 45 14             	mov    0x14(%ebp),%eax
  801485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80148b:	8b 45 14             	mov    0x14(%ebp),%eax
  80148e:	8b 00                	mov    (%eax),%eax
  801490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 d0                	add    %edx,%eax
  80149c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a2:	eb 0c                	jmp    8014b0 <strsplit+0x31>
			*string++ = 0;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8d 50 01             	lea    0x1(%eax),%edx
  8014aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	84 c0                	test   %al,%al
  8014b7:	74 18                	je     8014d1 <strsplit+0x52>
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	0f be c0             	movsbl %al,%eax
  8014c1:	50                   	push   %eax
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	e8 13 fb ff ff       	call   800fdd <strchr>
  8014ca:	83 c4 08             	add    $0x8,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	75 d3                	jne    8014a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	84 c0                	test   %al,%al
  8014d8:	74 5a                	je     801534 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	8b 00                	mov    (%eax),%eax
  8014df:	83 f8 0f             	cmp    $0xf,%eax
  8014e2:	75 07                	jne    8014eb <strsplit+0x6c>
		{
			return 0;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	eb 66                	jmp    801551 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8014f6:	89 0a                	mov    %ecx,(%edx)
  8014f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	01 c2                	add    %eax,%edx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801509:	eb 03                	jmp    80150e <strsplit+0x8f>
			string++;
  80150b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	84 c0                	test   %al,%al
  801515:	74 8b                	je     8014a2 <strsplit+0x23>
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	0f be c0             	movsbl %al,%eax
  80151f:	50                   	push   %eax
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	e8 b5 fa ff ff       	call   800fdd <strchr>
  801528:	83 c4 08             	add    $0x8,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	74 dc                	je     80150b <strsplit+0x8c>
			string++;
	}
  80152f:	e9 6e ff ff ff       	jmp    8014a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801534:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801535:	8b 45 14             	mov    0x14(%ebp),%eax
  801538:	8b 00                	mov    (%eax),%eax
  80153a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	01 d0                	add    %edx,%eax
  801546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80154c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <malloc>:
int sizeofarray=0;
uint32 addresses[100000];
int changed[100000];
int numOfPages[100000];
void* malloc(uint32 size)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	c1 e8 0c             	shr    $0xc,%eax
  80155f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;

		if(size%PAGE_SIZE!=0)
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	25 ff 0f 00 00       	and    $0xfff,%eax
  80156a:	85 c0                	test   %eax,%eax
  80156c:	74 03                	je     801571 <malloc+0x1e>
			num++;
  80156e:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  801571:	a1 04 30 80 00       	mov    0x803004,%eax
  801576:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80157b:	75 73                	jne    8015f0 <malloc+0x9d>
		{
			sys_allocateMem(USER_HEAP_START,size);
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	68 00 00 00 80       	push   $0x80000000
  801588:	e8 14 05 00 00       	call   801aa1 <sys_allocateMem>
  80158d:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  801590:	a1 04 30 80 00       	mov    0x803004,%eax
  801595:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	c1 e0 0c             	shl    $0xc,%eax
  80159e:	89 c2                	mov    %eax,%edx
  8015a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8015a5:	01 d0                	add    %edx,%eax
  8015a7:	a3 04 30 80 00       	mov    %eax,0x803004
			numOfPages[sizeofarray]=num;
  8015ac:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b4:	89 14 85 20 66 8c 00 	mov    %edx,0x8c6620(,%eax,4)
			addresses[sizeofarray]=last_addres;
  8015bb:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015c0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015c6:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
			changed[sizeofarray]=1;
  8015cd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015d2:	c7 04 85 a0 4b 86 00 	movl   $0x1,0x864ba0(,%eax,4)
  8015d9:	01 00 00 00 
			sizeofarray++;
  8015dd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015e2:	40                   	inc    %eax
  8015e3:	a3 2c 30 80 00       	mov    %eax,0x80302c
			return (void*)return_addres;
  8015e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015eb:	e9 71 01 00 00       	jmp    801761 <malloc+0x20e>
		}
		else
		{
			if(changes==0)
  8015f0:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	75 71                	jne    80166a <malloc+0x117>
			{
				sys_allocateMem(last_addres,size);
  8015f9:	a1 04 30 80 00       	mov    0x803004,%eax
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	50                   	push   %eax
  801605:	e8 97 04 00 00       	call   801aa1 <sys_allocateMem>
  80160a:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  80160d:	a1 04 30 80 00       	mov    0x803004,%eax
  801612:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	c1 e0 0c             	shl    $0xc,%eax
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	a1 04 30 80 00       	mov    0x803004,%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	a3 04 30 80 00       	mov    %eax,0x803004
				numOfPages[sizeofarray]=num;
  801629:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	89 14 85 20 66 8c 00 	mov    %edx,0x8c6620(,%eax,4)
				addresses[sizeofarray]=return_addres;
  801638:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80163d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801640:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801647:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80164c:	c7 04 85 a0 4b 86 00 	movl   $0x1,0x864ba0(,%eax,4)
  801653:	01 00 00 00 
				sizeofarray++;
  801657:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80165c:	40                   	inc    %eax
  80165d:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return (void*)return_addres;
  801662:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801665:	e9 f7 00 00 00       	jmp    801761 <malloc+0x20e>
			}
			else{
				int count=0;
  80166a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801671:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  801678:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  80167f:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801686:	eb 7c                	jmp    801704 <malloc+0x1b1>
				{
					uint32 *pg=NULL;
  801688:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  80168f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801696:	eb 1a                	jmp    8016b2 <malloc+0x15f>
					{
						if(addresses[j]==i)
  801698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80169b:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  8016a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8016a5:	75 08                	jne    8016af <malloc+0x15c>
						{
							index=j;
  8016a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  8016ad:	eb 0d                	jmp    8016bc <malloc+0x169>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  8016af:	ff 45 dc             	incl   -0x24(%ebp)
  8016b2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016b7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8016ba:	7c dc                	jl     801698 <malloc+0x145>
							index=j;
							break;
						}
					}

					if(index==-1)
  8016bc:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8016c0:	75 05                	jne    8016c7 <malloc+0x174>
					{
						count++;
  8016c2:	ff 45 f0             	incl   -0x10(%ebp)
  8016c5:	eb 36                	jmp    8016fd <malloc+0x1aa>
					}
					else
					{
						if(changed[index]==0)
  8016c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ca:	8b 04 85 a0 4b 86 00 	mov    0x864ba0(,%eax,4),%eax
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	75 05                	jne    8016da <malloc+0x187>
						{
							count++;
  8016d5:	ff 45 f0             	incl   -0x10(%ebp)
  8016d8:	eb 23                	jmp    8016fd <malloc+0x1aa>
						}
						else
						{
							if(count<min&&count>=num)
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8016e0:	7d 14                	jge    8016f6 <malloc+0x1a3>
  8016e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e8:	7c 0c                	jl     8016f6 <malloc+0x1a3>
							{
								min=count;
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  8016f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  8016f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  8016fd:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801704:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80170b:	0f 86 77 ff ff ff    	jbe    801688 <malloc+0x135>

					}

					}

				sys_allocateMem(min_addresss,size);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	ff 75 e4             	pushl  -0x1c(%ebp)
  80171a:	e8 82 03 00 00       	call   801aa1 <sys_allocateMem>
  80171f:	83 c4 10             	add    $0x10,%esp
				numOfPages[sizeofarray]=num;
  801722:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172a:	89 14 85 20 66 8c 00 	mov    %edx,0x8c6620(,%eax,4)
				addresses[sizeofarray]=last_addres;
  801731:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801736:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80173c:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801743:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801748:	c7 04 85 a0 4b 86 00 	movl   $0x1,0x864ba0(,%eax,4)
  80174f:	01 00 00 00 
				sizeofarray++;
  801753:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801758:	40                   	inc    %eax
  801759:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return(void*) min_addresss;
  80175e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	//you should get the size of the given allocation using its address
    uint32 va=(uint32)virtual_address;
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int size;
    int is_found=0;
  80176f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int index;
    for(int i=0;i<sizeofarray;i++){
  801776:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80177d:	eb 30                	jmp    8017af <free+0x4c>
    	if(addresses[i]==va&&changed[i]==1){
  80177f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801782:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801789:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80178c:	75 1e                	jne    8017ac <free+0x49>
  80178e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801791:	8b 04 85 a0 4b 86 00 	mov    0x864ba0(,%eax,4),%eax
  801798:	83 f8 01             	cmp    $0x1,%eax
  80179b:	75 0f                	jne    8017ac <free+0x49>
    		is_found=1;
  80179d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    		index=i;
  8017a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		break;
  8017aa:	eb 0d                	jmp    8017b9 <free+0x56>
	//you should get the size of the given allocation using its address
    uint32 va=(uint32)virtual_address;
    int size;
    int is_found=0;
    int index;
    for(int i=0;i<sizeofarray;i++){
  8017ac:	ff 45 ec             	incl   -0x14(%ebp)
  8017af:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017b4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017b7:	7c c6                	jl     80177f <free+0x1c>
    		is_found=1;
    		index=i;
    		break;
    	}
    }
    if(is_found==1){
  8017b9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8017bd:	75 3b                	jne    8017fa <free+0x97>
    	size=numOfPages[index]*PAGE_SIZE;
  8017bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c2:	8b 04 85 20 66 8c 00 	mov    0x8c6620(,%eax,4),%eax
  8017c9:	c1 e0 0c             	shl    $0xc,%eax
  8017cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	sys_freeMem(va,size);
  8017cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d2:	83 ec 08             	sub    $0x8,%esp
  8017d5:	50                   	push   %eax
  8017d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d9:	e8 a7 02 00 00       	call   801a85 <sys_freeMem>
  8017de:	83 c4 10             	add    $0x10,%esp
    	changed[index]=0;
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	c7 04 85 a0 4b 86 00 	movl   $0x0,0x864ba0(,%eax,4)
  8017eb:	00 00 00 00 
    	changes++;
  8017ef:	a1 28 30 80 00       	mov    0x803028,%eax
  8017f4:	40                   	inc    %eax
  8017f5:	a3 28 30 80 00       	mov    %eax,0x803028
    }


	//refer to the project presentation and documentation for details
}
  8017fa:	90                   	nop
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 18             	sub    $0x18,%esp
  801803:	8b 45 10             	mov    0x10(%ebp),%eax
  801806:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 b0 27 80 00       	push   $0x8027b0
  801811:	68 9f 00 00 00       	push   $0x9f
  801816:	68 d3 27 80 00       	push   $0x8027d3
  80181b:	e8 0b 07 00 00       	call   801f2b <_panic>

00801820 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 b0 27 80 00       	push   $0x8027b0
  80182e:	68 a5 00 00 00       	push   $0xa5
  801833:	68 d3 27 80 00       	push   $0x8027d3
  801838:	e8 ee 06 00 00       	call   801f2b <_panic>

0080183d <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	68 b0 27 80 00       	push   $0x8027b0
  80184b:	68 ab 00 00 00       	push   $0xab
  801850:	68 d3 27 80 00       	push   $0x8027d3
  801855:	e8 d1 06 00 00       	call   801f2b <_panic>

0080185a <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	68 b0 27 80 00       	push   $0x8027b0
  801868:	68 b0 00 00 00       	push   $0xb0
  80186d:	68 d3 27 80 00       	push   $0x8027d3
  801872:	e8 b4 06 00 00       	call   801f2b <_panic>

00801877 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	68 b0 27 80 00       	push   $0x8027b0
  801885:	68 b6 00 00 00       	push   $0xb6
  80188a:	68 d3 27 80 00       	push   $0x8027d3
  80188f:	e8 97 06 00 00       	call   801f2b <_panic>

00801894 <shrink>:
}
void shrink(uint32 newSize)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	68 b0 27 80 00       	push   $0x8027b0
  8018a2:	68 ba 00 00 00       	push   $0xba
  8018a7:	68 d3 27 80 00       	push   $0x8027d3
  8018ac:	e8 7a 06 00 00       	call   801f2b <_panic>

008018b1 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 b0 27 80 00       	push   $0x8027b0
  8018bf:	68 bf 00 00 00       	push   $0xbf
  8018c4:	68 d3 27 80 00       	push   $0x8027d3
  8018c9:	e8 5d 06 00 00       	call   801f2b <_panic>

008018ce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	57                   	push   %edi
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018e6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018e9:	cd 30                	int    $0x30
  8018eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    

008018f9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801902:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801905:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	50                   	push   %eax
  801915:	6a 00                	push   $0x0
  801917:	e8 b2 ff ff ff       	call   8018ce <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_cgetc>:

int
sys_cgetc(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 01                	push   $0x1
  801931:	e8 98 ff ff ff       	call   8018ce <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	50                   	push   %eax
  80194a:	6a 05                	push   $0x5
  80194c:	e8 7d ff ff ff       	call   8018ce <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 02                	push   $0x2
  801965:	e8 64 ff ff ff       	call   8018ce <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 03                	push   $0x3
  80197e:	e8 4b ff ff ff       	call   8018ce <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 04                	push   $0x4
  801997:	e8 32 ff ff ff       	call   8018ce <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_env_exit>:


void sys_env_exit(void)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 06                	push   $0x6
  8019b0:	e8 19 ff ff ff       	call   8018ce <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	6a 07                	push   $0x7
  8019ce:	e8 fb fe ff ff       	call   8018ce <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	56                   	push   %esi
  8019dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	56                   	push   %esi
  8019ed:	53                   	push   %ebx
  8019ee:	51                   	push   %ecx
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	6a 08                	push   $0x8
  8019f3:	e8 d6 fe ff ff       	call   8018ce <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    

00801a02 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 09                	push   $0x9
  801a15:	e8 b4 fe ff ff       	call   8018ce <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	6a 0a                	push   $0xa
  801a30:	e8 99 fe ff ff       	call   8018ce <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0b                	push   $0xb
  801a49:	e8 80 fe ff ff       	call   8018ce <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 0c                	push   $0xc
  801a62:	e8 67 fe ff ff       	call   8018ce <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 0d                	push   $0xd
  801a7b:	e8 4e fe ff ff       	call   8018ce <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	ff 75 08             	pushl  0x8(%ebp)
  801a94:	6a 11                	push   $0x11
  801a96:	e8 33 fe ff ff       	call   8018ce <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
	return;
  801a9e:	90                   	nop
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	ff 75 08             	pushl  0x8(%ebp)
  801ab0:	6a 12                	push   $0x12
  801ab2:	e8 17 fe ff ff       	call   8018ce <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aba:	90                   	nop
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 0e                	push   $0xe
  801acc:	e8 fd fd ff ff       	call   8018ce <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	6a 0f                	push   $0xf
  801ae6:	e8 e3 fd ff ff       	call   8018ce <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 10                	push   $0x10
  801aff:	e8 ca fd ff ff       	call   8018ce <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 14                	push   $0x14
  801b19:	e8 b0 fd ff ff       	call   8018ce <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 15                	push   $0x15
  801b33:	e8 96 fd ff ff       	call   8018ce <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_cputc>:


void
sys_cputc(const char c)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b4a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	50                   	push   %eax
  801b57:	6a 16                	push   $0x16
  801b59:	e8 70 fd ff ff       	call   8018ce <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 17                	push   $0x17
  801b73:	e8 56 fd ff ff       	call   8018ce <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	50                   	push   %eax
  801b8e:	6a 18                	push   $0x18
  801b90:	e8 39 fd ff ff       	call   8018ce <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 1b                	push   $0x1b
  801bad:	e8 1c fd ff ff       	call   8018ce <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 19                	push   $0x19
  801bca:	e8 ff fc ff ff       	call   8018ce <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	90                   	nop
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	6a 1a                	push   $0x1a
  801be8:	e8 e1 fc ff ff       	call   8018ce <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	51                   	push   %ecx
  801c0c:	52                   	push   %edx
  801c0d:	ff 75 0c             	pushl  0xc(%ebp)
  801c10:	50                   	push   %eax
  801c11:	6a 1c                	push   $0x1c
  801c13:	e8 b6 fc ff ff       	call   8018ce <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	52                   	push   %edx
  801c2d:	50                   	push   %eax
  801c2e:	6a 1d                	push   $0x1d
  801c30:	e8 99 fc ff ff       	call   8018ce <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	51                   	push   %ecx
  801c4b:	52                   	push   %edx
  801c4c:	50                   	push   %eax
  801c4d:	6a 1e                	push   $0x1e
  801c4f:	e8 7a fc ff ff       	call   8018ce <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	52                   	push   %edx
  801c69:	50                   	push   %eax
  801c6a:	6a 1f                	push   $0x1f
  801c6c:	e8 5d fc ff ff       	call   8018ce <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 20                	push   $0x20
  801c85:	e8 44 fc ff ff       	call   8018ce <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	ff 75 14             	pushl  0x14(%ebp)
  801c9a:	ff 75 10             	pushl  0x10(%ebp)
  801c9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ca0:	50                   	push   %eax
  801ca1:	6a 21                	push   $0x21
  801ca3:	e8 26 fc ff ff       	call   8018ce <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	50                   	push   %eax
  801cbc:	6a 22                	push   $0x22
  801cbe:	e8 0b fc ff ff       	call   8018ce <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	90                   	nop
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	50                   	push   %eax
  801cd8:	6a 23                	push   $0x23
  801cda:	e8 ef fb ff ff       	call   8018ce <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	90                   	nop
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ceb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cee:	8d 50 04             	lea    0x4(%eax),%edx
  801cf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	6a 24                	push   $0x24
  801cfe:	e8 cb fb ff ff       	call   8018ce <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return result;
  801d06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0f:	89 01                	mov    %eax,(%ecx)
  801d11:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	c9                   	leave  
  801d18:	c2 04 00             	ret    $0x4

00801d1b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	ff 75 10             	pushl  0x10(%ebp)
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 13                	push   $0x13
  801d2d:	e8 9c fb ff ff       	call   8018ce <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
	return ;
  801d35:	90                   	nop
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 25                	push   $0x25
  801d47:	e8 82 fb ff ff       	call   8018ce <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	50                   	push   %eax
  801d6a:	6a 26                	push   $0x26
  801d6c:	e8 5d fb ff ff       	call   8018ce <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return ;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <rsttst>:
void rsttst()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 28                	push   $0x28
  801d86:	e8 43 fb ff ff       	call   8018ce <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9d:	8b 55 18             	mov    0x18(%ebp),%edx
  801da0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	ff 75 10             	pushl  0x10(%ebp)
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	6a 27                	push   $0x27
  801db1:	e8 18 fb ff ff       	call   8018ce <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <chktst>:
void chktst(uint32 n)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	6a 29                	push   $0x29
  801dcc:	e8 fd fa ff ff       	call   8018ce <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd4:	90                   	nop
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <inctst>:

void inctst()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 2a                	push   $0x2a
  801de6:	e8 e3 fa ff ff       	call   8018ce <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <gettst>:
uint32 gettst()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 2b                	push   $0x2b
  801e00:	e8 c9 fa ff ff       	call   8018ce <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 2c                	push   $0x2c
  801e1c:	e8 ad fa ff ff       	call   8018ce <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
  801e24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e27:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e2b:	75 07                	jne    801e34 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e32:	eb 05                	jmp    801e39 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 2c                	push   $0x2c
  801e4d:	e8 7c fa ff ff       	call   8018ce <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
  801e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e58:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e5c:	75 07                	jne    801e65 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e63:	eb 05                	jmp    801e6a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 2c                	push   $0x2c
  801e7e:	e8 4b fa ff ff       	call   8018ce <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
  801e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e89:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e8d:	75 07                	jne    801e96 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e94:	eb 05                	jmp    801e9b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 2c                	push   $0x2c
  801eaf:	e8 1a fa ff ff       	call   8018ce <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
  801eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eba:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ebe:	75 07                	jne    801ec7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec5:	eb 05                	jmp    801ecc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	6a 2d                	push   $0x2d
  801ede:	e8 eb f9 ff ff       	call   8018ce <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee6:	90                   	nop
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	6a 00                	push   $0x0
  801efb:	53                   	push   %ebx
  801efc:	51                   	push   %ecx
  801efd:	52                   	push   %edx
  801efe:	50                   	push   %eax
  801eff:	6a 2e                	push   $0x2e
  801f01:	e8 c8 f9 ff ff       	call   8018ce <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	52                   	push   %edx
  801f1e:	50                   	push   %eax
  801f1f:	6a 2f                	push   $0x2f
  801f21:	e8 a8 f9 ff ff       	call   8018ce <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801f31:	8d 45 10             	lea    0x10(%ebp),%eax
  801f34:	83 c0 04             	add    $0x4,%eax
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801f3a:	a1 a0 80 92 00       	mov    0x9280a0,%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	74 16                	je     801f59 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801f43:	a1 a0 80 92 00       	mov    0x9280a0,%eax
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	50                   	push   %eax
  801f4c:	68 e0 27 80 00       	push   $0x8027e0
  801f51:	e8 73 e8 ff ff       	call   8007c9 <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801f59:	a1 00 30 80 00       	mov    0x803000,%eax
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	50                   	push   %eax
  801f65:	68 e5 27 80 00       	push   $0x8027e5
  801f6a:	e8 5a e8 ff ff       	call   8007c9 <cprintf>
  801f6f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801f72:	8b 45 10             	mov    0x10(%ebp),%eax
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7b:	50                   	push   %eax
  801f7c:	e8 dd e7 ff ff       	call   80075e <vcprintf>
  801f81:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	6a 00                	push   $0x0
  801f89:	68 01 28 80 00       	push   $0x802801
  801f8e:	e8 cb e7 ff ff       	call   80075e <vcprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801f96:	e8 4c e7 ff ff       	call   8006e7 <exit>

	// should not return here
	while (1) ;
  801f9b:	eb fe                	jmp    801f9b <_panic+0x70>

00801f9d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801fa3:	a1 20 30 80 00       	mov    0x803020,%eax
  801fa8:	8b 50 74             	mov    0x74(%eax),%edx
  801fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	74 14                	je     801fc6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	68 04 28 80 00       	push   $0x802804
  801fba:	6a 26                	push   $0x26
  801fbc:	68 50 28 80 00       	push   $0x802850
  801fc1:	e8 65 ff ff ff       	call   801f2b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801fcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fd4:	e9 b6 00 00 00       	jmp    80208f <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	85 c0                	test   %eax,%eax
  801fec:	75 08                	jne    801ff6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801fee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ff1:	e9 96 00 00 00       	jmp    80208c <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801ff6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ffd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802004:	eb 5d                	jmp    802063 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802006:	a1 20 30 80 00       	mov    0x803020,%eax
  80200b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802011:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802014:	c1 e2 04             	shl    $0x4,%edx
  802017:	01 d0                	add    %edx,%eax
  802019:	8a 40 04             	mov    0x4(%eax),%al
  80201c:	84 c0                	test   %al,%al
  80201e:	75 40                	jne    802060 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802020:	a1 20 30 80 00       	mov    0x803020,%eax
  802025:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80202b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80202e:	c1 e2 04             	shl    $0x4,%edx
  802031:	01 d0                	add    %edx,%eax
  802033:	8b 00                	mov    (%eax),%eax
  802035:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802038:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80203b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802040:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802045:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	01 c8                	add    %ecx,%eax
  802051:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802053:	39 c2                	cmp    %eax,%edx
  802055:	75 09                	jne    802060 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802057:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80205e:	eb 12                	jmp    802072 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802060:	ff 45 e8             	incl   -0x18(%ebp)
  802063:	a1 20 30 80 00       	mov    0x803020,%eax
  802068:	8b 50 74             	mov    0x74(%eax),%edx
  80206b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206e:	39 c2                	cmp    %eax,%edx
  802070:	77 94                	ja     802006 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802072:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802076:	75 14                	jne    80208c <CheckWSWithoutLastIndex+0xef>
			panic(
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 5c 28 80 00       	push   $0x80285c
  802080:	6a 3a                	push   $0x3a
  802082:	68 50 28 80 00       	push   $0x802850
  802087:	e8 9f fe ff ff       	call   801f2b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80208c:	ff 45 f0             	incl   -0x10(%ebp)
  80208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802092:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802095:	0f 8c 3e ff ff ff    	jl     801fd9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80209b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020a9:	eb 20                	jmp    8020cb <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8020ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8020b0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8020b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020b9:	c1 e2 04             	shl    $0x4,%edx
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	8a 40 04             	mov    0x4(%eax),%al
  8020c1:	3c 01                	cmp    $0x1,%al
  8020c3:	75 03                	jne    8020c8 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8020c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020c8:	ff 45 e0             	incl   -0x20(%ebp)
  8020cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8020d0:	8b 50 74             	mov    0x74(%eax),%edx
  8020d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d6:	39 c2                	cmp    %eax,%edx
  8020d8:	77 d1                	ja     8020ab <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020e0:	74 14                	je     8020f6 <CheckWSWithoutLastIndex+0x159>
		panic(
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	68 b0 28 80 00       	push   $0x8028b0
  8020ea:	6a 44                	push   $0x44
  8020ec:	68 50 28 80 00       	push   $0x802850
  8020f1:	e8 35 fe ff ff       	call   801f2b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8020f6:	90                   	nop
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    
  8020f9:	66 90                	xchg   %ax,%ax
  8020fb:	90                   	nop

008020fc <__udivdi3>:
  8020fc:	55                   	push   %ebp
  8020fd:	57                   	push   %edi
  8020fe:	56                   	push   %esi
  8020ff:	53                   	push   %ebx
  802100:	83 ec 1c             	sub    $0x1c,%esp
  802103:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802107:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80210b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80210f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802113:	89 ca                	mov    %ecx,%edx
  802115:	89 f8                	mov    %edi,%eax
  802117:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80211b:	85 f6                	test   %esi,%esi
  80211d:	75 2d                	jne    80214c <__udivdi3+0x50>
  80211f:	39 cf                	cmp    %ecx,%edi
  802121:	77 65                	ja     802188 <__udivdi3+0x8c>
  802123:	89 fd                	mov    %edi,%ebp
  802125:	85 ff                	test   %edi,%edi
  802127:	75 0b                	jne    802134 <__udivdi3+0x38>
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	31 d2                	xor    %edx,%edx
  802130:	f7 f7                	div    %edi
  802132:	89 c5                	mov    %eax,%ebp
  802134:	31 d2                	xor    %edx,%edx
  802136:	89 c8                	mov    %ecx,%eax
  802138:	f7 f5                	div    %ebp
  80213a:	89 c1                	mov    %eax,%ecx
  80213c:	89 d8                	mov    %ebx,%eax
  80213e:	f7 f5                	div    %ebp
  802140:	89 cf                	mov    %ecx,%edi
  802142:	89 fa                	mov    %edi,%edx
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
  80214c:	39 ce                	cmp    %ecx,%esi
  80214e:	77 28                	ja     802178 <__udivdi3+0x7c>
  802150:	0f bd fe             	bsr    %esi,%edi
  802153:	83 f7 1f             	xor    $0x1f,%edi
  802156:	75 40                	jne    802198 <__udivdi3+0x9c>
  802158:	39 ce                	cmp    %ecx,%esi
  80215a:	72 0a                	jb     802166 <__udivdi3+0x6a>
  80215c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802160:	0f 87 9e 00 00 00    	ja     802204 <__udivdi3+0x108>
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	89 fa                	mov    %edi,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	31 ff                	xor    %edi,%edi
  80217a:	31 c0                	xor    %eax,%eax
  80217c:	89 fa                	mov    %edi,%edx
  80217e:	83 c4 1c             	add    $0x1c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    
  802186:	66 90                	xchg   %ax,%ax
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	f7 f7                	div    %edi
  80218c:	31 ff                	xor    %edi,%edi
  80218e:	89 fa                	mov    %edi,%edx
  802190:	83 c4 1c             	add    $0x1c,%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
  802198:	bd 20 00 00 00       	mov    $0x20,%ebp
  80219d:	89 eb                	mov    %ebp,%ebx
  80219f:	29 fb                	sub    %edi,%ebx
  8021a1:	89 f9                	mov    %edi,%ecx
  8021a3:	d3 e6                	shl    %cl,%esi
  8021a5:	89 c5                	mov    %eax,%ebp
  8021a7:	88 d9                	mov    %bl,%cl
  8021a9:	d3 ed                	shr    %cl,%ebp
  8021ab:	89 e9                	mov    %ebp,%ecx
  8021ad:	09 f1                	or     %esi,%ecx
  8021af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021b3:	89 f9                	mov    %edi,%ecx
  8021b5:	d3 e0                	shl    %cl,%eax
  8021b7:	89 c5                	mov    %eax,%ebp
  8021b9:	89 d6                	mov    %edx,%esi
  8021bb:	88 d9                	mov    %bl,%cl
  8021bd:	d3 ee                	shr    %cl,%esi
  8021bf:	89 f9                	mov    %edi,%ecx
  8021c1:	d3 e2                	shl    %cl,%edx
  8021c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021c7:	88 d9                	mov    %bl,%cl
  8021c9:	d3 e8                	shr    %cl,%eax
  8021cb:	09 c2                	or     %eax,%edx
  8021cd:	89 d0                	mov    %edx,%eax
  8021cf:	89 f2                	mov    %esi,%edx
  8021d1:	f7 74 24 0c          	divl   0xc(%esp)
  8021d5:	89 d6                	mov    %edx,%esi
  8021d7:	89 c3                	mov    %eax,%ebx
  8021d9:	f7 e5                	mul    %ebp
  8021db:	39 d6                	cmp    %edx,%esi
  8021dd:	72 19                	jb     8021f8 <__udivdi3+0xfc>
  8021df:	74 0b                	je     8021ec <__udivdi3+0xf0>
  8021e1:	89 d8                	mov    %ebx,%eax
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	e9 58 ff ff ff       	jmp    802142 <__udivdi3+0x46>
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021f0:	89 f9                	mov    %edi,%ecx
  8021f2:	d3 e2                	shl    %cl,%edx
  8021f4:	39 c2                	cmp    %eax,%edx
  8021f6:	73 e9                	jae    8021e1 <__udivdi3+0xe5>
  8021f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021fb:	31 ff                	xor    %edi,%edi
  8021fd:	e9 40 ff ff ff       	jmp    802142 <__udivdi3+0x46>
  802202:	66 90                	xchg   %ax,%ax
  802204:	31 c0                	xor    %eax,%eax
  802206:	e9 37 ff ff ff       	jmp    802142 <__udivdi3+0x46>
  80220b:	90                   	nop

0080220c <__umoddi3>:
  80220c:	55                   	push   %ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 1c             	sub    $0x1c,%esp
  802213:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802217:	8b 74 24 34          	mov    0x34(%esp),%esi
  80221b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802227:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80222b:	89 f3                	mov    %esi,%ebx
  80222d:	89 fa                	mov    %edi,%edx
  80222f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802233:	89 34 24             	mov    %esi,(%esp)
  802236:	85 c0                	test   %eax,%eax
  802238:	75 1a                	jne    802254 <__umoddi3+0x48>
  80223a:	39 f7                	cmp    %esi,%edi
  80223c:	0f 86 a2 00 00 00    	jbe    8022e4 <__umoddi3+0xd8>
  802242:	89 c8                	mov    %ecx,%eax
  802244:	89 f2                	mov    %esi,%edx
  802246:	f7 f7                	div    %edi
  802248:	89 d0                	mov    %edx,%eax
  80224a:	31 d2                	xor    %edx,%edx
  80224c:	83 c4 1c             	add    $0x1c,%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    
  802254:	39 f0                	cmp    %esi,%eax
  802256:	0f 87 ac 00 00 00    	ja     802308 <__umoddi3+0xfc>
  80225c:	0f bd e8             	bsr    %eax,%ebp
  80225f:	83 f5 1f             	xor    $0x1f,%ebp
  802262:	0f 84 ac 00 00 00    	je     802314 <__umoddi3+0x108>
  802268:	bf 20 00 00 00       	mov    $0x20,%edi
  80226d:	29 ef                	sub    %ebp,%edi
  80226f:	89 fe                	mov    %edi,%esi
  802271:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802275:	89 e9                	mov    %ebp,%ecx
  802277:	d3 e0                	shl    %cl,%eax
  802279:	89 d7                	mov    %edx,%edi
  80227b:	89 f1                	mov    %esi,%ecx
  80227d:	d3 ef                	shr    %cl,%edi
  80227f:	09 c7                	or     %eax,%edi
  802281:	89 e9                	mov    %ebp,%ecx
  802283:	d3 e2                	shl    %cl,%edx
  802285:	89 14 24             	mov    %edx,(%esp)
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	d3 e0                	shl    %cl,%eax
  80228c:	89 c2                	mov    %eax,%edx
  80228e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802292:	d3 e0                	shl    %cl,%eax
  802294:	89 44 24 04          	mov    %eax,0x4(%esp)
  802298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80229c:	89 f1                	mov    %esi,%ecx
  80229e:	d3 e8                	shr    %cl,%eax
  8022a0:	09 d0                	or     %edx,%eax
  8022a2:	d3 eb                	shr    %cl,%ebx
  8022a4:	89 da                	mov    %ebx,%edx
  8022a6:	f7 f7                	div    %edi
  8022a8:	89 d3                	mov    %edx,%ebx
  8022aa:	f7 24 24             	mull   (%esp)
  8022ad:	89 c6                	mov    %eax,%esi
  8022af:	89 d1                	mov    %edx,%ecx
  8022b1:	39 d3                	cmp    %edx,%ebx
  8022b3:	0f 82 87 00 00 00    	jb     802340 <__umoddi3+0x134>
  8022b9:	0f 84 91 00 00 00    	je     802350 <__umoddi3+0x144>
  8022bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022c3:	29 f2                	sub    %esi,%edx
  8022c5:	19 cb                	sbb    %ecx,%ebx
  8022c7:	89 d8                	mov    %ebx,%eax
  8022c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022cd:	d3 e0                	shl    %cl,%eax
  8022cf:	89 e9                	mov    %ebp,%ecx
  8022d1:	d3 ea                	shr    %cl,%edx
  8022d3:	09 d0                	or     %edx,%eax
  8022d5:	89 e9                	mov    %ebp,%ecx
  8022d7:	d3 eb                	shr    %cl,%ebx
  8022d9:	89 da                	mov    %ebx,%edx
  8022db:	83 c4 1c             	add    $0x1c,%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5e                   	pop    %esi
  8022e0:	5f                   	pop    %edi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    
  8022e3:	90                   	nop
  8022e4:	89 fd                	mov    %edi,%ebp
  8022e6:	85 ff                	test   %edi,%edi
  8022e8:	75 0b                	jne    8022f5 <__umoddi3+0xe9>
  8022ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ef:	31 d2                	xor    %edx,%edx
  8022f1:	f7 f7                	div    %edi
  8022f3:	89 c5                	mov    %eax,%ebp
  8022f5:	89 f0                	mov    %esi,%eax
  8022f7:	31 d2                	xor    %edx,%edx
  8022f9:	f7 f5                	div    %ebp
  8022fb:	89 c8                	mov    %ecx,%eax
  8022fd:	f7 f5                	div    %ebp
  8022ff:	89 d0                	mov    %edx,%eax
  802301:	e9 44 ff ff ff       	jmp    80224a <__umoddi3+0x3e>
  802306:	66 90                	xchg   %ax,%ax
  802308:	89 c8                	mov    %ecx,%eax
  80230a:	89 f2                	mov    %esi,%edx
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    
  802314:	3b 04 24             	cmp    (%esp),%eax
  802317:	72 06                	jb     80231f <__umoddi3+0x113>
  802319:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80231d:	77 0f                	ja     80232e <__umoddi3+0x122>
  80231f:	89 f2                	mov    %esi,%edx
  802321:	29 f9                	sub    %edi,%ecx
  802323:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802327:	89 14 24             	mov    %edx,(%esp)
  80232a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80232e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802332:	8b 14 24             	mov    (%esp),%edx
  802335:	83 c4 1c             	add    $0x1c,%esp
  802338:	5b                   	pop    %ebx
  802339:	5e                   	pop    %esi
  80233a:	5f                   	pop    %edi
  80233b:	5d                   	pop    %ebp
  80233c:	c3                   	ret    
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	2b 04 24             	sub    (%esp),%eax
  802343:	19 fa                	sbb    %edi,%edx
  802345:	89 d1                	mov    %edx,%ecx
  802347:	89 c6                	mov    %eax,%esi
  802349:	e9 71 ff ff ff       	jmp    8022bf <__umoddi3+0xb3>
  80234e:	66 90                	xchg   %ax,%ax
  802350:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802354:	72 ea                	jb     802340 <__umoddi3+0x134>
  802356:	89 d9                	mov    %ebx,%ecx
  802358:	e9 62 ff ff ff       	jmp    8022bf <__umoddi3+0xb3>
