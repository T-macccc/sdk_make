#import "TraverseViewC.h"

@implementation TraverseViewC

- (instancetype)init{
    if (self = [super init])
    {
        _viewArray = [NSMutableArray array];
    }
    return self;
}

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
        for (NSObject *child in [viewController childViewControllers]) {
            if (!class || [child isKindOfClass:class]) {
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
