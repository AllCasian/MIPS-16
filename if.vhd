----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 19:06:54
-- Design Name: 
-- Module Name: if - Behavioral
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

entity if1 is
    Port(
    jmp: in std_logic;
    jmpAdr: in std_logic_vector(15 downto 0);
    pcsrc: in std_logic;
    brcAdr: in std_logic_vector(15 downto 0);
    en: in std_logic;
    rst: in std_logic;
    clk: in std_logic;
    pc_out: inout std_logic_vector(15 downto 0);
    instr: out std_logic_vector(15 downto 0)
    );
end if1;

architecture Behavioral of if1 is

type t_mem is array(0 to 255) of std_logic_vector(15 downto 0);
signal mem : t_mem :=(

    B"010_000_001_0000101",    -- x"4085" -- ADDI $1, $0, 5
    B"010_000_010_0000000",    -- x"4100" -- ADDI $2, $0, 0
    B"010_000_011_0000000",    -- x"4180" -- ADDI $3, $0, 0
    B"001_011_100_0000000",    -- x"2E00" -- LW $4, 0($3)
    B"100_100_000_0001000",    -- x"9008" -- BEQ $4, $0, 8
    B"000_010_001_010_0_011",  -- x"08A3" -- ADD $2, $2, $1
    B"010_011_011_0000100",    -- x"4D84" -- ADDI $3, $3, 4
    B"111_0000000000011",      -- x"E003" -- J 3
    B"000_000_010_001_0_011",  -- x"0113" -- ADD &1, &0, &2
    
    others => x"0000"
);

signal mux1: std_logic_vector(15 downto 0);
signal mux2: std_logic_vector(15 downto 0);
signal q: std_logic_vector(15 downto 0);

begin

process(q)
begin
    pc_out <= q + '1';
end process;

process(brcAdr, pc_out, pcsrc)
begin
    if pcsrc = '1' then
        mux1 <= brcAdr;
    else
        mux1 <= pc_out;
    end if;
end process;

process(jmpAdr, mux1, jmp)
begin
    if jmp = '1' then
        mux2 <= jmpAdr;
    else
        mux2 <= mux1;
    end if;
end process;

process(clk, rst, en, mux2)
begin
    if(rising_edge(clk)) then
        if(en = '1') then
            if(rst = '1') then
                q <= "0000000000000000";
            else
                q <= mux2;
            end if;
        end if;
    end if;
end process;

instr <= mem(conv_integer (q));

end Behavioral;
