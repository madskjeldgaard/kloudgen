// Stereo output
KloudGen2 {
	classvar numGrains=4;

	*ar{|gdur=0.1, buffer, buffernumchans=2, diffuse=0.5, density=1.0, rate=0.95, shape=0.5, ratespread=0.0, pos=0.25, posspread=0.0, rand=1.0, overlap=0.0, amp=0.5|
		var cloud;

		// Normalize params
		density = density.linexp(0.0,1.0,0.0001,100.0);
		rate = rate.linexp(0.0,1.0,0.01,10.0);

		cloud = Array.fill(numGrains, {|gNum|
			var coef=gNum+1/numGrains;

			// Add tiny difference to each grain generator
			var weight = Rand(0.9999,1.0);

			var finalgdur = gdur * weight * overlap.linlin(0.0,1.0,1.0,4.0);

			// Triggers are created by crossfading between deterministic and stochastic impulses
			// Crossfading is done directly on the frequency parameters of both

			// Deterministic
			var imp = Impulse.ar(density * (1-rand), phase: coef);

			// Random impulses
			var dust = Dust.ar(density * rand);

			// var trig = LinXFade2.ar(imp, dust, rand.linlin(0.0,1.0,-1.0,1.0));
			var trig = Mix.ar([imp , dust]);

			// Grain envelope
			var sineenv = EnvGen.ar(
				Env.sine, 
				trig, 
				timeScale: finalgdur
			);

			var clickenv = EnvGen.ar(
				Env([0,1,1,0], [0,1,0]), 
				trig, 
				timeScale: finalgdur
			);

			var env = XFade2.ar(sineenv, clickenv, shape.linlin(0.0,1.0,-1.0,1.0));

			// Calculate position in buffer
			var position = (weight * pos + (posspread * coef)).wrap(0.0,1.0) * BufFrames.ir(buffer);

			// Calculate playback rate
			// var randrate = rate * LFNoise1.ar(density*rate).linlin(-1.0,1.0,(1.0-diffuse).poll,1.0+diffuse);
			var randrate = rate * TRand.ar(lo: 1.0 - diffuse, hi: 1.0+diffuse, trig: trig);
			// var randrate = rate * TRand.kr(
			// 	lo: 1.0, 
			// 	hi: 1.0+diffuse, 
			// 	trig: trig
			// );
			var playbackrate =  weight * BufRateScale.kr(buffer) * randrate; 
			var sig = PlayBuf.ar(
				buffernumchans, 
				buffer, 
				ratespread * (gNum + 1) + 1 * playbackrate, 
				trig, 
				position,  
				loop: 0.0,  
				doneAction: 0
			);

			env * sig
		});

		// Normalize sound levels a bit
		cloud = cloud / numGrains;
		cloud = cloud * amp;
		
		// Pass cloud into panning function
		cloud = SynthDef.wrap(this.panFunction, prependArgs: [cloud]);

		^LeakDC.ar(cloud).poll
	}

	*panFunction{
		^{|in, stereospread=1, balance=0|
			Splay.ar(in.flatten, spread:stereospread, center: balance)
		}
	}
}

// Mono
KloudGen1 : KloudGen2{
	*panFunction{
		^{|in|
			Mix.ar(in.sum)/in.size
		}

	}
}

// Multichannel Azimuth
KloudGenAz : KloudGen2{
	classvar numGrains = 8; // Increase number of grains, just in case

	*panFunction{
		^{|in, numchans=4, center=0, width=1.5, orientation=0.5, spatialspread=1|
			SplayAz.ar(
				numChans: 4, // TODO: This only works if set manually. If the numchans argument is passed in here, I get an indexing error. Why
				inArray: in, 
				// spread: spatialspread, 
				// width: width, 
				// center: center, 
				// orientation: orientation,  
				// levelComp: true
			);
		}

	}
}
