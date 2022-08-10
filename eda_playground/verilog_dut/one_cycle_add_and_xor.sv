module single_cycle_add_and_xor(
  input [7:0] A,
  input [7:0] B,
  input [2:0] op_code,
  input clk,
  input reset_n,
  input start,
  output reg done,
  output reg [15:0] result
);

localparam [2:0]  add_op = 3'b001,
and_op = 3'b010,
xor_op = 3'b011;
reg [7:0] A_reg;
reg [7:0] B_reg;
reg       start_reg;
reg done_aux;

assign done = done_aux;


// Input register pipeline
always@(posedge clk, negedge reset_n) begin
  if(!reset_n) begin
    A_reg <= 'b0;
    B_reg <= 'b0;
    start_reg <= 'b0;
  end 
  else begin
    A_reg <= A;
    B_reg <= B;
    start_reg <= start & !done_aux;
  end
end


always@(posedge clk, negedge reset_n) begin
  if(!reset_n) begin
    result <= 'b0;
    done_aux <= 'b0;
  end 
  else begin
    if(start)
      case(op_code)
        add_op: begin
          result <= A_reg + B_reg;
          done_aux <= start_reg & !done_aux;
        end

        and_op: begin
          result <= A_reg & B_reg;
          done_aux <= start_reg & !done_aux;
        end

        xor_op: begin
          result <= A_reg ^ B_reg;
          done_aux <= start_reg & !done_aux;
        end

        default: begin
          result <= result;
          done_aux <= 'b0;
        end
      endcase    
    end // else 
  end // always@(posedge clk)
  endmodule
