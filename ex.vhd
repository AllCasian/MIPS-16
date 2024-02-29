----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2023 15:58:57
-- Design Name: 
-- Module Name: ex - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex is
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
end ex;

architecture Behavioral of ex is

signal aluCtrl: std_logic_vector(2 downto 0); 
signal b: std_logic_vector(15 downto 0);
signal c: std_logic_vector(15 downto 0);

begin

AluControl: process(aluOp, func)
begin
    case aluOp is
        when "01" =>
            case func is
                when "011" => aluCtrl <= "000";
                when "000" => aluCtrl <= "001";
                when "001" => aluCtrl <= "010";
                when "010" => aluCtrl <= "011";
                when "100" => aluCtrl <= "100";
                when "101" => aluCtrl <= "101";
                when "110" => aluCtrl <= "110";
                when others => aluCtrl <= "010";
            end case;
        when "00" => aluCtrl <= "000";
        when "10" => aluCtrl <= "001";
        when "11" => aluCtrl <= "101";
        when others => aluCtrl <= (others => 'X'); 
    end case;
end process;

process(rd2, ext_imm, aluSrc)
begin
    if aluSrc = '1' then
        b <= ext_imm;
    else
        b <= rd2;
    end if;
end process;

ALU: process(rd1, b, aluCtrl, sa)
begin
    case aluCtrl is
        when "000" => c <= rd1 + b;
        when "001" => c <= rd1 - b;
        when "010" =>
            case sa is
                when '0' => c <= b;
                when '1' => c <= b(14 downto 0)&"0";
                when others => c <= (others => 'X');
            end case;
        when "011" =>
            case sa is
                when '0' => c <= b;
                when '1' => c <= b(0)&b(15 downto 1);
                when others => c <= (others => 'X');
            end case;
        when "100" => c <= rd1 and b;
        when "101" => c <= rd1 or b;
        when "110" => c <= rd1 xor b;
        when others => c <= (others => 'X');
    end case;  
end process;

isZero: process(c)
begin
    if c = x"0000" then
        zero <= '1';
    else
        zero <= '0';
    end if;
end process;

aluRes <= c;
ge <= not c(15);
gt <= (not c(15)) and (not zero);
brAddr <= ext_imm + pc_1;
end Behavioral;
