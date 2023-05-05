


module tomasulo(clock);

input clock;


// ROM
wire [15:0]rom_out;
wire rom_read;


// HEAP
wire [15:0] heap_in;
wire [15:0] heap_out;
wire heap_rom_read;
wire heap_read;


// STATION
wire [47:00]bus;
wire request_data;
wire store_station;
wire [42:00] instruction_out;
wire run;
wire read_station;
wire store_cdb;
wire [22:00] cdb_solution;
wire mem_control;


// MUX
wire [15:00] instruction;
wire [15:00] data_inb;
wire [15:00] data_inc;
wire [47:00] mux_out;
wire merged;
wire cdb_intercept;
wire [22:00] data_cdb;



// REGISTER_DB
wire read_db;
wire store_db;
wire [03:00] add_a;
wire [03:00] add_b;
wire [03:00] add_c;
wire [15:00] data_in;

wire [15:00] out_b;
wire [15:00] out_c;

// ALU
wire [42:00] alu_instruction;
wire alu_run;
wire request_st;
wire cdb_done;
wire [22:00]alu_solution;


// MEM
wire key_storage;
wire [42:00] instruction_storage;
wire done_storage;
wire [22:00]solution_storage;


ROM                module_rm(clock, rom_read, rom_out);

heap               module_hp(clock, heap_in, heap_read, heap_out, read_out, heap_rom_read);

mux_merge          module_mx(clock, instruction, cdb_intercept, data_cdb, mux_control, data_inb, data_inc, mux_out, merged);

register_db        module_db(clock, read_db, store_db, add_a, add_b, add_c, data_in, out_b, out_c);

reserve_station    module_rs(clock, bus, cdb_solution, storage, store_station, read_station, store_cdb, store_sd, request_data, instruction_out, run, mem_control);

logic_unity        module_lu(clock, request_st, alu_instruction, alu_run, cdb_done, alu_solution);

memory             memory(clock, key_storage, instruction_storage, done_storage, solution_storage);

assign heap_in = rom_out;        // saida da rom para a heap
assign rom_read = heap_rom_read; // sinal de controle de leitura da heap para a rom
assign instruction = heap_out;   // saida da heap para o mux
assign read_db = read_out;       // sinal de controle da heap que informa que uma instrução foi despachada
assign mux_control = read_out;
assign cdb_intercept = cdb_done;
assign data_cdb = alu_solution;

// assim 
assign add_a = alu_solution[22:19];
assign add_b = heap_out[07:04];
assign add_c = heap_out[03:00];


assign data_inb = out_b;
assign data_inc = out_c;

assign bus = mux_out;
assign heap_read = request_data;
assign store_station = merged;

assign alu_instruction = instruction_out;
assign alu_run = run;

assign read_station = request_st;
assign store_cdb = cdb_done;
assign cdb_solution = alu_solution;

assign store_db = cdb_done || done_storage;
assign data_in = alu_solution[15:00];

assign key_storage = mem_control;
assign instruction_storage = instruction_out;
endmodule