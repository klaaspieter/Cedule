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
});

SpecEnd
