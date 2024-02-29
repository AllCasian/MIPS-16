----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 19:20:25
-- Design Name: 
-- Module Name: uc - Behavioral
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

entity uc is
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
end uc;

architecture Behavioral of uc is

begin

process(instr(15 downto 13))
begin
    regDst <= '0'; extOp <= '0'; aluSrc <= '0'; branch <= '0'; br <= '0'; jump <= '0';
    memWrite <= '0'; memToReg <= '0'; regWrite <= '0'; aluOp <= "00";
    case instr(15 downto 13) is
        when "000" =>
            regDst <= '1'; regWrite <= '1'; aluOp <= "01";
        when "001" =>
            extOp <= '1'; aluSrc <= '1'; memToReg <= '1'; regWrite <='1';
        when "010" =>
            extOp <= '1'; aluSrc <= '1'; regWrite <= '1';
        when "011" =>
            extOp <= '1'; aluSrc <= '1'; memWrite <= '1'; 
        when "100" =>
            extOp <= '1'; branch <= '1'; aluOp <= "10";
        when "101" =>
            aluSrc <= '1'; regWrite <= '1'; aluOp <= "11";
        when "110" =>
            extOp <= '1'; br <= '1'; aluOp <= "10";
        when others =>
            jump <= '1';
     end case;
end process;

end Behavioral;
