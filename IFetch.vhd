----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 02:25:03 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    Port ( clk : in STD_LOGIC;
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCsrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           reset : in STD_LOGIC;
           we : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           PC_Out : out STD_LOGIC_VECTOR (15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
    signal pc: std_logic_vector (15 downto 0) := x"0000";
    signal pcAux: std_logic_vector ( 15 downto 0);
    signal mux1Out: std_logic_vector(15 downto 0 );
    signal nextAddr: std_logic_vector(15 downto 0 );
    type rom_type is array (0 to 255) of std_logic_vector (15 downto 0);
    signal IM: rom_type:=(
    --B"000_010_011_110_0_001", -- add
    B"010_000_011_0000100", --lw
    B"000_000_000_000_0_110",--NoOp, OR
    B"000_000_000_000_0_110",--NoOp
    B"100_001_011_0000110", --beq
    B"000_000_000_000_0_110",--NoOp
    B"000_000_000_000_0_110",--NoOp
    B"000_000_000_000_0_110",--NoOp
    B"001_000_110_0000100", --addi
    B"000_010_011_110_0_001", -- add
   -- B"000_011_010_110_0_010", --sub
    B"000_010_100_011_1_011", --sll
    B"000_000_000_000_0_110", --NoOp
    B"000_000_000_000_0_110",--NoOp
   -- B"000_100_010_110_1_100", --srl
    B"000_001_011_010_0_101", --and
   -- B"000_001_011_110_0_110", --or
   -- B"000_001_011_110_0_111", --slt
    B"001_011_011_0000011", --addi 
    B"000_000_000_000_0_110",--NoOp
    B"011_000_010_0000000", --sw
    B"010_000_110_0000000", --lw
    B"000_000_000_000_0_110",--NoOp
    B"100_001_000_0000001", --beq
    B"000_000_000_000_0_110", --NoOp
    B"000_000_000_000_0_110", --NoOp
    B"000_000_000_000_0_110",--NoOp
    B"111_0000000000000", --jump
    B"000_000_000_000_0_110",--NoOp
    
  
    others => x"0000");
begin
    
    process(clk, reset, we)
    begin
        if clk='1' and clk'event then
           if reset = '1' then
               pc<=x"0000";
                elsif we = '1' then
                     pc <= nextAddr;
      end if;
   end if;
end process;
    
    pcAux <= pc + 1;
    
    with PCSrc select mux1Out <=
        pcAux when '0',
        branchAddr when '1';
        
    with jump select nextAddr <=
        mux1Out when '0',
        jumpAddr when '1';
     
     PC_Out<=pcAux;
     instr<= IM(conv_integer(pc(7 downto 0)));
       

end Behavioral;
