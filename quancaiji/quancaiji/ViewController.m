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

- (void)turnView{
    NextViewController *nextViewController = [[NextViewController alloc]init];
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [turnButton setTitle:@"turn" forState:UIControlStateNormal];
    [turnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:turnButton];
    turnButton.frame = CGRectMake(100, 100, 100, 50);
    
//    [turnButton addTarget:self action:@selector(turnView)  forControlEvents:UIControlEventTouchUpInside];//nav
    
    UIView *viewInButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    viewInButton.backgroundColor = [UIColor yellowColor];
    [turnButton addSubview:viewInButton];
    [turnButton addTarget:self action:@selector(turnView) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(turnView)];
//    self.navigationItem.leftBarButtonItem = leftButton;//nav
    

    Lotuseed *lotuseed = [[Lotuseed alloc]init];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
