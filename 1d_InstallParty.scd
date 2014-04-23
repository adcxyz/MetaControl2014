

Get current SuperCollider from

http://sourceforge.net/projects/supercollider/files/

Start SuperCollider,
run the line:

Quarks.checkoutAll; // and accept if needed

Quarks.installed.collect(_.name).postcs

[
	"Bending",
	"GamePad",
	"JITLibExtensions",
	"JITMIDIKtl",
	"KeyPlayer",
	"Morse",
	"MultiTouchPad",
	"Preference",
	"Republic",
	"SpeakersCorner",
	"UnitTesting"
].do { |quark|
	Quarks.install(quark);
};

clone some things from github:

https://github.com/ModalityTeam/Modality-toolkit
https://github.com/ModalityTeam/VariousMixedThings

// install by hand - create links into :

unixCmd("open" + quote(Platform.userExtensionDir));



https://github.com/adcxyz/MetaControl2014