
a = InfluxMix();

(
w = Window("InfluxMix - 3 top xy sliders influence big XY", Rect(10, 10, 550, 400)).front;
w.addFlowLayout;
// EnvirGui(a.inValDict, 4, w);

[\srcA, \srcB, \srcC].collect { |srcName|

    var sl2d = Slider2D(w, 120@130).action_({ |sl, x, y|
        a.influence(*[srcName,
			\x, sl.x.unibi.round(0.001),
			\y, sl.y.unibi.round(0.001)].postln);
        b.setXY(a.outValDict[\x] + 1 * 0.5, a.outValDict[\y] + 1 * 0.5);
    }).setXY(0.5, 0.5);

    var slInf = EZSlider(w, 40@130, srcName, [0, 4, \amp].asSpec, { |sl|
        a.trusts.put(srcName, sl.value.postln); }, 1, layout: \vert);
	w.view.decorator.shift(20, 0);

    // sl.mouseDownAction = { ktl.startRec };
    // sl.mouseUpAction = { ktl.play };
};
b = Slider2D(w, 250@250).setXY(0.5, 0.5);
)

(
Ndef(\x, { |freq = 40, amp = 0.25, ffreq = 1000, reso = 5|
	RLPF.ar(Saw.ar(freq + [0.1, -0.1]), ffreq, 1/reso) * amp;
});
Ndef(\x).play;
Ndef(\x).addSpec(\freq, [20, 2000]);
Ndef(\x).addSpec(\ffreq, [200, 20000]);
Ndef(\x).addSpec(\reso, [1, 100, \exp]);
Ndef(\x).gui;
)

c = Influx(2, 5);
c.attachMapped(Ndef(\x), \setx, Ndef(\x).controlKeys);
InfluxKtlGui(c);

c.set(\x, 0.5.rand2);
a.add(\infl_C, { |infmix| c.set(*infmix.outValDict.asKeyValuePairs) });
a.influence(\srcA, \x, 0.0);

