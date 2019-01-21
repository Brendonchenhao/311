`default_nettype none
module Basic_Organ_Solution(

    //////////// CLOCK //////////
    CLOCK_50,

    //////////// LED //////////
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,

    //////////// Audio //////////
    AUD_ADCDAT,
    AUD_ADCLRCK,
    AUD_BCLK,
    AUD_DACDAT,
    AUD_DACLRCK,
    AUD_XCK,

    //////////// I2C for Audio  //////////
    FPGA_I2C_SCLK,
    FPGA_I2C_SDAT,
    
    //////// GPIO //////////
    GPIO_0,
    GPIO_1,
    
);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [9:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input            [9:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;

//////////// Audio //////////
input                       AUD_ADCDAT;
inout                       AUD_ADCLRCK;
inout                       AUD_BCLK;
output                      AUD_DACDAT;
inout                       AUD_DACLRCK;
output                      AUD_XCK;

//////////// I2C for Audio  //////////
output                      FPGA_I2C_SCLK;
inout                       FPGA_I2C_SDAT;

//////////// GPIO //////////
inout           [35:0]      GPIO_0;
inout           [35:0]      GPIO_1;                             


//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [7:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDR[7:0] = LED[7:0];


wire            [7:0]      LCD_DATA;
wire                       LCD_EN;
wire                       LCD_ON;
wire                       LCD_RS;
wire                       LCD_RW;

assign GPIO_0[7:0] = LCD_DATA;
assign GPIO_0[8] = LCD_EN;
assign GPIO_0[9] = LCD_ON;
assign GPIO_0[10] = LCD_RS;
assign GPIO_0[11] = LCD_RS;
assign GPIO_0[12] = LCD_RW;


//Character definitions

//numbers
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'


wire Clock_1KHz, Clock_1Hz;
wire Sample_Clk_Signal;

//=======================================================================================================================
//
// Insert your code for Lab1 here!
//
//
assign Sample_Clk_Signal = Clock_1KHz;

// DEBUG: Lab 1 code start
wire [31:0] Do_L;
wire [31:0] Re; 
wire [31:0] Mi; 
wire [31:0] Fa; 
wire [31:0] So; 
wire [31:0] La; 
wire [31:0] Si; 
wire [31:0] Do_H;

assign  Do_L[31:0] = 32'd47801;
assign  Re[31:0] = 32'd42589;
assign  Mi[31:0] = 32'd37936;
assign  Fa[31:0] = 32'd35816;
assign  So[31:0] = 32'd31928;
assign  La[31:0] = 32'd28409;
assign  Si[31:0] = 32'd25329;
assign  Do_H[31:0] = 32'd23900;

wire Do_L_CLK, Re_CLK, Mi_CLK, Fa_CLK, So_CLK, La_CLK, Si_CLK, Do_H_CLK;

Generate_Arbitrary_Divided_Clk32 
Gen_Do_L_CLK
(
.inclk(CLK_50M),
.outclk(Do_L_CLK),
.outclk_Not(),
.div_clk_count(Do_L), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_Re_CLK
(
.inclk(CLK_50M),
.outclk(Re_CLK),
.outclk_Not(),
.div_clk_count(Re), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_Mi_CLK
(
.inclk(CLK_50M),
.outclk(Mi_CLK),
.outclk_Not(),
.div_clk_count(Mi), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_Fa_CLK
(
.inclk(CLK_50M),
.outclk(Fa_CLK),
.outclk_Not(),
.div_clk_count(Fa), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_So_CLK
(
.inclk(CLK_50M),
.outclk(So_CLK),
.outclk_Not(),
.div_clk_count(So), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_La_CLK
(
.inclk(CLK_50M),
.outclk(La_CLK),
.outclk_Not(),
.div_clk_count(La), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_Si_CLK
(
.inclk(CLK_50M),
.outclk(Si_CLK),
.outclk_Not(),
.div_clk_count(Si), 
.Reset(1'h1)); 

Generate_Arbitrary_Divided_Clk32 
Gen_Do_H_CLK
(
.inclk(CLK_50M),
.outclk(Do_H_CLK),
.outclk_Not(),
.div_clk_count(Do_H), 
.Reset(1'h1)); 

//Audio Generation Signal
//Note that the audio needs signed data - so convert 1 bit to 8 bits signed
// TODO: this is how audio are created. It's just the clock. 

//TODO: Task 1 & 2: 
// Audio: Let's build an organ tone one octave. That
// is, let's generate the notes "Do Re Mi Fa So La Si
// Do". Sound frequencies of these notes are: [ 523Hz 587Hz
// 659Hz 698Hz 783Hz 880Hz 987Hz 1046Hz ]. To do so, make a
// clock division controllable from the switches SW[3:1]. To
// start, you can use the module
// Generate_Arbitrary_Divided_Clk32 (which is not documented by
// the way, if you want to use it have to do "reverse
// engineering"), but in the version that you submit you must
// build your own clock divider. Clock dividers are a special
// type of counter which is controllable by the switches SW
// [3:1] to get the desired frequency. One of the objectives of
// this lab is to design that frequency divisor.
wire [7:0] audio_data; //generate signed sample audio signal
wire Organ_CLK_Signal;
always_comb begin
    case (SW[3:1])
        3'b000: Organ_CLK_Signal = Do_L_CLK;
        3'b001: Organ_CLK_Signal = Re_CLK;
        3'b010: Organ_CLK_Signal = Mi_CLK;
        3'b011: Organ_CLK_Signal = Fa_CLK;
        3'b100: Organ_CLK_Signal = So_CLK;
        3'b101: Organ_CLK_Signal = La_CLK;
        3'b110: Organ_CLK_Signal = Si_CLK;
        3'b111: Organ_CLK_Signal = Do_H_CLK;
        default: Organ_CLK_Signal = Sample_Clk_Signal;
    endcase
end
assign audio_data = {(~Organ_CLK_Signal),{7{Organ_CLK_Signal}}} & SW[0];

// TODO: Task 5
wire shift_left;

reg [2:0] rst_pipe = 3'b11;
wire reset = rst_pipe[2];


always @(posedge Clock_1Hz) 
begin
    rst_pipe <= {rst_pipe, 1'b0};
    if (reset) begin
        {shift_left, LED} <= {1'b0, 8'b00000001};
    end
    else begin
    casex ({shift_left, LED[7], LED[0]})
      3'b110:{shift_left, LED} <= {1'b0, 8'b01000000};
      3'b001:{shift_left, LED} <= {1'b1, 8'b00000010};
      3'b1xx:{shift_left, LED} <= {shift_left, LED << 1};
      3'b0xx:{shift_left, LED} <= {shift_left, LED >> 1};
      default: {shift_left, LED} <= {1'b1, {7{1'b0}}, 1'b1};
    endcase
    end

end

// DEBUG: Lab 1 code end
                

//=====================================================================================
//
// LCD Scope Acquisition Circuitry Wire Definitions                 
//
//=====================================================================================

wire allow_run_LCD_scope;
wire [15:0] scope_channelA, scope_channelB;
(* keep = 1, preserve = 1 *) wire scope_clk;
reg user_scope_enable_trigger;
wire user_scope_enable;
wire user_scope_enable_trigger_path0, user_scope_enable_trigger_path1;
wire scope_enable_source = SW[8];
wire choose_LCD_or_SCOPE =  SW[9];


doublesync user_scope_enable_sync1(.indata(scope_enable_source),
                  .outdata(user_scope_enable),
                  .clk(CLK_50M),
                  .reset(1'b1)); 

//Generate the oscilloscope clock
Generate_Arbitrary_Divided_Clk32 
Generate_LCD_scope_Clk(
.inclk(CLK_50M),
.outclk(scope_clk),
.outclk_Not(),
.div_clk_count(scope_sampling_clock_count),
.Reset(1'h1));

//Scope capture channels

(* keep = 1, preserve = 1 *) logic ScopeChannelASignal;
(* keep = 1, preserve = 1 *) logic ScopeChannelBSignal;

// assign ScopeChannelASignal = Sample_Clk_Signal;
assign ScopeChannelBSignal = SW[1];

scope_capture LCD_scope_channelA(
.clk(scope_clk),
.the_signal(ScopeChannelASignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelA),
.reset(1'b1));

scope_capture LCD_scope_channelB
(
.clk(scope_clk),
.the_signal(ScopeChannelBSignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelB),
.reset(1'b1));

assign LCD_ON   = 1'b1;
//The LCD scope and display


// DEBUG: Lab 1 task 3 start
 // TODO: Task 3, change the info message with different choice.
// "Do Re Mi Fa So La Si
// Do". Sound frequencies of these notes are: [ 523Hz 587Hz
// 659Hz 698Hz 783Hz 880Hz 987Hz 1046Hz ]
wire [31:0] scope_info_A;

always_comb begin
    case (SW[3:1])
        3'b000: {ScopeChannelASignal, scope_info_A} = {Do_L_CLK, character_D, character_lowercase_o, character_space, character_space};
        3'b001: {ScopeChannelASignal, scope_info_A} = {Re_CLK, character_R, character_lowercase_e, character_space, character_space};
        3'b010: {ScopeChannelASignal, scope_info_A} = {Mi_CLK, character_M, character_lowercase_i, character_space, character_space};
        3'b011: {ScopeChannelASignal, scope_info_A} = {Fa_CLK, character_F, character_lowercase_a, character_space, character_space};
        3'b100: {ScopeChannelASignal, scope_info_A} = {So_CLK, character_S, character_lowercase_o, character_space, character_space};
        3'b101: {ScopeChannelASignal, scope_info_A} = {La_CLK, character_L, character_lowercase_a, character_space, character_space};
        3'b110: {ScopeChannelASignal, scope_info_A} = {Si_CLK, character_S, character_lowercase_i, character_space, character_space};
        3'b111: {ScopeChannelASignal, scope_info_A} = {Do_H_CLK, character_D, character_lowercase_o, character_2, character_space};
        default: {ScopeChannelASignal, scope_info_A} = {Sample_Clk_Signal, character_W, character_H, character_A, character_T};
    endcase
end

//TODO: Task 4, change the content in LCD line 1 and 2

wire [7:0] audio_clk_message; 
wire [7:0] switches_message;

always_comb begin
    case (SW[3:1])
        3'b000: {audio_clk_message, switches_message} = {8'd523, 8'd1};
        3'b001: {audio_clk_message, switches_message} = {8'd587, 8'd2};
        3'b010: {audio_clk_message, switches_message} = {8'd659, 8'd3};
        3'b011: {audio_clk_message, switches_message} = {8'd698, 8'd4};
        3'b100: {audio_clk_message, switches_message} = {8'd783, 8'd5};
        3'b101: {audio_clk_message, switches_message} = {8'd880, 8'd6};
        3'b110: {audio_clk_message, switches_message} = {8'd987, 8'd7};
        3'b111: {audio_clk_message, switches_message} = {8'd1046, 8'd8};
        default: {audio_clk_message, switches_message} = {8'd1000, 8'd0};
    endcase
end


// DEBUG: Lab 1 task 3 end

LCD_Scope_Encapsulated_pacoblaze_wrapper LCD_LED_scope(
                        //LCD control signals
                    .lcd_d(LCD_DATA),//don't touch
                    .lcd_rs(LCD_RS), //don't touch
                    .lcd_rw(LCD_RW), //don't touch
                    .lcd_e(LCD_EN), //don't touch
                    .clk(CLK_50M),  //don't touch
                          
                        //LCD Display values
                      .InH(audio_clk_message),
                      .InG(switches_message),
                      .InF(8'h01),
                       .InE(8'h23),
                      .InD(8'h45),
                      .InC(8'h67),
                      .InB(8'h89),
                     .InA(8'h00),
                          
                     //LCD display information signals
                     
                         .InfoH({character_L,character_E}),
                          .InfoG({character_T,character_space}),
                          .InfoF({character_M,character_E}),
                          .InfoE({character_space,character_O}),
                          .InfoD({character_U,character_T}),
                          .InfoC({character_space,character_P}),
                          .InfoB({character_L,character_S}),
                          .InfoA({character_exclaim,character_space}),
                          
                  //choose to display the values or the oscilloscope
                          .choose_scope_or_LCD(choose_LCD_or_SCOPE),
                          
                  //scope channel declarations
                          .scope_channelA(scope_channelA), //don't touch
                          .scope_channelB(scope_channelB), //don't touch
                          
                  //scope information generation
                          .ScopeInfoA(scope_info_A),
                          .ScopeInfoB({character_S, character_W, character_1, character_space}),
                          
                 //enable_scope is used to freeze the scope just before capturing 
                 //the waveform for display (otherwise the sampling would be unreliable)
                          .enable_scope(allow_run_LCD_scope) //don't touch
                          
    );  
    

//=====================================================================================
//
//  Seven-Segment and speed control
//
//=====================================================================================

wire speed_up_event, speed_down_event;

//Generate 1 KHz Clock
// TODO: THis is how clocks are generated. 
Generate_Arbitrary_Divided_Clk32 
Gen_1KHz_clk
(
.inclk(CLK_50M),
.outclk(Clock_1KHz),
.outclk_Not(),
.div_clk_count(32'h61A6), //change this if necessary to suit your module
.Reset(1'h1)); 

wire speed_up_raw;
wire speed_down_raw;

doublesync 
key0_doublsync
(.indata(!KEY[0]),
.outdata(speed_up_raw),
.clk(Clock_1KHz),
.reset(1'b1));


doublesync 
key1_doublsync
(.indata(!KEY[1]),
.outdata(speed_down_raw),
.clk(Clock_1KHz),
.reset(1'b1));


parameter num_updown_events_per_sec = 10;
parameter num_1KHZ_clocks_between_updown_events = 1000/num_updown_events_per_sec;

reg [15:0] updown_counter = 0;
always @(posedge Clock_1KHz)
begin
      if (updown_counter >= num_1KHZ_clocks_between_updown_events)
      begin
            if (speed_up_raw)
            begin
                  speed_up_event_trigger <= 1;          
            end 
            
            if (speed_down_raw)
            begin
                  speed_down_event_trigger <= 1;            
            end 
            updown_counter <= 0;
      end
      else 
      begin
           updown_counter <= updown_counter + 1;
           speed_up_event_trigger <=0;
           speed_down_event_trigger <= 0;
      end     
end

wire speed_up_event_trigger;
wire speed_down_event_trigger;

async_trap_and_reset_gen_1_pulse 
make_speedup_pulse
(
 .async_sig(speed_up_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_up_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );
 
async_trap_and_reset_gen_1_pulse 
make_speedown_pulse
(
 .async_sig(speed_down_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_down_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );


wire speed_reset_event; 

doublesync 
key2_doublsync
(.indata(!KEY[2]),
.outdata(speed_reset_event),
.clk(CLK_50M),
.reset(1'b1));

parameter oscilloscope_speed_step = 100;

wire [15:0] speed_control_val;                      
speed_reg_control 
speed_reg_control_inst
(
.clk(CLK_50M),
.up_event(speed_up_event),
.down_event(speed_down_event),
.reset_event(speed_reset_event),
.speed_control_val(speed_control_val)
);

logic [15:0] scope_sampling_clock_count;
parameter [15:0] default_scope_sampling_clock_count = 12499; //2KHz


always @ (posedge CLK_50M) 
begin
    scope_sampling_clock_count <= default_scope_sampling_clock_count+{{16{speed_control_val[15]}},speed_control_val};
end 

        
        
logic [7:0] Seven_Seg_Val[5:0];
logic [3:0] Seven_Seg_Data[5:0];
    
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));

assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];

            
wire Clock_2Hz;
            
Generate_Arbitrary_Divided_Clk32 
Gen_2Hz_clk
(.inclk(CLK_50M),
.outclk(Clock_2Hz),
.outclk_Not(),
.div_clk_count(32'h17D7840 >> 1),
.Reset(1'h1)
); 
        
logic [23:0] actual_7seg_output;
reg [23:0] regd_actual_7seg_output;

always @(posedge Clock_2Hz)
begin
    regd_actual_7seg_output <= actual_7seg_output;
    Clock_1Hz <= ~Clock_1Hz;
end


assign Seven_Seg_Data[0] = regd_actual_7seg_output[3:0];
assign Seven_Seg_Data[1] = regd_actual_7seg_output[7:4];
assign Seven_Seg_Data[2] = regd_actual_7seg_output[11:8];
assign Seven_Seg_Data[3] = regd_actual_7seg_output[15:12];
assign Seven_Seg_Data[4] = regd_actual_7seg_output[19:16];
assign Seven_Seg_Data[5] = regd_actual_7seg_output[23:20];

    
assign actual_7seg_output =  scope_sampling_clock_count;




//=======================================================================================================================
//
//   Audio controller code - do not touch
//
//========================================================================================================================
wire [$size(audio_data)-1:0] actual_audio_data_left, actual_audio_data_right;
wire audio_left_clock, audio_right_clock;

to_slow_clk_interface 
interface_actual_audio_data_right
 (.indata(audio_data),
  .outdata(actual_audio_data_right),
  .inclk(CLK_50M),
  .outclk(audio_right_clock));
   
   
to_slow_clk_interface 
interface_actual_audio_data_left
 (.indata(audio_data),
  .outdata(actual_audio_data_left),
  .inclk(CLK_50M),
  .outclk(audio_left_clock));
   

audio_controller 
audio_control(
  // Clock Input (50 MHz)
  .iCLK_50(CLK_50M), // 50 MHz
  .iCLK_28(), // 27 MHz
  //  7-SEG Displays
  // I2C
  .I2C_SDAT(FPGA_I2C_SDAT), // I2C Data
  .oI2C_SCLK(FPGA_I2C_SCLK), // I2C Clock
  // Audio CODEC
  .AUD_ADCLRCK(AUD_ADCLRCK),                    //  Audio CODEC ADC LR Clock
  .iAUD_ADCDAT(AUD_ADCDAT),                 //  Audio CODEC ADC Data
  .AUD_DACLRCK(AUD_DACLRCK),                    //  Audio CODEC DAC LR Clock
  .oAUD_DACDAT(AUD_DACDAT),                 //  Audio CODEC DAC Data
  .AUD_BCLK(AUD_BCLK),                      //  Audio CODEC Bit-Stream Clock
  .oAUD_XCK(AUD_XCK),                       //  Audio CODEC Chip Clock
  .audio_outL({actual_audio_data_left,8'b1}), 
  .audio_outR({actual_audio_data_right,8'b1}),
  .audio_right_clock(audio_right_clock), 
  .audio_left_clock(audio_left_clock)
);


//=======================================================================================================================
//
//   End Audio controller code
//
//========================================================================================================================
                    
            
endmodule
