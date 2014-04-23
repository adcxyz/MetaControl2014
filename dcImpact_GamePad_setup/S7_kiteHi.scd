(
p = p ?? { ProxySpace.new }; p.push; q = q ?? { () };

~s7_kiteHi0 = { arg amp=0, ffreq=12000, move = 0.2, hack=3, dustfreq=100, width=0.3, lag=0.25;
	var n=6;
	var in = LFClipNoise.ar(dustfreq.lag(lag), { LFPulse.ar( hack * Rand(0.5, 2), Rand(0, 2pi), width+Rand(-0.3, 0.4))} ! n );
	var snd = Ringz.ar(in, 
		ffreq.lag(lag) * Array.fill(n, { LFDNoise1.kr(move-0.05, 0.95, 1)} ), 		1.25/hack
	).clump(2).sum; 
	
	(LPF.ar(snd, 400) + HPF.ar(snd, 400, 0.33)).softclip * amp.lag(0.03);
}; 

//[	~s7_kiteHi0.stop;	]
~s7_kiteHi0.play(vol: 0.5);

Spec.specs.put(\ffreq, ControlSpec(-1000, 30000, \lin));
Spec.specs.put(\move, ControlSpec(0.05, 40, \exp));
Spec.specs.put(\hack, ControlSpec(1, 40, \exp));
Spec.specs.put(\dustfreq, ControlSpec(0.20, 100000, \exp));
Spec.specs.put(\width, ControlSpec(0.01, 1.0, \amp));

GamePad.putProxy(7, \s7_kiteHi0, 
	(
		joyRY: { arg val; ~s7_kiteHi0.set(\amp, \amp.asSpec.map(val) ) },
		joyLX: { arg val; ~s7_kiteHi0.set(\hack, \hack.asSpec.map(val)) },
		joyLY: { arg val; ~s7_kiteHi0.set(\ffreq, \ffreq.asSpec.map(val)) },
		joyRX: { arg val; ~s7_kiteHi0.set(\move,  \move.asSpec.map(val)) },
		lHat: { arg val; 
			var curr; 
			if (val == 0) { "kiteHi - dustfreq: ".post; 
				curr = ~s7_kiteHi0.getKeysValues([\dustfreq])[0][1];
				curr = if (curr < 10000, curr.postln * 1.618, 0.2).postln;
				~s7_kiteHi0.set(\dustfreq, curr) 
			};
		},
		rHat: { arg val; 
			var curr; 
			if (val == 0) { "s7_kiteHi0 - width: ".post; 
				curr = ~width.getKeysValues([\rq])[0][1];
				curr = if (curr < 1, curr.postln * 1.618, 0.01).postln;
				~s7_kiteHi0.set(\width, curr) 
			};
		}		
	)
);

)
/* tests

~s7_kiteHi0.filter(2, {arg in; in*5});
~s7_kiteHi0.vol_(1); 
~s7_kiteHi0.vol_(0.1); 
~s7_kiteHi0.set(\filtfreq, 200); 
~s7_kiteHi0.set(\topfreq, 200);
~s7_kiteHi0.set(\divefreq, 1);
*/
