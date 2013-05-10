
~bbuf = Buffer.readChannel(s, "/home/emb/sc/bbbcch.wav", channels:[0]);
~bbuf.plot;

~bbuf.normalize(-12.dbamp);

~bbuf.peak

~gr.do({ arg gr; gr.kill; });

t = SystemClock.seconds;
t = SystemClock.seconds - t;

