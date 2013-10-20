//
//  FlickrPhotoTVC.m
//  SPoT
//
//  Created by Marcin Ekonomiuk on 21.04.2013.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentPhoto.h"

@interface FlickrPhotoTVC ()
@property (nonatomic, getter = isRunningOniPad) BOOL runningOniPad;

@end

@implementation FlickrPhotoTVC


- (void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    FlickrPhotoFormat formatPhoto=FlickrPhotoFormatLarge;
                    
                    if(self.isRunningOniPad)
                        formatPhoto=FlickrPhotoFormatOriginal;
                    
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:formatPhoto];
                    [RecentPhoto addPhoto:self.photos[indexPath.row]];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString*) titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE]description];
}

- (NSString*) subtitleForRow:(NSUInteger)row
{
    return  [self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"desc Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}
- (BOOL)isRunningOniPad
{
    if (!_runningOniPad) _runningOniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    return _runningOniPad;
}@end
