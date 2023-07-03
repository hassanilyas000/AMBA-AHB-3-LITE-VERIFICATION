//A program block that creates the environment and initiate the stimulus
`include "environment.sv"
program test(mem_intf vif);
  
  class my_trans extends transaction;
    constraint con_haddr { } ;
    
    bit [1:0] cnt;
    int count;
    function void pre_randomize();         //read-write at same addresses
      HWRITE.rand_mode(0);
      HADDR.rand_mode(0);
      HSIZE.rand_mode(0);
            HTRANS.rand_mode(0);
      HTRANS=3;           //-SEQ

      HSIZE=2;            //w
             
      if(cnt %2 == 0) begin
        HWRITE = 1;
        HADDR  = count;      
      end 
      else begin
        
        HWRITE = 0;
        HADDR  = count;
      end
      cnt++;
    endfunction


  endclass
    

  //declare environment handle
  environment env;
  my_trans my_tr;
  initial begin
    //create environment
    env=new(vif);
    my_tr = new();

    //initiate the stimulus by calling run of env
    env.gen.count = 10;

    env.gen.trans = my_tr;

    env.run();


  end
  
  initial begin    
    $display (" LOADING FILE IN TEST ");
    $readmemh( "memfile.txt", env.scb.mem_array , 0, 255);  
  end
  
endprogram



