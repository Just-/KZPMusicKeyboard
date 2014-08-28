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

@end
