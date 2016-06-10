//
//  ImageEffectCollectionViewCell.h
//  PhotoFrames
//
//  Created by Badal-PUB on 08/04/16.
//  Copyright © 2016 Badal-PUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEffectCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet GPUImageView *vwCellGPUImg;

@property (strong, nonatomic) IBOutlet UIButton *btnImageEffectCell;
@property (strong, nonatomic) IBOutlet UILabel *lblImageEffect;
@end
