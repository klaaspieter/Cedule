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
@property (nonatomic, readwrite, strong) NSTimer *timer;
@end

@implementation CEDScheduler

- (void)scheduleTask:(CEDTaskBlock)block withTimeInterval:(NSTimeInterval)interval;
{
    CEDTask *task = [CEDTask taskWithBlock:block withTimeInterval:interval];
    [self scheduleTasks:@[task]];
}

- (void)scheduleTasks:(NSArray *)tasks;
{
    [self.mutableTasks addObjectsFromArray:tasks];
    [self.mutableTasks sortUsingComparator:^NSComparisonResult(CEDTask *obj1, CEDTask *obj2) {
        return [obj1.performAfter compare:obj2.performAfter];
    }];
    [self scheduleNextPerform];
}

- (void)removeTask:(CEDTaskBlock)block;
{
    NSIndexSet *indexesToRemove = [self.mutableTasks indexesOfObjectsPassingTest:^BOOL(CEDTask *task, NSUInteger idx, BOOL *stop) {
        return task.block == block;
    }];
    [self.mutableTasks removeObjectsAtIndexes:indexesToRemove];
    [self scheduleNextPerform];
}

- (void)removeAllTasks;
{
    self.mutableTasks = [NSMutableArray array];
    [self scheduleNextPerform];
}

- (void)scheduleNextPerform;
{
    CEDTask *task = self.mutableTasks.firstObject;

    if (!task) {
        [self.timer invalidate];
    } else if (!self.timer || [self.timer.fireDate compare:task.performAfter] == NSOrderedAscending) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:task.performAfter.timeIntervalSinceNow target:self selector:@selector(performTasks:) userInfo:nil repeats:NO];
    }
}

- (void)performTasks:(NSTimer *)timer;
{
    NSMutableArray *tasksToReschedule = [NSMutableArray array];
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];

    [self.tasks enumerateObjectsUsingBlock:^(CEDTask *task, NSUInteger idx, BOOL *stop) {
        if ([self shouldPerform:task]) {
            task.block();
            [indexesToRemove addIndex:idx];
            [tasksToReschedule addObject:[CEDTask taskWithBlock:task.block withTimeInterval:task.interval]];
        }
    }];

    [self.mutableTasks removeObjectsAtIndexes:indexesToRemove];
    [self scheduleTasks:tasksToReschedule];
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
