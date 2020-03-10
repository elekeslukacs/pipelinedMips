library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--USE ieee.numeric_std.ALL;

entity saqwdf is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end saqwdf;

architecture Behavioral of saqwdf is

component mpg is
    Port (  btn : in std_logic_vector (4 downto 0);
            clk : in std_logic;
            enable : out std_logic_vector (4 downto 0));
end component;

component display is
    Port(
        clk : in std_logic;
        digit0 : in std_logic_vector (3 downto 0);
        digit1 : in std_logic_vector (3 downto 0);
        digit2 : in std_logic_vector (3 downto 0);
        digit3 : in std_logic_vector (3 downto 0);
        an : out std_logic_vector (3 downto 0);
        cat : out std_logic_vector (6 downto 0)
        );
end component;

component IFetch is
 Port ( clk : in STD_LOGIC;
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCsrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           reset : in STD_LOGIC;
           we : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           PC_Out : out STD_LOGIC_VECTOR (15 downto 0));
 end component;
 
 component IDecode is 
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
 end component;
 
 component EX is 
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
end component;

component MemoryUnit is
    Port ( clk : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut: out std_logic_vector (15 downto 0));
end component;
signal count : std_logic_vector (7 downto 0) := (others => '0');
signal countE : std_logic_vector (4 downto 0);


signal digits : std_logic_vector (15 downto 0);

signal instruction: std_logic_vector (15 downto 0);
signal pCounter: std_logic_vector (15 downto 0);
signal wData: std_logic_vector (15 downto 0);
signal rData1: std_logic_vector (15 downto 0);
signal rData2: std_logic_vector (15 downto 0);
signal extImm :std_logic_vector (15 downto 0);
signal sa: std_logic;
signal func: std_logic_vector (2 downto 0);
signal rw: std_logic;

signal RgDst: std_logic;
signal RegWrite: std_logic;
signal ExtOp: std_logic;
signal AluOP:std_logic_vector(2 downto 0);
signal AluSrc: std_logic;
signal MemtoRg: std_logic;
signal MemWrite: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;

signal ALUResult: std_logic_vector (15 downto 0);
signal branchAddr: std_logic_vector(15 downto 0);
signal zeroDetected: std_logic;

signal mw : std_logic;
signal MemData: std_logic_vector (15 downto 0);
signal ALUResOut: std_logic_vector (15 downto 0);
signal PCSrc : std_logic;
signal jumpAddr: std_logic_vector (15 downto 0);

signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(82 downto 0);
signal EX_MEM: std_logic_vector(55 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);

signal writeAddr: std_logic_vector (2 downto 0);
begin

P1: mpg port map (btn, clk, countE);
P2: display port map (clk, digits(3 downto 0), digits(7 downto 4), digits(11 downto 8), digits(15 downto 12), an, cat);
P3: IFetch port map (clk, branchAddr, jumpAddr, PCSrc, Jump, countE(0), countE(1), instruction, pCounter);
--P4: IDecode port map(clk, instruction, wData, RgDst, rw, ExtOp, rData1, rData2, extImm, sa, func); 
P4: IDecode port map(clk, IF_ID(15 downto 0), wData, MEM_WB(2 downto 0), rw, ExtOp, rData1, rData2, extImm, sa, func); 
--P5: EX port map(clk, pCounter, rData1, rData2, extImm, AluSrc, sa, func, AluOP, ALUResult, branchAddr, zeroDetected);
P5: EX port map(clk, IF_ID(31 downto 16),  ID_EX(57 downto 42), ID_EX(41 downto 26), ID_EX(25 downto 10), ID_EX(75), ID_EX(0), ID_EX(9 downto 7), ID_EX(78 downto 76), ALUResult, branchAddr, zeroDetected);
P6: MemoryUnit port map(clk, mw, EX_MEM(34 downto 19), EX_MEM(18 downto 3), MemData, ALUResOut);
-- zero det
--zero <= digits nand "1111111111111111";
--led(7)<='1' when zero="1111111111111111" else '0';

-- COUNTER
--process (clk, countE)
--begin
--   if clk='1' and clk'event then
--      if countE(0) = '1' then
--            count <= count + 1;
--      end if;
--   end if;
--end process;

--Control Unit

process(IF_ID(15 downto 0))
begin
    case(IF_ID(15 downto 13)) is
    when "000" =>
         RgDst <= '0';
         RegWrite <= '1';
         ExtOp <= '0';
         AluOP <= "000";
         AluSrc <= '0';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
     when "001" =>
         RgDst <= '1';
         RegWrite <= '1';
         ExtOp <= '1';
         AluOP <= "001";
         AluSrc <= '1';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
      when "010" =>
         RgDst <= '1';
         RegWrite <= '1';
         ExtOp <= '1';
         AluOP <= "001";
         AluSrc <= '1';
         MemtoRg <= '1';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
      when "011" =>
         RgDst <= 'X';
         RegWrite <= '0';
         ExtOp <= '1';
         AluOP <= "001";
         AluSrc <= '1';
         MemtoRg <= 'X';
         MemWrite <= '1';
         Branch <= '0';
         Jump <= '0';
       when "100"  =>
         RgDst <= 'X';
         RegWrite <= '0';
         ExtOp <= '1';
         AluOP <= "010";
         AluSrc <= '0';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '1';
         Jump <= '0';
        when "101" =>
         RgDst <= '1'; --rgdst modified
         RegWrite <= '1';
         ExtOp <= '1';
         AluOP <= "011";
         AluSrc <= '1';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
       when "110" =>
         RgDst <= 'X';
         RegWrite <= '1';
         ExtOp <= '1';
         AluOP <= "100";
         AluSrc <= '1';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
        when "111" =>
         RgDst <= 'X';
         RegWrite <= '0';
         ExtOp <= '0';
         AluOP <= "101";
         AluSrc <= '0';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '1';
       when others =>
       RgDst <= '0';
         RegWrite <= '1';
         ExtOp <= '1';
         AluOP <= "001";
         AluSrc <= '1';
         MemtoRg <= '0';
         MemWrite <= '0';
         Branch <= '0';
         Jump <= '0';
    end case;
 end process;
 
 --IF/ID
process(clk)
begin
    if(clk'event and clk = '1') then
        if(countE(1) = '1') then
            IF_ID(31 downto 16) <= pCounter;
            IF_ID(15 downto 0) <= instruction;
        end if;
    end if;
end process;

--ID/EX
process(clk)
begin
    if(clk'event and clk = '1') then
        if(countE(1) = '1') then
            ID_EX(82) <= MemToRg; --WB
            ID_EX(81) <= RegWrite;
            ID_EX(80) <= MemWRite; --MEM
            ID_EX(79) <= Branch;
            ID_EX(78 downto 76) <= ALUOp; --EX
            ID_EX(75) <= ALUSrc;
            ID_EX(74) <= RgDst;
            ID_EX(73 downto 58) <= IF_ID(31 downto 16); --pc+1
            ID_EX(57 downto 42) <= rData1; --rd1
            ID_EX(41 downto 26) <= rData2; --rd2
            ID_EX(25 downto 10) <= extImm; --ext_unit
            ID_EX(9 downto 7) <= func; --funct
            ID_EX(6 downto 4) <= IF_ID(9 downto 7); --rt
            ID_EX(3 downto 1) <= IF_ID(6 downto 4); --rd
            ID_EX(0) <= sa; --sa
        end if;
    end if;
end process;

-- MUX
process(ID_EX(74), ID_EX)
begin
    case (ID_EX(74)) is
        when '0' => writeAddr <= ID_EX(6 downto 4);
        when '1' => writeAddr <= ID_EX(3 downto 1);
    end case;
end process;

--EX/MEM
	process(clk)
begin
    if(clk'event and clk = '1') then
        if(countE(1) = '1') then
            EX_MEM(55) <= ID_EX(82);
            EX_MEM(54) <= ID_EX(81);
            EX_MEM(53) <= ID_EX(80);
            EX_MEM(52) <= ID_EX(79);
            EX_MEM(51 downto 36) <= branchAddr;
            EX_MEM(35) <= zeroDetected;
            EX_MEM(34 downto 19) <= ALUResult;
            EX_MEM(18 downto 3) <= ID_EX(41 downto 26);
            EX_MEM(2 downto 0) <= writeAddr;
        end if;
    end if;
end process;

--MEM/WB
process(clk)
begin
    if(clk'event and clk = '1') then
        if(countE(1) = '1') then
            MEM_WB(36) <= EX_MEM(55);
            MEM_WB(35) <= EX_MEM(54);
            MEM_WB(34 downto 19) <= MemData;
            MEM_WB(18 downto 3) <= EX_MEM(34 downto 19);
            MEM_WB(2 downto 0) <= EX_MEM(2 downto 0);
        end if;
    end if;
end process;
 
--rw <= RegWrite And countE(1);
--mw <= MemWrite and countE(1);
--PCSrc <= Branch and zeroDetected;
--jumpAddr <=  "000" & instruction(12 downto 0);
rw <= MEM_WB(35) And countE(1);
mw <= EX_MEM(53) and countE(1);
PCSrc <= ID_EX(79) and EX_MEM(35);
jumpAddr <=  "000" & IF_ID(12 downto 0);

--with MemtoRg select wData <= 
--    ALUResOut when '0',
--    MemData when '1';

with MEM_WB(36) select wData <= 
    MEM_WB(18 downto 3) when '0',
     MEM_WB(34 downto 19) when '1';   


--wData <= ALUResult;
with sw(7 downto 5) select digits <=
    IF_ID(15 downto 0) when "000", --instruction
    pCounter when "001", --pCounter ID_EX(73 downto 58)
    rData1 when "010", --rData1 ID_EX(57 downto 42)
    rData2 when "011", --rData2 ID_EX(41 downto 26)
    ID_EX(25 downto 10) when "100", --extImm
    ALUResult when "101", --AluResult MEM_WB(18 downto 3)
    MEM_WB(34 downto 19) when "110", --MemData
    wData when "111",
    x"0000" when others;
 
led(15) <= RgDst;
led(14) <= ExtOp;
led(13) <= ALUSrc;
led(12) <= Branch;
led(11) <= Jump;
led(10 downto 8) <= AluOp;
led(7) <= MemWrite;
led(6) <= MemtoRg;
led(5) <= RegWrite;


end Behavioral;