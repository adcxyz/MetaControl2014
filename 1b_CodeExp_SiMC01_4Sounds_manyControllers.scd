/*****
 * build 4 sound processes 
 * use lots of different controllers to play the same 4 sounds! 
 * test whether all the Library installs (quarks) work smoothly 

The four proxies are: 
	s4_formsing, 
	s5_allArm, 
	s6_moogSing, 
	s7_kiteHi0

in the class, map them to different audio chans

*********/


	// OVERVIEW: 

		// 1. simple guis 
	NdefGui			// OK, in 3.4
	ProxyMixer		// OK, in 3.4
	Handmade gui with 2DSliders // OK


		// 2. GamePad - sorry still osx only
	Impact		// install GamePad quark, then OK
	Ferrari		// OK 

	
		// 3. MIDI ctl
	Nano		// install JITMIDIKtl, OK 
 
						// multitouch - OSX 10.5 and up
	MultiTouchPad	// install MultiTouchPad quark
						// 1st finger is first proxy, 2 is 2, etc

		// any system
	KeyPlayer // 1-9 is amp, q-p is param 1, a - l param2 etc.

		// OSX, linux
	Cyborg	// GeneralHID, OK on osx, test on linux! 
	 

///////////////// code //////////////

//////	// Library install party - all installed in the Standalone! 

////// Quarks.checkoutAll;		// get the latest, wait till process completed
////// 	// cross platform: 
////// Quarks.install("KeyPlayer");
//////
////// Quarks.install("JITLib extensions");
////// Quarks.install("JITMIDIKtl");
////// 
//////		// sorry, OS X only ATM!
////// Quarks.install("GamePad");
////// Quarks.install("MultiTouchPad");


	// copy the line posted here: 
("(\nsudo cp " + "tongsengmod".resolveRelative + "/usr/bin\n)");
	// and paste it into the Terminal window: 
unixCmd("open /Applications/Utilities/Terminal.app/");
	// hit enter, allow copying the file by password ...


	// When done, recompile:
thisProcess.recompile; 



(	// prep
s.boot;

p = p ?? { ProxySpace.new }; p.push;
q.pxmix = ProxyMixer(p, 8);

(		// if it uses { |val| val / -255 } etc, put these new functions in the map:
Impact.normMaps[Impact.vendorID].putAll(
	(	'joyRX': { |val| val - 127 / -255 }, 
		'joyLY': { |val| val + 128 /  255 }, 
		'joyLX': { |val| val - 127 / -255 }, 
		'joyRY': { |val| val + 128 /  255 }
   	)
   		// postcs to check that the new functions are there: 
).postcs;
);
q = q ?? {()};
GamePad.startHID(q.pxmix);

)
/* 
GamePad.verbose = true;
GamePad.verbose = false;
GamePad.stop;
*/

(	// load the 4 patches - also loads them for GamePad
"dcImpact*/S4_*".resolveRelative.pathMatch.first.loadPaths;
"dcImpact*/S5_*".resolveRelative.pathMatch.first.loadPaths;
"dcImpact*/S6_*".resolveRelative.pathMatch.first.loadPaths;
"dcImpact*/S7_*".resolveRelative.pathMatch.first.loadPaths;

	// the 4 ndefs by name
q.ndefs = [~s4_formsing, ~s5_allArm, ~s6_moogSing, ~s7_kiteHi0];
)

	// make 4 NdefGuis for them 
	// these show changes for all of them
(
w = Window("Proxies:", Rect(600, 0, 400, 800)).front;
w.addFlowLayout;
q.ndefGuis = q.ndefs.collect { |px, i|
	NdefGui(px, 8, w);
};

q.ndefGuis.do { |gui| gui.skipjack.dt = 0.03 };
)

s.latency = nil;	// make the server respond to controls immediately;
s.latency = 0.05;	// default: do it a bit later, but precisely timed.



	// make 2 Slider2Ds, which act like gamepads:
(
	w = Window("xy sliders", Rect(0,600,400, 250)).front;
	w.addFlowLayout;
		// 4 buttons to switch them
	q.sl2dButtons = q.ndefs.collect { |px| 
		Button(w, Rect(0,0, 90, 30))
			.states_([
				[px.key.asString], 
				[px.key.asString, Color.white, Color.red]
			])
			.action = { |b| 
				q.sl2dButtons.do { |but| 
					but.value = (but == b).binaryValue;
					q.sl2dProxy = px; 
				};
			};
	};

	v = 2.collect { |i| Slider2D(w, Rect(0, 0, 190, 190))	};
	
	v[0].action = { |sl| 
		var keys = q.sl2dProxy.getKeysValues.collect(_[0]);
		var keyLX = keys[2];
		var keyLY = keys[3];
		q.sl2dProxy.set(
			keyLX, keyLX.asSpec.map(sl.x),
			keyLY, keyLY.asSpec.map(sl.y)
		);
	};

	v[1].action = { |sl| 
		var keys = q.sl2dProxy.getKeysValues.collect(_[0]);
		var keyRX = keys[0];
		var keyRY = keys[1];
		q.sl2dProxy.set(
			keyRX, keyRX.asSpec.map(sl.x),
			keyRY, keyRY.asSpec.map(sl.y)
		);
	};
)		


////////// MIDI control - very compressed example;
//// uses JITMIDI easy methods;
// attach NanoKtl first, 
// linux - make sure MIDI works ...
(
q.nano = NanoKtl.new;
(1..4).do { |i| q.nano.mapToNdefGui(q.ndefGuis[i - 1], i) };

)
//////////


	// osx only - install current Wacom Intuos driver first!
	// http://www.wacom.com/downloads/
(
q.wacomProxy = ~s4_formsing;

q.wwin = Window("Tablet Control!", Rect(0, 200, 400, 400)).front;
q.wwin.addFlowLayout;

q.wacomButtons = q.ndefs.collect { |px| 
	Button(q.wwin, Rect(0,0, 90, 30))
		.states_([
			[px.key.asString], 
			[px.key.asString, Color.white, Color.red]
		])
		.action = { |b| 
			q.wacomButtons.do { |but| 
				but.value = (but == b).binaryValue;
				q.wacomProxy = px; 
			};
		};
};

q.tabText = StaticText(q.wwin, Rect(0, 0, 370, 20)).background_(Color.white);

q.tablet = TabletView(q.wwin,Rect(0,0,380,300));
q.tablet.background = Color.white;

q.tabSetFunc = { |dict, vals| // normalized;
	var keysVals = q.wKeys.collect { |key, i|
		[key, key.asSpec.map(vals[i])]; 
	};
	q.wacomProxy.set(*keysVals.flat);
};

q.tablet.mouseDownAction = { arg view,x,y,pressure,tiltx,tilty,deviceID;
	['started',x,y,pressure,tiltx,tilty].round(0.001).postln;
	q.wKeys = q.wacomProxy.getKeysValues.collect(_[0]).keep(5);
	q.tabSetFunc([pressure, x/300, y/300, tiltx + 1 / 2, tiltx + 1 / 2]);
};

q.tablet.action = { arg view,x,y,pressure,tiltx,tilty,deviceID;
	q.tabText.string = [\x, x, \y, y, \pr, pressure,\tx, tiltx, \ty, tilty].round(0.001).asString;
	q.tabSetFunc([pressure, x/300, y/300, tiltx + 1 / 2, tiltx + 1 / 2]);
};

q.tablet.mouseUpAction = { arg view,x,y,pressure,tiltx,tilty,deviceID;
	['ended',x,y,pressure,tiltx,tilty].round(0.001).postln;
	q.tabSetFunc([pressure, x/300, y/300, tiltx + 1 / 2, tiltx + 1 / 2]);
};
)

// Attach a GamePad, e.g. Saitek Impact, or Ferrari;
// then : 
GamePad.startHID;

// right thumb: press button 2, so you are in wing 4
// left thumb select one of the 4 patches
// joysticks - 4 params of proxies are controlled; 
// right up-down is volume on all patches.
// see GamePad help file ... 


(
MultiTouchPad.start;

q[\mtSetFunc] = {|curID, xys| 
		var prox = q.ndefs.wrapAt(curID);
		var proxKeys = prox.getKeysValues.keep(3)
			.collect(_[0]);
			xys = xys ? [0.5, 0.5, 0];
		prox.set(
			*proxKeys.collect { arg key, i;
				[key, key.asSpec.map(xys[2 - i])]
			}.flat
		);
	};


MultiTouchPad.touchAction = q[\mtSetFunc];
MultiTouchPad.setAction = q[\mtSetFunc];
MultiTouchPad.untouchAction = q[\mtSetFunc];

q.mtGui = MultiTouchPad.gui;
MultiTouchPad.guiWin.view.keyDownAction = { |view, char| 
	if (char == $.) { MultiTouchPad.stop };
	if (char == $ ) { MultiTouchPad.start };
	
};
)

MultiTouchPad.stop;


KeyPlayer // 1-9 is amp, q-p is param 1, a - l param2 etc.
Quarks.install("KeyPlayer");

KeyPlayer.all.clear;
(
q.ndefs.collect { |ndef| 
	var k = KeyPlayer(ndef.key.asString.drop(3).keep(4).asSymbol);
	var ndefParams = ndef.getKeysValues.keep(4).collect(_[0]);
		// four lines of keys move four params:
	[	"1234567890", 
		"qwertyuiop",
		"asdfghjkl;",
		"zxcvbnm,.;" ].do { |line, i| 
			line.do { |char, j|
				k.put(char, { 
					var param = ndefParams[i];
					ndef.set(param, param.asSpec.map(j / 9));
				});
			};
		};
};
KeyPlayer.gui;
)



// 	Saitek Cyborg Flight control Joystick
	
GeneralHID.buildDeviceList;
GeneralHID.postDevices;
(
q.cyborgArr = GeneralHID.deviceList.detect { |arr| 
		arr[0].product == "Cyborg X"; };
)		
	q.cyborgArr[0];	// the platform-specific device
	q.cyborgArr[1];	// the info on the device

q.cyborg = GeneralHID.open(q.cyborgArr);

GeneralHID.startEventLoop;
q.cyborg.device.device.elements.do(_.dump);
q.cyborg.caps;
q.cyborg.makeGui;
	
	// this dict has the buttons
q.cyborg.slots[1].keys;

	// this has the continuous controls (sliders etc)
q.cyborg.slots[3].keys;

	// ... lets name them like that!  
q.cybSliders = q.cyborg.slots[3];
q.cybButtons = q.cyborg.slots[1];

	// now we want the leftmost lever/slider 
		// to be \amp: 
q.cybSliders[50].action = { |slot| slot.value.postln };
(
q.cybNdef = ~s4_formsing;
	// leftmost slider:
q.cybSliders[50].action = { |slot| 
	q.cybNdef.set(\amp, \amp.asSpec.map(slot.value))
};
 )

	// use 4 buttons for left thumb, 6, 7, 8, 9,
	// to switch between 4 ndefs: 
(
[6, 7, 8, 9].do { |butnum, i|
	q.cybButtons[butnum].action = { |slot| 
		q.cybNdef = q.ndefs[i].postcs;
	};
};
)

	// keep amp as is, next 3 params are controlled by joystick: 
	// LR = 48, frontback = 49, rotation = 53;
(
	// left lever, LR, FB, Rot
[50, 48, 49, 53].do { |ctlNum, i|
	q.cybSliders[ctlNum].action = { |slot| 
		var parKey = q.cybNdef.getKeysValues[i][0];
		q.cybNdef.set(parKey, parKey.asSpec.map(slot.value))
	};
};
)

