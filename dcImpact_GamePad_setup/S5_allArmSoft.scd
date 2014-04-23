(
p = p ?? { ProxySpace.new }; p.push; q = q ?? { () };

~s5_allArm = { arg amp=0, divefreq=0.2, topfreq= 10000, filtfreq=20;
	var mintime, source; 
	mintime = (LFDNoise0.kr(20!2, 0.5, 1) * topfreq).reciprocal; 
	source = LeakDC.ar(CombN.ar(
		Decay.ar(
			Dust.ar(0.6 ! 2, 1) + BrownNoise.ar(0.0005), 
			0.2, 
			WhiteNoise.ar * LFDNoise0.kr(0.4, 0.5, 0.5)
		),
		2.2, 
		(SinOsc.kr(divefreq, 0.2, 0.7, 0.7) + 
		LFDNoise3.kr(divefreq * 2.6, 0.4, 0.0)).max(mintime).min(2.2), 
		1
	)); 
	Limiter.ar(
		OnePole.ar(([ HPF.ar(source, filtfreq), LPF.ar(source, filtfreq, 4) ].sum * amp).distort, 0.2), 
		0.6
	);
}; 

~s5_allArm.play(vol: 0.5);	
//	(  ~s5_allArm.clear )
Spec.add(\topfreq, [20, 100000, \exp]);
Spec.add(\filtfreq, [8, 100000, \exp]);
Spec.add(\divefreq, [0.05, 20, \exp]);

GamePad.putProxy(5, \s5_allArm, 
	(
		joyRY: { arg val; ~s5_allArm.set(\amp, \amp.asSpec.map(val) )  },
		joyLX: { arg val; ~s5_allArm.set(\topfreq, \topfreq.asSpec.map(val)) },
		joyLY: { arg val; ~s5_allArm.set(\divefreq, \divefreq.asSpec.map(val)) },
		joyRX: { arg val; ~s5_allArm.set(\filtfreq,  \filtfreq.asSpec.map(val)) }
	)
);
/* tests

~s5_allArm.vol_(1); 
~s5_allArm.vol_(0.1); 
~s5_allArm.set(\filtfreq, 200); 
~s5_allArm.set(\topfreq, 200);
~s5_allArm.set(\divefreq, 1);

~s5_allArm.paused
*/
)
