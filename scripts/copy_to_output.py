# ！/usr/bin/env python3
import re
import sys
import shutil
from pathlib import Path

input_file = Path(sys.argv[1]).resolve()
out_dir = Path(sys.argv[2])

out_dir.mkdir(exist_ok=True)
shutil.copy(input_file, out_dir)
print(f"Copy {input_file} to {out_dir}")
