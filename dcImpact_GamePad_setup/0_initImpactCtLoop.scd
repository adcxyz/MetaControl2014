/* 
	ProxyMixer(p);
~b_Gran1.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~b_Gran2.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~b_bufplay1.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~b_bufplay2.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);

~s6_moogSing.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~s7_kiteHi0.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~s5_allArmSoft.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
~s4_formsing.playN(outs: [ 5.rand, 5.rand ], fadeTime: 3);
*/

/*
(
Server.default = s = Server.internal;
s.makeWindow;
s.boot; // !!!

p = (p ?? { ProxySpace(s) }).push; 
m = ProxyMixer(p, 10);

q = q ?? { () };
q.numChans = 11; 

Spec.add(\buf, [0, 1000, \lin, 1]);
);
*/

(
(
s.latency = nil;
GamePad.startHID(m); 
	
	// 
	// ONLY if you have a new Impact going from -128 to 127, uncomment this:
Impact.normMaps[Impact.vendorID].putAll(
	(	joyRX: { |val| val - 127 / -255 }, 
		joyLY: { |val| val + 128 /  255 }, 
		joyLX: { |val| val - 127 / -255 }, 
		joyRY: { |val| val + 128 /  255 }
   	)
);

);

/////// BUFFER //////////////////////// BUFFER ////////
(
		// set BufBanks folder here:
BufBank.root = "~/scwork/bufbank/";
BufBank.numBufs = 64;		// reserve 64 buffers
BufBank.numJams = 4;		// set the number of Jams (live rec. buffers)
BufBank.init;				// initialize now!
BufBank.clearJams;			// clear and allocate live buffers
BufBank.findFolders;		// find the subfolders in root folder
/* 
BufBank.stepFolder;		
*/
	// clear old buffers when clear-loading a new folder? 
BufBank.loadFiles;
);
///////// BUFFER //////////////////////// BUFFER ////////

		// load all proxies from their text files directly:
(
// q.dirpath = Document.current.path.dirname;
q.dirpath = thisProcess.nowExecutingPath.dirname;
Task({	 
	[		"S4_formSing.rtf",
			"S5_allArmSoft.rtf",
			"S6_moogSing.rtf",
			"S7_kiteHi.rtf", 
			"B1_bufGranulors6.rtf",
			"B0_bufPlayers.rtf"
	].do { |filename|  
		(q.dirpath +/+ filename).loadPaths; 
	//	Document.open(filename);
		1.0.wait; 
	};
//	defer { ProxyMixer(p, 10) };
	1.wait;
	~s4_formsing.pause.playN(4 % q.numChans, vol: 0.25);
	~s5_allArmSoft.pause.playN(2 % q.numChans, vol: 0.25);
	~s6_moogSing.pause.playN(0 % q.numChans, vol: 0.25);
	~s7_kiteHi0.pause.playN(6 % q.numChans, vol: 0.25);
	~b_bufplay1 .pause.playN(2 % q.numChans, vol: 0.25);
	~b_bufplay2 .pause.playN(6 % q.numChans, vol: 0.25);
// 
// 
//	p.do(_.pause);
}).play(AppClock);
);
);