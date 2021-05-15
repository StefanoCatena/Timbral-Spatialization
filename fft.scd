(
SynthDef(\fft_brownian, {
	arg in, out;
	var sig, buf, fft, specC, specP, specF;
	buf = LocalBuf(1024, 2);
	sig = In.ar(in, 2);
	//sig = Saw.ar(MouseX.kr(20, 20000));
	fft = FFT(buf, sig);

	specC = LinLin.kr(SpecCentroid.kr(fft), 20, 20000, 0.0, 1.0);
	specP = LinLin.kr(SpecPcile.kr(fft, 0.9), 20, 20000, 0.0, 5.0);
	specF = LinExp.kr(SpecFlatness.kr(fft), 0.0, 1.0, 5.0, 20.0);

	Out.kr(out,
		[
			LFBrownNoise2.kr(specF, specC, 0),
			LFBrownNoise2.kr(specF, specC, 0),
			specP
	]);
}).add;
)

(

(~bands[n].size - 1).do({
	arg item, i;
	~spats[i] = Synth(\spat, [\in, ~spatBus[i], \ctrlIn, ~ctrlBus[i], \amp, 9.dbamp]);

});

(~bands[n].size - 1).do({
	arg item, i;
	~ctrls[i] = Synth(\fft_brownian, [\in, ~inBus, \out, ~ctrlBus[i]]);
});

(~bands[n].size - 1).do({
	arg item, i;
	~eqs[i] = Synth(\eq, [\freqLo, ~bands[n][i], \freqHi, ~bands[n][i+1], \out, ~spatBus[i]]);

});

x = Synth(\input, [\out, ~inBus]);
)

(
{
	inf.do({
		(~bands[n].size - 1).do({
			arg item, i;
			~ctrlBus[i].get({
				arg msg;
				msg.postln;
			});
			0.25.wait;
		});
	});
}.fork;
)
