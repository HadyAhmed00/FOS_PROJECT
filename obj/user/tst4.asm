
obj/user/tst4:     file format elf32-i386


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
  800031:	e8 a9 08 00 00       	call   8008df <libmain>
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
  80003e:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	

	rsttst();
  800044:	e8 83 1f 00 00       	call   801fcc <rsttst>
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 03                	push   $0x3
  80004e:	e8 53 1f 00 00       	call   801fa6 <sys_bypassPageFault>
  800053:	83 c4 10             	add    $0x10,%esp


	
	

	int Mega = 1024*1024;
  800056:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80005d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  800064:	e8 26 1c 00 00       	call   801c8f <sys_calculate_free_frames>
  800069:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  80006c:	8d 55 80             	lea    -0x80(%ebp),%edx
  80006f:	b9 14 00 00 00       	mov    $0x14,%ecx
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	89 d7                	mov    %edx,%edi
  80007b:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  80007d:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  800083:	b9 14 00 00 00       	mov    $0x14,%ecx
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	89 d7                	mov    %edx,%edi
  80008f:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 f9 1b 00 00       	call   801c8f <sys_calculate_free_frames>
  800096:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009c:	01 c0                	add    %eax,%eax
  80009e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	e8 d8 17 00 00       	call   801882 <malloc>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 80             	mov    %eax,-0x80(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000b0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 62                	push   $0x62
  8000ba:	68 00 10 00 80       	push   $0x80001000
  8000bf:	68 00 00 00 80       	push   $0x80000000
  8000c4:	50                   	push   %eax
  8000c5:	e8 1c 1f 00 00       	call   801fe6 <tst>
  8000ca:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000cd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8000d0:	e8 ba 1b 00 00       	call   801c8f <sys_calculate_free_frames>
  8000d5:	29 c3                	sub    %eax,%ebx
  8000d7:	89 d8                	mov    %ebx,%eax
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 65                	push   $0x65
  8000e0:	6a 00                	push   $0x0
  8000e2:	68 01 02 00 00       	push   $0x201
  8000e7:	50                   	push   %eax
  8000e8:	e8 f9 1e 00 00       	call   801fe6 <tst>
  8000ed:	83 c4 20             	add    $0x20,%esp
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000f8:	48                   	dec    %eax
  8000f9:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8000ff:	e8 8b 1b 00 00       	call   801c8f <sys_calculate_free_frames>
  800104:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80010a:	01 c0                	add    %eax,%eax
  80010c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	50                   	push   %eax
  800113:	e8 6a 17 00 00       	call   801882 <malloc>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  80011e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800121:	01 c0                	add    %eax,%eax
  800123:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012c:	01 c0                	add    %eax,%eax
  80012e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800134:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	6a 00                	push   $0x0
  80013c:	6a 62                	push   $0x62
  80013e:	51                   	push   %ecx
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	e8 a0 1e 00 00       	call   801fe6 <tst>
  800146:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800149:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80014c:	e8 3e 1b 00 00       	call   801c8f <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	6a 00                	push   $0x0
  80015a:	6a 65                	push   $0x65
  80015c:	6a 00                	push   $0x0
  80015e:	68 00 02 00 00       	push   $0x200
  800163:	50                   	push   %eax
  800164:	e8 7d 1e 00 00       	call   801fe6 <tst>
  800169:	83 c4 20             	add    $0x20,%esp
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  80016c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016f:	01 c0                	add    %eax,%eax
  800171:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800174:	48                   	dec    %eax
  800175:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  80017b:	e8 0f 1b 00 00       	call   801c8f <sys_calculate_free_frames>
  800180:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800183:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800186:	01 c0                	add    %eax,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	e8 f1 16 00 00       	call   801882 <malloc>
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019a:	c1 e0 02             	shl    $0x2,%eax
  80019d:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a6:	c1 e0 02             	shl    $0x2,%eax
  8001a9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001af:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 62                	push   $0x62
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	e8 25 1e 00 00       	call   801fe6 <tst>
  8001c1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  8001c4:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8001c7:	e8 c3 1a 00 00       	call   801c8f <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	6a 65                	push   $0x65
  8001d7:	6a 00                	push   $0x0
  8001d9:	6a 02                	push   $0x2
  8001db:	50                   	push   %eax
  8001dc:	e8 05 1e 00 00       	call   801fe6 <tst>
  8001e1:	83 c4 20             	add    $0x20,%esp
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	01 c0                	add    %eax,%eax
  8001e9:	48                   	dec    %eax
  8001ea:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8001f0:	e8 9a 1a 00 00       	call   801c8f <sys_calculate_free_frames>
  8001f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	e8 7c 16 00 00       	call   801882 <malloc>
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega + 4*kilo,USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE, 'b', 0);
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	89 c2                	mov    %eax,%edx
  800214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800217:	c1 e0 02             	shl    $0x2,%eax
  80021a:	01 d0                	add    %edx,%eax
  80021c:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800225:	c1 e0 02             	shl    $0x2,%eax
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022d:	c1 e0 02             	shl    $0x2,%eax
  800230:	01 d0                	add    %edx,%eax
  800232:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800238:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	6a 00                	push   $0x0
  800240:	6a 62                	push   $0x62
  800242:	51                   	push   %ecx
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	e8 9c 1d 00 00       	call   801fe6 <tst>
  80024a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  80024d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800250:	e8 3a 1a 00 00       	call   801c8f <sys_calculate_free_frames>
  800255:	29 c3                	sub    %eax,%ebx
  800257:	89 d8                	mov    %ebx,%eax
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	6a 65                	push   $0x65
  800260:	6a 00                	push   $0x0
  800262:	6a 01                	push   $0x1
  800264:	50                   	push   %eax
  800265:	e8 7c 1d 00 00       	call   801fe6 <tst>
  80026a:	83 c4 20             	add    $0x20,%esp
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	01 c0                	add    %eax,%eax
  800272:	48                   	dec    %eax
  800273:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800279:	e8 11 1a 00 00       	call   801c8f <sys_calculate_free_frames>
  80027e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800284:	89 d0                	mov    %edx,%eax
  800286:	01 c0                	add    %eax,%eax
  800288:	01 d0                	add    %edx,%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	01 d0                	add    %edx,%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 eb 15 00 00       	call   801882 <malloc>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega + 8*kilo,USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE, 'b', 0);
  80029d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a0:	c1 e0 02             	shl    $0x2,%eax
  8002a3:	89 c2                	mov    %eax,%edx
  8002a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a8:	c1 e0 03             	shl    $0x3,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	c1 e0 02             	shl    $0x2,%eax
  8002b9:	89 c2                	mov    %eax,%edx
  8002bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002be:	c1 e0 03             	shl    $0x3,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	6a 00                	push   $0x0
  8002d1:	6a 62                	push   $0x62
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	e8 0b 1d 00 00       	call   801fe6 <tst>
  8002db:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2 ,0, 'e', 0);
  8002de:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8002e1:	e8 a9 19 00 00       	call   801c8f <sys_calculate_free_frames>
  8002e6:	29 c3                	sub    %eax,%ebx
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 00                	push   $0x0
  8002ef:	6a 65                	push   $0x65
  8002f1:	6a 00                	push   $0x0
  8002f3:	6a 02                	push   $0x2
  8002f5:	50                   	push   %eax
  8002f6:	e8 eb 1c 00 00       	call   801fe6 <tst>
  8002fb:	83 c4 20             	add    $0x20,%esp
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  8002fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	01 c0                	add    %eax,%eax
  800305:	01 d0                	add    %edx,%eax
  800307:	01 c0                	add    %eax,%eax
  800309:	01 d0                	add    %edx,%eax
  80030b:	48                   	dec    %eax
  80030c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 78 19 00 00       	call   801c8f <sys_calculate_free_frames>
  800317:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	89 c2                	mov    %eax,%edx
  80031f:	01 d2                	add    %edx,%edx
  800321:	01 d0                	add    %edx,%eax
  800323:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	50                   	push   %eax
  80032a:	e8 53 15 00 00       	call   801882 <malloc>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega + 16*kilo,USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  800335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800338:	c1 e0 02             	shl    $0x2,%eax
  80033b:	89 c2                	mov    %eax,%edx
  80033d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800340:	c1 e0 04             	shl    $0x4,%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034e:	c1 e0 02             	shl    $0x2,%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800356:	c1 e0 04             	shl    $0x4,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800361:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	6a 00                	push   $0x0
  800369:	6a 62                	push   $0x62
  80036b:	51                   	push   %ecx
  80036c:	52                   	push   %edx
  80036d:	50                   	push   %eax
  80036e:	e8 73 1c 00 00       	call   801fe6 <tst>
  800373:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  800376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	85 c0                	test   %eax,%eax
  800381:	79 05                	jns    800388 <_main+0x350>
  800383:	05 ff 0f 00 00       	add    $0xfff,%eax
  800388:	c1 f8 0c             	sar    $0xc,%eax
  80038b:	89 c3                	mov    %eax,%ebx
  80038d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800390:	e8 fa 18 00 00       	call   801c8f <sys_calculate_free_frames>
  800395:	29 c6                	sub    %eax,%esi
  800397:	89 f0                	mov    %esi,%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	6a 00                	push   $0x0
  80039e:	6a 65                	push   $0x65
  8003a0:	6a 00                	push   $0x0
  8003a2:	53                   	push   %ebx
  8003a3:	50                   	push   %eax
  8003a4:	e8 3d 1c 00 00       	call   801fe6 <tst>
  8003a9:	83 c4 20             	add    $0x20,%esp
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003af:	89 c2                	mov    %eax,%edx
  8003b1:	01 d2                	add    %edx,%edx
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003b8:	48                   	dec    %eax
  8003b9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8003bf:	e8 cb 18 00 00       	call   801c8f <sys_calculate_free_frames>
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	01 c0                	add    %eax,%eax
  8003cc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	50                   	push   %eax
  8003d3:	e8 aa 14 00 00       	call   801882 <malloc>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega + 16*kilo,USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  8003de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e1:	89 d0                	mov    %edx,%eax
  8003e3:	01 c0                	add    %eax,%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	01 c0                	add    %eax,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	89 c2                	mov    %eax,%edx
  8003ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f0:	c1 e0 04             	shl    $0x4,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8003fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	89 c2                	mov    %eax,%edx
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	c1 e0 04             	shl    $0x4,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800418:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	6a 00                	push   $0x0
  800420:	6a 62                	push   $0x62
  800422:	51                   	push   %ecx
  800423:	52                   	push   %edx
  800424:	50                   	push   %eax
  800425:	e8 bc 1b 00 00       	call   801fe6 <tst>
  80042a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  80042d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800430:	e8 5a 18 00 00       	call   801c8f <sys_calculate_free_frames>
  800435:	29 c3                	sub    %eax,%ebx
  800437:	89 d8                	mov    %ebx,%eax
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	6a 00                	push   $0x0
  80043e:	6a 65                	push   $0x65
  800440:	6a 00                	push   $0x0
  800442:	68 01 02 00 00       	push   $0x201
  800447:	50                   	push   %eax
  800448:	e8 99 1b 00 00       	call   801fe6 <tst>
  80044d:	83 c4 20             	add    $0x20,%esp
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	01 c0                	add    %eax,%eax
  800455:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  80045f:	e8 2b 18 00 00       	call   801c8f <sys_calculate_free_frames>
  800464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800467:	8b 45 80             	mov    -0x80(%ebp),%eax
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	50                   	push   %eax
  80046e:	e8 c5 15 00 00       	call   801a38 <free>
  800473:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 ,0, 'e', 0);
  800476:	e8 14 18 00 00       	call   801c8f <sys_calculate_free_frames>
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 d0                	mov    %edx,%eax
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	6a 00                	push   $0x0
  800489:	6a 65                	push   $0x65
  80048b:	6a 00                	push   $0x0
  80048d:	68 00 02 00 00       	push   $0x200
  800492:	50                   	push   %eax
  800493:	e8 4e 1b 00 00       	call   801fe6 <tst>
  800498:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[0];
  80049b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80049e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004a4:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8004a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004aa:	e8 de 1a 00 00       	call   801f8d <sys_rcr2>
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	6a 00                	push   $0x0
  8004b4:	6a 65                	push   $0x65
  8004b6:	6a 00                	push   $0x0
  8004b8:	53                   	push   %ebx
  8004b9:	50                   	push   %eax
  8004ba:	e8 27 1b 00 00       	call   801fe6 <tst>
  8004bf:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[0]] = 10;
  8004c2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004c8:	89 c2                	mov    %eax,%edx
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[0]]) ,0, 'e', 0);
  8004d2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004d8:	89 c2                	mov    %eax,%edx
  8004da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004dd:	01 d0                	add    %edx,%eax
  8004df:	89 c3                	mov    %eax,%ebx
  8004e1:	e8 a7 1a 00 00       	call   801f8d <sys_rcr2>
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	6a 00                	push   $0x0
  8004eb:	6a 65                	push   $0x65
  8004ed:	6a 00                	push   $0x0
  8004ef:	53                   	push   %ebx
  8004f0:	50                   	push   %eax
  8004f1:	e8 f0 1a 00 00       	call   801fe6 <tst>
  8004f6:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8004f9:	e8 91 17 00 00       	call   801c8f <sys_calculate_free_frames>
  8004fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800501:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	50                   	push   %eax
  800508:	e8 2b 15 00 00       	call   801a38 <free>
  80050d:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 +1,0, 'e', 0);
  800510:	e8 7a 17 00 00       	call   801c8f <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051a:	29 c2                	sub    %eax,%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	6a 00                	push   $0x0
  800523:	6a 65                	push   $0x65
  800525:	6a 00                	push   $0x0
  800527:	68 01 02 00 00       	push   $0x201
  80052c:	50                   	push   %eax
  80052d:	e8 b4 1a 00 00       	call   801fe6 <tst>
  800532:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[1];
  800535:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800538:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80053b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80053e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800541:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800544:	e8 44 1a 00 00       	call   801f8d <sys_rcr2>
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	6a 00                	push   $0x0
  80054e:	6a 65                	push   $0x65
  800550:	6a 00                	push   $0x0
  800552:	53                   	push   %ebx
  800553:	50                   	push   %eax
  800554:	e8 8d 1a 00 00       	call   801fe6 <tst>
  800559:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[1]] = 10;
  80055c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800562:	89 c2                	mov    %eax,%edx
  800564:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[1]]) ,0, 'e', 0);
  80056c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800572:	89 c2                	mov    %eax,%edx
  800574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	89 c3                	mov    %eax,%ebx
  80057b:	e8 0d 1a 00 00       	call   801f8d <sys_rcr2>
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	6a 65                	push   $0x65
  800587:	6a 00                	push   $0x0
  800589:	53                   	push   %ebx
  80058a:	50                   	push   %eax
  80058b:	e8 56 1a 00 00       	call   801fe6 <tst>
  800590:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800593:	e8 f7 16 00 00       	call   801c8f <sys_calculate_free_frames>
  800598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80059b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 91 14 00 00       	call   801a38 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  8005aa:	e8 e0 16 00 00       	call   801c8f <sys_calculate_free_frames>
  8005af:	89 c2                	mov    %eax,%edx
  8005b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b4:	29 c2                	sub    %eax,%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	83 ec 0c             	sub    $0xc,%esp
  8005bb:	6a 00                	push   $0x0
  8005bd:	6a 65                	push   $0x65
  8005bf:	6a 00                	push   $0x0
  8005c1:	6a 01                	push   $0x1
  8005c3:	50                   	push   %eax
  8005c4:	e8 1d 1a 00 00       	call   801fe6 <tst>
  8005c9:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[2];
  8005cc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8005d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d5:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8005d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005db:	e8 ad 19 00 00       	call   801f8d <sys_rcr2>
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	6a 00                	push   $0x0
  8005e5:	6a 65                	push   $0x65
  8005e7:	6a 00                	push   $0x0
  8005e9:	53                   	push   %ebx
  8005ea:	50                   	push   %eax
  8005eb:	e8 f6 19 00 00       	call   801fe6 <tst>
  8005f0:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[2]] = 10;
  8005f3:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8005f9:	89 c2                	mov    %eax,%edx
  8005fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fe:	01 d0                	add    %edx,%eax
  800600:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[2]]) ,0, 'e', 0);
  800603:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800609:	89 c2                	mov    %eax,%edx
  80060b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060e:	01 d0                	add    %edx,%eax
  800610:	89 c3                	mov    %eax,%ebx
  800612:	e8 76 19 00 00       	call   801f8d <sys_rcr2>
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	6a 00                	push   $0x0
  80061c:	6a 65                	push   $0x65
  80061e:	6a 00                	push   $0x0
  800620:	53                   	push   %ebx
  800621:	50                   	push   %eax
  800622:	e8 bf 19 00 00       	call   801fe6 <tst>
  800627:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80062a:	e8 60 16 00 00       	call   801c8f <sys_calculate_free_frames>
  80062f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800632:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 fa 13 00 00       	call   801a38 <free>
  80063e:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  800641:	e8 49 16 00 00       	call   801c8f <sys_calculate_free_frames>
  800646:	89 c2                	mov    %eax,%edx
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	29 c2                	sub    %eax,%edx
  80064d:	89 d0                	mov    %edx,%eax
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	6a 00                	push   $0x0
  800654:	6a 65                	push   $0x65
  800656:	6a 00                	push   $0x0
  800658:	6a 01                	push   $0x1
  80065a:	50                   	push   %eax
  80065b:	e8 86 19 00 00       	call   801fe6 <tst>
  800660:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[3];
  800663:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800666:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800669:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066c:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80066f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800672:	e8 16 19 00 00       	call   801f8d <sys_rcr2>
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	6a 00                	push   $0x0
  80067c:	6a 65                	push   $0x65
  80067e:	6a 00                	push   $0x0
  800680:	53                   	push   %ebx
  800681:	50                   	push   %eax
  800682:	e8 5f 19 00 00       	call   801fe6 <tst>
  800687:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[3]] = 10;
  80068a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800690:	89 c2                	mov    %eax,%edx
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[3]]) ,0, 'e', 0);
  80069a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a5:	01 d0                	add    %edx,%eax
  8006a7:	89 c3                	mov    %eax,%ebx
  8006a9:	e8 df 18 00 00       	call   801f8d <sys_rcr2>
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	6a 00                	push   $0x0
  8006b3:	6a 65                	push   $0x65
  8006b5:	6a 00                	push   $0x0
  8006b7:	53                   	push   %ebx
  8006b8:	50                   	push   %eax
  8006b9:	e8 28 19 00 00       	call   801fe6 <tst>
  8006be:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8006c1:	e8 c9 15 00 00       	call   801c8f <sys_calculate_free_frames>
  8006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  8006c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	50                   	push   %eax
  8006d0:	e8 63 13 00 00       	call   801a38 <free>
  8006d5:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 2 ,0, 'e', 0);
  8006d8:	e8 b2 15 00 00       	call   801c8f <sys_calculate_free_frames>
  8006dd:	89 c2                	mov    %eax,%edx
  8006df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e2:	29 c2                	sub    %eax,%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	6a 00                	push   $0x0
  8006eb:	6a 65                	push   $0x65
  8006ed:	6a 00                	push   $0x0
  8006ef:	6a 02                	push   $0x2
  8006f1:	50                   	push   %eax
  8006f2:	e8 ef 18 00 00       	call   801fe6 <tst>
  8006f7:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[4];
  8006fa:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800703:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800706:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800709:	e8 7f 18 00 00       	call   801f8d <sys_rcr2>
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	6a 00                	push   $0x0
  800713:	6a 65                	push   $0x65
  800715:	6a 00                	push   $0x0
  800717:	53                   	push   %ebx
  800718:	50                   	push   %eax
  800719:	e8 c8 18 00 00       	call   801fe6 <tst>
  80071e:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[4]] = 10;
  800721:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800727:	89 c2                	mov    %eax,%edx
  800729:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072c:	01 d0                	add    %edx,%eax
  80072e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[4]]) ,0, 'e', 0);
  800731:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800737:	89 c2                	mov    %eax,%edx
  800739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	e8 48 18 00 00       	call   801f8d <sys_rcr2>
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	6a 00                	push   $0x0
  80074a:	6a 65                	push   $0x65
  80074c:	6a 00                	push   $0x0
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	e8 91 18 00 00       	call   801fe6 <tst>
  800755:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800758:	e8 32 15 00 00       	call   801c8f <sys_calculate_free_frames>
  80075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  800760:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	50                   	push   %eax
  800767:	e8 cc 12 00 00       	call   801a38 <free>
  80076c:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 3*Mega/4096 ,0, 'e', 0);
  80076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	01 d2                	add    %edx,%edx
  800776:	01 d0                	add    %edx,%eax
  800778:	85 c0                	test   %eax,%eax
  80077a:	79 05                	jns    800781 <_main+0x749>
  80077c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800781:	c1 f8 0c             	sar    $0xc,%eax
  800784:	89 c3                	mov    %eax,%ebx
  800786:	e8 04 15 00 00       	call   801c8f <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800790:	29 c2                	sub    %eax,%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	6a 00                	push   $0x0
  800799:	6a 65                	push   $0x65
  80079b:	6a 00                	push   $0x0
  80079d:	53                   	push   %ebx
  80079e:	50                   	push   %eax
  80079f:	e8 42 18 00 00       	call   801fe6 <tst>
  8007a4:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[5];
  8007a7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8007ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b0:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8007b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007b6:	e8 d2 17 00 00       	call   801f8d <sys_rcr2>
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	6a 00                	push   $0x0
  8007c0:	6a 65                	push   $0x65
  8007c2:	6a 00                	push   $0x0
  8007c4:	53                   	push   %ebx
  8007c5:	50                   	push   %eax
  8007c6:	e8 1b 18 00 00       	call   801fe6 <tst>
  8007cb:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[5]] = 10;
  8007ce:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007d4:	89 c2                	mov    %eax,%edx
  8007d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[5]]) ,0, 'e', 0);
  8007de:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e9:	01 d0                	add    %edx,%eax
  8007eb:	89 c3                	mov    %eax,%ebx
  8007ed:	e8 9b 17 00 00       	call   801f8d <sys_rcr2>
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	6a 00                	push   $0x0
  8007f7:	6a 65                	push   $0x65
  8007f9:	6a 00                	push   $0x0
  8007fb:	53                   	push   %ebx
  8007fc:	50                   	push   %eax
  8007fd:	e8 e4 17 00 00       	call   801fe6 <tst>
  800802:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800805:	e8 85 14 00 00       	call   801c8f <sys_calculate_free_frames>
  80080a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  80080d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	50                   	push   %eax
  800814:	e8 1f 12 00 00       	call   801a38 <free>
  800819:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512+2,0, 'e', 0);
  80081c:	e8 6e 14 00 00       	call   801c8f <sys_calculate_free_frames>
  800821:	89 c2                	mov    %eax,%edx
  800823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800826:	29 c2                	sub    %eax,%edx
  800828:	89 d0                	mov    %edx,%eax
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	6a 00                	push   $0x0
  80082f:	6a 65                	push   $0x65
  800831:	6a 00                	push   $0x0
  800833:	68 02 02 00 00       	push   $0x202
  800838:	50                   	push   %eax
  800839:	e8 a8 17 00 00       	call   801fe6 <tst>
  80083e:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[6];
  800841:	8b 45 98             	mov    -0x68(%ebp),%eax
  800844:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800847:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80084a:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80084d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800850:	e8 38 17 00 00       	call   801f8d <sys_rcr2>
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	6a 00                	push   $0x0
  80085a:	6a 65                	push   $0x65
  80085c:	6a 00                	push   $0x0
  80085e:	53                   	push   %ebx
  80085f:	50                   	push   %eax
  800860:	e8 81 17 00 00       	call   801fe6 <tst>
  800865:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[6]] = 10;
  800868:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80086e:	89 c2                	mov    %eax,%edx
  800870:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800873:	01 d0                	add    %edx,%eax
  800875:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[6]]) ,0, 'e', 0);
  800878:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80087e:	89 c2                	mov    %eax,%edx
  800880:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800883:	01 d0                	add    %edx,%eax
  800885:	89 c3                	mov    %eax,%ebx
  800887:	e8 01 17 00 00       	call   801f8d <sys_rcr2>
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	6a 00                	push   $0x0
  800891:	6a 65                	push   $0x65
  800893:	6a 00                	push   $0x0
  800895:	53                   	push   %ebx
  800896:	50                   	push   %eax
  800897:	e8 4a 17 00 00       	call   801fe6 <tst>
  80089c:	83 c4 20             	add    $0x20,%esp

		tst(start_freeFrames, sys_calculate_free_frames() ,0, 'e', 0);
  80089f:	e8 eb 13 00 00       	call   801c8f <sys_calculate_free_frames>
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008a9:	83 ec 0c             	sub    $0xc,%esp
  8008ac:	6a 00                	push   $0x0
  8008ae:	6a 65                	push   $0x65
  8008b0:	6a 00                	push   $0x0
  8008b2:	52                   	push   %edx
  8008b3:	50                   	push   %eax
  8008b4:	e8 2d 17 00 00       	call   801fe6 <tst>
  8008b9:	83 c4 20             	add    $0x20,%esp
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	6a 00                	push   $0x0
  8008c1:	e8 e0 16 00 00       	call   801fa6 <sys_bypassPageFault>
  8008c6:	83 c4 10             	add    $0x10,%esp

	chktst(36);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 24                	push   $0x24
  8008ce:	e8 3e 17 00 00       	call   802011 <chktst>
  8008d3:	83 c4 10             	add    $0x10,%esp

	return;
  8008d6:	90                   	nop
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008e5:	e8 da 12 00 00       	call   801bc4 <sys_getenvindex>
  8008ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 03             	shl    $0x3,%eax
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8008fe:	01 c8                	add    %ecx,%eax
  800900:	01 c0                	add    %eax,%eax
  800902:	01 d0                	add    %edx,%eax
  800904:	01 c0                	add    %eax,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	89 c2                	mov    %eax,%edx
  80090a:	c1 e2 05             	shl    $0x5,%edx
  80090d:	29 c2                	sub    %eax,%edx
  80090f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800916:	89 c2                	mov    %eax,%edx
  800918:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80091e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800923:	a1 20 30 80 00       	mov    0x803020,%eax
  800928:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80092e:	84 c0                	test   %al,%al
  800930:	74 0f                	je     800941 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800932:	a1 20 30 80 00       	mov    0x803020,%eax
  800937:	05 40 3c 01 00       	add    $0x13c40,%eax
  80093c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800945:	7e 0a                	jle    800951 <libmain+0x72>
		binaryname = argv[0];
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	e8 d9 f6 ff ff       	call   800038 <_main>
  80095f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800962:	e8 f8 13 00 00       	call   801d5f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800967:	83 ec 0c             	sub    $0xc,%esp
  80096a:	68 d8 25 80 00       	push   $0x8025d8
  80096f:	e8 84 01 00 00       	call   800af8 <cprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800977:	a1 20 30 80 00       	mov    0x803020,%eax
  80097c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800982:	a1 20 30 80 00       	mov    0x803020,%eax
  800987:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80098d:	83 ec 04             	sub    $0x4,%esp
  800990:	52                   	push   %edx
  800991:	50                   	push   %eax
  800992:	68 00 26 80 00       	push   $0x802600
  800997:	e8 5c 01 00 00       	call   800af8 <cprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80099f:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a4:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8009af:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009b5:	83 ec 04             	sub    $0x4,%esp
  8009b8:	52                   	push   %edx
  8009b9:	50                   	push   %eax
  8009ba:	68 28 26 80 00       	push   $0x802628
  8009bf:	e8 34 01 00 00       	call   800af8 <cprintf>
  8009c4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8009cc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	50                   	push   %eax
  8009d6:	68 69 26 80 00       	push   $0x802669
  8009db:	e8 18 01 00 00       	call   800af8 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	68 d8 25 80 00       	push   $0x8025d8
  8009eb:	e8 08 01 00 00       	call   800af8 <cprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f3:	e8 81 13 00 00       	call   801d79 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009f8:	e8 19 00 00 00       	call   800a16 <exit>
}
  8009fd:	90                   	nop
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a06:	83 ec 0c             	sub    $0xc,%esp
  800a09:	6a 00                	push   $0x0
  800a0b:	e8 80 11 00 00       	call   801b90 <sys_env_destroy>
  800a10:	83 c4 10             	add    $0x10,%esp
}
  800a13:	90                   	nop
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <exit>:

void
exit(void)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a1c:	e8 d5 11 00 00       	call   801bf6 <sys_env_exit>
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a35:	89 0a                	mov    %ecx,(%edx)
  800a37:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3a:	88 d1                	mov    %dl,%cl
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4d:	75 2c                	jne    800a7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a4f:	a0 24 30 80 00       	mov    0x803024,%al
  800a54:	0f b6 c0             	movzbl %al,%eax
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8b 12                	mov    (%edx),%edx
  800a5c:	89 d1                	mov    %edx,%ecx
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	83 c2 08             	add    $0x8,%edx
  800a64:	83 ec 04             	sub    $0x4,%esp
  800a67:	50                   	push   %eax
  800a68:	51                   	push   %ecx
  800a69:	52                   	push   %edx
  800a6a:	e8 df 10 00 00       	call   801b4e <sys_cputs>
  800a6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 40 04             	mov    0x4(%eax),%eax
  800a81:	8d 50 01             	lea    0x1(%eax),%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a8a:	90                   	nop
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a9d:	00 00 00 
	b.cnt = 0;
  800aa0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	ff 75 08             	pushl  0x8(%ebp)
  800ab0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab6:	50                   	push   %eax
  800ab7:	68 24 0a 80 00       	push   $0x800a24
  800abc:	e8 11 02 00 00       	call   800cd2 <vprintfmt>
  800ac1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ac4:	a0 24 30 80 00       	mov    0x803024,%al
  800ac9:	0f b6 c0             	movzbl %al,%eax
  800acc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	50                   	push   %eax
  800ad6:	52                   	push   %edx
  800ad7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800add:	83 c0 08             	add    $0x8,%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 68 10 00 00       	call   801b4e <sys_cputs>
  800ae6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae9:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800af0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800afe:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	50                   	push   %eax
  800b15:	e8 73 ff ff ff       	call   800a8d <vcprintf>
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b2b:	e8 2f 12 00 00       	call   801d5f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	e8 48 ff ff ff       	call   800a8d <vcprintf>
  800b45:	83 c4 10             	add    $0x10,%esp
  800b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b4b:	e8 29 12 00 00       	call   801d79 <sys_enable_interrupt>
	return cnt;
  800b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	83 ec 14             	sub    $0x14,%esp
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b68:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b73:	77 55                	ja     800bca <printnum+0x75>
  800b75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b78:	72 05                	jb     800b7f <printnum+0x2a>
  800b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b7d:	77 4b                	ja     800bca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b85:	8b 45 18             	mov    0x18(%ebp),%eax
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8d:	52                   	push   %edx
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	ff 75 f0             	pushl  -0x10(%ebp)
  800b95:	e8 b6 17 00 00       	call   802350 <__udivdi3>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	ff 75 20             	pushl  0x20(%ebp)
  800ba3:	53                   	push   %ebx
  800ba4:	ff 75 18             	pushl  0x18(%ebp)
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 a1 ff ff ff       	call   800b55 <printnum>
  800bb4:	83 c4 20             	add    $0x20,%esp
  800bb7:	eb 1a                	jmp    800bd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	ff 75 20             	pushl  0x20(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bca:	ff 4d 1c             	decl   0x1c(%ebp)
  800bcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bd1:	7f e6                	jg     800bb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	53                   	push   %ebx
  800be2:	51                   	push   %ecx
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	e8 76 18 00 00       	call   802460 <__umoddi3>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	05 94 28 80 00       	add    $0x802894,%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	0f be c0             	movsbl %al,%eax
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	50                   	push   %eax
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
}
  800c06:	90                   	nop
  800c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c0f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c13:	7e 1c                	jle    800c31 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	8d 50 08             	lea    0x8(%eax),%edx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 10                	mov    %edx,(%eax)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	83 e8 08             	sub    $0x8,%eax
  800c2a:	8b 50 04             	mov    0x4(%eax),%edx
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	eb 40                	jmp    800c71 <getuint+0x65>
	else if (lflag)
  800c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c35:	74 1e                	je     800c55 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	eb 1c                	jmp    800c71 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	8d 50 04             	lea    0x4(%eax),%edx
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	89 10                	mov    %edx,(%eax)
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8b 00                	mov    (%eax),%eax
  800c67:	83 e8 04             	sub    $0x4,%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c76:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c7a:	7e 1c                	jle    800c98 <getint+0x25>
		return va_arg(*ap, long long);
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	8d 50 08             	lea    0x8(%eax),%edx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 10                	mov    %edx,(%eax)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 e8 08             	sub    $0x8,%eax
  800c91:	8b 50 04             	mov    0x4(%eax),%edx
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	eb 38                	jmp    800cd0 <getint+0x5d>
	else if (lflag)
  800c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9c:	74 1a                	je     800cb8 <getint+0x45>
		return va_arg(*ap, long);
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	8d 50 04             	lea    0x4(%eax),%edx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 10                	mov    %edx,(%eax)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	99                   	cltd   
  800cb6:	eb 18                	jmp    800cd0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 50 04             	lea    0x4(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 10                	mov    %edx,(%eax)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	83 e8 04             	sub    $0x4,%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	99                   	cltd   
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cda:	eb 17                	jmp    800cf3 <vprintfmt+0x21>
			if (ch == '\0')
  800cdc:	85 db                	test   %ebx,%ebx
  800cde:	0f 84 af 03 00 00    	je     801093 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	53                   	push   %ebx
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 d8             	movzbl %al,%ebx
  800d01:	83 fb 25             	cmp    $0x25,%ebx
  800d04:	75 d6                	jne    800cdc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d06:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d8             	movzbl %al,%ebx
  800d34:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d37:	83 f8 55             	cmp    $0x55,%eax
  800d3a:	0f 87 2b 03 00 00    	ja     80106b <vprintfmt+0x399>
  800d40:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  800d47:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d49:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d4d:	eb d7                	jmp    800d26 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d4f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d53:	eb d1                	jmp    800d26 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d5f:	89 d0                	mov    %edx,%eax
  800d61:	c1 e0 02             	shl    $0x2,%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	01 c0                	add    %eax,%eax
  800d68:	01 d8                	add    %ebx,%eax
  800d6a:	83 e8 30             	sub    $0x30,%eax
  800d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d78:	83 fb 2f             	cmp    $0x2f,%ebx
  800d7b:	7e 3e                	jle    800dbb <vprintfmt+0xe9>
  800d7d:	83 fb 39             	cmp    $0x39,%ebx
  800d80:	7f 39                	jg     800dbb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d82:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d85:	eb d5                	jmp    800d5c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d87:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8a:	83 c0 04             	add    $0x4,%eax
  800d8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	83 e8 04             	sub    $0x4,%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d9b:	eb 1f                	jmp    800dbc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da1:	79 83                	jns    800d26 <vprintfmt+0x54>
				width = 0;
  800da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800daa:	e9 77 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800daf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800db6:	e9 6b ff ff ff       	jmp    800d26 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dbb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc0:	0f 89 60 ff ff ff    	jns    800d26 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dcc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dd3:	e9 4e ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dd8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ddb:	e9 46 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			break;
  800e00:	e9 89 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e05:	8b 45 14             	mov    0x14(%ebp),%eax
  800e08:	83 c0 04             	add    $0x4,%eax
  800e0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 e8 04             	sub    $0x4,%eax
  800e14:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e16:	85 db                	test   %ebx,%ebx
  800e18:	79 02                	jns    800e1c <vprintfmt+0x14a>
				err = -err;
  800e1a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e1c:	83 fb 64             	cmp    $0x64,%ebx
  800e1f:	7f 0b                	jg     800e2c <vprintfmt+0x15a>
  800e21:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800e28:	85 f6                	test   %esi,%esi
  800e2a:	75 19                	jne    800e45 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e2c:	53                   	push   %ebx
  800e2d:	68 a5 28 80 00       	push   $0x8028a5
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	ff 75 08             	pushl  0x8(%ebp)
  800e38:	e8 5e 02 00 00       	call   80109b <printfmt>
  800e3d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e40:	e9 49 02 00 00       	jmp    80108e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e45:	56                   	push   %esi
  800e46:	68 ae 28 80 00       	push   $0x8028ae
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	ff 75 08             	pushl  0x8(%ebp)
  800e51:	e8 45 02 00 00       	call   80109b <printfmt>
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 30 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 30                	mov    (%eax),%esi
  800e6f:	85 f6                	test   %esi,%esi
  800e71:	75 05                	jne    800e78 <vprintfmt+0x1a6>
				p = "(null)";
  800e73:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7e 6d                	jle    800eeb <vprintfmt+0x219>
  800e7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e82:	74 67                	je     800eeb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	50                   	push   %eax
  800e8b:	56                   	push   %esi
  800e8c:	e8 0c 03 00 00       	call   80119d <strnlen>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e97:	eb 16                	jmp    800eaf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e99:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	50                   	push   %eax
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	ff d0                	call   *%eax
  800ea9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eac:	ff 4d e4             	decl   -0x1c(%ebp)
  800eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb3:	7f e4                	jg     800e99 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb5:	eb 34                	jmp    800eeb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ebb:	74 1c                	je     800ed9 <vprintfmt+0x207>
  800ebd:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec0:	7e 05                	jle    800ec7 <vprintfmt+0x1f5>
  800ec2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec5:	7e 12                	jle    800ed9 <vprintfmt+0x207>
					putch('?', putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	6a 3f                	push   $0x3f
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	ff d0                	call   *%eax
  800ed4:	83 c4 10             	add    $0x10,%esp
  800ed7:	eb 0f                	jmp    800ee8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	53                   	push   %ebx
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee8:	ff 4d e4             	decl   -0x1c(%ebp)
  800eeb:	89 f0                	mov    %esi,%eax
  800eed:	8d 70 01             	lea    0x1(%eax),%esi
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f be d8             	movsbl %al,%ebx
  800ef5:	85 db                	test   %ebx,%ebx
  800ef7:	74 24                	je     800f1d <vprintfmt+0x24b>
  800ef9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efd:	78 b8                	js     800eb7 <vprintfmt+0x1e5>
  800eff:	ff 4d e0             	decl   -0x20(%ebp)
  800f02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f06:	79 af                	jns    800eb7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f08:	eb 13                	jmp    800f1d <vprintfmt+0x24b>
				putch(' ', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 20                	push   $0x20
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f21:	7f e7                	jg     800f0a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f23:	e9 66 01 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	e8 3c fd ff ff       	call   800c73 <getint>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f46:	85 d2                	test   %edx,%edx
  800f48:	79 23                	jns    800f6d <vprintfmt+0x29b>
				putch('-', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 2d                	push   $0x2d
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	f7 d8                	neg    %eax
  800f62:	83 d2 00             	adc    $0x0,%edx
  800f65:	f7 da                	neg    %edx
  800f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f74:	e9 bc 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	e8 84 fc ff ff       	call   800c0c <getuint>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f98:	e9 98 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 58                	push   $0x58
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	6a 58                	push   $0x58
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	ff d0                	call   *%eax
  800fba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	6a 58                	push   $0x58
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	ff d0                	call   *%eax
  800fca:	83 c4 10             	add    $0x10,%esp
			break;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 30                	push   $0x30
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	6a 78                	push   $0x78
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	ff d0                	call   *%eax
  800fef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff5:	83 c0 04             	add    $0x4,%eax
  800ff8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 e8 04             	sub    $0x4,%eax
  801001:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801003:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80100d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801014:	eb 1f                	jmp    801035 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 e8             	pushl  -0x18(%ebp)
  80101c:	8d 45 14             	lea    0x14(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	e8 e7 fb ff ff       	call   800c0c <getuint>
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80102e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801035:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	52                   	push   %edx
  801040:	ff 75 e4             	pushl  -0x1c(%ebp)
  801043:	50                   	push   %eax
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	ff 75 f0             	pushl  -0x10(%ebp)
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	ff 75 08             	pushl  0x8(%ebp)
  801050:	e8 00 fb ff ff       	call   800b55 <printnum>
  801055:	83 c4 20             	add    $0x20,%esp
			break;
  801058:	eb 34                	jmp    80108e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	53                   	push   %ebx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	ff d0                	call   *%eax
  801066:	83 c4 10             	add    $0x10,%esp
			break;
  801069:	eb 23                	jmp    80108e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	6a 25                	push   $0x25
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	ff d0                	call   *%eax
  801078:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80107b:	ff 4d 10             	decl   0x10(%ebp)
  80107e:	eb 03                	jmp    801083 <vprintfmt+0x3b1>
  801080:	ff 4d 10             	decl   0x10(%ebp)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	48                   	dec    %eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 25                	cmp    $0x25,%al
  80108b:	75 f3                	jne    801080 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80108d:	90                   	nop
		}
	}
  80108e:	e9 47 fc ff ff       	jmp    800cda <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801093:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 16 fc ff ff       	call   800cd2 <vprintfmt>
  8010bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010bf:	90                   	nop
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 40 08             	mov    0x8(%eax),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	8b 10                	mov    (%eax),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	8b 40 04             	mov    0x4(%eax),%eax
  8010df:	39 c2                	cmp    %eax,%edx
  8010e1:	73 12                	jae    8010f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	8b 00                	mov    (%eax),%eax
  8010e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 0a                	mov    %ecx,(%edx)
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
}
  8010f5:	90                   	nop
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111d:	74 06                	je     801125 <vsnprintf+0x2d>
  80111f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801123:	7f 07                	jg     80112c <vsnprintf+0x34>
		return -E_INVAL;
  801125:	b8 03 00 00 00       	mov    $0x3,%eax
  80112a:	eb 20                	jmp    80114c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80112c:	ff 75 14             	pushl  0x14(%ebp)
  80112f:	ff 75 10             	pushl  0x10(%ebp)
  801132:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	68 c2 10 80 00       	push   $0x8010c2
  80113b:	e8 92 fb ff ff       	call   800cd2 <vprintfmt>
  801140:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801149:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801154:	8d 45 10             	lea    0x10(%ebp),%eax
  801157:	83 c0 04             	add    $0x4,%eax
  80115a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	ff 75 f4             	pushl  -0xc(%ebp)
  801163:	50                   	push   %eax
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	e8 89 ff ff ff       	call   8010f8 <vsnprintf>
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801175:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 06                	jmp    80118f <strlen+0x15>
		n++;
  801189:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	84 c0                	test   %al,%al
  801196:	75 f1                	jne    801189 <strlen+0xf>
		n++;
	return n;
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011aa:	eb 09                	jmp    8011b5 <strnlen+0x18>
		n++;
  8011ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	ff 4d 0c             	decl   0xc(%ebp)
  8011b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b9:	74 09                	je     8011c4 <strnlen+0x27>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 e8                	jne    8011ac <strnlen+0xf>
		n++;
	return n;
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011d5:	90                   	nop
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011e8:	8a 12                	mov    (%edx),%dl
  8011ea:	88 10                	mov    %dl,(%eax)
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	75 e4                	jne    8011d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120a:	eb 1f                	jmp    80122b <strncpy+0x34>
		*dst++ = *src;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 08             	mov    %edx,0x8(%ebp)
  801215:	8b 55 0c             	mov    0xc(%ebp),%edx
  801218:	8a 12                	mov    (%edx),%dl
  80121a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	84 c0                	test   %al,%al
  801223:	74 03                	je     801228 <strncpy+0x31>
			src++;
  801225:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801228:	ff 45 fc             	incl   -0x4(%ebp)
  80122b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801231:	72 d9                	jb     80120c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 30                	je     80127a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80124a:	eb 16                	jmp    801262 <strlcpy+0x2a>
			*dst++ = *src++;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	8b 55 0c             	mov    0xc(%ebp),%edx
  801258:	8d 4a 01             	lea    0x1(%edx),%ecx
  80125b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80125e:	8a 12                	mov    (%edx),%dl
  801260:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801269:	74 09                	je     801274 <strlcpy+0x3c>
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	84 c0                	test   %al,%al
  801272:	75 d8                	jne    80124c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80127a:	8b 55 08             	mov    0x8(%ebp),%edx
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	29 c2                	sub    %eax,%edx
  801282:	89 d0                	mov    %edx,%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801289:	eb 06                	jmp    801291 <strcmp+0xb>
		p++, q++;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	84 c0                	test   %al,%al
  801298:	74 0e                	je     8012a8 <strcmp+0x22>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	38 c2                	cmp    %al,%dl
  8012a6:	74 e3                	je     80128b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d0             	movzbl %al,%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f b6 c0             	movzbl %al,%eax
  8012b8:	29 c2                	sub    %eax,%edx
  8012ba:	89 d0                	mov    %edx,%eax
}
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012c1:	eb 09                	jmp    8012cc <strncmp+0xe>
		n--, p++, q++;
  8012c3:	ff 4d 10             	decl   0x10(%ebp)
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d0:	74 17                	je     8012e9 <strncmp+0x2b>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	84 c0                	test   %al,%al
  8012d9:	74 0e                	je     8012e9 <strncmp+0x2b>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 10                	mov    (%eax),%dl
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	38 c2                	cmp    %al,%dl
  8012e7:	74 da                	je     8012c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ed:	75 07                	jne    8012f6 <strncmp+0x38>
		return 0;
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	eb 14                	jmp    80130a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f b6 d0             	movzbl %al,%edx
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f b6 c0             	movzbl %al,%eax
  801306:	29 c2                	sub    %eax,%edx
  801308:	89 d0                	mov    %edx,%eax
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801318:	eb 12                	jmp    80132c <strchr+0x20>
		if (*s == c)
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801322:	75 05                	jne    801329 <strchr+0x1d>
			return (char *) s;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	eb 11                	jmp    80133a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	84 c0                	test   %al,%al
  801333:	75 e5                	jne    80131a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801348:	eb 0d                	jmp    801357 <strfind+0x1b>
		if (*s == c)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801352:	74 0e                	je     801362 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801354:	ff 45 08             	incl   0x8(%ebp)
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	75 ea                	jne    80134a <strfind+0xe>
  801360:	eb 01                	jmp    801363 <strfind+0x27>
		if (*s == c)
			break;
  801362:	90                   	nop
	return (char *) s;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80137a:	eb 0e                	jmp    80138a <memset+0x22>
		*p++ = c;
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80138a:	ff 4d f8             	decl   -0x8(%ebp)
  80138d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801391:	79 e9                	jns    80137c <memset+0x14>
		*p++ = c;

	return v;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013aa:	eb 16                	jmp    8013c2 <memcpy+0x2a>
		*d++ = *s++;
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	8d 50 01             	lea    0x1(%eax),%edx
  8013b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013be:	8a 12                	mov    (%edx),%dl
  8013c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 dd                	jne    8013ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ec:	73 50                	jae    80143e <memmove+0x6a>
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013f9:	76 43                	jbe    80143e <memmove+0x6a>
		s += n;
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801407:	eb 10                	jmp    801419 <memmove+0x45>
			*--d = *--s;
  801409:	ff 4d f8             	decl   -0x8(%ebp)
  80140c:	ff 4d fc             	decl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	8a 10                	mov    (%eax),%dl
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141f:	89 55 10             	mov    %edx,0x10(%ebp)
  801422:	85 c0                	test   %eax,%eax
  801424:	75 e3                	jne    801409 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801426:	eb 23                	jmp    80144b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8d 4a 01             	lea    0x1(%edx),%ecx
  801437:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80143a:	8a 12                	mov    (%edx),%dl
  80143c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	8d 50 ff             	lea    -0x1(%eax),%edx
  801444:	89 55 10             	mov    %edx,0x10(%ebp)
  801447:	85 c0                	test   %eax,%eax
  801449:	75 dd                	jne    801428 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801462:	eb 2a                	jmp    80148e <memcmp+0x3e>
		if (*s1 != *s2)
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8a 10                	mov    (%eax),%dl
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	38 c2                	cmp    %al,%dl
  801470:	74 16                	je     801488 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	0f b6 d0             	movzbl %al,%edx
  80147a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	eb 18                	jmp    8014a0 <memcmp+0x50>
		s1++, s2++;
  801488:	ff 45 fc             	incl   -0x4(%ebp)
  80148b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	8d 50 ff             	lea    -0x1(%eax),%edx
  801494:	89 55 10             	mov    %edx,0x10(%ebp)
  801497:	85 c0                	test   %eax,%eax
  801499:	75 c9                	jne    801464 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014b3:	eb 15                	jmp    8014ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f b6 d0             	movzbl %al,%edx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	0f b6 c0             	movzbl %al,%eax
  8014c3:	39 c2                	cmp    %eax,%edx
  8014c5:	74 0d                	je     8014d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014c7:	ff 45 08             	incl   0x8(%ebp)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014d0:	72 e3                	jb     8014b5 <memfind+0x13>
  8014d2:	eb 01                	jmp    8014d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014d4:	90                   	nop
	return (void *) s;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ee:	eb 03                	jmp    8014f3 <strtol+0x19>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 20                	cmp    $0x20,%al
  8014fa:	74 f4                	je     8014f0 <strtol+0x16>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 09                	cmp    $0x9,%al
  801503:	74 eb                	je     8014f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	3c 2b                	cmp    $0x2b,%al
  80150c:	75 05                	jne    801513 <strtol+0x39>
		s++;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	eb 13                	jmp    801526 <strtol+0x4c>
	else if (*s == '-')
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	3c 2d                	cmp    $0x2d,%al
  80151a:	75 0a                	jne    801526 <strtol+0x4c>
		s++, neg = 1;
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152a:	74 06                	je     801532 <strtol+0x58>
  80152c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801530:	75 20                	jne    801552 <strtol+0x78>
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	3c 30                	cmp    $0x30,%al
  801539:	75 17                	jne    801552 <strtol+0x78>
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	40                   	inc    %eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	3c 78                	cmp    $0x78,%al
  801543:	75 0d                	jne    801552 <strtol+0x78>
		s += 2, base = 16;
  801545:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801549:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801550:	eb 28                	jmp    80157a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801552:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801556:	75 15                	jne    80156d <strtol+0x93>
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	3c 30                	cmp    $0x30,%al
  80155f:	75 0c                	jne    80156d <strtol+0x93>
		s++, base = 8;
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80156b:	eb 0d                	jmp    80157a <strtol+0xa0>
	else if (base == 0)
  80156d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801571:	75 07                	jne    80157a <strtol+0xa0>
		base = 10;
  801573:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 2f                	cmp    $0x2f,%al
  801581:	7e 19                	jle    80159c <strtol+0xc2>
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 39                	cmp    $0x39,%al
  80158a:	7f 10                	jg     80159c <strtol+0xc2>
			dig = *s - '0';
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	83 e8 30             	sub    $0x30,%eax
  801597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159a:	eb 42                	jmp    8015de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 60                	cmp    $0x60,%al
  8015a3:	7e 19                	jle    8015be <strtol+0xe4>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3c 7a                	cmp    $0x7a,%al
  8015ac:	7f 10                	jg     8015be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	0f be c0             	movsbl %al,%eax
  8015b6:	83 e8 57             	sub    $0x57,%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015bc:	eb 20                	jmp    8015de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	3c 40                	cmp    $0x40,%al
  8015c5:	7e 39                	jle    801600 <strtol+0x126>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 5a                	cmp    $0x5a,%al
  8015ce:	7f 30                	jg     801600 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	0f be c0             	movsbl %al,%eax
  8015d8:	83 e8 37             	sub    $0x37,%eax
  8015db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e4:	7d 19                	jge    8015ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015e6:	ff 45 08             	incl   0x8(%ebp)
  8015e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015f0:	89 c2                	mov    %eax,%edx
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015fa:	e9 7b ff ff ff       	jmp    80157a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801604:	74 08                	je     80160e <strtol+0x134>
		*endptr = (char *) s;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
  80160c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80160e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801612:	74 07                	je     80161b <strtol+0x141>
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	f7 d8                	neg    %eax
  801619:	eb 03                	jmp    80161e <strtol+0x144>
  80161b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <ltostr>:

void
ltostr(long value, char *str)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801626:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80162d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801638:	79 13                	jns    80164d <ltostr+0x2d>
	{
		neg = 1;
  80163a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801647:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80164a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801655:	99                   	cltd   
  801656:	f7 f9                	idiv   %ecx
  801658:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165e:	8d 50 01             	lea    0x1(%eax),%edx
  801661:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801664:	89 c2                	mov    %eax,%edx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166e:	83 c2 30             	add    $0x30,%edx
  801671:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801673:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801676:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80167b:	f7 e9                	imul   %ecx
  80167d:	c1 fa 02             	sar    $0x2,%edx
  801680:	89 c8                	mov    %ecx,%eax
  801682:	c1 f8 1f             	sar    $0x1f,%eax
  801685:	29 c2                	sub    %eax,%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80168c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801694:	f7 e9                	imul   %ecx
  801696:	c1 fa 02             	sar    $0x2,%edx
  801699:	89 c8                	mov    %ecx,%eax
  80169b:	c1 f8 1f             	sar    $0x1f,%eax
  80169e:	29 c2                	sub    %eax,%edx
  8016a0:	89 d0                	mov    %edx,%eax
  8016a2:	c1 e0 02             	shl    $0x2,%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	01 c0                	add    %eax,%eax
  8016a9:	29 c1                	sub    %eax,%ecx
  8016ab:	89 ca                	mov    %ecx,%edx
  8016ad:	85 d2                	test   %edx,%edx
  8016af:	75 9c                	jne    80164d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bb:	48                   	dec    %eax
  8016bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c3:	74 3d                	je     801702 <ltostr+0xe2>
		start = 1 ;
  8016c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016cc:	eb 34                	jmp    801702 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e1:	01 c2                	add    %eax,%edx
  8016e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	01 c8                	add    %ecx,%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 c2                	add    %eax,%edx
  8016f7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016fa:	88 02                	mov    %al,(%edx)
		start++ ;
  8016fc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016ff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801708:	7c c4                	jl     8016ce <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80170a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 54 fa ff ff       	call   80117a <strlen>
  801726:	83 c4 04             	add    $0x4,%esp
  801729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	e8 46 fa ff ff       	call   80117a <strlen>
  801734:	83 c4 04             	add    $0x4,%esp
  801737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80173a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801741:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801748:	eb 17                	jmp    801761 <strcconcat+0x49>
		final[s] = str1[s] ;
  80174a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174d:	8b 45 10             	mov    0x10(%ebp),%eax
  801750:	01 c2                	add    %eax,%edx
  801752:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	01 c8                	add    %ecx,%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80175e:	ff 45 fc             	incl   -0x4(%ebp)
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801767:	7c e1                	jl     80174a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801769:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801770:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801777:	eb 1f                	jmp    801798 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801779:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177c:	8d 50 01             	lea    0x1(%eax),%edx
  80177f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801782:	89 c2                	mov    %eax,%edx
  801784:	8b 45 10             	mov    0x10(%ebp),%eax
  801787:	01 c2                	add    %eax,%edx
  801789:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	01 c8                	add    %ecx,%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801795:	ff 45 f8             	incl   -0x8(%ebp)
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80179e:	7c d9                	jl     801779 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	c6 00 00             	movb   $0x0,(%eax)
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bd:	8b 00                	mov    (%eax),%eax
  8017bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017d1:	eb 0c                	jmp    8017df <strsplit+0x31>
			*string++ = 0;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8d 50 01             	lea    0x1(%eax),%edx
  8017d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8017dc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	84 c0                	test   %al,%al
  8017e6:	74 18                	je     801800 <strsplit+0x52>
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	e8 13 fb ff ff       	call   80130c <strchr>
  8017f9:	83 c4 08             	add    $0x8,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	75 d3                	jne    8017d3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	84 c0                	test   %al,%al
  801807:	74 5a                	je     801863 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	83 f8 0f             	cmp    $0xf,%eax
  801811:	75 07                	jne    80181a <strsplit+0x6c>
		{
			return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 66                	jmp    801880 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80181a:	8b 45 14             	mov    0x14(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	8d 48 01             	lea    0x1(%eax),%ecx
  801822:	8b 55 14             	mov    0x14(%ebp),%edx
  801825:	89 0a                	mov    %ecx,(%edx)
  801827:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	01 c2                	add    %eax,%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801838:	eb 03                	jmp    80183d <strsplit+0x8f>
			string++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	84 c0                	test   %al,%al
  801844:	74 8b                	je     8017d1 <strsplit+0x23>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	50                   	push   %eax
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	e8 b5 fa ff ff       	call   80130c <strchr>
  801857:	83 c4 08             	add    $0x8,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	74 dc                	je     80183a <strsplit+0x8c>
			string++;
	}
  80185e:	e9 6e ff ff ff       	jmp    8017d1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801863:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801864:	8b 45 14             	mov    0x14(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801870:	8b 45 10             	mov    0x10(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <malloc>:
int changes=0;
int sizeofarray=0;
uint32 addresses[100];
int changed[100];
void* malloc(uint32 size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	c1 e8 0c             	shr    $0xc,%eax
  80188e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;
		if(size%PAGE_SIZE!=0)
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	25 ff 0f 00 00       	and    $0xfff,%eax
  801899:	85 c0                	test   %eax,%eax
  80189b:	74 03                	je     8018a0 <malloc+0x1e>
			num++;
  80189d:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  8018a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8018a5:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8018aa:	75 64                	jne    801910 <malloc+0x8e>
		{
			sys_allocateMem(USER_HEAP_START,size);
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	68 00 00 00 80       	push   $0x80000000
  8018b7:	e8 3a 04 00 00       	call   801cf6 <sys_allocateMem>
  8018bc:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  8018bf:	a1 04 30 80 00       	mov    0x803004,%eax
  8018c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	c1 e0 0c             	shl    $0xc,%eax
  8018cd:	89 c2                	mov    %eax,%edx
  8018cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	a3 04 30 80 00       	mov    %eax,0x803004
			addresses[sizeofarray]=last_addres;
  8018db:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018e0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8018e6:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
			changed[sizeofarray]=1;
  8018ed:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018f2:	c7 04 85 c0 32 80 00 	movl   $0x1,0x8032c0(,%eax,4)
  8018f9:	01 00 00 00 
			sizeofarray++;
  8018fd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801902:	40                   	inc    %eax
  801903:	a3 2c 30 80 00       	mov    %eax,0x80302c
			return (void*)return_addres;
  801908:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190b:	e9 26 01 00 00       	jmp    801a36 <malloc+0x1b4>
		}
		else
		{
			if(changes==0)
  801910:	a1 28 30 80 00       	mov    0x803028,%eax
  801915:	85 c0                	test   %eax,%eax
  801917:	75 62                	jne    80197b <malloc+0xf9>
			{
				sys_allocateMem(last_addres,size);
  801919:	a1 04 30 80 00       	mov    0x803004,%eax
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	50                   	push   %eax
  801925:	e8 cc 03 00 00       	call   801cf6 <sys_allocateMem>
  80192a:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  80192d:	a1 04 30 80 00       	mov    0x803004,%eax
  801932:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	c1 e0 0c             	shl    $0xc,%eax
  80193b:	89 c2                	mov    %eax,%edx
  80193d:	a1 04 30 80 00       	mov    0x803004,%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	a3 04 30 80 00       	mov    %eax,0x803004
				addresses[sizeofarray]=return_addres;
  801949:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80194e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801951:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801958:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80195d:	c7 04 85 c0 32 80 00 	movl   $0x1,0x8032c0(,%eax,4)
  801964:	01 00 00 00 
				sizeofarray++;
  801968:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80196d:	40                   	inc    %eax
  80196e:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return (void*)return_addres;
  801973:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801976:	e9 bb 00 00 00       	jmp    801a36 <malloc+0x1b4>
			}
			else{
				int count=0;
  80197b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801982:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  801989:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801990:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801997:	eb 7c                	jmp    801a15 <malloc+0x193>
				{
					uint32 *pg=NULL;
  801999:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  8019a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8019a7:	eb 1a                	jmp    8019c3 <malloc+0x141>
					{
						if(addresses[j]==i)
  8019a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019ac:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  8019b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019b6:	75 08                	jne    8019c0 <malloc+0x13e>
						{
							index=j;
  8019b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  8019be:	eb 0d                	jmp    8019cd <malloc+0x14b>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  8019c0:	ff 45 dc             	incl   -0x24(%ebp)
  8019c3:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8019c8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8019cb:	7c dc                	jl     8019a9 <malloc+0x127>
							index=j;
							break;
						}
					}

					if(index==-1)
  8019cd:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8019d1:	75 05                	jne    8019d8 <malloc+0x156>
					{
						count++;
  8019d3:	ff 45 f0             	incl   -0x10(%ebp)
  8019d6:	eb 36                	jmp    801a0e <malloc+0x18c>
					}
					else
					{
						if(changed[index]==0)
  8019d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019db:	8b 04 85 c0 32 80 00 	mov    0x8032c0(,%eax,4),%eax
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	75 05                	jne    8019eb <malloc+0x169>
						{
							count++;
  8019e6:	ff 45 f0             	incl   -0x10(%ebp)
  8019e9:	eb 23                	jmp    801a0e <malloc+0x18c>
						}
						else
						{
							if(count<min&&count>=num)
  8019eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8019f1:	7d 14                	jge    801a07 <malloc+0x185>
  8019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019f9:	7c 0c                	jl     801a07 <malloc+0x185>
							{
								min=count;
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  801a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  801a07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801a0e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801a15:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801a1c:	0f 86 77 ff ff ff    	jbe    801999 <malloc+0x117>

					}

					}

				sys_allocateMem(min_addresss,size);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a2b:	e8 c6 02 00 00       	call   801cf6 <sys_allocateMem>
  801a30:	83 c4 10             	add    $0x10,%esp

				return(void*) min_addresss;
  801a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	68 10 2a 80 00       	push   $0x802a10
  801a46:	6a 7b                	push   $0x7b
  801a48:	68 33 2a 80 00       	push   $0x802a33
  801a4d:	e8 2e 07 00 00       	call   802180 <_panic>

00801a52 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 18             	sub    $0x18,%esp
  801a58:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5b:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	68 40 2a 80 00       	push   $0x802a40
  801a66:	68 88 00 00 00       	push   $0x88
  801a6b:	68 33 2a 80 00       	push   $0x802a33
  801a70:	e8 0b 07 00 00       	call   802180 <_panic>

00801a75 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a7b:	83 ec 04             	sub    $0x4,%esp
  801a7e:	68 40 2a 80 00       	push   $0x802a40
  801a83:	68 8e 00 00 00       	push   $0x8e
  801a88:	68 33 2a 80 00       	push   $0x802a33
  801a8d:	e8 ee 06 00 00       	call   802180 <_panic>

00801a92 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 40 2a 80 00       	push   $0x802a40
  801aa0:	68 94 00 00 00       	push   $0x94
  801aa5:	68 33 2a 80 00       	push   $0x802a33
  801aaa:	e8 d1 06 00 00       	call   802180 <_panic>

00801aaf <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	68 40 2a 80 00       	push   $0x802a40
  801abd:	68 99 00 00 00       	push   $0x99
  801ac2:	68 33 2a 80 00       	push   $0x802a33
  801ac7:	e8 b4 06 00 00       	call   802180 <_panic>

00801acc <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	68 40 2a 80 00       	push   $0x802a40
  801ada:	68 9f 00 00 00       	push   $0x9f
  801adf:	68 33 2a 80 00       	push   $0x802a33
  801ae4:	e8 97 06 00 00       	call   802180 <_panic>

00801ae9 <shrink>:
}
void shrink(uint32 newSize)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	68 40 2a 80 00       	push   $0x802a40
  801af7:	68 a3 00 00 00       	push   $0xa3
  801afc:	68 33 2a 80 00       	push   $0x802a33
  801b01:	e8 7a 06 00 00       	call   802180 <_panic>

00801b06 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	68 40 2a 80 00       	push   $0x802a40
  801b14:	68 a8 00 00 00       	push   $0xa8
  801b19:	68 33 2a 80 00       	push   $0x802a33
  801b1e:	e8 5d 06 00 00       	call   802180 <_panic>

00801b23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	57                   	push   %edi
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
  801b29:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b38:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b3b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b3e:	cd 30                	int    $0x30
  801b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	e8 b2 ff ff ff       	call   801b23 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 01                	push   $0x1
  801b86:	e8 98 ff ff ff       	call   801b23 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	50                   	push   %eax
  801b9f:	6a 05                	push   $0x5
  801ba1:	e8 7d ff ff ff       	call   801b23 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 02                	push   $0x2
  801bba:	e8 64 ff ff ff       	call   801b23 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 03                	push   $0x3
  801bd3:	e8 4b ff ff ff       	call   801b23 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 04                	push   $0x4
  801bec:	e8 32 ff ff ff       	call   801b23 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_env_exit>:


void sys_env_exit(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 06                	push   $0x6
  801c05:	e8 19 ff ff ff       	call   801b23 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 07                	push   $0x7
  801c23:	e8 fb fe ff ff       	call   801b23 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c32:	8b 75 18             	mov    0x18(%ebp),%esi
  801c35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	51                   	push   %ecx
  801c44:	52                   	push   %edx
  801c45:	50                   	push   %eax
  801c46:	6a 08                	push   $0x8
  801c48:	e8 d6 fe ff ff       	call   801b23 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	52                   	push   %edx
  801c67:	50                   	push   %eax
  801c68:	6a 09                	push   $0x9
  801c6a:	e8 b4 fe ff ff       	call   801b23 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 0a                	push   $0xa
  801c85:	e8 99 fe ff ff       	call   801b23 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 0b                	push   $0xb
  801c9e:	e8 80 fe ff ff       	call   801b23 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 0c                	push   $0xc
  801cb7:	e8 67 fe ff ff       	call   801b23 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 0d                	push   $0xd
  801cd0:	e8 4e fe ff ff       	call   801b23 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 11                	push   $0x11
  801ceb:	e8 33 fe ff ff       	call   801b23 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 12                	push   $0x12
  801d07:	e8 17 fe ff ff       	call   801b23 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 0e                	push   $0xe
  801d21:	e8 fd fd ff ff       	call   801b23 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 0f                	push   $0xf
  801d3b:	e8 e3 fd ff ff       	call   801b23 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 10                	push   $0x10
  801d54:	e8 ca fd ff ff       	call   801b23 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	90                   	nop
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 14                	push   $0x14
  801d6e:	e8 b0 fd ff ff       	call   801b23 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	90                   	nop
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 15                	push   $0x15
  801d88:	e8 96 fd ff ff       	call   801b23 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	90                   	nop
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	50                   	push   %eax
  801dac:	6a 16                	push   $0x16
  801dae:	e8 70 fd ff ff       	call   801b23 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	90                   	nop
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 17                	push   $0x17
  801dc8:	e8 56 fd ff ff       	call   801b23 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	50                   	push   %eax
  801de3:	6a 18                	push   $0x18
  801de5:	e8 39 fd ff ff       	call   801b23 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	52                   	push   %edx
  801dff:	50                   	push   %eax
  801e00:	6a 1b                	push   $0x1b
  801e02:	e8 1c fd ff ff       	call   801b23 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	52                   	push   %edx
  801e1c:	50                   	push   %eax
  801e1d:	6a 19                	push   $0x19
  801e1f:	e8 ff fc ff ff       	call   801b23 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	90                   	nop
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	6a 1a                	push   $0x1a
  801e3d:	e8 e1 fc ff ff       	call   801b23 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e51:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e54:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	51                   	push   %ecx
  801e61:	52                   	push   %edx
  801e62:	ff 75 0c             	pushl  0xc(%ebp)
  801e65:	50                   	push   %eax
  801e66:	6a 1c                	push   $0x1c
  801e68:	e8 b6 fc ff ff       	call   801b23 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	6a 1d                	push   $0x1d
  801e85:	e8 99 fc ff ff       	call   801b23 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	51                   	push   %ecx
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 1e                	push   $0x1e
  801ea4:	e8 7a fc ff ff       	call   801b23 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	52                   	push   %edx
  801ebe:	50                   	push   %eax
  801ebf:	6a 1f                	push   $0x1f
  801ec1:	e8 5d fc ff ff       	call   801b23 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 20                	push   $0x20
  801eda:	e8 44 fc ff ff       	call   801b23 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 14             	pushl  0x14(%ebp)
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	50                   	push   %eax
  801ef6:	6a 21                	push   $0x21
  801ef8:	e8 26 fc ff ff       	call   801b23 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	50                   	push   %eax
  801f11:	6a 22                	push   $0x22
  801f13:	e8 0b fc ff ff       	call   801b23 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	90                   	nop
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	50                   	push   %eax
  801f2d:	6a 23                	push   $0x23
  801f2f:	e8 ef fb ff ff       	call   801b23 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	90                   	nop
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f43:	8d 50 04             	lea    0x4(%eax),%edx
  801f46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	6a 24                	push   $0x24
  801f53:	e8 cb fb ff ff       	call   801b23 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return result;
  801f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f64:	89 01                	mov    %eax,(%ecx)
  801f66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	c9                   	leave  
  801f6d:	c2 04 00             	ret    $0x4

00801f70 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	ff 75 10             	pushl  0x10(%ebp)
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	6a 13                	push   $0x13
  801f82:	e8 9c fb ff ff       	call   801b23 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8a:	90                   	nop
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 25                	push   $0x25
  801f9c:	e8 82 fb ff ff       	call   801b23 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fb2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	50                   	push   %eax
  801fbf:	6a 26                	push   $0x26
  801fc1:	e8 5d fb ff ff       	call   801b23 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc9:	90                   	nop
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <rsttst>:
void rsttst()
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 28                	push   $0x28
  801fdb:	e8 43 fb ff ff       	call   801b23 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe3:	90                   	nop
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	8b 45 14             	mov    0x14(%ebp),%eax
  801fef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ff2:	8b 55 18             	mov    0x18(%ebp),%edx
  801ff5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ff9:	52                   	push   %edx
  801ffa:	50                   	push   %eax
  801ffb:	ff 75 10             	pushl  0x10(%ebp)
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	6a 27                	push   $0x27
  802006:	e8 18 fb ff ff       	call   801b23 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return ;
  80200e:	90                   	nop
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <chktst>:
void chktst(uint32 n)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	6a 29                	push   $0x29
  802021:	e8 fd fa ff ff       	call   801b23 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
	return ;
  802029:	90                   	nop
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <inctst>:

void inctst()
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 2a                	push   $0x2a
  80203b:	e8 e3 fa ff ff       	call   801b23 <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
	return ;
  802043:	90                   	nop
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <gettst>:
uint32 gettst()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 2b                	push   $0x2b
  802055:	e8 c9 fa ff ff       	call   801b23 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 2c                	push   $0x2c
  802071:	e8 ad fa ff ff       	call   801b23 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
  802079:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80207c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802080:	75 07                	jne    802089 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
  802087:	eb 05                	jmp    80208e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 2c                	push   $0x2c
  8020a2:	e8 7c fa ff ff       	call   801b23 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
  8020aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020b1:	75 07                	jne    8020ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b8:	eb 05                	jmp    8020bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 2c                	push   $0x2c
  8020d3:	e8 4b fa ff ff       	call   801b23 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
  8020db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020e2:	75 07                	jne    8020eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e9:	eb 05                	jmp    8020f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 2c                	push   $0x2c
  802104:	e8 1a fa ff ff       	call   801b23 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
  80210c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80210f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802113:	75 07                	jne    80211c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802115:	b8 01 00 00 00       	mov    $0x1,%eax
  80211a:	eb 05                	jmp    802121 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	6a 2d                	push   $0x2d
  802133:	e8 eb f9 ff ff       	call   801b23 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
	return ;
  80213b:	90                   	nop
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802142:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802145:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802148:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	53                   	push   %ebx
  802151:	51                   	push   %ecx
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 2e                	push   $0x2e
  802156:	e8 c8 f9 ff ff       	call   801b23 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 2f                	push   $0x2f
  802176:	e8 a8 f9 ff ff       	call   801b23 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802186:	8d 45 10             	lea    0x10(%ebp),%eax
  802189:	83 c0 04             	add    $0x4,%eax
  80218c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80218f:	a1 50 34 80 00       	mov    0x803450,%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	74 16                	je     8021ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  802198:	a1 50 34 80 00       	mov    0x803450,%eax
  80219d:	83 ec 08             	sub    $0x8,%esp
  8021a0:	50                   	push   %eax
  8021a1:	68 64 2a 80 00       	push   $0x802a64
  8021a6:	e8 4d e9 ff ff       	call   800af8 <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8021ae:	a1 00 30 80 00       	mov    0x803000,%eax
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	ff 75 08             	pushl  0x8(%ebp)
  8021b9:	50                   	push   %eax
  8021ba:	68 69 2a 80 00       	push   $0x802a69
  8021bf:	e8 34 e9 ff ff       	call   800af8 <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8021c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ca:	83 ec 08             	sub    $0x8,%esp
  8021cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d0:	50                   	push   %eax
  8021d1:	e8 b7 e8 ff ff       	call   800a8d <vcprintf>
  8021d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8021d9:	83 ec 08             	sub    $0x8,%esp
  8021dc:	6a 00                	push   $0x0
  8021de:	68 85 2a 80 00       	push   $0x802a85
  8021e3:	e8 a5 e8 ff ff       	call   800a8d <vcprintf>
  8021e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8021eb:	e8 26 e8 ff ff       	call   800a16 <exit>

	// should not return here
	while (1) ;
  8021f0:	eb fe                	jmp    8021f0 <_panic+0x70>

008021f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8021f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8021fd:	8b 50 74             	mov    0x74(%eax),%edx
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	39 c2                	cmp    %eax,%edx
  802205:	74 14                	je     80221b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 88 2a 80 00       	push   $0x802a88
  80220f:	6a 26                	push   $0x26
  802211:	68 d4 2a 80 00       	push   $0x802ad4
  802216:	e8 65 ff ff ff       	call   802180 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80221b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802229:	e9 b6 00 00 00       	jmp    8022e4 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	01 d0                	add    %edx,%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	75 08                	jne    80224b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802243:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802246:	e9 96 00 00 00       	jmp    8022e1 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80224b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802252:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802259:	eb 5d                	jmp    8022b8 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80225b:	a1 20 30 80 00       	mov    0x803020,%eax
  802260:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802269:	c1 e2 04             	shl    $0x4,%edx
  80226c:	01 d0                	add    %edx,%eax
  80226e:	8a 40 04             	mov    0x4(%eax),%al
  802271:	84 c0                	test   %al,%al
  802273:	75 40                	jne    8022b5 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802275:	a1 20 30 80 00       	mov    0x803020,%eax
  80227a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802280:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802283:	c1 e2 04             	shl    $0x4,%edx
  802286:	01 d0                	add    %edx,%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80228d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802290:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802295:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	01 c8                	add    %ecx,%eax
  8022a6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022a8:	39 c2                	cmp    %eax,%edx
  8022aa:	75 09                	jne    8022b5 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8022ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8022b3:	eb 12                	jmp    8022c7 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022b5:	ff 45 e8             	incl   -0x18(%ebp)
  8022b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8022bd:	8b 50 74             	mov    0x74(%eax),%edx
  8022c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	77 94                	ja     80225b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8022c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022cb:	75 14                	jne    8022e1 <CheckWSWithoutLastIndex+0xef>
			panic(
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	68 e0 2a 80 00       	push   $0x802ae0
  8022d5:	6a 3a                	push   $0x3a
  8022d7:	68 d4 2a 80 00       	push   $0x802ad4
  8022dc:	e8 9f fe ff ff       	call   802180 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8022e1:	ff 45 f0             	incl   -0x10(%ebp)
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ea:	0f 8c 3e ff ff ff    	jl     80222e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8022f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022fe:	eb 20                	jmp    802320 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802300:	a1 20 30 80 00       	mov    0x803020,%eax
  802305:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80230b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80230e:	c1 e2 04             	shl    $0x4,%edx
  802311:	01 d0                	add    %edx,%eax
  802313:	8a 40 04             	mov    0x4(%eax),%al
  802316:	3c 01                	cmp    $0x1,%al
  802318:	75 03                	jne    80231d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80231a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80231d:	ff 45 e0             	incl   -0x20(%ebp)
  802320:	a1 20 30 80 00       	mov    0x803020,%eax
  802325:	8b 50 74             	mov    0x74(%eax),%edx
  802328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80232b:	39 c2                	cmp    %eax,%edx
  80232d:	77 d1                	ja     802300 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802335:	74 14                	je     80234b <CheckWSWithoutLastIndex+0x159>
		panic(
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	68 34 2b 80 00       	push   $0x802b34
  80233f:	6a 44                	push   $0x44
  802341:	68 d4 2a 80 00       	push   $0x802ad4
  802346:	e8 35 fe ff ff       	call   802180 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80234b:	90                   	nop
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    
  80234e:	66 90                	xchg   %ax,%ax

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80235b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80235f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802363:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802367:	89 ca                	mov    %ecx,%edx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80236f:	85 f6                	test   %esi,%esi
  802371:	75 2d                	jne    8023a0 <__udivdi3+0x50>
  802373:	39 cf                	cmp    %ecx,%edi
  802375:	77 65                	ja     8023dc <__udivdi3+0x8c>
  802377:	89 fd                	mov    %edi,%ebp
  802379:	85 ff                	test   %edi,%edi
  80237b:	75 0b                	jne    802388 <__udivdi3+0x38>
  80237d:	b8 01 00 00 00       	mov    $0x1,%eax
  802382:	31 d2                	xor    %edx,%edx
  802384:	f7 f7                	div    %edi
  802386:	89 c5                	mov    %eax,%ebp
  802388:	31 d2                	xor    %edx,%edx
  80238a:	89 c8                	mov    %ecx,%eax
  80238c:	f7 f5                	div    %ebp
  80238e:	89 c1                	mov    %eax,%ecx
  802390:	89 d8                	mov    %ebx,%eax
  802392:	f7 f5                	div    %ebp
  802394:	89 cf                	mov    %ecx,%edi
  802396:	89 fa                	mov    %edi,%edx
  802398:	83 c4 1c             	add    $0x1c,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5e                   	pop    %esi
  80239d:	5f                   	pop    %edi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    
  8023a0:	39 ce                	cmp    %ecx,%esi
  8023a2:	77 28                	ja     8023cc <__udivdi3+0x7c>
  8023a4:	0f bd fe             	bsr    %esi,%edi
  8023a7:	83 f7 1f             	xor    $0x1f,%edi
  8023aa:	75 40                	jne    8023ec <__udivdi3+0x9c>
  8023ac:	39 ce                	cmp    %ecx,%esi
  8023ae:	72 0a                	jb     8023ba <__udivdi3+0x6a>
  8023b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023b4:	0f 87 9e 00 00 00    	ja     802458 <__udivdi3+0x108>
  8023ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bf:	89 fa                	mov    %edi,%edx
  8023c1:	83 c4 1c             	add    $0x1c,%esp
  8023c4:	5b                   	pop    %ebx
  8023c5:	5e                   	pop    %esi
  8023c6:	5f                   	pop    %edi
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    
  8023c9:	8d 76 00             	lea    0x0(%esi),%esi
  8023cc:	31 ff                	xor    %edi,%edi
  8023ce:	31 c0                	xor    %eax,%eax
  8023d0:	89 fa                	mov    %edi,%edx
  8023d2:	83 c4 1c             	add    $0x1c,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	89 d8                	mov    %ebx,%eax
  8023de:	f7 f7                	div    %edi
  8023e0:	31 ff                	xor    %edi,%edi
  8023e2:	89 fa                	mov    %edi,%edx
  8023e4:	83 c4 1c             	add    $0x1c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    
  8023ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023f1:	89 eb                	mov    %ebp,%ebx
  8023f3:	29 fb                	sub    %edi,%ebx
  8023f5:	89 f9                	mov    %edi,%ecx
  8023f7:	d3 e6                	shl    %cl,%esi
  8023f9:	89 c5                	mov    %eax,%ebp
  8023fb:	88 d9                	mov    %bl,%cl
  8023fd:	d3 ed                	shr    %cl,%ebp
  8023ff:	89 e9                	mov    %ebp,%ecx
  802401:	09 f1                	or     %esi,%ecx
  802403:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802407:	89 f9                	mov    %edi,%ecx
  802409:	d3 e0                	shl    %cl,%eax
  80240b:	89 c5                	mov    %eax,%ebp
  80240d:	89 d6                	mov    %edx,%esi
  80240f:	88 d9                	mov    %bl,%cl
  802411:	d3 ee                	shr    %cl,%esi
  802413:	89 f9                	mov    %edi,%ecx
  802415:	d3 e2                	shl    %cl,%edx
  802417:	8b 44 24 08          	mov    0x8(%esp),%eax
  80241b:	88 d9                	mov    %bl,%cl
  80241d:	d3 e8                	shr    %cl,%eax
  80241f:	09 c2                	or     %eax,%edx
  802421:	89 d0                	mov    %edx,%eax
  802423:	89 f2                	mov    %esi,%edx
  802425:	f7 74 24 0c          	divl   0xc(%esp)
  802429:	89 d6                	mov    %edx,%esi
  80242b:	89 c3                	mov    %eax,%ebx
  80242d:	f7 e5                	mul    %ebp
  80242f:	39 d6                	cmp    %edx,%esi
  802431:	72 19                	jb     80244c <__udivdi3+0xfc>
  802433:	74 0b                	je     802440 <__udivdi3+0xf0>
  802435:	89 d8                	mov    %ebx,%eax
  802437:	31 ff                	xor    %edi,%edi
  802439:	e9 58 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  80243e:	66 90                	xchg   %ax,%ax
  802440:	8b 54 24 08          	mov    0x8(%esp),%edx
  802444:	89 f9                	mov    %edi,%ecx
  802446:	d3 e2                	shl    %cl,%edx
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	73 e9                	jae    802435 <__udivdi3+0xe5>
  80244c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80244f:	31 ff                	xor    %edi,%edi
  802451:	e9 40 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  802456:	66 90                	xchg   %ax,%ax
  802458:	31 c0                	xor    %eax,%eax
  80245a:	e9 37 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  80245f:	90                   	nop

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80246b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80246f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802473:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802477:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80247b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80247f:	89 f3                	mov    %esi,%ebx
  802481:	89 fa                	mov    %edi,%edx
  802483:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802487:	89 34 24             	mov    %esi,(%esp)
  80248a:	85 c0                	test   %eax,%eax
  80248c:	75 1a                	jne    8024a8 <__umoddi3+0x48>
  80248e:	39 f7                	cmp    %esi,%edi
  802490:	0f 86 a2 00 00 00    	jbe    802538 <__umoddi3+0xd8>
  802496:	89 c8                	mov    %ecx,%eax
  802498:	89 f2                	mov    %esi,%edx
  80249a:	f7 f7                	div    %edi
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	31 d2                	xor    %edx,%edx
  8024a0:	83 c4 1c             	add    $0x1c,%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	39 f0                	cmp    %esi,%eax
  8024aa:	0f 87 ac 00 00 00    	ja     80255c <__umoddi3+0xfc>
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	0f 84 ac 00 00 00    	je     802568 <__umoddi3+0x108>
  8024bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8024c1:	29 ef                	sub    %ebp,%edi
  8024c3:	89 fe                	mov    %edi,%esi
  8024c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	d3 e0                	shl    %cl,%eax
  8024cd:	89 d7                	mov    %edx,%edi
  8024cf:	89 f1                	mov    %esi,%ecx
  8024d1:	d3 ef                	shr    %cl,%edi
  8024d3:	09 c7                	or     %eax,%edi
  8024d5:	89 e9                	mov    %ebp,%ecx
  8024d7:	d3 e2                	shl    %cl,%edx
  8024d9:	89 14 24             	mov    %edx,(%esp)
  8024dc:	89 d8                	mov    %ebx,%eax
  8024de:	d3 e0                	shl    %cl,%eax
  8024e0:	89 c2                	mov    %eax,%edx
  8024e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024e6:	d3 e0                	shl    %cl,%eax
  8024e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024f0:	89 f1                	mov    %esi,%ecx
  8024f2:	d3 e8                	shr    %cl,%eax
  8024f4:	09 d0                	or     %edx,%eax
  8024f6:	d3 eb                	shr    %cl,%ebx
  8024f8:	89 da                	mov    %ebx,%edx
  8024fa:	f7 f7                	div    %edi
  8024fc:	89 d3                	mov    %edx,%ebx
  8024fe:	f7 24 24             	mull   (%esp)
  802501:	89 c6                	mov    %eax,%esi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	39 d3                	cmp    %edx,%ebx
  802507:	0f 82 87 00 00 00    	jb     802594 <__umoddi3+0x134>
  80250d:	0f 84 91 00 00 00    	je     8025a4 <__umoddi3+0x144>
  802513:	8b 54 24 04          	mov    0x4(%esp),%edx
  802517:	29 f2                	sub    %esi,%edx
  802519:	19 cb                	sbb    %ecx,%ebx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 e9                	mov    %ebp,%ecx
  802525:	d3 ea                	shr    %cl,%edx
  802527:	09 d0                	or     %edx,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	d3 eb                	shr    %cl,%ebx
  80252d:	89 da                	mov    %ebx,%edx
  80252f:	83 c4 1c             	add    $0x1c,%esp
  802532:	5b                   	pop    %ebx
  802533:	5e                   	pop    %esi
  802534:	5f                   	pop    %edi
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    
  802537:	90                   	nop
  802538:	89 fd                	mov    %edi,%ebp
  80253a:	85 ff                	test   %edi,%edi
  80253c:	75 0b                	jne    802549 <__umoddi3+0xe9>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f7                	div    %edi
  802547:	89 c5                	mov    %eax,%ebp
  802549:	89 f0                	mov    %esi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	f7 f5                	div    %ebp
  80254f:	89 c8                	mov    %ecx,%eax
  802551:	f7 f5                	div    %ebp
  802553:	89 d0                	mov    %edx,%eax
  802555:	e9 44 ff ff ff       	jmp    80249e <__umoddi3+0x3e>
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	89 c8                	mov    %ecx,%eax
  80255e:	89 f2                	mov    %esi,%edx
  802560:	83 c4 1c             	add    $0x1c,%esp
  802563:	5b                   	pop    %ebx
  802564:	5e                   	pop    %esi
  802565:	5f                   	pop    %edi
  802566:	5d                   	pop    %ebp
  802567:	c3                   	ret    
  802568:	3b 04 24             	cmp    (%esp),%eax
  80256b:	72 06                	jb     802573 <__umoddi3+0x113>
  80256d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802571:	77 0f                	ja     802582 <__umoddi3+0x122>
  802573:	89 f2                	mov    %esi,%edx
  802575:	29 f9                	sub    %edi,%ecx
  802577:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80257b:	89 14 24             	mov    %edx,(%esp)
  80257e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802582:	8b 44 24 04          	mov    0x4(%esp),%eax
  802586:	8b 14 24             	mov    (%esp),%edx
  802589:	83 c4 1c             	add    $0x1c,%esp
  80258c:	5b                   	pop    %ebx
  80258d:	5e                   	pop    %esi
  80258e:	5f                   	pop    %edi
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    
  802591:	8d 76 00             	lea    0x0(%esi),%esi
  802594:	2b 04 24             	sub    (%esp),%eax
  802597:	19 fa                	sbb    %edi,%edx
  802599:	89 d1                	mov    %edx,%ecx
  80259b:	89 c6                	mov    %eax,%esi
  80259d:	e9 71 ff ff ff       	jmp    802513 <__umoddi3+0xb3>
  8025a2:	66 90                	xchg   %ax,%ax
  8025a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025a8:	72 ea                	jb     802594 <__umoddi3+0x134>
  8025aa:	89 d9                	mov    %ebx,%ecx
  8025ac:	e9 62 ff ff ff       	jmp    802513 <__umoddi3+0xb3>
