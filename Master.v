module Master(sda,scl,clk);
inout sda;
input clk;
output reg scl;
reg scl2;
reg ack;
reg direction;
reg alpha;
reg [6:0] address;
reg [7:0] temp;
reg [7:0] temp_reserved;
reg rw;
reg[6:0] register;
reg a;
initial begin
	a = 0;
	rw = 0;
	scl = 1'b1;
	scl2 = 1'b1;
	direction = 1;
	address = 7'b1101001;
	register = 7'b1001010;
	temp = {address,rw};
	temp_reserved = {address,rw};
	alpha = 1;
	#5 alpha = 0;
end
always @(posedge clk)begin
	if(a==0)
		scl <= 1;
	else if(a==1)
		scl <= !scl;
end
/*always @(negedge sda)begin
	if (scl==1'b1) begin
		forever #2 scl <= !scl;
	end
end*/
always @(negedge sda)
	a <= 1;
always @(negedge scl)begin
	#1 forever #2 scl2 <= !scl2;
end
always @(sda)begin
	if(scl==1'b1) begin
		scl <= 1'b1;
	end
end

integer left_bits = 1;

always @(negedge scl2)begin

if(left_bits <= 8) begin  //****Sending Slave Address****//
	alpha <= temp[7];
	temp <= temp<<1;
   left_bits <= left_bits + 1;
end
else if(left_bits == 9)begin //****Receive ACK bit from Slave****//
	direction <= 0;
	ack <= sda;
	left_bits <= left_bits + 1;
	end
else if(left_bits == 10)begin 
	//ack <= sda;
	if(sda == 0)begin	       //****ACK = 0 Resend the Slave Address****//
		left_bits <= 1;
		direction <= 1;
		temp <= temp_reserved;
	end
	else begin					//****ACK = 1 Get Ready to send Register Address****//
		direction <= 1;
		alpha <= 0;
		left_bits <= left_bits + 1;
		end
end
else if(left_bits >=11 && left_bits <=17)begin //****Sending 7-bit Register Address****//
	//if(left_bits <=17)begin
		alpha <= register[6];
		register <= register<<1;
	//end
	left_bits <= left_bits + 1;
	end
else if (left_bits >= 18 && left_bits <= 28)begin //****ACK from Slave and 8 bit Data from Slave****//
	direction <=0;
	left_bits <= left_bits + 1;
	end
else if(left_bits == 29)begin //****ACK from Master ****//
	direction <= 1;
	alpha <= 1;
	left_bits <= left_bits + 1;
	end
else if(left_bits == 30)begin
	alpha <= 0;
	left_bits <= left_bits + 1;
	end
else if(left_bits == 31)begin //**** STOP Condition ****//
	#2 alpha <= 1;
	//a <= 0;
	left_bits <= left_bits + 1;
	end
else if(left_bits == 32) //**** STOP Condition ****//
	a <= 0;
	

//left_bits <= left_bits + 1;
end


assign sda = direction?alpha:1'bZ;

Slave Sl1(sda,scl);
//Slave2 Sl2(sda,scl);


endmodule

