~synthdefs = Main.packages.asDict.at('KloudGen') +/+ "examples/synthdefs.scd";
~synthdefs.load();
KloudGen
(
Pdef(\cloudpat1, 
	Pbind(
		\instrument, Pseq([\cloud,\appearance],inf), 
		// \dur, Pseg([0.25,8.0], Pwhite(4,128), \exp, inf), 
		\dur, Pwhite(0.1,0.25),
		\legato, 0,
		\attack, Pwhite(0.001,1.0), 
		\release, 1 - Pkey(\attack), 
		\gdur, Pseg(Pseq([0.25,0.01],inf), Pwhite(4,16), \exp, inf), 
		\amp, 1, 
		\density, 0.90, 
		\diffuse,0.1,
		\shape, 0,
		\posspread, 0.5,
		\pos, 0.35,
		\rand, 0.9,
		\rate, Pwhite(0.5,0.9)
	)
).play
)
