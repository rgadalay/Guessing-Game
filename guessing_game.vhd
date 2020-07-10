library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--declaring entity
entity GuessingGame is
Port ( 
btnC: in std_logic;--center button
btnU: in std_logic;--for D1
btnL: in std_logic;--for D0
btnR: in std_logic;--for D3
btnD: in std_logic;--for D2
clock: in std_logic;-- for clock
dp: out std_logic:='1';
switch : in std_logic_vector(3 downto 0); --for the 4 switches
anode_led : inout std_logic_vector (3 downto 0); -- for anode
switch_output : out std_logic_vector(15 downto 0):="0000000000000000";--for switch related output
seg: inout std_logic_vector(6 downto 0)--for segment 
);

end GuessingGame;

--declaring architecture
architecture Behavioral of GuessingGame is

signal new_clock : std_logic_vector(19 downto 0);
signal refresh : std_logic;
shared variable state_value:integer:=1;--for state

--for PL 1---
shared variable player1_data1:integer:=0;--used when PL1 is displayed initially
shared variable player1_data2:integer;-- used when during latching for player1 

---for PL 2---
shared variable player2_data1:integer:=0; --used when PL2 is displayed initially
shared variable player2_data2:integer:=0; -- used when during latching for player2


shared variable high_value:integer:=0; --for 2 HI
shared variable low_value:integer:=0; --for 2 LO
shared variable lose_value:integer:=0;-- for lose


shared variable output_led:  std_logic_vector(6 downto 0);-- storing the segment value temporarily before assigning to the actual segment


begin --begining the process

process(clock)
begin
if(rising_edge(clock))then
 new_clock <= new_clock+1;
 end if;
 end process;
  refresh<=new_clock( 18);
 

process(refresh)
variable count: integer := -1;

variable pl1_item0:std_logic_vector(3 downto 0); --to store anode0 value of player1
variable pl1_item1:std_logic_vector(3 downto 0);-- to store anode1 value of player1
variable pl1_item2:std_logic_vector(3 downto 0);-- to store anode2 value of player1
variable pl1_item3:std_logic_vector(3 downto 0);-- to store anode3 value of player1

variable pl2_item0:std_logic_vector(3 downto 0); -- to store anode0 value of player2
variable pl2_item1:std_logic_vector(3 downto 0); -- to store anode1 value of player2
variable pl2_item2:std_logic_vector(3 downto 0); -- to store anode2 value of player2
variable pl2_item3:std_logic_vector(3 downto 0); -- to store anode3 value of player2


variable result1:std_logic_vector(15 downto 0); -- result of player1
variable result2:std_logic_vector(15 downto 0); -- result of player2 

variable dp0: integer;
variable dp1: integer;
variable dp2: integer;
variable dp3: integer;


variable counter :integer:=0;---for delays

variable tries:integer:=0;-- for number of tries

begin
if(rising_edge(refresh)) then
count:=count+1;



--For latching of player 1
if (btnL='1' and player1_data2=0) then
    if state_value=1 or state_value=2 then
        pl1_item0:=switch;
        dp<='1';
        state_value:=2 ;end if; --for latching D0 
        
elsif (btnU='1' and player1_data2=1) then
    if state_value=1 or state_value=2 then 
        pl1_item1:=switch;
        dp<='1';
        state_value:=2;end if; --for latching D1
        
elsif (btnD='1' and player1_data2=2) then
    if state_value=1 or state_value=2 then
        pl1_item2:=switch;
        dp<='1';
        state_value:=2; end if;-- for latching D2
        
elsif (btnR='1' and player1_data2=3) then
    if state_value=1 or state_value=2 then
        pl1_item3:=switch;
        dp<='1';
        state_value:=2; end if; -- for latching D3
        
elsif (btnC='1' and state_value=2) then 
    result1:=pl1_item3&pl1_item2&pl1_item1&pl1_item0;-- storing result1
    dp<='1';state_value:=3; 
       
end if;-- latching of player 1 ends

--for latching of player 2
if (btnL='1' and player2_data2=0)  then 
    if (state_value=3 or state_value=4) then
        pl2_item0:=switch;
        dp<='1';
        state_value:=4 ; 
    end if; --for latching D0
    
elsif (btnU='1' and player2_data2=1)  then 
    if (state_value=3 or state_value=4) then
        pl2_item1:=switch;
        dp<='1';
        state_value:=4; 
    end if;--for latching D1
    
elsif (btnD='1' and player2_data2=2)  then 
    if (state_value=3 or state_value=4) then
        pl2_item2:=switch;
        dp<='1';
        state_value:=4; 
    end if;-- for latching D2
    
elsif (btnR='1' and player2_data2=3)  then
    if (state_value=3 or state_value=4) then
        pl2_item3:=switch;
        dp<='1';
        state_value:=4; 
    end if;-- for latching D3
    
end if;-- latching of player 2 ends

--checking the player1 and player2 related data
if (btnC='1' and state_value=4) then 
    dp<='1';
    result2:=pl2_item3&pl2_item2&pl2_item1&pl2_item0;
    
     if (result2>result1) then 
       tries:=tries+1;       
       player2_data2:=0;
       dp<='1';
       state_value:=5; --moving the state to 2HI
       pl2_item0:="0000";
       pl2_item1:="0000";
       pl2_item2:="0000";
       pl2_item3:="0000"; 
       
    end if; --to display 2HI
    
    if (result2<result1) then 
        tries:=tries+1;      
        player2_data2:=0;
        dp<='1';
        state_value:=6; -- moving the state to 2LO
        pl2_item0:="0000";
        pl2_item1:="0000";
        pl2_item2:="0000";
        pl2_item3:="0000";
    end if;-- to display 2LO
    
    
    if (result2=result1) then 
        tries:=tries+1;
        dp<='1';
        state_value:=7; -- to display number of successful attempts and blinking of led
    end if;
    
end if;-- verifying the result of player1 and player2 and displaying either tries/2HI/2LO


if (tries>4) then 
    tries:=0;
    dp<='1';
    state_value:=8;
end if; --to display LOSE

if(counter>600 and state_value=8 and tries=0) then -- for having 3 second delay and moving to player1 state again
    pl1_item0:="0000";
    pl1_item1:="0000";
    pl1_item2:="0000";
    pl1_item3:="0000";
    player1_data2:=0;
    dp<='1';
    state_value:=1;
                
elsif(state_value =8 and counter>=0 and counter<=600) then --incrementing the counter accordingly
    counter:=counter+1;
    
end if;

if(state_value = 1) then 
    counter:=0; -- making the counter to zero when redirected to state 1 again
end if;

-- for latching of player 2 again
if(btnL='1' and player2_data2=0) then
    if(state_value=5 or state_value=4 or state_value=6) then
        pl2_item0:=switch;
        dp<='1';
        state_value:=4;
    end if;
end if;-- for latching D0
    
if(btnU='1' and player2_data2=1) then
    if(state_value=5 or state_value=4 or state_value=6) then
        pl2_item1:=switch;
        dp<='1';
        state_value:=4;
    end if;
end if;-- for latching D1

if(btnD='1' and player2_data2=2) then
    if(state_value=5 or state_value=4 or state_value=6) then
        pl2_item2:=switch;
        dp<='1';
        state_value:=4;
    end if;
 end if;-- for latching D2
    
if(btnR='1' and player2_data2=3) then
    if(state_value=5 or state_value=4 or state_value=6) then
        pl2_item3:=switch;
        dp<='1';
        state_value:=4;
    end if;
end if;-- for latching D3



--display PL1
if state_value=1 then 
    case player1_data1 is
    when 0 =>  anode_led <= "1110";seg <= "1111001";player1_data1 := player1_data1 + 1; -- 1
    when 1 =>  anode_led <= "1101";seg <= "1111111";player1_data1 := player1_data1 + 1; -- none
    when 2 =>  anode_led <= "1011";seg <= "1000111";player1_data1 := player1_data1 + 1; -- L
    when 3 =>  anode_led <= "0111";seg <= "0001100";player1_data1 := 0; -- P
    when others=>null;
    end case;
    
--display PL2
elsif state_value=3 then
    case player2_data1 is
    when 0 =>  anode_led <= "1110";seg <= "0100100";player2_data1 := player2_data1 + 1; -- 2
    when 1 =>  anode_led <= "1101";seg <= "1111111";player2_data1 := player2_data1 + 1; -- none
    when 2 =>  anode_led <= "1011";seg <= "1000111";player2_data1 := player2_data1 + 1; -- L
    when 3 =>  anode_led <= "0111";seg <= "0001100";player2_data1 := 0; -- P
    when others=>null;
    end case;

--display 2 HI--
elsif state_value=5 then
    
    case high_value is
    when 0 =>  dp<='1';if(pl1_item0=pl2_item0)then dp<='0';end if;anode_led <= "1110";seg <= "1001111"; high_value := high_value + 1; -- I
    when 1 =>  dp<='1';if(pl1_item1=pl2_item1)then dp<='0';end if;anode_led <= "1101";seg <= "0001001"; high_value := high_value + 1;-- H
    when 2 =>  dp<='1';if(pl1_item2=pl2_item2)then dp<='0';end if;anode_led <= "1011";seg <= "1111111"; high_value := high_value + 1;-- none
    when 3 =>  dp<='1';if(pl1_item3=pl2_item3)then dp<='0';end if;anode_led <= "0111";seg <= "0100100"; high_value := 0;-- 2
    when others=> null;dp<='1';
    end case;
    
--display 2 LO--
elsif state_value=6 then
    
    case low_value is
    when 0 =>  dp<='1';if(pl1_item0=pl2_item0)then dp<='0';end if;anode_led <= "1110";seg <= "1000000";low_value := low_value + 1;-- O
    when 1 =>  dp<='1';if(pl1_item1=pl2_item1)then dp<='0';end if;anode_led <= "1101";seg <= "1000111";low_value := low_value + 1;-- L
    when 2 =>  dp<='1';if(pl1_item2=pl2_item2)then dp<='0';end if;anode_led <= "1011";seg <= "1111111";low_value := low_value + 1;-- none
    when 3 =>  dp<='1';if(pl1_item3=pl2_item3)then dp<='0';end if;anode_led <= "0111";seg <= "0100100";low_value := 0;-- 2
    when others=> null;dp<='1';
    end case;
    
--display number of tries and led blinking--
elsif state_value=7 then
    switch_output<="1111111111111111";
    case tries is
    when 1=> anode_led<="1110";seg<="1111001";
    when 2=> anode_led<="1110";seg<="0100100";
    when 3=> anode_led<="1110";seg<="0110000";
    when 4=> anode_led<="1110";seg<="0011001";
    when others=>null;
    end case;
    
      
-- display LOSE after 4 tries--
elsif state_value=8 then
    case lose_value is
    when 0 =>  anode_led <= "1110";seg <= "0000110";lose_value := lose_value + 1; -- E
    when 1 =>  anode_led <= "1101";seg <= "0010010";lose_value := lose_value + 1; -- S
    when 2 =>  anode_led <= "1011";seg <= "1000000";lose_value := lose_value + 1; -- O
    when 3 =>  anode_led <= "0111";seg <= "1000111";lose_value := 0; -- L
    when others=> null;
    end case;  

    

--for storing the segments value for appropriate anode of player 1
elsif state_value=2 then
    case player1_data2 is
        when 0=> case pl1_item0 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1110";seg<=output_led;
                player1_data2:=player1_data2+1;
        
        when 1=> case pl1_item1 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1101";seg<=output_led;
                player1_data2:=player1_data2+1;
        
         when 2=> case pl1_item2 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1011";seg<=output_led;
                player1_data2:=player1_data2+1;
         
          when 3=> case pl1_item3 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="0111";seg<=output_led;
                player1_data2:=0;
         when others=>null;
        end case;

--for storing the segments value for appropriate anode of player 2
elsif (state_value=4) then
    case player2_data2 is
        when 0=> case pl2_item0 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1110";seg<=output_led;
                player2_data2:=player2_data2+1;
        
        when 1=> case pl2_item1 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1101";seg<=output_led;
                player2_data2:=player2_data2+1;
        
         when 2=> case pl2_item2 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="1011";seg<=output_led;
                player2_data2:=player2_data2+1;
         
          when 3=> case pl2_item3 is
                    when "0000" => output_led := "1000000";   
                    when "0001" => output_led := "1111001";  
                    when "0010" => output_led := "0100100"; 
                    when "0011" => output_led := "0110000";  
                    when "0100" => output_led := "0011001";  
                    when "0101" => output_led := "0010010";  
                    when "0110" => output_led := "0000010";  
                    when "0111" => output_led := "1111000";  
                    when "1000" => output_led := "0000000";      
                    when "1001" => output_led := "0011000";  
                    when "1010" => output_led := "0001000"; 
                    when "1011" => output_led := "0000011"; 
                    when "1100" => output_led := "1000110"; 
                    when "1101" => output_led := "0100001"; 
                    when "1110" => output_led := "0000110"; 
                    when "1111" => output_led := "0001110";
                end case;
                anode_led<="0111";seg<=output_led;
                player2_data2:=0;
         when others=>null;
        end case;
end if;


end if;
end process;-- ending the process
end Behavioral;