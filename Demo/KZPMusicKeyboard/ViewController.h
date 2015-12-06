//
//  ViewController.h
//  KZPMusicKeyboardDemo
//
//  Created by Matt Rankin on 28/08/2014.
//  Copyright (c) 2014 Sudoseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboard.h"

@interface ViewController : UIViewController <KZPMusicKeyboardDelegate>

@property (weak, nonatomic) IBOutlet KZPMusicTextField *musicTextFieldIB;

@property (strong, nonatomic) KZPMusicTextField *musicTextField;
@property (weak, nonatomic) IBOutlet UIView *middlePanel;

- (IBAction)showKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showKeyboardButton;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UIView *textFieldFrame;


@property (weak, nonatomic) IBOutlet UITextView *spellingTextView;
@property (weak, nonatomic) IBOutlet UITextView *pitchTextView;
@property (weak, nonatomic) IBOutlet UITextView *durationTextView;

- (IBAction)showKeyboard:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (IBAction)shouldAnimateSwitchDidChange:(UISwitch *)sender;
- (IBAction)sendNoteOffSwitchDidChange:(UISwitch *)sender;
- (IBAction)enableKeyboardSwitchDidChange:(UISwitch *)sender;
- (IBAction)enablePolyphonySwitchDidChange:(UISwitch *)sender;
- (IBAction)enableSpellingSwitchDidChange:(UISwitch *)sender;
- (IBAction)enableDurationSwitchDidChange:(UISwitch *)sender;
- (IBAction)durationsActiveSwitchDidChange:(UISwitch *)sender;
- (IBAction)localSoundSwitchDidChange:(UISwitch *)sender;
- (IBAction)enableBackspaceSwitchDidChange:(UISwitch *)sender;
- (IBAction)enableDismissSwitchDidChange:(UISwitch *)sender;

@end
