/*
~basepath = Document.current.dir ++"/";
~exec = { |p| this.executeFile(~basepath++p); };
*/

s = Server.internal;
s.options.outputStreamsEnabled = "11";
s.options.inputStreamsEnabled = "11";

s.waitForBoot{
	
	~exec.value('../cotccm_lib/synthdefs.scd');
	
	~ezv_in = 0;
	~chain_in = 1;
	~amp0_out = 0;
	
	
	~in_g = Group.head(s);
	~proc_g = Group.after(~in_g);
	~out_g = Group.after(~proc_g);
	
	// input busses
	~ezv_b = Bus.audio(s, 1);
	~chain_b = Bus.audio(s, 1);
	
	// output busses
	~amp0_b = Bus.audio(s, 1);
	
	// patch synths to synth busses
	~ezv_in = {Out.ar(~ezv_b.index, SoundIn.ar(~ezv_in))}.play(~in_g, \addToTail);
	~chain_in = {Out.ar(~chain_b.index, SoundIn.ar(~chain_in))}.play(~in_g, \addToTail);
	
	/// patch synth busses to output
	~ezv_in = {Out.ar(~amp0_b.index, In.ar(~ezv_b.index))}.play(~proc_g, \addBefore);
	~chain_in = {Out.ar(~amp0_b.index, In.ar(~chain_b.index))}.play(~proc_g, \addBefore);
	
	
	
	~amp0_out = {Out.ar(~amp0_out, In.ar(~amp0_b.index))}.play(~out_g, \addToHead);
	
	~amp0_limit = Synth.new(\limit_insert, [\bus, ~amp0_b.index], ~proc_g, \addToTail);
	~amp0_limit.set(\limthresh, -6.dbamp);
};