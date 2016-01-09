//
//  ThreadDetailInfoTableViewController.m
//  JRsapp
//
//  Created by ryan on 16/1/7.
//  Copyright © 2016年 ryan. All rights reserved.
//

#import "ThreadDetailInfoTableViewController.h"

@interface ThreadDetailInfoTableViewController (){
    NSCache *cellCache;
    NSCache *_imageSizeCache;

}
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *models2;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew1;

@end

@implementation ThreadDetailInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableVIew1.dataSource = self;
    self.tableVIew1.delegate = self;
    
    self.models = [NSMutableArray new];
    self.models2 = [NSMutableArray new];
    for (int i=0; i<10; i++) {
                NSString *string = [NSString stringWithFormat:@"<h1>Hello %d</h1><h1>Hello</h1><img  src=\"http://cdn.computerhope.com/computer-hope.jpg\">", i];
//        NSString *string = [NSString stringWithFormat:@"<p>Hello %d</p>", i];
        [self.models addObject:string];
    }
    for (int j=0; j<10; j++) {
        NSString *string = [NSString stringWithFormat:@"<h1>HelloWr %d</h1><h1>Hello</h1><img  src=\"http://cdn.computerhope.com/computer-hope.jpg\">", j];
        //        NSString *string = [NSString stringWithFormat:@"<p>Hello %d</p>", i];
        [self.models2 addObject:string];
    }
//    self.tableView.estimatedRowHeight = 44.0;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    cellCache = [[NSCache alloc] init];
    _imageSizeCache = [[NSCache alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}
//- (void)configureCell:(MyDTTextCell *)cell forIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    NSString *html = @"<h1>Hello %d</h1><h1>Hello</h1><img  src=\"http://cdn.computerhope.com/computer-hope.jpg\">";
//    
//    [cell setHTMLString:html];
//    
//}
// disable this method to get static height = better performance
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDTTextCell *cell = (MyDTTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
//        return [cell requiredRowHeightInTableView:tableView];
    CGFloat width = cell.attributedTextContextView.frame.size.width;
    CGFloat suggestedHeight = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width].height;
//
    return suggestedHeight + 50.0;
//    return  cell.attributedTextContextView.frame.size.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDTTextCell *cell = (MyDTTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
    return cell;
}

- (MyDTTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"attributed_text_cell_section_%ld_pid_%ld",(long)indexPath.section, (long)indexPath.row];
    MyDTTextCell *cell = [cellCache objectForKey:cacheKey];
    NSLog(@"cacheKey：%@，section:%d,row:%d",cacheKey,indexPath.section,indexPath.row);
    if (!cell) {
//        cell = [[MyDTTextCell alloc] initWithReuseIdentifier:cacheKey];
         cell = [tableView dequeueReusableCellWithIdentifier:@"myDTCoreTextCell"];
        cell.hasFixedRowHeight = NO;
//        [cell.textLabel setText:@"测试"];
//        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//        subView.backgroundColor = [UIColor yellowColor];
//        [cell.contentView addSubview:subView];
//        cell.contentView.bounds = CGRectMake(0, 0, 100, 40);
        [cell setTextDelegate: self];
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        
        cell.attributedTextContextView.backgroundColor = [UIColor redColor];
        [cellCache setObject:cell forKey:cacheKey];
//        if (indexPath.section == 0) {
//            [cell setHTMLString:[self.models objectAtIndex:indexPath.row]];
//        }else if(indexPath.section == 1){
//            [cell setHTMLString:[self.models2 objectAtIndex:indexPath.row]];
//        }
        
//        cell.attributedTextContextView.backgroundColor = [UIColor redColor];
//        cell.attributedTextContextView.bounds = CGRectMake(80, 60, 100, 40);
    }
    
    if (indexPath.section == 0) {
        [cell setHTMLString:[self.models objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 1){
        [cell setHTMLString:[self.models2 objectAtIndex:indexPath.row]];
    }
    
    
    for (DTTextAttachment *oneAttachment in cell.attributedTextContextView.layoutFrame.textAttachments) {
        NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
        if (sizeValue) {
            cell.attributedTextContextView.layouter=nil;
            oneAttachment.displaySize = [sizeValue CGSizeValue];
        }
    }
    
    [cell.attributedTextContextView relayoutText];
    return cell;
}



#pragma mark -DTAttributedTextContentView Delegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        MyDTLazyImageView *imageView = [[MyDTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.image = [(DTImageTextAttachment *)attachment image];
        imageView.textContentView = attributedTextContentView;
        // url for deferred loading
        imageView.url = attachment.contentURL;
        return imageView;
        
        
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        //        [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            [_imageSizeCache setObject:[NSValue valueWithCGSize:[image size]] forKey:imageURL];
        //            [self.tableView reloadData];
        //        }];
       
    }
    return nil;
}
- (void)lazyImageView:(MyDTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size
{
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
//    // update all attachments that matching this URL
//    for (DTTextAttachment *oneAttachment in [lazyImageView.textContentView.layoutFrame textAttachmentsWithPredicate:pred])
//    {
//        oneAttachment.originalSize = size;
//    }
//    
//    // need to reset the layouter because otherwise we get the old framesetter or cached layout frames
//    lazyImageView.textContentView.layouter = nil;
//    
//    // here we're layouting the entire string,
//    // might be more efficient to only relayout the paragraphs that contain these attachments
//    [lazyImageView.textContentView relayoutText];
    
    BOOL didUpdate = NO;
    
    // update all attachments that matchin this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [lazyImageView.textContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = size;
            NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
            if (!sizeValue) {
                [_imageSizeCache setObject:[NSValue valueWithCGSize:size]forKey:url];
            }
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
//        lazyImageView.textContentView.layouter = nil;
        // layout might have changed due to image sizes
//        [lazyImageView.textContentView relayoutText];
        [self.tableView  reloadData];
        
    }
}

@end
