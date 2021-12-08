//// GUI CONSTRUCTOR
(
~build_window = {
	// Builds the main window that contains everything
	arg window_title, style, width, height;
	Window(window_title, Rect(10, 10, width, height))
	.background_(style.at("window_color"))
	.front;
};

~build_top_level = {
	// Buildts a top level composite view that manages child views' spacing.
	arg window, width, height, style;
	var compView = CompositeView(window, Rect(10, 10, width, height))
	.background_(style.at("top_level_frame_color"));
	compView.addFlowLayout(10@10);
	compView.decorator.gap_(0@10);
	compView;
};

~build_sequencer_header = {
	// Builds a header frame with a static text box with the title of the window
	arg top, hwidth, hheight, style, string;
	var guiTitle;
	guiTitle = StaticText(top, Rect(10, 10, hwidth, hheight));
	guiTitle.string = string;
	guiTitle.background = style.at("header_frame_color");
	guiTitle.font = style.at("header_font");
	guiTitle.align = \center;
	top.decorator.nextLine;
	guiTitle;
};

~build_track_buttons_container = {
	// Builds a frame to contain and organize the track and the stack of buttons.
	arg top_level, width, height, style;
	var compView = CompositeView(top_level, Rect(0, 0, width, height))
	.background_(style.at("top_level_frame_color"));
	compView.addFlowLayout(0@0);
	compView.decorator.gap_(0@0);
	compView;
};

~build_sequencer_control_panel_2 = {
	// Builds the control panel 2 for the sequencer
	arg top, hwidth, hheight, style, buttonsize, memory, stacked_buttons, reverb, track;
	var control2CompView, octaveLabel, minusOctBut, plusOctBut, quantLabel, quantSlider, quantNumberBox, mixKnob, roomKnob, dampKnob, reverbButton, outDevices, inDevices, inDevicesSelector, outDevicesSelector, outDevice, inDevice, inDevicesSelectorText, outDevicesSelectorText;

	// Control Comp View 2
	control2CompView = CompositeView(top, Rect(0, 0, hwidth, hheight));
	control2CompView.background = style.at("bank_frame_color");
	control2CompView.addFlowLayout(10@10);
	control2CompView.decorator.gap_(10@10);

	control2CompView.decorator.nextLine;

	// QUANTIZATION SLIDER NUMBER BOX
	quantNumberBox =  NumberBox(control2CompView, Rect(0, 20, 40, 30));
	quantNumberBox.value = 0;

	// REVERB BUTTON ON/OFF
	reverbButton = Button(control2CompView, 170@30)
	.states_([["Turn Reverb On", Color.white, style.at("text_color")], ["Turn Reverb Off", Color.white, Color.red]])
	.action_({
		if (reverbButton.value == 1, {
			// Set Granulator Splitter out2 to 99
			// Set granulator out to reverb
			memory.at(\seq_mem).put(\reverb_on, true);
			memory.at(\seq_mem).at(\granulatorSplitter).set(\out2, 99);
			memory.at(\seq_mem).at(\granulatorSequencer).set(\out, 99);
		}, {
			// Set splitter and granulator out to main
			memory.at(\seq_mem).at(\granulatorSplitter).set(\out2, 0);
			memory.at(\seq_mem).at(\granulatorSequencer).set(\out, 0);
			memory.at(\seq_mem).put(\reverb_on, false);
		});
	});

	// REVERB LABELS
	["Mix", "Room", "Damp"].do({
		arg item, i;
		var label;
		label = StaticText(control2CompView, Rect(0, 0, 170-20/3, 30))
		.string_(item)
		.font_(style.at("text_font"))
		.align_(\center);
		label.background = style.at("bank_frame_color");
	});

	// REVERB CONTROL KNOBS
	mixKnob = Knob.new(control2CompView, Rect(0, 0, 170-20/3, 170-20/3));
	mixKnob.mode =\vert;
	mixKnob.value = 0.5;
	mixKnob.action_({
		reverb.set(\mix, mixKnob.value);
	});

	roomKnob = Knob.new(control2CompView, Rect(0, 0, 170-20/3, 170-20/3));
	roomKnob.mode =\vert;
	roomKnob.value = 0.5;
	roomKnob.action_({
		reverb.set(\room, roomKnob.value);
	});

	dampKnob = Knob.new(control2CompView, Rect(0, 0, 170-20/3, 170-20/3));
	dampKnob.mode =\vert;
	dampKnob.value = 0.5;
	dampKnob.action_({
		reverb.set(\damp, dampKnob.value);
	});

	// In and Out Selectors
	// Probably will be depreciated or moved to a boot gui that sets the options
	// for users in an easier manner. Currently do nothing unless the
	// user stops the scsynth server and boots it again.
	inDevicesSelectorText = StaticText(control2CompView, 170/3@30)
	.string_("In")
	.stringColor_(Color.white)
	.background_(style.at("window_color"))
	.align_(\center);

	inDevicesSelector = PopUpMenu(control2CompView, (170/3*2-10)@30)
	.items_(inDevices)
	.action_({arg deviceName;
		deviceName.item.postln;
		Server.default.options.inDevice = deviceName.item;
	});

	outDevicesSelectorText = StaticText(control2CompView, 170/3@30)
	.string_("Out")
	.stringColor_(Color.white)
	.background_(style.at("window_color"))
	.align_(\center);

	outDevicesSelector = PopUpMenu(control2CompView, (170/3*2-10)@30)
	.items_(outDevices)
	.action_({arg deviceName;
		deviceName.item.postln;
		Server.default.options.outDevice = deviceName.item;
	});

	control2CompView;
};

~build_sequencer_control_panel_3 = {
	// Builds the control panel 3 for the sequencer
	arg top, hwidth, hheight, columns, style, memory, granulator, granulator_num;
	var control3CompView, granulatorLabel, granulatorOnButton, ampKnob, grainDensityKnob, grainBaseDurKnob, durRandKnob, grainRateKnob, grainRateRandKnob, grainPanKnob, grainPanRandKnob, grainPtrDelayKnob, grainPtrDelayRandKnob, grainMinPtrDelayKnob, blackHoleSeqButton;

	// Control Comp View 3
	control3CompView = CompositeView(top, Rect(0, 0, hwidth, hheight));
	control3CompView.background = style.at("bank_frame_color");
	control3CompView.addFlowLayout(10@10);
	control3CompView.decorator.gap_(10@5);

	// Granulator Label
	granulatorLabel = StaticText(control3CompView, Rect(0, 0, hwidth-20, 30))
	.string_("Granulator")
	.font_(style.at("text_font"))
	.align_(\center);
	granulatorLabel.background = style.at("window_color");
	granulatorLabel.stringColor = Color.white;

	// Granulatory Button On/Off
	granulatorOnButton = Button(control3CompView, Rect(0, 0, hwidth-20, 30))
	.states_([["Turn Granulator On", Color.white, style.at("text_color")], ["Turn Granulator Off", Color.white, Color.red]])
	.action_({
		if (granulatorOnButton.value == 1, {
			if (memory.at(\seq_mem).at(\reverb_on), {
				// Set granulator out to bus 99
				memory.at(\seq_mem).put(\granOut, 99);
				// Turn Granulator On
				~turn_granulator_on.value(memory);
			}, {
				// else send granulator to main out
				memory.at(\seq_mem).put(\granOut, 0);
				~turn_granulator_on.value(memory);
			});
			// Set granulator on to true
			memory.at(\seq_mem).put(\granulator_on, true);
		}, {
			//
			~turn_granulator_off.value(memory);
			// Set granulator on to false
			memory.at(\seq_mem).put(\granulator_on, false);
		});
	});

	control3CompView.decorator.nextLine;

	// Amp, density, and base duration labels
	["Amp", "Density", "Base Dur"].do({
		arg item, i;
		var label;
		label = StaticText(control3CompView, Rect(0, 0, hwidth-40/3, 30))
		.string_(item)
		.font_(style.at("text_font"))
		.align_(\center);
		label.background = style.at("bank_frame_color");
	});

	control3CompView.decorator.nextLine;

	// Granulator Amplitude
	ampKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	ampKnob.mode =\vert;
	ampKnob.value = 0.5;
	ampKnob.action_({
		var control;
		control = ControlSpec(0, 1, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "amp", granulator_num, control.map(ampKnob.value));

		// ~set_granulator_amp.value(memory, control.map(ampKnob.value));
	});

	// Granulator Density Control
	grainDensityKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainDensityKnob.mode =\vert;
	grainDensityKnob.value = 0.5;
	grainDensityKnob.action_({
		var control;
		control = ControlSpec(1, 200, \exp, 0.1);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "density", granulator_num, control.map(grainDensityKnob.value));
	});

	// Base Duration of Grains
	grainBaseDurKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainBaseDurKnob.mode =\vert;
	grainBaseDurKnob.value = 0.5;
	grainBaseDurKnob.action_({
		var control;
		control = ControlSpec(0.05, 2, \exp, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "baseDur", granulator_num, control.map(grainBaseDurKnob.value));
	});

	control3CompView.decorator.nextLine;

	// Duration randomization, playback rate, rate randomization label creation
	["Dur Rand", "PB Rate", "Rate Rand"].do({
		arg item, i;
		var label;
		label = StaticText(control3CompView, Rect(0, 0, hwidth-40/3, 30))
		.string_(item)
		.font_(style.at("text_font"))
		.align_(\center);
		label.background = style.at("bank_frame_color");
	});

	control3CompView.decorator.nextLine;

	// Grain Duration Randomization
	durRandKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	durRandKnob.mode =\vert;
	durRandKnob.value = 1;
	durRandKnob.action_({
		var control;
		control = ControlSpec(1, 0.005, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "durRand", granulator_num, control.map(durRandKnob.value));
	});

	// Grain Playback Rate
	grainRateKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainRateKnob.mode =\vert;
	grainRateKnob.value = 0.25; // set to start at 1
	grainRateKnob.action_({
		var control;
		control = ControlSpec(0.01, 4, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "rate", granulator_num, control.map(grainRateKnob.value));
	});

	// Playback Rate Randomization
	grainRateRandKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainRateRandKnob.mode =\vert;
	grainRateRandKnob.value = 0.99;
	grainRateRandKnob.action_({
		var control;
		control = ControlSpec(0.01, 0.99, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "rateRand", granulator_num, control.map(grainRateRandKnob.value));
	});

	control3CompView.decorator.nextLine;

	// Pan, pan randomization, pointer delay label creation
	["Pan", "Pan Rand", "Ptr Delay"].do({
		arg item, i;
		var label;
		label = StaticText(control3CompView, Rect(0, 0, hwidth-40/3, 30))
		.string_(item)
		.font_(style.at("text_font"))
		.align_(\center);
		label.background = style.at("bank_frame_color");
	});

	// Grainulator Pan
	grainPanKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainPanKnob.mode =\vert;
	grainPanKnob.value = 0.5;
	grainPanKnob.action_({
		var control;
		control = ControlSpec(-1, 1, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "pan", granulator_num, control.map(grainPanKnob.value));
	});

	// Grain Pan Randomization
	grainPanRandKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainPanRandKnob.mode =\vert;
	grainPanRandKnob.value = 0.0;
	grainPanRandKnob.action_({
		var control;
		control = ControlSpec(0, 1, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "panRand", granulator_num, control.map(grainPanRandKnob.value));
	});

	// Grain Pointer Delay
	grainPtrDelayKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainPtrDelayKnob.mode =\vert;
	grainPtrDelayKnob.value = 0.5;
	grainPtrDelayKnob.action_({
		var control;
		control = ControlSpec(0, ~server.sampleRate * 5, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "ptrSampleDelay", granulator_num, control.map(grainPtrDelayKnob.value));
	});

	// Pointer delay randomization, minimum pointer delay, and black hole label creation
	["Ptr Delay Rand", "Min Ptr Delay", "Black Hole"].do({
		arg item, i;
		var label;
		label = StaticText(control3CompView, Rect(0, 0, hwidth-40/3, 40))
		.string_(item)
		.font_(style.at("text_font"))
		.align_(\center);
		label.background = style.at("bank_frame_color");
	});

	// Grainulator Pointer Delay Randomization
	grainPtrDelayRandKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainPtrDelayRandKnob.mode =\vert;
	grainPtrDelayRandKnob.value = 0.5;
	grainPtrDelayRandKnob.action_({
		var control;
		control = ControlSpec(0, ~server.sampleRate * 5, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "ptrRandSamples", granulator_num, control.map(grainPtrDelayRandKnob.value));
	});

	// Grain Minimum Pointer Delay
	grainMinPtrDelayKnob = Knob.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3));
	grainMinPtrDelayKnob.mode =\vert;
	grainMinPtrDelayKnob.value = 1000 / ~server.sampleRate;
	grainMinPtrDelayKnob.action_({
		var control;
		control = ControlSpec(1, ~server.sampleRate * 5, \linear, 0.01);
		~set_granulator_by_name_control_key.value(memory, \granulator_mem, "minPtrDelay", granulator_num, control.map(grainMinPtrDelayKnob.value));
	});

	// Black Hole Button. Sends the sequencers out to nowhere (but leaves it running for the
	// buffer writing. These leaves the granulator on 'reading' and processing the unheard
	// sequencer.
	blackHoleSeqButton = Button.new(control3CompView, Rect(0, 0, hwidth-40/3, hwidth-40/3))
	.states_([["On", Color.white, style.at("text_color")], ["Off", Color.white, Color.red]])
	.action_({
		if (blackHoleSeqButton.value == 1, {
			// Send the splitter out to the ether
			memory.at(\seq_mem).at(\granulatorSplitter).set(\out2, 110);
		}, {
			if (memory.at(\seq_mem).at(\reverb_on), {
				memory.at(\seq_mem).at(\granulatorSplitter).set(\out2, 99);
			}, {
				memory.at(\seq_mem).at(\granulatorSplitter).set(\out2, 0);
			});
		});
	});

	control3CompView;
};

~update_track = {
	// Updates the track, giving one of the StaticText objects a random color and turning
	// off the previous index.
	arg index, track;
	if((index == 0), {
		{ track[1][index].background_(Color.rand) }.defer;
		{ track[1][track[1].size-1].background_(Color.white) }.defer;
	}, {
		{ track[1][index].background_(Color.rand) }.defer;
		{ track[1][index-1].background_(Color.white) }.defer;
	});
};

~set_buttons_sliders_numBoxes = {
	// Function that sets specific sliders/buttons/menus that should update when the
	// tab button changes.
	arg memory;
	var control_name;
	memory.at(\seq_mem).at(\noteDurationSlider).value = memory.at(\seq_mem).at(~build_control_name.value(memory, \sus));
	memory.at(\seq_mem).at(\volumeSlider).value = memory.at(\seq_mem).at(~build_control_name.value(memory, \amp));
	memory.at(\seq_mem).at(\instrumentMenu).value = memory.at(\seq_mem).at(~build_control_name.value(memory, \instrument) ++ '_idx');
};

)


