//
//  KHLSearchResultViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-11-4.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLColor.h"
#import "KHLSearchResultViewController.h"
#import "KHLSearchResultSubViewController.h"
#import "KHLInformationTableViewCell.h"
#import "InfomationViewController.h"

#pragma mark - DEFINATIONS AND ENUMERATIONS

#define MAXIMUM_CELLS_IN_SECTION 2
#define INFORMATION_CELL_PROPORTION (90.0f / 320.0f)
#define INFORMATION_MAJOR_TEXT_FONT_PROPORTION (14.0f / 320.0f)
#define INFORMATION_MEDIUM_TEXT_FONT_PROPORTION (12.0f / 320.0f)
#define INFORMATION_MINOR_TEXT_FONT_PROPORTION (10.0f / 320.0f)
#define SECTION_HEADER_FONT_SIZE 14.0f
#define SECTION_HEADER_TEXT_PADDING 8.0f
#define SECTION_HEADER_HEIGHT 30.0f

typedef NS_ENUM(NSInteger, KHLSearchResultType) {
    KHLSearchResultTypeVideos = 0,
    KHLSearchResultTypeInformations = 1
};



#pragma mark - INTERFACE AND IMPLEMENTATION

@interface KHLSearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KHLSearchResultViewController



#pragma mark - ATTRIBUTES GETTER AND SETTER

- (NSMutableArray *)videos
{
    if (!_videos) _videos = [[NSMutableArray alloc] init];
    return _videos;
}

- (NSMutableArray *)informations
{
    if (!_informations) _informations = [[NSMutableArray alloc] init];
    return _informations;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KHLSearchResultTypeVideos) {
        return self.videos.count > MAXIMUM_CELLS_IN_SECTION ? MAXIMUM_CELLS_IN_SECTION : self.videos.count;
    }
    
    if (section == KHLSearchResultTypeInformations) {
        return self.informations.count > MAXIMUM_CELLS_IN_SECTION ? MAXIMUM_CELLS_IN_SECTION : self.informations.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * INFORMATION_CELL_PROPORTION;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SECTION_HEADER_HEIGHT)];
    header.backgroundColor = [KHLColor tubai];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SECTION_HEADER_TEXT_PADDING, 0, header.frame.size.width - SECTION_HEADER_TEXT_PADDING, header.frame.size.height)];
    label.font = [UIFont systemFontOfSize:SECTION_HEADER_FONT_SIZE];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1.0f)];
    head.backgroundColor = [KHLColor qinghui];
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 1.0f, self.view.frame.size.width, 1.0f)];
    foot.backgroundColor = [KHLColor qinghui];
    
    // Configure title..
    //  and tap gesture recognizer..
    if (section == KHLSearchResultTypeVideos) {
        label.text = @"视频";
        UITapGestureRecognizer *pressSectionHeaderRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSectionHeaderTypeVideos)];
        [label setUserInteractionEnabled:TRUE];
        [label addGestureRecognizer:pressSectionHeaderRecognizer];
    } else if (section == KHLSearchResultTypeInformations) {
        label.text = @"资讯";
        UITapGestureRecognizer *pressSectionHeaderRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSectionHeaderTypeInformations)];
        [label setUserInteractionEnabled:TRUE];
        [label addGestureRecognizer:pressSectionHeaderRecognizer];
    } else {
        label.text = @"";
    }
    
//     // Add press gesture recognizer to label..
//    UITapGestureRecognizer *pressSectionHeaderRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSectionHeaderRecognizer:)];
//    pressSectionHeaderRecognizer.view.tag = section;
//    NSLog(@"sec: %lu, tag: %lu", section, pressSectionHeaderRecognizer.view.tag);
//    [pressSectionHeaderRecognizer setValue:[NSString stringWithFormat:@"%lu", section] forKey:@"SectionType"];
//    [label setUserInteractionEnabled:TRUE];
//    [label addGestureRecognizer:pressSectionHeaderRecognizer];
    
    [header addSubview:label];
    [header addSubview:head];
    [header addSubview:foot];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1.0f)];
    footer.backgroundColor = [KHLColor qinghui];
    return footer;
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
    SearchInterface *information;
    if (indexPath.section == KHLSearchResultTypeVideos) {
    information = [self.videos objectAtIndex:indexPath.row];
    } else if (indexPath.section == KHLSearchResultTypeInformations) {
        information = [self.informations objectAtIndex:indexPath.row];
    }
    
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
    SearchInterface *information;
    if (indexPath.section == KHLSearchResultTypeVideos) {
        information = [self.videos objectAtIndex:indexPath.row];
    } else if (indexPath.section == KHLSearchResultTypeInformations) {
        information = [self.informations objectAtIndex:indexPath.row];
    }
    
    // Push to detail view controller..
    InfomationViewController *detailViewController = [[InfomationViewController alloc] init];
    [detailViewController setPrestrain:information];
    [self.navigationController pushViewController:detailViewController animated:TRUE];
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}



#pragma mark - GESTURE RECOGNIZATION

- (void)pressSectionHeaderTypeVideos
{
    KHLSearchResultSubViewController *subViewController = [[KHLSearchResultSubViewController alloc] init];
    subViewController.datasource = [self.videos copy];
    [self.navigationController pushViewController:subViewController animated:TRUE];
}

- (void)pressSectionHeaderTypeInformations
{
    KHLSearchResultSubViewController *subViewController = [[KHLSearchResultSubViewController alloc] init];
    subViewController.datasource = [self.informations copy];
    [self.navigationController pushViewController:subViewController animated:TRUE];
}










@end
