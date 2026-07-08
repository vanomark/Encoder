module encoder #(
    parameter WIDTH = 32,
    parameter POS_W = $clog2(WIDTH)
)(
    input  [WIDTH-1:0] vector,
    output [POS_W-1:0] position,
    
    output             is_onehot,
    output             parity
);
    assign parity = ^vector;
    assign is_onehot = (|vector) & ~(|(vector & (vector - 1'b1)));
    
    // Шаг 1: Выделение старшей единицы
    // Создаем вектор, где останется только одна единица на старшей позиции.
    wire [WIDTH-1:0] msb_onehot;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_msb
            if (i == WIDTH - 1) begin
                assign msb_onehot[i] = vector[i];
            end else begin
                // Бит равен 1, если он сам 1 и ВСЕ старшие биты равны 0
                assign msb_onehot[i] = vector[i] & ~(|vector[WIDTH-1 : i+1]);
            end
        end
    endgenerate

    // Шаг 2: Преобразование в бинарный номер позиции
    // Для каждого бита выходной шины position собираем побитовое ИЛИ 
    // от тех битов msb_onehot, индексы которых содержат 1 в данной позиции.
    genvar j, k;
    generate
        for (j = 0; j < POS_W; j = j + 1) begin : gen_pos
            wire [WIDTH-1:0] mask;
            for (k = 0; k < WIDTH; k = k + 1) begin : gen_mask
                // (k >> j) & 1 — вычисляется на этапе компиляции
                assign mask[k] = ((k >> j) & 1) ? msb_onehot[k] : 1'b0;
            end
            // Свёртка по ИЛИ для получения j-го бита позиции
            assign position[j] = |mask;
        end
    endgenerate

endmodule