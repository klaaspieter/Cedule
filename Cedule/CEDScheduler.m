//
//  KPAScheduler.m
//  Cedule
//
//  Created by Klaas Pieter Annema on 04-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import "CEDScheduler.h"

@interface CEDScheduler ()
@property (nonatomic, readwrite, strong) NSMutableArray *mutableTasks;
@end

@implementation CEDScheduler

- (void)scheduleTask:(CEDSchedulerTask)task withTimeInterval:(NSTimeInterval)interval;
{
    [self.mutableTasks addObject:task];
}

- (NSMutableArray *)mutableTasks;
{
    if (!_mutableTasks) {
        _mutableTasks = [NSMutableArray array];
    }

    return _mutableTasks;
}

- (NSArray *)tasks;
{
    return [self.mutableTasks copy];
}

@end
