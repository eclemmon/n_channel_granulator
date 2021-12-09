// Sequencer
(
var window, top_level, ctrl_panel_container, header, ctrl_panel_1, granulator_ctrl_panel, memory=~gm, buffer_size=5, num_grans=3;

// #############################
// Initialize Base Memory Values
// #############################

memory.atFail(\granulator_mem, {
	memory.put(\granulator_mem, Dictionary.newFrom([
		// Booleans for routing
		\reverb_on, false,
		// Granulator data for start up.
	]));
});

// ##################################
// Create objects for sound synthesis
// ##################################
num_grans.do({
	arg i;
	var name, val, prefix;
	~prefix = i+1;

	[\granAmp, 0.5,
		\granOut, 0,
		\granAttack, 0.1,
		\granRelease, 0.1,
		\granGate, 0,
		\granSync, 1,
		\granDensity, 40,
		\granBaseDur, 100,
		\granDurRand, 0.1,
		\granRate, 1,
		\granRateRand, 0.99,
		\granPan, 0,
		\granPanRand, 0.99,
		\granGrainEnv, -1,
		\granPtrSampleDelay, 10000,
		\granPtrRandSamples, 4000,
		\granMinPtrDelay, 2000,
		\granulator_on, false,
	].do({
		arg item, i;
		if(i.even, {
			name = ~build_control_name.value(~prefix, item);
		}, {
			val = item;
			memory.at(\granulator_mem).put(name.asSymbol, val);
		});
	});

	// Create a buffer
	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \buffer).asSymbol, Buffer.alloc(~server, ~server.sampleRate * buffer_size));

	// Initialize input and pointer buses for granulator control.
	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \inputBus).asSymbol, Bus.audio(~server, 1));
	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \ptrBus).asSymbol, Bus.audio(~server, 1));

});

// Initialize groups to organize order of execution on the scsynth side.
memory.at(\granulator_mem)
.put(\inputGroup, Group.new);
memory.at(\granulator_mem)
.put(\ptrGroup, Group.after(memory.at(\granulator_mem).at(\inputGroup)));
memory.at(\granulator_mem)
.put(\recGroup, Group.after(memory.at(\granulator_mem).at(\ptrGroup)));
memory.at(\granulator_mem)
.put(\granGroup, Group.after(memory.at(\granulator_mem).at(\recGroup)));

num_grans.do({
	arg i;
	~prefix = i + 1;
	// Initialize reverb
	memory.at(\granulator_mem)
	.put(~build_control_name.value(i, \reverb).asSymbol,
		Synth(\reverb, [\input, 90+i, \output, 0, \mix, 0.5, \room, 0.5, \damp, 0.5], memory.at(\granulator_mem).at(\granGroup)));

	// Initialize a router for buffer recording.
	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \soundInRouter).asSymbol, Synth(\soundInRouter,
		[\in, 0+i, \out,
			memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \inputBus).asSymbol)
		],
		memory.at(\granulator_mem).at(\inputGroup)));

	// Set a pointer synth to trail the record 'playhead'
	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \pointer).asSymbol, Synth(\pointer,
		[\buf, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \buffer).asSymbol),
			\out, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \ptrBus).asSymbol)], memory.at(\granulator_mem).at(\ptrGroup)));

	// Start a buffer recording synth
memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \sequencerRecord).asSymbol,
	Synth(\recordBuffer, [
		\ptrIn, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \ptrBus).asSymbol),
		\recIn, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \inputBus).asSymbol),
		\buf, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \buffer).asSymbol)
	], memory.at(\granulator_mem).at(\recGroup)));

	// Build Granulator
	/*~build_granulator.value(memory, ~prefix);*/
/*	memory.at(\granulator_mem).put(~build_control_name.value(~prefix, \granulator).asSymbol,
		Synth(\granulatorSequencer, [
			\amp, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granAmp).asSymbol),
			\out, 0,
			\buf, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \buffer).asSymbol),
			\attack, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granAttack).asSymbol),
			\release, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granRelease).asSymbol),
			\gate, 0,
			\sync, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granSync).asSymbol),
			\density, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granDensity).asSymbol),
			\baseDur, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granBaseDur).asSymbol),
			\durRand, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granDurRand).asSymbol),
			\rate, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granRate).asSymbol),
			\rateRand, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granRateRand).asSymbol),
			\pan, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granPan).asSymbol),
			\panRand, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granPanRand).asSymbol),
			\grainEnv, -1,
			\ptrBus, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granPtrBus).asSymbol),
			\ptrSampleDelay, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granPtrSampleDelay).asSymbol),
			\ptrRandSamples, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granPtrRandSamples).asSymbol),
			\minPtrDelay, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granMinPtrDelay).asSymbol)
		], memory.at(\granulator_mem).at(\granGroup))
	);*/

});
)
