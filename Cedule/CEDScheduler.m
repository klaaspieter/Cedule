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
    [self.mutableTasks sortUsingComparator:^NSComparisonResult(CEDTask *obj1, CEDTask *obj2) {
        return [obj2.performAfter compare:obj1.performAfter];
    }];
    [self scheduleNextPerform];
}

- (void)scheduleNextPerform;
{
    CEDTask *task = self.mutableTasks.firstObject;
    [NSTimer scheduledTimerWithTimeInterval:task.interval target:self selector:@selector(performTasks:) userInfo:nil repeats:NO];
}

- (void)scheduleTasks:(NSArray *)tasks;
{
    [self.mutableTasks addObjectsFromArray:tasks];
    CEDTask *firstTask = self.mutableTasks.firstObject;
    [NSTimer scheduledTimerWithTimeInterval:firstTask.interval target:self selector:@selector(performTasks:) userInfo:nil repeats:NO];
}

- (void)performTasks:(NSTimer *)timer;
{
    NSMutableArray *tasksToSchedule = [NSMutableArray array];
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];

    [self.tasks enumerateObjectsUsingBlock:^(CEDTask *task, NSUInteger idx, BOOL *stop) {
        if ([self shouldPerform:task]) {
            task.block();
            [indexesToRemove addIndex:idx];
            [tasksToSchedule addObject:[CEDTask taskWithBlock:task.block withTimeInterval:task.interval]];
        }
    }];

    [self.mutableTasks removeObjectsAtIndexes:indexesToRemove];
    [self scheduleTasks:tasksToSchedule];
}

- (BOOL)shouldPerform:(CEDTask *)task;
{
    return [task.performAfter compare:[NSDate date]] == NSOrderedAscending;
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
