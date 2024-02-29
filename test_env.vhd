----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2023 22:22:30
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in std_logic_vector(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component if1 is
    Port(
    jmp: in std_logic;
    jmpAdr: in std_logic_vector(15 downto 0);
    pcsrc: in std_logic;
    brcAdr: in std_logic_vector(15 downto 0);
    en: in std_logic;
    rst: in std_logic;
    clk: in std_logic;
    pc_out: inout std_logic_vector(15 downto 0);
    instr: inout std_logic_vector(15 downto 0)
    );
end component;

component id is
    Port(
    regWrite: in std_logic;
    instr: in std_logic_vector(15 downto 0);
    regDst: in std_logic;
    clk: in std_logic;
    en: in std_logic;
    extOp: in std_logic; 
    wd: in std_logic_vector(15 downto 0);
    rd1: out std_logic_vector(15 downto 0);
    rd2: out std_logic_vector(15 downto 0);
    extImm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa:out std_logic
    );
end component;

component uc is
    Port (
    instr: in std_logic_vector(15 downto 0);
    regDst: out std_logic; 
    extOp: out std_logic;
    aluSrc: out std_logic;
    branch: out std_logic;
    br: out std_logic;
    jump: out std_logic;
    aluOp: out std_logic_vector(1 downto 0);
    memWrite: out std_logic; 
    memToReg: out std_logic;
    regWrite: out std_logic  
    );
end component;

component ex is
    Port (
    rd1: in std_logic_vector(15 downto 0);
    aluSrc: in std_logic;
    rd2: in std_logic_vector(15 downto 0);
    ext_imm: in std_logic_vector(15 downto 0);
    sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    aluOp: in std_logic_vector(1 downto 0);
    pc_1: in std_logic_vector(15 downto 0);
    ge: out std_logic;
    gt: out std_logic;
    zero: inout std_logic;
    aluRes: out std_logic_vector(15 downto 0);
    brAddr: out std_logic_vector(15 downto 0)
     );
end component;

component mem is
    Port (
    memWrite: in std_logic;
    aluResIn: in std_logic_vector(15 downto 0);
    rd2: in std_logic_vector(15 downto 0);
    clk: in std_logic;
    en: in std_logic;
    memData: out std_logic_vector(15 downto 0);
    aluResOut: out std_logic_vector(15 downto 0)
    );
end component;

signal cnt : std_logic_vector(7 downto 0) ;
signal enable1 : std_logic;
signal enable2 : std_logic;
signal pc_outt: std_logic_vector(15 downto 0);
signal instrr: std_logic_vector(15 downto 0);
signal mux1: std_logic_vector(15 downto 0);
signal branch: std_logic;
signal branchAddr: std_logic_vector(15 downto 0);
signal jump: std_logic;
signal jumpAddr: std_logic_vector(15 downto 0);
signal pcSrc: std_logic;
signal zero: std_logic;
signal regWrite, regDst, extOp, sa, aluSrc, br, memWrite, memToReg, ge, gt: std_logic;
signal wd, rd1, rd2, ext_imm, aluRes, memData, aluResOut, digits: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal aluOp: std_logic_vector(1 downto 0);

begin

monopulse1: MPG port map(enable2, btn(0), clk);
monopulse2: MPG port map(enable1, btn(1), clk);

display: SSD port map(clk, digits, an, cat);

InstrFetch: if1 port map(jump, jumpAddr, branch, branchAddr, enable2, enable1, clk, pc_outt, instrr);
InstrDecode: id port map(regWrite, instrr, regDst, clk, enable2, extOp, wd, rd1, rd2, ext_imm, func, sa);
MainControl: uc port map(instrr, regDst, extOp, aluSrc, branch, br, jump, aluOp, memWrite, memToReg, regWrite);
ExecutionUnit: ex port map(rd1, aluSrc, rd2, ext_imm, sa, func, aluOp, pc_outt, ge, gt, zero, aluRes, branchAddr);
Memm: mem port map(memWrite, aluRes, rd2, clk, enable2, memData, aluResOut);

with memToReg select
    wd <= memData when '1',
          aluResOut when '0',
          (others => '0') when others;

with sw(7 downto 5) select
        digits <=  instrr when "000", 
                   pc_outt when "001",
                   rd1 when "010",
                   rd2 when "011",
                   ext_imm when "100",
                   aluRes when "101",
                   memData when "110",
                   wd when "111",
                   (others => '0') when others; 

jumpAddr <= instrr(12 downto 0) & pc_outt(15 downto 13);
pcSrc <= zero and branch;
led(9 downto 0) <= aluOp & regDst & extOp & aluSrc & branch & jump & memWrite & memToReg & regWrite;

end Behavioral;
