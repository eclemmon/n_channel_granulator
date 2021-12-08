(
// TODO: Abstract many of the setter functions into a single function that constructs their setter keys in memory via automatic camel casing.

~set_granulator_by_name_control_key = {
	arg memory, name_space, name, number, value;
	var control_key, granulator_name;
	// Build names
	control_key = ~create_control_key.value(name, number);
	granulator_name = ~build_control_name.value(number, \granulator);
	granulator_name.postln;
	// Store Value to Memory
	memory.at(name_space.asSymbol).put(control_key.asSymbol, value);
	memory.at(name_space.asSymbol).at(control_key.asSymbol).postln;
	// Set the synth to value from memory
	memory.at(name_space.asSymbol).at(granulator_name.asSymbol).set(name.asSymbol, memory.at(name_space.asSymbol).at(control_key.asSymbol));
};

~create_control_key = {
	arg name, number;
	name = name[0].toUpper ++ name[1..];
	name = "gran" ++ name;
	name = ~build_control_name.value(number, name);
};

~turn_granulator_off = {
	// Turns the granulator off and sets the instrument in memory to nil, so that errors pass gracefully.
	arg memory;
	memory.at(\seq_mem).at(\granulatorSequencer).set(\gate, 0);
	memory.at(\seq_mem).put(\granulatorSequencer, nil)
};


~set_granulator_out = {
	// Sets the out channel of the granulator.
	arg memory, val;
	memory.at(\seq_mem).put(\granOut, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\out, memory.at(\seq_mem).at(\granOut));
};

~set_granulator_attack = {
	// Sets the attack time of the granulator synth. Not really used.
	arg memory, val;
	memory.at(\seq_mem).put(\granAttack, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\attack, memory.at(\seq_mem).at(\granAttack));
};

~set_granulator_release = {
	// Sets the release time of the granulator synth. Not really used.
	arg memory, val;
	memory.at(\seq_mem).put(\granRelease, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\release, memory.at(\seq_mem).at(\granRelease));
};

~set_granulator_sync = {
	// Sets the sync of the granulator synth.
	arg memory, val;
	memory.at(\seq_mem).put(\granSync, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\sync, memory.at(\seq_mem).at(\granSync));
};

~set_granulator_density = {
	// sets the density value of the granulator synth.
	arg memory, val;
	memory.at(\seq_mem).put(\granDensity, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\density, memory.at(\seq_mem).at(\granDensity));
};

~set_granulator_base_duration = {
	// Sets the base duration of the grains.
	arg memory, val;
	memory.at(\seq_mem).put(\granBaseDur, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\baseDur, memory.at(\seq_mem).at(\granBaseDur));
};

~set_granulator_duration_randomization = {
	// Sets the amount of randomization on the length of the grains. So baseDur ± whitenoise * durRand.
	arg memory, val;
	memory.at(\seq_mem).put(\granDurRand, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\durRand, memory.at(\seq_mem).at(\granDurRand));
};

~set_granulator_rate = {
	// Sets the play back rate of the grains. Higher value means quicker playback and therefore higher pitched grains and vice versa.
	arg memory, val;
	memory.at(\seq_mem).put(\granRate, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\rate, memory.at(\seq_mem).at(\granRate));
};

~set_granulator_rate_randomization = {
	// Sets the randomization of the playback rate of the grains. So granRate ± whitenoise * granRateRand.
	arg memory, val;
	memory.at(\seq_mem).put(\granRateRand, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\rateRand, memory.at(\seq_mem).at(\granRateRand));
};

~set_granulator_pan = {
	// Sets the pan of the granulator, left/right
	arg memory, val;
	memory.at(\seq_mem).put(\granPan, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\pan, memory.at(\seq_mem).at(\granPan));
};

~set_granulator_pan_randomization = {
	// Sets the randomization of grain outputs. Each grain is output according to its own poll.
	arg memory, val;
	memory.at(\seq_mem).put(\granPanRand, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\panRand, memory.at(\seq_mem).at(\granPanRand));
};

~set_granulator_grain_envelope = {
	// Sets the grain envelope. Not really used as the built-in Han envelope is good enough.
	arg memory, val;
	memory.at(\seq_mem).put(\granGrainEnv, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\grainEnv, memory.at(\seq_mem).at(\granGrainEnv));
};

~set_granulator_pointer_sample_delay = {
	// Sets the number of samples behind the recording "playhead" the grain buffer pointer is.
	arg memory, val;
	memory.at(\seq_mem).put(\granPtrSampleDelay, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\ptrSampleDelay, memory.at(\seq_mem).at(\granPtrSampleDelay));
};

~set_granulator_pointer_sample_randomization = {
	// Sets the randomization of the number of samples behind the recording "playhead" the grain buffer pointer is.
	arg memory, val;
	memory.at(\seq_mem).put(\granPtrRandSamples, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\ptrRandSamples, memory.at(\seq_mem).at(\granPtrRandSamples));
};

~set_granulator_minimum_pointer_delay = {
	// Sets the minimum pointer delay behind the "playhead" of the record buffer.
	arg memory, val;
	memory.at(\seq_mem).put(\granMinPtrDelay, val);
	memory.at(\seq_mem).at(\granulatorSequencer).set(\minPtrDelay, memory.at(\seq_mem).at(\granMinPtrDelay));
};

~build_control_name = {
	// A helper function that builds a control name according to the name defined.
	arg number, name;
	var str;
	str = name ++ "_" ++ number.asString;
	str;
};

)

