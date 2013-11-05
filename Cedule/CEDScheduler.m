//
//  KPAScheduler.m
//  Cedule
//
//  Created by Klaas Pieter Annema on 04-11-13.
//  Copyright (c) 2013 Annema. All rights reserved.
//

#import "CEDScheduler.h"

#import "CEDtask.h"

@interface CEDScheduler ()
@property (nonatomic, readwrite, strong) NSMutableArray *mutableTasks;
@end

@implementation CEDScheduler

- (void)scheduleTask:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;
{
    CEDTask *task = [CEDTask taskWithBlock:block withTimeInterval:interval];
    [self.mutableTasks addObject:task];
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performTasks:) userInfo:nil repeats:NO];
}

- (void)performTasks:(NSTimer *)timer;
{
    NSMutableArray *tasksToSchedule = [NSMutableArray array];
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];

    [self.tasks enumerateObjectsUsingBlock:^(CEDTask *task, NSUInteger idx, BOOL *stop) {
        task.block();
        [indexesToRemove addIndex:idx];
        [tasksToSchedule addObject:[CEDTask taskWithBlock:task.block withTimeInterval:task.interval]];
    }];

    [self.mutableTasks removeObjectsAtIndexes:indexesToRemove];
    [self.mutableTasks addObjectsFromArray:tasksToSchedule];
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
