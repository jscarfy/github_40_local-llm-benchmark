#!/usr/bin/env python3
from pathlib import Path
import re, time

mf = Path("Makefile")
if not mf.exists():
  print("[SKIP] No Makefile found.")
  raise SystemExit(0)

bak = mf.with_name(f"Makefile.bak.{time.strftime('%Y%m%d_%H%M%S')}")
bak.write_bytes(mf.read_bytes())
print(f"[INFO] Backed up Makefile to {bak}")

lines = mf.read_text(encoding="utf-8", errors="replace").splitlines(True)
out = []
in_rule = False

rule_header = re.compile(r"^[^\s#][^=]*:\s*.*$")
var_assign  = re.compile(r"^[^:#\s][^=]*\s*[:+?]?=\s*.*$")

for l in lines:
  if re.match(r"^\s*$", l):
    in_rule = False
    out.append(l)
    continue
  if rule_header.match(l) and not var_assign.match(l):
    in_rule = True
    out.append(l)
    continue
  if in_rule:
    if re.match(r"^ +\S", l) and not l.startswith("\t") and not re.match(r"^\s*#", l):
      l = re.sub(r"^ +", "\t", l)
  out.append(l)

mf.write_text("".join(out), encoding="utf-8")
print("[OK] Applied heuristic tab-fix to Makefile.")
