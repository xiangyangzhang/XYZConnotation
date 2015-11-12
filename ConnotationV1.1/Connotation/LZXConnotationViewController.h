//
//  LZXConnotationViewController.h
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "BaseViewController.h"
#import "ConnotationCell.h"
#import "ConnotationModel.h"

@interface LZXConnotationViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
//表格和数据源
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
//当前页
@property (nonatomic,assign) NSInteger currentPage;
//是否正在刷新和加载
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadMore;
//记录时间的最大值(最后一条数据的时间)
@property (nonatomic,copy) NSString *max_timestamp;


@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

- (void)createTableView;
- (void)createRefreshView ;
- (void)endRefreshing;
- (void)createPullUpView;
//请求加载数据
- (void)addTaskWithUrl:(NSString *)url;

@end










