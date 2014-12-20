//
//  ViewController.m
//  KZPMusicKeyboardDemo
//
//  Created by Matt Rankin on 28/08/2014.
//  Copyright (c) 2014 Sudoseng. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.musicTextFieldIB.musicInputType = KZPMusicInputType_PianoKeyboard | KZPMusicInputType_NormalKeyboard;
    self.musicTextFieldIB.needsRhythmControls = NO;
    
    self.textFieldFrame.hidden = YES;
    self.musicTextField = [[KZPMusicTextField alloc] initWithFrame:self.textFieldFrame.frame];
    self.musicTextField.backgroundColor = [UIColor whiteColor];
    self.musicTextField.placeholder = @"Music only...";
    self.musicTextField.needsRhythmControls = YES;
    self.musicTextField.textAlignment = NSTextAlignmentCenter;
    self.musicTextField.musicInputType = KZPMusicInputType_PianoKeyboard;
    [self.middlePanel addSubview:self.musicTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showKeyboard:(id)sender {
    [[KZPMusicKeyboardManager defaultManager] setResponder:self];
    [[KZPMusicKeyboardManager defaultManager] showControllerWithRhythmControls:YES];
    self.showKeyboardButton.enabled = NO;
}


#pragma mark - KZPMusicKeyboardDelegate -

- (void)keyboardDidSendBackspace
{
    self.outputLabel.text = @"";
}

- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                       dotted:(BOOL)dotted
                         tied:(BOOL)tied
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC
{
    NSMutableString *text = [NSMutableString stringWithString:@""];
    for (NSNumber *note in noteID) [text appendFormat:@"%@ ", note];
    NSLog(@"info %@, %@, %@, %d, %d", type, spelling, duration, dotted, tied);
    self.outputLabel.text = text;
}

- (void)keyboardWasDismissed
{
    [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:^{
        self.showKeyboardButton.enabled = YES;
    }];
}

@end
