// TouchOSC: layout: "simple".

// do the tricky setup: pairing with my NetAddr 
// or IP 255.255.255.255, langPort MUST be 57120

(
q.touchOscNdef = q.ndefs[0].postcs;		// var goal
q.touchOscNdefs = List.newClear;	q.touchOscNdefs.add(q.ndefs[0]);
q.accelScale = 0.8;

q.t_o_Acc_Resp.remove;
q.t_o_Acc_Resp = OSCresponder(nil, "accxyz", { |t, resp, msg|  
	q.coordsMSA = (msg[[1,2,3]] * q.accelScale * 0.5 + 0.5 ).clip(0,1); 	// globalize the 3 relevant vars
//	q.coordsMSA.postln;
	q.coordsMSA.do({|val, i|
 		q.touchOscNdefs.do({|ndef, j| // set poly
			var parKey = ndef.getKeysValues[i][0];
			ndef.set(parKey, parKey.asSpec.map(val))
 		})
	})	
}).add;
);

// later: 
// use 4 buttons to switch between 4 ndefs: 	page 1, 4 buttons on bottom

q.t_o_butt_Resp1.remove;	q.t_o_butt_Resp1 = OSCresponder(nil, "/1/toggle1", { |t, resp, msg|  
	if(msg[1]>0){	q.touchOscNdefs.add(q.ndefs[0]); }{ q.touchOscNdefs.remove(q.ndefs[0]);}
}).add;
q.t_o_butt_Resp2.remove;	q.t_o_butt_Resp2 = OSCresponder(nil, "/1/toggle2", { |t, resp, msg|  
	if(msg[1]>0){	q.touchOscNdefs.add(q.ndefs[1]); }{ q.touchOscNdefs.remove(q.ndefs[1]);}
}).add;
q.t_o_butt_Resp3.remove;	q.t_o_butt_Resp3 = OSCresponder(nil, "/1/toggle3", { |t, resp, msg|  
	if(msg[1]>0){	q.touchOscNdefs.add(q.ndefs[2]); }{ q.touchOscNdefs.remove(q.ndefs[2]);}
}).add;
q.t_o_butt_Resp4.remove;	q.t_o_butt_Resp4 = OSCresponder(nil, "/1/toggle4", { |t, resp, msg|  
	if(msg[1]>0){	q.touchOscNdefs.add(q.ndefs[3]); }{ q.touchOscNdefs.remove(q.ndefs[3]);}
}).add;
q.touchOscNdefs.do({|p|p.key.postln});\;


