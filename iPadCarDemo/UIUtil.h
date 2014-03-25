//
//  UIUtil.h
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//



@interface UIUtil : NSObject
{

}

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
+ (void) adjustButtonSizeToFitText:(UIButton*)button;

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
+ (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets;

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
+ (void) adjustLabelSizeToFitText:(UILabel*)label;

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
+ (void) adjustLabelHeightToFitText:(UILabel*)label;

//
// Returns the ideal height for the given text string.
//
+ (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// Returns the ideal size for the given text string.
//
+ (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setX:(CGFloat)xPos;

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setY:(CGFloat)yPos;

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
+ (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin;

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setWidth:(CGFloat)width;

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setHeight:(CGFloat)height;

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
+ (CGSize) view:(UIView*)view setSize:(CGSize)size;

//
// A helper method to set just the accessibility label and hint of the given view.
//
+ (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint;

//
// A helper method to set just the accessibility label and hint of the given view.
//
+ (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value;

//
// Removes all the subviews from the given view.
//
+ (void) viewRemoveAllSubviews:(UIView*)view;

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
+ (NSString*) letterizeString:(NSString*)str;

//
// A helper method to create a proper Setter Name.
//
+ (NSString*) properSetterName:(NSString*)str;

//
// Splits the given string on words and capitalizes each word.
//
+ (NSString*) capitalizeWordsInString:(NSString*)str;

//
// A helper method to set just the line break mode of the given UIButton.
//
+ (void) button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode;

//
// A helper method to set just the text alignment of the given UIButton.
//
+ (void) button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment;

//
// A helper method to set just the font of the given UIButton.
//
+ (void) button:(UIButton*)button setFont:(UIFont*)font;

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
+ (UIFont*) buttonGetFont:(UIButton*)button;

//
// Loads the nib with the given name and return the first UIView.
//
+ (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner;

+ (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement;

+ (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement;

//
// Calculate and returns the size that best fits the subviews of the given view.
//
+ (CGSize) sizeThatFitsView:(UIView*)view;

//
// Returns an autoreleased UIAccessibilityElement.
//
+ (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint;

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView;

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass;

//
// Displays the following message in a standard UIAlertView.
//
+ (void) alertMessage:(NSString*)message;

//
// A generic handler to deal with not implemented features.
//
+ (void) notYetImplementedHandler:(id)source;

@end
