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
    
    [self presentModalViewController:nextViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [turnButton setTitle:@"turn" forState:UIControlStateNormal];
    [turnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:turnButton];
    turnButton.frame = CGRectMake(100, 100, 100, 50);
    [turnButton addTarget:self action:@selector(turnView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewInButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    viewInButton.backgroundColor = [UIColor yellowColor];
    [turnButton addSubview:viewInButton];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 100, 50)];
    [self.view addSubview:textField];
    textField.placeholder = @"hehe";
    
    
    
    Lotuseed *lotuseed = [[Lotuseed alloc]initWithToken:@"Token" launchOptions:nil andFlushInterval:0];
//    TraverseViewC *traverse = [[TraverseViewC alloc]init];
//    
//    [traverse severalGetChild:self ofType:nil];
//    NSArray *array = traverse.viewArray;
//    NSLog(@"objects:%@",traverse.viewArray );
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
