(

p = p ?? { ProxySpace.new }; p.push; q = q ?? { () };

// modulating formant frequency

~s6_moogSing = { arg amp=0, moogRoot=24, lpRatio=36, lfDepth=24, lfSpeed=0.35, rq=0.2;
	var in;
	in = LFSaw.ar(
		(moogRoot.lag(0.5).round(1.5).lag(0.05) + LFDNoise3.kr(lfSpeed, [0, 0.1, -0.162])).midicps,
		0, 0.3).sum;
		
	(Limiter.ar(RLPF.ar(
		in, 
		(moogRoot.midicps * 
		(	lpRatio.lag(0.5) + 
			LFDNoise3.kr(lfSpeed ! 2, [-0.26 *lfDepth, 0.382 *lfDepth, lfDepth * -0.62, lfDepth ].lag(0.2))
		).midiratio).clip(20, 17000), rq, 0.6
	).clump(2).sum, 0.7) * (amp * 2)).softclip;
};
~s6_moogSing.play(vol: 0.5);

//	fork { 0.5.wait; ~s6_moogSing.send };

Spec.specs.put(\lpRatio, ControlSpec(12, 60, \lin));
Spec.specs.put(\moogRoot, ControlSpec(10, 40, \lin, 0.5));
Spec.specs.put(\lfDepth, ControlSpec(0.5, 48, \amp));
Spec.add(\lfSpeed, [0.01, 10, \exp]);

GamePad.putProxy(6, \s6_moogSing,
	(
		joyRY: { arg val; ~s6_moogSing.set(\amp, \amp.asSpec.map(val) )  },
		joyLX: { arg val; ~s6_moogSing.set(\lpRatio, \lpRatio.asSpec.map(val)) },		joyLY: { arg val; ~s6_moogSing.set(\moogRoot, \moogRoot.asSpec.map(val)) },		joyRX: { arg val; ~s6_moogSing.set(\lfDepth,\lfDepth.asSpec.map(val)) },
		lHat: { arg val; var curr; 
			if (val == 0) { "moogsing - lfSpeed: ".post; 
				curr = ~s6_moogSing.getKeysValues([\lfSpeed])[0][1];
				curr = if (curr < 10, curr.postln * 1.618, 0.1).postln;
				~s6_moogSing.set(\lfSpeed, curr) 
			};
		},
		rHat: { arg val; var curr; 
			if (val == 0) { "moogsing - rq: ".post; 
				curr = ~s6_moogSing.getKeysValues([\rq])[0][1];
				curr = if (curr > 0.01, curr.postln / 1.618, 1.0).postln;
				~s6_moogSing.set(\rq, curr) 
			};
		}
	)
);
)
/*
~s6_moogSing.set(\rq, 0.1);
*/
