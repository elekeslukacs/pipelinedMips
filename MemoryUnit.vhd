----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2019 04:12:54 PM
-- Design Name: 
-- Module Name: MemoryUnit - Behavioral
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
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemoryUnit is
    Port ( clk : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut: out std_logic_vector (15 downto 0));
end MemoryUnit;

architecture Behavioral of MemoryUnit is
type ram_array is array (0 to 15) of std_logic_vector(15 downto 0);
signal mem_unit : ram_array:=(
x"0001",
x"0002",
x"0003",
x"0004",
x"0005",
x"0006",
x"0007",
x"0008",
x"0009",
others => x"0000"
);
begin
process(clk)
begin
    if rising_edge(clk) then
        if memWrite = '1' then
            mem_unit(conv_integer(ALURes(6 downto 0))) <= RD2;
        end if;
    end if;
end process;
MemData <= mem_unit(conv_integer(ALURes(6 downto 0)));
ALUResOut <= ALURes;

end Behavioral;
