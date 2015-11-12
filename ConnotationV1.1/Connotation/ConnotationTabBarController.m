//
//  ConnotationTabBarController.m
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "ConnotationTabBarController.h"
#import "BaseViewController.h"

@interface ConnotationTabBarController ()

@end

@implementation ConnotationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
}
#pragma mark - 创建子视图控制器
- (void)createViewControllers {
    //类名字符串数组
    NSArray *vcNamesArr = @[@"JokesViewController",@"PicViewController",@"VideoViewController",@"GirlsViewController"];
    NSArray *imagesArr = @[@"圣斗士",@"海贼王",@"火影忍者",@"美女"];
    NSArray *selImageArr = @[@"圣斗士_selected",@"海贼王_selected" ,@"火影忍者_selected",@"美女_selected"];
    NSArray *titlesArr = @[@"段子",@"趣图",@"视频",@"美女"];
    
    NSArray *urlArr = @[JOKES,PICS,VIDEOS,GIRLS];
    
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < vcNamesArr.count; i++) {
        //把一个类名字符串 转化为 Class
        Class vcClass = NSClassFromString(vcNamesArr[i]);
        //vcClass 存储的就是 字符串表示的类的信息-->这个变量可以 执行 类的类方法
        //父类指针可以指向不同子类对象
        BaseViewController *baseView = [[vcClass alloc] init];
        baseView.title = titlesArr[i];
        //传值
        baseView.category = urlArr[i];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseView];
        //标签标题
        nav.tabBarItem.title = titlesArr[i];
        
        // 设置图片的渲染模式就可以调整选中状态图
//        nav.tabBarItem.image = [UIImage imageNamed:imagesArr[i]];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:titlesArr[i]
                                                       image:[[UIImage imageNamed:imagesArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:selImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //放入数组
        [vcArr addObject:nav];
    }
    //设置子视图控制器
    self.viewControllers = vcArr;
    
}


@end













