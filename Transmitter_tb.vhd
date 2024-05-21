library ieee;
use ieee.std_logic_1164.all;

entity Transmitter_tb is
    -- Testbench doesn't have ports
end entity Transmitter_tb;

architecture sim of Transmitter_tb is

    -- Component declaration for the Transmitter
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

    -- Signals for interfacing with the Transmitter component
    signal message        : std_logic_vector(10 downto 0) := (others => '0');
    signal clk            : std_logic := '0';
    signal Tx             : std_logic;
    signal readyToReceive : std_logic;
    signal ack            : std_logic;
    signal en             : std_logic := '0';

    -- Clock generation
    constant clk_period : time := 20 ns; -- Adjust to match your baud rate

begin

    -- Instantiate the Transmitter component
    uut: Transmitter
        port map (
            TransmittedMsg        => message,
            clk            => clk,
            Tx             => Tx,
            ReadytoTransmit => readyToReceive,
            TransmitStart            => ack,
            Enable             => en
        );

    -- Clock process
    clock_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    -- Stimulus process
stimulus_process : process
begin
    -- Initial delay
    wait for clk_period * 10;
    
    -- Send the first framed message
    en <= '1'; -- Enable transmission for the first message
    message <= "01100011001"; -- Example of the first framed message
    wait for clk_period;
    en <= '0'; -- Disable transmission to mimic end of the first message
    wait for clk_period * 15; -- Wait for the first message to be fully transmitted
    
    -- Send a second framed message
    en <= '1'; -- Enable transmission for the second message
    message <= "01011101110"; -- Example of the second framed message
    wait for clk_period;
    en <= '0'; -- Disable transmission to mimic end of the second message
    wait for clk_period * 15; -- Wait for the second message to be fully transmitted

    -- End of simulation
    wait; -- Terminate simulation
end process;


end architecture sim;
