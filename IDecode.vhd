----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2019 01:14:09 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
    Port (clk : in std_logic;
        instr : in STD_LOGIC_Vector (15 downto 0);
        wData: in std_logic_vector (15 downto 0);
        --RegDst: in std_logic;
        wAddr: in std_logic_vector (2 downto 0);
        RegWrite: in std_logic;
        ExtOp: in std_logic;
        rData1: out std_logic_vector (15 downto 0);
        rData2: out std_logic_vector (15 downto 0);
        ExtImm: out std_logic_vector (15 downto 0);
        sa: out std_logic;
        func: out std_logic_vector (2 downto 0));
end IDecode;

architecture Behavioral of IDecode is
component reg_file is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component;
signal rd : std_logic_vector (2 downto 0);
signal extended: std_logic_vector (15 downto 0);
begin

--with RegDst select rd <=
--    instr(6 downto 4) when '0',
--    instr(9 downto 7) when '1';

process(ExtOp, instr)
begin
    case(ExtOp) is 
    when '0' => ExtImm <= "000000000" & instr(6 downto 0);
    when '1' =>  if instr(6) = '1' then
                ExtImm <= "111111111" & instr(6 downto 0);
                else 
                ExtImm <= "000000000" & instr(6 downto 0);
                end if;
    end case;
end process;

sa <= instr(3);
func <= instr(2 downto 0);  

RF: reg_file port map (clk, instr(12 downto 10), instr(9 downto 7), wAddr, wData, RegWrite, rData1, rData2);               


end Behavioral;
