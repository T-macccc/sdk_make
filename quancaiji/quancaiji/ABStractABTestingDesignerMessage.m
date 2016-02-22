//
//  ABStractABTestingDesignerMessage.m
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "ABStractABTestingDesignerMessage.h"

@interface ABStractABTestingDesignerMessage()

@property (nonatomic, copy, readwrite) NSString *type;

@end

@implementation ABStractABTestingDesignerMessage
{
    NSMutableDictionary *_payload;
}

- (instancetype)initWithType:(NSString *)type{
    return [self initWithType:type payload:@{}];
}

- (instancetype)initWithType:(NSString *)type payload:(NSDictionary *)payload{
    self = [super init];
    if (self) {
        _type = type;
        _payload = [payload mutableCopy];
    }
    
    return self;
}

+ (instancetype)messageWithType:(NSString *)type payload:(NSDictionary *)payload{
    return [[self alloc]initWithType:type payload:payload];
}


@end
