cris_paths

model = 'gfs';
emis = 'wis';
input_glob = [prod_dir '/' datestr(JOB(1),'yyyy/mm/dd') '/cris_sdr4_allfov.' datestr(JOB(1),'yyyy.mm.dd') '*.rtp'];

sarta_core
