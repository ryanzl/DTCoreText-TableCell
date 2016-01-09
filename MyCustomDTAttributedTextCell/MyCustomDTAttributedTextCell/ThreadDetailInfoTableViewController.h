//
//  ThreadDetailInfoTableViewController.h
//  JRsapp
//
//  Created by ryan on 16/1/7.
//  Copyright © 2016年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>
#import "MyDTLazyImageView.h"
#import "MyDTTextCell.h"
@interface ThreadDetailInfoTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@end
