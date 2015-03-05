//
//  UIUtil.m
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//

#import "UIUtil.h"
#import "StringFunctions.h"
#import "NSString+Additions.h"
@implementation UIUtil

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
+ (void) adjustButtonSizeToFitText:(UIButton*)button
{
	[self adjustButtonSizeToFitText:button withInsets:UIEdgeInsetsZero];
}

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
+ (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets
{
	if (button != nil && [button titleForState:UIControlStateNormal] != nil)
	{
		CGSize idealSize = [self idealStringSize:[button titleForState:UIControlStateNormal] withWidth:FLT_MAX withFont:[self buttonGetFont:button]];
		//CGSize idealSize = [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
		
		idealSize.width = idealSize.width + insets.left + insets.right;
		idealSize.height = idealSize.height + insets.top + insets.bottom;
		
		if (idealSize.width >= 0 && idealSize.height >= 0)
		{
			CGRect btnFrame = button.frame;
			btnFrame.size = idealSize;
			button.frame = btnFrame;
		}
	}
}

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
+ (void) adjustLabelSizeToFitText:(UILabel*)label
{
	if (label != nil && label.text != nil)
	{
		CGSize idealSize = [[UIFactory sharedInstance] sizeWithMyFont:label.font withText:label.text withWidth:9999];// lineBreakMode:<#(NSLineBreakMode)#>
		
		//CGSize idealSize = [label.text sizeWithFont:label.font];
		
		if (idealSize.width >= 0 && idealSize.height >= 0)
		{
			label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, idealSize.width, idealSize.height);
		}
	}
}

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
+ (void) adjustLabelHeightToFitText:(UILabel*)label
{
	//	if (label != nil)
	//	{
	//		CGRect labelFrame = label.frame;
	//
	//		CGSize size = [self idealStringSize:label.text withWidth:labelFrame.size.width withFont:label.font];
	//		if (size.height >= 0)
	//		{
	//			label.frame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y, size.width, size.height);
	//		}
	//	}
	
	if (label != nil)
	{
		CGRect labelFrame = label.frame;
		
		CGFloat height = [self idealStringHeight:label.text withWidth:labelFrame.size.width withFont:label.font];
		if (height >= 0)
		{
			label.frame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y, labelFrame.size.width, height);
		}
	}
}

//
// Returns the ideal height for the given text string.
//
+ (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	return [self idealStringSize:text withWidth:width withFont:font].height;
}

//
// Returns the ideal size for the given text string.
//
+ (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	if (text == nil)
	{
		return CGSizeZero;
	}
	else
	{
		return [[UIFactory sharedInstance] sizeWithMyFont:font withText:text withWidth:width lineBreakMode:NSLineBreakByWordWrapping];
		//return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	}
}

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setX:(CGFloat)xPos
{
	CGPoint toReturn = CGPointZero;
	
	if (view != nil)
	{
		CGRect frame = view.frame;
		toReturn = CGPointMake(xPos, frame.origin.y);
		frame.origin = toReturn;
		view.frame = frame;
	}
	
	return toReturn;
}

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setY:(CGFloat)yPos
{
	CGPoint toReturn = CGPointZero;
	
	if (view != nil)
	{
		CGRect frame = view.frame;
		toReturn = CGPointMake(frame.origin.x, yPos);
		frame.origin = toReturn;
		view.frame = frame;
	}
	
	return toReturn;
}

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin
{
	if (view != nil)
	{
		CGRect frame = view.frame;
		frame.origin = origin;
		view.frame = frame;
	}
	
	return origin;
}

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setWidth:(CGFloat)width
{
	CGSize toReturn = CGSizeZero;
	
	if (view != nil)
	{
		CGRect frame = view.frame;
		toReturn = CGSizeMake(width, frame.size.height);
		frame.size = toReturn;
		view.frame = frame;
	}
	
	return toReturn;
}

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setHeight:(CGFloat)height
{
	CGSize toReturn = CGSizeZero;
	
	if (view != nil)
	{
		CGRect frame = view.frame;
		toReturn = CGSizeMake(frame.size.width, height);
		frame.size = toReturn;
		view.frame = frame;
	}
	
	return toReturn;
}

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setSize:(CGSize)size
{
	if (view != nil)
	{
		CGRect frame = view.frame;
		frame.size = size;
		view.frame = frame;
	}
	
	return size;
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
+ (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint
{
	[self view:view setAccessibilityLabel:label andHint:hint andValue:nil];
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
+ (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value
{
	if (view != nil)
	{
		if (label != nil && [view respondsToSelector:@selector(setAccessibilityLabel:)])
		{
			[view setAccessibilityLabel:label];
		}
		
		if (hint != nil && [view respondsToSelector:@selector(setAccessibilityHint:)])
		{
			[view setAccessibilityHint:hint];
		}
		
		if (value != nil && [view respondsToSelector:@selector(setAccessibilityValue:)])
		{
			[view setAccessibilityValue:value];
		}
	}
}

//
// Removes all the subviews from the given view.
//
+ (void) viewRemoveAllSubviews:(UIView*)view
{
	if (view == nil)
	{
		return;
	}
	
	NSArray* subviews = view.subviews;
	for (NSInteger i = [subviews count] - 1; i >= 0; i --)
	{
		[(UIView*)[subviews objectAtIndex:i] removeFromSuperview];
	}
}

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
+ (NSString*) letterizeString:(NSString*)str
{
	if (str != nil)
	{
		NSMutableString* letterized = [NSMutableString stringWithString:str];
		for (NSInteger i = [letterized length] - 1; i > 0; i --)
		{
			[letterized insertString:@" " atIndex:i];
		}
		
		return letterized;
	}
	
	return @"";
}
//
// A helper method to create a proper Setter Name.
//
+ (NSString*) properSetterName:(NSString*)str
{
	if (str != nil)
	{
		NSString *firstCh = [str substringFrom:0 to:1];
		NSString *rightPart = [str substringFromIndex:1];
		return [NSString stringWithFormat:@"%@%@",[firstCh capitalizedString],rightPart];
	}
	
	return nil;
}

//
// Splits the given string on words and capitalizes each word.
//
+ (NSString*) capitalizeWordsInString:(NSString*)str
{
	if (str == nil)
	{
		return @"";
	}
	
	NSMutableString* toReturn = [NSMutableString stringWithCapacity:[str length]];
	
	NSArray* words = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" +\n"]];
	if (words != nil && [words count] > 0)
	{
		for (NSString* aWord in words)
		{
			if ([toReturn length] > 0)
			{
				[toReturn appendString:@" "];
			}
			
			[toReturn appendString:[aWord capitalizedString]];
		}
	}
	
	return toReturn;
}

//
// A helper method to set just the line break mode of the given UIButton.
//
+ (void) button:(UIButton*)button setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
	if (button != nil)
	{
		button.titleLabel.lineBreakMode = lineBreakMode;
	}
}

//
// A helper method to set just the text alignment of the given UIButton.
//
+ (void) button:(UIButton*)button setTextAlignment:(NSTextAlignment)textAlignment
{
	if (button != nil && [button respondsToSelector:@selector(titleLabel)])
	{
		NSObject* aLabel = [button titleLabel];
		
		if ([aLabel isKindOfClass:[UILabel class]])
		{
			((UILabel*)aLabel).textAlignment = textAlignment;
		}
	}
}

//
// A helper method to set just the font of the given UIButton.
//
+ (void) button:(UIButton*)button setFont:(UIFont*)font
{
	if (button != nil && font != nil)
	{
		button.titleLabel.font = font;
	}
}

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
+ (UIFont*) buttonGetFont:(UIButton*)button
{
	if (button != nil)
	{
		if ([button respondsToSelector:@selector(titleLabel)])
		{
			return button.titleLabel.font;
		}
		else
		{
			//return button.font;
		}
	}
	
	return nil;
}

//
// Loads the nib with the given name and return the first UIView.
//
+ (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner
{
	NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
	if (![StringFunctions isEmpty:nibViews])
	{
		return [nibViews objectAtIndex:0];
	}
	
	return nil;
}

+ (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement
{
	[self replaceView:src withView:replacement];
	
	[replacement setTitle:[src titleForState:UIControlStateNormal] forState:UIControlStateNormal];
	
	return replacement;
}

+ (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement
{
	
	UIView* superview = src.superview;
	
	[src removeFromSuperview];
	
	replacement.frame = src.frame;
	replacement.autoresizesSubviews = src.autoresizesSubviews;
	replacement.autoresizingMask = src.autoresizingMask;
	
	[superview addSubview:replacement];
	
	
	return replacement;
}

//
// Calculate and returns the size that best fits the subviews of the given view.
//
+ (CGSize) sizeThatFitsView:(UIView*)view
{
	CGSize bestSize = CGSizeZero;
	
	if (view != nil)
	{
		NSArray* subviews = view.subviews;
		CGRect aRect = CGRectZero;
		for (UIView* v in subviews)
		{
			aRect = v.frame;
			if (CGRectGetMaxX(aRect) > bestSize.width)
			{
				bestSize.width = CGRectGetMaxX(aRect);
			}
			if (CGRectGetMaxY(aRect) > bestSize.height)
			{
				bestSize.height = CGRectGetMaxY(aRect);
			}
		}
	}
	
	return bestSize;
}

//
// Returns an autoreleased UIAccessibilityElement.
//
+ (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint
{
	return nil;
	/*
	 UIAccessibilityElement* element = [[[UIAccessibilityElement alloc] initWithAccessibilityContainer:container] autorelease];
	 
	 element.accessibilityFrame = frame;
	 element.accessibilityLabel = label;
	 element.accessibilityHint = hint;
	 
	 return element;
	 */
}

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView
{
	for (UIView* view in parentView.subviews)
	{
		if ([view isKindOfClass:[UIResponder class]])
		{
			if ([view isFirstResponder] == YES)
			{
				[view resignFirstResponder];
			}
		}
	}
}

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass
{
	for (UIView* view in parentView.subviews)
	{
		if ([view isKindOfClass:ofClass])
		{
			if ([view isFirstResponder] == YES)
			{
				[view resignFirstResponder];
			}
		}
	}
}

//
// Displays the following message in a standard UIAlertView.
//
+ (void) alertMessage:(NSString*)message
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

//
// A generic handler to deal with not implemented features.
//
+ (void) notYetImplementedHandler:(id)source
{
	NSString* message = @"This feature is coming soon.";
	
	//	NSString* message = @"Sorry, not yet implemented.";
	//	NSInteger randIndex = (rand() % 5);
	//	switch (randIndex)
	//	{
	//		case 0:
	//			message = @"Really sorry but not yet implemented.";
	//			break;
	//		case 1:
	//			message = @"Oh no! So sorry, not yet implemented.";
	//			break;
	//		case 2:
	//			message = @"Ugh! What? Sill not implemented? Nope.";
	//			break;
	//		case 3:
	//			message = @"Nope. Not implemented. Try again later.";
	//			break;
	//		case 4:
	//			message = @"That's right. We still don't have this working.";
	//			break;
	//		default:
	//			message = @"Bummer we dont have this working yet.";
	//			break;
	//	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end
