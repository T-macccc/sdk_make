//
//  TraverseViewC.h
//  quancaiji
//
//  Created by 杨 on 16/2/19.
//  Copyright © 2016年 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface TraverseViewC : NSObject

@property (nonatomic, strong)NSArray *views;
@property (nonatomic, strong)NSMutableArray *viewArray;

- (NSArray *)getChildrenOfObject:(NSObject *)obj ofType:(Class)class;
- (void)severalGetChild:(NSObject *)obj ofType:(Class)class;
@end
