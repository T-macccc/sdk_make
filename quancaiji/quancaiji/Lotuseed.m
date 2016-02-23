//
//  Lotuseed.m
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "Lotuseed.h"

#import "ViewController.h"

#define VERSION @"1.0.0"


@implementation Lotuseed

- (instancetype)init{
    if (self = [super init]) {
        _addTargetArray = [NSMutableArray array];
    }
    return self;
}

//添加动作
//- (void)buttonInvoke{
//    if ([Lotuseed sharedInstance].lotuseed == nil) {
//        NSLog(@"something nil");
//    }
//    [[Lotuseed sharedInstance].lotuseed track:@"UIButton" properties:@{
//                                                                       @"Button1":@"Button0"
//                                                                       }];
//    
//}

- (void)severalGetobj:(NSObject *)obj id:(id)something{
    NSArray *array = [NSArray array];
    array = [self getChildObj:obj id:something];
    if (array.count != 0) {
        [_addTargetArray addObject:array];
        NSLog(@"%@",array);
    }
    if (array != nil) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetobj:array[i] id:something];
        }
    }
}

- (NSArray *)getChildObj:(NSObject *)obj id:(id)something{
    NSMutableArray *children = [NSMutableArray array];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)obj;
        if ([viewController childViewControllers]) {
            [children addObjectsFromArray:[viewController childViewControllers]];
        }
        if (viewController.presentedViewController) {
            [children addObject:viewController.presentedViewController];
        }if (viewController.isViewLoaded) {
            [children addObject:viewController.view];
        }
    }
    else if ([obj isKindOfClass:[UIButton class]]){
        ViewController *VC = [[ViewController alloc]init];
        [(UIButton *)obj addTarget:something   action:@selector(buttonInvoke) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([obj isKindOfClass:[UIView class]]){
        [children addObjectsFromArray:[(UIView *)obj subviews]];
    }
    return children;
}


static Lotuseed *sharedInstance = nil;

//初始化
- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions andFlushInterval:(NSUInteger)flushInterval{
    if (apiToken == nil) {
        apiToken = @"";
    }
    if ([apiToken length] == 0) {
        NSLog(@"%@ warning empty apiToken",self);
    }
    if (self = [self init]) {
        self.people = [[LotuseedPeople alloc]initWithLotuseed:self];
        self.apiToken = apiToken;
        
        self.automaticProperties = [self collectProperties];
        self.distinctId = [self defaultDistinctId];
        
        NSString *label = [NSString stringWithFormat:@"com.lotuseed.%@.%p",apiToken,self];
        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
    }
    return self;
}

- (NSString *)defaultDistinctId{
    NSString *distinctId = [self IFA];
    if (!distinctId && NSClassFromString(@"UIDevice")) {
        distinctId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    if (!distinctId) {
        NSLog(@"%@ error getting device identifier: falling back to uuid",self);
        distinctId = [[NSUUID UUID] UUIDString];
    }
    return distinctId;
}

+ (Lotuseed *)sharedInstance{
    if (sharedInstance == nil) {
        [self new];
        NSLog(@"warning sharedInstance called before sharedInstanceWithToken:");
    }
    return sharedInstance;
}

- (instancetype)initWithToken:(NSString *)apiToken andFlushInterval:(NSUInteger)flushInterval{
    return [self initWithToken:apiToken launchOptions:nil andFlushInterval:flushInterval];
}

+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken{
    return [Lotuseed sharedInstanceWithToken:apiToken launchOptions:nil];
}

+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if defined(DEBUG)
        const NSUInteger flushInterval = 1;
#else
        const NSUInteger flushInterval = 60;
#endif
        sharedInstance = [[super alloc]initWithToken:apiToken launchOptions:launchOptions andFlushInterval:flushInterval];
    });
    return sharedInstance;
}

//设备信息采集
- (NSDictionary *)collectProperties{
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceModel = [self deviceModel];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CTCarrier *carrier = [self.telephonyInfo subscriberCellularProvider];
    
    [propertiesDict setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] forKey:@"$app_version"];
    [propertiesDict setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"$app_release"];
    [propertiesDict setValue:[self IFA] forKey:@"$ios_ifa"];
    [propertiesDict setValue:carrier.carrierName forKey:@"$carrier"];

    [propertiesDict addEntriesFromDictionary:@{
                                               @"mp_lib":@"iphone",
                                               @"$lib_version":[self libVersion],
                                               @"$manufacturer":@"Apple",
                                               @"$os":[device systemName],
                                               @"$os_version":[device systemVersion],
                                               @"$model":deviceModel,
                                               @"$screen_height":@((NSInteger)size.height),
                                               @"$screen_width":@((NSInteger)size.width)
                                               }];
    
    return [propertiesDict copy];
}

- (NSString *)deviceModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *result = @(answer);
    return result;
}

- (NSString *)IFA
{
    NSString *ifa = nil;
#if !defined(MIXPANEL_NO_IFA)
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) {
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        ifa = [uuid UUIDString];
    }
#endif
    return ifa;
}

- (NSString *)libVersion{
    return VERSION;
}

//tracking
- (void)identify:(NSString *)distinctedId{
    if (distinctedId == nil ||distinctedId.length == 0) {
        NSLog(@"%@ cannot identify blank,distinct id :%@",self,distinctedId);
        return;
    }
    dispatch_async(self.serialQueue, ^{
        self.distinctId = distinctedId;
        self.people.distinctId = distinctedId;
        if ([self.people.unidentifiedQueue count] > 0) {
            for (NSMutableDictionary *r in self.people.unidentifiedQueue) {
                r[@"$distinctId"] = distinctedId;
                [self.peopleQueue addObject:r];
            }
            [self.people.unidentifiedQueue removeAllObjects];
            [self archivePeople];
        }
        if ([Lotuseed inBackground]) {
            [self archiveProperties];
        }
    });
}

+ (void)assertPropertyTypes:(NSDictionary *)properties{
    for (id __unused k in properties) {
        NSAssert([k isKindOfClass:[NSString class]], @"%@ properties keys must be NSString/. got:%@ %@",self,[k class],k);
        
        NSAssert([properties[k] isKindOfClass:[NSString class]] ||
                [properties[k] isKindOfClass:[NSNumber class]] ||
                [properties[k] isKindOfClass:[NSNull class]] ||
                [properties[k] isKindOfClass:[NSArray class]] ||
                [properties[k] isKindOfClass:[NSDictionary class]] ||
                [properties[k] isKindOfClass:[NSDate class]] ||
                 [properties[k] isKindOfClass:[NSURL class]], @"%@ properties value must be NSString,NSNumber,NSNull,NSArray,NSDictionary,NSDate or NSURL.got: %@ %@",self,[properties[k] class],properties[k]);
    }
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties{
    if (event == nil || [event length] == 0) {
        NSLog(@"%@ lotuseed track called with empty event parametr. using 'mp_event'",self);
        event = @"mp_event";
    }
    properties = [properties copy];
    [Lotuseed assertPropertyTypes:properties];
    
    double timeInterval = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeSeconds = @(round(timeInterval));//时间戳取整
//    dispatch_async(self.serialQueue, ^{
        NSNumber *eventStartTime = self.timeEvents[event];
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        [p addEntriesFromDictionary:self.automaticProperties];
        p[@"token"] = self.apiToken;
        p[@"time"] = timeSeconds;
        if (eventStartTime) {//?
            [self.timeEvents removeObjectForKey:event];
            p[@"$duration"] = @([[NSString stringWithFormat:@"%.3f",timeInterval-[eventStartTime doubleValue]] floatValue]);
        }
        if (self.nameTag) {
            p[@"name_tag"] = self.nameTag;
        }
        if (self.distinctId) {
            p[@"distinctId"] = self.distinctId;
        }
        [p addEntriesFromDictionary:self.automaticProperties];
        if (properties) {
            [p addEntriesFromDictionary:properties];
        }
        NSDictionary *e = @{
                            @"event":event,
                            @"properties":[NSDictionary dictionaryWithDictionary:p]
                            };
        [self.eventQueue addObject:e];
//        if ([self.eventQueue count] > 500) {
//            [self.eventQueue removeObjectAtIndex:0];
//        }//??
        if ([Lotuseed inBackground]) {
            [self archiveEvents];
        }
//    });
//    flush
    
    NSLog(@"is tracking :%@",e);
}

+ (BOOL)inBackground{
#if !defined(MIXPANEL_APP_EXTENSION)
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
#else
    return NO;
#endif
}

//归档
- (void)archivePeople{
    NSString *filePath = [self peopleFilePath];
    NSMutableArray *peopleQueueCopy = [NSMutableArray arrayWithArray:[self.peopleQueue copy]];//self.peopleQueue为_unidentifierQueue
    if (![NSKeyedArchiver archiveRootObject:peopleQueueCopy toFile:filePath]) {
        NSLog(@"%@ unable to archive people data",self);
    }
}

- (void)archiveEvents{
    NSString *filePath = [self eventsFilePath];
    NSMutableArray *eventQueueCopy = [NSMutableArray arrayWithArray:[self.eventQueue copy]];
    if (![NSKeyedArchiver archiveRootObject:eventQueueCopy toFile:filePath]) {
        NSLog(@"%@ unable to archive events data",self);
    }
}

- (void)archiveProperties{
    NSString *filePath = [self propertiesFilePath];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setValue:self.distinctId forKey:@"distinctId"];
    [p setValue:self.automaticProperties forKey:@"autoProperties"];
    [p setValue:self.people.distinctId forKey:@"peopleDistinctId"];
    [p setValue:self.people.unidentifiedQueue forKey:@"peopleUnidentifierQueue"];
    
    if (![NSKeyedArchiver archiveRootObject:p toFile:filePath]) {
        NSLog(@"%@ unable to archive properties data",self);
    }
}

//路径
- (NSString *)filePathForData:(NSString *)data{
    NSString *fileName = [NSString stringWithFormat:@"lotuseed-%@-%@.plist",self.apiToken,data];
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

- (NSString *)peopleFilePath{
    return [self filePathForData:@"people"];
}

- (NSString *)eventsFilePath{
    return [self filePathForData:@"events"];
}

- (NSString *)propertiesFilePath{
    return [self filePathForData:@"properties"];
}
@end
//LotuseedPeple
@implementation LotuseedPeople

- (instancetype)initWithLotuseed:(Lotuseed *)lotuseed{
    if (self = [self init]) {
        self.lotuseed = lotuseed;
        self.unidentifiedQueue = [NSMutableArray array];
        self.automaticPeopleProperties = [self collectProperties];
    }
    return self;
}

- (NSDictionary *)collectProperties{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    __strong Lotuseed *strongLotuseed = _lotuseed;
    [p setValue:[strongLotuseed deviceModel] forKey:@"$ios_device_model"];
    [p setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] forKey:@"$ios_app_version"];
    [p setValue:[[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"] forKey:@"$ios_app_release"];
    [p setValue:[strongLotuseed IFA] forKey:@"$ios_ifa"];
    [p addEntriesFromDictionary:@{
                                  @"$ios_ifa":[[UIDevice currentDevice] systemVersion],
                                  @"$ios_lib_version":VERSION
                                  }];
    return [p copy];
}
@end