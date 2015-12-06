//
//  KZPMusicDurationData.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicDurationData.h"

@implementation KZPMusicDurationData

- (instancetype)initWithDuration:(unsigned int)duration rest:(BOOL)rest tied:(BOOL)tied dotted:(BOOL)dotted
{
    self = [super init];
    if (self) {
        _duration = duration;
        _rest = rest;
        _tiedForward = tied;
        _dotted = dotted;
    }
    return self;
}

@end
