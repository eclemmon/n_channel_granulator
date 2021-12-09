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


~build_control_name = {
	// A helper function that builds a control name according to the name defined.
	arg number, name;
	var str;
	str = name ++ "_" ++ number.asString;
	str;
};

~build_granulator = {
	arg memory, num;

	memory.at(\granulator_mem).put(~build_control_name.value(num, \granulator).asSymbol,
		Synth(\granulatorSequencer, [
			\amp, memory.at(\granulator_mem).at(~build_control_name.value(num, \granAmp).asSymbol),
			\out, 0,
			\buf, memory.at(\granulator_mem).at(~build_control_name.value(num, \buffer).asSymbol),
			\attack, memory.at(\granulator_mem).at(~build_control_name.value(num, \granAttack).asSymbol),
			\release, memory.at(\granulator_mem).at(~build_control_name.value(num, \granRelease).asSymbol),
			\gate, 1,
			\sync, memory.at(\granulator_mem).at(~build_control_name.value(num, \granSync).asSymbol),
			\density, memory.at(\granulator_mem).at(~build_control_name.value(num, \granDensity).asSymbol),
			\baseDur, memory.at(\granulator_mem).at(~build_control_name.value(num, \granBaseDur).asSymbol),
			\durRand, memory.at(\granulator_mem).at(~build_control_name.value(num, \granDurRand).asSymbol),
			\rate, memory.at(\granulator_mem).at(~build_control_name.value(num, \granRate).asSymbol),
			\rateRand, memory.at(\granulator_mem).at(~build_control_name.value(num, \granRateRand).asSymbol),
			\pan, memory.at(\granulator_mem).at(~build_control_name.value(num, \granPan).asSymbol),
			\panRand, memory.at(\granulator_mem).at(~build_control_name.value(num, \granPanRand).asSymbol),
			\grainEnv, -1,
			\ptrBus, memory.at(\granulator_mem).at(~build_control_name.value(num, \granPtrBus).asSymbol),
			\ptrSampleDelay, memory.at(\granulator_mem).at(~build_control_name.value(num, \granPtrSampleDelay).asSymbol),
			\ptrRandSamples, memory.at(\granulator_mem).at(~build_control_name.value(num, \granPtrRandSamples).asSymbol),
			\minPtrDelay, memory.at(\granulator_mem).at(~build_control_name.value(num, \granMinPtrDelay).asSymbol)
		], memory.at(\granulator_mem).at(\granGroup))
	);

};

)

