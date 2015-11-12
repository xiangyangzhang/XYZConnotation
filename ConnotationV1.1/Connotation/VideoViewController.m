//
//  VideoViewController.m
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "ConnotationModel.h"
#import <MediaPlayer/MediaPlayer.h>

//#import "LZXConnotationViewController.h"
@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
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

@property (nonatomic, strong) MPMoviePlayerViewController *mPlayer;
- (void)createTableView;
- (void)createRefreshView ;
- (void)endRefreshing;
//请求加载数据
- (void)addTaskWithUrl:(NSString *)url;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAf];
    [self createTableView];
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
    // 刷新头
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    //空的可变数据源数组
    self.dataArr = [[NSMutableArray alloc] init];
}

#pragma mark - 刷新
-  (void)createRefreshView {
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        weakSelf.max_timestamp = @"-1";
        
        NSString *url = [NSString stringWithFormat:CONTENTS_URL, weakSelf.category, weakSelf.currentPage, (NSInteger)30, weakSelf.max_timestamp];
        [weakSelf addTaskWithUrl:url];
        
    }];
}
#pragma mark - 结束刷新
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - 加载
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
#pragma mark - 下载
- (void)addTaskWithUrl:(NSString *)url {
    __weak typeof(self)weakSelf = self;
    //af get
    [ self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSLog(@"下载完成");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *itemArr = dict[@"items"];
            for (NSDictionary *itemDict in itemArr) {
                VideoModel *model = [[VideoModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArr addObject:model];
            }
            //刷新表格
            [weakSelf.tableView reloadData];
            //结束刷新
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络异常");
        [weakSelf endRefreshing];
    }];
}

#pragma mark - tableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    //填充cell
    VideoModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model ];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
//选中cell 进行界面跳转 播放视频
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // 选中cell
    NSLog(@"selected cell %ld", indexPath.row);
    VideoModel *model = self.dataArr[indexPath.row];
    
    // 网络资源
    [self loadMoviePlayerWithURL:[NSURL URLWithString:model.vplay_url]];
}

- (void)loadMoviePlayerWithURL:(NSURL *)url {
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    self.mPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    self.mPlayer.moviePlayer.shouldAutoplay = NO; // 设置是否自动播放
    
    // 模态跳转
    [self presentMoviePlayerViewControllerAnimated:self.mPlayer];
}
- (void)playEnd:(NSNotification *)not {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.mPlayer.moviePlayer stop];
    [self.mPlayer dismissMoviePlayerViewControllerAnimated];
}



@end
