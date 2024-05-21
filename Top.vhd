library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity TOP is
	port (
		SW            	  : in  std_logic_vector(7 downto 0);
      KEY             	: in  std_logic_vector(3 downto 0);
		UART_TXD					  : out std_logic;
		--TxOut					  : out std_logic;
		CLOCK_50 : in std_logic
		--LEDG                : out std_logic_vector(3 downto 0);
		--LEDR                : out std_logic_vector(17 downto 0);
		
	);
end entity;

architecture behaviour of TOP is
	
component Uart is
	port (
		FastClk            	  : in  std_logic;
      Enable             	: in  std_logic;
      InputMsg           : in  std_logic_vector(7 downto 0);
		TxOut					  : out std_logic
		
	);
end component;

--signal MessageInsig  : std_logic_vector(7 downto 0);
--signal MessageOutsig  : std_logic_vector(10 downto 0);
-- SIGNALSSSSS
--signal BaudClk, ackSig, readySig : std_logic;
--signal messageTx, messageRx : std_logic_vector(10 downto 0);

begin
	--D_enable <= en;
	--messageOut <= Mout;

	
	obj1 : UART
		port map (
			InputMsg => SW(7 downto 0),
			FastClk => CLOCK_50,
			TxOut => UART_TXD,
			Enable  => KEY(3)
		);

	
end behaviour;