(
p = p ?? { ProxySpace.new }; p.push; q = q ?? { () };

(
// modulating formant frequency
~s4_formsing = { arg amp=0, root=150, formfrq=500, harm=20, fdev=2, ndiv = 0.2, formLag=0.1, round = 1.5; 
	var freqCompare = 1; // ((formfrq / root).log2).abs.min(1).linexp(0, 1, 0.25, 1);
	var in = Blip.ar(
		root.lag(formLag) * LFNoise0.kr(root * ndiv ! 2, fdev.max(0.01) ).midiratio, 
		harm.lag(formLag), // .max(formfrq / root * 0.25), 
		0.1
	) * GrayNoise.ar(0.1, 1);
	
	Limiter.ar(Formlet.ar(in, formfrq.lag(formLag), 0.005, 0.02) * (freqCompare * amp.lag(0.1)))
		.softclip;
};
~s4_formsing.play(vol: 0.5);
//	[ ~s4_formsing.clear ]
);

Spec.specs.put(\formfrq, ControlSpec(50, 5000, \exp));
Spec.specs.put(\root, ControlSpec(20, 500, \exp));
Spec.specs.put(\harm, ControlSpec(1, 256, \exp));
Spec.specs.put(\formLag, ControlSpec(0.01, 100, \exp));
Spec.add(\ndiv, [0.01, 1, \exp].asSpec);
Spec.add(\fdev, [0, 24, \amp].asSpec);

GamePad.putProxy(4, 
	\s4_formsing, 
	(			// add switch and lag later? 
		joyRY: { arg val, modState; 
		//	modState.postln; 
			if (modState.notNil and: { modState[\midL] }, { 
				~s4_formsing.group.set(\formLag, \formLag.asSpec.map(val)) 
			}, { 
				~s4_formsing.set(\amp, \amp.asSpec.map(val) ) 
			});
		}, 
		joyLX: { arg val; ~s4_formsing.set(\formfrq, \formfrq.asSpec.map(val)) },
		joyLY: { arg val; ~s4_formsing.set(\root, \root.asSpec.map(val)) },
		joyRX: { arg val; ~s4_formsing.set(\harm, \harm.asSpec.map(val)) },
		
		rHat: { arg val; 
				if (val == 0, { 	
					q[\formSDev] = (q[\formSDev] ? 0 + 1); 
					~s4_formsing.set(\fdev, 
						[0.04, 0.5, 7, 12, 24].foldAt(q[\formSDev]).postln) 
				});
			},
		lHat: { arg val; 
				if (val == 0, { 
					q[\formSNDiv] = (q[\formSNDiv] ? 0 + 1); 
					~s4_formsing.set(\ndiv, 
						[0.01, 0.03, 0.1, 0.3, 1].foldAt(q[\formSNDiv]).postln) 
				});
			}
		)
)
)
/*
~s4_formsing.vol_(1);
~s4_formsing.set(\fdev, 0.01);
*/