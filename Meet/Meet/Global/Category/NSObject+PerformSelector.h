//
//  NSObject+PerformSelector.h
//  Meet
//
//  Created by Zhang on 6/4/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

@end
