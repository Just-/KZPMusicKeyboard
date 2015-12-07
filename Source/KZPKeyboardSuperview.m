//
//  KZPKeyboardSuperview.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 8/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPKeyboardSuperview.h"

@implementation KZPKeyboardSuperview

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return !CGRectContainsPoint(self.passThroughFrame, point);
}

@end
