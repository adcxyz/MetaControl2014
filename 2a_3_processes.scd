3 Kinds of Processes

Ndef - sound synthesis processes

Tdef - task, ||: wait, do something :||

Pdef - pattern (later ... )


Ndef(\a).play;

Ndef(\a, { Blip.ar }).play;

Ndef(\a, { Blip.ar(50) }).play;

Ndef(\a, { Blip.ar(50, 20) }).play;

Ndef(\a, { Blip.ar(\freq.kr(50), 20) }).play;

Ndef(\a).gui;

Ndef(\a, { Blip.ar(\freq.kr(50), \harm.kr(20)) }).play;

Ndef(\a).addSpec(\harm, [1, 100, \exp]);



/// more - detune, modulation, filter, ...

