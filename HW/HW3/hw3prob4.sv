module decoder24en
    (input logic [1:0] binary,
    output logic [3:0] onehot,
    input logic en_L);
        always_comb begin
        case(binary)
    2'h0 : onehot = 4'h1;
    2'h1 : onehot = 4'h2;
    2'h2 : onehot = 4'h4;
    2'h3 : onehot = 4'h8;
        endcase
    if (~en_L) onehot = 4'h0;
        end
endmodule : decoder24en

module decoder24en_tb
    (output logic [1:0] binary,
    input logic [3:0] onehot,
    output logic en_L);
    initial begin

        en_L = 1'b0;
        $monitor($time,,"onehot = %b, en_L = %b, binary = %b",onehot,en_L,
        binary);
        for(binary = 2'd0;binary < 2'd3;binary++) begin
                #10;
         end
    end

endmodule: decoder24en_tb

module top();
    logic [1:0] binary;
    logic [3:0] onehot;
    logic en_L;

    decoder24en DUT(.binary(binary), .onehot(onehot), .en_L(en_L));
    decoder24en_tb TB (.binary(binary), .onehot(onehot), .en_L(en_L));

endmodule : top;
