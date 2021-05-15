b = Buffer.read(s, "/Users/ste/Google Drive/Ste/Musica Elettronica/Soundfiles/05_MF_Harmonics.wav")

~bus = Bus.new(\control,0,7);

(
SynthDef(\analysis, {
	var sig;
	sig = PlayBuf.ar(2, b, loop:1);

	Out.kr(~bus, FluidSpectralShape.kr(sig).poll(0.1));
}).add;
)
(
w = Window("spectral Shape Monitor", Rect(10, 10, 220, 190)).front;

c = Array.fill(7, {arg i; StaticText(w, Rect(10, i * 25 + 10, 135, 20)).background_(Color.grey(0.7)).align_(\right)});
c[0].string = ("Centroid: ");
c[1].string = ("Spread: ");
c[2].string = ("Skewness: ");
c[3].string = ("Kurtosis: ");
c[4].string = ("Rolloff: ");
c[5].string = ("Flatness: ");
c[6].string = ("Crest: ");
a = Array.fill(7, {arg i;
    StaticText(w, Rect(150, i * 25 + 10, 60, 20)).background_(Color.grey(0.7)).align_(\center);
});
)

(
r = Routine {
    {

        ~bus.get({ arg val;
            {
                if(w.isClosed.not) {
                    val.do({arg item,index;
                        a[index].string = item.round(0.01)})
                }
            }.defer
        });

        0.01.wait;
    }.loop

}.play
)

Synth(\analysis)