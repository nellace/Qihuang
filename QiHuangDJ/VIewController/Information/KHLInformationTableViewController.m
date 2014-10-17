//
//  KHLInformationTableViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-17.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLInformationTableViewController.h"
#import "KHLInformationTableViewCell.h"
#import "InfomationViewController.h"

@interface KHLInformationTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KHLInformationTableViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"资讯列表"];
    [self setFanhui];
}



#pragma mark - TABLE VIEW CONTROLLER DELEGATE

#define INFORMATION_CELL_PROPORTION (90.0f / 320.0f)
#define INFORMATION_MAJOR_TEXT_FONT_PROPORTION (14.0f / 320.0f)
#define INFORMATION_MEDIUM_TEXT_FONT_PROPORTION (12.0f / 320.0f)
#define INFORMATION_MINOR_TEXT_FONT_PROPORTION (10.0f / 320.0f)

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * INFORMATION_CELL_PROPORTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    KHLInformationTableViewCell *infoCell = [self.tableView dequeueReusableCellWithIdentifier:@"KHLInformationTableViewCell"];
    if (infoCell == nil) {
        infoCell = [[[NSBundle mainBundle] loadNibNamed:@"KHLInformationTableViewCell" owner:self options:nil] firstObject];
    } if (infoCell == nil) {
        infoCell = [[KHLInformationTableViewCell alloc] init];
    }
    
    // Configure fonts..
    UIFont *majorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MAJOR_TEXT_FONT_PROPORTION)];
    UIFont *mediumFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MEDIUM_TEXT_FONT_PROPORTION)];
    UIFont *minorFont = [UIFont systemFontOfSize:(self.view.frame.size.width * INFORMATION_MINOR_TEXT_FONT_PROPORTION)];
    [infoCell.titleLabel setFont:majorFont];
    [infoCell.dateLabel setFont:mediumFont];
    [infoCell.descriptionLabel setFont:mediumFont];
    [infoCell.browseCountingLabel setFont:minorFont];
    [infoCell.posterLabel setFont:minorFont];
    
    // Configure thumb image view..
    if (indexPath.row % 3 == 0) {
        [infoCell.thumbImageView setImage:[UIImage imageNamed:@"mings-cavalry-anti-japanese-samurai"]];
    } else if (indexPath.row % 3 == 1) {
        [infoCell.thumbImageView setImage:[UIImage imageNamed:@"mings-student-on-journey"]];
    } else {
        [infoCell.thumbImageView setImage:[UIImage imageNamed:@"mings-ships-sailing"]];
    }
    
    // Configure labels..
    infoCell.titleLabel.text = @"喵描秒妙喵描秒妙喵描秒妙";
    infoCell.dateLabel.text = @"1544.12.22";
    NSString *description = @"霓为衣兮风为马。";
    if (indexPath.row % 3 == 0) description = @"绛罗朱袖起飞云，大武明华瞰雄州。";
    if (indexPath.row % 3 == 1) description = @"上元点鬟招萼绿，王母挥袂别飞琼。繁音急节十二遍，跳珠撼玉何铿铮。翔鸾舞了却收翅，唳鹤曲终长引声。当时乍见惊心目，凝视谛听殊未足。一落人间八九年，耳冷不曾闻此曲。湓城但听山魈语，巴峡唯闻杜鹃哭。";
    infoCell.descriptionLabel.text = description;
    infoCell.browseCountingLabel.text = [NSString stringWithFormat:@"浏览%.0f次", (2000.0f + 17 * indexPath.row)];
    infoCell.posterLabel.text = @"喵了个咪的";
    
    // Asign table view cell..
    cell = infoCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfomationViewController *infoViewController = [[InfomationViewController alloc] init];
    [self.navigationController pushViewController:infoViewController animated:TRUE];
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

@end
