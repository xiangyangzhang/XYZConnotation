//
//  LZXConnotationViewController.m
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "LZXConnotationViewController.h"

@interface LZXConnotationViewController ()

@end

@implementation LZXConnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAf];
    [self createTableView];
#warning mark - JHRefresh 刷新
    [self createRefreshView];
    [self createPullUpView];
    
#if 0
    self.currentPage = 0;
    self.isLoadMore = NO;
    self.isRefreshing = NO;
    self.max_timestamp = @"-1";
    //做第一次下载
    NSString *url = [NSString stringWithFormat:CONTENTS_URL,self.category,self.currentPage,(NSInteger)30,self.max_timestamp];
    
    [self addTaskWithUrl:url];
#else
    // 直接执行下拉刷新
    [self.tableView headerStartRefresh];
#endif
}

#pragma mark - 创建下载对象
- (void)createAf {
    self.manager = [AFHTTPRequestOperationManager manager];
    //设置二进制 不解析
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
- (void)createTableView {
    //取消 半透明条(导航条、tabBar的条)对滚动视图内容的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ConnotationCell" bundle:nil] forCellReuseIdentifier:@"ConnotationCell"];
    //空的可变数据源数组
    self.dataArr = [[NSMutableArray alloc] init];
}

#pragma mark - JHRefresh
-  (void)createRefreshView {
    __weak typeof(self) weakSelf = self; // 弱引用指针
    // 带文字特效的刷新
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
       // 开始刷新的时候会 回调beginRefresh:^{  }
        if (weakSelf.isRefreshing) { // 如果反复刷新 ，直接返回 不需要 刷新
            return ;
        }
        weakSelf.isRefreshing = YES; // 记录刷新
        
        weakSelf.currentPage = 0;
        weakSelf.max_timestamp = @"-1"; // 下拉刷新  -1
        
        //  发送下载请求
        NSString *url = [NSString stringWithFormat:CONTENTS_URL, weakSelf.category, weakSelf.currentPage, (NSInteger)30, weakSelf.max_timestamp];
        [weakSelf addTaskWithUrl:url];
    }];
}

/**
 *  结束刷新
 */

- (void)endRefreshing {
    if (self.isRefreshing) { // 结束上拉刷新
        self.isRefreshing = NO;
        // 关闭刷新特效
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) { // 结束上拉加载
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - 上拉加载
- (void)createPullUpView {
    __weak typeof(self)weakSelf = self;
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage ++;
        ConnotationModel *model = [weakSelf.dataArr lastObject];
        weakSelf.max_timestamp = model.update_time; // 当前界面最后一条数据的时间
        
        //  发送下载请求
        NSString *url = [NSString stringWithFormat:CONTENTS_URL, weakSelf.category, weakSelf.currentPage, (NSInteger)15, weakSelf.max_timestamp];
        [weakSelf addTaskWithUrl:url];

    }];
}

#pragma mark - 添加下载任务
- (void)addTaskWithUrl:(NSString *)url {
    __weak typeof(self) weakSelf = self;
#if 1   // POST请求
    [self.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载完成");
        if (responseObject) {
            
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects]; // 清空数组 刷新都是新数据
            }
            
            //json  最外层是字典
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *itemArr = dict[@"items"];
            for (NSDictionary *connotationDict in itemArr) {
                ConnotationModel *model = [[ConnotationModel alloc] init];
                //kvc 赋值
                [model setValuesForKeysWithDictionary:connotationDict];
                [weakSelf.dataArr addObject:model];
            }
            //刷新表格
            [weakSelf.tableView reloadData];
            [weakSelf endRefreshing];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"网络异常:%@",error);
        [weakSelf endRefreshing];
    }];
#else // get请求
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"下载完成");
        if (responseObject) {
            
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects]; // 清空数组 刷新都是新数据
            }
            
            //json  最外层是字典
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *itemArr = dict[@"items"];
            for (NSDictionary *connotationDict in itemArr) {
                ConnotationModel *model = [[ConnotationModel alloc] init];
                //kvc 赋值
                [model setValuesForKeysWithDictionary:connotationDict];
                [weakSelf.dataArr addObject:model];
            }
            //刷新表格
            [weakSelf.tableView reloadData];
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"网络异常:%@",error);
        [weakSelf endRefreshing];
    }];
#endif
}
#pragma mark - tableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnotationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnotationCell" forIndexPath:indexPath];
    //填充cell
    ConnotationModel *model = self.dataArr[indexPath.row];
    
    //把 分类传给 cell
    cell.category = self.category;
    [cell showDataWithModel:model];
    return cell;
}
#define kPadding 10
//重新计算cell 高度 动态计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnotationModel *model = self.dataArr[indexPath.row];
    CGFloat h = 31;
    //label 高
    h += [LZXHelper textHeightFromTextString:model.wbody width:kScreenSize.width-kPadding*2 fontSize:14];
    if (model.wpic_middle.length) {
        //有图片
        h += kPadding +(kScreenSize.width-kPadding*2)*model.wpic_m_height.doubleValue/model.wpic_m_width.doubleValue;
    }
    h += kPadding+30+kPadding; //30是button的高
    return h;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
