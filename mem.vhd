----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2023 22:13:55
-- Design Name: 
-- Module Name: mem - Behavioral
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

entity mem is
    Port (
    memWrite: in std_logic;
    aluResIn: in std_logic_vector(15 downto 0);
    rd2: in std_logic_vector(15 downto 0);
    clk: in std_logic;
    en: in std_logic;
    memData: out std_logic_vector(15 downto 0);
    aluResOut: out std_logic_vector(15 downto 0)
    );
end mem;

architecture Behavioral of mem is

type t_mem is array(0 to 31) of std_logic_vector(15 downto 0);
signal mem : t_mem := (
    x"000A",
    x"000B",
    x"000C",
    x"000D",
    x"000E",
    x"000F",
    x"0009",
    x"0008",
    others => x"0000"

);

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and memWrite = '1' then
            mem(conv_integer(aluResIn(4 downto 0))) <= rd2;
        end if;
    end if;
end process;

memData <= mem(conv_integer(aluResIn(4 downto 0)));
aluResOut <= aluResIn;
end Behavioral;
