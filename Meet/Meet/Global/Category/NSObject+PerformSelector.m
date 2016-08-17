//
//  NSObject+PerformSelector.m
//  Meet
//
//  Created by Zhang on 6/4/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) return;
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&arg1 atIndex:2];
    [invo setArgument:&arg2 atIndex:3];
    [invo retainArguments];
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end
