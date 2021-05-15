(

(~bands[n].size - 1).do({
	arg item, i;
	~spats[i] = Synth(\spat, [\in, ~spatBus[i], \ctrlIn, ~ctrlBus[i]]);

});
(~bands[n].size - 1).do({
	arg item, i;
	~eqs = Synth(\eq, [\freqLo, ~bands[n][i], \freqHi, ~bands[n][i+1], \out, ~spatBus[i]]);

});
{
	x = Synth(\bufferWriting, [\run, 1, \in, ~inBus, \buf, ~buffer], addAction:'addToTail');
	0.01.wait;
	x.set(\run, 0);
	~buffer.normalize;
}.fork;

(~bands[n].size - 1).do({
	arg item, i;
	~ctrl = Synth(\bufferReading, [\rate, rrand(0.001, 0.005), \out, ~ctrlBus[i], \buf, ~buffer]);

});

x = Synth(\input, [\out, ~inBus]);
)
(
~reSample = {
	{
		x.set(\run, 1);
		0.01.wait;
		x.set(\run, 0);
	}.fork;
	~buffer.normalize;
};
)
~reSample.value()

~buffer.plot;