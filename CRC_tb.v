`timescale 1ns/1ps

module  CRC_tb ();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter CRC_WD_tb = 8;
    parameter Clock_PERIOD = 100;
    parameter Test_Cases = 10;

    /////////////////////////////////////////////////////////
    //////////////////// DUT Signals ////////////////////////
    /////////////////////////////////////////////////////////


    reg      [CRC_WD_tb-1:0]      DATA_tb;
    reg                           CLK_tb;
    reg                           RST_tb;
    reg                           ACTIVE_tb;
    wire                          CRC_tb;
    wire                          Valid_tb;

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(Clock_PERIOD/2)  CLK_tb = ~CLK_tb;


    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    CRC DUT (
        .CLK(CLK_tb),
        .RST(RST_tb),
        .ACTIVE(ACTIVE_tb),
        .DATA(DATA_tb),
        .CRC(CRC_tb),
        .Valid(Valid_tb)
    );

    /////////////////////////////////////////////////////////
    ///////////////// Loops Variables ///////////////////////
    /////////////////////////////////////////////////////////

    integer                       Operation;

    /////////////////////////////////////////////////////////
    /////////////////////// Memories ////////////////////////
    /////////////////////////////////////////////////////////

    reg    [CRC_WD_tb-1:0]   Test_DATA    [Test_Cases-1:0] ;
    reg    [CRC_WD_tb-1:0]   Expec_Outs   [Test_Cases-1:0] ;

    ////////////////////////////////////////////////////////
    ////////////////// initial block /////////////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        
        // System Functions
        $dumpfile("CRC_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemh("DATA_h.txt", Test_DATA);
        $readmemh("Expec_Out_h.txt", Expec_Outs);

        // initialization
        initialize();

        // Reset
        reset();

        // Test Cases
        for (Operation = 0; Operation < Test_Cases; Operation = Operation + 1) begin
            do_oper(Test_DATA[Operation]);                        // do operation
            check_out(Expec_Outs[Operation],Operation);           // check output response
        end

        #100
        $stop;

    end




    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            DATA_tb = 'b10010011;
            CLK_tb  = 'b0;
            RST_tb  = 'b1;
            ACTIVE_tb = 'b0;    
        end
    endtask

    ///////////////////////// RESET /////////////////////////

    task reset;
        begin
            RST_tb =  'b1;
            #(Clock_PERIOD)
            RST_tb  = 'b0;
            #(Clock_PERIOD)
            RST_tb  = 'b1;
        end
    endtask

    //////////////////// Do Operation ///////////////////////

    task do_oper ;
        input  [CRC_WD_tb - 1 : 0]     IN_DATA;

        integer i;

        begin

            reset();

            #(Clock_PERIOD);

            ACTIVE_tb = 1'b1;

            for (i = 0; i < CRC_WD_tb; i = i + 1) begin

                DATA_tb = IN_DATA[i];

                #(Clock_PERIOD);
            end

            ACTIVE_tb = 1'b0;   
        end
    endtask

    ////////////////// Check Out Response  ////////////////////

    task check_out ;
        input  reg     [CRC_WD_tb - 1 : 0]     expec_out;
        input  integer                         Oper_Num; 

        integer i;
        
        reg    [CRC_WD_tb - 1 : 0]     gener_out;

        begin

            @(posedge Valid_tb);
            for(i = 0; i < CRC_WD_tb; i = i + 1) begin
                #(Clock_PERIOD) gener_out[i] = CRC_tb;   
            end
            if(gener_out == expec_out) begin
                $display("Test Case %d is succeeded",Oper_Num);
            end
            else begin
                $display("Test Case %d is failed", Oper_Num);
            end
        end
    endtask

endmodule