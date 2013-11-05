//
//  CEDTask.m
//  Cedule
//
//  Created by Klaas Pieter Annema on 05-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import "CEDTask.h"

@implementation CEDTask

+ (instancetype)taskWithBlock:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;
{
    return [[self alloc] initWithBlock:block withTimeInterval:interval];
}

- (id)initWithBlock:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;
{
    self = [super init];
    if (self) {
        _block = block;
        _interval = interval;
        _performAfter = [NSDate dateWithTimeIntervalSinceNow:interval];
    }

    return self;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> { interval: %f, timeLeft: %f }", NSStringFromClass(self.class), self, self.interval, self.performAfter.timeIntervalSinceNow];
}

@end
