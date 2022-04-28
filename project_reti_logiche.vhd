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
    PREPARE_READ_NUMBER,
    READ_WORDS_NUMBER,
    CHECK_WORDS_NUMBER,
    START_WORD_READ,
    SET_WORD_ADDRESS,
    PREPARE_READ_WORD,
    READ_WORD,
    CONVERTER,
    SAVE_FIRST,
    PREPARE_ADDRESS, 
    SAVE_SECOND,
    CHECK_COUNTER, 
    END_ELABORATION, 
    FINAL
    );
  
  
signal state : STATE_TYPE := START; -- stato della macchina (inizializzato a start)
signal counter : std_logic_vector(15 downto 0) := (others => '0');
signal save_counter : std_logic_vector(15 downto 0) := "0000001111101000";
signal n : std_logic_vector(7 downto 0) := (others => '0'); -- numero di parole per ciascuna elaborazione


begin
    process(i_clk, i_rst)
    variable temp_1 : std_logic_vector(7 downto 0) := (others => '0');
    variable p1k : std_logic_vector(7 downto 0) := (others => '0');
    variable p2k : std_logic_vector(7 downto 0) := (others => '0');
    variable uk1, uk2 : std_logic_vector(7 downto 0) := (others => '0');
    variable word : std_logic_vector(7 downto 0) := (others => '0');
    
    begin
            
            if i_rst = '1' then
                uk1 := (others => '0');
                uk2 := (others => '0');
                
                state <= START;
                
            elsif rising_edge(i_clk) then
                case state is
                    when START =>
                        if i_start <= '1' then
                            o_address <= (others => '0');
                            o_en <= '1';
                            o_we <= '0';
                        
                            state <= PREPARE_READ_NUMBER;
                        else
                            state <= START;
                        end if;
                        
                    when PREPARE_READ_NUMBER =>
                        
                        
                        state <= READ_WORDS_NUMBER;


                    when READ_WORDS_NUMBER =>
                        
                        uk1 := (others => '0');
                        uk2 := (others => '0');
                        counter <= (others => '0');
                        save_counter <= "0000001111101000";
                        temp_1 := i_data;
                        n <= (others => '0');
                        
                        state <= CHECK_WORDS_NUMBER;
                        

                    
                    when CHECK_WORDS_NUMBER =>
                        if (temp_1 = 0) then
                            state <= END_ELABORATION;
                
                        else
                            n <= temp_1;
                        
                            o_en <= '1';
                            o_we <= '0';
                            state <= START_WORD_READ;
                        
                        end if;                    
                    
                        
                    when START_WORD_READ =>
                        
                        counter <= std_logic_vector(unsigned(counter) + "00000001");
                        
                    
                        state <= SET_WORD_ADDRESS;
                        
                        
                    when SET_WORD_ADDRESS =>
                        o_we <= '0';
                        o_address <= counter;
                        state <= PREPARE_READ_WORD;

                        
                    when PREPARE_READ_WORD =>
                            
                            
                        state <= READ_WORD;
                            
                    when READ_WORD =>

                        word := i_data;
                        
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
                        
                        o_address <=  std_logic_vector(unsigned(save_counter)); 
                    
                        state <= SAVE_FIRST;
                        
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
                        
                        save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");
                        
                        state <= PREPARE_ADDRESS;
                        
                    when PREPARE_ADDRESS =>

                        state <= SAVE_SECOND;
                        
                    when SAVE_SECOND =>
                            o_en <= '1';
                            o_we <= '1';
                            o_address <=  std_logic_vector(unsigned(save_counter));
                            
                        
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
                            
                            state <= CHECK_COUNTER;
                            
                        when CHECK_COUNTER =>
                            
                            if counter > n then
                                state <= END_ELABORATION;
                                
                            else
                                state <= SET_WORD_ADDRESS;
                            end if;
                            
                            
                        when END_ELABORATION =>
                            o_en <= '0';
                            o_we <= '0';
                            o_done <= '1';
                            
                            if i_start = '0' then
                                state <= FINAL;
                            
                            else
                                state <= END_ELABORATION;
                            end if;
                        
                        when FINAL =>
                            
                            
                            if i_start = '1' then

                                state <= START;
                            else
                                o_done <= '0';
                                state <= FINAL;
                            end if;
                                
                            
                    
                    
                    end case;
                end if;

        end process;
        
    
    
end architecture;
