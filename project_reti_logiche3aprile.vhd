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
    READ_WORD,
    TEST3,
    TEST4, 
    CONVERTER,
    SAVE_FIRST,
    PREPARE_ADDRESS, 
    SAVE_SECOND,
    TEST2, 
    END_PROCESS, 
    FINAL
    );
  
  
signal state : STATE_TYPE := START; -- stato della macchina (inizializzato a start)
signal counter : std_logic_vector(15 downto 0) := (others => '0');
signal save_counter : std_logic_vector(15 downto 0) := "0000001111101000";
signal n : std_logic_vector(7 downto 0) := (others => '0'); -- numero di parole per ciascuna elaborazione
--signal word : std_logic_vector(7 downto 0) := (others => '0');




begin
    process(i_clk, i_rst)
    variable temp_1 : std_logic_vector(7 downto 0) := (others => '0');
    variable z : integer := 0;
    variable p1k : std_logic_vector(7 downto 0) := (others => '0');
    variable p2k : std_logic_vector(7 downto 0) := (others => '0');
    variable uk1, uk2 : std_logic_vector(7 downto 0) := (others => '0');
    variable word : std_logic_vector(7 downto 0) := (others => '0');
    begin


            
            if i_rst = '1' then
                uk1 := (others => '0');
                uk2 := (others => '0');
                
            else
                case state is
                    when START =>
                        if i_start <= '1' then
                        o_address <= (others => '0');
                        o_en <= '1';
                        o_we <= '0';
                        
                        state <= PREPARE_READ;
                        else
                            state <= START;
                        end if;
                        
                    when PREPARE_READ =>
                        
                        
                        state <= READ_WORDS_NUMBER;
                        
                    when READ_WORDS_NUMBER =>
                        
                        uk1 := (others => '0');
                        uk2 := (others => '0');
                        counter <= (others => '0');
                        save_counter <= "0000001111101000";
                        temp_1 := i_data;
                        n <= (others => '0');
                        
                        state <= TEST0;
                        

                    
                    when TEST0 =>
                        if (temp_1 = 0) then
                            state <= END_PROCESS;
                
                        else
                            n <= temp_1;
                        
                            o_en <= '1';
                            o_we <= '0';
                            state <= PREPARE_WORD;
                        
                        end if;                    
                    
                        
                    when PREPARE_WORD =>
                        
                        counter <= std_logic_vector(unsigned(counter) + "00000001");
                        
                    
                        state <= TEST;
                        
                    when TEST =>
                        o_we <= '0';

                        o_address <= counter;
                        state <= TEST1;
                        
                    when TEST1 =>
                           
                        state <= READ_WORD;
                        
                    
                            
                    when READ_WORD =>

                        word := i_data;
                        
                        state <= TEST3;
                        
                    when TEST3 =>
                        
                        state <= TEST4;
                        
                    when TEST4 =>
        
                        state <= CONVERTER;
                        
                        
                        
                    when CONVERTER =>
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
                    
                        state <= SAVE_FIRST;

                        
                    when SAVE_FIRST =>
                        o_en <= '1';
                        o_we <= '1';
                        o_address <=  std_logic_vector(unsigned(save_counter));  --CONTROLLARE SE PRIMA VA FATTO O_ADDRESS O O_DATA
                    
                        o_data(7) <= p1k(7);
                        o_data(6) <= p2k(7);
                        o_data(5) <= p1k(6);
                        o_data(4) <= p2k(6);
                        o_data(3) <= p1k(5);
                        o_data(2) <= p2k(5);
                        o_data(1) <= p1k(4);
                        o_data(0) <= p2k(4);
                        
                        save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");
                        
                        state <= PREPARE_ADDRESS;
                        
                    when PREPARE_ADDRESS =>
                        o_address <=  std_logic_vector(unsigned(save_counter));  --CONTROLLARE SE PRIMA VA FATTO O_ADDRESS O O_DATA
                        
                    
                        state <= SAVE_SECOND;
                        
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
                            
                            save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");
                            counter <=  std_logic_vector(unsigned(counter)+ "1");
                            
                            state <= TEST2;
                            
                        when TEST2 =>
                            
                            if counter > n then
                                state <= END_PROCESS;
                                
                            else
                                state <= TEST;
                            end if;
                            
                            
                        when END_PROCESS =>
                            o_en <= '0';
                            o_we <= '0';
                            o_done <= '1';
                            
                            if i_start = '0' then
                                state <= FINAL;
                            
                            else
                                state <= END_PROCESS;
                            end if;
                        
                        when FINAL =>
                            
                            
                            if i_start = '1' then
                                state <= READ_WORDS_NUMBER;
                            else
                                o_done <= '0';
                                state <= FINAL;
                            end if;
                                
                            
                    
                    
                    end case;
                end if;

        end process;
        
    
    
end architecture;
