a = Influx([\x, \y, \z], [\a, \b, \c, \d, \e]);
w = Window("Influx 3 x 5", Rect(0,0,400,400)).front;
u = UserView(w, Rect(0,0,400,400));
u.background_(Color.grey(0.2));
u.resize_(5);

InfluxWGui(a);

(
u.drawFunc = { |view|
	var inpoints, outpoints, trapeze;
	var ubounds, scalex, scaley;
	var handlePoints;
	
	ubounds = view.bounds;
	scalex = view.bounds.width / 400;
	scaley = view.bounds.height / 400;
	Pen.scale(scalex, scaley);

	Pen.color_(Color.white);
	Pen.font_(Font("Arial", 20));
	inpoints = a.inNames.collect { |name, i|
		var pt = 50@(i * 100 + 100);
		Pen.addArc(pt, 20, 0, 2pi);
		Pen.stringCenteredIn(name.asString, Rect.aboutPoint(pt, 10, 10));
		pt
	};
	outpoints = a.outNames.collect { |name, i|
		var pt = 350@(i * 70 + 60);
		Pen.addArc(pt, 20, 0, 2pi);
		Pen.stringCenteredIn(name.asString, Rect.aboutPoint(pt, 10, 10));
		pt
	};

	trapeze = [
		inpoints.first - (30@30),
		inpoints.last  + (-30@30),
		outpoints.last + (30@30),
		outpoints.first + (30@ -30)
	].wrapExtend(5);
	trapeze.doAdjacentPairs {|p1, p2| Pen.line(p1, p2) };

	Pen.stroke;

	handlePoints = inpoints.collect { |pti, i|
		outpoints.collect { |pto, o|
			var weight = a.weights[o][i];
			var hue = if (weight > 0, 0.08, 0.58);
			var sat = weight.abs;
			var handlePt = blend(pti, pto, (weight + 1 * 0.5).asPoint);
			
			Pen.width_((weight.abs * 10));
			Pen.color_(Color.hsv(hue, sat, 1, 0.8));
			Pen.line(
				blend(pti, pto, 0.06.asPoint),
				blend(pti, pto, 0.94.asPoint)
			);
			Pen.stroke;
			Pen.width_(2);
			Pen.color_(Color.white);
			Pen.addArc(handlePt, 5, 0, 2pi);
			Pen.stroke;
		}
	};
};
u.animate_(true);
w.refresh;
)
