(

(~bands[n].size - 1).do({
	arg item, i;
	~spats[i] = Synth(\spat, [\in, ~spatBus[i], \ctrlIn, ~ctrlBus[i], \amp, 1]);
});
(~bands[n].size - 1).do({
	arg item, i;
	~eqs[i] = Synth(\eq, [\freqLo, ~bands[n][i], \freqHi, ~bands[n][i+1], \out, ~spatBus[i]]);

});
//first start
{
	x = Synth(\firstStartBuf, [\run, 1, \buf, ~buffer], addAction:'addToTail');
	0.01.wait;
	x.free;
	~buffer.normalize;
}.fork;

(~bands[n].size - 1).do({
	arg item, i;
	~ctrls[i] = Synth(\bufferReading, [\rate, rrand(0.0001, 0.05), \out, ~ctrlBus[i], \buf, ~buffer], addAction:'addToTail');

});

x = Synth(\input, [\out, ~inBus]);
)

~buffer.plot;

(
~reSample = {
	x = Synth(\bufferWriting, [\run, 1, \in, ~inBus, \buf, ~buffer], addAction:'addToTail');
	0.01.wait;
	x.free;
	~buffer.normalize;
}.fork;
)
(
(~bands[n].size - 1).do({
	arg item, i;
	~ctrls[i].set(\rate, rrand(0.001, 0.1));

});
)