//
//  NSString+functions.m
//  Schillinger
//
//  Created by Matt Rankin on 1/03/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "NSString+functions.h"

@implementation NSString (functions)

- (BOOL)contains:(NSString *)substring
{
    return ![[self stringByReplacingOccurrencesOfString:substring withString:@""] isEqualToString:self];
}

- (BOOL)startsWith:(NSString *)substring
{
    return [[self substringToIndex:[substring length]] isEqualToString:substring];
}

- (NSString *)stringBetweenOpeningToken:(NSString *)tkOpen closingToken:(NSString *)tkClose
{
    NSString *result;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToString:tkOpen intoString:NULL];
    if ([scanner isAtEnd]) return nil;
    scanner.scanLocation++;
    if ([scanner isAtEnd]) return nil;
    [scanner scanUpToString:tkClose intoString:&result];
    return result;
}

- (NSString *)stringByRemovingOccurrencesOfString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

- (BOOL)matchedByRegex:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

- (NSString *)trimWhiteSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (NSString *)randomStringOfLength:(NSUInteger)length
{
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSUInteger alphabetLength = [alphabet length];
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0U; i < length; i++) {
        u_int32_t r = arc4random() % alphabetLength;
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

+ (NSString *)token
{
    return [self randomStringOfLength:15];
}

- (NSString *)convertToCamelCase
{
    return [NSString stringWithFormat:@"JS%@", [[self capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

// TODO: Contains nasty bug when parsing general strings
- (NSString *)convertToDisplayString
{
    NSString *removedUnderscores = [self stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSScanner *scanner = [NSScanner scannerWithString:removedUnderscores];
    
    NSString *initial, *tail;
    NSMutableString *displayString = [[NSMutableString alloc] init];
    while (scanner.scanLocation < [removedUnderscores length]) {
        [scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&initial];
//        if (initial) {
            [displayString appendString:initial];
//        } else {
//            scanner.scanLocation++;
//        }
        [scanner scanCharactersFromSet:[NSCharacterSet lowercaseLetterCharacterSet] intoString:&tail];
//        if (tail) {
            [displayString appendString:tail];
//        } else {
//            scanner.scanLocation++;
//        }
        [displayString appendString:@" "];
    }

    return displayString;
}

+ (NSString *)commaDelimitedListWithArray:(NSArray *)array
{
    NSMutableString *list;
    for (id element in array) {
        if (!list) list = [NSMutableString stringWithString:@""];
        [list appendString:[element description]];
        [list appendString:@","];
    }
    
    return list ? (NSString *)[list substringToIndex:[list length]-1] : nil;
}

- (NSString *)stringByRemovingLastCharacter
{
    return [self substringToIndex:self.length-(self.length>0)];
}

@end
