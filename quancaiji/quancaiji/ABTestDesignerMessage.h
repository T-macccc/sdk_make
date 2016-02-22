//
//  ABTestDesignerMessage.h
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABTestDesignerConnection;

@protocol ABTestDesignerMessage <NSObject>

@property (nonatomic, copy, readonly) NSString *type;

- (void)setPayloadObject:(id)object forKey:(NSString *)key;
- (id)payloadObjectForKey:(NSString *)key;

- (NSData *)JSONData;

- (NSOperation *)responseCommandWithConnection:(ABTestDesignerConnection *)connection;

@end
