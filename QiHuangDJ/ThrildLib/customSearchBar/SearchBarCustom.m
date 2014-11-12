//
//  SearchBarCustom.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-23.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "SearchBarCustom.h"

@implementation SearchBarCustom

- (UISearchBar *)customSearchBarUI:(NSString *)searchBarstyle{
    //自定义搜索条左侧放大镜
//    [self setImage:[UIImage imageNamed:@"nav_icon_sousuo.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //自定义搜索条输入框背景图片
    [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchWithHomepage"] forState:UIControlStateNormal];

    if ([searchBarstyle isEqualToString:@"home"]) {
        //纯净模式
        self.searchBarStyle = UISearchBarStyleMinimal;
    }else {
        self.searchBarStyle = UISearchBarStyleProminent;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
