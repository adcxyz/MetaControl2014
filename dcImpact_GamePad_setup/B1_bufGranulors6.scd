// st for Bj Nu style 2005

(
q[\numGranalatars] = 2;
q[\bufGranOffs] = 2;
p = p ?? { ProxySpace.push; }; 	q = q ? Impact.q ? ();
q[\usedRatios]=();

q[\granFunc] = { arg buf=1, ovlap = 1, grrate = 1, progress = 1, flip = 1, trate=12, 
	jit=0.25, randOffs=0, amp=0;
	var b = 10, dur, clk, pos, pan, bufdurKr;

	dur = 2 * ovlap / trate;
	clk = Impulse.kr(trate) + Dust.kr(trate * jit);	// better maken !
	bufdurKr = BufDur.kr(buf); 
	pos = LFSaw.kr(bufdurKr.max(0.01).reciprocal * 0.5 * progress )
		+ TRand.kr(0, 0.0001 + randOffs, clk) % 1 * bufdurKr;

	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, buf, grrate * flip, pos, dur, pan, amp: amp, interp: 2) * 3;
};

Spec.specs.add( \grrate -> ControlSpec(0.25, 4, \exp, 0.0));
Spec.specs.add( \progress -> ControlSpec(-1, 3, \lin));
Spec.specs.add( \jit -> ControlSpec(-4, 4, \lin));
Spec.specs.add( \randOffs -> ControlSpec(-1, 1, \lin));
Spec.specs.add( \grLag -> ControlSpec(0.05, 25, \exp));
Spec.specs.add( \ovlap -> ControlSpec(0.1, 10, \exp));
Spec.specs.add( \trate -> ControlSpec(4, 100, \exp));

/*
L 	pitch
	freez
	
R 	ovlap		X
	trate		Y
	
sh R	vol
	lag

shL	jitter		Y
	randOffs	X
*/
//
q[\granIndices] = q[\granIndices] ? (); 
q[\granForw] = q[\granForw]  ? (); 

q[\numGranalatars].do {	|i| 
	var name, chan, stepFunc;
	var prog; ////// !!!!!
	chan = q[\bufGranOffs]+i; 				// offset. for bufplay 1.
	name = ("b_Gran" ++ (i+1)).asSymbol.postln;

	p[name] = q[\granFunc].postln;

	
 	fork { 0.2.wait; p[name].fadeTime = 0.2; p[name].play(vol: 0.5); };

	q[\granIndices].put(chan, 1); 
	q[\granForw].put(chan, true);

	stepFunc = {Êarg val, inc = 1; 
		if(val == 0, { 
			q[\granIndices][chan] = (q[\granIndices][chan] ? 0 + inc)
				.wrap(0, BufBank.loaded.size - 1 + BufBank.numJams);
			p[name].group.set(
				\buf, BufBank.bufs[q[\granIndices][chan]].bufnum.postln
			);
			[	BufBank.loaded[q[\granIndices][chan]].basename, 
				"__BufNumChange__ ", q[\granIndices][chan], name 
			 ].postln;
		});
	};



	GamePad.putProxy(chan, name,
		(
			joyRY:	{ arg val, modState; 	if ( modState.notNil and: { modState.[\midL] },
								{ p[name].set(\amp, \amp.asSpec.map(val) ) },
								{ p[name].set(\trate, \trate.asSpec.map(val))}
							)
				}, 
			joyLX: 	{ arg val, modState; 	if( modState.notNil and: { modState.[\midR] },
								{p[name].set(\randOffs, 
									\randOffs.asSpec.map(val).max(0).squared.squared.postln)},
								{prog = \progress.asSpec.map(val);
									if( prog.abs < 0.1, { prog.postln });
									p[name].set(\progress, prog)};
							)
				},
			joyLY:	{ arg val, modState; 	if( modState.notNil and: { modState.[\midR] },
								{p[name].set(\jit, \jit.asSpec.map(val).max(0).postcln)},
								{p[name].set(\grrate, \grrate.asSpec.map(val))}
							)
				},
			joyRX:	{ arg val, modState; 	if( modState.notNil and: { modState.[\midL] },
								{ p[name].set(\lag, (\grLag.asSpec.map(val) - 0.05).postln); },
								{ p[name].set(\ovlap, \ovlap.asSpec.map(val))}
							)
				}, 
			lHat: 	{ arg val;	stepFunc.value(val, -1) },
			rHat: 	{ arg val; 	stepFunc.value(val, 1) },
			midR:	{ arg val; 	var flag; 
							if(val == 0, {
								flag = q[\granForw][chan].not;								q[\granForw][chan]=flag; 
								[ \b_Gran1, \flip, flag].postln;
								p[name].set(\flip, if(flag, 1, -1));
							});
			}
		)
	);

};

)

/*
~b_play0.vol_(04.8);
~b_play1.set(\buf, 5);
~b_play1.set(\lag, 1);
~b_play1.set(\flip, -1);
~b_play1.set(\rate, 0.25);
~b_play1.set(\start, 0.8);
~b_play1.set(\length, 0.1);

~b_play1 = nil;
~b_play1 = q[\granFunc];
 */