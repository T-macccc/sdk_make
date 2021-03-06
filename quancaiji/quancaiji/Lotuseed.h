//
//  Lotuseed.h
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>
#import <sys/types.h>


#import "Lotuseed.h"

@class LotuseedPeople;

@interface Lotuseed : NSObject

@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyInfo;

@property (nonatomic,strong) Lotuseed *lotuseed;
@property (atomic, strong) LotuseedPeople *people;
@property (atomic, copy) NSString *distinctId;
@property (nonatomic, copy) NSString *apiToken;
@property (nonatomic, strong) NSDictionary *automaticProperty;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableArray *eventQueue;
@property (nonatomic, strong) NSMutableArray *peopleQueue;
@property (nonatomic, strong) NSMutableDictionary *timeEvent;
@property (atomic, copy) NSString *nameTag;
@property (nonatomic, strong) NSString *model;

@property (nonatomic, strong) NSSet *variant;
@property (nonatomic, strong) NSSet *eventBinding;

@property (nonatomic,strong)NSMutableArray *addTargetArray;

- (NSString *)peopleFilePath;
- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions andFlushInterval:(NSUInteger)flushInterval;
- (void)track:(NSString *)event properties:(NSDictionary *)properties;
+ (Lotuseed *)sharedInstance;
- (void)severalGetobj:(NSObject *)obj id:(id)something;
+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken;
@end

@interface LotuseedPeople : NSObject

@property (nonatomic, weak) Lotuseed *lotuseed;
@property (nonatomic, strong) NSMutableArray *unidentifiedQueue;
@property (nonatomic,copy) NSString *distinctId;
@property (nonatomic,strong) NSDictionary *peopleAutoProperty;

- (instancetype)initWithLotuseed:(Lotuseed *)lotuseed;
@end