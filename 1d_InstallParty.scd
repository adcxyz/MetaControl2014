

Get current SuperCollider 3.6.6 (or newer) from:

http://sourceforge.net/projects/supercollider/files/

Start SuperCollider,
run the line:

Quarks.checkoutAll; // and accept if needed

// if that fails, follow instructions here:

http://supercollider.github.io/development/quarks-repository-moved.html

Quarks.installed.collect(_.name).postcs;

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

Quarks.gui;

//////////// clone some things from github:

https://github.com/ModalityTeam/Modality-toolkit
https://github.com/ModalityTeam/VariousMixedThings

// install by hand - create links into :

/// open the app support directory:
unixCmd("open" + quote(Platform.userAppSupportDir));

// everything in here can be classes, helps, plugins etc,
// will be included and loaded on startup and recompile.
// other file types will be ignored, but may slow recompiling:

unixCmd("open" + quote(Platform.userExtensionDir));


// clone these to Desktop :
https://github.com/adcxyz/MetaControl2014
https://github.com/ModalityTeam/Modality-toolkit
https://github.com/ModalityTeam/VariousMixedThings

// make a folder in appSupportDir, and move them there, e.g.:

"~/Library/Application Support/SuperCollider/ExtensionsMetaKtl/".pathMatch

"~/Library/Application Support/SuperCollider/ExtensionsMetaKtl/*".pathMatch.printAll; "";

(
f = { |pkg, srcDir = "/ExtensionsMetaKtl/"|
	var supDir = Platform.userAppSupportDir;
	var extDir = Platform.userExtensionDir;
	var targetPath = extDir +/+ pkg;

	srcDir = supDir +/+ srcDir;
	if (File.exists(targetPath)) {
		"already there.".postln;
	} {
		unixCmd("ln -s" + quote(srcDir +/+ pkg) + quote(targetPath));
	};
};
)

f.value("VariousMixedThings");
f.value("Modality-toolkit");


thisProcess.recompile;

Influx.openHelpFile;

