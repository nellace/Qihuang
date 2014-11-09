//
//  DianboListViewController.h
//  QiHuangDJ
//
//  Created by 雅泰  on 14-10-11.
//  Copyright (c) 2014年 雅泰 . All rights reserved.
//

#import "MQLCustomViewController.h"

@interface DianboListViewController : MQLCustomViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionItem;

@property (nonatomic, strong) NSString *category;

@end
