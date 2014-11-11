//
//  KHLPICAboutUsViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-17.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLPICAboutUsViewController.h"

@interface KHLPICAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation KHLPICAboutUsViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"关于七煌"];
    [self setFanhui];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc] init];
    parastyle.lineSpacing = 18.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: parastyle};
    NSString *text = @"　　上海七煌信息技术有限公司成立于2013年5月，注册资金2000万人民币，是一家以优化电竞产业结构、促进其多元发展为己任的新兴公司。公司分为行政区域以及教学区域两大块。行政区域位于上海市徐汇区，交通便利，为吸引人才提供了良好保障;教学区域位于上海松江大学城，具有良好的电竞氛围，是公司开展电竞教学业务的核心。\n　　公司在成立伊始即定下“携手相关产业共同发展，实现可持续互惠共赢”的大电竞战略。在发展过程中不断吸收业内人才，拥有了专业的制作团队和丰富的解说资源，为观众提供了全国电子竞技大赛（NEST)及OGN冬季赛、大师赛等国内外顶尖赛事直播。同时，七煌还着手举办较大规模的电竞赛事，以扩大品牌影响力；拍摄电竞主题电影，打造属于中国的电竞明星，推动电竞产业的多元发展。\n\n旗下栏目\n　　一、在“为中国电子竞技梦想护航发布会”上，七煌董事长孙博文正式宣布七煌获得OGN旗下所有节目版权，由七煌科技联合CJ集团、PandoraTV携手带来的高清OGN赛事官方转播，为广大中国英雄联盟玩家提供了了解世界顶级水平韩国英雄联盟赛事的渠道！\n　　二、OGN冠军赛为韩国CJ E&M公司旗下专业电子竞技电视台OnGameNet组织与承办的知名赛事。是由Riot认证的韩国唯一一个能获得LOL年度电子竞技全球联赛参赛资格的比赛。每年举办3个赛季，玩家每个星期都能看到精彩的赛事。比赛设有全球最丰厚的奖金池(超过 225,000美元) ，并设定了各类细分奖项，例如MVP ，最佳选手，以及各个位置打出最高战损比（KDA)的选手。七煌科技已获OnGameNet旗下所有节目在中国国内的版权，七煌的专业解说和优秀技术团队为大家带来高质量的比赛直播。\n　　三、七煌电子竞技落户于上海松江大学城，为广大玩家提供一个正规化的电竞训练平台，致力于培育德、智、体兼优，智能、体能、技能、俱佳的高素质电竞人才。无论你想当台前的明星还是幕后的英雄，我们都会为你的电竞保驾护航。让每一个热爱电子竞技的玩家都能展示自己的能力，只要你坚持信念，付出努力，就能获得成功\n　　四、全国电子竞技大赛（NEST)由国家体育总局体育信息中心与中国体育报业总社共同主办，北京华奥星空科技发展有限公司和浙报传媒集团股份有限公司承办，由杭州娃哈哈集团有限公司启力冠名赞助。七煌作为NEST的比赛直播方和特别合作方，全程独家直播NEST的线上比赛并转播了NEST的线下总决赛。\n　　五、义务国际电子竞技大赛（IET）由国家体育总局体育信息中心，浙江省体育局、中国体育报业总社共同主办，由义乌市人民政府和北京华奥星空科技发展有限公司承办。七煌是IET赛事的重要合作伙伴。\n\n七煌为梦想护航";
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
