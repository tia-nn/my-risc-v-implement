library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RiskVGlobals.all;

entity RV32I is
    port (
        clock, reset: in std_logic;
        pc: out std_logic_vector(XLEN-1 downto 0);
        inst: in std_logic_vector(31 downto 0)
    );
end RV32I;

architecture rtl of RV32I is

    component Controller is
        port (
            opcode: in std_logic_vector(6 downto 0);
            reg_write_enable: out std_logic;
            reg_write_data_sel: out std_logic -- 0: u-imm(<<12)  1: alu result
        );
    end component;
    component DataPath is
        port (
            clock, reset: in std_logic;
            pc: buffer std_logic_vector(XLEN-1 downto 0);
            inst: in std_logic_vector(31 downto 0);
            reg_write_enable: in std_logic;
            reg_write_data_sel: in std_logic -- 0: u-imm(<<12)  1: alu result
        );
    end component;

    signal reg_write_enable: std_logic;
    signal reg_write_data_sel: std_logic;

    signal opcode: std_logic_vector(6 downto 0);

begin

    opcode <= inst(6 downto 0);

    con: Controller port map (
        opcode => opcode,
        reg_write_enable => reg_write_enable,
        reg_write_data_sel => reg_write_data_sel
    );
    dp: DataPath port map (clock, reset,
        pc => pc,
        inst => inst,
        reg_write_enable => reg_write_enable,
        reg_write_data_sel => reg_write_data_sel
    );

end architecture;
