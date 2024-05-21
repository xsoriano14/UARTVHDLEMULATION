library ieee;
use ieee.std_logic_1164.all;

entity DataFramerBuilder_tb is
    -- Testbench doesn't have ports
end entity DataFramerBuilder_tb;

architecture sim of DataFramerBuilder_tb is

    -- Component declaration for the DataFramer
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

    -- Signals for interfacing with the DataFramer component
    signal message      : std_logic_vector(7 downto 0) := (others => '0');
    signal clk          : std_logic := '0';
    signal messageOut   : std_logic_vector(10 downto 0);
    signal done         : std_logic;
    signal ack          : std_logic := '0';
    signal readyToSend  : std_logic := '0';
    signal en           : std_logic := '0';

    -- Clock generation
    constant clk_period : time := 10 ns; -- Adjust as per your design's clock frequency

begin

    -- Instantiate the DataFramer component
    uut: DataFrameBuilder
        port map (
            InputMsg      => message,
            clk          => clk,
            OutputMsg   => messageOut,
            Done_Sig         => done,
            Received          => ack,
            SendMsg  => readyToSend,
            Enable           => en
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
    -- Initialization
    wait for clk_period * 10; -- Wait for a few clock cycles
    readyToSend <= '1';
    en <= '1';
    message <= "10010110"; -- First test message
    wait for clk_period * 10;

    -- Acknowledge reception of the first message
    ack <= '1';
    wait for clk_period * 5;
    ack <= '0';
    wait for clk_period * 10; -- Wait for the DataFramer to reset
	 
	 en <= '0';
	 wait for clk_period;
    -- Send a second test message
    en <= '1'; -- Enable the DataFramer again
    message <= "10001111"; -- Second test message
    wait for clk_period * 10;

    -- Acknowledge reception of the second message
    ack <= '1';
    wait for clk_period * 5;
    ack <= '0';

    wait; -- Terminate simulation
end process;


end architecture sim;
