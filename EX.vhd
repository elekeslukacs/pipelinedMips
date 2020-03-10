----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2019 01:33:49 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( clk : in STD_LOGIC;
            pc : in std_logic_vector (15 downto 0);
            readData1: in std_logic_vector (15 downto 0);
            readData2: in std_logic_vector (15 downto 0);
            immed: in std_logic_vector (15 downto 0);
            aluSrc: in std_logic;
            sa: in std_logic;
            func: in std_logic_vector (2 downto 0);
            aluOP: in std_logic_vector (2 downto 0);
            
            result: out std_logic_vector (15 downto 0);
            branch: out std_logic_vector (15 downto 0);
            zeroDetected: out std_logic
            );
end EX;

architecture Behavioral of EX is

signal readData : std_logic_vector (15 downto 0);
signal aluCtrl: std_logic_vector (2 downto 0);
signal temp: std_logic_vector (15 downto 0);

begin

branch <= pc + immed;

--mux

with aluSrc select readData <= 
    readData2 when '0',
    immed when '1';
 --zero   
zeroDetected <= '1' when temp = x"0000" else  '0';    
--ALU CTRL
process (aluOP, func)
begin
    case(aluOP) is
        when "000" => aluCtrl <= func;
        when "001" => aluCtrl <= "001";
        when "010" => aluCtrl <= "010";
        when "011" => aluCtrl <= "101";
        when "100" => aluCtrl <= "111";
        --when "101" => aluCtrl <= "
        when others => aluCtrl <= "000";
     end case;
 end process;
 
 --ALU
 process(aluCtrl, readData1, readData)
 begin 
    case(aluCtrl) is
        when "000" => temp <= readData1 xor readData;
        when "001" => temp <= readData1 + readData;
        when "010" => temp <= readData1 - readData;
        when "011" => temp <= readData1(14 downto 0) & '0';
        when "100" => temp <= '0' & readData1(14 downto 0);
        when "101" => temp <= readData1 and readData;
        when "110" => temp <= readData1 or readData;
        when "111" => if readData1 < readData then
                        temp <= x"0001";
                      else temp <= x"0000";
                      end if;
        when others => temp <= x"0000";
      end case;
   end process;
   result <= temp;
   
end Behavioral;
