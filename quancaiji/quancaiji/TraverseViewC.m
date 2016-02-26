#import "TraverseViewC.h"

#import "Lotuseed.h"
#import "NextViewController.h"
#import "LotuseedCell.h"

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

- (NSArray *)getChildrenOfObject:(NSObject *)obj ofType:(Class)class{//自定义控件的处理
    NSMutableArray *children = [NSMutableArray array];
    if ([obj isKindOfClass:[UIWindow class]]                    && [((UIWindow *)obj).rootViewController isKindOfClass:class])
    {//UIWindow
        [children addObject:((UIWindow *)obj).rootViewController];
    }
    else if ([obj isKindOfClass:[UIView class]]){
        NSLog(@"%d",[obj isKindOfClass:[UIView class]]);
        NSLog(@"subViews:%@",[(UIView *)obj subviews]);
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

- (void)handleTableView:(NSObject *)obj{//tableView,indexPath
    
//    NSString *ClassName = obj.class;
//    Class myClass = NSClassFromString(@"NextViewController");
    UITableView *objTableView = [(NextViewController *)obj dataTable];
    NSArray *indexArray = [(NextViewController *)obj indexPathArray];
    for (int i = 0; i<indexArray.count; i++) {
        id  myCell = nil;
        myCell = [objTableView cellForRowAtIndexPath:indexArray[i]];
        
        [self severalGetChild:myCell ofType:nil];

        for (id obj in self.viewArray) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *label = obj;
                NSString *name = label.text;
                CGRect labelRect = label.frame;
                NSLog(@"UILABEL:%f,%f,%f,%f,%@",label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height,label.text);
            }
        }
    }
}

- (void)handleTableViewWithTableView:(id)objTableView indexArray:(NSArray *)indexArray{//tableView,indexPath
    for (int i = 0; i<indexArray.count; i++) {
        id  myCell = nil;
        myCell = [objTableView cellForRowAtIndexPath:indexArray[i]];
        
        [self severalGetChild:myCell ofType:nil];
        
        for (id obj in self.viewArray) {
            
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel *label = obj;
                NSString *name = label.text;
                CGRect labelRect = label.frame;
//                NSLog(@"UILABEL:%f,%f,%f,%f,%@",label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height,label.text);
                NSLog(@"find label");
            }
            
            else if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView = obj;
                UIImage *image = imageView.image;
                CGRect imageRect = imageView.frame;
                
                NSLog(@"find imageView");
            }
            
            else if ([obj isKindOfClass:[UITextField class]])
            {
                UITextField *textField = obj;
                CGRect textFieldRect = textField.frame;
                NSString *text = textField.text;
                
                NSLog(@"find textField");
            }
        }
    }
}

- (void)severalGetChild:(NSObject *)obj ofType:(Class)class{
    
    NSArray *array = [NSArray array];
   array = [self getChildrenOfObject:obj ofType:class];
    if (array.count != 0) {
        [_viewArray addObjectsFromArray:array];
    }
    
    if (array.count) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetChild:array[i] ofType:class];
        }
    }
}


@end
