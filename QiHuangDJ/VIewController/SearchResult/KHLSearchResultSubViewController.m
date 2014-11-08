//
//  KHLSearchResultSubViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-11-4.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLSearchResultSubViewController.h"
#import "KHLInformationTableViewCell.h"
#import "InfomationViewController.h"
#import "DianboViewController.h"



#pragma mark - DEFINATION AND ENUMERATION

#define INFORMATION_CELL_PROPORTION (90.0f / 320.0f)
#define INFORMATION_MAJOR_TEXT_FONT_PROPORTION (14.0f / 320.0f)
#define INFORMATION_MEDIUM_TEXT_FONT_PROPORTION (12.0f / 320.0f)
#define INFORMATION_MINOR_TEXT_FONT_PROPORTION (10.0f / 320.0f)



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface KHLSearchResultSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KHLSearchResultSubViewController



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)datasource
{
    if (!_datasource) _datasource = [[NSMutableArray alloc] init];
    return _datasource;
}



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"搜索结果"];
        [self setFanhui];
    }
    
    return self;
}



#pragma mark - TABLE VIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * INFORMATION_CELL_PROPORTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    KHLInformationTableViewCell *iCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLInformationTableViewCell"];
    if (!iCell) {
        iCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLInformationTableViewCell" owner:self options:nil] firstObject];
    } if (!iCell) {
        iCell = [[KHLInformationTableViewCell alloc] init];
    }
    
    // Configure fonts..
    UIFont *majorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MAJOR_TEXT_FONT_PROPORTION)];
    UIFont *mediumFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MEDIUM_TEXT_FONT_PROPORTION)];
    UIFont *minorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MINOR_TEXT_FONT_PROPORTION)];
    [iCell.titleLabel setFont:majorFont];
    [iCell.dateLabel setFont:mediumFont];
    [iCell.descriptionLabel setFont:mediumFont];
    [iCell.browseCountingLabel setFont:minorFont];
    [iCell.posterLabel setFont:minorFont];
    
    // Acquire instance..
    SearchInterface *information = [self.datasource objectAtIndex:indexPath.row];
    
    // Configure thumb image view..
    if (information.imageUrl && ![information.imageUrl isEqualToString:@""]) {
        [iCell.thumbImageView setImageWithURL:[NSURL URLWithString:information.imageUrl]];
    } else {
        [iCell.thumbImageView setImage:[UIImage imageNamed:@"zhibo_huanchongtu@2x.png"]];
    }
    
    // Configure labels..
    iCell.titleLabel.text = information.title ? information.title : @"（无标题）";
    iCell.dateLabel.text = information.time ? information.time : @"";
    iCell.descriptionLabel.text = information.brief ? information.brief : @"";
    iCell.browseCountingLabel.text = information.count ? information.count : @"";
    iCell.posterLabel.text = information.publisher ? information.publisher : @"";
    
    // Asign table view cell..
    cell = iCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Acquire instance..
    SearchInterface *information = [self.datasource objectAtIndex:indexPath.row];
    UIViewController *detailViewController = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    // Configure prestrain and target view controller..
    if ([@"video" isEqualToString:information.type]) {
        detailViewController = [[DianboViewController alloc] init];
    } else if ([@"article" isEqualToString:information.type]) {
        detailViewController = [[InfomationViewController alloc] init];
        [(InfomationViewController *)detailViewController setPrestrain:information];
    } else {
        // 看来是搜到什么奇怪的东西了……
        return;
    }
    
    // Push to detail view controller..
    [self.navigationController pushViewController:detailViewController animated:TRUE];
}






















@end
