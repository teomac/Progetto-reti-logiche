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
    PREPARE_WORD,
    TEST,
    TEST1,
    READ_WORD, 
    CONVERTER,
    SAVE_FIRST,
    PREPARE_ADDRESS, 
    SAVE_SECOND, 
    END_PROCESS, 
    FINAL
    );
    
    type S is(
    S00,
    S01,
    S10,
    S11
    );
    
signal current_state : S := S00; -- stato del convolutore (inizializzato a S00)
signal state : STATE_TYPE := START; -- stato della macchina (inizializzato a start)
signal counter : std_logic_vector(15 downto 0) := (others => '0');
signal save_counter : std_logic_vector(15 downto 0) := "0000001111101000";
signal n : std_logic_vector(7 downto 0) := (others => '0'); -- numero di parole per ciascuna elaborazione
signal word : std_logic_vector(7 downto 0) := (others => '0');
signal p1k : std_logic_vector(7 downto 0) := (others => '0');
signal p2k : std_logic_vector(7 downto 0) := (others => '0');



begin
    process(i_clk, i_rst)
    variable temp_1 : std_logic_vector(7 downto 0) := (others => '0');
    variable z : integer := 0;
    begin
        if rising_edge(i_clk) then

            
            if i_rst = '1' then
                current_state <= S00;
                
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
                        
                        current_state <= S00;
                        counter <= (others => '0');
                        save_counter <= "0000001111101000";
                        temp_1 := i_data;
                        n <= (others => '0');
                        
                        if (temp_1 = n) then
                            state <= FINAL;
                    
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
                        o_address <= counter;
                        state <= TEST1;
                        
                    when TEST1 =>
                           
                        state <= READ_WORD;
                        
                    
                            
                    when READ_WORD =>
                        z := 0;

                        
                        word <= i_data;
                        
                        state <= CONVERTER;
                        
                    when CONVERTER =>
                    

                            
                        case current_state is
                                
                        
                            when S00 =>
 
                                if word(z)='0' then
                                    p1k(z) <= '0';
                                    p2k(z) <= '0';
                                    
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                                    
                                    current_state <= S00;
                                    
                                elsif word(z)='1' then
                                    p1k(z) <= '1';
                                    p2k(z) <= '1';
                                    
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                                    
                                    current_state <= S10;
                                end if;
                                
                            when S01 =>
                                
                                if word(z)='0' then
                                    p1k(z) <= '1';
                                    p2k(z) <= '1';
                                
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                                
                                    current_state <= S00;
                                
                                elsif word(z)='1' then
                                    p1k(z) <= '0';
                                    p2k(z) <= '0';
                                
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                                
                                    current_state <= S10;
                                end if;
                                
                            when S10 =>
                                
                                if word(z)='0' then
                                    p1k(z) <= '0';
                                    p2k(z) <= '1';
                            
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                            
                                    current_state <= S01;
                            
                                elsif word(z)='1' then
                                    p1k(z) <= '1';
                                    p2k(z) <= '0';
                            
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                            
                                    current_state <= S11;
                                end if;
                                
                            when S11 =>
                                if word(z)='0' then
                                    p1k(z) <= '1';
                                    p2k(z) <= '0';
                            
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                            
                                    current_state <= S01;
                            
                                elsif word(z)='1' then
                                    p1k(z) <= '0';
                                    p2k(z) <= '1';
                            
                                    z := z + 1;
                                    if z>7 then
                                        state <= SAVE_FIRST;  --CONTROLLARE CHE TORNA INDIETRO TUTTE LE VOLTE
                                    end if;                                    
                            
                                    current_state <= S11;
                                end if;
                        end case;
                        
                    when SAVE_FIRST =>
                        o_en <= '1';
                        o_we <= '1';
                        o_address <=  std_logic_vector(unsigned(save_counter));  --CONTROLLARE SE PRIMA VA FATTO O_ADDRESS O O_DATA
                    
                        o_data(0) <= p1k(0);
                        o_data(1) <= p2k(0);
                        o_data(2) <= p1k(1);
                        o_data(3) <= p2k(1);
                        o_data(4) <= p1k(2);
                        o_data(5) <= p2k(2);
                        o_data(6) <= p1k(3);
                        o_data(7) <= p2k(3);
                        
                        save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");
                        
                        state <= PREPARE_ADDRESS;
                        
                    when PREPARE_ADDRESS =>
                        o_address <=  std_logic_vector(unsigned(save_counter));  --CONTROLLARE SE PRIMA VA FATTO O_ADDRESS O O_DATA
                        
                    
                        state <= SAVE_SECOND;
                        
                    when SAVE_SECOND =>
                            o_en <= '1';
                            o_we <= '1';
                            
                        
                            o_data(0) <= p1k(4);
                            o_data(1) <= p2k(4);
                            o_data(2) <= p1k(5);
                            o_data(3) <= p2k(5);
                            o_data(4) <= p1k(6);
                            o_data(5) <= p2k(6);
                            o_data(6) <= p1k(7);
                            o_data(7) <= p2k(7);
                            
                            save_counter <=  std_logic_vector(unsigned(save_counter)+ "1");
                            counter <=  std_logic_vector(unsigned(counter)+ "1");
                            
                            if counter > n then
                                state <= END_PROCESS;
                                
                            else
                                state <= READ_WORD;
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
                            o_done <= '0';
                            
                            if i_start = '1' then
                                state <= READ_WORDS_NUMBER;
                            else
                                state <= FINAL;
                            end if;
                                
                            
                    
                    
                    end case;
                end if;
            end if;
        end process;
        
    
    
end architecture;