//
//  GeneralController.m
//  XYBlankSlateDemo
//
//  Created by xiayingying on 2018/8/31.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "GeneralController.h"
#import "GeneralViewModel.h"
#import "XYBlankSlate.h"
#import <MJRefresh/MJRefresh.h>
#import "WebViewController.h"

@interface GeneralController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray<GeneralModel *> *list;
@property (nonatomic, strong) GeneralViewModel      *viewModel;
@property (nonatomic, assign) NSInteger             page;

@end

@implementation GeneralController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

#pragma mark - Lazyloading
- (NSMutableArray<GeneralModel *> *)list {
    if (_list) {
        return _list;
    }
    
    _list = [NSMutableArray array];
    
    return _list;
}

- (GeneralViewModel *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    
    _viewModel = [[GeneralViewModel alloc] init];
    
    return _viewModel;
}

#pragma mark - Private
- (void)setupUI {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //设置tableView的header和footer
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullToRefresh];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self pullToLoading];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    //首次进入先隐藏footer
    self.tableView.mj_footer.hidden = YES;
    
    //设置空白页
    [self setupBlankSlate];
}

/**********************************/
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
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    handler.verticalOffset = -offset;
    //handler.verticalOffset = -roundf(self.tableView.frame.size.height/5);
    self.tableView.xy_handler = handler;
}
/**********************************/

- (void)loadData {
    //显示加载状态页
    if (self.mode == XYDisplayModeLoading) {
        self.tableView.xy_handler.state = XYDataLoadStateLoading;
        return;
    }
    //显示空数据页
    if (self.mode == XYDisplayModeEmpty) {
        self.tableView.xy_handler.state = XYDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.xy_handler.state = XYDataLoadStateEmpty;
        });
        return;
    }
    //显示加载错误页
    if (self.mode == XYDisplayModeFail) {
        self.tableView.xy_handler.state = XYDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.xy_handler.state = XYDataLoadStateFailed;
        });
        return;
    }
    //显示正常加载页
    if (self.mode == XYDisplayModeSuccess) {
        self.tableView.xy_handler.state = XYDataLoadStateLoading;
        [self pullToRefresh];
    }
}

//下拉刷新
- (void)pullToRefresh {
    self.page = 1;
    //请求数据
    [self.viewModel queryListWithPage:self.page success:^{
        [self.list removeAllObjects];
        
        //插入数据
        [self.list addObjectsFromArray:self.viewModel.list];
        
        if (self.viewModel.list.count == 0) {
            //无数据的情况
            //置为空数据状态
            self.tableView.xy_handler.state = XYDataLoadStateEmpty;
            //隐藏footer
            self.tableView.mj_footer.hidden = YES;
        } else {
            //有数据的情况
            //置为闲置状态
            self.tableView.xy_handler.state = XYDataLoadStateIdle;
            //设置footer显示状态
            self.tableView.mj_footer.hidden = self.list.count < 10;
            //刷新tableView
            [self.tableView reloadData];
        }
        
        //如果是刷新状态则停止刷新
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        if (self.list.count == 0) {
            self.tableView.xy_handler.state = XYDataLoadStateFailed;
        }
        //如果是刷新状态则停止刷新
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

//上拉加载
- (void)pullToLoading {
    self.page ++;
    [self.viewModel queryListWithPage:self.page success:^{
        //插入数据
        [self.list addObjectsFromArray:self.viewModel.list];
        
        if (self.viewModel.list.count == 0) {
            //显示已全部加载
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            //刷新tableView
            [self.tableView reloadData];
        }
        //停止加载状态
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        //停止加载状态
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simple" forIndexPath:indexPath];
    
    GeneralModel *model = self.list[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText = ({
        NSString *text = [NSString stringWithFormat:@"%@<%@>", model.desc, model.who];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(model.desc.length, model.who.length + 2)];
        
        attributedString;
    });
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = self.list[indexPath.row].url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
