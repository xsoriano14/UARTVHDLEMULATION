library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity DataFrameBuilder is
	port (
		InputMsg : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		OutputMsg : out std_logic_vector(10 downto 0);
		Done_Sig : out std_logic;
		Received : in std_logic;
		SendMsg : in std_logic;
		Enable : in std_logic
	);
end entity;

architecture Behavioural of DataFrameBuilder is

type state_type is (idle, Reset, FindParity);
signal state : state_type := idle;
begin

process (clk)
	constant startBit : std_logic := '0';
	variable parityBit : std_logic := '0';
	constant stopBit : std_logic := '1';
	
	variable LastEnable : std_logic := '0';
	
begin
	if rising_edge(clk) then
		case state is
			when idle =>
				Done_Sig <= '0';
				parityBit := '0';
				if LastEnable = '0' and Enable = '1' and SendMsg = '1' then
					state <= FindParity;
				end if;
				LastEnable := Enable;
				
			when FindParity =>
				for i in 0 to InputMsg'length-1 loop
					if InputMsg(i) = '1' then
						parityBit := not parityBit;
					end if;
				end loop;
				OutputMsg <= stopBit & parityBit & InputMsg & startBit;
				Done_Sig <= '1';
				state <= Reset;
				
			when Reset =>
				if Received = '1' then
					Done_Sig <= '0';
					state <= IDLE;
				end if;
				
		end case;
	end if;
end process;

end architecture;
