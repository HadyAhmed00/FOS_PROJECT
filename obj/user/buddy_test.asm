
obj/user/buddy_test:     file format elf32-i386


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
  800031:	e8 ea 05 00 00       	call   800620 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int GetPowOf2(int size);


void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec e4 00 00 00    	sub    $0xe4,%esp
	int freeFrames1 = sys_calculate_free_frames() ;
  800042:	e8 5d 1d 00 00       	call   801da4 <sys_calculate_free_frames>
  800047:	89 45 c0             	mov    %eax,-0x40(%ebp)
	int usedDiskPages1 = sys_pf_calculate_allocated_pages() ;
  80004a:	e8 d8 1d 00 00       	call   801e27 <sys_pf_calculate_allocated_pages>
  80004f:	89 45 bc             	mov    %eax,-0x44(%ebp)

	char line[100];
	readline("Enter dimension#1: ", line);
  800052:	83 ec 08             	sub    $0x8,%esp
  800055:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  80005b:	50                   	push   %eax
  80005c:	68 a0 25 80 00       	push   $0x8025a0
  800061:	e8 23 10 00 00       	call   801089 <readline>
  800066:	83 c4 10             	add    $0x10,%esp
	int N = strtol(line, NULL, 10);
  800069:	83 ec 04             	sub    $0x4,%esp
  80006c:	6a 0a                	push   $0xa
  80006e:	6a 00                	push   $0x0
  800070:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  800076:	50                   	push   %eax
  800077:	e8 73 15 00 00       	call   8015ef <strtol>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	assert(N * sizeof(int) <= BUDDY_LIMIT);
  800082:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800085:	c1 e0 02             	shl    $0x2,%eax
  800088:	3d 00 08 00 00       	cmp    $0x800,%eax
  80008d:	76 16                	jbe    8000a5 <_main+0x6d>
  80008f:	68 b4 25 80 00       	push   $0x8025b4
  800094:	68 d3 25 80 00       	push   $0x8025d3
  800099:	6a 10                	push   $0x10
  80009b:	68 e8 25 80 00       	push   $0x8025e8
  8000a0:	e8 c0 06 00 00       	call   800765 <_panic>
	readline("Enter dimension#2: ", line);
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	68 fa 25 80 00       	push   $0x8025fa
  8000b4:	e8 d0 0f 00 00       	call   801089 <readline>
  8000b9:	83 c4 10             	add    $0x10,%esp
	int M = strtol(line, NULL, 10);
  8000bc:	83 ec 04             	sub    $0x4,%esp
  8000bf:	6a 0a                	push   $0xa
  8000c1:	6a 00                	push   $0x0
  8000c3:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8000c9:	50                   	push   %eax
  8000ca:	e8 20 15 00 00       	call   8015ef <strtol>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	assert(M * sizeof(uint8) <= BUDDY_LIMIT);
  8000d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8000d8:	3d 00 08 00 00       	cmp    $0x800,%eax
  8000dd:	76 16                	jbe    8000f5 <_main+0xbd>
  8000df:	68 10 26 80 00       	push   $0x802610
  8000e4:	68 d3 25 80 00       	push   $0x8025d3
  8000e9:	6a 13                	push   $0x13
  8000eb:	68 e8 25 80 00       	push   $0x8025e8
  8000f0:	e8 70 06 00 00       	call   800765 <_panic>

	uint8 ** arr = malloc(N * sizeof(int)) ;
  8000f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000f8:	c1 e0 02             	shl    $0x2,%eax
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	50                   	push   %eax
  8000ff:	e8 93 18 00 00       	call   801997 <malloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int expectedNumOfAllocatedFrames = GetPowOf2(N * sizeof(int));
  80010a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80010d:	c1 e0 02             	shl    $0x2,%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 c5 04 00 00       	call   8005de <GetPowOf2>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	for (int i = 0; i < N; ++i)
  80011f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800126:	eb 6f                	jmp    800197 <_main+0x15f>
	{
		arr[i] = malloc(M) ;
  800128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800132:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800135:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800138:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 53 18 00 00       	call   801997 <malloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 03                	mov    %eax,(%ebx)
		expectedNumOfAllocatedFrames += GetPowOf2(M);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80014f:	e8 8a 04 00 00       	call   8005de <GetPowOf2>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	01 45 f4             	add    %eax,-0xc(%ebp)
		for (int j = 0; j < M; ++j)
  80015a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800161:	eb 29                	jmp    80018c <_main+0x154>
		{
			arr[i][j] = i % 255;
  800163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800170:	01 d0                	add    %edx,%eax
  800172:	8b 10                	mov    (%eax),%edx
  800174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800177:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80017a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017d:	bb ff 00 00 00       	mov    $0xff,%ebx
  800182:	99                   	cltd   
  800183:	f7 fb                	idiv   %ebx
  800185:	89 d0                	mov    %edx,%eax
  800187:	88 01                	mov    %al,(%ecx)

	for (int i = 0; i < N; ++i)
	{
		arr[i] = malloc(M) ;
		expectedNumOfAllocatedFrames += GetPowOf2(M);
		for (int j = 0; j < M; ++j)
  800189:	ff 45 ec             	incl   -0x14(%ebp)
  80018c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018f:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800192:	7c cf                	jl     800163 <_main+0x12b>
	assert(M * sizeof(uint8) <= BUDDY_LIMIT);

	uint8 ** arr = malloc(N * sizeof(int)) ;
	int expectedNumOfAllocatedFrames = GetPowOf2(N * sizeof(int));

	for (int i = 0; i < N; ++i)
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80019d:	7c 89                	jl     800128 <_main+0xf0>
		{
			arr[i][j] = i % 255;
		}
	}
	//cprintf("expectedNumOfAllocatedFrames = %d, %x\n", expectedNumOfAllocatedFrames, expectedNumOfAllocatedFrames);
	expectedNumOfAllocatedFrames = ROUNDUP(expectedNumOfAllocatedFrames, PAGE_SIZE) / PAGE_SIZE;
  80019f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8001a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	48                   	dec    %eax
  8001af:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8001b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	f7 75 ac             	divl   -0x54(%ebp)
  8001bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c0:	29 d0                	sub    %edx,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	79 05                	jns    8001cb <_main+0x193>
  8001c6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8001cb:	c1 f8 0c             	sar    $0xc,%eax
  8001ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int freeFrames2 = sys_calculate_free_frames() ;
  8001d1:	e8 ce 1b 00 00       	call   801da4 <sys_calculate_free_frames>
  8001d6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int usedDiskPages2 = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 49 1c 00 00       	call   801e27 <sys_pf_calculate_allocated_pages>
  8001de:	89 45 a0             	mov    %eax,-0x60(%ebp)

	//cprintf("usedDiskPages = %d, usedFrames = %d\n", usedDiskPages2 - usedDiskPages1 , freeFrames1 - freeFrames2 );
	assert(freeFrames1 - freeFrames2 == 1 + 1 + expectedNumOfAllocatedFrames);
  8001e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001e4:	2b 45 a4             	sub    -0x5c(%ebp),%eax
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	83 c2 02             	add    $0x2,%edx
  8001ed:	39 d0                	cmp    %edx,%eax
  8001ef:	74 16                	je     800207 <_main+0x1cf>
  8001f1:	68 34 26 80 00       	push   $0x802634
  8001f6:	68 d3 25 80 00       	push   $0x8025d3
  8001fb:	6a 27                	push   $0x27
  8001fd:	68 e8 25 80 00       	push   $0x8025e8
  800202:	e8 5e 05 00 00       	call   800765 <_panic>
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);
  800207:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80020a:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80020d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800210:	74 16                	je     800228 <_main+0x1f0>
  800212:	68 78 26 80 00       	push   $0x802678
  800217:	68 d3 25 80 00       	push   $0x8025d3
  80021c:	6a 28                	push   $0x28
  80021e:	68 e8 25 80 00       	push   $0x8025e8
  800223:	e8 3d 05 00 00       	call   800765 <_panic>
	for (int i = 0; i < N; ++i)
  800228:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80022f:	eb 59                	jmp    80028a <_main+0x252>
	{
		for (int j = 0; j < M; ++j)
  800231:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800238:	eb 45                	jmp    80027f <_main+0x247>
		{
			assert(arr[i][j] == i % 255);
  80023a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800244:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800247:	01 d0                	add    %edx,%eax
  800249:	8b 10                	mov    (%eax),%edx
  80024b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024e:	01 d0                	add    %edx,%eax
  800250:	8a 00                	mov    (%eax),%al
  800252:	0f b6 c8             	movzbl %al,%ecx
  800255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800258:	bb ff 00 00 00       	mov    $0xff,%ebx
  80025d:	99                   	cltd   
  80025e:	f7 fb                	idiv   %ebx
  800260:	89 d0                	mov    %edx,%eax
  800262:	39 c1                	cmp    %eax,%ecx
  800264:	74 16                	je     80027c <_main+0x244>
  800266:	68 b8 26 80 00       	push   $0x8026b8
  80026b:	68 d3 25 80 00       	push   $0x8025d3
  800270:	6a 2d                	push   $0x2d
  800272:	68 e8 25 80 00       	push   $0x8025e8
  800277:	e8 e9 04 00 00       	call   800765 <_panic>
	//cprintf("usedDiskPages = %d, usedFrames = %d\n", usedDiskPages2 - usedDiskPages1 , freeFrames1 - freeFrames2 );
	assert(freeFrames1 - freeFrames2 == 1 + 1 + expectedNumOfAllocatedFrames);
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
  80027c:	ff 45 e4             	incl   -0x1c(%ebp)
  80027f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800282:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800285:	7c b3                	jl     80023a <_main+0x202>
	int usedDiskPages2 = sys_pf_calculate_allocated_pages() ;

	//cprintf("usedDiskPages = %d, usedFrames = %d\n", usedDiskPages2 - usedDiskPages1 , freeFrames1 - freeFrames2 );
	assert(freeFrames1 - freeFrames2 == 1 + 1 + expectedNumOfAllocatedFrames);
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);
	for (int i = 0; i < N; ++i)
  800287:	ff 45 e8             	incl   -0x18(%ebp)
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800290:	7c 9f                	jl     800231 <_main+0x1f9>
		{
			assert(arr[i][j] == i % 255);
		}
	}

	for (int i = 0; i < N; ++i)
  800292:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800299:	eb 20                	jmp    8002bb <_main+0x283>
	{
		free(arr[i]);
  80029b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80029e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002a8:	01 d0                	add    %edx,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	50                   	push   %eax
  8002b0:	e8 98 18 00 00       	call   801b4d <free>
  8002b5:	83 c4 10             	add    $0x10,%esp
		{
			assert(arr[i][j] == i % 255);
		}
	}

	for (int i = 0; i < N; ++i)
  8002b8:	ff 45 e0             	incl   -0x20(%ebp)
  8002bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002be:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8002c1:	7c d8                	jl     80029b <_main+0x263>
	{
		free(arr[i]);
	}
	free(arr);
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8002c9:	e8 7f 18 00 00       	call   801b4d <free>
  8002ce:	83 c4 10             	add    $0x10,%esp

	//Free Level 1: Check number of nodes in each level in BuddyLevels
	int i;
	for(i = BUDDY_LOWER_LEVEL; i < BUDDY_UPPER_LEVEL; i++)
  8002d1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  8002d8:	e9 ce 00 00 00       	jmp    8003ab <_main+0x373>
	{
		if(LIST_SIZE(&BuddyLevels[i]) != 0)
  8002dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e0:	c1 e0 04             	shl    $0x4,%eax
  8002e3:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002e8:	8b 00                	mov    (%eax),%eax
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	0f 84 b6 00 00 00    	je     8003a8 <_main+0x370>
		{
			cprintf("Level # = %d - # of nodes = %d\n", i, LIST_SIZE(&BuddyLevels[i]));
  8002f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002f5:	c1 e0 04             	shl    $0x4,%eax
  8002f8:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002fd:	8b 00                	mov    (%eax),%eax
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	50                   	push   %eax
  800303:	ff 75 dc             	pushl  -0x24(%ebp)
  800306:	68 d0 26 80 00       	push   $0x8026d0
  80030b:	e8 f7 06 00 00       	call   800a07 <cprintf>
  800310:	83 c4 10             	add    $0x10,%esp
			struct BuddyNode* node = NULL;
  800313:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			LIST_FOREACH(node, &BuddyLevels[i])
  80031a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031d:	c1 e0 04             	shl    $0x4,%eax
  800320:	05 40 30 80 00       	add    $0x803040,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032a:	eb 31                	jmp    80035d <_main+0x325>
			{
				cprintf("Node data: va = %x, status = %d\n", node->va, node->status);
  80032c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032f:	8a 40 10             	mov    0x10(%eax),%al
  800332:	0f b6 d0             	movzbl %al,%edx
  800335:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800338:	8b 40 08             	mov    0x8(%eax),%eax
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	52                   	push   %edx
  80033f:	50                   	push   %eax
  800340:	68 f0 26 80 00       	push   $0x8026f0
  800345:	e8 bd 06 00 00       	call   800a07 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	{
		if(LIST_SIZE(&BuddyLevels[i]) != 0)
		{
			cprintf("Level # = %d - # of nodes = %d\n", i, LIST_SIZE(&BuddyLevels[i]));
			struct BuddyNode* node = NULL;
			LIST_FOREACH(node, &BuddyLevels[i])
  80034d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800350:	c1 e0 04             	shl    $0x4,%eax
  800353:	05 48 30 80 00       	add    $0x803048,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800361:	74 07                	je     80036a <_main+0x332>
  800363:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	eb 05                	jmp    80036f <_main+0x337>
  80036a:	b8 00 00 00 00       	mov    $0x0,%eax
  80036f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800372:	c1 e2 04             	shl    $0x4,%edx
  800375:	81 c2 48 30 80 00    	add    $0x803048,%edx
  80037b:	89 02                	mov    %eax,(%edx)
  80037d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800380:	c1 e0 04             	shl    $0x4,%eax
  800383:	05 48 30 80 00       	add    $0x803048,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	75 9e                	jne    80032c <_main+0x2f4>
  80038e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800392:	75 98                	jne    80032c <_main+0x2f4>
			{
				cprintf("Node data: va = %x, status = %d\n", node->va, node->status);
			}
			panic("The BuddyLevels at level <<%d>> is not freed ... !!", i);
  800394:	ff 75 dc             	pushl  -0x24(%ebp)
  800397:	68 14 27 80 00       	push   $0x802714
  80039c:	6a 43                	push   $0x43
  80039e:	68 e8 25 80 00       	push   $0x8025e8
  8003a3:	e8 bd 03 00 00       	call   800765 <_panic>
	}
	free(arr);

	//Free Level 1: Check number of nodes in each level in BuddyLevels
	int i;
	for(i = BUDDY_LOWER_LEVEL; i < BUDDY_UPPER_LEVEL; i++)
  8003a8:	ff 45 dc             	incl   -0x24(%ebp)
  8003ab:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
  8003af:	0f 8e 28 ff ff ff    	jle    8002dd <_main+0x2a5>
				cprintf("Node data: va = %x, status = %d\n", node->va, node->status);
			}
			panic("The BuddyLevels at level <<%d>> is not freed ... !!", i);
		}
	}
	uint32 buddy_max_space = ROUNDUP(BUDDY_NODE_SIZE(BUDDY_UPPER_LEVEL),PAGE_SIZE);
  8003b5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  8003bc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003bf:	05 ff 07 00 00       	add    $0x7ff,%eax
  8003c4:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003c7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cf:	f7 75 9c             	divl   -0x64(%ebp)
  8003d2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d5:	29 d0                	sub    %edx,%eax
  8003d7:	89 45 94             	mov    %eax,-0x6c(%ebp)
	int num_blocks_in_upper_level = buddy_max_space/BUDDY_NODE_SIZE(BUDDY_UPPER_LEVEL);
  8003da:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003dd:	c1 e8 0b             	shr    $0xb,%eax
  8003e0:	89 45 90             	mov    %eax,-0x70(%ebp)
	//assert(LIST_SIZE(&BuddyLevels[BUDDY_UPPER_LEVEL]) == expectedNumOfAllocatedFrames*(num_blocks_in_upper_level)); // Since in our case, each page (4kb) is divided into 2 buddies (nodes)

	//Free Level 2: Check content by creating a new dynamic allocation (Should overwrite the old content since the old content buddies are freed now so they shall be used again)
	uint8 ** arr2 = malloc(N * sizeof(int)) ;
  8003e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003e6:	c1 e0 02             	shl    $0x2,%eax
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	50                   	push   %eax
  8003ed:	e8 a5 15 00 00       	call   801997 <malloc>
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	89 45 8c             	mov    %eax,-0x74(%ebp)
	for (int i = 0; i < N; ++i)
  8003f8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8003ff:	eb 5f                	jmp    800460 <_main+0x428>
	{
		arr2[i] = malloc(M) ;
  800401:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80040e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800411:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800414:	83 ec 0c             	sub    $0xc,%esp
  800417:	50                   	push   %eax
  800418:	e8 7a 15 00 00       	call   801997 <malloc>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	89 03                	mov    %eax,(%ebx)
		for (int j = 0; j < M; ++j)
  800422:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800429:	eb 2a                	jmp    800455 <_main+0x41d>
		{
			arr2[i][j] = (i + 1)%255;
  80042b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8b 10                	mov    (%eax),%edx
  80043c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800442:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800445:	40                   	inc    %eax
  800446:	bb ff 00 00 00       	mov    $0xff,%ebx
  80044b:	99                   	cltd   
  80044c:	f7 fb                	idiv   %ebx
  80044e:	89 d0                	mov    %edx,%eax
  800450:	88 01                	mov    %al,(%ecx)
	//Free Level 2: Check content by creating a new dynamic allocation (Should overwrite the old content since the old content buddies are freed now so they shall be used again)
	uint8 ** arr2 = malloc(N * sizeof(int)) ;
	for (int i = 0; i < N; ++i)
	{
		arr2[i] = malloc(M) ;
		for (int j = 0; j < M; ++j)
  800452:	ff 45 d0             	incl   -0x30(%ebp)
  800455:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800458:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  80045b:	7c ce                	jl     80042b <_main+0x3f3>
	int num_blocks_in_upper_level = buddy_max_space/BUDDY_NODE_SIZE(BUDDY_UPPER_LEVEL);
	//assert(LIST_SIZE(&BuddyLevels[BUDDY_UPPER_LEVEL]) == expectedNumOfAllocatedFrames*(num_blocks_in_upper_level)); // Since in our case, each page (4kb) is divided into 2 buddies (nodes)

	//Free Level 2: Check content by creating a new dynamic allocation (Should overwrite the old content since the old content buddies are freed now so they shall be used again)
	uint8 ** arr2 = malloc(N * sizeof(int)) ;
	for (int i = 0; i < N; ++i)
  80045d:	ff 45 d4             	incl   -0x2c(%ebp)
  800460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800463:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800466:	7c 99                	jl     800401 <_main+0x3c9>
		for (int j = 0; j < M; ++j)
		{
			arr2[i][j] = (i + 1)%255;
		}
	}
	int freeFrames3 = sys_calculate_free_frames() ;
  800468:	e8 37 19 00 00       	call   801da4 <sys_calculate_free_frames>
  80046d:	89 45 88             	mov    %eax,-0x78(%ebp)
	int usedDiskPages3 = sys_pf_calculate_allocated_pages() ;
  800470:	e8 b2 19 00 00       	call   801e27 <sys_pf_calculate_allocated_pages>
  800475:	89 45 84             	mov    %eax,-0x7c(%ebp)

	//Check that no extra frames are taken
	//cprintf("usedDiskPages = %d, usedFrames = %d\n", usedDiskPages3 - usedDiskPages2 , freeFrames1 - freeFrames2 );
	assert(freeFrames3 - freeFrames2 == 0);
  800478:	8b 45 88             	mov    -0x78(%ebp),%eax
  80047b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80047e:	74 16                	je     800496 <_main+0x45e>
  800480:	68 48 27 80 00       	push   $0x802748
  800485:	68 d3 25 80 00       	push   $0x8025d3
  80048a:	6a 59                	push   $0x59
  80048c:	68 e8 25 80 00       	push   $0x8025e8
  800491:	e8 cf 02 00 00       	call   800765 <_panic>
	assert(usedDiskPages3 - usedDiskPages2 == 0);
  800496:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800499:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  80049c:	74 16                	je     8004b4 <_main+0x47c>
  80049e:	68 68 27 80 00       	push   $0x802768
  8004a3:	68 d3 25 80 00       	push   $0x8025d3
  8004a8:	6a 5a                	push   $0x5a
  8004aa:	68 e8 25 80 00       	push   $0x8025e8
  8004af:	e8 b1 02 00 00       	call   800765 <_panic>

	//Check the array content
	for (int i = 0; i < N; ++i)
  8004b4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004bb:	eb 5a                	jmp    800517 <_main+0x4df>
	{
		for (int j = 0; j < M; ++j)
  8004bd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004c4:	eb 46                	jmp    80050c <_main+0x4d4>
		{
			assert(arr2[i][j] == (i + 1)%255);
  8004c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	8b 10                	mov    (%eax),%edx
  8004d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004da:	01 d0                	add    %edx,%eax
  8004dc:	8a 00                	mov    (%eax),%al
  8004de:	0f b6 c8             	movzbl %al,%ecx
  8004e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e4:	40                   	inc    %eax
  8004e5:	bb ff 00 00 00       	mov    $0xff,%ebx
  8004ea:	99                   	cltd   
  8004eb:	f7 fb                	idiv   %ebx
  8004ed:	89 d0                	mov    %edx,%eax
  8004ef:	39 c1                	cmp    %eax,%ecx
  8004f1:	74 16                	je     800509 <_main+0x4d1>
  8004f3:	68 8d 27 80 00       	push   $0x80278d
  8004f8:	68 d3 25 80 00       	push   $0x8025d3
  8004fd:	6a 61                	push   $0x61
  8004ff:	68 e8 25 80 00       	push   $0x8025e8
  800504:	e8 5c 02 00 00       	call   800765 <_panic>
	assert(usedDiskPages3 - usedDiskPages2 == 0);

	//Check the array content
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
  800509:	ff 45 c8             	incl   -0x38(%ebp)
  80050c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80050f:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800512:	7c b2                	jl     8004c6 <_main+0x48e>
	//cprintf("usedDiskPages = %d, usedFrames = %d\n", usedDiskPages3 - usedDiskPages2 , freeFrames1 - freeFrames2 );
	assert(freeFrames3 - freeFrames2 == 0);
	assert(usedDiskPages3 - usedDiskPages2 == 0);

	//Check the array content
	for (int i = 0; i < N; ++i)
  800514:	ff 45 cc             	incl   -0x34(%ebp)
  800517:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80051d:	7c 9e                	jl     8004bd <_main+0x485>
			assert(arr2[i][j] == (i + 1)%255);
		}
	}

	//Free Level 3: Check number of free frames after calling free (The frames allocated by the buddies shall be freed)
	for (int i = 0; i < N; ++i)
  80051f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800526:	eb 20                	jmp    800548 <_main+0x510>
	{
		free(arr2[i]);
  800528:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80052b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800532:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 0b 16 00 00       	call   801b4d <free>
  800542:	83 c4 10             	add    $0x10,%esp
			assert(arr2[i][j] == (i + 1)%255);
		}
	}

	//Free Level 3: Check number of free frames after calling free (The frames allocated by the buddies shall be freed)
	for (int i = 0; i < N; ++i)
  800545:	ff 45 c4             	incl   -0x3c(%ebp)
  800548:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80054e:	7c d8                	jl     800528 <_main+0x4f0>
	{
		free(arr2[i]);
	}
	free(arr2);
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	ff 75 8c             	pushl  -0x74(%ebp)
  800556:	e8 f2 15 00 00       	call   801b4d <free>
  80055b:	83 c4 10             	add    $0x10,%esp

	int freeFrames4 = sys_calculate_free_frames() ;
  80055e:	e8 41 18 00 00       	call   801da4 <sys_calculate_free_frames>
  800563:	89 45 80             	mov    %eax,-0x80(%ebp)
	int usedDiskPages4 = sys_pf_calculate_allocated_pages() ;
  800566:	e8 bc 18 00 00       	call   801e27 <sys_pf_calculate_allocated_pages>
  80056b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

	assert(freeFrames4 - freeFrames3 == 1 + expectedNumOfAllocatedFrames);
  800571:	8b 45 80             	mov    -0x80(%ebp),%eax
  800574:	2b 45 88             	sub    -0x78(%ebp),%eax
  800577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80057a:	42                   	inc    %edx
  80057b:	39 d0                	cmp    %edx,%eax
  80057d:	74 16                	je     800595 <_main+0x55d>
  80057f:	68 a8 27 80 00       	push   $0x8027a8
  800584:	68 d3 25 80 00       	push   $0x8025d3
  800589:	6a 6f                	push   $0x6f
  80058b:	68 e8 25 80 00       	push   $0x8025e8
  800590:	e8 d0 01 00 00       	call   800765 <_panic>
	assert(usedDiskPages3 - usedDiskPages4 == expectedNumOfAllocatedFrames);
  800595:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800598:	2b 85 7c ff ff ff    	sub    -0x84(%ebp),%eax
  80059e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a1:	74 16                	je     8005b9 <_main+0x581>
  8005a3:	68 e8 27 80 00       	push   $0x8027e8
  8005a8:	68 d3 25 80 00       	push   $0x8025d3
  8005ad:	6a 70                	push   $0x70
  8005af:	68 e8 25 80 00       	push   $0x8025e8
  8005b4:	e8 ac 01 00 00       	call   800765 <_panic>
	assert(LIST_SIZE(&BuddyLevels[BUDDY_UPPER_LEVEL]) == 0);
  8005b9:	a1 fc 30 80 00       	mov    0x8030fc,%eax
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	74 16                	je     8005d8 <_main+0x5a0>
  8005c2:	68 28 28 80 00       	push   $0x802828
  8005c7:	68 d3 25 80 00       	push   $0x8025d3
  8005cc:	6a 71                	push   $0x71
  8005ce:	68 e8 25 80 00       	push   $0x8025e8
  8005d3:	e8 8d 01 00 00       	call   800765 <_panic>

	return;
  8005d8:	90                   	nop
}
  8005d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005dc:	c9                   	leave  
  8005dd:	c3                   	ret    

008005de <GetPowOf2>:

int GetPowOf2(int size)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
  8005e1:	83 ec 10             	sub    $0x10,%esp
	int i;
	for(i = BUDDY_LOWER_LEVEL; i <= BUDDY_UPPER_LEVEL; i++)
  8005e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
  8005eb:	eb 26                	jmp    800613 <GetPowOf2+0x35>
	{
		if(BUDDY_NODE_SIZE(i) >= size)
  8005ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f0:	ba 01 00 00 00       	mov    $0x1,%edx
  8005f5:	88 c1                	mov    %al,%cl
  8005f7:	d3 e2                	shl    %cl,%edx
  8005f9:	89 d0                	mov    %edx,%eax
  8005fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8005fe:	7c 10                	jl     800610 <GetPowOf2+0x32>
			return 1<<i;
  800600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800603:	ba 01 00 00 00       	mov    $0x1,%edx
  800608:	88 c1                	mov    %al,%cl
  80060a:	d3 e2                	shl    %cl,%edx
  80060c:	89 d0                	mov    %edx,%eax
  80060e:	eb 0e                	jmp    80061e <GetPowOf2+0x40>
}

int GetPowOf2(int size)
{
	int i;
	for(i = BUDDY_LOWER_LEVEL; i <= BUDDY_UPPER_LEVEL; i++)
  800610:	ff 45 fc             	incl   -0x4(%ebp)
  800613:	83 7d fc 0b          	cmpl   $0xb,-0x4(%ebp)
  800617:	7e d4                	jle    8005ed <GetPowOf2+0xf>
	{
		if(BUDDY_NODE_SIZE(i) >= size)
			return 1<<i;
	}
	return 0;
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80061e:	c9                   	leave  
  80061f:	c3                   	ret    

00800620 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800626:	e8 ae 16 00 00       	call   801cd9 <sys_getenvindex>
  80062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800631:	89 d0                	mov    %edx,%eax
  800633:	c1 e0 03             	shl    $0x3,%eax
  800636:	01 d0                	add    %edx,%eax
  800638:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80063f:	01 c8                	add    %ecx,%eax
  800641:	01 c0                	add    %eax,%eax
  800643:	01 d0                	add    %edx,%eax
  800645:	01 c0                	add    %eax,%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	89 c2                	mov    %eax,%edx
  80064b:	c1 e2 05             	shl    $0x5,%edx
  80064e:	29 c2                	sub    %eax,%edx
  800650:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800657:	89 c2                	mov    %eax,%edx
  800659:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80065f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800664:	a1 20 30 80 00       	mov    0x803020,%eax
  800669:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80066f:	84 c0                	test   %al,%al
  800671:	74 0f                	je     800682 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800673:	a1 20 30 80 00       	mov    0x803020,%eax
  800678:	05 40 3c 01 00       	add    $0x13c40,%eax
  80067d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800682:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800686:	7e 0a                	jle    800692 <libmain+0x72>
		binaryname = argv[0];
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	e8 98 f9 ff ff       	call   800038 <_main>
  8006a0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006a3:	e8 cc 17 00 00       	call   801e74 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	68 70 28 80 00       	push   $0x802870
  8006b0:	e8 52 03 00 00       	call   800a07 <cprintf>
  8006b5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bd:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c8:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	68 98 28 80 00       	push   $0x802898
  8006d8:	e8 2a 03 00 00       	call   800a07 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e5:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8006f0:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	68 c0 28 80 00       	push   $0x8028c0
  800700:	e8 02 03 00 00       	call   800a07 <cprintf>
  800705:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800708:	a1 20 30 80 00       	mov    0x803020,%eax
  80070d:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	50                   	push   %eax
  800717:	68 01 29 80 00       	push   $0x802901
  80071c:	e8 e6 02 00 00       	call   800a07 <cprintf>
  800721:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800724:	83 ec 0c             	sub    $0xc,%esp
  800727:	68 70 28 80 00       	push   $0x802870
  80072c:	e8 d6 02 00 00       	call   800a07 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800734:	e8 55 17 00 00       	call   801e8e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800739:	e8 19 00 00 00       	call   800757 <exit>
}
  80073e:	90                   	nop
  80073f:	c9                   	leave  
  800740:	c3                   	ret    

00800741 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800747:	83 ec 0c             	sub    $0xc,%esp
  80074a:	6a 00                	push   $0x0
  80074c:	e8 54 15 00 00       	call   801ca5 <sys_env_destroy>
  800751:	83 c4 10             	add    $0x10,%esp
}
  800754:	90                   	nop
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <exit>:

void
exit(void)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80075d:	e8 a9 15 00 00       	call   801d0b <sys_env_exit>
}
  800762:	90                   	nop
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80076b:	8d 45 10             	lea    0x10(%ebp),%eax
  80076e:	83 c0 04             	add    $0x4,%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800774:	a1 18 31 80 00       	mov    0x803118,%eax
  800779:	85 c0                	test   %eax,%eax
  80077b:	74 16                	je     800793 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80077d:	a1 18 31 80 00       	mov    0x803118,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	50                   	push   %eax
  800786:	68 18 29 80 00       	push   $0x802918
  80078b:	e8 77 02 00 00       	call   800a07 <cprintf>
  800790:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800793:	a1 00 30 80 00       	mov    0x803000,%eax
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	ff 75 08             	pushl  0x8(%ebp)
  80079e:	50                   	push   %eax
  80079f:	68 1d 29 80 00       	push   $0x80291d
  8007a4:	e8 5e 02 00 00       	call   800a07 <cprintf>
  8007a9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	e8 e1 01 00 00       	call   80099c <vcprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	6a 00                	push   $0x0
  8007c3:	68 39 29 80 00       	push   $0x802939
  8007c8:	e8 cf 01 00 00       	call   80099c <vcprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007d0:	e8 82 ff ff ff       	call   800757 <exit>

	// should not return here
	while (1) ;
  8007d5:	eb fe                	jmp    8007d5 <_panic+0x70>

008007d7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e2:	8b 50 74             	mov    0x74(%eax),%edx
  8007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e8:	39 c2                	cmp    %eax,%edx
  8007ea:	74 14                	je     800800 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ec:	83 ec 04             	sub    $0x4,%esp
  8007ef:	68 3c 29 80 00       	push   $0x80293c
  8007f4:	6a 26                	push   $0x26
  8007f6:	68 88 29 80 00       	push   $0x802988
  8007fb:	e8 65 ff ff ff       	call   800765 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800807:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80080e:	e9 b6 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800816:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	01 d0                	add    %edx,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	85 c0                	test   %eax,%eax
  800826:	75 08                	jne    800830 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800828:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80082b:	e9 96 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800830:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800837:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80083e:	eb 5d                	jmp    80089d <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800840:	a1 20 30 80 00       	mov    0x803020,%eax
  800845:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80084b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084e:	c1 e2 04             	shl    $0x4,%edx
  800851:	01 d0                	add    %edx,%eax
  800853:	8a 40 04             	mov    0x4(%eax),%al
  800856:	84 c0                	test   %al,%al
  800858:	75 40                	jne    80089a <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	a1 20 30 80 00       	mov    0x803020,%eax
  80085f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800865:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800868:	c1 e2 04             	shl    $0x4,%edx
  80086b:	01 d0                	add    %edx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 30 80 00       	mov    0x803020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 94                	ja     800840 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xef>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 94 29 80 00       	push   $0x802994
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 88 29 80 00       	push   $0x802988
  8008c1:	e8 9f fe ff ff       	call   800765 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 3e ff ff ff    	jl     800813 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 20                	jmp    800905 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8008ea:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	c1 e2 04             	shl    $0x4,%edx
  8008f6:	01 d0                	add    %edx,%eax
  8008f8:	8a 40 04             	mov    0x4(%eax),%al
  8008fb:	3c 01                	cmp    $0x1,%al
  8008fd:	75 03                	jne    800902 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008ff:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800902:	ff 45 e0             	incl   -0x20(%ebp)
  800905:	a1 20 30 80 00       	mov    0x803020,%eax
  80090a:	8b 50 74             	mov    0x74(%eax),%edx
  80090d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800910:	39 c2                	cmp    %eax,%edx
  800912:	77 d1                	ja     8008e5 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800917:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80091a:	74 14                	je     800930 <CheckWSWithoutLastIndex+0x159>
		panic(
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 e8 29 80 00       	push   $0x8029e8
  800924:	6a 44                	push   $0x44
  800926:	68 88 29 80 00       	push   $0x802988
  80092b:	e8 35 fe ff ff       	call   800765 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800930:	90                   	nop
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	8d 48 01             	lea    0x1(%eax),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
  800944:	89 0a                	mov    %ecx,(%edx)
  800946:	8b 55 08             	mov    0x8(%ebp),%edx
  800949:	88 d1                	mov    %dl,%cl
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095c:	75 2c                	jne    80098a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80095e:	a0 24 30 80 00       	mov    0x803024,%al
  800963:	0f b6 c0             	movzbl %al,%eax
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
  800969:	8b 12                	mov    (%edx),%edx
  80096b:	89 d1                	mov    %edx,%ecx
  80096d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800970:	83 c2 08             	add    $0x8,%edx
  800973:	83 ec 04             	sub    $0x4,%esp
  800976:	50                   	push   %eax
  800977:	51                   	push   %ecx
  800978:	52                   	push   %edx
  800979:	e8 e5 12 00 00       	call   801c63 <sys_cputs>
  80097e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	8b 40 04             	mov    0x4(%eax),%eax
  800990:	8d 50 01             	lea    0x1(%eax),%edx
  800993:	8b 45 0c             	mov    0xc(%ebp),%eax
  800996:	89 50 04             	mov    %edx,0x4(%eax)
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ac:	00 00 00 
	b.cnt = 0;
  8009af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	ff 75 08             	pushl  0x8(%ebp)
  8009bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c5:	50                   	push   %eax
  8009c6:	68 33 09 80 00       	push   $0x800933
  8009cb:	e8 11 02 00 00       	call   800be1 <vprintfmt>
  8009d0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d3:	a0 24 30 80 00       	mov    0x803024,%al
  8009d8:	0f b6 c0             	movzbl %al,%eax
  8009db:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e1:	83 ec 04             	sub    $0x4,%esp
  8009e4:	50                   	push   %eax
  8009e5:	52                   	push   %edx
  8009e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ec:	83 c0 08             	add    $0x8,%eax
  8009ef:	50                   	push   %eax
  8009f0:	e8 6e 12 00 00       	call   801c63 <sys_cputs>
  8009f5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f8:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a0d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800a14:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 f4             	pushl  -0xc(%ebp)
  800a23:	50                   	push   %eax
  800a24:	e8 73 ff ff ff       	call   80099c <vcprintf>
  800a29:	83 c4 10             	add    $0x10,%esp
  800a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a3a:	e8 35 14 00 00       	call   801e74 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4e:	50                   	push   %eax
  800a4f:	e8 48 ff ff ff       	call   80099c <vcprintf>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a5a:	e8 2f 14 00 00       	call   801e8e <sys_enable_interrupt>
	return cnt;
  800a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	53                   	push   %ebx
  800a68:	83 ec 14             	sub    $0x14,%esp
  800a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a77:	8b 45 18             	mov    0x18(%ebp),%eax
  800a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a82:	77 55                	ja     800ad9 <printnum+0x75>
  800a84:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a87:	72 05                	jb     800a8e <printnum+0x2a>
  800a89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a8c:	77 4b                	ja     800ad9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a91:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a94:	8b 45 18             	mov    0x18(%ebp),%eax
  800a97:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9c:	52                   	push   %edx
  800a9d:	50                   	push   %eax
  800a9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa1:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa4:	e8 8f 18 00 00       	call   802338 <__udivdi3>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	ff 75 20             	pushl  0x20(%ebp)
  800ab2:	53                   	push   %ebx
  800ab3:	ff 75 18             	pushl  0x18(%ebp)
  800ab6:	52                   	push   %edx
  800ab7:	50                   	push   %eax
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 a1 ff ff ff       	call   800a64 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
  800ac6:	eb 1a                	jmp    800ae2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	ff 75 20             	pushl  0x20(%ebp)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad9:	ff 4d 1c             	decl   0x1c(%ebp)
  800adc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae0:	7f e6                	jg     800ac8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af0:	53                   	push   %ebx
  800af1:	51                   	push   %ecx
  800af2:	52                   	push   %edx
  800af3:	50                   	push   %eax
  800af4:	e8 4f 19 00 00       	call   802448 <__umoddi3>
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	05 54 2c 80 00       	add    $0x802c54,%eax
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	0f be c0             	movsbl %al,%eax
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	50                   	push   %eax
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
}
  800b15:	90                   	nop
  800b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b22:	7e 1c                	jle    800b40 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	8d 50 08             	lea    0x8(%eax),%edx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	89 10                	mov    %edx,(%eax)
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	83 e8 08             	sub    $0x8,%eax
  800b39:	8b 50 04             	mov    0x4(%eax),%edx
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	eb 40                	jmp    800b80 <getuint+0x65>
	else if (lflag)
  800b40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b44:	74 1e                	je     800b64 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	8d 50 04             	lea    0x4(%eax),%edx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	89 10                	mov    %edx,(%eax)
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	83 e8 04             	sub    $0x4,%eax
  800b5b:	8b 00                	mov    (%eax),%eax
  800b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b62:	eb 1c                	jmp    800b80 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	8d 50 04             	lea    0x4(%eax),%edx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 10                	mov    %edx,(%eax)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	83 e8 04             	sub    $0x4,%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b85:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b89:	7e 1c                	jle    800ba7 <getint+0x25>
		return va_arg(*ap, long long);
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	8d 50 08             	lea    0x8(%eax),%edx
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	89 10                	mov    %edx,(%eax)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	83 e8 08             	sub    $0x8,%eax
  800ba0:	8b 50 04             	mov    0x4(%eax),%edx
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	eb 38                	jmp    800bdf <getint+0x5d>
	else if (lflag)
  800ba7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bab:	74 1a                	je     800bc7 <getint+0x45>
		return va_arg(*ap, long);
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 00                	mov    (%eax),%eax
  800bb2:	8d 50 04             	lea    0x4(%eax),%edx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 10                	mov    %edx,(%eax)
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	83 e8 04             	sub    $0x4,%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	99                   	cltd   
  800bc5:	eb 18                	jmp    800bdf <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 50 04             	lea    0x4(%eax),%edx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 10                	mov    %edx,(%eax)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	83 e8 04             	sub    $0x4,%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	99                   	cltd   
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be9:	eb 17                	jmp    800c02 <vprintfmt+0x21>
			if (ch == '\0')
  800beb:	85 db                	test   %ebx,%ebx
  800bed:	0f 84 af 03 00 00    	je     800fa2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	53                   	push   %ebx
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	0f b6 d8             	movzbl %al,%ebx
  800c10:	83 fb 25             	cmp    $0x25,%ebx
  800c13:	75 d6                	jne    800beb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c15:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c19:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c20:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c2e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	0f b6 d8             	movzbl %al,%ebx
  800c43:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c46:	83 f8 55             	cmp    $0x55,%eax
  800c49:	0f 87 2b 03 00 00    	ja     800f7a <vprintfmt+0x399>
  800c4f:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800c56:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c58:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c5c:	eb d7                	jmp    800c35 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c5e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d1                	jmp    800c35 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6e:	89 d0                	mov    %edx,%eax
  800c70:	c1 e0 02             	shl    $0x2,%eax
  800c73:	01 d0                	add    %edx,%eax
  800c75:	01 c0                	add    %eax,%eax
  800c77:	01 d8                	add    %ebx,%eax
  800c79:	83 e8 30             	sub    $0x30,%eax
  800c7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c87:	83 fb 2f             	cmp    $0x2f,%ebx
  800c8a:	7e 3e                	jle    800cca <vprintfmt+0xe9>
  800c8c:	83 fb 39             	cmp    $0x39,%ebx
  800c8f:	7f 39                	jg     800cca <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c94:	eb d5                	jmp    800c6b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800caa:	eb 1f                	jmp    800ccb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb0:	79 83                	jns    800c35 <vprintfmt+0x54>
				width = 0;
  800cb2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cb9:	e9 77 ff ff ff       	jmp    800c35 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cbe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cc5:	e9 6b ff ff ff       	jmp    800c35 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cca:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ccb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ccf:	0f 89 60 ff ff ff    	jns    800c35 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cdb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce2:	e9 4e ff ff ff       	jmp    800c35 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cea:	e9 46 ff ff ff       	jmp    800c35 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cef:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 e8 04             	sub    $0x4,%eax
  800cfe:	8b 00                	mov    (%eax),%eax
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	50                   	push   %eax
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	ff d0                	call   *%eax
  800d0c:	83 c4 10             	add    $0x10,%esp
			break;
  800d0f:	e9 89 02 00 00       	jmp    800f9d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d14:	8b 45 14             	mov    0x14(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d20:	83 e8 04             	sub    $0x4,%eax
  800d23:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d25:	85 db                	test   %ebx,%ebx
  800d27:	79 02                	jns    800d2b <vprintfmt+0x14a>
				err = -err;
  800d29:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d2b:	83 fb 64             	cmp    $0x64,%ebx
  800d2e:	7f 0b                	jg     800d3b <vprintfmt+0x15a>
  800d30:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  800d37:	85 f6                	test   %esi,%esi
  800d39:	75 19                	jne    800d54 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3b:	53                   	push   %ebx
  800d3c:	68 65 2c 80 00       	push   $0x802c65
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	ff 75 08             	pushl  0x8(%ebp)
  800d47:	e8 5e 02 00 00       	call   800faa <printfmt>
  800d4c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4f:	e9 49 02 00 00       	jmp    800f9d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d54:	56                   	push   %esi
  800d55:	68 6e 2c 80 00       	push   $0x802c6e
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	ff 75 08             	pushl  0x8(%ebp)
  800d60:	e8 45 02 00 00       	call   800faa <printfmt>
  800d65:	83 c4 10             	add    $0x10,%esp
			break;
  800d68:	e9 30 02 00 00       	jmp    800f9d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d70:	83 c0 04             	add    $0x4,%eax
  800d73:	89 45 14             	mov    %eax,0x14(%ebp)
  800d76:	8b 45 14             	mov    0x14(%ebp),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 30                	mov    (%eax),%esi
  800d7e:	85 f6                	test   %esi,%esi
  800d80:	75 05                	jne    800d87 <vprintfmt+0x1a6>
				p = "(null)";
  800d82:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  800d87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8b:	7e 6d                	jle    800dfa <vprintfmt+0x219>
  800d8d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d91:	74 67                	je     800dfa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	50                   	push   %eax
  800d9a:	56                   	push   %esi
  800d9b:	e8 12 05 00 00       	call   8012b2 <strnlen>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800da6:	eb 16                	jmp    800dbe <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	50                   	push   %eax
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbb:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc2:	7f e4                	jg     800da8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc4:	eb 34                	jmp    800dfa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dc6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dca:	74 1c                	je     800de8 <vprintfmt+0x207>
  800dcc:	83 fb 1f             	cmp    $0x1f,%ebx
  800dcf:	7e 05                	jle    800dd6 <vprintfmt+0x1f5>
  800dd1:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd4:	7e 12                	jle    800de8 <vprintfmt+0x207>
					putch('?', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 3f                	push   $0x3f
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	eb 0f                	jmp    800df7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	53                   	push   %ebx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfa:	89 f0                	mov    %esi,%eax
  800dfc:	8d 70 01             	lea    0x1(%eax),%esi
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f be d8             	movsbl %al,%ebx
  800e04:	85 db                	test   %ebx,%ebx
  800e06:	74 24                	je     800e2c <vprintfmt+0x24b>
  800e08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0c:	78 b8                	js     800dc6 <vprintfmt+0x1e5>
  800e0e:	ff 4d e0             	decl   -0x20(%ebp)
  800e11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e15:	79 af                	jns    800dc6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e17:	eb 13                	jmp    800e2c <vprintfmt+0x24b>
				putch(' ', putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	6a 20                	push   $0x20
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	ff d0                	call   *%eax
  800e26:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e29:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e30:	7f e7                	jg     800e19 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e32:	e9 66 01 00 00       	jmp    800f9d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e40:	50                   	push   %eax
  800e41:	e8 3c fd ff ff       	call   800b82 <getint>
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e55:	85 d2                	test   %edx,%edx
  800e57:	79 23                	jns    800e7c <vprintfmt+0x29b>
				putch('-', putdat);
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	ff 75 0c             	pushl  0xc(%ebp)
  800e5f:	6a 2d                	push   $0x2d
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	ff d0                	call   *%eax
  800e66:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6f:	f7 d8                	neg    %eax
  800e71:	83 d2 00             	adc    $0x0,%edx
  800e74:	f7 da                	neg    %edx
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e7c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e83:	e9 bc 00 00 00       	jmp    800f44 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e91:	50                   	push   %eax
  800e92:	e8 84 fc ff ff       	call   800b1b <getuint>
  800e97:	83 c4 10             	add    $0x10,%esp
  800e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea7:	e9 98 00 00 00       	jmp    800f44 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 58                	push   $0x58
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 58                	push   $0x58
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	6a 58                	push   $0x58
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	ff d0                	call   *%eax
  800ed9:	83 c4 10             	add    $0x10,%esp
			break;
  800edc:	e9 bc 00 00 00       	jmp    800f9d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	6a 30                	push   $0x30
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	ff d0                	call   *%eax
  800eee:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	6a 78                	push   $0x78
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	ff d0                	call   *%eax
  800efe:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f01:	8b 45 14             	mov    0x14(%ebp),%eax
  800f04:	83 c0 04             	add    $0x4,%eax
  800f07:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0d:	83 e8 04             	sub    $0x4,%eax
  800f10:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f1c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f23:	eb 1f                	jmp    800f44 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2e:	50                   	push   %eax
  800f2f:	e8 e7 fb ff ff       	call   800b1b <getuint>
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f3d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f44:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f4b:	83 ec 04             	sub    $0x4,%esp
  800f4e:	52                   	push   %edx
  800f4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f52:	50                   	push   %eax
  800f53:	ff 75 f4             	pushl  -0xc(%ebp)
  800f56:	ff 75 f0             	pushl  -0x10(%ebp)
  800f59:	ff 75 0c             	pushl  0xc(%ebp)
  800f5c:	ff 75 08             	pushl  0x8(%ebp)
  800f5f:	e8 00 fb ff ff       	call   800a64 <printnum>
  800f64:	83 c4 20             	add    $0x20,%esp
			break;
  800f67:	eb 34                	jmp    800f9d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	53                   	push   %ebx
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	ff d0                	call   *%eax
  800f75:	83 c4 10             	add    $0x10,%esp
			break;
  800f78:	eb 23                	jmp    800f9d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f7a:	83 ec 08             	sub    $0x8,%esp
  800f7d:	ff 75 0c             	pushl  0xc(%ebp)
  800f80:	6a 25                	push   $0x25
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	ff d0                	call   *%eax
  800f87:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f8a:	ff 4d 10             	decl   0x10(%ebp)
  800f8d:	eb 03                	jmp    800f92 <vprintfmt+0x3b1>
  800f8f:	ff 4d 10             	decl   0x10(%ebp)
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	48                   	dec    %eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 25                	cmp    $0x25,%al
  800f9a:	75 f3                	jne    800f8f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f9c:	90                   	nop
		}
	}
  800f9d:	e9 47 fc ff ff       	jmp    800be9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb3:	83 c0 04             	add    $0x4,%eax
  800fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	50                   	push   %eax
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	ff 75 08             	pushl  0x8(%ebp)
  800fc6:	e8 16 fc ff ff       	call   800be1 <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fce:	90                   	nop
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	8b 40 08             	mov    0x8(%eax),%eax
  800fda:	8d 50 01             	lea    0x1(%eax),%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	8b 10                	mov    (%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	8b 40 04             	mov    0x4(%eax),%eax
  800fee:	39 c2                	cmp    %eax,%edx
  800ff0:	73 12                	jae    801004 <sprintputch+0x33>
		*b->buf++ = ch;
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	8d 48 01             	lea    0x1(%eax),%ecx
  800ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffd:	89 0a                	mov    %ecx,(%edx)
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	88 10                	mov    %dl,(%eax)
}
  801004:	90                   	nop
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	8d 50 ff             	lea    -0x1(%eax),%edx
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80102c:	74 06                	je     801034 <vsnprintf+0x2d>
  80102e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801032:	7f 07                	jg     80103b <vsnprintf+0x34>
		return -E_INVAL;
  801034:	b8 03 00 00 00       	mov    $0x3,%eax
  801039:	eb 20                	jmp    80105b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80103b:	ff 75 14             	pushl  0x14(%ebp)
  80103e:	ff 75 10             	pushl  0x10(%ebp)
  801041:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801044:	50                   	push   %eax
  801045:	68 d1 0f 80 00       	push   $0x800fd1
  80104a:	e8 92 fb ff ff       	call   800be1 <vprintfmt>
  80104f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801052:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801055:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801058:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801063:	8d 45 10             	lea    0x10(%ebp),%eax
  801066:	83 c0 04             	add    $0x4,%eax
  801069:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	ff 75 f4             	pushl  -0xc(%ebp)
  801072:	50                   	push   %eax
  801073:	ff 75 0c             	pushl  0xc(%ebp)
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 89 ff ff ff       	call   801007 <vsnprintf>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801084:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80108f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801093:	74 13                	je     8010a8 <readline+0x1f>
		cprintf("%s", prompt);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	ff 75 08             	pushl  0x8(%ebp)
  80109b:	68 d0 2d 80 00       	push   $0x802dd0
  8010a0:	e8 62 f9 ff ff       	call   800a07 <cprintf>
  8010a5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	6a 00                	push   $0x0
  8010b4:	e8 72 12 00 00       	call   80232b <iscons>
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010bf:	e8 19 12 00 00       	call   8022dd <getchar>
  8010c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010cb:	79 22                	jns    8010ef <readline+0x66>
			if (c != -E_EOF)
  8010cd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010d1:	0f 84 ad 00 00 00    	je     801184 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	68 d3 2d 80 00       	push   $0x802dd3
  8010e2:	e8 20 f9 ff ff       	call   800a07 <cprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
			return;
  8010ea:	e9 95 00 00 00       	jmp    801184 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010ef:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010f3:	7e 34                	jle    801129 <readline+0xa0>
  8010f5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010fc:	7f 2b                	jg     801129 <readline+0xa0>
			if (echoing)
  8010fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801102:	74 0e                	je     801112 <readline+0x89>
				cputchar(c);
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	e8 86 11 00 00       	call   802295 <cputchar>
  80110f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801115:	8d 50 01             	lea    0x1(%eax),%edx
  801118:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801125:	88 10                	mov    %dl,(%eax)
  801127:	eb 56                	jmp    80117f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801129:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80112d:	75 1f                	jne    80114e <readline+0xc5>
  80112f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801133:	7e 19                	jle    80114e <readline+0xc5>
			if (echoing)
  801135:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801139:	74 0e                	je     801149 <readline+0xc0>
				cputchar(c);
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	ff 75 ec             	pushl  -0x14(%ebp)
  801141:	e8 4f 11 00 00       	call   802295 <cputchar>
  801146:	83 c4 10             	add    $0x10,%esp

			i--;
  801149:	ff 4d f4             	decl   -0xc(%ebp)
  80114c:	eb 31                	jmp    80117f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80114e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801152:	74 0a                	je     80115e <readline+0xd5>
  801154:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801158:	0f 85 61 ff ff ff    	jne    8010bf <readline+0x36>
			if (echoing)
  80115e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801162:	74 0e                	je     801172 <readline+0xe9>
				cputchar(c);
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	ff 75 ec             	pushl  -0x14(%ebp)
  80116a:	e8 26 11 00 00       	call   802295 <cputchar>
  80116f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	01 d0                	add    %edx,%eax
  80117a:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80117d:	eb 06                	jmp    801185 <readline+0xfc>
		}
	}
  80117f:	e9 3b ff ff ff       	jmp    8010bf <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801184:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80118d:	e8 e2 0c 00 00       	call   801e74 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801192:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801196:	74 13                	je     8011ab <atomic_readline+0x24>
		cprintf("%s", prompt);
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	68 d0 2d 80 00       	push   $0x802dd0
  8011a3:	e8 5f f8 ff ff       	call   800a07 <cprintf>
  8011a8:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011b2:	83 ec 0c             	sub    $0xc,%esp
  8011b5:	6a 00                	push   $0x0
  8011b7:	e8 6f 11 00 00       	call   80232b <iscons>
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011c2:	e8 16 11 00 00       	call   8022dd <getchar>
  8011c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ce:	79 23                	jns    8011f3 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011d0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8011dc:	68 d3 2d 80 00       	push   $0x802dd3
  8011e1:	e8 21 f8 ff ff       	call   800a07 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011e9:	e8 a0 0c 00 00       	call   801e8e <sys_enable_interrupt>
			return;
  8011ee:	e9 9a 00 00 00       	jmp    80128d <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011f3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011f7:	7e 34                	jle    80122d <atomic_readline+0xa6>
  8011f9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801200:	7f 2b                	jg     80122d <atomic_readline+0xa6>
			if (echoing)
  801202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801206:	74 0e                	je     801216 <atomic_readline+0x8f>
				cputchar(c);
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	ff 75 ec             	pushl  -0x14(%ebp)
  80120e:	e8 82 10 00 00       	call   802295 <cputchar>
  801213:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801219:	8d 50 01             	lea    0x1(%eax),%edx
  80121c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80121f:	89 c2                	mov    %eax,%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801229:	88 10                	mov    %dl,(%eax)
  80122b:	eb 5b                	jmp    801288 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80122d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801231:	75 1f                	jne    801252 <atomic_readline+0xcb>
  801233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801237:	7e 19                	jle    801252 <atomic_readline+0xcb>
			if (echoing)
  801239:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123d:	74 0e                	je     80124d <atomic_readline+0xc6>
				cputchar(c);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	ff 75 ec             	pushl  -0x14(%ebp)
  801245:	e8 4b 10 00 00       	call   802295 <cputchar>
  80124a:	83 c4 10             	add    $0x10,%esp
			i--;
  80124d:	ff 4d f4             	decl   -0xc(%ebp)
  801250:	eb 36                	jmp    801288 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801252:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801256:	74 0a                	je     801262 <atomic_readline+0xdb>
  801258:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80125c:	0f 85 60 ff ff ff    	jne    8011c2 <atomic_readline+0x3b>
			if (echoing)
  801262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801266:	74 0e                	je     801276 <atomic_readline+0xef>
				cputchar(c);
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	ff 75 ec             	pushl  -0x14(%ebp)
  80126e:	e8 22 10 00 00       	call   802295 <cputchar>
  801273:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801281:	e8 08 0c 00 00       	call   801e8e <sys_enable_interrupt>
			return;
  801286:	eb 05                	jmp    80128d <atomic_readline+0x106>
		}
	}
  801288:	e9 35 ff ff ff       	jmp    8011c2 <atomic_readline+0x3b>
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801295:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129c:	eb 06                	jmp    8012a4 <strlen+0x15>
		n++;
  80129e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 f1                	jne    80129e <strlen+0xf>
		n++;
	return n;
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bf:	eb 09                	jmp    8012ca <strnlen+0x18>
		n++;
  8012c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c4:	ff 45 08             	incl   0x8(%ebp)
  8012c7:	ff 4d 0c             	decl   0xc(%ebp)
  8012ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ce:	74 09                	je     8012d9 <strnlen+0x27>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	75 e8                	jne    8012c1 <strnlen+0xf>
		n++;
	return n;
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012ea:	90                   	nop
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8d 50 01             	lea    0x1(%eax),%edx
  8012f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012fd:	8a 12                	mov    (%edx),%dl
  8012ff:	88 10                	mov    %dl,(%eax)
  801301:	8a 00                	mov    (%eax),%al
  801303:	84 c0                	test   %al,%al
  801305:	75 e4                	jne    8012eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801307:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131f:	eb 1f                	jmp    801340 <strncpy+0x34>
		*dst++ = *src;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8d 50 01             	lea    0x1(%eax),%edx
  801327:	89 55 08             	mov    %edx,0x8(%ebp)
  80132a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132d:	8a 12                	mov    (%edx),%dl
  80132f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	84 c0                	test   %al,%al
  801338:	74 03                	je     80133d <strncpy+0x31>
			src++;
  80133a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80133d:	ff 45 fc             	incl   -0x4(%ebp)
  801340:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801343:	3b 45 10             	cmp    0x10(%ebp),%eax
  801346:	72 d9                	jb     801321 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801359:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135d:	74 30                	je     80138f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80135f:	eb 16                	jmp    801377 <strlcpy+0x2a>
			*dst++ = *src++;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 08             	mov    %edx,0x8(%ebp)
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801370:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801373:	8a 12                	mov    (%edx),%dl
  801375:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801377:	ff 4d 10             	decl   0x10(%ebp)
  80137a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137e:	74 09                	je     801389 <strlcpy+0x3c>
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	75 d8                	jne    801361 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80138f:	8b 55 08             	mov    0x8(%ebp),%edx
  801392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801395:	29 c2                	sub    %eax,%edx
  801397:	89 d0                	mov    %edx,%eax
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80139e:	eb 06                	jmp    8013a6 <strcmp+0xb>
		p++, q++;
  8013a0:	ff 45 08             	incl   0x8(%ebp)
  8013a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	84 c0                	test   %al,%al
  8013ad:	74 0e                	je     8013bd <strcmp+0x22>
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 10                	mov    (%eax),%dl
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	38 c2                	cmp    %al,%dl
  8013bb:	74 e3                	je     8013a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	0f b6 d0             	movzbl %al,%edx
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	0f b6 c0             	movzbl %al,%eax
  8013cd:	29 c2                	sub    %eax,%edx
  8013cf:	89 d0                	mov    %edx,%eax
}
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013d6:	eb 09                	jmp    8013e1 <strncmp+0xe>
		n--, p++, q++;
  8013d8:	ff 4d 10             	decl   0x10(%ebp)
  8013db:	ff 45 08             	incl   0x8(%ebp)
  8013de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e5:	74 17                	je     8013fe <strncmp+0x2b>
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	84 c0                	test   %al,%al
  8013ee:	74 0e                	je     8013fe <strncmp+0x2b>
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8a 10                	mov    (%eax),%dl
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	38 c2                	cmp    %al,%dl
  8013fc:	74 da                	je     8013d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801402:	75 07                	jne    80140b <strncmp+0x38>
		return 0;
  801404:	b8 00 00 00 00       	mov    $0x0,%eax
  801409:	eb 14                	jmp    80141f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f b6 d0             	movzbl %al,%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	0f b6 c0             	movzbl %al,%eax
  80141b:	29 c2                	sub    %eax,%edx
  80141d:	89 d0                	mov    %edx,%eax
}
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80142d:	eb 12                	jmp    801441 <strchr+0x20>
		if (*s == c)
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801437:	75 05                	jne    80143e <strchr+0x1d>
			return (char *) s;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	eb 11                	jmp    80144f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143e:	ff 45 08             	incl   0x8(%ebp)
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	84 c0                	test   %al,%al
  801448:	75 e5                	jne    80142f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145d:	eb 0d                	jmp    80146c <strfind+0x1b>
		if (*s == c)
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801467:	74 0e                	je     801477 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801469:	ff 45 08             	incl   0x8(%ebp)
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	84 c0                	test   %al,%al
  801473:	75 ea                	jne    80145f <strfind+0xe>
  801475:	eb 01                	jmp    801478 <strfind+0x27>
		if (*s == c)
			break;
  801477:	90                   	nop
	return (char *) s;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80148f:	eb 0e                	jmp    80149f <memset+0x22>
		*p++ = c;
  801491:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801494:	8d 50 01             	lea    0x1(%eax),%edx
  801497:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80149a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80149f:	ff 4d f8             	decl   -0x8(%ebp)
  8014a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014a6:	79 e9                	jns    801491 <memset+0x14>
		*p++ = c;

	return v;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014bf:	eb 16                	jmp    8014d7 <memcpy+0x2a>
		*d++ = *s++;
  8014c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014d3:	8a 12                	mov    (%edx),%dl
  8014d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	75 dd                	jne    8014c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801501:	73 50                	jae    801553 <memmove+0x6a>
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150e:	76 43                	jbe    801553 <memmove+0x6a>
		s += n;
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80151c:	eb 10                	jmp    80152e <memmove+0x45>
			*--d = *--s;
  80151e:	ff 4d f8             	decl   -0x8(%ebp)
  801521:	ff 4d fc             	decl   -0x4(%ebp)
  801524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801527:	8a 10                	mov    (%eax),%dl
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	8d 50 ff             	lea    -0x1(%eax),%edx
  801534:	89 55 10             	mov    %edx,0x10(%ebp)
  801537:	85 c0                	test   %eax,%eax
  801539:	75 e3                	jne    80151e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80153b:	eb 23                	jmp    801560 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8d 50 01             	lea    0x1(%eax),%edx
  801543:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801546:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801549:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154f:	8a 12                	mov    (%edx),%dl
  801551:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801553:	8b 45 10             	mov    0x10(%ebp),%eax
  801556:	8d 50 ff             	lea    -0x1(%eax),%edx
  801559:	89 55 10             	mov    %edx,0x10(%ebp)
  80155c:	85 c0                	test   %eax,%eax
  80155e:	75 dd                	jne    80153d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801577:	eb 2a                	jmp    8015a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157c:	8a 10                	mov    (%eax),%dl
  80157e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	38 c2                	cmp    %al,%dl
  801585:	74 16                	je     80159d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	0f b6 d0             	movzbl %al,%edx
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 c0             	movzbl %al,%eax
  801597:	29 c2                	sub    %eax,%edx
  801599:	89 d0                	mov    %edx,%eax
  80159b:	eb 18                	jmp    8015b5 <memcmp+0x50>
		s1++, s2++;
  80159d:	ff 45 fc             	incl   -0x4(%ebp)
  8015a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 c9                	jne    801579 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c8:	eb 15                	jmp    8015df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f b6 d0             	movzbl %al,%edx
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	0f b6 c0             	movzbl %al,%eax
  8015d8:	39 c2                	cmp    %eax,%edx
  8015da:	74 0d                	je     8015e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015dc:	ff 45 08             	incl   0x8(%ebp)
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e5:	72 e3                	jb     8015ca <memfind+0x13>
  8015e7:	eb 01                	jmp    8015ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e9:	90                   	nop
	return (void *) s;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801603:	eb 03                	jmp    801608 <strtol+0x19>
		s++;
  801605:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	3c 20                	cmp    $0x20,%al
  80160f:	74 f4                	je     801605 <strtol+0x16>
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3c 09                	cmp    $0x9,%al
  801618:	74 eb                	je     801605 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 2b                	cmp    $0x2b,%al
  801621:	75 05                	jne    801628 <strtol+0x39>
		s++;
  801623:	ff 45 08             	incl   0x8(%ebp)
  801626:	eb 13                	jmp    80163b <strtol+0x4c>
	else if (*s == '-')
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 2d                	cmp    $0x2d,%al
  80162f:	75 0a                	jne    80163b <strtol+0x4c>
		s++, neg = 1;
  801631:	ff 45 08             	incl   0x8(%ebp)
  801634:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163f:	74 06                	je     801647 <strtol+0x58>
  801641:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801645:	75 20                	jne    801667 <strtol+0x78>
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 30                	cmp    $0x30,%al
  80164e:	75 17                	jne    801667 <strtol+0x78>
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	40                   	inc    %eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	3c 78                	cmp    $0x78,%al
  801658:	75 0d                	jne    801667 <strtol+0x78>
		s += 2, base = 16;
  80165a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801665:	eb 28                	jmp    80168f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801667:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166b:	75 15                	jne    801682 <strtol+0x93>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 30                	cmp    $0x30,%al
  801674:	75 0c                	jne    801682 <strtol+0x93>
		s++, base = 8;
  801676:	ff 45 08             	incl   0x8(%ebp)
  801679:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801680:	eb 0d                	jmp    80168f <strtol+0xa0>
	else if (base == 0)
  801682:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801686:	75 07                	jne    80168f <strtol+0xa0>
		base = 10;
  801688:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 19                	jle    8016b1 <strtol+0xc2>
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	3c 39                	cmp    $0x39,%al
  80169f:	7f 10                	jg     8016b1 <strtol+0xc2>
			dig = *s - '0';
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	0f be c0             	movsbl %al,%eax
  8016a9:	83 e8 30             	sub    $0x30,%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016af:	eb 42                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3c 60                	cmp    $0x60,%al
  8016b8:	7e 19                	jle    8016d3 <strtol+0xe4>
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	3c 7a                	cmp    $0x7a,%al
  8016c1:	7f 10                	jg     8016d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	0f be c0             	movsbl %al,%eax
  8016cb:	83 e8 57             	sub    $0x57,%eax
  8016ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d1:	eb 20                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 40                	cmp    $0x40,%al
  8016da:	7e 39                	jle    801715 <strtol+0x126>
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	3c 5a                	cmp    $0x5a,%al
  8016e3:	7f 30                	jg     801715 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	0f be c0             	movsbl %al,%eax
  8016ed:	83 e8 37             	sub    $0x37,%eax
  8016f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016f9:	7d 19                	jge    801714 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016fb:	ff 45 08             	incl   0x8(%ebp)
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	0f af 45 10          	imul   0x10(%ebp),%eax
  801705:	89 c2                	mov    %eax,%edx
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	01 d0                	add    %edx,%eax
  80170c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80170f:	e9 7b ff ff ff       	jmp    80168f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801714:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801719:	74 08                	je     801723 <strtol+0x134>
		*endptr = (char *) s;
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	8b 55 08             	mov    0x8(%ebp),%edx
  801721:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801723:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801727:	74 07                	je     801730 <strtol+0x141>
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	f7 d8                	neg    %eax
  80172e:	eb 03                	jmp    801733 <strtol+0x144>
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <ltostr>:

void
ltostr(long value, char *str)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80173b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801742:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801749:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80174d:	79 13                	jns    801762 <ltostr+0x2d>
	{
		neg = 1;
  80174f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80175c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80175f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80176a:	99                   	cltd   
  80176b:	f7 f9                	idiv   %ecx
  80176d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801770:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801773:	8d 50 01             	lea    0x1(%eax),%edx
  801776:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801779:	89 c2                	mov    %eax,%edx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801783:	83 c2 30             	add    $0x30,%edx
  801786:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801788:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801790:	f7 e9                	imul   %ecx
  801792:	c1 fa 02             	sar    $0x2,%edx
  801795:	89 c8                	mov    %ecx,%eax
  801797:	c1 f8 1f             	sar    $0x1f,%eax
  80179a:	29 c2                	sub    %eax,%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017a9:	f7 e9                	imul   %ecx
  8017ab:	c1 fa 02             	sar    $0x2,%edx
  8017ae:	89 c8                	mov    %ecx,%eax
  8017b0:	c1 f8 1f             	sar    $0x1f,%eax
  8017b3:	29 c2                	sub    %eax,%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	c1 e0 02             	shl    $0x2,%eax
  8017ba:	01 d0                	add    %edx,%eax
  8017bc:	01 c0                	add    %eax,%eax
  8017be:	29 c1                	sub    %eax,%ecx
  8017c0:	89 ca                	mov    %ecx,%edx
  8017c2:	85 d2                	test   %edx,%edx
  8017c4:	75 9c                	jne    801762 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	48                   	dec    %eax
  8017d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d8:	74 3d                	je     801817 <ltostr+0xe2>
		start = 1 ;
  8017da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017e1:	eb 34                	jmp    801817 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f6:	01 c2                	add    %eax,%edx
  8017f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	01 c8                	add    %ecx,%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801804:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	01 c2                	add    %eax,%edx
  80180c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80180f:	88 02                	mov    %al,(%edx)
		start++ ;
  801811:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801814:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80181d:	7c c4                	jl     8017e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80181f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	01 d0                	add    %edx,%eax
  801827:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80182a:	90                   	nop
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	e8 54 fa ff ff       	call   80128f <strlen>
  80183b:	83 c4 04             	add    $0x4,%esp
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	e8 46 fa ff ff       	call   80128f <strlen>
  801849:	83 c4 04             	add    $0x4,%esp
  80184c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80184f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801856:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80185d:	eb 17                	jmp    801876 <strcconcat+0x49>
		final[s] = str1[s] ;
  80185f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801862:	8b 45 10             	mov    0x10(%ebp),%eax
  801865:	01 c2                	add    %eax,%edx
  801867:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	01 c8                	add    %ecx,%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801873:	ff 45 fc             	incl   -0x4(%ebp)
  801876:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801879:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80187c:	7c e1                	jl     80185f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80187e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801885:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80188c:	eb 1f                	jmp    8018ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80188e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801897:	89 c2                	mov    %eax,%edx
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	01 c2                	add    %eax,%edx
  80189e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a4:	01 c8                	add    %ecx,%eax
  8018a6:	8a 00                	mov    (%eax),%al
  8018a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018aa:	ff 45 f8             	incl   -0x8(%ebp)
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018b3:	7c d9                	jl     80188e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018db:	8b 45 10             	mov    0x10(%ebp),%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e6:	eb 0c                	jmp    8018f4 <strsplit+0x31>
			*string++ = 0;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8d 50 01             	lea    0x1(%eax),%edx
  8018ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8018f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	84 c0                	test   %al,%al
  8018fb:	74 18                	je     801915 <strsplit+0x52>
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	0f be c0             	movsbl %al,%eax
  801905:	50                   	push   %eax
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	e8 13 fb ff ff       	call   801421 <strchr>
  80190e:	83 c4 08             	add    $0x8,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	75 d3                	jne    8018e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8a 00                	mov    (%eax),%al
  80191a:	84 c0                	test   %al,%al
  80191c:	74 5a                	je     801978 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80191e:	8b 45 14             	mov    0x14(%ebp),%eax
  801921:	8b 00                	mov    (%eax),%eax
  801923:	83 f8 0f             	cmp    $0xf,%eax
  801926:	75 07                	jne    80192f <strsplit+0x6c>
		{
			return 0;
  801928:	b8 00 00 00 00       	mov    $0x0,%eax
  80192d:	eb 66                	jmp    801995 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80192f:	8b 45 14             	mov    0x14(%ebp),%eax
  801932:	8b 00                	mov    (%eax),%eax
  801934:	8d 48 01             	lea    0x1(%eax),%ecx
  801937:	8b 55 14             	mov    0x14(%ebp),%edx
  80193a:	89 0a                	mov    %ecx,(%edx)
  80193c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	01 c2                	add    %eax,%edx
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80194d:	eb 03                	jmp    801952 <strsplit+0x8f>
			string++;
  80194f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	8a 00                	mov    (%eax),%al
  801957:	84 c0                	test   %al,%al
  801959:	74 8b                	je     8018e6 <strsplit+0x23>
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	0f be c0             	movsbl %al,%eax
  801963:	50                   	push   %eax
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	e8 b5 fa ff ff       	call   801421 <strchr>
  80196c:	83 c4 08             	add    $0x8,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	74 dc                	je     80194f <strsplit+0x8c>
			string++;
	}
  801973:	e9 6e ff ff ff       	jmp    8018e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801978:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801979:	8b 45 14             	mov    0x14(%ebp),%eax
  80197c:	8b 00                	mov    (%eax),%eax
  80197e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801985:	8b 45 10             	mov    0x10(%ebp),%eax
  801988:	01 d0                	add    %edx,%eax
  80198a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801990:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <malloc>:
int changes=0;
int sizeofarray=0;
uint32 addresses[100];
int changed[100];
void* malloc(uint32 size)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	c1 e8 0c             	shr    $0xc,%eax
  8019a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;
		if(size%PAGE_SIZE!=0)
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	74 03                	je     8019b5 <malloc+0x1e>
			num++;
  8019b2:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  8019b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ba:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8019bf:	75 64                	jne    801a25 <malloc+0x8e>
		{
			sys_allocateMem(USER_HEAP_START,size);
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	68 00 00 00 80       	push   $0x80000000
  8019cc:	e8 3a 04 00 00       	call   801e0b <sys_allocateMem>
  8019d1:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  8019d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8019d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	c1 e0 0c             	shl    $0xc,%eax
  8019e2:	89 c2                	mov    %eax,%edx
  8019e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e9:	01 d0                	add    %edx,%eax
  8019eb:	a3 04 30 80 00       	mov    %eax,0x803004
			addresses[sizeofarray]=last_addres;
  8019f0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8019f5:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8019fb:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
			changed[sizeofarray]=1;
  801a02:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a07:	c7 04 85 c0 32 80 00 	movl   $0x1,0x8032c0(,%eax,4)
  801a0e:	01 00 00 00 
			sizeofarray++;
  801a12:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a17:	40                   	inc    %eax
  801a18:	a3 2c 30 80 00       	mov    %eax,0x80302c
			return (void*)return_addres;
  801a1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a20:	e9 26 01 00 00       	jmp    801b4b <malloc+0x1b4>
		}
		else
		{
			if(changes==0)
  801a25:	a1 28 30 80 00       	mov    0x803028,%eax
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	75 62                	jne    801a90 <malloc+0xf9>
			{
				sys_allocateMem(last_addres,size);
  801a2e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 cc 03 00 00       	call   801e0b <sys_allocateMem>
  801a3f:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  801a42:	a1 04 30 80 00       	mov    0x803004,%eax
  801a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  801a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4d:	c1 e0 0c             	shl    $0xc,%eax
  801a50:	89 c2                	mov    %eax,%edx
  801a52:	a1 04 30 80 00       	mov    0x803004,%eax
  801a57:	01 d0                	add    %edx,%eax
  801a59:	a3 04 30 80 00       	mov    %eax,0x803004
				addresses[sizeofarray]=return_addres;
  801a5e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a63:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a66:	89 14 85 20 31 80 00 	mov    %edx,0x803120(,%eax,4)
				changed[sizeofarray]=1;
  801a6d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a72:	c7 04 85 c0 32 80 00 	movl   $0x1,0x8032c0(,%eax,4)
  801a79:	01 00 00 00 
				sizeofarray++;
  801a7d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a82:	40                   	inc    %eax
  801a83:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return (void*)return_addres;
  801a88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a8b:	e9 bb 00 00 00       	jmp    801b4b <malloc+0x1b4>
			}
			else{
				int count=0;
  801a90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801a97:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  801a9e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801aa5:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  801aac:	eb 7c                	jmp    801b2a <malloc+0x193>
				{
					uint32 *pg=NULL;
  801aae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  801ab5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801abc:	eb 1a                	jmp    801ad8 <malloc+0x141>
					{
						if(addresses[j]==i)
  801abe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac1:	8b 04 85 20 31 80 00 	mov    0x803120(,%eax,4),%eax
  801ac8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801acb:	75 08                	jne    801ad5 <malloc+0x13e>
						{
							index=j;
  801acd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  801ad3:	eb 0d                	jmp    801ae2 <malloc+0x14b>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  801ad5:	ff 45 dc             	incl   -0x24(%ebp)
  801ad8:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801add:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801ae0:	7c dc                	jl     801abe <malloc+0x127>
							index=j;
							break;
						}
					}

					if(index==-1)
  801ae2:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801ae6:	75 05                	jne    801aed <malloc+0x156>
					{
						count++;
  801ae8:	ff 45 f0             	incl   -0x10(%ebp)
  801aeb:	eb 36                	jmp    801b23 <malloc+0x18c>
					}
					else
					{
						if(changed[index]==0)
  801aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af0:	8b 04 85 c0 32 80 00 	mov    0x8032c0(,%eax,4),%eax
  801af7:	85 c0                	test   %eax,%eax
  801af9:	75 05                	jne    801b00 <malloc+0x169>
						{
							count++;
  801afb:	ff 45 f0             	incl   -0x10(%ebp)
  801afe:	eb 23                	jmp    801b23 <malloc+0x18c>
						}
						else
						{
							if(count<min&&count>=num)
  801b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801b06:	7d 14                	jge    801b1c <malloc+0x185>
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b0e:	7c 0c                	jl     801b1c <malloc+0x185>
							{
								min=count;
  801b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b13:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  801b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  801b1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801b23:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801b2a:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801b31:	0f 86 77 ff ff ff    	jbe    801aae <malloc+0x117>

					}

					}

				sys_allocateMem(min_addresss,size);
  801b37:	83 ec 08             	sub    $0x8,%esp
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b40:	e8 c6 02 00 00       	call   801e0b <sys_allocateMem>
  801b45:	83 c4 10             	add    $0x10,%esp

				return(void*) min_addresss;
  801b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	68 e4 2d 80 00       	push   $0x802de4
  801b5b:	6a 7b                	push   $0x7b
  801b5d:	68 07 2e 80 00       	push   $0x802e07
  801b62:	e8 fe eb ff ff       	call   800765 <_panic>

00801b67 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 18             	sub    $0x18,%esp
  801b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b70:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	68 14 2e 80 00       	push   $0x802e14
  801b7b:	68 88 00 00 00       	push   $0x88
  801b80:	68 07 2e 80 00       	push   $0x802e07
  801b85:	e8 db eb ff ff       	call   800765 <_panic>

00801b8a <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	68 14 2e 80 00       	push   $0x802e14
  801b98:	68 8e 00 00 00       	push   $0x8e
  801b9d:	68 07 2e 80 00       	push   $0x802e07
  801ba2:	e8 be eb ff ff       	call   800765 <_panic>

00801ba7 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	68 14 2e 80 00       	push   $0x802e14
  801bb5:	68 94 00 00 00       	push   $0x94
  801bba:	68 07 2e 80 00       	push   $0x802e07
  801bbf:	e8 a1 eb ff ff       	call   800765 <_panic>

00801bc4 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	68 14 2e 80 00       	push   $0x802e14
  801bd2:	68 99 00 00 00       	push   $0x99
  801bd7:	68 07 2e 80 00       	push   $0x802e07
  801bdc:	e8 84 eb ff ff       	call   800765 <_panic>

00801be1 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	68 14 2e 80 00       	push   $0x802e14
  801bef:	68 9f 00 00 00       	push   $0x9f
  801bf4:	68 07 2e 80 00       	push   $0x802e07
  801bf9:	e8 67 eb ff ff       	call   800765 <_panic>

00801bfe <shrink>:
}
void shrink(uint32 newSize)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	68 14 2e 80 00       	push   $0x802e14
  801c0c:	68 a3 00 00 00       	push   $0xa3
  801c11:	68 07 2e 80 00       	push   $0x802e07
  801c16:	e8 4a eb ff ff       	call   800765 <_panic>

00801c1b <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	68 14 2e 80 00       	push   $0x802e14
  801c29:	68 a8 00 00 00       	push   $0xa8
  801c2e:	68 07 2e 80 00       	push   $0x802e07
  801c33:	e8 2d eb ff ff       	call   800765 <_panic>

00801c38 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	57                   	push   %edi
  801c3c:	56                   	push   %esi
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c50:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c53:	cd 30                	int    $0x30
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5f                   	pop    %edi
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    

00801c63 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	52                   	push   %edx
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	50                   	push   %eax
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 b2 ff ff ff       	call   801c38 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	90                   	nop
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_cgetc>:

int
sys_cgetc(void)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 01                	push   $0x1
  801c9b:	e8 98 ff ff ff       	call   801c38 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 05                	push   $0x5
  801cb6:	e8 7d ff ff ff       	call   801c38 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 02                	push   $0x2
  801ccf:	e8 64 ff ff ff       	call   801c38 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 03                	push   $0x3
  801ce8:	e8 4b ff ff ff       	call   801c38 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 04                	push   $0x4
  801d01:	e8 32 ff ff ff       	call   801c38 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_env_exit>:


void sys_env_exit(void)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 06                	push   $0x6
  801d1a:	e8 19 ff ff ff       	call   801c38 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	6a 07                	push   $0x7
  801d38:	e8 fb fe ff ff       	call   801c38 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d47:	8b 75 18             	mov    0x18(%ebp),%esi
  801d4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	51                   	push   %ecx
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	6a 08                	push   $0x8
  801d5d:	e8 d6 fe ff ff       	call   801c38 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 09                	push   $0x9
  801d7f:	e8 b4 fe ff ff       	call   801c38 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 0a                	push   $0xa
  801d9a:	e8 99 fe ff ff       	call   801c38 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 0b                	push   $0xb
  801db3:	e8 80 fe ff ff       	call   801c38 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 0c                	push   $0xc
  801dcc:	e8 67 fe ff ff       	call   801c38 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 0d                	push   $0xd
  801de5:	e8 4e fe ff ff       	call   801c38 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	6a 11                	push   $0x11
  801e00:	e8 33 fe ff ff       	call   801c38 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	6a 12                	push   $0x12
  801e1c:	e8 17 fe ff ff       	call   801c38 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return ;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 0e                	push   $0xe
  801e36:	e8 fd fd ff ff       	call   801c38 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 0f                	push   $0xf
  801e50:	e8 e3 fd ff ff       	call   801c38 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 10                	push   $0x10
  801e69:	e8 ca fd ff ff       	call   801c38 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 14                	push   $0x14
  801e83:	e8 b0 fd ff ff       	call   801c38 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	90                   	nop
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 15                	push   $0x15
  801e9d:	e8 96 fd ff ff       	call   801c38 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	90                   	nop
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eb4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	50                   	push   %eax
  801ec1:	6a 16                	push   $0x16
  801ec3:	e8 70 fd ff ff       	call   801c38 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	90                   	nop
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 17                	push   $0x17
  801edd:	e8 56 fd ff ff       	call   801c38 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	90                   	nop
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	ff 75 0c             	pushl  0xc(%ebp)
  801ef7:	50                   	push   %eax
  801ef8:	6a 18                	push   $0x18
  801efa:	e8 39 fd ff ff       	call   801c38 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 1b                	push   $0x1b
  801f17:	e8 1c fd ff ff       	call   801c38 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 19                	push   $0x19
  801f34:	e8 ff fc ff ff       	call   801c38 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	90                   	nop
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	6a 1a                	push   $0x1a
  801f52:	e8 e1 fc ff ff       	call   801c38 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	90                   	nop
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	8b 45 10             	mov    0x10(%ebp),%eax
  801f66:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f69:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f6c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	51                   	push   %ecx
  801f76:	52                   	push   %edx
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	50                   	push   %eax
  801f7b:	6a 1c                	push   $0x1c
  801f7d:	e8 b6 fc ff ff       	call   801c38 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	6a 1d                	push   $0x1d
  801f9a:	e8 99 fc ff ff       	call   801c38 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	51                   	push   %ecx
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 1e                	push   $0x1e
  801fb9:	e8 7a fc ff ff       	call   801c38 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 1f                	push   $0x1f
  801fd6:	e8 5d fc ff ff       	call   801c38 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 20                	push   $0x20
  801fef:	e8 44 fc ff ff       	call   801c38 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	6a 00                	push   $0x0
  802001:	ff 75 14             	pushl  0x14(%ebp)
  802004:	ff 75 10             	pushl  0x10(%ebp)
  802007:	ff 75 0c             	pushl  0xc(%ebp)
  80200a:	50                   	push   %eax
  80200b:	6a 21                	push   $0x21
  80200d:	e8 26 fc ff ff       	call   801c38 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	50                   	push   %eax
  802026:	6a 22                	push   $0x22
  802028:	e8 0b fc ff ff       	call   801c38 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	90                   	nop
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	50                   	push   %eax
  802042:	6a 23                	push   $0x23
  802044:	e8 ef fb ff ff       	call   801c38 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802055:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802058:	8d 50 04             	lea    0x4(%eax),%edx
  80205b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	52                   	push   %edx
  802065:	50                   	push   %eax
  802066:	6a 24                	push   $0x24
  802068:	e8 cb fb ff ff       	call   801c38 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
	return result;
  802070:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802079:	89 01                	mov    %eax,(%ecx)
  80207b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	c9                   	leave  
  802082:	c2 04 00             	ret    $0x4

00802085 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	6a 13                	push   $0x13
  802097:	e8 9c fb ff ff       	call   801c38 <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return ;
  80209f:	90                   	nop
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 25                	push   $0x25
  8020b1:	e8 82 fb ff ff       	call   801c38 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	50                   	push   %eax
  8020d4:	6a 26                	push   $0x26
  8020d6:	e8 5d fb ff ff       	call   801c38 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
	return ;
  8020de:	90                   	nop
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <rsttst>:
void rsttst()
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 28                	push   $0x28
  8020f0:	e8 43 fb ff ff       	call   801c38 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f8:	90                   	nop
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	8b 45 14             	mov    0x14(%ebp),%eax
  802104:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802107:	8b 55 18             	mov    0x18(%ebp),%edx
  80210a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	ff 75 10             	pushl  0x10(%ebp)
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	6a 27                	push   $0x27
  80211b:	e8 18 fb ff ff       	call   801c38 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return ;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <chktst>:
void chktst(uint32 n)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 29                	push   $0x29
  802136:	e8 fd fa ff ff       	call   801c38 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
	return ;
  80213e:	90                   	nop
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <inctst>:

void inctst()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 2a                	push   $0x2a
  802150:	e8 e3 fa ff ff       	call   801c38 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
	return ;
  802158:	90                   	nop
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <gettst>:
uint32 gettst()
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 2b                	push   $0x2b
  80216a:	e8 c9 fa ff ff       	call   801c38 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 2c                	push   $0x2c
  802186:	e8 ad fa ff ff       	call   801c38 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
  80218e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802191:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802195:	75 07                	jne    80219e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802197:	b8 01 00 00 00       	mov    $0x1,%eax
  80219c:	eb 05                	jmp    8021a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2c                	push   $0x2c
  8021b7:	e8 7c fa ff ff       	call   801c38 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
  8021bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021c6:	75 07                	jne    8021cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cd:	eb 05                	jmp    8021d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 2c                	push   $0x2c
  8021e8:	e8 4b fa ff ff       	call   801c38 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
  8021f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021f7:	75 07                	jne    802200 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fe:	eb 05                	jmp    802205 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 2c                	push   $0x2c
  802219:	e8 1a fa ff ff       	call   801c38 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
  802221:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802224:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802228:	75 07                	jne    802231 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80222a:	b8 01 00 00 00       	mov    $0x1,%eax
  80222f:	eb 05                	jmp    802236 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802231:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	6a 2d                	push   $0x2d
  802248:	e8 eb f9 ff ff       	call   801c38 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return ;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	53                   	push   %ebx
  802266:	51                   	push   %ecx
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 2e                	push   $0x2e
  80226b:	e8 c8 f9 ff ff       	call   801c38 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	52                   	push   %edx
  802288:	50                   	push   %eax
  802289:	6a 2f                	push   $0x2f
  80228b:	e8 a8 f9 ff ff       	call   801c38 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8022a1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	50                   	push   %eax
  8022a9:	e8 fa fb ff ff       	call   801ea8 <sys_cputc>
  8022ae:	83 c4 10             	add    $0x10,%esp
}
  8022b1:	90                   	nop
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8022ba:	e8 b5 fb ff ff       	call   801e74 <sys_disable_interrupt>
	char c = ch;
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8022c5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	50                   	push   %eax
  8022cd:	e8 d6 fb ff ff       	call   801ea8 <sys_cputc>
  8022d2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8022d5:	e8 b4 fb ff ff       	call   801e8e <sys_enable_interrupt>
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <getchar>:

int
getchar(void)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8022e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8022ea:	eb 08                	jmp    8022f4 <getchar+0x17>
	{
		c = sys_cgetc();
  8022ec:	e8 9b f9 ff ff       	call   801c8c <sys_cgetc>
  8022f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8022f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f8:	74 f2                	je     8022ec <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <atomic_getchar>:

int
atomic_getchar(void)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  802305:	e8 6a fb ff ff       	call   801e74 <sys_disable_interrupt>
	int c=0;
  80230a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  802311:	eb 08                	jmp    80231b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  802313:	e8 74 f9 ff ff       	call   801c8c <sys_cgetc>
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	74 f2                	je     802313 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  802321:	e8 68 fb ff ff       	call   801e8e <sys_enable_interrupt>
	return c;
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <iscons>:

int iscons(int fdnum)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	66 90                	xchg   %ax,%ax
  802337:	90                   	nop

00802338 <__udivdi3>:
  802338:	55                   	push   %ebp
  802339:	57                   	push   %edi
  80233a:	56                   	push   %esi
  80233b:	53                   	push   %ebx
  80233c:	83 ec 1c             	sub    $0x1c,%esp
  80233f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802343:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234f:	89 ca                	mov    %ecx,%edx
  802351:	89 f8                	mov    %edi,%eax
  802353:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802357:	85 f6                	test   %esi,%esi
  802359:	75 2d                	jne    802388 <__udivdi3+0x50>
  80235b:	39 cf                	cmp    %ecx,%edi
  80235d:	77 65                	ja     8023c4 <__udivdi3+0x8c>
  80235f:	89 fd                	mov    %edi,%ebp
  802361:	85 ff                	test   %edi,%edi
  802363:	75 0b                	jne    802370 <__udivdi3+0x38>
  802365:	b8 01 00 00 00       	mov    $0x1,%eax
  80236a:	31 d2                	xor    %edx,%edx
  80236c:	f7 f7                	div    %edi
  80236e:	89 c5                	mov    %eax,%ebp
  802370:	31 d2                	xor    %edx,%edx
  802372:	89 c8                	mov    %ecx,%eax
  802374:	f7 f5                	div    %ebp
  802376:	89 c1                	mov    %eax,%ecx
  802378:	89 d8                	mov    %ebx,%eax
  80237a:	f7 f5                	div    %ebp
  80237c:	89 cf                	mov    %ecx,%edi
  80237e:	89 fa                	mov    %edi,%edx
  802380:	83 c4 1c             	add    $0x1c,%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5f                   	pop    %edi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    
  802388:	39 ce                	cmp    %ecx,%esi
  80238a:	77 28                	ja     8023b4 <__udivdi3+0x7c>
  80238c:	0f bd fe             	bsr    %esi,%edi
  80238f:	83 f7 1f             	xor    $0x1f,%edi
  802392:	75 40                	jne    8023d4 <__udivdi3+0x9c>
  802394:	39 ce                	cmp    %ecx,%esi
  802396:	72 0a                	jb     8023a2 <__udivdi3+0x6a>
  802398:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80239c:	0f 87 9e 00 00 00    	ja     802440 <__udivdi3+0x108>
  8023a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d 76 00             	lea    0x0(%esi),%esi
  8023b4:	31 ff                	xor    %edi,%edi
  8023b6:	31 c0                	xor    %eax,%eax
  8023b8:	89 fa                	mov    %edi,%edx
  8023ba:	83 c4 1c             	add    $0x1c,%esp
  8023bd:	5b                   	pop    %ebx
  8023be:	5e                   	pop    %esi
  8023bf:	5f                   	pop    %edi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    
  8023c2:	66 90                	xchg   %ax,%ax
  8023c4:	89 d8                	mov    %ebx,%eax
  8023c6:	f7 f7                	div    %edi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	89 fa                	mov    %edi,%edx
  8023cc:	83 c4 1c             	add    $0x1c,%esp
  8023cf:	5b                   	pop    %ebx
  8023d0:	5e                   	pop    %esi
  8023d1:	5f                   	pop    %edi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    
  8023d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023d9:	89 eb                	mov    %ebp,%ebx
  8023db:	29 fb                	sub    %edi,%ebx
  8023dd:	89 f9                	mov    %edi,%ecx
  8023df:	d3 e6                	shl    %cl,%esi
  8023e1:	89 c5                	mov    %eax,%ebp
  8023e3:	88 d9                	mov    %bl,%cl
  8023e5:	d3 ed                	shr    %cl,%ebp
  8023e7:	89 e9                	mov    %ebp,%ecx
  8023e9:	09 f1                	or     %esi,%ecx
  8023eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023ef:	89 f9                	mov    %edi,%ecx
  8023f1:	d3 e0                	shl    %cl,%eax
  8023f3:	89 c5                	mov    %eax,%ebp
  8023f5:	89 d6                	mov    %edx,%esi
  8023f7:	88 d9                	mov    %bl,%cl
  8023f9:	d3 ee                	shr    %cl,%esi
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e2                	shl    %cl,%edx
  8023ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802403:	88 d9                	mov    %bl,%cl
  802405:	d3 e8                	shr    %cl,%eax
  802407:	09 c2                	or     %eax,%edx
  802409:	89 d0                	mov    %edx,%eax
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	f7 74 24 0c          	divl   0xc(%esp)
  802411:	89 d6                	mov    %edx,%esi
  802413:	89 c3                	mov    %eax,%ebx
  802415:	f7 e5                	mul    %ebp
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 19                	jb     802434 <__udivdi3+0xfc>
  80241b:	74 0b                	je     802428 <__udivdi3+0xf0>
  80241d:	89 d8                	mov    %ebx,%eax
  80241f:	31 ff                	xor    %edi,%edi
  802421:	e9 58 ff ff ff       	jmp    80237e <__udivdi3+0x46>
  802426:	66 90                	xchg   %ax,%ax
  802428:	8b 54 24 08          	mov    0x8(%esp),%edx
  80242c:	89 f9                	mov    %edi,%ecx
  80242e:	d3 e2                	shl    %cl,%edx
  802430:	39 c2                	cmp    %eax,%edx
  802432:	73 e9                	jae    80241d <__udivdi3+0xe5>
  802434:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802437:	31 ff                	xor    %edi,%edi
  802439:	e9 40 ff ff ff       	jmp    80237e <__udivdi3+0x46>
  80243e:	66 90                	xchg   %ax,%ax
  802440:	31 c0                	xor    %eax,%eax
  802442:	e9 37 ff ff ff       	jmp    80237e <__udivdi3+0x46>
  802447:	90                   	nop

00802448 <__umoddi3>:
  802448:	55                   	push   %ebp
  802449:	57                   	push   %edi
  80244a:	56                   	push   %esi
  80244b:	53                   	push   %ebx
  80244c:	83 ec 1c             	sub    $0x1c,%esp
  80244f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802453:	8b 74 24 34          	mov    0x34(%esp),%esi
  802457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802463:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802467:	89 f3                	mov    %esi,%ebx
  802469:	89 fa                	mov    %edi,%edx
  80246b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80246f:	89 34 24             	mov    %esi,(%esp)
  802472:	85 c0                	test   %eax,%eax
  802474:	75 1a                	jne    802490 <__umoddi3+0x48>
  802476:	39 f7                	cmp    %esi,%edi
  802478:	0f 86 a2 00 00 00    	jbe    802520 <__umoddi3+0xd8>
  80247e:	89 c8                	mov    %ecx,%eax
  802480:	89 f2                	mov    %esi,%edx
  802482:	f7 f7                	div    %edi
  802484:	89 d0                	mov    %edx,%eax
  802486:	31 d2                	xor    %edx,%edx
  802488:	83 c4 1c             	add    $0x1c,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
  802490:	39 f0                	cmp    %esi,%eax
  802492:	0f 87 ac 00 00 00    	ja     802544 <__umoddi3+0xfc>
  802498:	0f bd e8             	bsr    %eax,%ebp
  80249b:	83 f5 1f             	xor    $0x1f,%ebp
  80249e:	0f 84 ac 00 00 00    	je     802550 <__umoddi3+0x108>
  8024a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8024a9:	29 ef                	sub    %ebp,%edi
  8024ab:	89 fe                	mov    %edi,%esi
  8024ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024b1:	89 e9                	mov    %ebp,%ecx
  8024b3:	d3 e0                	shl    %cl,%eax
  8024b5:	89 d7                	mov    %edx,%edi
  8024b7:	89 f1                	mov    %esi,%ecx
  8024b9:	d3 ef                	shr    %cl,%edi
  8024bb:	09 c7                	or     %eax,%edi
  8024bd:	89 e9                	mov    %ebp,%ecx
  8024bf:	d3 e2                	shl    %cl,%edx
  8024c1:	89 14 24             	mov    %edx,(%esp)
  8024c4:	89 d8                	mov    %ebx,%eax
  8024c6:	d3 e0                	shl    %cl,%eax
  8024c8:	89 c2                	mov    %eax,%edx
  8024ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024ce:	d3 e0                	shl    %cl,%eax
  8024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024d8:	89 f1                	mov    %esi,%ecx
  8024da:	d3 e8                	shr    %cl,%eax
  8024dc:	09 d0                	or     %edx,%eax
  8024de:	d3 eb                	shr    %cl,%ebx
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	f7 f7                	div    %edi
  8024e4:	89 d3                	mov    %edx,%ebx
  8024e6:	f7 24 24             	mull   (%esp)
  8024e9:	89 c6                	mov    %eax,%esi
  8024eb:	89 d1                	mov    %edx,%ecx
  8024ed:	39 d3                	cmp    %edx,%ebx
  8024ef:	0f 82 87 00 00 00    	jb     80257c <__umoddi3+0x134>
  8024f5:	0f 84 91 00 00 00    	je     80258c <__umoddi3+0x144>
  8024fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ff:	29 f2                	sub    %esi,%edx
  802501:	19 cb                	sbb    %ecx,%ebx
  802503:	89 d8                	mov    %ebx,%eax
  802505:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802509:	d3 e0                	shl    %cl,%eax
  80250b:	89 e9                	mov    %ebp,%ecx
  80250d:	d3 ea                	shr    %cl,%edx
  80250f:	09 d0                	or     %edx,%eax
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 eb                	shr    %cl,%ebx
  802515:	89 da                	mov    %ebx,%edx
  802517:	83 c4 1c             	add    $0x1c,%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5f                   	pop    %edi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    
  80251f:	90                   	nop
  802520:	89 fd                	mov    %edi,%ebp
  802522:	85 ff                	test   %edi,%edi
  802524:	75 0b                	jne    802531 <__umoddi3+0xe9>
  802526:	b8 01 00 00 00       	mov    $0x1,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f7                	div    %edi
  80252f:	89 c5                	mov    %eax,%ebp
  802531:	89 f0                	mov    %esi,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f5                	div    %ebp
  802537:	89 c8                	mov    %ecx,%eax
  802539:	f7 f5                	div    %ebp
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	e9 44 ff ff ff       	jmp    802486 <__umoddi3+0x3e>
  802542:	66 90                	xchg   %ax,%ax
  802544:	89 c8                	mov    %ecx,%eax
  802546:	89 f2                	mov    %esi,%edx
  802548:	83 c4 1c             	add    $0x1c,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5e                   	pop    %esi
  80254d:	5f                   	pop    %edi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
  802550:	3b 04 24             	cmp    (%esp),%eax
  802553:	72 06                	jb     80255b <__umoddi3+0x113>
  802555:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802559:	77 0f                	ja     80256a <__umoddi3+0x122>
  80255b:	89 f2                	mov    %esi,%edx
  80255d:	29 f9                	sub    %edi,%ecx
  80255f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802563:	89 14 24             	mov    %edx,(%esp)
  802566:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80256a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80256e:	8b 14 24             	mov    (%esp),%edx
  802571:	83 c4 1c             	add    $0x1c,%esp
  802574:	5b                   	pop    %ebx
  802575:	5e                   	pop    %esi
  802576:	5f                   	pop    %edi
  802577:	5d                   	pop    %ebp
  802578:	c3                   	ret    
  802579:	8d 76 00             	lea    0x0(%esi),%esi
  80257c:	2b 04 24             	sub    (%esp),%eax
  80257f:	19 fa                	sbb    %edi,%edx
  802581:	89 d1                	mov    %edx,%ecx
  802583:	89 c6                	mov    %eax,%esi
  802585:	e9 71 ff ff ff       	jmp    8024fb <__umoddi3+0xb3>
  80258a:	66 90                	xchg   %ax,%ax
  80258c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802590:	72 ea                	jb     80257c <__umoddi3+0x134>
  802592:	89 d9                	mov    %ebx,%ecx
  802594:	e9 62 ff ff ff       	jmp    8024fb <__umoddi3+0xb3>
