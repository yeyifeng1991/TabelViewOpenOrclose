//
//  ViewController.m
//  TableViewClose
//
//  Created by YeYiFeng on 16/8/5.
//  Copyright © 2016年 YeYiFeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *groupArr;
     NSMutableArray *_bigArray;//装有大数组的小数组
    UITableView *tableview;
    BOOL isClose[3];
    //用来记录是谁点击的
    NSIndexPath *_indexPath;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"表格展开或关闭";
    groupArr=@[@"同学",@"同事",@"家人"];
    NSMutableArray *tongxueArr =[[NSMutableArray alloc]initWithObjects:@"同学1",@"同学2",@"同学3",@"同学4",@"同学5", nil];
    
    NSMutableArray *tongshiArr =[[NSMutableArray alloc]initWithObjects:@"同事1",@"同事2",@"同事3",@"同事4",@"同事5", nil];
    
    NSMutableArray *jiarenArr =[[NSMutableArray alloc]initWithObjects:@"家人1",@"家人2",@"家人3",@"家人4",@"家人5", nil];
    
    //大数组装小数组(为了将来取的时候方便)
    _bigArray =[[NSMutableArray alloc]initWithObjects:tongxueArr,tongshiArr,jiarenArr, nil];//大数组里装有小数组

    //创建表格
    tableview=[[UITableView  alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
//
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _bigArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isClose[section])//打开的情况下
    {
        NSMutableArray *rowarr=_bigArray[section];
        return rowarr.count;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
    }
    NSMutableArray *rowArr=_bigArray[indexPath.section];
    cell.textLabel.text=rowArr[indexPath.row];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    vi.backgroundColor =[UIColor yellowColor];
    
    //button
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, self.view.frame.size.width, 40);
    //10,11,12
    btn.tag =10+section;
    [btn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[groupArr objectAtIndex:section] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [vi addSubview:btn];
    
    //图片
    UIImageView *sanjiaoImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    sanjiaoImg.image =[UIImage imageNamed:@"a"];
    //图片的旋转>>>>
    if (isClose[section])
    {
        //展开  需要旋转90°
        //transform 旋转
        sanjiaoImg.transform =CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        //恢复到正常状态
        sanjiaoImg.transform =CGAffineTransformIdentity;
        
    }
    [vi addSubview:sanjiaoImg];

    
    //添加
    //UIButtonTypeContactAdd
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeContactAdd];
    addBtn.frame =CGRectMake(200, 5, 40, 30);
    [addBtn addTarget:self action:@selector(addPeople:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag =20+section;
    if (isClose[section])
    {
        addBtn.hidden =NO;
    }
    else
    {
        addBtn.hidden =YES;
    }
    [vi addSubview:addBtn];
    
    
    //删除
    UIButton *deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame =CGRectMake(240, 10, 50, 30);
    deleteBtn.backgroundColor =[UIColor blackColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    if (isClose[section])
    {
        deleteBtn.hidden =NO;
    }
    else
    {
        deleteBtn.hidden =YES;
    }
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:deleteBtn];
    

    return vi;
   
}
//滑动单元格进入编译状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    
    //大数组{小数组{内容}}
    //根据区数取出来小数组
    NSMutableArray *arr =[_bigArray objectAtIndex:indexPath.section];
    //删除
    [arr removeObjectAtIndex:indexPath.row];
    
    //    NSArray *arr =@[indexPath];
    
    //刷新  适用于删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView reloadData];
    
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(void)openOrClose:(UIButton *)sender
{
    //关闭>>>>>单元格为0
    //开启的时候必有一个区要重新绘制单元格
    
    //开启需要重新刷新表
    //拿到区号
    NSInteger section =sender.tag-10;
    //isflag =!isflag  >>顺便把区传递进去
    isClose[section] =!isClose[section];
       //结果集
    NSIndexSet *set =[NSIndexSet indexSetWithIndex:section];
    
    //刷新
    [tableview reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"杀";
}
//添加
-(void)addPeople:(UIButton *)sender
{
    //    往数组的最后一位添加一个元素
    NSInteger section =sender.tag -20;
    //根据按钮的tag值把小数组取出来
    NSMutableArray *arr =[_bigArray objectAtIndex:section];
    [arr addObject:@"小表哥"];
    
    //索引所在的
    //添加到最后一行
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:arr.count-1 inSection:section];
    
    
    //插入的刷新
    [tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    //    全表刷
    [tableview reloadData];
}
//删除>>>
-(void)deleteBtnClick:(UIButton *)sender
{
//   NSLog(@"当前点击了单元格---%ld---%ld",(long)_indexPath.section+1,(long)_indexPath.row+1);
    NSMutableArray *arr =[_bigArray objectAtIndex:_indexPath.section];//根据记录的区和行
    [arr removeObjectAtIndex:_indexPath.row];
//    [_bigArray removeLastObject];
    [tableview reloadData];
 
    
    //    [qqTableView setEditing:!qqTableView.editing animated:YES];
    
    
}
#pragma mark---重点，点击单元格时，记住单元格位置，区索引和行索引
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"当前点击了单元格---%ld---%ld",(long)indexPath.section+1,(long)indexPath.row+1);
    _indexPath =indexPath;
    NSLog(@"记录点击的位置>>>%@",_indexPath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
