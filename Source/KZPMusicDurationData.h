//
//  KZPMusicDurationData.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPMusicDurationData : NSObject

- (instancetype)initWithDuration:(unsigned int)duration rest:(BOOL)rest tied:(BOOL)tied dotted:(BOOL)dotted;

@property (nonatomic, readonly) unsigned int duration;
@property (nonatomic, readonly, getter=isRest) BOOL rest;
@property (nonatomic, readonly, getter=isTiedForward) BOOL tiedForward;
@property (nonatomic, readonly, getter=isDotted) BOOL dotted;

@end
