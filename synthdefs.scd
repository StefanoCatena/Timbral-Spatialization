(
Buffer.freeAll;
{
	//insert whatever audio file you want to use here
	//~buf = Buffer.read(s, "/Volumes/HD1/Johnatan Prajer/1_Dufour_Terra Incognita (1).aif");
	~buf = Buffer.read(s, "/Users/ste/Downloads/LUA_nuova_cura.wav");

	s.sync;
	~bands = [ //different types of equalizations
		[22, 88, 177, 335, 710, 1240, 2840, 5680, 11360, 20000], //all about audio eq
		[29, 61, 115, 218, 411, 777, 1500, 2800, 5200, 11000, 20000], //resonant EQ
		[10, 100, 1000, 10000, 20000],
		[31, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000], //API - 560 EQ grafico
	];
	n = 3;
	~binDec = FoaDecoderKernel.newCIPIC(3, s, 44100);
   	s.sync;

	~inBus = Bus.audio(s, 2);
	~ctrlBus = ~bands[n].size.collect({arg i; Bus.control(s, 3)});
	~spatBus = ~bands[n].size.collect({arg i; Bus.audio(s, 1)});
	~eqs = Array.newClear(~bands[n].size);
	~ctrls = Array.newClear(~bands[n].size);
	~spats = Array.newClear(~bands[n].size);
	0.2.wait;

	SynthDef(\input, {
		arg out;
		var sig;
		sig = PlayBuf.ar(2, ~buf, 1, loop:1);
		//sig = WhiteNoise.ar(0.2);
		//sig = Mix.ar([SoundIn.ar(0), SoundIn.ar(1)]);
		Out.ar(out, sig);
	}).add;

	SynthDef(\eq, {
		arg freqHi, freqLo, out;
		var sig, eq;
		sig = In.ar(~inBus, 2);
		eq = RLPF.ar(RHPF.ar(Mix.ar(sig), freqLo, 0.9), freqHi, 0.9);
		Out.ar(out, eq);
	}).add;

	SynthDef(\spat, {
		arg in, ctrlIn, amp;
		var enc, dec, sig, pol, out, rev, del, inData;
		//x, y, d
		inData = Lag.kr(In.kr(ctrlIn, 3), 0.5);
		d = inData[2].range(1, 5);
		pol = Cartesian.new(inData[0], inData[1]).mirrorY;
		sig = In.ar(in);
		enc = FoaPanB.ar(sig, pol.angles);
		dec = FoaDecode.ar(enc, ~binDec);
		rev = FreeVerb.ar(dec / d, 1, 0.8);
		Out.ar(0, ((dec / d) + rev)*amp);
	}).add;

	~buffer = Buffer.alloc(s, 256);
	SynthDef(\firstStartBuf, {
		arg in, run = 0, buf;
		var src;
		//src = In.ar(in, 1);
		src = PlayBuf.ar(1, ~buf, 1, 1, startPos:rrand(0, ~buf.numFrames), loop:1);
		RecordBuf.ar(src, buf, run:run);
	}).add;

	SynthDef(\bufferWriting, {
		arg in, run = 0, buf;
		var src;
		src = In.ar(in, 1);
		//src = PlayBuf.ar(1, ~buf, loop:1);
		RecordBuf.ar(src, buf, run:run);
	}).add;

	SynthDef(\bufferReading, {
		arg rate, out, buf;
		var x, y, d;
		x = PlayBuf.kr(1, buf, rate, startPos: rand(BufFrames.kr(buf)), loop:1);
		y = PlayBuf.kr(1, buf, rate, startPos: rand(BufFrames.kr(buf)), loop:1);
		d = PlayBuf.kr(1, buf, rate, startPos: rand(BufFrames.kr(buf)), loop:1);
		Out.kr(out, [x, y, d]);
	}).add;
}.fork;
)
//all about audio equalization solutions and frontiers


