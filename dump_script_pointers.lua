-- write basic bizhawk lua loop: for actions every frame

local start_script_pointers = {
    dp = {
        English = 0x20F355C,
        JapaneseRev5 = 0x20F5394,
        JapaneseRev6 = 0x20F54D4,
        German = 0x20F356C,
        Spanish = 0x20F35A8,
        Italian = 0x20F3510,
        French = 0x20F359C
    },
    p = {
    },
    hgss = {
        English = 0x20FAD00
    }

}

local game = "hgss"
local language = "English"

dofile("commands_"..game..".lua")
local max_cmd_id = #command_names - 1

os.execute("mkdir "..game)
file = io.open(game.."/script_pointers_"..language..".json","w")

file:write("[\n")

byte_array = mainmemory.read_bytes_as_array(start_script_pointers[game][language] - 0x2000000, (max_cmd_id+1)*4)
for i = 0, max_cmd_id do
    pointer = (byte_array[i*4+1] | byte_array[i*4+2]<<8 | byte_array[i*4+3]<<16 | byte_array[i*4+4]<<24) -1
    file:write('\t{"id": "0x'..string.format("%X",i)..'", "name": "' ..command_names[i+1]..'", "pointer": "0x'..string.format("%X",pointer)..'"}')
    if i < max_cmd_id then
        file:write(",\n")
    else
        file:write("\n")
    end
end

file:write("]\n")

io.close(file)
