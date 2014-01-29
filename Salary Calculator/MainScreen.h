#import <UIKit/UIKit.h>

@interface MainScreen : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIScrollView *scrView;
    IBOutlet UITextField *txtMonthYear;
    IBOutlet UIButton *btnMonthYear;
    IBOutlet UITextField *txtSalary;
    IBOutlet UITextField *txtDays;
    IBOutlet UITextField *txtDeductions;
    
    int startingYear;
    int startingMonth;
    int selectedYear;
    int selectedMonth;
    
    float noDays; //Leave Taken;
    float deductions;
    
    NSArray *arrMonth;
    NSMutableArray *arrYear;
    
    //
    UIActionSheet *actionSheet;
    UIPickerView *picker;
}
- (IBAction)btnMonthYear_Pressed:(id)sender;
- (IBAction)btnCalculate_Pressed:(id)sender;
@end
