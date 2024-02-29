----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 18:37:04
-- Design Name: 
-- Module Name: id - Behavioral
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

entity id is
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
end id;

architecture Behavioral of id is

signal mux: std_logic_vector(2 downto 0);

type t_rf is array(0 to 7) of std_logic_vector(15 downto 0);
signal rf : t_rf := (x"0001", x"0005", x"000A", x"000B", x"020A", x"130C", others => x"0000");

begin

process(instr(9 downto 7), instr(6 downto 4), regDst)
begin
    if regDst = '1' then
        mux <= instr(6 downto 4);
    else
        mux <= instr(9 downto 7);
    end if;
end process;

process(regWrite, instr, mux, wd, clk, en)
begin
    if rising_edge(clk) then 
        if en = '1' and regWrite = '1' then
            rf(conv_integer(mux)) <= wd; 
        end if;
    end if;        
end process; 
rd1 <= rf(conv_integer(instr(12 downto 10)));
rd2 <= rf(conv_integer(instr(9 downto 7)));

process(instr(6 downto 0), extOp)
begin
    if extOp = '1' then
        extImm <= instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6 downto 0);
    else 
        extImm <= "000000000"&instr(6 downto 0);
    end if;
end process;

func <= instr(2 downto 0);
sa <= instr(3);

end Behavioral;
