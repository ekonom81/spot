//
//  TagsFlickrPhotoTVC.m
//  SPoT
//
//  Created by Marcin Ekonomiuk on 21.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "TagsFlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "TagFlickr.h"
#import "UIApplication+NetworkActivity.h"

@interface TagsFlickrPhotoTVC ()
@end

@implementation TagsFlickrPhotoTVC

@synthesize tags=_tags;

-(NSMutableArray*) tags
{
    if(!_tags){
        _tags=[[NSMutableArray alloc]init];
    }
    return _tags;
}

-(void) setTags:(NSMutableArray *)tags
{
    _tags=tags;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTagsPhotos];
    [self.refreshControl addTarget:self
                            action:@selector(loadTagsPhotos)
                  forControlEvents:UIControlEventValueChanged];
    
    
}

-(void)loadTagsPhotos
{
    
    [self.refreshControl beginRefreshing];
    dispatch_queue_t q=dispatch_queue_create("table view loading queue", NULL);
    dispatch_async(q, ^{
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        NSArray* photos = [FlickrFetcher stanfordPhotos];
        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tags removeAllObjects];
            [self sortPhotosByTag:photos];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}


-(TagFlickr*)findTagFlickr:(NSString*)tagName
{
    for(NSUInteger i=0;i<self.tags.count;i++)
    {
        TagFlickr* tag= [self.tags objectAtIndex:i];
        
        if([tagName isEqualToString:tag.tagName])
            return tag;
    }
    return Nil;
}

- (void) sortPhotosByTag:(NSArray*)photos
{
    for (NSUInteger row=0; row<photos.count; row++) {
        
        NSString* photoTags =[photos[row][FLICKR_TAGS]description];
        NSArray* tagArray=[photoTags componentsSeparatedByString:@" "];
        for(NSUInteger tagRow=0;tagRow<tagArray.count;tagRow++)
        {
            NSString* tag = [tagArray objectAtIndex:tagRow];
            if(![tag isEqualToString:@"cs193pspot"] && ![tag isEqualToString:@"portrait"] && ![tag isEqualToString:@"landscape"])
            {
                TagFlickr* tagFlickr=[self findTagFlickr:tag];
                if(!tagFlickr){
                    tagFlickr =[[TagFlickr alloc]init];
                    tagFlickr.tagName = tag;
                    [self.tags addObject:tagFlickr];
                }
                [tagFlickr.photos addObject:[photos objectAtIndex:row]];
            }
        }
    }
    //Sorting tag photos
    for(NSUInteger i=0;i<self.tags.count;++i)
    {
        TagFlickr* tag=[self.tags objectAtIndex:i];
        tag.photos = [[tag.photos sortedArrayUsingComparator:^NSComparisonResult(id id1,id id2){
            NSString *str1=[id1[FLICKR_PHOTO_TITLE]description];
            NSString *str2=[id2[FLICKR_PHOTO_TITLE]description];
            
            return [str1 compare:str2 options:NSCaseInsensitiveSearch];
            
        }]mutableCopy];
        
    }
    //Sorting tags
    self.tags = [[self.tags sortedArrayUsingComparator:^NSComparisonResult(id ptag1,id ptag2){
        
        TagFlickr *tag1=[(TagFlickr*)ptag1 init];
        TagFlickr *tag2=[(TagFlickr*)ptag2 init];
        return [tag1.tagName compare:tag2.tagName options:NSCaseInsensitiveSearch];
    }] mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (NSString*) titleForRow:(NSUInteger)row
{
    return [self.tags[row]tagName];
}

- (NSString*) subtitleForRow:(NSUInteger)row
{
    TagFlickr* tagFlickr= [self.tags objectAtIndex:row];
    return [NSString stringWithFormat:@"%d photos",tagFlickr.photos.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Tag Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    TagFlickr *tagFlickr= self.tags[indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:tagFlickr.photos];
                    [segue.destinationViewController setTitle:tagFlickr.tagName];
                }
            }
        }
    }
}

@end
