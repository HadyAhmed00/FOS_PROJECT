
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 c0 2f 80 00       	push   $0x802fc0
  80006a:	e8 65 16 00 00       	call   8016d4 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 f4 27 00 00       	call   80286b <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 6f 28 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 cd 23 00 00       	call   80245e <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 e4 2f 80 00       	push   $0x802fe4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 14 30 80 00       	push   $0x803014
  8000b6:	e8 77 13 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 a8 27 00 00       	call   80286b <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 2c 30 80 00       	push   $0x80302c
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 14 30 80 00       	push   $0x803014
  8000db:	e8 52 13 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 09 28 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 98 30 80 00       	push   $0x803098
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 14 30 80 00       	push   $0x803014
  8000fe:	e8 2f 13 00 00       	call   801432 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 63 27 00 00       	call   80286b <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 de 27 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 3c 23 00 00       	call   80245e <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 e4 2f 80 00       	push   $0x802fe4
  800147:	6a 1a                	push   $0x1a
  800149:	68 14 30 80 00       	push   $0x803014
  80014e:	e8 df 12 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 13 27 00 00       	call   80286b <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 2c 30 80 00       	push   $0x80302c
  800169:	6a 1c                	push   $0x1c
  80016b:	68 14 30 80 00       	push   $0x803014
  800170:	e8 bd 12 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 74 27 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 98 30 80 00       	push   $0x803098
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 14 30 80 00       	push   $0x803014
  800193:	e8 9a 12 00 00       	call   801432 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 ce 26 00 00       	call   80286b <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 49 27 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 a7 22 00 00       	call   80245e <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 e4 2f 80 00       	push   $0x802fe4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 14 30 80 00       	push   $0x803014
  8001df:	e8 4e 12 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 82 26 00 00       	call   80286b <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 2c 30 80 00       	push   $0x80302c
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 14 30 80 00       	push   $0x803014
  800201:	e8 2c 12 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 e3 26 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 98 30 80 00       	push   $0x803098
  80021d:	6a 26                	push   $0x26
  80021f:	68 14 30 80 00       	push   $0x803014
  800224:	e8 09 12 00 00       	call   801432 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 3d 26 00 00       	call   80286b <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 b8 26 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 16 22 00 00       	call   80245e <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 e4 2f 80 00       	push   $0x802fe4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 14 30 80 00       	push   $0x803014
  800274:	e8 b9 11 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 ed 25 00 00       	call   80286b <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 2c 30 80 00       	push   $0x80302c
  80028f:	6a 2e                	push   $0x2e
  800291:	68 14 30 80 00       	push   $0x803014
  800296:	e8 97 11 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 4e 26 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 98 30 80 00       	push   $0x803098
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 14 30 80 00       	push   $0x803014
  8002b9:	e8 74 11 00 00       	call   801432 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 a8 25 00 00       	call   80286b <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 23 26 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 7f 21 00 00       	call   80245e <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 e4 2f 80 00       	push   $0x802fe4
  800301:	6a 35                	push   $0x35
  800303:	68 14 30 80 00       	push   $0x803014
  800308:	e8 25 11 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 56 25 00 00       	call   80286b <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 2c 30 80 00       	push   $0x80302c
  800326:	6a 37                	push   $0x37
  800328:	68 14 30 80 00       	push   $0x803014
  80032d:	e8 00 11 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 b7 25 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 98 30 80 00       	push   $0x803098
  800349:	6a 38                	push   $0x38
  80034b:	68 14 30 80 00       	push   $0x803014
  800350:	e8 dd 10 00 00       	call   801432 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 11 25 00 00       	call   80286b <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 8c 25 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 e8 20 00 00       	call   80245e <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 e4 2f 80 00       	push   $0x802fe4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 14 30 80 00       	push   $0x803014
  8003a4:	e8 89 10 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 bd 24 00 00       	call   80286b <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 2c 30 80 00       	push   $0x80302c
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 14 30 80 00       	push   $0x803014
  8003c6:	e8 67 10 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 1e 25 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 98 30 80 00       	push   $0x803098
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 14 30 80 00       	push   $0x803014
  8003e9:	e8 44 10 00 00       	call   801432 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 78 24 00 00       	call   80286b <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 f3 24 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 4b 20 00 00       	call   80245e <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 e4 2f 80 00       	push   $0x802fe4
  800435:	6a 47                	push   $0x47
  800437:	68 14 30 80 00       	push   $0x803014
  80043c:	e8 f1 0f 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 22 24 00 00       	call   80286b <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 2c 30 80 00       	push   $0x80302c
  80045a:	6a 49                	push   $0x49
  80045c:	68 14 30 80 00       	push   $0x803014
  800461:	e8 cc 0f 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 83 24 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 98 30 80 00       	push   $0x803098
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 14 30 80 00       	push   $0x803014
  800484:	e8 a9 0f 00 00       	call   801432 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 dd 23 00 00       	call   80286b <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 58 24 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 b0 1f 00 00       	call   80245e <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 e4 2f 80 00       	push   $0x802fe4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 14 30 80 00       	push   $0x803014
  8004df:	e8 4e 0f 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 7f 23 00 00       	call   80286b <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 2c 30 80 00       	push   $0x80302c
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 14 30 80 00       	push   $0x803014
  800504:	e8 29 0f 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 e0 23 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 98 30 80 00       	push   $0x803098
  800520:	6a 53                	push   $0x53
  800522:	68 14 30 80 00       	push   $0x803014
  800527:	e8 06 0f 00 00       	call   801432 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 3a 23 00 00       	call   80286b <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 b5 23 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 fa 1e 00 00       	call   80245e <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 e4 2f 80 00       	push   $0x802fe4
  80058f:	6a 59                	push   $0x59
  800591:	68 14 30 80 00       	push   $0x803014
  800596:	e8 97 0e 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 c8 22 00 00       	call   80286b <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 2c 30 80 00       	push   $0x80302c
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 14 30 80 00       	push   $0x803014
  8005bb:	e8 72 0e 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 29 23 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 98 30 80 00       	push   $0x803098
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 14 30 80 00       	push   $0x803014
  8005de:	e8 4f 0e 00 00       	call   801432 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 83 22 00 00       	call   80286b <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 fe 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 12 20 00 00       	call   802614 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 e4 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 c8 30 80 00       	push   $0x8030c8
  800620:	6a 67                	push   $0x67
  800622:	68 14 30 80 00       	push   $0x803014
  800627:	e8 06 0e 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 3a 22 00 00       	call   80286b <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 04 31 80 00       	push   $0x803104
  800642:	6a 68                	push   $0x68
  800644:	68 14 30 80 00       	push   $0x803014
  800649:	e8 e4 0d 00 00       	call   801432 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 18 22 00 00       	call   80286b <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 93 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 aa 1f 00 00       	call   802614 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 7c 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 c8 30 80 00       	push   $0x8030c8
  800688:	6a 6f                	push   $0x6f
  80068a:	68 14 30 80 00       	push   $0x803014
  80068f:	e8 9e 0d 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 d2 21 00 00       	call   80286b <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 04 31 80 00       	push   $0x803104
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 14 30 80 00       	push   $0x803014
  8006b1:	e8 7c 0d 00 00       	call   801432 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 b0 21 00 00       	call   80286b <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 2b 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 42 1f 00 00       	call   802614 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 14 22 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 c8 30 80 00       	push   $0x8030c8
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 14 30 80 00       	push   $0x803014
  8006f7:	e8 36 0d 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 6a 21 00 00       	call   80286b <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 04 31 80 00       	push   $0x803104
  800712:	6a 78                	push   $0x78
  800714:	68 14 30 80 00       	push   $0x803014
  800719:	e8 14 0d 00 00       	call   801432 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 53 24 00 00       	call   802b82 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 2b 21 00 00       	call   80286b <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 a6 21 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 2f 1f 00 00       	call   80268b <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 50 31 80 00       	push   $0x803150
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 14 30 80 00       	push   $0x803014
  800781:	e8 ac 0c 00 00       	call   801432 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 e0 20 00 00       	call   80286b <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 98 31 80 00       	push   $0x803198
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 14 30 80 00       	push   $0x803014
  8007a6:	e8 87 0c 00 00       	call   801432 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 3e 21 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 08 32 80 00       	push   $0x803208
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 14 30 80 00       	push   $0x803014
  8007d0:	e8 5d 0c 00 00       	call   801432 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 89 23 00 00       	call   802b69 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 3c 32 80 00       	push   $0x80323c
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 14 30 80 00       	push   $0x803014
  8007fb:	e8 32 0c 00 00       	call   801432 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 53 23 00 00       	call   802b69 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 90 32 80 00       	push   $0x803290
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 14 30 80 00       	push   $0x803014
  80083c:	e8 f1 0b 00 00       	call   801432 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 37 23 00 00       	call   802b82 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 de 32 80 00       	push   $0x8032de
  800858:	e8 0c 0e 00 00       	call   801669 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 06 20 00 00       	call   80286b <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 81 20 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 fd 1d 00 00       	call   80268b <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 e4 2f 80 00       	push   $0x802fe4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 14 30 80 00       	push   $0x803014
  8008ba:	e8 73 0b 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 a7 1f 00 00       	call   80286b <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 98 31 80 00       	push   $0x803198
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 14 30 80 00       	push   $0x803014
  8008df:	e8 4e 0b 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 05 20 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 08 32 80 00       	push   $0x803208
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 14 30 80 00       	push   $0x803014
  800905:	e8 28 0b 00 00       	call   801432 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 e8 32 80 00       	push   $0x8032e8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 14 30 80 00       	push   $0x803014
  8009b5:	e8 78 0a 00 00       	call   801432 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 e8 32 80 00       	push   $0x8032e8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 14 30 80 00       	push   $0x803014
  8009f6:	e8 37 0a 00 00       	call   801432 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 20 33 80 00       	push   $0x803320
  800a13:	e8 51 0c 00 00       	call   801669 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 4b 1e 00 00       	call   80286b <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 c6 1e 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 37 1c 00 00       	call   80268b <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 28 33 80 00       	push   $0x803328
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 14 30 80 00       	push   $0x803014
  800a80:	e8 ad 09 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 e1 1d 00 00       	call   80286b <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 98 31 80 00       	push   $0x803198
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 14 30 80 00       	push   $0x803014
  800aa5:	e8 88 09 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 3f 1e 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 08 32 80 00       	push   $0x803208
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 14 30 80 00       	push   $0x803014
  800ac6:	e8 67 09 00 00       	call   801432 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 e8 32 80 00       	push   $0x8032e8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 14 30 80 00       	push   $0x803014
  800b75:	e8 b8 08 00 00       	call   801432 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 e8 32 80 00       	push   $0x8032e8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 14 30 80 00       	push   $0x803014
  800bb7:	e8 76 08 00 00       	call   801432 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 e8 32 80 00       	push   $0x8032e8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 14 30 80 00       	push   $0x803014
  800bfe:	e8 2f 08 00 00       	call   801432 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 e8 32 80 00       	push   $0x8032e8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 14 30 80 00       	push   $0x803014
  800c44:	e8 e9 07 00 00       	call   801432 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 0f 1c 00 00       	call   80286b <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 8a 1c 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 a1 19 00 00       	call   802614 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 73 1c 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 5c 33 80 00       	push   $0x80335c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 14 30 80 00       	push   $0x803014
  800c9b:	e8 92 07 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 c6 1b 00 00       	call   80286b <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 b0 33 80 00       	push   $0x8033b0
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 14 30 80 00       	push   $0x803014
  800cc5:	e8 68 07 00 00       	call   801432 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 14 34 80 00       	push   $0x803414
  800cd4:	e8 90 09 00 00       	call   801669 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 23 1b 00 00       	call   80286b <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 9e 1b 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 0f 19 00 00       	call   80268b <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 28 33 80 00       	push   $0x803328
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 14 30 80 00       	push   $0x803014
  800d9b:	e8 92 06 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 c6 1a 00 00       	call   80286b <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 98 31 80 00       	push   $0x803198
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 14 30 80 00       	push   $0x803014
  800dc0:	e8 6d 06 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 24 1b 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 08 32 80 00       	push   $0x803208
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 14 30 80 00       	push   $0x803014
  800de1:	e8 4c 06 00 00       	call   801432 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 e8 32 80 00       	push   $0x8032e8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 14 30 80 00       	push   $0x803014
  800e1a:	e8 13 06 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 e8 32 80 00       	push   $0x8032e8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 14 30 80 00       	push   $0x803014
  800e5b:	e8 d2 05 00 00       	call   801432 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 f8 19 00 00       	call   80286b <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 73 1a 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 8b 17 00 00       	call   802614 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 5d 1a 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 5c 33 80 00       	push   $0x80335c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 14 30 80 00       	push   $0x803014
  800eb1:	e8 7c 05 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 b0 19 00 00       	call   80286b <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 b0 33 80 00       	push   $0x8033b0
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 14 30 80 00       	push   $0x803014
  800edb:	e8 52 05 00 00       	call   801432 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 1b 34 80 00       	push   $0x80341b
  800eea:	e8 7a 07 00 00       	call   801669 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 74 19 00 00       	call   80286b <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 ef 19 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 4b 15 00 00       	call   80245e <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 e4 2f 80 00       	push   $0x802fe4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 14 30 80 00       	push   $0x803014
  800f35:	e8 f8 04 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 2c 19 00 00       	call   80286b <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 2c 30 80 00       	push   $0x80302c
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 14 30 80 00       	push   $0x803014
  800f5a:	e8 d3 04 00 00       	call   801432 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 8a 19 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 98 30 80 00       	push   $0x803098
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 14 30 80 00       	push   $0x803014
  800f80:	e8 ad 04 00 00       	call   801432 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 e1 18 00 00       	call   80286b <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 5c 19 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 73 16 00 00       	call   802614 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 45 19 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 c8 30 80 00       	push   $0x8030c8
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 14 30 80 00       	push   $0x803014
  800fc9:	e8 64 04 00 00       	call   801432 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 98 18 00 00       	call   80286b <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 04 31 80 00       	push   $0x803104
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 14 30 80 00       	push   $0x803014
  800fee:	e8 3f 04 00 00       	call   801432 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 55 14 00 00       	call   80245e <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 ea 17 00 00       	call   80286b <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 65 18 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 e7 15 00 00       	call   80268b <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 28 33 80 00       	push   $0x803328
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 14 30 80 00       	push   $0x803014
  8010cf:	e8 5e 03 00 00       	call   801432 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 15 18 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 08 32 80 00       	push   $0x803208
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 14 30 80 00       	push   $0x803014
  8010f5:	e8 38 03 00 00       	call   801432 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 e8 32 80 00       	push   $0x8032e8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 14 30 80 00       	push   $0x803014
  801199:	e8 94 02 00 00       	call   801432 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 e8 32 80 00       	push   $0x8032e8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 14 30 80 00       	push   $0x803014
  8011da:	e8 53 02 00 00       	call   801432 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 e8 32 80 00       	push   $0x8032e8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 14 30 80 00       	push   $0x803014
  801221:	e8 0c 02 00 00       	call   801432 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 e8 32 80 00       	push   $0x8032e8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 14 30 80 00       	push   $0x803014
  801267:	e8 c6 01 00 00       	call   801432 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 ec 15 00 00       	call   80286b <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 67 16 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 7e 13 00 00       	call   802614 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 50 16 00 00       	call   8028ee <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 5c 33 80 00       	push   $0x80335c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 14 30 80 00       	push   $0x803014
  8012be:	e8 6f 01 00 00       	call   801432 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 22 34 80 00       	push   $0x803422
  8012cd:	e8 97 03 00 00       	call   801669 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 2c 34 80 00       	push   $0x80342c
  8012dd:	e8 f2 03 00 00       	call   8016d4 <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 a8 14 00 00       	call   8027a0 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80130c:	01 c8                	add    %ecx,%eax
  80130e:	01 c0                	add    %eax,%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	01 c0                	add    %eax,%eax
  801314:	01 d0                	add    %edx,%eax
  801316:	89 c2                	mov    %eax,%edx
  801318:	c1 e2 05             	shl    $0x5,%edx
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  801324:	89 c2                	mov    %eax,%edx
  801326:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80132c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801331:	a1 20 40 80 00       	mov    0x804020,%eax
  801336:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80133c:	84 c0                	test   %al,%al
  80133e:	74 0f                	je     80134f <libmain+0x62>
		binaryname = myEnv->prog_name;
  801340:	a1 20 40 80 00       	mov    0x804020,%eax
  801345:	05 40 3c 01 00       	add    $0x13c40,%eax
  80134a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80134f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801353:	7e 0a                	jle    80135f <libmain+0x72>
		binaryname = argv[0];
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	e8 cb ec ff ff       	call   800038 <_main>
  80136d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  801370:	e8 c6 15 00 00       	call   80293b <sys_disable_interrupt>
	cprintf("**************************************\n");
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	68 80 34 80 00       	push   $0x803480
  80137d:	e8 52 03 00 00       	call   8016d4 <cprintf>
  801382:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801385:	a1 20 40 80 00       	mov    0x804020,%eax
  80138a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  801390:	a1 20 40 80 00       	mov    0x804020,%eax
  801395:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	52                   	push   %edx
  80139f:	50                   	push   %eax
  8013a0:	68 a8 34 80 00       	push   $0x8034a8
  8013a5:	e8 2a 03 00 00       	call   8016d4 <cprintf>
  8013aa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8013ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8013b2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8013b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8013bd:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	52                   	push   %edx
  8013c7:	50                   	push   %eax
  8013c8:	68 d0 34 80 00       	push   $0x8034d0
  8013cd:	e8 02 03 00 00       	call   8016d4 <cprintf>
  8013d2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8013da:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	50                   	push   %eax
  8013e4:	68 11 35 80 00       	push   $0x803511
  8013e9:	e8 e6 02 00 00       	call   8016d4 <cprintf>
  8013ee:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	68 80 34 80 00       	push   $0x803480
  8013f9:	e8 d6 02 00 00       	call   8016d4 <cprintf>
  8013fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801401:	e8 4f 15 00 00       	call   802955 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801406:	e8 19 00 00 00       	call   801424 <exit>
}
  80140b:	90                   	nop
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	6a 00                	push   $0x0
  801419:	e8 4e 13 00 00       	call   80276c <sys_env_destroy>
  80141e:	83 c4 10             	add    $0x10,%esp
}
  801421:	90                   	nop
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <exit>:

void
exit(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80142a:	e8 a3 13 00 00       	call   8027d2 <sys_env_exit>
}
  80142f:	90                   	nop
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801438:	8d 45 10             	lea    0x10(%ebp),%eax
  80143b:	83 c0 04             	add    $0x4,%eax
  80143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801441:	a1 18 41 80 00       	mov    0x804118,%eax
  801446:	85 c0                	test   %eax,%eax
  801448:	74 16                	je     801460 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80144a:	a1 18 41 80 00       	mov    0x804118,%eax
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	50                   	push   %eax
  801453:	68 28 35 80 00       	push   $0x803528
  801458:	e8 77 02 00 00       	call   8016d4 <cprintf>
  80145d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801460:	a1 00 40 80 00       	mov    0x804000,%eax
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	50                   	push   %eax
  80146c:	68 2d 35 80 00       	push   $0x80352d
  801471:	e8 5e 02 00 00       	call   8016d4 <cprintf>
  801476:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 f4             	pushl  -0xc(%ebp)
  801482:	50                   	push   %eax
  801483:	e8 e1 01 00 00       	call   801669 <vcprintf>
  801488:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	6a 00                	push   $0x0
  801490:	68 49 35 80 00       	push   $0x803549
  801495:	e8 cf 01 00 00       	call   801669 <vcprintf>
  80149a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80149d:	e8 82 ff ff ff       	call   801424 <exit>

	// should not return here
	while (1) ;
  8014a2:	eb fe                	jmp    8014a2 <_panic+0x70>

008014a4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8014af:	8b 50 74             	mov    0x74(%eax),%edx
  8014b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b5:	39 c2                	cmp    %eax,%edx
  8014b7:	74 14                	je     8014cd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	68 4c 35 80 00       	push   $0x80354c
  8014c1:	6a 26                	push   $0x26
  8014c3:	68 98 35 80 00       	push   $0x803598
  8014c8:	e8 65 ff ff ff       	call   801432 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014db:	e9 b6 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8014e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	8b 00                	mov    (%eax),%eax
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	75 08                	jne    8014fd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014f5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014f8:	e9 96 00 00 00       	jmp    801593 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8014fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801504:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80150b:	eb 5d                	jmp    80156a <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80150d:	a1 20 40 80 00       	mov    0x804020,%eax
  801512:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801518:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80151b:	c1 e2 04             	shl    $0x4,%edx
  80151e:	01 d0                	add    %edx,%eax
  801520:	8a 40 04             	mov    0x4(%eax),%al
  801523:	84 c0                	test   %al,%al
  801525:	75 40                	jne    801567 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801527:	a1 20 40 80 00       	mov    0x804020,%eax
  80152c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801532:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801535:	c1 e2 04             	shl    $0x4,%edx
  801538:	01 d0                	add    %edx,%eax
  80153a:	8b 00                	mov    (%eax),%eax
  80153c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80153f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801542:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801547:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	01 c8                	add    %ecx,%eax
  801558:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155a:	39 c2                	cmp    %eax,%edx
  80155c:	75 09                	jne    801567 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80155e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801565:	eb 12                	jmp    801579 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801567:	ff 45 e8             	incl   -0x18(%ebp)
  80156a:	a1 20 40 80 00       	mov    0x804020,%eax
  80156f:	8b 50 74             	mov    0x74(%eax),%edx
  801572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801575:	39 c2                	cmp    %eax,%edx
  801577:	77 94                	ja     80150d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801579:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80157d:	75 14                	jne    801593 <CheckWSWithoutLastIndex+0xef>
			panic(
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 a4 35 80 00       	push   $0x8035a4
  801587:	6a 3a                	push   $0x3a
  801589:	68 98 35 80 00       	push   $0x803598
  80158e:	e8 9f fe ff ff       	call   801432 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801593:	ff 45 f0             	incl   -0x10(%ebp)
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159c:	0f 8c 3e ff ff ff    	jl     8014e0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b0:	eb 20                	jmp    8015d2 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8015b7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8015bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c0:	c1 e2 04             	shl    $0x4,%edx
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	8a 40 04             	mov    0x4(%eax),%al
  8015c8:	3c 01                	cmp    $0x1,%al
  8015ca:	75 03                	jne    8015cf <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8015cc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015cf:	ff 45 e0             	incl   -0x20(%ebp)
  8015d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8015d7:	8b 50 74             	mov    0x74(%eax),%edx
  8015da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015dd:	39 c2                	cmp    %eax,%edx
  8015df:	77 d1                	ja     8015b2 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015e7:	74 14                	je     8015fd <CheckWSWithoutLastIndex+0x159>
		panic(
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 f8 35 80 00       	push   $0x8035f8
  8015f1:	6a 44                	push   $0x44
  8015f3:	68 98 35 80 00       	push   $0x803598
  8015f8:	e8 35 fe ff ff       	call   801432 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	8d 48 01             	lea    0x1(%eax),%ecx
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	89 0a                	mov    %ecx,(%edx)
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	88 d1                	mov    %dl,%cl
  801618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80161f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	3d ff 00 00 00       	cmp    $0xff,%eax
  801629:	75 2c                	jne    801657 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80162b:	a0 24 40 80 00       	mov    0x804024,%al
  801630:	0f b6 c0             	movzbl %al,%eax
  801633:	8b 55 0c             	mov    0xc(%ebp),%edx
  801636:	8b 12                	mov    (%edx),%edx
  801638:	89 d1                	mov    %edx,%ecx
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	83 c2 08             	add    $0x8,%edx
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	50                   	push   %eax
  801644:	51                   	push   %ecx
  801645:	52                   	push   %edx
  801646:	e8 df 10 00 00       	call   80272a <sys_cputs>
  80164b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	8b 40 04             	mov    0x4(%eax),%eax
  80165d:	8d 50 01             	lea    0x1(%eax),%edx
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	89 50 04             	mov    %edx,0x4(%eax)
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801672:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801679:	00 00 00 
	b.cnt = 0;
  80167c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801683:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	68 00 16 80 00       	push   $0x801600
  801698:	e8 11 02 00 00       	call   8018ae <vprintfmt>
  80169d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a0:	a0 24 40 80 00       	mov    0x804024,%al
  8016a5:	0f b6 c0             	movzbl %al,%eax
  8016a8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	50                   	push   %eax
  8016b2:	52                   	push   %edx
  8016b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016b9:	83 c0 08             	add    $0x8,%eax
  8016bc:	50                   	push   %eax
  8016bd:	e8 68 10 00 00       	call   80272a <sys_cputs>
  8016c2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016c5:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8016cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016da:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8016e1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f0:	50                   	push   %eax
  8016f1:	e8 73 ff ff ff       	call   801669 <vcprintf>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801707:	e8 2f 12 00 00       	call   80293b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80170c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80170f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	ff 75 f4             	pushl  -0xc(%ebp)
  80171b:	50                   	push   %eax
  80171c:	e8 48 ff ff ff       	call   801669 <vcprintf>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801727:	e8 29 12 00 00       	call   802955 <sys_enable_interrupt>
	return cnt;
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	53                   	push   %ebx
  801735:	83 ec 14             	sub    $0x14,%esp
  801738:	8b 45 10             	mov    0x10(%ebp),%eax
  80173b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801744:	8b 45 18             	mov    0x18(%ebp),%eax
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80174f:	77 55                	ja     8017a6 <printnum+0x75>
  801751:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801754:	72 05                	jb     80175b <printnum+0x2a>
  801756:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801759:	77 4b                	ja     8017a6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80175b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80175e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801761:	8b 45 18             	mov    0x18(%ebp),%eax
  801764:	ba 00 00 00 00       	mov    $0x0,%edx
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	ff 75 f4             	pushl  -0xc(%ebp)
  80176e:	ff 75 f0             	pushl  -0x10(%ebp)
  801771:	e8 e6 15 00 00       	call   802d5c <__udivdi3>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	ff 75 20             	pushl  0x20(%ebp)
  80177f:	53                   	push   %ebx
  801780:	ff 75 18             	pushl  0x18(%ebp)
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	e8 a1 ff ff ff       	call   801731 <printnum>
  801790:	83 c4 20             	add    $0x20,%esp
  801793:	eb 1a                	jmp    8017af <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801795:	83 ec 08             	sub    $0x8,%esp
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 20             	pushl  0x20(%ebp)
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	ff d0                	call   *%eax
  8017a3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017a6:	ff 4d 1c             	decl   0x1c(%ebp)
  8017a9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017ad:	7f e6                	jg     801795 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017af:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bd:	53                   	push   %ebx
  8017be:	51                   	push   %ecx
  8017bf:	52                   	push   %edx
  8017c0:	50                   	push   %eax
  8017c1:	e8 a6 16 00 00       	call   802e6c <__umoddi3>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	05 74 38 80 00       	add    $0x803874,%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f be c0             	movsbl %al,%eax
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	ff d0                	call   *%eax
  8017df:	83 c4 10             	add    $0x10,%esp
}
  8017e2:	90                   	nop
  8017e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017ef:	7e 1c                	jle    80180d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8b 00                	mov    (%eax),%eax
  8017f6:	8d 50 08             	lea    0x8(%eax),%edx
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	89 10                	mov    %edx,(%eax)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8b 00                	mov    (%eax),%eax
  801803:	83 e8 08             	sub    $0x8,%eax
  801806:	8b 50 04             	mov    0x4(%eax),%edx
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	eb 40                	jmp    80184d <getuint+0x65>
	else if (lflag)
  80180d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801811:	74 1e                	je     801831 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8b 00                	mov    (%eax),%eax
  801818:	8d 50 04             	lea    0x4(%eax),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	89 10                	mov    %edx,(%eax)
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	83 e8 04             	sub    $0x4,%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	ba 00 00 00 00       	mov    $0x0,%edx
  80182f:	eb 1c                	jmp    80184d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8b 00                	mov    (%eax),%eax
  801836:	8d 50 04             	lea    0x4(%eax),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	89 10                	mov    %edx,(%eax)
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8b 00                	mov    (%eax),%eax
  801843:	83 e8 04             	sub    $0x4,%eax
  801846:	8b 00                	mov    (%eax),%eax
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801852:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801856:	7e 1c                	jle    801874 <getint+0x25>
		return va_arg(*ap, long long);
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	8b 00                	mov    (%eax),%eax
  80185d:	8d 50 08             	lea    0x8(%eax),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	89 10                	mov    %edx,(%eax)
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	83 e8 08             	sub    $0x8,%eax
  80186d:	8b 50 04             	mov    0x4(%eax),%edx
  801870:	8b 00                	mov    (%eax),%eax
  801872:	eb 38                	jmp    8018ac <getint+0x5d>
	else if (lflag)
  801874:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801878:	74 1a                	je     801894 <getint+0x45>
		return va_arg(*ap, long);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8b 00                	mov    (%eax),%eax
  80187f:	8d 50 04             	lea    0x4(%eax),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	89 10                	mov    %edx,(%eax)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	8b 00                	mov    (%eax),%eax
  80188c:	83 e8 04             	sub    $0x4,%eax
  80188f:	8b 00                	mov    (%eax),%eax
  801891:	99                   	cltd   
  801892:	eb 18                	jmp    8018ac <getint+0x5d>
	else
		return va_arg(*ap, int);
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8b 00                	mov    (%eax),%eax
  801899:	8d 50 04             	lea    0x4(%eax),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	89 10                	mov    %edx,(%eax)
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	83 e8 04             	sub    $0x4,%eax
  8018a9:	8b 00                	mov    (%eax),%eax
  8018ab:	99                   	cltd   
}
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    

008018ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	56                   	push   %esi
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018b6:	eb 17                	jmp    8018cf <vprintfmt+0x21>
			if (ch == '\0')
  8018b8:	85 db                	test   %ebx,%ebx
  8018ba:	0f 84 af 03 00 00    	je     801c6f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	53                   	push   %ebx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	ff d0                	call   *%eax
  8018cc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d2:	8d 50 01             	lea    0x1(%eax),%edx
  8018d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	0f b6 d8             	movzbl %al,%ebx
  8018dd:	83 fb 25             	cmp    $0x25,%ebx
  8018e0:	75 d6                	jne    8018b8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018e2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8018fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801902:	8b 45 10             	mov    0x10(%ebp),%eax
  801905:	8d 50 01             	lea    0x1(%eax),%edx
  801908:	89 55 10             	mov    %edx,0x10(%ebp)
  80190b:	8a 00                	mov    (%eax),%al
  80190d:	0f b6 d8             	movzbl %al,%ebx
  801910:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801913:	83 f8 55             	cmp    $0x55,%eax
  801916:	0f 87 2b 03 00 00    	ja     801c47 <vprintfmt+0x399>
  80191c:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  801923:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801925:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801929:	eb d7                	jmp    801902 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80192b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80192f:	eb d1                	jmp    801902 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801931:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801938:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80193b:	89 d0                	mov    %edx,%eax
  80193d:	c1 e0 02             	shl    $0x2,%eax
  801940:	01 d0                	add    %edx,%eax
  801942:	01 c0                	add    %eax,%eax
  801944:	01 d8                	add    %ebx,%eax
  801946:	83 e8 30             	sub    $0x30,%eax
  801949:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80194c:	8b 45 10             	mov    0x10(%ebp),%eax
  80194f:	8a 00                	mov    (%eax),%al
  801951:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801954:	83 fb 2f             	cmp    $0x2f,%ebx
  801957:	7e 3e                	jle    801997 <vprintfmt+0xe9>
  801959:	83 fb 39             	cmp    $0x39,%ebx
  80195c:	7f 39                	jg     801997 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80195e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801961:	eb d5                	jmp    801938 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801963:	8b 45 14             	mov    0x14(%ebp),%eax
  801966:	83 c0 04             	add    $0x4,%eax
  801969:	89 45 14             	mov    %eax,0x14(%ebp)
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 e8 04             	sub    $0x4,%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801977:	eb 1f                	jmp    801998 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801979:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80197d:	79 83                	jns    801902 <vprintfmt+0x54>
				width = 0;
  80197f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801986:	e9 77 ff ff ff       	jmp    801902 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80198b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801992:	e9 6b ff ff ff       	jmp    801902 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801997:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801998:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80199c:	0f 89 60 ff ff ff    	jns    801902 <vprintfmt+0x54>
				width = precision, precision = -1;
  8019a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019a8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019af:	e9 4e ff ff ff       	jmp    801902 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019b4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019b7:	e9 46 ff ff ff       	jmp    801902 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bf:	83 c0 04             	add    $0x4,%eax
  8019c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 e8 04             	sub    $0x4,%eax
  8019cb:	8b 00                	mov    (%eax),%eax
  8019cd:	83 ec 08             	sub    $0x8,%esp
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	ff d0                	call   *%eax
  8019d9:	83 c4 10             	add    $0x10,%esp
			break;
  8019dc:	e9 89 02 00 00       	jmp    801c6a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e4:	83 c0 04             	add    $0x4,%eax
  8019e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 e8 04             	sub    $0x4,%eax
  8019f0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019f2:	85 db                	test   %ebx,%ebx
  8019f4:	79 02                	jns    8019f8 <vprintfmt+0x14a>
				err = -err;
  8019f6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8019f8:	83 fb 64             	cmp    $0x64,%ebx
  8019fb:	7f 0b                	jg     801a08 <vprintfmt+0x15a>
  8019fd:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  801a04:	85 f6                	test   %esi,%esi
  801a06:	75 19                	jne    801a21 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a08:	53                   	push   %ebx
  801a09:	68 85 38 80 00       	push   $0x803885
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 5e 02 00 00       	call   801c77 <printfmt>
  801a19:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a1c:	e9 49 02 00 00       	jmp    801c6a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a21:	56                   	push   %esi
  801a22:	68 8e 38 80 00       	push   $0x80388e
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	ff 75 08             	pushl  0x8(%ebp)
  801a2d:	e8 45 02 00 00       	call   801c77 <printfmt>
  801a32:	83 c4 10             	add    $0x10,%esp
			break;
  801a35:	e9 30 02 00 00       	jmp    801c6a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3d:	83 c0 04             	add    $0x4,%eax
  801a40:	89 45 14             	mov    %eax,0x14(%ebp)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 e8 04             	sub    $0x4,%eax
  801a49:	8b 30                	mov    (%eax),%esi
  801a4b:	85 f6                	test   %esi,%esi
  801a4d:	75 05                	jne    801a54 <vprintfmt+0x1a6>
				p = "(null)";
  801a4f:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  801a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a58:	7e 6d                	jle    801ac7 <vprintfmt+0x219>
  801a5a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a5e:	74 67                	je     801ac7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	50                   	push   %eax
  801a67:	56                   	push   %esi
  801a68:	e8 0c 03 00 00       	call   801d79 <strnlen>
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a73:	eb 16                	jmp    801a8b <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a75:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a79:	83 ec 08             	sub    $0x8,%esp
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	50                   	push   %eax
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	ff d0                	call   *%eax
  801a85:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a88:	ff 4d e4             	decl   -0x1c(%ebp)
  801a8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a8f:	7f e4                	jg     801a75 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a91:	eb 34                	jmp    801ac7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a97:	74 1c                	je     801ab5 <vprintfmt+0x207>
  801a99:	83 fb 1f             	cmp    $0x1f,%ebx
  801a9c:	7e 05                	jle    801aa3 <vprintfmt+0x1f5>
  801a9e:	83 fb 7e             	cmp    $0x7e,%ebx
  801aa1:	7e 12                	jle    801ab5 <vprintfmt+0x207>
					putch('?', putdat);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	6a 3f                	push   $0x3f
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	ff d0                	call   *%eax
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	eb 0f                	jmp    801ac4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	53                   	push   %ebx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	ff d0                	call   *%eax
  801ac1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ac4:	ff 4d e4             	decl   -0x1c(%ebp)
  801ac7:	89 f0                	mov    %esi,%eax
  801ac9:	8d 70 01             	lea    0x1(%eax),%esi
  801acc:	8a 00                	mov    (%eax),%al
  801ace:	0f be d8             	movsbl %al,%ebx
  801ad1:	85 db                	test   %ebx,%ebx
  801ad3:	74 24                	je     801af9 <vprintfmt+0x24b>
  801ad5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ad9:	78 b8                	js     801a93 <vprintfmt+0x1e5>
  801adb:	ff 4d e0             	decl   -0x20(%ebp)
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	79 af                	jns    801a93 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ae4:	eb 13                	jmp    801af9 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ae6:	83 ec 08             	sub    $0x8,%esp
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	6a 20                	push   $0x20
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	ff d0                	call   *%eax
  801af3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801af6:	ff 4d e4             	decl   -0x1c(%ebp)
  801af9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801afd:	7f e7                	jg     801ae6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801aff:	e9 66 01 00 00       	jmp    801c6a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	ff 75 e8             	pushl  -0x18(%ebp)
  801b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	e8 3c fd ff ff       	call   80184f <getint>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b22:	85 d2                	test   %edx,%edx
  801b24:	79 23                	jns    801b49 <vprintfmt+0x29b>
				putch('-', putdat);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	6a 2d                	push   $0x2d
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	ff d0                	call   *%eax
  801b33:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3c:	f7 d8                	neg    %eax
  801b3e:	83 d2 00             	adc    $0x0,%edx
  801b41:	f7 da                	neg    %edx
  801b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b50:	e9 bc 00 00 00       	jmp    801c11 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	ff 75 e8             	pushl  -0x18(%ebp)
  801b5b:	8d 45 14             	lea    0x14(%ebp),%eax
  801b5e:	50                   	push   %eax
  801b5f:	e8 84 fc ff ff       	call   8017e8 <getuint>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b74:	e9 98 00 00 00       	jmp    801c11 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	6a 58                	push   $0x58
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	ff d0                	call   *%eax
  801b86:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b89:	83 ec 08             	sub    $0x8,%esp
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	6a 58                	push   $0x58
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	ff d0                	call   *%eax
  801b96:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	6a 58                	push   $0x58
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	ff d0                	call   *%eax
  801ba6:	83 c4 10             	add    $0x10,%esp
			break;
  801ba9:	e9 bc 00 00 00       	jmp    801c6a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	6a 30                	push   $0x30
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	ff d0                	call   *%eax
  801bbb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	6a 78                	push   $0x78
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	ff d0                	call   *%eax
  801bcb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bce:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd1:	83 c0 04             	add    $0x4,%eax
  801bd4:	89 45 14             	mov    %eax,0x14(%ebp)
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 e8 04             	sub    $0x4,%eax
  801bdd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801be9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf0:	eb 1f                	jmp    801c11 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bf2:	83 ec 08             	sub    $0x8,%esp
  801bf5:	ff 75 e8             	pushl  -0x18(%ebp)
  801bf8:	8d 45 14             	lea    0x14(%ebp),%eax
  801bfb:	50                   	push   %eax
  801bfc:	e8 e7 fb ff ff       	call   8017e8 <getuint>
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c0a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c11:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	52                   	push   %edx
  801c1c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c1f:	50                   	push   %eax
  801c20:	ff 75 f4             	pushl  -0xc(%ebp)
  801c23:	ff 75 f0             	pushl  -0x10(%ebp)
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	ff 75 08             	pushl  0x8(%ebp)
  801c2c:	e8 00 fb ff ff       	call   801731 <printnum>
  801c31:	83 c4 20             	add    $0x20,%esp
			break;
  801c34:	eb 34                	jmp    801c6a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c36:	83 ec 08             	sub    $0x8,%esp
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	53                   	push   %ebx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	ff d0                	call   *%eax
  801c42:	83 c4 10             	add    $0x10,%esp
			break;
  801c45:	eb 23                	jmp    801c6a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c47:	83 ec 08             	sub    $0x8,%esp
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	6a 25                	push   $0x25
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	ff d0                	call   *%eax
  801c54:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c57:	ff 4d 10             	decl   0x10(%ebp)
  801c5a:	eb 03                	jmp    801c5f <vprintfmt+0x3b1>
  801c5c:	ff 4d 10             	decl   0x10(%ebp)
  801c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c62:	48                   	dec    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 25                	cmp    $0x25,%al
  801c67:	75 f3                	jne    801c5c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c69:	90                   	nop
		}
	}
  801c6a:	e9 47 fc ff ff       	jmp    8018b6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c6f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    

00801c77 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c7d:	8d 45 10             	lea    0x10(%ebp),%eax
  801c80:	83 c0 04             	add    $0x4,%eax
  801c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c86:	8b 45 10             	mov    0x10(%ebp),%eax
  801c89:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8c:	50                   	push   %eax
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 16 fc ff ff       	call   8018ae <vprintfmt>
  801c98:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	8b 40 08             	mov    0x8(%eax),%eax
  801ca7:	8d 50 01             	lea    0x1(%eax),%edx
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb3:	8b 10                	mov    (%eax),%edx
  801cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb8:	8b 40 04             	mov    0x4(%eax),%eax
  801cbb:	39 c2                	cmp    %eax,%edx
  801cbd:	73 12                	jae    801cd1 <sprintputch+0x33>
		*b->buf++ = ch;
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	8b 00                	mov    (%eax),%eax
  801cc4:	8d 48 01             	lea    0x1(%eax),%ecx
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	89 0a                	mov    %ecx,(%edx)
  801ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  801ccf:	88 10                	mov    %dl,(%eax)
}
  801cd1:	90                   	nop
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	01 d0                	add    %edx,%eax
  801ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf9:	74 06                	je     801d01 <vsnprintf+0x2d>
  801cfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cff:	7f 07                	jg     801d08 <vsnprintf+0x34>
		return -E_INVAL;
  801d01:	b8 03 00 00 00       	mov    $0x3,%eax
  801d06:	eb 20                	jmp    801d28 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d08:	ff 75 14             	pushl  0x14(%ebp)
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d11:	50                   	push   %eax
  801d12:	68 9e 1c 80 00       	push   $0x801c9e
  801d17:	e8 92 fb ff ff       	call   8018ae <vprintfmt>
  801d1c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d30:	8d 45 10             	lea    0x10(%ebp),%eax
  801d33:	83 c0 04             	add    $0x4,%eax
  801d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d39:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3f:	50                   	push   %eax
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	ff 75 08             	pushl  0x8(%ebp)
  801d46:	e8 89 ff ff ff       	call   801cd4 <vsnprintf>
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d63:	eb 06                	jmp    801d6b <strlen+0x15>
		n++;
  801d65:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d68:	ff 45 08             	incl   0x8(%ebp)
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	8a 00                	mov    (%eax),%al
  801d70:	84 c0                	test   %al,%al
  801d72:	75 f1                	jne    801d65 <strlen+0xf>
		n++;
	return n;
  801d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d86:	eb 09                	jmp    801d91 <strnlen+0x18>
		n++;
  801d88:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d8b:	ff 45 08             	incl   0x8(%ebp)
  801d8e:	ff 4d 0c             	decl   0xc(%ebp)
  801d91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d95:	74 09                	je     801da0 <strnlen+0x27>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	84 c0                	test   %al,%al
  801d9e:	75 e8                	jne    801d88 <strnlen+0xf>
		n++;
	return n;
  801da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801db1:	90                   	nop
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8d 50 01             	lea    0x1(%eax),%edx
  801db8:	89 55 08             	mov    %edx,0x8(%ebp)
  801dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dc4:	8a 12                	mov    (%edx),%dl
  801dc6:	88 10                	mov    %dl,(%eax)
  801dc8:	8a 00                	mov    (%eax),%al
  801dca:	84 c0                	test   %al,%al
  801dcc:	75 e4                	jne    801db2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801ddf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801de6:	eb 1f                	jmp    801e07 <strncpy+0x34>
		*dst++ = *src;
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	8d 50 01             	lea    0x1(%eax),%edx
  801dee:	89 55 08             	mov    %edx,0x8(%ebp)
  801df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df4:	8a 12                	mov    (%edx),%dl
  801df6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	8a 00                	mov    (%eax),%al
  801dfd:	84 c0                	test   %al,%al
  801dff:	74 03                	je     801e04 <strncpy+0x31>
			src++;
  801e01:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e04:	ff 45 fc             	incl   -0x4(%ebp)
  801e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e0d:	72 d9                	jb     801de8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e24:	74 30                	je     801e56 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e26:	eb 16                	jmp    801e3e <strlcpy+0x2a>
			*dst++ = *src++;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	8d 50 01             	lea    0x1(%eax),%edx
  801e2e:	89 55 08             	mov    %edx,0x8(%ebp)
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e3a:	8a 12                	mov    (%edx),%dl
  801e3c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e3e:	ff 4d 10             	decl   0x10(%ebp)
  801e41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e45:	74 09                	je     801e50 <strlcpy+0x3c>
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	8a 00                	mov    (%eax),%al
  801e4c:	84 c0                	test   %al,%al
  801e4e:	75 d8                	jne    801e28 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e56:	8b 55 08             	mov    0x8(%ebp),%edx
  801e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e5c:	29 c2                	sub    %eax,%edx
  801e5e:	89 d0                	mov    %edx,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e65:	eb 06                	jmp    801e6d <strcmp+0xb>
		p++, q++;
  801e67:	ff 45 08             	incl   0x8(%ebp)
  801e6a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8a 00                	mov    (%eax),%al
  801e72:	84 c0                	test   %al,%al
  801e74:	74 0e                	je     801e84 <strcmp+0x22>
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 10                	mov    (%eax),%dl
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	38 c2                	cmp    %al,%dl
  801e82:	74 e3                	je     801e67 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	0f b6 d0             	movzbl %al,%edx
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	0f b6 c0             	movzbl %al,%eax
  801e94:	29 c2                	sub    %eax,%edx
  801e96:	89 d0                	mov    %edx,%eax
}
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e9d:	eb 09                	jmp    801ea8 <strncmp+0xe>
		n--, p++, q++;
  801e9f:	ff 4d 10             	decl   0x10(%ebp)
  801ea2:	ff 45 08             	incl   0x8(%ebp)
  801ea5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801ea8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eac:	74 17                	je     801ec5 <strncmp+0x2b>
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	8a 00                	mov    (%eax),%al
  801eb3:	84 c0                	test   %al,%al
  801eb5:	74 0e                	je     801ec5 <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 10                	mov    (%eax),%dl
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	8a 00                	mov    (%eax),%al
  801ec1:	38 c2                	cmp    %al,%dl
  801ec3:	74 da                	je     801e9f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec9:	75 07                	jne    801ed2 <strncmp+0x38>
		return 0;
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	eb 14                	jmp    801ee6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	8a 00                	mov    (%eax),%al
  801ed7:	0f b6 d0             	movzbl %al,%edx
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	0f b6 c0             	movzbl %al,%eax
  801ee2:	29 c2                	sub    %eax,%edx
  801ee4:	89 d0                	mov    %edx,%eax
}
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ef4:	eb 12                	jmp    801f08 <strchr+0x20>
		if (*s == c)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8a 00                	mov    (%eax),%al
  801efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801efe:	75 05                	jne    801f05 <strchr+0x1d>
			return (char *) s;
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	eb 11                	jmp    801f16 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f05:	ff 45 08             	incl   0x8(%ebp)
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	8a 00                	mov    (%eax),%al
  801f0d:	84 c0                	test   %al,%al
  801f0f:	75 e5                	jne    801ef6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f24:	eb 0d                	jmp    801f33 <strfind+0x1b>
		if (*s == c)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8a 00                	mov    (%eax),%al
  801f2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f2e:	74 0e                	je     801f3e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f30:	ff 45 08             	incl   0x8(%ebp)
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	8a 00                	mov    (%eax),%al
  801f38:	84 c0                	test   %al,%al
  801f3a:	75 ea                	jne    801f26 <strfind+0xe>
  801f3c:	eb 01                	jmp    801f3f <strfind+0x27>
		if (*s == c)
			break;
  801f3e:	90                   	nop
	return (char *) s;
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f50:	8b 45 10             	mov    0x10(%ebp),%eax
  801f53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f56:	eb 0e                	jmp    801f66 <memset+0x22>
		*p++ = c;
  801f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5b:	8d 50 01             	lea    0x1(%eax),%edx
  801f5e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f64:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f66:	ff 4d f8             	decl   -0x8(%ebp)
  801f69:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f6d:	79 e9                	jns    801f58 <memset+0x14>
		*p++ = c;

	return v;
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f86:	eb 16                	jmp    801f9e <memcpy+0x2a>
		*d++ = *s++;
  801f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8b:	8d 50 01             	lea    0x1(%eax),%edx
  801f8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f94:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f97:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f9a:	8a 12                	mov    (%edx),%dl
  801f9c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa1:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fa4:	89 55 10             	mov    %edx,0x10(%ebp)
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	75 dd                	jne    801f88 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fc8:	73 50                	jae    80201a <memmove+0x6a>
  801fca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd5:	76 43                	jbe    80201a <memmove+0x6a>
		s += n;
  801fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fda:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fe3:	eb 10                	jmp    801ff5 <memmove+0x45>
			*--d = *--s;
  801fe5:	ff 4d f8             	decl   -0x8(%ebp)
  801fe8:	ff 4d fc             	decl   -0x4(%ebp)
  801feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fee:	8a 10                	mov    (%eax),%dl
  801ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ffb:	89 55 10             	mov    %edx,0x10(%ebp)
  801ffe:	85 c0                	test   %eax,%eax
  802000:	75 e3                	jne    801fe5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802002:	eb 23                	jmp    802027 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802007:	8d 50 01             	lea    0x1(%eax),%edx
  80200a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80200d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802010:	8d 4a 01             	lea    0x1(%edx),%ecx
  802013:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802016:	8a 12                	mov    (%edx),%dl
  802018:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80201a:	8b 45 10             	mov    0x10(%ebp),%eax
  80201d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802020:	89 55 10             	mov    %edx,0x10(%ebp)
  802023:	85 c0                	test   %eax,%eax
  802025:	75 dd                	jne    802004 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80203e:	eb 2a                	jmp    80206a <memcmp+0x3e>
		if (*s1 != *s2)
  802040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802043:	8a 10                	mov    (%eax),%dl
  802045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802048:	8a 00                	mov    (%eax),%al
  80204a:	38 c2                	cmp    %al,%dl
  80204c:	74 16                	je     802064 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80204e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	0f b6 d0             	movzbl %al,%edx
  802056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802059:	8a 00                	mov    (%eax),%al
  80205b:	0f b6 c0             	movzbl %al,%eax
  80205e:	29 c2                	sub    %eax,%edx
  802060:	89 d0                	mov    %edx,%eax
  802062:	eb 18                	jmp    80207c <memcmp+0x50>
		s1++, s2++;
  802064:	ff 45 fc             	incl   -0x4(%ebp)
  802067:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80206a:	8b 45 10             	mov    0x10(%ebp),%eax
  80206d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802070:	89 55 10             	mov    %edx,0x10(%ebp)
  802073:	85 c0                	test   %eax,%eax
  802075:	75 c9                	jne    802040 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802084:	8b 55 08             	mov    0x8(%ebp),%edx
  802087:	8b 45 10             	mov    0x10(%ebp),%eax
  80208a:	01 d0                	add    %edx,%eax
  80208c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80208f:	eb 15                	jmp    8020a6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8a 00                	mov    (%eax),%al
  802096:	0f b6 d0             	movzbl %al,%edx
  802099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209c:	0f b6 c0             	movzbl %al,%eax
  80209f:	39 c2                	cmp    %eax,%edx
  8020a1:	74 0d                	je     8020b0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020a3:	ff 45 08             	incl   0x8(%ebp)
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020ac:	72 e3                	jb     802091 <memfind+0x13>
  8020ae:	eb 01                	jmp    8020b1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b0:	90                   	nop
	return (void *) s;
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020ca:	eb 03                	jmp    8020cf <strtol+0x19>
		s++;
  8020cc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	8a 00                	mov    (%eax),%al
  8020d4:	3c 20                	cmp    $0x20,%al
  8020d6:	74 f4                	je     8020cc <strtol+0x16>
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 09                	cmp    $0x9,%al
  8020df:	74 eb                	je     8020cc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 2b                	cmp    $0x2b,%al
  8020e8:	75 05                	jne    8020ef <strtol+0x39>
		s++;
  8020ea:	ff 45 08             	incl   0x8(%ebp)
  8020ed:	eb 13                	jmp    802102 <strtol+0x4c>
	else if (*s == '-')
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8a 00                	mov    (%eax),%al
  8020f4:	3c 2d                	cmp    $0x2d,%al
  8020f6:	75 0a                	jne    802102 <strtol+0x4c>
		s++, neg = 1;
  8020f8:	ff 45 08             	incl   0x8(%ebp)
  8020fb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802106:	74 06                	je     80210e <strtol+0x58>
  802108:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80210c:	75 20                	jne    80212e <strtol+0x78>
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	8a 00                	mov    (%eax),%al
  802113:	3c 30                	cmp    $0x30,%al
  802115:	75 17                	jne    80212e <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	40                   	inc    %eax
  80211b:	8a 00                	mov    (%eax),%al
  80211d:	3c 78                	cmp    $0x78,%al
  80211f:	75 0d                	jne    80212e <strtol+0x78>
		s += 2, base = 16;
  802121:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802125:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80212c:	eb 28                	jmp    802156 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80212e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802132:	75 15                	jne    802149 <strtol+0x93>
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8a 00                	mov    (%eax),%al
  802139:	3c 30                	cmp    $0x30,%al
  80213b:	75 0c                	jne    802149 <strtol+0x93>
		s++, base = 8;
  80213d:	ff 45 08             	incl   0x8(%ebp)
  802140:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802147:	eb 0d                	jmp    802156 <strtol+0xa0>
	else if (base == 0)
  802149:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80214d:	75 07                	jne    802156 <strtol+0xa0>
		base = 10;
  80214f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8a 00                	mov    (%eax),%al
  80215b:	3c 2f                	cmp    $0x2f,%al
  80215d:	7e 19                	jle    802178 <strtol+0xc2>
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 39                	cmp    $0x39,%al
  802166:	7f 10                	jg     802178 <strtol+0xc2>
			dig = *s - '0';
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	0f be c0             	movsbl %al,%eax
  802170:	83 e8 30             	sub    $0x30,%eax
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802176:	eb 42                	jmp    8021ba <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8a 00                	mov    (%eax),%al
  80217d:	3c 60                	cmp    $0x60,%al
  80217f:	7e 19                	jle    80219a <strtol+0xe4>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 7a                	cmp    $0x7a,%al
  802188:	7f 10                	jg     80219a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	0f be c0             	movsbl %al,%eax
  802192:	83 e8 57             	sub    $0x57,%eax
  802195:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802198:	eb 20                	jmp    8021ba <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8a 00                	mov    (%eax),%al
  80219f:	3c 40                	cmp    $0x40,%al
  8021a1:	7e 39                	jle    8021dc <strtol+0x126>
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 5a                	cmp    $0x5a,%al
  8021aa:	7f 30                	jg     8021dc <strtol+0x126>
			dig = *s - 'A' + 10;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	0f be c0             	movsbl %al,%eax
  8021b4:	83 e8 37             	sub    $0x37,%eax
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c0:	7d 19                	jge    8021db <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021c2:	ff 45 08             	incl   0x8(%ebp)
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	01 d0                	add    %edx,%eax
  8021d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021d6:	e9 7b ff ff ff       	jmp    802156 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021db:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e0:	74 08                	je     8021ea <strtol+0x134>
		*endptr = (char *) s;
  8021e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ee:	74 07                	je     8021f7 <strtol+0x141>
  8021f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f3:	f7 d8                	neg    %eax
  8021f5:	eb 03                	jmp    8021fa <strtol+0x144>
  8021f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <ltostr>:

void
ltostr(long value, char *str)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802209:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802214:	79 13                	jns    802229 <ltostr+0x2d>
	{
		neg = 1;
  802216:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80221d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802220:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802223:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802226:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802231:	99                   	cltd   
  802232:	f7 f9                	idiv   %ecx
  802234:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80223a:	8d 50 01             	lea    0x1(%eax),%edx
  80223d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802240:	89 c2                	mov    %eax,%edx
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80224a:	83 c2 30             	add    $0x30,%edx
  80224d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80224f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802252:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802257:	f7 e9                	imul   %ecx
  802259:	c1 fa 02             	sar    $0x2,%edx
  80225c:	89 c8                	mov    %ecx,%eax
  80225e:	c1 f8 1f             	sar    $0x1f,%eax
  802261:	29 c2                	sub    %eax,%edx
  802263:	89 d0                	mov    %edx,%eax
  802265:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802268:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802270:	f7 e9                	imul   %ecx
  802272:	c1 fa 02             	sar    $0x2,%edx
  802275:	89 c8                	mov    %ecx,%eax
  802277:	c1 f8 1f             	sar    $0x1f,%eax
  80227a:	29 c2                	sub    %eax,%edx
  80227c:	89 d0                	mov    %edx,%eax
  80227e:	c1 e0 02             	shl    $0x2,%eax
  802281:	01 d0                	add    %edx,%eax
  802283:	01 c0                	add    %eax,%eax
  802285:	29 c1                	sub    %eax,%ecx
  802287:	89 ca                	mov    %ecx,%edx
  802289:	85 d2                	test   %edx,%edx
  80228b:	75 9c                	jne    802229 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80228d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802297:	48                   	dec    %eax
  802298:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80229b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80229f:	74 3d                	je     8022de <ltostr+0xe2>
		start = 1 ;
  8022a1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022a8:	eb 34                	jmp    8022de <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	8a 00                	mov    (%eax),%al
  8022b4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bd:	01 c2                	add    %eax,%edx
  8022bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c5:	01 c8                	add    %ecx,%eax
  8022c7:	8a 00                	mov    (%eax),%al
  8022c9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	01 c2                	add    %eax,%edx
  8022d3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022d6:	88 02                	mov    %al,(%edx)
		start++ ;
  8022d8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022db:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022e4:	7c c4                	jl     8022aa <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022f1:	90                   	nop
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022fa:	ff 75 08             	pushl  0x8(%ebp)
  8022fd:	e8 54 fa ff ff       	call   801d56 <strlen>
  802302:	83 c4 04             	add    $0x4,%esp
  802305:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802308:	ff 75 0c             	pushl  0xc(%ebp)
  80230b:	e8 46 fa ff ff       	call   801d56 <strlen>
  802310:	83 c4 04             	add    $0x4,%esp
  802313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80231d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802324:	eb 17                	jmp    80233d <strcconcat+0x49>
		final[s] = str1[s] ;
  802326:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802329:	8b 45 10             	mov    0x10(%ebp),%eax
  80232c:	01 c2                	add    %eax,%edx
  80232e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	01 c8                	add    %ecx,%eax
  802336:	8a 00                	mov    (%eax),%al
  802338:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80233a:	ff 45 fc             	incl   -0x4(%ebp)
  80233d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802340:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802343:	7c e1                	jl     802326 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802345:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80234c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802353:	eb 1f                	jmp    802374 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802358:	8d 50 01             	lea    0x1(%eax),%edx
  80235b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80235e:	89 c2                	mov    %eax,%edx
  802360:	8b 45 10             	mov    0x10(%ebp),%eax
  802363:	01 c2                	add    %eax,%edx
  802365:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236b:	01 c8                	add    %ecx,%eax
  80236d:	8a 00                	mov    (%eax),%al
  80236f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802371:	ff 45 f8             	incl   -0x8(%ebp)
  802374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802377:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80237a:	7c d9                	jl     802355 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80237c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80237f:	8b 45 10             	mov    0x10(%ebp),%eax
  802382:	01 d0                	add    %edx,%eax
  802384:	c6 00 00             	movb   $0x0,(%eax)
}
  802387:	90                   	nop
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80238d:	8b 45 14             	mov    0x14(%ebp),%eax
  802390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a5:	01 d0                	add    %edx,%eax
  8023a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023ad:	eb 0c                	jmp    8023bb <strsplit+0x31>
			*string++ = 0;
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	8d 50 01             	lea    0x1(%eax),%edx
  8023b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8023b8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	8a 00                	mov    (%eax),%al
  8023c0:	84 c0                	test   %al,%al
  8023c2:	74 18                	je     8023dc <strsplit+0x52>
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	0f be c0             	movsbl %al,%eax
  8023cc:	50                   	push   %eax
  8023cd:	ff 75 0c             	pushl  0xc(%ebp)
  8023d0:	e8 13 fb ff ff       	call   801ee8 <strchr>
  8023d5:	83 c4 08             	add    $0x8,%esp
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	75 d3                	jne    8023af <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8a 00                	mov    (%eax),%al
  8023e1:	84 c0                	test   %al,%al
  8023e3:	74 5a                	je     80243f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	83 f8 0f             	cmp    $0xf,%eax
  8023ed:	75 07                	jne    8023f6 <strsplit+0x6c>
		{
			return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	eb 66                	jmp    80245c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8023fe:	8b 55 14             	mov    0x14(%ebp),%edx
  802401:	89 0a                	mov    %ecx,(%edx)
  802403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80240a:	8b 45 10             	mov    0x10(%ebp),%eax
  80240d:	01 c2                	add    %eax,%edx
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802414:	eb 03                	jmp    802419 <strsplit+0x8f>
			string++;
  802416:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8a 00                	mov    (%eax),%al
  80241e:	84 c0                	test   %al,%al
  802420:	74 8b                	je     8023ad <strsplit+0x23>
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	0f be c0             	movsbl %al,%eax
  80242a:	50                   	push   %eax
  80242b:	ff 75 0c             	pushl  0xc(%ebp)
  80242e:	e8 b5 fa ff ff       	call   801ee8 <strchr>
  802433:	83 c4 08             	add    $0x8,%esp
  802436:	85 c0                	test   %eax,%eax
  802438:	74 dc                	je     802416 <strsplit+0x8c>
			string++;
	}
  80243a:	e9 6e ff ff ff       	jmp    8023ad <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80243f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802440:	8b 45 14             	mov    0x14(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80244c:	8b 45 10             	mov    0x10(%ebp),%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802457:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <malloc>:
int changes=0;
int sizeofarray=0;
uint32 addresses[100];
int changed[100];
void* malloc(uint32 size)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	c1 e8 0c             	shr    $0xc,%eax
  80246a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;
		if(size%PAGE_SIZE!=0)
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	25 ff 0f 00 00       	and    $0xfff,%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 03                	je     80247c <malloc+0x1e>
			num++;
  802479:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  80247c:	a1 04 40 80 00       	mov    0x804004,%eax
  802481:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  802486:	75 64                	jne    8024ec <malloc+0x8e>
		{
			sys_allocateMem(USER_HEAP_START,size);
  802488:	83 ec 08             	sub    $0x8,%esp
  80248b:	ff 75 08             	pushl  0x8(%ebp)
  80248e:	68 00 00 00 80       	push   $0x80000000
  802493:	e8 3a 04 00 00       	call   8028d2 <sys_allocateMem>
  802498:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  80249b:	a1 04 40 80 00       	mov    0x804004,%eax
  8024a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	c1 e0 0c             	shl    $0xc,%eax
  8024a9:	89 c2                	mov    %eax,%edx
  8024ab:	a1 04 40 80 00       	mov    0x804004,%eax
  8024b0:	01 d0                	add    %edx,%eax
  8024b2:	a3 04 40 80 00       	mov    %eax,0x804004
			addresses[sizeofarray]=last_addres;
  8024b7:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8024bc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8024c2:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
			changed[sizeofarray]=1;
  8024c9:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8024ce:	c7 04 85 c0 42 80 00 	movl   $0x1,0x8042c0(,%eax,4)
  8024d5:	01 00 00 00 
			sizeofarray++;
  8024d9:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8024de:	40                   	inc    %eax
  8024df:	a3 2c 40 80 00       	mov    %eax,0x80402c
			return (void*)return_addres;
  8024e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e7:	e9 26 01 00 00       	jmp    802612 <malloc+0x1b4>
		}
		else
		{
			if(changes==0)
  8024ec:	a1 28 40 80 00       	mov    0x804028,%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	75 62                	jne    802557 <malloc+0xf9>
			{
				sys_allocateMem(last_addres,size);
  8024f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8024fa:	83 ec 08             	sub    $0x8,%esp
  8024fd:	ff 75 08             	pushl  0x8(%ebp)
  802500:	50                   	push   %eax
  802501:	e8 cc 03 00 00       	call   8028d2 <sys_allocateMem>
  802506:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  802509:	a1 04 40 80 00       	mov    0x804004,%eax
  80250e:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c1 e0 0c             	shl    $0xc,%eax
  802517:	89 c2                	mov    %eax,%edx
  802519:	a1 04 40 80 00       	mov    0x804004,%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	a3 04 40 80 00       	mov    %eax,0x804004
				addresses[sizeofarray]=return_addres;
  802525:	a1 2c 40 80 00       	mov    0x80402c,%eax
  80252a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80252d:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
				changed[sizeofarray]=1;
  802534:	a1 2c 40 80 00       	mov    0x80402c,%eax
  802539:	c7 04 85 c0 42 80 00 	movl   $0x1,0x8042c0(,%eax,4)
  802540:	01 00 00 00 
				sizeofarray++;
  802544:	a1 2c 40 80 00       	mov    0x80402c,%eax
  802549:	40                   	inc    %eax
  80254a:	a3 2c 40 80 00       	mov    %eax,0x80402c
				return (void*)return_addres;
  80254f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802552:	e9 bb 00 00 00       	jmp    802612 <malloc+0x1b4>
			}
			else{
				int count=0;
  802557:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  80255e:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  802565:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  80256c:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  802573:	eb 7c                	jmp    8025f1 <malloc+0x193>
				{
					uint32 *pg=NULL;
  802575:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  80257c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  802583:	eb 1a                	jmp    80259f <malloc+0x141>
					{
						if(addresses[j]==i)
  802585:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802588:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  80258f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802592:	75 08                	jne    80259c <malloc+0x13e>
						{
							index=j;
  802594:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802597:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  80259a:	eb 0d                	jmp    8025a9 <malloc+0x14b>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  80259c:	ff 45 dc             	incl   -0x24(%ebp)
  80259f:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8025a4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8025a7:	7c dc                	jl     802585 <malloc+0x127>
							index=j;
							break;
						}
					}

					if(index==-1)
  8025a9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025ad:	75 05                	jne    8025b4 <malloc+0x156>
					{
						count++;
  8025af:	ff 45 f0             	incl   -0x10(%ebp)
  8025b2:	eb 36                	jmp    8025ea <malloc+0x18c>
					}
					else
					{
						if(changed[index]==0)
  8025b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b7:	8b 04 85 c0 42 80 00 	mov    0x8042c0(,%eax,4),%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	75 05                	jne    8025c7 <malloc+0x169>
						{
							count++;
  8025c2:	ff 45 f0             	incl   -0x10(%ebp)
  8025c5:	eb 23                	jmp    8025ea <malloc+0x18c>
						}
						else
						{
							if(count<min&&count>=num)
  8025c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025cd:	7d 14                	jge    8025e3 <malloc+0x185>
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025d5:	7c 0c                	jl     8025e3 <malloc+0x185>
							{
								min=count;
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  8025dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  8025e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  8025ea:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8025f1:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8025f8:	0f 86 77 ff ff ff    	jbe    802575 <malloc+0x117>

					}

					}

				sys_allocateMem(min_addresss,size);
  8025fe:	83 ec 08             	sub    $0x8,%esp
  802601:	ff 75 08             	pushl  0x8(%ebp)
  802604:	ff 75 e4             	pushl  -0x1c(%ebp)
  802607:	e8 c6 02 00 00       	call   8028d2 <sys_allocateMem>
  80260c:	83 c4 10             	add    $0x10,%esp

				return(void*) min_addresss;
  80260f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 f0 39 80 00       	push   $0x8039f0
  802622:	6a 7b                	push   $0x7b
  802624:	68 13 3a 80 00       	push   $0x803a13
  802629:	e8 04 ee ff ff       	call   801432 <_panic>

0080262e <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 18             	sub    $0x18,%esp
  802634:	8b 45 10             	mov    0x10(%ebp),%eax
  802637:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	68 20 3a 80 00       	push   $0x803a20
  802642:	68 88 00 00 00       	push   $0x88
  802647:	68 13 3a 80 00       	push   $0x803a13
  80264c:	e8 e1 ed ff ff       	call   801432 <_panic>

00802651 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	68 20 3a 80 00       	push   $0x803a20
  80265f:	68 8e 00 00 00       	push   $0x8e
  802664:	68 13 3a 80 00       	push   $0x803a13
  802669:	e8 c4 ed ff ff       	call   801432 <_panic>

0080266e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	68 20 3a 80 00       	push   $0x803a20
  80267c:	68 94 00 00 00       	push   $0x94
  802681:	68 13 3a 80 00       	push   $0x803a13
  802686:	e8 a7 ed ff ff       	call   801432 <_panic>

0080268b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	68 20 3a 80 00       	push   $0x803a20
  802699:	68 99 00 00 00       	push   $0x99
  80269e:	68 13 3a 80 00       	push   $0x803a13
  8026a3:	e8 8a ed ff ff       	call   801432 <_panic>

008026a8 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	68 20 3a 80 00       	push   $0x803a20
  8026b6:	68 9f 00 00 00       	push   $0x9f
  8026bb:	68 13 3a 80 00       	push   $0x803a13
  8026c0:	e8 6d ed ff ff       	call   801432 <_panic>

008026c5 <shrink>:
}
void shrink(uint32 newSize)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
  8026c8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8026cb:	83 ec 04             	sub    $0x4,%esp
  8026ce:	68 20 3a 80 00       	push   $0x803a20
  8026d3:	68 a3 00 00 00       	push   $0xa3
  8026d8:	68 13 3a 80 00       	push   $0x803a13
  8026dd:	e8 50 ed ff ff       	call   801432 <_panic>

008026e2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 20 3a 80 00       	push   $0x803a20
  8026f0:	68 a8 00 00 00       	push   $0xa8
  8026f5:	68 13 3a 80 00       	push   $0x803a13
  8026fa:	e8 33 ed ff ff       	call   801432 <_panic>

008026ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
  802702:	57                   	push   %edi
  802703:	56                   	push   %esi
  802704:	53                   	push   %ebx
  802705:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802711:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802714:	8b 7d 18             	mov    0x18(%ebp),%edi
  802717:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80271a:	cd 30                	int    $0x30
  80271c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802722:	83 c4 10             	add    $0x10,%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	5f                   	pop    %edi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	8b 45 10             	mov    0x10(%ebp),%eax
  802733:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802736:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	52                   	push   %edx
  802742:	ff 75 0c             	pushl  0xc(%ebp)
  802745:	50                   	push   %eax
  802746:	6a 00                	push   $0x0
  802748:	e8 b2 ff ff ff       	call   8026ff <syscall>
  80274d:	83 c4 18             	add    $0x18,%esp
}
  802750:	90                   	nop
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <sys_cgetc>:

int
sys_cgetc(void)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 01                	push   $0x1
  802762:	e8 98 ff ff ff       	call   8026ff <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	50                   	push   %eax
  80277b:	6a 05                	push   $0x5
  80277d:	e8 7d ff ff ff       	call   8026ff <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 02                	push   $0x2
  802796:	e8 64 ff ff ff       	call   8026ff <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
}
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 03                	push   $0x3
  8027af:	e8 4b ff ff ff       	call   8026ff <syscall>
  8027b4:	83 c4 18             	add    $0x18,%esp
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 04                	push   $0x4
  8027c8:	e8 32 ff ff ff       	call   8026ff <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <sys_env_exit>:


void sys_env_exit(void)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 06                	push   $0x6
  8027e1:	e8 19 ff ff ff       	call   8026ff <syscall>
  8027e6:	83 c4 18             	add    $0x18,%esp
}
  8027e9:	90                   	nop
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	52                   	push   %edx
  8027fc:	50                   	push   %eax
  8027fd:	6a 07                	push   $0x7
  8027ff:	e8 fb fe ff ff       	call   8026ff <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	56                   	push   %esi
  80280d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80280e:	8b 75 18             	mov    0x18(%ebp),%esi
  802811:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802814:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	56                   	push   %esi
  80281e:	53                   	push   %ebx
  80281f:	51                   	push   %ecx
  802820:	52                   	push   %edx
  802821:	50                   	push   %eax
  802822:	6a 08                	push   $0x8
  802824:	e8 d6 fe ff ff       	call   8026ff <syscall>
  802829:	83 c4 18             	add    $0x18,%esp
}
  80282c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    

00802833 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802836:	8b 55 0c             	mov    0xc(%ebp),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	52                   	push   %edx
  802843:	50                   	push   %eax
  802844:	6a 09                	push   $0x9
  802846:	e8 b4 fe ff ff       	call   8026ff <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
}
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    

00802850 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	ff 75 0c             	pushl  0xc(%ebp)
  80285c:	ff 75 08             	pushl  0x8(%ebp)
  80285f:	6a 0a                	push   $0xa
  802861:	e8 99 fe ff ff       	call   8026ff <syscall>
  802866:	83 c4 18             	add    $0x18,%esp
}
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 0b                	push   $0xb
  80287a:	e8 80 fe ff ff       	call   8026ff <syscall>
  80287f:	83 c4 18             	add    $0x18,%esp
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 0c                	push   $0xc
  802893:	e8 67 fe ff ff       	call   8026ff <syscall>
  802898:	83 c4 18             	add    $0x18,%esp
}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 0d                	push   $0xd
  8028ac:	e8 4e fe ff ff       	call   8026ff <syscall>
  8028b1:	83 c4 18             	add    $0x18,%esp
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	ff 75 0c             	pushl  0xc(%ebp)
  8028c2:	ff 75 08             	pushl  0x8(%ebp)
  8028c5:	6a 11                	push   $0x11
  8028c7:	e8 33 fe ff ff       	call   8026ff <syscall>
  8028cc:	83 c4 18             	add    $0x18,%esp
	return;
  8028cf:	90                   	nop
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	ff 75 0c             	pushl  0xc(%ebp)
  8028de:	ff 75 08             	pushl  0x8(%ebp)
  8028e1:	6a 12                	push   $0x12
  8028e3:	e8 17 fe ff ff       	call   8026ff <syscall>
  8028e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8028eb:	90                   	nop
}
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 0e                	push   $0xe
  8028fd:	e8 fd fd ff ff       	call   8026ff <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
}
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	ff 75 08             	pushl  0x8(%ebp)
  802915:	6a 0f                	push   $0xf
  802917:	e8 e3 fd ff ff       	call   8026ff <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
}
  80291f:	c9                   	leave  
  802920:	c3                   	ret    

00802921 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802921:	55                   	push   %ebp
  802922:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 10                	push   $0x10
  802930:	e8 ca fd ff ff       	call   8026ff <syscall>
  802935:	83 c4 18             	add    $0x18,%esp
}
  802938:	90                   	nop
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 14                	push   $0x14
  80294a:	e8 b0 fd ff ff       	call   8026ff <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	90                   	nop
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 15                	push   $0x15
  802964:	e8 96 fd ff ff       	call   8026ff <syscall>
  802969:	83 c4 18             	add    $0x18,%esp
}
  80296c:	90                   	nop
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <sys_cputc>:


void
sys_cputc(const char c)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 04             	sub    $0x4,%esp
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80297b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	50                   	push   %eax
  802988:	6a 16                	push   $0x16
  80298a:	e8 70 fd ff ff       	call   8026ff <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
}
  802992:	90                   	nop
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 17                	push   $0x17
  8029a4:	e8 56 fd ff ff       	call   8026ff <syscall>
  8029a9:	83 c4 18             	add    $0x18,%esp
}
  8029ac:	90                   	nop
  8029ad:	c9                   	leave  
  8029ae:	c3                   	ret    

008029af <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	ff 75 0c             	pushl  0xc(%ebp)
  8029be:	50                   	push   %eax
  8029bf:	6a 18                	push   $0x18
  8029c1:	e8 39 fd ff ff       	call   8026ff <syscall>
  8029c6:	83 c4 18             	add    $0x18,%esp
}
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	52                   	push   %edx
  8029db:	50                   	push   %eax
  8029dc:	6a 1b                	push   $0x1b
  8029de:	e8 1c fd ff ff       	call   8026ff <syscall>
  8029e3:	83 c4 18             	add    $0x18,%esp
}
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	52                   	push   %edx
  8029f8:	50                   	push   %eax
  8029f9:	6a 19                	push   $0x19
  8029fb:	e8 ff fc ff ff       	call   8026ff <syscall>
  802a00:	83 c4 18             	add    $0x18,%esp
}
  802a03:	90                   	nop
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	52                   	push   %edx
  802a16:	50                   	push   %eax
  802a17:	6a 1a                	push   $0x1a
  802a19:	e8 e1 fc ff ff       	call   8026ff <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	90                   	nop
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a33:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	6a 00                	push   $0x0
  802a3c:	51                   	push   %ecx
  802a3d:	52                   	push   %edx
  802a3e:	ff 75 0c             	pushl  0xc(%ebp)
  802a41:	50                   	push   %eax
  802a42:	6a 1c                	push   $0x1c
  802a44:	e8 b6 fc ff ff       	call   8026ff <syscall>
  802a49:	83 c4 18             	add    $0x18,%esp
}
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	52                   	push   %edx
  802a5e:	50                   	push   %eax
  802a5f:	6a 1d                	push   $0x1d
  802a61:	e8 99 fc ff ff       	call   8026ff <syscall>
  802a66:	83 c4 18             	add    $0x18,%esp
}
  802a69:	c9                   	leave  
  802a6a:	c3                   	ret    

00802a6b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	51                   	push   %ecx
  802a7c:	52                   	push   %edx
  802a7d:	50                   	push   %eax
  802a7e:	6a 1e                	push   $0x1e
  802a80:	e8 7a fc ff ff       	call   8026ff <syscall>
  802a85:	83 c4 18             	add    $0x18,%esp
}
  802a88:	c9                   	leave  
  802a89:	c3                   	ret    

00802a8a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	52                   	push   %edx
  802a9a:	50                   	push   %eax
  802a9b:	6a 1f                	push   $0x1f
  802a9d:	e8 5d fc ff ff       	call   8026ff <syscall>
  802aa2:	83 c4 18             	add    $0x18,%esp
}
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    

00802aa7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802aa7:	55                   	push   %ebp
  802aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 20                	push   $0x20
  802ab6:	e8 44 fc ff ff       	call   8026ff <syscall>
  802abb:	83 c4 18             	add    $0x18,%esp
}
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	6a 00                	push   $0x0
  802ac8:	ff 75 14             	pushl  0x14(%ebp)
  802acb:	ff 75 10             	pushl  0x10(%ebp)
  802ace:	ff 75 0c             	pushl  0xc(%ebp)
  802ad1:	50                   	push   %eax
  802ad2:	6a 21                	push   $0x21
  802ad4:	e8 26 fc ff ff       	call   8026ff <syscall>
  802ad9:	83 c4 18             	add    $0x18,%esp
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 00                	push   $0x0
  802aec:	50                   	push   %eax
  802aed:	6a 22                	push   $0x22
  802aef:	e8 0b fc ff ff       	call   8026ff <syscall>
  802af4:	83 c4 18             	add    $0x18,%esp
}
  802af7:	90                   	nop
  802af8:	c9                   	leave  
  802af9:	c3                   	ret    

00802afa <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	6a 00                	push   $0x0
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	50                   	push   %eax
  802b09:	6a 23                	push   $0x23
  802b0b:	e8 ef fb ff ff       	call   8026ff <syscall>
  802b10:	83 c4 18             	add    $0x18,%esp
}
  802b13:	90                   	nop
  802b14:	c9                   	leave  
  802b15:	c3                   	ret    

00802b16 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
  802b19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b1f:	8d 50 04             	lea    0x4(%eax),%edx
  802b22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	52                   	push   %edx
  802b2c:	50                   	push   %eax
  802b2d:	6a 24                	push   $0x24
  802b2f:	e8 cb fb ff ff       	call   8026ff <syscall>
  802b34:	83 c4 18             	add    $0x18,%esp
	return result;
  802b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b40:	89 01                	mov    %eax,(%ecx)
  802b42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	c9                   	leave  
  802b49:	c2 04 00             	ret    $0x4

00802b4c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	ff 75 10             	pushl  0x10(%ebp)
  802b56:	ff 75 0c             	pushl  0xc(%ebp)
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	6a 13                	push   $0x13
  802b5e:	e8 9c fb ff ff       	call   8026ff <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
	return ;
  802b66:	90                   	nop
}
  802b67:	c9                   	leave  
  802b68:	c3                   	ret    

00802b69 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 25                	push   $0x25
  802b78:	e8 82 fb ff ff       	call   8026ff <syscall>
  802b7d:	83 c4 18             	add    $0x18,%esp
}
  802b80:	c9                   	leave  
  802b81:	c3                   	ret    

00802b82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	50                   	push   %eax
  802b9b:	6a 26                	push   $0x26
  802b9d:	e8 5d fb ff ff       	call   8026ff <syscall>
  802ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ba5:	90                   	nop
}
  802ba6:	c9                   	leave  
  802ba7:	c3                   	ret    

00802ba8 <rsttst>:
void rsttst()
{
  802ba8:	55                   	push   %ebp
  802ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bab:	6a 00                	push   $0x0
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 28                	push   $0x28
  802bb7:	e8 43 fb ff ff       	call   8026ff <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  802bbf:	90                   	nop
}
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  802bcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bce:	8b 55 18             	mov    0x18(%ebp),%edx
  802bd1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bd5:	52                   	push   %edx
  802bd6:	50                   	push   %eax
  802bd7:	ff 75 10             	pushl  0x10(%ebp)
  802bda:	ff 75 0c             	pushl  0xc(%ebp)
  802bdd:	ff 75 08             	pushl  0x8(%ebp)
  802be0:	6a 27                	push   $0x27
  802be2:	e8 18 fb ff ff       	call   8026ff <syscall>
  802be7:	83 c4 18             	add    $0x18,%esp
	return ;
  802bea:	90                   	nop
}
  802beb:	c9                   	leave  
  802bec:	c3                   	ret    

00802bed <chktst>:
void chktst(uint32 n)
{
  802bed:	55                   	push   %ebp
  802bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	ff 75 08             	pushl  0x8(%ebp)
  802bfb:	6a 29                	push   $0x29
  802bfd:	e8 fd fa ff ff       	call   8026ff <syscall>
  802c02:	83 c4 18             	add    $0x18,%esp
	return ;
  802c05:	90                   	nop
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <inctst>:

void inctst()
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 2a                	push   $0x2a
  802c17:	e8 e3 fa ff ff       	call   8026ff <syscall>
  802c1c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c1f:	90                   	nop
}
  802c20:	c9                   	leave  
  802c21:	c3                   	ret    

00802c22 <gettst>:
uint32 gettst()
{
  802c22:	55                   	push   %ebp
  802c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 2b                	push   $0x2b
  802c31:	e8 c9 fa ff ff       	call   8026ff <syscall>
  802c36:	83 c4 18             	add    $0x18,%esp
}
  802c39:	c9                   	leave  
  802c3a:	c3                   	ret    

00802c3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c3b:	55                   	push   %ebp
  802c3c:	89 e5                	mov    %esp,%ebp
  802c3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 2c                	push   $0x2c
  802c4d:	e8 ad fa ff ff       	call   8026ff <syscall>
  802c52:	83 c4 18             	add    $0x18,%esp
  802c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c5c:	75 07                	jne    802c65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c63:	eb 05                	jmp    802c6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6a:	c9                   	leave  
  802c6b:	c3                   	ret    

00802c6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c6c:	55                   	push   %ebp
  802c6d:	89 e5                	mov    %esp,%ebp
  802c6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c72:	6a 00                	push   $0x0
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 2c                	push   $0x2c
  802c7e:	e8 7c fa ff ff       	call   8026ff <syscall>
  802c83:	83 c4 18             	add    $0x18,%esp
  802c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c8d:	75 07                	jne    802c96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  802c94:	eb 05                	jmp    802c9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9b:	c9                   	leave  
  802c9c:	c3                   	ret    

00802c9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c9d:	55                   	push   %ebp
  802c9e:	89 e5                	mov    %esp,%ebp
  802ca0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 00                	push   $0x0
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 2c                	push   $0x2c
  802caf:	e8 4b fa ff ff       	call   8026ff <syscall>
  802cb4:	83 c4 18             	add    $0x18,%esp
  802cb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802cba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802cbe:	75 07                	jne    802cc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802cc0:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc5:	eb 05                	jmp    802ccc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccc:	c9                   	leave  
  802ccd:	c3                   	ret    

00802cce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802cce:	55                   	push   %ebp
  802ccf:	89 e5                	mov    %esp,%ebp
  802cd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cd4:	6a 00                	push   $0x0
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 2c                	push   $0x2c
  802ce0:	e8 1a fa ff ff       	call   8026ff <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
  802ce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ceb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802cef:	75 07                	jne    802cf8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802cf1:	b8 01 00 00 00       	mov    $0x1,%eax
  802cf6:	eb 05                	jmp    802cfd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	6a 2d                	push   $0x2d
  802d0f:	e8 eb f9 ff ff       	call   8026ff <syscall>
  802d14:	83 c4 18             	add    $0x18,%esp
	return ;
  802d17:	90                   	nop
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
  802d1d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	6a 00                	push   $0x0
  802d2c:	53                   	push   %ebx
  802d2d:	51                   	push   %ecx
  802d2e:	52                   	push   %edx
  802d2f:	50                   	push   %eax
  802d30:	6a 2e                	push   $0x2e
  802d32:	e8 c8 f9 ff ff       	call   8026ff <syscall>
  802d37:	83 c4 18             	add    $0x18,%esp
}
  802d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d3d:	c9                   	leave  
  802d3e:	c3                   	ret    

00802d3f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	6a 00                	push   $0x0
  802d4e:	52                   	push   %edx
  802d4f:	50                   	push   %eax
  802d50:	6a 2f                	push   $0x2f
  802d52:	e8 a8 f9 ff ff       	call   8026ff <syscall>
  802d57:	83 c4 18             	add    $0x18,%esp
}
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <__udivdi3>:
  802d5c:	55                   	push   %ebp
  802d5d:	57                   	push   %edi
  802d5e:	56                   	push   %esi
  802d5f:	53                   	push   %ebx
  802d60:	83 ec 1c             	sub    $0x1c,%esp
  802d63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d73:	89 ca                	mov    %ecx,%edx
  802d75:	89 f8                	mov    %edi,%eax
  802d77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d7b:	85 f6                	test   %esi,%esi
  802d7d:	75 2d                	jne    802dac <__udivdi3+0x50>
  802d7f:	39 cf                	cmp    %ecx,%edi
  802d81:	77 65                	ja     802de8 <__udivdi3+0x8c>
  802d83:	89 fd                	mov    %edi,%ebp
  802d85:	85 ff                	test   %edi,%edi
  802d87:	75 0b                	jne    802d94 <__udivdi3+0x38>
  802d89:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8e:	31 d2                	xor    %edx,%edx
  802d90:	f7 f7                	div    %edi
  802d92:	89 c5                	mov    %eax,%ebp
  802d94:	31 d2                	xor    %edx,%edx
  802d96:	89 c8                	mov    %ecx,%eax
  802d98:	f7 f5                	div    %ebp
  802d9a:	89 c1                	mov    %eax,%ecx
  802d9c:	89 d8                	mov    %ebx,%eax
  802d9e:	f7 f5                	div    %ebp
  802da0:	89 cf                	mov    %ecx,%edi
  802da2:	89 fa                	mov    %edi,%edx
  802da4:	83 c4 1c             	add    $0x1c,%esp
  802da7:	5b                   	pop    %ebx
  802da8:	5e                   	pop    %esi
  802da9:	5f                   	pop    %edi
  802daa:	5d                   	pop    %ebp
  802dab:	c3                   	ret    
  802dac:	39 ce                	cmp    %ecx,%esi
  802dae:	77 28                	ja     802dd8 <__udivdi3+0x7c>
  802db0:	0f bd fe             	bsr    %esi,%edi
  802db3:	83 f7 1f             	xor    $0x1f,%edi
  802db6:	75 40                	jne    802df8 <__udivdi3+0x9c>
  802db8:	39 ce                	cmp    %ecx,%esi
  802dba:	72 0a                	jb     802dc6 <__udivdi3+0x6a>
  802dbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dc0:	0f 87 9e 00 00 00    	ja     802e64 <__udivdi3+0x108>
  802dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dcb:	89 fa                	mov    %edi,%edx
  802dcd:	83 c4 1c             	add    $0x1c,%esp
  802dd0:	5b                   	pop    %ebx
  802dd1:	5e                   	pop    %esi
  802dd2:	5f                   	pop    %edi
  802dd3:	5d                   	pop    %ebp
  802dd4:	c3                   	ret    
  802dd5:	8d 76 00             	lea    0x0(%esi),%esi
  802dd8:	31 ff                	xor    %edi,%edi
  802dda:	31 c0                	xor    %eax,%eax
  802ddc:	89 fa                	mov    %edi,%edx
  802dde:	83 c4 1c             	add    $0x1c,%esp
  802de1:	5b                   	pop    %ebx
  802de2:	5e                   	pop    %esi
  802de3:	5f                   	pop    %edi
  802de4:	5d                   	pop    %ebp
  802de5:	c3                   	ret    
  802de6:	66 90                	xchg   %ax,%ax
  802de8:	89 d8                	mov    %ebx,%eax
  802dea:	f7 f7                	div    %edi
  802dec:	31 ff                	xor    %edi,%edi
  802dee:	89 fa                	mov    %edi,%edx
  802df0:	83 c4 1c             	add    $0x1c,%esp
  802df3:	5b                   	pop    %ebx
  802df4:	5e                   	pop    %esi
  802df5:	5f                   	pop    %edi
  802df6:	5d                   	pop    %ebp
  802df7:	c3                   	ret    
  802df8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802dfd:	89 eb                	mov    %ebp,%ebx
  802dff:	29 fb                	sub    %edi,%ebx
  802e01:	89 f9                	mov    %edi,%ecx
  802e03:	d3 e6                	shl    %cl,%esi
  802e05:	89 c5                	mov    %eax,%ebp
  802e07:	88 d9                	mov    %bl,%cl
  802e09:	d3 ed                	shr    %cl,%ebp
  802e0b:	89 e9                	mov    %ebp,%ecx
  802e0d:	09 f1                	or     %esi,%ecx
  802e0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e13:	89 f9                	mov    %edi,%ecx
  802e15:	d3 e0                	shl    %cl,%eax
  802e17:	89 c5                	mov    %eax,%ebp
  802e19:	89 d6                	mov    %edx,%esi
  802e1b:	88 d9                	mov    %bl,%cl
  802e1d:	d3 ee                	shr    %cl,%esi
  802e1f:	89 f9                	mov    %edi,%ecx
  802e21:	d3 e2                	shl    %cl,%edx
  802e23:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e27:	88 d9                	mov    %bl,%cl
  802e29:	d3 e8                	shr    %cl,%eax
  802e2b:	09 c2                	or     %eax,%edx
  802e2d:	89 d0                	mov    %edx,%eax
  802e2f:	89 f2                	mov    %esi,%edx
  802e31:	f7 74 24 0c          	divl   0xc(%esp)
  802e35:	89 d6                	mov    %edx,%esi
  802e37:	89 c3                	mov    %eax,%ebx
  802e39:	f7 e5                	mul    %ebp
  802e3b:	39 d6                	cmp    %edx,%esi
  802e3d:	72 19                	jb     802e58 <__udivdi3+0xfc>
  802e3f:	74 0b                	je     802e4c <__udivdi3+0xf0>
  802e41:	89 d8                	mov    %ebx,%eax
  802e43:	31 ff                	xor    %edi,%edi
  802e45:	e9 58 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e4a:	66 90                	xchg   %ax,%ax
  802e4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e50:	89 f9                	mov    %edi,%ecx
  802e52:	d3 e2                	shl    %cl,%edx
  802e54:	39 c2                	cmp    %eax,%edx
  802e56:	73 e9                	jae    802e41 <__udivdi3+0xe5>
  802e58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e5b:	31 ff                	xor    %edi,%edi
  802e5d:	e9 40 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e62:	66 90                	xchg   %ax,%ax
  802e64:	31 c0                	xor    %eax,%eax
  802e66:	e9 37 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e6b:	90                   	nop

00802e6c <__umoddi3>:
  802e6c:	55                   	push   %ebp
  802e6d:	57                   	push   %edi
  802e6e:	56                   	push   %esi
  802e6f:	53                   	push   %ebx
  802e70:	83 ec 1c             	sub    $0x1c,%esp
  802e73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e77:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e8b:	89 f3                	mov    %esi,%ebx
  802e8d:	89 fa                	mov    %edi,%edx
  802e8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e93:	89 34 24             	mov    %esi,(%esp)
  802e96:	85 c0                	test   %eax,%eax
  802e98:	75 1a                	jne    802eb4 <__umoddi3+0x48>
  802e9a:	39 f7                	cmp    %esi,%edi
  802e9c:	0f 86 a2 00 00 00    	jbe    802f44 <__umoddi3+0xd8>
  802ea2:	89 c8                	mov    %ecx,%eax
  802ea4:	89 f2                	mov    %esi,%edx
  802ea6:	f7 f7                	div    %edi
  802ea8:	89 d0                	mov    %edx,%eax
  802eaa:	31 d2                	xor    %edx,%edx
  802eac:	83 c4 1c             	add    $0x1c,%esp
  802eaf:	5b                   	pop    %ebx
  802eb0:	5e                   	pop    %esi
  802eb1:	5f                   	pop    %edi
  802eb2:	5d                   	pop    %ebp
  802eb3:	c3                   	ret    
  802eb4:	39 f0                	cmp    %esi,%eax
  802eb6:	0f 87 ac 00 00 00    	ja     802f68 <__umoddi3+0xfc>
  802ebc:	0f bd e8             	bsr    %eax,%ebp
  802ebf:	83 f5 1f             	xor    $0x1f,%ebp
  802ec2:	0f 84 ac 00 00 00    	je     802f74 <__umoddi3+0x108>
  802ec8:	bf 20 00 00 00       	mov    $0x20,%edi
  802ecd:	29 ef                	sub    %ebp,%edi
  802ecf:	89 fe                	mov    %edi,%esi
  802ed1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ed5:	89 e9                	mov    %ebp,%ecx
  802ed7:	d3 e0                	shl    %cl,%eax
  802ed9:	89 d7                	mov    %edx,%edi
  802edb:	89 f1                	mov    %esi,%ecx
  802edd:	d3 ef                	shr    %cl,%edi
  802edf:	09 c7                	or     %eax,%edi
  802ee1:	89 e9                	mov    %ebp,%ecx
  802ee3:	d3 e2                	shl    %cl,%edx
  802ee5:	89 14 24             	mov    %edx,(%esp)
  802ee8:	89 d8                	mov    %ebx,%eax
  802eea:	d3 e0                	shl    %cl,%eax
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ef2:	d3 e0                	shl    %cl,%eax
  802ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802efc:	89 f1                	mov    %esi,%ecx
  802efe:	d3 e8                	shr    %cl,%eax
  802f00:	09 d0                	or     %edx,%eax
  802f02:	d3 eb                	shr    %cl,%ebx
  802f04:	89 da                	mov    %ebx,%edx
  802f06:	f7 f7                	div    %edi
  802f08:	89 d3                	mov    %edx,%ebx
  802f0a:	f7 24 24             	mull   (%esp)
  802f0d:	89 c6                	mov    %eax,%esi
  802f0f:	89 d1                	mov    %edx,%ecx
  802f11:	39 d3                	cmp    %edx,%ebx
  802f13:	0f 82 87 00 00 00    	jb     802fa0 <__umoddi3+0x134>
  802f19:	0f 84 91 00 00 00    	je     802fb0 <__umoddi3+0x144>
  802f1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f23:	29 f2                	sub    %esi,%edx
  802f25:	19 cb                	sbb    %ecx,%ebx
  802f27:	89 d8                	mov    %ebx,%eax
  802f29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f2d:	d3 e0                	shl    %cl,%eax
  802f2f:	89 e9                	mov    %ebp,%ecx
  802f31:	d3 ea                	shr    %cl,%edx
  802f33:	09 d0                	or     %edx,%eax
  802f35:	89 e9                	mov    %ebp,%ecx
  802f37:	d3 eb                	shr    %cl,%ebx
  802f39:	89 da                	mov    %ebx,%edx
  802f3b:	83 c4 1c             	add    $0x1c,%esp
  802f3e:	5b                   	pop    %ebx
  802f3f:	5e                   	pop    %esi
  802f40:	5f                   	pop    %edi
  802f41:	5d                   	pop    %ebp
  802f42:	c3                   	ret    
  802f43:	90                   	nop
  802f44:	89 fd                	mov    %edi,%ebp
  802f46:	85 ff                	test   %edi,%edi
  802f48:	75 0b                	jne    802f55 <__umoddi3+0xe9>
  802f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4f:	31 d2                	xor    %edx,%edx
  802f51:	f7 f7                	div    %edi
  802f53:	89 c5                	mov    %eax,%ebp
  802f55:	89 f0                	mov    %esi,%eax
  802f57:	31 d2                	xor    %edx,%edx
  802f59:	f7 f5                	div    %ebp
  802f5b:	89 c8                	mov    %ecx,%eax
  802f5d:	f7 f5                	div    %ebp
  802f5f:	89 d0                	mov    %edx,%eax
  802f61:	e9 44 ff ff ff       	jmp    802eaa <__umoddi3+0x3e>
  802f66:	66 90                	xchg   %ax,%ax
  802f68:	89 c8                	mov    %ecx,%eax
  802f6a:	89 f2                	mov    %esi,%edx
  802f6c:	83 c4 1c             	add    $0x1c,%esp
  802f6f:	5b                   	pop    %ebx
  802f70:	5e                   	pop    %esi
  802f71:	5f                   	pop    %edi
  802f72:	5d                   	pop    %ebp
  802f73:	c3                   	ret    
  802f74:	3b 04 24             	cmp    (%esp),%eax
  802f77:	72 06                	jb     802f7f <__umoddi3+0x113>
  802f79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f7d:	77 0f                	ja     802f8e <__umoddi3+0x122>
  802f7f:	89 f2                	mov    %esi,%edx
  802f81:	29 f9                	sub    %edi,%ecx
  802f83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f87:	89 14 24             	mov    %edx,(%esp)
  802f8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f92:	8b 14 24             	mov    (%esp),%edx
  802f95:	83 c4 1c             	add    $0x1c,%esp
  802f98:	5b                   	pop    %ebx
  802f99:	5e                   	pop    %esi
  802f9a:	5f                   	pop    %edi
  802f9b:	5d                   	pop    %ebp
  802f9c:	c3                   	ret    
  802f9d:	8d 76 00             	lea    0x0(%esi),%esi
  802fa0:	2b 04 24             	sub    (%esp),%eax
  802fa3:	19 fa                	sbb    %edi,%edx
  802fa5:	89 d1                	mov    %edx,%ecx
  802fa7:	89 c6                	mov    %eax,%esi
  802fa9:	e9 71 ff ff ff       	jmp    802f1f <__umoddi3+0xb3>
  802fae:	66 90                	xchg   %ax,%ax
  802fb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fb4:	72 ea                	jb     802fa0 <__umoddi3+0x134>
  802fb6:	89 d9                	mov    %ebx,%ecx
  802fb8:	e9 62 ff ff ff       	jmp    802f1f <__umoddi3+0xb3>
