(
var window, top_level, header, header_text="Granulators", ctrl_panel_container, memory=~gm, columns=16, sequencer_ctrls;
// #########
// BUILD GUI
// #########

// Build window, top_level and header
window = ~build_window.value("Sequencer", ~style_1, 740, 800);
top_level = ~build_top_level.value(window, 720, 760, ~style_1);
header = ~build_sequencer_header.value(top_level, 700, 80, ~style_1, header_text);

// Built Control panels
ctrl_panel_container = ~build_track_buttons_container.value(top_level, 225+190+200, 600, ~style_1);

sequencer_ctrls = Array.fill(3, {
	arg i;
	~prefix = i+1;
	~prefix.postln;
	~build_sequencer_control_panel_3.value(ctrl_panel_container, 200, 600, columns, ~style_1, memory, memory.at(\granulator_mem).at(~build_control_name.value(~prefix, \granulator).asSymbol), i+1);
});

CmdPeriod.add({window.close});
)

