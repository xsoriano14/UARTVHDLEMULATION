library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity UART is
	port (
		FastClk            	  : in  std_logic;
      Enable             	: in  std_logic;
      InputMsg           : in  std_logic_vector(7 downto 0);
		TxOut					  : out std_logic
		
	);
end entity;

architecture behaviour of UART is
	
component BaudClock is
	generic(
		BaudFrequency : integer; -- in bits/sec
		ClkFrequency : integer -- in Hz
	);
	port (
		InputClk : in std_logic;
		SlowClk : out std_logic
	);
end component;


component DataFrameBuilder is
	port (
		InputMsg : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		OutputMsg : out std_logic_vector(10 downto 0);
		Done_Sig : out std_logic;
		Received : in std_logic;
		SendMsg : in std_logic;
		Enable : in std_logic
	);
end component;

component Transmitter is
	port (
		TransmittedMsg : in std_logic_vector(10 downto 0); 
		clk : in std_logic; -- baud rate clock
		Enable : in std_logic; 
		ReadytoTransmit : out std_logic := '1';
		TransmitStart : out std_logic := '0';
		Tx : out std_logic := '1'
	);
end component;


-- SIGNALSSSSS
signal BaudClk, ackSig, readySig : std_logic;
signal messageTx, messageRx : std_logic_vector(10 downto 0);
signal T_enable, D_enable, V_enable : std_logic;
signal Mout : std_logic_vector(7 downto 0);

begin
	D_enable <= Enable;
	--messageOut <= Mout;

	obj1 : BaudClock
		generic map (
			9600,
			50e6
		)
		port map (
			InputClk => FastClk,
			SlowClk => BaudClk
		);
		
	obj2 : DataFrameBuilder
		port map (
			InputMsg => InputMsg,
			clk => FastClk,
			OutputMsg => messageTx,
			Enable => D_enable,
			Done_Sig => T_enable,
			Received => ackSig,
			SendMsg => readySig
		);
	
	obj3 : Transmitter
		port map (
			TransmittedMsg => messageTx,
			clk => BaudClk,
			Enable => T_enable,
			ReadytoTransmit => readySig,
			Tx => TxOut,
			TransmitStart => ackSig
		);
	
end behaviour;