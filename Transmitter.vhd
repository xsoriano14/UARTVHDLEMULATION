library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Transmitter is
	port (
		TransmittedMsg : in std_logic_vector(10 downto 0); 
		clk : in std_logic; -- baud rate clock
		Enable : in std_logic;
		ReadytoTransmit : out std_logic := '1';
		TransmitStart : out std_logic := '0';
		Tx : out std_logic := '1'
	);
end entity;

architecture Behavioural of Transmitter is

type state_type is (idle, Start, transmit);
signal state : state_type := idle;

begin

process (clk)
	variable Counter : integer := 0;
	variable LastEnable : std_logic := '0';

	begin
		if rising_edge(clk) then
			case state is
				when idle =>
					TransmitStart <= '0';
					ReadytoTransmit <= '1';
					Counter := 0;
					Tx <= '1';
					TransmitStart <= '0';
					
					if Enable = '1' then
						state <= Start;
						ReadytoTransmit <= '0';
					end if;
					
				when Start =>
					TransmitStart <= '1';
					state <= transmit;
					
				when transmit =>
					if Counter <= 10 then
						Tx <= TransmittedMsg(Counter);
						Counter := Counter + 1;
					else 
						Counter := 0;
						state <= idle;
					end if;
					
			end case;
		end if;
	end process;

end architecture;