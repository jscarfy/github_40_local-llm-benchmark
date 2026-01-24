#!/usr/bin/env python3
import re
from pathlib import Path

AMS_MAIN = Path("tex/amsart/main.tex")
BMR_MAIN = Path("tex/beamer/slides.tex")
AMS_DIR = Path("tex/amsart/sections")
BMR_DIR = Path("tex/beamer/sections")

START = "%== AUTO INCLUDES START =="
END = "%== AUTO INCLUDES END =="


def ensure_main(p: Path, kind: str):
    p.parent.mkdir(parents=True, exist_ok=True)
    if p.exists():
        txt = p.read_text(encoding="utf-8", errors="replace").replace("\r\n", "\n")
    else:
        if kind == "ams":
            txt = "\\documentclass{amsart}\n\\usepackage{amsmath,amssymb,amsthm}\n\\begin{document}\n"
        else:
            txt = "\\documentclass{beamer}\n\\usetheme{default}\n\\begin{document}\n"
        txt += f"{START}\n{END}\n\\end{document}\n"
        p.write_text(txt, encoding="utf-8")
        return
    if START not in txt:
        txt += ("\n" if not txt.endswith("\n") else "") + START + "\n"
    if END not in txt:
        txt += END + "\n"
    p.write_text(txt, encoding="utf-8")


def numeric_prefix(name: str):
    m = re.match(r"^(\d+)-", name)
    return int(m.group(1)) if m else None


def gen_inputs(dirp: Path, prefix: str):
    dirp.mkdir(parents=True, exist_ok=True)
    files = [f.name for f in dirp.glob("*.tex")]
    files = [f for f in files if numeric_prefix(f) is not None]
    files.sort(key=lambda s: numeric_prefix(s))
    return "".join([f"\\input{{{prefix}/{fn}}}\n" for fn in files])


def replace_block(p: Path, replacement: str):
    txt = p.read_text(encoding="utf-8", errors="replace").replace("\r\n", "\n")
    s = txt.find(START)
    e = txt.find(END)
    if s == -1 or e == -1 or e < s:
        raise RuntimeError(f"Markers missing/malformed in {p}")
    s_end = s + len(START)
    new_txt = txt[:s_end] + "\n" + replacement + txt[e:]
    p.write_text(new_txt, encoding="utf-8")


def main():
    ensure_main(AMS_MAIN, "ams")
    ensure_main(BMR_MAIN, "bmr")
    replace_block(AMS_MAIN, gen_inputs(AMS_DIR, "tex/amsart/sections"))
    replace_block(BMR_MAIN, gen_inputs(BMR_DIR, "tex/beamer/sections"))
    print("[OK] Synced includes:", AMS_MAIN, BMR_MAIN)


if __name__ == "__main__":
    main()
