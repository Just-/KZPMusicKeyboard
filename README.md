[![Build Status](https://travis-ci.org/kazoompah/KZPMusicKeyboard.svg?branch=master)](https://travis-ci.org/kazoompah/KZPMusicKeyboard)

KZPMusicKeyboard 
============

Drop this into an iOS project to enable versatile musical data entry. You can also just use it as a playable virtual instrument if required, although it is less suited for that purpose.

Explanation
-----------

The keyboard object generates data for pitch, spelling and duration, which is received through a delegate method and can be used selectively depending on the application. For example, it can be configured as a way of entering data for musical notation, or it can be configured to only supply note on/off information which could then be translated into MIDI events to control a sampler, sequencer or a remote interface. Please note that this keyboard does not send messages directly to CoreMIDI. There are several ways of doing the latter using libraries such as [TheAmazingAudioEngine](http://theamazingaudioengine.com/), [MidiBus](http://www.audeonic.com/midibus/) or [MIKMIDI](https://github.com/mixedinkey-opensource/MIKMIDI).

Demo
----

The repo contains a demo project that will allow you to quickly discover what configurations are available and what kind of output will be provided to your app. The demo code should also be informative if you're having trouble setting it up correctly. Make sure that you run `pod install` after cloning the repo.

Installation
------------

The best way to add this to a project is to use Cocoapods. Add the following 2 lines to your Podfile, then run `pod install`:

	pod 'KZPUtilities', :git => 'https://github.com/kazoompah/KZPUtilities.git'
	pod 'KZPMusicKeyboard', :git => 'https://github.com/kazoompah/KZPMusicKeyboard.git'	

The project is not available via the public cocoa pods repo at the moment.

Basic Usage 
------

The keyboard is a singleton which is summoned like this:
```objective-c
	[[KZPMusicKeyboard keyboard] show];
```

To hide the keyboard, do this:
```objective-c
	[[KZPMusicKeyboard keyboard] hide];
```

If the keyboard is set to be animated (see 'Configuring'), you may want to call `showWithCompletion:` and `hideWithCompletion:` instead, which allows you to pass a block which is executed once the keyboard has fully appeared/disappeared.

To receive data from the keyboard, assign an object (such as a view controller) as delegate:

```objective-c
	[[KZPMusicKeyboard keyboard] setDelegate:self];
```

Then implement the callback method `musicKeyboardDidSendPitchData:withDurationData:` to receive pitch and/or duration objects depending on the configuration. See the `KZPMusicPitchData` and `KZPMusicDurationData` headers for an explanation of how to use these objects.

If you allow the keyboard to dismiss manually (see 'Configuring'), then it is a good idea to implement the `keyboardWasDismissed` delegate method in case that action means something. If you allow the user to send a 'backspace' message (e.g., when entering a sequence notes on a staff), then you need to implement the `keyboardDidSendBackspace` delegate method to handle this.

Configuring
-----------

By default the keyboard will display all of its controls and make them active. But this might be unnecessary for situations not involving data entry. The available settings can be explored in the `KZPMusicKeyboard` header. For example, a playable keyboard with no extra functionality that is meant to display permanently could be achieved with the following:

```objective-c
 	KZPMusicKeyboard *keyboard = [KPZMusicKeyboard keyboard];
	keyboard.shouldAnimate = NO;
	keyboard.sendNoteOff = YES;
	keyboard.allowSpelling = NO;
	keyboard.polyphonic = YES;
	keyboard.chordSensitivity = 20.0f; // Milliseconds. When a chord is detected, all its notes are delivered in a single pitch data object.
	keyboard.useDurationControls = NO;
	keyboard.useLocalAudio = YES;
	keyboard.allowDismiss = NO;
	keyboard.allowBackspace = NO;
	[keyboard show];
```

In this case, because none of the additional controls are active and chord sensitivity is fixed programmatically, the keyboard's top ribbon is hidden automatically. 