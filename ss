module top_module (
    input wire CLK_50MHZ,   
    input wire RESET_N,     
    input wire INC_BTN,     
    input wire DEC_BTN,     
    input wire SET_MODE_SW, 
    input wire TIME_MODE_SW,
    
    input wire ALARM_SET_SW,
    input wire STOPWATCH_SW,

    input wire BTN_USA, BTN_UK, BTN_RUSSIA,

    output wire [7:0] SEG_ANODE,
    output wire [7:0] SEG_DATA,
    output wire PIEZO_OUT
);

    wire [3:0] H_10, H_01, M_10, M_01, S_10, S_01;
    wire is_pm_w;
    wire alarm_ringing_w;
    wire reset_active_high = ~RESET_N;

    // Clock Module Instance
    clock_module clock_inst (
        .clk        (CLK_50MHZ),
        .reset      (reset_active_high),
        .inc_btn    (INC_BTN),
        .dec_btn    (DEC_BTN),
        .set_mode   (SET_MODE_SW),
        .time_mode  (TIME_MODE_SW),
        
        .btn_usa    (BTN_USA),
        .btn_uk     (BTN_UK),
        .btn_russia (BTN_RUSSIA),
        
        .alarm_set_sw (ALARM_SET_SW),
        .stopwatch_sw (STOPWATCH_SW),
        
        .alarm_ringing (alarm_ringing_w),

        .H_10(H_10), .H_01(H_01), .M_10(M_10), .M_01(M_01),
        .S_10(S_10), .S_01(S_01), .is_pm(is_pm_w)
    );

    // 7-Segment Display Driver Instance
    seven_seg_driver driver_inst (
        .clk        (CLK_50MHZ),
        .reset      (reset_active_high),
        .H_10(H_10), .H_01(H_01), .M_10(M_10), .M_01(M_01),
        .S_10(S_10), .S_01(S_01), .is_pm(is_pm_w),
        .time_mode  (TIME_MODE_SW),
        .seg_anode  (SEG_ANODE),
        .seg_data   (SEG_DATA)
    );
    
    // Piezo Buzzer Driver Instance
    piezo_music_driver music_inst (
        .clk        (CLK_50MHZ),
        .reset      (reset_active_high),
        .alarm_on   (alarm_ringing_w),
        .piezo_out  (PIEZO_OUT)
    );

endmodule
