(
s.waitForBoot{
	// Test it out
	~path = Main.packages.asDict.at('KloudGen') +/+ "examples/sound/harmshort.wav";
	b = b ?? { Buffer.read(s, ~path.asAbsolutePath )};

	// A very straight forward cloud synth
	SynthDef(\cloud, { 
		arg out=0, 
		dur=1, 
		attack=0.1,
		release=0.9,
		legato=0,
		amp=0.75,
		gdur=0.1, 
		buffer, 
		diffuse=0.1, 
		density=0.75, 
		rate=1.0, 
		shape=0.0, 
		ratespread=0, 
		pos=0.5, 
		posspread=0.1, 
		rand=0.25, 
		overlap=0;

		var sig = KloudGen2.ar(
			gdur, 
			buffer, 
			2, 
			diffuse, 
			density, 
			rate, 
			shape, 
			ratespread, 
			pos, 
			posspread, 
			rand, 
			overlap, 
			1.0
		);

		var env = EnvGen.kr(
			Env.perc(attack, release),  
			gate: 1.0,  
			timeScale: dur * (legato+1),  
			doneAction: 2
		);

		sig = sig * env;
		sig = sig * amp;

		Out.ar(out, sig)

	}).add;

	// Same as above but with envelope modulating some of the cloud parameters
	SynthDef(\appearance, { 
		arg out=0, 
		dur=1, 
		attack=0.1,
		release=0.9,
		legato=0,
		amp=0.75,
		gdur=0.1, 
		buffer, 
		diffuse=0.1, 
		density=0.75, 
		rate=1.0, 
		shape=0.0, 
		ratespread=0, 
		pos=0.5, 
		posspread=0.1, 
		rand=0.25, 
		overlap=0;

		var env = EnvGen.kr(
			Env.perc(attack, release),  
			gate: 1.0,  
			timeScale: dur * (legato+1),  
			doneAction: 2
		);

		var sig = KloudGen2.ar(
			env.linlin(0.0,1.0,gdur/2, gdur), 
			buffer, 
			2, 
			env.lag2 * diffuse, 
			env.lag3.linlin(0.0,1.0, density/2, density),
			rate, 
			shape, 
			ratespread, 
			pos, 
			posspread, 
			rand, 
			overlap, 
			1.0
		);

		sig = sig * env;
		sig = sig * amp;

		Out.ar(out, sig)

	}).add;
}
)
// Test:
// (
// Synth(\cloud, [\dur, 8.0, \gdur, rrand(0.01,0.1), \buffer, b, \rate, rrand(0.5,1.0), \density, 0.85]);

// Synth(\appearance, [\dur, 18.0, \gdur, rrand(0.1,0.2), \buffer, b, \rate, rrand(0.5,0.95), \density, 0.95, \diffuse, 0.15, \posspread, 0.5, \rand, 0.01, \overlap, 0.25, \shape, 0.9]);
// )
