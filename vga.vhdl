library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gg is
    Port ( 
        i_clk : in  STD_LOGIC;  -- 板載主時脈 (例如 100MHz)
        i_rst : in  STD_LOGIC;  -- 重置訊號 (高電位重置)
        H     : out STD_LOGIC;  -- HSYNC
        V     : out STD_LOGIC;  -- VSYNC
        red   : out STD_LOGIC_VECTOR (3 downto 0);
        green : out STD_LOGIC_VECTOR (3 downto 0);
        blue  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end gg;

architecture Behavioral of gg is

    -- 640x480 @ 60Hz 標準時序參數
    constant H_ACT   : integer := 640;
    constant H_FP    : integer := 16;
    constant H_SYNC  : integer := 96;
    constant H_BP    : integer := 48;
    constant H_TOTAL : integer := 800; -- 640 + 16 + 96 + 48

    constant V_ACT   : integer := 480;
    constant V_FP    : integer := 10;
    constant V_SYNC  : integer := 2;
    constant V_BP    : integer := 33;
    constant V_TOTAL : integer := 525; -- 480 + 10 + 2 + 33

    -- 25MHz Pixel Clock 生成 (100MHz / 4 = 25MHz)
    signal divcnt   : integer range 0 to 1 := 0;
    signal divclk   : STD_LOGIC := '0';

    -- 位置計數器
    signal h_cnt : integer range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : integer range 0 to V_TOTAL - 1 := 0;

    -- 有效顯示區域與座標
    signal video_on   : boolean := false;
    signal horizontal : integer := 0;
    signal vertical   : integer := 0;

begin

    ------------------------------------------------------------------
    -- 1. 25MHz 時脈分頻器
    ------------------------------------------------------------------
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            divcnt <= 0;
            divclk <= '0';
        elsif rising_edge(i_clk) then
            if divcnt = 1 then
                divcnt <= 0;
                divclk <= not divclk;
            else
                divcnt <= divcnt + 1;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- 2. 水平與垂直雙層掃描計數器
    ------------------------------------------------------------------
    process(divclk, i_rst)
    begin
        if i_rst = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(divclk) then
            if h_cnt = H_TOTAL - 1 then
                h_cnt <= 0;
                if v_cnt = V_TOTAL - 1 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- 3. HSYNC / VSYNC 同步訊號 (負極性脈衝)
    ------------------------------------------------------------------
    H <= '0' when (h_cnt >= H_ACT + H_FP) and (h_cnt < H_ACT + H_FP + H_SYNC) else '1';
    V <= '0' when (v_cnt >= V_ACT + V_FP) and (v_cnt < V_ACT + V_FP + V_SYNC) else '1';

    ------------------------------------------------------------------
    -- 4. 有效顯示區域判定與座標定義
    ------------------------------------------------------------------
    video_on <= true when (h_cnt < H_ACT) and (v_cnt < V_ACT) else false;
    
    horizontal <= h_cnt;
    vertical   <= v_cnt;

    ------------------------------------------------------------------
    -- 5. 畫面渲染 (紅綠藍圖塊 + Blanking 非顯示區消隱保護)
    ------------------------------------------------------------------
    picture_display : process(horizontal, vertical, video_on)
    begin
        if video_on then
            -- 紅色圖塊
            if vertical < 360 and horizontal < 350 and horizontal > 0 then
                red <= "1111";
            else
                red <= "0000";
            end if;

            -- 綠色圖塊
            if vertical < 360 and horizontal > 250 and horizontal < 640 then
                green <= "1111";
            else
                green <= "0000";
            end if;

            -- 藍色圖塊
            if vertical > 120 and vertical < 480 and horizontal > 150 and horizontal < 500 then
                blue <= "1111";
            else
                blue <= "0000";
            end if;
        else
            -- 消隱保護：非有效顯示區域 (Sync / Porch) 強制輸出全黑 0000
            red   <= "0000";
            green <= "0000";
            blue  <= "0000";
        end if;
    end process;

end Behavioral;
