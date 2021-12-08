// CHECK SETTINGS OF COMP
ServerOptions.outDevices;
ServerOptions.inDevices;
MIDIFunc.trace(true);
MIDIFunc.trace(false);

(
var path;
path = thisProcess.nowExecutingPath.dirname;
path.postln;

// Set hardware in device
Server.default.options.inDevice_("Scarlett 18i8 USB");
// Set hardware out device
Server.default.options.outDevice_("MacBook Pro Speakers");

// Set gloabal settings for scsynth server, assign server to a global var.
~server = Server.default;
~server.options.numOutputBusChannels_(2);
~server.options.numInputBusChannels_(4);
~server.waitForBoot(
	{
		// LOAD SYNTH DEFS
		thisProcess.interpreter.executeFile(path +/+ "/synthdefs.scd");

		// LOAD GUI STYLES
		thisProcess.interpreter.executeFile(path +/+ "/GUI_files/GUI_Styles.scd");

		// LOAD GUI CONSTRUCTOR
		thisProcess.interpreter.executeFile(path +/+ "/GUI_files/GUI_Functions.scd");

		// LOAD GRANULATOR FUNCTIONS
		thisProcess.interpreter.executeFile(path +/+ "/granulator_functions.scd");

		// Wait until boot is done and then begin launching the rest of the prograam
		~server.sync;

		// Set global memory storage
		~gm = Dictionary.new();

		// Boot Sequencer
		// thisProcess.interpreter.executeFile(path +/+ "/granulator_run.scd");
	};
);
)

