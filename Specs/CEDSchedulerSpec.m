#import "SpecHelper.h"

#import "CEDScheduler.h"

SpecBegin(CEDScheduler)

__block CEDScheduler *_scheduler;

describe(@"Scheduler", ^{
    before(^{
        _scheduler = [[CEDScheduler alloc] init];
    });

    it(@"can schedule a task", ^{
        [_scheduler scheduleTask:^{} withTimeInterval:0.0];
        expect(_scheduler.tasks).to.haveCountOf(1);
    });

    it(@"schedules the task after the correct interval", ^{
        [_scheduler scheduleTask:^{} withTimeInterval:10.0];
        CEDTask *task = _scheduler.tasks[0];
        expect(task.performAfter.timeIntervalSinceNow).to.beCloseToWithin(10.0, 1.0);
    });
});

SpecEnd
