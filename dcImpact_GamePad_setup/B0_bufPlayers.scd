(
q[\numBufPlayers] = 2;
q[\bufPlayOffs] = 0;

p = p ?? { ProxySpace.push; }; 	
q = q ? Impact.q ? ();

q[\usedRatios]=();
q[\playbufIndices] = q[\playbufIndices] ? (); 
q[\playbufForw] = q[\playbufForw] ? (); 

q[\bufplay] = { arg buf=4, rate=1, flip=1, start=0, normL=1, pblag=1, usedRatio=1, amp=0, gain = 1; 

	var in, out, bufFrames, startFr, stopFr, rateLag, usedBufFrames, maxDly=0.007;
	var minL, length;
	rateLag = rate.lag(pblag);
	bufFrames =  BufFrames.kr(buf);
	usedBufFrames = bufFrames * usedRatio;
	
	startFr = start.lag(pblag*0.5) * usedBufFrames; 
	minL = 0.01 * BufSampleRate.kr(buf);		// maxL = usedBufFrames.
	length = usedBufFrames - minL * normL.lag(pblag*0.5).squared * 4 + minL; // !!
	stopFr = startFr + length;

	in =	BufRd.ar(1, 		// number of channels of samples
			buf, 
			(
				Phasor.ar(
					1, 
					rateLag * BufRateScale.kr(buf) * flip , 
					startFr + [0, LFNoise1.kr(0.2, 20)], 
					stopFr,
					0, 
					usedBufFrames
				) 
			) % usedBufFrames,
			1, 2
		);
	out = Limiter.ar(in * amp * gain, 0.9);
};

Spec.specs.add( \pbrate -> ControlSpec(0.25, 2, \exp, 0.0));
Spec.specs.add( \pbrate -> ControlSpec(0.125, 8, \exp, 0.0));
Spec.specs.add( \start -> ControlSpec(0, 1, \lin));
Spec.specs.add( \normL -> ControlSpec(0, 1, \lin));
Spec.specs.add( \length -> ControlSpec(0.005, 1.995, \lin));
Spec.specs.add( \pblag -> ControlSpec(0.05, 20, \exp));

q[\numBufPlayers].do {	|i| 
	var name, chan, stepFunc;
	chan = i + q[\bufPlayOffs]; 	// offset. for bufplay 1.
	name = ("b_bufplay" ++ (i+1)).asSymbol;

	p[name]  = q[\bufplay];
	p[name].play(vol: 0.5);

	q[\playbufIndices].put(chan, 1); 
	q[\playbufForw].put(chan, true);
	
	stepFunc = {Êarg val, inc = 1; 
		if(val == 0, { 
			q[\playbufIndices][chan] = (q[\playbufIndices][chan] ? 0 + inc)
					.wrap(0, BufBank.loaded.size - 1 + BufBank.numJams);
		//	BufBank.bufs[q[\playbufIndices][chan]].path.basename.postln;
			p[name].set(
				\buf, BufBank.bufs[q[\playbufIndices][chan]].bufnum.postln
				, \usedRatio, q[\usedRatios][q[\playbufIndices][chan]] ? 1
			);
			[	BufBank.loaded[q[\playbufIndices][chan]].basename, 
				"__BufNumChange__ ", q[\playbufIndices][chan], name 
			 ].postln;
		});
	};
	
	GamePad.putProxy(chan, 
		name, 
		(
			joyRX:	{ arg val; 	p[name].set(\rate, \pbrate.asSpec.map(val)) }, 
			joyLX: 	{ arg val; 	p[name].set(\start, val); },
		//	joyLY:	{ arg val; 	 p[name].set(\normL, val) }, // was orig. 
			joyLY:	{ arg val; 	 p[name].set(\normL, \amp.asSpec.map(min(val, 1 - val) * 2)) },
			joyRY:	{ arg val, modState; 	
						if( modState.notNil and: { modState.[\midL] }, 
							{ p[name].set(\pblag, (\pblag.asSpec.map(val) - 0.05).postln); },
							{ p[name].set(\amp, \amp.asSpec.map(val) ) }
						)
					}, 
			lHat: 	{ arg val; 	stepFunc.value(val, -1) },
			rHat: 	{ arg val; 	stepFunc.value(val, 1) },
			midR:	{ arg val; 	var flag; 
						if(val == 0, {
							flag = q[\playbufForw][chan].not;								q[\playbufForw][chan]=flag; 
							[ name, \flip, flag].postln;
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
~b_play1 = q[\bufplay];
 */