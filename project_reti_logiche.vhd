library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type STATE_TYPE is (
    START,
    PREPARE_READ, 
    READ_WORDS_NUMBER,
    TEST0,
    PREPARE_WORD,
    TEST,
    TEST1,
    --TEST3,
    --TEST4,
    READ_WORD,
    CONVERTER,
    PREPARE_ADDRESS1,
    SAVE_FIRST,
    WAIT1,
    PREPARE_ADDRESS2, 
    SAVE_SECOND,
    WAIT2,
    TEST2, 
    END_PROCESS,
    SEMIFINAL_PROCESS, 
    FINAL
    );
  
  
signal state : STATE_TYPE := START; -- stato della macchina (inizializzato a start)
signal nextstate: STATE_TYPE := START;
signal counter : std_logic_vector(15 downto 0) := (others => '0');
signal save_counter : std_logic_vector(15 downto 0) := "0000001111101000";
signal n : std_logic_vector(7 downto 0) := (others => '0'); -- numero di parole per ciascuna elaborazione
signal word : std_logic_vector(7 downto 0) := (others => '0');
--signal p1k : std_logic_vector(7 downto 0) := (others => '0');
--signal p2k : std_logic_vector(7 downto 0) := (others => '0');
signal sk1, sk2 : std_logic_vector(7 downto 0) := (others => '0');

begin

process (i_clk)
begin
    if rising_edge(i_clk) then
        state <= nextstate;
        end if;
        
        if i_rst = '1' then
          sk1 <= (others => '0');
            sk2 <= (others => '0');
            end if;

end process;



process(state, i_rst)
        
    
    variable temp_1 : std_logic_vector(7 downto 0) := (others => '0');
    variable p1k : std_logic_vector(7 downto 0) := (others => '0');
    variable p2k : std_logic_vector(7 downto 0) := (others => '0');
    variable uk1, uk2 : std_logic_vector(7 downto 0) := (others => '0');
    --variable word : std_logic_vector(7 downto 0) := (others => '0');
    --variable counter : std_logic_vector(15 downto 0) := (others => '0');
    --variable save_counter : std_logic_vector(15 downto 0) := "0000001111101000";



begin   
               
           ---- if i_rst = '1' then
              --  uk1 := (others => '0');
              --  uk2 := (others => '0');
                
          -- else
                case state is
                    when START =>
                        if i_start <= '1' then
                        o_address <= (others => '0');
                        o_en <= '1';
                        o_we <= '0';
                        
                        nextstate <= PREPARE_READ;
                        else
                            nextstate <= START;
                        end if;
                        
                    when PREPARE_READ =>
                        
                        o_address <= (others => '0');
                        
                        if i_rst = '1' then
                             uk1 := (others => '0');
                             uk2 := (others => '0');
                             end if;
                        
                        nextstate <= READ_WORDS_NUMBER;
                        
                    when READ_WORDS_NUMBER =>
                        
                        uk1 := (others => '0');
                        uk2 := (others => '0');
                        counter <= (others => '0');
                        save_counter <= "0000001111101000";
                        temp_1 := i_data;
                        n <= (others => '0');
                        
                        nextstate <= TEST0;
                        

                    
                    when TEST0 =>
                    
                        if (temp_1 = 0) then
                            nextstate <= END_PROCESS;
                
                        else
                            n <= temp_1;
                        
                            o_en <= '1';
                            o_we <= '0';
                            counter <= std_logic_vector(unsigned(counter) + "00000001");  --counter =1                           
                            nextstate <= PREPARE_WORD;
                        
                        end if;                    
                    
                        
                    when PREPARE_WORD =>
                        

                        --o_we <= '0';
                        
                   
                        nextstate <= TEST;
                        
                    when TEST =>
                        o_we <= '0';
                        

                        o_address <= counter;    --address=2
                        --nextstate <= TEST1;
                        
                    --when TEST1 =>
                           
                       -- state <= TEST3;
                        
                   -- when TEST3 =>
                                                
                        -- state <= TEST4;
                                                
                   -- when TEST4 =>
                                
                         nextstate <= TEST1;
                         
                    when TEST1 =>
                    
                    nextstate <= READ_WORD;                                             
                    
                            
                    when READ_WORD =>

                        word <= i_data;
                        
                        nextstate <= CONVERTER;
                        
                    
                        
                        
                        
                    when CONVERTER =>
                    
                        o_we<='1';
                        uk1 := sk1;
                        uk2 := sk2;
                        
                        
                        p1k(7) := (word(7) XOR uk2(0));
                        p2k(7) := ((word(7) XOR uk1(0)) XOR uk2(0));
                                            
                        uk2 := uk1;
                        uk1(0) := word(7);
                                            
                        p1k(6) := (word(6) XOR uk2(0));
                        p2k(6) := ((word(6) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(6);
                    
                        p1k(5) := (word(5) XOR uk2(0));
                        p2k(5) := ((word(5) XOR uk1(0)) XOR uk2(0));
                                           
                        uk2 := uk1;
                        uk1(0) := word(5);
                    
                        p1k(4) := (word(4) XOR uk2(0));
                        p2k(4) := ((word(4) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(4);
                    
                        p1k(3) := (word(3) XOR uk2(0));
                        p2k(3) := ((word(3) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(3);
                                            
                        p1k(2) := (word(2) XOR uk2(0));
                        p2k(2) := ((word(2) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(2);
                    
                        p1k(1) := (word(1) XOR uk2(0));
                        p2k(1) := ((word(1) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(1);
                    
                        
                        p1k(0) := (word(0) XOR uk2(0));
                        p2k(0) := ((word(0) XOR uk1(0)) XOR uk2(0));
                    
                        uk2 := uk1;
                        uk1(0) := word(0);
                        
                        sk1 <= uk1;
                        sk2 <=uk2;
                        
                    
                        nextstate <= PREPARE_ADDRESS1;
                        
                       when PREPARE_ADDRESS1 =>
                        o_address <=  std_logic_vector(unsigned(save_counter));  --address=1000  --address=1002
                        o_we <='1';
                        nextstate <= SAVE_FIRST;
                       

                        
                    when SAVE_FIRST =>
                        o_en <= '1';
                        o_we <= '1';
                       
                    
                        o_data(7) <= p1k(7);
                        o_data(6) <= p2k(7);
                        o_data(5) <= p1k(6);
                        o_data(4) <= p2k(6);
                        o_data(3) <= p1k(5);
                        o_data(2) <= p2k(5);
                        o_data(1) <= p1k(4);
                        o_data(0) <= p2k(4);
                        
                        save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");  --savecounter=1001  --savecounter=1003
                        
                        nextstate <= WAIT1;
                        
                        when WAIT1 =>
                        
                        nextstate <= PREPARE_ADDRESS2;
                        
                        
                        
                    when PREPARE_ADDRESS2 =>
                        o_address <=  std_logic_vector(unsigned(save_counter));  --address=1001  --address=1003
                        o_we<='1';
                    
                        nextstate <= SAVE_SECOND;
                        
                    when SAVE_SECOND =>
                            o_en <= '1';
                            o_we <= '1';
                            
                        
                            o_data(7) <= p1k(3);
                            o_data(6) <= p2k(3);
                            o_data(5) <= p1k(2);
                            o_data(4) <= p2k(2);
                            o_data(3) <= p1k(1);
                            o_data(2) <= p2k(1);
                            o_data(1) <= p1k(0);
                            o_data(0) <= p2k(0);
                            
                            save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");  --save_counter=1002 --savecounter=1004
                            counter <= std_logic_vector(unsigned(counter) + "00000001");      --counter=2   --counter=3
                            
                            nextstate <= WAIT2;
                            
                            when WAIT2 =>
                            
                            nextstate <= TEST2;
                            
                            
                        when TEST2 =>
                            
                            if counter > n then
                                nextstate <= END_PROCESS;
                                
                            else
                                nextstate <= TEST;
                            end if;
                            
                            
                        when END_PROCESS =>
                            o_en <= '0';
                            o_we <= '0';
                            o_done <= '1';
                            
                           --wait until i_start = '0'
                           --if(i_start = '0') then     
                          -- nextstate <= FINAL;
                           
                            
                           --else
                              nextstate <= SEMIFINAL_PROCESS;
                           -- end if;
                           
                           when SEMIFINAL_PROCESS =>
                           -- if (i_start = '0') then
                            --    nextstate <= FINAL;
                            --else
                            nextstate <= FINAL;
                           -- end if;
                           
                        
                        when FINAL =>
                            
                            
                            if i_start = '1' then
                                nextstate <= READ_WORDS_NUMBER;
                            else
                                o_done <= '0';
                                nextstate <= FINAL;
                            end if;
                                
                            
                    
                    
                    end case;
--                end if;

        end process;
        
    
    
end architecture;