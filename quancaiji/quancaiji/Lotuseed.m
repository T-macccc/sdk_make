//
//  Lotuseed.m
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "Lotuseed.h"

#import "ViewController.h"
#import "Lotuseed.h"

#define VERSION @"1.0.0"

@implementation Lotuseed

- (instancetype)init{
    if (self = [super init]) {
        _addTargetArray = [NSMutableArray array];
    }
    return self;
}

//添加监控
- (void)buttonInvoke{
    if ([Lotuseed sharedInstance] == nil) {
        NSLog(@"单例为空");
    }
    [[Lotuseed sharedInstance] track:@"UIButton" properties:@{
                                                              @"Button1":@"Button0"
                                                              }];
    
}

- (void)severalGetobj:(NSObject *)obj id:(id)something{
    NSArray *array = [NSArray array];
    array = [self getChildObj:obj id:something];
    if (array.count != 0) {
        [_addTargetArray addObject:array];
        NSLog(@"%@",array);
    }
    if (array.count) {
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
    else if ([obj isKindOfClass:[UITableView class]]){
//        NSLog(@"i'm tableView");
    }
    else if ([obj isKindOfClass:[UIButton class]]){
        
        [(UIButton *)obj addTarget:[Lotuseed sharedInstance]  action:@selector(buttonInvoke) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([obj isKindOfClass:[UIView class]]){
    
        [children addObjectsFromArray:[(UIView *)obj subviews]];
    }
    return children;
}

//初始化,重置

- (void)reset{
dispatch_async(self.serialQueue, ^{
    self.distinctId = [self defaultDistinctId];
    self.automaticProperty = [NSMutableDictionary dictionary];
    self.people.distinctId = nil;
    self.people.unidentifiedQueue = [NSMutableArray array];
    self.eventQueue = [NSMutableArray array];
    self.peopleQueue = [NSMutableArray array];
    self.timeEvent = [NSMutableDictionary dictionary];
    
    
});
}

+ (NSString *)getCurrentDeviceModel:(UIViewController *)controller{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

static Lotuseed *sharedInstance = nil;

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
        
        self.automaticProperty = [self collectProperties];
        self.distinctId = [self defaultDistinctId];
        self.model = [Lotuseed getCurrentDeviceModel:self];
        
        self.timeEvent = [NSMutableDictionary dictionary];
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
    NSString *model = [Lotuseed getCurrentDeviceModel:self];
    
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
                                               @"$screen_width":@((NSInteger)size.width),
                                               @"$shebeimodel":model
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
        NSNumber *eventStartTime = self.timeEvent[event];
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        [p addEntriesFromDictionary:self.automaticProperty];
        p[@"token"] = self.apiToken;
        p[@"time"] = timeSeconds;
        if (eventStartTime) {//?
            [self.timeEvent removeObjectForKey:event];
            p[@"$duration"] = @([[NSString stringWithFormat:@"%.3f",timeInterval-[eventStartTime doubleValue]] floatValue]);
        }
        if (self.nameTag) {
            p[@"name_tag"] = self.nameTag;
        }
        if (self.distinctId) {
            p[@"distinctId"] = self.distinctId;
        }
        [p addEntriesFromDictionary:self.automaticProperty];
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
    
//    NSLog(@"is tracking :%@",e);
}

+ (BOOL)inBackground{
#if !defined(MIXPANEL_APP_EXTENSION)
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
#else
    return NO;
#endif
}

//归档

- (void)archive{
    [self archivePeople];
    [self archiveEvents];
    [self archiveProperties];
    [self archiveVariants];
    [self archiveEventBindings];
}

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
    [p setValue:self.automaticProperty forKey:@"autoProperty"];
    [p setValue:self.people.distinctId forKey:@"peopleDistinctId"];
    [p setValue:self.people.unidentifiedQueue forKey:@"peopleUnidentifierQueue"];
    
    if (![NSKeyedArchiver archiveRootObject:p toFile:filePath]) {
        NSLog(@"%@ unable to archive properties data",self);
    }
}

- (void)archiveVariants{
    NSString *filePath = [self variantsFilePath];
    if (![NSKeyedArchiver archiveRootObject:self.variant toFile:filePath]) {
        NSLog(@"%@ unable to archive variant data",self);
    }
}

- (void)archiveEventBindings{
    NSString *filePath = [self variantsFilePath];
    if (![NSKeyedArchiver archiveRootObject:self.eventBinding toFile:filePath]) {
        NSLog(@"%@ unable to archive eventBinding data",self);
    }
}


//解归档
- (id)unarchiveFromFile:(NSString *)filePath{
    id unarchiveData = nil;
    @try {
        unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        unarchiveData = nil;
        NSLog(@"%@ unable to unarchive data in %@",self,filePath);
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"%@ unable to remove archived file at %@-%@",self,filePath,error);
        }
    }
    return unarchiveData;
}

- (void)unarchiveEvent{
    self.eventQueue = (NSMutableArray *)[self unarchiveFromFile:[self eventsFilePath]];
    if (!self.eventQueue) {
        self.eventQueue = [NSMutableArray array];
    }
}

- (void)unarchiveEventBinding{
    self.eventBinding = (NSSet *)[self unarchiveFromFile:[self eventBindingFilePath]];
    if (!self.eventBinding) {
        self.eventBinding = [NSSet set];
    }
}

- (void)unarchiveVariant{
    self.variant = (NSSet *)[self unarchiveFromFile:[self variantsFilePath]];
    if (!self.variant) {
        self.variant = [NSSet set];
    }
}

- (void)unarchivePeople{
    self.peopleQueue = (NSMutableArray *)[self unarchiveFromFile:[self peopleFilePath]];
    if (!self.peopleQueue) {
        self.peopleQueue = [NSMutableArray array];
    }
}

- (void)unarchiveProperties{
    NSDictionary *properties = (NSDictionary *)[self unarchiveFromFile:[self propertiesFilePath]];
    if (properties) {
        self.distinctId = properties[@"distinctId"] ? :[self defaultDistinctId];
        self.automaticProperty = properties[@"autoProperty"] ? : [NSMutableDictionary dictionary];
        self.people.distinctId = properties[@"peopleDistinctId"];
        self.people.unidentifiedQueue = properties[@"peopleUnidentifiedQueue"] ? : [NSMutableArray array];
        self.variant = properties[@"variant"] ? :[NSSet set];
        self.eventBinding = properties[@"event_Binding"] ? :[NSArray array];
        self.timeEvent = properties[@"timeEvent"] ? :[NSMutableDictionary dictionary];
    }
}

- (void)unarchive{
    [self unarchiveEvent];
    [self unarchiveEventBinding];
    [self unarchivePeople];
    [self unarchiveProperties];
    [self unarchiveVariant];
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

- (NSString *)variantsFilePath{
    return [self filePathForData:@"variants"];
}

- (NSString *)eventBindingFilePath{
    return [self filePathForData:@"event_bindings"];
}

//self.autoProperty的操作
- (void)registerSuperPropertiesOnce:(NSDictionary *)properties defaultValue:(id)defaultValue{
    properties = [properties copy];
    [Lotuseed assertPropertyTypes:properties];
    dispatch_async(self.serialQueue, ^{
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self.automaticProperty];
        for (NSString *key in properties) {
            id value = tmp[key];
            if (value == nil || [value isEqual:defaultValue]) {
                tmp[key] = properties[key];
            }
        }
        self.automaticProperty = [NSDictionary dictionaryWithDictionary:tmp];
        if ([Lotuseed inBackground]) {
            [self archiveProperties];
        }
    });
}

- (void)unregisterSuperProperty:(NSString *)propertyName{
dispatch_async(self.serialQueue, ^{
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self.automaticProperty];
    if (tmp[propertyName] != nil) {
        [tmp removeObjectForKey:propertyName];
    }
    self.automaticProperty = [NSDictionary dictionaryWithDictionary:tmp];
    if ([Lotuseed inBackground]) {
        [self archiveProperties];
    }
});
}

- (void)clearSuperProperties{
dispatch_async(self.serialQueue, ^{
    self.automaticProperty = @{};
    if ([Lotuseed inBackground]) {
        [self archiveProperties];
    }
});
}

- (NSDictionary *)currentSuperProperties{
    return [self.automaticProperty copy];
}

@end
//LotuseedPeple
@implementation LotuseedPeople

- (instancetype)initWithLotuseed:(Lotuseed *)lotuseed{
    if (self = [self init]) {
        self.lotuseed = lotuseed;
        self.unidentifiedQueue = [NSMutableArray array];
        self.peopleAutoProperty = [self collectProperties];
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