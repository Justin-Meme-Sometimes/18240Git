module ChipInterface
    (output logic [17:0] LEDR,
    input logic [5:0] SW);

    LoteriaSOP L(.a(SW[5]), .b(SW[4]), .c(SW[3]), .d(SW[2]),
        .e(SW[1]),.f(SW[0]),.win(LEDR[17]),.error(LEDR[16]));


endmodule : ChipInterface

