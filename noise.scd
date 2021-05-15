(
//NOISE TECHNIQUES
SynthDef(\noise0, {
	arg out, freq;
	Out.kr(out,
		[
			LFNoise0.kr(freq).range(-1, 1),
			LFNoise0.kr(freq).range(-1, 1),
			LFNoise0.kr(freq).range(-1, 1)
	]);
}).add;
SynthDef(\brownian, {
	arg out, freq;
	Out.kr(out,
		[
			//nesting Noise!
			LFBrownNoise2.kr(LFNoise0.kr(freq).range(1, 10), 1, 1),
			LFBrownNoise2.kr(LFNoise0.kr(freq).range(1, 10), 1, 1),
			LFBrownNoise2.kr(LFNoise0.kr(freq).range(1, 10), 1, 1)
	]);
}).add;

)


(

(~bands[n].size - 1).do({
	arg item, i;
	~spats[i] = Synth(\spat, [\in, ~spatBus[i], \ctrlIn, ~ctrlBus[i]]);
});
(~bands[n].size - 1).do({
	arg item, i;
	~eqs = Synth(\eq, [\freqLo, ~bands[n][i], \freqHi, ~bands[n][i+1], \out, ~spatBus[i]]);

});

(~bands[n].size - 1).do({
	arg item, i;
	~ctrls[i] = Synth(\brownian, [\out, ~ctrlBus[i], \freq, rrand(1, 4)], addAction:'addToTail');

});

x = Synth(\input, [\out, ~inBus]);
)

(~bands[n].size - 1).do({
	arg item, i;
	~ctrls[i].set(\freq, rrand(0.5, 5))

});

{ LFBrownNoise1.kr(10, 1, 1).plot }.play;
