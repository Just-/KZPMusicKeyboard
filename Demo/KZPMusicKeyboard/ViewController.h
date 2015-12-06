//
//  ViewController.h
//  KZPMusicKeyboardDemo
//
//  Created by Matt Rankin on 28/08/2014.
//  Copyright (c) 2014 Sudoseng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *spellingTextView;
@property (weak, nonatomic) IBOutlet UITextView *pitchTextView;
@property (weak, nonatomic) IBOutlet UITextView *durationTextView;

@property (weak, nonatomic) IBOutlet UIButton *showKeyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyboardButton;

- (IBAction)showKeyboard:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (IBAction)configurationSwitchChanged:(UISwitch *)sender;

// TODO: chord sensitivity ?
@property (weak, nonatomic) IBOutlet UISwitch *shouldAnimateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendNoteOffSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enablePitchControlSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *polyphonicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableSpellingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableDurationControlsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *durationControlsActiveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *localAudioSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableBackspaceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableManualDismissSwitch;


@end
