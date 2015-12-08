//
//  KZPMusicKeyboardRibbonButton.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 8/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardRibbonButton.h"

@implementation KZPMusicKeyboardRibbonButton

- (void)style
{
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)toggle
{
    self.selected ? [self deselect] : [self select];
}

- (void)select
{
    if (self.enabled) {
        self.selected = YES;
        self.alpha = 1.0;
    }
}

- (void)deselect
{
    if (self.enabled) {
        self.selected = NO;
        self.alpha = 0.5;
    }
}

- (void)disable
{
    self.selected = NO;
    self.enabled = NO;
    self.alpha = 0.15;
}

- (void)enable
{
    self.selected = NO;
    self.enabled = YES;
    self.alpha = 0.5;
}

@end
