#import "TraverseViewC.h"

#import "Lotuseed.h"

@implementation TraverseViewC

- (instancetype)init{
    if (self = [super init])
    {
        _viewArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)testMethod{
    NSLog(@"1");
}



- (void)uiviewInvoke{
    [[Lotuseed sharedInstance].lotuseed track:@"UIView" properties:@{
                                           @"UIView1":@"UIView0"
                                           }];
}

//- (void)uibuttonInvoke{
//    if ([Lotuseed sharedInstance].lotuseed == nil) {
//        NSLog(@"something nil");
//    }
//    [[Lotuseed sharedInstance].lotuseed track:@"UIButton" properties:@{
//                                             @"Button1":@"Button0"
//                                             }];
//
//}
//
//- (void)severalGetobj:(NSObject *)obj id:(id)something{
//    NSArray *array = [NSArray array];
//    array = [self getChildObj:obj id:something];
//    if (array.count != 0) {
//        [_addTargetArray addObject:array];
//    }
//    if (array != nil) {
//        for (int i = 0; i<array.count; i++) {
//            [self severalGetobj:array[i] id:something];
//        }
//    }
//}
//
//- (NSArray *)getChildObj:(NSObject *)obj id:(id)something{
//    NSMutableArray *children = [NSMutableArray array];
//    if ([obj isKindOfClass:[UIViewController class]]) {
//        UIViewController *viewController = (UIViewController *)obj;
//        if ([viewController childViewControllers]) {
//            [children addObjectsFromArray:[viewController childViewControllers]];
//        }
//        if (viewController.presentedViewController) {
//            [children addObject:viewController.presentedViewController];
//        }if (viewController.isViewLoaded) {
//            [children addObject:viewController.view];
//        }
//    }
//    else if ([obj isKindOfClass:[UIButton class]]){
//        NSLog(@"after : %@",obj);
//        [(UIButton *)obj addTarget:something action:@selector(uibuttonInvoke) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else if ([obj isKindOfClass:[UIView class]]){
//        [children addObjectsFromArray:[(UIView *)obj subviews]];
//    }
//    return children;
//}

- (NSArray *)getChildrenOfObject:(NSObject *)obj ofType:(Class)class{
    NSMutableArray *children = [NSMutableArray array];
    if ([obj isKindOfClass:[UIWindow class]] && [((UIWindow *)obj).rootViewController isKindOfClass:class])
    {//UIWindow
        [children addObject:((UIWindow *)obj).rootViewController];
    }
    else if ([obj isKindOfClass:[UIView class]]){
        for (NSObject *child in [(UIView *)obj subviews]) {
            if (!class || [child isKindOfClass:class]) {
                [children addObject:child];
            }
        }
    }
    
    else if ([obj isKindOfClass:[UIViewController class]]){//UIViewController
        UIViewController *viewController = (UIViewController *)obj;
        for (NSObject *child in [viewController childViewControllers])
        {
            if (!class || [child isKindOfClass:class])
            {
                [children addObject:child];
            }
        }
        if (viewController.presentedViewController && (!class || [viewController.presentedViewController isKindOfClass:class])) {
            [children addObject:viewController.presentedViewController];
        }
        if (!class || (viewController.isViewLoaded && [viewController.view isKindOfClass:class])) {
            [children addObject:viewController.view];
        }
    }
    NSArray *result;
    if ([class isSubclassOfClass:[UITableViewCell class]]) {
    result = [children sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        if (obj2.frame.origin.y > obj1.frame.origin.y) {
            return NSOrderedAscending;
        }
        else if (obj2.frame.origin.y < obj1.frame.origin.y){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    }else{
        result = [children copy];
    }
    return result;
}

- (void)severalGetChild:(NSObject *)obj ofType:(Class)class{
    NSArray *array = [NSArray array];
   array = [self getChildrenOfObject:obj ofType:class];
    if (array.count != 0) {
        [_viewArray addObjectsFromArray:array];
    }
    
    if (array != nil) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetChild:array[i] ofType:class];
        }
    }
}


@end
