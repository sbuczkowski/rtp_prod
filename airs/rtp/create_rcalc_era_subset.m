airs_paths

model = 'era';
emis = 'wis';
input_glob = [prod_dir '/' datestr(JOB(1),'yyyy/mm/dd') '/airs_l1bcm.' datestr(JOB(1),'yyyy.mm.dd') '*.rtp'];

sarta_core
