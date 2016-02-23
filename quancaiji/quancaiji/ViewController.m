//
//  ViewController.m
//  quancaiji
//
//  Created by 杨 on 16/2/19.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "ViewController.h"

#import "TraverseViewC.h"
#import "NextViewController.h"
#import "Lotuseed.h"


@implementation ViewController

//- (void)turnView{
//    NextViewController *nextViewController = [[NextViewController alloc]init];
//    
//    [self presentModalViewController:nextViewController animated:YES];
//}

- (void)buttonInvoke{
    if ([Lotuseed sharedInstance].lotuseed == nil) {
        NSLog(@"something must nil");
    }
    [[Lotuseed sharedInstance].lotuseed track:@"UIButton" properties:@{
                                                                       @"Button1":@"Button0"
                                                                       }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [turnButton setTitle:@"turn" forState:UIControlStateNormal];
    [turnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:turnButton];
    turnButton.frame = CGRectMake(100, 100, 100, 50);
    NSLog(@"before:%@",turnButton);
//    [turnButton addTarget:self action:@selector(printView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewInButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    viewInButton.backgroundColor = [UIColor yellowColor];
    [turnButton addSubview:viewInButton];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 100, 50)];
    [self.view addSubview:textField];
    textField.placeholder = @"hehe";
    textField.backgroundColor = [UIColor yellowColor];
    textField.font = [UIFont fontWithName:@"XIXI" size:20.f];
    textField.textColor = [UIColor cyanColor];
    textField.secureTextEntry = YES;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.text = @"default";
    
    self.view.backgroundColor = [UIColor cyanColor];

    Lotuseed *lotuseed = [[Lotuseed alloc]initWithToken:@"Token" launchOptions:nil andFlushInterval:0];
    [lotuseed track:@"test" properties:@{
                                         @"key":@"value"
                                         }];
//    
//    TraverseViewC *traverse = [[TraverseViewC alloc]init];
//    
//    [traverse severalGetChild:self ofType:nil];
//    NSArray *array = traverse.viewArray;
    
    [lotuseed severalGetobj:self id:self];
    
//
//    UIView *testView = array[0];
//    CGColorRef color = testView.layer.backgroundColor;
//    
//    viewInButton.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1.0];
//    
//    NSLog(@"objects:%@",traverse.viewArray );
}

- (void)printView{
    
    NSLog(@"ViewController");
    
//    TraverseViewC *traverse = [[TraverseViewC alloc]init];
//    
//    [traverse severalGetChild:self ofType:nil];
//    NSLog(@"NOW VIEW:%@",traverse.viewArray);

//    [[Lotuseed sharedInstance].lotuseed track:@"testButton" properties:@{
//                                               @"testKey":@"testValue"
//                                               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
