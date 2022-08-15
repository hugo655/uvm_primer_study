module three_cycle_mult(
  input [7:0] A,
  input [7:0] B,
  input clk,
  input reset_n,
  input start,
  output reg done_mult,
  output reg [15:0] result_mult
);

reg [7:0]  A_reg;
reg [7:0]  B_reg;
reg [15:0] mult[2];
reg        done[4];

always@(posedge clk, negedge reset_n) begin
  if(!reset_n) begin
    done[0] <= 'b0;
    done[1] <= 'b0;
    done[2] <= 'b0;
    done[3] <= 'b0;


    A_reg <= 'b0;
    B_reg <= 'b0;

    mult[0] <= 'b0;
    mult[1] <= 'b0;

    result_mult[0] <= 'b0;
  end
  else begin
    A_reg <= A;
    B_reg <= B;

    mult[0] <= A_reg * B_reg;
    mult[1] <= mult[0];
    result_mult <= mult[1];

    done[0] <= start & !done[3];
    done[1] <= done[0] & !done[3];
    done[2] <= done[1] & !done[3];
    done[3] <= done[2] & !done[3];
  end
end

assign done_mult = done[3];  
endmodule
