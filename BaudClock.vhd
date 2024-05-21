library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity BaudClock is
	generic(
		BaudFrequency : integer; -- bits/sec
		
		ClkFrequency : integer -- Hz
	);
	
	port (
	
		InputClk : in std_logic;
		SlowClk : out std_logic
	);
end entity;

architecture Behavioural of BaudClock is
constant CycleLimit : integer := (ClkFrequency) / (BaudFrequency*2);
begin

	process (InputClk)
		variable counter : integer := 0;
		variable TempClk : std_logic := '0';
		
	begin 
		if rising_edge(InputClk) then
			if (counter >= CycleLimit) then
				counter := 0;
				TempClk := not TempClk;
			else
				counter := counter + 1;
			end if;
			
			SlowClk <= TempClk;
		end if;
	end process;

end architecture;
