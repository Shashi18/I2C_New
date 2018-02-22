module Slave(
    inout sda,
    input scl
    );
parameter [6:0] address = 7'b1101101;
reg [7:0] temp = 8'bx;
reg [6:0] s_add;
parameter [6:0] register = 7'b1001010;
reg[7:0] array[0:75];
reg ack;
reg scl2;
initial begin
scl2 <= 1;
array[74] = 8'b00011101;
end
always @(negedge scl)begin
		ack <= sda;
		#1 forever #2 scl2 <= !scl2;
end
reg alpha = 0;
reg direction = 0;
integer n = 1;
assign sda = direction?alpha:1'bz;
/*always @(scl)begin
 #1 scl2 = !scl;
end*/
//always @(sda)begin
//   scl2 = sda;
//end
/*always @(negedge scl)begin
	ack <= 0;
	temp <= {temp,ack};
end*/
always @(negedge scl2)begin
	if(n<=8)begin
		temp <= {temp,sda};
		n <= n + 1;
		end
	else if(n==9)begin
		temp = {temp,sda};
		if(temp[7:1]===address) begin
			direction <= 1;
			alpha <= 1;
		end
		else begin
			direction <= 1;
			alpha <= 0;
		end
		//temp <= {temp,sda};
		n <= n + 1;
	end
	else if(n==10) begin
		if (temp[7:1] !== address)begin
			direction <= 0;
			n <= 1;
			end
		else begin
			direction <= 0;
			n <= n + 1;
			end
	end
	else if(n>=11 && n<=17)begin
		s_add <= {s_add,sda};
		n <= n+1;
		end
	else if(n==18)begin
		s_add = {s_add,sda};
		direction <= 1;
		if(s_add==register)
			alpha <= 1;
		else 
			alpha <= 0;
		n <= n + 1;
	end
	else if (n==19)begin
		alpha <= 0;
		n <= n + 1;
		end
	else if(n>=20 && n<=28)begin
		alpha <= array[s_add][7];
		array[s_add] <= array[s_add]<<1;
		n <= n + 1;
	end
	else if(n==29)begin
		direction <= 0;
	   n <= n + 1;
		end
	else
	ack = sda;
//n <= n + 1;
end

endmodule
