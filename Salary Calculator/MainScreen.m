#import "MainScreen.h"

@implementation MainScreen
#pragma mark - General Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrMonth = [[NSArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December",nil];
    
    
    NSUInteger days = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
    NSUInteger months = [calendar rangeOfUnit:NSMonthCalendarUnit
                                       inUnit:NSYearCalendarUnit
                                      forDate:today].length;
    
    startingYear = components.year;
    startingMonth = components.month - 1;
    for (int i = 1; i <= months; i++) {
        components.month = i;
        NSDate *month = [calendar dateFromComponents:components];
        days += [calendar rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:month].length;
    }
    
    arrYear = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        [arrYear addObject:[NSString stringWithFormat:@"%i", startingYear + i]];
    }
    
    selectedYear = 0;
    selectedMonth = startingMonth;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIButton Methods
- (IBAction)btnCalculate_Pressed:(id)sender {
    
    if ([txtMonthYear.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select Month & Year." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
    else if ([txtSalary.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter salary." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
    else {
        noDays = 0;
        deductions = 0;
        if ([txtDays.text length] > 0) {
            noDays = [txtDays.text floatValue];
        }
        if ([txtDeductions.text length] > 0) {
            deductions = [txtDeductions.text floatValue];
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *today = [NSDate date];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
        components.month = selectedMonth + 1;
        NSDate *month = [calendar dateFromComponents:components];
        int totalDays = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:month].length;
        
        float oneDaySalary = [txtSalary.text floatValue]/totalDays;
        
        float payableSalary = [txtSalary.text floatValue] - (deductions + (oneDaySalary * noDays));
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"Total Payable Salary %.02f", payableSalary] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
}
#pragma mark - Select Month & Year
- (IBAction)btnMonthYear_Pressed:(id)sender {
    
    [txtSalary resignFirstResponder];
    [txtDays resignFirstResponder];
    [txtDeductions resignFirstResponder];
    
    txtMonthYear.text = [NSString stringWithFormat:@"%@ & %@", [arrMonth objectAtIndex:selectedMonth], [arrYear objectAtIndex:selectedYear]];
    actionSheet = [[UIActionSheet alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, 320, 216)];
    picker.showsSelectionIndicator=YES;
    picker.dataSource = self;
    picker.delegate = self;
    [picker selectRow:selectedMonth inComponent:0 animated:YES];
    [picker selectRow:selectedYear inComponent:1 animated:YES];
    [actionSheet addSubview:picker];
    
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    tools.barStyle=UIBarStyleBlackOpaque;
    [actionSheet addSubview:tools];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnActinDoneClicked)];
    doneButton.imageInsets=UIEdgeInsetsMake(200, 6, 50, 25);
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,flexSpace,doneButton,nil];
    
    [tools setItems:array];
    
    //picker title
    UILabel *lblPickerTitle=[[UILabel alloc]initWithFrame:CGRectMake(60,8, 200, 25)];
    lblPickerTitle.text=@"Month & Year";
    lblPickerTitle.backgroundColor=[UIColor clearColor];
    lblPickerTitle.textColor=[UIColor whiteColor];
    lblPickerTitle.textAlignment=UITextAlignmentCenter;
    lblPickerTitle.font=[UIFont boldSystemFontOfSize:15];
    [tools addSubview:lblPickerTitle];
    
    [actionSheet showFromRect:CGRectMake(0,480, 320,256) inView:self.view animated:YES];
    [actionSheet setBounds:CGRectMake(0,0, 320, 480)];
    
}
- (void)btnActinDoneClicked {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark - UIPickerView Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [arrMonth count];
    }
    else {
        return [arrYear count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [arrMonth objectAtIndex:row];
    }
    else {
        return [arrYear objectAtIndex:row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedMonth = row;
    }
    else {
        selectedYear = row;
    }
    txtMonthYear.text = [NSString stringWithFormat:@"%@ & %@", [arrMonth objectAtIndex:selectedMonth], [arrYear objectAtIndex:selectedYear]];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [scrView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
@end
