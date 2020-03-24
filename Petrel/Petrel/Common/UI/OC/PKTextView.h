//
//  PKTextView.h
//  PKTextView
//
//  Created by glaszig on 14.03.13.
//  Copyright (c) 2013 glaszig. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PKTextView.
FOUNDATION_EXPORT double PKTextViewVersionNumber;

//! Project version string for PKTextView.
FOUNDATION_EXPORT const unsigned char PKTextViewVersionString[];


IB_DESIGNABLE

@interface PKTextView : UITextView

@property (copy, nonatomic) IBInspectable NSString *placeholder;
@property (nonatomic) IBInspectable double fadeTime;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;
@property (retain, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

@end
