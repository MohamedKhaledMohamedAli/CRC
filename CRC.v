module CRC #(
        parameter DATA_WIDTH = 4'd8,
        parameter SEED = 8'hD8
    )(
        input  wire       CLK, RST, ACTIVE, DATA,
        output reg        CRC, Valid
    );
    
    reg [DATA_WIDTH - 1 : 0] LFSR;         // declare LFSR (Linear Feedback Shift Register)
    
    integer N;

    parameter   [DATA_WIDTH - 1 : 0] Taps = 'b1000100;     // taps defines the sequence 
    
    // Internal Signals
    wire                        Feedback;
    reg                         done;
    reg [DATA_WIDTH - 1 : 0]    count;
    
    assign Feedback = DATA ^ LFSR[0];
    
    always @(posedge CLK or negedge RST) begin

        if (!RST) begin
            LFSR <= SEED;
            CRC <= 1'b0;
            Valid <= 1'b0;
        end
        else if(ACTIVE) begin	 
            LFSR[DATA_WIDTH - 1] <= Feedback; 	 
            for (N = 0; N < DATA_WIDTH - 1; N = N + 1) begin 
                if (Taps[N] == 1) begin
                    LFSR[N] <= LFSR[N + 1] ^ Feedback;
                end 
                else begin
                    LFSR[N] <= LFSR[N + 1];
                end
            end
        end
        else if(!done) begin

            if (done == 'b0) begin
                {LFSR[6:0],CRC} <= LFSR ;
                Valid <= 1'b1;
            end else begin
                Valid <= 1'b0;
            end
        end
    end

    // Counter
    always @(posedge CLK or negedge RST) begin
        
        if(!RST) begin
            count <= 'b0;
            done <= 'b1;
        end
        else if (ACTIVE) begin
            count <= 'b0;
            done <= 'b0;
        end
        else if (!ACTIVE && !done) begin
            count <= count + 'b1;

            if (count == 'b111) begin
                done <= 'b1;
            end
        end
    end
    
endmodule