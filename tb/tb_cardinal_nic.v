module cardinal_nic_test;

  reg              clk;
  reg              reset;
  reg [1:0]        addr;
  reg [63:0]       d_in;
  reg              nicEn;
  reg              nicEnWr;
  reg              net_ro;
  reg              net_polarity;
  reg              net_si;
  reg [63:0]       net_dl;  
  wire             net_ri;
  wire             net_so; 
  wire [63:0]      net_do;
  wire [63:0]       d_out;

  cardinal_nic nic (clk, reset, addr, d_in,nicEn, nicEnWr, net_ro, net_polarity, net_si, net_dl, net_ri, net_so, net_do,d_out);

  initial begin
    forever begin
      #2 clk = ~clk;
    end 
  end 

  initial begin
    clk            = 0;
    reset          = 1;
    repeat(5) @(posedge clk);
    reset          = 0;
    //test receive data from router
    net_si         = 1'b1;
    net_dl         = 64'h0000_0000_0000_0001;
    repeat(2) @(posedge clk);
    net_si         = 1'b0;
    //test load avaliable
    nicEn          = 1;
    nicEnWr        = 0;
    addr           = 2'b00;
    repeat(2) @(posedge clk);
    //test load unavaliable
    repeat(2) @(posedge clk);
    //test store avaliable
    net_ro         = 0;
    nicEn          = 1;
    nicEnWr        = 0;
    addr           = 2'b11;
    d_in         = 64'h0000_0000_0000_0002;
    repeat(2) @(posedge clk);
    if(d_out[63] == 0) begin
      nicEnWr      = 1;
      addr         = 2'b10;
    end
    repeat(2) @(posedge clk);
    //test store unavaliable
    nicEnWr        = 0;
    addr           = 2'b11;
    d_in           = 64'h0000_0000_0000_0003;
    repeat(2) @(posedge clk);
    if(d_out[63] == 0) begin
      nicEnWr      = 1;
      addr         = 2'b10;
    end

    repeat(2) @(posedge clk);


    // //test send data to processor
    // nicEn          = 1;
    // nicEnWr        = 0;
    // addr           = 2'b00;
    // repeat(2) @(posedge clk);
    // nicEn          = 0;
    // repeat(2) @(posedge clk);
    // //test receive data form processor
    // d_in           = 64'h0000_0000_0000_0002;
    // nicEn          = 1;
    // nicEnWr        = 0;
    // addr           = 2'b00;
    // repeat(2) @(posedge clk);
    // addr           = 2'b01;
    // repeat(2) @(posedge clk);
    // addr           = 2'b11;
    // repeat(2) @(posedge clk);
    // addr           = 2'b10;
    // repeat(2) @(posedge clk);

    // repeat(2) @(posedge clk);
    // //test send data to router
    // net_ro         = 1'b1;
    // net_polarity   = 1'b1;
    // repeat(2) @(posedge clk);
    // net_polarity   = 1'b0;
    // repeat(2) @(posedge clk);
    // reset          = 1;
    // repeat(2) @(posedge clk);
    $stop();
  end 


endmodule