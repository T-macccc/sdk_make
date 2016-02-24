//
//  NextViewController.m
//  quancaiji
//
//  Created by 杨 on 16/2/19.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "NextViewController.h"

#import "TraverseViewC.h"
#import "Lotuseed.h"

@interface NextViewController ()<UITableViewDataSource,UITableViewDelegate>
//{
//    UITableView *dataTable;
//    NSMutableArray *dataArray1;
//    NSMutableArray *dataArray2;
//    NSMutableArray *titleArray;
//    NSMutableArray *indexPathArray;
//}
@end

@implementation NextViewController

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_titleArray objectAtIndex:section];
            break;
        case 1:
            return [_titleArray objectAtIndex:section];
            break;
            
        default:
            break;
    }
    return @"Unknow";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_dataArray1 count];
            break;
        case 1:
            return [_dataArray2 count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_indexPathArray addObject:indexPath];
    UITableViewCell *cell = [_dataTable cellForRowAtIndexPath:indexPath];
    NSLog(@"section:%d,row:%d",indexPath.section,indexPath.row);
    NSLog(@"cell:%@",cell);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            [[cell textLabel] setText:[_dataArray1 objectAtIndex:indexPath.row]];
            break;
            
        case 1:
            [[cell textLabel] setText:[_dataArray2 objectAtIndex:indexPath.row]];
            break;
            
        default:
            [[cell textLabel] setText:@"Unknow"];
            break;
    }
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    [_dataTable setDelegate:self];
    [_dataTable setDataSource:self];
    [self.view addSubview:_dataTable];

    _dataArray1 = [[NSMutableArray alloc]initWithObjects:@"China",@"American",@"English", nil];
    _dataArray2 = [[NSMutableArray alloc]initWithObjects:@"Yellow",@"Black",@"White", nil];
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"country",@"race", nil];
    _indexPathArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TraverseViewC *traverse = [TraverseViewC new];
    
    [traverse severalGetChild:self ofType:nil];
    NSLog(@"child:%@",traverse.viewArray);
    
    NSLog(@"rowHeight:%f",_dataTable.estimatedRowHeight);
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
