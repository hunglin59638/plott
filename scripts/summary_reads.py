import re
import sys
from pathlib import Path

reads_dir =  Path(sys.argv[0])
reads_dct = {}
if reads_dir.is_dir():
    for file in reads_dir.iterdir():
        if file.is_file() and file.stat().st_size > 0:
            sample_prefix = file.stem.replace(".fastq", "").replace(".gz", "")
            sample_id = re.sub("_(1|2)$", "", sample_prefix)
            reads_dct.setdefault(sample_id, {"long": None, "short": []})
            if re.search("_(1|2)$", sample_prefix):
                reads_dct[sample_id]["short"].append(file)
            else:
                reads_dct[sample_id]["long"] = file
