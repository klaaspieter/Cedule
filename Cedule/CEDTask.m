//
//  CEDTask.m
//  Cedule
//
//  Created by Klaas Pieter Annema on 05-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import "CEDTask.h"

@implementation CEDTask

+ (instancetype)taskWithBlock:(CEDSchedulerTask)block withTimeInterval:(NSTimeInterval)interval;
{
    return [[self alloc] initWithBlock:block withTimeInterval:interval];
}

- (id)initWithBlock:(CEDSchedulerTask)block withTimeInterval:(NSTimeInterval)interval;
{
    self = [super init];
    if (self) {
        _block = block;
        _performAfter = [NSDate dateWithTimeIntervalSinceNow:interval];
    }

    return self;
}

@end
