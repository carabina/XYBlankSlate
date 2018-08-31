//
//  ViewController.m
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/22.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "ViewController.h"
#import "XYBlankSlate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//mock数据
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //设置空白页
    [self setupBlankSlate];
    
    self.dataArr = [NSMutableArray array];
    
    
    self.tableView.xy_handler.state = XYDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        for (int i = 0; i < 30; i++) {
//            [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
//        }
        [self.tableView reloadData];
        self.tableView.xy_handler.state = XYDataLoadStateFailed;
    });
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:showUserInfoCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是哈哈哈哈%@",self.dataArr[indexPath.row]];
    
    return cell;
}


#pragma mark - 设置空白页
- (void)setupBlankSlate {
    //设置空白状态配置
    XYBlankSlateGeneralHandler *handler = [[XYBlankSlateGeneralHandler alloc] init];
    
    [handler setBackgroundColor:[UIColor clearColor] forState:XYDataLoadStateLoading | XYDataLoadStateEmpty | XYDataLoadStateFailed];
    handler.titleFont = [UIFont systemFontOfSize:16];
    handler.titleColor = [UIColor grayColor];
    handler.descriptionFont = [UIFont systemFontOfSize:14];
    handler.descriptionColor = [UIColor lightGrayColor];
    handler.buttonTitleFont = [UIFont systemFontOfSize:15];
    handler.buttonTitleColor = [UIColor whiteColor];
    
    //加载状态配置
    [handler setTitle:@"加载中..." forState:XYDataLoadStateLoading];
    [handler setImage:[UIImage imageNamed:@"loading"] forState:XYDataLoadStateLoading];
    [handler setImageAnimation:({
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
        animation.duration = 0.35;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        animation;
        
    }) forState:XYDataLoadStateLoading];
    [handler setAnimate:YES forState:XYDataLoadStateLoading];
    
    //无数据状态配置
    [handler setTitle:@"数据为空" forState:XYDataLoadStateEmpty];
    [handler setDescription:@"糟糕！这里什么都没有~" forState:XYDataLoadStateEmpty];
    [handler setImage:[UIImage imageNamed:@"empty"] forState:XYDataLoadStateEmpty];
    
    //加载错误状态配置
    [handler setImage:[UIImage imageNamed:@"error"] forState:XYDataLoadStateFailed];
    [handler setAttributedDescription:({
        //设置指定文字样式
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我们的东西不见了！"];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
        
        string;
    }) forState:XYDataLoadStateFailed];
    [handler setButtonTitle:@"重新载入" controlState:UIControlStateNormal forState:XYDataLoadStateFailed];
    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    UIImage *bgImage = [UIImage imageNamed:@"button_background"];
    bgImage = [[bgImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
    [handler setButtonBackgroundImage:bgImage controlState:UIControlStateNormal forState:XYDataLoadStateFailed];
    [handler setButtonBackgroundImage:bgImage controlState:UIControlStateHighlighted forState:XYDataLoadStateFailed];
    [handler setSpaceHeight:20 forState:XYDataLoadStateFailed];
    
    //点击按钮回调
    [handler setTapButtonHandler:^(UIButton *button) {
        
    } forState:XYDataLoadStateFailed];
    //禁止滚动
    handler.scrollable = NO;
    
    self.tableView.xy_handler = handler;
    
}

@end
